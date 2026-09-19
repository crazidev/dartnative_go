import 'dart:io';

import 'package:tom_ast_generator/tom_ast_generator.dart';

/// Libraries handled by native bridges at runtime — skipped during bundling.
///
/// Shared by the dev server (`server.dart --rebuild-ast`) and
/// `tool/build_ast_bundle.dart` so both produce identical bundles.
const kAstBridgedLibraries = {
  'package:dartnative/dartnative.dart',
  'package:dartnative/src/framework.dart',
  'package:dartnative_share/dartnative_share.dart',
  'package:dartnative_webview/dartnative_webview.dart',
  'package:dartnative_shared_preferences/dartnative_shared_preferences.dart',
  'package:dartnative_path_provider/dartnative_path_provider.dart',
  'package:dartnative_url_launcher/dartnative_url_launcher.dart',
  'package:dartnative_splash/dartnative_splash.dart',
  'package:flutter/widgets.dart',
  'package:flutter/material.dart',
};

/// Result of [buildGuestAstBundle].
class AstBuildResult {
  final bool success;
  final String outputPath;
  final int moduleCount;
  final int byteSize;
  final String entryPointUri;
  final String? error;

  /// True when the rebuild was skipped because no source changed
  /// (incremental fast path — equivalent to `flutter run` detecting
  /// "no changes").
  final bool cached;

  const AstBuildResult({
    required this.success,
    required this.outputPath,
    this.moduleCount = 0,
    this.byteSize = 0,
    this.entryPointUri = '',
    this.error,
    this.cached = false,
  });
}

/// Stub replacing `dartnative_plugin_registrant.dart` inside AST bundles.
///
/// The real file loads native FFI symbols (`dartnative_ios/android`), which
/// the analyzer-free interpreter cannot execute. The source runtime
/// neutralizes it the same way by intercepting `registerNativeBindings` as
/// a no-op (see `InterpreterRunner`). With this stub, guest `main()` calling
/// `DartNativePluginRegistrant.registerAll()` keeps working on both engines.
const kRegistrantStub = '''
// AST-bundling stub: replaces dartnative_plugin_registrant.dart.
// Real file loads FFI symbols; interpreted guests treat it as a no-op.
abstract final class DartNativePluginRegistrant {
  static void registerAll() {}
}
''';

/// Builds `explicitSources` stubs for the registrant, keyed by every URI
/// spelling guest code may use (relative `lib/`/`guest_app/` + `package:`).
///
/// Only injected when the real registrant file exists on disk, so genuinely
/// missing imports still surface as bundler errors.
Map<String, String> registrantStubs(
  Directory projectDir,
  String? packageName,
) {
  final stubs = <String, String>{};
  if (File('${projectDir.path}/lib/dartnative_plugin_registrant.dart')
      .existsSync()) {
    stubs['lib/dartnative_plugin_registrant.dart'] = kRegistrantStub;
    if (packageName != null) {
      stubs['package:$packageName/dartnative_plugin_registrant.dart'] =
          kRegistrantStub;
    }
  }
  if (File('${projectDir.path}/guest_app/dartnative_plugin_registrant.dart')
      .existsSync()) {
    stubs['guest_app/dartnative_plugin_registrant.dart'] = kRegistrantStub;
    if (packageName != null) {
      stubs['package:$packageName/dartnative_plugin_registrant.dart'] =
          kRegistrantStub;
    }
  }
  return stubs;
}
String? detectGuestPackageName(Directory projectDir) {
  try {
    final pubspec = File('${projectDir.path}/pubspec.yaml');
    if (!pubspec.existsSync()) return null;
    for (final line in pubspec.readAsLinesSync()) {
      final match = RegExp(r'^name:\s*([A-Za-z0-9_]+)').firstMatch(line.trim());
      if (match != null) return match.group(1);
    }
  } catch (_) {}
  return null;
}

/// Mirrors the dev server's codeDir fallback: `lib/` then `guest_app/`.
/// Returns null when neither entrypoint exists.
File? resolveGuestEntry(Directory projectDir, [String? entryArg]) {
  if (entryArg != null) {
    final f = File(
      entryArg.startsWith('/') ? entryArg : '${projectDir.path}/$entryArg',
    );
    return f.existsSync() ? f : null;
  }
  final libMain = File('${projectDir.path}/lib/main.dart');
  if (libMain.existsSync()) return libMain;
  final guestMain = File('${projectDir.path}/guest_app/main.dart');
  if (guestMain.existsSync()) return guestMain;
  return null;
}

/// Source root mirrored from the entry fallback (for fingerprinting).
Directory _codeRootFor(Directory projectDir, File entryFile) {
  if (entryFile.path.contains('${projectDir.path}/guest_app/')) {
    return Directory('${projectDir.path}/guest_app');
  }
  return Directory('${projectDir.path}/lib');
}

/// FNV-1a 64-bit fingerprint over all `.dart` files under [codeRoot].
///
/// Cheap I/O (no analyzer parse): sorted `relativePath + bytes` hash.
/// Used to skip rebuilds when sources are unchanged since the last
/// successful build — the `flutter run` "no changes" fast path.
Future<String> fingerprintGuestSources(Directory codeRoot) async {
  var hash = 0xcbf29ce484222325;
  const prime = 0x100000001b3;
  void mix(int byte) {
    hash ^= byte;
    hash = (hash * prime) & 0xFFFFFFFFFFFFFFFF;
  }

  final files = <File>[];
  if (codeRoot.existsSync()) {
    await for (final e in codeRoot.list(recursive: true)) {
      if (e is File && e.path.endsWith('.dart')) files.add(e);
    }
  }
  files.sort((a, b) => a.path.compareTo(b.path));
  for (final f in files) {
    final rel = f.path.replaceAll('\\', '/');
    for (final c in rel.codeUnits) {
      mix(c & 0xFF);
      mix((c >> 8) & 0xFF);
    }
    try {
      final bytes = await f.readAsBytes();
      for (final b in bytes) {
        mix(b);
      }
    } catch (_) {}
  }
  return hash.toRadixString(16);
}

class _LastBuild {
  final String fingerprint;
  final String outputPath;
  final int moduleCount;
  final int byteSize;
  final String entryPointUri;

  const _LastBuild({
    required this.fingerprint,
    required this.outputPath,
    required this.moduleCount,
    required this.byteSize,
    required this.entryPointUri,
  });
}

/// Last successful build per project (server-process lifetime).
final Map<String, _LastBuild> _lastBuilds = {};

/// Builds `<project>/assets/bundles/guest.ast` for the target guest project.
///
/// Incremental: when [incremental] (default) and the source fingerprint
/// matches the last successful build for this project, the analyzer parse
/// is skipped and the cached result is returned in milliseconds.
/// Set [force] to bypass the cache (e.g. after bridge changes).
///
/// Returns failure (never throws) when the entrypoint is missing, the
/// package name is undiscoverable, or the bundler rejects an import
/// (e.g. full native shells pulling FFI registrants — see docs).
Future<AstBuildResult> buildGuestAstBundle(
  Directory projectDir, {
  String? entryArg,
  String? outputArg,
  String? packageArg,
  bool incremental = true,
  bool force = false,
}) async {
  final entryFile = resolveGuestEntry(projectDir, entryArg);
  if (entryFile == null) {
    return const AstBuildResult(
      success: false,
      outputPath: '',
      error: 'No entrypoint (looked for lib/main.dart, then guest_app/main.dart)',
    );
  }

  final packageName = packageArg ?? detectGuestPackageName(projectDir);
  if (packageName == null) {
    return const AstBuildResult(
      success: false,
      outputPath: '',
      error: 'Could not detect package name from pubspec.yaml (pass packageArg)',
    );
  }

  final outPath =
      outputArg ?? '${projectDir.path}/assets/bundles/guest.ast';
  final outFile = File(
    outPath.startsWith('/') ? outPath : '${projectDir.path}/$outPath',
  );

  // Incremental fast path: unchanged sources since last success → skip parse.
  final codeRoot = _codeRootFor(projectDir, entryFile);
  if (incremental && !force) {
    final last = _lastBuilds[projectDir.path];
    if (last != null && last.outputPath == outFile.path) {
      final fp = await fingerprintGuestSources(codeRoot);
      if (fp == last.fingerprint && outFile.existsSync()) {
        final size = await outFile.length();
        return AstBuildResult(
          success: true,
          outputPath: outFile.path,
          moduleCount: last.moduleCount,
          byteSize: size,
          entryPointUri: last.entryPointUri,
          cached: true,
        );
      }
    }
  }

  try {
    final bundler = AstBundler(
      bridgedLibraries: kAstBridgedLibraries,
      explicitSources: registrantStubs(projectDir, packageName),
      packageName: packageName,
      projectRoot: projectDir.path,
    );
    final bundle = await bundler.createFromFile(entryFile.path);
    await outFile.parent.create(recursive: true);
    bundle.saveToFile(outFile.path);
    final size = await outFile.length();
    final fp = await fingerprintGuestSources(codeRoot);
    _lastBuilds[projectDir.path] = _LastBuild(
      fingerprint: fp,
      outputPath: outFile.path,
      moduleCount: bundle.modules.length,
      byteSize: size,
      entryPointUri: bundle.entryPointUri,
    );
    return AstBuildResult(
      success: true,
      outputPath: outFile.path,
      moduleCount: bundle.modules.length,
      byteSize: size,
      entryPointUri: bundle.entryPointUri,
    );
  } catch (e) {
    return AstBuildResult(
      success: false,
      outputPath: outFile.path,
      error: e.toString(),
    );
  }
}

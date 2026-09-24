import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart' as analyzer;
import 'package:path/path.dart' as p;
import 'package:tom_ast_generator/tom_ast_generator.dart';

import '../runner/bytecode/bundle_codec.dart';
import '../runner/logger.dart';
import '../runner/runtime_mode.dart';
import 'bytecode_emitter.dart';

/// Extended [AstConverter] that handles newer/unmapped analyzer nodes
/// such as [analyzer.LibraryIdentifier] in `library foo;` directives.
class SafeAstConverter extends AstConverter {
  @override
  SAstNode? convert(analyzer.AstNode? node) {
    if (node == null) return null;
    if (node is analyzer.LibraryIdentifier) {
      final name = node.components.map((c) => c.name).join('.');
      return SSimpleIdentifier(
        offset: node.offset,
        length: node.length,
        name: name,
        inDeclarationContext: false,
      );
    }
    return super.convert(node);
  }
}

/// Libraries handled by native bridges at runtime — skipped during bundling.
///
/// Shared by the dev server (`server.dart --rebuild-ast`) and
/// `tool/build_ast_bundle.dart` so both produce identical bundles.
const kAstBridgedLibraries = {
  'package:dartnative/dartnative.dart',
  'package:dartnative/plugin.dart',
  'package:dartnative/src/framework.dart',
  'package:dartnative_share/dartnative_share.dart',
  'package:dartnative_webview/dartnative_webview.dart',
  'package:dartnative_shared_preferences/dartnative_shared_preferences.dart',
  'package:dartnative_path_provider/dartnative_path_provider.dart',
  'package:dartnative_url_launcher/dartnative_url_launcher.dart',
  'package:dartnative_splash/dartnative_splash.dart',
  'package:dartnative_supabase/dartnative_supabase.dart',
  'package:dartnative_social_sign_in/dartnative_social_sign_in.dart',
  'package:dartnative_sqlite/dartnative_sqlite.dart',
  'package:dartnative_keys/dartnative_keys.dart',
  'package:dartnative_ios/dartnative_ios.dart',
  'package:dartnative_android/dartnative_android.dart',
  'package:native_bottomsheet/native_bottomsheet.dart',
  'package:native_bottomsheet/src/show_bottom_sheet.dart',
  'package:native_bottomsheet/src/sheet_controller.dart',
  'package:native_bottomsheet/src/sheet_detent.dart',
  'package:native_bottomsheet/src/sheet_platform_config.dart',
  'package:native_bottomsheet/src/ffi_bindings.dart',
  'package:native_bottomsheet/src/sheet_native_bindings.dart',
  'package:riverpod_kit/riverpod_kit.dart',
  'package:riverpod/riverpod.dart',
  'package:flutter/widgets.dart',
  'package:flutter/material.dart',
  'package:flutter/cupertino.dart',
  'package:flutter/foundation.dart',
  'package:flutter/painting.dart',
  'package:flutter/rendering.dart',
  'package:flutter/services.dart',
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

  /// True when the sibling `guest.bc` was (re)generated successfully in this
  /// build. False means no bytecode artifact exists for this fingerprint, so
  /// callers must not serve a stale one.
  final bool bytecodeBuilt;

  /// Per-module content fingerprints (module URI → FNV-1a hex of the module's
  /// serialized AST). Lets the device tell which modules actually changed
  /// between reloads instead of re-declaring the whole bundle.
  final Map<String, String> moduleFingerprints;

  const AstBuildResult({
    required this.success,
    required this.outputPath,
    this.moduleCount = 0,
    this.byteSize = 0,
    this.entryPointUri = '',
    this.error,
    this.cached = false,
    this.bytecodeBuilt = false,
    this.moduleFingerprints = const {},
  });
}

/// FNV-1a 64-bit accumulator shared by source-tree and per-module hashing.
class _Fnv1a64 {
  int _hash = 0xcbf29ce484222325;
  static const int _prime = 0x100000001b3;

  void addByte(int byte) {
    _hash ^= byte;
    _hash = (_hash * _prime) & 0xFFFFFFFFFFFFFFFF;
  }

  void addBytes(List<int> bytes) {
    for (final b in bytes) {
      addByte(b);
    }
  }

  void addString(String value) {
    for (final c in value.codeUnits) {
      addByte(c & 0xFF);
      addByte((c >> 8) & 0xFF);
    }
  }

  String get hex => _hash.toRadixString(16);
}

/// FNV-1a fingerprints for every compiled module, keyed by module URI.
///
/// Hashed from the serialized `SCompilationUnit` (not the source file) so the
/// fingerprint is exact for what the interpreter will actually execute.
Map<String, String> fingerprintBundleModules(Map<String, SCompilationUnit> modules) {
  final out = <String, String>{};
  modules.forEach((uri, unit) {
    final hash = _Fnv1a64()..addString(jsonEncode(unit.toJson()));
    out[uri] = hash.hex;
  });
  return out;
}

/// Last successfully computed per-module fingerprints for [projectDir].
///
/// Read by the dev server when serving `/manifest.json`. Empty when the project
/// has never been built (or the bundle predates per-module fingerprints).
Map<String, String> moduleFingerprintsForProject(Directory projectDir) {
  return Map<String, String>.of(
    _lastBuilds[projectDir.path]?.moduleFingerprints ?? const {},
  );
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

/// Packages that are build/dev tools and should never be bundled into the runtime.
const kExcludedDevPackages = {
  '_fe_analyzer_shared',
  'analyzer',
  'build',
  'build_config',
  'build_daemon',
  'build_resolvers',
  'build_runner',
  'build_runner_core',
  'code_builder',
  'dart_style',
  'frontend_server_client',
  'graphs',
  'lints',
  'flutter_lints',
  'source_gen',
  'source_helper',
  'test',
  'test_api',
  'test_core',
  'matcher',
  'coverage',
};

final Map<String, ({DateTime mtime, Map<String, String> sources})>
    _packageSourcesCache = {};

/// Discovers and loads source code for third-party and pure Dart packages
/// listed in `.dart_tool/package_config.json`.
///
/// Allows `AstBundler` to automatically resolve and bundle package imports
/// (e.g. `package:riverpod_kit/riverpod_kit.dart`, `package:riverpod/riverpod.dart`)
/// into the AST bundle without manual configuration.
Map<String, String> resolvePackageSources(
  Directory projectDir, {
  String? packageName,
}) {
  final configFile = File('${projectDir.path}/.dart_tool/package_config.json');
  if (!configFile.existsSync()) return const {};

  final mtime = configFile.lastModifiedSync();
  final cacheKey = '${projectDir.path}:$packageName';
  final cached = _packageSourcesCache[cacheKey];
  if (cached != null && cached.mtime == mtime) {
    return cached.sources;
  }

  final sources = <String, String>{};

  try {
    final json = jsonDecode(configFile.readAsStringSync());
    if (json is! Map<String, dynamic>) return sources;
    final packages = json['packages'] as List<dynamic>?;
    if (packages == null) return sources;

    final baseUri = configFile.uri;

    for (final pkg in packages) {
      if (pkg is! Map<String, dynamic>) continue;
      final name = pkg['name'] as String?;
      if (name == null || name.isEmpty) continue;
      // Skip the host app itself (handled directly by AstBundler via lib/)
      if (name == packageName) continue;
      // Skip native core and platform bindings
      if (name == 'dartnative' ||
          name == 'dartnative_ios' ||
          name == 'dartnative_android') {
        continue;
      }
      // Skip dev and analyzer tool packages
      if (kExcludedDevPackages.contains(name)) {
        continue;
      }

      final rawRootStr = pkg['rootUri'] as String?;
      final rawPkgUriStr = (pkg['packageUri'] as String?) ?? 'lib/';
      if (rawRootStr == null) continue;

      final rootUriStr =
          rawRootStr.endsWith('/') ? rawRootStr : '$rawRootStr/';
      final packageUriStr =
          rawPkgUriStr.endsWith('/') ? rawPkgUriStr : '$rawPkgUriStr/';

      final rootUri = baseUri.resolve(rootUriStr);
      final libUri = rootUri.resolve(packageUriStr);
      final libDir = Directory.fromUri(libUri);
      if (!libDir.existsSync()) continue;

      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final rel = p
              .relative(entity.path, from: libDir.path)
              .replaceAll('\\', '/');
          final packageUri = 'package:$name/$rel';
          // Don't override bridged libraries
          if (!kAstBridgedLibraries.contains(packageUri)) {
            try {
              sources[packageUri] = entity.readAsStringSync();
            } catch (_) {}
          }
        }
      }
    }
    _packageSourcesCache[cacheKey] = (mtime: mtime, sources: sources);
  } catch (_) {}

  return sources;
}

String? detectGuestPackageName(Directory projectDir) {
  try {
    final pubspec = File('${projectDir.path}/pubspec.yaml');
    if (!pubspec.existsSync()) return null;
    for (final line in pubspec.readAsLinesSync()) {
      final match =
          RegExp(r'^name:\s*([A-Za-z0-9_]+)').firstMatch(line.trim());
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
Future<String> fingerprintGuestSources(
  Directory codeRoot, [
  Directory? projectDir,
]) async {
  final hash = _Fnv1a64();

  final files = <File>[];
  if (codeRoot.existsSync()) {
    await for (final e in codeRoot.list(recursive: true)) {
      if (e is File && e.path.endsWith('.dart')) files.add(e);
    }
  }
  if (projectDir != null) {
    final pkgConfig = File('${projectDir.path}/.dart_tool/package_config.json');
    if (pkgConfig.existsSync()) files.add(pkgConfig);
  }
  files.sort((a, b) => a.path.compareTo(b.path));
  for (final f in files) {
    hash.addString(f.path.replaceAll('\\', '/'));
    try {
      hash.addBytes(await f.readAsBytes());
    } catch (_) {}
  }
  return hash.hex;
}

class _LastBuild {
  final String fingerprint;
  final String outputPath;
  final int moduleCount;
  final int byteSize;
  final String entryPointUri;
  final bool bytecodeBuilt;
  final Map<String, String> moduleFingerprints;

  const _LastBuild({
    required this.fingerprint,
    required this.outputPath,
    required this.moduleCount,
    required this.byteSize,
    required this.entryPointUri,
    required this.bytecodeBuilt,
    required this.moduleFingerprints,
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

  final rawPath = outputArg ?? 'assets/bundles/guest.ast';
  final outPath = rawPath.startsWith('${projectDir.path}/')
      ? rawPath
      : p.isAbsolute(rawPath)
          ? rawPath
          : p.join(projectDir.path, rawPath);
  final outFile = File(outPath);

  // Incremental fast path: unchanged sources since last success → skip parse.
  final codeRoot = _codeRootFor(projectDir, entryFile);
  final bcPath = outPath.endsWith('.ast')
      ? '${outPath.substring(0, outPath.length - 4)}.bc'
      : '$outPath.bc';
  final bcFile = File(bcPath);

  if (incremental && !force) {
    final last = _lastBuilds[projectDir.path];
    if (last != null && last.outputPath == outFile.path) {
      final fp = await fingerprintGuestSources(codeRoot, projectDir);
      if (fp == last.fingerprint && outFile.existsSync()) {
        // The `.ast` artifact is the source of truth for the cache; a missing
        // sibling `.bc` (deleted after a failed emit, or by hand) must not
        // force a re-parse on every request.
        final bcMissing = last.bytecodeBuilt && !bcFile.existsSync();
        if (bcMissing) {
          DartGoLogger.warn(
            'guest.bc is missing for an unchanged source tree — force a '
            'rebuild to regenerate the bytecode bundle.',
            tag: 'AstBuilder',
          );
        }
        final size = await outFile.length();
        return AstBuildResult(
          success: true,
          outputPath: outFile.path,
          moduleCount: last.moduleCount,
          byteSize: size,
          entryPointUri: last.entryPointUri,
          cached: true,
          bytecodeBuilt: last.bytecodeBuilt && !bcMissing,
          moduleFingerprints: last.moduleFingerprints,
        );
      }
    }
  }

  try {
    final t1 = Stopwatch()..start();
    final explicitSources = <String, String>{
      ...resolvePackageSources(projectDir, packageName: packageName),
      ...registrantStubs(projectDir, packageName),
    };
    final resolveMs = t1.elapsedMilliseconds;

    final t2 = Stopwatch()..start();
    final bundler = AstBundler(
      bridgedLibraries: kAstBridgedLibraries,
      explicitSources: explicitSources,
      packageName: packageName,
      projectRoot: projectDir.path,
      converter: SafeAstConverter(),
    );
    final bundle = await bundler.createFromFile(entryFile.path);
    final parseBundleMs = t2.elapsedMilliseconds;

    final t3 = Stopwatch()..start();
    await outFile.parent.create(recursive: true);
    bundle.saveToFile(outFile.path);
    final size = await outFile.length();

    // Auto-build Bytecode bundle (.bc) alongside .ast so both runtimes stay in
    // sync. Skipped entirely while the Bytecode engine is disabled
    // (kBytecodeEnabled) — nothing can select it, so the artifact would only cost
    // build time.
    //
    // A failed emit is fatal *for bytecode*: the stale artifact is deleted so the
    // dev server stops advertising `hasBytecodeBundle` and the device falls back
    // to AST instead of executing a bundle that no longer matches the sources.
    var bytecodeBuilt = false;
    if (!kBytecodeEnabled) {
      if (bcFile.existsSync()) {
        try {
          await bcFile.delete();
        } catch (_) {}
      }
    } else {
      try {
        final bcEmitter = BytecodeEmitter();
        final bcBundle = bcEmitter.compileBundle(bundle);
        final bcBytes = BytecodeBundleCodec.encodeBundle(bcBundle);
        await bcFile.parent.create(recursive: true);
        await bcFile.writeAsBytes(bcBytes, flush: true);
        bytecodeBuilt = true;
      } catch (bcError, bcSt) {
        var deletedStale = false;
        try {
          if (bcFile.existsSync()) {
            await bcFile.delete();
            deletedStale = true;
          }
        } catch (_) {}
        DartGoLogger.error(
          'Bytecode auto-build failed — guest.bc is unavailable'
          '${deletedStale ? ' (deleted stale artifact)' : ''}',
          bcError,
          bcSt,
        );
        DartGoLogger.warn(
          'Bytecode mode unavailable for this build; AST mode unaffected.',
          tag: 'AstBuilder',
        );
      }
    }

    final moduleFingerprints = fingerprintBundleModules(bundle.modules);
    final fp = await fingerprintGuestSources(codeRoot, projectDir);
    _lastBuilds[projectDir.path] = _LastBuild(
      fingerprint: fp,
      outputPath: outFile.path,
      moduleCount: bundle.modules.length,
      byteSize: size,
      entryPointUri: bundle.entryPointUri,
      bytecodeBuilt: bytecodeBuilt,
      moduleFingerprints: moduleFingerprints,
    );
    final writeMs = t3.elapsedMilliseconds;
    DartGoLogger.bench(
      'AstBuilder',
      'guest.ast & guest.bc generated',
      resolveMs + parseBundleMs + writeMs,
      {
        'resolve': resolveMs,
        'parse': parseBundleMs,
        'write': writeMs,
        'bytecode': bytecodeBuilt ? 'ok' : 'failed',
        'module_fps': moduleFingerprints.length,
      },
    );

    return AstBuildResult(
      success: true,
      outputPath: outFile.path,
      moduleCount: bundle.modules.length,
      byteSize: size,
      entryPointUri: bundle.entryPointUri,
      bytecodeBuilt: bytecodeBuilt,
      moduleFingerprints: moduleFingerprints,
    );
  } catch (e, st) {
    return AstBuildResult(
      success: false,
      outputPath: outFile.path,
      error: '$e\n$st',
    );
  }
}


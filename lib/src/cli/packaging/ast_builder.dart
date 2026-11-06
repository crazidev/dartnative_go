// ignore_for_file: unnecessary_null_comparison, dead_code, dead_null_aware_expression
// ↑ Archive 3.x (embedded in DartNative AOT) returns nullable List<int>? from
//   GZipEncoder.encode(); archive 4.x (host/pub-cache) returns non-nullable.
//   The null-checks below are intentional cross-version compatibility shims.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:archive/archive.dart' show GZipEncoder;
import 'package:path/path.dart' as p;
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart' show AstBundle;

import '../../runner/logger.dart';
import '../server_components/client_module_index.dart';
import 'safe_ast_converter.dart';
import '../server_components/server_annotation_scanner.dart';
import '../server_components/server_annotation_source.dart';
import '../diagnostics/icon_annotation_scanner.dart'
    show iconFontAnnotationSources;
import '../server_components/server_component_bundler.dart';

// GZip encoder used to pre-compress module bytes during parse.
// Declared final (not const) for archive 3.x / 4.x compat — see AstBundle.
final _gzipEncoder = GZipEncoder();

/// Formats a byte count as human-readable size (e.g. `100 B`, `73.2 KB`,
/// `1.50 MB`). Shared by DevServer logs and AST tooling so bundle sizes
/// don't render as raw byte counts.
String formatByteSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}

/// Libraries handled by native bridges at runtime — skipped during bundling.
///
/// Shared by the dev server (`server.dart --rebuild-ast`) and
/// `tool/build_ast_bundle.dart` so both produce identical bundles.
const kAstBridgedLibraries = {
  'package:dartnative/dartnative.dart',
  'package:dartnative/flutter_compat.dart',
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
  'package:dartnative_notifications/dartnative_notifications.dart',
  'package:dartnative_notifications/src/dartnative_notifications.dart',
  'package:dartnative_notifications/src/notifications_ffi_bindings.dart',
  'package:dartnative_system/dartnative_system.dart',
  'package:dartnative_system/src/package_info.dart',
  'package:dartnative_system/src/app_badge.dart',
  'package:dartnative_system/src/system_ffi_bindings.dart',
  'package:dartnative_connectivity/connectivity.dart',
  'package:dartnative_connectivity/src/connectivity.dart',
  'package:dartnative_connectivity/src/connectivity_result.dart',
  'package:dartnative_connectivity/src/connectivity_ffi_bindings.dart',
  'package:dartnative_media_picker/dartnative_media_picker.dart',
  'package:dartnative_media_picker/gallery.dart',
  'package:dartnative_media_picker/src/media_picker.dart',
  'package:dartnative_media_picker/src/gallery.dart',
  'package:dartnative_media_picker/src/media_picker_ffi_bindings.dart',
  'package:dartnative_media_picker/src/gallery_ffi_bindings.dart',
  'package:dartnative_background/dartnative_background.dart',
  'package:dartnative_background/task_manager.dart',
  'package:dartnative_background/src/task_manager.dart',
  'package:dartnative_background/src/options.dart',
  'package:dartnative_background/src/task_manager_ffi_bindings.dart',
  'package:riverpod_kit/riverpod_kit.dart',
  'package:riverpod/riverpod.dart',
  // Third-party pure-Dart packages compiled into the shell (see the `dio`
  // module in buildkit{,_ast}.yaml). Guests importing them get the bridged,
  // native-speed copy, so the bundler must not try to parse them.
  'package:dio/dio.dart',
  'package:flutter/widgets.dart',
  'package:flutter/material.dart',
  'package:flutter/cupertino.dart',
  'package:flutter/foundation.dart',
  'package:flutter/painting.dart',
  'package:flutter/rendering.dart',
  'package:flutter/services.dart',
  // Host `ServerComponentView` for guest code. The URI resolves at runtime
  // to the bridge registered by AstInterpreterRunner — never bundled (the
  // real file pulls in the host runner + flutter, which must not leak into
  // guest bundles). Contrast package:dartnative_go/server.dart (the
  // dependency-free annotation), which IS bundled via explicitSources.
  'package:dartnative_go/server_component.dart',
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

  /// Per-module content fingerprints (module URI → FNV-1a hex).
  final Map<String, String> moduleFingerprints;

  /// Fingerprint of the guest sources for incremental cache checks.
  final String fingerprint;

  /// Compressed delta patch bytes for hot reload.
  final List<int>? patchBytes;

  /// Client module index emitted alongside the bundle, if available.
  final ClientModuleIndex? clientModuleIndex;

  /// Server component build results, if any annotated components were found.
  final ServerComponentsBuildResult? serverComponents;

  const AstBuildResult({
    required this.success,
    required this.outputPath,
    this.moduleCount = 0,
    this.byteSize = 0,
    this.entryPointUri = '',
    this.error,
    this.cached = false,
    this.moduleFingerprints = const {},
    this.fingerprint = '',
    this.patchBytes,
    this.clientModuleIndex,
    this.serverComponents,
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

/// Process-lifetime AST compilation unit cache.
///
/// Stores per-module: the source hash (FNV-1a hex of raw source), the parsed
/// [SCompilationUnit], its JSON fingerprint, and — crucially — the
/// already-gzip-compressed bytes for the module.
///
/// Caching compressed bytes means hot reloads only pay the gzip cost for
/// modules whose source actually changed; the other N-k modules are stitched
/// into the ZIP from memory with zero serialization work.
final Map<
  String,
  ({
    String sourceHash,
    SCompilationUnit unit,
    String fingerprint,
    List<int> compressedBytes,
  })
>
_moduleAstCache = {};

/// Process-lifetime cache of gzip-compressed module bytes (module URI → bytes).
///
/// Populated by [_getOrParse] and read by [buildGuestAstBundle] to supply the
/// [precompressedModules] argument to [AstBundle.saveToFile]. Updated in-place
/// when a module is re-parsed so stale bytes are evicted automatically.
final Map<String, List<int>> _compressedBytesCache = {};

/// Process-lifetime cache of per-module AST JSON sizes (module URI → bytes).
///
/// Recorded while a module is serialized anyway (parse / fingerprint), then
/// written into the bundle manifest so devices can report AST sizes without
/// re-serializing every decoded module at launch. See
/// [AstBundle.toZip]'s `moduleAstBytes` parameter.
final Map<String, int> _moduleAstBytesCache = {};

/// Process-lifetime cache of per-class AST JSON sizes
/// (module URI → class name → bytes). See [_moduleAstBytesCache].
final Map<String, Map<String, int>> _classAstBytesCache = {};

/// Process-lifetime source-file cache: absolute file path → (mtime, source).
///
/// Used by [IncrementalAstBundler._resolveFromFileSystem] to skip disk reads
/// for files whose mtime is unchanged. This eliminates the ~1 000 ms cost of
/// reading 2 000 `.dart` files on every hot reload even when only 10 changed.
///
/// Entry is invalidated (removed) when [_getOrParse] detects that a file's
/// source hash has changed relative to the last-cached [SCompilationUnit].
final Map<String, ({DateTime mtime, String source})> _fileSourceCache = {};

/// Process-lifetime bidirectional path ↔ URI mapping.
///
/// [_filePathToUri]: absolute canonical file path → module URI.
/// Populated by [IncrementalAstBundler._resolveFromFileSystem] on every
/// successful resolution so [buildGuestAstBundle] can find the URI for a
/// changed file path and evict it from the module seed.
final Map<String, String> _filePathToUri = {};

/// Process-lifetime URI → absolute file path reverse mapping.
final Map<String, String> _uriToFilePath = {};

/// FNV-1a fingerprints for every compiled module, keyed by module URI.
///
/// Fast path: reuses cached fingerprints for unchanged units, avoiding
/// expensive `jsonEncode(unit.toJson())` serialization on every reload.
Map<String, String> fingerprintBundleModules(
  Map<String, SCompilationUnit> modules,
) {
  final out = <String, String>{};
  modules.forEach((uri, unit) {
    final cached = _moduleAstCache[uri];
    if (cached != null && identical(cached.unit, unit)) {
      out[uri] = cached.fingerprint;
    } else {
      final hash = _Fnv1a64()..addString(jsonEncode(unit.toJson()));
      out[uri] = hash.hex;
    }
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

/// Returns the current fingerprint of the AST bundle for [projectDir],
/// using the last build cache or falling back to the file's modification time.
String astBundleFingerprintForProject(Directory projectDir, File astFile) {
  final last = _lastBuilds[projectDir.path];
  if (last != null && last.fingerprint.isNotEmpty) {
    return last.fingerprint;
  }
  if (astFile.existsSync()) {
    return astFile.lastModifiedSync().millisecondsSinceEpoch.toString();
  }
  return '';
}

/// Returns the in-memory [AstBundle] from the last successful build for
/// [projectDir], or `null` if no build has been performed yet.
///
/// Callers should prefer this over `AstBundle.fromFile(outPath)` during
/// hot reload — the cached bundle is already deserialized and avoids the
/// ~600 ms ZIP-decode + `fromJson` overhead for large projects.
AstBundle? cachedBundleForProject(Directory projectDir) {
  return _lastBuilds[projectDir.path]?.cachedBundle;
}

/// Returns the in-memory delta patch bytes from the last hot reload build for
/// [projectDir], or `null` if the last build was a cold/full build or had no patch.
List<int>? patchBytesForProject(Directory projectDir) {
  return _lastBuilds[projectDir.path]?.patchBytes;
}

/// Returns the in-memory delta patch [AstBundle] from the last hot reload build.
AstBundle? patchBundleForProject(Directory projectDir) {
  return _lastBuilds[projectDir.path]?.patchBundle;
}

/// Source fingerprint of the bundle the current patch delta applies to.
///
/// Devices send this back as `?base=` on `/guest.ast.patch`; a mismatch
/// means the device missed an intermediate reload and must take the full
/// bundle. Null when no patch is active.
String? patchBaseFingerprintForProject(Directory projectDir) {
  return _lastBuilds[projectDir.path]?.patchBaseFingerprint;
}

/// Source fingerprint of the current in-memory bundle for [projectDir].
///
/// Sent as `X-Ast-Bundle` on patch responses so devices advance their patch
/// base without a full fetch. Empty when no build has completed yet.
String bundleFingerprintForProject(Directory projectDir) {
  return _lastBuilds[projectDir.path]?.fingerprint ?? '';
}

/// Source fingerprint of the bundle bytes last written to [outFilePath].
///
/// Sent as `X-Ast-Bundle` on full `/guest.ast` responses. Empty when the
/// file was not written by a tracked build (e.g. predates this server
/// process) — devices then treat their base as unknown and re-sync via a
/// full fetch before trusting patches.
String fileSourceFingerprintForPath(String outFilePath) {
  return _fileSourceFingerprints[outFilePath] ?? '';
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
  if (File(
    '${projectDir.path}/lib/dartnative_plugin_registrant.dart',
  ).existsSync()) {
    stubs['lib/dartnative_plugin_registrant.dart'] = kRegistrantStub;
    if (packageName != null) {
      stubs['package:$packageName/dartnative_plugin_registrant.dart'] =
          kRegistrantStub;
    }
  }
  if (File(
    '${projectDir.path}/guest_app/dartnative_plugin_registrant.dart',
  ).existsSync()) {
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
final Map<String, ({DateTime mtime, Map<String, String> sources})>
_pkgDirCache = {};

/// Locates the nearest `.dart_tool/package_config.json` for [startDir],
/// walking up parent directories.
///
/// Pub workspaces keep a single config at the workspace root; member packages
/// (for example `example/`) have no `.dart_tool/package_config.json` of their
/// own. Returning the ancestor config keeps pure-Dart dependency resolution
/// working for workspace members instead of silently yielding an empty map.
File? findPackageConfigFile(Directory startDir) {
  var dir = startDir.absolute;
  while (true) {
    final candidate = File('${dir.path}/.dart_tool/package_config.json');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) return null;
    dir = parent;
  }
}

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
  final configFile = findPackageConfigFile(projectDir);
  if (configFile == null) return const {};

  final mtime = configFile.lastModifiedSync();
  final cacheKey = '${configFile.path}:$packageName';
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
      // Skip the server-component host package itself: guest code imports
      // `package:dartnative_go/server.dart` for the annotation, which is
      // provided implicitly (and minimally) via [serverAnnotationSources].
      // Reading its whole lib/ here would slow every build for no benefit.
      if (name == 'dartnative_go') {
        continue;
      }
      // Skip dev and analyzer tool packages
      if (kExcludedDevPackages.contains(name)) {
        continue;
      }

      final rawRootStr = pkg['rootUri'] as String?;
      final rawPkgUriStr = (pkg['packageUri'] as String?) ?? 'lib/';
      if (rawRootStr == null) continue;

      final rootUriStr = rawRootStr.endsWith('/') ? rawRootStr : '$rawRootStr/';
      final packageUriStr = rawPkgUriStr.endsWith('/')
          ? rawPkgUriStr
          : '$rawPkgUriStr/';

      final rootUri = baseUri.resolve(rootUriStr);
      final libUri = rootUri.resolve(packageUriStr);
      final libDir = Directory.fromUri(libUri);
      if (!libDir.existsSync()) continue;

      final libStat = libDir.statSync();
      final libMtime = libStat.modified;
      final pkgKey = '$name:${libDir.path}';
      final cachedPkg = _pkgDirCache[pkgKey];
      if (cachedPkg != null && cachedPkg.mtime == libMtime) {
        sources.addAll(cachedPkg.sources);
        continue;
      }

      final pkgSources = <String, String>{};
      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final rel = p
              .relative(entity.path, from: libDir.path)
              .replaceAll('\\', '/');
          final packageUri = 'package:$name/$rel';
          // Don't override bridged libraries
          if (!kAstBridgedLibraries.contains(packageUri)) {
            try {
              pkgSources[packageUri] = entity.readAsStringSync();
            } catch (_) {}
          }
        }
      }
      _pkgDirCache[pkgKey] = (mtime: libMtime, sources: pkgSources);
      sources.addAll(pkgSources);
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
    final pkgConfig = findPackageConfigFile(projectDir);
    if (pkgConfig != null) files.add(pkgConfig);
  }
  files.sort((a, b) => a.path.compareTo(b.path));
  for (final f in files) {
    hash.addString(f.path.replaceAll('\\', '/'));
    try {
      final bytes = await f.readAsBytes();
      hash.addBytes(bytes);
      // Warm _fileHashCache so the first hot reload after a cold-build scan
      // doesn't need to re-read all files — fastFingerprintGuestSources will
      // find the cache populated and only re-read changed files.
      if (!_fileHashCache.containsKey(f.path)) {
        final mtime = f.lastModifiedSync();
        final perFile = _Fnv1a64()..addBytes(bytes);
        _fileHashCache[f.path] = (mtime: mtime, contentHash: perFile.hex);
      }
    } catch (_) {}
  }
  return hash.hex;
}

/// Per-file content fingerprint cache: absolute path → (mtime, contentHash).
///
/// Populated by [_updateFileHashCache]. Allows [fastFingerprintGuestSources]
/// to skip reading files that haven't changed (mtime unchanged).
final Map<String, ({DateTime mtime, String contentHash})> _fileHashCache = {};

/// Computes an incremental project fingerprint by only re-reading [changedPaths]
/// and reusing the cached per-file hash for every other file.
///
/// This is the hot-reload fast-path: for a 2 000-file project with 10 changed
/// files we stat 10 files and read 10 files instead of all 2 000, reducing
/// fingerprint cost from ~400 ms to <5 ms.
///
/// Falls back to [fingerprintGuestSources] (full scan) when [_fileHashCache]
/// is empty (e.g. first build in a new server process).
Future<String> fastFingerprintGuestSources(
  Directory codeRoot,
  Directory? projectDir,
  Set<String> changedPaths,
) async {
  // Cold-start: cache is empty — do a full scan to populate it.
  if (_fileHashCache.isEmpty) {
    await _populateFileHashCache(codeRoot, projectDir);
  } else {
    // Warm: only re-hash the files we know changed.
    for (final path in changedPaths) {
      final f = File(path);
      if (!f.existsSync()) {
        _fileHashCache.remove(path);
        continue;
      }
      try {
        final bytes = await f.readAsBytes();
        final mtime = f.lastModifiedSync();
        final h = _Fnv1a64()..addBytes(bytes);
        _fileHashCache[path] = (mtime: mtime, contentHash: h.hex);
      } catch (_) {
        _fileHashCache.remove(path);
      }
    }
  }

  // Combine all per-file hashes into a single deterministic fingerprint.
  // Sort by path for stability.
  final sortedPaths = _fileHashCache.keys.toList()..sort();
  final combined = _Fnv1a64();
  for (final path in sortedPaths) {
    combined.addString(path.replaceAll('\\', '/'));
    combined.addString(_fileHashCache[path]!.contentHash);
  }
  return combined.hex;
}

/// Populates [_fileHashCache] by stat + reading every `.dart` file under
/// [codeRoot] (and `package_config.json` when [projectDir] is given).
Future<void> _populateFileHashCache(
  Directory codeRoot,
  Directory? projectDir,
) async {
  final files = <File>[];
  if (codeRoot.existsSync()) {
    await for (final e in codeRoot.list(recursive: true)) {
      if (e is File && e.path.endsWith('.dart')) files.add(e);
    }
  }
  if (projectDir != null) {
    final pkgConfig = findPackageConfigFile(projectDir);
    if (pkgConfig != null) files.add(pkgConfig);
  }
  for (final f in files) {
    final path = f.path;
    final existing = _fileHashCache[path];
    final mtime = f.lastModifiedSync();
    if (existing != null && existing.mtime == mtime) continue; // still valid
    try {
      final bytes = await f.readAsBytes();
      final h = _Fnv1a64()..addBytes(bytes);
      _fileHashCache[path] = (mtime: mtime, contentHash: h.hex);
    } catch (_) {}
  }
}

class _LastBuild {
  final String fingerprint;
  final String outputPath;
  final int moduleCount;
  final int byteSize;
  final String entryPointUri;
  final Map<String, String> moduleFingerprints;

  /// In-memory bundle: avoids reading + decompressing guest.ast from disk on
  /// client reload. Set after every successful build.
  final AstBundle? cachedBundle;

  /// Delta patch bundle containing ONLY the modules changed in this reload cycle.
  final AstBundle? patchBundle;

  /// Compressed bytes of [patchBundle] (gzip JSON), ready for sub-10ms network transfer.
  final List<int>? patchBytes;

  /// Source fingerprint of the bundle this [patchBytes] delta applies to
  /// (the *previous* build's [fingerprint]). A device whose base differs
  /// must take the full bundle — applying the delta would strand stale
  /// modules (franken-bundle) with no error. Null when [patchBytes] is null.
  final String? patchBaseFingerprint;

  /// Client module index from the last successful build.
  final ClientModuleIndex? clientModuleIndex;

  /// Server component build results, if any.
  final ServerComponentsBuildResult? serverComponents;

  const _LastBuild({
    required this.fingerprint,
    required this.outputPath,
    required this.moduleCount,
    required this.byteSize,
    required this.entryPointUri,
    required this.moduleFingerprints,
    this.cachedBundle,
    this.patchBundle,
    this.patchBytes,
    this.patchBaseFingerprint,
    this.clientModuleIndex,
    this.serverComponents,
  });
}

/// Last successful build per project (server-process lifetime).
final Map<String, _LastBuild> _lastBuilds = {};

/// Source fingerprint of the bundle bytes last written to each output file.
///
/// The disk write for hot reloads is deferred to the background, so the file
/// can lag the in-memory bundle: this map is updated only on write
/// *completion*, guaranteeing the recorded fingerprint always describes the
/// bytes actually served from disk (unlike [_lastBuilds], which tracks the
/// newer in-memory state). Keyed by output file path.
final Map<String, String> _fileSourceFingerprints = {};

/// Incremental AST bundler that reuses parsed [SCompilationUnit]s for modules
/// whose source content has not changed.
class IncrementalAstBundler {
  final Set<String> bridgedLibraries;
  final Map<String, String> explicitSources;
  final String? packageName;
  final String? projectRoot;
  final AstBundlerConfig config;
  final AstConverter converter;

  IncrementalAstBundler({
    this.bridgedLibraries = const {},
    this.explicitSources = const {},
    this.packageName,
    this.projectRoot,
    this.config = const AstBundlerConfig(),
    AstConverter? converter,
  }) : converter = converter ?? SafeAstConverter();

  /// Creates an [AstBundle] from a Dart entry-point file.
  ///
  /// ### Hot-reload seed
  ///
  /// Pass [seedModules] (a map from module URI to [SCompilationUnit]) to
  /// pre-populate the bundle with known-good modules from the previous build.
  /// The DFS traversal will skip any URI already present in the seed, so only
  /// new or removed modules are resolved. This is the key hot-reload
  /// optimization: for a 2 000-module project with 10 changed files, the DFS
  /// terminates in ~1 ms instead of ~500 ms.
  ///
  /// The seed must NOT contain stale entries for changed files — the caller
  /// is responsible for removing changed URIs before passing.
  Future<AstBundle> createFromFile(
    String entryPointPath, {
    Map<String, SCompilationUnit>? seedModules,
  }) async {
    final file = File(entryPointPath);
    if (!file.existsSync()) {
      throw ArgumentError('Entry point file not found: $entryPointPath');
    }

    final source = await file.readAsString();

    final root = projectRoot ?? _detectProjectRoot(entryPointPath);
    final canonicalEntryPath = Uri.file(
      File(entryPointPath).absolute.path,
    ).normalizePath().toFilePath();
    final String entryUri;
    if (root != null &&
        packageName != null &&
        p.isWithin(p.join(root, 'lib'), canonicalEntryPath)) {
      final rel = p
          .relative(canonicalEntryPath, from: p.join(root, 'lib'))
          .replaceAll(r'\', '/');
      entryUri = 'package:$packageName/$rel';
    } else if (root != null) {
      entryUri = p
          .relative(canonicalEntryPath, from: root)
          .replaceAll(r'\', '/');
    } else {
      entryUri = entryPointPath.replaceAll(r'\', '/');
    }

    _filePathToUri[canonicalEntryPath] = entryUri;
    _uriToFilePath[entryUri] = canonicalEntryPath;

    final bundleSources = <String, String>{};
    bundleSources[entryUri] = source;

    // Start with the seed (previous build's modules minus evicted URIs).
    // The DFS will only recurse into URIs absent from this map.
    final modules = seedModules != null
        ? Map<String, SCompilationUnit>.of(seedModules)
        : <String, SCompilationUnit>{};

    final entryAst = _getOrParse(source, entryUri, path: entryPointPath);
    modules[entryUri] = entryAst;

    await _resolveImports(
      entryAst,
      Uri.parse(entryUri),
      modules,
      bundleSources: bundleSources,
      depth: 0,
      fileSystemRoot: root,
    );

    return AstBundle(
      entryPointUri: entryUri,
      modules: modules,
      sources: bundleSources,
    );
  }

  SCompilationUnit _getOrParse(String source, String uri, {String? path}) {
    final hash = (_Fnv1a64()..addString(source)).hex;
    final cached = _moduleAstCache[uri];
    if (cached != null && cached.sourceHash == hash) {
      // Source unchanged — reuse the parsed unit (and its compressed bytes
      // already sitting in _compressedBytesCache).
      return cached.unit;
    }

    final parseResult = parseString(
      content: source,
      path: path ?? uri,
      throwIfDiagnostics: false,
    );

    if (parseResult.errors.isNotEmpty) {
      final errors = parseResult.errors
          .map((e) => '  ${e.message} (offset ${e.offset})')
          .join('\n');
      throw FormatException('Parse errors in ${path ?? uri}:\n$errors');
    }

    final unit = converter.convertCompilationUnit(parseResult.unit);
    final moduleJson = jsonEncode(unit.toJson());
    final moduleBytes = utf8.encode(moduleJson);
    final fp = (_Fnv1a64()..addString(moduleJson)).hex;

    // Pre-compress now so the upcoming toZip() call can stitch these bytes
    // in without re-encoding. Archive 3.x encode() returns nullable; archive
    // 4.x returns non-nullable List<int>. The null-check and fallback below
    // are intentional cross-version compatibility shims (see ignore_for_file).
    final compressed = _gzipEncoder.encode(moduleBytes);
    if (compressed != null) {
      _compressedBytesCache[uri] = compressed;
    } else {
      _compressedBytesCache.remove(uri);
    }

    // Record AST sizes while the JSON is already in hand: the device profile
    // then reads them from the manifest instead of re-serializing every
    // decoded module at launch (a multi-second cost on device).
    final classBytes = <String, int>{};
    for (final declaration in unit.declarations) {
      if (declaration is! SClassDeclaration) continue;
      final className = declaration.name?.name ?? '(unnamed)';
      classBytes[className] =
          utf8.encode(jsonEncode(declaration.toJson())).length;
    }
    _moduleAstBytesCache[uri] = moduleBytes.length;
    _classAstBytesCache[uri] = classBytes;

    _moduleAstCache[uri] = (
      sourceHash: hash,
      unit: unit,
      fingerprint: fp,
      compressedBytes: compressed ?? const [],
    );
    return unit;
  }

  Future<void> _resolveImports(
    SCompilationUnit ast,
    Uri moduleUri,
    Map<String, SCompilationUnit> modules, {
    Map<String, String>? bundleSources,
    required int depth,
    String? fileSystemRoot,
  }) async {
    if (depth >= config.maxImportDepth) {
      throw StateError(
        'Import depth exceeded ${config.maxImportDepth} '
        'while processing $moduleUri. Possible circular import chain.',
      );
    }

    for (final directive in ast.directives) {
      String? uriString;
      if (directive is SImportDirective) {
        uriString = _extractUriString(directive.uri);
      } else if (directive is SExportDirective) {
        uriString = _extractUriString(directive.uri);
      } else if (config.followPartDirectives && directive is SPartDirective) {
        uriString = _extractUriString(directive.uri);
      }

      if (uriString == null) continue;

      final importUri = Uri.parse(uriString);
      final resolvedUri = _resolveUri(importUri, moduleUri);
      final canonicalUri = resolvedUri.toString();

      if (modules.containsKey(canonicalUri)) continue;

      final resolution = await _resolveImportUri(
        resolvedUri,
        moduleUri: moduleUri,
        fileSystemRoot: fileSystemRoot,
      );

      switch (resolution.action) {
        case ImportAction.skip:
          break;
        case ImportAction.include:
          if (modules.containsKey(resolution.canonicalUri)) break;
          if (bundleSources != null && resolution.value != null) {
            bundleSources[resolution.canonicalUri] = resolution.value!;
          }
          final importedAst = _getOrParse(
            resolution.value!,
            resolution.canonicalUri,
            path: resolution.canonicalUri,
          );
          modules[resolution.canonicalUri] = importedAst;
          await _resolveImports(
            importedAst,
            Uri.parse(resolution.canonicalUri),
            modules,
            bundleSources: bundleSources,
            depth: depth + 1,
            fileSystemRoot: fileSystemRoot,
          );
        case ImportAction.error:
          throw StateError(
            'Cannot resolve import "$uriString" from $moduleUri: ${resolution.value}',
          );
      }
    }
  }

  Future<ImportResolution> _resolveImportUri(
    Uri resolvedUri, {
    required Uri moduleUri,
    String? fileSystemRoot,
  }) async {
    final uriString = resolvedUri.toString();

    if (config.stdlibSchemes.contains(resolvedUri.scheme)) {
      return ImportResolution.skip(canonicalUri: uriString);
    }

    if (bridgedLibraries.contains(uriString)) {
      return ImportResolution.skip(canonicalUri: uriString);
    }

    if (explicitSources.containsKey(uriString)) {
      return ImportResolution.include(
        explicitSources[uriString]!,
        canonicalUri: uriString,
      );
    }

    if (resolvedUri.isScheme('package') && packageName != null) {
      final packagePath = resolvedUri.pathSegments.firstOrNull;
      if (packagePath == packageName) {
        return _resolveFromFileSystem(
          resolvedUri,
          fileSystemRoot: fileSystemRoot,
        );
      }
    }

    if (!resolvedUri.hasScheme || resolvedUri.scheme.isEmpty) {
      return _resolveFromFileSystem(
        resolvedUri,
        fileSystemRoot: fileSystemRoot,
      );
    }

    if (resolvedUri.isScheme('package')) {
      return ImportResolution.error(
        'Package import "$uriString" is not bridged and not in the same package. '
        'Either add it to bridgedLibraries or provide it via explicitSources.',
        canonicalUri: uriString,
      );
    }

    return ImportResolution.error(
      'Unsupported import scheme "${resolvedUri.scheme}" in "$uriString".',
      canonicalUri: uriString,
    );
  }

  Future<ImportResolution> _resolveFromFileSystem(
    Uri uri, {
    String? fileSystemRoot,
  }) async {
    final uriString = uri.toString();
    String? filePath;

    if (uri.isScheme('package') && packageName != null) {
      final pathInPackage = uri.pathSegments
          .skip(1)
          .join(Platform.pathSeparator);
      final root = fileSystemRoot ?? projectRoot;
      if (root != null) {
        filePath = p.join(root, 'lib', pathInPackage);
      }
    } else {
      filePath = uri.toFilePath();
      if (fileSystemRoot != null && !p.isAbsolute(filePath)) {
        filePath = p.join(fileSystemRoot, filePath);
      }
    }

    if (filePath == null) {
      return ImportResolution.error(
        'Cannot determine file path for "$uriString". '
        'Set projectRoot or provide the source via explicitSources.',
        canonicalUri: uriString,
      );
    }

    final canonicalPath = Uri.file(
      File(filePath).absolute.path,
    ).normalizePath().toFilePath();
    final file = File(canonicalPath);
    if (!file.existsSync()) {
      return ImportResolution.error(
        'Source file not found: $canonicalPath (for import "$uriString").',
        canonicalUri: uriString,
      );
    }

    final root = fileSystemRoot ?? projectRoot;
    final String canonicalUri;
    if (root != null &&
        packageName != null &&
        p.isWithin(p.join(root, 'lib'), canonicalPath)) {
      final rel = p
          .relative(canonicalPath, from: p.join(root, 'lib'))
          .replaceAll(r'\', '/');
      canonicalUri = 'package:$packageName/$rel';
    } else if (uri.isScheme('package')) {
      canonicalUri = uriString;
    } else if (root != null && p.isWithin(root, canonicalPath)) {
      canonicalUri = p
          .relative(canonicalPath, from: root)
          .replaceAll(r'\', '/');
    } else {
      canonicalUri = uriString;
    }

    // Record path ↔ URI so buildGuestAstBundle can evict changed URIs from
    // the module seed without having to re-walk the entire import graph.
    _filePathToUri[canonicalPath] = canonicalUri;
    _uriToFilePath[canonicalUri] = canonicalPath;

    // mtime-based source cache: skip the disk read entirely when the file
    // hasn't been modified since the last build. For a 2 000-module project
    // with 10 changed files this eliminates ~1 990 file reads (~1 000 ms)
    // per hot reload, leaving only 10 reads for the actually changed files.
    final mtime = file.lastModifiedSync();
    final cachedSource = _fileSourceCache[canonicalPath];
    final String source;
    if (cachedSource != null && cachedSource.mtime == mtime) {
      source = cachedSource.source;
    } else {
      source = await file.readAsString();
      _fileSourceCache[canonicalPath] = (mtime: mtime, source: source);
    }
    return ImportResolution.include(source, canonicalUri: canonicalUri);
  }

  String? _extractUriString(SStringLiteral? uriNode) {
    if (uriNode is SSimpleStringLiteral) return uriNode.value;
    return null;
  }

  Uri _resolveUri(Uri importUri, Uri moduleUri) {
    if (importUri.isScheme('dart') || importUri.isScheme('package')) {
      return importUri;
    }
    return moduleUri.resolveUri(importUri);
  }

  String? _detectProjectRoot(String filePath) {
    var dir = Directory(p.dirname(p.absolute(filePath)));
    while (dir.path != dir.parent.path) {
      if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
        return dir.path;
      }
      dir = dir.parent;
    }
    return null;
  }
}

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
  Set<String>? changedFiles,
}) async {
  final entryFile = resolveGuestEntry(projectDir, entryArg);
  if (entryFile == null) {
    return const AstBuildResult(
      success: false,
      outputPath: '',
      error:
          'No entrypoint (looked for lib/main.dart, then guest_app/main.dart)',
    );
  }

  final packageName = packageArg ?? detectGuestPackageName(projectDir);
  if (packageName == null) {
    return const AstBuildResult(
      success: false,
      outputPath: '',
      error:
          'Could not detect package name from pubspec.yaml (pass packageArg)',
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

  if (incremental && !force) {
    final last = _lastBuilds[projectDir.path];
    if (last != null && last.outputPath == outFile.path) {
      // Fast incremental fingerprint: only re-read changed files.
      final fp = changedFiles != null
          ? await fastFingerprintGuestSources(
              codeRoot,
              projectDir,
              changedFiles,
            )
          : await fingerprintGuestSources(codeRoot, projectDir);
      if (fp == last.fingerprint && outFile.existsSync()) {
        final size = outFile.lengthSync();
        return AstBuildResult(
          success: true,
          outputPath: outFile.path,
          moduleCount: last.moduleCount,
          byteSize: size,
          entryPointUri: last.entryPointUri,
          cached: true,
          moduleFingerprints: last.moduleFingerprints,
          fingerprint: fp,
          clientModuleIndex: last.clientModuleIndex,
          serverComponents: last.serverComponents,
        );
      }
    }
  }

  if (force) {
    _fileSourceCache.clear();
    _moduleAstCache.clear();
    _compressedBytesCache.clear();
    _moduleAstBytesCache.clear();
    _classAstBytesCache.clear();
  }

  try {
    final t1 = Stopwatch()..start();
    final explicitSources = <String, String>{
      ...resolvePackageSources(projectDir, packageName: packageName),
      ...registrantStubs(projectDir, packageName),
      // Server-side @ServerComponent annotation, last so the canonical
      // sources win even if the guest declares a host path dependency.
      ...serverAnnotationSources(),
      // @IconFont annotation for guest icon registries (same mechanism;
      // identical server.dart bytes, so spread order is irrelevant).
      ...iconFontAnnotationSources(),
    };
    final resolveMs = t1.elapsedMilliseconds;

    final t2 = Stopwatch()..start();
    final bundler = IncrementalAstBundler(
      bridgedLibraries: kAstBridgedLibraries,
      explicitSources: explicitSources,
      packageName: packageName,
      projectRoot: projectDir.path,
      converter: SafeAstConverter(),
    );

    // Hot-reload DFS fast-path: if we have a previous in-memory bundle and a
    // known set of changed files, seed the bundler with all previous modules
    // minus the changed ones, then pre-parse the changed files into the seed.
    // The DFS from main.dart then finds every URI already in the map and
    // terminates in ~1 ms instead of traversing all 2 000+ nodes.
    Map<String, SCompilationUnit>? seedModules;
    final previousBundle = _lastBuilds[projectDir.path]?.cachedBundle;
    // URIs successfully re-parsed from changed files. The seed DFS below
    // `continue`s at every URI already in the seed, so without an extra
    // traversal pass the *new* imports of these modules (e.g. a
    // just-created file) would never be discovered — see below.
    final reparsedUris = <String>{};
    if (incremental &&
        !force &&
        changedFiles != null &&
        previousBundle != null) {
      // Start with the full previous module map.
      seedModules = Map<String, SCompilationUnit>.of(previousBundle.modules);

      // Evict changed modules by resolving file paths → URIs.
      for (final path in changedFiles) {
        final canonicalPath = Uri.file(
          File(path).absolute.path,
        ).normalizePath().toFilePath();
        final uri = _filePathToUri[canonicalPath];
        if (uri != null) {
          seedModules.remove(uri);
          // Also invalidate source and compressed-bytes caches so next
          // _getOrParse always re-reads and re-compresses this file.
          _fileSourceCache.remove(canonicalPath);
          _compressedBytesCache.remove(uri);
          _moduleAstBytesCache.remove(uri);
          _classAstBytesCache.remove(uri);
        }
      }

      // Pre-parse the changed files and insert into the seed so the DFS sees
      // all 2 041 entries immediately and short-circuits on every lookup.
      for (final path in changedFiles) {
        final canonicalPath = Uri.file(
          File(path).absolute.path,
        ).normalizePath().toFilePath();
        final uri = _filePathToUri[canonicalPath];
        if (uri == null) continue; // new file — let DFS discover it normally
        try {
          final source = await File(canonicalPath).readAsString();
          // Update the mtime cache with the new source.
          _fileSourceCache[canonicalPath] = (
            mtime: File(canonicalPath).lastModifiedSync(),
            source: source,
          );
          final unit = bundler._getOrParse(source, uri, path: canonicalPath);
          seedModules[uri] = unit;
          reparsedUris.add(uri);
        } catch (_) {
          // If pre-parse fails (e.g. syntax error), remove from seed so the
          // DFS picks it up normally and surfaces the parse error.
          seedModules.remove(uri);
          reparsedUris.remove(uri);
        }
      }
    }

    final bundle = await bundler.createFromFile(
      entryFile.path,
      seedModules: seedModules,
    );
    final parseBundleMs = t2.elapsedMilliseconds;

    // New-file fix: the seed DFS skips every URI already in the seed, so a
    // changed module's *new* imports are never traversed. A just-created
    // file imported by an edited file would be missing from the bundle,
    // and the device would fail with `Package module ... not found in
    // bundle` until a full restart.
    // Traverse each re-parsed module's own directives to pull newly added
    // dependencies (and their sources) into the bundle. Unresolvable new
    // imports fail the build here — same as a cold build — so the device
    // keeps its working generation instead of hot-reloading into an error.
    for (final uri in reparsedUris) {
      final unit = bundle.modules[uri];
      if (unit == null) continue;
      await bundler._resolveImports(
        unit,
        Uri.parse(uri),
        bundle.modules,
        bundleSources: bundle.sources,
        depth: 0,
        fileSystemRoot: projectDir.path,
      );
    }

    // Sources fix: createFromFile only records sources for modules it
    // (re)parses in this run, so incremental bundles would otherwise carry
    // just the entry (devices report `source=n/a` and source-dependent
    // fallbacks go blind). Refresh changed files from disk first — the seed
    // DFS skips them (already seeded), so their fresh text never reaches
    // bundleSources — then carry forward the previous bundle's sources for
    // everything still present.
    final bundleSources = bundle.sources;
    if (changedFiles != null && bundleSources != null) {
      for (final path in changedFiles) {
        try {
          final canonical = Uri.file(
            File(path).absolute.path,
          ).normalizePath().toFilePath();
          final uri = _filePathToUri[canonical];
          if (uri != null && bundle.modules.containsKey(uri)) {
            bundleSources[uri] = await File(canonical).readAsString();
          }
        } catch (_) {}
      }
    }
    // Carry forward the previous bundle's sources for everything still present.
    final prevSources = previousBundle?.sources;
    if (prevSources != null && bundleSources != null) {
      for (final entry in prevSources.entries) {
        if (bundle.modules.containsKey(entry.key)) {
          bundleSources.putIfAbsent(entry.key, () => entry.value);
        }
      }
    }

    final t3 = Stopwatch()..start();

    final moduleFingerprints = fingerprintBundleModules(bundle.modules);
    // Compute fingerprint incrementally (only changed files re-read).
    final fp = changedFiles != null
        ? await fastFingerprintGuestSources(codeRoot, projectDir, changedFiles)
        : await fingerprintGuestSources(codeRoot, projectDir);

    // Determine whether we can skip the synchronous disk write.
    //
    // Hot reload fast-path: when a previous in-memory bundle exists and we
    // received a changedFiles hint, the dev server will serve the new bundle
    // directly from [cachedBundleForProject] — it never reads the .ast file
    // back during a live session. We schedule the ZIP write to happen in the
    // background so the caller gets a result in ~30 ms instead of ~1 000 ms.
    //
    // Synchronous write is kept for:
    //   • Cold builds (no previous cachedBundle) — client may load from disk.
    //   • force=true rebuilds — bridge change, need a fresh canonical .ast.
    //   • Non-incremental builds.
    final hasCachedBundle = _lastBuilds[projectDir.path]?.cachedBundle != null;
    final isHotReload =
        incremental && !force && changedFiles != null && hasCachedBundle;

    int size;
    AstBundle? patchBundle;
    List<int>? patchBytes;
    String? previousFingerprint;
    if (isHotReload) {
      // Capture the base BEFORE this build overwrites [_lastBuilds]: the
      // patch below is a delta from the previous bundle to this one.
      previousFingerprint = _lastBuilds[projectDir.path]?.fingerprint;
      final last = _lastBuilds[projectDir.path];
      final patchModules = <String, SCompilationUnit>{};
      for (final path in changedFiles) {
        final canonical = Uri.file(
          File(path).absolute.path,
        ).normalizePath().toFilePath();
        final uri = _filePathToUri[canonical];
        if (uri != null && bundle.modules.containsKey(uri)) {
          patchModules[uri] = bundle.modules[uri]!;
        }
      }
      if (patchModules.isEmpty && last != null) {
        final prevFps = last.moduleFingerprints;
        for (final entry in moduleFingerprints.entries) {
          if (prevFps[entry.key] != entry.value) {
            final unit = bundle.modules[entry.key];
            if (unit != null) patchModules[entry.key] = unit;
          }
        }
      }
      // New-module union: a just-created file pulled in by the traversal
      // above may not be in changedFiles (watcher batches can split the
      // file creation from the import edit). Union every module whose
      // fingerprint is new or changed so the patch is self-sufficient —
      // otherwise the device applies a patch whose importer references a
      // module it never received.
      if (last != null) {
        final prevFps = last.moduleFingerprints;
        for (final entry in bundle.modules.entries) {
          if (prevFps[entry.key] != moduleFingerprints[entry.key]) {
            patchModules[entry.key] = entry.value;
          }
        }
      }
      if (patchModules.isNotEmpty) {
        final patchEntry = patchModules.containsKey(bundle.entryPointUri)
            ? bundle.entryPointUri
            : patchModules.keys.first;
        // Carry the recorded sizes for the patched modules so the device's
        // `applyPatch` refreshes its size metadata along with the AST.
        final patchModuleSizes = <String, int>{};
        final patchClassSizes = <String, Map<String, int>>{};
        for (final uri in patchModules.keys) {
          final moduleBytes = _moduleAstBytesCache[uri];
          if (moduleBytes != null) patchModuleSizes[uri] = moduleBytes;
          final classBytes = _classAstBytesCache[uri];
          if (classBytes != null) patchClassSizes[uri] = classBytes;
        }
        patchBundle = AstBundle(
          entryPointUri: patchEntry,
          modules: patchModules,
          moduleAstBytes: patchModuleSizes.isEmpty ? null : patchModuleSizes,
          classAstBytes: patchClassSizes.isEmpty ? null : patchClassSizes,
        );
        try {
          patchBytes = patchBundle.toBytes();
        } catch (_) {}
      }

      // Background write — does NOT block the return path.
      // Uses the precompressed cache so the background ZIP is still fast.
      final outFilePath = outFile.path;
      final cachedBytes = Map<String, List<int>>.of(_compressedBytesCache);
      final cachedModuleSizes = Map<String, int>.of(_moduleAstBytesCache);
      final cachedClassSizes = Map<String, Map<String, int>>.of(
        _classAstBytesCache,
      );
      final writtenFingerprint = fp;
      Future(() async {
        try {
          await outFile.parent.create(recursive: true);
          bundle.saveToFile(
            outFilePath,
            precompressedModules: cachedBytes,
            moduleAstBytes: cachedModuleSizes,
            classAstBytes: cachedClassSizes,
          );
          // Record only on success: the fingerprint must describe the bytes
          // actually on disk, which clients use as their patch base.
          _fileSourceFingerprints[outFilePath] = writtenFingerprint;
        } catch (_) {
          // Background write failure is non-fatal: the server continues
          // serving the in-memory bundle. It will be retried on next rebuild.
        }
      });
      // Report the last known size (will be stale by one reload but benign).
      size = outFile.existsSync() ? outFile.lengthSync() : 0;
    } else {
      // Cold/forced build — write synchronously before returning.
      await outFile.parent.create(recursive: true);
      bundle.saveToFile(
        outFile.path,
        precompressedModules: _compressedBytesCache,
        moduleAstBytes: _moduleAstBytesCache,
        classAstBytes: _classAstBytesCache,
      );
      _fileSourceFingerprints[outFile.path] = fp;
      size = outFile.lengthSync();
    }

    // Build and save the client module index alongside guest.ast.
    final clientIndex = ClientModuleIndex.fromBundle(
      bundle,
      bridgedUris: kAstBridgedLibraries,
      fingerprint: fp,
    );
    final indexFile = File(
      '${outFile.parent.path}/$kClientModuleIndexFile',
    );
    clientIndex.saveToFile(indexFile);

    // Scan for @ServerComponent annotations and build per-component delta bundles.
    ServerComponentsBuildResult? serverComponents;
    final annotated = ServerAnnotationScanner.scanBundle(bundle);
    if (annotated.isNotEmpty) {
      final componentBundler = ServerComponentBundler(
        bridgedLibraries: kAstBridgedLibraries,
        explicitSources: explicitSources,
        packageName: packageName,
        projectRoot: projectDir.path,
        converter: SafeAstConverter(),
        clientModuleIndex: clientIndex,
      );

      final result = await componentBundler.buildAll(
        annotated,
        allSources: {
          ...bundle.sources ?? const {},
          ...explicitSources,
        },
      );

      if (result.components.isNotEmpty) {
        final compDir = Directory('${outFile.parent.path}/server_components');
        for (final entry in result.components.entries) {
          final compFile = File('${compDir.path}/${entry.key}.ast');
          compFile.parent.createSync(recursive: true);
          compFile.writeAsBytesSync(entry.value.astBytes);
        }
        saveServerManifestToFile(
          result.manifest,
          File('${compDir.path}/manifest.json'),
        );
        serverComponents = result;
      }
    }

    _lastBuilds[projectDir.path] = _LastBuild(
      fingerprint: fp,
      outputPath: outFile.path,
      moduleCount: bundle.modules.length,
      byteSize: size,
      entryPointUri: bundle.entryPointUri,
      moduleFingerprints: moduleFingerprints,
      cachedBundle: bundle,
      patchBundle: patchBundle,
      patchBytes: patchBytes,
      patchBaseFingerprint: patchBytes != null ? previousFingerprint : null,
      clientModuleIndex: clientIndex,
      serverComponents: serverComponents,
    );
    final writeMs = t3.elapsedMilliseconds;
    DartGoLogger.bench(
      'AstBuilder',
      isHotReload
          ? 'guest.ast hot-reload (disk write deferred)'
          : 'guest.ast generated',
      resolveMs + parseBundleMs + writeMs,
      {
        'resolve': resolveMs,
        'parse': parseBundleMs,
        'write': writeMs,
        'hot_reload': isHotReload,
        'module_fps': moduleFingerprints.length,
      },
    );

    return AstBuildResult(
      success: true,
      outputPath: outFile.path,
      moduleCount: bundle.modules.length,
      byteSize: size,
      entryPointUri: bundle.entryPointUri,
      moduleFingerprints: moduleFingerprints,
      fingerprint: fp,
      patchBytes: patchBytes,
      clientModuleIndex: clientIndex,
      serverComponents: serverComponents,
    );
  } catch (e, st) {
    return AstBuildResult(
      success: false,
      outputPath: outFile.path,
      error: '$e\n$st',
    );
  }
}

/// Long-lived worker isolate that runs [buildGuestAstBundle] off the HTTP server's
/// event loop while keeping the AST module cache [_moduleAstCache] hot across rebuilds.
class AstBuildWorker {
  static final AstBuildWorker instance = AstBuildWorker();

  SendPort? _commands;
  ReceivePort? _responses;
  Isolate? _isolate;
  final Map<int, Completer<AstBuildResult>> _pending = {};
  int _nextId = 0;
  bool _starting = false;
  Completer<void>? _startCompleter;

  Future<void> _ensureStarted() async {
    if (_commands != null) return;
    if (_starting) return _startCompleter?.future;
    _starting = true;
    _startCompleter = Completer<void>();

    try {
      final handshake = ReceivePort();
      _isolate = await Isolate.spawn(_workerMain, handshake.sendPort);
      _responses = ReceivePort();
      final workerSendPort = await handshake.first as SendPort;
      workerSendPort.send(_responses!.sendPort);
      _commands = workerSendPort;

      _responses!.listen((message) {
        if (message is List && message.length >= 2) {
          final id = message[0] as int;
          final res = message[1] as AstBuildResult;
          _pending.remove(id)?.complete(res);
        }
      });
      _startCompleter?.complete();
    } catch (e) {
      _startCompleter?.completeError(e);
      rethrow;
    } finally {
      _starting = false;
    }
  }

  static void _workerMain(SendPort initialReplyTo) {
    final commandPort = ReceivePort();
    initialReplyTo.send(commandPort.sendPort);

    SendPort? replyTo;
    commandPort.listen((message) async {
      if (replyTo == null && message is SendPort) {
        replyTo = message;
        return;
      }
      if (message == 'stop') {
        commandPort.close();
        return;
      }
      if (message is List && message.length >= 8) {
        final id = message[0] as int;
        final projectDirPath = message[1] as String;
        final entryArg = message[2] as String?;
        final outputArg = message[3] as String?;
        final packageArg = message[4] as String?;
        final incremental = message[5] as bool;
        final force = message[6] as bool;
        final changedFiles = (message[7] as List?)?.cast<String>().toSet();

        try {
          final result = await buildGuestAstBundle(
            Directory(projectDirPath),
            entryArg: entryArg,
            outputArg: outputArg,
            packageArg: packageArg,
            incremental: incremental,
            force: force,
            changedFiles: changedFiles,
          );
          replyTo?.send([id, result]);
        } catch (e) {
          replyTo?.send([
            id,
            AstBuildResult(
              success: false,
              outputPath: '',
              error: 'Worker build error: $e',
            ),
          ]);
        }
      }
    });
  }

  Future<AstBuildResult> build(
    Directory projectDir, {
    String? entryArg,
    String? outputArg,
    String? packageArg,
    bool incremental = true,
    bool force = false,
    Set<String>? changedFiles,
  }) async {
    try {
      await _ensureStarted();
      final id = _nextId++;
      final completer = Completer<AstBuildResult>();
      _pending[id] = completer;
      _commands!.send([
        id,
        projectDir.path,
        entryArg,
        outputArg,
        packageArg,
        incremental,
        force,
        changedFiles?.toList(),
      ]);
      final result = await completer.future;
      if (result.success) {
        _lastBuilds[projectDir.path] = _LastBuild(
          fingerprint: result.fingerprint,
          outputPath: result.outputPath,
          moduleCount: result.moduleCount,
          byteSize: result.byteSize,
          entryPointUri: result.entryPointUri,
          moduleFingerprints: result.moduleFingerprints,
          patchBytes: result.patchBytes,
          clientModuleIndex: result.clientModuleIndex,
          serverComponents: result.serverComponents,
        );
      }
      return result;
    } catch (_) {
      // Fallback to in-process execution if isolate spawning fails
      return buildGuestAstBundle(
        projectDir,
        entryArg: entryArg,
        outputArg: outputArg,
        packageArg: packageArg,
        incremental: incremental,
        force: force,
        changedFiles: changedFiles,
      );
    }
  }

  void stop() {
    try {
      _commands?.send('stop');
    } catch (_) {}
    _commands = null;
    _responses?.close();
    _responses = null;
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    for (final c in _pending.values) {
      if (!c.isCompleted) {
        c.complete(
          const AstBuildResult(
            success: false,
            outputPath: '',
            error: 'Worker stopped',
          ),
        );
      }
    }
    _pending.clear();
  }
}

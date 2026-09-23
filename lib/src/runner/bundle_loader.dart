import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';

import '../cli/dep_packager.dart';
import '../interpreter/auto_import_parser.dart';
import 'dep_cache.dart';
import 'logger.dart';

/// Encapsulates the loaded project metadata and virtual multi-file source map.
///
/// Dual-mode: [sources]/[entrypointCode] always populated (source default).
/// [astBytes] best-effort populated from `GET /guest.ast` when the dev server
/// has a pre-compiled bundle (see `tool/build_ast_bundle.dart` + `server.dart`).
class ProjectBundle {
  final String appName;
  final String? appVersion;
  final String? splashUrl;
  final String? iconUrl;
  final String? splashBackgroundColor;
  final String serverUrl;
  final Map<String, String> sources;
  final String entrypointCode;
  final String entrypointLibrary;
  final List<Map<String, dynamic>> breakpoints;
  final List<String> assets;

  /// Raw pre-compiled `AstBundle` bytes (ZIP/gzip/JSON auto-detected by
  /// `tom_d4rt_ast` on the device). Null when server has no `/guest.ast`.
  final List<int>? astBytes;

  /// Entry function inside [astBytes] (defaults to `main`).
  final String? astEntryPoint;

  /// Raw pre-compiled `BytecodeBundle` bytes. Null when server has no `/guest.bc`.
  final List<int>? bytecodeBytes;

  /// Whether an AST bundle is available for opt-in testing.
  bool get hasAst => astBytes != null && astBytes!.isNotEmpty;

  /// Whether a Bytecode bundle is available.
  bool get hasBytecode => bytecodeBytes != null && bytecodeBytes!.isNotEmpty;

  const ProjectBundle({
    required this.appName,
    this.appVersion,
    this.splashUrl,
    this.iconUrl,
    this.splashBackgroundColor,
    required this.serverUrl,
    required this.sources,
    required this.entrypointCode,
    required this.entrypointLibrary,
    this.breakpoints = const [],
    this.assets = const [],
    this.astBytes,
    this.astEntryPoint,
    this.bytecodeBytes,
  });
}

/// Service to fetch and parse project manifests and bundles from the dev server.
class BundleLoader {
  final HttpClient _client;
  DepCache? _depCache;
  Map<String, String>? _cachedDepSources;
  String? _loadedDepsHash;

  BundleLoader({HttpClient? client, this._depCache})
      : _client = client ?? (HttpClient()..connectionTimeout = const Duration(seconds: 10));

  /// Sets the active on-device dependency cache.
  set depCache(DepCache? cache) {
    _depCache = cache;
    _cachedDepSources = null;
    _loadedDepsHash = null;
  }
  DepCache? get depCache => _depCache;

  /// Normalizes base server URL without trailing slash.
  static String normalizeUrl(String input) {
    var trimmed = input.trim();
    if (trimmed.isEmpty) return trimmed;
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      trimmed = 'http://$trimmed';
    }
    if (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  /// Fetches the project manifest from `$serverUrl/manifest.json`.
  Future<Map<String, dynamic>?> fetchManifest(String serverUrl) async {
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/manifest.json'));
      final res = await req.close();
      if (res.statusCode == HttpStatus.ok) {
        final body = await res.transform(utf8.decoder).join();
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) return decoded;
      }
    } catch (_) {}
    return null;
  }

  /// Best-effort fetch of pre-compiled `AstBundle` bytes from `/guest.ast`.
  ///
  /// Returns null (not an error) when the server has no bundle yet — source
  /// mode keeps working. Never throws.
  Future<List<int>?> fetchAstBytes(String serverUrl) async {
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/guest.ast'));
      final res = await req.close();
      if (res.statusCode != HttpStatus.ok) return null;
      final bytes = await res.fold<List<int>>(
        <int>[],
        (prev, el) => prev..addAll(el),
      );
      return bytes.isEmpty ? null : bytes;
    } catch (_) {
      return null;
    }
  }

  /// Best-effort fetch of pre-compiled `BytecodeBundle` bytes from `/guest.bc`.
  Future<List<int>?> fetchBytecodeBytes(String serverUrl) async {
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/guest.bc'));
      final res = await req.close();
      if (res.statusCode != HttpStatus.ok) return null;
      final bytes = await res.fold<List<int>>(
        <int>[],
        (prev, el) => prev..addAll(el),
      );
      return bytes.isEmpty ? null : bytes;
    } catch (_) {
      return null;
    }
  }

  /// Fetches package metadata from `/deps.json`.
  Future<List<DepEntry>> fetchDepsList(String serverUrl) async {
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/deps.json'));
      final res = await req.close();
      if (res.statusCode == HttpStatus.ok) {
        final body = await res.transform(utf8.decoder).join();
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic> && decoded['deps'] is List) {
          return (decoded['deps'] as List)
              .map((e) => DepEntry.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (_) {}
    return const [];
  }

  /// Downloads and extracts user code from `/user-code.zip`.
  Future<Map<String, String>> fetchUserCode(String serverUrl) async {
    final baseUrl = normalizeUrl(serverUrl);
    final userSources = <String, String>{};
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/user-code.zip'));
      final res = await req.close();
      if (res.statusCode == HttpStatus.ok) {
        final zipBytes = await res.fold<List<int>>(
          <int>[],
          (prev, el) => prev..addAll(el),
        );
        if (zipBytes.isNotEmpty) {
          final archive = ZipDecoder().decodeBytes(zipBytes);
          for (final file in archive) {
            if (file.isFile) {
              final content = utf8.decode(file.content as List<int>);
              userSources[file.name] = content;
            }
          }
        }
      }
    } catch (_) {}
    return userSources;
  }

  /// Fetches a package ZIP and stores it into the cache.
  Future<void> _fetchAndCachePackage(
    String zipUrl,
    String name,
    String version,
    DepCache cache,
  ) async {
    try {
      final req = await _client.getUrl(Uri.parse(zipUrl));
      final res = await req.close();
      if (res.statusCode == HttpStatus.ok) {
        final bytes = await res.fold<List<int>>(
          <int>[],
          (prev, el) => prev..addAll(el),
        );
        if (bytes.isNotEmpty) {
          await cache.storePackageZip(name, version, bytes);
        }
      }
    } catch (_) {}
  }

  /// Fetches the complete project bundle.
  ///
  /// Optimized:
  /// - When [onlyAst] is true, only fetches `/manifest.json` and `/guest.ast` (sub-50ms).
  /// - In source mode with `depMode: true`, only fetches changed packages (cached permanently)
  ///   and transfers `/user-code.zip` (< 10 KB).
  Future<ProjectBundle> fetchBundle(
    String serverUrl, {
    Map<String, dynamic>? preloadedManifest,
    Map<String, Set<int>>? breakpointsByFile,
    bool fetchAst = true,
    bool fetchBytecode = true,
    bool onlyAst = false,
    bool onlyBytecode = false,
    void Function(int downloaded, int total)? onProgress,
  }) async {
    final totalSw = Stopwatch()..start();
    final baseUrl = normalizeUrl(serverUrl);
    final manifestSw = Stopwatch()..start();
    final manifest = preloadedManifest ?? await fetchManifest(baseUrl) ?? {};
    final manifestMs = manifestSw.elapsedMilliseconds;

    final appName = manifest['appName']?.toString() ?? 'DartNative App';
    final appVersion = manifest['appVersion']?.toString();
    final hasSplash = manifest['hasSplash'] == true;
    final hasIcon = manifest['hasIcon'] == true;
    final splashUrl = hasSplash
        ? (manifest['splashUrl']?.toString() ?? '$baseUrl/assets/splash.png')
        : null;
    final iconUrl = hasIcon
        ? (manifest['iconUrl']?.toString() ?? '$baseUrl/assets/icon.png')
        : null;
    final splashBg = manifest['splashBackgroundColor']?.toString();

    final rawAssets = <String>[];
    if (manifest['assets'] is List) {
      rawAssets.addAll((manifest['assets'] as List).map((e) => e.toString()));
    }

    // 1. Fast Bytecode Mode Path (zero source downloading)
    if (onlyBytecode || (manifest['hasBytecodeBundle'] == true && onlyBytecode)) {
      final bcSw = Stopwatch()..start();
      final bcBytes = await fetchBytecodeBytes(baseUrl);
      final bcMs = bcSw.elapsedMilliseconds;
      if (bcBytes != null && bcBytes.isNotEmpty) {
        DartGoLogger.bench(
          'BundleLoader',
          'Bytecode fetchBundle',
          totalSw.elapsedMilliseconds,
          {
            'manifest': manifestMs,
            'bytecode_download': bcMs,
            'size': '${bcBytes.length}B',
          },
        );
        return ProjectBundle(
          appName: appName,
          appVersion: appVersion,
          splashUrl: splashUrl,
          iconUrl: iconUrl,
          splashBackgroundColor: splashBg,
          serverUrl: baseUrl,
          sources: const {},
          entrypointCode: '',
          entrypointLibrary: '',
          breakpoints: const [],
          assets: rawAssets,
          bytecodeBytes: bcBytes,
        );
      }
    }

    // 1b. Fast AST Mode Path (zero source downloading)
    if (onlyAst && (manifest['hasAstBundle'] == true || fetchAst)) {
      final astSw = Stopwatch()..start();
      final astBytes = await fetchAstBytes(baseUrl);
      final astMs = astSw.elapsedMilliseconds;
      if (astBytes != null && astBytes.isNotEmpty) {
        DartGoLogger.bench(
          'BundleLoader',
          'AST fetchBundle',
          totalSw.elapsedMilliseconds,
          {
            'manifest': manifestMs,
            'ast_download': astMs,
            'size': '${astBytes.length}B',
          },
        );
        return ProjectBundle(
          appName: appName,
          appVersion: appVersion,
          splashUrl: splashUrl,
          iconUrl: iconUrl,
          splashBackgroundColor: splashBg,
          serverUrl: baseUrl,
          sources: const {},
          entrypointCode: '',
          entrypointLibrary: '',
          breakpoints: const [],
          assets: rawAssets,
          astBytes: astBytes,
          astEntryPoint: manifest['astEntryPoint']?.toString(),
          bytecodeBytes: await fetchBytecodeBytes(baseUrl),
        );
      }
    }

    // 2. Smart Dependency Mode Path (Expo Go-style)
    if (manifest['depMode'] == true) {
      _depCache ??= await DepCache.create();
      final cache = _depCache!;
      final depsHash = manifest['depsHash']?.toString() ?? '';
      final cachedDepsHash = cache.loadDepsHash();

      List<DepEntry> deps = const [];
      if (depsHash.isNotEmpty && depsHash != cachedDepsHash) {
        deps = await fetchDepsList(baseUrl);
        final needed = deps
            .where((d) => !cache.hasPackage(d.name, d.version))
            .toList();
        int downloaded = 0;
        final total = needed.length;
        if (total > 0) {
          onProgress?.call(0, total);
          final pool = <Future>[];
          for (final dep in needed) {
            pool.add(
              _fetchAndCachePackage(dep.zipUrl, dep.name, dep.version, cache)
                  .then((_) {
                downloaded++;
                onProgress?.call(downloaded, total);
              }),
            );
          }
          await Future.wait(pool);
        }
        await cache.saveDepsHash(depsHash);
        await cache.prune(deps);
      } else {
        deps = await fetchDepsList(baseUrl);
      }

      // Fetch user code ZIP only (always fast, < 10 KB)
      final userSw = Stopwatch()..start();
      final userSources = await fetchUserCode(baseUrl);
      final userMs = userSw.elapsedMilliseconds;

      final depLoadSw = Stopwatch()..start();
      if (_cachedDepSources == null || _loadedDepsHash != depsHash) {
        _cachedDepSources = cache.loadAllSources(deps);
        _loadedDepsHash = depsHash;
      }
      final depSources = _cachedDepSources!;
      final depLoadMs = depLoadSw.elapsedMilliseconds;

      final rawFiles = <String, String>{
        ...depSources,
        ...userSources,
      };

      final packageName = manifest['packageName']?.toString() ??
          manifest['appName']?.toString() ??
          'guest_app';

      final vmapSw = Stopwatch()..start();
      final virtualSources = AutoImportParser.buildVirtualSourceMap(
        rawFiles,
        packageName: packageName,
        breakpointsByFile: breakpointsByFile,
      );
      final vmapMs = vmapSw.elapsedMilliseconds;

      String entrypointLibrary = 'package:$packageName/main.dart';
      String entrypointCode = '';

      if (virtualSources.containsKey('package:$packageName/main.dart')) {
        entrypointLibrary = 'package:$packageName/main.dart';
        entrypointCode = virtualSources['package:$packageName/main.dart']!;
      } else if (virtualSources.containsKey('package:guest_app/main.dart')) {
        entrypointLibrary = 'package:guest_app/main.dart';
        entrypointCode = virtualSources['package:guest_app/main.dart']!;
      } else if (virtualSources.containsKey('main.dart')) {
        entrypointLibrary = 'main.dart';
        entrypointCode = virtualSources['main.dart']!;
      } else if (virtualSources.isNotEmpty) {
        entrypointLibrary = virtualSources.keys.first;
        entrypointCode = virtualSources.values.first;
      }

      DartGoLogger.bench(
        'BundleLoader',
        'Source fetchBundle',
        totalSw.elapsedMilliseconds,
        {
          'manifest': manifestMs,
          'user_zip': userMs,
          'dep_cache': depLoadMs,
          'vmap': vmapMs,
        },
      );

      return ProjectBundle(
        appName: appName,
        appVersion: appVersion,
        splashUrl: splashUrl,
        iconUrl: iconUrl,
        splashBackgroundColor: splashBg,
        serverUrl: baseUrl,
        sources: virtualSources,
        entrypointCode: entrypointCode,
        entrypointLibrary: entrypointLibrary,
        breakpoints: const [],
        assets: rawAssets,
        astBytes: fetchAst ? await fetchAstBytes(baseUrl) : null,
        astEntryPoint: manifest['astEntryPoint']?.toString(),
        bytecodeBytes: fetchBytecode ? await fetchBytecodeBytes(baseUrl) : null,
      );
    }

    // 3. Fallback to /bundle.json
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/bundle.json'));
      final res = await req.close();

      if (res.statusCode == HttpStatus.ok) {
        final body = await res.transform(utf8.decoder).join();
        final rawMap = jsonDecode(body) as Map<String, dynamic>;

        final rawFiles = <String, String>{};
        final breakpoints = <Map<String, dynamic>>[];

        if (rawMap.containsKey('assets') && rawMap['assets'] is List) {
          for (final a in rawMap['assets'] as List) {
            final str = a.toString();
            if (!rawAssets.contains(str)) rawAssets.add(str);
          }
        }

        if (rawMap.containsKey('files') && rawMap['files'] is Map) {
          (rawMap['files'] as Map).forEach((k, v) {
            rawFiles[k.toString()] = v.toString();
          });
          if (rawMap['breakpoints'] is List) {
            breakpoints.addAll(
              (rawMap['breakpoints'] as List).cast<Map<String, dynamic>>(),
            );
          }
        } else {
          rawMap.forEach((k, v) {
            if (k != 'manifest' && k != 'breakpoints' && k != 'assets') {
              rawFiles[k.toString()] = v.toString();
            }
          });
        }

        final packageName = manifest['packageName']?.toString() ??
            manifest['appName']?.toString() ??
            'guest_app';

        final virtualSources = AutoImportParser.buildVirtualSourceMap(
          rawFiles,
          packageName: packageName,
          breakpointsByFile: breakpointsByFile,
        );

        String entrypointLibrary = 'package:$packageName/main.dart';
        String entrypointCode = '';

        if (virtualSources.containsKey('package:$packageName/main.dart')) {
          entrypointLibrary = 'package:$packageName/main.dart';
          entrypointCode = virtualSources['package:$packageName/main.dart']!;
        } else if (virtualSources.containsKey('package:guest_app/main.dart')) {
          entrypointLibrary = 'package:guest_app/main.dart';
          entrypointCode = virtualSources['package:guest_app/main.dart']!;
        } else if (virtualSources.containsKey('main.dart')) {
          entrypointLibrary = 'main.dart';
          entrypointCode = virtualSources['main.dart']!;
        } else if (virtualSources.isNotEmpty) {
          entrypointLibrary = virtualSources.keys.first;
          entrypointCode = virtualSources.values.first;
        }

        return ProjectBundle(
          appName: appName,
          appVersion: appVersion,
          splashUrl: splashUrl,
          iconUrl: iconUrl,
          splashBackgroundColor: splashBg,
          serverUrl: baseUrl,
          sources: virtualSources,
          entrypointCode: entrypointCode,
          entrypointLibrary: entrypointLibrary,
          breakpoints: breakpoints,
          assets: rawAssets,
          astBytes: fetchAst ? await fetchAstBytes(baseUrl) : null,
          astEntryPoint: manifest['astEntryPoint']?.toString(),
          bytecodeBytes: fetchBytecode ? await fetchBytecodeBytes(baseUrl) : null,
        );
      }
    } catch (_) {}

    // 4. Fallback to /app.dart
    final req = await _client.getUrl(Uri.parse('$baseUrl/app.dart'));
    final res = await req.close();
    if (res.statusCode != HttpStatus.ok) {
      throw HttpException('Server returned HTTP ${res.statusCode}');
    }

    final code = await res.transform(utf8.decoder).join();
    final rawFiles = {'main.dart': code};
    final virtualSources = AutoImportParser.buildVirtualSourceMap(
      rawFiles,
      breakpointsByFile: breakpointsByFile,
    );

    return ProjectBundle(
      appName: appName,
      appVersion: appVersion,
      splashUrl: splashUrl,
      iconUrl: iconUrl,
      splashBackgroundColor: splashBg,
      serverUrl: baseUrl,
      sources: virtualSources,
      entrypointCode: virtualSources['main.dart'] ?? code,
      entrypointLibrary: 'main.dart',
      astBytes: fetchAst ? await fetchAstBytes(baseUrl) : null,
      bytecodeBytes: fetchBytecode ? await fetchBytecodeBytes(baseUrl) : null,
    );
  }

  void close() {
    _client.close(force: true);
  }
}

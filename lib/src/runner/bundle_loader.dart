import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';

import '../cli/packaging/dep_packager.dart';
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

  /// Per-module content fingerprints for [astBytes] (module URI → FNV-1a hex),
  /// as reported by the dev server manifest. Empty when the server predates
  /// per-module fingerprints. Used to detect which modules changed on reload
  /// without re-hashing the whole bundle on device.
  final Map<String, String> astModuleFingerprints;

  /// Incremental delta patch bytes (from `GET /guest.ast.patch`).
  /// When present, this bundle represents a lightweight delta containing
  /// only the modified modules.
  final List<int>? astPatchBytes;

  /// Whether this bundle is an incremental patch.
  final bool isPatch;

  /// Whether an AST bundle or patch is available for opt-in testing.
  bool get hasAst =>
      (astBytes != null && astBytes!.isNotEmpty) ||
      (astPatchBytes != null && astPatchBytes!.isNotEmpty);

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
    this.astPatchBytes,
    this.isPatch = false,
    this.astEntryPoint,
    this.astModuleFingerprints = const {},
  });
}

/// Service to fetch and parse project manifests and bundles from the dev server.
class BundleLoader {
  final HttpClient _client;
  DepCache? _depCache;
  Map<String, String>? _cachedDepSources;
  String? _loadedDepsHash;

  // NOTE: no `this._depCache` formal here: private named parameters need
  // language version 3.12, but the device toolchain pins this package to
  // 3.9 (see .dart_tool/package_config.json as written by `dn pub get`).
  BundleLoader({HttpClient? client, DepCache? depCache})
    : _client =
          client ??
          (HttpClient()..connectionTimeout = const Duration(seconds: 10)),
      _depCache = depCache;

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

  /// Reads `astModuleFingerprints` from a manifest, tolerating older servers
  /// (and malformed payloads) by returning an empty map.
  static Map<String, String> _moduleFingerprintsFrom(
    Map<String, dynamic>? manifest,
  ) {
    final raw = manifest?['astModuleFingerprints'];
    if (raw is! Map) return const {};
    final out = <String, String>{};
    raw.forEach((k, v) => out[k.toString()] = v.toString());
    return out;
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

  final Map<String, ({String etag, List<int> bytes})> _astCache = {};

  /// Clears in-memory AST bundle cache (e.g. for testing or fresh cold start).
  void clearAstCache() {
    _astCache.clear();
  }

  /// Best-effort fetch of pre-compiled `AstBundle` bytes from `/guest.ast`.
  ///
  /// Supports HTTP ETag / 304 Not Modified to avoid re-downloading unchanged
  /// bundles over the network.
  /// Returns null (not an error) when the server has no bundle yet — source
  /// mode keeps working. Never throws.
  Future<List<int>?> fetchAstBytes(String serverUrl) async {
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/guest.ast'));
      final cached = _astCache[baseUrl];
      if (cached != null) {
        req.headers.set(HttpHeaders.ifNoneMatchHeader, cached.etag);
      }
      final res = await req.close();
      if (res.statusCode == HttpStatus.notModified && cached != null) {
        return cached.bytes;
      }
      if (res.statusCode != HttpStatus.ok) return null;
      final etag = res.headers.value(HttpHeaders.etagHeader);
      final bytes = await res.fold<List<int>>(
        <int>[],
        (prev, el) => prev..addAll(el),
      );
      if (bytes.isEmpty) return null;
      if (etag != null && etag.isNotEmpty) {
        _astCache[baseUrl] = (etag: etag, bytes: bytes);
      }
      return bytes;
    } catch (_) {
      return null;
    }
  }

  /// Best-effort fetch of incremental `AstBundle` delta patch bytes from `/guest.ast.patch`.
  /// Returns null when no patch is active (e.g. 404), falling back to full bundle fetch.
  Future<List<int>?> fetchAstPatchBytes(String serverUrl) async {
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/guest.ast.patch'));
      final res = await req.close();
      if (res.statusCode != HttpStatus.ok) return null;
      final bytes = await res.fold<List<int>>(
        <int>[],
        (prev, el) => prev..addAll(el),
      );
      return bytes.isNotEmpty ? bytes : null;
    } catch (_) {
      return null;
    }
  }

  /// Best-effort fetch of one server-component delta bundle from
  /// `/server-components/<componentId>.ast`.
  ///
  /// The id is strictly validated (`[A-Za-z0-9_-]+`, mirroring the server)
  /// so a bad id returns null instead of throwing. Returns null when the
  /// server has no such component (404) or the fetch fails. Never throws.
  /// Pair with `AstInterpreterRunner.loadServerComponent`, which must run on
  /// the SAME runner instance that evaluated the client bundle:
  ///
  /// ```dart
  /// final bytes = await bundleLoader.fetchServerComponentBytes(
  ///   serverUrl, 'profile_card');
  /// final cls = bytes == null ? null : await runner.loadServerComponent(
  ///   componentId: 'profile_card', astBytes: bytes);
  /// ```
  Future<List<int>?> fetchServerComponentBytes(
    String serverUrl,
    String componentId,
  ) async {
    if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(componentId)) return null;
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(
        Uri.parse('$baseUrl/server-components/$componentId.ast'),
      );
      final res = await req.close();
      if (res.statusCode != HttpStatus.ok) return null;
      final bytes = await res.fold<List<int>>(
        <int>[],
        (prev, el) => prev..addAll(el),
      );
      return bytes.isNotEmpty ? bytes : null;
    } catch (_) {
      return null;
    }
  }

  /// Best-effort fetch of the component manifest from
  /// `/server-components/manifest.json` (id → url + fingerprint).
  /// Returns an empty map when the app has no server components. Never throws.
  Future<Map<String, Map<String, String>>> fetchServerComponentsManifest(
    String serverUrl,
  ) async {
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(
        Uri.parse('$baseUrl/server-components/manifest.json'),
      );
      final res = await req.close();
      if (res.statusCode != HttpStatus.ok) return const {};
      final body = await res.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (decoded is! Map) return const {};
      final components = decoded['components'];
      if (components is! Map) return const {};
      final out = <String, Map<String, String>>{};
      components.forEach((k, v) {
        if (v is Map) {
          out[k.toString()] = {
            'url': '${v['url']}',
            'fingerprint': '${v['fingerprint']}',
          };
        }
      });
      return out;
    } catch (_) {
      return const {};
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
    bool onlyAst = false,
    bool isHotReload = false,
    bool hasAssetChanges = false,
    void Function(int downloaded, int total)? onProgress,
  }) async {
    final totalSw = Stopwatch()..start();
    final baseUrl = normalizeUrl(serverUrl);

    // Fast AST Hot-Reload Path:
    // When performing an AST hot reload with NO asset changes, skip fetching
    // /manifest.json entirely and download /guest.ast.patch directly (< 5 KB, ~15ms).
    // If the patch succeeds, return immediately without touching /manifest.json.
    // If the patch returns null (404/not available), gracefully fall back to full
    // manifest + bundle download.
    if (onlyAst && isHotReload && !hasAssetChanges) {
      final patchSw = Stopwatch()..start();
      final patchBytes = await fetchAstPatchBytes(baseUrl);
      final patchMs = patchSw.elapsedMilliseconds;
      if (patchBytes != null && patchBytes.isNotEmpty) {
        DartGoLogger.bench(
          'BundleLoader',
          'AST fetchPatch',
          totalSw.elapsedMilliseconds,
          {
            'manifest': 0,
            'download': patchMs,
            'size': '${patchBytes.length}B',
            'is_patch': true,
          },
        );
        return ProjectBundle(
          appName: 'DartNative App',
          serverUrl: baseUrl,
          sources: const {},
          entrypointCode: '',
          entrypointLibrary: '',
          breakpoints: const [],
          assets: const [],
          astBytes: null,
          astPatchBytes: patchBytes,
          isPatch: true,
          astEntryPoint: null,
          astModuleFingerprints: const {},
        );
      }
    }

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

    // 1b. Fast AST Mode Path (zero source downloading)
    if (onlyAst && (manifest['hasAstBundle'] == true || fetchAst)) {
      final astSw = Stopwatch()..start();
      final astBytes = await fetchAstBytes(baseUrl);
      final astMs = astSw.elapsedMilliseconds;
      if (astBytes != null && astBytes.isNotEmpty) {
        final moduleFingerprints = _moduleFingerprintsFrom(manifest);
        DartGoLogger.bench(
          'BundleLoader',
          'AST fetchBundle',
          totalSw.elapsedMilliseconds,
          {
            'manifest': manifestMs,
            'download': astMs,
            'size': '${astBytes.length}B',
            'is_patch': false,
            'module_fps': moduleFingerprints.length,
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
          isPatch: false,
          astEntryPoint: manifest['astEntryPoint']?.toString(),
          astModuleFingerprints: moduleFingerprints,
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
              _fetchAndCachePackage(
                dep.zipUrl,
                dep.name,
                dep.version,
                cache,
              ).then((_) {
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

      final packageName =
          manifest['packageName']?.toString() ??
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
        astModuleFingerprints: _moduleFingerprintsFrom(manifest),
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

        final packageName =
            manifest['packageName']?.toString() ??
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
          astModuleFingerprints: _moduleFingerprintsFrom(manifest),
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
    );
  }

  void close() {
    _client.close(force: true);
  }
}

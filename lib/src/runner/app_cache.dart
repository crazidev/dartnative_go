import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'bundle_loader.dart';
import 'logger.dart';

/// On-device persistent cache for guest application bundles (enables offline mode).
class AppCache {
  final Directory cacheDir;
  Future<void> _metaQueue = Future<void>.value();

  AppCache(this.cacheDir);

  Future<T> _withMetaLock<T>(Future<T> Function() fn) {
    final next = _metaQueue.then((_) => fn());
    _metaQueue = next.then((_) {}, onError: (_) {});
    return next;
  }

  /// Creates or returns the on-device application cache root.
  static Future<AppCache> create([Directory? baseDir]) async {
    final root =
        baseDir ?? Directory('${Directory.systemTemp.path}/dn_app_cache');
    if (!root.existsSync()) {
      root.createSync(recursive: true);
    }
    return AppCache(root);
  }

  /// Generates a filesystem-safe directory name for a given server URL.
  static String urlToKey(String serverUrl) {
    final normalized = BundleLoader.normalizeUrl(serverUrl);
    final sanitized = normalized
        .replaceAll(RegExp(r'^https?:\/\/'), '')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    final hash = normalized.codeUnits
        .fold<int>(5381, (h, c) => ((h << 5) + h) + c)
        .toRadixString(16);
    return '${sanitized}_$hash';
  }

  Directory _dirForUrl(String serverUrl) {
    final key = urlToKey(serverUrl);
    return Directory(p.join(cacheDir.path, key));
  }

  /// Saves a complete [ProjectBundle] to disk for offline execution.
  /// Incremental patches are ignored to avoid corrupting the full base bundle.
  Future<void> saveBundle(ProjectBundle bundle) async {
    if (bundle.isPatch) return;
    try {
      final dir = _dirForUrl(bundle.serverUrl);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final metaFile = File(p.join(dir.path, 'meta.json'));
      final meta = {
        'appName': bundle.appName,
        'appVersion': bundle.appVersion,
        'splashUrl': bundle.splashUrl,
        'iconUrl': bundle.iconUrl,
        'splashBackgroundColor': bundle.splashBackgroundColor,
        'splashBackgroundColorDark': bundle.splashBackgroundColorDark,
        'serverUrl': bundle.serverUrl,
        'entrypointLibrary': bundle.entrypointLibrary,
        'entrypointCode': bundle.entrypointCode,
        'breakpoints': bundle.breakpoints,
        'assets': bundle.assets,
        'assetEtags': bundle.assetEtags,
        'astEntryPoint': bundle.astEntryPoint,
        'astModuleFingerprints': bundle.astModuleFingerprints,
        'hasAst': bundle.hasAst,
        'savedAt': DateTime.now().toIso8601String(),
      };
      await metaFile.writeAsString(jsonEncode(meta));

      // Sources (for source mode)
      final sourcesFile = File(p.join(dir.path, 'sources.json'));
      if (bundle.sources.isNotEmpty) {
        await sourcesFile.writeAsString(jsonEncode(bundle.sources));
      }

      // AST bytes (for AST mode)
      final astFile = File(p.join(dir.path, 'guest.ast'));
      if (bundle.astBytes != null && bundle.astBytes!.isNotEmpty) {
        await astFile.writeAsBytes(bundle.astBytes!);
      }

      DartGoLogger.info(
        'AppCache: cached bundle for "${bundle.appName}" (${bundle.serverUrl})',
      );
    } catch (e) {
      DartGoLogger.warn('AppCache: failed to save bundle: $e');
    }
  }

  /// Loads a cached [ProjectBundle] for the given [serverUrl] if available.
  Future<ProjectBundle?> loadBundle(String serverUrl) async {
    try {
      final dir = _dirForUrl(serverUrl);
      if (!dir.existsSync()) return null;

      final metaFile = File(p.join(dir.path, 'meta.json'));
      if (!metaFile.existsSync()) return null;

      final metaJson = jsonDecode(await metaFile.readAsString());
      if (metaJson is! Map<String, dynamic>) return null;

      Map<String, String> sources = const {};
      final sourcesFile = File(p.join(dir.path, 'sources.json'));
      if (sourcesFile.existsSync()) {
        final decodedSources = jsonDecode(await sourcesFile.readAsString());
        if (decodedSources is Map) {
          sources = decodedSources.map(
            (k, v) => MapEntry(k.toString(), v.toString()),
          );
        }
      }

      List<int>? astBytes;
      final astFile = File(p.join(dir.path, 'guest.ast'));
      if (astFile.existsSync()) {
        astBytes = await astFile.readAsBytes();
      }

      final rawBreakpoints = metaJson['breakpoints'];
      final breakpoints = <Map<String, dynamic>>[];
      if (rawBreakpoints is List) {
        for (final bp in rawBreakpoints) {
          if (bp is Map) breakpoints.add(Map<String, dynamic>.from(bp));
        }
      }

      final rawAssets = metaJson['assets'];
      final assets = <String>[];
      if (rawAssets is List) {
        for (final a in rawAssets) {
          if (a != null) assets.add(a.toString());
        }
      }

      final rawModuleFps = metaJson['astModuleFingerprints'];
      final astModuleFingerprints = <String, String>{};
      if (rawModuleFps is Map) {
        rawModuleFps.forEach(
          (k, v) => astModuleFingerprints[k.toString()] = v.toString(),
        );
      }

      final rawAssetEtags = metaJson['assetEtags'];
      final assetEtags = <String, String>{};
      if (rawAssetEtags is Map) {
        rawAssetEtags.forEach(
          (k, v) => assetEtags[k.toString()] = v.toString(),
        );
      }

      return ProjectBundle(
        appName: metaJson['appName']?.toString() ?? 'DartNative App',
        appVersion: metaJson['appVersion']?.toString(),
        splashUrl: metaJson['splashUrl']?.toString(),
        iconUrl: metaJson['iconUrl']?.toString(),
        splashBackgroundColor: metaJson['splashBackgroundColor']?.toString(),
        splashBackgroundColorDark: metaJson['splashBackgroundColorDark']
            ?.toString(),
        serverUrl:
            metaJson['serverUrl']?.toString() ??
            BundleLoader.normalizeUrl(serverUrl),
        sources: sources,
        entrypointCode: metaJson['entrypointCode']?.toString() ?? '',
        entrypointLibrary:
            metaJson['entrypointLibrary']?.toString() ?? 'main.dart',
        breakpoints: breakpoints,
        assets: assets,
        assetEtags: assetEtags,
        astBytes: astBytes,
        isPatch: false,
        astEntryPoint: metaJson['astEntryPoint']?.toString(),
        astModuleFingerprints: astModuleFingerprints,
      );
    } catch (e) {
      DartGoLogger.warn('AppCache: failed to load cached bundle: $e');
      return null;
    }
  }

  /// Whether a cached bundle exists for the given [serverUrl].
  bool hasBundle(String serverUrl) {
    final dir = _dirForUrl(serverUrl);
    if (!dir.existsSync()) return false;
    final metaFile = File(p.join(dir.path, 'meta.json'));
    return metaFile.existsSync();
  }

  /// Removes cached bundle for a specific [serverUrl].
  Future<void> removeBundle(String serverUrl) async {
    try {
      final dir = _dirForUrl(serverUrl);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    } catch (_) {}
  }

  /// Clears all cached application bundles.
  Future<void> clearAll() async {
    try {
      if (cacheDir.existsSync()) {
        for (final entity in cacheDir.listSync()) {
          try {
            entity.deleteSync(recursive: true);
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  /// Computes the total byte size of cached application bundles.
  int getCacheSizeBytes() {
    if (!cacheDir.existsSync()) return 0;
    int total = 0;
    try {
      for (final entity in cacheDir.listSync(recursive: true)) {
        if (entity is File) {
          total += entity.lengthSync();
        }
      }
    } catch (_) {}
    return total;
  }

  /// Formatted human-readable cache size.
  String getFormattedCacheSize() {
    final bytes = getCacheSizeBytes();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  /// Returns the number of cached application bundles.
  int getCachedBundleCount() {
    if (!cacheDir.existsSync()) return 0;
    int count = 0;
    try {
      for (final entity in cacheDir.listSync()) {
        if (entity is Directory) {
          final meta = File(p.join(entity.path, 'meta.json'));
          if (meta.existsSync()) count++;
        }
      }
    } catch (_) {}
    return count;
  }

  // ---------------------------------------------------------------------------
  // Font & Asset Disk Caching + Reinvalidation
  // ---------------------------------------------------------------------------

  static String _normalizeAssetPath(String assetPath) {
    var clean = assetPath.trim().replaceAll(r'\', '/');
    while (clean.startsWith('/')) {
      clean = clean.substring(1);
    }
    if (!clean.startsWith('assets/')) {
      clean = 'assets/$clean';
    }
    return clean;
  }

  static String _safeFontFileName(String family, String ext) {
    final sanitized = family.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    final suffix = ext.startsWith('.') ? ext : '.$ext';
    return '$sanitized$suffix';
  }

  Map<String, dynamic> _readJsonMap(File file) {
    if (!file.existsSync()) return {};
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return {};
  }

  /// Returns the cached font [File] for [family] if present on disk and
  /// (when [expectedEtag] is provided) its stored ETag matches.
  File? getCachedFontFile(
    String serverUrl,
    String family, {
    String? expectedEtag,
  }) {
    final dir = _dirForUrl(serverUrl);
    final meta = _readJsonMap(File(p.join(dir.path, 'fonts_meta.json')));
    final entry = meta[family.trim()];
    if (entry is! Map) return null;
    if (expectedEtag != null &&
        expectedEtag.isNotEmpty &&
        entry['etag']?.toString() != expectedEtag) {
      return null;
    }
    final fileName = entry['fileName']?.toString();
    if (fileName == null || fileName.isEmpty) return null;
    final file = File(p.join(dir.path, 'fonts', fileName));
    return file.existsSync() ? file : null;
  }

  /// Stored ETag for cached [family] (for `If-None-Match` revalidation).
  String? getCachedFontEtag(String serverUrl, String family) {
    final dir = _dirForUrl(serverUrl);
    final meta = _readJsonMap(File(p.join(dir.path, 'fonts_meta.json')));
    final entry = meta[family.trim()];
    if (entry is! Map) return null;
    return entry['etag']?.toString();
  }

  /// Persists downloaded font [bytes] for [family] under the server's cache
  /// directory along with its [etag]. Returns the saved [File].
  Future<File?> saveFont(
    String serverUrl,
    String family,
    List<int> bytes, {
    String? etag,
    String ext = '.ttf',
  }) async {
    try {
      final dir = _dirForUrl(serverUrl);
      final fontsDir = Directory(p.join(dir.path, 'fonts'));
      if (!fontsDir.existsSync()) fontsDir.createSync(recursive: true);

      final fileName = _safeFontFileName(family, ext);
      final file = File(p.join(fontsDir.path, fileName));
      await file.writeAsBytes(bytes, flush: true);

      await _withMetaLock(() async {
        final metaFile = File(p.join(dir.path, 'fonts_meta.json'));
        final meta = _readJsonMap(metaFile);
        meta[family.trim()] = {
          'fileName': fileName,
          if (etag != null && etag.isNotEmpty) 'etag': etag,
          'size': bytes.length,
          'savedAt': DateTime.now().toIso8601String(),
        };
        await metaFile.writeAsString(jsonEncode(meta));
      });
      return file;
    } catch (e) {
      DartGoLogger.warn('AppCache: failed to save font "$family": $e');
      return null;
    }
  }

  /// Invalidates and removes cached font [family] from disk.
  Future<void> invalidateFont(String serverUrl, String family) async {
    try {
      final dir = _dirForUrl(serverUrl);
      final metaFile = File(p.join(dir.path, 'fonts_meta.json'));
      final meta = _readJsonMap(metaFile);
      final entry = meta.remove(family.trim());
      if (entry is Map) {
        final fileName = entry['fileName']?.toString();
        if (fileName != null) {
          final f = File(p.join(dir.path, 'fonts', fileName));
          if (f.existsSync()) f.deleteSync();
        }
      }
      await metaFile.writeAsString(jsonEncode(meta));
    } catch (_) {}
  }

  /// Returns a cached asset [File] for [assetPath] if present on disk.
  File? getCachedAssetFile(String serverUrl, String assetPath) {
    final norm = _normalizeAssetPath(assetPath);
    if (norm.contains('..')) return null;
    final dir = _dirForUrl(serverUrl);
    final file = File(p.join(dir.path, norm));
    return file.existsSync() ? file : null;
  }

  /// Stored ETag for a cached asset (for `If-None-Match` revalidation).
  String? getCachedAssetEtag(String serverUrl, String assetPath) {
    final norm = _normalizeAssetPath(assetPath);
    final dir = _dirForUrl(serverUrl);
    final meta = _readJsonMap(File(p.join(dir.path, 'assets_meta.json')));
    final entry = meta[norm];
    if (entry is! Map) return null;
    return entry['etag']?.toString();
  }

  /// Persists downloaded asset [bytes] for [assetPath] along with its [etag].
  Future<File?> saveAsset(
    String serverUrl,
    String assetPath,
    List<int> bytes, {
    String? etag,
  }) async {
    try {
      final norm = _normalizeAssetPath(assetPath);
      if (norm.contains('..')) return null;
      final dir = _dirForUrl(serverUrl);
      final file = File(p.join(dir.path, norm));
      if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
      await file.writeAsBytes(bytes, flush: true);

      await _withMetaLock(() async {
        final metaFile = File(p.join(dir.path, 'assets_meta.json'));
        final meta = _readJsonMap(metaFile);
        meta[norm] = {
          if (etag != null && etag.isNotEmpty) 'etag': etag,
          'size': bytes.length,
          'savedAt': DateTime.now().toIso8601String(),
        };
        await metaFile.writeAsString(jsonEncode(meta));
      });
      return file;
    } catch (e) {
      DartGoLogger.warn('AppCache: failed to save asset "$assetPath": $e');
      return null;
    }
  }

  /// Compares cached assets against [serverEtags] (`path -> etag`). Any
  /// cached asset whose ETag changed or that was removed on the server is
  /// deleted from disk and returned so callers can evict in-memory caches.
  Future<List<String>> invalidateStaleAssets(
    String serverUrl,
    Map<String, String> serverEtags,
  ) async {
    final invalidated = <String>[];
    try {
      final dir = _dirForUrl(serverUrl);
      final metaFile = File(p.join(dir.path, 'assets_meta.json'));
      final meta = _readJsonMap(metaFile);
      if (meta.isEmpty) return invalidated;

      final keysToRemove = <String>[];
      for (final entry in meta.entries) {
        final path = entry.key;
        final cachedEtag = (entry.value is Map)
            ? (entry.value as Map)['etag']?.toString()
            : null;
        final serverEtag = serverEtags[path];
        if (serverEtag == null ||
            (cachedEtag != null && cachedEtag != serverEtag)) {
          keysToRemove.add(path);
          invalidated.add(path);
          final file = File(p.join(dir.path, path));
          if (file.existsSync()) {
            try {
              file.deleteSync();
            } catch (_) {}
          }
        }
      }
      if (keysToRemove.isNotEmpty) {
        for (final k in keysToRemove) {
          meta.remove(k);
        }
        await metaFile.writeAsString(jsonEncode(meta));
      }
    } catch (_) {}
    return invalidated;
  }
}

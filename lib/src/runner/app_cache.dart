import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'bundle_loader.dart';
import 'logger.dart';

/// On-device persistent cache for guest application bundles (enables offline mode).
class AppCache {
  final Directory cacheDir;

  AppCache(this.cacheDir);

  /// Creates or returns the on-device application cache root.
  static Future<AppCache> create([Directory? baseDir]) async {
    final root = baseDir ??
        Directory('${Directory.systemTemp.path}/dn_app_cache');
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
        'serverUrl': bundle.serverUrl,
        'entrypointLibrary': bundle.entrypointLibrary,
        'entrypointCode': bundle.entrypointCode,
        'breakpoints': bundle.breakpoints,
        'assets': bundle.assets,
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

      return ProjectBundle(
        appName: metaJson['appName']?.toString() ?? 'DartNative App',
        appVersion: metaJson['appVersion']?.toString(),
        splashUrl: metaJson['splashUrl']?.toString(),
        iconUrl: metaJson['iconUrl']?.toString(),
        splashBackgroundColor: metaJson['splashBackgroundColor']?.toString(),
        serverUrl: metaJson['serverUrl']?.toString() ??
            BundleLoader.normalizeUrl(serverUrl),
        sources: sources,
        entrypointCode: metaJson['entrypointCode']?.toString() ?? '',
        entrypointLibrary:
            metaJson['entrypointLibrary']?.toString() ?? 'main.dart',
        breakpoints: breakpoints,
        assets: assets,
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
}

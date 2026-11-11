import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'dep_entry.dart';

/// On-device persistent cache for third-party dependency packages (Expo Go-style).
class DepCache {
  final Directory cacheDir;
  final File metaFile;
  String? _cachedDepsHash;

  DepCache(this.cacheDir) : metaFile = File('${cacheDir.path}/deps_meta.json') {
    _init();
  }

  static Future<DepCache> create([Directory? baseDir]) async {
    final root =
        baseDir ?? Directory('${Directory.systemTemp.path}/dn_dep_cache');
    if (!root.existsSync()) {
      root.createSync(recursive: true);
    }
    return DepCache(root);
  }

  void _init() {
    try {
      if (metaFile.existsSync()) {
        final json = jsonDecode(metaFile.readAsStringSync());
        if (json is Map<String, dynamic>) {
          _cachedDepsHash = json['depsHash'] as String?;
        }
      }
    } catch (_) {}
  }

  String? loadDepsHash() => _cachedDepsHash;

  Future<void> saveDepsHash(String hash) async {
    _cachedDepsHash = hash;
    try {
      if (!cacheDir.existsSync()) cacheDir.createSync(recursive: true);
      await metaFile.writeAsString(jsonEncode({'depsHash': hash}));
    } catch (_) {}
  }

  bool hasPackage(String name, String version) {
    final pkgDir = Directory('${cacheDir.path}/$name@$version');
    return pkgDir.existsSync();
  }

  /// Extracts ZIP bytes and stores package files under `<cacheDir>/<name>@<version>/`
  Future<void> storePackageZip(
    String name,
    String version,
    List<int> zipBytes,
  ) async {
    final pkgDir = Directory('${cacheDir.path}/$name@$version');
    if (pkgDir.existsSync()) {
      try {
        pkgDir.deleteSync(recursive: true);
      } catch (_) {}
    }
    pkgDir.createSync(recursive: true);

    final archive = ZipDecoder().decodeBytes(zipBytes);
    for (final file in archive) {
      if (file.isFile) {
        final outPath = p.join(pkgDir.path, file.name);
        final outFile = File(outPath);
        outFile.parent.createSync(recursive: true);
        outFile.writeAsBytesSync(file.content as List<int>);
      }
    }
  }

  /// Loads all cached pure Dart sources for the given active dependency list.
  /// Returns map of "package:$name/$relPath" -> file content.
  Map<String, String> loadAllSources(List<DepEntry> deps) {
    final result = <String, String>{};
    for (final dep in deps) {
      final pkgDir = Directory('${cacheDir.path}/${dep.name}@${dep.version}');
      if (pkgDir.existsSync()) {
        for (final entity in pkgDir.listSync(recursive: true)) {
          if (entity is File && entity.path.endsWith('.dart')) {
            final rel = p
                .relative(entity.path, from: pkgDir.path)
                .replaceAll(r'\', '/');
            try {
              result['package:${dep.name}/$rel'] = entity.readAsStringSync();
            } catch (_) {}
          }
        }
      }
    }
    return result;
  }

  /// Prunes cached packages that are not present in [activeDeps].
  Future<void> prune(List<DepEntry> activeDeps) async {
    final activeKeys = activeDeps.map((d) => '${d.name}@${d.version}').toSet();
    if (!cacheDir.existsSync()) return;
    for (final entity in cacheDir.listSync()) {
      if (entity is Directory) {
        final folderName = p.basename(entity.path);
        if (!activeKeys.contains(folderName)) {
          try {
            entity.deleteSync(recursive: true);
          } catch (_) {}
        }
      }
    }
  }

  /// Computes the total byte size of cached dependency files.
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

  /// Formatted human readable cache size (e.g. "1.2 MB" or "350 KB").
  String getFormattedCacheSize() {
    final bytes = getCacheSizeBytes();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  /// Returns the number of cached packages.
  int getCachedPackageCount() {
    if (!cacheDir.existsSync()) return 0;
    int count = 0;
    try {
      for (final entity in cacheDir.listSync()) {
        if (entity is Directory && p.basename(entity.path).contains('@')) {
          count++;
        }
      }
    } catch (_) {}
    return count;
  }

  /// Clears all cached package files and resets depsHash.
  Future<void> clearCache() async {
    _cachedDepsHash = null;
    if (cacheDir.existsSync()) {
      try {
        for (final entity in cacheDir.listSync()) {
          entity.deleteSync(recursive: true);
        }
      } catch (_) {}
    }
  }
}

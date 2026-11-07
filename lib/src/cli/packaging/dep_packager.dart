import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'ast_builder.dart';

/// Metadata entry for a single pure-Dart dependency package.
class DepEntry {
  final String name;
  final String version;
  final String zipUrl;
  final String contentHash;
  final int byteSize;

  const DepEntry({
    required this.name,
    required this.version,
    required this.zipUrl,
    required this.contentHash,
    required this.byteSize,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'version': version,
    'zipUrl': zipUrl,
    'contentHash': contentHash,
    'byteSize': byteSize,
  };

  factory DepEntry.fromJson(Map<String, dynamic> json) => DepEntry(
    name: json['name'] as String,
    version: json['version'] as String? ?? '1.0.0',
    zipUrl: json['zipUrl'] as String,
    contentHash: json['contentHash'] as String,
    byteSize: json['byteSize'] as int? ?? 0,
  );
}

/// Result of resolving dependencies and building package ZIP archives.
class DepPackagerResult {
  final String depsHash;
  final List<DepEntry> deps;
  final Map<String, List<int>> packageZips; // name@version -> zip bytes

  const DepPackagerResult({
    required this.depsHash,
    required this.deps,
    required this.packageZips,
  });
}

/// Server-side packager that bundles third-party packages into individual ZIPs.
class DepPackager {
  // In-memory cache for package zips: "$projectPath" -> DepPackagerResult
  static final Map<String, ({DateTime mtime, DepPackagerResult result})>
  _cache = {};

  /// Computes a deterministic SHA-256 hash over sorted name@version pairs.
  static String computeDepsHash(List<DepEntry> deps) {
    final sortedPairs = deps.map((d) => '${d.name}@${d.version}').toList()
      ..sort();
    final data = utf8.encode(sortedPairs.join('|'));
    return sha256.convert(data).toString().substring(0, 16);
  }

  /// Extracts version from a package directory (via pubspec.yaml or directory name).
  static String extractPackageVersion(Directory pkgRootDir) {
    try {
      final pubspec = File('${pkgRootDir.path}/pubspec.yaml');
      if (pubspec.existsSync()) {
        for (final line in pubspec.readAsLinesSync()) {
          final match = RegExp(
            r'^version:\s*([^\s#]+)',
          ).firstMatch(line.trim());
          if (match != null) {
            return match.group(1)!.trim();
          }
        }
      }
    } catch (_) {}

    // Fallback: parse from folder name e.g. "riverpod-3.3.2"
    final folderName = p.basename(pkgRootDir.path);
    final dashIdx = folderName.lastIndexOf('-');
    if (dashIdx != -1 && dashIdx < folderName.length - 1) {
      return folderName.substring(dashIdx + 1);
    }

    return '1.0.0';
  }

  /// Fixed ZIP entry timestamp for [zipFilesMap]: 1980-01-01T00:00:00Z, the
  /// earliest representable DOS date. Pinned so identical sources always
  /// encode to identical bytes.
  static const int _fixedZipTimestamp = 315532800;

  /// Packs a memory map of files (path -> content) into a ZIP archive.
  ///
  /// The output is byte-for-byte deterministic for the same [files]: entries
  /// are sorted by path and every entry gets a fixed modification time.
  /// `ArchiveFile` otherwise defaults `lastModTime` to `DateTime.now()`, so
  /// two packs of identical sources straddling a second boundary produced
  /// different bytes — and therefore a different `userCodeHash`, which clients
  /// use to decide whether to re-download `user-code.zip`.
  static List<int> zipFilesMap(Map<String, String> files) {
    final archive = Archive();
    final paths = files.keys.toList()..sort();
    for (final path in paths) {
      final bytes = utf8.encode(files[path]!);
      final file = ArchiveFile(path, bytes.length, bytes)
        ..lastModTime = _fixedZipTimestamp;
      archive.addFile(file);
    }
    final encoder = ZipEncoder();
    final dynamic encoded = encoder.encode(archive);
    if (encoded is List<int>) {
      return encoded;
    }
    return <int>[];
  }

  /// Resolves all pure Dart dependencies, builds their ZIPs, and caches them.
  static DepPackagerResult resolveAndPack(
    Directory projectDir,
    String serverUrl, {
    String? packageName,
  }) {
    final configFile = File(
      '${projectDir.path}/.dart_tool/package_config.json',
    );
    if (!configFile.existsSync()) {
      return const DepPackagerResult(
        depsHash: 'empty',
        deps: [],
        packageZips: {},
      );
    }

    final mtime = configFile.lastModifiedSync();
    final cacheKey = projectDir.path;
    final cached = _cache[cacheKey];
    if (cached != null && cached.mtime == mtime) {
      return cached.result;
    }

    final depEntries = <DepEntry>[];
    final packageZips = <String, List<int>>{};

    try {
      final json = jsonDecode(configFile.readAsStringSync());
      if (json is Map<String, dynamic>) {
        final packages = json['packages'] as List<dynamic>?;
        if (packages != null) {
          final baseUri = configFile.uri;

          for (final pkg in packages) {
            if (pkg is! Map<String, dynamic>) continue;
            final name = pkg['name'] as String?;
            if (name == null || name.isEmpty) continue;
            if (name == packageName) continue;
            if (name == 'dartnative' ||
                name == 'dartnative_ios' ||
                name == 'dartnative_android') {
              continue;
            }
            if (kExcludedDevPackages.contains(name)) continue;

            final rawRootStr = pkg['rootUri'] as String?;
            final rawPkgUriStr = (pkg['packageUri'] as String?) ?? 'lib/';
            if (rawRootStr == null) continue;

            final rootUriStr = rawRootStr.endsWith('/')
                ? rawRootStr
                : '$rawRootStr/';
            final packageUriStr = rawPkgUriStr.endsWith('/')
                ? rawPkgUriStr
                : '$rawPkgUriStr/';

            final rootUri = baseUri.resolve(rootUriStr);
            final libUri = rootUri.resolve(packageUriStr);
            final pkgRootDir = Directory.fromUri(rootUri);
            final libDir = Directory.fromUri(libUri);
            if (!libDir.existsSync()) continue;

            // Collect files in package lib/
            final filesMap = <String, String>{};
            for (final entity in libDir.listSync(recursive: true)) {
              if (entity is File && entity.path.endsWith('.dart')) {
                final rel = p
                    .relative(entity.path, from: libDir.path)
                    .replaceAll(r'\', '/');
                final packageUri = 'package:$name/$rel';
                if (!kAstBridgedLibraries.contains(packageUri)) {
                  try {
                    filesMap[rel] = entity.readAsStringSync();
                  } catch (_) {}
                }
              }
            }

            if (filesMap.isEmpty) continue;

            final version = extractPackageVersion(pkgRootDir);
            final zipKey = '$name@$version';
            final zipBytes = zipFilesMap(filesMap);
            final contentHash = sha256
                .convert(zipBytes)
                .toString()
                .substring(0, 16);

            packageZips[zipKey] = zipBytes;
            depEntries.add(
              DepEntry(
                name: name,
                version: version,
                zipUrl: '$serverUrl/pkg/$zipKey.zip',
                contentHash: contentHash,
                byteSize: zipBytes.length,
              ),
            );
          }
        }
      }
    } catch (_) {}

    final depsHash = computeDepsHash(depEntries);
    final result = DepPackagerResult(
      depsHash: depsHash,
      deps: depEntries,
      packageZips: packageZips,
    );

    _cache[cacheKey] = (mtime: mtime, result: result);
    return result;
  }

  /// Packs user project code (lib/ or guest_app/) into a ZIP.
  static ({List<int> bytes, String hash}) packUserCode(
    Directory codeDir, {
    String? packageName,
  }) {
    final filesMap = <String, String>{};
    if (codeDir.existsSync()) {
      for (final entity in codeDir.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final rel = p
              .relative(entity.path, from: codeDir.path)
              .replaceAll(r'\', '/');
          try {
            filesMap[rel] = entity.readAsStringSync();
          } catch (_) {}
        }
      }
    }

    final zipBytes = zipFilesMap(filesMap);
    final hash = sha256.convert(zipBytes).toString().substring(0, 16);
    return (bytes: zipBytes, hash: hash);
  }
}

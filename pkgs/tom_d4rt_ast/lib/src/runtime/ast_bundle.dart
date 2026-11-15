import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:tom_d4rt_ast/ast.dart';
import 'package:tom_d4rt_ast/src/runtime/exceptions.dart';
import 'package:tom_d4rt_ast/src/runtime/utils/file_access/file_access.dart';

// `package:archive`'s GZip codecs delegate to the native `dart:io` GZipCodec
// on native platforms and to a pure-Dart ZLib on web, so using them instead of
// `dart:io`'s `gzip` costs nothing on the host and keeps this library — which
// the public barrel re-exports — importable from web. The bytes are identical
// either way; this is the same gzip container.
// DartNative note: the GZip codec singletons are deliberately `final`, not
// `const`: DartNative's patched AOT platform embeds the `package:archive`
// 3.x API whose `GZipEncoder`/`GZipDecoder` constructors are not `const`
// (host/pub-cache resolves archive 4.x, where they are `const` — `final`
// compiles against both).
final _gzipEncoder = GZipEncoder();
final _gzipDecoder = GZipDecoder();

// =============================================================================
// Bundle Format Configuration
// =============================================================================

/// Configuration constants for the [AstBundle] file format.
///
/// Centralizes all format-defining values to avoid hardcoded literals
/// throughout the codebase. These constants define:
/// - File format version and extensions
/// - Archive entry naming conventions
/// - JSON key names for serialization
/// - Magic byte sequences for format detection
abstract final class AstBundleFormat {
  /// Current bundle format version identifier.
  ///
  /// Increment when making breaking changes to the serialization format.
  static const String version = '1.0';

  /// Default file extension for bundle archives.
  static const String bundleExtension = '.ast';

  /// File extension suffix for AST JSON entries within the archive.
  static const String astJsonSuffix = '.ast.json';

  /// Name of the manifest file within the ZIP archive.
  static const String manifestFileName = 'manifest.json';

  // ── JSON Key Names ──

  /// Key for the format version field.
  static const String keyVersion = 'version';

  /// Key for the entry point URI field.
  static const String keyEntryPoint = 'entryPoint';

  /// Key for the file-to-URI mapping in the manifest.
  static const String keyFiles = 'files';

  /// Key for the modules map in the JSON serialization.
  static const String keyModules = 'modules';

  /// Key for the optional source code map.
  static const String keySources = 'sources';

  /// Key for the optional per-module AST byte-size map (module URI → bytes).
  ///
  /// Written once by the bundler so diagnostics can report module sizes
  /// without re-serializing the decoded AST on the device.
  static const String keyModuleSizes = 'moduleSizes';

  /// Key for the optional per-class AST byte-size map
  /// (module URI → class name → bytes).
  static const String keyClassSizes = 'classSizes';

  /// Key for the optional per-module Dart source byte-size map
  /// (module URI → bytes).
  static const String keySourceSizes = 'sourceSizes';

  /// File extension suffix for Dart source entries within the archive.
  static const String sourceDartSuffix = '.src.dart';

  // ── Magic Bytes for Format Detection ──

  /// ZIP file signature bytes (`PK\x03\x04`).
  static const List<int> zipMagicBytes = [0x50, 0x4B, 0x03, 0x04];

  /// Gzip file signature bytes (`\x1f\x8b`).
  static const List<int> gzipMagicBytes = [0x1F, 0x8B];
}

// =============================================================================
// Bundle Manifest
// =============================================================================

/// Describes the contents of an [AstBundle] ZIP archive.
///
/// The manifest maps archive file names to module URIs and identifies
/// the entry point. It is stored as plain JSON at
/// [AstBundleFormat.manifestFileName] within the ZIP archive.
///
/// ## Example manifest.json
/// ```json
/// {
///   "version": "1.0",
///   "entryPoint": "bin/main.dart",
///   "files": {
///     "0.ast.json": "bin/main.dart",
///     "1.ast.json": "lib/utils.dart"
///   }
/// }
/// ```
class AstBundleManifest {
  /// Format version of this manifest.
  final String version;

  /// URI of the entry point module (e.g. `bin/main.dart`).
  final String entryPoint;

  /// Mapping from archive file name (e.g. `0.ast.json`) to module URI.
  final Map<String, String> files;

  /// Optional mapping from source file name (e.g. `0.src.dart`) to module URI.
  ///
  /// When present, the archive contains Dart source code alongside the
  /// compiled AST modules. This is opt-in and `null` by default.
  final Map<String, String>? sourceFiles;

  /// Optional per-module AST JSON size in bytes, keyed by module URI.
  ///
  /// Emitted by the bundler at build time so hosts can report module sizes
  /// (verbose profiling, DevTools AST panel) without serializing every decoded
  /// module back to JSON. `null` for bundles produced before this field
  /// existed; readers must fall back to on-demand serialization.
  final Map<String, int>? moduleSizes;

  /// Optional per-class AST JSON size in bytes, keyed by module URI and then
  /// class name. See [moduleSizes] for why this is recorded.
  final Map<String, Map<String, int>>? classSizes;

  /// Optional per-module Dart source size in bytes, keyed by module URI.
  /// See [moduleSizes].
  final Map<String, int>? sourceSizes;

  const AstBundleManifest({
    required this.version,
    required this.entryPoint,
    required this.files,
    this.sourceFiles,
    this.moduleSizes,
    this.classSizes,
    this.sourceSizes,
  });

  /// Serializes this manifest to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
    AstBundleFormat.keyVersion: version,
    AstBundleFormat.keyEntryPoint: entryPoint,
    AstBundleFormat.keyFiles: files,
    if (sourceFiles != null) AstBundleFormat.keySources: sourceFiles,
    if (moduleSizes != null) AstBundleFormat.keyModuleSizes: moduleSizes,
    if (classSizes != null) AstBundleFormat.keyClassSizes: classSizes,
    if (sourceSizes != null) AstBundleFormat.keySourceSizes: sourceSizes,
  };

  /// Deserializes a manifest from a JSON map.
  ///
  /// Throws [ArgumentD4rtException] if required fields are missing
  /// or have invalid types.
  factory AstBundleManifest.fromJson(Map<String, dynamic> json) {
    final version = json[AstBundleFormat.keyVersion] as String?;
    if (version == null) {
      throw ArgumentD4rtException(
        'Invalid bundle manifest: '
        'missing "${AstBundleFormat.keyVersion}"',
      );
    }

    final entryPoint = json[AstBundleFormat.keyEntryPoint] as String?;
    if (entryPoint == null) {
      throw ArgumentD4rtException(
        'Invalid bundle manifest: '
        'missing "${AstBundleFormat.keyEntryPoint}"',
      );
    }

    final filesJson = json[AstBundleFormat.keyFiles];
    if (filesJson is! Map<String, dynamic>) {
      throw ArgumentD4rtException(
        'Invalid bundle manifest: '
        '"${AstBundleFormat.keyFiles}" must be a JSON object',
      );
    }

    // Parse optional sources mapping
    Map<String, String>? sourceFiles;
    final sourcesJson = json[AstBundleFormat.keySources];
    if (sourcesJson is Map<String, dynamic>) {
      sourceFiles = sourcesJson.map((k, v) => MapEntry(k, v.toString()));
    }

    return AstBundleManifest(
      version: version,
      entryPoint: entryPoint,
      files: filesJson.map((k, v) => MapEntry(k, v.toString())),
      sourceFiles: sourceFiles,
      moduleSizes: _intMap(json[AstBundleFormat.keyModuleSizes]),
      classSizes: _nestedIntMap(json[AstBundleFormat.keyClassSizes]),
      sourceSizes: _intMap(json[AstBundleFormat.keySourceSizes]),
    );
  }

  /// Parses an optional `Map<String, int>` from bundle JSON.
  ///
  /// Malformed entries are skipped rather than failing the whole bundle: sizes
  /// are diagnostics-only metadata and must never break loading.
  static Map<String, int>? _intMap(Object? value) {
    if (value is! Map) return null;
    final out = <String, int>{};
    for (final entry in value.entries) {
      final key = entry.key;
      final raw = entry.value;
      if (key is String && raw is num) {
        out[key] = raw.toInt();
      }
    }
    return out.isEmpty ? null : out;
  }

  /// Parses an optional `Map<String, Map<String, int>>` from bundle JSON.
  static Map<String, Map<String, int>>? _nestedIntMap(Object? value) {
    if (value is! Map) return null;
    final out = <String, Map<String, int>>{};
    for (final entry in value.entries) {
      final key = entry.key;
      final nested = _intMap(entry.value);
      if (key is String && nested != null) {
        out[key] = nested;
      }
    }
    return out.isEmpty ? null : out;
  }

  @override
  String toString() =>
      'AstBundleManifest(version: $version, '
      'entryPoint: $entryPoint, '
      'files: ${files.length})';
}

// =============================================================================
// AstBundle
// =============================================================================

/// A transportable unit containing an entry point and all required modules.
///
/// [AstBundle] is the primary distribution format for pre-parsed D4rt scripts.
/// It encapsulates one or more [SCompilationUnit] modules that can be executed
/// by `D4rtRunner` without requiring the Dart analyzer.
///
/// ## Serialization Formats
///
/// | Format | Methods | Use Case |
/// |--------|---------|----------|
/// | JSON   | [toJson] / [fromJson] | Debugging, tool integration |
/// | Bytes  | [toBytes] / [fromBytes] | Network transfer, in-memory |
/// | ZIP    | [toZip] / [fromZip] | File distribution (`.ast`) |
/// | File   | [saveToFile] / [fromFile] | Disk I/O with auto-detection |
///
/// ## Example
///
/// ```dart
/// // Create and save a bundle
/// final bundle = AstBundle(
///   entryPointUri: 'bin/main.dart',
///   modules: {'bin/main.dart': mainAst, 'lib/utils.dart': utilsAst},
/// );
/// bundle.saveToFile('my_script.ast');
///
/// // Load and execute
/// final loaded = AstBundle.fromFile('my_script.ast');
/// final runner = D4rtRunner();
/// runner.execute(ast: loaded.entryPoint);
/// ```
class AstBundle {
  /// URI identifying the entry point module.
  final String entryPointUri;

  /// All modules in this bundle, keyed by their URI.
  final Map<String, SCompilationUnit> modules;

  /// Optional Dart source code for each module, keyed by URI.
  ///
  /// When non-null, the source code is included alongside the compiled
  /// AST in both JSON and ZIP serialization formats. This is opt-in
  /// and disabled by default (`null`).
  final Map<String, String>? sources;

  /// Optional per-module AST JSON size in bytes, keyed by URI.
  ///
  /// Recorded by the bundler at build time (see [AstBundleManifest.moduleSizes])
  /// so diagnostics can report sizes without re-serializing decoded modules.
  /// `null` for bundles that predate the field.
  final Map<String, int>? moduleAstBytes;

  /// Optional per-class AST JSON size in bytes, keyed by module URI and then
  /// class name. See [moduleAstBytes].
  final Map<String, Map<String, int>>? classAstBytes;

  /// Optional per-module Dart source size in bytes, keyed by URI.
  /// See [moduleAstBytes].
  final Map<String, int>? sourceBytes;

  /// Creates an [AstBundle] with the given entry point and modules.
  ///
  /// Optionally includes [sources] — a map from module URI to Dart source
  /// code. When `null` (the default), no source is bundled.
  ///
  /// [moduleAstBytes] / [classAstBytes] / [sourceBytes] are diagnostics-only
  /// size metadata; when `null` they are omitted from serialization.
  ///
  /// Throws [ArgumentD4rtException] if [entryPointUri] is not present
  /// in [modules].
  AstBundle({
    required this.entryPointUri,
    required this.modules,
    this.sources,
    this.moduleAstBytes,
    this.classAstBytes,
    this.sourceBytes,
  }) {
    if (!modules.containsKey(entryPointUri)) {
      throw ArgumentD4rtException(
        'Entry point "$entryPointUri" not found in modules. '
        'Available: ${modules.keys.join(", ")}',
      );
    }
  }

  /// The entry point [SCompilationUnit].
  SCompilationUnit get entryPoint => modules[entryPointUri]!;

  /// Number of modules in this bundle.
  int get moduleCount => modules.length;

  /// Whether this bundle contains only the entry point module.
  bool get isSingleModule => modules.length == 1;

  /// Creates a new [AstBundle] by applying the modules from [patch] over this bundle.
  AstBundle applyPatch(AstBundle patch) {
    final merged = Map<String, SCompilationUnit>.of(modules);
    merged.addAll(patch.modules);
    Map<String, String>? mergedSources;
    if (sources != null || patch.sources != null) {
      mergedSources = Map<String, String>.of(sources ?? const {});
      if (patch.sources != null) {
        mergedSources.addAll(patch.sources!);
      }
    }
    Map<String, int>? mergedModuleSizes;
    if (moduleAstBytes != null || patch.moduleAstBytes != null) {
      mergedModuleSizes = Map<String, int>.of(moduleAstBytes ?? const {});
      if (patch.moduleAstBytes != null) {
        mergedModuleSizes.addAll(patch.moduleAstBytes!);
      }
    }
    Map<String, Map<String, int>>? mergedClassSizes;
    if (classAstBytes != null || patch.classAstBytes != null) {
      mergedClassSizes = Map<String, Map<String, int>>.of(
        classAstBytes ?? const {},
      );
      if (patch.classAstBytes != null) {
        mergedClassSizes.addAll(patch.classAstBytes!);
      }
    }
    Map<String, int>? mergedSourceSizes;
    if (sourceBytes != null || patch.sourceBytes != null) {
      mergedSourceSizes = Map<String, int>.of(sourceBytes ?? const {});
      if (patch.sourceBytes != null) {
        mergedSourceSizes.addAll(patch.sourceBytes!);
      }
    }
    return AstBundle(
      entryPointUri: entryPointUri,
      modules: merged,
      sources: mergedSources,
      moduleAstBytes: mergedModuleSizes,
      classAstBytes: mergedClassSizes,
      sourceBytes: mergedSourceSizes,
    );
  }

  // ===========================================================================
  // JSON Serialization
  // ===========================================================================

  /// Serializes this bundle to a JSON-compatible map.
  ///
  /// The resulting map includes format version, entry point URI,
  /// and all module ASTs keyed by their URI. When [sources] is non-null,
  /// the map also includes source code keyed by module URI.
  Map<String, dynamic> toJson() => {
    AstBundleFormat.keyVersion: AstBundleFormat.version,
    AstBundleFormat.keyEntryPoint: entryPointUri,
    AstBundleFormat.keyModules: modules.map(
      (uri, cu) => MapEntry(uri, cu.toJson()),
    ),
    if (sources != null) AstBundleFormat.keySources: sources,
    if (moduleAstBytes != null) AstBundleFormat.keyModuleSizes: moduleAstBytes,
    if (classAstBytes != null) AstBundleFormat.keyClassSizes: classAstBytes,
    if (sourceBytes != null) AstBundleFormat.keySourceSizes: sourceBytes,
  };

  /// Deserializes a bundle from a JSON map.
  ///
  /// Throws [ArgumentD4rtException] if required fields are missing
  /// or module data is invalid.
  factory AstBundle.fromJson(Map<String, dynamic> json) {
    _requireString(json, AstBundleFormat.keyVersion, 'bundle JSON');
    final entryPointUri = _requireString(
      json,
      AstBundleFormat.keyEntryPoint,
      'bundle JSON',
    );

    final modulesJson = json[AstBundleFormat.keyModules];
    if (modulesJson is! Map<String, dynamic>) {
      throw ArgumentD4rtException(
        'Invalid bundle JSON: '
        '"${AstBundleFormat.keyModules}" must be a JSON object',
      );
    }

    final modules = <String, SCompilationUnit>{};
    for (final entry in modulesJson.entries) {
      if (entry.value is! Map<String, dynamic>) {
        throw ArgumentD4rtException(
          'Invalid bundle JSON: '
          'module "${entry.key}" is not a valid AST object',
        );
      }
      modules[entry.key] = SCompilationUnit.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }

    // Parse optional sources
    Map<String, String>? sources;
    final sourcesJson = json[AstBundleFormat.keySources];
    if (sourcesJson is Map<String, dynamic>) {
      sources = sourcesJson.map((k, v) => MapEntry(k, v.toString()));
    }

    return AstBundle(
      entryPointUri: entryPointUri,
      modules: modules,
      sources: sources,
      moduleAstBytes: AstBundleManifest._intMap(
        json[AstBundleFormat.keyModuleSizes],
      ),
      classAstBytes: AstBundleManifest._nestedIntMap(
        json[AstBundleFormat.keyClassSizes],
      ),
      sourceBytes: AstBundleManifest._intMap(
        json[AstBundleFormat.keySourceSizes],
      ),
    );
  }

  // ===========================================================================
  // Binary Serialization (gzip-compressed JSON)
  // ===========================================================================

  /// Serializes this bundle as gzip-compressed JSON bytes.
  ///
  /// Compact format suitable for network transfer and in-memory storage.
  /// For file distribution, prefer [toZip] / [saveToFile].
  List<int> toBytes() {
    final jsonString = jsonEncode(toJson());
    // `encode` (not `encodeBytes`) + [_requireBytes]: archive 4.x keeps
    // `encode` as a non-nullable alias of `encodeBytes`, while archive 3.x
    // (embedded in DartNative's AOT platform) only has nullable `encode`.
    return _requireBytes(
      _gzipEncoder.encode(utf8.encode(jsonString)),
      'gzip-encode bundle',
    );
  }

  /// Deserializes a bundle from gzip-compressed JSON bytes.
  ///
  /// Throws [ArgumentD4rtException] if decompression or parsing fails.
  factory AstBundle.fromBytes(List<int> bytes) {
    try {
      final decompressed = _gzipDecoder.decodeBytes(bytes);
      final jsonString = utf8.decode(decompressed);
      final json = jsonDecode(jsonString);
      if (json is! Map<String, dynamic>) {
        throw ArgumentD4rtException(
          'Invalid bundle bytes: decoded JSON is not an object',
        );
      }
      return AstBundle.fromJson(json);
    } on FormatException catch (e) {
      throw ArgumentD4rtException('Invalid bundle bytes: ${e.message}');
    }
  }

  // ===========================================================================
  // ZIP Archive Serialization
  // ===========================================================================

  /// Serializes this bundle as a ZIP archive.
  ///
  /// The archive follows the `.ast` bundle specification:
  /// - `manifest.json` — plain JSON with metadata and file-to-URI mapping
  /// - `N.ast.json` — gzip-compressed JSON for each module
  /// - `N.src.dart` — plain-text source code (only when [sources] is non-null)
  ///
  /// Module entries are pre-compressed with gzip and stored without
  /// additional ZIP-level compression, allowing individual modules
  /// to be extracted and used standalone.
  ///
  /// ### Incremental fast-path
  ///
  /// Pass [precompressedModules] (a map from module URI to already-compressed
  /// gzip bytes) to skip re-serialization and re-compression for unchanged
  /// modules. Only modules whose URI is *not* present in the map are
  /// re-encoded. This is the primary hot-reload optimization: a 2 000-module
  /// project where 10 files changed should spend ~0 ms on the other 1 990.
  ///
  /// The method also **populates** [precompressedModules] with the newly
  /// compressed bytes for any module it had to encode, so the caller can
  /// cache and reuse them on the next rebuild.
  ///
  /// [moduleAstBytes] / [classAstBytes] are optional diagnostics caches: pass
  /// the maps the caller keeps across rebuilds and the method reuses the
  /// recorded sizes for unchanged modules, records sizes for newly encoded
  /// ones, and writes the result into `manifest.json`. This lets devices show
  /// AST sizes without re-serializing every decoded module.
  List<int> toZip({
    Map<String, List<int>>? precompressedModules,
    Map<String, int>? moduleAstBytes,
    Map<String, Map<String, int>>? classAstBytes,
  }) {
    final archive = Archive();
    final moduleSizes = <String, int>{};
    final classSizes = <String, Map<String, int>>{};
    final sourceSizes = <String, int>{};

    // Assign sequential file names to each module
    final fileToUri = <String, String>{};
    final uriToFileName = <String, String>{};
    var index = 0;
    for (final uri in modules.keys) {
      final fileName = '$index${AstBundleFormat.astJsonSuffix}';
      fileToUri[fileName] = uri;
      uriToFileName[uri] = fileName;
      index++;
    }

    // Build optional source file mapping
    Map<String, String>? sourceFileToUri;
    if (sources != null && sources!.isNotEmpty) {
      sourceFileToUri = <String, String>{};
      var srcIndex = 0;
      for (final uri in sources!.keys) {
        final srcFileName = '$srcIndex${AstBundleFormat.sourceDartSuffix}';
        sourceFileToUri[srcFileName] = uri;
        srcIndex++;
      }
      // Record source sizes up front: the manifest is serialized before the
      // source entries are written, and diagnostics should never re-encode
      // bundled source text on the device.
      for (final entry in sources!.entries) {
        sourceSizes[entry.key] = utf8.encode(entry.value).length;
      }
    }

    // Write each module as gzip-compressed JSON.
    // Hot-reload fast-path: if the caller supplied pre-compressed bytes for
    // this URI (unchanged module), stitch them in directly — zero JSON encode
    // + zero gzip work.
    for (final entry in modules.entries) {
      final uri = entry.key;
      final fileName = uriToFileName[uri]!;

      final List<int> compressed;
      final cached = precompressedModules?[uri];
      if (cached != null) {
        // Unchanged module — reuse cached compressed bytes.
        compressed = cached;
        final cachedSize = moduleAstBytes?[uri];
        if (cachedSize != null) moduleSizes[uri] = cachedSize;
        final cachedClasses = classAstBytes?[uri];
        if (cachedClasses != null) classSizes[uri] = cachedClasses;
      } else {
        // New or changed module — encode + compress, then populate cache.
        final moduleJson = jsonEncode(entry.value.toJson());
        final moduleBytes = utf8.encode(moduleJson);
        // See [toBytes]: `encode` + [_requireBytes] compiles against archive
        // 3.x (DartNative AOT platform) and 4.x (host) alike.
        compressed = _requireBytes(
          _gzipEncoder.encode(moduleBytes),
          'gzip-encode module "$uri"',
        );
        precompressedModules?[uri] = compressed;
        moduleSizes[uri] = moduleBytes.length;
        moduleAstBytes?[uri] = moduleBytes.length;
        if (classAstBytes != null) {
          final sizes = <String, int>{};
          for (final declaration in entry.value.declarations) {
            if (declaration is! SClassDeclaration) continue;
            final className = declaration.name?.name ?? '(unnamed)';
            sizes[className] = utf8
                .encode(jsonEncode(declaration.toJson()))
                .length;
          }
          classAstBytes[uri] = sizes;
          classSizes[uri] = sizes;
        }
      }

      // Use noCompress: content is already gzip-compressed.
      archive.addFile(
        ArchiveFile.noCompress(fileName, compressed.length, compressed),
      );
    }

    // Write manifest (uncompressed, human-readable) after the modules so the
    // per-module size metadata recorded above is available.
    final manifest = AstBundleManifest(
      version: AstBundleFormat.version,
      entryPoint: entryPointUri,
      files: fileToUri,
      sourceFiles: sourceFileToUri,
      moduleSizes: moduleSizes.isEmpty ? null : moduleSizes,
      classSizes: classSizes.isEmpty ? null : classSizes,
      sourceSizes: sourceSizes.isEmpty ? null : sourceSizes,
    );
    final manifestJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(manifest.toJson());
    archive.addFile(
      ArchiveFile.string(AstBundleFormat.manifestFileName, manifestJson),
    );

    // Write source files (plain text, uncompressed for readability)
    if (sources != null && sourceFileToUri != null) {
      final uriToSrcFileName = <String, String>{};
      for (final entry in sourceFileToUri.entries) {
        uriToSrcFileName[entry.value] = entry.key;
      }
      for (final entry in sources!.entries) {
        final srcFileName = uriToSrcFileName[entry.key];
        if (srcFileName != null) {
          sourceSizes[entry.key] = utf8.encode(entry.value).length;
          archive.addFile(ArchiveFile.string(srcFileName, entry.value));
        }
      }
    }

    // Record source sizes up front: the manifest is serialized before the
    // source entries are written, and diagnostics should never re-encode
    // bundled source text on the device.
    if (sources != null && sourceFileToUri != null) {
      for (final entry in sources!.entries) {
        if (sourceFileToUri.containsKey(entry.key)) {
          sourceSizes[entry.key] = utf8.encode(entry.value).length;
        }
      }
    }

    // `ZipEncoder().encode` returns `List<int>` on archive 4.x but
    // `List<int>?` on archive 3.x (DartNative AOT platform): narrow via
    // [_requireBytes] so this compiles against both.
    return _requireBytes(ZipEncoder().encode(archive), 'encode bundle archive');
  }

  /// Deserializes a bundle from ZIP archive bytes.
  ///
  /// Reads the manifest to discover module URIs, then loads and
  /// decompresses each referenced module file.
  ///
  /// Throws [ArgumentD4rtException] if the archive is invalid,
  /// the manifest is missing, or referenced module files are absent.
  factory AstBundle.fromZip(List<int> bytes) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (e) {
      throw ArgumentD4rtException('Invalid ZIP archive: $e');
    }

    // Parse manifest
    final manifestFile = archive.findFile(AstBundleFormat.manifestFileName);
    if (manifestFile == null) {
      throw ArgumentD4rtException(
        'Invalid bundle archive: '
        'missing "${AstBundleFormat.manifestFileName}"',
      );
    }

    final manifestJson = jsonDecode(utf8.decode(manifestFile.content));
    if (manifestJson is! Map<String, dynamic>) {
      throw ArgumentD4rtException(
        'Invalid bundle archive: manifest is not a valid JSON object',
      );
    }
    final manifest = AstBundleManifest.fromJson(manifestJson);

    // Load each module referenced by the manifest
    final modules = <String, SCompilationUnit>{};
    for (final entry in manifest.files.entries) {
      final fileName = entry.key;
      final uri = entry.value;

      final file = archive.findFile(fileName);
      if (file == null) {
        throw ArgumentD4rtException(
          'Invalid bundle archive: '
          'module file "$fileName" referenced in manifest not found',
        );
      }

      final moduleJson = _decodeModuleContent(file.content, uri, fileName);
      modules[uri] = SCompilationUnit.fromJson(moduleJson);
    }

    // Load optional source files referenced by the manifest
    Map<String, String>? sources;
    if (manifest.sourceFiles != null && manifest.sourceFiles!.isNotEmpty) {
      sources = <String, String>{};
      for (final entry in manifest.sourceFiles!.entries) {
        final srcFileName = entry.key;
        final uri = entry.value;
        final srcFile = archive.findFile(srcFileName);
        if (srcFile != null) {
          sources[uri] = utf8.decode(srcFile.content);
        }
      }
      if (sources.isEmpty) sources = null;
    }

    return AstBundle(
      entryPointUri: manifest.entryPoint,
      modules: modules,
      sources: sources,
      moduleAstBytes: manifest.moduleSizes,
      classAstBytes: manifest.classSizes,
      sourceBytes: manifest.sourceSizes,
    );
  }

  // ===========================================================================
  // File I/O
  // ===========================================================================

  /// Saves this bundle to a file in ZIP archive format.
  ///
  /// Creates parent directories if they don't exist.
  ///
  /// Pass [precompressedModules] to enable the incremental hot-reload
  /// fast-path, and [moduleAstBytes] / [classAstBytes] to carry recorded size
  /// metadata across rebuilds — see [toZip] for details.
  void saveToFile(
    String path, {
    Map<String, List<int>>? precompressedModules,
    Map<String, int>? moduleAstBytes,
    Map<String, Map<String, int>>? classAstBytes,
  }) {
    writeFileAsBytesSync(
      path,
      toZip(
        precompressedModules: precompressedModules,
        moduleAstBytes: moduleAstBytes,
        classAstBytes: classAstBytes,
      ),
    );
  }

  /// Loads a bundle from a file.
  ///
  /// Auto-detects the format based on file content magic bytes:
  /// - ZIP archive (standard `.ast` files)
  /// - Gzip-compressed JSON
  /// - Plain JSON (fallback)
  ///
  /// Throws [ArgumentD4rtException] if the file doesn't exist,
  /// is empty, or has an unrecognized format.
  factory AstBundle.fromFile(String path) {
    if (!fileExistsSync(path)) {
      throw ArgumentD4rtException('Bundle file not found: $path');
    }

    final bytes = readFileAsBytesSync(path);
    if (bytes.isEmpty) {
      throw ArgumentD4rtException('Bundle file is empty: $path');
    }

    // Auto-detect format from magic bytes
    if (_startsWith(bytes, AstBundleFormat.zipMagicBytes)) {
      return AstBundle.fromZip(bytes);
    }
    if (_startsWith(bytes, AstBundleFormat.gzipMagicBytes)) {
      return AstBundle.fromBytes(bytes);
    }

    // Fallback: try plain JSON
    try {
      final json = jsonDecode(utf8.decode(bytes));
      if (json is Map<String, dynamic>) {
        return AstBundle.fromJson(json);
      }
    } catch (_) {
      // Fall through to error
    }

    throw ArgumentD4rtException('Unrecognized bundle format in file: $path');
  }

  // ===========================================================================
  // Private Helpers
  // ===========================================================================

  /// Decodes module content bytes, handling optional gzip compression.
  static Map<String, dynamic> _decodeModuleContent(
    List<int> content,
    String uri,
    String fileName,
  ) {
    var bytes = content;
    if (_startsWith(bytes, AstBundleFormat.gzipMagicBytes)) {
      bytes = _gzipDecoder.decodeBytes(bytes);
    }

    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map<String, dynamic>) {
      throw ArgumentD4rtException(
        'Invalid bundle archive: '
        'module "$uri" ($fileName) is not a valid AST JSON object',
      );
    }
    return decoded;
  }

  /// Extracts a required string field from a JSON map.
  static String _requireString(
    Map<String, dynamic> json,
    String key,
    String context,
  ) {
    final value = json[key] as String?;
    if (value == null) {
      throw ArgumentD4rtException('Invalid $context: missing "$key"');
    }
    return value;
  }

  /// Narrows a nullable `package:archive` codec result.
  ///
  /// `GZipEncoder`/`ZipEncoder.encode` return `List<int>` on archive 4.x but
  /// `List<int>?` on archive 3.x (embedded in DartNative's AOT platform), so
  /// call sites pass the result through here instead of declaring an
  /// explicitly nullable local — compiling against both APIs with no
  /// analyzer hints on either.
  static List<int> _requireBytes(List<int>? bytes, String what) {
    if (bytes == null) {
      throw ArgumentD4rtException('Failed to $what');
    }
    return bytes;
  }

  /// Checks whether [bytes] starts with the given [prefix].
  static bool _startsWith(List<int> bytes, List<int> prefix) {
    if (bytes.length < prefix.length) return false;
    for (var i = 0; i < prefix.length; i++) {
      if (bytes[i] != prefix[i]) return false;
    }
    return true;
  }

  @override
  String toString() =>
      'AstBundle(entryPoint: $entryPointUri, '
      'modules: $moduleCount'
      '${sources != null ? ', sources: ${sources!.length}' : ''})';
}

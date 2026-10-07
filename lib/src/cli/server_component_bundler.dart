/// Delta bundler for server components.
///
/// Given a set of annotated components and a client module index, produces
/// per-component AST bundles containing only the code unique to each
/// component — shared modules are resolved from the client bundle at runtime.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart' show AstBundle;

import 'client_module_index.dart';
import 'safe_ast_converter.dart';
import 'server_annotation_scanner.dart';

/// Result of building a single server component bundle.
class ServerComponentBuildResult {
  /// The component identifier (from the annotation).
  final String componentId;

  /// The generated AST bundle bytes.
  final List<int> astBytes;

  /// Number of modules in this component bundle.
  final int moduleCount;

  /// Total byte size of the component bundle.
  final int byteSize;

  /// Fingerprint of the component's sources for cache invalidation.
  final String fingerprint;

  const ServerComponentBuildResult({
    required this.componentId,
    required this.astBytes,
    required this.moduleCount,
    required this.byteSize,
    required this.fingerprint,
  });
}

/// Result of building all server components.
class ServerComponentsBuildResult {
  /// Map of component ID → build result.
  final Map<String, ServerComponentBuildResult> components;

  /// Server components manifest: component ID → bundle URL path + fingerprint.
  final Map<String, ({String url, String fingerprint})> manifest;

  const ServerComponentsBuildResult({
    required this.components,
    required this.manifest,
  });
}

/// Builds per-component AST bundles for `@ServerComponent` annotated classes.
///
/// Each component bundle contains only the modules NOT already in the
/// client bundle. Shared libraries are resolved from the interpreter's
/// existing module pool at runtime.
class ServerComponentBundler {
  final Set<String> bridgedLibraries;
  final Map<String, String> explicitSources;
  final String? packageName;
  final String? projectRoot;
  final AstBundlerConfig config;
  final AstConverter converter;
  final ClientModuleIndex clientModuleIndex;

  ServerComponentBundler({
    this.bridgedLibraries = const {},
    this.explicitSources = const {},
    this.packageName,
    this.projectRoot,
    this.config = const AstBundlerConfig(),
    AstConverter? converter,
    required this.clientModuleIndex,
  }) : converter = converter ?? SafeAstConverter();

  /// Builds a per-component delta bundle for [component].
  ///
  /// The returned bundle contains only the modules that are NOT in the
  /// client module index. Modules already in the client bundle are
  /// excluded — they will be resolved from the interpreter's existing
  /// module pool at runtime.
  ///
  /// The component's entry module is ALWAYS included, even when it is
  /// also in the client index (shared component). The declaration
  /// registry treats re-declaration idempotently, so the duplication
  /// is harmless and keeps [AstBundle.entryPointUri] valid.
  Future<AstBundle?> buildComponentBundle(
    AnnotatedComponent component, {
    required Map<String, String> allSources,
  }) async {
    final moduleUri = component.moduleUri;
    var source = allSources[moduleUri];
    // Fallback: server-only modules are never reachable from main() so
    // they are absent from bundle.sources — resolve from disk instead.
    source ??= _readSourceFromDisk(moduleUri);
    if (source == null) return null;

    // Parse the component's entry module.
    final entryAst = _getOrParse(source, moduleUri);

    // Resolve the full transitive import closure starting from this module.
    // Follows normal imports (non-bridged, non-client) to build the closure.
    final deltaModules = <String, SCompilationUnit>{};
    deltaModules[moduleUri] = entryAst;

    await _resolveDeltaImports(
      entryAst,
      Uri.parse(moduleUri),
      deltaModules,
      bundleSources: allSources,
      depth: 0,
      fileSystemRoot: projectRoot,
    );

    if (deltaModules.isEmpty) return null;

    return AstBundle(
      entryPointUri: moduleUri,
      modules: deltaModules,
    );
  }

  /// Resolves the transitive import closure for a server component,
  /// stopping at every module that is in the client bundle or is bridged.
  Future<void> _resolveDeltaImports(
    SCompilationUnit ast,
    Uri moduleUri,
    Map<String, SCompilationUnit> modules, {
    Map<String, String>? bundleSources,
    required int depth,
    String? fileSystemRoot,
  }) async {
    if (depth >= config.maxImportDepth) {
      return; // Don't throw — just stop following this branch.
    }

    for (final directive in ast.directives) {
      String? uriString;
      if (directive is SImportDirective) {
        // ★ KEY: Stop at deferred imports — they're separate boundaries.
        if (directive.isDeferred) continue;
        uriString = _extractUriString(directive.uri);
      } else if (directive is SExportDirective) {
        uriString = _extractUriString(directive.uri);
      } else if (config.followPartDirectives && directive is SPartDirective) {
        uriString = _extractUriString(directive.uri);
      }

      if (uriString == null) continue;

      final importUri = Uri.parse(uriString);

      // Skip dart: scheme — always resolved by the runtime.
      if (config.stdlibSchemes.contains(importUri.scheme)) continue;

      // Skip bridged libraries — handled by native bridges.
      if (bridgedLibraries.contains(uriString)) continue;

      // ★ KEY: Skip modules already in the client bundle.
      // The interpreter already has these — no need to re-bundle.
      final resolvedUri = _resolveUri(importUri, moduleUri);
      final canonicalUri = resolvedUri.toString();
      if (clientModuleIndex.contains(canonicalUri)) continue;

      // Skip if already resolved in this delta closure.
      if (modules.containsKey(canonicalUri)) continue;

      // Attempt to resolve from available sources, falling back to disk
      // for server-only transitive deps never reachable from main().
      var source = bundleSources?[canonicalUri];
      source ??= _readSourceFromDisk(canonicalUri);
      if (source == null) continue;

      // Parse and recurse.
      final importedAst = _getOrParse(source, canonicalUri);
      modules[canonicalUri] = importedAst;
      await _resolveDeltaImports(
        importedAst,
        Uri.parse(canonicalUri),
        modules,
        bundleSources: bundleSources,
        depth: depth + 1,
        fileSystemRoot: fileSystemRoot,
      );
    }
  }

  SCompilationUnit _getOrParse(String source, String uri) {
    final parseResult = parseString(
      content: source,
      path: uri,
      throwIfDiagnostics: false,
    );
    return converter.convertCompilationUnit(parseResult.unit);
  }

  Uri _resolveUri(Uri importUri, Uri moduleUri) {
    if (importUri.isScheme('dart') || importUri.isScheme('package')) {
      return importUri;
    }
    return moduleUri.resolveUri(importUri);
  }

  String? _extractUriString(SStringLiteral? uriNode) {
    if (uriNode is SSimpleStringLiteral) return uriNode.value;
    return null;
  }

  /// Reads [moduleUri] from disk under [projectRoot].
  ///
  /// Handles `package:<name>/path` (→ `<root>/lib/path`) and
  /// root-relative paths (→ `<root>/path`). Returns null when the
  /// file cannot be resolved — the caller skips the module.
  String? _readSourceFromDisk(String moduleUri) {
    final root = projectRoot;
    if (root == null) return null;
    try {
      final uri = Uri.parse(moduleUri);
      String? filePath;
      if (uri.isScheme('package')) {
        final segments = uri.pathSegments;
        if (segments.isEmpty) return null;
        // package:<self>/... → <root>/lib/...
        // package:<other>/... → not resolvable from this project.
        if (packageName != null && segments.first == packageName) {
          filePath =
              '$root/lib/${segments.skip(1).join('/')}';
        } else {
          return null;
        }
      } else if (!uri.hasScheme) {
        filePath = '$root/$moduleUri';
      } else {
        return null;
      }
      final file = File(filePath);
      if (!file.existsSync()) return null;
      return file.readAsStringSync();
    } catch (_) {
      return null;
    }
  }

  /// Builds delta bundles for every component in [annotated].
  ///
  /// Returns a [ServerComponentsBuildResult] with per-component bytes
  /// plus the serving manifest (component ID → relative URL + fingerprint).
  /// Components whose entry source cannot be resolved are skipped.
  Future<ServerComponentsBuildResult> buildAll(
    Set<AnnotatedComponent> annotated, {
    required Map<String, String> allSources,
    String bundleUrlPrefix = 'server_components',
  }) async {
    final built = <String, ServerComponentBuildResult>{};
    final manifest = <String, ({String url, String fingerprint})>{};
    for (final component in annotated) {
      final bundle = await buildComponentBundle(
        component,
        allSources: allSources,
      );
      if (bundle == null) continue;
      final bytes = bundle.toBytes();
      final fp = _fingerprintBytes(bytes);
      built[component.componentId] = ServerComponentBuildResult(
        componentId: component.componentId,
        astBytes: bytes,
        moduleCount: bundle.modules.length,
        byteSize: bytes.length,
        fingerprint: fp,
      );
      manifest[component.componentId] = (
        url: '$bundleUrlPrefix/${component.componentId}.ast',
        fingerprint: fp,
      );
    }
    return ServerComponentsBuildResult(
      components: built,
      manifest: manifest,
    );
  }
}

/// FNV-1a 64-bit hex over [bytes] (matches the bundler fingerprint style).
String _fingerprintBytes(List<int> bytes) {
  var hash = 0xcbf29ce484222325;
  const prime = 0x100000001b3;
  for (final b in bytes) {
    hash ^= b;
    hash = (hash * prime) & 0xFFFFFFFFFFFFFFFF;
  }
  return hash.toRadixString(16);
}

/// Serializes a component [manifest] to the dev-server / CDN JSON format.
///
/// ```json
/// {
///   "version": 1,
///   "components": {
///     "profile_card": {"url": "server_components/profile_card.ast", "fingerprint": "abc123"}
///   }
/// }
/// ```
Map<String, dynamic> serverManifestToJson(
  Map<String, ({String url, String fingerprint})> manifest,
) {
  return {
    'version': 1,
    'components': {
      for (final e in manifest.entries)
        e.key: {'url': e.value.url, 'fingerprint': e.value.fingerprint},
    },
  };
}

/// Writes the component [manifest] as pretty JSON to [file].
void saveServerManifestToFile(
  Map<String, ({String url, String fingerprint})> manifest,
  File file,
) {
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(serverManifestToJson(manifest)),
  );
}

/// Delta bundler for server components.
///
/// Given a set of annotated components and a client module index, produces
/// per-component AST bundles containing only the code unique to each
/// component — shared modules are resolved from the client bundle at runtime.
library;

import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart' show AstBundle;

import 'client_module_index.dart';
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
  Future<AstBundle?> buildComponentBundle(
    AnnotatedComponent component, {
    required Map<String, String> allSources,
  }) async {
    final moduleUri = component.moduleUri;
    final source = allSources[moduleUri];
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

      // Attempt to resolve from available sources.
      final source = bundleSources?[canonicalUri];
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
    // Use the shared process-lifetime AST cache from ast_builder.dart
    // via the same FNV-1a hashing pattern. For now, parse fresh.
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
}

/// AST converter that extends the generator's default to handle
/// newer analyzer node types without crashing.
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
    final nodeType = node.runtimeType.toString();
    if (nodeType.contains('DotShorthandPropertyAccess')) {
      final propName = (node as dynamic).propertyName?.name?.toString() ??
          (node as dynamic).identifier?.name?.toString() ??
          node.toString().replaceAll(RegExp(r'^\.'), '');
      return SSimpleIdentifier(
        offset: node.offset,
        length: node.length,
        name: propName,
        inDeclarationContext: false,
      );
    }
    if (nodeType.contains('DotShorthandInvocation')) {
      final methodName = (node as dynamic).methodName?.name?.toString() ??
          (node as dynamic).identifier?.name?.toString() ??
          '';
      final args = (node as dynamic).argumentList as analyzer.AstNode?;
      return SMethodInvocation(
        offset: node.offset,
        length: node.length,
        methodName: SSimpleIdentifier(
          offset: node.offset,
          length: methodName.length,
          name: methodName,
          inDeclarationContext: false,
        ),
        argumentList: convert(args) as SArgumentList?,
      );
    }
    return super.convert(node);
  }
}

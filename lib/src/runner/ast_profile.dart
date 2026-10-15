import 'dart:convert';

import 'package:tom_ast_model/ast.dart' show SClassDeclaration;
import 'package:tom_d4rt_ast/runtime.dart' as ast;

/// One bundle module's size + load profile.
class AstModuleProfile {
  final String uri;

  /// Owning package (`package:foo/...` → `foo`, `dart:*` → `dart SDK`,
  /// anything else → `app`).
  final String package;
  final int astBytes;
  final int? sourceBytes;
  final int classCount;

  /// Inclusive load time in microseconds, or null when the module was not
  /// loaded through the timed path (bridged, cache-skipped, or the entry
  /// unit, which the loader reports as `not loaded`).
  final int? loadMicros;
  final int loads;
  final int cacheHits;

  const AstModuleProfile({
    required this.uri,
    required this.package,
    required this.astBytes,
    required this.sourceBytes,
    required this.classCount,
    required this.loadMicros,
    required this.loads,
    required this.cacheHits,
  });
}

/// One interpreted class's AST footprint.
class AstClassProfile {
  final String uri;
  final String name;
  final int astBytes;

  const AstClassProfile({
    required this.uri,
    required this.name,
    required this.astBytes,
  });
}

/// One natively-bridged library touched during evaluation.
class AstBridgedLibProfile {
  final String uri;
  final int symbols;
  final int? loadMicros;

  const AstBridgedLibProfile({
    required this.uri,
    required this.symbols,
    required this.loadMicros,
  });
}

/// One entry of the slowest-load ranking. Covers bundle modules and
/// natively-loaded libraries alike (`dart:io`, bridged barrels), so URIs
/// with no bundle AST report `astBytes: 0`.
class AstSlowModuleProfile {
  final String uri;
  final int loadMicros;
  final int loads;
  final int astBytes;

  const AstSlowModuleProfile({
    required this.uri,
    required this.loadMicros,
    required this.loads,
    required this.astBytes,
  });
}

/// Per-package rollup across [AstProfileSnapshot.modules].
class AstPackageProfile {
  final String package;
  final int modules;
  final int classes;
  final int astBytes;

  const AstPackageProfile({
    required this.package,
    required this.modules,
    required this.classes,
    required this.astBytes,
  });
}

/// Structured, UI-ready snapshot of the last bundle evaluation.
///
/// Pure data — built on demand by [AstInterpreterRunner.lastAstProfile] from
/// the decoded bundle plus the retained per-module timing maps, so opening
/// the AST viewer never pays the `jsonEncode` sizing walk unless asked.
class AstProfileSnapshot {
  final DateTime capturedAt;
  final bool isHotReload;
  final int moduleCount;
  final int totalAstBytes;
  final int totalSourceBytes;
  final bool hasSources;
  final int totalClasses;
  final double? mainMs;

  /// Packages sorted by AST bytes, descending.
  final List<AstPackageProfile> packages;

  /// All bundle modules sorted by AST bytes, descending.
  final List<AstModuleProfile> modules;

  /// Top URIs by inclusive load time (max 10), bundle and native alike.
  final List<AstSlowModuleProfile> slowestModules;

  /// Largest classes by AST bytes (max 50).
  final List<AstClassProfile> largestClasses;

  /// Bridged libraries sorted by symbol count, descending.
  final List<AstBridgedLibProfile> bridgedLibs;

  const AstProfileSnapshot({
    required this.capturedAt,
    required this.isHotReload,
    required this.moduleCount,
    required this.totalAstBytes,
    required this.totalSourceBytes,
    required this.hasSources,
    required this.totalClasses,
    required this.mainMs,
    required this.packages,
    required this.modules,
    required this.slowestModules,
    required this.largestClasses,
    required this.bridgedLibs,
  });
}

/// Derives the explorer grouping key from a module URI.
String astPackageOf(String uri) {
  if (uri.startsWith('package:')) {
    final rest = uri.substring('package:'.length);
    final slash = rest.indexOf('/');
    return slash < 0 ? rest : rest.substring(0, slash);
  }
  if (uri.startsWith('dart:')) return 'dart SDK';
  return 'app';
}

/// Builds an [AstProfileSnapshot] from a decoded bundle and the timing maps
/// the runner retains per evaluation. Sizing walks the AST via `jsonEncode`
/// — call only on demand (viewer open, verbose log), not per evaluation.
AstProfileSnapshot buildAstProfile({
  required ast.AstBundle bundle,
  required Map<String, int> moduleLoadMicros,
  required Map<String, int> moduleLoadCounts,
  required Map<String, int> moduleCacheHits,
  required Map<String, int> bridgedSymbols,
  required int? mainMicros,
  required bool isHotReload,
}) {
  final modules = <AstModuleProfile>[];
  final classProfiles = <AstClassProfile>[];
  var totalAstBytes = 0;
  var totalSourceBytes = 0;
  var totalClasses = 0;

  for (final entry in bundle.modules.entries) {
    final uri = entry.key;
    final unit = entry.value;
    final astBytes = utf8.encode(jsonEncode(unit.toJson())).length;
    totalAstBytes += astBytes;
    final source = bundle.sources?[uri];
    final sourceBytes = source == null ? null : utf8.encode(source).length;
    if (sourceBytes != null) totalSourceBytes += sourceBytes;
    final classes = unit.declarations.whereType<SClassDeclaration>().toList();
    totalClasses += classes.length;
    for (final declaration in classes) {
      final className = declaration.name?.name ?? '(unnamed)';
      classProfiles.add(
        AstClassProfile(
          uri: uri,
          name: className,
          astBytes: utf8.encode(jsonEncode(declaration.toJson())).length,
        ),
      );
    }
    final loadMicros = moduleLoadMicros[uri];
    modules.add(
      AstModuleProfile(
        uri: uri,
        package: astPackageOf(uri),
        astBytes: astBytes,
        sourceBytes: sourceBytes,
        classCount: classes.length,
        loadMicros: loadMicros,
        loads: moduleLoadCounts[uri] ?? 0,
        cacheHits: moduleCacheHits[uri] ?? 0,
      ),
    );
  }

  modules.sort((a, b) => b.astBytes.compareTo(a.astBytes));
  classProfiles.sort((a, b) => b.astBytes.compareTo(a.astBytes));

  final moduleAstBytes = <String, int>{
    for (final m in modules) m.uri: m.astBytes,
  };
  final slowestUris = moduleLoadMicros.keys.toList()
    ..sort((a, b) => moduleLoadMicros[b]!.compareTo(moduleLoadMicros[a]!));
  final slowest = slowestUris.take(10).map((uri) {
    final elapsed = moduleLoadMicros[uri]!;
    return AstSlowModuleProfile(
      uri: uri,
      loadMicros: elapsed,
      loads: moduleLoadCounts[uri] ?? 1,
      astBytes: moduleAstBytes[uri] ?? 0,
    );
  }).toList();

  final bridged = bridgedSymbols.entries
      .map(
        (e) => AstBridgedLibProfile(
          uri: e.key,
          symbols: e.value,
          loadMicros: moduleLoadMicros[e.key],
        ),
      )
      .toList()
    ..sort((a, b) => b.symbols.compareTo(a.symbols));

  final packageAccum = <String, AstPackageProfile>{};
  for (final m in modules) {
    final prev = packageAccum[m.package];
    packageAccum[m.package] = AstPackageProfile(
      package: m.package,
      modules: (prev?.modules ?? 0) + 1,
      classes: (prev?.classes ?? 0) + m.classCount,
      astBytes: (prev?.astBytes ?? 0) + m.astBytes,
    );
  }
  final packages = packageAccum.values.toList()
    ..sort((a, b) => b.astBytes.compareTo(a.astBytes));

  return AstProfileSnapshot(
    capturedAt: DateTime.now(),
    isHotReload: isHotReload,
    moduleCount: bundle.moduleCount,
    totalAstBytes: totalAstBytes,
    totalSourceBytes: totalSourceBytes,
    hasSources: bundle.sources != null,
    totalClasses: totalClasses,
    mainMs: mainMicros == null ? null : mainMicros / 1000,
    packages: packages,
    modules: modules,
    slowestModules: slowest,
    largestClasses: classProfiles.take(50).toList(),
    bridgedLibs: bridged,
  );
}

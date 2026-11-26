/// Discovers icon-font registries via class annotations.
///
/// Two cooperating paths, mirroring the `@ServerComponent` pipeline
/// (`server_annotation_scanner.dart`):
///
/// 1. **Precise** — [IconAnnotationScanner.scanBundle] walks the already
///    parsed `AstBundle` (`SClassDeclaration.metadata`, preserved by the
///    generator's converter) for `@staticIconProvider` (the SDK's marker,
///    already on `CupertinoIcons`/`MaterialSymbols*`), `@StaticIconProvider`
///    and `@IconFont` (the dependency-free annotation in
///    `lib/src/server/icon_font_annotation.dart` for external packages).
///    Zero re-parse cost: it reuses the in-memory bundle.
/// 2. **Cheap pre-scan** — [findAnnotatedClasses] regex-matches the same
///    markers over raw sources (no analyzer parse) for when no bundle
///    exists yet (cold start).
///
/// Recognizing the *declaring* class (instead of regex-matching *usage*
/// sites) is what makes external packages work: the annotation travels
/// with the class, so a widget kit's private icon registry is discovered
/// even when guest code never names a single glyph.
library;

import 'dart:io';

import 'package:tom_ast_model/ast.dart';
import 'package:tom_d4rt_ast/runtime.dart' show AstBundle;

/// An icon-font registry class found via annotation.
class AnnotatedIconFont {
  /// Simple class name (e.g. `CupertinoIcons`, `WeatherIcons`).
  final String className;

  /// Module URI declaring the class (e.g. `package:weather_icons/icons.dart`).
  final String moduleUri;

  /// Owning package (`weather_icons`), derived from [moduleUri].
  final String package;

  /// Font family served under `/fonts/<family>.ttf`. From
  /// `@IconFont(family:)`, a known class alias, else [className].
  final String family;

  /// Explicit `fontAsset` hint from `@IconFont(fontAsset:)`, if any.
  final String? fontAsset;

  const AnnotatedIconFont({
    required this.className,
    required this.moduleUri,
    required this.package,
    required this.family,
    this.fontAsset,
  });

  @override
  String toString() => 'AnnotatedIconFont($className → $family @ $package)';

  @override
  bool operator ==(Object other) =>
      other is AnnotatedIconFont &&
      other.className == className &&
      other.moduleUri == moduleUri;

  @override
  int get hashCode => Object.hash(className, moduleUri);
}

/// Scans parsed bundles and raw sources for annotated icon registries.
class IconAnnotationScanner {
  /// Annotation names we recognize (usage `@x` and type `X` spellings).
  static const annotationNames = {
    'staticIconProvider',
    'StaticIconProvider',
    'IconFont',
  };

  /// Class-name → font-family aliases where the registry class is not
  /// named after its font (e.g. FontAwesome's holder class).
  static const classAliases = {
    'fontawesomeicons': 'FontAwesome5',
    'fontawesome': 'FontAwesome5',
  };

  /// Resolves the served font family for an annotated [className],
  /// preferring an explicit `@IconFont(family:)` value, then [classAliases],
  /// then the class name itself.
  static String familyForClass(String className, {String? explicitFamily}) {
    if (explicitFamily != null && explicitFamily.isNotEmpty) {
      return explicitFamily;
    }
    return classAliases[className.toLowerCase()] ?? className;
  }

  /// Precise scan of an already-parsed [bundle]. Only top-level class
  /// declarations are considered. Never throws (returns empty on
  /// malformed input) so manifest serving stays up.
  static Set<AnnotatedIconFont> scanBundle(
    AstBundle bundle, {
    String defaultPackage = 'guest_app',
  }) {
    final results = <AnnotatedIconFont>{};
    try {
      for (final entry in bundle.modules.entries) {
        final moduleUri = entry.key;
        final unit = entry.value;
        for (final decl in unit.declarations) {
          if (decl is! SClassDeclaration) continue;
          final className = decl.namePart.typeName.name;
          if (className.isEmpty) continue;
          for (final annotation in decl.metadata) {
            final nameIdentifier = annotation.name;
            final name = nameIdentifier is SSimpleIdentifier
                ? nameIdentifier.name
                : null;
            if (name == null || !annotationNames.contains(name)) continue;
            results.add(
              AnnotatedIconFont(
                className: className,
                moduleUri: moduleUri,
                package: _packageOf(moduleUri, defaultPackage),
                family: _familyOf(name, annotation, className),
                fontAsset: name == 'IconFont'
                    ? _namedStringArg(annotation, 'fontAsset')
                    : null,
              ),
            );
            break;
          }
        }
      }
    } catch (_) {}
    return results;
  }

  /// Cheap pre-scan of raw [sources] (module URI → content) for annotated
  /// classes. No analyzer parse — matches `@Marker … class Name` after
  /// stripping comments and strings. Returns module URI → class names.
  /// The bundle scan stays authoritative; this covers cold start.
  static Map<String, Set<String>> findAnnotatedClasses(
    Map<String, String> sources,
  ) {
    final out = <String, Set<String>>{};
    for (final entry in sources.entries) {
      final clean = _stripCommentsAndStrings(entry.value);
      for (final m in _annotatedClassPattern.allMatches(clean)) {
        out.putIfAbsent(entry.key, () => <String>{}).add(m.group(3)!);
      }
    }
    return out;
  }

  /// Best-effort `family:` value from an `@IconFont(family: 'X')` marker
  /// in raw [source] for [className]. Null when absent/unparseable —
  /// callers fall back to the class name.
  ///
  /// Runs on comment-stripped (but string-preserving) source: full
  /// string stripping would erase the family value itself.
  static String? findIconFontFamily(String source, String className) {
    final clean = _stripCommentsOnly(source);
    final pattern = RegExp(
      '@IconFont\\(([^)]*)\\)\\s*(?:(?:abstract|final|sealed|base|interface|mixin)\\s+)*class\\s+${RegExp.escape(className)}\\b',
    );
    final m = pattern.firstMatch(clean);
    if (m == null) return null;
    final args = m.group(1) ?? '';
    // Normal (non-raw) string: quote matching without raw-string pitfalls.
    final fam = RegExp("family\\s*:\\s*['\"]([^'\"]+)['\"]").firstMatch(args);
    return fam?.group(1);
  }

  static final _annotatedClassPattern = RegExp(
    r'@(staticIconProvider|StaticIconProvider|IconFont)'
    r'(\([^)]*\))?'
    r'\s*(?:(?:abstract|final|sealed|base|interface|mixin)\s+)*'
    r'class\s+([A-Za-z0-9_]+)',
  );

  static String _familyOf(
    String annotationName,
    SAnnotation annotation,
    String className,
  ) {
    if (annotationName == 'IconFont') {
      return familyForClass(
        className,
        explicitFamily: _namedStringArg(annotation, 'family'),
      );
    }
    return familyForClass(className);
  }

  static String? _namedStringArg(SAnnotation annotation, String name) {
    final args = annotation.arguments;
    if (args == null) return null;
    for (final arg in args.arguments) {
      if (arg is SNamedArgument) {
        if (arg.name.name == name &&
            arg.argumentExpression is SSimpleStringLiteral) {
          return (arg.argumentExpression as SSimpleStringLiteral).value;
        }
      }
    }
    return null;
  }

  static String _packageOf(String moduleUri, String defaultPackage) {
    try {
      final uri = Uri.parse(moduleUri);
      if (uri.isScheme('package') && uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.first;
      }
    } catch (_) {}
    return defaultPackage;
  }

  static String _stripCommentsOnly(String source) {
    return source
        .replaceAll(RegExp(r'/\*[\s\S]*?\*/'), ' ')
        .replaceAll(RegExp(r'//.*'), ' ');
  }

  static String _stripCommentsAndStrings(String source) {
    return source
        .replaceAll(RegExp(r'/\*[\s\S]*?\*/'), ' ')
        .replaceAll(RegExp(r'//.*'), ' ')
        .replaceAll(RegExp(r"'''[\s\S]*?'''"), "''")
        .replaceAll(RegExp(r'"""[\s\S]*?"""'), '""')
        .replaceAll(RegExp(r"'([^'\\]|\\.)*'"), "''")
        .replaceAll(RegExp(r'"([^"\\]|\\.)*"'), '""');
  }
}

/// Package URIs under which guest code imports the `@IconFont` annotation.
const kIconFontAnnotationUris = {
  'package:dartnative_go/server.dart',
  'package:dartnative_go/src/server/icon_font_annotation.dart',
};

/// Host-relative paths backing [kIconFontAnnotationUris], in the same order.
const _kIconFontAnnotationPaths = [
  'lib/server.dart',
  'lib/src/server/icon_font_annotation.dart',
];

/// Reads the real `@IconFont` annotation sources for implicit bundler
/// injection (same mechanism as [serverAnnotationSources], kept separate
/// so the server-component parity guard is unaffected).
///
/// Merge into the bundler's `explicitSources` wherever
/// `serverAnnotationSources()` is spread, so guest `import
/// 'package:dartnative_go/server.dart'` resolves even though
/// `package:dartnative_go` is otherwise skipped.
Map<String, String> iconFontAnnotationSources() {
  final root = _dartnativeGoRoot();
  if (root == null) return const {};
  final sources = <String, String>{};
  for (var i = 0; i < _kIconFontAnnotationPaths.length; i++) {
    final file = File('${root.path}/${_kIconFontAnnotationPaths[i]}');
    try {
      if (!file.existsSync()) return const {};
      sources[kIconFontAnnotationUris.elementAt(i)] = file.readAsStringSync();
    } catch (_) {
      return const {};
    }
  }
  return sources;
}

/// Walks up from the running script to the `dartnative_go` package root.
Directory? _dartnativeGoRoot() {
  try {
    var dir = Directory.fromUri(Platform.script.resolve('.'));
    while (true) {
      final pubspec = File('${dir.path}/pubspec.yaml');
      if (pubspec.existsSync()) {
        try {
          for (final line in pubspec.readAsLinesSync()) {
            if (line.trim() == 'name: dartnative_go') return dir;
          }
        } catch (_) {}
      }
      final parent = dir.parent;
      if (parent.path == dir.path) return null;
      dir = parent;
    }
  } catch (_) {
    return null;
  }
}

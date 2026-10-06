/// Scans parsed AST modules for `@ServerComponent` and `@Server` annotations.
///
/// Used by the bundler to discover server component entry points and by
/// the delta bundler to determine chunk boundaries.
library;

import 'package:tom_ast_model/ast.dart';
import 'package:tom_d4rt_ast/runtime.dart' show AstBundle;

/// A single annotated server component discovered in a parsed module.
class AnnotatedComponent {
  /// The simple class name (e.g. `ProfileCard`).
  final String className;

  /// The module URI where this class is declared
  /// (e.g. `package:myapp/profile_card.dart`).
  final String moduleUri;

  /// The `id` value from the `@ServerComponent` or `@Server` annotation,
  /// or [className] if no explicit id was provided.
  final String componentId;

  /// The `version` value from the annotation (defaults to 1).
  final int version;

  const AnnotatedComponent({
    required this.className,
    required this.moduleUri,
    required this.componentId,
    this.version = 1,
  });

  @override
  bool operator ==(Object other) =>
      other is AnnotatedComponent &&
      other.className == className &&
      other.moduleUri == moduleUri;

  @override
  int get hashCode => Object.hash(className, moduleUri);
}

/// Scans AST bundles for `@ServerComponent` and `@Server` annotations.
class ServerAnnotationScanner {
  /// Annotation names we recognize.
  static const _kAnnotationNames = {'ServerComponent', 'Server'};

  /// Scans every module in [bundle] and returns a set of annotated components.
  ///
  /// Only top-level class declarations are considered. Enum, mixin, and
  /// extension annotations are ignored.
  static Set<AnnotatedComponent> scanBundle(AstBundle bundle) {
    final results = <AnnotatedComponent>{};
    for (final entry in bundle.modules.entries) {
      final moduleUri = entry.key;
      final unit = entry.value;
      for (final decl in unit.declarations) {
        if (decl is! SClassDeclaration) continue;
        for (final annotation in decl.metadata) {
          final annotationName = annotation.name?.name;
          if (annotationName == null) continue;
          if (!_kAnnotationNames.contains(annotationName)) continue;

          final className = decl.name?.name ?? '';
          if (className.isEmpty) continue;

          // Extract the `id` argument from annotation constructor arguments.
          final componentId = _extractId(annotation, className);

          // Extract the `version` argument.
          final version = _extractVersion(annotation);

          results.add(AnnotatedComponent(
            className: className,
            moduleUri: moduleUri,
            componentId: componentId,
            version: version,
          ));
        }
      }
    }
    return results;
  }

  /// Extracts the `id` value from a `@ServerComponent(id: 'foo')` annotation.
  ///
  /// Falls back to [fallback] when no `id` argument is present.
  static String _extractId(SAnnotation annotation, String fallback) {
    final args = annotation.arguments;
    if (args == null) return fallback;

    // Walk the argument list looking for a named argument `id:` or a
    // positional first argument.
    for (final arg in args.arguments) {
      if (arg is SNamedExpression) {
        final label = arg.name?.name;
        if (label == 'id') {
          final expr = arg.expression;
          if (expr is SSimpleStringLiteral) {
            return expr.value ?? fallback;
          }
        }
      }
    }

    // If no named `id:` argument, try the first positional argument.
    if (args.arguments.isNotEmpty) {
      final first = args.arguments.first;
      if (first is SSimpleStringLiteral) {
        return first.value ?? fallback;
      }
    }

    return fallback;
  }

  /// Extracts the `version` value from the annotation, defaulting to 1.
  static int _extractVersion(SAnnotation annotation) {
    final args = annotation.arguments;
    if (args == null) return 1;

    for (final arg in args.arguments) {
      if (arg is SNamedExpression) {
        final label = arg.name?.name;
        if (label == 'version') {
          final expr = arg.expression;
          if (expr is SIntegerLiteral) {
            return expr.value;
          }
        }
      }
    }

    return 1;
  }
}

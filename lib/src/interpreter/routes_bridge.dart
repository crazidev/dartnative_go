/// Host-side `registerRoutes` bridge for both interpreter engines.
///
/// `registerRoutes(Map<String, WidgetBuilder>)` is a *native-binding* call in
/// `package:dartnative`: on the host VM the framework's stub throws
/// `UnimplementedError`, so any guest whose `main()` registers named routes
/// (the upstream playground registers ~50) cannot boot headless at all.
///
/// Two problems solved here:
///
/// 1. **No native side.** The routes are captured host-side instead of
///    forwarded, so the entrypoint completes and the dev tooling can replay a
///    named route (`D4rtRoutes.routes`).
/// 2. **Typed-map coercion.** The generated bridge asks for
///    `Map<String, WidgetBuilder>`; a guest map literal arrives as
///    `_Map<Object?, Object?>` whose values are *interpreted functions*, which
///    no `Map` relaxer can turn into native `Widget Function(BuildContext)`
///    closures. Each value is wrapped into a real closure here instead, so the
///    route table is usable (not merely stored).
library;

import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt/tom_d4rt.dart' as src;
import 'package:tom_d4rt_ast/d4rt.dart' as ast;

import 'ast/ast_widget_proxies.dart' as ast_proxies;
import 'dn_bridge.dart' show unwrap;

/// The named routes the running guest registered, keyed by path.
///
/// Cleared on every fresh evaluation (`reset`) so a hot restart does not keep
/// routes from the previous generation.
abstract final class D4rtRoutes {
  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{};

  /// Forgets every route. Call before evaluating a new generation.
  static void reset() => routes.clear();

  static List<String> get paths => routes.keys.toList(growable: false);
}

/// Builds a native [WidgetBuilder] from an interpreted builder closure.
WidgetBuilder _sourceBuilder(Object? raw, src.InterpreterVisitor visitor) {
  return (BuildContext context) {
    final built = src.D4.callInterpreterCallback(visitor, raw, [context]);
    final widget = unwrap<Widget>(built, visitor: visitor);
    if (widget == null) {
      throw StateError(
        'registerRoutes: route builder returned ${built.runtimeType}, '
        'not a Widget',
      );
    }
    return widget;
  };
}

/// AST counterpart of [_sourceBuilder].
WidgetBuilder _astBuilder(Object? raw, ast.InterpreterVisitor visitor) {
  return (BuildContext context) {
    final built = ast.D4.callInterpreterCallback(visitor, raw, [context]);
    final widget = ast_proxies.wrapAstInterpretedWidget(built, visitor: visitor);
    if (widget == null) {
      throw StateError(
        'registerRoutes: route builder returned ${built.runtimeType}, '
        'not a Widget',
      );
    }
    return widget;
  };
}

/// Source-engine `registerRoutes` implementation.
void registerRoutesSource(
  src.InterpreterVisitor visitor,
  List<Object?> positional,
) {
  final raw = positional.isNotEmpty ? positional[0] : null;
  if (raw is! Map) return;
  raw.forEach((key, value) {
    if (key is! String || value == null) return;
    D4rtRoutes.routes[key] = _sourceBuilder(value, visitor);
  });
}

/// AST-engine `registerRoutes` implementation.
void registerRoutesAst(
  ast.InterpreterVisitor visitor,
  List<Object?> positional,
) {
  final raw = positional.isNotEmpty ? positional[0] : null;
  if (raw is! Map) return;
  raw.forEach((key, value) {
    if (key is! String || value == null) return;
    D4rtRoutes.routes[key] = _astBuilder(value, visitor);
  });
}

/// Libraries `registerRoutes` is declared in (the generated bridge registers
/// the same symbol; the host override wins by registering last).
const kRegisterRoutesLibraries = <String>[
  'package:dartnative/dartnative.dart',
  'package:dartnative/src/framework.dart',
  'package:dartnative/flutter_compat.dart',
];

/// `void registerRoutes(Map<String, WidgetBuilder> routes)`
const kRegisterRoutesSignature =
    'void registerRoutes(Map<String, WidgetBuilder> routes)';

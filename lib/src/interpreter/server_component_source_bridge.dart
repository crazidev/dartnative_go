import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt/tom_d4rt.dart';

import '../widgets/server_component_loader.dart';
import '../widgets/server_component_view.dart';
import 'ast/server_component_bridge.dart' show kServerComponentBridgeUri;

/// Registers the host [ServerComponentView] on the source (`tom_d4rt`)
/// engine, mirroring `registerServerComponentBridge` on the AST engine.
///
/// Without this, a guest that imports `package:dartnative_go/server_component.dart`
/// fails with "Package module source not preloaded" whenever it runs in source
/// mode (e.g. no `/guest.ast` on the dev server, so `InterpreterRunner` falls
/// back to source).
///
/// Components are AST delta bundles, so [loaderProvider] must return a loader
/// whose runner is an `AstInterpreterRunner`; the mounted view is wired to it
/// the same way the AST bridge wires it.
void registerSourceServerComponentBridge(
  D4rt interpreter, {
  required ServerComponentLoader Function() loaderProvider,
}) {
  final bridge = BridgedClass(
    nativeType: ServerComponentView,
    name: 'ServerComponentView',
    isAssignable: (v) => v is ServerComponentView,
    constructors: {
      '': (visitor, positional, named) {
        final componentId = D4.getRequiredNamedArg<String>(
          named,
          'componentId',
          'ServerComponentView',
        );
        final props = D4.coerceMapOrNull<String, dynamic>(
          named['props'],
          'props',
        );
        final fallbackComponentId = D4.getOptionalNamedArg<String?>(
          named,
          'fallbackComponentId',
        );
        final key = D4.getOptionalNamedArg<Key?>(named, 'key');
        final fallback = D4.extractBridgedArgOrNull<Widget>(
          named['fallback'],
          'fallback',
          visitor,
        );
        final loadingRaw = named['loadingBuilder'];
        final loadingBuilder = loadingRaw == null
            ? null
            : (BuildContext context) => D4.extractBridgedArg<Widget>(
                D4.callInterpreterCallback(visitor, loadingRaw, [context]),
                'loadingBuilder',
                visitor,
              );
        final errorRaw = named['errorBuilder'];
        final errorBuilder = errorRaw == null
            ? null
            : (Object error) => D4.extractBridgedArg<Widget>(
                D4.callInterpreterCallback(visitor, errorRaw, [error]),
                'errorBuilder',
                visitor,
              );
        final loader = loaderProvider();
        return ServerComponentView(
          key: key,
          componentId: componentId,
          props: props,
          fallbackComponentId: fallbackComponentId,
          fallback: fallback,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
          runner: loader.runner,
          loadComponent: loader.loadComponent,
        );
      },
    },
    constructorSignatures: {
      '': 'ServerComponentView({required String componentId, Map<String, dynamic>? props, String? fallbackComponentId, Widget? fallback, Widget Function(BuildContext)? loadingBuilder, Widget Function(Object)? errorBuilder, Key? key})',
    },
    getters: {
      'componentId': (visitor, target) => D4
          .validateTarget<ServerComponentView>(
            target,
            'ServerComponentView',
          )
          .componentId,
      'props': (visitor, target) => D4
          .validateTarget<ServerComponentView>(
            target,
            'ServerComponentView',
          )
          .props,
    },
    getterSignatures: {
      'componentId': 'String get componentId',
      'props': 'Map<String, dynamic>? get props',
    },
  );
  BridgedClass.registerSupertypes({
    'ServerComponentView': ['StatefulWidget', 'Widget'],
  });
  interpreter.registerBridgedClass(bridge, kServerComponentBridgeUri);
}

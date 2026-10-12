import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

import '../../widgets/server_component_loader.dart';
import '../../widgets/server_component_view.dart';

/// Guest-visible URI for [ServerComponentView]. The bundler skips this
/// library (see `kAstBridgedLibraries`) — it is never parsed into a bundle.
/// At runtime this bridge supplies it, so guest code writes:
///
/// ```dart
/// import 'package:dartnative_go/server_component.dart';
///
/// ServerComponentView(componentId: 'demo_card', props: {'userId': 7})
/// ```
const kServerComponentBridgeUri = 'package:dartnative_go/server_component.dart';

/// Registers the host [ServerComponentView] as a bridged widget on the
/// analyzer-free runtime, so interpreted guest code can mount server
/// components declaratively — the same class the host mounts directly.
///
/// Guest-meaningful constructor parameters are bridged (`componentId`,
/// `props`, `fallbackComponentId`, `fallback`, `loadingBuilder`,
/// `errorBuilder`, `key`). Interpreted builder closures are invoked through
/// `D4.callInterpreterCallback` on the evaluating visitor. Native-only
/// parameters (`runner`, `loadComponent`) are NOT bridged: the adapter wires
/// [loader] (fetch) and its runner (shared interpreter) itself.
///
/// Call once per runner before the first execution — `AstInterpreterRunner`
/// does this in `initRunner`, alongside the other hand-written bridges.
void registerServerComponentBridge(
  ast.D4rtRunner runner, {
  required ServerComponentLoader loader,
}) {
  final bridge = ast.BridgedClass(
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
      '':
          'ServerComponentView({required String componentId, Map<String, dynamic>? props, String? fallbackComponentId, Widget? fallback, Widget Function(BuildContext)? loadingBuilder, Widget Function(Object)? errorBuilder, Key? key})',
    },
    getters: {
      'componentId': (visitor, target) =>
          D4.validateTarget<ServerComponentView>(
            target,
            'ServerComponentView',
          ).componentId,
      'props': (visitor, target) =>
          D4.validateTarget<ServerComponentView>(
            target,
            'ServerComponentView',
          ).props,
    },
    getterSignatures: {
      'componentId': 'String get componentId',
      'props': 'Map<String, dynamic>? get props',
    },
  );
  ast.BridgedClass.registerSupertypes({
    'ServerComponentView': ['StatefulWidget', 'Widget'],
  });
  runner.registerBridgedClass(
    bridge,
    kServerComponentBridgeUri,
    sourceUri: kServerComponentBridgeUri,
  );
}

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
/// Only guest-meaningful constructor parameters are bridged
/// (`componentId`, `props`, `fallbackComponentId`, `key`). Native-only
/// parameters (`runner`, `loadComponent`) and function-typed UI hooks
/// (`loadingBuilder`, `errorBuilder`) are intentionally NOT bridged:
/// the adapter wires [loader] (fetch) and its runner (shared interpreter)
/// itself, and loading/error UI falls back to the view defaults.
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
        return ServerComponentView(
          key: key,
          componentId: componentId,
          props: props,
          fallbackComponentId: fallbackComponentId,
          runner: loader.runner,
          loadComponent: loader.loadComponent,
        );
      },
    },
    constructorSignatures: {
      '':
          'ServerComponentView({required String componentId, Map<String, dynamic>? props, String? fallbackComponentId, Key? key})',
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

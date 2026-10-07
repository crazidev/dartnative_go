import 'package:dartnative/dartnative.dart' show Widget;
import 'package:dartnative_go/src/cli/server_annotation_scanner.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/widgets/server_component_view.dart'
    show mountServerComponent;
import 'package:tom_d4rt_ast/runtime.dart' as ast;

/// Headless test harness for `@ServerComponent` loading.
///
/// Mirrors [DnHarness] but specializes in component flows: a client bundle is
/// pre-loaded once (no `main()` is run), then per-component delta bundles are
/// merged into the same live interpreter. No HTTP, no dev server, no device —
/// bundles are passed in-memory as [ast.AstBundle] objects.
///
/// ```dart
/// final harness = ServerComponentHarness();
/// await harness.loadClientBundle(project.clientBundle);
/// final cls = await harness.loadComponent(
///   componentId: 'profile_card',
///   componentBundle: project.componentBundles['profile_card']!,
/// );
/// expect(cls, isNotNull);
/// final widget = harness.mountComponent('profile_card', props: {'userId': 7});
/// expect(widget, isNotNull);
/// ```
class ServerComponentHarness {
  final AstInterpreterRunner runner;

  /// Component id → annotated class name, learned from each loaded bundle.
  /// Ids and class names usually differ (`profile_card` vs `ProfileCard`).
  final Map<String, String> _componentClassNames = {};

  ServerComponentHarness({AstInterpreterRunner? runner})
      : runner = runner ?? AstInterpreterRunner();

  /// Pre-loads the client bundle's modules without running any entry point.
  Future<void> loadClientBundle(
    ast.AstBundle clientBundle, {
    Map<String, String> moduleFingerprints = const {},
  }) {
    return runner.preloadBundle(
      clientBundle.toBytes(),
      moduleFingerprints: moduleFingerprints,
    );
  }

  /// Loads one server-component delta bundle and resolves its class.
  Future<ast.InterpretedClass?> loadComponent({
    required String componentId,
    required ast.AstBundle componentBundle,
  }) {
    for (final component in ServerAnnotationScanner.scanBundle(
      componentBundle,
    )) {
      if (component.componentId == componentId) {
        _componentClassNames[componentId] = component.className;
      }
    }
    return runner.loadServerComponent(
      componentId: componentId,
      astBytes: componentBundle.toBytes(),
    );
  }

  /// Instantiates an already-loaded component as a native [Widget].
  ///
  /// Returns null when [componentId] does not resolve or the instance
  /// cannot be wrapped (see [mountServerComponent]).
  Widget? mountComponent(
    String componentId, {
    Map<String, dynamic>? props,
  }) {
    final cls = runner.resolveTopLevel(
      _componentClassNames[componentId] ?? componentId,
    );
    if (cls == null) return null;
    return mountServerComponent(runner: runner, cls: cls, props: props);
  }

  void dispose() => runner.dispose();
}

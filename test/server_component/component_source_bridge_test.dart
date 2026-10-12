import 'package:dartnative/dartnative.dart' show BuildContext, Text, Widget;
import 'package:dartnative_go/src/runner/interpreter_runner.dart';
import 'package:dartnative_go/src/widgets/server_component_view.dart';
import 'package:test/test.dart';

/// Stand-in context: the guest builder ignores its argument, and no widget
/// tree exists under `dn test`.
class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Regression: the source engine (`useAst: false`, also the fallback when no
/// `/guest.ast` exists) must provide `package:dartnative_go/server_component.dart`
/// instead of failing with "Package module source not preloaded".
void main() {
  test('source engine resolves the server_component import to the host view',
      () async {
    final runner = InterpreterRunner(useAst: false);
    addTearDown(runner.unmount);

    const entry = 'package:example/main.dart';
    const source = "import 'package:dartnative/dartnative.dart';\n"
        "import 'package:dartnative_go/server_component.dart';\n"
        'void main() {\n'
        "  runApp(ServerComponentView(componentId: 'profile_card', "
        "props: {'userId': 7}));\n"
        '}\n';

    final widget = await runner.evaluate(
      library: entry,
      source: source,
      sources: {entry: source},
    );

    expect(widget, isA<Widget>());
    expect(widget, isA<ServerComponentView>());
    final view = widget as ServerComponentView;
    expect(view.componentId, equals('profile_card'));
    expect(view.props, equals({'userId': 7}));
    expect(view.loadComponent, isNotNull);
  });

  test('interpreted fallback and builder callbacks reach the host view',
      () async {
    final runner = InterpreterRunner(useAst: false);
    addTearDown(runner.unmount);

    const entry = 'package:example/main.dart';
    const source = "import 'package:dartnative/dartnative.dart';\n"
        "import 'package:dartnative_go/server_component.dart';\n"
        'void main() {\n'
        '  runApp(ServerComponentView(\n'
        "    componentId: 'profile_card',\n"
        "    fallback: Text('fallback'),\n"
        "    loadingBuilder: (context) => Text('loading'),\n"
        "    errorBuilder: (error) => Text('error'),\n"
        '  ));\n'
        '}\n';

    final widget = await runner.evaluate(
      library: entry,
      source: source,
      sources: {entry: source},
    ) as ServerComponentView;

    expect((widget.fallback as Text).data, equals('fallback'));
    // Invoke the interpreted closures from the host, as the view does.
    expect(
      ((widget.loadingBuilder!)(_FakeContext()) as Text).data,
      equals('loading'),
    );
    expect(
      ((widget.errorBuilder!)(StateError('boom')) as Text).data,
      equals('error'),
    );
  });
}

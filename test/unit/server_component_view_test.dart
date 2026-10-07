import 'package:dartnative/dartnative.dart' show Text;
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/widgets/server_component_view.dart';
import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

void main() {
  group('ServerComponentView', () {
    test('stores componentId, props, fallback and loader', () async {
      Future<ast.InterpretedClass?> loader(String id) async => null;
      final widget = ServerComponentView(
        componentId: 'profile_card',
        props: const {'userId': 7},
        fallback: const Text('loading'),
        fallbackComponentId: 'profile_card_static',
        loadComponent: loader,
      );
      expect(widget.componentId, equals('profile_card'));
      expect(widget.props, equals({'userId': 7}));
      expect(widget.fallback, isA<Text>());
      expect(widget.fallbackComponentId, equals('profile_card_static'));
      expect(widget.loadComponent, isNotNull);
      expect(widget.loadingBuilder, isNull);
    });

    test('loadingBuilder is stored when provided', () {
      final widget = ServerComponentView(
        componentId: 'profile_card',
        loadingBuilder: (context) => const Text('busy'),
      );
      expect(widget.loadingBuilder, isNotNull);
      expect(widget.fallback, isNull);
    });

    test('mountServerComponent returns null without a live visitor', () {
      // A fresh runner never initialized has no visitor — mounting must
      // fail closed (null) instead of throwing, so the widget can render
      // its error/fallback UI.
      final runner = AstInterpreterRunner();
      addTearDown(runner.dispose);
      expect(runner.visitor, isNull);
      final fakeBundle = _FakeClass();
      expect(
        mountServerComponent(
          runner: runner,
          cls: fakeBundle,
          props: const {'userId': 1},
        ),
        isNull,
      );
    });
  });
}

/// Minimal [ast.InterpretedClass] stand-in: only used on paths that return
/// before touching the class (no visitor → null).
class _FakeClass implements ast.InterpretedClass {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

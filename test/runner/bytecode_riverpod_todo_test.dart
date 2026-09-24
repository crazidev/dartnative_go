import 'dart:io';
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/cli/bytecode_emitter.dart';
import 'package:dartnative_go/src/runner/bytecode/bytecode_widget_proxies.dart';
import 'package:dartnative_go/src/runner/bytecode/call_frame.dart';
import 'package:dartnative_go/src/runner/bytecode_interpreter_runner.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:riverpod_kit/src/widget_ref.dart';
import 'package:test/test.dart';

import '../test_lab/fixtures/riverpod_fixture.dart';

/// The Bytecode engine is disabled by default (`kBytecodeEnabled`). Re-enable it
/// for a run with `--dart-define=DN_ENABLE_BYTECODE=true`.
const _bytecodeEnabled = bool.fromEnvironment('DN_ENABLE_BYTECODE');
String get _bytecodeSkipReason =>
    'Bytecode engine disabled — re-run with '
    '--dart-define=DN_ENABLE_BYTECODE=true';

void main() {
  group('Bytecode Riverpod Notifier & Global Provider Test', () {
    test('Top-level provider initialization and Notifier state updates', () async {
      final projectDir = Directory('example');
      if (!projectDir.existsSync()) return;

      // 1. Build AST & Bytecode Bundle for example
      final buildResult = await buildGuestAstBundle(
        projectDir,
        packageArg: 'example',
        force: true,
      );
      expect(buildResult.success, isTrue, reason: buildResult.error);

      final bcFile = File('example/assets/bundles/guest.bc');
      expect(bcFile.existsSync(), isTrue);

      final bundleBytes = await bcFile.readAsBytes();
      expect(bundleBytes.isNotEmpty, isTrue);

      // 2. Evaluate bundle
      final runner = BytecodeInterpreterRunner();
      final widget = await runner.evaluateBytecodeBundle(bundleBytes);
      expect(widget, isNotNull);

      // 3. Verify globals
      final todoProvider = runner.vm.globals['todoProvider'];
      expect(todoProvider, isNotNull, reason: 'todoProvider should be present in globals');
      expect(todoProvider, isA<NotifierProvider>());

      // 4. Test ProviderContainer resolution
      final container = ProviderContainer();
      final todos = container.read(todoProvider as NotifierProvider<dynamic, dynamic>);
      expect(todos, isA<List>());
      expect((todos as List).isEmpty, isTrue);

      // 5. Read notifier and verify instance
      final notifier = container.read((todoProvider as dynamic).notifier);
      expect(notifier, isNotNull);
      expect(notifier, isA<BytecodeNotifierProxy>());

      final proxy = notifier as BytecodeNotifierProxy;
      expect(proxy.instance.bytecodeClass.name, 'TodoNotifier');

      // 6. Invoke addTodo on notifier
      runner.vm.executeFunction(
        funcId: proxy.instance.bytecodeClass.methodFuncIds['addTodo']!,
        namedArgs: {
          'title': 'Test Todo',
          'description': 'Testing bytecode riverpod',
          'color': const Color(0xFFFFF3A3),
        },
        thisTarget: proxy.instance,
      );

      // 7. Verify container state updated through Riverpod
      final updatedTodos = container.read(todoProvider as NotifierProvider<dynamic, dynamic>) as List;
      expect(updatedTodos.length, 1);
      final firstTodo = updatedTodos[0] as BytecodeInstance;
      expect(firstTodo.fields['title'], 'Test Todo');
      expect(firstTodo.fields['description'], 'Testing bytecode riverpod');
    });
  },
  skip: _bytecodeEnabled ? false : _bytecodeSkipReason,
);
}

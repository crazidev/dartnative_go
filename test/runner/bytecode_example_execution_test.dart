import 'dart:io';
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/runner/bytecode/bytecode_widget_proxies.dart';
import 'package:dartnative_go/src/runner/bytecode_interpreter_runner.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:test/test.dart';

import '../test_lab/fixtures/riverpod_fixture.dart';

void main() {
  group('Bytecode Example App Execution Test', () {
    test('Compiles example app AST & bytecode and executes without blank screen', () async {
      final projectDir = Directory('example');
      if (!projectDir.existsSync()) return;

      // 1. Build AST & Bytecode Bundle
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

      // 2. Initialize BytecodeInterpreterRunner and evaluate
      final runner = BytecodeInterpreterRunner();

      final widget = await runner.evaluateBytecodeBundle(bundleBytes);
      expect(widget, isNotNull, reason: 'evaluated bytecode root widget must not be null');
      expect(runner.vm.bridgeAdapter.capturedApp, isNotNull, reason: 'capturedApp must not be null');

      // 3. Verify widget and globals execution
      if (widget is ProviderScope) {
        expect(widget.child, isA<BytecodeConsumerStatefulWidget>());
        final consumerWidget = widget.child as BytecodeConsumerStatefulWidget;
        expect(consumerWidget.instance.bytecodeClass.name, 'TodoScreen');
        expect(runner.vm.globals['todoProvider'], isNotNull,
            reason: 'todoProvider must be initialized in VM globals');
      } else if (widget is BytecodeStatefulWidget) {
        final state = widget.createState() as BytecodeStateProxy;
        expect(state.stateInstance.fields['currentIndex'], 0);

        final builtTree = state.build(FakeBuildContext());
        expect(builtTree, isA<Scaffold>());
        final scaffold = builtTree as Scaffold;
        expect(scaffold.body, isA<Column>());
        final column = scaffold.body as Column;
        expect(column.children.length, 3);

        final button = column.children[2] as Button;
        expect(button.onPressed, isNotNull);

        // Trigger button callback:
        button.onPressed!();
        expect(state.stateInstance.fields['currentIndex'], 1);
      }
    });
  });
}


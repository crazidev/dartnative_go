import 'dart:io';
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/runner/bytecode/bytecode_widget_proxies.dart';
import 'package:dartnative_go/src/runner/bytecode_interpreter_runner.dart';
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

      // 3. Verify StatefulWidget and State execution
      expect(widget, isA<BytecodeStatefulWidget>());
      final stateful = widget as BytecodeStatefulWidget;
      final state = stateful.createState() as BytecodeStateProxy;
      expect(state.stateInstance.fields['isLoggedIn'], isFalse);

      final builtTree = state.build(FakeBuildContext());
      expect(builtTree, isA<Scaffold>());
      final scaffold = builtTree as Scaffold;
      expect(scaffold.body, isA<Column>());
      final column = scaffold.body as Column;
      expect(column.children.length, 2);

      final button = column.children[1] as Button;
      expect(button.onPressed, isNotNull);

      // Trigger button callback:
      button.onPressed!();
      expect(state.stateInstance.fields['isLoggedIn'], isTrue);
    });
  });
}


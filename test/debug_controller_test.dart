import 'dart:async';
import 'package:dartnative_go/src/interpreter/auto_import_parser.dart';
import 'package:dartnative_go/src/interpreter/debug_controller.dart';
import 'package:tom_d4rt/d4rt.dart';

Future<void> main() async {
  print('Running DebugController & Breakpoint tests...\n');

  final controller = DebugController();
  controller.reset();

  try {

  // 1. Breakpoint Registration
  controller.addBreakpoint('guest_app/reset_button.dart', 27);
  assert(controller.hasBreakpoint('reset_button.dart', 27), 'Should find normalized breakpoint');
  assert(controller.hasBreakpoint('guest_app/reset_button.dart', 27), 'Should find full path breakpoint');
  assert(controller.getBreakpointLinesForFile('reset_button.dart').contains(27), 'Should contain line 27');

  controller.removeBreakpoint('reset_button.dart', 27);
  assert(!controller.hasBreakpoint('reset_button.dart', 27), 'Breakpoint should be removed');

  controller.setBreakpoints([
    {'file': 'main.dart', 'line': 15},
    {'file': 'reset_button.dart', 'line': 30},
  ]);
  assert(controller.breakpoints.length == 2, 'Should have 2 breakpoints set');
  assert(controller.hasBreakpoint('main.dart', 15), 'Should have main.dart:15');
  print('✓ Test 1 passed: Breakpoint CRUD & normalization');

  // 2. Programmatic debugger() call & environment introspection
  final interpreter = D4rt();
  interpreter.execute(source: '''
var testCounter = 99;
void main() {
  testCounter = 100;
}
''');
  controller.activeInterpreter = interpreter;

  BreakpointHitEvent? capturedEvent;
  controller.onBreakpointHit = (event) {
    capturedEvent = event;
  };

  await controller.handleDebuggerCall('Checking counter value');
  assert(capturedEvent != null, 'Breakpoint hit event must be emitted');
  assert(capturedEvent!.message == 'Checking counter value', 'Message should match');
  assert(capturedEvent!.variables.containsKey('testCounter'), 'Variables must include testCounter');
  print('✓ Test 2 passed: handleDebuggerCall & variable snapshotting');

  // 3. Line breakpoint hit & counter
  controller.clearBreakpoints();
  controller.addBreakpoint('reset_button.dart', 27);

  await controller.handleLineBreakpoint('reset_button.dart', 27);
  assert(capturedEvent != null && capturedEvent!.file == 'reset_button.dart');
  assert(capturedEvent!.line == 27);
  final bp = controller.breakpoints.firstWhere((b) => b.line == 27);
  assert(bp.hitCount == 1, 'Hit count should be 1');

  await controller.handleLineBreakpoint('reset_button.dart', 27);
  assert(bp.hitCount == 2, 'Hit count should be 2');
  print('✓ Test 3 passed: handleLineBreakpoint & hit counting');

  // 4. Execution pause & resume flow
  controller.pauseOnHit = true;
  var resumed = false;
  final future = controller.handleDebuggerCall('Pausing for test').then((_) {
    resumed = true;
  });

  assert(controller.isPaused, 'Controller should report isPaused == true');
  assert(!resumed, 'Execution should be suspended');

  controller.resume();
  await future.timeout(
    const Duration(seconds: 2),
    onTimeout: () => throw TimeoutException('Resume did not unblock in time'),
  );
  controller.pauseOnHit = false;
  assert(!controller.isPaused, 'Controller should report isPaused == false');
  assert(resumed, 'Execution should have resumed');
  print('✓ Test 4 passed: Pause and resume completion flow');

  // 5. Breakpoint instrumentation in AutoImportParser
  const source = '''void main() {
  print("Hello");
  print("World");
}''';

  final instrumented = AutoImportParser.instrumentBreakpoints(
    source,
    'main.dart',
    {2},
  );

  final lines = instrumented.split('\n');
  assert(lines.length == 4, 'Line count must be preserved (was ${lines.length})');
  assert(
    lines[1].contains("await __debugBreakpoint('main.dart', 2); print(\"Hello\");"),
    'Line 2 must contain injected breakpoint call',
  );
  print('✓ Test 5 passed: Source line instrumentation preserves line numbering');

  // 6. Virtual Source Map instrumentation
  final raw = {
    'reset_button.dart': '''class ResetButton {
  void reset() {
    print("reset");
  }
}''',
  };

  final vMap = AutoImportParser.buildVirtualSourceMap(
    raw,
    breakpointsByFile: {
      'reset_button.dart': {3},
    },
  );

  final code = vMap['reset_button.dart']!;
  assert(
    code.contains("await __debugBreakpoint('reset_button.dart', 3);"),
    'Virtual source map must contain instrumented breakpoint',
  );
  print('✓ Test 6 passed: buildVirtualSourceMap breakpoint instrumentation');

    print('\n🎉 All 6 DebugController & Breakpoint tests passed successfully!');
  } finally {
    controller.reset();
  }
}

import 'dart:async';

import 'package:dartnative_go/src/interpreter/auto_import_parser.dart';
import 'package:dartnative_go/src/interpreter/breakpoint_instrumenter.dart';
import 'package:dartnative_go/src/interpreter/debug_controller.dart';
import 'package:test/test.dart';
import 'package:tom_d4rt/d4rt.dart';

void main() {
  group('DebugController & Breakpoints', () {
    late DebugController controller;

    setUp(() {
      controller = DebugController();
      controller.reset();
    });

    tearDown(() {
      controller.reset();
    });

    test('breakpoint CRUD with path normalization', () {
      controller.addBreakpoint('guest_app/reset_button.dart', 27);
      expect(controller.hasBreakpoint('reset_button.dart', 27), isTrue);
      expect(
        controller.hasBreakpoint('guest_app/reset_button.dart', 27),
        isTrue,
      );
      expect(
        controller.getBreakpointLinesForFile('reset_button.dart'),
        contains(27),
      );

      controller.removeBreakpoint('reset_button.dart', 27);
      expect(controller.hasBreakpoint('reset_button.dart', 27), isFalse);

      controller.setBreakpoints([
        {'file': 'main.dart', 'line': 15},
        {'file': 'reset_button.dart', 'line': 30},
      ]);
      expect(controller.breakpoints, hasLength(2));
      expect(controller.hasBreakpoint('main.dart', 15), isTrue);
    });

    test('programmatic debugger() snapshots variables', () async {
      final interpreter = D4rt();
      interpreter.execute(
        source: '''
var testCounter = 99;
void main() {
  testCounter = 100;
}
''',
      );
      controller.activeInterpreter = interpreter;

      BreakpointHitEvent? capturedEvent;
      controller.onBreakpointHit = (event) => capturedEvent = event;

      await controller.handleDebuggerCall('Checking counter value');
      expect(capturedEvent, isNotNull);
      expect(capturedEvent!.message, equals('Checking counter value'));
      expect(capturedEvent!.variables, contains('testCounter'));
    });

    test('line breakpoints count hits', () async {
      BreakpointHitEvent? capturedEvent;
      controller.onBreakpointHit = (event) => capturedEvent = event;

      controller.clearBreakpoints();
      controller.addBreakpoint('reset_button.dart', 27);

      await controller.handleLineBreakpoint('reset_button.dart', 27);
      expect(capturedEvent, isNotNull);
      expect(capturedEvent!.file, equals('reset_button.dart'));
      expect(capturedEvent!.line, equals(27));
      final bp = controller.breakpoints.firstWhere((b) => b.line == 27);
      expect(bp.hitCount, equals(1));

      await controller.handleLineBreakpoint('reset_button.dart', 27);
      expect(bp.hitCount, equals(2));
    });

    test('pause blocks execution until resume', () async {
      controller.pauseOnHit = true;
      var resumed = false;
      final future = controller
          .handleDebuggerCall('Pausing for test')
          .then(
            (_) => resumed = true,
          );

      expect(controller.isPaused, isTrue);
      expect(resumed, isFalse);

      controller.resume();
      await future.timeout(
        const Duration(seconds: 2),
        onTimeout: () => throw TimeoutException('Resume did not unblock'),
      );
      controller.pauseOnHit = false;
      expect(controller.isPaused, isFalse);
      expect(resumed, isTrue);
    });

    test('breakpoint instrumentation preserves line numbering', () {
      const source = '''void main() {
  print("Hello");
  print("World");
}''';
      final instrumented = instrumentBreakpoints(
        source,
        'main.dart',
        {2},
      );
      final lines = instrumented.split('\n');
      expect(lines, hasLength(4));
      expect(
        lines[1],
        contains("await __debugBreakpoint('main.dart', 2); print(\"Hello\");"),
      );
    });

    test('virtual source maps carry instrumented breakpoints', () {
      const raw = {
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
        breakpointInstrumenter: instrumentBreakpoints,
      );
      expect(
        vMap['reset_button.dart'],
        contains("await __debugBreakpoint('reset_button.dart', 3);"),
      );
    });
  });
}

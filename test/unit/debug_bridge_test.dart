import 'package:dartnative_go/src/debug/debug_bridge.dart';
import 'package:test/test.dart';

void main() {
  group('DartNativeDebugBridge', () {
    late DartNativeDebugBridge bridge;

    setUp(() {
      bridge = DartNativeDebugBridge();
    });

    test('logs are captured, queryable, capped at maxLogs, and clearable', () {
      expect(bridge.logs, isEmpty);

      bridge.appendLog(LogEntry(
        message: 'Info log',
        level: 'INFO',
        source: 'server',
      ));
      bridge.appendLog(LogEntry(
        message: 'Error log',
        level: 'ERROR',
        source: 'device',
      ));

      expect(bridge.logs.length, equals(2));
      expect(bridge.logs.first.message, equals('Info log'));
      expect(bridge.logs.last.level, equals('ERROR'));

      // Test cap of 1000
      for (var i = 0; i < 1050; i++) {
        bridge.appendLog(LogEntry(
          message: 'Log #$i',
          level: 'INFO',
          source: 'device',
        ));
      }
      expect(bridge.logs.length, equals(1000));
      expect(bridge.logs.last.message, equals('Log #1049'));

      bridge.clearLogs();
      expect(bridge.logs, isEmpty);
    });

    test('breakpoints management and broadcast notification', () {
      var broadcastCalled = false;
      Map<String, dynamic>? lastBroadcast;

      bridge.registerBroadcast((msg) {
        broadcastCalled = true;
        lastBroadcast = msg;
      });

      expect(bridge.breakpoints, isEmpty);

      bridge.setBreakpoints([
        {'file': 'main.dart', 'line': 12},
        {'file': 'counter.dart', 'line': 45},
      ]);

      expect(bridge.breakpoints.length, equals(2));
      expect(broadcastCalled, isTrue);
      expect(lastBroadcast?['type'], equals('breakpoints'));
      expect((lastBroadcast?['breakpoints'] as List).length, equals(2));

      bridge.clearBreakpoints();
      expect(bridge.breakpoints, isEmpty);
      expect((lastBroadcast?['breakpoints'] as List).isEmpty, isTrue);
    });

    test('breakpoint hit pauses execution and populates state', () async {
      expect(bridge.isPaused, isFalse);
      expect(bridge.currentVariables, isEmpty);

      final eventFuture = bridge.events.first;

      bridge.notifyBreakpointHit({
        'file': 'todo_screen.dart',
        'line': 34,
        'variables': {'counter': 42, 'title': 'Test Item'},
        'stack': [
          {'id': 1, 'function': '_onIncrement', 'uri': 'todo_screen.dart', 'line': 34, 'column': 5},
          {'id': 2, 'function': 'build', 'uri': 'todo_screen.dart', 'line': 50, 'column': 10},
        ],
      });

      expect(bridge.isPaused, isTrue);
      expect(bridge.currentVariables['counter'], equals(42));
      expect(bridge.currentVariables['title'], equals('Test Item'));
      expect(bridge.currentStack.length, equals(2));
      expect(bridge.currentStack.first.function, equals('_onIncrement'));
      expect(bridge.currentHitEvent?['file'], equals('todo_screen.dart'));

      final event = await eventFuture;
      expect(event.kind, equals(DebugEventKind.stopped));
      expect(event.data['line'], equals(34));

      // Resume
      var resumedBroadcast = false;
      bridge.registerBroadcast((msg) {
        if (msg['type'] == 'resume') resumedBroadcast = true;
      });

      final resumeFuture = bridge.events.first;
      bridge.resume();

      expect(bridge.isPaused, isFalse);
      expect(bridge.currentVariables, isEmpty);
      expect(bridge.currentStack, isEmpty);
      expect(bridge.currentHitEvent, isNull);
      expect(resumedBroadcast, isTrue);

      final resumeEvent = await resumeFuture;
      expect(resumeEvent.kind, equals(DebugEventKind.continued));
    });

    test('screenshot request and resolution', () async {
      var requestDispatched = false;
      String? dispatchedReqId;

      bridge.registerBroadcast((msg) {
        if (msg['type'] == 'screenshot_request') {
          requestDispatched = true;
          dispatchedReqId = msg['requestId'] as String?;
        }
      });

      final futureScreenshot = bridge.requestScreenshot();
      expect(requestDispatched, isTrue);
      expect(dispatchedReqId, isNotNull);

      // Simulate device resolving the screenshot with base64 PNG
      const fakeBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
      bridge.resolveScreenshot(dispatchedReqId!, fakeBase64);

      final result = await futureScreenshot;
      expect(result, equals(fakeBase64));
    });

    test('eval request and resolution', () async {
      var requestDispatched = false;
      String? dispatchedReqId;

      bridge.registerBroadcast((msg) {
        if (msg['type'] == 'eval_request') {
          requestDispatched = true;
          dispatchedReqId = msg['requestId'] as String?;
        }
      });

      final futureEval = bridge.requestEval('counter + 10');
      expect(requestDispatched, isTrue);
      expect(dispatchedReqId, isNotNull);

      // Simulate device resolving the eval
      bridge.resolveEval(dispatchedReqId!, '52');

      final result = await futureEval;
      expect(result, equals('52'));
    });

    test('eval request handles error response', () async {
      String? reqId;
      bridge.registerBroadcast((msg) {
        if (msg['type'] == 'eval_request') {
          reqId = msg['requestId'] as String?;
        }
      });

      final futureEval = bridge.requestEval('invalid_var');
      bridge.resolveEval(reqId!, '', error: 'Variable not found');

      expect(futureEval, throwsA(predicate((e) => e.toString().contains('Variable not found'))));
    });
  });
}

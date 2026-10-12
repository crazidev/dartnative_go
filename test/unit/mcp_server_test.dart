import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/debug/debug_bridge.dart';
import 'package:dartnative_go/src/mcp/mcp_server.dart';
import 'package:test/test.dart';

void main() {
  group('DartNativeMcpServer', () {
    late DartNativeDebugBridge bridge;
    late DartNativeMcpServer mcpServer;
    late HttpClient httpClient;
    late int port;

    bool hotReloadCalled = false;
    bool hotRestartCalled = false;

    setUp(() async {
      hotReloadCalled = false;
      hotRestartCalled = false;

      bridge = DartNativeDebugBridge();
      httpClient = HttpClient();

      mcpServer = DartNativeMcpServer(
        bridge: bridge,
        port: 0, // OS assigns an available ephemeral port
        getServerUrl: () => 'http://127.0.0.1:8088',
        getClientCount: () => 1,
        onHotReload: () async {
          hotReloadCalled = true;
        },
        onHotRestart: () async {
          hotRestartCalled = true;
        },
        onWidgetTree: (reqId) async => {
          'type': 'Column',
          'children': [
            {'type': 'Text', 'text': 'Counter: 0'}
          ]
        },
        onUiTap: (reqId, target) async => {'ok': true},
        onUiType: (reqId, target, text) async => {'ok': true},
        broadcast: (_) {},
      );

      await mcpServer.start();
      port = mcpServer.activePort;
    });

    tearDown(() async {
      await mcpServer.stop();
      httpClient.close(force: true);
    });

    Future<Map<String, dynamic>> postRpc(String method, [Map<String, dynamic>? params]) async {
      final req = await httpClient.post('127.0.0.1', port, '/mcp/v1');
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode({
        'jsonrpc': '2.0',
        'id': 1,
        'method': method,
        'params': params ?? {},
      }));
      final res = await req.close();
      final body = await utf8.decodeStream(res);
      return jsonDecode(body) as Map<String, dynamic>;
    }

    test('initialize returns protocol version and server capabilities', () async {
      final res = await postRpc('initialize');
      expect(res['error'], isNull);
      final result = res['result'] as Map<String, dynamic>;
      expect(result['protocolVersion'], equals('2024-11-05'));
      expect(result['serverInfo']['name'], equals('dartnative-go'));
      expect(result['capabilities']['tools'], isNotNull);
      expect(result['capabilities']['resources'], isNotNull);
    });

    test('tools/list returns all registered tools', () async {
      final res = await postRpc('tools/list');
      expect(res['error'], isNull);
      final tools = (res['result']['tools'] as List).cast<Map<String, dynamic>>();

      final toolNames = tools.map((t) => t['name'] as String).toSet();
      expect(toolNames, containsAll([
        'dart_go.server_status',
        'dart_go.logs',
        'dart_go.clear_logs',
        'dart_go.hot_reload',
        'dart_go.hot_restart',
        'dart_go.set_breakpoints',
        'dart_go.clear_breakpoints',
        'dart_go.get_breakpoint_info',
        'dart_go.resume',
        'dart_go.get_variables',
        'dart_go.evaluate',
        'dart_go.screenshot',
        'dart_go.get_widget_tree',
        'dart_go.tap',
        'dart_go.type_text',
      ]));
    });

    test('resources/list and resources/read return accurate state', () async {
      bridge.appendLog(LogEntry(message: 'App initialized', level: 'INFO', source: 'device'));
      bridge.setBreakpoints([{'file': 'main.dart', 'line': 20}]);

      final listRes = await postRpc('resources/list');
      final resources = (listRes['result']['resources'] as List).cast<Map<String, dynamic>>();
      expect(resources.length, equals(4));

      // Read status
      final statusRes = await postRpc('resources/read', {'uri': 'dartnative://status'});
      final statusText = statusRes['result']['contents'][0]['text'] as String;
      expect(statusText, contains('http://127.0.0.1:8088'));

      // Read logs
      final logsRes = await postRpc('resources/read', {'uri': 'dartnative://logs'});
      final logsText = logsRes['result']['contents'][0]['text'] as String;
      expect(logsText, contains('App initialized'));

      // Read breakpoints
      final bpRes = await postRpc('resources/read', {'uri': 'dartnative://breakpoints'});
      final bpText = bpRes['result']['contents'][0]['text'] as String;
      expect(bpText, contains('main.dart'));
    });

    test('dart_go.logs and dart_go.clear_logs tools', () async {
      bridge.appendLog(LogEntry(message: 'Line 1', level: 'INFO', source: 'device'));
      bridge.appendLog(LogEntry(message: 'Warning in file', level: 'WARN', source: 'device'));
      bridge.appendLog(LogEntry(message: 'Error occurred', level: 'ERROR', source: 'device'));

      // Read all logs
      final logsRes = await postRpc('tools/call', {
        'name': 'dart_go.logs',
        'arguments': {'limit': 10},
      });
      final logsContent = logsRes['result']['content'][0]['text'] as String;
      expect(logsContent, contains('Line 1'));
      expect(logsContent, contains('Error occurred'));

      // Filter by level
      final filteredRes = await postRpc('tools/call', {
        'name': 'dart_go.logs',
        'arguments': {'level': 'error'},
      });
      final filteredContent = filteredRes['result']['content'][0]['text'] as String;
      expect(filteredContent, contains('Error occurred'));
      expect(filteredContent, isNot(contains('Line 1')));

      // Clear logs
      final clearRes = await postRpc('tools/call', {
        'name': 'dart_go.clear_logs',
        'arguments': {},
      });
      expect(clearRes['result']['content'][0]['text'], contains('cleared'));
      expect(bridge.logs, isEmpty);
    });

    test('dart_go.hot_reload and hot_restart invoke handlers', () async {
      final reloadRes = await postRpc('tools/call', {
        'name': 'dart_go.hot_reload',
        'arguments': {},
      });
      expect(reloadRes['result']['content'][0]['text'], contains('Hot reload triggered'));
      expect(hotReloadCalled, isTrue);

      final restartRes = await postRpc('tools/call', {
        'name': 'dart_go.hot_restart',
        'arguments': {},
      });
      expect(restartRes['result']['content'][0]['text'], contains('Hot restart triggered'));
      expect(hotRestartCalled, isTrue);
    });

    test('breakpoints management and inspection via MCP tools', () async {
      final setRes = await postRpc('tools/call', {
        'name': 'dart_go.set_breakpoints',
        'arguments': {
          'file': 'list_screen.dart',
          'lines': [15, 25],
        },
      });
      expect(setRes['result']['content'][0]['text'], contains('Set 2 breakpoint(s)'));
      expect(bridge.breakpoints.length, equals(2));

      // Info when not paused
      final infoRes1 = await postRpc('tools/call', {
        'name': 'dart_go.get_breakpoint_info',
        'arguments': {},
      });
      expect(infoRes1['result']['content'][0]['text'], contains('not paused'));

      // Simulate hit
      bridge.notifyBreakpointHit({
        'file': 'list_screen.dart',
        'line': 15,
        'variables': {'itemsCount': 3, 'filter': 'active'},
        'stack': [
          {'id': 1, 'function': '_buildList', 'uri': 'list_screen.dart', 'line': 15, 'column': 4},
        ],
      });

      // Info when paused
      final infoRes2 = await postRpc('tools/call', {
        'name': 'dart_go.get_breakpoint_info',
        'arguments': {},
      });
      expect(infoRes2['result']['content'][0]['text'], contains('Paused at list_screen.dart:15'));
      expect(infoRes2['result']['content'][0]['text'], contains('_buildList'));

      // Get variables
      final varsRes = await postRpc('tools/call', {
        'name': 'dart_go.get_variables',
        'arguments': {},
      });
      final varsText = varsRes['result']['content'][0]['text'] as String;
      expect(varsText, contains('itemsCount = 3'));
      expect(varsText, contains('filter = active'));

      // Resume
      final resumeRes = await postRpc('tools/call', {
        'name': 'dart_go.resume',
        'arguments': {},
      });
      expect(resumeRes['result']['content'][0]['text'], contains('Execution resumed'));
      expect(bridge.isPaused, isFalse);

      // Clear breakpoints
      final clearBpRes = await postRpc('tools/call', {
        'name': 'dart_go.clear_breakpoints',
        'arguments': {},
      });
      expect(clearBpRes['result']['content'][0]['text'], contains('cleared'));
      expect(bridge.breakpoints, isEmpty);
    });

    test('dart_go.screenshot tool retrieves base64 image', () async {
      bridge.registerBroadcast((msg) {
        if (msg['type'] == 'screenshot_request') {
          bridge.resolveScreenshot(msg['requestId'] as String, 'FAKE_BASE64_IMAGE_DATA');
        }
      });

      final ssRes = await postRpc('tools/call', {
        'name': 'dart_go.screenshot',
        'arguments': {},
      });
      final content = ssRes['result']['content'][0] as Map<String, dynamic>;
      expect(content['type'], equals('image'));
      expect(content['data'], equals('FAKE_BASE64_IMAGE_DATA'));
      expect(content['mimeType'], equals('image/png'));
    });

    test('dart_go.evaluate tool evaluates expression while paused', () async {
      bridge.notifyBreakpointHit({
        'file': 'main.dart',
        'line': 10,
        'variables': {'total': 100},
      });

      bridge.registerBroadcast((msg) {
        if (msg['type'] == 'eval_request') {
          bridge.resolveEval(msg['requestId'] as String, '105');
        }
      });

      final evalRes = await postRpc('tools/call', {
        'name': 'dart_go.evaluate',
        'arguments': {'expression': 'total + 5'},
      });
      expect(evalRes['result']['content'][0]['text'], contains('total + 5 => 105'));
    });

    test('dart_go.get_widget_tree, tap, and type_text tools', () async {
      final treeRes = await postRpc('tools/call', {
        'name': 'dart_go.get_widget_tree',
        'arguments': {},
      });
      expect(treeRes['result']['content'][0]['text'], contains('Counter: 0'));

      final tapRes = await postRpc('tools/call', {
        'name': 'dart_go.tap',
        'arguments': {'title': 'Submit'},
      });
      expect(tapRes['result']['content'][0]['text'], contains('Tap succeeded'));

      final typeRes = await postRpc('tools/call', {
        'name': 'dart_go.type_text',
        'arguments': {'field': 'Email', 'text': 'test@example.com'},
      });
      expect(typeRes['result']['content'][0]['text'], contains('Type succeeded'));
    });

    test('SSE endpoint /mcp/v1/events pushes live events', () async {
      final req = await httpClient.get('127.0.0.1', port, '/mcp/v1/events');
      final res = await req.close();
      expect(res.statusCode, equals(200));
      expect(res.headers.contentType?.mimeType, equals('text/event-stream'));

      final lines = <String>[];
      final completer = Completer<void>();

      final sub = res.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
        lines.add(line);
        if (lines.any((l) => l.contains('stopped'))) {
          if (!completer.isCompleted) completer.complete();
        }
      });

      // Trigger a breakpoint hit to produce an SSE event
      bridge.notifyBreakpointHit({
        'file': 'sse_test.dart',
        'line': 99,
      });

      await completer.future.timeout(const Duration(seconds: 3));
      await sub.cancel();

      expect(lines.any((l) => l.startsWith('event: stopped')), isTrue);
    });
  });
}

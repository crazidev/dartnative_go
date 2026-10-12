import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../debug/debug_bridge.dart';

/// MCP (Model Context Protocol) HTTP server embedded in DartNative Go.
///
/// Exposes JSON-RPC 2.0 at `POST /mcp/v1` and an SSE stream at
/// `GET /mcp/v1/events`. All 15 tools listed in the plan are implemented.
///
/// Bind port: configurable (default 8089), launch alongside the dev server.
class DartNativeMcpServer {
  final DartNativeDebugBridge bridge;
  final int port;
  final String Function()? getServerUrl;
  final int Function()? getClientCount;
  final Future<void> Function()? onHotReload;
  final Future<void> Function()? onHotRestart;
  final Future<Map<String, dynamic>> Function(String requestId, Map<String, dynamic> target)? onUiTap;
  final Future<Map<String, dynamic>> Function(String requestId, Map<String, dynamic> target, String text)? onUiType;
  final Future<Map<String, dynamic>> Function(String requestId)? onWidgetTree;
  final void Function(Map<String, dynamic>)? broadcast;

  HttpServer? _server;
  final List<HttpResponse> _sseClients = [];

  DartNativeMcpServer({
    required this.bridge,
    this.port = 8089,
    this.getServerUrl,
    this.getClientCount,
    this.onHotReload,
    this.onHotRestart,
    this.onUiTap,
    this.onUiType,
    this.onWidgetTree,
    this.broadcast,
  });

  StreamSubscription? _bridgeEventSub;

  int get activePort => _server?.port ?? port;

  Future<void> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port, shared: true);
    _server = server;

    // Forward bridge events to SSE clients
    _bridgeEventSub = bridge.events.listen(_pushSseEvent);

    server.listen(
      _handleRequest,
      onError: (e) => print('[MCP] Request error: $e'),
    );
  }

  Future<void> stop() async {
    await _bridgeEventSub?.cancel();
    _bridgeEventSub = null;
    for (final sse in List.of(_sseClients)) {
      try {
        sse.close();
      } catch (_) {}
    }
    _sseClients.clear();
    await _server?.close(force: true);
    _server = null;
  }

  void _corsHeaders(HttpResponse res) {
    res.headers
      ..set('Access-Control-Allow-Origin', '*')
      ..set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
      ..set('Access-Control-Allow-Headers', 'Content-Type');
  }

  Future<void> _handleRequest(HttpRequest req) async {
    final path = req.uri.path;
    _corsHeaders(req.response);

    if (req.method == 'OPTIONS') {
      req.response
        ..statusCode = 200
        ..close();
      return;
    }

    if ((path == '/mcp/v1/events' || path == '/sse' || path == '/mcp/v1') && req.method == 'GET') {
      _handleSse(req);
      return;
    }

    if (path == '/mcp/v1' && req.method == 'POST') {
      await _handleJsonRpc(req);
      return;
    }

    req.response
      ..statusCode = 404
      ..write('Not found')
      ..close();
  }

  // ── SSE push stream ────────────────────────────────────────────────────

  void _handleSse(HttpRequest req) {
    final res = req.response;
    res.bufferOutput = false;
    res.headers
      ..set('Content-Type', 'text/event-stream')
      ..set('Cache-Control', 'no-cache')
      ..set('Connection', 'keep-alive');
    res.statusCode = 200;
    _sseClients.add(res);
    req.response.done.catchError((_) => _sseClients.remove(res));
    // Send standard MCP endpoint URI for JSON-RPC POSTs
    try {
      res.write('event: endpoint\ndata: /mcp/v1\n\n');
      res.flush();
    } catch (_) {}
    // Send initial ping
    _sendSse(res, 'connected', {'status': 'ok'});
  }

  void _sendSse(HttpResponse res, String event, Map<String, dynamic> data) {
    try {
      res.write('event: $event\ndata: ${jsonEncode(data)}\n\n');
      res.flush();
    } catch (_) {}
  }

  void _pushSseEvent(DebugEvent event) {
    final clients = List.of(_sseClients);
    for (final client in clients) {
      _sendSse(client, event.kind.name, event.data);
    }
  }

  // ── JSON-RPC 2.0 dispatch ──────────────────────────────────────────────

  Future<void> _handleJsonRpc(HttpRequest req) async {
    late Map<String, dynamic> body;
    try {
      final raw = await utf8.decodeStream(req);
      body = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      _jsonError(req.response, null, -32700, 'Parse error');
      return;
    }

    final id = body['id'];
    final method = body['method']?.toString() ?? '';
    final params = (body['params'] is Map)
        ? Map<String, dynamic>.from(body['params'] as Map)
        : <String, dynamic>{};

    try {
      final result = await _dispatch(method, params);
      _jsonOk(req.response, id, result);
    } on McpError catch (e) {
      _jsonError(req.response, id, e.code, e.message);
    } catch (e) {
      _jsonError(req.response, id, -32603, 'Internal error: $e');
    }
  }

  void _jsonOk(HttpResponse res, dynamic id, dynamic result) {
    res
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'jsonrpc': '2.0', 'id': id, 'result': result}))
      ..close();
  }

  void _jsonError(HttpResponse res, dynamic id, int code, String message) {
    res
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({
        'jsonrpc': '2.0',
        'id': id,
        'error': {'code': code, 'message': message},
      }))
      ..close();
  }

  Future<dynamic> _dispatch(String method, Map<String, dynamic> params) async {
    switch (method) {
      // ── MCP handshake ────────────────────────────────────────────────

      case 'initialize':
        return {
          'protocolVersion': '2024-11-05',
          'capabilities': {
            'tools': {'listChanged': false},
            'resources': {'subscribe': true, 'listChanged': false},
          },
          'serverInfo': {'name': 'dartnative-go', 'version': '1.0.0'},
        };

      case 'tools/list':
        return {'tools': _toolList()};

      case 'resources/list':
        return {'resources': _resourceList()};

      case 'resources/read':
        return _readResource(params['uri']?.toString() ?? '');

      // ── Tool invocations ──────────────────────────────────────────────

      case 'tools/call':
        final toolName = params['name']?.toString() ?? '';
        final args = (params['arguments'] is Map)
            ? Map<String, dynamic>.from(params['arguments'] as Map)
            : <String, dynamic>{};
        return _callTool(toolName, args);

      default:
        throw McpError(-32601, 'Method not found: $method');
    }
  }

  // ── Tool call handler ─────────────────────────────────────────────────

  Future<Map<String, dynamic>> _callTool(
      String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'dart_go.server_status':
        return _textResult(jsonEncode({
          'serverUrl': getServerUrl?.call() ?? bridge.serverUrl,
          'connectedClients': getClientCount?.call() ?? bridge.connectedClients,
          'isPaused': bridge.isPaused,
          'activeBreakpoints': bridge.breakpoints.length,
          'logCount': bridge.logs.length,
        }));

      case 'dart_go.logs':
        final limit = (args['limit'] as int?) ?? 100;
        final level = args['level']?.toString() ?? 'all';
        var entries = bridge.logs;
        if (level != 'all') {
          entries = entries.where((l) => l.level.toLowerCase() == level.toLowerCase()).toList();
        }
        final recent = entries.length > limit
            ? entries.sublist(entries.length - limit)
            : entries;
        return _textResult(
          recent.map((e) => '[${e.timestamp.toIso8601String().substring(11, 19)}][${e.level}][${e.source}] ${e.message}').join('\n'),
        );

      case 'dart_go.clear_logs':
        bridge.clearLogs();
        return _textResult('Log buffer cleared.');

      case 'dart_go.hot_reload':
        if (onHotReload != null) {
          await onHotReload!();
        } else {
          bridge.hotReload();
        }
        return _textResult('Hot reload triggered.');

      case 'dart_go.hot_restart':
        if (onHotRestart != null) {
          await onHotRestart!();
        } else {
          bridge.hotRestart();
        }
        return _textResult('Hot restart triggered.');

      case 'dart_go.set_breakpoints':
        final file = args['file']?.toString() ?? '';
        final lines = (args['lines'] as List?)?.whereType<int>().toList() ?? [];
        if (file.isEmpty) throw McpError(-32602, '"file" is required');

        final existing = List<Map<String, dynamic>>.from(bridge.breakpoints);
        existing.removeWhere((b) => b['file'] == file);
        for (final line in lines) {
          existing.add({'file': file, 'line': line});
        }
        bridge.setBreakpoints(existing);
        return _textResult('Set ${lines.length} breakpoint(s) in $file: $lines');

      case 'dart_go.clear_breakpoints':
        bridge.clearBreakpoints();
        return _textResult('All breakpoints cleared.');

      case 'dart_go.get_breakpoint_info':
        if (!bridge.isPaused) {
          return _textResult('App is running (not paused at a breakpoint).');
        }
        final hit = bridge.currentHitEvent!;
        final stack = bridge.currentStack
            .map((f) => '  #${f.id} ${f.function} (${f.uri}:${f.line}:${f.column})')
            .join('\n');
        return _textResult(
          'Paused at ${hit['file']}:${hit['line']}\n'
          '${hit['message'] ?? ''}\n'
          'Call stack:\n$stack',
        );

      case 'dart_go.resume':
        if (!bridge.isPaused) {
          return _textResult('App is not paused.');
        }
        bridge.resume();
        return _textResult('Execution resumed.');

      case 'dart_go.get_variables':
        if (!bridge.isPaused) {
          return _textResult('App is not paused at a breakpoint.');
        }
        final vars = bridge.currentVariables;
        if (vars.isEmpty) {
          return _textResult('No variable snapshot available at current breakpoint.');
        }
        final text = vars.entries
            .map((e) => '  ${e.key} = ${e.value}')
            .join('\n');
        return _textResult('Variables at ${bridge.currentHitEvent!['file']}:${bridge.currentHitEvent!['line']}:\n$text');

      case 'dart_go.evaluate':
        final expr = args['expression']?.toString() ?? '';
        if (expr.isEmpty) throw McpError(-32602, '"expression" is required');
        if (!bridge.isPaused) {
          return _textResult('Cannot evaluate: app is not paused at a breakpoint.');
        }
        try {
          final result = await bridge.requestEval(expr);
          return _textResult('$expr => $result');
        } catch (e) {
          return _textResult('Eval error: $e');
        }

      case 'dart_go.screenshot':
        try {
          final b64 = await bridge.requestScreenshot();
          return {
            'content': [
              {'type': 'image', 'data': b64, 'mimeType': 'image/png'},
            ],
          };
        } catch (e) {
          throw McpError(-32603, 'Screenshot failed: $e');
        }

      case 'dart_go.get_widget_tree':
        if (onWidgetTree == null) {
          throw McpError(-32603, 'Widget tree not available (no handler registered)');
        }
        final reqId = 'mcp_tree_${DateTime.now().millisecondsSinceEpoch}';
        final tree = await onWidgetTree!(reqId);
        return _textResult(jsonEncode(tree));

      case 'dart_go.tap':
        if (broadcast == null) throw McpError(-32603, 'No broadcast handler');
        final reqId = 'mcp_tap_${DateTime.now().millisecondsSinceEpoch}';
        final target = <String, dynamic>{};
        if (args['title'] != null) target['title'] = args['title'];
        if (args['icon'] != null) target['icon'] = args['icon'];
        if (onUiTap != null) {
          final result = await onUiTap!(reqId, target);
          final ok = result['ok'] == true;
          return _textResult(ok ? 'Tap succeeded.' : 'Tap failed: ${result['error']}');
        }
        broadcast!({'type': 'ui_tap', 'requestId': reqId, 'target': target});
        return _textResult('Tap dispatched (requestId: $reqId).');

      case 'dart_go.type_text':
        final text = args['text']?.toString() ?? '';
        if (text.isEmpty) throw McpError(-32602, '"text" is required');
        if (broadcast == null) throw McpError(-32603, 'No broadcast handler');
        final reqId = 'mcp_type_${DateTime.now().millisecondsSinceEpoch}';
        final target = <String, dynamic>{};
        if (args['field'] != null) target['text'] = args['field'];
        if (onUiType != null) {
          final result = await onUiType!(reqId, target, text);
          final ok = result['ok'] == true;
          return _textResult(ok ? 'Type succeeded.' : 'Type failed: ${result['error']}');
        }
        broadcast!({'type': 'ui_type', 'requestId': reqId, 'target': target, 'text': text});
        return _textResult('Type dispatched (requestId: $reqId).');

      default:
        throw McpError(-32601, 'Unknown tool: $name');
    }
  }

  // ── Resource reader ────────────────────────────────────────────────────

  Map<String, dynamic> _readResource(String uri) {
    switch (uri) {
      case 'dartnative://status':
        return {
          'contents': [
            {
              'uri': uri,
              'mimeType': 'application/json',
              'text': jsonEncode({
                'serverUrl': getServerUrl?.call() ?? bridge.serverUrl,
                'connectedClients': getClientCount?.call() ?? bridge.connectedClients,
                'isPaused': bridge.isPaused,
                'currentHit': bridge.currentHitEvent,
                'activeBreakpoints': bridge.breakpoints,
              }),
            },
          ],
        };

      case 'dartnative://logs':
        return {
          'contents': [
            {
              'uri': uri,
              'mimeType': 'text/plain',
              'text': bridge.logs
                  .map((e) => '[${e.level}] ${e.message}')
                  .join('\n'),
            },
          ],
        };

      case 'dartnative://breakpoints':
        return {
          'contents': [
            {
              'uri': uri,
              'mimeType': 'application/json',
              'text': jsonEncode(bridge.breakpoints),
            },
          ],
        };

      case 'dartnative://variables':
        return {
          'contents': [
            {
              'uri': uri,
              'mimeType': 'application/json',
              'text': jsonEncode(bridge.currentVariables),
            },
          ],
        };

      default:
        throw McpError(-32602, 'Unknown resource: $uri');
    }
  }

  // ── Static schema definitions ──────────────────────────────────────────

  static Map<String, dynamic> _textResult(String text) => {
        'content': [
          {'type': 'text', 'text': text},
        ],
      };

  static List<Map<String, dynamic>> _toolList() => [
        _tool('dart_go.server_status', 'Get DartNative Go dev server status, connected clients, and debug state.', {}),
        _tool('dart_go.logs', 'Read device log buffer.', {
          'limit': {'type': 'integer', 'description': 'Max lines to return (default 100)'},
          'level': {'type': 'string', 'enum': ['all', 'info', 'error', 'warn'], 'description': 'Filter by log level'},
        }),
        _tool('dart_go.clear_logs', 'Clear the device log buffer.', {}),
        _tool('dart_go.hot_reload', 'Trigger a hot reload (state-preserving).', {}),
        _tool('dart_go.hot_restart', 'Trigger a full hot restart (state reset + fresh main()).', {}),
        _tool('dart_go.set_breakpoints', 'Set line breakpoints in a Dart source file.', {
          'file': {'type': 'string', 'description': 'File name, e.g. todo_screen.dart'},
          'lines': {'type': 'array', 'items': {'type': 'integer'}, 'description': 'Line numbers to break at'},
        }, required: ['file', 'lines']),
        _tool('dart_go.clear_breakpoints', 'Remove all active breakpoints.', {}),
        _tool('dart_go.get_breakpoint_info', 'Get current pause location and call stack when stopped at a breakpoint.', {}),
        _tool('dart_go.resume', 'Continue execution from a breakpoint.', {}),
        _tool('dart_go.get_variables', 'Inspect local/global variables at the current breakpoint.', {
          'scope': {'type': 'string', 'enum': ['locals', 'globals', 'all'], 'description': 'Variable scope'},
        }),
        _tool('dart_go.evaluate', 'Evaluate a Dart expression in the paused interpreter scope.', {
          'expression': {'type': 'string', 'description': 'Dart expression to evaluate'},
        }, required: ['expression']),
        _tool('dart_go.screenshot', 'Capture a screenshot from the connected device. Returns a PNG image.', {}),
        _tool('dart_go.get_widget_tree', 'Get the current widget tree as a JSON structure.', {}),
        _tool('dart_go.tap', 'Tap a widget by title or icon name.', {
          'title': {'type': 'string', 'description': 'Widget title/text to tap'},
          'icon': {'type': 'string', 'description': 'Icon name to tap (e.g. CupertinoIcons.plus)'},
        }),
        _tool('dart_go.type_text', 'Type text into a field.', {
          'text': {'type': 'string', 'description': 'Text to type'},
          'field': {'type': 'string', 'description': 'Field label or hint text to target'},
        }, required: ['text']),
      ];

  static Map<String, dynamic> _tool(
    String name,
    String description,
    Map<String, dynamic> properties, {
    List<String> required = const [],
  }) =>
      {
        'name': name,
        'description': description,
        'inputSchema': {
          'type': 'object',
          'properties': properties,
          if (required.isNotEmpty) 'required': required,
        },
      };

  static List<Map<String, dynamic>> _resourceList() => [
        {'uri': 'dartnative://status', 'name': 'Server Status', 'mimeType': 'application/json'},
        {'uri': 'dartnative://logs', 'name': 'Device Logs', 'mimeType': 'text/plain'},
        {'uri': 'dartnative://breakpoints', 'name': 'Active Breakpoints', 'mimeType': 'application/json'},
        {'uri': 'dartnative://variables', 'name': 'Paused Variables', 'mimeType': 'application/json'},
      ];
}

class McpError implements Exception {
  final int code;
  final String message;
  const McpError(this.code, this.message);
}

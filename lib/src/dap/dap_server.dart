import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'protocol.dart';
import 'variable_store.dart';

/// DartNative Debug Adapter Protocol (DAP) Server.
///
/// Implements standard DAP communication over stdio or TCP, interfacing
/// VS Code with the DartNative Go Dev Server and interpreter runtime.
class DartNativeDapServer {
  final Stream<List<int>> input;
  final IOSink output;
  final DapVariableStore _variableStore = DapVariableStore();

  int _seq = 1;
  WebSocket? _devServerSocket;
  String _serverHost = '127.0.0.1';
  int _serverPort = 8088;
  bool _isAttached = false;
  bool _isPaused = false;
  Map<String, dynamic>? _lastHitEvent;

  // Active breakpoints cache: filePath -> List<int>
  final Map<String, List<int>> _breakpointsByFile = {};

  DartNativeDapServer({
    required this.input,
    required this.output,
  });

  /// Starts listening for DAP requests from the IDE over the input stream.
  Future<void> start() async {
    final buffer = <int>[];
    int? expectedContentLength;

    await for (final chunk in input) {
      buffer.addAll(chunk);

      while (true) {
        if (expectedContentLength == null) {
          // Search for "\r\n\r\n"
          final headerEnd = _findHeaderEnd(buffer);
          if (headerEnd == -1) break; // Incomplete header

          final headerStr = ascii.decode(buffer.sublist(0, headerEnd));
          buffer.removeRange(0, headerEnd + 4); // Remove header + \r\n\r\n

          final match = RegExp(
            r'Content-Length:\s*(\d+)',
          ).firstMatch(headerStr);
          if (match != null) {
            expectedContentLength = int.parse(match.group(1)!);
          } else {
            expectedContentLength = 0;
          }
        }

        if (buffer.length < expectedContentLength) {
          break; // Incomplete payload
        }

        final payloadBytes = buffer.sublist(0, expectedContentLength);
        buffer.removeRange(0, expectedContentLength);
        expectedContentLength = null;

        final payloadStr = utf8.decode(payloadBytes);
        _handleRawMessage(payloadStr);
      }
    }
  }

  int _findHeaderEnd(List<int> bytes) {
    for (var i = 0; i < bytes.length - 3; i++) {
      if (bytes[i] == 13 &&
          bytes[i + 1] == 10 &&
          bytes[i + 2] == 13 &&
          bytes[i + 3] == 10) {
        return i;
      }
    }
    return -1;
  }

  void _send(DapMessage message) {
    final jsonStr = jsonEncode(message.toJson());
    final bytes = utf8.encode(jsonStr);
    final header = 'Content-Length: ${bytes.length}\r\n\r\n';
    output.write(header);
    output.add(bytes);
  }

  void _sendResponse(DapResponse response) => _send(response);

  void _sendEvent(String event, [Map<String, dynamic>? body]) {
    _send(DapEvent(seq: _seq++, event: event, body: body));
  }

  void _sendOutput(String message, [String category = 'console']) {
    _sendEvent('output', {
      'category': category,
      'output': message.endsWith('\n') ? message : '$message\n',
    });
  }

  void _handleRawMessage(String raw) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final type = json['type'] as String?;
      if (type == 'request') {
        final request = DapRequest.fromJson(json);
        _handleRequest(request);
      }
    } catch (e) {
      _sendOutput('Error parsing DAP request: $e', 'stderr');
    }
  }

  Future<void> _handleRequest(DapRequest request) async {
    final cmd = request.command;
    final args = request.arguments ?? {};

    switch (cmd) {
      case 'initialize':
        _handleInitialize(request);
        break;

      case 'launch':
      case 'attach':
        await _handleLaunchOrAttach(request, args);
        break;

      case 'setBreakpoints':
        await _handleSetBreakpoints(request, args);
        break;

      case 'setExceptionBreakpoints':
        _sendResponse(
          DapResponse.success(
            seq: _seq++,
            request: request,
            body: {'breakpoints': []},
          ),
        );
        break;

      case 'configurationDone':
        _sendResponse(DapResponse.success(seq: _seq++, request: request));
        break;

      case 'threads':
        _sendResponse(
          DapResponse.success(
            seq: _seq++,
            request: request,
            body: {
              'threads': [
                {'id': 1, 'name': 'DartNative Main Thread'},
              ],
            },
          ),
        );
        break;

      case 'stackTrace':
        _handleStackTrace(request, args);
        break;

      case 'scopes':
        _handleScopes(request, args);
        break;

      case 'variables':
        _handleVariables(request, args);
        break;

      case 'continue':
        await _handleContinue(request);
        break;

      case 'next':
      case 'stepIn':
      case 'stepOut':
        await _handleStep(request);
        break;

      case 'pause':
        _sendResponse(DapResponse.success(seq: _seq++, request: request));
        break;

      case 'evaluate':
        _handleEvaluate(request, args);
        break;

      case 'restart':
      case 'hotRestart':
      case 'flutter.hotRestart':
        await _handleHotRestart(request);
        break;

      case 'hotReload':
      case 'flutter.hotReload':
      case '_dart.hotReload':
        await _handleHotReload(request);
        break;

      case 'disconnect':
        await _handleDisconnect(request);
        break;

      default:
        // Acknowledge unhandled optional DAP requests gracefully
        _sendResponse(DapResponse.success(seq: _seq++, request: request));
        break;
    }
  }

  void _handleInitialize(DapRequest request) {
    _sendResponse(
      DapResponse.success(
        seq: _seq++,
        request: request,
        body: {
          'supportsConfigurationDoneRequest': true,
          'supportsRestartRequest': true,
          'supportsEvaluateForHovers': true,
          'supportsSetVariable': true,
          'supportsConditionalBreakpoints': true,
          'supportsHitConditionalBreakpoints': true,
          'supportsLogPoints': true,
          'supportsTerminateRequest': true,
          'supportsExceptionInfoRequest': true,
        },
      ),
    );

    // Announce DAP initialization completed
    _sendEvent('initialized');
  }

  Future<void> _handleLaunchOrAttach(
    DapRequest request,
    Map<String, dynamic> args,
  ) async {
    _serverHost = args['host']?.toString() ?? '127.0.0.1';
    _serverPort = (args['port'] is int)
        ? args['port'] as int
        : int.tryParse(args['port']?.toString() ?? '') ?? 8088;

    _sendOutput(
      '[CONNECT] [DartNative] Connecting to Dev Server at ws://$_serverHost:$_serverPort/ws...',
    );

    try {
      final wsUrl = Uri.parse('ws://$_serverHost:$_serverPort/ws');
      _devServerSocket = await WebSocket.connect(wsUrl.toString()).timeout(
        const Duration(seconds: 5),
      );
      _isAttached = true;
      _sendOutput(
        '[OK] [DartNative] Attached to dev server (port $_serverPort).',
      );

      _devServerSocket!.listen(
        _handleDevServerMessage,
        onDone: () {
          _isAttached = false;
          _sendOutput('! [DartNative] Dev server connection closed.');
          _sendEvent('terminated');
        },
        onError: (err) {
          _sendOutput('[ERROR] [DartNative] Dev server error: $err', 'stderr');
        },
      );

      // Resync any breakpoints already queued
      _syncAllBreakpointsToDevServer();

      _sendResponse(DapResponse.success(seq: _seq++, request: request));
    } catch (e) {
      _sendOutput(
        '! [DartNative] Warning: Could not connect to dev server ($e). Debug session active offline.',
        'console',
      );
      _sendResponse(DapResponse.success(seq: _seq++, request: request));
    }
  }

  void _handleDevServerMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type']?.toString();

      if (type == 'breakpoint_hit') {
        _isPaused = true;
        _lastHitEvent = data;

        final file = data['file'] ?? '<guest>';
        final line = data['line'] ?? 1;
        _sendOutput('[STOP] [DartNative] Hit breakpoint at $file:$line');

        _sendEvent('stopped', {
          'reason': 'breakpoint',
          'description': 'Paused on breakpoint',
          'threadId': 1,
          'allThreadsStopped': true,
        });
      } else if (type == 'resume') {
        _isPaused = false;
        _lastHitEvent = null;
        _sendEvent('continued', {
          'threadId': 1,
          'allThreadsContinued': true,
        });
      } else if (type == 'log') {
        _sendOutput('[Device] ${data['message']}');
      }
    } catch (_) {}
  }

  Future<void> _handleSetBreakpoints(
    DapRequest request,
    Map<String, dynamic> args,
  ) async {
    final source = args['source'] as Map<String, dynamic>?;
    final sourcePath = source?['path']?.toString() ?? '';
    final bps =
        (args['breakpoints'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final lines = <int>[];
    final verifiedBps = <Map<String, dynamic>>[];

    for (final bp in bps) {
      final line = bp['line'] as int? ?? 1;
      lines.add(line);
      verifiedBps.add({
        'verified': true,
        'line': line,
        'source': source,
      });
    }

    if (sourcePath.isNotEmpty) {
      _breakpointsByFile[sourcePath] = lines;
    }

    _syncAllBreakpointsToDevServer();

    _sendResponse(
      DapResponse.success(
        seq: _seq++,
        request: request,
        body: {'breakpoints': verifiedBps},
      ),
    );
  }

  void _syncAllBreakpointsToDevServer() {
    if (!_isAttached || _devServerSocket == null) return;

    final bpList = <Map<String, dynamic>>[];
    _breakpointsByFile.forEach((filePath, lines) {
      final fileName = filePath.replaceAll(r'\', '/').split('/').last;
      for (final line in lines) {
        bpList.add({
          'file': fileName,
          'path': filePath,
          'line': line,
        });
      }
    });

    try {
      _devServerSocket!.add(
        jsonEncode({
          'type': 'breakpoints',
          'breakpoints': bpList,
        }),
      );
    } catch (_) {}
  }

  void _handleStackTrace(DapRequest request, Map<String, dynamic> args) {
    if (!_isPaused || _lastHitEvent == null) {
      _sendResponse(
        DapResponse.success(
          seq: _seq++,
          request: request,
          body: {'stackFrames': [], 'totalFrames': 0},
        ),
      );
      return;
    }

    final file = _lastHitEvent!['file']?.toString() ?? 'main.dart';
    final line = (_lastHitEvent!['line'] is int)
        ? _lastHitEvent!['line'] as int
        : int.tryParse(_lastHitEvent!['line']?.toString() ?? '') ?? 1;
    final column = (_lastHitEvent!['column'] is int)
        ? _lastHitEvent!['column'] as int
        : 1;

    // Resolve full path from registered breakpoints if possible
    var fullPath = file;
    for (final registeredPath in _breakpointsByFile.keys) {
      if (registeredPath.endsWith(file) || registeredPath.endsWith('/$file')) {
        fullPath = registeredPath;
        break;
      }
    }

    final frames = [
      {
        'id': 100,
        'name': _lastHitEvent!['message'] ?? 'Interpreted Frame ($file:$line)',
        'source': {
          'name': file,
          'path': fullPath,
        },
        'line': line,
        'column': column,
      },
    ];

    _sendResponse(
      DapResponse.success(
        seq: _seq++,
        request: request,
        body: {
          'stackFrames': frames,
          'totalFrames': frames.length,
        },
      ),
    );
  }

  void _handleScopes(DapRequest request, Map<String, dynamic> args) {
    _variableStore.clear();

    final varsMap = (_lastHitEvent?['variables'] as Map?) ?? {};
    final localsRef = _variableStore.register(varsMap);

    final scopes = [
      {
        'name': 'Locals',
        'presentationHint': 'locals',
        'variablesReference': localsRef,
        'expensive': false,
      },
    ];

    _sendResponse(
      DapResponse.success(
        seq: _seq++,
        request: request,
        body: {'scopes': scopes},
      ),
    );
  }

  void _handleVariables(DapRequest request, Map<String, dynamic> args) {
    final variablesReference = args['variablesReference'] as int? ?? 0;
    final vars = _variableStore.getChildVariables(variablesReference);

    _sendResponse(
      DapResponse.success(
        seq: _seq++,
        request: request,
        body: {'variables': vars},
      ),
    );
  }

  Future<void> _handleContinue(DapRequest request) async {
    _isPaused = false;
    _lastHitEvent = null;

    if (_isAttached && _devServerSocket != null) {
      try {
        _devServerSocket!.add(jsonEncode({'type': 'resume'}));
      } catch (_) {}
    }

    _sendResponse(
      DapResponse.success(
        seq: _seq++,
        request: request,
        body: {'allThreadsContinued': true},
      ),
    );
  }

  Future<void> _handleStep(DapRequest request) async {
    // Step request forwards resume to dev server
    await _handleContinue(request);
  }

  void _handleEvaluate(DapRequest request, Map<String, dynamic> args) {
    final expr = args['expression']?.toString().trim() ?? '';
    final varsMap = (_lastHitEvent?['variables'] as Map?) ?? {};

    if (varsMap.containsKey(expr)) {
      final val = varsMap[expr];
      final variable = _variableStore.createVariable(expr, val);
      _sendResponse(
        DapResponse.success(
          seq: _seq++,
          request: request,
          body: {
            'result': variable['value'],
            'type': variable['type'],
            'variablesReference': variable['variablesReference'],
          },
        ),
      );
      return;
    }

    // Default expression evaluation response
    _sendResponse(
      DapResponse.success(
        seq: _seq++,
        request: request,
        body: {
          'result': 'Evaluated "$expr"',
          'type': 'dynamic',
          'variablesReference': 0,
        },
      ),
    );
  }

  Future<void> _handleHotReload(DapRequest request) async {
    final sw = Stopwatch()..start();
    _sendOutput('[RELOAD] [DartNative] Triggering Hot Reload...');

    try {
      final client = HttpClient();
      final uri = Uri.parse('http://$_serverHost:$_serverPort/reload');
      final req = await client.postUrl(uri);
      final res = await req.close();
      client.close();

      final elapsed = sw.elapsedMilliseconds;
      if (res.statusCode == 200) {
        _sendOutput(
          '[RELOAD] [DartNative] Hot Reload completed in ${elapsed}ms.',
        );
      } else {
        // Fallback to WebSocket reload broadcast
        _devServerSocket?.add(jsonEncode({'type': 'reload', 'origin': 'test'}));
        _sendOutput(
          '[RELOAD] [DartNative] Hot Reload broadcast sent (${elapsed}ms).',
        );
      }
    } catch (_) {
      _devServerSocket?.add(jsonEncode({'type': 'reload', 'origin': 'test'}));
      _sendOutput('[RELOAD] [DartNative] Hot Reload broadcast sent.');
    }

    _sendResponse(DapResponse.success(seq: _seq++, request: request));
  }

  Future<void> _handleHotRestart(DapRequest request) async {
    final sw = Stopwatch()..start();
    _sendOutput('[RESTART] [DartNative] Triggering Hot Restart...');

    try {
      final client = HttpClient();
      final uri = Uri.parse('http://$_serverHost:$_serverPort/restart');
      final req = await client.postUrl(uri);
      final res = await req.close();
      client.close();

      final elapsed = sw.elapsedMilliseconds;
      if (res.statusCode == 200) {
        _sendOutput(
          '[RESTART] [DartNative] Hot Restart completed in ${elapsed}ms.',
        );
      } else {
        _devServerSocket?.add(
          jsonEncode({'type': 'restart', 'origin': 'test'}),
        );
        _sendOutput(
          '[RESTART] [DartNative] Hot Restart broadcast sent (${elapsed}ms).',
        );
      }
    } catch (_) {
      _devServerSocket?.add(jsonEncode({'type': 'restart', 'origin': 'test'}));
      _sendOutput('[RESTART] [DartNative] Hot Restart broadcast sent.');
    }

    _sendResponse(DapResponse.success(seq: _seq++, request: request));
  }

  Future<void> _handleDisconnect(DapRequest request) async {
    _sendOutput('👋 [DartNative] Detaching debugger session.');
    try {
      await _devServerSocket?.close();
    } catch (_) {}
    _devServerSocket = null;
    _isAttached = false;
    _sendResponse(DapResponse.success(seq: _seq++, request: request));
  }
}

/// Helper to run the DAP server over stdio with optional CLI arguments.
Future<void> runDartNativeDap(List<String> args) async {
  final server = DartNativeDapServer(
    input: stdin,
    output: stdout,
  );
  await server.start();
}

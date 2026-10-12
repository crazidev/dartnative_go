import 'dart:async';

/// A structured log entry captured from the device or dev server.
class LogEntry {
  final DateTime timestamp;
  final String message;
  final String level; // INFO, ERROR, WARN
  final String source; // 'device' | 'server'

  LogEntry({
    required this.message,
    required this.level,
    required this.source,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'message': message,
        'level': level,
        'source': source,
      };
}

/// A single frame in a call stack.
class FrameInfo {
  final int id;
  final String uri;       // file name, e.g. 'todo_screen.dart'
  final String function;  // function/method name, or '<anonymous>'
  final int line;
  final int column;

  const FrameInfo({
    required this.id,
    required this.uri,
    required this.function,
    required this.line,
    required this.column,
  });

  factory FrameInfo.fromJson(Map<String, dynamic> json) => FrameInfo(
        id: json['id'] as int? ?? 0,
        uri: json['uri']?.toString() ?? 'unknown',
        function: json['function']?.toString() ?? '<anonymous>',
        line: json['line'] as int? ?? 1,
        column: json['column'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uri': uri,
        'function': function,
        'line': line,
        'column': column,
      };
}

/// Events emitted by [DartNativeDebugBridge] to all listeners.
enum DebugEventKind { stopped, continued, log, screenshot, reload, restart }

class DebugEvent {
  final DebugEventKind kind;
  final Map<String, dynamic> data;

  const DebugEvent(this.kind, this.data);
}

/// Central debug state hub shared by the DAP server and the MCP server.
///
/// Owns:
/// - Active breakpoints (single source of truth; moved out of server.dart)
/// - Device log ring buffer (max [maxLogs] entries)
/// - Current pause state (hit event, call stack, variables)
/// - Screenshot request/response lifecycle
/// - Eval request/response lifecycle
///
/// Both the DAP adapter and the MCP HTTP server read from this bridge.
/// Only [DartGoServer] writes device messages into it via [handleDeviceMessage].
class DartNativeDebugBridge {
  static final DartNativeDebugBridge instance = DartNativeDebugBridge();
  DartNativeDebugBridge();

  // ---------- Log buffer ------------------------------------------------

  static const int maxLogs = 1000;
  final List<LogEntry> _logs = [];
  List<LogEntry> get logs => List.unmodifiable(_logs);

  void appendLog(LogEntry entry) {
    _logs.add(entry);
    if (_logs.length > maxLogs) _logs.removeAt(0);
    _eventController.add(DebugEvent(DebugEventKind.log, entry.toJson()));
  }

  void clearLogs() => _logs.clear();

  // ---------- Breakpoints -----------------------------------------------

  final List<Map<String, dynamic>> _breakpoints = [];
  List<Map<String, dynamic>> get breakpoints =>
      List.unmodifiable(_breakpoints);

  /// Replaces the entire breakpoint set and broadcasts it to connected devices.
  void setBreakpoints(List<Map<String, dynamic>> bps) {
    _breakpoints
      ..clear()
      ..addAll(bps);
    _broadcast?.call({'type': 'breakpoints', 'breakpoints': _breakpoints});
  }

  void clearBreakpoints() => setBreakpoints([]);

  // ---------- Pause state -----------------------------------------------

  Map<String, dynamic>? currentHitEvent;
  List<FrameInfo> currentStack = [];
  Map<String, dynamic> currentVariables = {};

  bool get isPaused => currentHitEvent != null;

  /// Called by [DartGoServer] when a `breakpoint_hit` WS message arrives.
  void notifyBreakpointHit(Map<String, dynamic> event) {
    currentHitEvent = event;

    // Parse frame stack if device sent one
    final rawStack = event['stack'];
    if (rawStack is List) {
      currentStack = rawStack
          .whereType<Map>()
          .map((f) => FrameInfo.fromJson(Map<String, dynamic>.from(f)))
          .toList();
    } else {
      // Synthetic single frame from file/line
      currentStack = [
        FrameInfo(
          id: 0,
          uri: event['file']?.toString() ?? 'unknown',
          function: event['function']?.toString() ?? '<interpreted>',
          line: (event['line'] is int) ? event['line'] as int : 1,
          column: (event['column'] is int) ? event['column'] as int : 1,
        ),
      ];
    }

    // Snapshot variables
    final rawVars = event['variables'];
    if (rawVars is Map) {
      currentVariables = Map<String, dynamic>.from(rawVars);
    } else {
      currentVariables = {};
    }

    _eventController.add(DebugEvent(DebugEventKind.stopped, event));
  }

  /// Called by [DartGoServer] when a `resume` WS message arrives.
  void notifyResumed() {
    currentHitEvent = null;
    currentStack = [];
    currentVariables = {};
    _eventController.add(DebugEvent(DebugEventKind.continued, {}));
  }

  // ---------- Commands (bridge → device) --------------------------------

  /// Callback registered by [DartGoServer] to broadcast messages to devices.
  void Function(Map<String, dynamic> message)? _broadcast;

  void registerBroadcast(void Function(Map<String, dynamic>) fn) {
    _broadcast = fn;
  }

  void resume() {
    _broadcast?.call({'type': 'resume'});
    notifyResumed();
  }

  void hotReload() {
    _broadcast?.call({
      'type': 'reload',
      'origin': 'mcp',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    _eventController.add(DebugEvent(DebugEventKind.reload, {}));
  }

  void hotRestart() {
    _broadcast?.call({
      'type': 'restart',
      'origin': 'mcp',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    _eventController.add(DebugEvent(DebugEventKind.restart, {}));
  }

  // ---------- Screenshot request/response --------------------------------

  final Map<String, Completer<String>> _screenshotCompleters = {};

  /// Requests a screenshot from the device. Returns base64 PNG.
  /// Throws [TimeoutException] if device doesn't respond within [timeout].
  Future<String> requestScreenshot({
    Duration timeout = const Duration(seconds: 8),
  }) {
    final id = 'ss_${DateTime.now().millisecondsSinceEpoch}';
    final completer = Completer<String>();
    _screenshotCompleters[id] = completer;
    _broadcast?.call({'type': 'screenshot_request', 'requestId': id});
    return completer.future.timeout(
      timeout,
      onTimeout: () {
        _screenshotCompleters.remove(id);
        throw TimeoutException('Screenshot request timed out ($timeout)');
      },
    );
  }

  /// Called by [DartGoServer] when a `screenshot_response` arrives.
  void resolveScreenshot(String requestId, String base64Data) {
    _screenshotCompleters.remove(requestId)?.complete(base64Data);
  }

  // ---------- Eval request/response -------------------------------------

  final Map<String, Completer<String>> _evalCompleters = {};

  /// Requests evaluation of a Dart expression in the paused interpreter.
  /// Returns the stringified result.
  Future<String> requestEval(String expression, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    final id = 'eval_${DateTime.now().millisecondsSinceEpoch}';
    final completer = Completer<String>();
    _evalCompleters[id] = completer;
    _broadcast?.call({
      'type': 'eval_request',
      'requestId': id,
      'expression': expression,
    });
    return completer.future.timeout(
      timeout,
      onTimeout: () {
        _evalCompleters.remove(id);
        throw TimeoutException('Eval request timed out');
      },
    );
  }

  /// Called by [DartGoServer] when an `eval_response` arrives.
  void resolveEval(String requestId, String result, {String? error}) {
    final c = _evalCompleters.remove(requestId);
    if (c == null) return;
    if (error != null) {
      c.completeError(Exception(error));
    } else {
      c.complete(result);
    }
  }

  // ---------- Event stream -----------------------------------------------

  final StreamController<DebugEvent> _eventController =
      StreamController<DebugEvent>.broadcast();

  /// Broadcast stream of debug events. Subscribe to get live updates.
  Stream<DebugEvent> get events => _eventController.stream;

  // ---------- Server metadata (set by DartGoServer on start) -----------

  String serverUrl = '';
  int connectedClients = 0;

  // ---------- Forwarding inbound device messages -----------------------

  /// Called by [DartGoServer] for every WS message received from a device.
  /// Returns true if the bridge consumed the message (no further processing needed).
  bool handleDeviceMessage(Map<String, dynamic> data) {
    final type = data['type']?.toString();

    switch (type) {
      case 'log':
        final msg = data['message']?.toString() ?? '';
        final level = data['level']?.toString() ?? 'INFO';
        appendLog(LogEntry(message: msg, level: level, source: 'device'));
        return false; // server.dart still prints it

      case 'breakpoint_hit':
        notifyBreakpointHit(data);
        return false; // server.dart still prints to terminal

      case 'screenshot_response':
        final id = data['requestId']?.toString() ?? '';
        final imgData = data['data']?.toString() ?? '';
        resolveScreenshot(id, imgData);
        return true;

      case 'eval_response':
        final id = data['requestId']?.toString() ?? '';
        final result = data['result']?.toString() ?? '';
        final error = data['error']?.toString();
        resolveEval(id, result, error: error);
        return true;

      default:
        return false;
    }
  }
}

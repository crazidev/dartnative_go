import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Manages the real-time WebSocket connection to the DartNative Go dev server.
class LiveConnection {
  final String serverUrl;
  final void Function(String? changedFile)? onReload;
  final void Function(List<Map<String, dynamic>> breakpoints)? onBreakpoints;
  final void Function()? onResume;
  final void Function(bool enabled)? onSetVmDebugger;
  final void Function(bool enabled)? onSetVerbose;
  final void Function(String error)? onError;

  /// Hot restart requested by a test script (`restart` broadcast, usually
  /// `origin: test`). Unlike `onReload` (state-preserving), the handler
  /// should drop interpreter state and evaluate fresh.
  final void Function()? onRestart;

  /// UI automation (see `lib/src/runner/ui_probe.dart` for the protocol).
  /// `onUiProbeRequest` fires when a test script asks for the widget tree;
  /// the handler should reply with [sendUiTree]. `onUiTap` fires with the
  /// button title and/or target spec; the handler should reply with [sendUiTapResult].
  final void Function(String requestId)? onUiProbeRequest;
  final void Function(String requestId, String? title, Map<String, dynamic>? target)? onUiTap;

  /// UI automation triggers (see `lib/src/runner/ui_probe.dart`). Each fires
  /// with the request id plus the decoded target (and text for type/submit);
  /// the handler replies with [sendUiActionResult].
  final void Function(String requestId, Map<String, dynamic> target)? onUiHover;
  final void Function(String requestId, Map<String, dynamic> target)? onUiFocus;
  final void Function(String requestId, Map<String, dynamic> target)? onUiBlur;
  final void Function(String requestId, Map<String, dynamic> target, String? text)? onUiSubmit;
  final void Function(String requestId, Map<String, dynamic> target, String text)? onUiType;
  final void Function(String requestId, Map<String, dynamic>? target, double deltaX, double deltaY)? onUiScroll;

  WebSocket? _socket;
  bool _isDisposed = false;

  LiveConnection({
    required this.serverUrl,
    this.onReload,
    this.onBreakpoints,
    this.onResume,
    this.onSetVmDebugger,
    this.onSetVerbose,
    this.onError,
    this.onRestart,
    this.onUiProbeRequest,
    this.onUiTap,
    this.onUiHover,
    this.onUiFocus,
    this.onUiBlur,
    this.onUiSubmit,
    this.onUiType,
    this.onUiScroll,
  });

  bool get isConnected => _socket != null && _socket!.readyState == WebSocket.open;

  static Map<String, dynamic> _targetMap(Map<String, dynamic> data) {
    final target = data['target'];
    if (target is Map<String, dynamic>) return target;
    if (target is Map) return Map<String, dynamic>.from(target);
    return const {};
  }

  /// Connects to the dev server WebSocket at `ws://$host:$port/ws`.
  Future<void> connect({Duration timeout = const Duration(seconds: 5)}) async {
    _isDisposed = false;
    final wsUrl = '${serverUrl.replaceFirst('http', 'ws')}/ws';

    try {
      _socket?.close();
      final socket = await WebSocket.connect(wsUrl).timeout(timeout);
      if (_isDisposed) {
        socket.close();
        return;
      }

      _socket = socket;
      socket.listen(
        (message) {
          try {
            final data = jsonDecode(message as String) as Map<String, dynamic>;
            final type = data['type']?.toString();

            if (type == 'reload') {
              final changedFile = data['changedFile'] as String?;
              onReload?.call(changedFile);
            } else if (type == 'restart') {
              onRestart?.call();
            } else if (type == 'breakpoints') {
              final bpList = (data['breakpoints'] as List).cast<Map<String, dynamic>>();
              onBreakpoints?.call(bpList);
            } else if (type == 'resume') {
              onResume?.call();
            } else if (type == 'set_vm_debugger') {
              onSetVmDebugger?.call(data['enabled'] == true);
            } else if (type == 'set_verbose') {
              onSetVerbose?.call(data['enabled'] == true);
            } else if (type == 'ui_probe_request') {
              onUiProbeRequest?.call(data['requestId']?.toString() ?? '');
            } else if (type == 'ui_tap') {
              onUiTap?.call(
                data['requestId']?.toString() ?? '',
                data['title']?.toString(),
                _targetMap(data),
              );
            } else if (type == 'ui_scroll') {
              onUiScroll?.call(
                data['requestId']?.toString() ?? '',
                _targetMap(data),
                (data['deltaX'] as num?)?.toDouble() ?? 0.0,
                (data['deltaY'] as num?)?.toDouble() ?? 100.0,
              );
            } else if (type == 'ui_hover') {
              onUiHover?.call(
                data['requestId']?.toString() ?? '',
                _targetMap(data),
              );
            } else if (type == 'ui_focus') {
              onUiFocus?.call(
                data['requestId']?.toString() ?? '',
                _targetMap(data),
              );
            } else if (type == 'ui_blur') {
              onUiBlur?.call(
                data['requestId']?.toString() ?? '',
                _targetMap(data),
              );
            } else if (type == 'ui_submit') {
              onUiSubmit?.call(
                data['requestId']?.toString() ?? '',
                _targetMap(data),
                data['text']?.toString(),
              );
            } else if (type == 'ui_type') {
              onUiType?.call(
                data['requestId']?.toString() ?? '',
                _targetMap(data),
                data['text']?.toString() ?? '',
              );
            }
          } catch (_) {}
        },
        onDone: () {
          _socket = null;
        },
        onError: (e) {
          _socket = null;
          onError?.call(e.toString());
        },
      );
    } catch (e) {
      _socket = null;
      onError?.call(e.toString());
    }
  }

  /// Sends device logs back to the dev server terminal.
  void sendDeviceLog(String message, {String level = 'INFO'}) {
    if (!isConnected) return;
    try {
      _socket?.add(
        jsonEncode({
          'type': 'log',
          'level': level,
          'message': message,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );
    } catch (_) {}
  }

  /// Sends verbose mode change to dev server.
  void sendSetVerbose(bool enabled) {
    if (!isConnected) return;
    try {
      _socket?.add(
        jsonEncode({
          'type': 'set_verbose',
          'enabled': enabled,
        }),
      );
    } catch (_) {}
  }

  /// Sends breakpoint hit details to the dev server terminal.
  void sendBreakpointHit(Map<String, dynamic> event) {
    if (!isConnected) return;
    try {
      _socket?.add(
        jsonEncode(
          Map<String, dynamic>.from(event)..['type'] = 'breakpoint_hit',
        ),
      );
    } catch (_) {}
  }

  /// Sends the serialized widget tree answering a `ui_probe_request`.
  void sendUiTree(String requestId, Map<String, dynamic> tree) {
    if (!isConnected) return;
    try {
      _socket?.add(
        jsonEncode({
          'type': 'ui_tree',
          'requestId': requestId,
          'tree': tree,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );
    } catch (_) {}
  }

  /// Sends the outcome of a `ui_tap` request (`error` is null on success).
  void sendUiTapResult(String requestId, bool ok, [String? error]) {
    sendUiActionResult('ui_tap_result', requestId, ok,
        error: error, viewId: null);
  }

  /// Sends a trigger outcome (`ui_hover_result`, `ui_focus_result`,
  /// `ui_blur_result`, `ui_submit_result`, `ui_type_result`).
  void sendUiActionResult(
    String type,
    String requestId,
    bool ok, {
    String? error,
    int? viewId,
  }) {
    if (!isConnected) return;
    try {
      _socket?.add(
        jsonEncode({
          'type': type,
          'requestId': requestId,
          'ok': ok,
          'error': ?error,
          'viewId': ?viewId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );
    } catch (_) {}
  }

  /// Closes the connection.
  void disconnect() {
    _isDisposed = true;
    _socket?.close();
    _socket = null;
  }
}

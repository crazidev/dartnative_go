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

  /// UI automation (see `lib/src/runner/ui_probe.dart` for the protocol).
  /// `onUiProbeRequest` fires when a test script asks for the widget tree;
  /// the handler should reply with [sendUiTree]. `onUiTap` fires with the
  /// button title; the handler should reply with [sendUiTapResult].
  final void Function(String requestId)? onUiProbeRequest;
  final void Function(String requestId, String title)? onUiTap;

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
    this.onUiProbeRequest,
    this.onUiTap,
  });

  bool get isConnected => _socket != null && _socket!.readyState == WebSocket.open;

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
                data['title']?.toString() ?? '',
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
    if (!isConnected) return;
    try {
      _socket?.add(
        jsonEncode({
          'type': 'ui_tap_result',
          'requestId': requestId,
          'ok': ok,
          'error': ?error,
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

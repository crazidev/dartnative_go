import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'device_name.dart';

export 'device_name.dart' show appleModelDisplayName, resolveDeviceName;

/// Manages the real-time WebSocket connection to the DartNative Go dev server.
class LiveConnection {
  final String serverUrl;

  /// Human-readable device name sent to the dev server on connect.
  final String deviceName;
  final void Function(String? changedFile)? onReload;
  final void Function(List<String> changedFiles, {bool isAssetChange})?
  onReloadBatch;
  final void Function(List<Map<String, dynamic>> breakpoints)? onBreakpoints;
  final void Function()? onResume;
  final void Function(bool enabled)? onSetVmDebugger;
  final void Function(bool enabled)? onSetVerbose;
  final void Function(String error)? onError;

  /// Fired whenever the socket opens or closes so the host UI can flip
  /// Connected / Offline without polling [isConnected].
  final void Function(bool connected)? onConnectionChanged;

  /// Fired when the socket reconnects after a previous connection dropped
  /// (e.g. dev server restarted with new config/assets).
  final void Function()? onReconnected;

  /// When true (default), an unexpected socket drop schedules reconnect
  /// attempts with exponential backoff. [disconnect] cancels the loop.
  final bool autoReconnect;

  /// Hot restart requested by a test script (`restart` broadcast, usually
  /// `origin: test`). Unlike `onReload` (state-preserving), the handler
  /// should drop interpreter state and evaluate fresh.
  final void Function()? onRestart;

  /// UI automation (see `lib/src/runner/ui_probe.dart` for the protocol).
  /// `onUiProbeRequest` fires when a test script asks for the widget tree;
  /// the handler should reply with [sendUiTree]. `onUiTap` fires with the
  /// button title and/or target spec; the handler should reply with [sendUiTapResult].
  final void Function(String requestId)? onUiProbeRequest;
  final void Function(
    String requestId,
    String? title,
    Map<String, dynamic>? target,
  )?
  onUiTap;

  /// UI automation triggers (see `lib/src/runner/ui_probe.dart`). Each fires
  /// with the request id plus the decoded target (and text for type/submit);
  /// the handler replies with [sendUiActionResult].
  final void Function(String requestId, Map<String, dynamic> target)? onUiHover;
  final void Function(String requestId, Map<String, dynamic> target)? onUiFocus;
  final void Function(String requestId, Map<String, dynamic> target)? onUiBlur;
  final void Function(
    String requestId,
    Map<String, dynamic> target,
    String? text,
  )?
  onUiSubmit;
  final void Function(
    String requestId,
    Map<String, dynamic> target,
    String text,
  )?
  onUiType;
  final void Function(
    String requestId,
    Map<String, dynamic>? target,
    double deltaX,
    double deltaY,
  )?
  onUiScroll;

  WebSocket? _socket;
  bool _isDisposed = false;
  Completer<bool> _initialVerboseState = Completer<bool>();
  Timer? _reconnectTimer;
  Duration _reconnectDelay = _initialReconnectDelay;
  bool _reconnectInFlight = false;
  bool _notifiedConnected = false;
  bool _hasConnectedOnce = false;

  /// Bumped whenever the active socket is replaced or torn down so a stale
  /// `onDone` / `onError` from a closed predecessor cannot schedule reconnect
  /// or clear the socket that just replaced it.
  int _socketGeneration = 0;

  static const Duration _initialReconnectDelay = Duration(seconds: 1);
  static const Duration _maxReconnectDelay = Duration(seconds: 30);

  LiveConnection({
    required this.serverUrl,
    String? deviceName,
    this.onReload,
    this.onReloadBatch,
    this.onBreakpoints,
    this.onResume,
    this.onSetVmDebugger,
    this.onSetVerbose,
    this.onError,
    this.onConnectionChanged,
    this.onReconnected,
    this.autoReconnect = true,
    this.onRestart,
    this.onUiProbeRequest,
    this.onUiTap,
    this.onUiHover,
    this.onUiFocus,
    this.onUiBlur,
    this.onUiSubmit,
    this.onUiType,
    this.onUiScroll,
  }) : deviceName = (deviceName != null && deviceName.trim().isNotEmpty)
           ? deviceName.trim()
           : resolveDeviceName();

  bool get isConnected =>
      _socket != null && _socket!.readyState == WebSocket.open;

  /// True while a reconnect attempt is scheduled or in flight after a drop.
  bool get isReconnecting =>
      !_isDisposed &&
      !isConnected &&
      autoReconnect &&
      (_reconnectInFlight || (_reconnectTimer?.isActive ?? false));

  static Map<String, dynamic> _targetMap(Map<String, dynamic> data) {
    final target = data['target'];
    if (target is Map<String, dynamic>) return target;
    if (target is Map) return Map<String, dynamic>.from(target);
    return const {};
  }

  /// Connects to the dev server WebSocket at `ws://$host:$port/ws`.
  Future<void> connect({Duration timeout = const Duration(seconds: 5)}) async {
    _isDisposed = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    if (_initialVerboseState.isCompleted) {
      _initialVerboseState = Completer<bool>();
    }
    final baseWs = Uri.parse('${serverUrl.replaceFirst('http', 'ws')}/ws');
    final wsUrl = baseWs
        .replace(
          queryParameters: {
            if (deviceName.isNotEmpty) 'deviceName': deviceName,
            'platform': Platform.operatingSystem,
          },
        )
        .toString();
    final generation = ++_socketGeneration;

    try {
      final previous = _socket;
      _socket = null;
      previous?.close();
      final socket = await WebSocket.connect(wsUrl).timeout(timeout);
      if (_isDisposed || generation != _socketGeneration) {
        socket.close();
        return;
      }

      _socket = socket;
      _reconnectDelay = _initialReconnectDelay;
      _reconnectInFlight = false;
      final isReconnect = _hasConnectedOnce;
      _hasConnectedOnce = true;
      _setConnected(true);
      if (isReconnect) {
        onReconnected?.call();
      }
      socket.listen(
        (message) {
          if (generation != _socketGeneration) return;
          try {
            final data = jsonDecode(message as String) as Map<String, dynamic>;
            final type = data['type']?.toString();

            if (type == 'reload') {
              final changedFile = data['changedFile'] as String?;
              final rawFiles = data['changedFiles'];
              final isAssetChange = data['isAssetChange'] == true;
              final changedFiles = <String>[];
              if (rawFiles is List) {
                for (final f in rawFiles) {
                  if (f != null) changedFiles.add(f.toString());
                }
              } else if (changedFile != null && changedFile.isNotEmpty) {
                changedFiles.add(changedFile);
              }
              if (onReloadBatch != null) {
                onReloadBatch?.call(changedFiles, isAssetChange: isAssetChange);
              } else {
                onReload?.call(changedFile);
              }
            } else if (type == 'restart') {
              onRestart?.call();
            } else if (type == 'breakpoints') {
              final bpList = (data['breakpoints'] as List)
                  .cast<Map<String, dynamic>>();
              onBreakpoints?.call(bpList);
            } else if (type == 'resume') {
              onResume?.call();
            } else if (type == 'set_vm_debugger') {
              onSetVmDebugger?.call(data['enabled'] == true);
            } else if (type == 'set_verbose') {
              final enabled = data['enabled'] == true;
              onSetVerbose?.call(enabled);
              if (!_initialVerboseState.isCompleted) {
                _initialVerboseState.complete(true);
              }
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
          if (generation != _socketGeneration) return;
          _handleSocketClosed(generation);
        },
        onError: (e) {
          if (generation != _socketGeneration) return;
          onError?.call(e.toString());
          _handleSocketClosed(generation);
        },
      );
    } catch (e) {
      if (generation != _socketGeneration) return;
      _socket = null;
      onError?.call(e.toString());
      if (!_initialVerboseState.isCompleted) {
        _initialVerboseState.complete(false);
      }
      _setConnected(false);
      _scheduleReconnect();
    }
  }

  void _setConnected(bool connected) {
    if (_notifiedConnected == connected) return;
    _notifiedConnected = connected;
    onConnectionChanged?.call(connected);
  }

  void _handleSocketClosed(int generation) {
    if (generation != _socketGeneration) return;
    _socket = null;
    if (!_initialVerboseState.isCompleted) {
      _initialVerboseState.complete(false);
    }
    _setConnected(false);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_isDisposed || !autoReconnect) return;
    if (isConnected) return;
    if (_reconnectTimer?.isActive ?? false) return;
    if (_reconnectInFlight) return;

    final delay = _reconnectDelay;
    final nextMs = (delay.inMilliseconds * 2).clamp(
      _initialReconnectDelay.inMilliseconds,
      _maxReconnectDelay.inMilliseconds,
    );
    _reconnectDelay = Duration(milliseconds: nextMs);
    _reconnectTimer = Timer(delay, () async {
      if (_isDisposed || !autoReconnect || isConnected) return;
      _reconnectInFlight = true;
      try {
        await connect();
      } finally {
        _reconnectInFlight = false;
        if (!_isDisposed && !isConnected && autoReconnect) {
          _scheduleReconnect();
        }
      }
    });
  }

  /// Waits for the server's initial verbose setting before the first guest
  /// evaluation, so diagnostic callbacks are enabled for the cold load.
  ///
  /// Returns false if the server does not send the setting before [timeout] or
  /// the connection closes. Older servers can still launch; callers can warn
  /// that the initial verbose profile may be incomplete.
  Future<bool> waitForInitialVerbose({
    Duration timeout = const Duration(seconds: 2),
  }) => _initialVerboseState.future.timeout(timeout, onTimeout: () => false);

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

  /// Sends structured reload or restart timing telemetry to the dev server so
  /// Normal mode can render concise per-phase timings without verbose log noise.
  void sendReloadStats({
    required bool isRestart,
    required int totalMs,
    required Map<String, int> timings,
  }) {
    if (!isConnected) return;
    try {
      _socket?.add(
        jsonEncode({
          'type': isRestart ? 'restart_stats' : 'reload_stats',
          'totalMs': totalMs,
          'timings': timings,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );
    } catch (_) {}
  }

  /// Sends initial connect/launch timing and bundle metadata to the dev server.
  void sendLaunchStats({
    required String mode,
    required int totalMs,
    required Map<String, int> timings,
    int? bundleBytes,
    int? moduleCount,
    int? assetCount,
  }) {
    if (!isConnected) return;
    try {
      _socket?.add(
        jsonEncode({
          'type': 'launch_stats',
          'mode': mode,
          'totalMs': totalMs,
          'timings': timings,
          'bundleBytes': ?bundleBytes,
          'moduleCount': ?moduleCount,
          'assetCount': ?assetCount,
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
    sendUiActionResult(
      'ui_tap_result',
      requestId,
      ok,
      error: error,
      viewId: null,
    );
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

  /// Closes the connection and cancels any pending reconnect attempts.
  void disconnect() {
    _isDisposed = true;
    _socketGeneration++;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectInFlight = false;
    _reconnectDelay = _initialReconnectDelay;
    final socket = _socket;
    _socket = null;
    socket?.close();
    if (!_initialVerboseState.isCompleted) {
      _initialVerboseState.complete(false);
    }
    _setConnected(false);
  }
}

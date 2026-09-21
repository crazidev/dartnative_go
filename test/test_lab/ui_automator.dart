/// WS-based UI automation driver — same script runs headless and on-device.
///
/// Pure Dart (`dart:async`/`convert`/`io` only): importable from `tool/`
/// scripts under vanilla `dart run` as well as from `dn test` suites.
/// Headless device stand-in lives in `ui_simulated_device.dart` (needs
/// `dart:ui` via the harness).
///
/// Headless: drive a simulated device through [FakeDevServer]. On-device:
/// point [UiAutomator] at the real dev server URL while the DartNative Go
/// app (with the probe handler wired in `lib/main.dart`) is connected —
/// `probe()` / `tap()` work identically, because the wire protocol is the
/// same (`lib/src/runner/ui_probe.dart`).
///
/// ```dart
/// final auto = UiAutomator(serverUrl: server.baseUrl);
/// await auto.connect();
/// final tree = await auto.probe();
/// UiAutomator.expectText(tree, 'Count: 11');
/// await auto.tap('Increment');
/// ```
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/runner/ui_tree_json.dart';

/// Failure of a UI automation step (assertion or device-side error).
class UiAutomationFailure implements Exception {
  final String message;
  const UiAutomationFailure(this.message);

  @override
  String toString() => 'UiAutomationFailure: $message';
}

/// Drives UI automation over the dev-server WebSocket.
class UiAutomator {
  final String serverUrl;
  final Duration stepTimeout;

  WebSocket? _socket;
  int _nextRequestId = 0;
  final Map<String, Completer<Map<String, dynamic>>> _pendingTrees = {};
  final Map<String, Completer<Map<String, dynamic>>> _pendingTaps = {};
  final Map<String, Completer<Map<String, dynamic>>> _pendingActions = {};

  UiAutomator({
    required this.serverUrl,
    this.stepTimeout = const Duration(seconds: 10),
  });

  Future<void> connect() async {
    final wsUrl = '${serverUrl.replaceFirst('http', 'ws')}/ws';
    _socket = await WebSocket.connect(wsUrl).timeout(stepTimeout);
    _socket!.listen(
      (message) {
        try {
          final data = jsonDecode(message as String);
          if (data is! Map<String, dynamic>) return;
          final requestId = data['requestId']?.toString();
          if (requestId == null) return;
          if (data['type'] == 'ui_tree') {
            _pendingTrees.remove(requestId)?.complete(data);
          } else if (data['type'] == 'ui_tap_result') {
            _pendingTaps.remove(requestId)?.complete(data);
          } else if ((data['type'] as String?)?.endsWith('_result') == true) {
            _pendingActions.remove(requestId)?.complete(data);
          }
        } catch (_) {}
      },
      onDone: () => _socket = null,
      onError: (_) => _socket = null,
    );
  }

  String _requestId() => 'ui_${DateTime.now().millisecondsSinceEpoch}_${_nextRequestId++}';

  void _send(Map<String, dynamic> data) {
    final socket = _socket;
    if (socket == null) {
      throw const UiAutomationFailure('UiAutomator is not connected');
    }
    socket.add(jsonEncode(data));
  }

  /// Asks the device for its current widget tree; throws on timeout or when
  /// the device reports no mounted app.
  Future<Map<String, dynamic>> probe() async {
    final requestId = _requestId();
    final pending = Completer<Map<String, dynamic>>();
    _pendingTrees[requestId] = pending;
    _send({'type': 'ui_probe_request', 'requestId': requestId});
    final answer = await pending.future.timeout(
      stepTimeout,
      onTimeout: () {
        _pendingTrees.remove(requestId);
        throw UiAutomationFailure(
          'probe $requestId timed out after ${stepTimeout.inSeconds}s '
          '(is the app connected and mounted?)',
        );
      },
    );
    final tree = answer['tree'];
    if (tree is Map<String, dynamic> && tree['type'] == 'Error') {
      throw UiAutomationFailure('probe failed: ${tree['error']}');
    }
    if (tree is! Map<String, dynamic>) {
      throw UiAutomationFailure('probe returned a malformed tree: $tree');
    }
    return tree;
  }

  /// Taps the button titled [title]; throws when the device reports failure.
  Future<void> tap(String title) async {
    final requestId = _requestId();
    final pending = Completer<Map<String, dynamic>>();
    _pendingTaps[requestId] = pending;
    _send({'type': 'ui_tap', 'requestId': requestId, 'title': title});
    final answer = await pending.future.timeout(
      stepTimeout,
      onTimeout: () {
        _pendingTaps.remove(requestId);
        throw UiAutomationFailure(
          'tap "$title" timed out after ${stepTimeout.inSeconds}s',
        );
      },
    );
    if (answer['ok'] != true) {
      throw UiAutomationFailure('tap "$title" failed: ${answer['error']}');
    }
  }

  /// Sends a trigger action (`ui_hover`, `ui_focus`, `ui_blur`, `ui_submit`,
  /// `ui_type`) for [target] and returns the device-reported `viewId`
  /// (may be null on Level-1-only trees). Throws on device failure.
  ///
  /// [target] keys: `title`, `text`, `key`, `icon_code_point`,
  /// `icon_font_family`. [text] carries the submit/type payload.
  Future<int?> action(
    String type, {
    Map<String, dynamic>? target,
    String? text,
  }) async {
    final requestId = _requestId();
    final pending = Completer<Map<String, dynamic>>();
    _pendingActions[requestId] = pending;
    _send({
      'type': type,
      'requestId': requestId,
      'target': target ?? const {},
      'text': ?text,
    });
    final answer = await pending.future.timeout(
      stepTimeout,
      onTimeout: () {
        _pendingActions.remove(requestId);
        throw UiAutomationFailure(
          '$type timed out after ${stepTimeout.inSeconds}s',
        );
      },
    );
    if (answer['ok'] != true) {
      throw UiAutomationFailure('$type failed: ${answer['error']}');
    }
    final viewId = answer['viewId'];
    return viewId is int ? viewId : null;
  }

  /// Hover: resolve [target] and report its native `viewId`.
  Future<int?> hover({Map<String, dynamic>? target}) =>
      action('ui_hover', target: target);

  /// Focus: `TextField.focusNode.requestFocus()`.
  Future<int?> focus({Map<String, dynamic>? target}) =>
      action('ui_focus', target: target);

  /// Blur: `TextField.focusNode.unfocus()`.
  Future<int?> blur({Map<String, dynamic>? target}) =>
      action('ui_blur', target: target);

  /// Submit: `TextField.onSubmitted`, with optional [text] override.
  Future<int?> submit({Map<String, dynamic>? target, String? text}) =>
      action('ui_submit', target: target, text: text);

  /// Type: set `TextField` controller text and fire `onChanged`.
  Future<int?> type({Map<String, dynamic>? target, required String text}) =>
      action('ui_type', target: target, text: text);

  Future<void> disconnect() async {
    _pendingTrees.clear();
    _pendingTaps.clear();
    _pendingActions.clear();
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
  }

  /// Polls `probe()` until the tree contains [text] (or no longer contains
  /// [absentText], or contains button [button]), or [timeout] elapses.
  ///
  /// Required after taps and reloads: remounts are async, so a single probe
  /// races the app. Returns the first satisfying tree.
  Future<Map<String, dynamic>> probeUntil({
    String? text,
    String? absentText,
    String? button,
    String? key,
    int? iconCodePoint,
    String? iconFontFamily,
    Duration timeout = const Duration(seconds: 10),
    Duration interval = const Duration(milliseconds: 300),
  }) async {
    final deadline = DateTime.now().add(timeout);
    Map<String, dynamic>? last;
    while (DateTime.now().isBefore(deadline)) {
      last = await probe();
      final okText = text == null || findTextNodes(last, text).isNotEmpty;
      final okAbsent =
          absentText == null || findTextNodes(last, absentText).isEmpty;
      final okButton =
          button == null || findButtonNodes(last, button).isNotEmpty;
      final okKey = key == null || findKeyNodes(last, key).isNotEmpty;
      final okIcon = iconCodePoint == null && iconFontFamily == null ||
          findIconNodes(last,
                  codePoint: iconCodePoint, fontFamily: iconFontFamily)
              .isNotEmpty;
      if (okText && okAbsent && okButton && okKey && okIcon) return last;
      await Future<void>.delayed(interval);
    }
    final want = [
      if (text != null) 'text "$text"',
      if (absentText != null) 'no text "$absentText"',
      if (button != null) 'button "$button"',
      if (key != null) 'key "$key"',
      if (iconCodePoint != null) 'icon $iconCodePoint',
      if (iconFontFamily != null) 'icon font "$iconFontFamily"',
    ].join(', ');
    throw UiAutomationFailure(
      'probeUntil timed out waiting for $want after ${timeout.inSeconds}s. '
      'Last tree:\n${jsonEncode(last)}',
    );
  }

  /// Asks the dev server to broadcast a `reload` (test-originated hot reload).
  ///
  /// The server only relays messages tagged `origin: test`; device reloads
  /// originate server-side, so this cannot loop. Prefer file-edit reloads
  /// (they exercise watcher → rebuild → broadcast → refetch); use this when
  /// the driver has no filesystem access to the project.
  void triggerReload([String? changedFile]) {
    _send({
      'type': 'reload',
      'origin': 'test',
      'changedFile': ?changedFile,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Asks the app to hot-restart: drop interpreter state and evaluate the
  /// current bundle fresh (also (re)mounts after an error/empty state).
  ///
  /// Returns immediately; follow with `probeUntil` for the expected
  /// post-restart tree. The `restart:` scenario step does both.
  void triggerRestart() {
    _send({
      'type': 'restart',
      'origin': 'test',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // -- tree assertions (work on probe() results headless AND on-device) --

  static void expectText(Map<String, dynamic> tree, String data) {
    if (findTextNodes(tree, data).isEmpty) {
      throw UiAutomationFailure(
        'expected Text "$data" in tree, got:\n${jsonEncode(tree)}',
      );
    }
  }

  static void expectNoText(Map<String, dynamic> tree, String data) {
    if (findTextNodes(tree, data).isNotEmpty) {
      throw UiAutomationFailure('expected no Text "$data", but found it');
    }
  }

  static void expectButton(Map<String, dynamic> tree, String title) {
    if (findButtonNodes(tree, title).isEmpty) {
      throw UiAutomationFailure(
        'expected Button "$title" in tree, got:\n${jsonEncode(tree)}',
      );
    }
  }

  static void expectKey(Map<String, dynamic> tree, String key) {
    if (findKeyNodes(tree, key).isEmpty) {
      throw UiAutomationFailure(
        'expected key "$key" in tree, got:\n${jsonEncode(tree)}',
      );
    }
  }

  static void expectIcon(
    Map<String, dynamic> tree, {
    int? codePoint,
    String? fontFamily,
  }) {
    if (codePoint == null && fontFamily == null) {
      throw UiAutomationFailure(
          'expectIcon needs code_point and/or font_family');
    }
    if (findIconNodes(tree, codePoint: codePoint, fontFamily: fontFamily)
        .isEmpty) {
      throw UiAutomationFailure(
        'expected Icon(codePoint: $codePoint, fontFamily: $fontFamily) '
        'in tree, got:\n${jsonEncode(tree)}',
      );
    }
  }
}

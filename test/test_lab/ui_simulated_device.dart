/// Headless stand-in for the mobile app: answers `ui_probe_request` /
/// `ui_tap` with a [DnHarness] tree, using the same handler logic as
/// `lib/main.dart`. Lets automation scripts run fully headless in CI.
///
/// Needs `dart:ui` (via the harness) — run under `dn test`. The plain
/// `UiAutomator` driver in `ui_automator.dart` stays importable from `tool/`
/// scripts under vanilla `dart run`.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/runner/ui_probe.dart';

import 'harness.dart';

class SimulatedDevice {
  final DnHarness harness;
  final String serverUrl;

  WebSocket? _socket;

  SimulatedDevice({required this.harness, required this.serverUrl});

  Future<void> connect() async {
    final wsUrl = '${serverUrl.replaceFirst('http', 'ws')}/ws';
    _socket = await WebSocket.connect(wsUrl);
    _socket!.listen((message) async {
      try {
        final data = jsonDecode(message as String);
        if (data is! Map<String, dynamic>) return;
        final type = data['type']?.toString();
        final requestId = data['requestId']?.toString() ?? '';
        if (type == 'ui_probe_request') {
          final root = harness.lastRoot;
          _send({
            'type': 'ui_tree',
            'requestId': requestId,
            'tree': root == null
                ? {'type': 'Error', 'error': 'no app mounted'}
                : serializeTree(root),
          });
        } else if (type == 'ui_tap') {
          final root = harness.lastRoot;
          if (root == null) {
            _send({
              'type': 'ui_tap_result',
              'requestId': requestId,
              'ok': false,
              'error': 'no app mounted',
            });
            return;
          }
          final error = tapButtonByTitle(root, data['title']?.toString() ?? '');
          _send({
            'type': 'ui_tap_result',
            'requestId': requestId,
            'ok': error == null,
            'error': ?error,
          });
        } else if (type == 'ui_hover' ||
            type == 'ui_focus' ||
            type == 'ui_blur' ||
            type == 'ui_submit' ||
            type == 'ui_type') {
          // Same trigger logic as `lib/main.dart`, over the harness tree.
          final root = harness.lastRoot;
          if (root == null) {
            _send({
              'type': '${type}_result',
              'requestId': requestId,
              'ok': false,
              'error': 'no app mounted',
            });
            return;
          }
          final spec = TargetSpec.fromJson(_targetMap(data));
          final TriggerOutcome outcome;
          switch (type) {
            case 'ui_hover':
              outcome = hoverTarget(widgetRoot: root, spec: spec);
            case 'ui_focus':
              outcome = focusTarget(widgetRoot: root, spec: spec);
            case 'ui_blur':
              outcome = blurTarget(widgetRoot: root, spec: spec);
            case 'ui_submit':
              outcome = submitTarget(
                widgetRoot: root,
                spec: spec,
                text: data['text']?.toString(),
              );
            default:
              outcome = typeIntoTarget(
                widgetRoot: root,
                spec: spec,
                text: data['text']?.toString() ?? '',
              );
          }
          _send(outcome.toJson(requestId, '${type}_result'));
        } else if (type == 'restart') {
          // Test-originated hot restart: fresh interpreter over the same
          // guest files (mirrors `_restartApp` in `lib/main.dart`).
          if (harness.guestFiles.isNotEmpty) {
            try {
              await harness.hotRestart(harness.guestFiles);
            } catch (_) {}
          }
        }
      } catch (_) {}
    });
  }

  void _send(Map<String, dynamic> data) {
    try {
      _socket?.add(jsonEncode(data));
    } catch (_) {}
  }

  static Map<String, dynamic> _targetMap(Map<String, dynamic> data) {
    final target = data['target'];
    if (target is Map<String, dynamic>) return target;
    if (target is Map) return Map<String, dynamic>.from(target);
    return const {};
  }

  Future<void> disconnect() async {
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
  }
}

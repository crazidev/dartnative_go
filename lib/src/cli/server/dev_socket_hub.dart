/// WebSocket side of the dev server: client registry, broadcasts, and the
/// message protocol (logs, verbose sync, breakpoints, UI-automation relay).
library;

import 'dart:convert';
import 'dart:io';

import '../../runner/logger.dart';
import '../packaging/ast_builder.dart';
import 'http_support.dart';

/// `ui_*` requests a test script sends to drive the device.
const _uiRequests = {
  'ui_probe_request',
  'ui_tap',
  'ui_hover',
  'ui_focus',
  'ui_blur',
  'ui_submit',
  'ui_type',
  'ui_scroll',
};

/// `ui_*` answers the device sends back.
const _uiResults = {
  'ui_tap_result',
  'ui_hover_result',
  'ui_focus_result',
  'ui_blur_result',
  'ui_submit_result',
  'ui_type_result',
  'ui_scroll_result',
};

class DevSocketHub {
  DevSocketHub(this.projectDir);

  final Directory projectDir;
  final List<WebSocket> _sockets = [];

  /// Breakpoints replayed to every newly connected client.
  final List<Map<String, dynamic>> breakpoints = [];

  int get clientCount => _sockets.length;

  /// Upgrades [request] to a WebSocket and starts handling its messages.
  Future<void> accept(HttpRequest request) async {
    if (!WebSocketTransformer.isUpgradeRequest(request)) {
      sendText(request, HttpStatus.badRequest, 'Expected WebSocket upgrade');
      return;
    }
    final socket = await WebSocketTransformer.upgrade(request);
    _sockets.add(socket);
    print('[DevServer] [WS] Client connected (${_sockets.length} active)');

    socket.add(
      jsonEncode({'type': 'set_verbose', 'enabled': DartGoLogger.verbose}),
    );
    if (breakpoints.isNotEmpty) {
      socket.add(
        jsonEncode({'type': 'breakpoints', 'breakpoints': breakpoints}),
      );
    }

    socket.listen(
      (message) {
        try {
          final data = jsonDecode(message as String);
          if (data is Map) _onMessage(data);
        } catch (_) {}
      },
      onDone: () {
        _sockets.remove(socket);
        print(
          '[DevServer] [WS] Client disconnected (${_sockets.length} active)',
        );
      },
      onError: (_) => _sockets.remove(socket),
    );
  }

  void broadcast(Map<String, dynamic> data) {
    final payload = jsonEncode(data);
    for (final ws in _sockets) {
      try {
        ws.add(payload);
      } catch (_) {}
    }
  }

  void broadcastBreakpoints() =>
      broadcast({'type': 'breakpoints', 'breakpoints': breakpoints});

  /// Announces a reload. [changed] is a path or an iterable of paths,
  /// rebased onto [baseDir]. Code reloads carry the patch URL when a delta
  /// bundle is available; asset reloads never do.
  void broadcastReload([
    Object? changed,
    String? baseDir,
    bool isAssetChange = false,
  ]) {
    final paths = <String>[
      if (changed is String && changed.isNotEmpty) _relative(changed, baseDir),
      if (changed is Iterable)
        for (final item in changed)
          if (item is String && item.isNotEmpty) _relative(item, baseDir),
    ];
    final patch = patchBytesForProject(projectDir);
    final usePatch = patch != null && patch.isNotEmpty && !isAssetChange;
    broadcast({
      'type': 'reload',
      'changedFile': paths.firstOrNull,
      'changedFiles': paths,
      'isPatch': usePatch,
      'isAssetChange': isAssetChange,
      'patchUrl': usePatch ? '/guest.ast.patch' : null,
      'patchSize': usePatch ? patch.length : null,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void closeAll() {
    for (final ws in _sockets) {
      try {
        ws.close();
      } catch (_) {}
    }
  }

  static String _relative(String path, String? baseDir) {
    final rel = baseDir == null ? path : path.replaceFirst('$baseDir/', '');
    return rel.replaceAll(r'\', '/');
  }

  void _onMessage(Map data) {
    final type = data['type'];
    final fromTest = data['origin'] == 'test';
    switch (type) {
      case 'log':
        _printDeviceLog(data);
      case 'set_verbose':
        final enabled = data['enabled'] == true;
        DartGoLogger.verbose = enabled;
        print('\n[VERBOSE] Toggled from app: ${verboseLabel(enabled)}\n');
        broadcast({'type': 'set_verbose', 'enabled': enabled});
      case 'breakpoint_hit':
        _printBreakpointHit(data);
      // Test scripts have no filesystem access; only `origin: test` is
      // honored, so device-originated reloads cannot loop back.
      case 'reload' when fromTest:
        print('[DevServer] [UI] Test-triggered reload requested');
        broadcastReload(data['changedFile']?.toString(), projectDir.path);
      case 'restart' when fromTest:
        print('[DevServer] [UI] Test-triggered restart requested');
        broadcast({
          'type': 'restart',
          'origin': 'test',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      case 'ui_tree':
        print(
          '[DevServer] [UI] UI tree received (request ${data['requestId'] ?? '?'})',
        );
        broadcast(Map<String, dynamic>.from(data));
      case final String t when _uiRequests.contains(t):
        broadcast(Map<String, dynamic>.from(data));
      case final String t when _uiResults.contains(t):
        _printUiResult(t, data);
        broadcast(Map<String, dynamic>.from(data));
    }
  }

  void _printDeviceLog(Map data) {
    final time = DateTime.now().toIso8601String().substring(11, 19);
    final msg = data['message'] ?? '';
    if ((data['level'] ?? 'INFO') == 'ERROR') {
      print('\x1B[31m[$time][Device Error]\x1B[0m $msg');
    } else {
      print('\x1B[36m[$time][Device Log]\x1B[0m $msg');
    }
  }

  void _printBreakpointHit(Map data) {
    final vars = data['variables'] as Map?;
    print(
      '\n\x1B[31m[STOP] BREAKPOINT HIT: ${data['file'] ?? '<guest>'}:${data['line'] ?? '?'}\x1B[0m',
    );
    if (data['message'] != null) print('   Note: ${data['message']}');
    if (vars != null && vars.isNotEmpty) {
      print('   Variables:');
      vars.forEach((k, v) => print('     $k = $v'));
    }
    print('   -> Type c to resume execution.\n');
  }

  void _printUiResult(String type, Map data) {
    final req = data['requestId'] ?? '?';
    final action = type.replaceFirst('ui_', '').replaceFirst('_result', '');
    if (data['ok'] == true) {
      final view = data['viewId'];
      print(
        '[DevServer] [UI] $action ok (request $req${view != null ? ', view $view' : ''})',
      );
    } else {
      print('[DevServer] [UI] $action FAILED (request $req): ${data['error']}');
    }
  }
}

/// Colored ON/OFF label for verbose-mode messages.
String verboseLabel(bool enabled) => enabled
    ? '\x1B[32mON\x1B[0m (detailed telemetry)'
    : '\x1B[33mOFF\x1B[0m (clean output)';

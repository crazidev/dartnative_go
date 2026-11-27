/// WebSocket side of the dev server: client registry, broadcasts, and the
/// message protocol (logs, verbose sync, breakpoints, UI-automation relay).
library;

import 'dart:convert';
import 'dart:io';

import '../../runner/logger.dart';
import '../packaging/ast_builder.dart';
import 'http_support.dart';
import 'terminal_ui.dart';

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
  DevSocketHub(this.projectDir, {DevServerConsole? console})
    : console = console ?? DevServerConsole();

  final Directory projectDir;
  final DevServerConsole console;
  StartupScreenInfo? startupInfo;
  final List<WebSocket> _sockets = [];
  final Map<WebSocket, String> _deviceNames = {};

  /// Breakpoints replayed to every newly connected client.
  final List<Map<String, dynamic>> breakpoints = [];

  int get clientCount => _sockets.length;

  /// Upgrades [request] to a WebSocket and starts handling its messages.
  Future<void> accept(HttpRequest request) async {
    if (!WebSocketTransformer.isUpgradeRequest(request)) {
      sendText(request, HttpStatus.badRequest, 'Expected WebSocket upgrade');
      return;
    }
    final rawName = request.uri.queryParameters['deviceName']?.trim();
    final deviceName = (rawName != null && rawName.isNotEmpty) ? rawName : null;
    final socket = await WebSocketTransformer.upgrade(request);
    _sockets.add(socket);
    if (deviceName != null) {
      _deviceNames[socket] = deviceName;
    }
    console.onDeviceConnected(_sockets.length, deviceName: deviceName);

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
          if (data is Map) _onMessage(data, socket: socket);
        } catch (_) {}
      },
      onDone: () {
        final name = _deviceNames.remove(socket);
        _sockets.remove(socket);
        console.onDeviceDisconnected(_sockets.length, deviceName: name);
      },
      onError: (_) {
        _deviceNames.remove(socket);
        _sockets.remove(socket);
      },
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

  /// Broadcasts hot restart so devices drop interpreter state and re-evaluate.
  void broadcastRestart({String origin = 'cli'}) {
    broadcast({
      'type': 'restart',
      'origin': origin,
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

  void _onMessage(Map data, {WebSocket? socket}) {
    final type = data['type'];
    final fromTest = data['origin'] == 'test';
    switch (type) {
      case 'hello':
        final name = data['deviceName']?.toString().trim();
        if (socket != null && name != null && name.isNotEmpty) {
          _deviceNames[socket] = name;
        }
      case 'log':
        _printDeviceLog(data);
      case 'launch_stats':
        _onLaunchStats(data);
      case 'reload_stats':
        _onStructuredStats(data, isRestart: false);
      case 'restart_stats':
        _onStructuredStats(data, isRestart: true);
      case 'set_verbose':
        final enabled = data['enabled'] == true;
        DartGoLogger.verbose = enabled;
        console.onVerboseToggled(
          enabled,
          startupInfo: startupInfo,
          fromApp: true,
        );
        broadcast({'type': 'set_verbose', 'enabled': enabled});
      case 'breakpoint_hit':
        _printBreakpointHit(data);
      // Test scripts have no filesystem access; only `origin: test` is
      // honored, so device-originated reloads cannot loop back.
      case 'reload' when fromTest:
        if (DartGoLogger.devLogs) {
          print('[DevServer] [UI] Test-triggered reload requested');
        }
        broadcastReload(data['changedFile']?.toString(), projectDir.path);
      case 'restart' when fromTest:
        if (DartGoLogger.devLogs) {
          print('[DevServer] [UI] Test-triggered restart requested');
        }
        broadcastRestart(origin: 'test');
      case 'ui_tree':
        if (DartGoLogger.devLogs) {
          print(
            '[DevServer] [UI] UI tree received (request ${data['requestId'] ?? '?'})',
          );
        }
        broadcast(Map<String, dynamic>.from(data));
      case final String t when _uiRequests.contains(t):
        broadcast(Map<String, dynamic>.from(data));
      case final String t when _uiResults.contains(t):
        _printUiResult(t, data);
        broadcast(Map<String, dynamic>.from(data));
    }
  }

  void _onLaunchStats(Map data) {
    final totalMs = data['totalMs'] is int ? data['totalMs'] as int : 0;
    final rawTimings = data['timings'];
    final timings = <String, int>{};
    if (rawTimings is Map) {
      rawTimings.forEach((key, value) {
        if (value is int) timings[key.toString()] = value;
      });
    }
    console.onDeviceLaunch(
      mode: data['mode']?.toString(),
      totalMs: totalMs,
      timings: timings,
      bundleBytes: data['bundleBytes'] is int ? data['bundleBytes'] as int : null,
      moduleCount: data['moduleCount'] is int ? data['moduleCount'] as int : null,
      assetCount: data['assetCount'] is int ? data['assetCount'] as int : null,
    );
  }

  void _onStructuredStats(Map data, {required bool isRestart}) {
    final totalMs = data['totalMs'] is int ? data['totalMs'] as int : 0;
    final rawTimings = data['timings'];
    final timings = <String, int>{};
    if (rawTimings is Map) {
      rawTimings.forEach((key, value) {
        if (value is int) timings[key.toString()] = value;
      });
    }
    console.onStructuredReloadOrRestart(
      isRestart: isRestart,
      totalMs: totalMs,
      timings: timings,
    );
  }

  void _printDeviceLog(Map data) {
    final msg = data['message']?.toString() ?? '';
    final level = data['level']?.toString() ?? 'INFO';
    console.onDeviceLog(msg, level: level);
  }

  void _printBreakpointHit(Map data) {
    final vars = data['variables'] as Map?;
    final loc = '${data['file'] ?? '<guest>'}:${data['line'] ?? '?'}';
    final lines = <String>[
      if (data['message'] != null) 'note: ${data['message']}',
      if (vars != null && vars.isNotEmpty)
        for (final entry in vars.entries) '${entry.key} = ${entry.value}',
      'press c or POST /resume to continue',
    ];
    console.onError('Breakpoint hit · $loc', lines.join('\n'));
  }

  void _printUiResult(String type, Map data) {
    if (!DartGoLogger.devLogs) return;
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

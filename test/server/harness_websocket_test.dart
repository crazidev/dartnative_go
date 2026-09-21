/// WebSocket event contract for the whole dartnative_go dev protocol.
///
/// No mobile app: a real [LiveConnection] client talks to the in-memory
/// [FakeDevServer] with `package:test`. Covers every message type the real
/// `DartGoServer` (`lib/src/cli/server.dart`) emits and consumes:
/// `reload`, `set_verbose`, `breakpoints`, `resume` (server → client) and
/// `log`, `set_verbose`, `breakpoint_hit` (client → server).
library;

import 'dart:async';

import 'package:dartnative_go/src/runner/live_connection.dart';
import 'package:test/test.dart';

import '../test_lab/fake_server.dart';

void main() {
  group('websocket events (LiveConnection + FakeDevServer)', () {
    late FakeDevServer server;

    setUp(() async {
      server = FakeDevServer(appName: 'WS App');
      await server.start();
    });

    tearDown(() async {
      await server.stop();
    });

    test('connects and receives reload with changed file', () async {
      final reloads = <String?>[];
      final conn = LiveConnection(
        serverUrl: server.baseUrl,
        onReload: reloads.add,
      );
      await conn.connect();
      expect(conn.isConnected, isTrue);

      server.emitReload('lib/main.dart');
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(reloads, contains('lib/main.dart'));
      conn.disconnect();
      expect(conn.isConnected, isFalse);
    });

    test('receives set_verbose toggles both directions', () async {
      final verboseStates = <bool>[];
      final conn = LiveConnection(
        serverUrl: server.baseUrl,
        onSetVerbose: verboseStates.add,
      );
      await conn.connect();

      server.emitVerbose(true);
      server.emitVerbose(false);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(verboseStates, equals([true, false]));

      // Client → server toggle lands on the fake server.
      conn.sendSetVerbose(true);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(
        server.receivedVerboseToggles.any((m) => m['enabled'] == true),
        isTrue,
      );
      conn.disconnect();
    });

    test('receives breakpoints and resume', () async {
      final receivedBreakpoints = <List<Map<String, dynamic>>>[];
      var resumed = false;
      final conn = LiveConnection(
        serverUrl: server.baseUrl,
        onBreakpoints: receivedBreakpoints.add,
        onResume: () => resumed = true,
      );
      await conn.connect();

      server.emitBreakpoints([
        {'file': 'main.dart', 'line': 15},
      ]);
      server.emitResume();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(receivedBreakpoints, hasLength(1));
      expect(receivedBreakpoints.single.single['line'], equals(15));
      expect(resumed, isTrue);
      conn.disconnect();
    });

    test('device logs arrive at the server terminal side', () async {
      final conn = LiveConnection(serverUrl: server.baseUrl);
      await conn.connect();

      conn.sendDeviceLog('hello from device');
      conn.sendDeviceLog('boom', level: 'ERROR');
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(
        server.receivedLogs.any(
          (m) => m['message'] == 'hello from device' && m['level'] == 'INFO',
        ),
        isTrue,
      );
      expect(
        server.receivedLogs.any(
          (m) => m['message'] == 'boom' && m['level'] == 'ERROR',
        ),
        isTrue,
      );
      conn.disconnect();
    });

    test('breakpoint hits arrive at the server', () async {
      final conn = LiveConnection(serverUrl: server.baseUrl);
      await conn.connect();

      conn.sendBreakpointHit({
        'file': 'main.dart',
        'line': 15,
        'message': 'tapped',
      });
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(server.receivedBreakpointHits, hasLength(1));
      expect(server.receivedBreakpointHits.single['line'], equals(15));
      conn.disconnect();
    });

    test('receives restart broadcasts via onRestart', () async {
      var restarted = false;
      final conn = LiveConnection(
        serverUrl: server.baseUrl,
        onRestart: () => restarted = true,
      );
      await conn.connect();

      server.emitRestart();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(restarted, isTrue);
      conn.disconnect();
    });
  });
}

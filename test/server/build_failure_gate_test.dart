/// A bundle build that fails must not broadcast a reload: with the previous
/// `guest.ast` still in place there is nothing new to fetch, so every device
/// keeps running its current generation instead of pointlessly re-evaluating.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/cli/server.dart';
import 'package:test/test.dart';

const _main = '''
import 'package:dartnative/dartnative.dart';

void main() {
  runApp(const Text('gate'));
}
''';

void main() {
  group('dev server failed-build gate (real DartGoServer)', () {
    late Directory tmp;
    late Directory projectDir;
    late DartGoServer server;
    late WebSocket socket;
    final messages = <Map<String, dynamic>>[];

    setUpAll(() async {
      tmp = Directory.systemTemp.createTempSync('dn_build_gate_');
      projectDir = Directory('${tmp.path}/gate_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: gate_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(_main);

      server = DartGoServer(
        DartGoServerOptions(
          projectDir: projectDir,
          startPort: 9140,
          endPort: 9145,
          enableBroadcast: false,
          enableQrCode: false,
          customHost: '127.0.0.1',
        ),
      );
      unawaited(server.start());
      for (var i = 0; i < 100 && server.boundPort == null; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      final port = server.boundPort;
      expect(port, isNotNull, reason: 'server did not bind in time');
      socket = await WebSocket.connect('ws://127.0.0.1:$port/ws');
      socket.listen((message) {
        try {
          final data = jsonDecode(message as String);
          if (data is Map<String, dynamic>) messages.add(data);
        } catch (_) {}
      });
      messages.clear();
    });

    tearDownAll(() async {
      await socket.close();
      server.stop();
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    int reloadsSeen() =>
        messages.where((m) => m['type'] == 'reload').length;

    Future<void> waitForReloads(int count) async {
      for (var i = 0; i < 200 && reloadsSeen() < count; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      expect(
        reloadsSeen(),
        greaterThanOrEqualTo(count),
        reason: 'timed out waiting for $count reload broadcast(s)',
      );
    }

    test('failed build broadcasts nothing, fixed build broadcasts', () async {
      File('${projectDir.path}/lib/main.dart')
          .writeAsStringSync('$_main\n// touch\n');
      await waitForReloads(1);
      final baseline = reloadsSeen();

      File('${projectDir.path}/lib/main.dart').deleteSync();
      await Future<void>.delayed(const Duration(seconds: 6));
      expect(
        reloadsSeen(),
        equals(baseline),
        reason: 'a failed rebuild must not broadcast: devices keep running',
      );

      File('${projectDir.path}/lib/main.dart').writeAsStringSync(_main);
      await waitForReloads(baseline + 1);
    });
  });
}

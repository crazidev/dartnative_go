import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/client/http_client.dart';
import 'package:dartnative_go/src/client/network_scanner.dart';
import 'package:dartnative_go/src/client/project_model.dart';
import 'package:test/test.dart';

void main() {
  group('client URL + project model', () {
    test('normalizeUrl handles bare host, trailing slash, https', () {
      expect(
        DartGoHttpClient.normalizeUrl('192.168.1.10:8088'),
        equals('http://192.168.1.10:8088'),
      );
      expect(
        DartGoHttpClient.normalizeUrl('http://localhost:8088/'),
        equals('http://localhost:8088'),
      );
      expect(
        DartGoHttpClient.normalizeUrl('https://myproject.com/'),
        equals('https://myproject.com'),
      );
    });

    test('DartGoProject manifest parsing + JSON round-trip', () {
      final project = DartGoProject.fromManifest(
        {
          'protocol': 'dart_go',
          'appName': 'Test App',
          'appVersion': '1.0.0',
          'serverUrl': 'http://127.0.0.1:8088',
          'hasIcon': true,
          'iconUrl': 'http://127.0.0.1:8088/assets/icon.png',
        },
        'http://127.0.0.1:8088',
      );
      expect(project.appName, equals('Test App'));
      expect(project.isActive, isTrue);
      expect(project.url, equals('http://127.0.0.1:8088'));
      expect(
        project.iconUrl,
        equals('http://127.0.0.1:8088/assets/icon.png'),
      );

      final reconstructed = DartGoProject.fromJson(project.toJson());
      expect(reconstructed.appName, equals(project.appName));
      expect(reconstructed.url, equals(project.url));
      expect(reconstructed.isActive, equals(project.isActive));
    });

    test('active projects sort above inactive, newest first', () {
      final list = [
        DartGoProject(
          appName: 'Inactive Old',
          url: 'http://192.168.1.1:8088',
          isActive: false,
          lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        DartGoProject(
          appName: 'Active Project A',
          url: 'http://192.168.1.2:8088',
          isActive: true,
          lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        DartGoProject(
          appName: 'Inactive Recent',
          url: 'http://192.168.1.3:8088',
          isActive: false,
          lastSeen: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
        DartGoProject(
          appName: 'Active Project B',
          url: 'http://192.168.1.4:8088',
          isActive: true,
          lastSeen: DateTime.now(),
        ),
      ];
      list.sort((a, b) {
        if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
        return b.lastSeen.compareTo(a.lastSeen);
      });
      expect(
        list.map((p) => p.appName).toList(),
        equals([
          'Active Project B',
          'Active Project A',
          'Inactive Recent',
          'Inactive Old',
        ]),
      );
    });
  });

  group('network scanner discovery', () {
    late HttpServer server;
    late DartGoNetworkScanner scanner;

    setUpAll(() async {
      // Ephemeral port: a fixed one (8090) collides with `server_integration`
      // and with any live dev server when the whole suite runs in parallel.
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final port = server.port;
      server.listen((req) {
        if (req.uri.path == '/manifest.json') {
          req.response
            ..headers.contentType = ContentType.json
            ..write(
              jsonEncode({
                'protocol': 'dart_go',
                'appName': 'Mock Live Dev Server',
                'appVersion': '0.1.0',
                'serverUrl': 'http://127.0.0.1:$port',
              }),
            )
            ..close();
        } else {
          req.response
            ..statusCode = HttpStatus.notFound
            ..close();
        }
      });
      scanner = DartGoNetworkScanner(startPort: port, endPort: port);
    });

    tearDownAll(() async {
      scanner.dispose();
      await server.close();
    });

    test('discovers live server across the port range', () async {
      await scanner.scanNow();
      final found = scanner.currentProjects.any(
        (p) => p.appName == 'Mock Live Dev Server' && p.isActive,
      );
      expect(found, isTrue);
    });

    test('fromBeacon preserves versioned iconUrl and appVersion', () {
      final project = DartGoProject.fromBeacon({
        'protocol': 'dart_go',
        'appName': 'Updated App',
        'appVersion': '2.0.0',
        'url': 'http://127.0.0.1:8088',
        'hasIcon': true,
        'iconUrl': 'http://127.0.0.1:8088/assets/icon.png?v=123-456',
      });
      expect(project.appVersion, equals('2.0.0'));
      expect(
        project.iconUrl,
        equals('http://127.0.0.1:8088/assets/icon.png?v=123-456'),
      );
    });

    test('emits update when iconUrl or appVersion changes on restart', () async {
      var iconVersion = 'v1';
      var appVersion = '1.0.0';
      final dynamicServer = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      final port = dynamicServer.port;
      dynamicServer.listen((req) {
        if (req.uri.path == '/manifest.json') {
          req.response
            ..headers.contentType = ContentType.json
            ..write(
              jsonEncode({
                'protocol': 'dart_go',
                'appName': 'Same Name',
                'appVersion': appVersion,
                'serverUrl': 'http://127.0.0.1:$port',
                'hasIcon': true,
                'iconUrl': 'http://127.0.0.1:$port/assets/icon.png?v=$iconVersion',
              }),
            )
            ..close();
        } else {
          req.response
            ..statusCode = HttpStatus.notFound
            ..close();
        }
      });

      final localScanner = DartGoNetworkScanner(startPort: port, endPort: port);
      final emissions = <List<DartGoProject>>[];
      final sub = localScanner.projectsStream.listen(emissions.add);
      try {
        await localScanner.scanNow();
        await Future<void>.delayed(Duration.zero);
        expect(emissions.length, equals(1));
        expect(
          emissions.last.single.iconUrl,
          endsWith('/assets/icon.png?v=v1'),
        );

        iconVersion = 'v2';
        appVersion = '1.0.1';
        await localScanner.scanNow();
        await Future<void>.delayed(Duration.zero);
        expect(emissions.length, equals(2));
        expect(
          emissions.last.single.iconUrl,
          endsWith('/assets/icon.png?v=v2'),
        );
        expect(emissions.last.single.appVersion, equals('1.0.1'));
      } finally {
        await sub.cancel();
        localScanner.dispose();
        await dynamicServer.close();
      }
    });
  });
}

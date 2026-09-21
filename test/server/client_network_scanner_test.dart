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

      final reconstructed =
          DartGoProject.fromJson(project.toJson());
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
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8090);
      server.listen((req) {
        if (req.uri.path == '/manifest.json') {
          req.response
            ..headers.contentType = ContentType.json
            ..write(jsonEncode({
              'protocol': 'dart_go',
              'appName': 'Mock Live Dev Server',
              'appVersion': '0.1.0',
              'serverUrl': 'http://127.0.0.1:8090',
            }))
            ..close();
        } else {
          req.response
            ..statusCode = HttpStatus.notFound
            ..close();
        }
      });
      scanner = DartGoNetworkScanner(startPort: 8088, endPort: 8092);
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
  });
}

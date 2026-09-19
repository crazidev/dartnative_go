import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/client/http_client.dart';
import 'package:dartnative_go/src/client/network_scanner.dart';
import 'package:dartnative_go/src/client/project_model.dart';

void main() async {
  print('Running client and scanner tests...');

  // Test 1: DartGoHttpClient.normalizeUrl
  assert(
    DartGoHttpClient.normalizeUrl('192.168.1.10:8088') ==
        'http://192.168.1.10:8088',
  );
  assert(
    DartGoHttpClient.normalizeUrl('http://localhost:8088/') ==
        'http://localhost:8088',
  );
  assert(
    DartGoHttpClient.normalizeUrl('https://myproject.com/') ==
        'https://myproject.com',
  );
  print('✔ Test 1: URL Normalization passed');

  // Test 2: DartGoProject serialization & factory from manifest
  final manifest = {
    'protocol': 'dart_go',
    'appName': 'Test App',
    'appVersion': '1.0.0',
    'serverUrl': 'http://127.0.0.1:8088',
    'hasIcon': true,
    'iconUrl': 'http://127.0.0.1:8088/assets/icon.png',
  };

  final project = DartGoProject.fromManifest(manifest, 'http://127.0.0.1:8088');
  assert(project.appName == 'Test App');
  assert(project.isActive == true);
  assert(project.url == 'http://127.0.0.1:8088');
  assert(project.iconUrl == 'http://127.0.0.1:8088/assets/icon.png');

  final json = project.toJson();
  final reconstructed = DartGoProject.fromJson(json);
  assert(reconstructed.appName == project.appName);
  assert(reconstructed.url == project.url);
  assert(reconstructed.isActive == project.isActive);
  print('✔ Test 2: Project serialization & manifest parsing passed');

  // Test 3: Sorting rule - active projects must be kept at the top
  final p1 = DartGoProject(
    appName: 'Inactive Old',
    url: 'http://192.168.1.1:8088',
    isActive: false,
    lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
  );
  final p2 = DartGoProject(
    appName: 'Active Project A',
    url: 'http://192.168.1.2:8088',
    isActive: true,
    lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
  );
  final p3 = DartGoProject(
    appName: 'Inactive Recent',
    url: 'http://192.168.1.3:8088',
    isActive: false,
    lastSeen: DateTime.now().subtract(const Duration(minutes: 1)),
  );
  final p4 = DartGoProject(
    appName: 'Active Project B',
    url: 'http://192.168.1.4:8088',
    isActive: true,
    lastSeen: DateTime.now(),
  );

  final list = [p1, p2, p3, p4];
  list.sort((a, b) {
    if (a.isActive != b.isActive) {
      return a.isActive ? -1 : 1;
    }
    return b.lastSeen.compareTo(a.lastSeen);
  });

  assert(list[0].appName == 'Active Project B');
  assert(list[1].appName == 'Active Project A');
  assert(list[2].appName == 'Inactive Recent');
  assert(list[3].appName == 'Inactive Old');
  print('✔ Test 3: Active projects kept at the top passed');

  // Test 4: Live mock HTTP server scanning across port range
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8090);
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

  final scanner = DartGoNetworkScanner(
    startPort: 8088,
    endPort: 8092,
  );

  await scanner.scanNow();
  final scanned = scanner.currentProjects;
  final foundMock = scanned.any((p) => p.appName == 'Mock Live Dev Server' && p.isActive);
  assert(foundMock, 'Scanner should discover live server on port 8090');
  print('✔ Test 4: Port-range network scanner discovery passed (found Mock Live Dev Server on port 8090)');

  scanner.dispose();
  await server.close();

  print('\nAll client & network scanner tests completed successfully! 🎉');
}

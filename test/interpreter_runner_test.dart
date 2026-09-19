import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/runner/bundle_loader.dart';
import 'package:dartnative_go/src/runner/live_connection.dart';

void main() async {
  print('====================================================');
  print('🚀 Running DartNative Go BundleLoader Test Suite');
  print('====================================================\n');

  // Test 1: BundleLoader.normalizeUrl
  assert(
    BundleLoader.normalizeUrl('192.168.1.100:8088') ==
        'http://192.168.1.100:8088',
  );
  assert(
    BundleLoader.normalizeUrl('http://localhost:8088/') ==
        'http://localhost:8088',
  );
  assert(
    BundleLoader.normalizeUrl('https://demo.dartnative.com/') ==
        'https://demo.dartnative.com',
  );
  print('✔ Test 1: BundleLoader URL normalization passed');

  // Test 2: LiveConnection message formatting & state
  final conn = LiveConnection(serverUrl: 'http://127.0.0.1:8088');
  assert(!conn.isConnected);
  conn.disconnect();
  print('✔ Test 2: LiveConnection initialization & disconnect passed');

  // Test 3: End-to-end BundleLoader with live mock server
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8095);
  server.listen((req) {
    if (req.uri.path == '/manifest.json') {
      req.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({
          'protocol': 'dart_go',
          'appName': 'Example App',
          'appVersion': '1.0.0',
          'hasSplash': true,
          'splashUrl': 'http://127.0.0.1:8095/assets/splash.png',
          'hasIcon': true,
          'iconUrl': 'http://127.0.0.1:8095/assets/icon.png',
          'splashBackgroundColor': '#111111',
          'serverUrl': 'http://127.0.0.1:8095',
        }))
        ..close();
    } else if (req.uri.path == '/bundle.json') {
      req.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({
          'manifest': {
            'appName': 'Example App',
            'appVersion': '1.0.0',
            'hasSplash': true,
            'splashUrl': 'http://127.0.0.1:8095/assets/splash.png',
            'hasIcon': true,
            'iconUrl': 'http://127.0.0.1:8095/assets/icon.png',
            'splashBackgroundColor': '#111111',
          },
          'files': {
            'main.dart': "import 'package:dartnative/dartnative.dart';\nWidget main() => const Text('Hello');",
            'helper.dart': "String greeting() => 'Hello';",
          },
        }))
        ..close();
    } else {
      req.response
        ..statusCode = HttpStatus.notFound
        ..close();
    }
  });

  final loader = BundleLoader();
  final bundle = await loader.fetchBundle('http://127.0.0.1:8095');

  assert(bundle.appName == 'Example App');
  assert(bundle.appVersion == '1.0.0');
  assert(bundle.splashUrl == 'http://127.0.0.1:8095/assets/splash.png');
  assert(bundle.iconUrl == 'http://127.0.0.1:8095/assets/icon.png');
  assert(bundle.splashBackgroundColor == '#111111');
  assert(bundle.sources.containsKey('main.dart'));
  assert(bundle.sources.containsKey('helper.dart'));
  assert(bundle.entrypointCode.contains("Widget main()"));
  print('✔ Test 3: BundleLoader successfully fetched & parsed manifest and multi-file bundle from server');

  loader.close();
  await server.close();

  print('\nAll interpreter runner & bundle loader tests passed! 🎉\n');
}

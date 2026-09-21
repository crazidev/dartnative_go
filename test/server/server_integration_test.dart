import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/cli/server.dart';
import 'package:test/test.dart';

/// Boots the real `DartGoServer` (ephemeral 9120..9125, no broadcast/QR)
/// and asserts the client-facing HTTP surface.
void main() {
  group('dev server HTTP surface (real DartGoServer)', () {
    late DartGoServer server;
    late HttpClient client;

    setUpAll(() async {
      server = DartGoServer(
        DartGoServerOptions(
          projectDir: Directory.current,
          startPort: 9120,
          endPort: 9125,
          enableBroadcast: false,
          enableQrCode: false,
          customHost: '127.0.0.1',
        ),
      );
      unawaited(server.start());
      await Future.delayed(const Duration(milliseconds: 500));
      client = HttpClient();
    });

    tearDownAll(() {
      server.stop();
      client.close(force: true);
    });

    Future<Map<String, dynamic>> getJson(String path) async {
      final req = await client.getUrl(Uri.parse('http://127.0.0.1:9120$path'));
      final res = await req.close();
      expect(res.statusCode, equals(HttpStatus.ok), reason: 'GET $path');
      return jsonDecode(await res.transform(utf8.decoder).join())
          as Map<String, dynamic>;
    }

    Future<List<int>> getBytes(String path, {String? mimeType}) async {
      final req = await client.getUrl(Uri.parse('http://127.0.0.1:9120$path'));
      final res = await req.close();
      expect(res.statusCode, equals(HttpStatus.ok), reason: 'GET $path');
      if (mimeType != null) {
        expect(res.headers.contentType?.mimeType, equals(mimeType));
      }
      return res.fold<List<int>>([], (a, b) => a..addAll(b));
    }

    test('/health reports status ok', () async {
      final health = await getJson('/health');
      expect(health['status'], equals('ok'));
      expect(health['appName'], equals('dartnative_go'));
    });

    test('/manifest.json carries protocol + icon', () async {
      final manifest = await getJson('/manifest.json');
      expect(manifest['protocol'], equals('dart_go'));
      expect(manifest['appName'], equals('dartnative_go'));
      expect(manifest['hasIcon'], isTrue);
      expect(manifest['iconUrl'], isNotNull);
    });

    test('/assets/icon.png serves bytes', () async {
      expect(await getBytes('/assets/icon.png'), isNotEmpty);
    });

    test('/assets.json lists discovered assets', () async {
      final assets = await getJson('/assets.json');
      expect(assets['assets'], isA<List>());
    });

    test('/assets/dn-logo.png serves PNG bytes', () async {
      expect(
        await getBytes('/assets/dn-logo.png', mimeType: 'image/png'),
        isNotEmpty,
      );
    });

    test('/asset?path= serves by query parameter', () async {
      expect(
        await getBytes('/asset?path=assets/dn-logo.png',
            mimeType: 'image/png'),
        isNotEmpty,
      );
    });

    test('/bundle.json carries files + manifest + assets', () async {
      final bundle = await getJson('/bundle.json');
      expect(bundle['files'], isA<Map>());
      expect(bundle['manifest'], isA<Map>());
      expect(bundle['assets'], isA<List>());
      expect(bundle['manifest']['assets'], isA<List>());
    });
  });
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/cli/server/server.dart';
import 'package:dartnative_go/src/runner/bundle_loader.dart';
import 'package:test/test.dart';

/// Serves a pre-built annotated app from a real `DartGoServer` (ephemeral
/// ports, no broadcast/QR, no rebuild) and asserts the Phase-5
/// server-component HTTP surface.
void main() {
  group('server-component endpoints (real DartGoServer)', () {
    late Directory tmp;
    late Directory proj;
    late DartGoServer server;
    late HttpClient client;
    const port = 9130;

    setUpAll(() async {
      tmp = Directory.systemTemp.createTempSync('dn_server_comp_ep_');
      proj = Directory('${tmp.path}/app')..createSync();
      final lib = Directory('${proj.path}/lib')..createSync(recursive: true);
      File('${proj.path}/pubspec.yaml').writeAsStringSync('name: demo_app\n');
      File('${lib.path}/helper.dart')
          .writeAsStringSync('int doubleIt(int x) => x * 2;\n');
      File('${lib.path}/card.dart').writeAsStringSync(
        "import 'helper.dart';\n"
        'class ServerComponent {\n'
        '  final String id;\n'
        '  final int version;\n'
        '  const ServerComponent({required this.id, this.version = 1});\n'
        '}\n'
        "@ServerComponent(id: 'profile_card')\n"
        'class ProfileCard {\n'
        '  const ProfileCard();\n'
        '  int answer() => doubleIt(21);\n'
        '}\n',
      );
      File('${lib.path}/main.dart').writeAsStringSync(
        "import 'card.dart';\n"
        'void main() {\n'
        '  ProfileCard();\n'
        '}\n',
      );

      final built = await buildGuestAstBundle(proj, force: true);
      expect(built.success, isTrue, reason: built.error);
      expect(built.serverComponents, isNotNull);

      server = DartGoServer(
        DartGoServerOptions(
          projectDir: proj,
          startPort: port,
          endPort: port + 5,
          enableBroadcast: false,
          enableQrCode: false,
          customHost: '127.0.0.1',
          rebuildAst: false,
        ),
      );
      unawaited(server.start());
      final deadline = DateTime.now().add(const Duration(seconds: 2));
      while (server.boundPort == null && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(server.boundPort, equals(port));
      client = HttpClient();
    });

    tearDownAll(() {
      server.stop();
      client.close(force: true);
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    Future<HttpClientResponse> get(String path) async {
      final req =
          await client.getUrl(Uri.parse('http://127.0.0.1:$port$path'));
      return req.close();
    }

    Future<dynamic> getJson(String path) async {
      final res = await get(path);
      expect(res.statusCode, equals(HttpStatus.ok), reason: 'GET $path');
      return jsonDecode(await res.transform(utf8.decoder).join());
    }

    test('/server-components/manifest.json lists the component', () async {
      final manifest =
          await getJson('/server-components/manifest.json') as Map;
      final components = manifest['components'] as Map;
      expect(components.keys, contains('profile_card'));
      final entry = components['profile_card'] as Map;
      expect(entry['url'], contains('profile_card.ast'));
      expect((entry['fingerprint'] as String), isNotEmpty);
    });

    test('/server-components/<id>.ast serves the delta bundle', () async {
      final res = await get('/server-components/profile_card.ast');
      expect(res.statusCode, equals(HttpStatus.ok));
      final bytes =
          await res.fold<List<int>>([], (a, b) => a..addAll(b));
      expect(bytes, isNotEmpty);
    });

    test('unknown component id is 404', () async {
      final res = await get('/server-components/nope.ast');
      expect(res.statusCode, equals(HttpStatus.notFound));
      await res.drain();
    });

    test('/client-module-index.json serves the client module set', () async {
      final index = await getJson('/client-module-index.json') as Map;
      final modules = (index['modules'] as List).cast<String>();
      expect(modules.any((m) => m.contains('main.dart')), isTrue);
      expect(modules.any((m) => m.contains('card.dart')), isTrue);
    });

    test('/manifest.json advertises server components', () async {
      final manifest = await getJson('/manifest.json') as Map;
      expect(manifest['hasServerComponents'], isTrue);
      expect(
        manifest['serverComponentsUrl'] as String,
        contains('/server-components/manifest.json'),
      );
      final components = manifest['serverComponents'] as Map;
      expect(components.keys, contains('profile_card'));
      final entry = components['profile_card'] as Map;
      expect((entry['url'] as String).startsWith('http'), isTrue);
    });

    test('BundleLoader fetches manifest + component bytes (device path)',
        () async {
      // This is exactly what the host app runs on a live device.
      final loader = BundleLoader();
      try {
        final baseUrl = 'http://127.0.0.1:$port';
        final manifest =
            await loader.fetchServerComponentsManifest(baseUrl);
        expect(manifest.keys, contains('profile_card'));
        expect(manifest['profile_card']!['fingerprint'], isNotEmpty);

        final bytes = await loader.fetchServerComponentBytes(
          baseUrl,
          'profile_card',
        );
        expect(bytes, isNotNull);
        expect(bytes, isNotEmpty);

        expect(
          await loader.fetchServerComponentBytes(baseUrl, 'nope'),
          isNull,
        );
        expect(
          await loader.fetchServerComponentBytes(baseUrl, '../guest'),
          isNull,
          reason: 'bad ids never reach the network',
        );
      } finally {
        loader.close();
      }
    });
  });
}

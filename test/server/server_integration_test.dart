import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/cli/server/server.dart';
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
          rebuildAst: false,
        ),
      );
      unawaited(server.start());
      final deadline = DateTime.now().add(const Duration(seconds: 2));
      while (server.boundPort == null && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(server.boundPort, equals(9120));
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

    test('/manifest.json serves AST bundle surface without bytecode', () async {
      final manifest = await getJson('/manifest.json');
      expect(
        manifest['hasAstBundle'],
        isA<bool>(),
        reason: 'the device boots from the advertised AST bundle flag',
      );
      expect(
        manifest['astUrl'] == null ||
            (manifest['astUrl'] as String).endsWith('/guest.ast'),
        isTrue,
        reason: 'the device fetches AST bytes from the advertised URL',
      );
      expect(
        manifest['astModuleFingerprints'],
        isA<Map>(),
        reason: 'per-module fingerprints drive module reuse on reload',
      );
      expect(
        manifest['astPending'],
        isA<bool>(),
        reason:
            'AST-mode clients wait for an in-flight build instead of '
            'falling back to source mode',
      );
      expect(
        manifest['profile'],
        isFalse,
        reason:
            'the AST BUNDLE explorer stays hidden unless the server '
            'starts with --profile',
      );
      for (final key in [
        'hasBytecodeBundle',
        'bytecodeUrl',
        'depMode',
        'depsHash',
        'depsCount',
        'depsUrl',
        'userCodeUrl',
        'userCodeHash',
      ]) {
        expect(
          manifest.containsKey(key),
          isFalse,
          reason: 'removed/source-mode key $key must not leak in manifest',
        );
      }
    });

    test('/guest.bc is gone', () async {
      final req = await client.getUrl(
        Uri.parse('http://127.0.0.1:9120/guest.bc'),
      );
      final res = await req.close();
      await res.drain();
      expect(
        res.statusCode,
        equals(HttpStatus.notFound),
        reason: 'no route may serve a bundle format nothing executes',
      );
    });

    test('source-mode endpoints are disabled (404)', () async {
      for (final path in [
        '/bundle.json',
        '/app.dart',
        '/user-code.zip',
        '/user-code-hash',
        '/deps.json',
        '/pkg/dartnative@1.0.0.zip',
      ]) {
        final req = await client.getUrl(
          Uri.parse('http://127.0.0.1:9120$path'),
        );
        final res = await req.close();
        await res.drain<void>();
        expect(
          res.statusCode,
          equals(HttpStatus.notFound),
          reason: 'source-mode endpoint $path must return 404',
        );
      }
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

    test('/asset?path= query endpoint is disabled (404)', () async {
      for (final path in [
        '/asset?path=assets/dn-logo.png',
        '/asset?path=pubspec.yaml',
      ]) {
        final req = await client.getUrl(
          Uri.parse('http://127.0.0.1:9120$path'),
        );
        final res = await req.close();
        await res.drain<void>();
        expect(
          res.statusCode,
          equals(HttpStatus.notFound),
          reason: 'legacy query endpoint $path must return 404',
        );
      }
    });

    test('non-asset project files are never exposed (404)', () async {
      for (final path in [
        '/pubspec.yaml',
        '/lib/main.dart',
        '/assets/pubspec.yaml',
        '/assets/lib/main.dart',
        '/assets/../pubspec.yaml',
        '/assets/%2e%2e/pubspec.yaml',
        '/assets/bundles/guest.ast',
        '/assets/%ZZ',
      ]) {
        final req = await client.getUrl(
          Uri.parse('http://127.0.0.1:9120$path'),
        );
        final res = await req.close();
        await res.drain<void>();
        expect(
          res.statusCode,
          equals(HttpStatus.notFound),
          reason: 'path $path must not expose project files',
        );
      }
    });

    test('/_dngo/loading omits local filesystem path', () async {
      final req = await client.getUrl(
        Uri.parse('http://127.0.0.1:9120/_dngo/loading'),
      );
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      expect(res.statusCode, equals(HttpStatus.ok));
      expect(
        body,
        isNot(contains(Directory.current.path)),
        reason: 'loading page must not leak local project path on LAN',
      );
    });
  });
}

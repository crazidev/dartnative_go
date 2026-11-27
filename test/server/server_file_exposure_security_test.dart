import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/cli/server/http_support.dart';
import 'package:dartnative_go/src/cli/server/server.dart';
import 'package:test/test.dart';

/// Verifies that `DartGoServer` cannot expose source code, secrets, dotfiles,
/// legacy bundle files, or symlink-escaped files when reachable on a shared or
/// public network.
void main() {
  group('dev server file-exposure hardening (real DartGoServer)', () {
    late Directory sandbox;
    late Directory projectDir;
    late Directory siblingPrivateDir;
    late DartGoServer server;
    late HttpClient client;
    late String baseUrl;

    setUpAll(() async {
      sandbox = Directory.systemTemp.createTempSync('dngo_sec_');
      projectDir = Directory('${sandbox.path}/app')..createSync();
      siblingPrivateDir = Directory('${sandbox.path}/app_private')
        ..createSync();

      // Sensitive project files outside assets/
      File('${projectDir.path}/pubspec.yaml').writeAsStringSync(
        'name: sec_test_app\nversion: 1.0.0\n',
      );
      File('${projectDir.path}/.env').writeAsStringSync(
        'API_SECRET=super-secret-value\n',
      );
      Directory('${projectDir.path}/lib').createSync();
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(
        'void main() {}\n',
      );
      File('${projectDir.path}/lib/secrets.dart').writeAsStringSync(
        "const token = 'private-token';\n",
      );

      // Sibling directory whose prefix matches `assets` (`assets_private`)
      final siblingAssetsDir = Directory('${projectDir.path}/assets_private')
        ..createSync();
      File('${siblingAssetsDir.path}/secret.txt').writeAsStringSync(
        'sibling-secret',
      );
      File('${siblingPrivateDir.path}/outside.txt').writeAsStringSync(
        'outside-secret',
      );

      // Legitimate and unsafe files under assets/
      final assetsDir = Directory('${projectDir.path}/assets')..createSync();
      File('${assetsDir.path}/logo.png').writeAsBytesSync([0x89, 0x50, 0x4E, 0x47]);
      Directory('${assetsDir.path}/images').createSync();
      File('${assetsDir.path}/images/hero.png').writeAsBytesSync([1, 2, 3]);

      // Hidden dotfiles/dirs inside assets/
      File('${assetsDir.path}/.env').writeAsStringSync('HIDDEN_SECRET=1\n');
      Directory('${assetsDir.path}/.hidden').createSync();
      File('${assetsDir.path}/.hidden/token.txt').writeAsStringSync('hidden');

      // Legacy assets/bundles/ directory
      Directory('${assetsDir.path}/bundles').createSync();
      File('${assetsDir.path}/bundles/guest.ast').writeAsBytesSync([9, 9, 9]);

      // Symlink escape vectors
      Link('${assetsDir.path}/escape_env.png').createSync('../.env');
      Link('${assetsDir.path}/escape_sibling.txt')
          .createSync('../assets_private/secret.txt');
      Link('${assetsDir.path}/escape_outside.txt')
          .createSync('${siblingPrivateDir.path}/outside.txt');
      Link('${assetsDir.path}/internal_hidden.txt').createSync('.env');
      Link('${assetsDir.path}/internal_bundle.ast')
          .createSync('bundles/guest.ast');

      server = DartGoServer(
        DartGoServerOptions(
          projectDir: projectDir,
          startPort: 9160,
          endPort: 9175,
          enableBroadcast: false,
          enableQrCode: false,
          customHost: '127.0.0.1',
          rebuildAst: false,
        ),
      );
      unawaited(server.start());
      final deadline = DateTime.now().add(const Duration(seconds: 3));
      while (server.boundPort == null && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(server.boundPort, isNotNull);
      baseUrl = 'http://127.0.0.1:${server.boundPort}';
      client = HttpClient();
    });

    tearDownAll(() {
      server.stop();
      client.close(force: true);
      try {
        sandbox.deleteSync(recursive: true);
      } catch (_) {}
    });

    Future<int> statusFor(String path) async {
      final req = await client.getUrl(Uri.parse('$baseUrl$path'));
      final res = await req.close();
      await res.drain<void>();
      return res.statusCode;
    }

    test('serves legitimate files strictly inside assets/', () async {
      expect(await statusFor('/assets/logo.png'), equals(HttpStatus.ok));
      expect(await statusFor('/assets/images/hero.png'), equals(HttpStatus.ok));
    });

    test('collectProjectAssets and /assets.json exclude hidden, bundles, and symlink escapes', () async {
      final listed = collectProjectAssets(projectDir);
      expect(
        listed,
        equals(['assets/images/hero.png', 'assets/logo.png']),
      );

      final req = await client.getUrl(Uri.parse('$baseUrl/assets.json'));
      final res = await req.close();
      expect(res.statusCode, equals(HttpStatus.ok));
      final body =
          jsonDecode(await res.transform(utf8.decoder).join()) as Map;
      expect(
        body['assets'],
        equals(['assets/images/hero.png', 'assets/logo.png']),
      );
    });

    test('blocks all source-mode endpoints', () async {
      for (final path in [
        '/bundle.json',
        '/app.dart',
        '/user-code.zip',
        '/user-code-hash',
        '/deps.json',
        '/pkg/example@1.0.0.zip',
      ]) {
        expect(
          await statusFor(path),
          equals(HttpStatus.notFound),
          reason: 'source-mode route $path must be disabled',
        );
      }
    });

    test('blocks direct project-root and non-asset paths (no fallback route)', () async {
      for (final path in [
        '/.env',
        '/pubspec.yaml',
        '/lib/main.dart',
        '/lib/secrets.dart',
        '/assets_private/secret.txt',
        '/logo.png',
        '/asset?path=assets/logo.png',
        '/asset?path=.env',
        '/asset?path=lib/secrets.dart',
      ]) {
        expect(
          await statusFor(path),
          equals(HttpStatus.notFound),
          reason: 'route $path must return 404',
        );
      }
    });

    test('blocks project-root bypass, dotfiles, bundles, traversal, and symlink escapes under /assets/', () async {
      for (final path in [
        '/assets/',
        '/assets/.env',
        '/assets/.hidden/token.txt',
        '/assets/pubspec.yaml',
        '/assets/lib/main.dart',
        '/assets/lib/secrets.dart',
        '/assets/bundles/guest.ast',
        '/assets/escape_env.png',
        '/assets/escape_sibling.txt',
        '/assets/escape_outside.txt',
        '/assets/internal_hidden.txt',
        '/assets/internal_bundle.ast',
        '/assets/../.env',
        '/assets/..%2F.env',
        '/assets/%2e%2e/.env',
        '/assets/images/../../.env',
        '/assets/images',
        '/assets/%ZZ',
      ]) {
        expect(
          await statusFor(path),
          equals(HttpStatus.notFound),
          reason: 'asset path $path must return 404',
        );
      }
    });

    test('resolveAssetFile rejects null bytes and backslash traversal directly', () {
      expect(resolveAssetFile(projectDir, 'assets/logo.png\x00'), isNull);
      expect(resolveAssetFile(projectDir, r'assets\..\.env'), isNull);
      expect(resolveAssetFile(projectDir, '.env'), isNull);
      expect(resolveAssetFile(projectDir, 'lib/main.dart'), isNull);
      expect(resolveAssetFile(projectDir, 'assets/logo.png'), isNotNull);
    });
  });
}

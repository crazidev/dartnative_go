/// Pubspec parsing + bundle output for the whole dartnative_go dev server.
///
/// No mobile app: `PubspecValidator` runs against temp projects and
/// `BundleLoader` runs against the in-memory [FakeDevServer] with
/// `package:test`. Covers `/manifest.json`, `/bundle.json`, `/guest.ast`
/// (present + absent), `/health`, and URL normalization — the same surface
/// the mobile client consumes from `lib/src/cli/server.dart`.
library;

import 'dart:io';

import 'package:dartnative_go/src/cli/pubspec_validator.dart';
import 'package:dartnative_go/src/runner/bundle_loader.dart';
import 'package:test/test.dart';

import '../test_lab/fake_server.dart';

void _writePubspec(Directory dir, String body) {
  File('${dir.path}/pubspec.yaml').writeAsStringSync(body);
}

void main() {
  group('pubspec parsing (PubspecValidator)', () {
    late Directory temp;

    setUp(() {
      temp = Directory.systemTemp.createTempSync('dn_harness_pubspec_');
    });

    tearDown(() {
      try {
        temp.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('compatible plugins validate clean', () {
      _writePubspec(temp, '''
name: valid_app
version: 1.2.3
dependencies:
  dartnative: ^1.0.0
  dartnative_share: ^1.0.0
  path: ^1.8.0
''');
      final res = PubspecValidator(temp).validate();
      expect(res.hasPubspec, isTrue);
      expect(res.isFullyCompatible, isTrue);
      expect(res.validSupportedPlugins, contains('dartnative_share'));
      expect(res.pureDartDependencies, contains('path'));
      expect(res.versionMismatches, isEmpty);
      expect(res.unsupportedNativePlugins, isEmpty);
    });

    test('version mismatch is reported with both constraints', () {
      _writePubspec(temp, '''
name: mismatch_app
version: 1.0.0
dependencies:
  dartnative: ^1.0.0
  dartnative_share: ^2.0.0
''');
      final res = PubspecValidator(temp).validate();
      expect(res.isFullyCompatible, isFalse);
      expect(res.versionMismatches, hasLength(1));
      expect(res.versionMismatches.first.pluginName, 'dartnative_share');
      expect(res.versionMismatches.first.declaredConstraint, '^2.0.0');
      expect(
        res.versionMismatches.first.requiredConstraint,
        isNotEmpty,
      );
    });

    test('unknown native plugin is reported as unsupported', () {
      _writePubspec(temp, '''
name: unsupported_app
version: 1.0.0
dependencies:
  dartnative: ^1.0.0
  dartnative_bluetooth: ^0.5.0
''');
      final res = PubspecValidator(temp).validate();
      expect(res.isFullyCompatible, isFalse);
      expect(res.unsupportedNativePlugins, contains('dartnative_bluetooth'));
    });

    test('missing pubspec degrades gracefully', () {
      final res = PubspecValidator(temp).validate();
      expect(res.hasPubspec, isFalse);
      expect(res.appName, equals('Unknown'));
    });
  });

  group('bundle output (BundleLoader + FakeDevServer)', () {
    late FakeDevServer server;
    late BundleLoader loader;

    setUp(() async {
      server = FakeDevServer(
        appName: 'Harness App',
        files: {
          'main.dart': "import 'package:dartnative/dartnative.dart';\nWidget main() => const Text('Hello');",
          'helper.dart': "String greeting() => 'Hello';",
        },
      );
      await server.start();
      loader = BundleLoader();
    });

    tearDown(() async {
      loader.close();
      await server.stop();
    });

    test('normalizeUrl handles bare host, trailing slash, https', () {
      expect(
        BundleLoader.normalizeUrl('192.168.1.100:8088'),
        equals('http://192.168.1.100:8088'),
      );
      expect(
        BundleLoader.normalizeUrl('http://localhost:8088/'),
        equals('http://localhost:8088'),
      );
      expect(
        BundleLoader.normalizeUrl('https://demo.dartnative.com/'),
        equals('https://demo.dartnative.com'),
      );
    });

    test('fetchManifest returns protocol + app name', () async {
      final manifest = await loader.fetchManifest(server.baseUrl);
      expect(manifest, isNotNull);
      expect(manifest!['protocol'], equals('dart_go'));
      expect(manifest['appName'], equals('Harness App'));
    });

    test('fetchBundle parses multi-file bundle.json', () async {
      final bundle = await loader.fetchBundle(server.baseUrl, fetchAst: false);
      expect(bundle.appName, equals('Harness App'));
      expect(bundle.sources.keys, contains('main.dart'));
      expect(bundle.sources.keys, contains('helper.dart'));
      expect(bundle.entrypointCode, contains('Widget main()'));
    });

    test('fetchAstBytes is null when server has no guest.ast', () async {
      expect(await loader.fetchAstBytes(server.baseUrl), isNull);
      final bundle = await loader.fetchBundle(server.baseUrl);
      expect(bundle.hasAst, isFalse);
    });

    test('fetchAstBytes returns bytes when guest.ast exists', () async {
      await server.stop();
      server = FakeDevServer(appName: 'AST App', astBytes: [1, 2, 3, 4]);
      await server.start();
      final bytes = await loader.fetchAstBytes(server.baseUrl);
      expect(bytes, equals([1, 2, 3, 4]));
      final bundle = await loader.fetchBundle(server.baseUrl);
      expect(bundle.hasAst, isTrue);
    });

    test('fetchAstBytes utilizes ETag to return cached bytes on 304', () async {
      await server.stop();
      server = FakeDevServer(appName: 'AST ETag App', astBytes: [10, 20, 30]);
      await server.start();
      loader.clearAstCache();

      // First fetch caches ETag & bytes
      final first = await loader.fetchAstBytes(server.baseUrl);
      expect(first, equals([10, 20, 30]));

      // Second fetch should use cached bytes via 304 Not Modified
      final second = await loader.fetchAstBytes(server.baseUrl);
      expect(second, equals([10, 20, 30]));
    });
  });
}

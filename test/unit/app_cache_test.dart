import 'dart:io';
import 'package:test/test.dart';
import 'package:dartnative_go/src/client/project_model.dart';
import 'package:dartnative_go/src/runner/app_cache.dart';
import 'package:dartnative_go/src/runner/bundle_loader.dart';

void main() {
  group('AppCache', () {
    late Directory tempDir;
    late AppCache appCache;

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync('dn_app_cache_test_');
      appCache = await AppCache.create(tempDir);
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('generates consistent, filesystem-safe URL keys', () {
      final key1 = AppCache.urlToKey('http://192.168.1.100:8088');
      final key2 = AppCache.urlToKey('http://192.168.1.100:8088/');
      expect(key1, equals(key2));
      expect(key1, contains('192.168.1.100_8088'));
      expect(key1, isNot(contains('/')));
      expect(key1, isNot(contains(':')));
    });

    test('saves and loads a ProjectBundle with sources and AST bytes', () async {
      const serverUrl = 'http://127.0.0.1:8088';
      expect(appCache.hasBundle(serverUrl), isFalse);

      final bundle = ProjectBundle(
        appName: 'Test Offline App',
        appVersion: '1.2.3',
        splashUrl: 'http://127.0.0.1:8088/assets/splash.png',
        iconUrl: 'http://127.0.0.1:8088/assets/icon.png',
        splashBackgroundColor: '#000000',
        serverUrl: serverUrl,
        sources: {
          'package:guest_app/main.dart': 'void main() => runApp(const Text("Hi"));',
          'package:guest_app/utils.dart': 'int add(int a, int b) => a + b;',
        },
        entrypointCode: 'void main() => runApp(const Text("Hi"));',
        entrypointLibrary: 'package:guest_app/main.dart',
        breakpoints: [
          {'file': 'main.dart', 'line': 1},
        ],
        assets: ['assets/image.png'],
        astBytes: [1, 2, 3, 4, 5],
        astEntryPoint: 'main',
        astModuleFingerprints: {'package:guest_app/main.dart': 'abc1234'},
      );

      await appCache.saveBundle(bundle);
      expect(appCache.hasBundle(serverUrl), isTrue);
      expect(appCache.getCachedBundleCount(), equals(1));
      expect(appCache.getCacheSizeBytes(), greaterThan(0));

      final loaded = await appCache.loadBundle(serverUrl);
      expect(loaded, isNotNull);
      expect(loaded!.appName, equals('Test Offline App'));
      expect(loaded.appVersion, equals('1.2.3'));
      expect(loaded.splashUrl, equals('http://127.0.0.1:8088/assets/splash.png'));
      expect(loaded.iconUrl, equals('http://127.0.0.1:8088/assets/icon.png'));
      expect(loaded.splashBackgroundColor, equals('#000000'));
      expect(loaded.serverUrl, equals(serverUrl));
      expect(loaded.sources.length, equals(2));
      expect(loaded.sources['package:guest_app/main.dart'], contains('runApp'));
      expect(loaded.entrypointCode, equals('void main() => runApp(const Text("Hi"));'));
      expect(loaded.entrypointLibrary, equals('package:guest_app/main.dart'));
      expect(loaded.breakpoints.length, equals(1));
      expect(loaded.assets, equals(['assets/image.png']));
      expect(loaded.astBytes, equals([1, 2, 3, 4, 5]));
      expect(loaded.astEntryPoint, equals('main'));
      expect(loaded.astModuleFingerprints['package:guest_app/main.dart'], equals('abc1234'));
      expect(loaded.hasAst, isTrue);
    });

    test('ignores incremental patch bundles to protect base bundle', () async {
      const serverUrl = 'http://127.0.0.1:8088';

      final fullBundle = ProjectBundle(
        appName: 'Base App',
        serverUrl: serverUrl,
        sources: {'main.dart': 'original code'},
        entrypointCode: 'original code',
        entrypointLibrary: 'main.dart',
        astBytes: [10, 20, 30],
      );
      await appCache.saveBundle(fullBundle);

      final patchBundle = ProjectBundle(
        appName: 'Patch App',
        serverUrl: serverUrl,
        sources: const {},
        entrypointCode: '',
        entrypointLibrary: '',
        astPatchBytes: [99, 99],
        isPatch: true,
      );
      await appCache.saveBundle(patchBundle);

      final loaded = await appCache.loadBundle(serverUrl);
      expect(loaded, isNotNull);
      expect(loaded!.appName, equals('Base App'));
      expect(loaded.sources['main.dart'], equals('original code'));
      expect(loaded.astBytes, equals([10, 20, 30]));
    });

    test('clearAll removes all cached bundles', () async {
      final bundle1 = ProjectBundle(
        appName: 'App 1',
        serverUrl: 'http://localhost:8088',
        sources: {'main.dart': 'app1'},
        entrypointCode: 'app1',
        entrypointLibrary: 'main.dart',
      );
      final bundle2 = ProjectBundle(
        appName: 'App 2',
        serverUrl: 'http://localhost:8089',
        sources: {'main.dart': 'app2'},
        entrypointCode: 'app2',
        entrypointLibrary: 'main.dart',
      );

      await appCache.saveBundle(bundle1);
      await appCache.saveBundle(bundle2);
      expect(appCache.getCachedBundleCount(), equals(2));

      await appCache.clearAll();
      expect(appCache.getCachedBundleCount(), equals(0));
      expect(appCache.getCacheSizeBytes(), equals(0));
      expect(appCache.hasBundle('http://localhost:8088'), isFalse);
      expect(appCache.hasBundle('http://localhost:8089'), isFalse);
    });
  });

  group('DartGoProject hasCache', () {
    test('serializes and deserializes hasCache field correctly', () {
      final project = DartGoProject(
        appName: 'Cached App',
        url: 'http://localhost:8088',
        isActive: false,
        hasCache: true,
        lastSeen: DateTime.parse('2026-09-30T00:00:00.000Z'),
      );

      final json = project.toJson();
      expect(json['hasCache'], isTrue);

      final decoded = DartGoProject.fromJson(json);
      expect(decoded.hasCache, isTrue);
      expect(decoded.appName, equals('Cached App'));

      final copy = decoded.copyWith(hasCache: false);
      expect(copy.hasCache, isFalse);
    });
  });
}

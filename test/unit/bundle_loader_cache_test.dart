import 'dart:io';
import 'package:test/test.dart';
import 'package:dartnative_go/src/runner/app_cache.dart';
import 'package:dartnative_go/src/runner/bundle_loader.dart';

void main() {
  group('BundleLoader Offline Caching', () {
    late Directory tempDir;
    late AppCache appCache;
    late BundleLoader loader;

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync('dn_bundle_loader_cache_test_');
      appCache = await AppCache.create(tempDir);
      loader = BundleLoader(appCache: appCache);
    });

    tearDown(() {
      loader.close();
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('loads cached bundle when dev server is offline/unreachable', () async {
      const offlineUrl = 'http://127.0.0.1:59999';

      // Pre-seed cache as if the app had previously connected
      final cachedBundle = ProjectBundle(
        appName: 'Cached Counter App',
        appVersion: '2.0.0',
        serverUrl: offlineUrl,
        sources: {
          'package:guest_app/main.dart': 'void main() => runApp(const CounterApp());',
        },
        entrypointCode: 'void main() => runApp(const CounterApp());',
        entrypointLibrary: 'package:guest_app/main.dart',
        astBytes: [1, 2, 3, 4],
      );
      await appCache.saveBundle(cachedBundle);

      // Attempting to fetch bundle from offline server should return cached version
      final loaded = await loader.fetchBundle(offlineUrl);
      expect(loaded, isNotNull);
      expect(loaded.appName, equals('Cached Counter App'));
      expect(loaded.appVersion, equals('2.0.0'));
      expect(loaded.serverUrl, equals(offlineUrl));
      expect(loaded.sources['package:guest_app/main.dart'], contains('CounterApp'));
      expect(loaded.astBytes, equals([1, 2, 3, 4]));
    });

    test('loads cached AST bundle in onlyAst mode when dev server is offline', () async {
      const offlineUrl = 'http://127.0.0.1:59998';

      final cachedAstBundle = ProjectBundle(
        appName: 'AST Cached App',
        serverUrl: offlineUrl,
        sources: const {},
        entrypointCode: '',
        entrypointLibrary: '',
        astBytes: [100, 200, 255],
      );
      await appCache.saveBundle(cachedAstBundle);

      final loaded = await loader.fetchBundle(offlineUrl, onlyAst: true);
      expect(loaded, isNotNull);
      expect(loaded.appName, equals('AST Cached App'));
      expect(loaded.astBytes, equals([100, 200, 255]));
    });

    test('throws when dev server is offline and no cache exists', () async {
      const offlineUrl = 'http://127.0.0.1:59997';
      expect(
        () => loader.fetchBundle(offlineUrl),
        throwsA(anything),
      );
    });
  });
}

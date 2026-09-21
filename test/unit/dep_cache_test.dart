import 'dart:io';
import 'package:test/test.dart';
import 'package:dartnative_go/src/cli/dep_packager.dart';
import 'package:dartnative_go/src/runner/dep_cache.dart';

void main() {
  test('DepCache stores, loads, and prunes package ZIP files', () async {
    final tempDir = Directory.systemTemp.createTempSync('dn_dep_cache_test_');

    try {
      final cache = await DepCache.create(Directory('${tempDir.path}/cache'));

      expect(cache.loadDepsHash(), isNull);
      await cache.saveDepsHash('hash_v1');
      expect(cache.loadDepsHash(), equals('hash_v1'));

      // Create dummy package zip
      final pkgFiles = {
        'riverpod.dart': 'class Provider { const Provider(); }',
        'src/notifier.dart': 'class Notifier {}',
      };
      final zipBytes = DepPackager.zipFilesMap(pkgFiles);

      await cache.storePackageZip('riverpod', '3.3.2', zipBytes);
      expect(cache.hasPackage('riverpod', '3.3.2'), isTrue);

      final deps = [
        const DepEntry(
          name: 'riverpod',
          version: '3.3.2',
          zipUrl: 'http://localhost/pkg/riverpod@3.3.2.zip',
          contentHash: 'abc',
          byteSize: 100,
        ),
      ];

      final sources = cache.loadAllSources(deps);
      expect(sources.containsKey('package:riverpod/riverpod.dart'), isTrue);
      expect(sources['package:riverpod/riverpod.dart'], contains('class Provider'));
      expect(sources.containsKey('package:riverpod/src/notifier.dart'), isTrue);

      // Prune
      await cache.prune([]);
      expect(cache.hasPackage('riverpod', '3.3.2'), isFalse);
    } finally {
      tempDir.deleteSync(recursive: true);
    }
  });
}

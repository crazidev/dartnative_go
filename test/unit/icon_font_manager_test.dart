import 'package:dartnative_go/src/runner/bundle_loader.dart';
import 'package:dartnative_go/src/runner/icon_font_manager.dart';
import 'package:dartnative_go/src/runner/icon_registry.dart';
import 'package:test/test.dart';

ProjectBundle _bundle({
  String hash = 'abc123',
  List<Map<String, dynamic>> iconFonts = const [],
}) {
  return ProjectBundle(
    appName: 'Test App',
    serverUrl: 'http://127.0.0.1:8088',
    sources: const {},
    entrypointCode: '',
    entrypointLibrary: 'main.dart',
    iconFonts: iconFonts,
    iconFontsHash: hash,
  );
}

void main() {
  group('IconFontManager', () {
    test('built-ins never fetch', () async {
      var calls = 0;
      final manager = IconFontManager(
        fetcher: (_) async {
          calls++;
          return [1, 2, 3];
        },
      );
      final bundle = _bundle(
        iconFonts: [
          {
            'family': 'CupertinoIcons',
            'builtIn': true,
            'url': null,
            'hasFontFile': false,
          },
          {
            'family': 'MaterialIcons',
            'builtIn': true,
            'url': null,
            'hasFontFile': false,
          },
        ],
      );
      expect(manager.neededFonts(bundle), isEmpty);
      final loaded = await manager.syncBundle(bundle);
      expect(loaded, isEmpty);
      expect(calls, equals(0));
      expect(manager.isReady('CupertinoIcons'), isTrue);
    });

    test('fetches only advertised non-built-in families once', () async {
      final fetched = <String>[];
      final manager = IconFontManager(
        fetcher: (family) async {
          fetched.add(family);
          return [9, 9, 9];
        },
      );
      final bundle = _bundle(
        iconFonts: [
          {
            'family': 'FontAwesome5',
            'builtIn': false,
            'hasFontFile': true,
            'url': 'http://127.0.0.1:8088/fonts/FontAwesome5.ttf',
          },
          {
            'family': 'MyCustom',
            'builtIn': false,
            'hasFontFile': false,
            'url': null,
          },
        ],
      );
      final needed = manager.neededFonts(bundle);
      expect(needed.map((e) => e['family']), equals(['FontAwesome5']));

      final loaded = await manager.syncBundle(bundle);
      expect(loaded, equals(['FontAwesome5']));
      expect(fetched, equals(['FontAwesome5']));
      expect(manager.fontBytes('FontAwesome5'), equals([9, 9, 9]));

      // Second sync with same hash: no-op, no extra fetch.
      final again = await manager.syncBundle(bundle);
      expect(again, isEmpty);
      expect(fetched, hasLength(1));
    });

    test('concurrent ensureLoaded dedupes to one fetch', () async {
      var calls = 0;
      final manager = IconFontManager(
        fetcher: (_) async {
          calls++;
          await Future<void>.delayed(const Duration(milliseconds: 5));
          return [7];
        },
      );
      final results = await Future.wait([
        manager.ensureLoaded('SomeFont'),
        manager.ensureLoaded('SomeFont'),
        manager.ensureLoaded('SomeFont'),
      ]);
      expect(calls, equals(1));
      expect(results, everyElement(equals([7])));
    });

    test('fetch failure returns null and never throws', () async {
      final manager = IconFontManager(
        fetcher: (_) async => null,
      );
      expect(await manager.ensureLoaded('Missing'), isNull);
      final loaded = await manager.syncBundle(
        _bundle(
          iconFonts: [
            {
              'family': 'Missing',
              'builtIn': false,
              'hasFontFile': true,
              'url': 'http://x/fonts/Missing.ttf',
            },
          ],
        ),
      );
      expect(loaded, isEmpty);
    });

    test('reset clears cache and hash', () async {
      final manager = IconFontManager(fetcher: (_) async => [1]);
      await manager.ensureLoaded('F1');
      expect(manager.loadedFamilies, contains('F1'));
      manager.reset();
      expect(manager.loadedFamilies, isEmpty);
      expect(manager.lastHash, isEmpty);
    });
  });

  group('icon_registry families', () {
    test('built-in classification', () {
      expect(isBuiltInIconFamily('CupertinoIcons'), isTrue);
      expect(isBuiltInIconFamily('MaterialIcons'), isTrue);
      expect(isBuiltInIconFamily('Material Symbols Outlined'), isTrue);
      expect(isBuiltInIconFamily('FontAwesome5'), isFalse);
      expect(isBuiltInIconFamily('MyCustom'), isFalse);
    });

    test('package mapping', () {
      expect(iconFontPackageForFamily('CupertinoIcons'), 'cupertino_icons');
      expect(iconFontPackageForFamily('FontAwesome5'), 'font_awesome_flutter');
      expect(iconFontPackageForFamily('MaterialIcons'), 'flutter');
      expect(iconFontPackageForFamily('Nope'), isNull);
    });
  });

  group('BundleLoader manifest parsing', () {
    test('iconFontsFrom tolerates missing/legacy manifests', () {
      expect(BundleLoader.iconFontsFrom(null), isEmpty);
      expect(BundleLoader.iconFontsFrom({}), isEmpty);
      expect(
        BundleLoader.iconFontsFrom({
          'iconFonts': [
            {'family': 'CupertinoIcons', 'glyphCount': 2},
          ],
        }),
        hasLength(1),
      );
    });

    test('customFontsFrom tolerates missing manifests', () {
      expect(BundleLoader.customFontsFrom(null), isEmpty);
      expect(
        BundleLoader.customFontsFrom({
          'fonts': [
            {'family': 'MyFont', 'asset': 'assets/my.ttf'},
          ],
        }),
        hasLength(1),
      );
    });
  });
}

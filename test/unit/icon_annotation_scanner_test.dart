import 'dart:io';

import 'package:dartnative_go/src/cli/diagnostics/icon_annotation_scanner.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/cli/packaging/safe_ast_converter.dart';
import 'package:test/test.dart';

void main() {
  group('IconAnnotationScanner.scanBundle', () {
    test('finds @staticIconProvider and @IconFont classes', () async {
      final tmp = Directory.systemTemp.createTempSync('dn_icon_scan_');
      try {
        final lib = Directory('${tmp.path}/lib')..createSync();
        File('${tmp.path}/pubspec.yaml').writeAsStringSync('name: demo_app\n');
        File('${lib.path}/icons.dart').writeAsStringSync('''
class StaticIconProvider {
  const StaticIconProvider();
}
const StaticIconProvider staticIconProvider = StaticIconProvider();
class IconFont {
  final String family;
  const IconFont({required this.family, this.fontAsset});
  final String? fontAsset;
}
@staticIconProvider
abstract class FakeIcons {
  static const int sunny = 0xE001;
}
@IconFont(family: 'Custom', fontAsset: 'fonts/c.ttf')
class CustomIcons {
  static const int moon = 0xE002;
}
class Plain {
  const Plain();
}
''');
        File('${lib.path}/main.dart').writeAsStringSync(
          "import 'icons.dart';\n"
          'void main() {\n'
          '  print(FakeIcons.sunny);\n'
          '  print(CustomIcons.moon);\n'
          '  Plain();\n'
          '}\n',
        );
        final bundler = IncrementalAstBundler(
          bridgedLibraries: kAstBridgedLibraries,
          packageName: 'demo_app',
          projectRoot: tmp.path,
          converter: SafeAstConverter(),
        );
        final bundle = await bundler.createFromFile('${lib.path}/main.dart');
        final found = IconAnnotationScanner.scanBundle(bundle);
        expect(
          found.any(
            (a) =>
                a.className == 'FakeIcons' &&
                a.family == 'FakeIcons' &&
                a.package == 'demo_app',
          ),
          isTrue,
          reason: 'expected FakeIcons, got $found',
        );
        expect(
          found.any(
            (a) =>
                a.className == 'CustomIcons' &&
                a.family == 'Custom' &&
                a.fontAsset == 'fonts/c.ttf',
          ),
          isTrue,
          reason: 'expected CustomIcons(Custom), got $found',
        );
        expect(found.any((a) => a.className == 'Plain'), isFalse);
      } finally {
        try {
          tmp.deleteSync(recursive: true);
        } catch (_) {}
      }
    });

    test('ignores bundles without annotated classes', () async {
      final tmp = Directory.systemTemp.createTempSync('dn_icon_scan_plain_');
      try {
        final lib = Directory('${tmp.path}/lib')..createSync();
        File('${tmp.path}/pubspec.yaml').writeAsStringSync('name: demo_app\n');
        File('${lib.path}/plain.dart')
            .writeAsStringSync('class Plain {\n  const Plain();\n}\n');
        File('${lib.path}/main.dart').writeAsStringSync(
          "import 'plain.dart';\nvoid main() {\n  Plain();\n}\n",
        );
        final bundler = IncrementalAstBundler(
          bridgedLibraries: kAstBridgedLibraries,
          packageName: 'demo_app',
          projectRoot: tmp.path,
          converter: SafeAstConverter(),
        );
        final bundle = await bundler.createFromFile('${lib.path}/main.dart');
        expect(IconAnnotationScanner.scanBundle(bundle), isEmpty);
      } finally {
        try {
          tmp.deleteSync(recursive: true);
        } catch (_) {}
      }
    });
  });

  group('IconAnnotationScanner pre-scan', () {
    test('findAnnotatedClasses matches markers without parsing', () {
      final found = IconAnnotationScanner.findAnnotatedClasses({
        'package:demo/icons.dart': '''
// @IconFont(family: 'Ghost') class GhostIcons {}
final s = "@staticIconProvider class Fake {}";
@staticIconProvider
abstract class FakeIcons {}
@IconFont(family: 'Custom')
class CustomIcons {}
class Plain {}
''',
      });
      expect(found['package:demo/icons.dart'],
          equals({'FakeIcons', 'CustomIcons'}));
    });

    test('findIconFontFamily extracts the family argument', () {
      expect(
        IconAnnotationScanner.findIconFontFamily(
          "@IconFont(family: 'WeatherIcons')\nabstract class WeatherIcons {}",
          'WeatherIcons',
        ),
        equals('WeatherIcons'),
      );
      expect(
        IconAnnotationScanner.findIconFontFamily(
          '@staticIconProvider\nabstract class FakeIcons {}',
          'FakeIcons',
        ),
        isNull,
      );
    });

    test('familyForClass prefers explicit family, then aliases', () {
      expect(
        IconAnnotationScanner.familyForClass('X', explicitFamily: 'Y'),
        equals('Y'),
      );
      expect(
        IconAnnotationScanner.familyForClass('FontAwesomeIcons'),
        equals('FontAwesome5'),
      );
      expect(
        IconAnnotationScanner.familyForClass('CupertinoIcons'),
        equals('CupertinoIcons'),
      );
    });
  });

  group('iconFontAnnotationSources', () {
    test('injects the real host annotation sources', () {
      final sources = iconFontAnnotationSources();
      expect(sources.keys.toSet(), equals(kIconFontAnnotationUris));
      expect(
        sources['package:dartnative_go/server.dart'],
        contains("export 'src/server/icon_font_annotation.dart'"),
      );
      final annotation =
          sources['package:dartnative_go/src/server/icon_font_annotation.dart']!;
      expect(annotation, contains('class IconFont'));
      expect(annotation, contains('final String family'));
    });

    test('injected sources stay identical to the real files', () async {
      final sources = iconFontAnnotationSources();
      expect(sources, isNotEmpty);
      final root = Directory.current;
      for (final uri in kIconFontAnnotationUris) {
        final rel = uri.replaceFirst('package:dartnative_go/', 'lib/');
        final onDisk = await File('${root.path}/$rel').readAsString();
        expect(
          sources[uri],
          equals(onDisk),
          reason: '$uri injection must match $rel exactly',
        );
      }
    });
  });
}

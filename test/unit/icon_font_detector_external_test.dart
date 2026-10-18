import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/cli/diagnostics/icon_font_detector.dart';
import 'package:test/test.dart';

/// Builds a fake guest project + fake external icon package:
///
///   tmp/proj/            ← guest (name: demo, no icon usage at all)
///     pubspec.yaml
///     lib/main.dart
///     .dart_tool/package_config.json → weather_icons
///   tmp/weather_icons/   ← external package, never imported by name in
///     pubspec.yaml         guest code beyond a plain import
///     lib/icons.dart     ← @IconFont registry + IconData consts
///     fonts/WeatherIcons.ttf
Map<String, Directory> _externalPackageProject() {
  final tmp = Directory.systemTemp.createTempSync('dn_icon_ext_');
  final proj = Directory('${tmp.path}/proj')..createSync();
  final lib = Directory('${proj.path}/lib')..createSync();
  File('${proj.path}/pubspec.yaml').writeAsStringSync('name: demo\n');
  File('${lib.path}/main.dart').writeAsStringSync(
    "import 'package:weather_icons/icons.dart';\n"
    'void main() {\n'
    '  print(WeatherIcons.sunny);\n'
    '}\n',
  );
  final pkg = Directory('${tmp.path}/weather_icons')..createSync();
  final pkgLib = Directory('${pkg.path}/lib')..createSync();
  Directory('${pkg.path}/fonts').createSync();
  File('${pkg.path}/pubspec.yaml')
      .writeAsStringSync('name: weather_icons\n');
  File('${pkgLib.path}/icons.dart').writeAsStringSync('''
class IconFont {
  final String family;
  const IconFont({required this.family});
}
class IconData {
  final int codePoint;
  final String? fontFamily;
  const IconData(this.codePoint, {this.fontFamily});
}
@IconFont(family: 'WeatherIcons')
abstract final class WeatherIcons {
  static const IconData sunny = IconData(0xE001, fontFamily: 'WeatherIcons');
  static const IconData moon = IconData(0xE002, fontFamily: 'WeatherIcons');
}
''');
  File('${pkg.path}/fonts/WeatherIcons.ttf')
      .writeAsBytesSync([0, 1, 2, 3, 4, 5]);
  final dartTool = Directory('${proj.path}/.dart_tool')..createSync();
  File('${dartTool.path}/package_config.json').writeAsStringSync(
    jsonEncode({
      'configVersion': 2,
      'packages': [
        {
          'name': 'demo',
          'rootUri': '../',
          'packageUri': 'lib/',
          'languageVersion': '3.9',
        },
        {
          'name': 'weather_icons',
          'rootUri': '../../weather_icons',
          'packageUri': 'lib/',
          'languageVersion': '3.9',
        },
      ],
    }),
  );
  return {'tmp': tmp, 'proj': proj};
}

void main() {
  group('IconFontDetector external packages', () {
    test('annotated registry in a dependency is discovered with font file',
        () {
      final dirs = _externalPackageProject();
      try {
        final report = IconFontDetector(dirs['proj']!).detect();
        expect(
          report.families,
          contains('WeatherIcons'),
          reason: 'annotation must surface the external family; '
              'families=${report.families}',
        );
        expect(report.annotatedFamilies, contains('WeatherIcons'));
        expect(
          report.fontPackages['WeatherIcons'],
          equals('weather_icons'),
        );
        expect(report.fontFiles.keys, contains('WeatherIcons'));
        final manifest =
            report.toManifestJson('http://127.0.0.1:8088').firstWhere(
                  (e) => e['family'] == 'WeatherIcons',
                );
        expect(manifest['builtIn'], isFalse);
        expect(
          manifest['url'],
          equals('http://127.0.0.1:8088/fonts/WeatherIcons.ttf'),
        );
        // Glyph usage inside the external package still resolves.
        expect(
          report.codePointsByFamily['WeatherIcons'],
          contains(0xE001),
        );
        // And the font file itself resolves for serving.
        final file = IconFontDetector(
          dirs['proj']!,
        ).resolveFontFile('WeatherIcons');
        expect(file, isNotNull);
        expect(file!.existsSync(), isTrue);
      } finally {
        try {
          dirs['tmp']!.deleteSync(recursive: true);
        } catch (_) {}
      }
    });
  });
}

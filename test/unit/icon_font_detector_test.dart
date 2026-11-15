import 'package:dartnative_go/src/cli/diagnostics/icon_font_detector.dart';
import 'package:test/test.dart';

void main() {
  group('IconFontDetector.scanSources', () {
    test('detects CupertinoIcons and Material Icons usage', () {
      final report = IconFontDetector.scanSources({
        'lib/main.dart': '''
import 'package:dartnative/dartnative.dart';
Widget build() => Column(children: [
  Icon(CupertinoIcons.plus),
  Icon(CupertinoIcons.checkmark),
  Icon(Icons.home),
]);
''',
      });
      expect(
        report.glyphsByFamily['CupertinoIcons'],
        containsAll(['plus', 'checkmark']),
      );
      expect(report.glyphsByFamily['MaterialIcons'], contains('home'));
      // Known glyphs resolve to code points (subset for manifest).
      expect(
        report.codePointsByFamily['CupertinoIcons'],
        isNotEmpty,
      );
    });

    test('ignores matches inside comments and strings', () {
      final report = IconFontDetector.scanSources({
        'lib/a.dart': '''
// Icon(CupertinoIcons.plus)
final s = "Icons.home CupertinoIcons.checkmark";
Widget build() => Icon(CupertinoIcons.search);
''',
      });
      expect(report.glyphsByFamily['CupertinoIcons'], equals({'search'}));
      expect(report.glyphsByFamily['MaterialIcons'], isNull);
    });

    test('detects MaterialSymbols variants and FontAwesome', () {
      final report = IconFontDetector.scanSources({
        'lib/a.dart': '''
Icon(MaterialSymbolsOutlined.home);
Icon(FontAwesomeIcons.gear);
''',
      });
      expect(
        report.glyphsByFamily['Material Symbols Outlined'],
        contains('home'),
      );
      final fa =
          report.glyphsByFamily['FontAwesome5'] ??
          report.glyphsByFamily['FontAwesome6'];
      expect(fa, contains('gear'));
    });

    test('detects raw IconData code points with fontFamily', () {
      final report = IconFontDetector.scanSources({
        'lib/a.dart': '''
const icon = IconData(0xF489, fontFamily: 'CupertinoIcons');
''',
      });
      expect(
        report.codePointsByFamily['CupertinoIcons'],
        contains(0xF489),
      );
    });

    test('empty sources produce empty report', () {
      final report = IconFontDetector.scanSources({
        'lib/a.dart': 'void main() {}',
      });
      expect(report.isEmpty, isTrue);
      expect(report.hash, isNotEmpty);
    });

    test('hash is stable for identical usage', () {
      const src = 'Icon(CupertinoIcons.plus);';
      final a = IconFontDetector.scanSources({'lib/a.dart': src});
      final b = IconFontDetector.scanSources({'lib/a.dart': src});
      expect(a.hash, equals(b.hash));
    });

    test('toManifestJson carries subset + builtIn flags', () {
      final report = IconFontDetector.scanSources({
        'lib/a.dart': 'Icon(CupertinoIcons.plus);',
      });
      final json = report.toManifestJson('http://127.0.0.1:8088');
      expect(json, hasLength(1));
      expect(json.first['family'], equals('CupertinoIcons'));
      expect(json.first['builtIn'], isTrue);
      expect(json.first['names'], contains('plus'));
      expect(json.first['codePoints'], isNotEmpty);
    });
  });
}

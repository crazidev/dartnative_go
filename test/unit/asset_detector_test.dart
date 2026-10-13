import 'dart:io';

import 'package:dartnative_go/src/cli/diagnostics/asset_detector.dart';
import 'package:test/test.dart';

void main() {
  group('AssetDetector', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('dart_go_asset_test_');
      File('${tempDir.path}/pubspec.yaml').writeAsStringSync('''
name: asset_app
dartnative_splash:
  color: "#123456"
  image: assets/my_splash.png
''');
      final assetsDir = Directory('${tempDir.path}/assets')..createSync();
      File('${assetsDir.path}/my_splash.png').writeAsStringSync('fake image');
      File('${assetsDir.path}/icon.png').writeAsStringSync('fake icon');
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('detects splash config, file, and background color', () {
      final assets = AssetDetector(tempDir).detect();
      expect(assets.hasSplash, isTrue);
      expect(assets.splashPath, equals('assets/my_splash.png'));
      expect(assets.splashBackgroundColor, equals('#123456'));
    });

    test('detects app icon', () {
      final assets = AssetDetector(tempDir).detect();
      expect(assets.hasIcon, isTrue);
      expect(assets.iconPath, equals('assets/icon.png'));
    });
  });
}

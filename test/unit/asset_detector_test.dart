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
      File(
        '${assetsDir.path}/config_icon.png',
      ).writeAsStringSync('config icon');
      File(
        '${assetsDir.path}/config_splash.png',
      ).writeAsStringSync('config splash');
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
      expect(assets.hasConfiguredSplashColor, isTrue);
    });

    test('detects app icon', () {
      final assets = AssetDetector(tempDir).detect();
      expect(assets.hasIcon, isTrue);
      expect(assets.iconPath, equals('assets/icon.png'));
    });

    test('leaves splash background null when color is not configured', () {
      File('${tempDir.path}/pubspec.yaml').writeAsStringSync('''
name: asset_app
''');
      final assets = AssetDetector(tempDir).detect();
      expect(assets.splashBackgroundColor, isNull);
      expect(assets.splashBackgroundColorDark, isNull);
      expect(assets.hasConfiguredSplashColor, isFalse);
    });

    test('detects color_dark from splash config', () {
      File('${tempDir.path}/pubspec.yaml').writeAsStringSync('''
name: asset_app
dartnative_splash:
  color: "#123456"
  color_dark: "#abcdef"
  image: assets/my_splash.png
''');
      final assets = AssetDetector(tempDir).detect();
      expect(assets.splashBackgroundColor, equals('#123456'));
      expect(assets.splashBackgroundColorDark, equals('#abcdef'));
    });

    test(
      'prefers dngo.config.dart icon, splash, and background over pubspec',
      () {
        File('${tempDir.path}/dngo.config.dart').writeAsStringSync('''
import 'package:dartnative_go_config/dngo.dart';

DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: 'Configured App',
    bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
    version: AppVersion(name: '2.0.0', buildNumber: 3),
    icon: AppIcon(source: 'assets/config_icon.png'),
    splash: SplashConfig(
      image: 'assets/config_splash.png',
      backgroundColor: ColorValue('#AABBCC'),
      backgroundDark: ColorValue('#112233'),
    ),
  ),
);
''');
        final assets = AssetDetector(tempDir).detect();
        expect(assets.iconPath, equals('assets/config_icon.png'));
        expect(assets.splashPath, equals('assets/config_splash.png'));
        expect(assets.splashBackgroundColor, equals('#AABBCC'));
        expect(assets.splashBackgroundColorDark, equals('#112233'));
      },
    );

    test('uses android platform icon when app.icon is absent', () {
      File(
        '${tempDir.path}/pubspec.yaml',
      ).writeAsStringSync('name: asset_app\n');
      File('${tempDir.path}/dngo.config.dart').writeAsStringSync('''
import 'package:dartnative_go_config/dngo.dart';

DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: 'Configured App',
    bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
    version: AppVersion(name: '1.0.0', buildNumber: 1),
  ),
  platforms: PlatformsConfig(
    android: AndroidConfig(
      icon: AndroidAppIcon(
        foreground: 'assets/config_icon.png',
        background: ColorValue('#000000'),
      ),
    ),
  ),
);
''');
      final assets = AssetDetector(tempDir).detect();
      expect(assets.iconPath, equals('assets/config_icon.png'));
      expect(assets.splashPath, equals('assets/config_icon.png'));
    });
  });
}

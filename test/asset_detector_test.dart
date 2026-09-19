import 'dart:io';
import 'package:dartnative_go/src/cli/asset_detector.dart';

void main() {
  final tempDir = Directory.systemTemp.createTempSync('dart_go_asset_test_');

  try {
    // 1. Create fake pubspec with splash config
    final pubspec = File('${tempDir.path}/pubspec.yaml');
    pubspec.writeAsStringSync('''
name: asset_app
dartnative_splash:
  color: "#123456"
  image: assets/my_splash.png
''');

    // Create dummy image file
    final assetsDir = Directory('${tempDir.path}/assets')..createSync();
    File('${assetsDir.path}/my_splash.png').writeAsStringSync('fake image');
    File('${assetsDir.path}/icon.png').writeAsStringSync('fake icon');

    final detector = AssetDetector(tempDir);
    final assets = detector.detect();

    assert(assets.hasSplash, 'Expected splash file to be detected');
    assert(assets.splashPath == 'assets/my_splash.png');
    assert(assets.splashBackgroundColor == '#123456');

    assert(assets.hasIcon, 'Expected icon file to be detected');
    assert(assets.iconPath == 'assets/icon.png');

    print('All AssetDetector tests passed successfully!');
  } finally {
    tempDir.deleteSync(recursive: true);
  }
}

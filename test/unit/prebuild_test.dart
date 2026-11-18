import 'dart:io';

import '../../lib/src/prebuild/config.dart';
import '../../lib/src/prebuild/native_generator.dart';
import 'package:test/test.dart';

void main() {
  test('parses generated dngo config', () {
    final config = DngoConfigParser.parse('''
final dngoConfig = DngoConfig(
  name: 'Smoke App',
  iosBundleId: 'com.example.smoke',
  androidApplicationId: 'com.example.smoke',
  versionName: '2.3.4',
  buildNumber: 7,
  plugins: ['dartnative_media_picker'],
);
''');
    expect(config.name, 'Smoke App');
    expect(config.buildNumber, 7);
    expect(config.plugins, contains('dartnative_media_picker'));
  });

  test('generates native values', () {
    final root = Directory.systemTemp.createTempSync('dngo-prebuild-');
    addTearDown(() => root.deleteSync(recursive: true));
    Directory('${root.path}/android/app/src/main').createSync(recursive: true);
    Directory('${root.path}/ios/Runner').createSync(recursive: true);
    File('${root.path}/android/app/build.gradle.kts').writeAsStringSync(
      'applicationId = "old.app"\nminSdk = 26\nversionName = "0.1.0"',
    );
    File(
      '${root.path}/android/app/src/main/AndroidManifest.xml',
    ).writeAsStringSync(
      '<manifest><application android:label="Old"/></manifest>',
    );
    File(
      '${root.path}/ios/Podfile',
    ).writeAsStringSync("platform :ios, '16.1'\n");
    File('${root.path}/ios/Runner/Info.plist').writeAsStringSync(
      '<plist><dict><key>CFBundleDisplayName</key><string>Old</string></dict></plist>',
    );
    DngoNativeGenerator(root).generate(
      const DngoConfig(
        name: 'New App',
        iosBundleId: 'com.example.new',
        androidApplicationId: 'com.example.new',
        versionName: '1.0.0',
        buildNumber: 1,
        iosDeploymentTarget: 17,
      ),
    );
    expect(
      File('${root.path}/android/app/build.gradle.kts').readAsStringSync(),
      contains('applicationId = "com.example.new"'),
    );
    expect(
      File('${root.path}/ios/Podfile').readAsStringSync(),
      contains("'17.0'"),
    );
    expect(
      File('${root.path}/ios/Runner/Info.plist').readAsStringSync(),
      contains('New App'),
    );
  });
}

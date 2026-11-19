import 'dart:io';

import 'package:test/test.dart';

import '../../lib/src/prebuild/config.dart';
import '../../lib/src/prebuild/config_init.dart';

void main() {
  group('prebuild:init', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('dngo-init-');
    });

    tearDown(() {
      if (root.existsSync()) root.deleteSync(recursive: true);
    });

    void write(String path, String content) {
      File('${root.path}/$path')
        ..createSync(recursive: true)
        ..writeAsStringSync(content);
    }

    test('reads name, version and bundle ids from the project', () {
      write('pubspec.yaml', 'name: my_app\nversion: 2.3.4+7\n');
      write(
        'android/app/build.gradle.kts',
        'android {\n'
            '  namespace = "com.acme.namespace"\n'
            '  defaultConfig {\n'
            '    applicationId = "com.acme.myapp"\n'
            '  }\n'
            '}\n',
      );
      write(
        'android/app/src/main/AndroidManifest.xml',
        '<manifest xmlns:android="http://schemas.android.com/apk/res/android">'
            '<application android:label="Acme App"/>'
            '</manifest>',
      );
      write(
        'ios/Runner/Info.plist',
        '<?xml version="1.0" encoding="UTF-8"?>'
            '<plist version="1.0"><dict>'
            '<key>CFBundleDisplayName</key><string>Acme iOS</string>'
            '</dict></plist>',
      );
      write(
        'ios/Runner.xcodeproj/project.pbxproj',
        'PRODUCT_BUNDLE_IDENTIFIER = com.acme.app;\n'
            'PRODUCT_BUNDLE_IDENTIFIER = com.acme.app.RunnerTests;\n'
            'PRODUCT_BUNDLE_IDENTIFIER = com.acme.app;\n',
      );

      final inspection = initializeDngoConfig(root);

      expect(inspection.name, 'Acme App');
      expect(inspection.versionName, '2.3.4');
      expect(inspection.buildNumber, 7);
      expect(inspection.androidBundleId, 'com.acme.myapp');
      expect(inspection.iosBundleId, 'com.acme.app');
      expect(inspection.hasAndroid, isTrue);
      expect(inspection.hasIos, isTrue);

      final config = DngoConfigParser.parse(
        File('${root.path}/dngo.config.dart').readAsStringSync(),
      );
      expect(config.name, 'Acme App');
      expect(config.app.version.name, '2.3.4');
      expect(config.app.version.buildNumber, 7);
      expect(config.iosBundleId, 'com.acme.app');
      expect(config.androidApplicationId, 'com.acme.myapp');
    });

    test('resolves an android label string resource', () {
      write('pubspec.yaml', 'name: my_app\nversion: 1.0.0+1\n');
      write(
        'android/app/build.gradle.kts',
        'applicationId = "com.acme.app"\n',
      );
      write(
        'android/app/src/main/AndroidManifest.xml',
        '<manifest xmlns:android="http://schemas.android.com/apk/res/android">'
            '<application android:label="@string/app_name"/>'
            '</manifest>',
      );
      write(
        'android/app/src/main/res/values/strings.xml',
        '<resources><string name="app_name">Acme From XML</string></resources>',
      );

      final inspection = initializeDngoConfig(root);

      expect(inspection.name, 'Acme From XML');
      expect(inspection.iosBundleId, 'com.acme.app');
    });

    test('falls back when native folders are missing', () {
      write('pubspec.yaml', 'name: my_cool_app\n');

      final inspection = initializeDngoConfig(root);

      expect(inspection.name, 'My Cool App');
      expect(inspection.versionName, '1.0.0');
      expect(inspection.buildNumber, 1);
      expect(inspection.androidBundleId, 'com.example.my_cool_app');
      expect(inspection.iosBundleId, 'com.example.my_cool_app');
      expect(inspection.hasAndroid, isFalse);
      expect(inspection.hasIos, isFalse);
    });

    test('does not overwrite an existing config without force', () {
      write('pubspec.yaml', 'name: my_app\nversion: 1.0.0+1\n');
      final config = File('${root.path}/dngo.config.dart')
        ..writeAsStringSync('// hand written\n');

      expect(() => initializeDngoConfig(root), throwsStateError);
      expect(config.readAsStringSync(), '// hand written\n');

      initializeDngoConfig(root, force: true);
      expect(config.readAsStringSync(), contains('DngoConfig get dngoConfig'));
    });

    test('asks before overwriting an existing config', () {
      write('pubspec.yaml', 'name: my_app\nversion: 1.0.0+1\n');
      final config = File('${root.path}/dngo.config.dart')
        ..writeAsStringSync('// hand written\n');

      expect(
        () => initializeDngoConfig(root, confirmOverwrite: () => false),
        throwsStateError,
      );
      expect(config.readAsStringSync(), '// hand written\n');

      initializeDngoConfig(root, confirmOverwrite: () => true);
      expect(config.readAsStringSync(), contains('DngoConfig get dngoConfig'));
    });

    test('syncs native project settings into the config', () {
      write('pubspec.yaml', 'name: my_app\nversion: 1.0.0+1\n');
      write(
        'android/app/build.gradle.kts',
        'android {\n'
            '  namespace = "com.acme.app"\n'
            '  compileSdk = 36\n'
            '  ndkVersion = "27.0.12077973"\n'
            '  defaultConfig {\n'
            '    applicationId = "com.acme.app"\n'
            '    minSdk = 24\n'
            '    targetSdk = 35\n'
            '    versionCode = 9\n'
            '    versionName = "2.0.0"\n'
            '  }\n'
            '}\n',
      );
      write(
        'android/app/src/main/AndroidManifest.xml',
        '<manifest xmlns:android="http://schemas.android.com/apk/res/android">'
            '<uses-permission android:name="android.permission.CAMERA"/>'
            '<application android:label="Acme" android:usesCleartextTraffic="true">'
            '<activity android:name=".MainActivity">'
            '<intent-filter>'
            '<action android:name="android.intent.action.MAIN"/>'
            '<category android:name="android.intent.category.LAUNCHER"/>'
            '</intent-filter>'
            '<intent-filter android:autoVerify="true">'
            '<action android:name="android.intent.action.VIEW"/>'
            '<category android:name="android.intent.category.DEFAULT"/>'
            '<category android:name="android.intent.category.BROWSABLE"/>'
            '<data android:scheme="https" android:host="acme.com"/>'
            '</intent-filter>'
            '</activity>'
            '</application>'
            '<queries>'
            '<intent>'
            '<action android:name="android.intent.action.PROCESS_TEXT"/>'
            '<data android:mimeType="text/plain"/>'
            '</intent>'
            '<intent>'
            '<action android:name="android.intent.action.VIEW"/>'
            '<data android:scheme="youtube"/>'
            '</intent>'
            '</queries>'
            '</manifest>',
      );
      write(
        'ios/Podfile',
        "platform :ios, '17.0'\n",
      );
      write(
        'ios/Runner.xcodeproj/project.pbxproj',
        'PRODUCT_BUNDLE_IDENTIFIER = com.acme.app;\n'
            'IPHONEOS_DEPLOYMENT_TARGET = 17.0;\n'
            'TARGETED_DEVICE_FAMILY = "1,2";\n',
      );
      write(
        'ios/Runner/Info.plist',
        '<?xml version="1.0" encoding="UTF-8"?>'
            '<plist version="1.0"><dict>'
            '<key>CFBundleDisplayName</key><string>Acme</string>'
            '<key>UISupportedInterfaceOrientations</key>'
            '<array>'
            '<string>UIInterfaceOrientationPortrait</string>'
            '<string>UIInterfaceOrientationLandscapeLeft</string>'
            '</array>'
            '<key>LSApplicationQueriesSchemes</key>'
            '<array><string>youtube</string></array>'
            '<key>CFBundleURLTypes</key>'
            '<array><dict>'
            '<key>CFBundleURLSchemes</key>'
            '<array><string>dartnativego</string><string>acme</string></array>'
            '</dict></array>'
            '<key>NSSupportsLiveActivities</key><true/>'
            '</dict></plist>',
      );
      write(
        'ios/Runner/Runner.entitlements',
        '<plist><dict>'
            '<key>com.apple.security.application-groups</key>'
            '<array><string>group.acme</string></array>'
            '<key>com.apple.developer.associated-domains</key>'
            '<array><string>applinks:acme.com</string></array>'
            '</dict></plist>',
      );

      final inspection = initializeDngoConfig(
        root,
        syncFromProject: true,
      );

      expect(inspection.syncedFromProject, isTrue);
      expect(inspection.android.minSdk, 24);
      expect(inspection.android.targetSdk, 35);
      expect(inspection.android.compileSdk, 36);
      expect(inspection.android.ndkVersion, '27.0.12077973');
      expect(inspection.android.versionCode, 9);
      expect(inspection.android.versionName, '2.0.0');
      expect(inspection.android.usesCleartextTraffic, isTrue);
      expect(
        inspection.android.permissions,
        contains(AndroidPermission.camera),
      );
      expect(
        inspection.android.intentQueries.single.data.single.scheme,
        'youtube',
      );
      expect(inspection.android.intentFilters, hasLength(1));
      expect(inspection.android.intentFilters.single.autoVerify, isTrue);
      expect(inspection.ios.minimumDeploymentTarget.major, 17);
      expect(
        inspection.ios.supportedOrientations,
        {IosOrientation.portrait, IosOrientation.landscapeLeft},
      );
      expect(inspection.ios.appGroup, 'group.acme');
      expect(inspection.ios.supportsLiveActivities, isTrue);
      expect(inspection.ios.querySchemes, contains('youtube'));
      expect(inspection.ios.urlSchemes, contains('acme'));
      expect(inspection.ios.urlSchemes, isNot(contains('dartnativego')));
      expect(inspection.ios.associatedDomains, contains('applinks:acme.com'));

      final parsed = DngoConfigParser.parse(
        File('${root.path}/dngo.config.dart').readAsStringSync(),
      );
      expect(parsed.platforms.android.minSdk, 24);
      expect(
        parsed.platforms.android.permissions,
        contains(AndroidPermission.camera),
      );
      expect(parsed.platforms.ios.urlSchemes, contains('acme'));
      expect(parsed.platforms.ios.appGroup, 'group.acme');
    });

    test('formats the generated config with dart format', () {
      write('pubspec.yaml', 'name: my_app\nversion: 1.0.0+1\n');
      initializeDngoConfig(root, syncFromProject: false);
      final file = File('${root.path}/dngo.config.dart');
      final result = Process.runSync('dart', [
        'format',
        '--output=none',
        '--set-exit-if-changed',
        file.path,
      ]);
      expect(result.exitCode, 0, reason: result.stdout.toString());
    });

    test('can skip syncing native settings', () {
      write('pubspec.yaml', 'name: my_app\nversion: 1.0.0+1\n');
      write(
        'android/app/build.gradle.kts',
        'applicationId = "com.acme.app"\nminSdk = 28\n',
      );

      final inspection = initializeDngoConfig(root, syncFromProject: false);

      expect(inspection.syncedFromProject, isFalse);
      expect(inspection.android.minSdk, isNull);
    });

    test('requires pubspec.yaml', () {
      expect(
        () => initializeDngoConfig(root),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('pubspec.yaml'),
          ),
        ),
      );
    });
  });
}

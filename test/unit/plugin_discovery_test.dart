import 'dart:io';

import 'package:test/test.dart';

import '../../lib/src/prebuild/config.dart';
import '../../lib/src/prebuild/native_generator.dart';
import '../../lib/src/prebuild/plugin_discovery.dart';

void main() {
  test('parses a plugin build_config.dart', () {
    final parsed = parsePluginBuildConfig('''
import 'package:dartnative_go_config/dngo.dart';

DngoPluginConfig get dngoPluginConfig => PluginBuildConfig(
  name: 'native_bottomsheet',
  permissions: {
    AndroidPermission.vibrate,
    AndroidPermission.recordAudio,
  },
  iosPermissions: {
    'NSMicrophoneUsageDescription': 'Hold the mic in the sheet.',
    'NSSpeechRecognitionUsageDescription': 'Dictate into the sheet.',
  },
);
''');
    expect(parsed, isNotNull);
    expect(parsed!.name, 'native_bottomsheet');
    expect(
      parsed.permissions,
      {AndroidPermission.vibrate, AndroidPermission.recordAudio},
    );
    expect(
      parsed.iosPermissions['NSMicrophoneUsageDescription'],
      'Hold the mic in the sheet.',
    );
  });

  test('discovers build_config.dart from package_config.json', () {
    final root = Directory.systemTemp.createTempSync('dngo-plugin-discover-');
    addTearDown(() => root.deleteSync(recursive: true));
    final plugin = Directory('${root.path}/plugin')..createSync();
    File('${plugin.path}/build_config.dart').writeAsStringSync('''
PluginBuildConfig(
  name: 'native_bottomsheet',
  permissions: {AndroidPermission.vibrate},
  iosPermissions: {'NSMicrophoneUsageDescription': 'Mic'},
)
''');
    Directory('${root.path}/.dart_tool').createSync();
    File('${root.path}/.dart_tool/package_config.json').writeAsStringSync('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "example",
      "rootUri": "../",
      "packageUri": "lib/"
    },
    {
      "name": "native_bottomsheet",
      "rootUri": "${plugin.uri}",
      "packageUri": "lib/"
    },
    {
      "name": "dartnative",
      "rootUri": "file:///unused/",
      "packageUri": "lib/"
    }
  ]
}
''');

    final discovered = discoverPluginBuildConfigs(root);
    expect(discovered, hasLength(1));
    expect(discovered.single.name, 'native_bottomsheet');
    expect(
      discovered.single.androidPermissions,
      contains('android.permission.VIBRATE'),
    );
  });

  test('prebuild applies discovered plugin permissions', () async {
    final root = Directory.systemTemp.createTempSync('dngo-plugin-prebuild-');
    addTearDown(() => root.deleteSync(recursive: true));
    Directory('${root.path}/android/app/src/main').createSync(recursive: true);
    Directory('${root.path}/ios/Runner').createSync(recursive: true);
    File(
      '${root.path}/android/app/src/main/AndroidManifest.xml',
    ).writeAsStringSync(
      '<manifest><application android:label="App"/></manifest>',
    );
    File('${root.path}/ios/Runner/Info.plist').writeAsStringSync(
      '<plist><dict></dict></plist>',
    );
    final plugin = Directory('${root.path}/plugin')..createSync();
    File('${plugin.path}/build_config.dart').writeAsStringSync('''
PluginBuildConfig(
  name: 'native_bottomsheet',
  permissions: {AndroidPermission.vibrate, AndroidPermission.recordAudio},
  iosPermissions: {
    'NSMicrophoneUsageDescription': 'Hold the mic in the sheet.',
  },
)
''');
    Directory('${root.path}/.dart_tool').createSync();
    File('${root.path}/.dart_tool/package_config.json').writeAsStringSync('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "native_bottomsheet",
      "rootUri": "${plugin.uri}",
      "packageUri": "lib/"
    }
  ]
}
''');

    const app = AppConfig(
      name: 'App',
      bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
      version: AppVersion(name: '1.0.0', buildNumber: 1),
    );
    await DngoNativeGenerator(root).generate(const DngoConfig(app: app));

    final manifest = File(
      '${root.path}/android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    expect(manifest, contains('android.permission.VIBRATE'));
    expect(manifest, contains('android.permission.RECORD_AUDIO'));
    final plist = File('${root.path}/ios/Runner/Info.plist').readAsStringSync();
    expect(plist, contains('NSMicrophoneUsageDescription'));
    expect(plist, contains('Hold the mic in the sheet.'));

    Directory('${root.path}/.dart_tool').listSync().toList();
    File('${root.path}/.dart_tool/package_config.json').writeAsStringSync('''
{"configVersion": 2, "packages": []}
''');
    await DngoNativeGenerator(root).generate(const DngoConfig(app: app));
    expect(
      File(
        '${root.path}/android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync(),
      isNot(contains('android.permission.VIBRATE')),
    );
    expect(
      File('${root.path}/ios/Runner/Info.plist').readAsStringSync(),
      isNot(contains('NSMicrophoneUsageDescription')),
    );
  });

  test('app plugin config overrides discovered build_config', () async {
    final root = Directory.systemTemp.createTempSync('dngo-plugin-override-');
    addTearDown(() => root.deleteSync(recursive: true));
    Directory('${root.path}/android/app/src/main').createSync(recursive: true);
    File(
      '${root.path}/android/app/src/main/AndroidManifest.xml',
    ).writeAsStringSync(
      '<manifest><application android:label="App"/></manifest>',
    );
    final plugin = Directory('${root.path}/plugin')..createSync();
    File('${plugin.path}/build_config.dart').writeAsStringSync('''
PluginBuildConfig(
  name: 'native_bottomsheet',
  permissions: {AndroidPermission.vibrate},
)
''');
    Directory('${root.path}/.dart_tool').createSync();
    File('${root.path}/.dart_tool/package_config.json').writeAsStringSync('''
{
  "configVersion": 2,
  "packages": [
    {"name": "native_bottomsheet", "rootUri": "${plugin.uri}", "packageUri": "lib/"}
  ]
}
''');

    await DngoNativeGenerator(root).generate(
      const DngoConfig(
        app: AppConfig(
          name: 'App',
          bundleId: BundleId(
            ios: 'com.example.app',
            android: 'com.example.app',
          ),
          version: AppVersion(name: '1.0.0', buildNumber: 1),
        ),
        plugins: [
          PluginBuildConfig(
            name: 'native_bottomsheet',
            permissions: {AndroidPermission.camera},
          ),
        ],
      ),
    );
    final manifest = File(
      '${root.path}/android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    expect(manifest, contains('android.permission.CAMERA'));
    expect(manifest, isNot(contains('android.permission.VIBRATE')));
  });
}

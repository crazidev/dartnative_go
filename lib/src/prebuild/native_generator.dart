import 'dart:io';
import 'dart:io';

import 'config.dart';

class DngoNativeGenerator {
  final Directory projectDir;
  const DngoNativeGenerator(this.projectDir);

  Future<void> ensureNativeProject() async {
    final hasAndroid = Directory('${projectDir.path}/android').existsSync();
    final hasIos = Directory('${projectDir.path}/ios').existsSync();
    if (hasAndroid && hasIos) return;
    final result = await Process.run(
      'dn',
      ['create', '.'],
      workingDirectory: projectDir.path,
    );
    if (result.exitCode != 0) {
      throw ProcessException(
        'dn',
        ['create', '.'],
        result.stderr.toString(),
        result.exitCode,
      );
    }
  }

  void generate(DngoConfig config) {
    _generateAndroid(config);
    _generateIos(config);
    _writeManifest(config);
  }

  void _generateAndroid(DngoConfig config) {
    final gradle = File('${projectDir.path}/android/app/build.gradle.kts');
    if (gradle.existsSync()) {
      var text = gradle.readAsStringSync();
      text = text.replaceFirst(
        RegExp(r'applicationId\s*=\s*"[^"]*"'),
        'applicationId = "${config.androidApplicationId}"',
      );
      text = text.replaceFirst(
        RegExp(r'minSdk\s*=\s*\d+'),
        'minSdk = ${config.androidMinSdk}',
      );
      text = text.replaceFirst(
        RegExp(r'versionName\s*=\s*[^\n]+'),
        'versionName = "${config.versionName}"',
      );
      gradle.writeAsStringSync(text);
    }

    final manifest = File(
      '${projectDir.path}/android/app/src/main/AndroidManifest.xml',
    );

    if (manifest.existsSync()) {
      var text = manifest.readAsStringSync();
      text = text.replaceFirst(
        RegExp(r'android:label="[^"]*"'),
        'android:label="${config.name}"',
      );
      for (final entry in config.iosPermissions.entries) {
        if (entry.key == 'NSPhotoLibraryUsageDescription' &&
            !text.contains('READ_MEDIA_IMAGES')) {
          text = text.replaceFirst(
            '<application',
            '<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>\n        <application',
          );
          break;
        }
      }
      manifest.writeAsStringSync(text);
    }
  }

  void _generateIos(DngoConfig config) {
    final podfile = File('${projectDir.path}/ios/Podfile');
    if (podfile.existsSync()) {
      var text = podfile.readAsStringSync();
      text = text.replaceFirst(
        RegExp(r"platform :ios, '[^']+'"),
        "platform :ios, '${config.iosDeploymentTarget}.0'",
      );
      podfile.writeAsStringSync(text);
    }
    final plist = File('${projectDir.path}/ios/Runner/Info.plist');
    if (plist.existsSync()) {
      var text = plist.readAsStringSync();
      text = _replacePlistString(text, 'CFBundleDisplayName', config.name);
      text = _replacePlistString(
        text,
        'CFBundleShortVersionString',
        config.versionName,
      );
      for (final entry in config.iosPermissions.entries) {
        if (!text.contains('<key>${entry.key}</key>')) {
          text = text.replaceFirst(
            '</dict>',
            '\t<key>${entry.key}</key>\n\t<string>${entry.value}</string>\n</dict>',
          );
        }
      }
      plist.writeAsStringSync(text);
    }
  }

  String _replacePlistString(String text, String key, String value) {
    final pattern = RegExp(
      r'(<key>' + RegExp.escape(key) + r'</key>\s*<string>)[^<]*(</string>)',
    );
    return text.replaceFirst(pattern, r'$1' + value + r'$2');
  }

  void _writeManifest(DngoConfig config) {
    final file = File('${projectDir.path}/.dart_tool/dngo/prebuild.json')
      ..createSync(recursive: true);
    file.writeAsStringSync(config.encode());
  }
}

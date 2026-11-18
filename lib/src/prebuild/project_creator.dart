import 'dart:io';

import '../cli/diagnostics/dart_go_version.dart';
import 'config.dart';
import 'native_generator.dart';

class DngoProjectCreator {
  final Directory workingDirectory;
  const DngoProjectCreator(this.workingDirectory);

  Future<void> run({String? name, List<String>? plugins}) async {
    final appName = name ?? _ask('App name: ');
    final selected = plugins ?? _askPlugins();
    final slug = _slug(appName);
    final result = await Process.run('dn', [
      'create',
      slug,
    ], workingDirectory: workingDirectory.path);
    if (result.exitCode != 0) {
      throw ProcessException(
        'dn',
        ['create', slug],
        result.stderr.toString(),
        result.exitCode,
      );
    }
    final project = Directory('${workingDirectory.path}/$slug');
    final config = DngoConfig(
      name: appName,
      iosBundleId: 'com.example.$slug',
      androidApplicationId: 'com.example.$slug',
      versionName: '1.0.0',
      buildNumber: 1,
      plugins: selected.toSet(),
      iosPermissions: _defaultPermissions(selected),
    );
    File('${project.path}/dngo.config.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync(renderConfig(config));
    DngoNativeGenerator(project).generate(config);
    stdout.writeln(
      'Created $slug with ${selected.length} supported plugin(s).',
    );
  }

  Map<String, String> _defaultPermissions(List<String> plugins) {
    final result = <String, String>{};
    if (plugins.contains('dartnative_media_picker')) {
      result['NSPhotoLibraryUsageDescription'] =
          'Pick photos and videos to use in the app.';
      result['NSPhotoLibraryAddUsageDescription'] =
          'Save photos and videos you create in the app.';
    }
    if (plugins.contains('dartnative_notifications')) {
      result['NSUserNotificationsUsageDescription'] =
          'Allow notifications from this app.';
    }
    return result;
  }

  List<String> _askPlugins() {
    stdout.writeln('Supported plugins:');
    for (var i = 0; i < kSupportedNativePlugins.length; i++) {
      final plugin = kSupportedNativePlugins[i];
      stdout.writeln(
        '  ${i + 1}. ${plugin.name} (${plugin.supportedConstraint})',
      );
    }
    final input = _ask('Plugins (comma-separated numbers, empty for none): ');
    return input
        .split(',')
        .map((value) => int.tryParse(value.trim()))
        .whereType<int>()
        .where((index) => index > 0 && index <= kSupportedNativePlugins.length)
        .map((index) => kSupportedNativePlugins[index - 1].name)
        .toList();
  }

  String _ask(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync()?.trim() ?? '';
  }

  String _slug(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}

String renderConfig(DngoConfig config) {
  final permissions = config.iosPermissions.entries
      .map((entry) => "'${entry.key}': '${entry.value}'")
      .join(',\n        ');
  final plugins = config.plugins.map((plugin) => "'$plugin'").join(', ');
  return '''import 'package:dartnative_go/src/prebuild/config.dart';

const dngoConfig = DngoConfig(
  name: '${config.name}',
  iosBundleId: '${config.iosBundleId}',
  androidApplicationId: '${config.androidApplicationId}',
  versionName: '${config.versionName}',
  buildNumber: ${config.buildNumber},
  androidMinSdk: ${config.androidMinSdk},
  androidTargetSdk: ${config.androidTargetSdk},
  iosDeploymentTarget: ${config.iosDeploymentTarget},
  ${config.icon == null ? '' : "icon: '${config.icon}',"}
  ${config.splash == null ? '' : "splash: '${config.splash}',"}
  ${config.splashColor == null ? '' : "splashColor: '${config.splashColor}',"}
  iosPermissions: {
        $permissions
  },
  plugins: {$plugins},
);
''';
}

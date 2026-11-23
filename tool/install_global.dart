import 'dart:io';

import 'sync_versions.dart';

/// Builds and installs `dngo` into global bin directories in PATH:
/// - ~/.local/bin/dngo
/// - ~/.pub-cache/bin/dngo
///
/// Syncs `version.dart` from pubspec + `dn_plugins.lock` before compile so
/// `dngo --version` and the local dev server advertise the same numbers
/// with no runtime probes.
void main() async {
  final scriptDir = File(Platform.script.toFilePath()).parent.parent;
  final binFile = File('${scriptDir.path}/bin/dngo.dart');

  if (!binFile.existsSync()) {
    print('Error: Could not find ${binFile.path}');
    exit(1);
  }

  final synced = syncVersions(scriptDir);
  print(
    '✔ Synced versions (dngo ${synced.dngoVersion}, '
    'DartNative ${synced.dartNativeVersion})',
  );

  print('⚡️ Compiling dngo native executable...');
  final tempOut = '${Directory.systemTemp.path}/dngo_build';

  final result = await Process.run(
    'dart',
    ['compile', 'exe', binFile.path, '-o', tempOut],
    workingDirectory: scriptDir.path,
  );

  if (result.exitCode != 0) {
    print('Compilation failed:\n${result.stderr}');
    exit(result.exitCode);
  }

  final home = Platform.environment['HOME'] ?? '';
  final targetDirs = [
    '$home/.local/bin',
    '$home/.pub-cache/bin',
  ];

  var installedCount = 0;
  for (final dirPath in targetDirs) {
    final dir = Directory(dirPath);
    if (dir.existsSync()) {
      final destFile = File('$dirPath/dngo');
      try {
        File(tempOut).copySync(destFile.path);
        // Ensure executable permissions
        Process.runSync('chmod', ['+x', destFile.path]);
        print('✔ Installed to ${destFile.path}');
        installedCount++;
      } catch (e) {
        print('⚠ Could not write to ${destFile.path}: $e');
      }
    }
  }

  try {
    File(tempOut).deleteSync();
  } catch (_) {}

  if (installedCount > 0) {
    print('\n🎉 dngo CLI successfully installed globally!');
    print('You can now run:');
    print('  dngo start');
    print('  dngo doctor');
    print('  dngo version');
  } else {
    print(
      'Warning: No target directory in ~/.local/bin or ~/.pub-cache/bin was found.',
    );
  }
}

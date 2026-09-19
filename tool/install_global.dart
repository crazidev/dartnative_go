import 'dart:io';

/// Builds and installs `dart_go` into global bin directories in PATH:
/// - ~/.local/bin/dart_go
/// - ~/.pub-cache/bin/dart_go
void main() async {
  final scriptDir = File(Platform.script.toFilePath()).parent.parent;
  final binFile = File('${scriptDir.path}/bin/dart_go.dart');

  if (!binFile.existsSync()) {
    print('Error: Could not find ${binFile.path}');
    exit(1);
  }

  print('⚡️ Compiling dart_go native executable...');
  final tempOut = '${Directory.systemTemp.path}/dart_go_build';

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
      final destFile = File('$dirPath/dart_go');
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
    print('\n🎉 dart_go CLI successfully installed globally!');
    print('You can now run:');
    print('  dart_go start');
    print('  dart_go doctor');
    print('  dart_go version');
  } else {
    print('Warning: No target directory in ~/.local/bin or ~/.pub-cache/bin was found.');
  }
}

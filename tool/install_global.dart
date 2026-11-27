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
  final tempOutDir = Directory('${Directory.systemTemp.path}/dngo_build');
  if (tempOutDir.existsSync()) {
    tempOutDir.deleteSync(recursive: true);
  }

  final result = await Process.run(
    'dart',
    ['build', 'cli', '-t', binFile.path, '-o', tempOutDir.path],
    workingDirectory: scriptDir.path,
  );

  if (result.exitCode != 0) {
    print('Compilation failed:\n${result.stderr}');
    exit(result.exitCode);
  }

  final builtBin = File('${tempOutDir.path}/bundle/bin/dngo');
  if (!builtBin.existsSync()) {
    print('Compilation succeeded but expected binary not found at ${builtBin.path}');
    exit(1);
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
      final stagedFile = File('$dirPath/.dngo.tmp.$pid');
      try {
        // Stage to a fresh inode and atomically rename into place instead of
        // overwriting in place. On macOS, overwriting an existing executable
        // keeps the kernel's cached code signature (csblob) on the old vnode,
        // causing taskgated to kill the new binary with SIGKILL (Code Signature Invalid).
        if (stagedFile.existsSync()) {
          stagedFile.deleteSync();
        }
        builtBin.copySync(stagedFile.path);
        if (!Platform.isWindows) {
          Process.runSync('chmod', ['+x', stagedFile.path]);
        }
        stagedFile.renameSync(destFile.path);
        print('✔ Installed to ${destFile.path}');
        installedCount++;
      } catch (e) {
        if (stagedFile.existsSync()) {
          try {
            stagedFile.deleteSync();
          } catch (_) {}
        }
        print('⚠ Could not write to ${destFile.path}: $e');
      }
    }
  }

  try {
    tempOutDir.deleteSync(recursive: true);
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

/// `dart_go open` — deliver a `dartnativego://` link to a simulator/emulator or print it.
library;

import 'dart:io';

import '../../client/deep_link.dart';
import '../server/qr_code.dart';
import 'command_line.dart';

/// Bundle id / package name used when opening the link with platform tooling.
const String kDartGoAndroidPackage = 'com.example.dartnative_go';
const String kDartGoIosBundleId = 'com.beatcodestudio.dartgo';

Future<void> runDeepLinkCommand(DartGoCommandLine cli) async {
  final serverUrl = cli.deepLinkTarget;
  if (serverUrl == null || serverUrl.trim().isEmpty) {
    stderr.writeln(
      'Usage: dart_go open --url=<host:port> [--name=<app>] [--device] [--qr]\n'
      '       dart_go open <link>\n',
    );
    exitCode = 1;
    return;
  }

  // `dart_go open dartnativego://…` passes the whole link through unchanged.
  final link = serverUrl.startsWith('${DartGoDeepLink.scheme}://')
      ? serverUrl
      : DartGoDeepLink.build(serverUrl, appName: cli.deepLinkName);

  print('[LINK] $link');

  if (cli.deepLinkQr) {
    print('');
    print(QrCode(link).renderToTerminal());
  }

  if (!cli.deepLinkDevice) return;

  final opened = await _openOnDevice(link);
  if (!opened) {
    stderr.writeln(
      '\n! No simulator, emulator or device was available to open the link.\n'
      '  Open it on the device yourself, or tap the QR code above.',
    );
    exitCode = 1;
  }
}

/// Delivers [link] to a running simulator/emulator. Returns false when no
/// platform tooling is present or the command failed.
Future<bool> _openOnDevice(String link) async {
  if (Platform.isMacOS) {
    final simulators = await _run('xcrun', [
      'simctl',
      'openurl',
      'booted',
      link,
    ]);
    if (simulators) {
      print('[LINK] Opened on the booted iOS simulator.');
      return true;
    }
  }

  // adb works the same for emulators and physical Android devices.
  final android = await _run('adb', [
    'shell',
    'am',
    'start',
    '-a',
    'android.intent.action.VIEW',
    '-d',
    link,
    kDartGoAndroidPackage,
  ]);
  if (android) {
    print('[LINK] Opened on the connected Android device/emulator.');
    return true;
  }
  return false;
}

/// Runs [executable] with [args]; returns true only when it exits 0.
Future<bool> _run(String executable, List<String> args) async {
  try {
    final result = await Process.run(executable, args);
    return result.exitCode == 0;
  } on Object {
    // Tool missing (no Xcode, no adb): the caller falls back to printing.
    return false;
  }
}

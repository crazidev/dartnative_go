/// Terminal output and interactive keys for `dart_go start`.
library;

import 'dart:async';
import 'dart:io';

import '../../runner/logger.dart';
import '../diagnostics/dart_go_version.dart';
import 'dev_socket_hub.dart';
import 'qr_code.dart';

const _dim = '\x1B[90m';
const _reset = '\x1B[0m';
const _cyan = '\x1B[36m';

void printBanner() {
  print('\x1B[2J\x1B[0;0H');
  print('╔══════════════════════════════════════════════════════════╗');
  print('║            [DART] DartNative Go Dev Server [DART]        ║');
  print('║                 CLI & Runtime v$kDartGoVersion                   ║');
  print('╚══════════════════════════════════════════════════════════╝\n');
}

void printConnectionInfo(String serverUrl) {
  print('[WEB] Server URL: $_cyan$serverUrl$_reset');
  print(
    '[WS] WebSocket:  $_cyan${serverUrl.replaceFirst('http', 'ws')}/ws$_reset',
  );
}

void printHelpHint() => print('${_dim}Press h for help$_reset\n');

void printQr(String serverUrl) {
  print('[MOBILE] \x1B[1mScan with DartNative Go mobile app:$_reset');
  print(QrCode(serverUrl).renderToTerminal());
}

/// Single-key commands read from stdin while the server runs.
class StdinCommands {
  StdinCommands({
    required this.serverUrl,
    required this.hub,
    required this.onStop,
  });

  final String serverUrl;
  final DevSocketHub hub;

  /// Called on Ctrl+C; must release the server.
  final void Function() onStop;

  StreamSubscription<List<int>>? _sub;

  void start() {
    try {
      if (stdin.hasTerminal) {
        stdin.lineMode = false;
        stdin.echoMode = false;
      }
    } catch (_) {}
    _sub = stdin.listen((bytes) {
      for (final byte in bytes) {
        if (byte == 3) {
          onStop();
          exit(0);
        }
        _handle(String.fromCharCode(byte).toLowerCase());
      }
    });
  }

  void stop() {
    try {
      if (stdin.hasTerminal) {
        stdin.lineMode = true;
        stdin.echoMode = true;
      }
    } catch (_) {}
    _sub?.cancel();
  }

  void _handle(String key) {
    switch (key) {
      case 'h':
        print('\nCommands:');
        print('  h  Help');
        print('  r  Hot reload');
        print(
          '  v  Toggle verbose logging (currently: ${DartGoLogger.verbose ? "on" : "off"})',
        );
        print('  q  Show QR code');
        print('  c  Clear screen\n');
      case 'r':
        print('\n[RELOAD] Triggering manual reload...');
        hub.broadcastReload();
      case 'v':
        final enabled = DartGoLogger.toggleVerbose();
        hub.broadcast({'type': 'set_verbose', 'enabled': enabled});
        print('\n[VERBOSE] ${verboseLabel(enabled)}\n');
      case 'q':
        print('');
        printQr(serverUrl);
        printHelpHint();
      case 'c':
        print('\x1B[2J\x1B[0;0H');
        printConnectionInfo(serverUrl);
        print('');
        printHelpHint();
    }
  }
}

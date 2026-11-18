import 'dart:io';

import 'package:dartnative_go/src/cli/diagnostics/asset_detector.dart';
import 'package:dartnative_go/src/cli/commands/command_line.dart';
import 'package:dartnative_go/src/cli/commands/deep_link_command.dart';
import 'package:dartnative_go/src/cli/diagnostics/dart_go_version.dart';
import 'package:dartnative_go/src/cli/diagnostics/pubspec_validator.dart';
import 'package:dartnative_go/src/cli/server/server.dart';
import 'package:dartnative_go/src/dap/dap_server.dart';

Future<void> main(List<String> args) async {
  final cli = DartGoCommandLine.parse(args);
  switch (cli.command) {
    case DartGoCommand.help:
      _printHelp();
      return;
    case DartGoCommand.version:
      _printVersion();
      return;
    case DartGoCommand.doctor:
      _runDoctor(cli.projectDir);
      return;
    case DartGoCommand.dap:
      await runDartNativeDap(cli.commandArgs);
      return;
    case DartGoCommand.open:
      await runDeepLinkCommand(cli);
      return;
    case DartGoCommand.unknown:
      print('Unknown command: ${args.first}\n');
      _printHelp();
      exit(1);
    case DartGoCommand.start:
      final server = DartGoServer(
        DartGoServerOptions(
          projectDir: cli.projectDir,
          startPort: cli.startPort,
          endPort: cli.endPort,
          enableBroadcast: cli.broadcast,
          enableQrCode: cli.qrCode,
          customHost: cli.host,
          rebuildAst: cli.rebuildAst,
          verbose: cli.verbose,
          profile: cli.profile,
        ),
      );
      ProcessSignal.sigint.watch().listen((_) {
        print('\n[STOP] Shutting down DartNative Go server...');
        server.stop();
        exit(0);
      });
      await server.start();
  }
}

void _runDoctor(Directory projectDir) {
  print('╔══════════════════════════════════════════════════════════╗');
  print('║             [CHECK] DartNative Go Project Doctor         ║');
  print('╚══════════════════════════════════════════════════════════╝\n');

  final validator = PubspecValidator(projectDir);
  final validation = validator.validate();
  print(validation.formatReport());

  final detector = AssetDetector(projectDir);
  final assets = detector.detect();
  print(assets.formatReport());
}

void _printVersion() {
  print('DartNative Go CLI version: v$kDartGoVersion');
  print('Target Mobile Runtime:      v$kDartGoRuntimeVersion\n');
  print('Supported Native Plugins in DartNative Go v$kDartGoVersion:');
  for (final p in kSupportedNativePlugins) {
    final coreTag = p.isCore ? ' [core]' : '';
    print(
      '  • ${p.name.padRight(24)} ${p.supportedConstraint.padRight(10)}$coreTag (${p.description})',
    );
  }
}

void _printHelp() {
  print('''
[DART] dngo — The DartNative Go CLI

USAGE:
  dngo <command> [arguments]

AVAILABLE COMMANDS:
  start          Start live dev server with QR code, asset serving & hot reload (default)
  open           Open a project in the app through a dartnativego:// deep link
  dap            Start DAP (Debug Adapter Protocol) server for VS Code debugging
  debug_adapter  Alias for 'dap'
  doctor         Inspect project dependencies and assets for compatibility
  version        Display CLI version and bundled native plugin compatibility matrix
  help           Show this help message

OPTIONS FOR 'open':
      --url=<host:port>       Dev server address to open (or pass a whole link)
      --name=<app>            App name shown on the splash while it loads
      --device                Open the link with xcrun simctl / adb
      --qr                    Render the link as a terminal QR code

OPTIONS FOR 'start':
  -p, --port=<int>            Base port to start listening on (default: 8088)
      --port-range=<min-max>  Range of ports to scan and broadcast across (default: 8088-8098)
      --project=<path>        Path to DartNative project directory (default: current directory)
      --host=<ip>             Custom host IP/interface to advertise
      --rebuild-ast           Rebuild .dart_tool/bundles/guest.ast on Dart changes (AST hot reload; default: on)
      --no-rebuild-ast        Disable AST rebuild (source-only hot reload)
  -v, --verbose               Enable verbose step-by-step benchmark logs and diagnostic traces
      --profile               Show the AST BUNDLE explorer in the app DevTools sheet (default: off)
      --no-broadcast          Disable local UDP discovery beacon
      --no-qrcode             Disable terminal QR code rendering

EXAMPLES:
  dngo start
  dngo start --project=/path/to/my_app
  dngo start --project=/path/to/my_app --rebuild-ast
  dngo start -p 8090
  dngo open --url=192.168.1.10:8088 --device
  dngo open dartnativego://open?url=192.168.1.10%3A8088
  dngo doctor
  dngo version
''');
}

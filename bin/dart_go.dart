import 'dart:io';

import 'package:dartnative_go/src/cli/asset_detector.dart';
import 'package:dartnative_go/src/cli/dart_go_version.dart';
import 'package:dartnative_go/src/cli/pubspec_validator.dart';
import 'package:dartnative_go/src/cli/server.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty || args.contains('-h') || args.contains('--help') || args.first == 'help') {
    if (args.isNotEmpty && args.first != 'help' && !args.contains('-h') && !args.contains('--help')) {
      // Proceed to default start
    } else {
      _printHelp();
      return;
    }
  }

  final command = args.isEmpty ? 'start' : args.first;

  if (command == 'version' || command == '--version' || command == '-v') {
    _printVersion();
    return;
  }

  if (command == 'doctor') {
    final projectDir = _parseProjectDir(args.skip(1).toList());
    _runDoctor(projectDir);
    return;
  }

  if (command == 'start' || !command.startsWith('-')) {
    final commandArgs = (command == 'start') ? args.skip(1).toList() : args;
    final projectDir = _parseProjectDir(commandArgs);
    final (startPort, endPort) = _parsePortRange(commandArgs);
    final enableBroadcast = !commandArgs.contains('--no-broadcast');
    final enableQrCode = !commandArgs.contains('--no-qrcode');
    final customHost = _parseStringArg(commandArgs, 'host');
    final rebuildAst = !commandArgs.contains('--no-rebuild-ast');

    final server = DartGoServer(
      DartGoServerOptions(
        projectDir: projectDir,
        startPort: startPort,
        endPort: endPort,
        enableBroadcast: enableBroadcast,
        enableQrCode: enableQrCode,
        customHost: customHost,
        rebuildAst: rebuildAst,
      ),
    );

    // Trap SIGINT / SIGTERM for graceful shutdown
    ProcessSignal.sigint.watch().listen((_) {
      print('\n🛑 Shutting down DartNative Go server...');
      server.stop();
      exit(0);
    });

    await server.start();
    return;
  }

  print('Unknown command: $command\n');
  _printHelp();
  exit(1);
}

Directory _parseProjectDir(List<String> args) {
  for (final a in args) {
    if (a.startsWith('--project=')) {
      return Directory(a.substring('--project='.length));
    }
  }
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--project' && i + 1 < args.length) {
      return Directory(args[i + 1]);
    }
  }
  // If a positional directory argument is passed
  for (final a in args) {
    if (!a.startsWith('-')) {
      final dir = Directory(a);
      if (dir.existsSync()) return dir;
    }
  }
  return Directory.current;
}

(int startPort, int endPort) _parsePortRange(List<String> args) {
  var start = 8088;
  var end = 8098;

  for (final a in args) {
    if (a.startsWith('--port-range=')) {
      final val = a.substring('--port-range='.length);
      final parts = val.split('-');
      if (parts.length == 2) {
        start = int.tryParse(parts[0]) ?? start;
        end = int.tryParse(parts[1]) ?? end;
      }
    } else if (a.startsWith('--port=') || a.startsWith('-p=')) {
      final val = a.replaceFirst(RegExp(r'^(-p|--port)='), '');
      final p = int.tryParse(val);
      if (p != null) {
        start = p;
        end = p + 10;
      }
    }
  }

  for (var i = 0; i < args.length; i++) {
    if ((args[i] == '-p' || args[i] == '--port') && i + 1 < args.length) {
      final p = int.tryParse(args[i + 1]);
      if (p != null) {
        start = p;
        end = p + 10;
      }
    }
  }

  return (start, end);
}

String? _parseStringArg(List<String> args, String name) {
  for (final a in args) {
    if (a.startsWith('--$name=')) {
      return a.substring('--$name='.length);
    }
  }
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--$name' && i + 1 < args.length) {
      return args[i + 1];
    }
  }
  return null;
}

void _runDoctor(Directory projectDir) {
  print('╔══════════════════════════════════════════════════════════╗');
  print('║             🩺 DartNative Go Project Doctor              ║');
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
    print('  • ${p.name.padRight(24)} ${p.supportedConstraint.padRight(10)}$coreTag (${p.description})');
  }
}

void _printHelp() {
  print('''
⚡️ dart_go — The DartNative Go CLI

USAGE:
  dart_go <command> [arguments]

AVAILABLE COMMANDS:
  start       Start live dev server with QR code, asset serving & hot reload (default)
  doctor      Inspect project dependencies and assets for compatibility
  version     Display CLI version and bundled native plugin compatibility matrix
  help        Show this help message

OPTIONS FOR 'start':
  -p, --port=<int>            Base port to start listening on (default: 8088)
      --port-range=<min-max>  Range of ports to scan and broadcast across (default: 8088-8098)
      --project=<path>        Path to DartNative project directory (default: current directory)
      --host=<ip>             Custom host IP/interface to advertise
      --rebuild-ast           Rebuild assets/bundles/guest.ast on Dart changes (AST hot reload; default: on)
      --no-rebuild-ast        Disable AST rebuild (source-only hot reload)
      --no-broadcast          Disable local UDP discovery beacon
      --no-qrcode             Disable terminal QR code rendering

EXAMPLES:
  dart_go start
  dart_go start --project=/path/to/my_app
  dart_go start --project=/path/to/my_app --rebuild-ast
  dart_go start -p 8090
  dart_go doctor
  dart_go version
''');
}

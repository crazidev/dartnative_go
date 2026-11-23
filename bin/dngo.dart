import 'dart:io';

import 'package:dartnative_go/src/cli/diagnostics/asset_detector.dart';
import 'package:dartnative_go/src/cli/commands/command_line.dart';
import 'package:dartnative_go/src/cli/commands/deep_link_command.dart';
import 'package:dartnative_go/src/cli/diagnostics/dart_go_version.dart';
import 'package:dartnative_go/src/cli/diagnostics/pubspec_validator.dart';
import 'package:dartnative_go/src/cli/server/server.dart';
import 'package:dartnative_go/src/dap/dap_server.dart';
import 'package:dartnative_go/src/prebuild/config.dart';
import 'package:dartnative_go/src/prebuild/config_init.dart';
import 'package:dartnative_go/src/prebuild/native_generator.dart';
import 'package:dartnative_go/src/prebuild/plugin_discovery.dart';
import 'package:dartnative_go/src/prebuild/project_creator.dart';

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
    case DartGoCommand.prebuild:
      await _runPrebuild(
        cli.projectDir,
        clean: cli.commandArgs.contains('--clean'),
      );
      return;
    case DartGoCommand.prebuildInit:
      _runPrebuildInit(
        cli.projectDir,
        force: cli.commandArgs.contains('--force'),
        syncFromProject: cli.commandArgs.contains('--no-sync')
            ? false
            : cli.commandArgs.contains('--sync')
            ? true
            : null,
      );
      return;
    case DartGoCommand.create:
      await DngoProjectCreator(cli.projectDir).run(
        name: _arg(cli.commandArgs, 'name'),
        plugins: _arg(cli.commandArgs, 'plugins')
            ?.split(',')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList(),
      );
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

Future<void> _runPrebuild(Directory projectDir, {bool clean = false}) async {
  final file = File('${projectDir.path}/dngo.config.dart');
  if (!file.existsSync()) {
    throw StateError('Missing dngo.config.dart in ${projectDir.path}');
  }
  final parsed = DngoConfigParser.parse(
    file.readAsStringSync(),
    baseDirectory: projectDir.path,
  );
  final config = applyDngoPluginDefaults(parsed);
  final generator = DngoNativeGenerator(projectDir);
  await generator.ensureNativeProject(clean: clean);
  await generator.generate(config);
  final discovered = discoverPluginBuildConfigs(projectDir);
  print(
    clean
        ? 'Recreated and generated native projects for ${config.name}.'
        : 'Synced native projects for ${config.name}.',
  );
  if (discovered.isNotEmpty) {
    print(
      '  plugins:         ${discovered.map((plugin) => plugin.name).join(', ')} '
      '(from build_config.dart)',
    );
  }
}

void _runPrebuildInit(
  Directory projectDir, {
  bool force = false,
  bool? syncFromProject,
}) {
  final inspection = initializeDngoConfig(
    projectDir,
    force: force,
    syncFromProject: syncFromProject,
    confirmOverwrite: force
        ? null
        : () => _confirm(
            'dngo.config.dart already exists. Overwrite it?',
            defaultYes: false,
          ),
    confirmSync: () => _confirm(
      'Sync permissions, Gradle, Info.plist, Podfile and other native '
      'settings into dngo.config.dart?',
      defaultYes: true,
    ),
  );
  print('Created ${projectDir.path}/dngo.config.dart');
  print('  name:            ${inspection.name}');
  print(
    '  version:         ${inspection.versionName}+${inspection.buildNumber}',
  );
  print('  android bundle:  ${inspection.androidBundleId}');
  print('  ios bundle:      ${inspection.iosBundleId}');
  print(
    inspection.syncedFromProject
        ? '  native settings: copied from the current Android/iOS project'
        : '  native settings: skipped',
  );
  if (!inspection.hasAndroid || !inspection.hasIos) {
    final missing = [
      if (!inspection.hasAndroid) 'android',
      if (!inspection.hasIos) 'ios',
    ];
    print(
      '  note:            ${missing.join(' and ')} project(s) not found; '
      'fallback bundle ids were used.',
    );
  }
}

bool _confirm(String question, {required bool defaultYes}) {
  if (!stdin.hasTerminal) return defaultYes;
  stdout.write('$question ${defaultYes ? '[Y/n]' : '[y/N]'} ');
  final answer = stdin.readLineSync()?.trim().toLowerCase();
  if (answer == null || answer.isEmpty) return defaultYes;
  return answer == 'y' || answer == 'yes';
}

String? _arg(List<String> args, String name) {
  final prefix = '--$name=';
  for (var i = 0; i < args.length; i++) {
    if (args[i].startsWith(prefix)) return args[i].substring(prefix.length);
    if (args[i] == '--$name' && i + 1 < args.length) return args[i + 1];
  }
  return null;
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
  print('Target Mobile Runtime:      v$kDartGoRuntimeVersion');
  print('DartNative SDK:             v$kDartNativeVersion\n');
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
  prebuild       Sync Android and iOS projects from dngo.config.dart (use --clean to recreate)
  prebuild:init  Create dngo.config.dart from an existing project
  create         Run dn create, select supported plugins, and generate config
  version        Display CLI version and bundled native plugin compatibility matrix
  help           Show this help message

OPTIONS FOR 'open':
      --url=<host:port>       Dev server address to open (or pass a whole link)
      --name=<app>            App name shown on the splash while it loads
      --device                Open the link with xcrun simctl / adb
      --qr                    Render the link as a terminal QR code

OPTIONS FOR 'prebuild':
      --project=<path>        Path to DartNative project directory (default: current directory)
      --clean                 Delete android/ and ios/ first, then recreate them from the template

OPTIONS FOR 'prebuild:init':
      --project=<path>        Path to DartNative project directory (default: current directory)
      --force                 Overwrite an existing dngo.config.dart without asking
      --sync                  Copy native project settings into the config without asking
      --no-sync               Write only name, version and bundle ids

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
  dngo prebuild
  dngo prebuild --clean
  dngo version
''');
}

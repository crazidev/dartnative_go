import 'dart:io';

/// Commands exposed by the `dart_go` executable.
enum DartGoCommand {
  start,
  open,
  doctor,
  version,
  dap,
  prebuild,
  prebuildInit,
  create,
  help,
  unknown,
}

/// Parsed, side-effect-free CLI configuration.
///
/// Keeping parsing separate from command execution makes the executable small,
/// testable, and safe to reuse from wrappers around `dart_go`.
class DartGoCommandLine {
  final DartGoCommand command;
  final List<String> commandArgs;
  final Directory projectDir;
  final int startPort;
  final int endPort;
  final String? host;
  final bool verbose;
  final bool broadcast;
  final bool qrCode;
  final bool rebuildAst;

  /// `--profile`: advertises `profile: true` in the manifest so AST-mode
  /// apps show the AST BUNDLE explorer in their DevTools sheet. Off by
  /// default — the explorer costs an on-demand AST sizing walk per open.
  final bool profile;

  /// `open`: the project address (or a whole `dartnativego://` link) to hand
  /// to the app. Null when the command was given neither `--url` nor a
  /// positional link.
  final String? deepLinkTarget;

  /// `open --name`: app name shown on the splash while the project loads.
  final String? deepLinkName;

  /// `open --device`: deliver the link with `xcrun simctl` / `adb` instead of
  /// only printing it.
  final bool deepLinkDevice;

  /// `open --qr`: also render the link as a terminal QR code.
  final bool deepLinkQr;

  const DartGoCommandLine({
    required this.command,
    required this.commandArgs,
    required this.projectDir,
    required this.startPort,
    required this.endPort,
    required this.host,
    required this.verbose,
    required this.broadcast,
    required this.qrCode,
    required this.rebuildAst,
    required this.profile,
    this.deepLinkTarget,
    this.deepLinkName,
    this.deepLinkDevice = false,
    this.deepLinkQr = false,
  });

  factory DartGoCommandLine.parse(List<String> args, {Directory? currentDir}) {
    final baseDir = currentDir ?? Directory.current;
    if (args.isEmpty) return _start(args, baseDir);
    if (args.contains('-h') ||
        args.contains('--help') ||
        args.first == 'help') {
      return _help(args, baseDir);
    }

    final first = args.first;
    if (first == 'version' ||
        first == '--version' ||
        (first == '-v' && args.length == 1)) {
      return _simple(DartGoCommand.version, args, baseDir);
    }
    if (first == 'doctor') {
      return _simple(
        DartGoCommand.doctor,
        args,
        _projectDir(args.skip(1), baseDir),
      );
    }
    if (first == 'dap' || first == 'debug_adapter') {
      return _simple(DartGoCommand.dap, args.skip(1).toList(), baseDir);
    }
    if (first == 'prebuild:init') {
      return _simple(
        DartGoCommand.prebuildInit,
        args.skip(1).toList(),
        _projectDir(args.skip(1), baseDir),
      );
    }
    if (first == 'prebuild') {
      return _simple(
        DartGoCommand.prebuild,
        args.skip(1).toList(),
        _projectDir(args.skip(1), baseDir),
      );
    }
    if (first == 'create') {
      return _simple(DartGoCommand.create, args.skip(1).toList(), baseDir);
    }
    if (first == 'open') {
      return _open(args.skip(1).toList(), baseDir);
    }

    final startArgs = first == 'start' ? args.skip(1).toList() : args;
    if (first == 'start' ||
        !first.startsWith('-') ||
        first == '-v' ||
        first == '--verbose') {
      return _start(startArgs, baseDir);
    }
    return _simple(DartGoCommand.unknown, args, baseDir);
  }

  static DartGoCommandLine _start(List<String> args, Directory baseDir) {
    final (startPort, endPort) = _ports(args);
    return DartGoCommandLine(
      command: DartGoCommand.start,
      commandArgs: args,
      projectDir: _projectDir(args, baseDir),
      startPort: startPort,
      endPort: endPort,
      host: _value(args, 'host'),
      verbose: args.contains('-v') || args.contains('--verbose'),
      broadcast: !args.contains('--no-broadcast'),
      qrCode: !args.contains('--no-qrcode'),
      rebuildAst: !args.contains('--no-rebuild-ast'),
      profile: args.contains('--profile'),
    );
  }

  static DartGoCommandLine _open(List<String> args, Directory baseDir) {
    // Positional form: `dart_go open dartnativego://…` (or `open 192.168.1.9:8088`).
    String? positional;
    for (var i = 0; i < args.length; i++) {
      final arg = args[i];
      if (arg.startsWith('-')) {
        // Skip the value of `--flag value` pairs.
        if (!arg.contains('=') && i + 1 < args.length) i++;
        continue;
      }
      positional = arg;
      break;
    }
    final target = _value(args, 'url') ?? positional;
    return DartGoCommandLine(
      command: DartGoCommand.open,
      commandArgs: args,
      projectDir: baseDir,
      startPort: 8088,
      endPort: 8098,
      host: null,
      verbose: false,
      broadcast: true,
      qrCode: true,
      rebuildAst: true,
      profile: false,
      deepLinkTarget: (target == null || target.trim().isEmpty) ? null : target,
      deepLinkName: _value(args, 'name'),
      deepLinkDevice: args.contains('--device'),
      deepLinkQr: args.contains('--qr'),
    );
  }

  static DartGoCommandLine _simple(
    DartGoCommand command,
    List<String> args,
    Directory projectDir,
  ) => DartGoCommandLine(
    command: command,
    commandArgs: args,
    projectDir: projectDir,
    startPort: 8088,
    endPort: 8098,
    host: null,
    verbose: false,
    broadcast: true,
    qrCode: true,
    rebuildAst: true,
    profile: false,
  );

  static DartGoCommandLine _help(List<String> args, Directory baseDir) =>
      _simple(DartGoCommand.help, args, baseDir);

  static Directory _projectDir(Iterable<String> args, Directory fallback) {
    final values = args.toList();
    final explicit = _value(values, 'project');
    if (explicit != null) return Directory(explicit);
    for (final value in values) {
      if (!value.startsWith('-')) {
        final candidate = Directory(value);
        if (candidate.existsSync()) return candidate;
      }
    }
    return fallback;
  }

  static (int, int) _ports(List<String> args) {
    var start = 8088;
    var end = 8098;
    final range = _value(args, 'port-range');
    if (range != null) {
      final parts = range.split('-');
      if (parts.length == 2) {
        start = int.tryParse(parts[0]) ?? start;
        end = int.tryParse(parts[1]) ?? end;
      }
    }
    final port = _value(args, 'port') ?? _value(args, 'p');
    final parsed = int.tryParse(port ?? '');
    if (parsed != null) {
      start = parsed;
      end = parsed + 10;
    }
    return (start, end);
  }

  static String? _value(List<String> args, String name) {
    final prefix = '--$name=';
    for (var i = 0; i < args.length; i++) {
      final arg = args[i];
      if (arg.startsWith(prefix)) return arg.substring(prefix.length);
      if (name == 'p' && arg.startsWith('-p=')) return arg.substring(3);
      if (arg == '--$name' && i + 1 < args.length) return args[i + 1];
      if (name == 'p' && arg == '-p' && i + 1 < args.length) return args[i + 1];
    }
    return null;
  }
}

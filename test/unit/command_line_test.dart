import 'dart:io';

import 'package:dartnative_go/src/cli/commands/command_line.dart';
import 'package:test/test.dart';

void main() {
  final cwd = Directory('/tmp/dartnative-go-cli-test');

  group('DartGoCommandLine', () {
    test('defaults to start in the supplied directory', () {
      final parsed = DartGoCommandLine.parse([], currentDir: cwd);

      expect(parsed.command, DartGoCommand.start);
      expect(parsed.projectDir.path, cwd.path);
      expect(parsed.startPort, 8088);
      expect(parsed.endPort, 8098);
      expect(parsed.rebuildAst, isTrue);
    });

    test('parses start options and project path', () {
      final parsed = DartGoCommandLine.parse([
        'start',
        '--project=/tmp/example',
        '--port-range=9000-9010',
        '--host',
        '192.168.1.20',
        '--verbose',
        '--no-broadcast',
        '--no-qrcode',
        '--no-rebuild-ast',
      ], currentDir: cwd);

      expect(parsed.command, DartGoCommand.start);
      expect(parsed.projectDir.path, '/tmp/example');
      expect(parsed.startPort, 9000);
      expect(parsed.endPort, 9010);
      expect(parsed.host, '192.168.1.20');
      expect(parsed.verbose, isTrue);
      expect(parsed.broadcast, isFalse);
      expect(parsed.qrCode, isFalse);
      expect(parsed.rebuildAst, isFalse);
      expect(parsed.profile, isFalse);
    });

    test('parses prebuild --clean without treating it as the project path', () {
      final parsed = DartGoCommandLine.parse(
        ['prebuild', '--clean'],
        currentDir: cwd,
      );

      expect(parsed.command, DartGoCommand.prebuild);
      expect(parsed.commandArgs, contains('--clean'));
      expect(parsed.projectDir.path, cwd.path);
    });

    test('parses prebuild:init without treating it as prebuild', () {
      final parsed = DartGoCommandLine.parse(
        ['prebuild:init'],
        currentDir: cwd,
      );

      expect(parsed.command, DartGoCommand.prebuildInit);
      expect(parsed.commandArgs, isEmpty);
      expect(parsed.projectDir.path, cwd.path);
    });

    test('parses prebuild:init --force and --project', () {
      final parsed = DartGoCommandLine.parse(
        ['prebuild:init', '--force', '--project=/tmp/example'],
        currentDir: cwd,
      );

      expect(parsed.command, DartGoCommand.prebuildInit);
      expect(parsed.commandArgs, contains('--force'));
      expect(parsed.projectDir.path, '/tmp/example');
    });

    test('parses prebuild:init --sync and --no-sync', () {
      expect(
        DartGoCommandLine.parse(
          ['prebuild:init', '--sync'],
          currentDir: cwd,
        ).commandArgs,
        contains('--sync'),
      );
      expect(
        DartGoCommandLine.parse(
          ['prebuild:init', '--no-sync'],
          currentDir: cwd,
        ).commandArgs,
        contains('--no-sync'),
      );
    });

    test('parses --profile (AST explorer opt-in)', () {
      final parsed = DartGoCommandLine.parse(
        ['start', '--profile'],
        currentDir: cwd,
      );

      expect(parsed.command, DartGoCommand.start);
      expect(parsed.profile, isTrue);
    });

    test(
      'recognizes aliases without treating their arguments as start options',
      () {
        expect(
          DartGoCommandLine.parse([
            'debug_adapter',
            '--verbose',
          ], currentDir: cwd).command,
          DartGoCommand.dap,
        );
        expect(
          DartGoCommandLine.parse(['--version'], currentDir: cwd).command,
          DartGoCommand.version,
        );
        expect(
          DartGoCommandLine.parse(['help'], currentDir: cwd).command,
          DartGoCommand.help,
        );
      },
    );

    test('parses doctor project option', () {
      final parsed = DartGoCommandLine.parse(
        ['doctor', '--project', '/tmp/example'],
        currentDir: cwd,
      );

      expect(parsed.command, DartGoCommand.doctor);
      expect(parsed.projectDir.path, '/tmp/example');
    });

    test('marks unknown options as unknown', () {
      expect(
        DartGoCommandLine.parse(['--not-a-command'], currentDir: cwd).command,
        DartGoCommand.unknown,
      );
    });

    test('supports disabling QR via --no-qr, --no-qrcode, --qr=false, and env', () {
      expect(
        DartGoCommandLine.parse(['start', '--no-qr'], currentDir: cwd).qrCode,
        isFalse,
      );
      expect(
        DartGoCommandLine.parse(['--no-qr'], currentDir: cwd),
        isA<DartGoCommandLine>()
            .having((c) => c.command, 'command', DartGoCommand.start)
            .having((c) => c.qrCode, 'qrCode', isFalse),
      );
      expect(
        DartGoCommandLine.parse(['start', '--qr=false'], currentDir: cwd).qrCode,
        isFalse,
      );
      expect(
        DartGoCommandLine.parse(
          ['start'],
          currentDir: cwd,
          environment: const {'DNGO_NO_QR': '1'},
        ).qrCode,
        isFalse,
      );
      expect(
        DartGoCommandLine.parse(
          ['start'],
          currentDir: cwd,
          environment: const {'DNGO_QR': '0'},
        ).qrCode,
        isFalse,
      );
      // Explicit --qr overrides DNGO_NO_QR=1.
      expect(
        DartGoCommandLine.parse(
          ['start', '--qr'],
          currentDir: cwd,
          environment: const {'DNGO_NO_QR': '1'},
        ).qrCode,
        isTrue,
      );
    });
  });
}

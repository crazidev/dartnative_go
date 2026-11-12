/// Guest failures that happen *after* evaluation must reach the host's error
/// channel — the channel the `dart_go` CLI prints — not only the device screen.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/ast/ast_widget_proxies.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

const _buildGuest = r'''
import 'package:dartnative/dartnative.dart';

class Exploding extends StatelessWidget {
  const Exploding({super.key});

  @override
  Widget build(BuildContext context) {
    throw StateError('build blew up');
  }
}

void main() {
  runApp(const Exploding());
}
''';

const _callbackGuest = r'''
import 'package:dartnative/dartnative.dart';

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Button(
          child: Text('Boom'),
          onPressed: () {
            throw StateError('handler blew up');
          },
        ),
      ),
    ),
  );
}
''';

void main() {
  group('AST guest error reporting', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;
    late List<String> errors;
    late List<String> stacks;
    late AstInterpreterRunner runner;

    setUp(() {
      logs = <String>[];
      errors = <String>[];
      stacks = <String>[];
      tmp = Directory.systemTemp.createTempSync('dn_guest_error_');
      projectDir = Directory('${tmp.path}/guest_error_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: guest_error_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      runner = AstInterpreterRunner(
        onLog: logs.add,
        onGuestError: (error, stack) {
          errors.add('$error');
          stacks.add('$stack');
        },
      );
    });

    tearDown(() {
      runner.dispose();
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    Future<({List<int> bytes, Map<String, String> fingerprints})> build(
      String source,
      String tag,
    ) async {
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(source);
      final out = File('${projectDir.path}/$tag.ast');
      final result = await buildGuestAstBundle(
        projectDir,
        outputArg: out.path,
        force: true,
      );
      expect(result.success, isTrue, reason: result.error);
      return (
        bytes: await out.readAsBytes(),
        fingerprints: result.moduleFingerprints,
      );
    }

    test('a throwing bridge callback reaches the host error channel', () async {
      final bundle = await build(_callbackGuest, 'callback');
      final root = await runner.evaluateAstBundleAs<Widget>(
        bundle.bytes,
        moduleFingerprints: bundle.fingerprints,
      );
      final button = ((root as Scaffold).body as Center).child as Button;

      expect(
        button.onPressed,
        isNotNull,
        reason: 'precondition: the button has a guest handler',
      );
      expect(
        () => button.onPressed!(),
        throwsA(anything),
        reason: 'reporting must not swallow the failure',
      );
      expect(
        errors.where((e) => e.contains('handler blew up')),
        isNotEmpty,
        reason: 'a throwing callback must reach the host error channel',
      );
      expect(
        stacks.where((s) => s.contains('callInterpreterCallback')),
        isNotEmpty,
        reason: 'the host channel must also capture the stack trace',
      );
    });

    test('a throwing build reaches the host error channel', () async {
      final bundle = await build(_buildGuest, 'build');
      final root = await runner.evaluateAstBundleAs<Widget>(
        bundle.bytes,
        moduleFingerprints: bundle.fingerprints,
      );
      final panel = root as InterpretedStatelessWidget;

      late Widget fallback;
      expect(
        () => fallback = panel.build(_FakeContext()),
        returnsNormally,
        reason:
            'a monitored build failure becomes a neutral placeholder: the '
            'host is about to replace it with its own error surface, and '
            'rethrowing would flash the framework error screen first',
      );
      expect(fallback, isA<SizedBox>());
      expect(
        errors.where((e) => e.contains('build blew up')),
        isNotEmpty,
        reason: 'a throwing build must reach the host error channel',
      );
      expect(
        stacks.where((s) => s.contains('Exploding.build')),
        isNotEmpty,
        reason:
            'the host channel must also capture the stack trace, pointing at '
            'the guest frame that threw: $stacks',
      );
    });
  });
}

class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

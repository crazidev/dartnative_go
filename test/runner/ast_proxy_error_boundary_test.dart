/// A proxy whose guest build starts throwing renders its last good child
/// instead of failing the tree: the working UI stays up while the error goes
/// to the host error channel. The next reload with fixed code builds fresh.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/ast/ast_widget_proxies.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

String _main({required bool explode}) => '''
import 'package:dartnative/dartnative.dart';

class Panel extends StatelessWidget {
  const Panel({super.key});

  @override
  Widget build(BuildContext context) {
    ${explode ? "throw StateError('panel blew up');" : "return const Text('panel ok');"}
  }
}

void main() {
  runApp(const Panel());
}
''';

void main() {
  group('AST proxy error boundary', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;
    late List<String> errors;
    late AstInterpreterRunner runner;

    setUp(() {
      logs = <String>[];
      errors = <String>[];
      tmp = Directory.systemTemp.createTempSync('dn_boundary_');
      projectDir = Directory('${tmp.path}/boundary_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: boundary_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      runner = AstInterpreterRunner(
        onLog: logs.add,
        onGuestError: (error, stack) => errors.add('$error'),
      );
    });

    tearDown(() {
      runner.dispose();
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    Future<({List<int> bytes, Map<String, String> fingerprints})> build(
      bool explode,
      String tag,
    ) async {
      File('${projectDir.path}/lib/main.dart')
          .writeAsStringSync(_main(explode: explode));
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

    test('a throwing build falls back to the last good child', () async {
      final v1 = await build(false, 'ok');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      final panel = rootV1 as InterpretedStatelessWidget;
      final first = panel.build(_FakeContext());
      expect((first as Text).data, 'panel ok');

      final v2 = await build(true, 'boom');
      await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );

      expect(
        panel.build(_FakeContext()),
        same(first),
        reason: 'the working UI stays up instead of failing the tree',
      );
      expect(
        errors.where((e) => e.contains('panel blew up')),
        isNotEmpty,
        reason: 'the failure is still reported to the host channel',
      );

      final v3 = await build(false, 'fixed');
      await runner.evaluateAstBundleAs<Widget>(
        v3.bytes,
        isHotReload: true,
        moduleFingerprints: v3.fingerprints,
      );
      expect(
        (panel.build(_FakeContext()) as Text).data,
        'panel ok',
        reason: 'fixed code builds fresh again',
      );
    });
  });
}

class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

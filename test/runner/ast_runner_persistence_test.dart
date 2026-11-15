/// Phase 1 contract: the AST engine keeps ONE core `tom_d4rt_ast` runner
/// across hot reloads (bridge surface + warm stdlib/bridge parent are built
/// once), and a hot restart / dispose builds a fresh one.
///
/// Also pins the state preservation the persistent runner must not regress:
/// class statics survive a hot reload. Since Phase 3 that is done by the
/// runtime's declaration registry (no host snapshot/restore pass any more), and
/// it is observed through the host-visible `onLog` channel rather than through
/// interpreted statics.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

const _v1 = r'''
import 'package:dartnative/dartnative.dart';

class Counter {
  static int taps = 0;
}

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: v1'),
            Button(
              child: Text('Tap'),
              onPressed: () {
                Counter.taps += 1;
                print('taps=${Counter.taps}');
              },
            ),
          ],
        ),
      ),
    ),
  );
}
''';

const _v2 = r'''
import 'package:dartnative/dartnative.dart';

class Counter {
  static int taps = 0;
}

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: v2'),
            Button(
              child: Text('Tap'),
              onPressed: () {
                Counter.taps += 1;
                print('taps=${Counter.taps}');
              },
            ),
          ],
        ),
      ),
    ),
  );
}
''';

Directory _makeGuest(Directory parent, String name, String source) {
  final dir = Directory('${parent.path}/$name')..createSync(recursive: true);
  File('${dir.path}/pubspec.yaml').writeAsStringSync('name: $name\n');
  Directory('${dir.path}/lib').createSync();
  File('${dir.path}/lib/main.dart').writeAsStringSync(source);
  return dir;
}

Column _columnOf(Widget root) {
  final scaffold = root as Scaffold;
  return (scaffold.body as Center).child as Column;
}

void main() {
  group('AST runner persistence (Phase 1)', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_ast_persist_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    setUp(() {
      logs = <String>[];
      projectDir = _makeGuest(tmp, 'persist_guest', _v1);
    });

    Future<List<int>> build(String source, String tag) async {
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(source);
      final out = File('${projectDir.path}/$tag.ast');
      final result = await buildGuestAstBundle(
        projectDir,
        outputArg: out.path,
        force: true,
      );
      expect(result.success, isTrue, reason: result.error);
      return out.readAsBytes();
    }

    test('hot reload reuses the core runner and keeps class statics', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_v1, 'v1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      expect((_columnOf(rootV1).children[0] as Text).data, 'Gen: v1');
      expect(runner.coreRunnerGeneration, 1);
      expect(runner.evaluationCount, 1);

      // Mutate interpreted state through the mounted widget.
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(logs, contains('taps=1'));

      final v2Bytes = await build(_v2, 'v2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );

      // Edited code took effect...
      expect((_columnOf(rootV2).children[0] as Text).data, 'Gen: v2');
      // ...while the SAME core runner served both generations.
      expect(runner.coreRunnerGeneration, 1);
      expect(runner.evaluationCount, 2);
      expect(runner.visitor, isNotNull);

      // Class statics survived the reload: the next tap continues from 1.
      (_columnOf(rootV2).children[1] as Button).onPressed!();
      expect(
        logs,
        contains('taps=2'),
        reason: 'static state must survive the reload (logs: $logs)',
      );
    });

    test(
      'dispose drops the core runner; the next evaluation builds a new one',
      () async {
        final runner = AstInterpreterRunner(onLog: logs.add);
        addTearDown(runner.dispose);

        final v1Bytes = await build(_v1, 'restart_v1');
        await runner.evaluateAstBundleAs<Widget>(v1Bytes);
        expect(runner.coreRunnerGeneration, 1);

        runner.dispose();
        expect(runner.coreRunnerGeneration, 1);
        expect(runner.evaluationCount, 1);

        final root = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
        expect((_columnOf(root).children[0] as Text).data, 'Gen: v1');
        expect(
          runner.coreRunnerGeneration,
          2,
          reason: 'a post-dispose evaluation must build a fresh core runner',
        );
        expect(runner.evaluationCount, 2);
      },
    );

    test('a failed hot reload keeps the runner and the state intact', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_v1, 'fail_v1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(logs, contains('taps=1'));

      // Garbage bytes: decode/execute throws inside the evaluation.
      await expectLater(
        runner.evaluateAstBundleAs<Widget>([1, 2, 3, 4, 5]),
        throwsA(anything),
      );
      expect(
        runner.coreRunnerGeneration,
        1,
        reason: 'a failed reload must not rebuild or drop the core runner',
      );
      expect(
        logs.where((l) => l.startsWith('taps=')).toList(),
        ['taps=1'],
        reason: 'a failed reload must not re-run or lose preserved state',
      );

      // The next good evaluation still works and the static state is intact.
      final v1BytesAgain = await build(_v1, 'recover');
      final recovered = await runner.evaluateAstBundleAs<Widget>(
        v1BytesAgain,
        isHotReload: true,
      );
      expect((_columnOf(recovered).children[0] as Text).data, 'Gen: v1');
      (_columnOf(recovered).children[1] as Button).onPressed!();
      expect(
        logs.last,
        'taps=2',
        reason: 'statics kept counting after recovery',
      );
    });
  });
}

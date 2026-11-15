/// Phase 3: top-level variable state survives a hot reload.
///
/// Dart VM rule implemented here: a top-level variable keeps its running value
/// when its initializer is unchanged, and re-runs the initializer when the
/// initializer itself changed. `late` stays lazy, `final` is enforced.
///
/// Assertions use the host-visible `onLog` channel.
///
/// Each test runs three full analyzer builds plus a reload evaluation. That is
/// well under the default 30 s budget on an idle host but exceeds it when the
/// suite runs in parallel with the rest of `test/`; the guest behavior under
/// test has no such limit.
@Timeout(Duration(seconds: 120))
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

String _guest(String tag, {required String counterInit, String extra = ''}) =>
    '''
import 'package:dartnative/dartnative.dart';

int counter = $counterInit;
late int lazyCounter;
final int finalSeed = 7;
List<int> history = <int>[];
$extra

void show(String label) {
  final n = history.length;
  print('\$label counter=\$counter lazy=\$lazyCounter final=\$finalSeed '
      'history=\$n');
}

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: $tag'),
            Button(
              child: Text('Mutate'),
              onPressed: () {
                counter += 100;
                history.add(counter);
                lazyCounter = 42;
                show('$tag');
              },
            ),
            Button(
              child: Text('Show'),
              onPressed: () => show('$tag'),
            ),
          ],
        ),
      ),
    ),
  );
}
''';

Column _columnOf(Widget root) {
  final scaffold = root as Scaffold;
  return (scaffold.body as Center).child as Column;
}

void main() {
  group('AST top-level state preservation (Phase 3)', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_var_cells_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    setUp(() {
      logs = <String>[];
      projectDir = Directory('${tmp.path}/var_guest')
        ..createSync(recursive: true);
      File(
        '${projectDir.path}/pubspec.yaml',
      ).writeAsStringSync('name: var_guest\n');
      Directory('${projectDir.path}/lib').createSync();
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

    void tap(Widget root, int index) {
      (_columnOf(root).children[index] as Button).onPressed!();
    }

    test(
      'unchanged initializers keep the live value across a reload',
      () async {
        final runner = AstInterpreterRunner(onLog: logs.add);
        addTearDown(runner.dispose);

        final v1Bytes = await build(_guest('v1', counterInit: '1'), 'v1');
        final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
        tap(rootV1, 1);
        expect(logs.last, 'v1 counter=101 lazy=42 final=7 history=1');

        // Only the UI text changes: every initializer is byte-identical.
        final v2Bytes = await build(_guest('v2', counterInit: '1'), 'v2');
        final rootV2 = await runner.evaluateAstBundleAs<Widget>(
          v2Bytes,
          isHotReload: true,
        );
        expect((_columnOf(rootV2).children[0] as Text).data, 'Gen: v2');

        // New generation sees the SAME state — the whole point of Phase 3.
        tap(rootV2, 2);
        expect(
          logs.last,
          'v2 counter=101 lazy=42 final=7 history=1',
          reason: 'top-level state must survive the reload (logs: $logs)',
        );
        // ...and the old generation's closure mutates that same state.
        tap(rootV1, 1);
        expect(logs.last, 'v1 counter=201 lazy=42 final=7 history=2');
        tap(rootV2, 2);
        expect(logs.last, 'v2 counter=201 lazy=42 final=7 history=2');
      },
    );

    test('a changed initializer re-runs (Dart VM rule)', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_guest('v1', counterInit: '1'), 'c1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      tap(rootV1, 1);
      expect(logs.last, 'v1 counter=101 lazy=42 final=7 history=1');

      final v2Bytes = await build(_guest('v2', counterInit: '5'), 'c2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      tap(rootV2, 2);
      expect(
        logs.last,
        'v2 counter=5 lazy=42 final=7 history=1',
        reason: 'changed initializer must re-run; untouched cells keep state',
      );
    });

    test('late top-levels stay lazy and final is enforced', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_guest('v1', counterInit: '1'), 'l1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);

      // `late int lazyCounter;` is uninitialized: reading it before assignment
      // must throw instead of silently yielding null.
      expect(
        () => tap(rootV1, 2),
        throwsA(anything),
        reason: 'uninitialized late read must throw',
      );

      // Assigning through the closure initializes the cell.
      tap(rootV1, 1);
      expect(logs.last, 'v1 counter=101 lazy=42 final=7 history=1');

      // A reload keeps the late value.
      final v2Bytes = await build(_guest('v2', counterInit: '1'), 'l2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      tap(rootV2, 2);
      expect(logs.last, 'v2 counter=101 lazy=42 final=7 history=1');
    });

    test('registry reports the variable cells it is tracking', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_guest('v1', counterInit: '1'), 'r1');
      await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      // counter, lazyCounter, finalSeed, history
      expect(runner.declarationRegistry.stats['var_cells'], 4);

      runner.dispose();
      expect(runner.declarationRegistry.stats['var_cells'], 0);
    });
  });
}

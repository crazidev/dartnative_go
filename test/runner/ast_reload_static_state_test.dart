/// Phase 3b: class static storage is cell-backed.
///
/// A `static` field's value survives a hot reload when its initializer is
/// unchanged (Dart VM rule), re-runs when the initializer changed, and a bare
/// write from inside a static method mutates the authoritative slot (the old
/// snapshot + `_propagateStaticFieldWrite` machinery is gone).
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

String _guest(String tag, {required String hitsInit, String extra = ''}) => '''
import 'package:dartnative/dartnative.dart';

class Registry {
  static int hits = $hitsInit;
  static List<String> log = <String>[];
  static late int lazyHits;
  $extra

  static void record() {
    hits += 1;
    log.add('hit');
    final n = log.length;
    print('$tag hits=\$hits entries=\$n lazy=\${lazyHits == null ? 0 : lazyHits}');
  }

  static int get total => hits * 10;
}

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: $tag'),
            Button(
              child: Text('Record'),
              onPressed: Registry.record,
            ),
            Button(
              child: Text('Show'),
              onPressed: () {
                final n = Registry.log.length;
                print('$tag hits=\${Registry.hits} entries=\$n total=\${Registry.total}');
              },
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
  group('AST class static state preservation (Phase 3b)', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_static_cells_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    setUp(() {
      logs = <String>[];
      projectDir = Directory('${tmp.path}/static_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: static_guest\n');
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

    test('static state survives a reload and keeps counting up', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_guest('v1', hitsInit: '1'), 's1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      tap(rootV1, 1);
      expect(logs.last, 'v1 hits=2 entries=1 lazy=0');

      final v2Bytes = await build(_guest('v2', hitsInit: '1'), 's2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      expect((_columnOf(rootV2).children[0] as Text).data, 'Gen: v2');

      // Same static storage: the new generation continues from hits == 2 and
      // the shared list already holds one entry.
      tap(rootV2, 2);
      expect(
        logs.last,
        'v2 hits=2 entries=1 total=20',
        reason: 'statics must survive the reload (logs: $logs)',
      );

      // Bare write from the static method mutates the authoritative slot.
      tap(rootV2, 1);
      expect(logs.last, 'v2 hits=3 entries=2 lazy=0');
      tap(rootV1, 2);
      expect(
        logs.last,
        'v1 hits=3 entries=2 total=30',
        reason: 'old generation must see writes made by the new one',
      );
    });

    test('a changed static initializer re-runs', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_guest('v1', hitsInit: '1'), 'c1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      tap(rootV1, 1);
      expect(logs.last, 'v1 hits=2 entries=1 lazy=0');

      final v2Bytes = await build(_guest('v2', hitsInit: '100'), 'c2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      tap(rootV2, 2);
      expect(
        logs.last,
        'v2 hits=100 entries=1 total=1000',
        reason: 'changed initializer re-runs; the shared list is untouched',
      );
    });

    test('a new static field is added without disturbing the old ones',
        () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_guest('v1', hitsInit: '1'), 'n1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      tap(rootV1, 1);
      expect(logs.last, 'v1 hits=2 entries=1 lazy=0');

      final v2Bytes = await build(
        _guest('v2', hitsInit: '1', extra: 'static int misses = 5;'),
        'n2',
      );
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      tap(rootV2, 2);
      expect(
        logs.last,
        'v2 hits=2 entries=1 total=20',
        reason: 'adding a static keeps the existing cells',
      );
      expect(runner.declarationRegistry.stats['var_cells'], greaterThanOrEqualTo(4));
    });
  });
}

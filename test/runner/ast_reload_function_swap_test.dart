/// Phase 2 contract: hot reload swaps function BODIES in place, so objects
/// created by a previous generation execute the new code while keeping their
/// own state.
///
/// The guest is built as a real on-disk project (analyzer-free `guest.ast`),
/// evaluated through [AstInterpreterRunner], then edited and hot-reloaded. The
/// observable proof is a button captured from the FIRST generation: its closure
/// is stale by design (closures are per-generation until Phase 3), but the
/// top-level function and the instance method it calls are stable shells, so a
/// tap after the reload must run the NEW method body against the OLD
/// instance's field values.
///
/// Assertions go through the host-visible `onLog` channel (never through
/// interpreted statics) per the test-lab rules.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

/// v1: `bump` adds `by`.
const _v1 = r'''
import 'package:dartnative/dartnative.dart';

class Counter {
  int value = 0;

  int bump(int by) {
    value += by;
    return value;
  }
}

void main() {
  final counter = Counter();
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: v1'),
            Button(
              child: Text('Bump'),
              onPressed: () {
                counter.bump(5);
                print('value=${counter.value}');
              },
            ),
          ],
        ),
      ),
    ),
  );
}
''';

/// v2: same declarations, `bump` multiplies — a pure body edit.
const _v2 = r'''
import 'package:dartnative/dartnative.dart';

class Counter {
  int value = 0;

  int bump(int by) {
    value += by * 10;
    return value;
  }
}

void main() {
  final counter = Counter();
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: v2'),
            Button(
              child: Text('Bump'),
              onPressed: () {
                counter.bump(5);
                print('value=${counter.value}');
              },
            ),
          ],
        ),
      ),
    ),
  );
}
''';

/// v3: `bump` gains a parameter — a signature change, which must retire the
/// cell instead of swapping a differently-shaped body into live references.
const _v3 = r'''
import 'package:dartnative/dartnative.dart';

class Counter {
  int value = 0;

  int bump(int by, int times) {
    value += by * times;
    return value;
  }
}

void main() {
  final counter = Counter();
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: v3'),
            Button(
              child: Text('Bump'),
              onPressed: () {
                counter.bump(5, 2);
                print('value=${counter.value}');
              },
            ),
          ],
        ),
      ),
    ),
  );
}
''';

Directory _makeGuest(Directory parent, String name) {
  final dir = Directory('${parent.path}/$name')..createSync(recursive: true);
  File('${dir.path}/pubspec.yaml').writeAsStringSync('name: $name\n');
  Directory('${dir.path}/lib').createSync();
  return dir;
}

Column _columnOf(Widget root) {
  final scaffold = root as Scaffold;
  return (scaffold.body as Center).child as Column;
}

void main() {
  group('AST function-body swap (Phase 2)', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_fn_swap_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    setUp(() {
      logs = <String>[];
      projectDir = _makeGuest(tmp, 'fn_swap_guest');
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

    test('a live instance runs the reloaded method body with its own state',
        () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_v1, 'v1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      expect((_columnOf(rootV1).children[0] as Text).data, 'Gen: v1');

      // Mutate the generation-1 instance: value 0 -> 5.
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(logs, contains('value=5'));
      expect(runner.declarationRegistry.stats['swaps'], 0);

      final v2Bytes = await build(_v2, 'v2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );

      // Edited code is live for new callers.
      expect((_columnOf(rootV2).children[0] as Text).data, 'Gen: v2');
      final stats = runner.declarationRegistry.stats;
      expect(stats['swaps'], greaterThan(0), reason: 'bodies must be swapped');
      expect(stats['generation'], 2);

      // The button captured from generation 1 still owns the generation-1
      // Counter (value == 5). Its closure body is generation-1 code (closures
      // become stable in Phase 3), but the method it calls is a stable shell,
      // so the reload's `bump` body runs against the OLD instance: 5 + 5 * 10.
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(
        logs.last,
        'value=55',
        reason: 'live instance + reloaded method body (logs: $logs)',
      );

      // The generation-2 widget uses its own instance and the same new body.
      (_columnOf(rootV2).children[1] as Button).onPressed!();
      expect(logs.last, 'value=50');
    });

    test('a signature change retires the cell instead of swapping', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_v1, 'sig1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(logs, contains('value=5'));

      final v3Bytes = await build(_v3, 'sig3');
      final rootV3 = await runner.evaluateAstBundleAs<Widget>(
        v3Bytes,
        isHotReload: true,
      );
      expect((_columnOf(rootV3).children[0] as Text).data, 'Gen: v3');
      expect(
        runner.declarationRegistry.stats['retirements'],
        greaterThan(0),
        reason: 'changed parameter lists must retire their cells',
      );

      // The old tear-off keeps the old 1-parameter shape: the generation-1
      // instance still answers `bump(5)` and the stale call site does not blow
      // up (I5 policy — in-flight callers keep a coherent signature).
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(logs.last, 'value=10');
    });

    test('an added member is visible to instances from earlier generations',
        () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      // The call site (the stale closure) stays identical across the reload;
      // only `report` gains the call to the method that v1 did not have. The
      // instance it receives was created by v1.
      String guest(String tag, {required String reportBody, String extra = ''}) =>
          '''
import 'package:dartnative/dartnative.dart';

class Counter {
  int value = 0;

  int bump(int by) {
    value += by;
    return value;
  }
$extra
}

void report(Counter counter) {
  $reportBody
}

void main() {
  final counter = Counter();
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: $tag'),
            Button(
              child: Text('Bump'),
              onPressed: () {
                counter.bump(5);
                report(counter);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
''';

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

      final v1Bytes = await build(
        guest('v1', reportBody: "print('value=\${counter.value}');"),
        'add1',
      );
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(logs.last, 'value=5');

      // v2 adds `doubled()` and teaches the (stable) `report` shell to call it.
      final v2Bytes = await build(
        guest(
          'v2',
          reportBody:
              "print('value=\${counter.value} doubled=\${counter.doubled()}');",
          extra: '\n  int doubled() => value * 2;',
        ),
        'add2',
      );
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      expect((_columnOf(rootV2).children[0] as Text).data, 'Gen: v2');
      expect(
        runner.declarationRegistry.stats['retirements'],
        0,
        reason: 'adding a member is additive: the class cell is kept',
      );

      // New instance: 0 -> 5.
      (_columnOf(rootV2).children[1] as Button).onPressed!();
      expect(logs.last, 'value=5 doubled=10');

      // The generation-1 instance (value 5) resolves `doubled`, a method that
      // did not exist when it was created, through the reloaded class version.
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(
        logs.last,
        'value=10 doubled=20',
        reason: 'old instance must see members added by the reload',
      );
    });

    test('a swapped function accepts an old-generation instance at a '
        'user-typed parameter (Phase 4)', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      String guest(String tag) => '''
import 'package:dartnative/dartnative.dart';

class Counter {
  int value = 0;
}

void report(Counter counter) {
  print('reported \${counter.value}');
}

void main() {
  final counter = Counter();
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: $tag'),
            Button(
              child: Text('Report'),
              onPressed: () => report(counter),
            ),
          ],
        ),
      ),
    ),
  );
}
''';

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

      final v1Bytes = await build(guest('v1'), 'gap1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(logs, contains('reported 0'));

      // Reload swaps `report`'s body, so the generation-1 closure now calls the
      // generation-2 function whose `Counter` parameter type is the NEW class
      // object. Phase 4's ClassCell makes the old instance dispatch through (and
      // type-check against) the current class version, so the call succeeds and
      // the preserved value is read.
      final v2Bytes = await build(guest('v2'), 'gap2');
      await runner.evaluateAstBundleAs<Widget>(v2Bytes, isHotReload: true);
      expect(
        runner.declarationRegistry.stats['swaps'],
        greaterThan(0),
        reason: 'report body must have been swapped',
      );

      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(
        logs.last,
        'reported 0',
        reason: 'old-generation instance satisfies the reloaded parameter type',
      );
      expect(runner.declarationRegistry.stats['class_cells'], 1);
    });

    test('dispose clears the registry so a restart rebuilds every shell',
        () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_v1, 'restart1');
      await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      expect(runner.declarationRegistry.cellCount, greaterThan(0));

      runner.dispose();
      expect(runner.declarationRegistry.cellCount, 0);
      expect(runner.declarationRegistry.stats['swaps'], 0);

      final root = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      expect((_columnOf(root).children[0] as Text).data, 'Gen: v1');
      expect(
        runner.declarationRegistry.stats['misses'],
        greaterThan(0),
        reason: 'post-restart declarations are all first sightings again',
      );
    });
  });
}

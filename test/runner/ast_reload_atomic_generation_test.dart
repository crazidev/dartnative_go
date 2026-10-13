/// Phase 5b: generation transactions.
///
/// A failed reload must leave the runtime exactly as the previous generation
/// left it — no half-applied code. The host keeps showing the previous widget,
/// and that widget's live objects must keep running the *old* code with the
/// *old* state, not a mixture of both.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

/// v1: everything healthy.
const _v1 = r'''
import 'package:dartnative/dartnative.dart';

class Counter {
  static int hits = 1;
  int value = 10;

  int bump(int by) {
    value += by;
    return value;
  }
}

void report(Counter counter) {
  print('report ${counter.value}');
}

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: v1'),
            Button(
              child: Text('Go'),
              onPressed: () {
                final c = Counter();
                c.bump(5);
                report(c);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
''';

/// v2: edited bodies, statics AND a top-level initializer that throws, so the
/// generation dies half-way through applying itself.
const _v2Broken = r'''
import 'package:dartnative/dartnative.dart';

class Counter {
  static int hits = 100;
  int value = 999;

  int bump(int by) {
    value += by * 7;
    return value;
  }
}

void report(Counter counter) {
  print('report ${counter.value}');
}

late int explode;

void main() {
  explode = 1 ~/ 0;
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: v2'),
            Button(
              child: Text('Go'),
              onPressed: () {
                final c = Counter();
                c.bump(5);
                report(c);
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
  group('AST generation transactions (Phase 5b)', () {
    late Directory tmp;
    late Directory projectDir;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_atomic_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    setUp(() {
      projectDir = Directory('${tmp.path}/atomic_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: atomic_guest\n');
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

    test('a failed generation is rolled back to the previous one', () async {
      final logs = <String>[];
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_v1, 'ok1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(logs.last, 'report 15', reason: 'v1 behaviour before the reload');

      final brokenBytes = await build(_v2Broken, 'broken2');
      await expectLater(
        runner.evaluateAstBundleAs<Widget>(brokenBytes, isHotReload: true),
        throwsA(anything),
        reason: 'the broken generation must fail',
      );

      // The previous widget is still mounted and must behave EXACTLY like v1:
      // old method body (value += by, not * 7) and old statics/top-levels.
      logs.clear();
      (_columnOf(rootV1).children[1] as Button).onPressed!();
      expect(
        logs.last,
        'report 15',
        reason: 'a failed generation must not leak reloaded code '
            '(logs: $logs)',
      );

      // The registry is still usable: a good reload afterwards commits.
      final v1Again = await build(_v1, 'ok3');
      final rootV3 = await runner.evaluateAstBundleAs<Widget>(
        v1Again,
        isHotReload: true,
      );
      expect((_columnOf(rootV3).children[0] as Text).data, 'Gen: v1');
      logs.clear();
      (_columnOf(rootV3).children[1] as Button).onPressed!();
      expect(logs.last, 'report 15');
      expect(runner.declarationRegistry.stats['generation'], 3);
    });
  });
}

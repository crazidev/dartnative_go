/// Phase 3c: enum statics are cell-backed and enum values keep their identity.
///
/// A value captured before a reload is the *same object* the reloaded enum
/// publishes, so `==`, `hashCode` and `is` keep working across the reload —
/// without this, a preserved value compared unequal to the new generation's.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

String _guest(String tag, {required String baseInit, String constants = ''}) => '''
import 'package:dartnative/dartnative.dart';

enum Status {
  active,
  inactive$constants;

  static int base = $baseInit;
  static int seen = 0;

  static void bump() {
    base += 1;
    seen += 1;
  }
}

late Status captured;

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: $tag'),
            Button(
              child: Text('Bump'),
              onPressed: Status.bump,
            ),
            Button(
              child: Text('Compare'),
              onPressed: () {
                final same = captured == Status.active;
                final n = Status.seen;
                print('$tag same=\$same seen=\$n base=\${Status.base}');
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
  group('AST enum state preservation (Phase 3c)', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_enum_cells_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    setUp(() {
      logs = <String>[];
      projectDir = Directory('${tmp.path}/enum_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: enum_guest\n');
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

    test('enum statics survive and values keep identity', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      // v1 captures the enum value in a top-level `late` so the comparison
      // happens against a value created by the PREVIOUS generation.
      final v1Source = _guest('v1', baseInit: '5').replaceAll(
        '  runApp(',
        '  captured = Status.active;\n  runApp(',
      );
      final v1Bytes = await build(v1Source, 'e1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      tap(rootV1, 1);
      tap(rootV1, 2);
      expect(logs.last, 'v1 same=true seen=1 base=6');

      final v2Bytes = await build(_guest('v2', baseInit: '5'), 'e2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      expect((_columnOf(rootV2).children[0] as Text).data, 'Gen: v2');

      // Enum statics continue from the preserved values...
      tap(rootV2, 1);
      tap(rootV2, 2);
      expect(logs.last, 'v2 same=true seen=2 base=7');
      // ...and the generation-1 comparison still sees its captured value as
      // equal to the reloaded enum's value (stable identity, not a re-create).
      tap(rootV1, 2);
      expect(
        logs.last,
        'v1 same=true seen=2 base=7',
        reason: 'preserved enum value must keep identity across the reload',
      );
    });

    test('adding an enum constant keeps the preserved values (additive)',
        () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Source = _guest('v1', baseInit: '5').replaceAll(
        '  runApp(',
        '  captured = Status.active;\n  runApp(',
      );
      final v1Bytes = await build(v1Source, 'x1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      tap(rootV1, 2);
      expect(logs.last, 'v1 same=true seen=0 base=5');

      final v2Bytes = await build(
        _guest('v2', baseInit: '5', constants: ',\n  pending'),
        'x2',
      );
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      // New generation works with the new constant list...
      tap(rootV2, 2);
      expect(logs.last, 'v2 same=true seen=0 base=5');
      // ...and the generation-1 value is still the same object, so the enum
      // statics were not rebuilt and nothing was retired.
      tap(rootV1, 2);
      expect(logs.last, 'v1 same=true seen=0 base=5');
      expect(
        runner.declarationRegistry.stats['retirements'],
        0,
        reason: 'appending a constant must not retire the enum value cells',
      );
    });

    test('removing an enum constant retires the preserved values', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Source = _guest(
        'v1',
        baseInit: '5',
        constants: ',\n  pending',
      ).replaceAll('  runApp(', '  captured = Status.active;\n  runApp(');
      final v1Bytes = await build(v1Source, 'y1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      tap(rootV1, 2);
      expect(logs.last, 'v1 same=true seen=0 base=5');

      // Drop `pending`: a breaking edit, so the enum value cells are retired.
      final v2Bytes = await build(_guest('v2', baseInit: '5'), 'y2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      tap(rootV2, 2);
      expect(logs.last, 'v2 same=true seen=0 base=5');
      expect(
        runner.declarationRegistry.stats['retirements'],
        greaterThan(0),
        reason: 'a removed constant must retire the enum value cells',
      );
    });
  });
}

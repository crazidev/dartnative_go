/// A class moves from the importing module to the imported module across a
/// reload — the `StickyNote` shuffle: v1 defines it locally in `todo.dart`,
/// v2 comments that out and uncomments the definition in `sticky.dart`, which
/// `todo.dart` imports (with a cycle back, as in the example app).
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/ast/ast_widget_proxies.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

const _main = '''
import 'package:dartnative/dartnative.dart';
import 'todo.dart';

void main() {
  runApp(buildGrid());
}
''';

String _todo({required bool localNote}) => '''
import 'package:dartnative/dartnative.dart';
import 'sticky.dart';

${localNote ? '''
class Note extends StatelessWidget {
  final String label;

  const Note({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text('local:\$label');
  }
}
''' : ''}

Widget buildGrid() => const Note(label: 'n');
''';

String _sticky({required bool defineNote}) => '''
import 'package:dartnative/dartnative.dart';
import 'todo.dart';

${defineNote ? '''
class Note extends StatelessWidget {
  final String label;

  const Note({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text('moved:\$label');
  }
}
''' : '''
class Unused {
  const Unused();
}
'''}
''';

List<String> _labels(Widget w) {
  if (w is Text) return [w.data];
  throw StateError('unexpected widget ${w.runtimeType}');
}

void main() {
  group('AST class moves between modules', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;
    late AstInterpreterRunner runner;

    setUp(() {
      logs = <String>[];
      tmp = Directory.systemTemp.createTempSync('dn_move_');
      projectDir = Directory('${tmp.path}/move_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: move_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(_main);
      runner = AstInterpreterRunner(onLog: logs.add);
    });

    tearDown(() {
      runner.dispose();
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    Future<({List<int> bytes, Map<String, String> fingerprints})> build({
      required bool localNote,
      required bool defineNote,
      required String name,
    }) async {
      File('${projectDir.path}/lib/todo.dart')
          .writeAsStringSync(_todo(localNote: localNote));
      File('${projectDir.path}/lib/sticky.dart')
          .writeAsStringSync(_sticky(defineNote: defineNote));
      final out = File('${projectDir.path}/$name.ast');
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

    Widget buildRoot(Widget root) {
      if (root is InterpretedStatelessWidget) {
        return root.build(_FakeContext());
      }
      throw StateError('unexpected root ${root.runtimeType}');
    }

    test('a broken intermediate generation heals on the next reload',
        () async {
      final v1 = await build(localNote: true, defineNote: false, name: 'h1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      expect(_labels(buildRoot(rootV1)), ['local:n']);

      final v2 = await build(localNote: false, defineNote: false, name: 'h2');
      await expectLater(
        runner.evaluateAstBundleAs<Widget>(
          v2.bytes,
          isHotReload: true,
          moduleFingerprints: v2.fingerprints,
        ),
        throwsA(anything),
        reason: 'precondition: with no Note anywhere the reload must fail',
      );

      final v3 = await build(localNote: false, defineNote: true, name: 'h3');
      final rootV3 = await runner.evaluateAstBundleAs<Widget>(
        v3.bytes,
        isHotReload: true,
        moduleFingerprints: v3.fingerprints,
      );
      final loaderV3 = (runner.visitor as dynamic).moduleContext;
      final cacheV3 = (loaderV3 as dynamic).moduleCache as Map;
      final todoEnv = (cacheV3[Uri.parse('lib/todo.dart')] as dynamic).environment;
      expect(
        ((todoEnv as dynamic).values as Map).containsKey('Note'),
        isTrue,
        reason: 'the reused importer must merge the added export',
      );
      expect(
        _labels(buildRoot(rootV3)),
        ['moved:n'],
        reason: 'todo.dart is reused here, so the added import must still '
            'become visible in its environment',
      );
    });

    test('a class moved to the imported module resolves after reload',
        () async {
      final v1 = await build(localNote: true, defineNote: false, name: 'v1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      expect(_labels(buildRoot(rootV1)), ['local:n']);

      final v2 = await build(localNote: false, defineNote: true, name: 'v2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      expect(
        _labels(buildRoot(rootV2)),
        ['moved:n'],
        reason: 'Note now comes from sticky.dart through the import',
      );
    });
  });
}

class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

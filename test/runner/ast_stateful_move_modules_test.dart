/// Faithful `StickyNote` shuffle: a stateful widget moves from the importing
/// module to the imported module, and the moved widget references a type from
/// the importer (real cyclic type dependency, as with `Todo`/`NoteColors`).
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
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

String _todo({required bool localNote}) =>
    '''
import 'package:dartnative/dartnative.dart';
import 'sticky.dart';

class Shared {
  final String tag;
  const Shared(this.tag);
}

const shared = Shared('s');

${localNote ? '''
class Note extends StatefulWidget {
  final String label;

  const Note({required this.label});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Text('local:\${widget.label}');
  }
}
''' : ''}

Widget buildGrid() => const Note(label: 'n');
''';

String _sticky({required bool defineNote}) =>
    '''
import 'package:dartnative/dartnative.dart';
import 'todo.dart';

${defineNote ? '''
class Note extends StatefulWidget {
  final Shared shared;
  final String label;

  const Note({required this.label, this.shared = shared});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Text('moved:\${widget.label}:shared');
  }
}
''' : '''
class Unused {
  const Unused();
}
'''}
''';

String _renderedLabel(Widget root) {
  Widget w = root;
  if (w is InterpretedStatefulWidget) {
    final proxy = w.createState() as InterpretedStateProxy;
    w = proxy.build(_FakeContext());
  }
  if (w is Text) return w.data;
  throw StateError('unexpected widget ${w.runtimeType}');
}

void main() {
  group('AST stateful class moves between modules', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;
    late AstInterpreterRunner runner;

    setUp(() {
      logs = <String>[];
      tmp = Directory.systemTemp.createTempSync('dn_move_stateful_');
      projectDir = Directory('${tmp.path}/move_stateful_guest')
        ..createSync(recursive: true);
      File(
        '${projectDir.path}/pubspec.yaml',
      ).writeAsStringSync('name: move_stateful_guest\n');
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
      File(
        '${projectDir.path}/lib/todo.dart',
      ).writeAsStringSync(_todo(localNote: localNote));
      File(
        '${projectDir.path}/lib/sticky.dart',
      ).writeAsStringSync(_sticky(defineNote: defineNote));
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

    test('a module\'s own declaration shadows an imported one', () async {
      // `sticky.dart` imports `todo.dart` and declares its own `Note`. That is
      // legal Dart: a library's own class shadows an imported one of the same
      // name, and tom_d4rt 1.244.0 made the engine honour it (before that the
      // import won, and the second module's pass-2 re-registered members on the
      // already-frozen imported class, which surfaced as a conflict). The
      // regression this guards is *silent merging*: each module must resolve
      // `Note` to its OWN declaration, which the rendered label shows.
      final v1 = await build(localNote: true, defineNote: false, name: 'd1');
      await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );

      final v2 = await build(localNote: true, defineNote: true, name: 'd2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      expect(
        _renderedLabel(rootV2),
        'local:n',
        reason: 'todo.dart keeps its own Note even though sticky.dart '
            'declares one of the same name',
      );
    });

    test('stateful move through a broken intermediate heals', () async {
      final v1 = await build(localNote: true, defineNote: false, name: 's1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      expect(_renderedLabel(rootV1), 'local:n');

      final v2 = await build(localNote: false, defineNote: false, name: 's2');
      await expectLater(
        runner.evaluateAstBundleAs<Widget>(
          v2.bytes,
          isHotReload: true,
          moduleFingerprints: v2.fingerprints,
        ),
        throwsA(anything),
        reason: 'precondition: with no Note anywhere the reload must fail',
      );

      final v3 = await build(localNote: false, defineNote: true, name: 's3');
      final rootV3 = await runner.evaluateAstBundleAs<Widget>(
        v3.bytes,
        isHotReload: true,
        moduleFingerprints: v3.fingerprints,
      );
      expect(
        _renderedLabel(rootV3),
        'moved:n:shared',
        reason: 'Note now comes from sticky.dart through the import',
      );
    });
  });
}

class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

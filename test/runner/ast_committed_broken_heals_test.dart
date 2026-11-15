/// The broken-intermediate generation COMMITS (the bad reference sits inside a
/// build body, so declarations succeed), poisoning the reuse cache: the next
/// reload reuses the importer whose environment lacks the newly added export.
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

class Grid extends StatelessWidget {
  final String label;

  const Grid({required this.label});

  @override
  Widget build(BuildContext context) {
    return Note(label: label);
  }
}

Widget buildGrid() => const Grid(label: 'g');
''';

String _sticky({required bool defineNote}) =>
    '''
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

String _renderGrid(Widget root) {
  final proxy = root as InterpretedStatelessWidget;
  final grid = proxy.build(_FakeContext()) as InterpretedStatelessWidget;
  final text = grid.build(_FakeContext()) as Text;
  return text.data;
}

void main() {
  group('AST committed broken generation heals', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;
    late AstInterpreterRunner runner;

    setUp(() {
      logs = <String>[];
      tmp = Directory.systemTemp.createTempSync('dn_commit_broken_');
      projectDir = Directory('${tmp.path}/commit_broken_guest')
        ..createSync(recursive: true);
      File(
        '${projectDir.path}/pubspec.yaml',
      ).writeAsStringSync('name: commit_broken_guest\n');
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

    test(
      'a committed broken generation heals when the export appears',
      () async {
        final v1 = await build(localNote: true, defineNote: false, name: 'c1');
        final rootV1 = await runner.evaluateAstBundleAs<Widget>(
          v1.bytes,
          moduleFingerprints: v1.fingerprints,
        );
        expect(_renderGrid(rootV1), 'local:g');

        final v2 = await build(localNote: false, defineNote: false, name: 'c2');
        final rootV2 = await runner.evaluateAstBundleAs<Widget>(
          v2.bytes,
          isHotReload: true,
          moduleFingerprints: v2.fingerprints,
        );
        expect(
          () => _renderGrid(rootV2),
          throwsA(anything),
          reason:
              'precondition: the broken generation commits (declarations '
              'succeed) and only fails when the grid builds',
        );

        final v3 = await build(localNote: false, defineNote: true, name: 'c3');
        final rootV3 = await runner.evaluateAstBundleAs<Widget>(
          v3.bytes,
          isHotReload: true,
          moduleFingerprints: v3.fingerprints,
        );
        expect(
          _renderGrid(rootV3),
          'moved:g',
          reason:
              'todo.dart is reused here, so the added export must still '
              'become visible in its environment',
        );
      },
    );
  });
}

class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Two user modules that import each other — the `todo_screen.dart` ⇄
/// `sticky_note.dart` layout. An edit to either side must take effect on reload.
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
import 'a.dart';

void main() {
  runApp(buildGrid());
}
''';

String _a(String tag) => '''
import 'package:dartnative/dartnative.dart';
import 'b.dart';

class Shared {
  static String tag = '$tag';
}

Widget buildGrid() => Note(label: Shared.tag);
''';

String _b(String suffix) => '''
import 'package:dartnative/dartnative.dart';
import 'a.dart';

class Note extends StatelessWidget {
  final String label;

  const Note({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text('\$label:\${Shared.tag}$suffix');
  }
}
''';

List<String> _labels(Widget w) {
  if (w is Text) return [w.data];
  throw StateError('unexpected widget ${w.runtimeType}');
}

void main() {
  group('AST circular user imports', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;
    late AstInterpreterRunner runner;

    setUp(() {
      logs = <String>[];
      tmp = Directory.systemTemp.createTempSync('dn_cycle_');
      projectDir = Directory('${tmp.path}/cycle_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: cycle_guest\n');
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

    Future<({List<int> bytes, Map<String, String> fingerprints})> build(
      String aTag,
      String bSuffix,
      String name,
    ) async {
      File('${projectDir.path}/lib/a.dart').writeAsStringSync(_a(aTag));
      File('${projectDir.path}/lib/b.dart').writeAsStringSync(_b(bSuffix));
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

    test('edits on either side of the cycle take effect', () async {
      final v1 = await build('a', '', 'v1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      expect(_labels(buildRoot(rootV1)), ['a:a']);

      final v2 = await build('a', '!', 'v2');
      await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      final visitorV2 = runner.visitor!;
      final gridFn = visitorV2.globalEnvironment.get('buildGrid');
      expect(gridFn, isNotNull);
      final rebuilt = (gridFn as dynamic).call(visitorV2, [], <String, Object?>{});
      final loaderV2 = (visitorV2 as dynamic).moduleContext;
      final cacheV2 = (loaderV2 as dynamic).moduleCache as Map;
      expect(
        cacheV2.keys.map((u) => u.toString()),
        contains('lib/b.dart'),
        reason: 'a reused importer must still load its dependencies',
      );
      expect(
        _labels(
          buildRoot(wrapAstInterpretedWidget(rebuilt, visitor: visitorV2)!),
        ),
        ['a:a!'],
        reason: 'an edit to b.dart must render after reload',
      );

      final v3 = await build('b', '!', 'v3');
      await runner.evaluateAstBundleAs<Widget>(
        v3.bytes,
        isHotReload: true,
        moduleFingerprints: v3.fingerprints,
      );
      final visitorV3 = runner.visitor!;
      final gridFnV3 = visitorV3.globalEnvironment.get('buildGrid');
      expect(gridFnV3, isNotNull);
      final rebuiltV3 = (gridFnV3 as dynamic).call(visitorV3, [], <String, Object?>{});
      expect(
        _labels(
          buildRoot(
            wrapAstInterpretedWidget(rebuiltV3, visitor: visitorV3)!,
          ),
        ),
        ['b:b!'],
        reason: 'an edit to a.dart must render after reload',
      );
    });
  });
}

class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

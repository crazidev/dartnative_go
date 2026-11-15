/// The generational remount map in AST mode.
///
/// In source mode the tracker scrapes `class X` out of the bundle's source
/// text. An AST bundle carries no sources, so the map comes from the decoded
/// compilation units; without it a widget declared outside the entry module
/// never gets a new generation and its subtree is never rebuilt on edit.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/widget_generation_tracker.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

String _main() => '''
import 'package:dartnative/dartnative.dart';
import 'sticky_note.dart';

void main() {
  runApp(const StickyNote());
}
''';

String _note() => '''
import 'package:dartnative/dartnative.dart';

class StickyNote extends StatelessWidget {
  const StickyNote({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('note');
  }
}
''';

void main() {
  group('AST widget generation tracking', () {
    late Directory tmp;
    late Directory projectDir;
    late AstInterpreterRunner runner;

    setUp(() {
      WidgetGenerationTracker.resetAll();
      tmp = Directory.systemTemp.createTempSync('dn_gen_tracker_');
      projectDir = Directory('${tmp.path}/gen_tracker_guest')
        ..createSync(recursive: true);
      File(
        '${projectDir.path}/pubspec.yaml',
      ).writeAsStringSync('name: gen_tracker_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(_main());
      File(
        '${projectDir.path}/lib/sticky_note.dart',
      ).writeAsStringSync(_note());
      runner = AstInterpreterRunner(onLog: (_) {});
    });

    tearDown(() {
      runner.dispose();
      WidgetGenerationTracker.resetAll();
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'a widget declared outside the entry module bumps its generation',
      () async {
        final out = File('${projectDir.path}/app.ast');
        final result = await buildGuestAstBundle(
          projectDir,
          outputArg: out.path,
          force: true,
        );
        expect(result.success, isTrue, reason: result.error);

        await runner.evaluateAstBundleAs<Widget>(
          await out.readAsBytes(),
          moduleFingerprints: result.moduleFingerprints,
        );

        final classFiles = runner.classFileMap;
        expect(
          classFiles['StickyNote'],
          contains('sticky_note.dart'),
          reason: 'precondition: the class map comes from the decoded bundle',
        );

        WidgetGenerationTracker.registerClassFiles(classFiles);
        final before = WidgetGenerationTracker.getGeneration('StickyNote');
        final bumped = WidgetGenerationTracker.notifyFilesChanged({
          'lib/sticky_note.dart',
        });
        expect(bumped, contains('StickyNote'));
        expect(WidgetGenerationTracker.getGeneration('StickyNote'), before + 1);
      },
    );
  });
}

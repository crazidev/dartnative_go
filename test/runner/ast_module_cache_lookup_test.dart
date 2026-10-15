/// Regression: pushed-route rebind lookup must work under device conditions.
///
/// On device, bundles carry no sources and a screen reached through a
/// transitive import (never merged into the entry environment, e.g.
/// `BottomSheetExampleApp` behind `plugins_screen.dart`) was invisible to
/// `findUserClassInVisitor` — every reload logged
/// `[HotReload] could not find X in the updated interpreter` and the mounted
/// screen went stale until pop + re-push. The loader's live module cache is
/// the authoritative, generation-correct source.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_bundle_codec.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/runner/native_bottomsheet_manager.dart';
import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

void main() {
  test(
    'transitive classes resolve after reload without bundle sources',
    () async {
      final tmp = Directory.systemTemp.createTempSync('lookup_guest_');
      try {
        Directory('${tmp.path}/lib').createSync();
        File('${tmp.path}/pubspec.yaml')
            .writeAsStringSync('name: lookup_guest\n');
        // helper2 is imported (not re-exported) by helper: its class never
        // merges into the entry environment — like a pushed-route screen.
        File('${tmp.path}/lib/helper2.dart').writeAsStringSync(
          'class DeepWidget {\n'
          "  String get name => 'deep';\n"
          '}\n',
        );
        File('${tmp.path}/lib/helper.dart').writeAsStringSync(
          "import 'helper2.dart';\n"
          'class Helper {\n'
          '  String get label => DeepWidget().name;\n'
          '}\n',
        );
        File('${tmp.path}/lib/main.dart').writeAsStringSync(
          "import 'package:dartnative/dartnative.dart';\n"
          "import 'helper.dart';\n"
          'void main() {\n'
          "  runApp(Text(Helper().label));\n"
          '}\n',
        );
        final out = File('${tmp.path}/lookup.ast');
        final result = await buildGuestAstBundle(
          tmp,
          outputArg: out.path,
          force: true,
        );
        expect(result.success, isTrue, reason: result.error);

        // Strip sources: device cold-fetches via the sources-less fast path
        // and rebuilt bundles only carry the entry source.
        final full = decodeAstBundleBytes(await out.readAsBytes());
        final stripped = ast.AstBundle(
          entryPointUri: full.entryPointUri,
          modules: full.modules,
        );
        final bytes = stripped.toBytes();

        final runner = AstInterpreterRunner(onLog: (_) {});
        addTearDown(runner.dispose);
        await runner.evaluateAstBundleAs<Widget>(bytes);
        await runner.evaluateAstBundleAs<Widget>(
          bytes,
          isHotReload: true,
        );

        final visitor = runner.visitor;
        expect(visitor, isNotNull);
        expect(
          findUserClassInVisitor(visitor, 'Helper'),
          isNotNull,
          reason: 'directly imported class stays visible',
        );
        expect(
          findUserClassInVisitor(visitor, 'DeepWidget'),
          isNotNull,
          reason: 'transitively imported class must resolve from the '
              'loaded module cache (pushed-route rebind)',
        );
      } finally {
        try {
          tmp.deleteSync(recursive: true);
        } catch (_) {}
      }
    },
    timeout: const Timeout(Duration(seconds: 120)),
  );
}

/// End-to-end hot reload of the real `example/` guest project.
///
/// This is the regression guard for the reload path that a unit test cannot
/// see: the example app imports its plugin registrant with a RELATIVE import
/// (`import 'dartnative_plugin_registrant.dart';`) from `lib/main.dart` while a
/// sibling module is bundled under a `package:` URI
/// (`package:example/todo_screen.dart`). Reloads that reuse an unchanged module
/// must still restore the module context, or the entry's relative import
/// resolves against the reused module's URI and the reload fails with
/// `Package module "package:example/dartnative_plugin_registrant.dart" not found
/// in bundle`.
///
/// Skipped when `example/` is absent (the suite is optional in trimmed checkouts).
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

void main() {
  test('example app survives a no-op and an edited hot reload', () async {
    final projectDir = Directory('example');
    if (!projectDir.existsSync()) return;

    final runner = AstInterpreterRunner(onLog: (_) {});
    addTearDown(runner.dispose);

    final out = File('${Directory.systemTemp.path}/example_reload.ast');
    Future<({List<int> bytes, Map<String, String> fingerprints})> build() async {
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

    final v1 = await build();
    final root = await runner.evaluateAstBundleAs<Widget>(
      v1.bytes,
      moduleFingerprints: v1.fingerprints,
    );
    expect(root, isNotNull, reason: 'example app must mount');

    // No-op reload: identical bytes, every module reused from the cache.
    final noop = await runner.evaluateAstBundleAs<Widget>(
      v1.bytes,
      isHotReload: true,
      moduleFingerprints: v1.fingerprints,
    );
    expect(noop, isNotNull);
    expect(
      runner.declarationRegistry.moduleCacheCount,
      greaterThan(0),
      reason: 'unchanged modules should have been cached and reused',
    );

    // Edited reload: a comment-only change to the entry module. The relative
    // registrant import must still resolve after the reuse path ran.
    final mainFile = File('${projectDir.path}/lib/main.dart');
    final original = mainFile.readAsStringSync();
    try {
      mainFile.writeAsStringSync(
        original.replaceFirst(
          "import 'dartnative_plugin_registrant.dart';",
          "import 'dartnative_plugin_registrant.dart';\n// reload regression edit",
        ),
      );
      final v2 = await build();
      final reloaded = await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      expect(reloaded, isNotNull);
      expect(runner.evaluationCount, 3);
    } finally {
      mainFile.writeAsStringSync(original);
    }
  });
}

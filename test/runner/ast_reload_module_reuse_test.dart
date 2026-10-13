/// Phase 5: module-level reuse, decode caching, and the async-activation
/// policy.
///
/// * A module whose content fingerprint is unchanged is NOT re-declared — its
///   environment, classes and functions are reused, while the entry module's
///   declarations still go through the registry.
/// * A reload does not strand an `await` that was suspended by an earlier
///   generation (the AST parent map is kept alive while activations are live).
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

const _helperV1 = r'''
int helperAdd(int a, int b) => a + b;
''';

const _helperV2 = r'''
int helperAdd(int a, int b) => a + b * 10;
''';

String _main(String tag, {required String body, bool async = false}) => '''
import 'package:dartnative/dartnative.dart';
import 'helper.dart';

int topLevel = 3;

$body

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: $tag'),
            Button(
              child: Text('Go'),
              onPressed: ()${async ? ' async' : ''} {
${async ? '                await Future<void>.delayed('
      'const Duration(milliseconds: 5));' : ''}
                final sum = helperAdd(topLevel, 4);
                print('$tag sum=\$sum');
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
  group('AST module reuse + async activations (Phase 5)', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_phase5_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    setUp(() {
      logs = <String>[];
      projectDir = Directory('${tmp.path}/p5_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: p5_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      File('${projectDir.path}/lib/helper.dart').writeAsStringSync(_helperV1);
    });

    Future<({List<int> bytes, Map<String, String> fingerprints})> build(
      String mainSource,
      String helperSource,
      String tag,
    ) async {
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(mainSource);
      File('${projectDir.path}/lib/helper.dart').writeAsStringSync(helperSource);
      final out = File('${projectDir.path}/$tag.ast');
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

    void tap(Widget root, int index) {
      (_columnOf(root).children[index] as Button).onPressed!();
    }

    test('an unchanged module is reused, a changed one is re-declared',
        () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      // v1 → v2 edits ONLY main.dart, so helper.dart keeps its fingerprint.
      final v1 = await build(
        _main('v1', body: "void noop() {}"),
        _helperV1,
        'm1',
      );
      expect(v1.fingerprints.keys.any((k) => k.contains('helper.dart')), isTrue);

      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      tap(rootV1, 1);
      expect(logs.last, 'v1 sum=7');
      final modulesAfterV1 = runner.declarationRegistry.moduleCacheCount;
      expect(modulesAfterV1, greaterThan(0), reason: 'modules are cached');

      final v2 = await build(
        _main('v2', body: "void noop() {}"),
        _helperV1,
        'm2',
      );
      expect(
        v2.fingerprints.entries
            .firstWhere((e) => e.key.contains('helper.dart'))
            .value,
        equals(
          v1.fingerprints.entries
              .firstWhere((e) => e.key.contains('helper.dart'))
              .value,
        ),
        reason: 'unchanged module must have an unchanged fingerprint',
      );

      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      expect((_columnOf(rootV2).children[0] as Text).data, 'Gen: v2');
      // The reused helper module still works, and the entry module re-declared.
      tap(rootV2, 1);
      expect(logs.last, 'v2 sum=7');

      // Editing helper.dart changes its fingerprint → it is re-declared and the
      // new body takes effect for every generation.
      final v3 = await build(
        _main('v3', body: "void noop() {}"),
        _helperV2,
        'm3',
      );
      expect(
        v3.fingerprints.entries
            .firstWhere((e) => e.key.contains('helper.dart'))
            .value,
        isNot(
          equals(
            v2.fingerprints.entries
                .firstWhere((e) => e.key.contains('helper.dart'))
                .value,
          ),
        ),
      );
      final rootV3 = await runner.evaluateAstBundleAs<Widget>(
        v3.bytes,
        isHotReload: true,
        moduleFingerprints: v3.fingerprints,
      );
      tap(rootV3, 1);
      expect(
        logs.last,
        'v3 sum=43',
        reason: 'edited helper must be re-declared (3 + 4 * 10)',
      );
    });

    test('a reverted module is re-declared, not resurrected from cache',
        () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      // A -> B -> A on `helper.dart`, the module that is eligible for reuse.
      // After the revert its fingerprint matches a HISTORICAL value, so a cache
      // keyed on "any fingerprint ever seen" hands back the generation-1 module
      // while the function cells still hold generation 2's code — the UI would
      // keep computing B's result.
      final v1 = await build(
        _main('v1', body: "void noop() {}"),
        _helperV1,
        'r1',
      );
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      tap(rootV1, 1);
      expect(logs.last, 'v1 sum=7');

      final v2 = await build(
        _main('v2', body: "void noop() {}"),
        _helperV2,
        'r2',
      );
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      tap(rootV2, 1);
      expect(logs.last, 'v2 sum=43', reason: 'edited helper must take effect');

      final v3 = await build(
        _main('v3', body: "void noop() {}"),
        _helperV1,
        'r3',
      );
      expect(
        v3.fingerprints.entries
            .firstWhere((e) => e.key.contains('helper.dart'))
            .value,
        equals(
          v1.fingerprints.entries
              .firstWhere((e) => e.key.contains('helper.dart'))
              .value,
        ),
        reason: 'precondition: the reverted module has a historical fingerprint',
      );

      final rootV3 = await runner.evaluateAstBundleAs<Widget>(
        v3.bytes,
        isHotReload: true,
        moduleFingerprints: v3.fingerprints,
      );
      tap(rootV3, 1);
      expect(
        logs.last,
        'v3 sum=7',
        reason: 'a reverted module must run its reverted code, not the last edit',
      );
    });

    test('identical bytes hit the decode cache', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1 = await build(
        _main('v1', body: "void noop() {}"),
        _helperV1,
        'c1',
      );
      await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      // Same bytes again (e.g. a no-op reload) reuse the decoded bundle.
      final root = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        isHotReload: true,
        moduleFingerprints: v1.fingerprints,
      );
      expect((_columnOf(root).children[0] as Text).data, 'Gen: v1');
      expect(runner.evaluationCount, 2);
    });

    test('an activation suspended across a reload still completes', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1 = await build(
        _main('v1', body: "void noop() {}", async: true),
        _helperV1,
        'a1',
      );
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );

      // Kick off the async callback, then reload while it is suspended.
      tap(rootV1, 1);
      await Future<void>.delayed(const Duration(milliseconds: 1));

      final v2 = await build(
        _main('v2', body: "void noop() {}", async: true),
        _helperV1,
        'a2',
      );
      await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );

      // Let the suspended activation resume; it must still print its result.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(
        logs.where((l) => l.startsWith('v1 sum=')).toList(),
        ['v1 sum=7'],
        reason: 'a generation-1 activation must survive a reload (logs: $logs)',
      );
    });
  });
}

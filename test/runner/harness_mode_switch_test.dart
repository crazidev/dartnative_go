/// Source ⇄ AST mode switching for the whole dartnative_go runner.
///
/// No mobile app: pure-Dart guest logic runs through BOTH engines on the
/// host VM with `package:test` — `tom_d4rt` (source/analyzer, the default)
/// and `tom_d4rt_ast` (pre-compiled bundle, opt-in via `useAst`).
/// Widget-level dual-mode coverage lives in
/// `test/runner/riverpod_comprehensive_test.dart`; here we pin the fast
/// logic-level contract plus the harness mode flag.
library;

import 'package:dartnative_go/src/runner/ast_bundle_codec.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/runner/runtime_mode.dart';
import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

import '../test_lab/harness.dart';

const _logic = '''
int add(int a, int b) => a + b;
String greeting(String name) => 'Hello, \$name!';
int main() => add(20, 22);
''';

void main() {
  group('runtime mode defaults', () {
    test('AST is the default; Source is the fallback', () {
      expect(kUseAst, isTrue);
      expect(kDefaultRuntimeMode, equals(RuntimeMode.ast));
      expect(runtimeModeFromBool(false), equals(RuntimeMode.source));
      expect(runtimeModeFromBool(true), equals(RuntimeMode.ast));
      expect(RuntimeMode.ast.label, contains('AST'));
      expect(RuntimeMode.source.label, contains('Source'));

      expect(flagsFromRuntimeMode(RuntimeMode.ast), isTrue);
      expect(flagsFromRuntimeMode(RuntimeMode.source), isFalse);

      // Name resolution
      expect(runtimeModeFromName('ast'), equals(RuntimeMode.ast));
      expect(runtimeModeFromName('source'), equals(RuntimeMode.source));
      expect(runtimeModeFromName('unknown'), equals(RuntimeMode.ast));

      // Cycle order: AST -> Source -> AST (when both engines are linked).
      kSourceRuntimeLinked = true;
      addTearDown(() => kSourceRuntimeLinked = false);
      expect(RuntimeMode.ast.next, equals(RuntimeMode.source));
      expect(RuntimeMode.source.next, equals(RuntimeMode.ast));
      expect(selectableRuntimeModes, hasLength(2));
    });

    test('product builds expose AST only and clamp a stored Source mode', () {
      expect(kSourceRuntimeLinked, isFalse);
      expect(selectableRuntimeModes, equals([RuntimeMode.ast]));
      expect(RuntimeMode.ast.next, equals(RuntimeMode.ast));
      expect(
        supportedRuntimeMode(RuntimeMode.source),
        equals(RuntimeMode.ast),
      );
      expect(supportedRuntimeMode(RuntimeMode.ast), equals(RuntimeMode.ast));
    });

    test('harness starts in source mode and can switch', () {
      final harness = DnHarness(onLog: (_) {});
      expect(harness.mode, equals(DnMode.source));
      harness.switchMode(DnMode.ast);
      expect(harness.mode, equals(DnMode.ast));
      harness.dispose();
    });
  });

  group('source vs AST logic parity', () {
    test('same guest logic returns 42 on both engines', () async {
      final sourceRunner = D4rt();
      final sourceResult = await sourceRunner.execute(source: _logic);
      expect(sourceResult, equals(42));

      final bundler = AstBundler();
      final bundle = await bundler.createFromSource(
        _logic,
        sourcePath: 'parity.dart',
      );
      final astRunner = ast.D4rtRunner();
      expect(astRunner.executeBundleAs<int>(bundle, name: 'main'), equals(42));
    });

    test('AST bytes survive guest.ast-style ZIP round-trip', () async {
      final bundler = AstBundler();
      final bundle = await bundler.createFromSource(
        _logic,
        sourcePath: 'parity.dart',
      );
      final zipBytes = bundle.toZip();
      expect(zipBytes.take(2).toList(), equals([0x50, 0x4B]));
      final reloaded = decodeAstBundleBytes(zipBytes);
      final runner = ast.D4rtRunner();
      expect(runner.executeBundleAs<int>(reloaded, name: 'main'), equals(42));
    });

    test('AST named functions accept args; gzip also decodes', () async {
      final bundler = AstBundler();
      final bundle = await bundler.createFromSource(
        _logic,
        sourcePath: 'parity.dart',
      );
      final runner = ast.D4rtRunner();
      // Regression: client once used gzip-only fromBytes on ZIP data →
      // "Invalid GZip Signature". decodeAstBundleBytes auto-detects both.
      expect(
        runner.executeBundleAs<int>(
          bundle,
          name: 'add',
          positionalArgs: [7, 8],
        ),
        equals(15),
      );
      final fromGzip = decodeAstBundleBytes(bundle.toBytes());
      final runner2 = ast.D4rtRunner();
      expect(
        runner2.executeBundleAs<int>(fromGzip, name: 'main'),
        equals(42),
      );
    });

    test('entry-point resolution never treats functions as modules', () async {
      final bundler = AstBundler();
      final bundle = await bundler.createFromSource(
        _logic,
        sourcePath: 'parity.dart',
      );
      expect(resolveBundleEntry(bundle, 'main'), equals(bundle.entryPointUri));
      expect(
        resolveBundleEntry(bundle, bundle.entryPointUri),
        equals(bundle.entryPointUri),
      );
      expect(resolveBundleEntry(bundle, null), equals(bundle.entryPointUri));
    });

    test(
      'harness AST engine evaluates typed bundles (guest.ast path)',
      () async {
        final bundler = AstBundler();
        final bundle = await bundler.createFromSource(
          _logic,
          sourcePath: 'parity.dart',
        );
        final astRunner = AstInterpreterRunner(onLog: (_) {});
        final result = await astRunner.evaluateAstBundleAs<int>(
          bundle.toBytes(),
        );
        expect(result, equals(42));
        astRunner.dispose();
      },
    );
  });
}

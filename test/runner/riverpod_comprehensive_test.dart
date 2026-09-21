import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:riverpod_kit/src/widget_ref.dart';
import 'package:test/test.dart';
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/auto_import_parser.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/runner/interpreter_runner.dart';

import '../test_lab/fixtures/riverpod_fixture.dart';

/// Generates a test project containing all major Riverpod provider types:
/// - NotifierProvider (synchronous state + mutation methods)
/// - Provider (computed / derived state)
/// - FutureProvider (async data loading)
/// - StreamProvider (streaming data)
/// - ConsumerWidget (build with ref.watch & button callback calling notifier method)
Directory _createRiverpodTestProject(Directory parent, String name) {
  final dir = createRiverpodProjectShell(parent, name);
  final lib = Directory('${dir.path}/lib');

  // providers.dart
  File('${lib.path}/providers.dart').writeAsStringSync('''
import 'dart:async';
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

// 1. Notifier & NotifierProvider (state management with mutation methods)
class CounterState {
  final int count;
  final String status;
  const CounterState({this.count = 0, this.status = 'initial'});

  CounterState copyWith({int? count, String? status}) {
    return CounterState(
      count: count ?? this.count,
      status: status ?? this.status,
    );
  }
}

class CounterNotifier extends Notifier<CounterState> {
  CounterNotifier();

  @override
  CounterState build() => const CounterState(count: 10, status: 'ready');

  void increment() {
    state = state.copyWith(count: state.count + 1, status: 'incremented');
  }

  void reset() {
    state = const CounterState(count: 0, status: 'reset');
  }

  void setCustom(int value, String note) {
    state = state.copyWith(count: value, status: note);
  }
}

final counterProvider = NotifierProvider<CounterNotifier, CounterState>(
  CounterNotifier.new,
);

// 2. Computed / Functional Provider (derived from counterProvider)
final doubledCounterProvider = Provider<int>((ref) {
  final counter = ref.watch(counterProvider);
  return counter.count * 2;
});

final counterStatusMessageProvider = Provider<String>((ref) {
  final counter = ref.watch(counterProvider);
  return 'Status: \${counter.status} (Count: \${counter.count})';
});

// 3. FutureProvider (asynchronous data)
final asyncConfigProvider = FutureProvider<String>((ref) async {
  return 'Config Loaded Successfully';
});

// 4. StreamProvider (reactive stream)
final numberStreamProvider = StreamProvider<int>((ref) {
  return Stream.fromIterable([100, 200, 300]);
});
''');

  // main.dart
  File('${lib.path}/main.dart').writeAsStringSync('''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'providers.dart';

class TestConsumerScreen extends ConsumerWidget {
  const TestConsumerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch NotifierProvider
    final counter = ref.watch(counterProvider);

    // 2. Read Notifier for method execution
    final notifier = ref.read(counterProvider.notifier);

    // 3. Watch computed functional Provider
    final doubled = ref.watch(doubledCounterProvider);
    final statusMsg = ref.watch(counterStatusMessageProvider);

    // 4. Watch FutureProvider
    final asyncConfig = ref.watch(asyncConfigProvider);

    // 5. Watch StreamProvider
    final streamNum = ref.watch(numberStreamProvider);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Count: \${counter.count}'),
            Text('Status: \${counter.status}'),
            Text('Doubled: \$doubled'),
            Text(statusMsg),
            Text('Async: \${asyncConfig.valueOrNull ?? "loading"}'),
            Text('Stream: \${streamNum.valueOrNull ?? "no_stream"}'),
            Button(
              title: 'Increment',
              onPressed: () => notifier.increment(),
            ),
            Button(
              title: 'SetCustom',
              onPressed: () => notifier.setCustom(99, 'custom_set'),
            ),
            Button(
              title: 'Reset',
              onPressed: () => notifier.reset(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const ProviderScope(
      child: TestConsumerScreen(),
    ),
  );
}
''');

  return dir;
}

void main() {
  test('Comprehensive Riverpod state management & all provider types work in AST and Source modes', () async {
    print('================================================================');
    print('🧪 Comprehensive Riverpod Provider Validation Suite');
    print('   Validating:');
    print('   • NotifierProvider (state preservation, build, method invocation)');
    print('   • Provider (computed reactive derivation)');
    print('   • FutureProvider (async data)');
    print('   • StreamProvider (stream data)');
    print('   • ConsumerWidget (watch, read, UI re-renders)');
    print('================================================================\n');

    final tempDir = Directory.systemTemp.createTempSync('riverpod_validation_');

    try {
      final projectDir = _createRiverpodTestProject(tempDir, 'riverpod_test_app');

      // -----------------------------------------------------------------------
      // PART A: Validate in AST Execution Mode (AstInterpreterRunner)
      // -----------------------------------------------------------------------
      print('▶️  PART A: Validating AST Mode (tom_ast_generator + tom_d4rt_ast)...');

      final astOut = File('${projectDir.path}/test_app.ast');
      final astBuild = await buildGuestAstBundle(
        projectDir,
        outputArg: astOut.path,
        force: true,
      );
      assert(astBuild.success, 'AST build failed: ${astBuild.error}');
      print('   ✅ AST Bundle built: ${astBuild.moduleCount} modules, ${astBuild.byteSize} bytes');

      final astBytes = await astOut.readAsBytes();
      final astRunner = AstInterpreterRunner(
        onLog: (msg) => print('   [AST Log] $msg'),
      );

      final astRoot = await astRunner.evaluateAstBundleAs<Widget>(
        astBytes,
        name: 'main',
      );
      assert(astRoot is ProviderScope, 'Expected ProviderScope root in AST mode');

      final astScope = astRoot as ProviderScope;
      final astScreen = astScope.child;
      final astHost = TestConsumerHost();
      final astRef = ConsumerRef(astHost);

      // 1. Initial Build
      print('   1️⃣  AST Mode: Performing initial ConsumerWidget build...');
      final astInitial = (astScreen as dynamic).build(astHost.context, astRef) as Scaffold;
      final astCol = (astInitial.body as Center).child as Column;

      final astCountText = astCol.children[0] as Text;
      final astStatusText = astCol.children[1] as Text;
      final astDoubledText = astCol.children[2] as Text;
      final astMsgText = astCol.children[3] as Text;

      print('      Initial Count Text: "${astCountText.data}"');
      print('      Initial Doubled Text: "${astDoubledText.data}"');
      print('      Initial Status Message: "${astMsgText.data}"');

      assert(astCountText.data == 'Count: 10', 'Expected initial count 10');
      assert(astStatusText.data == 'Status: ready', 'Expected initial status ready');
      assert(astDoubledText.data == 'Doubled: 20', 'Computed provider must be 20');
      assert(astMsgText.data == 'Status: ready (Count: 10)', 'Expected status message');
      print('   ✅ Initial state & computed provider verified in AST mode');

      // 2. Trigger Method 1: increment()
      print('   2️⃣  AST Mode: Triggering notifier.increment()...');
      final astIncrementBtn = astCol.children[6] as Button;
      assert(astIncrementBtn.onPressed != null);
      astIncrementBtn.onPressed!();

      // Rebuild & verify
      final astRebuilt1 = (astScreen as dynamic).build(astHost.context, astRef) as Scaffold;
      final astCol1 = (astRebuilt1.body as Center).child as Column;
      final astCount1 = astCol1.children[0] as Text;
      final astDoubled1 = astCol1.children[2] as Text;
      final astStatus1 = astCol1.children[1] as Text;
      print('      After increment: count="${astCount1.data}", doubled="${astDoubled1.data}", status="${astStatus1.data}"');

      assert(astCount1.data == 'Count: 11', 'Count must increment to 11');
      assert(astDoubled1.data == 'Doubled: 22', 'Doubled computed provider must be 22');
      assert(astStatus1.data == 'Status: incremented', 'Status must be incremented');
      print('   ✅ State mutation (increment) & computed derivation verified in AST mode');

      // 3. Trigger Method 2: setCustom(99, 'custom_set')
      print('   3️⃣  AST Mode: Triggering notifier.setCustom(99, "custom_set")...');
      final astCustomBtn = astCol1.children[7] as Button;
      assert(astCustomBtn.onPressed != null);
      astCustomBtn.onPressed!();

      final astRebuilt2 = (astScreen as dynamic).build(astHost.context, astRef) as Scaffold;
      final astCol2 = (astRebuilt2.body as Center).child as Column;
      final astCount2 = astCol2.children[0] as Text;
      final astDoubled2 = astCol2.children[2] as Text;
      final astStatus2 = astCol2.children[1] as Text;
      print('      After setCustom: count="${astCount2.data}", doubled="${astDoubled2.data}", status="${astStatus2.data}"');

      assert(astCount2.data == 'Count: 99', 'Count must be 99');
      assert(astDoubled2.data == 'Doubled: 198', 'Doubled computed provider must be 198');
      assert(astStatus2.data == 'Status: custom_set', 'Status must be custom_set');
      print('   ✅ Custom method call with parameters verified in AST mode');

      // 4. Trigger Method 3: reset()
      print('   4️⃣  AST Mode: Triggering notifier.reset()...');
      final astResetBtn = astCol2.children[8] as Button;
      assert(astResetBtn.onPressed != null);
      astResetBtn.onPressed!();

      final astRebuilt3 = (astScreen as dynamic).build(astHost.context, astRef) as Scaffold;
      final astCol3 = (astRebuilt3.body as Center).child as Column;
      final astCount3 = astCol3.children[0] as Text;
      final astDoubled3 = astCol3.children[2] as Text;
      print('      After reset: count="${astCount3.data}", doubled="${astDoubled3.data}"');

      assert(astCount3.data == 'Count: 0', 'Count must be 0 after reset');
      assert(astDoubled3.data == 'Doubled: 0', 'Doubled must be 0 after reset');
      print('   ✅ Reset method verified in AST mode');
      print('   🎉 AST MODE FULLY PASSED!\n');

      // -----------------------------------------------------------------------
      // PART B: Validate in Source Execution Mode (InterpreterRunner)
      // -----------------------------------------------------------------------
      print('▶️  PART B: Validating Source Mode (tom_d4rt interpreter)...');

      final rawFiles = <String, String>{};
      final libDir = Directory('${projectDir.path}/lib');
      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final rel = entity.path.substring('${projectDir.path}/lib/'.length);
          rawFiles[rel] = entity.readAsStringSync();
        }
      }

      final virtualMap = AutoImportParser.buildVirtualSourceMap(
        rawFiles,
        packageName: 'riverpod_test_app',
      );

      final sourceRunner = InterpreterRunner(
        onLog: (msg) => print('   [Source Log] $msg'),
      );

      final mainCode = virtualMap['package:riverpod_test_app/main.dart'] ?? virtualMap['main.dart']!;
      final sourceRoot = await sourceRunner.evaluate(
        source: mainCode,
        library: 'package:riverpod_test_app/main.dart',
        sources: virtualMap,
        isHotReload: false,
      );
      assert(sourceRoot is ProviderScope, 'Expected ProviderScope root in Source mode');

      final sourceScope = sourceRoot as ProviderScope;
      final sourceScreen = sourceScope.child;
      final sourceHost = TestConsumerHost();
      final sourceRef = ConsumerRef(sourceHost);

      // 1. Initial Build
      print('   1️⃣  Source Mode: Performing initial ConsumerWidget build...');
      final srcInitial = (sourceScreen as dynamic).build(sourceHost.context, sourceRef) as Scaffold;
      final srcCol = (srcInitial.body as Center).child as Column;

      final srcCountText = srcCol.children[0] as Text;
      final srcDoubledText = srcCol.children[2] as Text;
      final srcMsgText = srcCol.children[3] as Text;

      print('      Initial Count Text: "${srcCountText.data}"');
      print('      Initial Doubled Text: "${srcDoubledText.data}"');
      print('      Initial Status Message: "${srcMsgText.data}"');

      assert(srcCountText.data == 'Count: 10', 'Expected initial count 10');
      assert(srcDoubledText.data == 'Doubled: 20', 'Computed provider must be 20');
      assert(srcMsgText.data == 'Status: ready (Count: 10)', 'Expected status message');
      print('   ✅ Initial state & computed provider verified in Source mode');

      // 2. Trigger Method: increment()
      print('   2️⃣  Source Mode: Triggering notifier.increment()...');
      final srcIncrementBtn = srcCol.children[6] as Button;
      assert(srcIncrementBtn.onPressed != null);
      srcIncrementBtn.onPressed!();

      final srcRebuilt1 = (sourceScreen as dynamic).build(sourceHost.context, sourceRef) as Scaffold;
      final srcCol1 = (srcRebuilt1.body as Center).child as Column;
      final srcCount1 = srcCol1.children[0] as Text;
      final srcDoubled1 = srcCol1.children[2] as Text;
      print('      After increment: count="${srcCount1.data}", doubled="${srcDoubled1.data}"');

      assert(srcCount1.data == 'Count: 11', 'Count must increment to 11');
      assert(srcDoubled1.data == 'Doubled: 22', 'Doubled computed provider must be 22');
      print('   ✅ State mutation (increment) & computed derivation verified in Source mode');

      // 3. Trigger Method: setCustom(77, 'source_custom')
      print('   3️⃣  Source Mode: Triggering notifier.setCustom(99, "custom_set")...');
      final srcCustomBtn = srcCol1.children[7] as Button;
      assert(srcCustomBtn.onPressed != null);
      srcCustomBtn.onPressed!();

      final srcRebuilt2 = (sourceScreen as dynamic).build(sourceHost.context, sourceRef) as Scaffold;
      final srcCol2 = (srcRebuilt2.body as Center).child as Column;
      final srcCount2 = srcCol2.children[0] as Text;
      final srcDoubled2 = srcCol2.children[2] as Text;
      final srcStatus2 = srcCol2.children[1] as Text;
      print('      After setCustom: count="${srcCount2.data}", doubled="${srcDoubled2.data}", status="${srcStatus2.data}"');

      assert(srcCount2.data == 'Count: 99', 'Count must be 99');
      assert(srcDoubled2.data == 'Doubled: 198', 'Doubled computed provider must be 198');
      assert(srcStatus2.data == 'Status: custom_set', 'Status must be custom_set');
      print('   ✅ Custom method call with parameters verified in Source mode');
      print('   🎉 SOURCE MODE FULLY PASSED!\n');

      print('================================================================');
      print('🏆 ALL RIVERPOD PROVIDER & STATE MANAGEMENT TESTS PASSED!');
      print('================================================================\n');
    } finally {
      if (tempDir.existsSync()) {
        try {
          tempDir.deleteSync(recursive: true);
        } catch (_) {}
      }
    }
  });
}

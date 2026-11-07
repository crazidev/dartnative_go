import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:riverpod_kit/src/widget_ref.dart';
import 'package:test/test.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/auto_import_parser.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/runner/interpreter_runner.dart';
import '../test_lab/fixtures/riverpod_fixture.dart';

void main() {
  test('Riverpod state and top-level providers persist across Hot Reload in Source and AST modes', () async {
    final tempDir = Directory.systemTemp.createTempSync('dn_riverpod_hr_test_');

    try {
      final projectDir = Directory('${tempDir.path}/riverpod_hr_app')..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml').writeAsStringSync('''
name: riverpod_hr_app
dependencies:
  dartnative: ^1.0.0
  riverpod_kit:
    hosted: https://dartpub.dev
    version: ^0.1.0
''');

      final libDir = Directory('${projectDir.path}/lib')..createSync();

      // Write initial state & widget code
      File('${libDir.path}/state.dart').writeAsStringSync('''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

class CounterState {
  final int count;
  const CounterState(this.count);
}

class CounterNotifier extends Notifier<CounterState> {
  CounterNotifier();

  @override
  CounterState build() {
    return const CounterState(10);
  }

  void increment() {
    state = CounterState(state.count + 1);
  }

  void decrement() {
    state = CounterState(state.count - 1);
  }
}

final counterProvider = NotifierProvider<CounterNotifier, CounterState>(CounterNotifier.new);

final doubleCountProvider = Provider<int>((ref) {
  final s = ref.watch(counterProvider);
  return s.count * 2;
});
''');

      File('${libDir.path}/home_screen.dart').writeAsStringSync('''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'state.dart';

class CounterScreen extends ConsumerWidget {
  final String title;
  const CounterScreen({this.title = 'Initial Version'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterProvider);
    final doubled = ref.watch(doubleCountProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          children: [
            Text('Count: \${counterState.count}'),
            Text('Doubled: \$doubled'),
            Button(
              child: const Text('Increment'),
              onPressed: () {
                ref.read(counterProvider.notifier).increment();
              },
            ),
          ],
        ),
      ),
    );
  }
}
''');

      File('${libDir.path}/main.dart').writeAsStringSync('''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'home_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: const CounterScreen(),
    ),
  );
}
''');

      // -----------------------------------------------------------------------
      // PART A: Source Mode Hot Reload State Preservation
      // -----------------------------------------------------------------------
      print('▶️  Testing Source Mode Hot Reload State Preservation...');
      final runner = InterpreterRunner(
        onLog: (msg) => print('   [Source Log] $msg'),
      );

      final rawFilesV1 = <String, String>{};
      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final rel = entity.path.substring('${projectDir.path}/lib/'.length);
          rawFilesV1[rel] = entity.readAsStringSync();
        }
      }

      final virtualMapV1 = AutoImportParser.buildVirtualSourceMap(
        rawFilesV1,
        packageName: 'riverpod_hr_app',
      );

      final mainCodeV1 = virtualMapV1['package:riverpod_hr_app/main.dart'] ?? virtualMapV1['main.dart']!;
      final rootV1 = await runner.evaluate(
        source: mainCodeV1,
        library: 'package:riverpod_hr_app/main.dart',
        sources: virtualMapV1,
        isHotReload: false,
      );

      expect(rootV1, isA<ProviderScope>());
      final scopeV1 = rootV1 as ProviderScope;
      final screenV1 = scopeV1.child;

      final host = TestConsumerHost();
      final ref = ConsumerRef(host);

      // 1. Initial build: Count = 10
      final initialScaffold = (screenV1 as dynamic).build(host.context, ref) as Scaffold;
      final initialCol = (initialScaffold.body as Center).child as Column;
      final initialCountText = initialCol.children[0] as Text;
      final initialDoubledText = initialCol.children[1] as Text;
      expect(initialCountText.data, equals('Count: 10'));
      expect(initialDoubledText.data, equals('Doubled: 20'));
      print('   ✅ Initial state: Count = 10, Doubled = 20');

      // 2. Increment state: Count -> 11
      final incBtn = initialCol.children[2] as Button;
      incBtn.onPressed!();

      final incScaffold = (screenV1 as dynamic).build(host.context, ref) as Scaffold;
      final incCol = (incScaffold.body as Center).child as Column;
      final incCountText = incCol.children[0] as Text;
      final incDoubledText = incCol.children[1] as Text;
      expect(incCountText.data, equals('Count: 11'));
      expect(incDoubledText.data, equals('Doubled: 22'));
      print('   ✅ Mutated state before reload: Count = 11, Doubled = 22');

      // 3. Update guest code (modify title in HomeScreen)
      File('${libDir.path}/home_screen.dart').writeAsStringSync('''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'state.dart';

class CounterScreen extends ConsumerWidget {
  final String title;
  const CounterScreen({this.title = 'Reloaded Version 2'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterProvider);
    final doubled = ref.watch(doubleCountProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          children: [
            Text('Count: \${counterState.count}'),
            Text('Doubled: \$doubled'),
            Button(
              child: const Text('Increment'),
              onPressed: () {
                ref.read(counterProvider.notifier).increment();
              },
            ),
          ],
        ),
      ),
    );
  }
}
''');

      // 4. Hot Reload
      print('   🔄 Performing Hot Reload (isHotReload: true)...');
      final rawFilesV2 = <String, String>{};
      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final rel = entity.path.substring('${projectDir.path}/lib/'.length);
          rawFilesV2[rel] = entity.readAsStringSync();
        }
      }
      final virtualMapV2 = AutoImportParser.buildVirtualSourceMap(
        rawFilesV2,
        packageName: 'riverpod_hr_app',
      );

      final mainCodeV2 = virtualMapV2['package:riverpod_hr_app/main.dart'] ?? virtualMapV2['main.dart']!;
      final rootV2 = await runner.evaluate(
        source: mainCodeV2,
        library: 'package:riverpod_hr_app/main.dart',
        sources: virtualMapV2,
        isHotReload: true,
      );

      final scopeV2 = rootV2 as ProviderScope;
      final screenV2 = scopeV2.child;

      // 5. Rebuild after Hot Reload using the retained host/container
      final reloadedScaffold = (screenV2 as dynamic).build(host.context, ref) as Scaffold;
      final reloadedCol = (reloadedScaffold.body as Center).child as Column;
      final reloadedCountText = reloadedCol.children[0] as Text;
      final reloadedDoubledText = reloadedCol.children[1] as Text;
      final reloadedTitleText = ((reloadedScaffold.appBar as AppBar).title as Text).data;

      print('      Reloaded Title: "$reloadedTitleText"');
      print('      Reloaded Count: "${reloadedCountText.data}"');
      print('      Reloaded Doubled: "${reloadedDoubledText.data}"');

      expect(reloadedTitleText, equals('Reloaded Version 2'), reason: 'Code change must apply');
      expect(reloadedCountText.data, equals('Count: 11'), reason: 'Count state (11) must be preserved across Hot Reload');
      expect(reloadedDoubledText.data, equals('Doubled: 22'), reason: 'Derived provider must reflect preserved count');
      print('   ✅ Hot reload state preservation verified in Source mode!');

      // 6. Mutate again after Hot Reload: Count -> 12
      final reloadedIncBtn = reloadedCol.children[2] as Button;
      reloadedIncBtn.onPressed!();

      final postScaffold = (screenV2 as dynamic).build(host.context, ref) as Scaffold;
      final postCol = (postScaffold.body as Center).child as Column;
      final postCountText = postCol.children[0] as Text;
      final postDoubledText = postCol.children[1] as Text;
      expect(postCountText.data, equals('Count: 12'));
      expect(postDoubledText.data, equals('Doubled: 24'));
      print('   ✅ Post-reload mutation verified: Count = 12, Doubled = 24');
      print('   🎉 SOURCE MODE HOT RELOAD TEST PASSED!\n');

      // -----------------------------------------------------------------------
      // PART B: AST Mode Hot Reload State Preservation
      // -----------------------------------------------------------------------
      print('▶️  Testing AST Mode Hot Reload State Preservation...');
      final astRunner = AstInterpreterRunner(
        onLog: (msg) => print('   [AST Log] $msg'),
      );

      // Build V1 AST Bundle
      final astOutV1 = File('${projectDir.path}/app_v1.ast');
      final astBuildV1 = await buildGuestAstBundle(
        projectDir,
        outputArg: astOutV1.path,
        force: true,
      );
      expect(astBuildV1.success, isTrue, reason: 'AST build V1 must succeed: ${astBuildV1.error}');
      final bundleBytesV1 = await astOutV1.readAsBytes();

      final astRootV1 = await astRunner.evaluateAstBundleAs<Widget>(
        bundleBytesV1,
        isHotReload: false,
      );

      expect(astRootV1, isA<ProviderScope>());
      final astScopeV1 = astRootV1 as ProviderScope;
      final astScreenV1 = astScopeV1.child;

      final astHost = TestConsumerHost();
      final astRef = ConsumerRef(astHost);

      // 1. AST initial build
      final astInitial = (astScreenV1 as dynamic).build(astHost.context, astRef) as Scaffold;
      final astCol1 = (astInitial.body as Center).child as Column;
      expect((astCol1.children[0] as Text).data, equals('Count: 10'));
      print('   ✅ AST Initial state: Count = 10');

      // 2. Increment state in AST mode: Count -> 11
      (astCol1.children[2] as Button).onPressed!();
      final astIncScaffold = (astScreenV1 as dynamic).build(astHost.context, astRef) as Scaffold;
      final astIncCol = (astIncScaffold.body as Center).child as Column;
      expect((astIncCol.children[0] as Text).data, equals('Count: 11'));
      expect((astIncCol.children[1] as Text).data, equals('Doubled: 22'));
      print('   ✅ AST Mutated state before reload: Count = 11');

      // 3. Update guest code for AST build V2
      File('${libDir.path}/home_screen.dart').writeAsStringSync('''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'state.dart';

class CounterScreen extends ConsumerWidget {
  final String title;
  const CounterScreen({this.title = 'AST Reloaded Version 3'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterProvider);
    final doubled = ref.watch(doubleCountProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          children: [
            Text('Count: \${counterState.count}'),
            Text('Doubled: \$doubled'),
            Button(
              child: const Text('Increment'),
              onPressed: () {
                ref.read(counterProvider.notifier).increment();
              },
            ),
          ],
        ),
      ),
    );
  }
}
''');

      final astOutV2 = File('${projectDir.path}/app_v2.ast');
      final astBuildV2 = await buildGuestAstBundle(
        projectDir,
        outputArg: astOutV2.path,
        force: true,
      );
      expect(astBuildV2.success, isTrue, reason: 'AST build V2 must succeed: ${astBuildV2.error}');
      final bundleBytesV2 = await astOutV2.readAsBytes();

      // 4. Hot Reload in AST mode
      print('   🔄 Performing AST Hot Reload (isHotReload: true)...');
      final astRootV2 = await astRunner.evaluateAstBundleAs<Widget>(
        bundleBytesV2,
        isHotReload: true,
      );

      final astScopeV2 = astRootV2 as ProviderScope;
      final astScreenV2 = astScopeV2.child;

      // 5. Rebuild after AST Hot Reload
      final astReloadedScaffold = (astScreenV2 as dynamic).build(astHost.context, astRef) as Scaffold;
      final astReloadedCol = (astReloadedScaffold.body as Center).child as Column;
      final astReloadedCountText = astReloadedCol.children[0] as Text;
      final astReloadedDoubledText = astReloadedCol.children[1] as Text;
      final astReloadedTitle = ((astReloadedScaffold.appBar as AppBar).title as Text).data;

      print('      AST Reloaded Title: "$astReloadedTitle"');
      print('      AST Reloaded Count: "${astReloadedCountText.data}"');
      print('      AST Reloaded Doubled: "${astReloadedDoubledText.data}"');

      expect(astReloadedTitle, equals('AST Reloaded Version 3'));
      expect(astReloadedCountText.data, equals('Count: 11'), reason: 'AST mode must preserve state across hot reload');
      expect(astReloadedDoubledText.data, equals('Doubled: 22'));
      print('   ✅ Hot reload state preservation verified in AST mode!');

      // 6. Mutate again in AST mode: Count -> 12
      (astReloadedCol.children[2] as Button).onPressed!();
      final astPostScaffold = (astScreenV2 as dynamic).build(astHost.context, astRef) as Scaffold;
      final astPostCol = (astPostScaffold.body as Center).child as Column;
      expect((astPostCol.children[0] as Text).data, equals('Count: 12'));
      expect((astPostCol.children[1] as Text).data, equals('Doubled: 24'));
      print('   ✅ AST Post-reload mutation verified: Count = 12, Doubled = 24');
      print('   🎉 AST MODE HOT RELOAD TEST PASSED!\n');

      print('================================================================');
      print('🏆 ALL RIVERPOD HOT RELOAD STATE PRESERVATION TESTS PASSED!');
      print('================================================================\n');
    } finally {
      if (tempDir.existsSync()) {
        try {
          tempDir.deleteSync(recursive: true);
        } catch (_) {}
      }
    }
    // Builds and evaluates the fixture in both engines, twice each. Comfortably
    // inside the default 30 s budget on an idle host, but not when the rest of
    // `test/` runs alongside it; the behavior under test has no such limit.
  }, timeout: const Timeout(Duration(seconds: 120)));
}

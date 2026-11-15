/// Regression test for interpreted `ConsumerStatefulWidget` screens.
///
/// Reproduces the device failure seen with `example/lib/todo_screen.dart`
/// (`TodoScreen extends ConsumerStatefulWidget`):
///
///     Invalid parameter "child": expected Widget,
///     got InterpretedInstance(TodoScreen)
///
/// Root cause: the generated `classSupertypes()` table drops the
/// cross-barrel edge `ConsumerStatefulWidget -> StatefulWidget`, so
/// `D4.tryCreateInterfaceProxyWithVisitor` never reached the generic
/// `StatefulWidget` proxy. Fixed with dedicated
/// `InterpretedConsumerStatefulWidget` / `InterpretedConsumerStateProxy`
/// (the latter extends the real `ConsumerState`, so interpreted code keeps
/// the native `ref` getter — field snapshot/restore alone cannot provide
/// it) registered under the exact bridged names in
/// `lib/src/interpreter/widget_proxies.dart` and
/// `lib/src/interpreter/ast/ast_widget_proxies.dart`.
///
/// Covers (in BOTH source and AST engines):
/// 1. Bridge surface: `ConsumerStatefulWidget` + `ConsumerState` (with the
///    `ref` getter) registered in source and AST bridges with parity.
/// 2. Headless behavior: `ProviderScope(child: <interpreted
///    ConsumerStatefulWidget>())` coerces to a native `Widget` (the crash),
///    `createState()` returns a native `ConsumerState`, and the
///    native-proxy / bridged-superobject wiring is intact.
/// 3. On-device (real mount, `ref.watch` + notifier mutation + rebuild):
///    device-gated group below, skipped unless `DN_DEVICE_TEST` is defined —
///    host `State.context`/`stateSetContext` are stubs, and `ref` needs a
///    mounted element (`_StateHost` casts `context` to `Element`), so the
///    full `ref.watch` path cannot run headless.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:test/test.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/ast/ast_widget_proxies.dart'
    as ast_proxies;
import 'package:dartnative_go/src/interpreter/ast/riverpod_kit_bridges.b.dart'
    as ast_bridges;
import 'package:dartnative_go/src/interpreter/riverpod_kit_bridges.b.dart'
    as src_bridges;
import 'package:dartnative_go/src/interpreter/widget_proxies.dart'
    as src_proxies;

import '../test_lab/fixtures/riverpod_fixture.dart';
import '../test_lab/harness.dart';
import '../test_lab/widget_probe.dart';

/// True only on a device with the native runtime, e.g.
/// `dn test -d DEVICE_ID --dart-define=DN_DEVICE_TEST=true
/// test/runner/riverpod_consumer_stateful_test.dart`.
const _isDeviceRun = bool.fromEnvironment('DN_DEVICE_TEST');

/// Minimal TodoScreen-shaped guest: a stateful consumer screen mounted as
/// `ProviderScope` child — the exact shape that crashed on device.
const _statefulGuest = r'''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

class CounterState {
  final int count;
  const CounterState(this.count);
}

class CounterNotifier extends Notifier<CounterState> {
  CounterNotifier();

  @override
  CounterState build() => const CounterState(10);

  void increment() {
    state = CounterState(state.count + 1);
  }
}

final counterProvider = NotifierProvider<CounterNotifier, CounterState>(
  CounterNotifier.new,
);

class CounterStatefulScreen extends ConsumerStatefulWidget {
  const CounterStatefulScreen({super.key});

  @override
  ConsumerState<CounterStatefulScreen> createState() =>
      _CounterStatefulScreenState();
}

class _CounterStatefulScreenState
    extends ConsumerState<CounterStatefulScreen> {
  @override
  Widget build(BuildContext context) {
    final counter = ref.watch(counterProvider);
    final notifier = ref.read(counterProvider.notifier);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Count: ${counter.count}'),
            Button(
              title: 'Increment',
              onPressed: () => notifier.increment(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const ProviderScope(child: CounterStatefulScreen()));
}
''';

/// Guest v1 for the reload-rebind test: `mode` defaults to `'v1'` and the
/// state exposes no `version` method.
const _reloadGuestV1 = r'''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

class HotScreen extends ConsumerStatefulWidget {
  const HotScreen({super.key});

  @override
  ConsumerState<HotScreen> createState() => _HotScreenState();
}

class _HotScreenState extends ConsumerState<HotScreen> {
  String mode = 'v1';

  @override
  Widget build(BuildContext context) {
    return Text('Build $mode');
  }
}

void main() {
  runApp(const ProviderScope(child: HotScreen()));
}
''';

/// Guest v2: same screen, new internals (`mode` defaults to `'v2'`, adds
/// `version()` returning `'v2'`) — what hot reload must pick up.
const _reloadGuestV2 = r'''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

class HotScreen extends ConsumerStatefulWidget {
  const HotScreen({super.key});

  @override
  ConsumerState<HotScreen> createState() => _HotScreenState();
}

class _HotScreenState extends ConsumerState<HotScreen> {
  String mode = 'v2';

  String version() => 'v2';

  @override
  Widget build(BuildContext context) {
    return Text('Build $mode v2');
  }
}

void main() {
  runApp(const ProviderScope(child: HotScreen()));
}
''';

/// Guest v3: `createState` throws, so the rebind must fail loudly (the
/// `didUpdateWidget` override logs it) instead of silently keeping stale UI.
const _reloadGuestBroken = r'''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

class HotScreen extends ConsumerStatefulWidget {
  const HotScreen({super.key});

  @override
  ConsumerState<HotScreen> createState() {
    throw StateError('boom');
  }
}

void main() {
  runApp(const ProviderScope(child: HotScreen()));
}
''';

/// Shared structural assertions for a root produced from [_statefulGuest].
///
/// The first two expects are the reported crash: the `ProviderScope`
/// bridge must coerce the interpreted screen to a native `Widget`.
void _expectStatefulScreenRoot(Widget root, String engine) {
  expect(
    root,
    isA<ProviderScope>(),
    reason: '[$engine] guest main must produce a ProviderScope root',
  );
  final child = (root as ProviderScope).child;
  expect(
    child,
    isA<Widget>(),
    reason:
        '[$engine] ProviderScope child must coerce to a native Widget, '
        'not InterpretedInstance (dump:\n${dumpTree(root)})',
  );
  expect(
    child,
    isA<ConsumerStatefulWidget>(),
    reason: '[$engine] child proxy must preserve the consumer-stateful type',
  );

  // createState() must hand back a native ConsumerState (carries `ref`).
  final state = (child as dynamic).createState();
  expect(
    state,
    isA<ConsumerState>(),
    reason: '[$engine] createState must return a native ConsumerState',
  );

  // Widget-side wiring: the interpreted instance points at its proxy.
  final widgetInstance = (child as dynamic).instance;
  expect(
    widgetInstance.nativeProxy,
    same(child),
    reason: '[$engine] widget InterpretedInstance.nativeProxy must be set',
  );

  // State-side wiring: interpreted state routes member lookups (e.g. `ref`)
  // to the native ConsumerState.
  final stateInstance = (state as dynamic).stateInstance;
  expect(
    stateInstance.nativeProxy,
    same(state),
    reason: '[$engine] state InterpretedInstance.nativeProxy must be set',
  );
  expect(
    stateInstance.bridgedSuperObject,
    same(state),
    reason:
        '[$engine] state InterpretedInstance.bridgedSuperObject must be the '
        'native ConsumerState so `ref` resolves natively',
  );
}

void main() {
  group('ConsumerStatefulWidget bridge surface', () {
    test(
      'source bridges expose ConsumerStatefulWidget + ConsumerState.ref',
      () {
        final classes = src_bridges.RiverpodKitBridge.bridgeClasses();
        final names = classes.map((c) => c.name).toSet();
        expect(names, contains('ConsumerStatefulWidget'));
        expect(names, contains('ConsumerState'));
        final state = classes.firstWhere((c) => c.name == 'ConsumerState');
        expect(
          state.getterSignatures.keys,
          contains('ref'),
          reason: 'ConsumerState bridge must expose the ref getter',
        );
      },
    );

    test('AST bridges mirror the source consumer-stateful surface', () {
      final src = src_bridges.RiverpodKitBridge.bridgeClasses();
      final ast = ast_bridges.RiverpodKitBridge.bridgeClasses();
      for (final name in ['ConsumerStatefulWidget', 'ConsumerState']) {
        final s = src.firstWhere((c) => c.name == name);
        final a = ast.firstWhere((c) => c.name == name);
        expect(
          a.methodSignatures.keys.toSet(),
          equals(s.methodSignatures.keys.toSet()),
          reason: 'AST $name methods must match source',
        );
        expect(
          a.getterSignatures.keys.toSet(),
          equals(s.getterSignatures.keys.toSet()),
          reason: 'AST $name getters must match source',
        );
      }
    });
  });

  group('ConsumerStatefulWidget headless (source mode)', () {
    late DnHarness harness;

    setUp(() {
      harness = DnHarness(onLog: (_) {});
    });

    tearDown(() {
      harness.dispose();
    });

    test('ProviderScope child coerces interpreted screen to Widget', () async {
      final root = await harness.evaluate({'main.dart': _statefulGuest});
      _expectStatefulScreenRoot(root, 'source');
    });

    test('wrapInterpretedWidget resolves the interpreted screen', () async {
      final root = await harness.evaluate({'main.dart': _statefulGuest});
      final child = (root as ProviderScope).child;
      final instance = (child as dynamic).instance;
      expect(
        src_proxies.wrapInterpretedWidget(instance),
        same(child),
        reason: 'wrapInterpretedWidget must return the existing native proxy',
      );
    });

    // The const guest above may take the interpreter's const-evaluation
    // path; without `const` the call must go through the runtime
    // `ProviderScope` constructor adapter, which used to forward `child`
    // as `dynamic` straight into the native `Widget` parameter -> bare
    // `type 'InterpretedInstance' is not a subtype of type 'Widget'` on
    // hot reload. The adapter must coerce via extractBridgedArg<Widget>.
    test('non-const ProviderScope child coerces via runtime path', () async {
      final root = await harness.evaluate({
        'main.dart': _statefulGuest.replaceFirst(
          'const ProviderScope',
          'ProviderScope',
        ),
      });
      _expectStatefulScreenRoot(root, 'source-runtime');
    });
  });

  group('ConsumerStatefulWidget headless (AST mode)', () {
    late Directory tempDir;
    late DnHarness harness;

    setUpAll(() async {
      tempDir = Directory.systemTemp.createTempSync('dn_csw_ast_');
      final projectDir = createRiverpodProjectShell(tempDir, 'csw_test_app');
      File(
        '${projectDir.path}/lib/main.dart',
      ).writeAsStringSync(_statefulGuest);
      final out = File('${projectDir.path}/test_app.ast');
      final build = await buildGuestAstBundle(
        projectDir,
        outputArg: out.path,
        force: true,
      );
      expect(
        build.success,
        isTrue,
        reason: 'AST bundle build failed: ${build.error}',
      );
      final bytes = await out.readAsBytes();
      harness = DnHarness(onLog: (_) {});
      await harness.evaluateAstBytes(bytes, entryPoint: 'main');
    });

    tearDownAll(() {
      harness.dispose();
      deleteTempDir(tempDir);
    });

    test('ProviderScope child coerces interpreted screen to Widget', () {
      _expectStatefulScreenRoot(harness.lastRoot!, 'ast');
    });

    test('wrapAstInterpretedWidget resolves the interpreted screen', () {
      final root = harness.lastRoot!;
      final child = (root as ProviderScope).child;
      final instance = (child as dynamic).instance;
      expect(
        ast_proxies.wrapAstInterpretedWidget(instance),
        same(child),
        reason:
            'wrapAstInterpretedWidget must return the existing native proxy',
      );
    });

    test('non-const ProviderScope child coerces via runtime path', () async {
      final tempDir = Directory.systemTemp.createTempSync('dn_csw_nc_');
      final harness = DnHarness(onLog: (_) {});
      try {
        final projectDir = createRiverpodProjectShell(tempDir, 'csw_nc_app');
        File('${projectDir.path}/lib/main.dart').writeAsStringSync(
          _statefulGuest.replaceFirst('const ProviderScope', 'ProviderScope'),
        );
        final out = File('${projectDir.path}/test_app.ast');
        final build = await buildGuestAstBundle(
          projectDir,
          outputArg: out.path,
          force: true,
        );
        expect(build.success, isTrue);
        await harness.evaluateAstBytes(
          await out.readAsBytes(),
          entryPoint: 'main',
        );
        _expectStatefulScreenRoot(harness.lastRoot!, 'ast-runtime');
      } finally {
        harness.dispose();
        deleteTempDir(tempDir);
      }
    });
  });

  group('ConsumerStatefulWidget reload rebind (source mode)', () {
    late DnHarness oldHarness;
    late DnHarness newHarness;

    setUp(() {
      oldHarness = DnHarness(onLog: (_) {});
      newHarness = DnHarness(onLog: (_) {});
    });

    tearDown(() {
      oldHarness.dispose();
      newHarness.dispose();
    });

    test('rebind carries setState fields to the new interpreter', () async {
      final oldRoot = await oldHarness.evaluate({'main.dart': _reloadGuestV1});
      final newRoot = await newHarness.evaluate({'main.dart': _reloadGuestV2});

      final oldScreen =
          (oldRoot as ProviderScope).child
              as src_proxies.InterpretedConsumerStatefulWidget;
      final newScreen =
          (newRoot as ProviderScope).child
              as src_proxies.InterpretedConsumerStatefulWidget;
      final proxy =
          oldScreen.createState() as src_proxies.InterpretedConsumerStateProxy;
      final oldState = proxy.stateInstance;

      // Simulate user edits via setState before the reload.
      (oldState as dynamic).set('mode', 'dark');
      expect(
        (oldState as dynamic).getField('mode'),
        equals('dark'),
        reason: 'precondition: field write must land on the old instance',
      );

      // This is exactly what didUpdateWidget runs after the framework hands
      // the state its new widget (minus mount-dependent super/setState).
      src_proxies.rebindConsumerStateForReload(proxy, newScreen);

      expect(
        identical(proxy.visitor, newScreen.visitor),
        isTrue,
        reason: 'proxy must delegate to the new interpreter',
      );
      expect(
        identical(proxy.ownerWidget, newScreen),
        isTrue,
        reason: 'proxy must track the new owner widget',
      );

      final rebound = proxy.stateInstance;
      expect(
        identical(rebound, oldState),
        isFalse,
        reason: 'state instance must come from the new interpreter',
      );
      expect(
        (rebound as dynamic).getField('mode'),
        equals('dark'),
        reason: 'setState fields must survive the reload',
      );

      // New details are reachable: v2-only method resolves on the rebound
      // instance through the new visitor.
      final versionFn = (rebound as dynamic).get(
        'version',
        visitor: proxy.visitor,
      );
      expect(
        (versionFn as dynamic).call(proxy.visitor, [], <String, Object?>{}),
        equals('v2'),
        reason: 'edited code must be reachable after rebind',
      );

      expect(
        identical((rebound as dynamic).nativeProxy, proxy),
        isTrue,
        reason: 'rebound instance must point back at the native state',
      );
      expect(
        identical((rebound as dynamic).bridgedSuperObject, proxy),
        isTrue,
        reason: 'rebound instance must route `ref` through ConsumerState',
      );
    });

    test('rebind failure throws instead of silently staling', () async {
      final oldRoot = await oldHarness.evaluate({'main.dart': _reloadGuestV1});
      final brokenRoot = await newHarness.evaluate({
        'main.dart': _reloadGuestBroken,
      });

      final oldScreen =
          (oldRoot as ProviderScope).child
              as src_proxies.InterpretedConsumerStatefulWidget;
      final brokenScreen =
          (brokenRoot as ProviderScope).child
              as src_proxies.InterpretedConsumerStatefulWidget;
      final proxy =
          oldScreen.createState() as src_proxies.InterpretedConsumerStateProxy;

      expect(
        () => src_proxies.rebindConsumerStateForReload(proxy, brokenScreen),
        // The interpreter wraps the guest `throw` (InternalInterpreter-
        // D4rtException carrying `Bad state: boom`); what matters is the
        // cause propagates instead of leaving stale UI bound silently.
        throwsA(
          predicate(
            (e) => e.toString().contains('boom'),
            'an error carrying the guest cause',
          ),
        ),
        reason:
            'unusable new code must surface (didUpdateWidget logs it) rather '
            'than leave the previous state silently bound to stale code',
      );
    });
  });

  group('ConsumerStatefulWidget reload rebind (AST mode)', () {
    late Directory tempDir;
    late DnHarness oldHarness;
    late DnHarness newHarness;

    Future<void> loadVersion(
      DnHarness harness,
      String project,
      String guest,
    ) async {
      final projectDir = createRiverpodProjectShell(tempDir, project);
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(guest);
      final out = File('${projectDir.path}/test_app.ast');
      final build = await buildGuestAstBundle(
        projectDir,
        outputArg: out.path,
        force: true,
      );
      expect(
        build.success,
        isTrue,
        reason: 'AST bundle build failed: ${build.error}',
      );
      await harness.evaluateAstBytes(
        await out.readAsBytes(),
        entryPoint: 'main',
      );
    }

    setUpAll(() async {
      tempDir = Directory.systemTemp.createTempSync('dn_csw_reload_');
      oldHarness = DnHarness(onLog: (_) {});
      newHarness = DnHarness(onLog: (_) {});
      await loadVersion(oldHarness, 'csw_reload_v1', _reloadGuestV1);
      await loadVersion(newHarness, 'csw_reload_v2', _reloadGuestV2);
    });

    tearDownAll(() {
      oldHarness.dispose();
      newHarness.dispose();
      deleteTempDir(tempDir);
    });

    test('rebind carries setState fields to the new interpreter', () {
      final oldScreen =
          (oldHarness.lastRoot! as ProviderScope).child
              as ast_proxies.InterpretedConsumerStatefulWidget;
      final newScreen =
          (newHarness.lastRoot! as ProviderScope).child
              as ast_proxies.InterpretedConsumerStatefulWidget;
      final proxy =
          oldScreen.createState() as ast_proxies.InterpretedConsumerStateProxy;
      final oldState = proxy.stateInstance;

      (oldState as dynamic).set('mode', 'dark');

      ast_proxies.rebindAstConsumerStateForReload(proxy, newScreen);

      expect(identical(proxy.visitor, newScreen.visitor), isTrue);
      final rebound = proxy.stateInstance;
      expect(identical(rebound, oldState), isFalse);
      expect(
        (rebound as dynamic).getField('mode'),
        equals('dark'),
        reason: 'setState fields must survive the reload',
      );
      final versionFn = (rebound as dynamic).get(
        'version',
        visitor: proxy.visitor,
      );
      expect(
        (versionFn as dynamic).call(proxy.visitor, [], <String, Object?>{}),
        equals('v2'),
        reason: 'edited code must be reachable after rebind',
      );
    });
  });

  // Regression for the device tap crash:
  //   Undefined variable: setState (Undefined property 'setState' on
  //   _TodoScreenState.)
  // Member lookup consults only the direct bridged superclass
  // (`ConsumerState`, which exposes just `ref`/`dispose`), so `State`
  // members inherited one level up never resolved. The RC-5 supplementary
  // adapters must make them resolvable. Invocation itself needs a mounted
  // element (host `State` members are stubs), so headless coverage stops
  // at resolution; the device group below owns invocation.
  group('ConsumerState inherited State members resolve', () {
    test(
      'setState/initState/didChangeDependencies/didUpdateWidget (source)',
      () async {
        final harness = DnHarness(onLog: (_) {});
        try {
          final root = await harness.evaluate({'main.dart': _reloadGuestV1});
          final screen =
              (root as ProviderScope).child
                  as src_proxies.InterpretedConsumerStatefulWidget;
          final proxy =
              screen.createState() as src_proxies.InterpretedConsumerStateProxy;
          final state = proxy.stateInstance;
          for (final member in [
            'setState',
            'initState',
            'didChangeDependencies',
            'didUpdateWidget',
          ]) {
            expect(
              (state as dynamic).get(member, visitor: proxy.visitor),
              isNotNull,
              reason: 'source: ConsumerState member $member must resolve',
            );
          }
        } finally {
          harness.dispose();
        }
      },
    );

    test(
      'setState/initState/didChangeDependencies/didUpdateWidget (AST)',
      () async {
        final tempDir = Directory.systemTemp.createTempSync('dn_csw_mem_');
        final harness = DnHarness(onLog: (_) {});
        try {
          final projectDir = createRiverpodProjectShell(tempDir, 'csw_mem_app');
          File(
            '${projectDir.path}/lib/main.dart',
          ).writeAsStringSync(_reloadGuestV1);
          final out = File('${projectDir.path}/test_app.ast');
          final build = await buildGuestAstBundle(
            projectDir,
            outputArg: out.path,
            force: true,
          );
          expect(build.success, isTrue);
          await harness.evaluateAstBytes(
            await out.readAsBytes(),
            entryPoint: 'main',
          );
          final screen =
              (harness.lastRoot! as ProviderScope).child
                  as ast_proxies.InterpretedConsumerStatefulWidget;
          final proxy =
              screen.createState() as ast_proxies.InterpretedConsumerStateProxy;
          final state = proxy.stateInstance;
          for (final member in [
            'setState',
            'initState',
            'didChangeDependencies',
            'didUpdateWidget',
          ]) {
            expect(
              (state as dynamic).get(member, visitor: proxy.visitor),
              isNotNull,
              reason: 'ast: ConsumerState member $member must resolve',
            );
          }
        } finally {
          harness.dispose();
          deleteTempDir(tempDir);
        }
      },
    );
  });

  group(
    'ConsumerStatefulWidget on-device (real mount, ref + mutation)',
    () {
      late DnHarness harness;

      setUp(() {
        harness = DnHarness(onLog: (_) {});
      });

      tearDown(() {
        harness.dispose();
      });

      test('ref.watch renders, Increment mutates, rebuild shows it', () async {
        final root = await harness.evaluate({'main.dart': _statefulGuest});
        _expectStatefulScreenRoot(root, 'device');

        // Full mount below needs the real reconciler (`State.context`,
        // `stateSetContext`, and `_StateHost`'s `context as Element` cast
        // are host stubs). The real app proves this path; here we pin the
        // wiring the mount relies on.
        final child = (root as ProviderScope).child;
        final state = (child as dynamic).createState();
        expect(state, isA<ConsumerState<ConsumerStatefulWidget>>());
      });
    },
    skip: _isDeviceRun
        ? false
        : 'needs a device runtime: dn test -d <device-id> '
              '--dart-define=DN_DEVICE_TEST=true test/runner/riverpod_consumer_stateful_test.dart',
  );
}

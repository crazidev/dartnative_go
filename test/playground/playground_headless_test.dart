/// Headless coverage of the upstream `playground/` app.
///
/// The playground is the reference DartNative app: ~100 modules, five tabs and
/// ~50 registered routes, exercising every first-party plugin. This suite
/// proves the code *runs* in the analyzer-free interpreter (`tom_d4rt_ast`, the
/// engine `kUseAst` selects on device) without a mobile runtime:
///
///  1. **boot** — the real `lib/main.dart` evaluates and `runApp` captures the
///     shell (`PlaygroundHome`). That is the full boot path: plugin registrant,
///     Skia factories, SQLite pre-warm, Firebase/notifications setup (both
///     native and caught), ~50 `registerRoutes` calls, and the
///     SharedPreferences-backed theme restore.
///  2. **routes** — every route `main()` registered is built through its
///     captured `WidgetBuilder` and the resulting screen's `build(context)`
///     runs. This also proves the route-map coercion (interpreted closure →
///     native `WidgetBuilder`) works.
///  3. **tabs** — the shell's `build` runs and each of the five tab bodies is
///     built, which is where most non-routed demos (Lottie, media, graphics)
///     are constructed.
///
/// Native-only plugins are replaced by host fakes (`test/test_lab/fakes/`)
/// installed through `DnHarness.astBridgeOverrides` — the same policy as the
/// per-plugin suites: the fake proves bridge wiring + guest logic; the real FFI
/// call needs a device.
///
/// Run: `dn test test/playground/`
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/routes_bridge.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

import '../test_lab/fakes/fake_shared_preferences_ast.dart';

/// Minimal `BuildContext` for driving an interpreted `build(context)`.
class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Runs a screen's `build` without mounting it.
///
/// Interpreted widgets are native `StatefulWidget`/`StatelessWidget` subclasses
/// whose `build` is a real method, so `createState()` + `build(context)` runs
/// the guest code without an element tree or a render pass.
Widget _render(Widget widget, BuildContext context) {
  if (widget is StatefulWidget) {
    final state = widget.createState();
    return (state as dynamic).build(context) as Widget;
  }
  if (widget is StatelessWidget) {
    return (widget as dynamic).build(context) as Widget;
  }
  return widget;
}

/// Children of the layout widgets the playground's shell uses, so the tab
/// bodies can be reached from the built tree.
List<Widget> _childrenOf(Widget w) {
  if (w is Scaffold) return [?w.body];
  // Interpreted `InheritedWidget` subclasses are wrapped by
  // `InterpretedInheritedWidget`; the shell's theme wrapper is one.
  if (w is InheritedWidget) return [w.child];
  if (w is IndexedStack) return List<Widget>.of(w.children);
  if (w is Stack) return List<Widget>.of(w.children);
  if (w is Column) return List<Widget>.of(w.children);
  if (w is Row) return List<Widget>.of(w.children);
  if (w is Center) return [w.child];
  if (w is Padding) return [w.child];
  if (w is Container) return [?w.child];
  if (w is SafeArea) return [w.child];
  if (w is SingleChildScrollView) return [w.child];
  return const [];
}

/// Routes that cannot build headless yet, with the reason. Everything not
/// listed here MUST build — that is the regression guard.
///
/// Each entry names the runtime capability that is missing, not a playground
/// bug: the same screen runs on a device where the native side exists.
const _knownGaps = <String, String>{
  // `AnimationController(vsync: this)` from a State using
  // `SingleTickerProviderStateMixin`: needs a `TickerProvider` interface proxy
  // (there is none registered for the AST engine).
  '/chatgpt-picker': 'missing TickerProvider interface proxy',
  '/stickers-keyboard': 'missing TickerProvider interface proxy',
  // Interpreted `CustomPainter` subclasses passed to `CustomPaint` /
  // `CanvasSurface`: needs a `CustomPainter` interface proxy.
  '/live-text': 'missing CustomPainter interface proxy',
  '/text-rendering': 'missing CustomPainter interface proxy',
  '/canvas': 'missing CustomPainter interface proxy',
  // riverpod_kit `Signal` bridge exposes no `watch` method.
  '/state-store': 'riverpod_kit Signal.watch is not bridged',
  // `late` field initialized in `initState()`; this suite builds without
  // mounting, so initState never runs.
  '/storage-prefs': 'late field set in initState (not mounted)',
  '/storage-secure': 'late field set in initState (not mounted)',
  '/storage-cache': 'late field set in initState (not mounted)',
  '/storage-sqlite': 'late field set in initState (not mounted)',
  // `onTap: () => ...` inside a collection literal keeps the interpreted
  // function's `dynamic Function()` shape instead of a `VoidCallback`.
  '/material3-badges': 'VoidCallback coercion in a collection literal',
};

void main() {
  final playground = Directory('playground');
  late AstBuildResult build;
  late List<int> bytes;
  late FakeSharedPreferencesAstHost prefs;
  late AstInterpreterRunner runner;
  late Widget root;

  setUpAll(() async {
    if (!playground.existsSync()) {
      throw StateError(
        'playground/ missing — clone DartNative/dartnative into this repo',
      );
    }
    // Artifacts live in the repo (root filesystem), not the system temp dir:
    // /tmp is a small tmpfs on CI hosts and a 2 MB bundle plus the analyzer's
    // scratch space overflows it.
    final outDir = Directory('.dart_tool/playground_headless')
      ..createSync(recursive: true);
    build = await buildGuestAstBundle(
      playground,
      outputArg: File('${outDir.path}/playground_main.ast').absolute.path,
      force: true,
    );
    if (!build.success) {
      throw StateError('bundle build failed: ${build.error}');
    }
    bytes = await File('${outDir.path}/playground_main.ast').readAsBytes();

    prefs = FakeSharedPreferencesAstHost();
    runner = AstInterpreterRunner(onLog: (_) {});
    runner.initRunner();
    installFakeSharedPreferencesAst(prefs)(runner.runner!);
    root = await runner.evaluateAstBundleAs<Widget>(
      bytes,
      entryPoint: 'package:playground/main.dart',
      moduleFingerprints: build.moduleFingerprints,
    );
  });

  tearDownAll(() {
    runner.dispose();
  });

  test('boot: main() mounts the playground shell', () {
    expect(root, isNotNull, reason: 'runApp must capture a root widget');
    expect(
      root.runtimeType.toString(),
      contains('Interpreted'),
      reason:
          'root must be an interpreted widget proxy, got ${root.runtimeType}',
    );
    expect(
      D4rtRoutes.paths,
      isNotEmpty,
      reason: 'main() registers ~50 named routes; none were captured',
    );
  });

  test('routes: every registered route builds', () {
    final context = _FakeContext();
    final failures = <String>[];
    for (final entry in D4rtRoutes.routes.entries) {
      try {
        final screen = entry.value(context);
        _render(screen, context);
      } catch (error, stack) {
        failures.add(
          '${entry.key}: ${error.toString().split('\n').first}\n'
          '    ${stack.toString().split('\n').take(3).join('\n    ')}',
        );
      }
    }
    final unexpected = <String>[];
    for (final failure in failures) {
      final path = failure.split(':').first;
      if (!_knownGaps.containsKey(path)) unexpected.add(failure);
    }
    final covered = D4rtRoutes.routes.length - failures.length;
    // The playground's own smoke threshold: most routes must build, and no
    // route may fail for a reason we have not documented.
    expect(
      covered,
      greaterThanOrEqualTo(30),
      reason: 'only $covered/${D4rtRoutes.routes.length} routes built',
    );
    expect(
      unexpected,
      isEmpty,
      reason: 'undocumented route failures:\n${unexpected.join('\n')}',
    );
  });

  test('tabs: the shell builds and every tab body builds', () {
    final context = _FakeContext();
    final shell = _render(root, context);

    // Find the IndexedStack that holds the five tab bodies.
    final queue = <Widget>[shell];
    final tabBodies = <Widget>[];
    while (queue.isNotEmpty) {
      final node = queue.removeLast();
      if (node is IndexedStack) {
        tabBodies.addAll(node.children);
        continue;
      }
      queue.addAll(_childrenOf(node));
    }
    expect(
      tabBodies,
      isNotEmpty,
      reason: 'shell tree has no IndexedStack of tab bodies',
    );

    final failures = <String>[];
    for (final body in tabBodies) {
      final name = body.runtimeType.toString();
      try {
        _render(body, context);
      } catch (error, stack) {
        failures.add(
          '$name: ${error.toString().split('\n').first}\n'
          '    ${stack.toString().split('\n').take(3).join('\n    ')}',
        );
      }
    }
    expect(
      failures,
      isEmpty,
      reason: '${failures.length} tab bodies failed to build:\n'
          '${failures.join('\n')}',
    );
  });
}

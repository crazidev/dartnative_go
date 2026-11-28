/// Headless coverage of the upstream `dn-silly-benchmark` app.
///
/// The app is vendored under `silly_benchmark/` as a fixture — the bouncing
/// balls benchmark: every ball is a real native view in a `Stack`, driven by a
/// `Ticker`, with a HUD reading frame rate, CPU and RSS.
///
/// What it exercises that `playground/` does not:
///
///  * `Ticker(callback)..start()` constructed directly from a `State`, rather
///    than through `TickerProvider` / `AnimationController`;
///  * `DartNativePerformance.addFrameTimingCallback` + `Timer.periodic` from
///    `initState`, i.e. a guest that keeps a frame clock alive;
///  * `ProcessInfo.currentRss` read every sample (the `dart:io` bridge);
///  * `dart:ffi` `DynamicLibrary.process().lookupFunction` for the CPU clock —
///    the signature table in the `dart:ffi` stdlib bridge makes this resolve to
///    a real `clock()` on the host, so CPU% is a real number, not `n/a`;
///  * `LayoutBuilder` feeding live constraints into a child, and a
///    `ValueListenableBuilder`-driven HUD.
///
/// Run: `dn test test/silly_benchmark/`
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';
import 'package:tom_d4rt_ast/d4rt.dart' as ast;

/// Minimal `BuildContext` for driving an interpreted `build(context)`.
class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Shared context for the tree walk (interpreted stateless widgets are built
/// during traversal, and they need one).
final _context = _FakeContext();

/// Everything the guest printed. `BenchMetrics` logs one CSV line per sample,
/// which is the only externally visible signal that its clock is alive.
final _logs = <String>[];

/// The AST visitor, for calling a guest method directly.
late ast.InterpreterVisitor _visitor;

/// Mounts [widget] far enough to build it, and returns the state object so a
/// test can dispose it (the benchmark starts a `Ticker` and a `Timer.periodic`
/// in `initState`, so a mounted screen must be torn down or the test hangs).
///
/// Mirrors `playground_headless_test.dart`: `initState` and
/// `didChangeDependencies` run before `build`, because the benchmark starts its
/// metrics there.
(Object?, Widget) _mount(Widget widget, BuildContext context) {
  if (widget is StatefulWidget) {
    final state = widget.createState();
    (state as dynamic).initState();
    (state as dynamic).didChangeDependencies();
    return (state, (state as dynamic).build(context) as Widget);
  }
  if (widget is StatelessWidget) {
    return (null, (widget as dynamic).build(context) as Widget);
  }
  return (null, widget);
}

/// Disposes a mounted state, ignoring failures from members that need a
/// platform (the guest's `dispose` calls `SystemChrome`/`DartNativePerformance`).
void _unmount(Object? state) {
  if (state == null) return;
  try {
    (state as dynamic).dispose();
  } catch (_) {}
}

/// Every widget in [root]'s tree that is a [T], walking the layout widgets the
/// benchmark uses.
List<T> _find<T extends Widget>(Widget root) {
  final found = <T>[];
  final queue = <Widget>[root];
  final seen = <Widget>{};
  while (queue.isNotEmpty) {
    final node = queue.removeLast();
    if (!seen.add(node)) continue;
    if (node is T) found.add(node);
    queue.addAll(_childrenOf(node));
  }
  return found;
}

List<Widget> _childrenOf(Widget w) {
  // Interpreted `StatelessWidget` subclasses (`_Button`, `BenchHud`) have no
  // tree of their own until `build` runs. Building them here is safe: unlike a
  // `StatefulWidget` there is no lifecycle to dispose.
  if (w is StatelessWidget) {
    try {
      final built = (w as dynamic).build(_context) as Widget?;
      return [?built];
    } catch (_) {
      return const [];
    }
  }
  if (w is Scaffold) return [?w.body];
  if (w is Stack) return List<Widget>.of(w.children);
  if (w is Column) return List<Widget>.of(w.children);
  if (w is Row) return List<Widget>.of(w.children);
  if (w is Padding) return [w.child];
  if (w is Container) return [?w.child];
  if (w is SizedBox) return [?w.child];
  if (w is Center) return [w.child];
  if (w is Expanded) return [w.child];
  if (w is Flexible) return [w.child];
  if (w is Align) return [w.child];
  if (w is DecoratedBox) return [?w.child];
  if (w is Opacity) return [w.child];
  if (w is SafeArea) return [w.child];
  if (w is ClipRect) return [w.child];
  if (w is Offstage) return [w.child];
  if (w is GestureDetector) return [?w.child];
  if (w is Positioned) return [w.child];
  if (w is ColoredBox) return [?w.child];
  if (w is LayoutBuilder) {
    // The benchmark's only LayoutBuilder is the arena's constraint source.
    // Its builder cannot run without a layout pass, so the tree stops here.
    return const [];
  }
  return const [];
}

void main() {
  final app = Directory('silly_benchmark');
  late AstInterpreterRunner runner;
  late Widget root;

  setUpAll(() async {
    if (!app.existsSync()) {
      throw StateError(
        'silly_benchmark/ missing — clone '
        'https://github.com/Chinmay-KB/dn-silly-benchmark into this repo',
      );
    }
    final outDir = Directory('.dart_tool/silly_benchmark_headless')
      ..createSync(recursive: true);
    final build = await buildGuestAstBundle(
      app,
      outputArg: File('${outDir.path}/benchmark.ast').absolute.path,
      force: true,
    );
    if (!build.success) {
      throw StateError('bundle build failed: ${build.error}');
    }
    final bytes = await File('${outDir.path}/benchmark.ast').readAsBytes();

    runner = AstInterpreterRunner(onLog: _logs.add);
    runner.initRunner();
    root = await runner.evaluateAstBundleAs<Widget>(
      bytes,
      entryPoint: 'package:dn_silly_benchmark/main.dart',
      moduleFingerprints: build.moduleFingerprints,
    );
    // The visitor exists once the bundle has run.
    _visitor = runner.runner!.visitor!;
  });

  tearDownAll(() {
    runner.dispose();
  });

  test('boot: main() mounts the benchmark screen', () {
    expect(root, isNotNull, reason: 'runApp must capture a root widget');
    expect(
      root.runtimeType.toString(),
      contains('Interpreted'),
      reason: 'root must be an interpreted widget proxy, got ${root.runtimeType}',
    );
  });

  test('render: the screen builds with its HUD and controls', () {
    final context = _FakeContext();
    final (state, tree) = _mount(root, context);
    try {
      // Scaffold → Stack → arena (LayoutBuilder), HUD, and the button row.
      final stacks = _find<Stack>(tree);
      expect(stacks, isNotEmpty, reason: 'no Stack in the built screen');
      final rows = _find<Row>(tree);
      expect(rows, isNotEmpty, reason: 'no button row in the built screen');
      final layoutBuilders = _find<LayoutBuilder>(tree);
      expect(
        layoutBuilders,
        isNotEmpty,
        reason: 'the arena is fed by a LayoutBuilder; none built',
      );
      final texts = _find<Text>(tree);
      expect(
        texts.map((t) => t.data).whereType<String>().toList(),
        contains('+50 balls'),
        reason: 'the add-balls control did not build',
      );
    } finally {
      _unmount(state);
    }
  });

  test('arena: a layout pass produces an empty ball Stack', () {
    final context = _FakeContext();
    final (state, tree) = _mount(root, context);
    try {
      final builder = _find<LayoutBuilder>(tree).first;
      final arena = builder.builder(
        context,
        const BoxConstraints(maxWidth: 390, maxHeight: 700),
      );
      final (arenaState, arenaTree) = _mount(arena, context);
      try {
        expect(
          arenaTree,
          isA<SizedBox>(),
          reason: 'BallArena builds a sized Stack host',
        );
        final sized = arenaTree as SizedBox;
        expect(sized.width, 390);
        expect(sized.height, 700);
        expect(
          (sized.child as Stack?)?.children ?? const <Widget>[],
          isEmpty,
          reason: 'no balls are added until the +50 control is tapped',
        );
      } finally {
        _unmount(arenaState);
      }
    } finally {
      _unmount(state);
    }
  });

  test('metrics: the guest samples fps, RSS and CPU every 500 ms', () async {
    final context = _FakeContext();
    final (state, _) = _mount(root, context);
    try {
      // `BenchMetrics.start()` runs in `initState`: it registers a frame
      // callback, starts a 500 ms `Timer.periodic`, and logs one CSV line per
      // sample. Waiting two samples proves the whole clock path is live on the
      // host — the Dart timer, `ProcessInfo.currentRss` (the `dart:io`
      // bridge), and `clock()` through `dart:ffi` (the `dart:ffi` bridge).
      await Future<void>.delayed(const Duration(milliseconds: 1200));
    } finally {
      _unmount(state);
    }

    final samples = _logs.where((l) => l.startsWith('[bench] ')).toList();
    final csv = samples.where((l) => !l.contains('t_s,balls')).toList();
    expect(
      csv.length,
      greaterThanOrEqualTo(2),
      reason:
          'expected the benchmark to log at least two samples; got $samples',
    );

    final fields = csv.last.substring('[bench] '.length).split(',');
    expect(fields.length, 7, reason: 'unexpected CSV shape: ${csv.last}');
    final rssMb = double.parse(fields[4]);
    expect(
      rssMb,
      greaterThan(0),
      reason: 'ProcessInfo.currentRss must reach the guest; got ${fields[4]}',
    );
    expect(
      fields[3],
      isNot('na'),
      reason:
          'the dart:ffi clock() lookup must succeed on the host so CPU% is '
          'real, not "na" (sample: ${csv.last})',
    );
  });

  test('arena: the guest builds a ball as a circular native view', () {
    final context = _FakeContext();
    final (state, tree) = _mount(root, context);
    try {
      final arena = _find<LayoutBuilder>(tree).first.builder(
        context,
        const BoxConstraints(maxWidth: 390, maxHeight: 700),
      );
      final (arenaState, _) = _mount(arena, context);
      try {
        // `_newBall()` is the guest's own ball factory; `_tick` cannot run
        // here because it guards on `mounted`, and a state mounted outside an
        // element tree is never mounted (the same limit the playground suite
        // has).
        final instance = (arenaState as dynamic).d4rtInstance;
        final newBall = instance.klass.findInstanceMethod('_newBall');
        expect(newBall, isNotNull, reason: 'BallArena._newBall is missing');
        final ball = instance
            .bindMethodCached(newBall!)
            .call(_visitor, const [], const <String, Object?>{});
        // `_Ball.view` comes back as a bridged handle on the native widget.
        final rawView = (ball as dynamic).get('view');
        final view = ast.D4.unwrapAs<Widget>(rawView, visitor: _visitor);
        expect(view, isA<Container>(), reason: 'a ball must be a native view');
        final decoration = (view as Container).decoration as BoxDecoration;
        expect(decoration.shape, BoxShape.circle);
        expect(decoration.color, isNotNull);
      } finally {
        _unmount(arenaState);
      }
    } finally {
      _unmount(state);
    }
  });
}

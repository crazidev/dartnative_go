/// Source-engine (`tom_d4rt`) coverage of the vendored `dn-silly-benchmark`.
///
/// [silly_benchmark_headless_test.dart] drives the analyzer-free AST engine.
/// This suite boots the same app through [InterpreterRunner], which is where
/// the `dart:ffi` bridge matters most: the source engine rejects statically
/// undefined names at module load, so an unbridged `dart:ffi` made the whole
/// `bench/metrics.dart` module unloadable rather than throwing inside the
/// guest's `try`.
///
/// Run: `dn test test/silly_benchmark/silly_benchmark_source_test.dart`
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:test/test.dart';

import '../test_lab/harness.dart';

class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  final app = Directory('silly_benchmark');
  final logs = <String>[];
  late DnHarness harness;
  late Widget root;

  setUpAll(() async {
    if (!app.existsSync()) {
      throw StateError(
        'silly_benchmark/ missing — clone '
        'https://github.com/Chinmay-KB/dn-silly-benchmark into this repo',
      );
    }
    final files = <String, String>{};
    for (final entity in Directory('silly_benchmark/lib').listSync(
      recursive: true,
    )) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      files[entity.path.substring('silly_benchmark/lib/'.length)] =
          await entity.readAsString();
    }
    harness = DnHarness(
      mode: DnMode.source,
      packageName: 'dn_silly_benchmark',
      onLog: logs.add,
    );
    root = await harness.evaluate(files);
  });

  tearDownAll(() {
    harness.dispose();
  });

  test('boot: main() mounts the benchmark screen', () {
    expect(root, isNotNull);
    expect(
      root.runtimeType.toString(),
      contains('Interpreted'),
      reason: 'root must be an interpreted widget proxy, got ${root.runtimeType}',
    );
  });

  test('render: the screen builds and the metrics clock is live', () async {
    final context = _FakeContext();
    final state = (root as StatefulWidget).createState();
    try {
      (state as dynamic).initState();
      (state as dynamic).didChangeDependencies();
      final tree = (state as dynamic).build(context) as Widget;
      expect(tree, isA<Scaffold>());

      // Two 500 ms samples, as in the AST suite: proves the Dart timer,
      // `ProcessInfo.currentRss` and the `dart:ffi` `clock()` lookup all work
      // on this engine too.
      await Future<void>.delayed(const Duration(milliseconds: 1200));
    } finally {
      try {
        (state as dynamic).dispose();
      } catch (_) {}
    }

    final csv = logs
        .where((l) => l.startsWith('[bench] ') && !l.contains('t_s,balls'))
        .toList();
    expect(
      csv.length,
      greaterThanOrEqualTo(2),
      reason: 'expected benchmark samples; got $logs',
    );
    final fields = csv.last.substring('[bench] '.length).split(',');
    expect(fields.length, 7, reason: 'unexpected CSV shape: ${csv.last}');
    expect(double.parse(fields[4]), greaterThan(0), reason: 'RSS must be real');
    expect(
      fields[3],
      isNot('na'),
      reason: 'dart:ffi clock() must resolve on the source engine too',
    );
  });
}

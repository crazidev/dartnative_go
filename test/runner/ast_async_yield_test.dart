import 'dart:async';

import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;
import 'package:tom_ast_generator/tom_ast_generator.dart';

/// Interpreted async continuations used to be queued exclusively as microtasks
/// (`Future.microtask`), and every pending microtask drains before the embedder
/// regains control. A long chain of interpreted `await`s therefore starved the
/// embedder's event loop — on Flutter that means a frozen UI for the duration
/// of, say, a `dio` request.
///
/// `InterpretedFunction._scheduleStateMachineRun` now time-slices async work:
/// while one event-loop turn stays under
/// [ast.InterpretedFunction.asyncSliceBudgetMicros] continuations keep the
/// microtask fast path, and once the budget is spent the next continuation is
/// deferred to a zero-duration timer turn so the event loop can run.
///
/// This test drives an interpreted `await` chain and counts how many times a
/// host `Timer` gets to fire: with slicing disabled the chain never yields
/// (zero ticks), with slicing enabled the loop keeps turning.
void main() {
  const source = r'''
Future<String> main() async {
  var s = 0;
  for (var i = 0; i < 4000; i++) {
    await Future<void>.value();
    s += i;
  }
  return 'done $s';
}
''';

  Future<int> runChain(int budgetMicros) async {
    final bundle = await AstBundler().createFromSource(
      source,
      sourcePath: 'async_slice_yield_test.dart',
    );
    final previous = ast.InterpretedFunction.asyncSliceBudgetMicros;
    ast.InterpretedFunction.asyncSliceBudgetMicros = budgetMicros;
    var ticks = 0;
    final timer = Timer.periodic(const Duration(milliseconds: 1), (_) {
      ticks++;
    });
    try {
      final result = await ast.D4rtRunner().executeBundleAsAsync<String>(
        bundle,
        name: 'main',
      );
      expect(result, startsWith('done'));
    } finally {
      timer.cancel();
      ast.InterpretedFunction.asyncSliceBudgetMicros = previous;
    }
    return ticks;
  }

  test(
    'a long interpreted await chain yields to the event loop when sliced',
    () async {
      final unslicedTicks = await runChain(0);
      final slicedTicks = await runChain(4000);

      // Without slicing, an all-microtask continuation chain never lets the
      // host timer run.
      expect(unslicedTicks, 0);
      // With slicing, the event loop turns during the chain.
      expect(slicedTicks, greaterThan(1));
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}

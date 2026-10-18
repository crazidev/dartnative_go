import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart';

void main() {
  setUp(D4rtProfiler.reset);
  tearDown(D4rtProfiler.reset);

  test('aggregates measurements and reports longest spans first', () {
    D4rtProfiler.record('setup', 1200);
    D4rtProfiler.record('declarations', 400);
    D4rtProfiler.record('setup', 800);

    expect(
      D4rtProfiler.snapshot(),
      equals({
        'setup': {'us': 2000, 'ms': 2.0, 'n': 2},
        'declarations': {'us': 400, 'ms': 0.4, 'n': 1},
      }),
    );
    final report = D4rtProfiler.report().split('\n');
    expect(report, hasLength(3));
    expect(report[0], equals('D4rt init profile:'));
    expect(report[1], matches(RegExp(r'^  setup\s+2\.000 ms  \(2x\)$')));
    expect(
      report[2],
      matches(RegExp(r'^  declarations\s+0\.400 ms  \(1x\)$')),
    );
  });

  test('reports when no spans have been recorded', () {
    expect(
      D4rtProfiler.report(title: 'Empty profile'),
      equals('Empty profile: (no spans recorded)'),
    );
  });
}

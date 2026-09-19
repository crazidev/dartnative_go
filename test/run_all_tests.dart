import 'dart:async';
import 'dart:io';

import 'auto_import_parser_test.dart' as auto_import_test;
import 'ast_builder_test.dart' as ast_builder_test;
import 'ast_parity_test.dart' as ast_parity_test;
import 'bridge_config_parity_test.dart' as bridge_config_test;
import 'debug_controller_test.dart' as debug_test;
import 'granular_generational_remounting_test.dart' as granular_test;
import 'hot_reload_callback_test.dart' as callback_test;
import 'hot_reload_state_preservation_test.dart' as state_test;
import 'runtime_mode_test.dart' as runtime_mode_test;

class TestCase {
  final String name;
  final FutureOr<void> Function() run;
  final Duration timeout;

  TestCase({
    required this.name,
    required this.run,
    this.timeout = const Duration(seconds: 15),
  });
}

Future<void> main() async {
  final totalStopwatch = Stopwatch()..start();
  print('====================================================');
  print('🚀 Running DartNative Go Fast Unified Test Suite');
  print('====================================================\n');

  final tests = [
    TestCase(
      name: 'Granular Generational Remounting',
      run: () => granular_test.main(),
    ),
    TestCase(
      name: 'Auto Import Parser & Symbol Indexer',
      run: () => auto_import_test.main(),
    ),
    TestCase(
      name: 'DebugController & Breakpoints',
      run: () => debug_test.main(),
    ),
    TestCase(
      name: 'Hot Reload Module Invalidation',
      run: () => callback_test.main(),
    ),
    TestCase(
      name: 'Hot Reload State Preservation & Field Transfer',
      run: () => state_test.main(),
    ),
    TestCase(
      name: 'Runtime Mode (source default, AST opt-in)',
      run: () => runtime_mode_test.main(),
    ),
    TestCase(
      name: 'AST Parity (source vs tom_d4rt_ast logic)',
      run: () => ast_parity_test.main(),
    ),
    TestCase(
      name: 'AST Builder (entry/package/bundle)',
      run: () => ast_builder_test.main(),
    ),
    TestCase(
      name: 'Bridge Config Parity (buildkit vs buildkit_ast)',
      run: () => bridge_config_test.main(),
    ),
  ];

  int passed = 0;
  int failed = 0;
  final results = <String, String>{};

  for (final test in tests) {
    print('----------------------------------------------------');
    print('▶️  Starting: ${test.name}');
    final testSw = Stopwatch()..start();
    try {
      await Future.sync(test.run).timeout(
        test.timeout,
        onTimeout: () {
          throw TimeoutException('Test exceeded maximum duration of ${test.timeout.inSeconds}s');
        },
      );
      testSw.stop();
      passed++;
      results[test.name] = 'PASSED (${(testSw.elapsedMilliseconds / 1000).toStringAsFixed(2)}s)';
      print('✅ Passed in ${(testSw.elapsedMilliseconds / 1000).toStringAsFixed(2)}s');
    } catch (e, stack) {
      testSw.stop();
      failed++;
      results[test.name] = 'FAILED (${(testSw.elapsedMilliseconds / 1000).toStringAsFixed(2)}s)';
      print('❌ FAILED: ${test.name}');
      print('Error: $e');
      print('Stack: $stack');
    }
  }

  totalStopwatch.stop();
  final totalTime = (totalStopwatch.elapsedMilliseconds / 1000).toStringAsFixed(2);

  print('\n====================================================');
  print('📊 Test Suite Summary (${totalTime}s total)');
  print('====================================================');
  results.forEach((name, status) {
    print('  • $name: $status');
  });
  print('----------------------------------------------------');
  print('Result: $passed passed, $failed failed');
  print('====================================================\n');

  if (failed > 0) {
    exit(1);
  }
}

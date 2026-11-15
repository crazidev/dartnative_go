import 'package:test/test.dart';
import 'package:dartnative_go/src/runner/logger.dart';

void main() {
  group('DartGoLogger', () {
    final List<String> logs = [];

    setUp(() {
      logs.clear();
      DartGoLogger.verbose = false;
      DartGoLogger.logSink = (message, {level = 'INFO'}) {
        logs.add('[$level] $message');
      };
    });

    tearDown(() {
      DartGoLogger.logSink = null;
    });

    test('suppresses debug and bench logs when verbose is false', () {
      DartGoLogger.verbose = false;

      DartGoLogger.debug('Hidden debug message');
      DartGoLogger.bench('TestTag', 'Heavy task', 150, {
        'step1': 50,
        'step2': 100,
      });

      expect(logs, isEmpty);
    });

    test('emits debug and bench logs when verbose is true', () {
      DartGoLogger.verbose = true;

      DartGoLogger.debug('Visible debug message', tag: 'UnitTest');
      DartGoLogger.bench('TestTag', 'Heavy task', 150, {
        'step1': 50,
        'step2': 100,
      });

      expect(logs.length, equals(2));
      expect(logs[0], contains('[UnitTest] Visible debug message'));
      expect(
        logs[1],
        contains(
          '[TestTag] [TIME] Heavy task ready in 150ms (step1=50ms, step2=100ms)',
        ),
      );
    });

    test('always emits info, warn, error regardless of verbose', () {
      DartGoLogger.verbose = false;

      DartGoLogger.info('Info notice');
      DartGoLogger.warn('Warning notice', tag: 'Security');
      DartGoLogger.error('Failure notice');

      expect(logs.length, equals(3));
      expect(logs[0], contains('Info notice'));
      expect(logs[1], contains('[Security] ! Warning notice'));
      expect(logs[2], contains('[ERROR] Failure notice'));
    });

    test(
      'reload logs single line when not verbose and full details when verbose',
      () {
        DartGoLogger.verbose = false;
        DartGoLogger.reload(
          mode: 'Source',
          totalMs: 45,
          timings: {'fetch': 10, 'track': 5, 'eval': 30, 'remount': 0},
        );

        expect(logs.length, equals(1));
        expect(logs[0], equals('[INFO] [RELOAD] Source finished in 45ms'));

        logs.clear();
        DartGoLogger.verbose = true;
        DartGoLogger.reload(
          mode: 'AST',
          totalMs: 12,
          timings: {'fetch': 2, 'track': 0, 'eval': 10, 'remount': 0},
        );

        expect(logs.length, equals(1));
        expect(
          logs[0],
          equals(
            '[INFO] [RELOAD] AST finished in 12ms (fetch=2ms, track=0ms, eval=10ms, remount=0ms)',
          ),
        );
      },
    );

    test('toggleVerbose flips boolean and returns new state', () {
      DartGoLogger.verbose = false;
      expect(DartGoLogger.toggleVerbose(), isTrue);
      expect(DartGoLogger.verbose, isTrue);

      expect(DartGoLogger.toggleVerbose(), isFalse);
      expect(DartGoLogger.verbose, isFalse);
    });
  });
}

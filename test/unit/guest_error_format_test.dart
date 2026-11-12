import 'package:dartnative_go/src/runner/guest_error_format.dart';
import 'package:dartnative_go/src/runner/logger.dart';
import 'package:test/test.dart';

void main() {
  group('formatGuestError', () {
    test('splits a message from a stack embedded in the error text', () {
      final combined =
          'Runtime Error: Text expects at least 1 argument(s), got 0\n'
          '#0      _PluginsScreenState.build '
          '(package:example/plugins/plugins_screen.dart:75:38)';

      final formatted = formatGuestError(combined, null);
      expect(
        formatted.message,
        'Runtime Error: Text expects at least 1 argument(s), got 0',
      );
      expect(formatted.stack, contains('_PluginsScreenState.build'));
      expect(formatted.message, isNot(contains('#0')));
    });

    test('prefers the separately reported stack', () {
      final reported = StackTrace.fromString(
        '#0      main (package:example/main.dart:3:1)',
      );
      final formatted = formatGuestError(
        'Runtime Error: boom\n#0      old (package:example/old.dart:1:1)',
        reported,
      );
      expect(formatted.message, 'Runtime Error: boom');
      expect(formatted.stack, contains('main (package:example/main.dart:3:1)'));
      expect(formatted.stack, isNot(contains('old.dart')));
    });

    test('keeps a multi-line message when it carries no frames', () {
      final formatted = formatGuestError('first line\nsecond line', null);
      expect(formatted.message, 'first line\nsecond line');
      expect(formatted.stack, isNull);
    });

    test('falls back to the embedded stack when none is reported', () {
      final formatted = formatGuestError(
        'Runtime Error: x\n#0      a (package:example/a.dart:1:1)',
        null,
      );
      expect(formatted.message, 'Runtime Error: x');
      expect(formatted.stack, contains('a.dart'));
    });

    test('single-line errors have no stack', () {
      final formatted = formatGuestError('plain failure', null);
      expect(formatted.message, 'plain failure');
      expect(formatted.stack, isNull);
    });
  });

  group('parseStackFrames', () {
    test('splits numbered frames into member and location', () {
      final frames = parseStackFrames(
        '#0      _PluginsScreenState.build '
        '(package:example/plugins/plugins_screen.dart:75:38)\n'
        '#1      InterpretedStateProxy.build '
        '(package:dartnative_go/src/interpreter/widget_proxies.dart:212:5)',
      );

      expect(frames, hasLength(2));
      expect(frames[0].index, 0);
      expect(frames[0].gutter, '#0');
      expect(frames[0].member, '_PluginsScreenState.build');
      expect(
        frames[0].location,
        'package:example/plugins/plugins_screen.dart:75:38',
      );
      expect(frames[0].isGuest, isTrue);

      expect(frames[1].index, 1);
      expect(frames[1].isGuest, isFalse, reason: 'host package is dimmed');
    });

    test('keeps unnumbered lines as frames', () {
      final frames = parseStackFrames('<asynchronous suspension>');
      expect(frames, hasLength(1));
      expect(frames.single.index, isNull);
      expect(frames.single.gutter, '');
      expect(frames.single.member, '<asynchronous suspension>');
      expect(frames.single.location, isNull);
      expect(frames.single.hasLocation, isFalse);
    });

    test('treats dart: frames as non-guest', () {
      final frames = parseStackFrames(
        '#2      _rootRun (dart:async/zone.dart:1:1)',
      );
      expect(frames.single.isGuest, isFalse);
    });

    test('tolerates members containing parentheses', () {
      final frames = parseStackFrames(
        '#3      foo.<anonymous closure> (package:example/main.dart:9:2)',
      );
      expect(frames.single.member, 'foo.<anonymous closure>');
      expect(frames.single.location, 'package:example/main.dart:9:2');
    });

    test('dedupes consecutive identical lines', () {
      final line = '#0      a (package:example/a.dart:1:1)';
      final frames = parseStackFrames('$line\n$line\n$line');
      expect(frames, hasLength(1));
    });

    test('returns empty for null or blank input', () {
      expect(parseStackFrames(null), isEmpty);
      expect(parseStackFrames('   \n\n '), isEmpty);
    });

    test('singleLine reproduces the classic frame form', () {
      final frames = parseStackFrames(
        '#0      _PluginsScreenState.build '
        '(package:example/plugins/plugins_screen.dart:75:38)',
      );
      expect(
        frames.single.singleLine,
        '_PluginsScreenState.build '
        '(package:example/plugins/plugins_screen.dart:75:38)',
      );
    });
  });

  group('buildCopyText', () {
    test('includes the message and every frame', () {
      final text = buildCopyText(
        title: 'Unhandled Exception',
        message: 'Runtime Error: boom',
        stack:
            '#0      _PluginsScreenState.build '
            '(package:example/plugins/plugins_screen.dart:75:38)\n'
            '#1      main (package:example/main.dart:3:1)',
      );

      expect(text, startsWith('Unhandled Exception: Runtime Error: boom'));
      expect(text, contains('\n\nStack trace:\n'));
      expect(
        text,
        contains(
          '#0  _PluginsScreenState.build '
          '(package:example/plugins/plugins_screen.dart:75:38)',
        ),
      );
      expect(text, contains('#1  main (package:example/main.dart:3:1)'));
      // One line per frame, so it pastes cleanly into an editor.
      expect(text.split('\n').length, 5);
    });

    test('omits the trace section when there is no stack', () {
      final text = buildCopyText(
        title: 'Unhandled Exception',
        message: 'plain failure',
      );
      expect(text, 'Unhandled Exception: plain failure');
      expect(text, isNot(contains('Stack trace')));
    });
  });

  group('logGuestError', () {
    late List<String> captured;

    setUp(() {
      captured = [];
      DartGoLogger.logSink = (message, {level = 'INFO'}) {
        captured.add('$level|$message');
      };
    });

    tearDown(() {
      DartGoLogger.logSink = null;
    });

    test('logs the failure once, message first and trace beneath', () {
      final error = Exception(
        'Runtime Error: Text expects at least 1 argument(s), got 0',
      );
      final stack = StackTrace.fromString(
        '#0      _PluginsScreenState.build '
        '(package:example/plugins/plugins_screen.dart:75:38)',
      );

      logGuestError(error, stack);

      expect(captured, hasLength(1), reason: 'one CLI entry per failure');
      final entry = captured.single;
      expect(entry, startsWith('ERROR|'));
      final lines = entry.split('\n');
      // Message first, trace under it.
      expect(lines.first, contains('Text expects at least 1 argument(s)'));
      expect(lines[1], startsWith('#0'));
      expect(lines[1], contains('plugins_screen.dart:75:38'));
      // The frames must not be repeated inside the message line.
      expect(lines.first, isNot(contains('#0')));
    });
  });

  group('summarizeGuestError', () {
    test('strips host, interpreter and bridge framing', () {
      const raw =
          "Unhandled Exception: Guest runtime error: Runtime Error: Native "
          "error during bridged constructor '' for class 'Text': Argument "
          'Error: Text expects at least 1 argument(s), got 0';

      final summary = summarizeGuestError(raw);

      expect(summary.type, 'Argument Error');
      expect(
        summary.message,
        'Text expects at least 1 argument(s), got 0',
        reason: 'the surfaces show the cause, not how it travelled',
      );
    });

    test('strips the default bridged constructor wrapper', () {
      const raw =
          'Guest runtime error: Runtime Error: Native error during default '
          "bridged constructor for 'TextField': Argument Error: Invalid "
          'parameter "controller": expected TextEditingController?, got '
          'LateVariable';

      final summary = summarizeGuestError(raw);

      expect(summary.type, 'Argument Error');
      expect(
        summary.message,
        'Invalid parameter "controller": expected TextEditingController?, got '
        'LateVariable',
        reason: 'the cause keeps its own colon',
      );
    });

    test('reads a Dart-style type prefix', () {
      final summary = summarizeGuestError(
        'Hot Reload Error: StateError: Bad state: No element',
      );

      expect(summary.type, 'StateError');
      expect(summary.message, 'Bad state: No element');
    });

    test('reads a lowercase-second-word type', () {
      final summary = summarizeGuestError(
        'Guest failed to start: Runtime Error: Bad state: boom',
      );

      expect(summary.type, 'Bad state');
      expect(summary.message, 'boom');
    });

    test('keeps a message with no type intact', () {
      const raw =
          'Guest runtime error: type \'int\' is not a subtype of type '
          "'String'";
      final summary = summarizeGuestError(raw);

      expect(summary.type, isNull);
      expect(
        summary.message,
        "type 'int' is not a subtype of type 'String'",
      );
    });

    test('does not mistake a sentence for a type', () {
      final summary = summarizeGuestError(
        'Runtime Error: Invalid parameter "controller": expected A, got B',
      );

      expect(summary.type, isNull);
      expect(summary.message, contains('Invalid parameter'));
    });

    test('displayMessage falls back to the type', () {
      final summary = summarizeGuestError('Runtime Error: Argument Error:');

      expect(summary.displayMessage, isNotEmpty);
    });
  });
}

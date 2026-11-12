/// Presentation helpers for guest (interpreted) errors.
library;

import 'logger.dart';

/// One parsed frame of a guest stack trace (`#N` gutter + member + location).
///
/// [raw] is kept verbatim as the fallback for anything unparsable.
class StackFrame {
  /// The frame number (`#0` → `0`), or null when the line had none.
  final int? index;

  /// The member that threw, e.g. `_PluginsScreenState.build`.
  final String member;

  /// `package:example/plugins/plugins_screen.dart:75:38`, or null for frames
  /// such as `<asynchronous suspension>`.
  final String? location;

  /// True for the guest project's own code, false for interpreter, framework
  /// and `dart:` internals — those are dimmed so the user's frames stand out.
  final bool isGuest;

  /// The original line, used for copying and as a last-resort label.
  final String raw;

  const StackFrame({
    required this.index,
    required this.member,
    required this.location,
    required this.isGuest,
    required this.raw,
  });

  /// `#0` for numbered frames, empty for unnumbered ones.
  String get gutter => index == null ? '' : '#$index';

  /// What to show when there is no [location] to print beneath the member.
  bool get hasLocation => location != null && location!.isNotEmpty;

  /// Single-line form used by the clipboard payload.
  String get singleLine {
    final label = member.isEmpty ? raw : member;
    return hasLocation ? '$label ($location)' : label;
  }
}

/// Prefixes of the host/interpreter packages that are dimmed in the viewer.
const List<String> _kFrameworkPrefixes = [
  'package:dartnative/',
  'package:dartnative_go/',
  'package:tom_d4rt',
  'package:tom_ast',
  'package:flutter/',
  'dart:',
];

/// Splits a stack trace into frames.
///
/// Unnumbered lines (`<asynchronous suspension>`, wrapped messages) still
/// become frames — with a null [StackFrame.index] — so nothing is silently
/// dropped. The result is empty when [stack] has no usable content.
List<StackFrame> parseStackFrames(String? stack) {
  if (stack == null) return const [];
  final frames = <StackFrame>[];
  String? previousRaw;

  for (final line in stack.split('\n')) {
    final trimmed = line.trimRight();
    if (trimmed.trim().isEmpty) continue;
    // Consecutive duplicates appear when an error's `toString()` already
    // carried frames and the runner reported the same trace.
    if (trimmed == previousRaw) continue;
    previousRaw = trimmed;

    frames.add(_parseLine(trimmed));
  }
  return frames;
}

StackFrame _parseLine(String line) {
  final match = RegExp(r'^#(\d+)\s+(.*)$').firstMatch(line);
  final index = match == null ? null : int.tryParse(match.group(1)!);
  var rest = (match == null ? line : match.group(2)!).trim();

  String? location;
  // `member (location)` — the location is the last parenthesised group, which
  // tolerates members that themselves contain parentheses.
  if (rest.endsWith(')')) {
    final open = rest.lastIndexOf(' (');
    if (open > 0) {
      location = rest.substring(open + 2, rest.length - 1).trim();
      rest = rest.substring(0, open).trim();
    }
  }

  return StackFrame(
    index: index,
    member: rest,
    location: (location == null || location.isEmpty) ? null : location,
    isGuest: location != null && !_kFrameworkPrefixes.any(location.startsWith),
    raw: line,
  );
}

/// Builds the clipboard/terminal payload for an error: the message followed by
/// the trace, one frame per line.
///
/// The viewer renders frames in a two-column layout, but a copied trace must
/// stay paste-able into an editor or an issue, so it is plain text here.
String buildCopyText({
  required String title,
  required String message,
  String? stack,
}) {
  final frames = parseStackFrames(stack);
  final buffer = StringBuffer()
    ..writeln(message.trim().isEmpty ? title : '$title: ${message.trim()}');
  if (frames.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('Stack trace:');
    for (final frame in frames) {
      final gutter = frame.gutter;
      buffer.writeln(
        gutter.isEmpty ? frame.singleLine : '$gutter  ${frame.singleLine}',
      );
    }
  }
  return buffer.toString().trimRight();
}

/// Splits a guest error into a message and a stack without duplicating frames.
///
/// Interpreters embed the guest stack in `toString()` *and* report it
/// separately — first line is the message; reported stack wins, embedded as
/// fallback.
({String message, String? stack}) formatGuestError(
  Object error,
  StackTrace? stack,
) {
  var message = error.toString();
  String? embedded;
  final newline = message.indexOf('\n');
  if (newline >= 0) {
    final tail = message.substring(newline + 1).trim();
    if (tail.startsWith('#') || tail.contains('package:')) {
      embedded = tail;
      message = message.substring(0, newline).trimRight();
    }
  }
  final reported = stack?.toString().trim();
  final frames = (reported != null && reported.isNotEmpty)
      ? reported
      : embedded;
  return (message: message, stack: frames);
}

/// Prefixes added by the host, the interpreter and the framework *around* the
/// failure. They describe how the exception travelled, not what went wrong, so
/// the error surfaces strip them and show the exception itself.
const List<String> _kErrorNoisePrefixes = [
  'Unhandled Exception:',
  'Unhandled exception:',
  'Guest runtime error:',
  'Guest failed to start:',
  'Interpreter Error:',
  'Hot Reload Error:',
  'Hot Restart Error:',
  'Runtime Error:',
  'Runtime Exception:',
  'Exception:',
];

/// Bridge wrappers that only say which bridged member threw. The inner message
/// (the actual failure) is what the user needs.
final List<RegExp> _kBridgeWrapperPatterns = [
  // Native error during bridged constructor '' for class 'Text': <cause>
  RegExp(r'''^Native error during bridged constructor\b[^:]*:\s*'''),
  // Native error during default bridged constructor for 'TextField': <cause>
  RegExp(r'''^Native error during default bridged constructor\b[^:]*:\s*'''),
  RegExp(r'''^Native error in bridged superclass \w+\b[^:]*:\s*'''),
  RegExp(r'''^Native error during bridged \w+\b[^:]*:\s*'''),
  // Any remaining bridge framing, e.g. "Native error while ...".
  RegExp(r'''^Native error\b[^:]*:\s*'''),
];

/// Matches an exception type name before a colon: `Argument Error`,
/// `StateError`, `Bad state`, `LateInitializationError`.
///
/// Deliberately strict — no quotes, punctuation or long sentences — so a
/// message like `Invalid parameter "controller": expected …` keeps its colon
/// instead of being read as a type.
final RegExp _kErrorTypePattern = RegExp(
  r'^[A-Z][A-Za-z0-9_]*(?: [A-Za-z][A-Za-z0-9_]*){0,3}$',
);

/// A guest failure reduced to what the user needs: the exception type and the
/// message, with the host/interpreter framing removed.
class GuestErrorSummary {
  /// The exception type, e.g. `Argument Error`; null when the message does not
  /// name one.
  final String? type;

  /// The failure itself, e.g. `Text expects at least 1 argument(s), got 0`.
  final String message;

  const GuestErrorSummary({required this.type, required this.message});

  /// What the error surface shows as the headline.
  String get displayMessage =>
      message.trim().isEmpty ? (type ?? 'Unknown error') : message.trim();

  @override
  String toString() => type == null ? message : '$type: $message';
}

/// Removes the host/interpreter framing from [message], keeping the cause.
String stripGuestErrorNoise(String message) {
  var text = message.trim();
  // Loop because the layers stack: `Guest runtime error: Runtime Error:
  // Native error during bridged constructor …: Argument Error: …`.
  for (var guard = 0; guard < 12; guard++) {
    var changed = false;
    for (final prefix in _kErrorNoisePrefixes) {
      if (text.startsWith(prefix)) {
        text = text.substring(prefix.length).trimLeft();
        changed = true;
      }
    }
    for (final pattern in _kBridgeWrapperPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        text = text.substring(match.end).trimLeft();
        changed = true;
      }
    }
    if (!changed) break;
  }
  return text.trim();
}

/// Reduces a guest error message to its exception type and cause.
///
/// ```text
/// Unhandled Exception: Guest runtime error: Runtime Error: Native error during
/// bridged constructor '' for class 'Text': Argument Error: Text expects at
/// least 1 argument(s), got 0
/// ```
/// becomes type `Argument Error`, message `Text expects at least 1 argument(s),
/// got 0`.
GuestErrorSummary summarizeGuestError(String message) {
  final text = stripGuestErrorNoise(message);
  final separator = text.indexOf(': ');
  if (separator > 0) {
    final candidate = text.substring(0, separator).trim();
    final rest = text.substring(separator + 2).trim();
    if (rest.isNotEmpty && _kErrorTypePattern.hasMatch(candidate)) {
      return GuestErrorSummary(type: candidate, message: rest);
    }
  }
  return GuestErrorSummary(type: null, message: text);
}

/// Reports one guest failure to the CLI: message first, trace beneath.
///
/// Single logging path for guest exceptions — callers format via
/// [formatGuestError]; the error view only displays.
void logGuestError(Object error, StackTrace? stack) {
  final formatted = formatGuestError(error, stack);
  final frames = formatted.stack;
  DartGoLogger.error(
    formatted.message,
    null,
    frames == null ? null : StackTrace.fromString(frames),
  );
}

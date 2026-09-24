/// Centralized logger for DartNative Go runtime, CLI, and interpreters.
///
/// Automatically checks [verbose] mode internally, removing the need for callers
/// to write manual `if (verbose)` / `else` branch checks.
class DartGoLogger {
  static bool verbose = false;

  /// Optional log sink (e.g. WebSocket connection to relay device logs to CLI).
  static void Function(String message, {String level})? logSink;

  /// Toggles verbose mode and returns the new value.
  static bool toggleVerbose() {
    verbose = !verbose;
    return verbose;
  }

  /// Logs general informational messages (always output).
  static void info(String message) {
    _output(message, level: 'INFO');
  }

  /// Logs verbose-only diagnostic messages.
  /// Automatically suppressed when [verbose] is `false`.
  static void debug(String message, {String? tag}) {
    if (!verbose) return;
    final prefix = tag != null ? '[$tag] ' : '';
    _output('$prefix$message', level: 'DEBUG');
  }

  /// Logs benchmark and timing telemetry.
  /// Automatically suppressed when [verbose] is `false`.
  static void bench(
    String tag,
    String operation,
    int totalMs, [
    Map<String, dynamic>? breakdown,
  ]) {
    if (!verbose) return;
    final breakdownStr = breakdown != null && breakdown.isNotEmpty
        ? ' (${breakdown.entries.map((e) => '${e.key}=${e.value}${e.value is int ? 'ms' : ''}').join(', ')})'
        : '';
    _output('[$tag] ⏱️ $operation ready in ${totalMs}ms$breakdownStr', level: 'BENCH');
  }

  /// Logs hot reload duration and step breakdowns.
  /// When not verbose, outputs a concise single-line confirmation.
  /// When verbose, includes the full millisecond breakdown.
  static void reload({
    required String mode,
    required int totalMs,
    required Map<String, int> timings,
  }) {
    final details = timings.entries.map((e) => '${e.key}=${e.value}ms').join(', ');
    final msg = verbose
        ? '🚀 [Hot Reload] $mode finished in ${totalMs}ms ($details)'
        : '🚀 [Hot Reload] $mode finished in ${totalMs}ms';
    _output(msg, level: 'INFO');
  }

  /// Logs warnings (always output).
  static void warn(String message, {String? tag}) {
    final prefix = tag != null ? '[$tag] ⚠️ ' : '⚠️ ';
    _output('$prefix$message', level: 'WARN');
  }

  /// Logs error messages and optional stack traces (always output).
  ///
  /// An error is relayed to the CLI with a short stack even when verbose is
  /// off: the device screen shows the message but not where it came from, so a
  /// trimmed trace is what makes a guest failure diagnosable from the terminal.
  /// Verbose mode sends the whole trace.
  static void error(String message, [dynamic err, StackTrace? stack]) {
    final msg = err != null ? '$message: $err' : message;
    _output('🔴 $msg', level: 'ERROR');
    if (stack == null) return;
    final lines = '$stack'.split('\n');
    _output(
      verbose ? '$stack' : lines.take(8).join('\n'),
      level: 'ERROR',
    );
  }

  static void _output(String message, {String level = 'INFO'}) {
    // ignore: avoid_print
    print(message);
    logSink?.call(message, level: level);
  }
}

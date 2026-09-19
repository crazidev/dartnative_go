import 'dart:async';
import 'package:tom_d4rt/d4rt.dart';

/// Represents a source line breakpoint.
class Breakpoint {
  final String file;
  final int line;
  int hitCount;

  Breakpoint({required this.file, required this.line, this.hitCount = 0});

  /// Normalizes a file identifier (e.g., 'guest_app/reset_button.dart' or 'reset_button.dart')
  /// to its base file name for resilient matching.
  String get normalizedFile {
    final clean = file.replaceAll(r'\', '/');
    return clean.contains('/') ? clean.split('/').last : clean;
  }

  String get key => '$normalizedFile:$line';

  Map<String, dynamic> toJson() => {
    'file': file,
    'line': line,
    'hitCount': hitCount,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Breakpoint &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'Breakpoint($file:$line, hits: $hitCount)';
}

/// Event emitted when a breakpoint or `debugger()` statement is hit.
class BreakpointHitEvent {
  final String? file;
  final int? line;
  final String? message;
  final Map<String, String> variables;
  final DateTime timestamp;

  BreakpointHitEvent({
    this.file,
    this.line,
    this.message,
    this.variables = const {},
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'file': file,
    'line': line,
    'message': message,
    'variables': variables,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// Central controller for DartNative interpreted debugging.
///
/// Features:
/// 1. Programmatic breakpoints via `debugger([message])` or `breakpoint([message])`.
/// 2. Line breakpoints managed dynamically from dev server or IDE.
/// 3. Native IDE breakpoint triggers via `dart:developer.debugger()`.
/// 4. Execution suspension (`Completer<void>`) with interactive resume.
/// 5. Snapshotting variables from the active [D4rt] interpreter.
class DebugController {
  static final DebugController _instance = DebugController._internal();
  factory DebugController() => _instance;
  DebugController._internal();

  /// Active line breakpoints indexed by 'file:line'
  final Map<String, Breakpoint> _breakpoints = {};

  /// Whether breakpoints should pause execution until resumed.
  bool pauseOnHit = true;

  /// Whether to trigger native Dart VM developer.debugger() (SIGTRAP/DAP break).
  /// Defaults to false so the IDE does not intercept with host engine files.
  bool enableVmDebugger = false;

  /// Currently active breakpoint event if paused.
  BreakpointHitEvent? currentHit;

  /// Notifier for breakpoint state changes (allows UI overlay and barrier).
  final List<void Function(BreakpointHitEvent? hit)> _hitListeners = [];

  void addHitListener(void Function(BreakpointHitEvent? hit) listener) =>
      _hitListeners.add(listener);

  void removeHitListener(void Function(BreakpointHitEvent? hit) listener) =>
      _hitListeners.remove(listener);

  void _notifyHit(BreakpointHitEvent? hit) {
    currentHit = hit;
    for (final l in List.of(_hitListeners)) {
      l(hit);
    }
  }

  /// Active pause completer when execution is halted at a breakpoint.
  Completer<void>? _pauseCompleter;

  /// Callback to notify host or WebSocket transport of breakpoint hits.
  void Function(BreakpointHitEvent event)? onBreakpointHit;

  /// Callback to log debugger output to host/console.
  void Function(String message)? onLog;

  /// Reference to active interpreter for variable inspection.
  D4rt? activeInterpreter;

  /// Returns an unmodifiable list of active breakpoints.
  List<Breakpoint> get breakpoints =>
      _breakpoints.values.toList(growable: false);

  /// Whether execution is currently paused at a breakpoint.
  bool get isPaused => _pauseCompleter != null && !_pauseCompleter!.isCompleted;

  /// Awaits until execution is resumed if currently paused.
  Future<void> waitIfPaused() {
    if (isPaused) {
      return _pauseCompleter!.future;
    }
    return Future.value();
  }

  /// Normalizes a file path to its simple filename for consistent matching.
  static String normalizeFileName(String path) {
    final clean = path.replaceAll(r'\', '/');
    return clean.contains('/') ? clean.split('/').last : clean;
  }

  /// Adds a line breakpoint.
  void addBreakpoint(String file, int line) {
    final bp = Breakpoint(file: file, line: line);
    _breakpoints[bp.key] = bp;
    _log('📌 [Debugger] Breakpoint added at ${bp.key}');
  }

  /// Removes a line breakpoint.
  void removeBreakpoint(String file, int line) {
    final key = '${normalizeFileName(file)}:$line';
    if (_breakpoints.remove(key) != null) {
      _log('🗑️ [Debugger] Breakpoint removed at $key');
    }
  }

  /// Replaces all active breakpoints with a new set.
  void setBreakpoints(List<Map<String, dynamic>> list) {
    _breakpoints.clear();
    for (final item in list) {
      final file = item['file']?.toString();
      final line = item['line'] is int
          ? item['line'] as int
          : int.tryParse(item['line']?.toString() ?? '');
      if (file != null && line != null) {
        addBreakpoint(file, line);
      }
    }
  }

  /// Clears all active breakpoints.
  void clearBreakpoints() {
    _breakpoints.clear();
    _log('🧹 [Debugger] All breakpoints cleared.');
  }

  /// Resets all controller state, breakpoints, listeners, and resume completers.
  void reset() {
    clearBreakpoints();
    pauseOnHit = false;
    enableVmDebugger = false;
    currentHit = null;
    activeInterpreter = null;
    onBreakpointHit = null;
    onLog = null;
    _hitListeners.clear();
    if (isPaused) {
      _pauseCompleter?.complete();
      _pauseCompleter = null;
    }
  }

  /// Checks if a line breakpoint is set for the given file and line.
  bool hasBreakpoint(String file, int line) {
    final key = '${normalizeFileName(file)}:$line';
    return _breakpoints.containsKey(key);
  }

  /// Returns active breakpoint lines for a specific file.
  Set<int> getBreakpointLinesForFile(String file) {
    final target = normalizeFileName(file);
    final lines = <int>{};
    for (final bp in _breakpoints.values) {
      if (bp.normalizedFile == target) {
        lines.add(bp.line);
      }
    }
    return lines;
  }

  /// Inspects variables from the active interpreter's environment.
  Map<String, String> inspectVariables() {
    final vars = <String, String>{};
    try {
      final envState = activeInterpreter?.getEnvironmentState();
      if (envState != null) {
        for (final v in envState.variables) {
          vars[v.name] = v.isNull ? 'null' : '(${v.valueType})';
        }
      }
    } catch (_) {}
    return vars;
  }

  /// Programmatic breakpoint handler (invoked by `debugger([message])` or `breakpoint([message])`).
  Future<void> handleDebuggerCall([String? message]) async {
    final vars = inspectVariables();
    final event = BreakpointHitEvent(
      message: message ?? 'debugger() invoked',
      variables: vars,
    );

    _log('🛑 [DEBUGGER] Execution paused: ${event.message}');
    if (vars.isNotEmpty) {
      _log(
        '   Variables: ${vars.entries.map((e) => '${e.key}=${e.value}').join(', ')}',
      );
    }

    // 1. Notify UI and WebSocket listeners immediately so barrier & banner appear on device
    if (pauseOnHit) {
      if (_pauseCompleter == null || _pauseCompleter!.isCompleted) {
        _pauseCompleter = Completer<void>();
      }
    }
    _notifyHit(event);
    onBreakpointHit?.call(event);

    if (pauseOnHit) {
      await _waitForResume();
    }
  }

  /// Line breakpoint handler (invoked by injected `__debugBreakpoint(file, line)` calls).
  Future<void> handleLineBreakpoint(String file, int line) async {
    final key = '${normalizeFileName(file)}:$line';
    final bp = _breakpoints[key];
    if (bp != null) {
      bp.hitCount++;
    }

    final vars = inspectVariables();
    final cleanFile = normalizeFileName(file);
    final event = BreakpointHitEvent(
      file: cleanFile,
      line: line,
      message: 'Hit breakpoint at $cleanFile:$line',
      variables: vars,
    );

    _log(
      '\n╔═══════════════════════════════════════════════════════════════════════════════╗',
    );
    _log('║ 🛑 [BREAKPOINT HIT] $cleanFile:$line (hit #${bp?.hitCount ?? 1})');
    _log('║ 👉 guest_app/$cleanFile:$line');
    if (vars.isNotEmpty) {
      _log(
        '║ Scope: ${vars.entries.map((e) => '${e.key}=${e.value}').join(', ')}',
      );
    }
    _log(
      '╚═══════════════════════════════════════════════════════════════════════════════╝\n',
    );

    // 1. Notify UI and WebSocket listeners immediately so barrier & banner appear on device
    if (pauseOnHit) {
      if (_pauseCompleter == null || _pauseCompleter!.isCompleted) {
        _pauseCompleter = Completer<void>();
      }
    }
    _notifyHit(event);
    onBreakpointHit?.call(event);

    if (pauseOnHit) {
      await _waitForResume();
    }
  }

  bool _isResumeRequested = false;

  /// Resumes paused execution.
  void resume() {
    _notifyHit(null);
    _isResumeRequested = true;
    if (_pauseCompleter != null && !_pauseCompleter!.isCompleted) {
      _log('▶️ [Debugger] Resuming execution...');
      _pauseCompleter?.complete();
    }
  }

  /// Internal suspension helper.
  Future<void> _waitForResume() async {
    if (_isResumeRequested) {
      _isResumeRequested = false;
      _pauseCompleter = null;
      return;
    }
    if (_pauseCompleter != null) {
      await _pauseCompleter!.future;
      _pauseCompleter = null;
    }
  }

  void _log(String message) {
    if (onLog != null) {
      onLog!(message);
    } else {
      // ignore: avoid_print
      print(message);
    }
  }
}

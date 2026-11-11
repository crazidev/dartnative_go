import 'package:dartnative/dartnative.dart';

import '../interpreter/auto_import_parser.dart' show BreakpointInstrumenter;
import 'ast_interpreter_runner.dart';
import 'bundle_loader.dart';

/// Factory for the host app shell to create an engine-specific [GuestRunner].
typedef GuestRunnerBuilder =
    GuestRunner Function({
      void Function(String message)? onLog,
      VoidCallback? onExit,
      String? currentServerUrl,
      bool useAst,
      void Function(Object error, StackTrace stack)? onGuestError,
    });

/// The host-facing surface of a guest runtime.
abstract class GuestRunner {
  String? currentServerUrl;
  void Function(String message)? onLog;
  VoidCallback? onExit;
  void Function(Object error, StackTrace stack)? onGuestError;

  /// When true, [evaluateBundle] prefers pre-compiled AST bytes.
  bool get useAst;
  set useAst(bool value);

  /// Whether this runner can execute source (analyzer) guest code.
  bool get supportsSourceRuntime;

  /// Analyzer-free AST runner, when one has been created.
  AstInterpreterRunner? get astRunner;

  /// Visitor of the active engine (used for hot-reload remounting).
  Object? get activeVisitor;

  /// Instrumenter for source line breakpoints, or null when unavailable.
  BreakpointInstrumenter? get breakpointInstrumenter;

  /// Initializes a fresh interpreter session.
  void initInterpreter();

  /// Evaluates [bundle] and resolves the root widget.
  Future<Widget> evaluateBundle(
    ProjectBundle bundle, {
    bool isHotReload = false,
  });

  /// Replaces the active source breakpoints (no-op without a source runtime).
  void setBreakpoints(List<Map<String, dynamic>> breakpoints);

  /// Resumes paused source execution (no-op without a source runtime).
  void resumeDebugger();

  /// Cleanly unmounts the active guest app.
  void unmount();
}

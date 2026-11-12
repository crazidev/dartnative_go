import 'package:dartnative/dartnative.dart';

import '../interpreter/auto_import_parser.dart' show BreakpointInstrumenter;
import 'ast_interpreter_runner.dart';
import 'bundle_loader.dart';

/// Reports a guest build that failed before it rendered any child.
///
/// [rebuildsInPlace] is false when the failed proxy has no `State` to mark
/// dirty, so only a remount (not a hot reload) can repaint it.
typedef GuestBlankBuildReporter =
    void Function(
      Object error,
      StackTrace stack, {
      required bool rebuildsInPlace,
    });

/// Factory for the host app shell to create an engine-specific [GuestRunner].
typedef GuestRunnerBuilder =
    GuestRunner Function({
      void Function(String message)? onLog,
      VoidCallback? onExit,
      String? currentServerUrl,
      bool useAst,
      void Function(Object error, StackTrace stack)? onGuestError,
      GuestBlankBuildReporter? onGuestBlankBuild,
      VoidCallback? onGuestRecovered,
    });

/// The host-facing surface of a guest runtime.
abstract class GuestRunner {
  String? currentServerUrl;
  void Function(String message)? onLog;
  VoidCallback? onExit;
  void Function(Object error, StackTrace stack)? onGuestError;

  /// Guest build failures that left no rendered child, so the host must take
  /// over the whole screen instead of floating a banner over a blank surface.
  GuestBlankBuildReporter? onGuestBlankBuild;

  /// Fires when a previously blank guest surface builds a child again, so the
  /// host can drop its full-screen error view without exposing a blank frame.
  VoidCallback? onGuestRecovered;

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

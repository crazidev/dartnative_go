import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast_runtime;

import '../interpreter/auto_import_parser.dart' show BreakpointInstrumenter;
import 'ast_interpreter_runner.dart';
import 'bundle_loader.dart';
import 'guest_error_format.dart';
import 'guest_runner.dart';
import 'logger.dart';

/// Analyzer-free AST runner used by the product entrypoint (`lib/main.dart`).
class AstGuestRunner implements GuestRunner {
  @override
  String? currentServerUrl;

  @override
  void Function(String message)? onLog;

  @override
  VoidCallback? onExit;

  @override
  void Function(Object error, StackTrace stack)? onGuestError;

  @override
  GuestBlankBuildReporter? onGuestBlankBuild;

  @override
  VoidCallback? onGuestRecovered;

  @override
  bool useAst;

  AstInterpreterRunner? _astRunner;

  AstGuestRunner({
    this.onLog,
    this.onExit,
    this.currentServerUrl,
    this.useAst = true,
    this.onGuestError,
    this.onGuestBlankBuild,
    this.onGuestRecovered,
  }) {
    initInterpreter();
  }

  /// Constructor tear-off matching [GuestRunnerBuilder].
  static AstGuestRunner create({
    void Function(String message)? onLog,
    VoidCallback? onExit,
    String? currentServerUrl,
    bool useAst = true,
    void Function(Object error, StackTrace stack)? onGuestError,
    GuestBlankBuildReporter? onGuestBlankBuild,
    VoidCallback? onGuestRecovered,
  }) => AstGuestRunner(
    onLog: onLog,
    onExit: onExit,
    currentServerUrl: currentServerUrl,
    useAst: useAst,
    onGuestError: onGuestError,
    onGuestBlankBuild: onGuestBlankBuild,
    onGuestRecovered: onGuestRecovered,
  );

  @override
  bool get supportsSourceRuntime => false;

  @override
  AstInterpreterRunner? get astRunner => _astRunner;

  @override
  Object? get activeVisitor => _astRunner?.visitor;

  @override
  BreakpointInstrumenter? get breakpointInstrumenter => null;

  @override
  void initInterpreter() {
    _astRunner?.currentServerUrl = currentServerUrl;
  }

  @override
  Future<Widget> evaluateBundle(
    ProjectBundle bundle, {
    bool isHotReload = false,
  }) async {
    if (!bundle.hasAst) {
      throw StateError(
        'This build links only the AST runtime, but the dev server did not '
        'provide /guest.ast. Rebuild the bundle on the server (or launch the '
        'Source-capable development entrypoint: dn run -t lib/main_source.dart).',
      );
    }
    return evaluateAstBundle(
      bundle.astBytes ?? const [],
      astPatchBytes: bundle.astPatchBytes,
      isPatch: bundle.isPatch,
      entryPoint: bundle.astEntryPoint,
      isHotReload: isHotReload,
      moduleFingerprints: bundle.astModuleFingerprints,
    );
  }

  /// Executes pre-compiled `AstBundle` bytes via `tom_d4rt_ast`.
  Future<Widget> evaluateAstBundle(
    List<int> astBytes, {
    List<int>? astPatchBytes,
    bool isPatch = false,
    String? entryPoint,
    bool isHotReload = false,
    Map<String, String> moduleFingerprints = const {},
  }) async {
    _astRunner ??= AstInterpreterRunner(
      onLog: onLog,
      onGuestError: (error, stack) {
        final effectiveStack = _effectiveStack(error, stack);
        logGuestError(error, effectiveStack);
        onGuestError?.call(error, effectiveStack);
      },
      onGuestBlankBuild: (error, stack, {required rebuildsInPlace}) {
        final effectiveStack = _effectiveStack(error, stack);
        onGuestBlankBuild?.call(
          error,
          effectiveStack,
          rebuildsInPlace: rebuildsInPlace,
        );
      },
      onGuestRecovered: onGuestRecovered,
      onExit: onExit,
      currentServerUrl: currentServerUrl,
    );
    _astRunner!.currentServerUrl = currentServerUrl;
    _astRunner!.onGuestRecovered = onGuestRecovered;
    _astRunner!.onLog = onLog;
    _astRunner!.profileExecution = DartGoLogger.verbose;
    _astRunner!.onGuestBlankBuild = onGuestBlankBuild;
    _astRunner!.onGuestError ??= (error, stack) {
      final effectiveStack = _effectiveStack(error, stack);
      logGuestError(error, effectiveStack);
      onGuestError?.call(error, effectiveStack);
    };
    _astRunner!.onExit = onExit;

    return await _astRunner!.evaluateAstBundleAs<Widget>(
      astBytes,
      astPatchBytes: astPatchBytes,
      isPatch: isPatch,
      entryPoint: entryPoint,
      isHotReload: isHotReload,
      moduleFingerprints: moduleFingerprints,
    );
  }

  static StackTrace _effectiveStack(Object error, StackTrace stack) {
    if (error is ast_runtime.D4rtException &&
        error.guestStackTrace != null &&
        error.guestStackTrace!.isNotEmpty) {
      return StackTrace.fromString(error.guestStackTrace!);
    }
    return stack;
  }

  @override
  void setBreakpoints(List<Map<String, dynamic>> breakpoints) {
    // AST mode has no line debugger; source breakpoints are a no-op here.
  }

  @override
  void resumeDebugger() {
    // AST mode has no line debugger.
  }

  @override
  void unmount() {
    _astRunner?.dispose();
    _astRunner = null;
  }
}

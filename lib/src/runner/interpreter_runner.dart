import 'dart:async';
import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast_runtime;

import '../interpreter/asset_bridge.dart';
import '../interpreter/auto_import_parser.dart';
import '../interpreter/breakpoint_instrumenter.dart';
import '../interpreter/d4rt_dartnative_application.dart';
import '../interpreter/debug_controller.dart';
import '../interpreter/dn_bridge.dart';
import '../interpreter/host_api_bridge.dart';
import '../interpreter/server_component_source_bridge.dart';
import '../widgets/server_component_loader.dart';
import 'ast_interpreter_runner.dart';
import 'bundle_loader.dart';
import 'guest_error_format.dart';
import 'guest_runner.dart';
import 'logger.dart';
import 'runtime_mode.dart';

/// Manages dynamic execution of DartNative guest apps using tom_d4rt or tom_d4rt_ast.
class InterpreterRunner implements GuestRunner {
  /// The analyzer-based interpreter.
  ///
  /// Built eagerly in source mode. In AST mode it is **deferred**: a full
  /// bridge surface for an engine that will not run the guest is wasted launch
  /// time, so it is only created when something actually needs it (the
  /// [interpreter] getter, source-mode evaluation, host fakes in tests).
  D4rt? _interpreter;
  final DebugController _debugController = DebugController();

  Widget? _capturedApp;
  D4rtDartNativeApplication? _activeApplication;
  @override
  String? currentServerUrl;
  @override
  void Function(String message)? onLog;
  @override
  VoidCallback? onExit;

  /// When true, [evaluateBundle] prefers pre-compiled AST bytes.
  @override
  bool useAst;

  // Per-module snapshots for hot reload state preservation
  final Map<String, Map<String, Object?>> _moduleTopLevelSnapshots = {};
  final Map<String, Map<String, Map<String, Object?>>> _moduleStaticSnapshots =
      {};
  final Map<String, Object?> _globalTopLevelSnapshot = {};
  final Map<String, Map<String, Object?>> _globalStaticSnapshot = {};

  AstInterpreterRunner? _astRunner;
  ServerComponentLoader? _sourceComponentLoader;
  DebugController get debugController => _debugController;

  /// The source-mode interpreter, created on first use (see [_interpreter]).
  D4rt get interpreter => _interpreter ??= _buildSourceInterpreter();
  RuntimeMode get runtimeMode => runtimeModeFromBool(useAst);
  @override
  AstInterpreterRunner? get astRunner => _astRunner;
  @override
  Object? get activeVisitor =>
      useAst ? _astRunner?.visitor : _interpreter?.visitor;

  @override
  bool get supportsSourceRuntime => true;

  @override
  BreakpointInstrumenter? get breakpointInstrumenter => instrumentBreakpoints;

  @override
  void setBreakpoints(List<Map<String, dynamic>> breakpoints) =>
      _debugController.setBreakpoints(breakpoints);

  @override
  void resumeDebugger() => _debugController.resume();

  /// Extra listener for guest failures outside evaluation (builds,
  /// lifecycle methods, bridge callbacks). The AST runner always logs these
  /// through [DartGoLogger]; this callback lets the host surface them too
  /// (e.g. an on-device error banner) without replacing that logging.
  @override
  void Function(Object error, StackTrace stack)? onGuestError;

  /// Guest build failures that left no rendered child, so the host must take
  /// over the whole screen instead of floating a banner over a blank surface.
  @override
  GuestBlankBuildReporter? onGuestBlankBuild;

  /// Fires when a previously blank guest surface builds a child again, so the
  /// host can remove its error view without exposing a blank frame.
  @override
  VoidCallback? onGuestRecovered;

  InterpreterRunner({
    this.onLog,
    this.onExit,
    this.currentServerUrl,
    this.useAst = kUseAst,
    this.onGuestError,
    this.onGuestBlankBuild,
    this.onGuestRecovered,
  }) {
    initInterpreter();
  }

  /// Constructor tear-off matching [GuestRunnerBuilder].
  static InterpreterRunner create({
    void Function(String message)? onLog,
    VoidCallback? onExit,
    String? currentServerUrl,
    bool useAst = kUseAst,
    void Function(Object error, StackTrace stack)? onGuestError,
    GuestBlankBuildReporter? onGuestBlankBuild,
    VoidCallback? onGuestRecovered,
  }) => InterpreterRunner(
    onLog: onLog,
    onExit: onExit,
    currentServerUrl: currentServerUrl,
    useAst: useAst,
    onGuestError: onGuestError,
    onGuestBlankBuild: onGuestBlankBuild,
    onGuestRecovered: onGuestRecovered,
  );

  /// Initializes a fresh interpreter session with all registered bridges and runtime hooks.
  ///
  /// In AST mode the source interpreter is not built here — see [_interpreter].
  /// Server-scoped values (asset resolver URL, log sink) are still refreshed so
  /// a URL change reaches whichever engine ends up running.
  @override
  void initInterpreter() {
    _capturedApp = null;
    _debugController.onLog = onLog;
    AssetResolver.activeServerUrl = currentServerUrl;

    try {
      _interpreter?.dispose();
    } catch (_) {}
    _interpreter = null;
    _debugController.activeInterpreter = null;

    if (useAst) return;

    _debugController.activeInterpreter = interpreter;
  }

  /// Builds the analyzer-based interpreter and registers the full bridge
  /// surface on it. Called at most once per [initInterpreter] generation.
  D4rt _buildSourceInterpreter() {
    final interpreter = D4rt();
    _debugController.activeInterpreter = interpreter;
    _debugController.onLog = onLog;

    // Grant permissions so guest apps can load dart:io and network resources
    interpreter.grant(FilesystemPermission.any);
    interpreter.grant(NetworkPermission.any);
    interpreter.grant(ProcessRunPermission.any);
    interpreter.grant(IsolatePermission.any);
    interpreter.grant(DangerousPermission.any);

    // 1. Core DartNative framework bridges + proxies. This already registers
    // the full generated surface (DartnativeGoBridges) via
    // registerDartNativeBridges — registering it a second time here only
    // duplicated work.
    registerDartNativeBridges(interpreter, onLog: onLog);
    registerAssetAwareBridges(
      interpreter,
      serverUrlProvider: () => currentServerUrl,
    );
    AssetResolver.activeServerUrl = currentServerUrl;

    // 2b. Host ServerComponentView (`package:dartnative_go/server_component.dart`).
    // Components are AST bundles, so they mount through the embedded AST runner.
    registerSourceHostApiBridge(interpreter);
    registerSourceServerComponentBridge(
      interpreter,
      loaderProvider: () => _sourceComponentLoader ??= ServerComponentLoader(
        serverUrl: currentServerUrl ?? '',
        serverUrlProvider: () => currentServerUrl ?? '',
        runner: _astRunner ??= AstInterpreterRunner(
          onLog: onLog,
          onGuestError: onGuestError,
          onGuestBlankBuild: onGuestBlankBuild,
          onGuestRecovered: onGuestRecovered,
          onExit: onExit,
          currentServerUrl: currentServerUrl,
        ),
      ),
    );

    // 3. Special Framework Bridges: D4rtDartNativeApplication, runApp, unawaited
    Object? captureRunApp(
      InterpreterVisitor visitor,
      List<Object?> positional,
      Map<String, Object?> named,
      List<RuntimeType>? typeArgs,
    ) {
      if (positional.isNotEmpty) {
        _capturedApp = unwrap<Widget>(positional[0], visitor: visitor);
      }
      return null;
    }

    for (final lib in [
      'package:dartnative/dartnative.dart',
      'package:dartnative/flutter_compat.dart',
      'package:dartnative/src/framework.dart',
      'package:flutter/widgets.dart',
      'package:flutter/material.dart',
    ]) {
      interpreter.registertopLevelFunction(
        'runApp',
        captureRunApp,
        lib,
        signature: 'void runApp(Widget app)',
      );
    }

    // 4. Intercept registerNativeBindings so guest app calling DartNativePluginRegistrant.registerAll()
    // does not fail or attempt to re-register native host bindings
    interpreter.registertopLevelFunction(
      'registerNativeBindings',
      (visitor, positional, named, typeArgs) {
        return null;
      },
      'package:dartnative/dartnative.dart',
      signature: 'void registerNativeBindings(dynamic bindings)',
    );
    interpreter.registertopLevelFunction(
      'registerNativeBindings',
      (visitor, positional, named, typeArgs) {
        return null;
      },
      'package:dartnative/src/framework.dart',
      signature: 'void registerNativeBindings(dynamic bindings)',
    );

    // 4. Intercept exitToLauncher()
    interpreter.registertopLevelFunction(
      'exitToLauncher',
      (visitor, positional, named, typeArgs) {
        onExit?.call();
        return null;
      },
      'package:dartnative/dartnative.dart',
      signature: 'void exitToLauncher()',
    );

    // 4b. Register unawaited() from dart:async
    void registerUnawaited(String library) {
      interpreter.registertopLevelFunction(
        'unawaited',
        (visitor, positional, named, typeArgs) {
          final arg = positional.isNotEmpty ? positional[0] : null;
          if (arg is Future) {
            arg.ignore();
          }
          return null;
        },
        library,
        signature: 'void unawaited(Future<void> future)',
      );
    }

    for (final lib in [
      'dart:async',
      'package:dartnative/dartnative.dart',
      'package:dartnative/flutter_compat.dart',
      'package:dartnative/src/framework.dart',
    ]) {
      registerUnawaited(lib);
    }

    // 5. Debugger and Breakpoint hooks
    interpreter.registertopLevelFunction(
      'debugger',
      (visitor, positional, named, typeArgs) {
        final message = positional.isNotEmpty
            ? positional[0]?.toString()
            : null;
        return _debugController.handleDebuggerCall(message);
      },
      'package:dartnative/dartnative.dart',
      signature: 'Future<void> debugger([String? message])',
    );

    interpreter.registertopLevelFunction(
      'breakpoint',
      (visitor, positional, named, typeArgs) {
        final message = positional.isNotEmpty
            ? positional[0]?.toString()
            : null;
        return _debugController.handleDebuggerCall(message);
      },
      'package:dartnative/dartnative.dart',
      signature: 'Future<void> breakpoint([String? message])',
    );

    interpreter.registertopLevelFunction(
      '__debugBreakpoint',
      (visitor, positional, named, typeArgs) {
        final file = positional.isNotEmpty
            ? positional[0]?.toString() ?? '<unknown>'
            : '<unknown>';
        final line = positional.length > 1 && positional[1] is int
            ? positional[1] as int
            : int.tryParse(
                    positional.length > 1 ? positional[1].toString() : '',
                  ) ??
                  0;
        return _debugController.handleLineBreakpoint(file, line);
      },
      'package:dartnative/dartnative.dart',
      signature: 'Future<void> __debugBreakpoint(String file, int line)',
    );

    // 6. D4rtDartNativeApplication wrapper hook
    interpreter.registertopLevelFunction(
      'D4rtDartNativeApplication',
      (visitor, positional, named, typeArgs) {
        final rootWidget = unwrap<Widget>(named['root'], visitor: visitor);
        return D4rtDartNativeApplication(
          root:
              rootWidget ??
              const Scaffold(
                body: Center(
                  child: Text('Empty D4rtDartNativeApplication root'),
                ),
              ),
          onMount: named['onMount'] != null
              ? () => D4.callInterpreterCallback(visitor, named['onMount'], [])
              : null,
          onUnmount: named['onUnmount'] != null
              ? () =>
                    D4.callInterpreterCallback(visitor, named['onUnmount'], [])
              : null,
        );
      },
      'package:dartnative/dartnative.dart',
      signature:
          'D4rtDartNativeApplication({required Widget root, Function? onMount, Function? onUnmount})',
    );

    return interpreter;
  }

  void _snapshotState([String? currentLibrary]) {
    final visitor = _interpreter?.visitor;
    if (visitor == null) return;

    _moduleTopLevelSnapshots.clear();
    _moduleStaticSnapshots.clear();
    _globalTopLevelSnapshot.clear();
    _globalStaticSnapshot.clear();

    bool isStatePreservingObject(Object? val) {
      if (val == null) return false;
      if (val is String ||
          val is num ||
          val is bool ||
          val is Symbol ||
          val is Type) {
        return false;
      }
      if (val is InterpretedFunction ||
          val is Callable ||
          val is BridgedClass) {
        return false;
      }
      final typeStr = val.runtimeType.toString();
      if (typeStr.contains('Provider') ||
          typeStr.contains('Notifier') ||
          typeStr.contains('Controller') ||
          typeStr.contains('Container')) {
        return true;
      }
      if (val is BridgedInstance) {
        final className = val.bridgedClass.name;
        if (className.contains('Provider') ||
            className.contains('Notifier') ||
            className.contains('Controller') ||
            className.contains('Container')) {
          return true;
        }
      }
      return false;
    }

    void snapshotEnvTo(
      Environment env,
      Map<String, Object?> topLevelMap,
      Map<String, Map<String, Object?>> staticMap,
    ) {
      for (final entry in env.values.entries) {
        var val = entry.value;
        // tom_d4rt >= 1.233 stores every top-level variable (and every field)
        // with an initializer in a lazy `LateVariable` holder (GitHub #10), so
        // the binding is the holder rather than the value. Unwrap it — only
        // when already initialized, so a reload never runs an initializer the
        // program had not run — and snapshot what it holds.
        if (val is LateVariable) {
          if (!val.isInitialized) continue;
          val = val.value;
        }
        if (val is InterpretedClass) {
          if (val.staticFields.isNotEmpty) {
            staticMap[entry.key] = Map.of(val.staticFields);
          }
        } else if (isStatePreservingObject(val)) {
          topLevelMap[entry.key] = val;
        }
      }
    }

    // 1. Snapshot global environment & visitor current environment chain
    Environment? currentEnv = visitor.environment;
    while (currentEnv != null) {
      snapshotEnvTo(currentEnv, _globalTopLevelSnapshot, _globalStaticSnapshot);
      currentEnv = currentEnv.enclosing;
    }
    snapshotEnvTo(
      visitor.globalEnvironment,
      _globalTopLevelSnapshot,
      _globalStaticSnapshot,
    );

    // 2. Snapshot per-module environments (only user package & relevant stateful modules)
    try {
      final loader = visitor.moduleLoader;
      final mainPkg =
          (currentLibrary != null && currentLibrary.startsWith('package:'))
          ? currentLibrary.split('/')[0]
          : 'package:guest_app';

      for (final key in loader.sources.keys) {
        // Skip stdlib and third-party dependency modules — only user app holds state
        final isUserModule =
            key.startsWith(mainPkg) ||
            key.startsWith('package:guest_app') ||
            (!key.startsWith('package:') && !key.startsWith('dart:'));
        if (!isUserModule) continue;

        try {
          final mod = loader.loadModule(Uri.parse(key));
          final topMap = <String, Object?>{};
          final statMap = <String, Map<String, Object?>>{};
          snapshotEnvTo(mod.environment, topMap, statMap);
          snapshotEnvTo(mod.exportedEnvironment, topMap, statMap);
          if (topMap.isNotEmpty) _moduleTopLevelSnapshots[key] = topMap;
          if (statMap.isNotEmpty) _moduleStaticSnapshots[key] = statMap;
        } catch (_) {}
      }
    } catch (_) {}
  }

  void _restoreState() {
    final visitor = _interpreter?.visitor;
    if (visitor == null) return;

    void restoreEnvFrom(
      Environment env,
      Map<String, Object?> topLevelMap,
      Map<String, Map<String, Object?>> staticMap,
    ) {
      for (final entry in staticMap.entries) {
        final cls = env.values[entry.key];
        if (cls is InterpretedClass) {
          cls.staticFields.addAll(entry.value);
        }
      }

      for (final entry in topLevelMap.entries) {
        if (env.values.containsKey(entry.key)) {
          final existing = env.values[entry.key];
          // The new generation binds the declaration to a fresh, uninitialized
          // `LateVariable`; assign into it so the lazy binding answers with the
          // preserved object instead of running its initializer again.
          if (existing is LateVariable) {
            if (existing.isInitialized) continue;
            try {
              existing.assign(entry.value);
            } catch (_) {}
            continue;
          }
          if (existing is! InterpretedClass &&
              existing is! InterpretedFunction &&
              existing is! Callable) {
            env.values[entry.key] = entry.value;
          }
        }
      }
    }

    // 1. Restore global environment & visitor current environment chain
    Environment? currentEnv = visitor.environment;
    while (currentEnv != null) {
      restoreEnvFrom(
        currentEnv,
        _globalTopLevelSnapshot,
        _globalStaticSnapshot,
      );
      currentEnv = currentEnv.enclosing;
    }
    restoreEnvFrom(
      visitor.globalEnvironment,
      _globalTopLevelSnapshot,
      _globalStaticSnapshot,
    );

    // 2. Restore per-module environments (only for modules that had snapshot data)
    try {
      final loader = visitor.moduleLoader;
      final keysToRestore = _moduleTopLevelSnapshots.keys
          .followedBy(_moduleStaticSnapshots.keys)
          .toSet();
      for (final key in keysToRestore) {
        final topMap = _moduleTopLevelSnapshots[key];
        final statMap = _moduleStaticSnapshots[key];
        if (topMap != null || statMap != null) {
          try {
            final mod = loader.loadModule(Uri.parse(key));
            restoreEnvFrom(
              mod.environment,
              topMap ?? const {},
              statMap ?? const {},
            );
            restoreEnvFrom(
              mod.exportedEnvironment,
              topMap ?? const {},
              statMap ?? const {},
            );
          } catch (_) {}
        }
      }
    } catch (_) {}

    _moduleTopLevelSnapshots.clear();
    _moduleStaticSnapshots.clear();
    _globalTopLevelSnapshot.clear();
    _globalStaticSnapshot.clear();
  }

  /// Evaluates guest code from [source] and resolves the root [Widget].
  ///
  /// Source path (default). See [evaluateBundle] for mode dispatch.
  Future<Widget> evaluate({
    required String source,
    required String library,
    Map<String, String>? sources,
    bool isHotReload = false,
  }) async {
    final totalSw = Stopwatch()..start();
    final interpreter = this.interpreter;
    int snapMs = 0;
    if (isHotReload) {
      final snapSw = Stopwatch()..start();
      _snapshotState(library);
      try {
        interpreter.dispose();
      } catch (_) {}
      snapMs = snapSw.elapsedMilliseconds;
    }

    _capturedApp = null;
    final autoImportSw = Stopwatch()..start();
    final processedScript = AutoImportParser.processAndAutoImport(
      source,
      currentFilePath: library,
      projectFiles: sources,
    );
    final autoImportMs = autoImportSw.elapsedMilliseconds;

    final execSw = Stopwatch()..start();
    Object? rawResult = runZoned(
      () => interpreter.execute(
        source: processedScript,
        name: 'main',
        library: library,
        sources: sources,
      ),
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          onLog?.call(line);
        },
      ),
    );

    if (rawResult is Future) {
      rawResult = await rawResult;
    }
    final execMs = execSw.elapsedMilliseconds;

    if (rawResult is D4rtDartNativeApplication) {
      _activeApplication = rawResult;
      try {
        rawResult.onMount?.call();
      } catch (_) {}
    }

    Widget? resolvedWidget =
        _capturedApp ?? unwrap<Widget>(rawResult, visitor: interpreter.visitor);

    if (resolvedWidget == null) {
      throw StateError(
        'Evaluation succeeded, but could not resolve a Widget from the entrypoint ($rawResult).\n'
        'Ensure your main() calls runApp(Widget) or returns a Widget.',
      );
    }

    int restoreMs = 0;
    if (isHotReload) {
      final restoreSw = Stopwatch()..start();
      _restoreState();
      restoreMs = restoreSw.elapsedMilliseconds;
    }

    DartGoLogger.bench(
      'Interpreter',
      'evaluate (${isHotReload ? "reload" : "initial"})',
      totalSw.elapsedMilliseconds,
      {
        'snap': snapMs,
        'auto_import': autoImportMs,
        'exec': execMs,
        'restore': restoreMs,
      },
    );

    return resolvedWidget;
  }

  /// Dispatches to AST or Source evaluation based on flags.
  @override
  Future<Widget> evaluateBundle(
    ProjectBundle bundle, {
    bool isHotReload = false,
  }) async {
    if (useAst) {
      if (bundle.hasAst) {
        return evaluateAstBundle(
          bundle.astBytes ?? const [],
          astPatchBytes: bundle.astPatchBytes,
          isPatch: bundle.isPatch,
          entryPoint: bundle.astEntryPoint,
          isHotReload: isHotReload,
          // Phase 5: unchanged modules are not re-declared on reload.
          moduleFingerprints: bundle.astModuleFingerprints,
        );
      }
      onLog?.call(
        '[Runner] AST mode enabled but no /guest.ast on server — falling back to source. '
        'If the server just started, wait for `[AST] guest.ast ready` there and reload; '
        'if it never appears, check the server log for the bundle build error (or --no-rebuild-ast).',
      );
    }
    return evaluate(
      source: bundle.entrypointCode,
      library: bundle.entrypointLibrary,
      sources: bundle.sources,
      isHotReload: isHotReload,
    );
  }

  /// Executes pre-compiled `AstBundle` bytes via `tom_d4rt_ast`.
  ///
  /// Delegates to [AstInterpreterRunner] (analyzer-free, stdlib + direct
  /// native widgets in v1). Generated DartNative bridges are source-typed
  /// and register on phase 2 — see [AstInterpreterRunner] docs.
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
        final effectiveStack =
            (error is ast_runtime.D4rtException &&
                error.guestStackTrace != null &&
                error.guestStackTrace!.isNotEmpty)
            ? StackTrace.fromString(error.guestStackTrace!)
            : stack;
        logGuestError(error, effectiveStack);
        onGuestError?.call(error, effectiveStack);
      },
      onGuestBlankBuild: (error, stack, {required rebuildsInPlace}) {
        final effectiveStack =
            (error is ast_runtime.D4rtException &&
                error.guestStackTrace != null &&
                error.guestStackTrace!.isNotEmpty)
            ? StackTrace.fromString(error.guestStackTrace!)
            : stack;
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
      final effectiveStack =
          (error is ast_runtime.D4rtException &&
              error.guestStackTrace != null &&
              error.guestStackTrace!.isNotEmpty)
          ? StackTrace.fromString(error.guestStackTrace!)
          : stack;
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

  /// Cleanly unmounts the active guest app.
  @override
  void unmount() {
    try {
      _activeApplication?.onUnmount?.call();
    } catch (_) {}
    _activeApplication = null;
    _capturedApp = null;
    try {
      _interpreter?.dispose();
    } catch (_) {}
    detachSourceHostApiListeners();
    _interpreter = null;
    _astRunner?.dispose();
    _astRunner = null;
    try {
      _sourceComponentLoader?.bundleLoader.close();
    } catch (_) {}
    _sourceComponentLoader = null;
  }
}

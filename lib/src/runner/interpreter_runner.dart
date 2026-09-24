import 'dart:async';
import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt/tom_d4rt.dart';

import '../interpreter/asset_bridge.dart';
import '../interpreter/auto_import_parser.dart';
import '../interpreter/d4rt_flutter_application.dart';
import '../interpreter/dartscript.b.dart';
import '../interpreter/debug_controller.dart';
import '../interpreter/dn_bridge.dart';
import 'ast_interpreter_runner.dart';
import 'bytecode/bytecode_models.dart';
import 'bytecode_interpreter_runner.dart';
import 'bundle_loader.dart';
import 'logger.dart';
import 'runtime_mode.dart';

/// Manages dynamic execution of DartNative guest apps using tom_d4rt, tom_d4rt_ast, or Bytecode VM.
class InterpreterRunner {
  late D4rt _interpreter;
  final DebugController _debugController = DebugController();

  Widget? _capturedApp;
  D4rtFlutterApplication? _activeApplication;
  String? currentServerUrl;
  void Function(String message)? onLog;
  VoidCallback? onExit;

  /// When true, [evaluateBundle] prefers pre-compiled AST bytes.
  bool useAst;
  /// When true, [evaluateBundle] prefers Bytecode stack VM execution.
  bool useBytecode;

  // Per-module snapshots for hot reload state preservation
  final Map<String, Map<String, Object?>> _moduleTopLevelSnapshots = {};
  final Map<String, Map<String, Map<String, Object?>>> _moduleStaticSnapshots = {};
  final Map<String, Object?> _globalTopLevelSnapshot = {};
  final Map<String, Map<String, Object?>> _globalStaticSnapshot = {};

  AstInterpreterRunner? _astRunner;
  BytecodeInterpreterRunner? _bytecodeRunner;
  DebugController get debugController => _debugController;
  D4rt get interpreter => _interpreter;
  RuntimeMode get runtimeMode => runtimeModeFromBool(useAst, useBytecode);
  BytecodeInterpreterRunner? get bytecodeRunner => _bytecodeRunner;
  Object? get activeVisitor => useAst
      ? _astRunner?.visitor
      : (useBytecode ? _bytecodeRunner?.vm : _interpreter.visitor);

  InterpreterRunner({
    this.onLog,
    this.onExit,
    this.currentServerUrl,
    this.useAst = kUseAst,
    this.useBytecode = kUseBytecode,
  }) {
    initInterpreter();
  }

  /// Initializes a fresh interpreter session with all registered bridges and runtime hooks.
  void initInterpreter() {
    _capturedApp = null;
    _interpreter = D4rt();
    _debugController.activeInterpreter = _interpreter;
    _debugController.onLog = onLog;

    // Grant permissions so guest apps can load dart:io and network resources
    _interpreter.grant(FilesystemPermission.any);
    _interpreter.grant(NetworkPermission.any);
    _interpreter.grant(ProcessRunPermission.any);
    _interpreter.grant(IsolatePermission.any);
    _interpreter.grant(DangerousPermission.any);

    // 1. Core DartNative framework bridges + proxies
    registerDartNativeBridges(_interpreter, onLog: onLog);
    registerAssetAwareBridges(
      _interpreter,
      serverUrlProvider: () => currentServerUrl,
    );
    AssetResolver.activeServerUrl = currentServerUrl;

    // 2. Full generated bridge surface (plugins, riverpod, etc.)
    try {
      DartnativeGoBridges.register(_interpreter);
    } catch (_) {}

    // 3. Special Framework Bridges: D4rtFlutterApplication, runApp, unawaited
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
      'package:dartnative/src/framework.dart',
      'package:flutter/widgets.dart',
      'package:flutter/material.dart',
    ]) {
      _interpreter.registertopLevelFunction(
        'runApp',
        captureRunApp,
        lib,
        signature: 'void runApp(Widget app)',
      );
    }

    // 4. Intercept registerNativeBindings so guest app calling DartNativePluginRegistrant.registerAll()
    // does not fail or attempt to re-register native host bindings
    _interpreter.registertopLevelFunction(
      'registerNativeBindings',
      (visitor, positional, named, typeArgs) {
        return null;
      },
      'package:dartnative/dartnative.dart',
      signature: 'void registerNativeBindings(dynamic bindings)',
    );
    _interpreter.registertopLevelFunction(
      'registerNativeBindings',
      (visitor, positional, named, typeArgs) {
        return null;
      },
      'package:dartnative/src/framework.dart',
      signature: 'void registerNativeBindings(dynamic bindings)',
    );

    // 4. Intercept exitToLauncher()
    _interpreter.registertopLevelFunction(
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
      _interpreter.registertopLevelFunction(
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
      'package:dartnative/src/framework.dart',
    ]) {
      registerUnawaited(lib);
    }

    // 5. Debugger and Breakpoint hooks
    _interpreter.registertopLevelFunction(
      'debugger',
      (visitor, positional, named, typeArgs) {
        final message = positional.isNotEmpty ? positional[0]?.toString() : null;
        return _debugController.handleDebuggerCall(message);
      },
      'package:dartnative/dartnative.dart',
      signature: 'Future<void> debugger([String? message])',
    );

    _interpreter.registertopLevelFunction(
      'breakpoint',
      (visitor, positional, named, typeArgs) {
        final message = positional.isNotEmpty ? positional[0]?.toString() : null;
        return _debugController.handleDebuggerCall(message);
      },
      'package:dartnative/dartnative.dart',
      signature: 'Future<void> breakpoint([String? message])',
    );

    _interpreter.registertopLevelFunction(
      '__debugBreakpoint',
      (visitor, positional, named, typeArgs) {
        final file = positional.isNotEmpty ? positional[0]?.toString() ?? '<unknown>' : '<unknown>';
        final line = positional.length > 1 && positional[1] is int
            ? positional[1] as int
            : int.tryParse(positional.length > 1 ? positional[1].toString() : '') ?? 0;
        return _debugController.handleLineBreakpoint(file, line);
      },
      'package:dartnative/dartnative.dart',
      signature: 'Future<void> __debugBreakpoint(String file, int line)',
    );

    // 6. D4rtFlutterApplication wrapper hook
    _interpreter.registertopLevelFunction(
      'D4rtFlutterApplication',
      (visitor, positional, named, typeArgs) {
        final rootWidget = unwrap<Widget>(named['root'], visitor: visitor);
        return D4rtFlutterApplication(
          root: rootWidget ??
              const Scaffold(
                body: Center(child: Text('Empty D4rtFlutterApplication root')),
              ),
          onMount: named['onMount'] != null
              ? () => D4.callInterpreterCallback(visitor, named['onMount'], [])
              : null,
          onUnmount: named['onUnmount'] != null
              ? () => D4.callInterpreterCallback(visitor, named['onUnmount'], [])
              : null,
        );
      },
      'package:dartnative/dartnative.dart',
      signature:
          'D4rtFlutterApplication({required Widget root, Function? onMount, Function? onUnmount})',
    );
  }

  void _snapshotState([String? currentLibrary]) {
    final visitor = _interpreter.visitor;
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
        final val = entry.value;
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
    snapshotEnvTo(visitor.globalEnvironment, _globalTopLevelSnapshot, _globalStaticSnapshot);

    // 2. Snapshot per-module environments (only user package & relevant stateful modules)
    try {
      final loader = visitor.moduleLoader;
      final mainPkg = (currentLibrary != null && currentLibrary.startsWith('package:'))
          ? currentLibrary.split('/')[0]
          : 'package:guest_app';

      for (final key in loader.sources.keys) {
        // Skip stdlib and third-party dependency modules — only user app holds state
        final isUserModule = key.startsWith(mainPkg) ||
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
    final visitor = _interpreter.visitor;
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
      restoreEnvFrom(currentEnv, _globalTopLevelSnapshot, _globalStaticSnapshot);
      currentEnv = currentEnv.enclosing;
    }
    restoreEnvFrom(visitor.globalEnvironment, _globalTopLevelSnapshot, _globalStaticSnapshot);

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
            restoreEnvFrom(mod.environment, topMap ?? const {}, statMap ?? const {});
            restoreEnvFrom(mod.exportedEnvironment, topMap ?? const {}, statMap ?? const {});
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
    int snapMs = 0;
    if (isHotReload) {
      final snapSw = Stopwatch()..start();
      _snapshotState(library);
      try {
        _interpreter.dispose();
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
      () => _interpreter.execute(
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

    if (rawResult is D4rtFlutterApplication) {
      _activeApplication = rawResult;
      try {
        rawResult.onMount?.call();
      } catch (_) {}
    }

    Widget? resolvedWidget = _capturedApp ??
        unwrap<Widget>(rawResult, visitor: _interpreter.visitor);

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

  /// Dispatches to Bytecode, AST, or Source evaluation based on flags.
  Future<Widget> evaluateBundle(
    ProjectBundle bundle, {
    bool isHotReload = false,
  }) async {
    if (useBytecode) {
      if (bundle.hasBytecode) {
        return evaluateBytecodeBundle(
          bundle.bytecodeBytes!,
          isHotReload: isHotReload,
        );
      }
      onLog?.call(
        '[Runner] Bytecode mode enabled but no /guest.bc on server — falling back.',
      );
    }
    if (useAst) {
      if (bundle.hasAst) {
        return evaluateAstBundle(
          bundle.astBytes!,
          entryPoint: bundle.astEntryPoint,
          isHotReload: isHotReload,
        );
      }
      onLog?.call(
        '[Runner] AST mode enabled but no /guest.ast on server — falling back to source.',
      );
    }
    return evaluate(
      source: bundle.entrypointCode,
      library: bundle.entrypointLibrary,
      sources: bundle.sources,
      isHotReload: isHotReload,
    );
  }

  /// Executes pre-compiled `BytecodeBundle` bytes on the Stack VM.
  Future<Widget> evaluateBytecodeBundle(
    List<int> bytecodeBytes, {
    bool isHotReload = false,
  }) async {
    _bytecodeRunner ??= BytecodeInterpreterRunner(
      onLog: onLog,
      onExit: onExit,
      currentServerUrl: currentServerUrl,
    );
    _bytecodeRunner!.currentServerUrl = currentServerUrl;
    _bytecodeRunner!.onLog = onLog;
    _bytecodeRunner!.onExit = onExit;

    return await _bytecodeRunner!.evaluateBytecodeBundle(
      bytecodeBytes,
      isHotReload: isHotReload,
    );
  }

  /// Applies a [BytecodeDelta] hot patch in-place.
  Set<String>? applyBytecodeDelta(BytecodeDelta delta) {
    return _bytecodeRunner?.applyBytecodeDelta(delta);
  }

  /// Executes pre-compiled `AstBundle` bytes via `tom_d4rt_ast`.
  ///
  /// Delegates to [AstInterpreterRunner] (analyzer-free, stdlib + direct
  /// native widgets in v1). Generated DartNative bridges are source-typed
  /// and register on phase 2 — see [AstInterpreterRunner] docs.
  Future<Widget> evaluateAstBundle(
    List<int> astBytes, {
    String? entryPoint,
    bool isHotReload = false,
  }) async {
    _astRunner ??= AstInterpreterRunner(
      onLog: onLog,
      onExit: onExit,
      currentServerUrl: currentServerUrl,
    );
    _astRunner!.currentServerUrl = currentServerUrl;
    _astRunner!.onLog = onLog;
    _astRunner!.onExit = onExit;

    return await _astRunner!.evaluateAstBundleAs<Widget>(
      astBytes,
      entryPoint: entryPoint,
      isHotReload: isHotReload,
    );
  }

  /// Cleanly unmounts the active guest app.
  void unmount() {
    try {
      _activeApplication?.onUnmount?.call();
    } catch (_) {}
    _activeApplication = null;
    _capturedApp = null;
    try {
      _interpreter.dispose();
    } catch (_) {}
    _astRunner?.dispose();
    _astRunner = null;
    _bytecodeRunner?.dispose();
    _bytecodeRunner = null;
  }
}

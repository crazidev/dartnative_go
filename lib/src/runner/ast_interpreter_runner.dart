import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

import 'ast_bundle_codec.dart';
import 'logger.dart';
import '../interpreter/ast/ast_asset_bridge.dart';
import '../interpreter/ast/ast_widget_proxies.dart';
import '../interpreter/ast/dartscript.b.dart' as ast_bridges;

/// Executes pre-compiled `AstBundle` bytes on the analyzer-free engine.
///
/// Full bridge surface (`DartnativeGoAstBridges`, generated via
/// `tool/d4rtgen_ast.dart` from `buildkit_ast.yaml`) + interpreted-widget
/// proxies (`ast_widget_proxies.dart`, port of `widget_proxies.dart`) are
/// registered here, mirroring the source `InterpreterRunner`.
class AstInterpreterRunner {
  ast.D4rtRunner? _runner;
  Widget? _capturedApp;
  String? currentServerUrl;
  void Function(String message)? onLog;
  VoidCallback? onExit;

  // Per-module snapshots for hot reload state preservation
  final Map<String, Map<String, Object?>> _moduleTopLevelSnapshots = {};
  final Map<String, Map<String, Map<String, Object?>>> _moduleStaticSnapshots = {};
  final Map<String, Object?> _globalTopLevelSnapshot = {};
  final Map<String, Map<String, Object?>> _globalStaticSnapshot = {};

  AstInterpreterRunner({this.onLog, this.onExit, this.currentServerUrl});

  void _snapshotState() {
    final visitor = _runner?.visitor;
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
      if (val is ast.InterpretedFunction ||
          val is ast.Callable ||
          val is ast.BridgedClass) {
        return false;
      }
      final typeStr = val.runtimeType.toString();
      if (typeStr.contains('Provider') ||
          typeStr.contains('Notifier') ||
          typeStr.contains('Controller') ||
          typeStr.contains('Container')) {
        return true;
      }
      if (val is ast.BridgedInstance) {
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
      ast.Environment env,
      Map<String, Object?> topLevelMap,
      Map<String, Map<String, Object?>> staticMap,
    ) {
      for (final entry in env.values.entries) {
        final val = entry.value;
        if (val is ast.InterpretedClass) {
          if (val.staticFields.isNotEmpty) {
            staticMap[entry.key] = Map.of(val.staticFields);
          }
        } else if (isStatePreservingObject(val)) {
          topLevelMap[entry.key] = val;
        }
      }
    }

    ast.Environment? currentEnv = visitor.environment;
    while (currentEnv != null) {
      snapshotEnvTo(currentEnv, _globalTopLevelSnapshot, _globalStaticSnapshot);
      currentEnv = currentEnv.enclosing;
    }
    snapshotEnvTo(visitor.globalEnvironment, _globalTopLevelSnapshot, _globalStaticSnapshot);

    try {
      final loader = visitor.moduleContext;
      if (loader is ast.AstModuleLoader) {
        for (final key in loader.modules.keys) {
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
      }
    } catch (_) {}
  }

  void _restoreState() {
    final visitor = _runner?.visitor;
    if (visitor == null) return;

    void restoreEnvFrom(
      ast.Environment env,
      Map<String, Object?> topLevelMap,
      Map<String, Map<String, Object?>> staticMap,
    ) {
      for (final entry in staticMap.entries) {
        final cls = env.values[entry.key];
        if (cls is ast.InterpretedClass) {
          cls.staticFields.addAll(entry.value);
        }
      }

      for (final entry in topLevelMap.entries) {
        if (env.values.containsKey(entry.key)) {
          final existing = env.values[entry.key];
          if (existing is! ast.InterpretedClass &&
              existing is! ast.InterpretedFunction &&
              existing is! ast.Callable) {
            env.values[entry.key] = entry.value;
          }
        }
      }
    }

    ast.Environment? currentEnv = visitor.environment;
    while (currentEnv != null) {
      restoreEnvFrom(currentEnv, _globalTopLevelSnapshot, _globalStaticSnapshot);
      currentEnv = currentEnv.enclosing;
    }
    restoreEnvFrom(visitor.globalEnvironment, _globalTopLevelSnapshot, _globalStaticSnapshot);

    try {
      final loader = visitor.moduleContext;
      if (loader is ast.AstModuleLoader) {
        for (final key in loader.modules.keys) {
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
      }
    } catch (_) {}

    _moduleTopLevelSnapshots.clear();
    _moduleStaticSnapshots.clear();
    _globalTopLevelSnapshot.clear();
    _globalStaticSnapshot.clear();
  }

  void initRunner() {
    _capturedApp = null;
    final runner = ast.D4rtRunner();
    runner.grant(ast.FilesystemPermission.any);
    runner.grant(ast.NetworkPermission.any);
    runner.grant(ast.ProcessRunPermission.any);
    runner.grant(ast.IsolatePermission.any);
    runner.grant(ast.DangerousPermission.any);

    // Full generated bridge surface (AST-typed via buildkit_ast.yaml).
    ast_bridges.DartnativeGoAstBridges.register(runner);
    registerAstWidgetInterfaceProxies(runner, onLog: onLog);
    // Asset-aware Image/AssetImage overrides (last registration wins),
    // mirroring the source engine's registerAssetAwareBridges.
    registerAstAssetAwareBridges(
      runner,
      serverUrlProvider: () => currentServerUrl,
    );
    AstAssetResolver.activeServerUrl = currentServerUrl;

    Object? captureRunApp(
      ast.InterpreterVisitor visitor,
      List<Object?> positional,
      Map<String, Object?> named,
      List<ast.RuntimeType>? typeArgs,
    ) {
      if (positional.isNotEmpty) {
        _capturedApp = wrapAstInterpretedWidget(
          positional[0],
          visitor: visitor,
        );
      }
      return null;
    }

    for (final lib in [
      'package:dartnative/dartnative.dart',
      'package:dartnative/src/framework.dart',
      'package:flutter/widgets.dart',
      'package:flutter/material.dart',
    ]) {
      runner.registertopLevelFunction(
        'runApp',
        captureRunApp,
        lib,
        signature: 'void runApp(Widget app)',
      );
    }

    _runner = runner;
  }

  /// Executes [astBytes] (`AstBundle.fromBytes`, auto ZIP/gzip/JSON) and
  /// resolves the root widget or typed [name] result.
  Future<T> evaluateAstBundleAs<T>(
    List<int> astBytes, {
    String? entryPoint,
    String name = 'main',
    List<Object?>? positionalArgs,
    Map<String, Object?>? namedArgs,
    bool isHotReload = false,
  }) async {
    final totalSw = Stopwatch()..start();
    int snapMs = 0;
    if (isHotReload) {
      final snapSw = Stopwatch()..start();
      _snapshotState();
      try {
        _runner?.dispose();
      } catch (_) {}
      snapMs = snapSw.elapsedMilliseconds;
    }
    final initSw = Stopwatch()..start();
    initRunner();
    final initMs = initSw.elapsedMilliseconds;

    final runner = _runner!;
    final decodeSw = Stopwatch()..start();
    final bundle = decodeAstBundleBytes(astBytes);
    final decodeMs = decodeSw.elapsedMilliseconds;

    final effectiveEntry = resolveBundleEntry(bundle, entryPoint);
    if (entryPoint != null && effectiveEntry != entryPoint) {
      onLog?.call(
        '[AST] entryPoint "$entryPoint" not a bundle module; '
        'using "${bundle.entryPointUri}".',
      );
    }

    final execSw = Stopwatch()..start();
    Object? raw;
    await runZoned(
      () async {
        final result = runner.executeBundle(
          bundle,
          entryPoint: effectiveEntry,
          name: name,
          positionalArgs: positionalArgs,
          namedArgs: namedArgs,
        );
        raw = result is Future ? await result : result;
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          onLog?.call(line);
        },
      ),
    );
    final execMs = execSw.elapsedMilliseconds;

    int restoreMs = 0;
    if (isHotReload) {
      final restoreSw = Stopwatch()..start();
      _restoreState();
      restoreMs = restoreSw.elapsedMilliseconds;
    }

    DartGoLogger.bench(
      'AstInterpreter',
      'AST evaluate (${isHotReload ? "reload" : "initial"})',
      totalSw.elapsedMilliseconds,
      {
        'snap': snapMs,
        'init': initMs,
        'decode': decodeMs,
        'exec': execMs,
        'restore': restoreMs,
      },
    );

    if (T == Widget || T == dynamic) {
      final captured = _capturedApp;
      if (captured != null) return captured as T;
      try {
        return ast.D4.unwrapAs<T>(raw, visitor: runner.visitor);
      } catch (_) {}
    } else {
      try {
        return ast.D4.unwrapAs<T>(raw, visitor: runner.visitor);
      } catch (_) {}
    }

    if (raw != null && raw is T) return raw as T;
    throw StateError(
      'AST evaluation succeeded but could not resolve $T from entry `$name` '
      '($raw). Ensure main() calls runApp(Widget) or returns a Widget.',
    );
  }

  void dispose() {
    _snapshotState();
    _runner?.dispose();
    _runner = null;
    _capturedApp = null;
  }
}

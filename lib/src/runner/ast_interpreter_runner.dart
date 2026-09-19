import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

import 'ast_bundle_codec.dart';
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

  AstInterpreterRunner({this.onLog, this.onExit, this.currentServerUrl});

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
  }) async {
    initRunner();
    final runner = _runner!;
    final bundle = decodeAstBundleBytes(astBytes);
    final effectiveEntry = resolveBundleEntry(bundle, entryPoint);
    if (entryPoint != null && effectiveEntry != entryPoint) {
      onLog?.call(
        '[AST] entryPoint "$entryPoint" not a bundle module; '
        'using "${bundle.entryPointUri}".',
      );
    }

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

    if (T == Widget || T == dynamic) {
      final captured = _capturedApp;
      if (captured != null) return captured as T;
      try {
        return ast.D4.unwrapAs<T>(raw, visitor: null);
      } catch (_) {}
    } else {
      try {
        return ast.D4.unwrapAs<T>(raw, visitor: null);
      } catch (_) {}
    }

    if (raw != null && raw is T) return raw as T;
    throw StateError(
      'AST evaluation succeeded but could not resolve $T from entry `$name` '
      '($raw). Ensure main() calls runApp(Widget) or returns a Widget.',
    );
  }

  void dispose() {
    _runner = null;
    _capturedApp = null;
  }
}

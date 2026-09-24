import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:tom_ast_model/ast.dart' show SClassDeclaration;
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

  /// Guest code that threw outside evaluation — a build, a lifecycle method, a
  /// bridge callback. Relayed to the host (and through it to the `dart_go` CLI)
  /// so a runtime failure is not only visible on the device screen.
  void Function(Object error, StackTrace stack)? onGuestError;
  VoidCallback? onExit;

  /// Number of core `tom_d4rt_ast` runners constructed by this instance.
  ///
  /// Stays at 1 across hot reloads (the core runner, its bridge registrations
  /// and its warm stdlib/bridge parent are reused) and only increments after
  /// [dispose] — i.e. on hot restart, runtime-mode switch or unmount.
  int _coreRunnerGeneration = 0;

  /// Number of bundle evaluations performed (initial + reloads).
  int _evaluationCount = 0;

  /// Hot-reload declaration registry (Phase 2). Survives hot reloads so
  /// function bodies and variable storage are swapped in place; cleared by
  /// [dispose] (hot restart, runtime-mode switch, unmount) together with the
  /// core runner.
  final ast.DeclarationRegistry _declarationRegistry = ast.DeclarationRegistry();

  /// Decoded-bundle cache (Phase 5). Decoding a `.ast` archive is the single
  /// most expensive host-side step of a reload, and the dev server re-sends the
  /// same bytes whenever the edited module isn't the entry. Keyed by the bundle
  /// bytes' FNV-1a hash; the decoded AST is immutable from the runtime's point
  /// of view, and any module whose content did change arrives as new bytes.
  ast.AstBundle? _cachedBundle;
  int? _cachedBundleHash;
  int? _cachedBundleLength;
  bool _lastDecodeWasCacheHit = false;

  AstInterpreterRunner({
    this.onLog,
    this.onGuestError,
    this.onExit,
    this.currentServerUrl,
  });

  ast.InterpreterVisitor? get visitor => _runner?.visitor;

  /// Host-visible diagnostics: how many core runners this instance has built.
  int get coreRunnerGeneration => _coreRunnerGeneration;

  /// Host-visible diagnostics: how many bundles have been evaluated.
  int get evaluationCount => _evaluationCount;

  /// Host-visible diagnostics: the hot-reload declaration registry backing
  /// function-body swaps (hit/miss/swap/retirement counters + cell count).
  ast.DeclarationRegistry get declarationRegistry => _declarationRegistry;

  /// Creates the core runner + registers the full bridge surface exactly once.
  ///
  /// Idempotent: repeated calls (one per evaluation) keep the existing runner,
  /// its bridge registrations and its warm stdlib/bridge parent alive, so a hot
  /// reload no longer pays for bridge re-registration. Server-scoped values
  /// are refreshed so a URL change still reaches the asset bridges.
  void initRunner() {
    AstAssetResolver.activeServerUrl = currentServerUrl;
    if (_runner != null) return;

    final runner = ast.D4rtRunner(declarationRegistry: _declarationRegistry);
    runner.grant(ast.FilesystemPermission.any);
    runner.grant(ast.NetworkPermission.any);
    runner.grant(ast.ProcessRunPermission.any);
    runner.grant(ast.IsolatePermission.any);
    runner.grant(ast.DangerousPermission.any);

    // Full generated bridge surface (AST-typed via buildkit_ast.yaml).
    ast_bridges.DartnativeGoAstBridges.register(runner);
    registerAstWidgetInterfaceProxies(
      runner,
      onLog: onLog,
      onError: onGuestError,
    );
    // Asset-aware Image/AssetImage overrides (last registration wins),
    // mirroring the source engine's registerAssetAwareBridges.
    registerAstAssetAwareBridges(
      runner,
      serverUrlProvider: () => currentServerUrl,
    );

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
    _coreRunnerGeneration++;
  }

  /// Executes [astBytes] (`AstBundle.fromBytes`, auto ZIP/gzip/JSON) and
  /// resolves the root widget or typed [name] result.
  ///
  /// The core runner is created once and reused across evaluations (see
  /// [initRunner]). State preservation across a hot reload is the runtime's
  /// job, not the host's: the declaration registry keeps function bodies and
  /// variable storage stable (Phases 2 + 3), so there is no snapshot/restore
  /// pass here any more — the previous Provider/Notifier-name heuristic is
  /// gone, and every top-level and static value survives a reload.
  Future<T> evaluateAstBundleAs<T>(
    List<int> astBytes, {
    String? entryPoint,
    String name = 'main',
    List<Object?>? positionalArgs,
    Map<String, Object?>? namedArgs,
    bool isHotReload = false,
    Map<String, String> moduleFingerprints = const {},
  }) async {
    final totalSw = Stopwatch()..start();
    _capturedApp = null;
    final initSw = Stopwatch()..start();
    final hadCoreRunner = _runner != null;
    initRunner();
    final initMs = initSw.elapsedMilliseconds;
    final reusedCoreRunner = hadCoreRunner;

    final runner = _runner!;
    final decodeSw = Stopwatch()..start();
    final bundle = _decodeBundle(astBytes);
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
          moduleFingerprints: moduleFingerprints,
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
    _evaluationCount++;

    DartGoLogger.bench(
      'AstInterpreter',
      'AST evaluate (${isHotReload ? "reload" : "initial"})',
      totalSw.elapsedMilliseconds,
      {
        'init': initMs,
        'decode': decodeMs,
        'exec': execMs,
        'core_runner': reusedCoreRunner ? 'reused' : 'new',
        'decode_cache': _lastDecodeWasCacheHit ? 'hit' : 'miss',
        'decl_cells': _declarationRegistry.cellCount,
        'var_cells': _declarationRegistry.variableCellCount,
        'decl_swaps': _declarationRegistry.swaps,
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

  /// Decodes [bytes], reusing the last decoded bundle when the content hash
  /// matches (Phase 5).
  /// Widget class name to defining module URI, for the decoded bundle.
  ///
  /// The generation tracker maps a changed file to the widget classes that must
  /// remount. In source mode it scrapes that map out of the bundle's source
  /// text; an AST bundle carries no sources, so it is derived from the decoded
  /// compilation units instead. Without it a widget defined outside the entry
  /// module never gets a new generation and its subtree is never rebuilt.
  Map<String, String> get classFileMap => _classFileMap;
  Map<String, String> _classFileMap = const {};

  ast.AstBundle _decodeBundle(List<int> bytes) {
    final hash = _fnv1a64(bytes);
    final cached = _cachedBundle;
    if (cached != null &&
        _cachedBundleHash == hash &&
        _cachedBundleLength == bytes.length) {
      _lastDecodeWasCacheHit = true;
      return cached;
    }
    _classFileMap = const {};
    final decoded = decodeAstBundleBytes(bytes);
    _classFileMap = _classFilesOf(decoded);
    _cachedBundle = decoded;
    _cachedBundleHash = hash;
    _cachedBundleLength = bytes.length;
    _lastDecodeWasCacheHit = false;
    return decoded;
  }

  static Map<String, String> _classFilesOf(ast.AstBundle bundle) {
    final map = <String, String>{};
    bundle.modules.forEach((uri, unit) {
      for (final declaration in unit.declarations) {
        if (declaration is SClassDeclaration) {
          final name = declaration.name?.name;
          if (name != null && name.isNotEmpty) map[name] = uri;
        }
      }
    });
    return map;
  }

  /// FNV-1a 64-bit over [bytes] (same hash the dev server uses for bundles).
  static int _fnv1a64(List<int> bytes) {
    var hash = 0xcbf29ce484222325;
    const prime = 0x100000001b3;
    for (final byte in bytes) {
      hash ^= byte;
      hash = (hash * prime) & 0xFFFFFFFFFFFFFFFF;
    }
    return hash;
  }

  /// Drops the core runner and all preserved state (hot restart / mode switch /
  /// unmount). The next evaluation builds a fresh runner, so
  /// [coreRunnerGeneration] increments.
  void dispose() {
    _declarationRegistry.clear();
    _cachedBundle = null;
    _cachedBundleHash = null;
    _cachedBundleLength = null;
    try {
      _runner?.dispose();
    } catch (_) {}
    _runner = null;
    _capturedApp = null;
  }
}

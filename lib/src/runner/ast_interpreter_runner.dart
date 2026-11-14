import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:tom_ast_model/ast.dart' show SClassDeclaration;
import 'package:tom_d4rt_ast/runtime.dart' as ast;

import 'ast_bundle_codec.dart';
import 'ast_profile.dart';
import 'guest_runner.dart';
import 'logger.dart';
import '../cli/server_components/server_annotation_scanner.dart';
import '../interpreter/ast/ast_asset_bridge.dart';
import '../interpreter/ast/host_api_bridge.dart';
import '../interpreter/ast/ast_widget_proxies.dart';
import '../interpreter/ast/dartscript.b.dart' as ast_bridges;
import '../interpreter/ast/isolate_compute_bridge.dart';
import '../interpreter/ast/server_component_bridge.dart';
import '../widgets/server_component_loader.dart';

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

  /// Guest build failures that left no rendered child, so the host must take
  /// over the whole screen instead of floating a banner over a blank surface.
  GuestBlankBuildReporter? onGuestBlankBuild;

  /// Fires when a previously blank guest surface builds a child again, so the
  /// host can remove its error view without exposing a blank frame.
  VoidCallback? onGuestRecovered;
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
  final ast.DeclarationRegistry _declarationRegistry =
      ast.DeclarationRegistry();

  /// Decoded-bundle cache (Phase 5). Decoding a `.ast` archive is the single
  /// most expensive host-side step of a reload, and the dev server re-sends the
  /// same bytes whenever the edited module isn't the entry. Keyed by the bundle
  /// bytes' FNV-1a hash; the decoded AST is immutable from the runtime's point
  /// of view, and any module whose content did change arrives as new bytes.
  ast.AstBundle? _cachedBundle;
  int? _cachedBundleHash;
  int? _cachedBundleLength;
  bool _lastDecodeWasCacheHit = false;

  /// Enables detailed module/class/plugin diagnostics for the next evaluation.
  /// Gates verbose log output only — per-module timing maps are always
  /// collected (a few hundred map entries) so the in-app AST viewer
  /// ([lastAstProfile]) has load data without verbose logging.
  bool profileExecution = false;

  /// Retained per-module timings from the last evaluation. Written on every
  /// evaluation (initial + reload); read on demand by [lastAstProfile].
  /// Cleared by [dispose].
  Map<String, int> _lastModuleLoadMicros = const {};
  Map<String, int> _lastModuleLoadCounts = const {};
  Map<String, int> _lastModuleCacheHits = const {};
  Map<String, int> _lastBridgedSymbols = const {};
  int? _lastMainMicros;
  bool _lastWasHotReload = false;

  /// Memoized profile snapshot + dirty flag.
  ///
  /// [buildAstProfile] sizes every module and class by serializing its AST to
  /// JSON — far too expensive to run per widget build. [lastAstProfile] is read
  /// from `main.dart`'s `build` on *every* rebuild, so the walk must run once
  /// per bundle evaluation, not per frame. [_profileDirty] is set wherever the
  /// bundle or the retained timing maps change; the getter recomputes lazily on
  /// the next read and otherwise returns the cache.
  AstProfileSnapshot? _cachedProfile;
  bool _profileDirty = true;

  /// Structured snapshot of the last bundle evaluation for the AST viewer.
  ///
  /// Computed on demand from the decoded bundle plus the retained timing maps,
  /// then memoized until the next evaluation ([_profileDirty]). Null before the
  /// first evaluation or after [dispose].
  AstProfileSnapshot? get lastAstProfile {
    if (!_profileDirty) return _cachedProfile;
    _profileDirty = false;
    final bundle = _cachedBundle;
    if (bundle == null) {
      _cachedProfile = null;
      return null;
    }
    _cachedProfile = buildAstProfile(
      bundle: bundle,
      moduleLoadMicros: _lastModuleLoadMicros,
      moduleLoadCounts: _lastModuleLoadCounts,
      moduleCacheHits: _lastModuleCacheHits,
      bridgedSymbols: _lastBridgedSymbols,
      mainMicros: _lastMainMicros,
      isHotReload: _lastWasHotReload,
    );
    return _cachedProfile;
  }

  AstInterpreterRunner({
    this.onLog,
    this.onGuestError,
    this.onGuestBlankBuild,
    this.onGuestRecovered,
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

  List<int>? _cachedBundleBytes;

  /// Module fingerprints from the last full-bundle evaluation, forwarded to
  /// component loads so registry cache matches succeed for unchanged client
  /// modules (see `D4rtRunner.executeComponentBundle`).
  Map<String, String> _lastModuleFingerprints = const {};

  /// Loader backing the `ServerComponentView` guest bridge. Created lazily
  /// so runners that never serve components pay nothing; the loader reads
  /// the live [currentServerUrl] per fetch. Closed by [dispose].
  ServerComponentLoader? _componentLoader;
  ServerComponentLoader get componentLoader =>
      _componentLoader ??= ServerComponentLoader(
        serverUrl: currentServerUrl ?? '',
        serverUrlProvider: () => currentServerUrl ?? '',
        runner: this,
      );

  /// The active bundle bytes for this runner, accessible to worker isolates.
  List<int>? get cachedBundleBytes => _cachedBundleBytes;

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
    registerAstComputeBridge(runner);
    registerAstWidgetInterfaceProxies(
      runner,
      onLog: onLog,
      onError: onGuestError,
      onBlankBuild: onGuestBlankBuild,
      onRecovered: onGuestRecovered,
    );
    // Asset-aware Image/AssetImage overrides (last registration wins),
    // mirroring the source engine's registerAssetAwareBridges.
    registerAstAssetAwareBridges(
      runner,
      serverUrlProvider: () => currentServerUrl,
    );
    // Host ServerComponentView for guest code
    // (`package:dartnative_go/server_component.dart`). The loader reads the
    // live server URL per fetch, so URL changes after init are picked up.
    registerServerComponentBridge(runner, loader: componentLoader);
    // Host API for interpreted UI (`package:dartnative_go_api/host_api.dart`).
    registerAstHostApiBridge(runner);

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
      'package:dartnative/flutter_compat.dart',
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

    // Mirror of the source engine (interpreter_runner.dart §4b):
    // `unawaited()` from dart:async. Without this, guest code calling it
    // fails in AST mode with "Default bridged constructor adapter for
    // 'unawaited' returned null".
    Object? captureUnawaited(
      ast.InterpreterVisitor visitor,
      List<Object?> positional,
      Map<String, Object?> named,
      List<ast.RuntimeType>? typeArgs,
    ) {
      final arg = positional.isNotEmpty ? positional[0] : null;
      if (arg is Future) {
        arg.ignore();
      }
      return null;
    }

    for (final lib in [
      'dart:async',
      'package:dartnative/dartnative.dart',
      'package:dartnative/flutter_compat.dart',
      'package:dartnative/src/framework.dart',
    ]) {
      runner.registertopLevelFunction(
        'unawaited',
        captureUnawaited,
        lib,
        signature: 'void unawaited(Future<void> future)',
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
    List<int>? astPatchBytes,
    bool isPatch = false,
    String? entryPoint,
    String name = 'main',
    List<Object?>? positionalArgs,
    Map<String, Object?>? namedArgs,
    bool isHotReload = false,
    Map<String, String> moduleFingerprints = const {},
  }) async {
    final totalSw = Stopwatch()..start();
    _capturedApp = null;
    _lastModuleFingerprints = Map<String, String>.of(moduleFingerprints);
    final initSw = Stopwatch()..start();
    final hadCoreRunner = _runner != null;
    initRunner();
    // Self-synchronize the profile gate with global verbosity: embedders may
    // set profileExecution explicitly, but verbose device logs must also
    // enable profile output (mirrors the assignment host runners perform).
    profileExecution = DartGoLogger.verbose;
    final initMs = initSw.elapsedMilliseconds;
    final reusedCoreRunner = hadCoreRunner;

    final runner = _runner!;
    // Timing maps are always collected: a few hundred integer entries that
    // feed both the verbose [PROFILE] logs and the on-demand AST viewer
    // ([lastAstProfile]). Only the log output is gated on [profileExecution].
    final moduleLoadMicros = <String, int>{};
    final moduleLoadCounts = <String, int>{};
    final moduleCacheHits = <String, int>{};
    final bridgedSymbols = <String, int>{};
    int? mainMicros;
    runner.onModuleLoadProfile =
        (uri, elapsedMicros, isBundleModule, cacheHit, symbolCount) {
          if (cacheHit) {
            moduleCacheHits.update(
              uri,
              (count) => count + 1,
              ifAbsent: () => 1,
            );
            return;
          }
          moduleLoadMicros.update(
            uri,
            (total) => total + elapsedMicros,
            ifAbsent: () => elapsedMicros,
          );
          moduleLoadCounts.update(
            uri,
            (count) => count + 1,
            ifAbsent: () => 1,
          );
          if (!isBundleModule && symbolCount > 0) {
            bridgedSymbols[uri] = symbolCount;
          }
        };
    runner.onFunctionProfile = (name, elapsedMicros) {
      if (name == 'main') mainMicros = elapsedMicros;
    };

    final decodeSw = Stopwatch()..start();
    final ast.AstBundle bundle;
    if (isPatch &&
        astPatchBytes != null &&
        astPatchBytes.isNotEmpty &&
        _cachedBundle != null) {
      final patch = decodeAstBundleBytes(astPatchBytes);
      bundle = _cachedBundle!.applyPatch(patch);
      _cachedBundle = bundle;
      _classFileMap = {..._classFileMap, ..._classFilesOf(patch)};
      _lastDecodeWasCacheHit = false;
    } else {
      if (astBytes.isNotEmpty) {
        _cachedBundleBytes = astBytes;
        ast.D4rtIsolateWorker.activeBundleBytes = astBytes;
      }
      bundle = _decodeBundle(astBytes);
    }
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
    if (ast.D4rtProfiler.enabled) {
      ast.D4rtProfiler.reset();
    }
    try {
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
    } finally {
      if (ast.D4rtProfiler.enabled) {
        final report = ast.D4rtProfiler.report(
          title:
              'D4rt AST init profile (${isHotReload ? "reload" : "initial"})',
        );
        for (final line in report.split('\n')) {
          DartGoLogger.debug(line, tag: 'D4rtProfiler');
        }
      }
    }
    final execMs = execSw.elapsedMilliseconds;
    _evaluationCount++;

    String formatBytes(int bytes) =>
        bytes >= 1024 ? '${(bytes / 1024).toStringAsFixed(1)}KiB' : '${bytes}B';

    // Retain timings for the on-demand AST viewer ([lastAstProfile]).
    _lastModuleLoadMicros = Map.of(moduleLoadMicros);
    _lastModuleLoadCounts = Map.of(moduleLoadCounts);
    _lastModuleCacheHits = Map.of(moduleCacheHits);
    _lastBridgedSymbols = Map.of(bridgedSymbols);
    _lastMainMicros = mainMicros;
    _lastWasHotReload = isHotReload;
    // Invalidate the memoized viewer profile: the bundle/timings just changed.
    _profileDirty = true;

    void logExecutionProfile(AstProfileSnapshot profile) {
      final sized = profile.hasSizeMetadata;
      DartGoLogger.debug(
        '[PROFILE] bundle: modules=${profile.moduleCount}, '
        'AST=${sized ? formatBytes(profile.totalAstBytes) : 'sizes unavailable (rebuild guest.ast)'}, '
        'source=${!profile.hasSources
            ? 'not bundled'
            : sized
            ? formatBytes(profile.totalSourceBytes)
            : 'sizes unavailable'}, '
        'classes=${profile.totalClasses}, mainCallSync=${profile.mainMs == null ? 'n/a' : '${profile.mainMs!.toStringAsFixed(1)}ms'}',
        tag: 'AstInterpreter',
      );

      for (final module in profile.modules.take(10)) {
        DartGoLogger.debug(
          '[PROFILE] module ${module.uri}: AST=${sized ? formatBytes(module.astBytes) : '?'}, '
          'source=${module.sourceBytes == null ? 'n/a' : formatBytes(module.sourceBytes!)} '
          'classes=${module.classCount}, '
          'loadTotal=${module.loadMicros == null ? 'not loaded' : '${(module.loadMicros! / 1000).toStringAsFixed(1)}ms inclusive'}, '
          'loads=${module.loads}, cacheHits=${module.cacheHits}',
          tag: 'AstInterpreter',
        );
      }

      for (final slow in profile.slowestModules) {
        final elapsedMicros = slow.loadMicros;
        final loads = slow.loads;
        DartGoLogger.debug(
          '[PROFILE] slow module ${slow.uri}: '
          'loadTotal=${(elapsedMicros / 1000).toStringAsFixed(1)}ms inclusive, '
          'avg=${(elapsedMicros / loads / 1000).toStringAsFixed(1)}ms across $loads loads, '
          'AST=${sized ? formatBytes(slow.astBytes) : '?'}',
          tag: 'AstInterpreter',
        );
      }

      for (final clazz in profile.largestClasses.take(10)) {
        DartGoLogger.debug(
          '[PROFILE] class ${clazz.uri}::${clazz.name}: AST=${sized ? formatBytes(clazz.astBytes) : '?'}',
          tag: 'AstInterpreter',
        );
      }

      for (final lib in profile.bridgedLibs.take(10)) {
        DartGoLogger.debug(
          '[PROFILE] bridged library ${lib.uri}: symbols=${lib.symbols}, '
          'loadTotal=${lib.loadMicros == null ? 'cached' : '${(lib.loadMicros! / 1000).toStringAsFixed(1)}ms'}',
          tag: 'AstInterpreter',
        );
      }
    }

    // Profile the launch itself. This is timed (and reported in the bench line)
    // because it used to be invisible: it runs after `exec` and could cost more
    // than decode + execute together when it serialized the bundle.
    var profileMs = 0;
    if (profileExecution) {
      final profileSw = Stopwatch()..start();
      // Launch-path logging must never serialize the bundle: sizes come from
      // the manifest when present, and are simply reported as unavailable for
      // older bundles instead of costing seconds of `jsonEncode` on device.
      logExecutionProfile(
        buildAstProfile(
          bundle: bundle,
          moduleLoadMicros: moduleLoadMicros,
          moduleLoadCounts: moduleLoadCounts,
          moduleCacheHits: moduleCacheHits,
          bridgedSymbols: bridgedSymbols,
          mainMicros: mainMicros,
          isHotReload: isHotReload,
          allowSerialization: false,
        ),
      );
      profileMs = profileSw.elapsedMilliseconds;
    }

    DartGoLogger.bench(
      'AstInterpreter',
      'AST evaluate (${isHotReload ? "reload" : "initial"})',
      totalSw.elapsedMilliseconds,
      {
        'init': initMs,
        'decode': decodeMs,
        'exec': execMs,
        'profile': profileMs,
        'core_runner': reusedCoreRunner ? 'reused' : 'new',
        'decode_cache': _lastDecodeWasCacheHit ? 'hit' : 'miss',
        // Counts, not durations: string values keep the logger from
        // appending an `ms` unit to them.
        'decl_cells': '${_declarationRegistry.cellCount} cells',
        'var_cells': '${_declarationRegistry.variableCellCount} cells',
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

  /// Loads a library [AstBundle] without running any entry point.
  ///
  /// Component-only evaluation mode: declaration + interpretation passes run
  /// for every module in the bundle, but no `main()` (or any function) is
  /// invoked. Used by the server-component harness to pre-load the client
  /// bundle headlessly — tests then load deltas via [loadServerComponent]
  /// and resolve classes via [resolveTopLevel].
  ///
  /// The decoded bundle occupies the client decode slot (same as a full
  /// evaluation), so [moduleFingerprints] are remembered for later
  /// component loads.
  Future<void> preloadBundle(
    List<int> astBytes, {
    String? entryPoint,
    Map<String, String> moduleFingerprints = const {},
  }) async {
    initRunner();
    if (astBytes.isNotEmpty) {
      _cachedBundleBytes = astBytes;
      ast.D4rtIsolateWorker.activeBundleBytes = astBytes;
    }
    final bundle = _decodeBundle(astBytes);
    _lastModuleFingerprints = Map<String, String>.of(moduleFingerprints);
    await runZoned(
      () async {
        _runner!.executeComponentBundle(
          bundle,
          entryPoint: entryPoint,
          moduleFingerprints: moduleFingerprints,
        );
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          onLog?.call(line);
        },
      ),
    );
    _evaluationCount++;
  }

  /// Loads one server-component delta bundle and resolves its class.
  ///
  /// The [astBytes] chunk (as emitted under `server_components/`) is merged
  /// into the live execution: client-shared imports resolve from the
  /// already-loaded modules by reference. Returns the component's class, or
  /// null when no loaded module declares it.
  ///
  /// The component id and the class name usually differ (`profile_card` vs
  /// `ProfileCard`), so the bundle is scanned for the annotation carrying
  /// [componentId] and the annotated class name is resolved. When the bundle
  /// carries no matching annotation, [componentId] itself is used as the
  /// class name (id-doubles-as-name convention).
  ///
  /// Component bytes deliberately bypass the client decode cache
  /// ([decodeAstBundleBytes] instead of [_decodeBundle]) so a component
  /// load can never evict the client bundle a pending hot-reload patch
  /// applies against.
  Future<ast.InterpretedClass?> loadServerComponent({
    required String componentId,
    required List<int> astBytes,
    Map<String, String>? expectedFingerprints,
  }) async {
    initRunner();
    final bundle = decodeAstBundleBytes(astBytes);
    _classFileMap = {..._classFileMap, ..._classFilesOf(bundle)};
    final fps = expectedFingerprints ?? _lastModuleFingerprints;
    await runZoned(
      () async {
        _runner!.executeComponentBundle(
          bundle,
          moduleFingerprints: fps,
        );
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          onLog?.call(line);
        },
      ),
    );
    _evaluationCount++;
    return _runner!.resolveTopLevel(
      _componentClassName(bundle, componentId),
    );
  }

  /// Maps a component id to its annotated class name by scanning [bundle].
  ///
  /// Falls back to [componentId] when no annotation matches (covers bundles
  /// whose class is literally named after the component id).
  static String _componentClassName(
    ast.AstBundle bundle,
    String componentId,
  ) {
    for (final component in ServerAnnotationScanner.scanBundle(bundle)) {
      if (component.componentId == componentId) return component.className;
    }
    return componentId;
  }

  /// Resolves a top-level class by [name] across every loaded module
  /// (client bundle first, then server components newest-first).
  ///
  /// Returns null when nothing is loaded yet or no module declares [name].
  ast.InterpretedClass? resolveTopLevel(String name) {
    final runner = _runner;
    if (runner == null) return null;
    return runner.resolveTopLevel(name);
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
    _profileDirty = true;
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
    _lastModuleLoadMicros = const {};
    _lastModuleLoadCounts = const {};
    _lastModuleCacheHits = const {};
    _lastBridgedSymbols = const {};
    _lastMainMicros = null;
    _cachedProfile = null;
    _profileDirty = true;
    try {
      _componentLoader?.bundleLoader.close();
    } catch (_) {}
    _componentLoader = null;
    try {
      _runner?.dispose();
    } catch (_) {}
    detachAstHostApiListeners();
    _runner = null;
    _capturedApp = null;
  }
}

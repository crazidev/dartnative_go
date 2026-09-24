/// Headless test harness for dartnative_go — no mobile app required.
///
/// Wraps [InterpreterRunner] (source/analyzer mode, the default) and
/// [AstInterpreterRunner] (pre-compiled AST mode, opt-in) behind one API so
/// every scenario — hot reload, hot restart, mode switching, plugin checks —
/// runs on the host VM with `package:test`.
///
/// Usage:
/// ```dart
/// final h = DnHarness(mode: DnMode.source, logs: logs.add);
/// final root = await h.evaluate({'main.dart': '...'});
/// await h.hotReload({'main.dart': '... v2 ...'});
/// await h.hotRestart({'main.dart': '... v2 ...'});
/// ```
library;

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/interpreter/auto_import_parser.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/runner/interpreter_runner.dart';
import 'package:tom_d4rt/d4rt.dart';

/// Which interpreter engine the harness drives.
enum DnMode {
  /// `tom_d4rt` — analyzer-based on-device execution (default).
  source,

  /// `tom_d4rt_ast` — analyzer-free pre-compiled bundle (opt-in).
  ast,
}

/// Headless driver for evaluating guest apps without a mobile device.
class DnHarness {
  DnMode mode;

  /// Raw guest files keyed by relative path (`main.dart`, `prefs_screen.dart`).
  Map<String, String> guestFiles;

  /// Package name used for the virtual source map (`package:<name>/main.dart`).
  final String packageName;

  final void Function(String message)? onLog;

  /// Bridge overrides installed on EVERY fresh source runner, after the
  /// generated bridges register and before the first evaluate (last
  /// registration wins while no bridged module env is built yet). Use for
  /// per-plugin host fakes, e.g. `installFakeSharedPreferences`.
  final List<void Function(D4rt interpreter)> bridgeOverrides;

  late InterpreterRunner _sourceRunner;
  AstInterpreterRunner? _astRunner;

  /// Last resolved root widget (from `runApp` capture or `main` return).
  Widget? lastRoot;

  /// Last entrypoint library used.
  String lastLibrary = '';

  DnHarness({
    this.mode = DnMode.source,
    this.guestFiles = const {},
    this.packageName = 'guest_app',
    this.onLog,
    this.bridgeOverrides = const [],
  }) {
    _sourceRunner = _newSourceRunner();
  }

  /// Fresh source runner with [bridgeOverrides] applied. Every evaluate /
  /// restart path must go through here so fakes survive runner recreation.
  InterpreterRunner _newSourceRunner() {
    final runner = InterpreterRunner(
      onLog: onLog,
      useAst: false,
      useBytecode: false,
    );
    for (final override in bridgeOverrides) {
      override(runner.interpreter);
    }
    return runner;
  }

  InterpreterRunner get sourceRunner => _sourceRunner;
  AstInterpreterRunner? get astRunner => _astRunner;

  Map<String, String> _virtualMap(Map<String, String> files) =>
      AutoImportParser.buildVirtualSourceMap(files, packageName: packageName);

  String _libraryFor(Map<String, String> vmap) {
    const candidates = <String>[];
    final pkgMain = 'package:$packageName/main.dart';
    if (vmap.containsKey(pkgMain)) return pkgMain;
    if (vmap.containsKey('package:guest_app/main.dart')) {
      return 'package:guest_app/main.dart';
    }
    if (vmap.containsKey('main.dart')) return 'main.dart';
    if (candidates.isNotEmpty) return candidates.first;
    if (vmap.isNotEmpty) return vmap.keys.first;
    return pkgMain;
  }

  /// Evaluates [files] (or the harness [guestFiles]) from scratch.
  Future<Widget> evaluate([Map<String, String>? files]) async {
    final raw = files ?? guestFiles;
    guestFiles = Map.of(raw);
    final vmap = _virtualMap(raw);
    final library = _libraryFor(vmap);
    lastLibrary = library;
    final code = vmap[library] ?? vmap.values.first;

    // Fresh interpreter for a clean launch.
    _sourceRunner = _newSourceRunner();
    lastRoot = await _sourceRunner.evaluate(
      source: code,
      library: library,
      sources: vmap,
      isHotReload: false,
    );
    return lastRoot!;
  }

  /// Simulates hot reload: re-evaluates with state preservation
  /// (`isHotReload: true` → snapshot/restore path in `InterpreterRunner`).
  Future<Widget> hotReload(Map<String, String> newFiles) async {
    guestFiles = Map.of(newFiles);
    final vmap = _virtualMap(newFiles);
    final library = _libraryFor(vmap);
    lastLibrary = library;
    final code = vmap[library] ?? vmap.values.first;
    lastRoot = await _sourceRunner.evaluate(
      source: code,
      library: library,
      sources: vmap,
      isHotReload: true,
    );
    return lastRoot!;
  }

  /// Simulates hot restart: drops the interpreter and evaluates fresh
  /// (all state reset).
  Future<Widget> hotRestart(Map<String, String> newFiles) async {
    guestFiles = Map.of(newFiles);
    try {
      _sourceRunner.unmount();
    } catch (_) {}
    _sourceRunner = _newSourceRunner();
    final vmap = _virtualMap(newFiles);
    final library = _libraryFor(vmap);
    lastLibrary = library;
    final code = vmap[library] ?? vmap.values.first;
    lastRoot = await _sourceRunner.evaluate(
      source: code,
      library: library,
      sources: vmap,
      isHotReload: false,
    );
    return lastRoot!;
  }

  /// Evaluates pre-compiled AST [bytes] via the analyzer-free engine.
  Future<Widget> evaluateAstBytes(
    List<int> bytes, {
    String? entryPoint,
    bool isHotReload = false,
  }) async {
    mode = DnMode.ast;
    _astRunner ??= AstInterpreterRunner(onLog: onLog);
    lastRoot = await _astRunner!.evaluateAstBundleAs<Widget>(
      bytes,
      entryPoint: entryPoint,
      isHotReload: isHotReload,
    );
    return lastRoot!;
  }

  /// Calls a top-level [functionName] in the current interpreter session.
  ///
  /// Suited for pure functions (computations, getters). NOTE: mutated
  /// interpreted state (statics, top-levels) is per-`execute` isolated, so a
  /// write from a tapped callback is NOT reliably visible here — verify tap
  /// side effects through host-visible channels instead: `onLog` prints,
  /// bridge fakes (see `test/test_lab/fakes/`), or provider containers.
  /// (Plugin calls work across executes precisely because bridges hold
  /// state in host memory.)
  Future<Object?> callFunction(
    String functionName, {
    List<Object?> positionalArgs = const [],
    Map<String, Object?> namedArgs = const {},
  }) async {
    final vmap = _virtualMap(guestFiles);
    final library = lastLibrary.isNotEmpty ? lastLibrary : _libraryFor(vmap);
    final code = vmap[library] ?? vmap.values.first;
    Object? raw = _sourceRunner.interpreter.execute(
      source: code,
      name: functionName,
      library: library,
      sources: vmap,
    );
    if (raw is Future) raw = await raw;
    return raw;
  }

  /// Switches the harness mode flag (source ⇄ ast).
  void switchMode(DnMode next) {
    mode = next;
  }

  void dispose() {
    try {
      _sourceRunner.unmount();
    } catch (_) {}
    try {
      _astRunner?.dispose();
    } catch (_) {}
    _astRunner = null;
  }
}

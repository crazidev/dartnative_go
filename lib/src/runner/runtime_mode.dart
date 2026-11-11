/// Runtime engine selection for DartNative Go guest execution.
///
/// AST (default) uses `tom_d4rt_ast` / `tom_d4rt_flutter_ast` with
/// pre-compiled `AstBundle` bytes (analyzer-free, OTA/web-safe).
/// Source uses `tom_d4rt` with on-device `package:analyzer` parsing.
enum RuntimeMode { source, ast }

/// Global default. AST is the default engine now.
const bool kUseAst = true;

const RuntimeMode kDefaultRuntimeMode = RuntimeMode.ast;

/// Whether the analyzer-based Source runtime is linked into this binary.
/// Set before `runApp` by development entrypoints (e.g. `main_source.dart`).
bool kSourceRuntimeLinked = false;

/// Available runtime modes based on linked engines.
List<RuntimeMode> get selectableRuntimeModes =>
    kSourceRuntimeLinked ? RuntimeMode.values : const [RuntimeMode.ast];

extension RuntimeModeX on RuntimeMode {
  bool get isSource => this == RuntimeMode.source;
  bool get isAst => this == RuntimeMode.ast;

  String get label => switch (this) {
    RuntimeMode.source => 'Source',
    RuntimeMode.ast => 'AST',
  };

  /// Cycle order: AST -> Source -> AST, restricted to linked modes.
  RuntimeMode get next {
    final modes = selectableRuntimeModes;
    if (modes.length <= 1) return this;
    final index = modes.indexOf(this);
    return modes[(index < 0 ? 0 : index + 1) % modes.length];
  }
}

RuntimeMode runtimeModeFromBool(bool useAst) =>
    useAst ? RuntimeMode.ast : RuntimeMode.source;

RuntimeMode runtimeModeFromName(String? name) {
  if (name == null) return kDefaultRuntimeMode;
  for (final m in RuntimeMode.values) {
    if (m.name.toLowerCase() == name.toLowerCase()) return m;
  }
  return kDefaultRuntimeMode;
}

bool flagsFromRuntimeMode(RuntimeMode mode) => mode == RuntimeMode.ast;

/// Clamps a stored/requested mode to one this binary can actually run.
///
/// A persisted `source` selection from a debug build must not strand a product
/// build in a mode whose runtime is not linked.
RuntimeMode supportedRuntimeMode(RuntimeMode mode) =>
    selectableRuntimeModes.contains(mode) ? mode : kDefaultRuntimeMode;

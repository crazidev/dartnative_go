/// Runtime engine selection for DartNative Go guest execution.
///
/// AST (default) uses `tom_d4rt_ast` / `tom_d4rt_flutter_ast` with
/// pre-compiled `AstBundle` bytes (analyzer-free, OTA/web-safe).
/// Source uses `tom_d4rt` with on-device `package:analyzer` parsing.
enum RuntimeMode { source, ast }

/// Global default. AST is the default engine now.
const bool kUseAst = true;

const RuntimeMode kDefaultRuntimeMode = RuntimeMode.ast;

/// Modes a user can actually select right now.
List<RuntimeMode> get selectableRuntimeModes => RuntimeMode.values;

extension RuntimeModeX on RuntimeMode {
  bool get isSource => this == RuntimeMode.source;
  bool get isAst => this == RuntimeMode.ast;

  String get label => switch (this) {
    RuntimeMode.source => 'Source',
    RuntimeMode.ast => 'AST',
  };

  /// Cycle order: AST -> Source -> AST.
  RuntimeMode get next => switch (this) {
    RuntimeMode.ast => RuntimeMode.source,
    RuntimeMode.source => RuntimeMode.ast,
  };
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

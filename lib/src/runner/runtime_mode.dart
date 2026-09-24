/// Runtime engine selection for DartNative Go guest execution.
///
/// AST (default) uses `tom_d4rt_ast` / `tom_d4rt_flutter_ast` with
/// pre-compiled `AstBundle` bytes (analyzer-free, OTA/web-safe).
/// Bytecode uses `BytecodeVM` stack-based interpreter.
/// Source uses `tom_d4rt` with on-device `package:analyzer` parsing.
enum RuntimeMode { source, ast, bytecode }

/// Global default. AST is the default engine now.
const bool kUseAst = true;
const bool kUseBytecode = false;

const RuntimeMode kDefaultRuntimeMode = RuntimeMode.ast;

extension RuntimeModeX on RuntimeMode {
  bool get isSource => this == RuntimeMode.source;
  bool get isAst => this == RuntimeMode.ast;
  bool get isBytecode => this == RuntimeMode.bytecode;

  String get label => switch (this) {
    RuntimeMode.source => 'Source (tom_d4rt)',
    RuntimeMode.ast => 'AST (tom_d4rt_ast)',
    RuntimeMode.bytecode => 'Bytecode (Stack VM)',
  };

  /// Cycle order: AST -> Bytecode -> Source -> AST
  RuntimeMode get next => switch (this) {
    RuntimeMode.ast => RuntimeMode.bytecode,
    RuntimeMode.bytecode => RuntimeMode.source,
    RuntimeMode.source => RuntimeMode.ast,
  };
}

RuntimeMode runtimeModeFromBool(bool useAst, [bool useBytecode = false]) {
  if (useBytecode) return RuntimeMode.bytecode;
  return useAst ? RuntimeMode.ast : RuntimeMode.source;
}

RuntimeMode runtimeModeFromName(String? name) {
  if (name == null) return kDefaultRuntimeMode;
  for (final m in RuntimeMode.values) {
    if (m.name.toLowerCase() == name.toLowerCase()) return m;
  }
  return kDefaultRuntimeMode;
}

(bool useAst, bool useBytecode) flagsFromRuntimeMode(RuntimeMode mode) => switch (mode) {
  RuntimeMode.ast => (true, false),
  RuntimeMode.bytecode => (false, true),
  RuntimeMode.source => (false, false),
};


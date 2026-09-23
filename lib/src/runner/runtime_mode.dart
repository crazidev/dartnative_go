/// Runtime engine selection for DartNative Go guest execution.
///
/// Source (default) uses `tom_d4rt` with on-device `package:analyzer` parsing.
/// AST (opt-in) will use `tom_d4rt_ast` / `tom_d4rt_flutter_ast` with
/// pre-compiled `AstBundle` bytes (analyzer-free, OTA/web-safe).
///
/// Default must stay [RuntimeMode.source] until AST bridges are verified.
/// Toggle via [kUseAst] or per-runner [InterpreterRunner.useAst].
enum RuntimeMode { source, ast, bytecode }

/// Global default. Keep `false` (source) for now; AST is default opt-in.
const bool kUseAst = false;
const bool kUseBytecode = false;

const RuntimeMode kDefaultRuntimeMode = RuntimeMode.source;

extension RuntimeModeX on RuntimeMode {
  bool get isSource => this == RuntimeMode.source;
  bool get isAst => this == RuntimeMode.ast;
  bool get isBytecode => this == RuntimeMode.bytecode;

  String get label => switch (this) {
    RuntimeMode.source => 'Source (tom_d4rt)',
    RuntimeMode.ast => 'AST (tom_d4rt_ast)',
    RuntimeMode.bytecode => 'Bytecode (Stack VM)',
  };
}

RuntimeMode runtimeModeFromBool(bool useAst, [bool useBytecode = false]) {
  if (useBytecode) return RuntimeMode.bytecode;
  return useAst ? RuntimeMode.ast : RuntimeMode.source;
}

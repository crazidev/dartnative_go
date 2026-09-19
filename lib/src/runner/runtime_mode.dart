/// Runtime engine selection for DartNative Go guest execution.
///
/// Source (default) uses `tom_d4rt` with on-device `package:analyzer` parsing.
/// AST (opt-in) will use `tom_d4rt_ast` / `tom_d4rt_flutter_ast` with
/// pre-compiled `AstBundle` bytes (analyzer-free, OTA/web-safe).
///
/// Default must stay [RuntimeMode.source] until AST bridges are verified.
/// Toggle via [kUseAst] or per-runner [InterpreterRunner.useAst].
enum RuntimeMode { source, ast }

/// Global default. Keep `false` (source) for now; AST is test-only.
const bool kUseAst = false;

const RuntimeMode kDefaultRuntimeMode = RuntimeMode.source;

extension RuntimeModeX on RuntimeMode {
  bool get isSource => this == RuntimeMode.source;
  bool get isAst => this == RuntimeMode.ast;

  String get label => switch (this) {
    RuntimeMode.source => 'Source (tom_d4rt)',
    RuntimeMode.ast => 'AST (tom_d4rt_ast)',
  };
}

RuntimeMode runtimeModeFromBool(bool useAst) =>
    useAst ? RuntimeMode.ast : RuntimeMode.source;

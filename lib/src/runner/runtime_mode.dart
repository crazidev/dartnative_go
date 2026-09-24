/// Runtime engine selection for DartNative Go guest execution.
///
/// AST (default) uses `tom_d4rt_ast` / `tom_d4rt_flutter_ast` with
/// pre-compiled `AstBundle` bytes (analyzer-free, OTA/web-safe).
/// Bytecode uses `BytecodeVM` stack-based interpreter.
/// Source uses `tom_d4rt` with on-device `package:analyzer` parsing.
enum RuntimeMode { source, ast, bytecode }

/// Kill switch for the Bytecode engine.
///
/// The Bytecode stack VM is **disabled by default** while the AST runtime owns
/// hot reload: the engine is still in the tree, but nothing selects it, nothing
/// builds `guest.bc`, and its suites are skipped. Re-enable it for one build
/// with:
///
/// ```sh
/// dart run ... --dart-define=DN_ENABLE_BYTECODE=true
/// dn test --dart-define=DN_ENABLE_BYTECODE=true test/
/// ```
const bool kBytecodeEnabled = bool.fromEnvironment('DN_ENABLE_BYTECODE');

/// Global default. AST is the default engine now.
const bool kUseAst = true;

/// Bytecode is opt-in through [kBytecodeEnabled] only.
const bool kUseBytecode = false;

const RuntimeMode kDefaultRuntimeMode = RuntimeMode.ast;

/// Modes a user can actually select right now.
List<RuntimeMode> get selectableRuntimeModes => kBytecodeEnabled
    ? RuntimeMode.values
    : const [RuntimeMode.source, RuntimeMode.ast];

extension RuntimeModeX on RuntimeMode {
  bool get isSource => this == RuntimeMode.source;
  bool get isAst => this == RuntimeMode.ast;
  bool get isBytecode => this == RuntimeMode.bytecode;

  /// False when the engine is disabled by [kBytecodeEnabled] and can therefore
  /// never be selected or restored from storage.
  bool get isSelectable => !isBytecode || kBytecodeEnabled;

  String get label => switch (this) {
    RuntimeMode.source => 'Source (tom_d4rt)',
    RuntimeMode.ast => 'AST (tom_d4rt_ast)',
    RuntimeMode.bytecode => 'Bytecode (Stack VM)',
  };

  /// Cycle order: AST -> Bytecode -> Source -> AST.
  ///
  /// With Bytecode disabled the cycle is AST -> Source -> AST.
  RuntimeMode get next {
    if (!kBytecodeEnabled) {
      return switch (this) {
        RuntimeMode.ast => RuntimeMode.source,
        RuntimeMode.source => RuntimeMode.ast,
        RuntimeMode.bytecode => RuntimeMode.ast,
      };
    }
    return switch (this) {
      RuntimeMode.ast => RuntimeMode.bytecode,
      RuntimeMode.bytecode => RuntimeMode.source,
      RuntimeMode.source => RuntimeMode.ast,
    };
  }
}

RuntimeMode runtimeModeFromBool(bool useAst, [bool useBytecode = false]) {
  if (useBytecode) {
    // A disabled Bytecode request falls back to the default engine, matching
    // `flagsFromRuntimeMode` and the persisted-mode path.
    return kBytecodeEnabled ? RuntimeMode.bytecode : kDefaultRuntimeMode;
  }
  return useAst ? RuntimeMode.ast : RuntimeMode.source;
}

RuntimeMode runtimeModeFromName(String? name) {
  if (name == null) return kDefaultRuntimeMode;
  for (final m in RuntimeMode.values) {
    if (m.name.toLowerCase() == name.toLowerCase()) {
      // A saved Bytecode choice from a previous build is ignored while the
      // engine is disabled, so a stale preference cannot lock the app into a
      // mode it cannot run.
      return m.isSelectable ? m : kDefaultRuntimeMode;
    }
  }
  return kDefaultRuntimeMode;
}

(bool useAst, bool useBytecode) flagsFromRuntimeMode(RuntimeMode mode) =>
    switch (mode) {
      RuntimeMode.ast => (true, false),
      RuntimeMode.bytecode => kBytecodeEnabled ? (false, true) : (true, false),
      RuntimeMode.source => (false, false),
    };


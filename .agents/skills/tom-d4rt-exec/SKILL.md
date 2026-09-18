---
name: tom-d4rt-exec
description: >-
  Use this skill when developing, configuring, or debugging the CLI and embedding execution runner tom_d4rt_exec. Covers the parse-via-analyzer to mirror-AST to interpret pipeline, typed execution APIs (executeBundleAs), AST bundle creation/running, and embedding dynamic execution in host Dart CLI applications.
---

# tom_d4rt_exec — CLI & Embedding Execution Runner Skill

`tom_d4rt_exec` is the unified CLI and embedding entry point that bridges host-side parsing and runtime AST interpretation. It accepts raw Dart source code, parses it via the analyzer, converts it to an `SAstNode` tree via `tom_ast_generator`, and executes it on `tom_d4rt_ast`'s interpreter engine.

---

## Key Architecture & Concepts

- **Split Responsibility Pipeline**:
  1. Parse Dart source → `analyzer.AstNode` (via Dart analyzer).
  2. Mirror analyzer AST → `SAstNode` tree (via `tom_ast_generator.AstConverter`).
  3. Interpret `SAstNode` tree → execution result (via `tom_d4rt_ast.D4rtRunner`).
- **Unified API**: Offers the same API surface as `tom_d4rt` (`D4rt` class with `execute`, `eval`, and `continuedExecute`), but internally runs on the analyzer-free AST engine.
- **Typed Execution**: Supports `executeBundleAs<T>` and direct bundle execution.
- **Host vs Client Decoupling**: Uses analyzer dependencies strictly on the host/developer side, producing bundles that mobile or web clients can execute without the analyzer.

---

## When to Use This Skill

Activate this skill when:
- Embedding dynamic Dart script execution in command-line tools or server environments.
- Running scripts directly from source files while targeting the modern AST interpreter pipeline.
- Converting Dart source into bundles and running them in a single step.
- Debugging issues that occur specifically along the parse → mirror → interpret pipeline.

---

## Common Workflows & Code Patterns

### 1. Executing Dart Source Directly
```dart
import 'package:tom_d4rt_exec/d4rt.dart';

void main() async {
  final d4rt = D4rt();
  
  final result = await d4rt.execute(
    source: '''
      void main() {
        print("Running in tom_d4rt_exec pipeline!");
      }
    ''',
  );
}
```

### 2. Loading and Executing AST Bundles
```dart
import 'package:tom_d4rt_exec/runtime.dart';

void main() {
  final runner = D4rtRunner();
  final bundle = AstBundle.fromFile('script.ast');
  
  final message = runner.executeBundleAs<String>(bundle, name: 'getMessage');
  print(message);
}
```

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [tom_d4rt_exec_user_guide.md](./references/tom_d4rt_exec_user_guide.md): The core guide detailing the parse-to-AST execution pipeline, bundle APIs, typed return values, and source execution.
- [tom_d4rt_exec_limitations.md](./references/tom_d4rt_exec_limitations.md): Delta limitations specific to `tom_d4rt_exec` (analyzer host overhead, AST compilation boundaries).
- [BRIDGING_GUIDE.md](./references/BRIDGING_GUIDE.md): Bridging guide for exposing native Dart APIs to scripts running in `tom_d4rt_exec`.
- [advanced_bridging_user_guide.md](./references/advanced_bridging_user_guide.md): Advanced bridging techniques including polymorphic callbacks and lifecycle integration.
- [issues.md](./references/issues.md): Open issues and tracker for `tom_d4rt_exec`.

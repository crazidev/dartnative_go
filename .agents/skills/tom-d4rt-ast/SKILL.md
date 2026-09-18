---
name: tom-d4rt-ast
description: >-
  Use this skill when developing, integrating, or debugging the zero-dependency, analyzer-free AST interpreter tom_d4rt_ast. Covers AstBundle loading (ZIP/gzip/JSON), D4rtRunner execution, typed execution (executeBundleAs), web-safe execution, runtime registration, and AST node hierarchy.
---

# tom_d4rt_ast — Zero-Dependency AST Interpreter Skill

`tom_d4rt_ast` runs the D4rt interpreter directly on pre-compiled, standalone AST nodes (`SAstNode` from `tom_ast_model`) inside transportable containers called `AstBundle`. It completely removes the `analyzer` and `dart:io` runtime dependencies, making it lightweight and fully compatible with Flutter and Flutter Web.

---

## Key Architecture & Concepts

- **Analyzer-Free**: Replaces runtime parsing with pre-built AST bundles produced ahead-of-time by `tom_ast_generator` or `tom_d4rt_exec`.
- **Core Entry (`D4rtRunner` / `D4rt`)**: The primary execution runner is `D4rtRunner` (aliased as `D4rt`), allowing bridge code from `tom_d4rt_generator` to run unmodified.
- **AstBundle Formats**: Auto-detects on-disk compression formats: ZIP (`PK\x03\x04`), gzip (`\x1F\x8B`), and plain JSON.
- **Typed Execution**: Features `executeBundleAs<T>(bundle, name: '...')` to execute specific functions and unwrap the result as native types via `D4.unwrapAs<T>`.
- **Extension Registration**: Shares canonical `registerExtensions()` and `finalizeBridges()` methods to link bridges.

---

## When to Use This Skill

Activate this skill when:
- Deploying dynamic Dart scripts on Flutter Web, iOS, Android, or desktop without bundling the heavyweight `analyzer` package.
- Inspecting or optimizing `AstBundle` serialization, deserialization, and execution.
- Working on the `SAstNode` interpreter visitor, environment scopes, or AST node hierarchy.
- Debugging bridge extension registration (`registerExtensions`) in an AST environment.
- Investigating relaxer, proxy, or constructor usage logging via `D4`.

---

## Common Workflows & Code Patterns

### 1. Loading and Running an AST Bundle
```dart
import 'package:tom_d4rt_ast/runtime.dart';

void main() async {
  // Load pre-compiled AST bundle from file or bytes
  final bundle = AstBundle.fromFile('path/to/script.ast');

  final runner = D4rtRunner();
  runner.grant(FilesystemPermission.read);

  // Execute typed entry point
  final label = runner.executeBundleAs<String>(bundle, name: 'buildLabel');
  print(label);
}
```

### 2. Registering Bridges in AST Runtime
```dart
import 'package:tom_d4rt_ast/d4rt.dart';

final d4rt = D4rt();
d4rt.registerBridge(MyCustomBridge());
d4rt.registerExtensions();
d4rt.finalizeBridges();
```

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [tom_d4rt_ast_user_guide.md](./references/tom_d4rt_ast_user_guide.md): The differences-only user guide detailing AST bundle execution, loaders, typed returns, and comparison with `tom_d4rt`.
- [tom_d4rt_ast_limitations.md](./references/tom_d4rt_ast_limitations.md): Delta limitations specific to the AST runtime (such as ahead-of-time bundle generation requirement and memory characteristics).
- [d4rt_ast_architecture_design.md](./references/d4rt_ast_architecture_design.md): Deep architectural specification of the AST pipeline, AST visitor implementation, and serialization format.
- [analyzer_ast_hierarchy.md](./references/analyzer_ast_hierarchy.md): Comprehensive reference mapping Dart Analyzer AST node classes to their standalone equivalents.
- [extension_registration.md](./references/extension_registration.md): Mechanics of extension registration (`registerExtensions`) and bridge finalization (`finalizeBridges`).
- [runtime_registration_surface.md](./references/runtime_registration_surface.md): Authoritative reference of the runtime registration API surface.
- [usage_logging.md](./references/usage_logging.md): Guide to opt-in relaxer, proxy, and constructor instrumentation on `D4` for identifying bridge usage patterns.

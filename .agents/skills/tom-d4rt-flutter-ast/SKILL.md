---
name: tom-d4rt-flutter-ast
description: >-
  Use this skill when developing, deploying, or debugging the analyzer-free Flutter AST runtime tom_d4rt_flutter_ast. Covers FlutterD4rt, executing pre-compiled AstBundles to render Flutter widgets, Over-the-Air (OTA) UI updates, web-safe Flutter execution (dart2js/dart2wasm), async widget building (buildAsync), and Flutter interpreter issue resolution.
---

# tom_d4rt_flutter_ast — Analyzer-Free Flutter AST Runtime Skill

`tom_d4rt_flutter_ast` is the analyzer-free runtime that executes pre-compiled `AstBundle` artifacts to render native Flutter widgets. Operating without `dart:analyzer` or `dart:io`, it is fully web-compatible (dart2js and dart2wasm) and serves as the strategic engine for **Over-The-Air (OTA) dynamic UI updates** in Flutter.

---

## Key Architecture & Concepts

- **`FlutterD4rt` Entry Point**: Replaces `SourceFlutterD4rt` from the source runtime. Wraps `tom_d4rt_ast.D4rtRunner` with the complete Flutter bridge surface.
- **`AstBundle` Input**: Executes pre-compiled bundles where all multi-file dependencies and source structures are already resolved and serialized.
- **Sync & Async Execution**: Supports both synchronous `build<Widget>(bundle, context)` and asynchronous `buildAsync<Widget>(bundle, context)` APIs.
- **OTA Architecture**: Download compressed `AstBundle`s from a server, deserialize on-device, and instantly mount live native Flutter widgets without going through app store review cycles.
- **Web-Safe**: Contains zero `dart:io` calls, running smoothly on Flutter Web, iOS, Android, macOS, Linux, and Windows.

---

## When to Use This Skill

Activate this skill when:
- Implementing dynamic over-the-air Flutter UI or server-driven UI (SDUI).
- Running interpreted Flutter widgets on the Web or in environments where the analyzer is disallowed.
- Calling `FlutterD4rt.build(bundle, context)` or `FlutterD4rt.buildAsync(bundle, context)`.
- Diagnosing interpreter, generator, or Flutter test-environment bugs across dynamic scripts.
- Reviewing deep issue analyses and unfixable interpreter edge cases.

---

## Common Workflows & Code Patterns

### 1. Rendering a Widget from an AstBundle
```dart
import 'package:flutter/material.dart';
import 'package:tom_d4rt_flutter_ast/tom_d4rt_flutter_ast.dart';

class DynamicAstCard extends StatelessWidget {
  static final runner = FlutterD4rt();
  final AstBundle bundle;

  const DynamicAstCard({super.key, required this.bundle});

  @override
  Widget build(BuildContext context) {
    // Renders the widget defined in the AstBundle entry point
    return runner.build<Widget>(bundle, context);
  }
}
```

### 2. Async Loading & OTA Widget Rendering
```dart
final runner = FlutterD4rt();
final bytes = await http.readBytes(Uri.parse('https://example.com/ui/feed_card.ast'));
final bundle = AstBundle.fromBytes(bytes);

final widget = await runner.buildAsync<Widget>(bundle, context);
```

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [tom_d4rt_flutter_ast_user_guide.md](./references/tom_d4rt_flutter_ast_user_guide.md): The differences-only user guide detailing `FlutterD4rt`, bundle execution, sync/async APIs, and web compatibility.
- [creating_fully_dynamic_applications.md](./references/creating_fully_dynamic_applications.md): Architectural analysis and guide on building fully dynamic Flutter applications with OTA updates.
- [tom_d4rt_flutter_ast_limitations.md](./references/tom_d4rt_flutter_ast_limitations.md): Delta limitations specific to the Flutter AST runtime.
- [flutter_bugs.md](./references/flutter_bugs.md): Catalog of Flutter test-environment and framework-level issues encountered during dynamic execution.
- [generator_issues.md](./references/generator_issues.md): Verified issues and quirks with bridge generation when targeting Flutter.
- [interpreter_issues.md](./references/interpreter_issues.md): Comprehensive cluster-organized active issues in the Flutter AST interpreter.
- [interpreter_generator_open_issues.md](./references/interpreter_generator_open_issues.md): Verified open issues tracker across interpreter and generator.
- [interpreter_unfixable.md](./references/interpreter_unfixable.md): Exhaustive catalog of fundamental language limitations and unfixable edge cases.
- [test_script_context.md](./references/test_script_context.md): Specification of the execution environment and context injected into test scripts.
- [issue_analysis_20260424.md](./references/issue_analysis_20260424.md): Deep-dive audit report on interpreter error runs and resolution paths.
- [issue_analysis_20260624.md](./references/issue_analysis_20260624.md): Follow-up audit report analyzing interpreter issue closures and regressions.

---
name: tom-ast-model
description: >-
  Use this skill when working with the pure data model tom_ast_model for serializable Dart ASTs. Covers SAstNode hierarchy, SCompilationUnit, JSON serialization/deserialization contracts, structural diffing (equals with log), nodeType discriminators, and visitor patterns with zero external dependencies.
---

# tom_ast_model — Serializable Dart AST Data Model Skill

`tom_ast_model` is the zero-dependency data contract for the analyzer-free D4rt stack. It defines a 1:1 serializable mirror of the Dart analyzer AST with plain Dart classes prefixed with `S` (`SAstNode`, `SCompilationUnit`, `SClassDeclaration`, `SMethodInvocation`), depending only on `dart:convert`.

---

## Key Architecture & Concepts

- **Zero Runtime Overhead**: No analyzer, no bridges, no execution engine. Safe for Flutter mobile and Flutter Web.
- **Node Contract**: Every AST node inherits from `SAstNode` and carries `offset` and `length` for source tracking.
- **JSON Round-Trip**:
  - Serialization: `node.toJson()` generates a clean `Map<String, dynamic>` with nulls omitted.
  - Deserialization: `SAstNodeFactory.fromJson(map)` or `SCompilationUnit.fromJson(map)` with a `"nodeType"` string discriminator.
  - Unrecognized nodes deserialize into `_SUnknownNode` to guarantee forward compatibility without throwing.
- **Structural Equality & Diffing**: Provides `nodeA.equals(nodeB, log)` to compare trees structurally and diagnose differences.
- **Visitor Pattern**: Implements `SAstVisitor<R>` for traversing or transforming AST node trees.

---

## When to Use This Skill

Activate this skill when:
- Working on `SAstNode` data structures, adding new AST node types, or updating AST serialization.
- Inspecting JSON representations of AST nodes produced by `tom_ast_generator`.
- Writing AST transformations, custom linters, visitors, or tree printers targeting `SAstNode`.
- Comparing or diffing AST trees via `equals(log)`.

---

## Common Workflows & Code Patterns

### 1. Serializing and Deserializing an AST Unit
```dart
import 'dart:convert';
import 'package:tom_ast_model/tom_ast_model.dart';

// Deserialize from JSON Map
final Map<String, dynamic> jsonMap = jsonDecode(bundleContent);
final SCompilationUnit unit = SCompilationUnit.fromJson(jsonMap);

// Walk declarations
for (final decl in unit.declarations) {
  if (decl is SClassDeclaration) {
    print('Found class: ${decl.name.name}');
  }
}

// Reserialize back to JSON
final Map<String, dynamic> outputMap = unit.toJson();
```

### 2. Structural Diffing of Two AST Trees
```dart
final log = <String>[];
final areEqual = treeA.equals(treeB, log);
if (!areEqual) {
  print('Trees differ:\n${log.join("\n")}');
}
```

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [tom_ast_model_user_guide.md](./references/tom_ast_model_user_guide.md): Comprehensive guide to the `SAstNode` model, the four core capabilities (typed tree, JSON round-trip, diffing, visitors), and the `nodeType` discriminator design.
- [tom_ast_model_limitations.md](./references/tom_ast_model_limitations.md): Delta limitations defining what the model intentionally omits (no semantic analysis, no const evaluation, no built-in compiler).

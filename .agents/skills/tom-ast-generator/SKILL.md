---
name: tom-ast-generator
description: >-
  Use this skill when converting Dart source files into serializable AST bundles using tom_ast_generator. Covers astgen CLI commands, astgen_build.yaml configuration, AstConverter (analyzer to SAstNode mapping), AstBundler multi-file packaging, bundle compression (JSON/gzip/zip), and recursive import resolution.
---

# tom_ast_generator — Analyzer-to-AST Generator Skill

`tom_ast_generator` is the host/CI-side compilation tool that converts raw Dart source code into serializable `SAstNode` mirror trees and `AstBundle` artifacts. It confines the heavy `analyzer` package to build-time so downstream mobile/web applications can run interpreted Dart with zero analyzer dependencies.

> **Key Distinction**:
> - `tom_ast_generator` (`astgen`): Compiles Dart **scripts** into `AstBundle` format to be *interpreted*.
> - `tom_d4rt_generator` (`d4rtgen`): Compiles host Dart **libraries/APIs** into `*.b.dart` *bridge classes*.

---

## Key Architecture & Concepts

- **AstConverter**: Performs 1:1 structural translation from `analyzer.CompilationUnit` to `tom_ast_model.SCompilationUnit`.
- **AstBundler**: Discovers recursive local imports, converts all dependent files, and packages them into an `AstBundle` with manifest metadata.
- **CLI (`astgen`)**: Command-line interface for compiling single files, directories, or entire packages into `.ast` bundles.
- **Two-Tier Configuration (`astgen_build.yaml`)**:
  - Global configuration: format settings, compression levels (none, gzip, zip), and include/exclude globs.
  - Target configurations: individual bundle build targets with specific entry points and outputs.

---

## When to Use This Skill

Activate this skill when:
- Compiling Dart source scripts into `.ast` bundles for Flutter or Flutter Web deployments.
- Configuring or modifying `astgen_build.yaml` build specifications.
- Debugging AST conversion failures, missing nodes, or unresolved imports during bundle generation.
- Running the `astgen` CLI tool to generate pre-compiled script bundles.

---

## Common Workflows & Code Patterns

### 1. Generating Bundles via CLI
```bash
# Compile single script to JSON/ZIP bundle
dart run tom_ast_generator:astgen compile -i lib/scripts/entry.dart -o assets/entry.ast

# Build all targets declared in astgen_build.yaml
dart run tom_ast_generator:astgen build --config astgen_build.yaml
```

### 2. Programmatic Bundle Creation
```dart
import 'package:tom_ast_generator/tom_ast_generator.dart';

void main() async {
  // Bundle entry point and its recursive local imports
  final bundle = await AstBundler.createFromFile(
    entryPath: 'lib/src/script.dart',
    baseDir: 'lib/src',
  );

  // Write out as compressed JSON/bytes
  await bundle.saveToFile('assets/script.ast');
}
```

### 3. Sample `astgen_build.yaml`
```yaml
targets:
  main_bundle:
    entry: lib/scripts/main.dart
    output: assets/bundles/main.ast
    compression: gzip
    include_sources: false
```

---

### 4. DartNative Go Tooling & Verification Pipeline

In `dartnative_go`, bridge and AST generation are orchestrated via scripts in `tool/`:

```bash
# 1. Regenerate source runtime bridges and apply post-fixes
dart run tool/d4rtgen.dart

# 2. Regenerate AST runtime bridges (for analyzer-free tom_d4rt_ast)
dart run tool/d4rtgen_ast.dart

# 3. Compile and validate pre-compiled AST bundle
dart run tool/build_ast_bundle.dart --project=example

# 4. Run static analysis across generated files and repository
dart analyze

# 5. Run AST and bridge parity regression test suite
dart --enable-asserts test/ast_builder_test.dart
dart --enable-asserts test/bridge_config_parity_test.dart

# 6. Recompile and install global dart_go CLI
dart run tool/install_global.dart
```

### 5. Analyzing, Patching & Post-Fixes Workflow
Whenever running bridge or AST generation:
1. **Analyze**: Run `dart analyze` to detect any syntax mismatches, deprecated symbols, or type cast errors.
2. **Patch Generator Skew**: If the generator emits code with known signature skews (e.g. enum extensions, default parameter mismatches), codify the fix in `_applyBridgePostFixes()` inside `tool/d4rtgen.dart` / `tool/d4rtgen_ast.dart` so it is applied deterministically on every generation run.
3. **Re-verify**: Ensure `dart analyze` and `dart test/ast_builder_test.dart` pass with zero issues.

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [tom_ast_generator_user_guide.md](./references/tom_ast_generator_user_guide.md): The essential user guide detailing the generator pipeline, converter guarantees, bundler capabilities, and the distinction from the bridge generator.
- [astgen_build_yaml.md](./references/astgen_build_yaml.md): Detailed reference specification for all keys and options in `astgen_build.yaml`.
- [tom_build_configuration_and_cli.md](./references/tom_build_configuration_and_cli.md): In-depth CLI manual covering options, exit codes, batch compilation, and CI automation.
- [tom_ast_generator_limitations.md](./references/tom_ast_generator_limitations.md): Delta limitations (host-only dependency, parser-only behavior, macro limitations).


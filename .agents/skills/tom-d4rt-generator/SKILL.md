---
name: tom-d4rt-generator
description: >-
  Use this skill when configuring, running, maintaining, or debugging the D4rt Bridge Generator tom_d4rt_generator. Covers d4rtgen CLI, buildkit.yaml / build.yaml, *.b.dart code generation, type relaxation ($Relaxed* wrappers), generic-constructor factories (_rc2*), proxy class generation (D4rt* proxies for abstract classes like CustomPainter), UserBridge overrides, allowlist pruning, and VM/web signature skew coercion.
---

# tom_d4rt_generator — Bridge Generator Skill

`tom_d4rt_generator` is the code generation engine that inspects Dart libraries and emits `*.b.dart` bridge registrations, type relaxers, generic constructor factories, and proxy classes. It allows the `tom_d4rt` interpreter to call native host Dart APIs and frameworks (including Flutter) with full type safety and seamless callback bridging.

> **Golden Rule**: Never hand-edit generated `*.b.dart` files. Always modify the generator or configuration (`buildkit.yaml`), and regenerate.

---

## Key Architecture & Concepts

### The 4 Artifact Categories (A–D)
1. **Category A — Type-Relaxing Wrappers (`$Relaxed*<V>`)**: Solves erased generic variance mismatches (e.g., `ValueNotifier<dynamic>` passed where `ValueNotifier<T>` is required).
2. **Category B — Relaxer Factories (`registerGenericTypeWrapper`)**: Combinatorial factory switches dispatching runtime values to relaxed wrappers.
3. **Category C — Generic-Constructor Factories (`registerGenericConstructor`)**: Enables the interpreter to instantiate generic host classes dynamically with type arguments.
4. **Category D — Proxy Classes (`registerInterfaceProxy`)**: Host subclasses of framework abstract classes (e.g. `CustomPainter`, `ChangeNotifier`, `FlowDelegate`) that delegate methods back to interpreted Dart callbacks.

### UserBridge System
Allows developers to override, extend, or manually supplement generated bridges for classes that require custom native glue or complex lifecycle management.

---

## When to Use This Skill

Activate this skill when:
- Adding or updating bridges for native Dart or Flutter packages.
- Configuring `buildkit.yaml` or `build.yaml` (entry points, exports, exclusions, type relaxers).
- Running the `d4rtgen` CLI or `dart run build_runner build`.
- Debugging bridge compilation failures, missing constructors, or signature mismatch errors.
- Handling type variance issues with generics via Type Relaxation or `@D4rtUserRelaxer`.
- Creating native proxy classes for abstract framework classes using `proxyClasses:` or `@D4rtUserProxy`.
- Pruning bridge output size using allowlists (`corpus_relaxer_allowlist.yaml`).
- Resolving VM↔Web signature discrepancies (`enableVmWebSkewCoercion`).

---

## Common Workflows & Commands

### 1. Generating Bridges via CLI
```bash
# Generate bridges using d4rtgen CLI
dart run tom_d4rt_generator:d4rtgen --config buildkit.yaml

# Or using build_runner
dart run build_runner build --delete-conflicting-outputs
```

### 2. Scanning Corpus for Allowlist Pruning
```bash
# Scan test/demo scripts to identify actually used relaxer types and prune combinatorial explosions
dart run tom_d4rt_generator:scan_corpus_types --output doc/corpus_relaxer_allowlist.yaml
```

### 3. Sample `buildkit.yaml` Configuration
```yaml
d4rtgen:
  generateAllRelaxers: false
  allowlistFile: doc/corpus_relaxer_allowlist.yaml
  modules:
    my_package:
      entry: package:my_package/my_package.dart
      output: lib/src/bridges/
      proxyClasses:
        - MyAbstractHandler
```

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [index.md](./references/index.md): Master navigation index explaining the 4 mechanism categories (A–D), reduction knobs, and document hierarchy.
- [bridgegenerator_user_guide.md](./references/bridgegenerator_user_guide.md): Quick start guide for annotations, dependencies, and generator setup.
- [tom_d4rt_generator_configuration.md](./references/tom_d4rt_generator_configuration.md): **Authoritative full reference** for every `buildkit.yaml` option, module configuration, and CLI switch.
- [d4rt_generator_cli_user_guide.md](./references/d4rt_generator_cli_user_guide.md): Comprehensive guide to using the `d4rtgen` standalone CLI.
- [bridgegenerator_user_reference.md](./references/bridgegenerator_user_reference.md): `build.yaml` builder integration reference.
- [generics_wrapper_and_type_relaxation_strategy.md](./references/generics_wrapper_and_type_relaxation_strategy.md): Deep dive into type relaxation, variance handling, and `$Relaxed*` wrapper mechanics.
- [proxy_class_generation.md](./references/proxy_class_generation.md): Architecture of proxy classes, callback forwarding, and handling abstract framework types.
- [generic_constructor_and_other_extensions.md](./references/generic_constructor_and_other_extensions.md): Guide to runtime extension categories RC-1 through RC-5 and generic constructors.
- [user_bridge_user_guide.md](./references/user_bridge_user_guide.md): How to author custom `UserBridge` classes for complex manual bridging.
- [userbridge_override_design.md](./references/userbridge_override_design.md): Architectural design of the `UserBridge` override and dispatch system.
- [user_proxy_relaxer_annotations.md](./references/user_proxy_relaxer_annotations.md): Guide to `@D4rtUserProxy` and `@D4rtUserRelaxer` code annotations.
- [generate_allowlists.md](./references/generate_allowlists.md): How to generate and maintain corpus allowlists to reduce generated code bloat.
- [deprecated_allowlist.md](./references/deprecated_allowlist.md): Handling of `@Deprecated` symbols in upstream bridged libraries.
- [corpus_relaxer_allowlist.yaml](./references/corpus_relaxer_allowlist.yaml): Canonical corpus relaxer allowlist definition.
- [vm_web_skew_coercion.md](./references/vm_web_skew_coercion.md): Resolving method signature differences between Dart VM and Dart Web.
- [worked_samples.md](./references/worked_samples.md): Runnable examples demonstrating generated bridge usage.
- [test_coverage.md](./references/test_coverage.md): Test matrix and coverage targets for the bridge generator.
- [issues.md](./references/issues.md): Known issues, open limitations, and active tracker for the generator.

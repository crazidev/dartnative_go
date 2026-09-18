---
name: tom-d4rt
description: >-
  Use this skill when developing, integrating, configuring, or debugging the core tom_d4rt Dart interpreter engine. Covers D4rt initialization, script execution (execute/eval), bridge registration, security sandboxing, standard library gaps, and canonical interpreter limitations.
---

# tom_d4rt — Base Dart Interpreter Skill

`tom_d4rt` is the authoritative core interpreter of the D4rt family. It executes Dart source code dynamically at runtime using the Dart analyzer AST in VM environments. It owns the canonical limitations canon and base runtime registration surfaces for all derived projects.

---

## Key Architecture & Concepts

- **Execution Model (`D4rt`)**: The interpreter does not have a separate `init()` method; the runtime environment is initialized upon the first call to `execute()`. Once initialized, subsequent `eval()` calls evaluate expressions within that established execution context.
- **Bridging**: Bridges allow interpreted scripts to instantiate native host Dart classes, call methods, and pass callbacks seamlessly.
- **Canonical Limitations**: `tom_d4rt` owns `d4rt_limitations.md`, which is the single source of truth for language, interpreter, and generator limits across the entire repo.
- **Security & Sandbox**: Controls script capabilities (file system access, network access, isolate spawning).
- **Extension & Facades**: Supports `registerExtensions()` and `finalizeBridges()` for modular library registrations.

---

## When to Use This Skill

Activate this skill when:
- Writing, modifying, or debugging code that uses or alters `tom_d4rt`.
- Integrating the base Dart interpreter into a host Dart application.
- Authoring manual or generator-assisted bridges for host Dart classes (`D4rtBridge`).
- Checking language feature support, interpreter limits, or standard library SDK support.
- Investigating interpreter execution errors, callback escape errors, or bridging issues.

---

## Common Workflows & Code Patterns

### 1. Initializing and Running Scripts
```dart
import 'package:tom_d4rt/tom_d4rt.dart';

final d4rt = D4rt();

// Initial execution declares top-level elements and runs main()
final result = await d4rt.execute(
  source: '''
    void main() {
      print("Hello from interpreted Dart!");
    }
  ''',
);

// Subsequent evaluations in the same context
final value = d4rt.eval('2 + 2');
```

### 2. Multi-File Execution
```dart
final d4rt = D4rt();
await d4rt.execute(
  source: "import 'helper.dart'; void main() { greet(); }",
  sources: {
    'helper.dart': 'void greet() => print("Greetings!");',
  },
);
```

### 3. Registering Bridges
```dart
d4rt.registerBridge(MyClassBridge());
d4rt.registerExtensions();
d4rt.finalizeBridges();
```

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [d4rt_user_guide.md](./references/d4rt_user_guide.md): Complete guide to `D4rt` initialization, `execute()`, `eval()`, multi-file execution, callback error handling, and runtime configuration.
- [d4rt_limitations.md](./references/d4rt_limitations.md): The **authoritative canon** for language limitations, syntax gaps, unsupported dart:core/dart:async features, and workarounds.
- [BRIDGING_GUIDE.md](./references/BRIDGING_GUIDE.md): Comprehensive bridging manual detailing bridge interfaces, parameter extraction, and method invocation.
- [advanced_bridging_user_guide.md](./references/advanced_bridging_user_guide.md): Advanced patterns including polymorphic callbacks, generic type arguments, and complex lifecycle bridging.
- [manual_bridge_interventions.md](./references/manual_bridge_interventions.md): Practical instructions for handling edge cases where automatic bridge generation requires manual code adjustments.
- [runtime_registration_surface.md](./references/runtime_registration_surface.md): Authoritative list of registration APIs, extension methods, and bridge facades on the VM interpreter.
- [stdlib_sdk_gap_audit.md](./references/stdlib_sdk_gap_audit.md): Systematic audit of Dart standard library classes and methods supported vs missing in the interpreter.
- [issues.md](./references/issues.md): Active tracked issues, known interpreter bugs, and resolution status.

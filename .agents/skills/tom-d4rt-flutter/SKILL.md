---
name: tom-d4rt-flutter
description: >-
  Use this skill when developing, integrating, or debugging the dynamic Flutter runtime tom_d4rt_flutter. Covers SourceFlutterD4rt, building live Flutter widgets from Dart source, BuildContext passing, multi-file widget definitions (buildMultiFile), Flutter bridge interventions, performance/GC tuning, and Flutter runtime limitations.
---

# tom_d4rt_flutter — Dynamic Flutter Runtime Skill

`tom_d4rt_flutter` renders interpreted Dart UI against real Flutter widgets. It wraps the analyzer-based `tom_d4rt` interpreter with the complete Flutter Material and Cupertino bridge surface, proxy classes (`CustomPainter`, `ChangeNotifier`), and type relaxers, enabling applications to evaluate raw Dart source code and return live Flutter `Widget` trees.

---

## Key Architecture & Concepts

- **`SourceFlutterD4rt`**: The primary runner class. Upon creation, it initializes the interpreter, registers all Flutter bridges, and finalizes bridge tables so scripts can execute immediately.
- **`build<Widget>(source, context)`**: Evaluates a source script expecting a `Widget build(BuildContext context)` function, injects the real Flutter `BuildContext`, and returns the instantiated native Flutter widget.
- **`buildMultiFile(sources, entryPoint, context)`**: Evaluates multi-file Flutter components with dependencies.
- **Manual Bridge Interventions**: Custom manual bridge adapters to handle Flutter widgets with complex native parameters or non-trivial constructor ergonomics.
- **Performance & GC Guidelines**: Recommends reusing `SourceFlutterD4rt` instances across rebuilds rather than re-instantiating, to avoid costly bridge re-registration.

---

## When to Use This Skill

Activate this skill when:
- Executing dynamic Dart code that imports Flutter (`package:flutter/material.dart`, `package:flutter/widgets.dart`).
- Returning live interactive Flutter widgets from interpreted code.
- Investigating Flutter bridge dispatch errors, widget rendering glitches, or `BuildContext` forwarding issues.
- Consulting manual bridge interventions and Flutter runtime limitation deltas.

---

## Common Workflows & Code Patterns

### 1. Rendering a Dynamic Widget from Source
```dart
import 'package:flutter/material.dart';
import 'package:tom_d4rt_flutter/tom_d4rt_flutter.dart';

class DynamicCardWidget extends StatelessWidget {
  static final runner = SourceFlutterD4rt();

  final String dynamicSource = '''
    import 'package:flutter/material.dart';

    Widget build(BuildContext context) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Dynamic Widget Content'),
        ),
      );
    }
  ''';

  @override
  Widget build(BuildContext context) {
    return runner.build<Widget>(dynamicSource, context);
  }
}
```

### 2. Multi-File Dynamic UI
```dart
final runner = SourceFlutterD4rt();
final widget = runner.buildMultiFile<Widget>(
  sources: {
    'card.dart': '...',
    'button.dart': '...',
  },
  entryPath: 'card.dart',
  context: context,
);
```

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [tom_d4rt_flutter_user_guide.md](./references/tom_d4rt_flutter_user_guide.md): The authoritative Flutter runtime guide covering `SourceFlutterD4rt`, `build`, `buildMultiFile`, `BuildContext` injection, performance, and GC considerations.
- [tom_d4rt_flutter_limitations.md](./references/tom_d4rt_flutter_limitations.md): Flutter-runtime delta limitations detailing known limits in Flutter bridge adapters, animation hooks, and widget interactions.
- [manual_bridge_interventions.md](./references/manual_bridge_interventions.md): Detailed documentation of manual interventions and overrides implemented for Flutter bridge classes.
- [example_app_plan.md](./references/example_app_plan.md): Architectural roadmap and backlog of multi-file Flutter sample applications exercising the bridge runtime.

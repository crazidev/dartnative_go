# DartNative Go — Architecture & Implementation

## 1. Overview

**DartNative Go** is an on-device dynamic client runtime for [DartNative](https://dartpub.dev) applications (analogous to *Expo Go* in the React Native ecosystem). It enables developers to author full DartNative mobile applications using multi-file modular structures, stateful components, and local `setState()`, and run or hot-reload them dynamically over Wi-Fi / localhost without recompiling native binaries.

---

## 2. High-Level Architecture

```
   ┌────────────────────────────────────────────────────────────────────────┐
   │             Live Dev Server (tool/dev_server.dart)                     │
   │  - Watches guest_app/ (*.dart) with debouncing                         │
   │  - Serves multi-file bundle: http://localhost:8088/bundle.json         │
   │  - Real-time WebSocket:      ws://localhost:8088/ws                    │
   │  - Receives guest logs:      POST /log                                 │
   └──────────────────┬────────────────────────────────▲────────────────────┘
                      │ HTTP & WebSocket               │ Guest Print Logs
                      ▼                                │
   ┌───────────────────────────────────────────────────┴────────────────────┐
   │             Host App (dartnative_go / lib/main.dart)                   │
   │                                                                        │
   │  ┌──────────────────────────────────────────────────────────────────┐  │
   │  │  Interpreter Engine (tom_d4rt - Source Based)                    │  │
   │  │  - Source parser powered by package:analyzer                     │  │
   │  │  - Automated Type-Safe Bridges (51,000+ lines generated)         │  │
   │  │  - Multi-file virtual sources routing                            │  │
   │  └───────────────────────────────┬──────────────────────────────────┘  │
   │                                  ▼                                     │
   │  ┌──────────────────────────────────────────────────────────────────┐  │
   │  │  Widget & State Interface Proxies (lib/src/interpreter/)         │  │
   │  │  - InterpretedStatefulWidgetProxy                                │  │
   │  │  - InterpretedStateProxy (bridges native State.setState)         │  │
   │  │  - super.initState() guard & local setState() routing            │  │
   │  └───────────────────────────────┬──────────────────────────────────┘  │
   │                                  ▼                                     │
   │  ┌──────────────────────────────────────────────────────────────────┐  │
   │  │  Native DartNative Render Pipeline                               │  │
   │  │  - Native Scaffold, AppBar, Column, Row, Button, Text rendering  │  │
   │  └──────────────────────────────────────────────────────────────────┘  │
   └────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Technology Stack & Strategy

| Component | Technology | Description |
| :--- | :--- | :--- |
| **Host Application** | `dartnative` (v1.0.0) | Native iOS & Android runner shell with full graphics engine support. |
| **Interpreter** | `tom_d4rt` (v1.77.0) | Pure-Dart interpreter operating in **source-based (analyzer)** mode. |
| **Bridge Generator** | `tom_d4rt_generator` / `d4rtgen` | Code generator that inspected DartNative framework APIs and generated 51,000+ lines of reflection-free bindings. |
| **Live Dev Server** | Standalone Dart script (`tool/dev_server.dart`) | HTTP bundle provider + WebSocket broadcaster with filesystem watching. |
| **Guest Application** | Pure Dart (`guest_app/`) | Interpreted modular code written against standard DartNative APIs. |

---

## 4. Key Problems Solved & Technical Solutions

### Problem 1: Interpreted `StatefulWidget` & Local `setState()`
* **Challenge**: When guest code declares standard Flutter/DartNative classes (e.g., `class CounterApp extends StatefulWidget`, `class _CounterAppState extends State<CounterApp>`), those classes exist inside `d4rt`'s virtual memory as `BridgedInstance` / `InterpreterInstance`. The host's native Flutter element tree cannot recognize or build them directly, and calling `setState()` inside the script does not trigger native UI repaints.
* **Solution**:
  - Implemented custom proxy wrappers in [`lib/src/interpreter/widget_proxies.dart`](file:///Users/mac/Dev/projects/dartnative_go/lib/src/interpreter/widget_proxies.dart):
    - `InterpretedStatefulWidgetProxy`: Extends native `StatefulWidget` and wraps the interpreted widget object.
    - `InterpretedStateProxy`: Extends native `State<StatefulWidget>`. It instantiates the guest's state class, hooks into `State.setState()`, and calls native `markNeedsBuild()` / `super.setState(() {})`.
    - Recursively resolves child widgets returned by `build(context)` so they become native render widgets.

### Problem 2: Stack Overflow / Infinite Recursion on `super.initState()`
* **Challenge**: Interpreted `State` classes routinely invoke `super.initState()`. In a naive bridge implementation, calling `super.initState()` either caused reflection lookup failures or recursively invoked the state proxy's own method, crashing the application with a stack overflow upon tapping "Connect".
* **Solution**:
  - Registered a safe handler for `State.initState` in `widget_proxies.dart`:
    ```dart
    'initState': (visitor, target, positional, named, typeArgs) {
      if (target is InterpretedStateProxy) {
        // Native state has already completed super.initState();
        // treat interpreted super call as a safe no-op.
        return null;
      }
      return null;
    }
    ```

### Problem 3: Multi-File Relative Imports
* **Challenge**: A monolithic script is not practical for real app development. As soon as guest code splits into modules (e.g., `import 'reset_button.dart';`), a standard interpreter fails because relative URIs cannot be resolved without a virtual filesystem.
* **Solution**:
  - **Dev Server Multi-File Bundler**: In [`tool/dev_server.dart`](file:///Users/mac/Dev/projects/dartnative_go/tool/dev_server.dart), added the `/bundle.json` endpoint that traverses `guest_app/`, reads all `.dart` files, and returns a JSON map of `{ "relativePath": "fileContent" }`.
  - **Virtual URI Alias Mapping**: In [`lib/main.dart`](file:///Users/mac/Dev/projects/dartnative_go/lib/main.dart), normalized paths into multiple lookup formats:
    - `package:guest_app/reset_button.dart`
    - `reset_button.dart`
    - `file:///reset_button.dart`
  - Passed the dictionary to `_interpreter.execute(..., sources: _liveSources)`, giving the interpreter full module resolution.

### Problem 4: Bi-Directional Guest Logging & Diagnostics
* **Challenge**: By default, `print()` statements inside interpreted sandboxes are captured or lost, making debugging impossible for guest app developers.
* **Solution**:
  - Wrapped execution inside a custom Dart `runZoned` with `ZoneSpecification(print: ...)` in `lib/main.dart`.
  - Redirected guest logs to:
    1. The host debug console (IDE / terminal).
    2. The in-app Go Launcher log viewer.
    3. The Dev Server via `POST http://localhost:8088/log`, enabling developers to see live outputs directly in their server terminal.

### Problem 5: Missing Imports & Cross-Module Dependencies
* **Challenge**: Developers often write UI code without remembering to write boilerplate imports (`import 'package:dartnative/dartnative.dart';`), standard libraries (`dart:math`, `dart:async`), or relative imports for sibling components. In standard runtimes, this causes compile-time undefined symbol errors.
* **Solution**:
  - Built [`AutoImportParser`](file:///Users/mac/Dev/projects/dartnative_go/lib/src/interpreter/auto_import_parser.dart):
    - **Framework Symbol Auto-Injection**: Detects usage of core framework symbols (`Widget`, `StatefulWidget`, `Scaffold`, `Text`, `Button`, etc.) and automatically injects `package:dartnative/dartnative.dart` if missing.
    - **Standard Library Auto-Injection**: Detects `min`, `max`, `Random` (`dart:math`) or `Timer`, `Completer` (`dart:async`).
    - **Project-Wide Symbol Discovery**: Scans project sources for declared classes/enums, resolves relative import paths, and auto-wires dependencies (e.g. `ResetButton` from `reset_button.dart`).
    - **Virtual Path Alias Matrix**: Generates a unified alias map (`package:guest_app/...`, `file:///...`, relative paths) so any import format resolves.

### Problem 6: Advanced Generator Options for Fluid UI Performance
* **Challenge**: Long-running synchronous interpreted callbacks inside UI event handlers can block Flutter's single-threaded event loop and hitch frame rates.
* **Solution**:
  - Configured advanced generator flags in [`buildkit.yaml`](file:///Users/mac/Dev/projects/dartnative_go/buildkit.yaml):
    - `yieldVoidCallbacks: true`: Wraps void bridged callbacks in an asynchronous micro-yield (`Future.delayed(Duration.zero)`) after calling the interpreted handler, returning a slice of the event loop to Flutter for smooth touch gestures and animations.
    - `generateDartscript: true` & `registrationClass: DartnativeGoBridges`: Generates [`lib/src/interpreter/dartscript.b.dart`](file:///Users/mac/Dev/projects/dartnative_go/lib/src/interpreter/dartscript.b.dart) to automatically register both primary and sub-package barrels (`src/core.dart`, `src/widgets.dart`, `src/framework.dart`) as well as RC-2 / GEN-079 relaxer factories.

### Problem 7: Stale Closures / Callbacks Not Updating on Hot Reload
* **Challenge**: When editing callbacks in imported submodules (e.g., updating `onPressed: () { print("onPressed: reset count 2"); }` in `reset_button.dart`), live hot reloads failed to take effect until a manual hot restart was performed.
* **Root Causes**:
  1. `tom_d4rt`'s internal `ModuleLoader._moduleCache` retained previously parsed AST `CompilationUnit` objects for imported modules across `execute()` calls on the same interpreter instance.
  2. Flutter's element reconciliation (`canUpdate`) preserved existing child state elements without triggering a re-render of their `build()` methods.
* **Solution**:
  - **Interpreter Session Disposal**: On reload, invoke `_interpreter.dispose()`, calling `releaseLoadedModules()` to purge `_moduleLoader._moduleCache` and re-parse all updated files from `_liveSources`.
  - **Generational Remounting**: Increment `_reloadGeneration++` and mount the root inside `KeyedSubtree(key: ValueKey('guest_root_$_reloadGeneration'))`. This ensures that all widgets and state closures recreate with the newly parsed closures.

### Problem 8: First-Class App Lifecycle & Safe `setState` Execution
* **Challenge**: Complex guest applications create long-lived listeners, tickers, and streams that outlive a single widget frame, and mid-build `setState` calls can crash the engine.
* **Solution**:
  - Implemented [`D4rtFlutterApplication`](file:///Users/mac/Dev/projects/dartnative_go/lib/src/interpreter/d4rt_flutter_application.dart) supporting `onMount` and `onUnmount` hooks invoked automatically across reloads and disconnects.
  - Implemented safe `setState` deferral via microtask scheduling when invoked during active render passes.

---

## 5. Directory Structure & Key Files

```
dartnative_go/
├── guest_app/                                # Dynamic guest application code
│   ├── main.dart                            # Entrypoint (CounterApp StatefulWidget)
│   └── reset_button.dart                    # Subcomponent (demonstrating multi-file imports)
├── lib/
│   ├── main.dart                            # Host application, Launcher UI, OTA client
│   ├── d4rt_bridges.b.dart                  # Bridge entrypoints
│   └── src/
│       └── interpreter/
│           ├── dartnative_bridges.b.dart    # 51,000+ lines generated DartNative bindings
│           ├── dn_bridge.dart               # Bridge registration helper
│           ├── relaxers.b.dart              # Type relaxer wrappers
│           └── widget_proxies.dart          # Interpreted StatefulWidget & State proxies
├── tool/
│   ├── dev_server.dart                      # Live Dev Server (HTTP bundle + WebSocket)
│   └── generate_app_assets.dart             # Asset generator
├── pubspec.yaml                             # Host dependencies (tom_d4rt, dartnative)
└── ARCHITECTURE.md                          # This document
```

---

## 6. How It Works: Step-by-Step Execution Flow

1. **Host Bootstrapping**:
   - The native app starts and displays the **DartNative Go Launcher** screen.
   - `_initInterpreter()` instantiates `D4rt()` and registers `dartnative_bridges.b.dart` and `widget_proxies.dart`.
2. **Dev Server Connection**:
   - Tapping **"Connect to Live Dev Server"** fetches `http://localhost:8088/bundle.json`.
   - The host opens a WebSocket connection to `ws://localhost:8088/ws` for change notifications.
3. **Execution**:
   - `_interpreter.execute(source: mainCode, name: 'main', sources: _liveSources)` is evaluated.
   - If the returned object is an interpreted `StatefulWidget`, the host wraps it in an `InterpretedStatefulWidgetProxy`.
   - The proxy mounts into the Flutter/DartNative element tree as a true native widget.
4. **Interactive State & Hot Reload**:
   - Clicking buttons triggers interpreted event handlers; `setState()` triggers native rebuilds.
   - Saving changes in `guest_app/` causes the Dev Server to push a WebSocket notification.
   - The host fetches the updated bundle and re-evaluates the widget tree instantly.

---

## 7. Commands & Quick Reference

```bash
# Start the live dev server
dart run tool/dev_server.dart

# Run the host app on iOS simulator or device
dn run -d <device-id>

# Generate/update bridges (if DartNative framework APIs change)
dart run tom_d4rt_generator:d4rtgen
```

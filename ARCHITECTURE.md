# DartNative Go — Architecture & Implementation

## 1. Overview

**DartNative Go** is an on-device dynamic client runtime for [DartNative](https://dartpub.dev) applications (analogous to *Expo Go* in the React Native ecosystem). It enables developers to author full DartNative mobile applications using multi-file modular structures, stateful components, Riverpod state management, and local `setState()`, and run or hot-reload them dynamically over Wi-Fi / localhost in under 50ms without recompiling native binaries.

---

## 2. High-Level Architecture

```
   ┌────────────────────────────────────────────────────────────────────────┐
   │             Live Dev Server (bin/dart_go.dart / server.dart)           │
   │  - Validates pubspec & native plugins                                  │
   │  - Analyzes dependencies (.dart_tool/package_config.json)              │
   │  - Serves lightweight user code ZIP: http://localhost:8088/user-code.zip│
   │  - Serves pure-Dart package ZIPs:    http://localhost:8088/pkg/*.zip   │
   │  - Serves pre-compiled AST bundle:   http://localhost:8088/guest.ast   │
   │  - Real-time WebSocket:              ws://localhost:8088/ws            │
   │  - Bi-directional sync:              reload, breakpoints, verbose mode │
   └──────────────────┬────────────────────────────────▲────────────────────┘
                      │ HTTP Manifest & ZIP Bundles    │ Real-time Telemetry
                      ▼                                │ & Device Logs
   ┌───────────────────────────────────────────────────┴────────────────────┐
   │             Host App (dartnative_go / lib/main.dart)                   │
   │                                                                        │
   │  ┌──────────────────────────────────────────────────────────────────┐  │
   │  │  Runner Pipeline (lib/src/runner/)                               │  │
   │  │  - BundleLoader (In-memory + On-device DepCache)                 │  │
   │  │  - DartGoLogger (Auto-checking zero-if/else logging & bench)     │  │
   │  │  - LiveConnection (WebSocket reload & bidirectional verbose sync)│  │
   │  └───────────────────────────────┬──────────────────────────────────┘  │
   │                                  ▼                                     │
   │  ┌──────────────────────────────────────────────────────────────────┐  │
   │  │  Dual-Mode Interpreter Engines                                   │  │
   │  │  1. Source Mode (tom_d4rt - Analyzer-based on-device execution)  │  │
   │  │  2. AST Mode (tom_d4rt_ast - Analyzer-free precompiled bundle)   │  │
   │  │  - Automated Type-Safe Bridges (51,000+ lines generated)         │  │
   │  │  - User-module-only state snapshotting (< 2ms)                   │  │
   │  └───────────────────────────────┬──────────────────────────────────┘  │
   │                                  ▼                                     │
   │  ┌──────────────────────────────────────────────────────────────────┐  │
   │  │  Widget & State Interface Proxies (lib/src/interpreter/)         │  │
   │  │  - InterpretedConsumerWidget (Riverpod Ref + ProviderScope mount)│  │
   │  │  - InterpretedStatefulWidgetProxy / InterpretedStateProxy        │  │
   │  │  - Granular Generational Remounting (Targeted mutated widget)    │  │
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
| **Source Interpreter** | `tom_d4rt` (v1.77.0) | Pure-Dart interpreter operating in **source-based (analyzer)** mode (default). |
| **AST Interpreter** | `tom_d4rt_ast` | Zero-dependency, analyzer-free AST interpreter for precompiled bundles. |
| **Bridge Generator** | `tom_d4rt_generator` / `d4rtgen` | Code generator that inspected DartNative framework APIs and generated 51,000+ lines of reflection-free bindings. |
| **Live Dev Server** | `dart_go start` (`server.dart`) | HTTP manifest + on-demand dependency packager + UDP broadcaster + WebSocket server. |
| **Guest Application** | Pure Dart (`example/` / user app) | Interpreted modular code written against standard DartNative & Flutter-compatible APIs. |

---

## 4. Key Architectural Subsystems

### 4.1 Dependency Packaging & On-Device Caching (Expo Go Architecture)
* **Challenge**: Packaging entire projects with large dependencies into a single monolithic bundle causes massive bundle downloads and slow parsing on every single save.
* **Solution**:
  1. **Split Manifest & Packaging**: Dev server inspects `.dart_tool/package_config.json` via `DepPackager`. Pure Dart dependencies (e.g. `flutter_riverpod`, `collection`, etc.) are packaged into individual versioned ZIP archives (`/pkg/<name>@<version>.zip`) with immutable cache headers.
  2. **User Code Isolation**: Only user project code is zipped into `/user-code.zip`.
  3. **On-Device `DepCache`**: Downloaded package ZIPs are unpacked and persisted in `<app_support_dir>/dartnative_go/dep_cache/<pkg>@<ver>/`.
  4. **In-Memory Cache**: `BundleLoader` retains `_cachedDepSources` across hot reloads. During incremental reloads, fetching dependencies takes **0ms**.
  5. **DevTool Cache Control**: Developers can inspect cache size and clear cached packages from the mobile in-app DevTool overlay.

### 4.2 Sub-100ms Hot Reload & State Preservation
* **Challenge**: Full interpreter state snapshots previously iterated through thousands of library symbols across all 93+ dependencies, taking upwards of 6,700ms per hot reload. Additionally, unmounting root widgets caused `ProviderContainer` disposals, resetting Riverpod state.
* **Solution**:
  1. **Targeted User-Module Snapshotting**: `_snapshotState` and `_restoreState` in `InterpreterRunner` restrict top-level variable retention exclusively to user project modules (`entrypointLibrary` and non-`package:` files). Snapshot time reduced from **6,729ms → < 2ms**.
  2. **Root Container Stabilization**: The root `ProviderScope` is mounted with a stable element key (`const ValueKey('guest_root')`), guaranteeing the container remains live and state is preserved across reloads.
  3. **Granular Generational Remounting**: `InterpretedConsumerWidget` and `InterpretedStatefulWidget` use generational keys (`Consumer_<ClassName>_gen_$gen`). Only the specific widget modified in source code remounts with fresh methods, while preserved state is seamlessly bound.
  4. **Reload Speed**: Total hot reload latency dropped from **~8,200ms → 45ms** (Source) and **< 15ms** (AST).

### 4.3 Unified Auto-Checking Logger (`DartGoLogger`) & Verbose Sync
* **Challenge**: Scattered inline `if (verbose) / else` checks created boilerplate and inconsistency between CLI and device logging.
* **Solution**:
  1. **`DartGoLogger`**: Centralized utility providing `info()`, `debug()`, `bench()`, `reload()`, `warn()`, and `error()`. Internal checks automatically suppress debug and benchmark telemetry when `DartGoLogger.verbose` is `false`.
  2. **Bi-Directional WebSocket Sync (`set_verbose`)**:
     - Pressing `v` in the dev server terminal toggles verbose mode and broadcasts `{'type': 'set_verbose', 'enabled': bool}` to connected mobile apps.
     - Toggling `VERBOSE LOGS` in the mobile app DevTool sends `set_verbose` to the dev server, syncing terminal telemetry instantly.
  3. **Startup Flag**: CLI supports `-v` and `--verbose` flags on `dart_go start`.

---

## 5. Development Workflow & Commands

```bash
# Start Dev Server with interactive hot reload & auto AST build
dart_go start

# Start Dev Server in verbose mode with detailed telemetry
dart_go start -v

# Run Dev Server on custom port
dart_go start --port=8090

# Pre-compile AST bundle for test execution
dart run tool/build_ast_bundle.dart
```

### Dev Server Interactive Stdin Commands:
- `r`: Trigger manual hot reload across all connected devices.
- `v`: Toggle verbose diagnostic logging & benchmark traces.
- `q`: Render ASCII QR code in terminal for camera scanning.
- `c`: Clear terminal screen.
- `h`: Show command help.

---

## 6. Headless Test Lab (`test/`)

All suites are `package:test` and run under the DartNative tester —
`dn test test/` is the single runner (never bare `dart test` for widget
suites: `package:dartnative` needs `dart:ui`). The old
`test/run_all_tests.dart` import-hack is retired.

```text
test/
  unit/      # pure logic, no dart:ui
  runner/    # interpreter flows via DnHarness (reload, modes, riverpod, UI)
  server/    # dev-server protocol (FakeDevServer + real-server suites)
  plugins/   # one suite per native plugin (shared_preferences = template)
  test_lab/  # harness INFRA, not suites (DnHarness, widget_probe,
             # reload_driver, FakeDevServer, UiAutomator, fakes, fixtures)
```

- **Bridge fakes (host-only, opt-in):** `loadModule` consults
  `_hasBridgedContentForUri` BEFORE the `sources` map, so registered
  bridges shadow `AutoImportParser` stubs and FFI plugins throw on macOS.
  `DnHarness(bridgeOverrides:)` installs in-memory fakes over the real
  bridges (last registration wins, before first evaluate) — one
  `test/test_lab/fakes/fake_<plugin>.dart` per plugin. Device suites pass
  NO overrides and run with
  `dn test -d <id> --dart-define=DN_DEVICE_TEST=true`.
- **Assertion channels:** tap side effects are asserted via host-visible
  channels (`onLog` prints = device logs on-device, fake-host objects,
  provider containers). Interpreted statics/top-levels are per-`execute`
  isolated and MUST NOT be the assertion channel.
- **Skills:** `.agents/skills/dartnative-test-{lab,writing}` (runbook +
  authoring recipe) and `dartnative-plugin-matrix` (per-plugin checklist).

---

## 7. UI Automation Protocol (WS)

Test scripts drive the app as second WebSocket clients; the dev server
relays automation messages (`ui_*`, test-origin `reload`/`restart`) and the
app answers from its live tree (`lib/main.dart` probe handler, anchored at
`_guestProbeKey` so probes prefer the reconciled DNTree with native
`viewId`s, falling back to the widget walk).

| Direction | Messages |
| :--- | :--- |
| script → device | `ui_probe_request`, `ui_tap{title}`, `ui_hover/focus/blur{sub}`¹, `ui_submit/ui_type{text}`, `restart`², `reload`² |
| device → script | `ui_tree{tree}`, `ui_tap_result`, `ui_<action>_result{ok,error?,viewId?}` |

¹ Selectors: `{title?, text?, key?, icon_code_point?}` (AND-combined).
`hover` = reachability + `viewId` report (the SDK exposes no hover
callbacks). `focus`/`blur` need `TextField.focusNode`; `submit` needs
`onSubmitted` (Buttons fail with "use tap"); `type` needs a controller and
fires `onChanged`.
² `origin: test` only — device reloads originate server-side, so test
signals cannot loop. `restart` drops interpreter state and (re)mounts;
`reload` preserves it.

YAML scenarios (`tool/scenarios/*.yaml`) run headless
(`--against fake`, canned trees + temp sandbox) or on-device via
`dart run tool/ui_test_run.dart` (vanilla `dart run`: only pure imports).
Steps: `require_clean` (fail fast on dirty reload targets, or
`restore: true`), `restart`, `probe`, `expect_text/no_text/button/key/icon`,
`tap`, `hover/focus/blur/submit/type`, `probe_until`, `reload`
(exactly-once `search→replace`/`append`, `settle`/`revert`), `sleep`, `log`.

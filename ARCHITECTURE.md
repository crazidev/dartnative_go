# DartNative Go — Architecture & Implementation

## 1. Overview

**DartNative Go** is an on-device dynamic client runtime for [DartNative](https://dartpub.dev) applications (analogous to *Expo Go* in the React Native ecosystem). It enables developers to author full DartNative mobile applications using multi-file modular structures, stateful components, Riverpod state management, and local `setState()`, and run or hot-reload them dynamically over Wi-Fi / localhost in under 50ms without recompiling native binaries.

---

## 2. High-Level Architecture

```
   ┌────────────────────────────────────────────────────────────────────────┐
   │             Live Dev Server (bin/dngo.dart / server.dart)              │
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
| **Live Dev Server** | `dngo start` (`server.dart`) | HTTP manifest + on-demand dependency packager + UDP broadcaster + WebSocket server. |
| **Guest Application** | Pure Dart (`example/` / user app) | Interpreted modular code written against standard DartNative APIs. |

---

## 4. Key Architectural Subsystems

### 4.1 Dependency Packaging & On-Device Caching (Expo Go Architecture)
* **Challenge**: Packaging entire projects with large dependencies into a single monolithic bundle causes massive bundle downloads and slow parsing on every single save.
* **Solution**:
  1. **Split Manifest & Packaging**: Dev server inspects `.dart_tool/package_config.json` via `DepPackager`. Pure Dart dependencies (e.g. `riverpod_kit`, `collection`, etc.) are packaged into individual versioned ZIP archives (`/pkg/<name>@<version>.zip`) with immutable cache headers.
  2. **User Code Isolation**: Only user project code is zipped into `/user-code.zip`.
  3. **On-Device `DepCache`**: Downloaded package ZIPs are unpacked and persisted in `<app_support_dir>/dartnative_go/dep_cache/<pkg>@<ver>/`.
  4. **In-Memory Cache**: `BundleLoader` retains `_cachedDepSources` across hot reloads. During incremental reloads, fetching dependencies takes **0ms**.
  5. **DevTool Cache Control**: Developers can inspect cache size and clear cached packages from the mobile in-app DevTool overlay.

### 4.2 Scale-Proof Incremental AST & Delta Patch Protocol (`guest.ast.patch`)
* **Challenge**: In applications containing hundreds or thousands of modules (e.g. 500–2,000+ files), monolithic AST bundles grow to 2–5+ MB. Downloading and JSON-deserializing the full bundle on every 1-line edit creates a 3–5 second bottleneck (network transfer + ~2.5s client CPU decoding).
* **Solution**:
  1. **In-Memory DFS Seeding**: On save, `AstBuilder` seeds the dependency graph with unchanged module compilation units, reducing full DFS traversal across thousands of files down to **~1ms**.
  2. **Cold-Build Cache Warming**: Re-reads for hashing are eliminated by warming `_fileHashCache` during initial start.
  3. **Delta Patch Bundles (`/guest.ast.patch`)**: The server isolates only the modified compilation units and pre-compresses them into an in-memory gzip delta patch (**~20 KB** vs 1.89 MB, a **99% reduction** in network payload).
  4. **Zero-Manifest Fast-Path**: Code-only reloads bypass `/manifest.json` completely, saving 300–500ms of roundtrip latency. The full manifest is automatically fetched only when asset additions in `assets/` are detected.
  5. **In-Memory `AstBundle.applyPatch()`**: The device runtime merges the delta compilation units into the live AST tree in **~5ms**, skipping the deserialization of hundreds of unchanged modules and swapping declaration cells in **~45ms**.
  6. **Patch lineage**: every hot build records the generation its delta applies to; the device sends its base as `?base=` and takes the full bundle on mismatch instead of building a franken-bundle from a skipped intermediate reload (self-healing on the next save, no restart).
  7. **Scale Benchmarks**: 10 changed files out of 2,000 modules rebuild in **19ms** and hot-reload on device in **~100–150ms**.

### 4.3 Sub-100ms Hot Reload & State Preservation
* **Challenge**: full state snapshots walked thousands of symbols across 93+ dependencies (~6,700ms per reload), root unmounts killed Riverpod containers, and the AST engine rebuilt the whole runtime then guessed what to keep by type-name heuristic — so ordinary state reset and live objects ran stale code.
* **Big picture** — one reload is a pipeline; every stage below plugs into it:

```text
save in IDE ──▶ dev server rebuilds guest.ast ──▶ device fetches bundle
        ──▶ evaluate as a new GENERATION (cells swapped, modules reused)
        ──▶ remount changed widgets ──▶ report timing / errors to CLI
```

* **Declaration cells** (`tom_d4rt_ast/declaration_registry.dart`): the runtime keeps a process-lifetime registry. Every declaration resolves to a **stable object** whose *contents* a reload replaces — live references never dangle:

```text
gen 1                          gen 2 (body edit)
┌──────────────┐                ┌──────────────┐
│ shell (fn)   │                │ NEW shell    │
│      │       │                │      │       │
│      ▼       │                │      ▼       │
│ ┌──────────┐ │  publish       │ ┌──────────┐ │
│ │ Cell     │ │ ─────────────▶ │ │ Cell     │ │  same object,
│ │ code: v1 │ │                │ │ code: v2 │ │  new contents
│ └──────────┘ │                │ └──────────┘ │
└──────────────┘                └──────────────┘
  ▲ class tables, tear-offs,         ▲ every live reference
    timers/callbacks all               now runs v2 — nothing
    point at the cell                  re-wires
```

  1. **`FunctionCell`** — `InterpretedFunction` is a thin shell; `bind()` shares the cell, so bound-method and lookup caches stay valid by identity.
  2. **`VariableCell`** — top-levels, class statics, enum statics. Dart VM rule: keep the value when the initializer is unchanged, re-evaluate when it changed — compared by an **offset-free canonical key** (an edit earlier in the file must not reset unrelated state). `late` stays lazy, `final` enforced, imports share the cell.
  3. **`ClassCell`** — each generation builds a fresh class object (tables freeze after wiring) and publishes it; `InterpretedInstance.klass` reads through the cell, so pre-reload objects dispatch to the reloaded class and `is`/`as` keep working.
  4. **Additive vs breaking** — body edits and added members keep the cell; a changed signature or removed member retires it, so old instances keep the old call shapes.
* **Generation transactions** — every publication is journalled; a failed reload replays the journal in reverse, so the mounted widget never runs a half-applied generation.
* **Async policy** — the parent map that resumes suspended `await`s is kept alive while older-generation activations are still running; they finish on the code they started in.
* **One persistent core runner** — the `tom_d4rt_ast` runner, bridges and warm stdlib parent are built once and reused; only hot restart / mode switch / unmount tears down.
* **Module reuse** — the server ships per-module fingerprints in `/manifest.json`; a module unchanged **since the previous generation** is not re-declared (its `LoadedModule` is reused and re-parented). Only the *latest* fingerprint is cached: a reverted file must be re-declared, or the cells (holding the newer code) and the module (claiming the old shape) disagree:

```text
gen N (todo.dart unchanged → REUSED)     gen N+1 (sticky.dart edited → re-declared)
┌────────────────────────┐               ┌────────────────────────┐
│ cached env: {...}      │  re-run       │ fresh env: {Note}      │
│   │ import merge       │  merges  ───▶ │                        │
│   ▼                    │               │  added names appear;   │
│ {.., Note}  ◀──────────┘               │  same-declaration      │
└────────────────────────┘               │  bindings are skipped  │
  reused object, healed bindings         └────────────────────────┘
```

  Three rules keep reuse sound: (1) a reused module re-runs its import/export merges, so names a dependency *adds* later become visible; (2) Pass 1 runs before the import merge, so a cyclic import can't plant the previous generation's frozen class as this generation's placeholder; (3) unprefixed-import records are replaced, not accumulated.
* **Widget side** — the framework only rebuilds what changed:
  1. **Generational keys** (`Stateful_<Class>_gen_$gen`): the tracker maps changed files to widget classes. AST bundles carry no source text, so the class→file map is derived from the decoded compilation units (`AstInterpreterRunner.classFileMap`) on every load/reload/restart.
  2. **Stable root** (`guest_root` key) keeps providers and state alive; overlapping reloads/ restarts are ordered by monotonic sequence tokens.
  3. **Bottom sheets** live in their own reconciler outside the app root, so `NativeBottomSheetManager.notifyHotReload` rebinds them explicitly: visitor advances, state fields carry over on retired classes, never gated on `mounted`; the unchanged child widget is marked dirty via `lastStateProxy` (stateless content gets a per-reload subtree key instead).
  4. **Pushed routes** are not rebuilt with the root, so each mounted state proxy rebinds directly: `findUserClassInVisitor` searches the new generation's *loaded module environments* (entry-merged names miss transitively imported screens; bundle sources are usually absent on device). A `[HotReload] could not find X` log means that screen goes stale until remount.
  5. **Proxies unwrap** — a host widget object handed back to guest code (`didUpdateWidget(covariant StickyNote oldWidget)`) implements `D4InterpretedProxy`, so argument checks and field reads resolve through the interpreted class behind it.
* **Callback identity** — `==` / `!=` never invoke function values; callbacks compare by identity. (The binary-expression visitor used to auto-call zero-arg closures, so any `callback == null` guard executed the callback.)
* **Bridge warm-up is lazy** — a same-type re-registration (one class bridged through two barrels) swaps the deferred thunk instead of building two `BridgedClass` member maps eagerly; cross-generation re-merges compare by native type rather than object identity, so reloads don't throw spurious conflicts or pay re-registration.
* **Failures reach the terminal**:

```text
guest build / lifecycle / button handler throws
        ──▶ host hook (onGuestError / onCallbackError) ──▶ DartGoLogger.error
        ──▶ logSink ──▶ WebSocket ──▶ CLI prints red [Device Error] + short stack
        (reporting never swallows: the error is logged and surfaced on-device)
```

* **Bad saves never take down the working app** — three gates, inside out:
  1. **Server**: a bundle build that fails leaves the previous `guest.ast` in place and broadcasts *nothing*; devices keep running untouched, the CLI warning is the whole signal.
  2. **Host**: a reload whose evaluation throws keeps the mounted tree (the interpreter already rolled its generation back); only an initial load with nothing to show gets the error screen.
  3. **Proxy**: a guest `build` that starts throwing renders its last good child (`_lastGoodChild`); before the first good child, a monitored failure renders a neutral placeholder (via `onGuestBlankBuild`) so the framework's red screen never flashes before the host error view. `createState` still throws — there is no widget to replace.
* **Error display** (`ErrorDisplayStorage`, DevTools → ERROR DISPLAY): failures are always recorded; `summarizeGuestError` strips host/interpreter framing so surfaces show the cause with the exception type as subtitle. Automatic surface is the dismissible `GuestErrorBanner`; `InterpreterErrorView` opens on banner tap, failed-to-start, or persisted full-screen mode. Both live in the host `App.builder` layer (above every route). Recovery waits for `onGuestRecovered` (or remount + two clean frames). Blank proxies report once per distinct message. Error-view Reload again retries the screen in place; DevTools Reload restarts to root; Home pops to the launcher. CLI gets a trimmed 8-line stack (full under `-v`).
* **Source engine** (legacy): user-module-only snapshots (`< 2ms`), stable root key, generational remount.
* **Engines**: AST (default, pre-compiled bundles) and Source (on-device analyzer parsing). The Bytecode stack VM was removed: two engines, no kill switches.


### 4.4 Unified Auto-Checking Logger (`DartGoLogger`) & Verbose Sync
* **Challenge**: Scattered inline `if (verbose) / else` checks created boilerplate and inconsistency between CLI and device logging.
* **Solution**:
  1. **`DartGoLogger`**: Centralized utility providing `info()`, `debug()`, `bench()`, `reload()`, `warn()`, and `error()`. Internal checks automatically suppress debug and benchmark telemetry when `DartGoLogger.verbose` is `false`.
  2. **Bi-Directional WebSocket Sync (`set_verbose`)**:
     - Pressing `v` in the dev server terminal toggles verbose mode and broadcasts `{'type': 'set_verbose', 'enabled': bool}` to connected mobile apps.
     - Toggling `VERBOSE LOGS` in the mobile app DevTool sends `set_verbose` to the dev server, syncing terminal telemetry instantly.
  3. **Startup Flag**: CLI supports `-v` and `--verbose` flags on `dngo start`.

### 4.5 Host Theme (shadcn tokens + Riverpod)
* **Location**: the theme lives in `pkgs/dngo_ui` (`lib/src/theme/`).
  Tokens: `pkgs/dngo_ui/tool/shadcn_tokens.css` holds the
  `:root`/`.dark` shadcn custom properties. From `pkgs/dngo_ui/`,
  `dart run tool/shadcn_to_dart.dart` converts every `oklch(...)` token to
  sRGB and emits `lib/src/theme/shadcn_theme.dart` (`ShadcnLight`/`ShadcnDark`
  bags + `ThemeData` with a shadcn→ColorScheme
  mapping; `destructive` has no `-foreground` token, so `onError` is derived
  as the highest-contrast theme neutral). `host_ui_theme.dart` aliases the
  generated data as `HostUiThemeData`/`HostUiRadius`.
* **State**: `ThemePreference {system, light, dark}` persists via
  `ThemeStorage` (same pattern as `ErrorDisplayStorage`) and is owned at
  runtime by `themePreferenceProvider` (`NotifierProvider<ThemeController, …>`
  from `riverpod_kit`, whose `ProviderScope.rootContainer` fallback keeps
  native sheets on the same container). Mutations persist and pin the native
  appearance via `setAppBrightness` (null = follow system).
* **Surfaces**: launcher `App(theme/darkTheme/themeMode)` + hand-painted
  `LauncherColors`; launcher app-bar "Change Theme" cycles; DevTools sheet
  has a THEME section mirroring ERROR DISPLAY.

---

## 5. Development Workflow & Commands

```bash
# Start Dev Server with interactive hot reload & auto AST build
dngo start

# Start Dev Server in verbose mode with detailed telemetry
dngo start -v

# Run Dev Server on custom port
dngo start --port=8090

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
- **Reload-state suites** worth knowing:
  `runner/ast_runner_persistence_test.dart` (one core runner across reloads),
  `runner/ast_reload_function_swap_test.dart` (bodies swapped on live
  instances, signature/additive rules),
  `runner/ast_reload_variable_state_test.dart` + `ast_reload_static_state_test.dart`
  + `ast_reload_enum_state_test.dart` (cell-backed storage),
  `runner/ast_reload_module_reuse_test.dart` (fingerprinted module reuse,
  reverted module re-declaration, decode cache, async activation surviving a
  reload),
  `runner/ast_reload_bottom_sheet_test.dart` (sheet proxy rebind, state fields
  preserved, stateless sheet content),
  `runner/ast_widget_proxy_argument_test.dart` (a widget proxy satisfies a
  covariant interpreted parameter, wrong arguments still rejected),
  `runner/ast_guest_error_reporting_test.dart` (a throwing callback and a
  throwing build reach the host error channel),
  `runner/ast_widget_generation_tracking_test.dart` (a widget outside the entry
  module bumps its generation),
  `runner/ast_circular_module_test.dart` (edits on either side of a cyclic
  user import take effect),
  `runner/ast_class_moves_modules_test.dart` + `ast_stateful_move_modules_test.dart`
  (a class moving between modules, through a broken intermediate),
  `runner/ast_committed_broken_heals_test.dart` (a broken generation that
  commits because the bad reference sits in a build body heals when the export
  appears),
  `runner/ast_proxy_error_boundary_test.dart` (a throwing build falls back to
  the last good child, then builds fresh when fixed; a first build renders a
  neutral placeholder instead of the framework error screen),
  `server/build_failure_gate_test.dart` (a failed rebuild broadcasts nothing,
  the fixed rebuild broadcasts),
  `runner/ast_reload_atomic_generation_test.dart` (failed generation rolls
  back).
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

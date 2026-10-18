# Session Context — `server-components` branch

> **Last updated:** 2026-10-15  
> **Branch:** `server-components`  
> **Recent commits:**
> - `d9a0e63` refactor(cli): organize commands, packaging, diagnostics, and server
> - `f774ba2` chore: replace emoji with ASCII tags in logs and UI strings

---

## What we've been doing

### 1. Server-Components feature (the big arc)

The branch is building a full **Server Component** system on top of DartNative Go:

- `@ServerComponent` annotation lets Dart widgets be served from the server and hot-swapped OTA.
- A **build pipeline** (`server_component_bundler.dart`) scans annotations, compiles AST bundles, and exports them to a CDN-ready directory.
- A **dev server** (`DartGoServer`) serves those bundles over HTTP/WebSocket and broadcasts hot-reload events.
- A **client widget** (`ServerComponentView` / `ServerComponentLoader`) fetches and mounts the remote component at runtime.
- A **test harness** (`ServerComponentHarness`) lets headless tests drive the full load→render→reload cycle.

Phases completed (per commit history):
| Phase | Description |
|-------|-------------|
| 1 | Server annotation scanner |
| 2c | Build pipeline + tests |
| 3 | Runtime component loading |
| 4 | Headless `ServerComponentHarness` + component tests |
| 5 | Dev server component endpoints |
| 6 | CDN export tool |
| — | Live-device demo glue |
| — | Example app restructure (server-demo + sticky-note screens) |
| — | Snapshot of remaining branch work (MCP server, debug bridge, app cache, breakpoint overlay) |

---

### 2. CLI refactor (`bin/dart_go.dart` + `lib/src/cli/`)

The flat `lib/src/cli/` directory was reorganised into sub-packages:

```
lib/src/cli/
  commands/          ← DartGoCommandLine (pure parse, no side-effects)
  diagnostics/       ← asset_detector, dart_go_version, pubspec_validator
  packaging/         ← ast_builder, dep_packager, safe_ast_converter
  server/            ← server, broadcaster, qr_code, dev_socket_hub, http_support, terminal_ui
  server_components/ ← client_module_index, server_annotation_scanner/source, server_component_bundler
```

`bin/dart_go.dart` is now a thin dispatcher that delegates to `DartGoCommandLine.parse()` and calls the right handler — no inline arg-parsing logic.

The server itself was split into focused files:
- **`DevSocketHub`** — WebSocket registry, broadcast, UI-automation relay, breakpoint replay.
- **`StdinCommands`** / **`terminal_ui.dart`** — interactive key handler (`h/r/v/q/c`) and banner printing.
- **`http_support.dart`** — shared HTTP response helpers (sendText, sendJson, sendBytes, ETag).

---

### 3. Emoji → ASCII tag cleanup (committed `f774ba2`)

All emoji prefixes in log/output strings were replaced with plain ASCII bracket tags so output is clean in CI, the DAP output pane, and VS Code's debug console:

| Old | New |
|-----|-----|
| `🔴` | `[ERROR]` |
| `⚠️` | `!` / `[WARN]` |
| `⚡️` | `[RELOAD]` |
| `🛑` | `[STOP]` |
| `✅` | `[OK]` |
| `❌` | `[ERROR]` |
| `🧹` | `[CLEAN]` |
| `👉` | `->` |
| `⏱️` | `[TIME]` |

Files touched: `logger.dart`, `dap_server.dart`, `debug_controller.dart`, `floating_devtool_button.dart`, `main.dart`.

---

### 4. Other in-flight changes (not yet committed)

| File / area | What changed | Status |
|-------------|-------------|--------|
| `bin/dart_go.dart` | Rewired to `DartGoCommandLine`; old inline arg-parsing removed | Unstaged |
| `lib/src/cli/commands/command_line.dart` | New — pure CLI parser | Untracked |
| `lib/src/cli/server/{dev_socket_hub,http_support,terminal_ui}.dart` | New — server split-out | Untracked |
| `lib/src/cli/{diagnostics,packaging,server,server_components}/` | Reorganised from flat `cli/` | Staged (new files) / old paths deleted |
| `lib/src/theme/shadcn.dart` | `dartnative_shadcn` exports commented out (dep resolution issue) | Unstaged |
| `lib/src/widgets/server_component_loader.dart` | Import path updated to new `server_components/` sub-package | Unstaged |
| `lib/src/runner/{ast_interpreter_runner,bundle_loader,dep_cache}.dart` | Import paths updated to new sub-packages | Unstaged |
| `example/pubspec.yaml` | Plugin overrides moved from `.dart_tool/dartnative_sdk/` → `../.dart_tool/dn_plugins/` | Unstaged |
| `example/lib/plugins/plugins_screen.dart` | Temporarily shows `TodoScreen` instead of `MediaPickerDemo` | Unstaged |
| `example/lib/sticky-note/todo_screen.dart` | `BarButtonItem` action commented out | Unstaged |
| `lib/src/debug/debug_bridge.dart` | Deleted (was snapshotted in last commit, now removed) | Unstaged |
| `lib/src/mcp/mcp_server.dart` | Deleted (was snapshotted in last commit, now removed) | Unstaged |
| `test/unit/{debug_bridge,mcp_server}_test.dart` | Deleted alongside their subjects | Unstaged |
| All `test/runner/`, `test/server/`, `test/unit/` files | Import path updates only (1-line each) | Unstaged |
| `tool/*.dart` | Import path updates | Unstaged |
| `docs/architecture/` | New architecture docs directory | Untracked |

---

### 5. Interpreter + reload correctness arc (ready to commit)

Device-driven debugging session against the `example/` demo app (40 modules,
`collection` + `equatable` in the graph). Six fixes, each with regression
tests; all suites green. Requires a host-app rebuild + `dart_go` restart to
reach devices (interpreter, retry, and lineage client all ship in the binary).

| # | Fix | Files |
|---|-----|-------|
| 1 | Cold-start bridge registration: same-type re-registration swaps the lazy thunk instead of eagerly building two `BridgedClass` member maps (`registerBridgedDefinitions` ~8 s → warm-parent build is lazy) | `pkgs/tom_d4rt_ast/.../environment.dart` |
| 2 | Reload re-merge equivalence: same native class/enum rebuilt in a new generation compares by type/value-set, not object identity (killed the `UnmodifiableListView` export-conflict on reload) | same file |
| 3 | AST bundle explorer: structured `AstProfileSnapshot` (always-on cheap timings, sized on demand) + DevTool **AST BUNDLE** panel + identical verbose `[PROFILE]` logs; the panel is gated on the server-side `--profile` flag (`profile` manifest field → `profileEnabled` bundle field) | `lib/src/runner/ast_profile.dart` (new), `ast_interpreter_runner.dart`, `lib/src/devtool/ast_profile_panel.dart` (new), `devtool_sheet.dart`, `devtool_overlay.dart`, `lib/main.dart` |
| 4 | Patch lineage (`?base=` + `X-Ast-Bundle` + `astPending`): deltas apply only to their recorded base; mismatches fall back to full fetch instead of franken-bundles; devices wait out the background initial build instead of falling back to source | `ast_builder.dart`, `lib/src/cli/server/server.dart`, `bundle_loader.dart`, `interpreter_runner.dart` |
| 5 | Pushed-route rebind lookup via the loader's live `moduleCache` (entry merges + bundle ASTs/sources never see transitive screens — the `[HotReload] could not find X` stale-screen bug); incremental rebuilds preserve + refresh bundle `sources` | `native_bottomsheet_manager.dart`, `ast_builder.dart` |
| 6 | `==` / `!=` never invoke zero-arg callbacks (a `callback == null` guard executed the callback — the share-demo loop) | `pkgs/tom_d4rt_ast/.../interpreter_visitor.dart` |

New tests: `environment_lazy_rereg_test`, `environment_import_equivalence_test`
(pkgs), `ast_callback_identity_test`, `ast_module_cache_lookup_test`,
lineage tests in `harness_pubspec_bundle_test` + `ast_builder_test`,
manifest `astPending` assertion, `@Timeout(120s)` on the example reload test.

Known pre-existing failures (verified identical with and without these
changes): `ast_guest_error_reporting_test` stack-trace assertion,
`system_bridge_test` device-gated case, batch-run timing flakes under
concurrency (suites pass file-by-file).

---

## What we're going to do next

### Immediate — finish the CLI refactor commit

1. **Stage and commit the CLI reorganisation** as one logical commit:
   - New `lib/src/cli/{commands,diagnostics,packaging,server,server_components}/` files
   - Deleted old flat `lib/src/cli/*.dart` files
   - Updated `bin/dart_go.dart`
   - All import-path fixups across `lib/`, `test/`, `tool/`

2. **Stage and commit the example app changes** separately:
   - `example/pubspec.yaml` plugin override path fix (`dn_plugins` vs `dartnative_sdk`)
   - `example/lib/plugins/plugins_screen.dart` (restore `MediaPickerDemo` or keep `TodoScreen` intentionally)
   - `example/lib/sticky-note/todo_screen.dart` (decide on the commented-out `BarButtonItem`)

3. **Decide on `dartnative_shadcn`** — the exports are commented out in `shadcn.dart`. Either:
   - Fix the dep resolution and restore the exports, or
   - Remove the dependency entirely if shadcn is not needed on this branch.

### Medium-term — server-components polish

- Wire `DevSocketHub` and `StdinCommands` into the refactored `DartGoServer` (the new server.dart is 1268 lines — may need further splitting).
- Verify the `docs/architecture/` docs are accurate and complete.
- Run the full test suite (`dn test`) to confirm all import-path changes compile cleanly.
- Decide fate of `debug_bridge.dart` and `mcp_server.dart` — were they intentionally removed or just deferred?

### Longer-term

- Publish the server-components feature to the `main` branch via MR.
- Update `docs/README.md` and `docs/getting_started.md` with server-component usage.

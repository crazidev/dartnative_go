# Architecture

A plain-language map of how DartNative Go fits together. For the exhaustive
deep-dive (bridge internals, widget proxies, reconciler details) see the root
[ARCHITECTURE.md](../ARCHITECTURE.md). This page is the orientation you read
first.

## The big picture

DartNative Go is two programs talking over the local network:

- **The dev server** (`dart_go start`) runs on your workstation. It watches
  your guest project's Dart sources, packages them together with their
  dependencies, optionally compiles them into a pre-parsed AST bundle, and
  broadcasts reloads.
- **The shell app** (this repository, run with `dn run`) is a native iOS /
  Android / desktop app with a Dart interpreter embedded in it. It downloads
  your guest code over HTTP and *interprets* it — your widgets are built by
  the interpreter and inflated into real native views by the DartNative
  reconciler.

Because the guest app is interpreted, not compiled, changing a
`lib/*.dart` file and saving can refresh the on-device UI in under 50 ms —
no native build step, no app store, no cable.

```
 your editor                workstation                     device
 ┌──────────┐   save   ┌───────────────────────┐   HTTP    ┌───────────────────┐
 │ lib/*.dart│ ──────► │ dart_go start          │ ────────► │ DartNative Go      │
 └──────────┘          │  · file watcher        │  sources  │  · interpreter     │
                       │  · AST bundler         │  + .ast   │  · widget proxies  │
                       │  · dep packager        │           │  · DN reconciler   │
                       │  · HTTP + WS server    │ ◄──────── │  · native views    │
                       │  · UDP beacon + QR     │   WS      └───────────────────┘
                       └───────────────────────┘  reload
```

## Repository layout

| Path | What lives there |
| :--- | :--- |
| `lib/main.dart` | Product entrypoint (AST-only): plugins + theme bootstrap, then the shared `lib/src/app_shell.dart` host shell. |
| `lib/main_source.dart` | Development entrypoint with the Source engine + analyzer linked (`dn run -t lib/main_source.dart`). |
| `lib/src/cli/` | Everything the `dart_go` CLI uses: `server.dart` (HTTP/WS/file-watch), `broadcaster.dart` (UDP beacons), `dep_packager.dart` (dependency zips), `ast_builder.dart` (guest.ast builds), `pubspec_validator.dart`, `asset_detector.dart`, `qr_code.dart`. |
| `lib/src/runner/` | Guest execution: `interpreter_runner.dart` (source mode), `ast_interpreter_runner.dart` (AST mode), `bundle_loader.dart` (fetch + unpack bundles, patch lineage), `ast_profile.dart` (structured bundle profile), `live_connection.dart` (WebSocket client), `runtime_mode.dart`, `ui_probe.dart` (UI automation), `dep_cache.dart`. |
| `lib/src/interpreter/` | The bridge surface: `dartscript.b.dart` plus one `*_bridges.b.dart` per plugin (generated), `widget_proxies.dart`, `asset_bridge.dart`, `debug_controller.dart`. Subfolder `ast/` holds the AST-mode equivalents. |
| `lib/src/launcher/` | The project-picker UI you see when the app starts. |
| `lib/src/devtool/` | The in-app developer overlay (logs, error surfaces, settings, AST bundle explorer). |
| `lib/src/client/` | Persistence + networking for the launcher (project storage, network scanner, preferences). |
| `bin/` | The `dart_go` CLI entrypoint. |
| `tool/` | Host-side tools: dev server entry, AST bundling, bridge generation, app-asset generation, theme conversion, UI scenario runner. |
| `test/` | `unit/`, `server/`, `runner/`, `plugins/` test suites plus the `test_lab/` automation harness (see [Testing](testing.md)). |
| `example/` | A bundled guest app used by the walkthroughs. |

## The four flows that matter

### 1. Discovery

The server sends a JSON **UDP beacon** every ~1.5 s to the broadcast address
across the port range 8088–8098 plus the dedicated discovery port 45454. The
shell app listens for these beacons and lists found servers in its launcher.
Where broadcast is blocked (corporate Wi-Fi), the terminal **QR code** or
manual URL entry carries the same information. Details:
[Dev Server & Protocol](dev_server.md#discovery-beacons).

### 2. Loading

When you tap a project, the app fetches the manifest, the user-code zip, the
dependency zips (cached by content hash), the asset list, and — when present —
the pre-compiled `guest.ast` bundle. Then it hands everything to the
interpreter, which executes `main()` and captures the root widget. Details:
[Dev Server & Protocol](dev_server.md#http-endpoints).

### 3. Interpretation

Your guest code never touches the Dart compiler on device. Two engines can
execute it — **source mode** parses Dart on-device with `package:analyzer`;
**AST mode** (default) runs the pre-parsed bundle analyzer-free. Both share
one trick: calls into Flutter and native plugins are *bridged* to real
implementations compiled into the shell, and custom widgets become *proxies*
whose `build()` methods run in the interpreter while their output inflates
real native views. Details: [Runtime Modes](runtime_modes.md).

### 4. Hot reload

The server watches `lib/`, rebuilds the AST bundle when needed, and sends a
`reload` WebSocket message. The app re-fetches the code and re-evaluates it
while **preserving state**: top-level variables, statics, and (in AST mode)
function bodies are kept in declaration cells that survive across
generations, so a bad save leaves the working app running. Details:
[Hot Reload](hot_reload.md).

## What the shell compiles in vs. what guests bring

The shell app is a normal DartNative app: it statically links the DartNative
framework and a fixed matrix of native plugins (`dartnative_share`,
`dartnative_webview`, `riverpod_kit`, … — see `dart_go version`). Guests may
use any of those plugins **at the exact versions the shell was built with**
(`dart_go doctor` checks this) plus arbitrary *pure-Dart* packages, which the
server ships as source zips and the interpreter executes like guest code. A
handful of pure-Dart packages (e.g. `dio`) are instead compiled into the shell
and bridged whole, so their guest imports run as native code — see
[Interpreter and bridges](architecture/interpreter.md#third-party-packages-compiled-into-the-shell).

## Where to go next

- [Getting Started](getting_started.md) — run the loop end to end.
- [Dev Server & Protocol](dev_server.md) — every endpoint and message.
- [Runtime Modes](runtime_modes.md) — source vs AST trade-offs.
- [Hot Reload](hot_reload.md) — how state survives.
- [Troubleshooting](troubleshooting.md) — when something is off.

# Architecture by feature

One page per feature: purpose, owning files, data flow, invariants.
Cross-cutting depth (reload internals, bridge details) stays in the root
[ARCHITECTURE.md](../../ARCHITECTURE.md); orientation is in
[../architecture.md](../architecture.md).

| Feature | Owns | Page |
| :--- | :--- | :--- |
| CLI | `bin/dngo.dart`, `lib/src/cli/{commands,diagnostics}/` | [cli.md](cli.md) |
| Dev server and bundling | `lib/src/cli/{server,packaging}/` | [dev-server.md](dev-server.md) |
| Runner (device side) | `lib/src/runner/` (except `ui_*`, `icon_registry`) | [runner.md](runner.md) |
| Interpreter and bridges | `lib/src/interpreter/`, generated `*.b.dart` | [interpreter.md](interpreter.md) |
| Server components | `lib/server*.dart`, `lib/src/server/`, `lib/src/cli/server_components/`, `lib/src/widgets/server_component_*` | [server-components.md](server-components.md) |
| Debugging | `lib/src/{dap,debug}/`, `interpreter/debug_controller.dart` | [debugging.md](debugging.md) |
| Host UI | `lib/main.dart`, `pkgs/dngo_ui`, `pkgs/dngo_api`, `lib/src/{preview,widgets,devtool,theme,client}/` | [host-ui.md](host-ui.md) |
| UI automation and tests | `lib/src/runner/{ui_probe,ui_tree_json,icon_registry}.dart`, `test/` | [testing.md](testing.md) |
| Headless fixtures | `playground/`, `silly_benchmark/`, `test/{playground,silly_benchmark}/` | [playground-headless.md](playground-headless.md), [silly-benchmark.md](silly-benchmark.md) |

## Rules that apply everywhere

- `lib/src/cli/**` runs on the workstation (plain `dart`); it must not import
  `dart:ui` or DartNative UI. `lib/src/runner/ui_tree_json.dart` and
  `icon_registry.dart` are also pure Dart so `tool/` scripts can use them.
- Every guest-facing API exists twice: source engine (`tom_d4rt`) and AST
  engine (`tom_d4rt_ast`, under `interpreter/ast/`). Change both together.
- `*.b.dart` files are generated (`tool/d4rtgen*.dart`); never edit by hand.
- Logging goes through `DartGoLogger`; status prefixes are ASCII
  (`[OK]`, `[ERROR]`, `[RELOAD]`, ...), no emoji.
- The whole `tom_d4rt` family is vendored under `third_party/`
  (`tom_d4rt`, `tom_d4rt_ast`, `tom_d4rt_generator`, `tom_d4rt_exec`) and
  path-overridden from the root `pubspec.yaml`, so our patches ship with the
  app instead of living in a pub-cache copy. `third_party/tom_d4rt_ast` is
  upstream **0.260.0** plus the DartNative patch list in its `pubspec.yaml`
  header; keep local changes minimal and listed there so upstream syncs stay
  mechanical.

# Architecture by feature

One page per feature: purpose, owning files, data flow, invariants.
Cross-cutting depth (reload internals, bridge details) stays in the root
[ARCHITECTURE.md](../../ARCHITECTURE.md); orientation is in
[../architecture.md](../architecture.md).

| Feature | Owns | Page |
| :--- | :--- | :--- |
| CLI | `bin/dart_go.dart`, `lib/src/cli/{commands,diagnostics}/` | [cli.md](cli.md) |
| Dev server and bundling | `lib/src/cli/{server,packaging}/` | [dev-server.md](dev-server.md) |
| Runner (device side) | `lib/src/runner/` (except `ui_*`, `icon_registry`) | [runner.md](runner.md) |
| Interpreter and bridges | `lib/src/interpreter/`, generated `*.b.dart` | [interpreter.md](interpreter.md) |
| Server components | `lib/server*.dart`, `lib/src/server/`, `lib/src/cli/server_components/`, `lib/src/widgets/server_component_*` | [server-components.md](server-components.md) |
| Debugging | `lib/src/{dap,debug}/`, `interpreter/debug_controller.dart` | [debugging.md](debugging.md) |
| Host UI | `lib/main.dart`, `pkgs/dartnative_go_ui`, `pkgs/dartnative_go_api`, `lib/src/{preview,widgets,devtool,theme,client}/` | [host-ui.md](host-ui.md) |
| UI automation and tests | `lib/src/runner/{ui_probe,ui_tree_json,icon_registry}.dart`, `test/` | [testing.md](testing.md) |

## Rules that apply everywhere

- `lib/src/cli/**` runs on the workstation (plain `dart`); it must not import
  `dart:ui` or Flutter. `lib/src/runner/ui_tree_json.dart` and
  `icon_registry.dart` are also pure Dart so `tool/` scripts can use them.
- Every guest-facing API exists twice: source engine (`tom_d4rt`) and AST
  engine (`tom_d4rt_ast`, under `interpreter/ast/`). Change both together.
- `*.b.dart` files are generated (`tool/d4rtgen*.dart`); never edit by hand.
- Logging goes through `DartGoLogger`; status prefixes are ASCII
  (`[OK]`, `[ERROR]`, `[RELOAD]`, ...), no emoji.
- The vendored `pkgs/tom_d4rt_ast` is a fork of upstream 0.65.0. Keep local
  changes minimal and listed in its `pubspec.yaml` header so upstream syncs
  stay mechanical.

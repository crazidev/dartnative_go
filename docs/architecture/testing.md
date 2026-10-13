# UI automation and tests

## Files

| Path | Role |
| :--- | :--- |
| `lib/src/runner/ui_probe.dart` | Serializes the live UI to JSON; taps/types by selector. |
| `lib/src/runner/ui_tree_json.dart`, `icon_registry.dart` | Pure-Dart helpers shared with `tool/` scripts. |
| `tool/ui_test_run.dart`, `tool/scenarios/*.yaml` | YAML scenarios, headless (`--against fake`) or on device. |
| `test/unit` | Pure logic. |
| `test/runner` | Interpreter flows through `DnHarness`. |
| `test/server`, `test/server_component` | Dev-server protocol and component loading. |
| `test/plugins` | One suite per native plugin. |
| `test/test_lab` | Harness infrastructure, fakes, fixtures (not suites). |

## Running

Widget suites need the DartNative tester: `dn test test/`. Pure unit suites
(for example `logger_test`, `asset_detector_test`) also run with `dart test`.

## Rules

- Assert through host-visible channels (logs, fakes, provider containers),
  never interpreted statics.
- Bridge fakes are opt-in via `DnHarness(bridgeOverrides:)`; device suites
  pass none.

Message-level protocol: root [ARCHITECTURE.md](../../ARCHITECTURE.md)
sections 6-7.

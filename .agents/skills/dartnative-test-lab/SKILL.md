---
name: dartnative-test-lab
description: >-
  Use this skill when running, debugging, or organizing tests for dartnative_go. Covers the test layout (test/unit, test/runner, test/server, test/plugins, test/test_lab), the dn test runner (host vs device runs, filters, reporters), and the host-vs-device / fake policies.
---

# dartnative_go Test Lab — Runbook

All suites are `package:test` and run under the DartNative tester. The old
`test/run_all_tests.dart` import-hack is retired; the runner is `dn test`.

## Layout

```text
test/
  unit/      # pure logic, no dart:ui — validator, assets, qr, logger,
             # auto_import, dep packager/cache, ast_builder, bridge_config, debug
  runner/    # interpreter flows via DnHarness — hot_reload, mode_switch,
             # riverpod_*, ui_automation
  server/    # dev-server protocol — pubspec_bundle, websocket, network_scanner,
             # server_integration (real DartGoServer)
  plugins/   # one suite per native plugin (shared_preferences = template)
  test_lab/  # harness INFRA, not suites — never add `*_test.dart` here
    harness.dart            # DnHarness: evaluate / hotReload / hotRestart /
                            # callFunction / bridgeOverrides / switchMode
    widget_probe.dart       # findText(s), findButtons, tapButton, dumpTree
    reload_driver.dart      # applyEdit{,Script} with RefreshKind.reload|restart
    fake_server.dart        # in-memory dev server + WS relay
    ui_automator.dart       # UiAutomator driver + SimulatedDevice
    plugin_case.dart        # PluginCase contract + PluginFailureKind
    fakes/fake_<plugin>.dart
    fixtures/               # shared suite fixtures (riverpod_fixture, …)
```

`lib/src/runner/ui_probe.dart` is the device-capable serializer (widget walk
+ reconciler DNTree walk); `test_lab` re-exports nothing from `lib/` except
through explicit imports.

## Commands

```sh
dn test test/                                   # everything (host)
dn test test/unit                               # one area
dn test test/plugins/shared_preferences_bridge_test.dart
dn test test/ --name "hot reload"               # filter by test name
dn test test/ --reporter expanded               # per-test lines
dn test test/ --reporter json                   # machine-readable
# device (real FFI, real DNTree with viewIds):
dn test -d <device-id> --dart-define=DN_DEVICE_TEST=true test/plugins/...
```

- NEVER bare `dart test` for widget suites: `package:dartnative` needs
  `dart:ui`, which only the `dn` tester provides. Pure-logic `unit/` suites
  also run under `dn test` — keep one runner.
- JSON reporter counts `loading <file>` + `(setUpAll)`/`(tearDownAll)`
  pseudo-tests; the expanded `+N ~M` line is the human tally
  (N pass, M device-skipped).
- Fixed ports are a collision hazard: prefer ephemeral ports
  (`HttpServer.bind(..., 0)`, `DartGoServerOptions(startPort: 0, …)` where
  supported) or `FakeDevServer`. `client_network_scanner_test` still binds
  8090 — do not run it alongside a live dev server.

## UI scenarios on real hardware (`tool/ui_test_run.dart`)

Plain-`dart run` CLI (no `dart:ui`: it imports only the pure `UiAutomator`
driver + `FakeDevServer` + `package:yaml`). Scenarios live in
`tool/scenarios/*.yaml` — steps: `require_clean` (fail fast on dirty
reload targets via `git diff`, or `restore: true` to auto-restore leftover
edits instead of blocking — whole-state reset; start device scenarios
with it), `restart` (hot-restart + settle; doubles as load-the-app —
start every device scenario with it), `probe`,
`expect_text`/`expect_no_text`/`expect_button`/`expect_key`/`expect_icon`,
`tap`, `hover` (reachability + native `viewId` report — the SDK exposes no
hover callbacks), `focus`/`blur` (need `TextField.focusNode`),
`submit` (needs `TextField.onSubmitted`; buttons fail with "use tap"),
`type` (needs `TextField` controller + fires `onChanged`), `probe_until`
(poll after every tap/reload; also takes `key:`/`icon_code_point:`),
`expect_text`/`expect_no_text`/`expect_button`/`expect_key`/`expect_icon`,
`tap`, `hover`/`focus`/`blur`/`submit`/`type` (target via
title/text/key/icon_code_point; submit/type take `text:`), `probe_until`
(poll after every tap/reload; also accepts key:/icon: conditions),
`reload` (file `edit:` with exactly-once `search→replace` or `append:`,
optional `signal: true`, `settle:`/`revert`/`revert_settle:` — NO
full-file write in v1), `sleep`, `log`.

Trigger semantics (honest limits): `hover` = reachability + native viewId
reporting (the SDK exposes no hover callbacks on Button/TextField);
`focus`/`blur` need `TextField.focusNode` (`requestFocus`/`unfocus`);
`type` needs a `TextEditingController` (+ fires `onChanged`); `submit`
needs `onSubmitted` (Buttons: use `tap` — submit fails saying so). All
degrade to clean errors on unsupported targets, including on host stubs.

```sh
dart run tool/ui_test_run.dart --scenario tool/scenarios/counter.yaml --against fake
dart_go start   # in example/ (or your project); connect the app via QR
dart run tool/ui_test_run.dart --scenario tool/scenarios/example_login.yaml \
  --server http://<lan-ip>:<port>
```

Fake mode needs a top-level `fake:` block (`trees:` served round-robin per
probe sticking at last, `taps:` title→`ok`/error, `files:` seeding a temp
sandbox for reload edits). Exit codes: 0 pass, 1 step failure, 2 usage.

## Policies

- **Host vs device**: host runs everything except groups skipped without
  `DN_DEVICE_TEST`. Device runs (`-d` + `--dart-define`) execute the same
  files with real FFI and a real reconciler. A group that needs the device
  MUST use `skip:` with the exact rerun command in the reason.
- **Fakes**: `DnHarness(bridgeOverrides:)` installs host fakes over real
  bridges (last registration wins, before first evaluate). Fakes are
  host-only and opt-in — device suites pass NO overrides. One
  `test/test_lab/fakes/fake_<plugin>.dart` per native plugin.
- **Assertion channels**: tap side effects are asserted via host-visible
  channels — `onLog` prints (= device logs on-device), bridge-fake host
  objects, provider containers. Interpreted statics/top-levels are
  per-`execute` isolated and MUST NOT be the assertion channel
  (see dartnative-test-writing).

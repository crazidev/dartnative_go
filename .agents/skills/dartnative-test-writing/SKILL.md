---
name: dartnative-test-writing
description: >-
  Use this skill when writing a new test suite or converting an old assert-script for dartnative_go. Covers the package:test recipe per area, DnHarness/widget_probe/FakeDevServer/UiAutomator patterns, device-gated groups, and the hard-won interpreter gotchas that decide whether a test is valid.
---

# Writing dartnative_go Tests — Recipe + Gotchas

## Recipe by area

**`test/unit/`** — plain `group`/`test` + `expect`. Temp dirs via
`setUp`/`tearDown` (fast, per-test isolation) or `setUpAll`/`tearDownAll`
(expensive shared setup, e.g. AST builds). No `dart:ui` imports — keep it
that way so these stay fast.

**`test/runner/`** — drive `DnHarness`:
```dart
final harness = DnHarness(onLog: logs.add);
final root = await harness.evaluate({'main.dart': guest});
tapButton(root, 'Save');                       // invokes onPressed
await harness.hotReload(editedFiles);          // state-preserving
await harness.hotRestart(editedFiles);         // fresh interpreter
await applyEditScript(harness, [EditStep(...)]); // scripted sequences
```
Guest code is a `Map<String, String>` of sources; the entry MUST call
`runApp(...)` or return a `Widget`, else `evaluate` throws. Assert on the
tree with `findText`/`findButtonNodes`/`dumpTree` (failure reasons should
include `dumpTree(root)`).

**`test/server/`** — `FakeDevServer` for protocol suites
(`await server.start()`, ephemeral port, `server.baseUrl`), real
`DartGoServer` only in `server_integration_test.dart`. `LiveConnection`
is the real client in both.

**Automation** — `UiAutomator(serverUrl: …)` + `SimulatedDevice(harness: …)`
for headless loops; same `UiAutomator` script drives the real app on-device.
Assert trees with `UiAutomator.expectText/expectButton/expectNoText`.

**Conversion** (old `void main() + assert` scripts): keep bodies, wrap in
`group`/`test`, `assert(x)` → `expect(x, …)` with `reason:` where the
assert had a message. Numbered `print('✓ Test N')` lines become separate
`test()`s. Shared scaffolding moves to `test/test_lab/fixtures/`.

## Gotchas (validity-critical)

1. **Bridges shadow `AutoImportParser` stubs.** `loadModule` checks
   `_hasBridgedContentForUri` BEFORE the `sources` map, so with
   `InterpreterRunner`'s full bridge surface registered, interpreted plugin
   calls hit REAL native code — the in-memory stubs never load. Consequence:
   FFI plugins throw on the host (`… is not supported on macos`) unless a
   harness `bridgeOverrides` fake is installed. Classify failures as
   `bridgeMissing` / `nativeMissing` / `paritySkew`, never "flaky".
2. **Interpreted statics are per-`execute` isolated.** A tap's write to a
   guest static/top-level is NOT visible to a later `callFunction` read.
   `callFunction` is for pure functions only. Assert taps via `onLog`
   prints, fake-host objects, or provider containers (proven in
   `runner/ui_automation_test.dart` and the prefs suite).
3. **`const` widgets canonicalize.** Identity joins (`indexElementsByWidget`)
   match `const` instances across trees; use non-const widgets to test
   negative identity cases.
4. **Snapshot scope.** `InterpreterRunner._snapshotState` preserves only
   Provider/Notifier/Controller/Container objects — plain top-levels reset
   on reload. State-preservation claims need Riverpod-style coverage.
5. **Runner + device env**: widget suites REQUIRE `dn test` (dart:ui).
   Device groups need `skip:` with the rerun command, gated on
   `bool.fromEnvironment('DN_DEVICE_TEST')`.
6. **Input triggers need their props.** `focus`/`blur` require a
   `TextField.focusNode` (else clean `no focusNode` error);
   `type` requires a `TextEditingController` (else `no controller`);
   `submit` requires `TextField.onSubmitted` and rejects Buttons with
   "use tap". On the host these throw inside SDK stubs — triggers catch
   and return the error string, so the graceful path is testable headless;
   the real path (keyboard, controller sync) only runs on device.
7. **Icons match by data, not names.** Serialized nodes carry
   `icon: {code_point, font_family?}` — `CupertinoIcons.person` has no
   usable name at runtime. Discover code points with
   `dart run tool/ui_test_run.dart … --list-trees`, then pin them in
   `expect_icon` / `TargetSpec(iconCodePoint:)`.
8. **Keys match raw values.** `key:` args and `findKeyNodes` match
   `key_value` (`ValueKey` payload, e.g. `guest_root`) or the full `key`
   string; app-shell keys (`guest_root`, the probe `GlobalKey`) are stable
   across reloads and safe to assert.
9. **Repo quirk**: `lib/src/runner/*` carries the git `assume-unchanged`
   bit (`git ls-files -v` shows `H`) — edits there are invisible to
   `git status`/commit until cleared with
   `git update-index --no-assume-unchanged`.

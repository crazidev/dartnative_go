---
name: dartnative-plugin-matrix
description: >-
  Use this skill when adding compatibility coverage for a dartnative_* native plugin (share, webview, splash, path_provider, url_launcher, supabase, …). Covers the per-plugin checklist: bridge-surface parity, host fake, headless behavior suite, UI interaction, and the device-gated real-FFI group. Template: test/plugins/shared_preferences_bridge_test.dart.
---

# Plugin Matrix — Adding a Plugin

Each supported plugin (`kSupportedNativePlugins` in
`lib/src/cli/dart_go_version.dart`) gets ONE suite:
`test/plugins/<name>_bridge_test.dart`, plus ONE fake when the plugin
needs FFI the host lacks: `test/test_lab/fakes/fake_<name>.dart`.

## Checklist (in order)

1. **Surface.** Bridge classes + full method/static-method signatures exist
   in BOTH `lib/src/interpreter/<name>_bridges.b.dart` and
   `lib/src/interpreter/ast/<name>_bridges.b.dart`; assert the AST set
   equals the source set (parity test). If a bridge file is missing, that
   IS the finding — file it as `bridgeMissing`, do not hand-write bridges.
2. **Fake (host only).** If the plugin's native calls throw on macOS,
   build `buildFake<Name>Bridge(host)` + `installFake<Name>(interpreter,
   host)` mirroring the generated `BridgedClass` shape (same class name;
   register under EVERY reachable URI: barrel + `bridgeReExports()`
   targets — re-export merges run after barrel registration and would
   otherwise restore the real class). Fake state lives in a host object so
   it is visible across executes. No fake needed for pure-Dart surfaces.
3. **Headless behavior.** Guest app exercising every method family
   (get/set/remove/clear + edge cases: missing keys, wrong types, empty
   lists), evaluated via `DnHarness(bridgeOverrides: [fake])`, asserted via
   the resolved widget tree (`findText` per outcome).
4. **UI interaction.** Guest with `Text` + `Button`s driving the plugin;
   `tapButton`, then assert through a host-visible channel (fake-host
   object, `onLog` print, provider container) — never interpreted statics
   (per-`execute` isolated).
5. **Device group (real FFI, no fake).** Same guest, NO `bridgeOverrides`,
   gated with `skip: !_isDeviceRun ? 'needs a device runtime: dn test -d
   <device-id> --dart-define=DN_DEVICE_TEST=true …' : false`, where
   `const _isDeviceRun = bool.fromEnvironment('DN_DEVICE_TEST')`.
6. **Native-limitation pin.** If the real FFI throws on host, keep one test
   documenting the boundary (skipped on device runs).

## Complexity order for the remaining plugins

`path_provider` (pure data) → `url_launcher` (canLaunch mock) →
`share` (sheet mock) → `splash` (asset resolve) → `webview` (URL load,
heaviest) → `supabase` / `social_sign_in` / `sqlite` / `keys` (no bridges
yet — surface step comes first).

## Done when

`dn test test/plugins/<name>_bridge_test.dart` is green on host AND the
device group is green under `dn test -d <id>
--dart-define=DN_DEVICE_TEST=true`.

# Fast Debug: Run From a Pre-Built Binary (No Fresh Build)

This guide starts debugging **without building from scratch**. Instead of a
full `dn run` build (~minutes), it points `dn run` at an existing native app
bundle (iOS `.app`/IPA or Android APK) via `useApplicationBinary`. `dn run`
then updates the assets inside that bundle and launches it with the debugger
attached; the latest Dart code is supplied at launch and through hot reload /
hot restart.

This is the right tool when the user wants to start debugging quickly and
native code has not changed. **Always evaluate this path before starting a
fresh build**, including on the first agent launch in a session: a prior IDE,
CI, or agent run may already have left a usable binary. Use a normal full
`dn_run` launch only when native code is out of date, the artifact is missing
or incompatible, or compatibility cannot be established safely.

---

## 1. When This applies — the Build-Skip Decision

Rebuilding is required **only when native code changed**. Dart-only changes
can always ride on the existing binary via hot reload. So before launching:

1. **Locate the candidate binary and establish its build time** (see the table
   below). Inspect an existing app bundle rather than assuming that a build
   must be performed. Use its latest relevant file modification time as
   "last build" when no build manifest/timestamp is available.
2. **Gather the native-surface modification times** newer than the binary:
   - The app root's `ios/` and `android/` trees (Podfile and lockfile, Xcode
     project/workspace, Gradle files, native sources, generated registrants,
     entitlements, and `Info.plist`).
   - All relevant workspace `pubspec.yaml`/`pubspec.lock` files and plugin
     lock/metadata files (for example `dn_plugins.lock` and
     `.dn-plugins-dependencies`) — changing package resolution can change the
     native side even when Dart imports still work.
   - Local path plugins and hosted packages with native code: resolve package
     roots from `.dart_tool/package_config.json` and check their platform
     sources/build configuration too.
   - Other `native`/`platform`/`macos`/`windows`/`linux` directories if
     present.
3. **Decide**:
   - Every relevant native-surface mtime **≤ binary build time** and the
     compatibility checks below pass → native inputs are unchanged →
     **skip the build** and launch with `useApplicationBinary` (this guide).
   - Any native-surface mtime **> binary mtime** → native changed → the
     binary is stale → a fresh build is **unavoidable** (plugins/native code
     cannot be hot-reloaded). Do a normal full `dn_run` launch instead.
   - No binary found, or dependency state changed enough that asset/kernel
     sync is unsafe → fall back to a full `dn_run` launch (which rebuilds).

### Compatibility checklist — do not rely on freshness alone

Before reusing an artifact, confirm all of the following:

- **Artifact exists and is debug:** it supports JIT/hot reload, not profile or
  release mode.
- **Platform and device class match:** the artifact is for the requested OS and
  the requested simulator/emulator or physical device. For iOS, a simulator
  `.app` is not a device `.app`/IPA; `Debug-iphoneos` must not be assumed usable
  on an iOS Simulator. For Android, check ABI and build variant/flavor.
- **App/root/config match:** it was built from this native app root and the
  expected bundle/application ID, flavor, and workspace configuration. A Dart
  example package may need to launch from its enclosing root if it has no own
  `ios/Runner` or `android` scaffold; pass the example entrypoint relative to
  that enclosing root.
- **Native inputs are fresh:** no relevant native project, plugin, dependency,
  or generated-registration inputs changed after the build.

If any item is false or cannot be verified, do a full build and report the
specific compatibility reason. Never pass a binary from another platform or
guess that a device artifact is a simulator artifact just to avoid a build.

You do not need to be perfect here: if a skip-build launch fails or prints
build/asset errors, stop the app (`dn_stop_app`) and redo the launch without
`useApplicationBinary` — that performs the full build.

**Where the debug binaries live:**

| Platform | Typical debug binary | Notes |
| :--- | :--- | :--- |
| iOS Simulator | `build/ios/iphonesimulator/Runner.app` (toolchain output may vary) | Must be built for the Simulator SDK. Verify the actual output for this project; do not substitute a `Debug-iphoneos` device bundle. |
| iOS device build | `build/ios/Debug-iphoneos/Runner.app` (toolchain output may vary) | Device-only `.app`; not interchangeable with a Simulator `.app`. |
| iOS IPA | `build/ios/ipa/*.ipa` | Device package; do not assume it can run on an iOS Simulator. |
| Android | `build/app/outputs/flutter-apk/app-debug.apk` | Flavor variants: `app-<flavor>-debug.apk` |

Prefer a binary produced in **debug** mode — hot reload needs a JIT (debug)
build. A profile/release binary boots but cannot hot reload. If the expected
artifact is not in the common location, locate existing outputs (for example,
inspect `build/ios/` for `Runner.app` bundles or `build/` for debug APKs) before
concluding that no fast path is available. Use filesystem inspection tools (or
`find` when necessary) to locate candidates; use the artifact path/build output
to verify the SDK/device class instead of inferring it from the filename alone.

---

## 2. Prepare the Dart Side (Assets & Dependencies)

1. Run `analyze_files` first, as always. Fix or, if dependencies are missing,
   call `pub` `command: "get"` and re-analyze.
2. The skip-build launch itself syncs the compiled Dart kernel and the asset
   bundle into the pre-built app before installing it — that is how "latest
   changes" reach the device with no fresh build.
3. If `pubspec.lock`/dependency state is known good (no dependency change
   since the last build, verified in step 1 of the decision above), pass
   `arguments: ["--no-pub"]` to skip the implicit `dn pub get` for a faster
   startup — matching the VS Code launch config `--no-pub`. Otherwise omit it
   and let `dn` refresh the package graph.

Do **not** run `dn_build` in this flow — that defeats the purpose.

---

## 3. Launch With the Pre-Built Binary (`dn_run`)

Before the tool call, tell the user this is a **fast launch using a compatible
prebuilt debug binary; the native build will be skipped**. Start measuring the
launch elapsed time around the awaited `dn_run` call. If the compatibility
gate failed, do not enter this section—announce the reason for a full build
and use the normal simulator workflow instead.

Call `dn_run` with the regular `root` + `device` parameters plus
`useApplicationBinary`:

```json
{
  "ServerName": "dartnative",
  "ToolName": "dn_run",
  "Arguments": {
    "root": "file:///Users/mac/Dev/projects/dartnative_go",
    "device": "<device-id-from-dn_devices>",
    "useApplicationBinary": "build/ios/iphonesimulator/Runner.app",
    "arguments": ["--no-pub"],
    "timeout": 180000
  }
}
```

Behavior and rules:

- The path must point to an **existing** APK/IPA/`.app` on disk. Relative
  paths resolve against `root`. `dn_run` fails fast with a readable error if
  the path is missing (saying what to do), instead of an opaque build error.
- `dn` skips building from scratch when the application binary is provided.
- Device type constraints per the CLI: APK for Android devices, IPA/`.app`
  for iOS devices; other device types do not support prebuilt binaries (for
  desktop targets, use a normal launch).
- Startup readiness and failure detection is identical to the normal launch
  (`ready`, `pid`, `dtdUri`/`vmServiceUri`, logs). See
  [`simulator_run_workflow.md`](./simulator_run_workflow.md) § 3.
- A cold-device install can still take a while even without a build; keep the
  default `timeout` for repeat launches and raise it (e.g. `180000`) when a
  slow device is attached.

---

## 4. Attach the Debugger & Sync the Latest Changes

Attach works exactly as in the normal flow — nothing extra to do in the
common case:

1. `dn_run` captures the app's DTD/VM service URI from startup output and
   **connects automatically** (`dtdUri`/`vmServiceUri` in the result).
2. Verify with `dtd` `listConnectedApps` if you want confirmation; manual
   fallbacks (`dtd` `connect`, `vm_service` `connect` with the VM service URI
   from `dn_app_logs`) are described in
   [`runtime_and_dtd.md`](./runtime_and_dtd.md).

Because the binary's *Dart/kernel payload can be older than your sources*,
always sync right after the app is up:

1. `hot_reload` — pushes the latest Dart code; if the app paused on entry to
   the stale code this catches it up immediately.
2. `hot_restart` — run it instead of (or after) a hot reload when
   `main()`/`initState`/global state must re-execute with the new code. This
   is the more reliable "get me on the latest code" step after a skip-build
   launch.
3. `get_runtime_errors` and `dn_app_logs` to confirm the app runs clean.

When reporting completion, use one short fast-launch summary line, include the
device name and measured launch/sync time, and say native build was **skipped**.
Put only this run's VM Service WebSocket URL in its own fenced copy box and
render its DevTools debugger URL as a Markdown link. Get both from this run's
`dn_run` output or `dn_app_logs`; follow the response format in
[`simulator_run_workflow.md`](./simulator_run_workflow.md). Do not reuse URLs
from an earlier process.

Continue the normal iterate loop from
[`simulator_run_workflow.md`](./simulator_run_workflow.md) § 5 (edit →
analyze → reload/restart → error check).

---

## 5. Common Failure Modes

| Symptom | Cause | Fix |
| :--- | :--- | :--- |
| `useApplicationBinary` path does not exist | No prior build, or wrong platform directory | Full `dn_run` launch to build; retry binary path afterwards |
| Stale-asset / missing-asset errors at startup | Binary predates resource changes | Full `dn_run` launch (rebuilds assets correctly) |
| Hot reload fails or never applies | Binary is a profile/release build | Rebuild in debug (`dn_run` without `useApplicationBinary`, or `dn_build`) |
| Launcher reports ABI/asset mismatch | Binary built for another simulator/device arch | Full `dn_run` launch for this device |
| App builds but exits right after startup | Native plugins changed since binary was built | Full `dn_run` launch; update the decision inputs next time |

---

## 6. Shutdown

As always: `dn_stop_app` with the `pid` from `dn_run`.

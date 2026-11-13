# Building, Testing & Toolchain Diagnostics

This guide covers compiling release artifacts, running test suites, and diagnosing the DartNative environment.

---

## 1. Overview

DartNative projects use `dn build` to produce target platform artifacts and `dn test` to run automated tests.

---

## 2. Tools

### `dn_build`
- **Purpose**: Compiles a release artifact for the specified platform target.
- **Supported targets**: `apk`, `appbundle`, `aar`, `ios`, `ipa`, `macos`, `linux`, `windows`, `web`.
- **Parameters**:
  - `target` (required): Target build platform (e.g. `apk`, `macos`, `ios`).
  - `roots` (optional): Project root URI.
  - `args` (optional): Extra CLI arguments forwarded to `dn build`.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "dn_build",
    "Arguments": {
      "target": "macos"
    }
  }
  ```

---

### `run_tests`
- **Purpose**: Runs `dn test` with `package:test` arguments across the project or for specific test files.
- **Parameters**:
  - `roots` (optional): Project roots or file paths to test.
  - `args` (optional): Extra test arguments (e.g. `--name`, `--plain-name`).
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "run_tests",
    "Arguments": {}
  }
  ```

---

### `dn_clean`
- **Purpose**: Cleans build caches, ephemeral artifacts, and generated files (`dn clean`).
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "dn_clean",
    "Arguments": {}
  }
  ```

---

### `dn_doctor`
- **Purpose**: Diagnoses the DartNative toolchain, SDK installation, dependencies, and environment configuration.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "dn_doctor",
    "Arguments": {}
  }
  ```

---

### Build Feedback, Timing & Runtime URLs

Before a potentially expensive **app launch** with `dn_run`, tell the user
whether the agent will do a full native build or reuse a compatible prebuilt
debug binary and skip the build. The fast-path compatibility gate and response
format are mandatory; see
[`simulator_run_workflow.md`](./simulator_run_workflow.md) and
[`fast_run_without_build.md`](./fast_run_without_build.md).

For `dn_build`, state the target before starting and report the build result and
duration afterward. `dn_build` produces an artifact but does not launch a
debuggable app, so a VM Service URL or debugger/DevTools URL is not available;
explicitly label those fields **not applicable** rather than presenting a URL
from another or stale app session.

For a successful `dn_run`, retrieve `dn_app_logs` if needed and report the
exact VM Service URL and DartNative debugger/DevTools URL printed for that
process. Keep full-vs-fast mode to one simple line; include the device name and
total elapsed time. Put only the VM Service WebSocket URL in its own fenced
code block (copy box), and render the debugger URL as a Markdown link. Include:

- Mode: full native build, or fast prebuilt-binary launch (build skipped).
- Build duration from Xcode/`dn` output when present, plus total call elapsed
  time to `ready: true`. For the fast path, say native build was skipped and
  provide launch/sync elapsed time instead.
- Any errors detected and the recovery attempted. Claim an error was fixed
  only after the subsequent build/startup/runtime logs confirm it.
- For `dn_run`, include whether the IDE debugger attach succeeded, was skipped,
  or failed, using the `ideAttach` result from the launch output.

For iOS CocoaPods/linker failures or runtime plugin-symbol warnings, follow the
`pod install` recovery sequence in
[`simulator_run_workflow.md`](./simulator_run_workflow.md). After pod changes,
do not reuse a prebuilt binary; perform a full `dn_run` and verify the original
error is gone.

---

### `create_project`
- **Purpose**: Creates a new DartNative or Dart project using `dn create`.
- **Parameters**:
  - `projectType` (required): `"dartnative"` or `"dart"`.
  - `directory` (required): Target directory name.
  - `template` (optional): Template name.

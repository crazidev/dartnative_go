# Device Management & Application Execution

This guide covers discovering devices, launching DartNative applications, reading logs, and stopping background app processes.

---

## 1. Overview

DartNative projects run on devices and emulators using `dn run`. The `dartnative` MCP server manages running processes asynchronously and assigns process IDs (`pid`) to track logs and stop running apps.

---

## 2. Tools

### `dn_devices`
- **Purpose**: Lists all available physical devices, emulators, simulators, and desktop targets.
- **Parameters**: None.
- **Usage note**: The device **IDs** in this output are exactly what the
  `device` parameter of `dn_run` and `dn_install` require. Pick the iOS
  simulator or Android emulator ID for the normal fast-iteration path.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "dn_devices",
    "Arguments": {}
  }
  ```

---

### `dn_run`
- **Purpose**: Launches the application on a target device using `dn run`.
- **Behavior**: Runs asynchronously, keeps the process alive, and returns `pid`,
  `root`, `ready`, `exited`, the startup `logs`, and — when the app reports
  them — `dtdUri` and/or `vmServiceUri`. The captured DTD/VM service URIs are
  connected **automatically**, so hot reload and other app tools work right
  after launch without extra setup.
- **Parameters**:
  - `root` (**required**): Project root as a `file:` URI.
  - `device` (**required**): The device ID of the target from `dn_devices`.
    This must be a concrete device ID (e.g. an iOS simulator or Android
    emulator ID from the device list), not a platform name such as `ios`.
  - `target` (optional): Path to the entrypoint file (e.g., `lib/main.dart`).
  - `useApplicationBinary` (optional): Path to a pre-built application binary
    to run **without building from scratch** (fast debug path). Android: an
    APK, e.g. `build/app/outputs/flutter-apk/app-debug.apk`; iOS: an IPA or
    `.app` bundle, e.g. `build/ios/Debug-iphoneos/Runner.app`. Relative paths
    resolve against `root`. `dn_run` verifies the path exists before
    launching. Use only when native code has not changed since the binary was
    built; the asset bundle is updated at launch and the latest Dart code is
    applied via hot reload. The binary must be a debug build for hot reload.
  - `arguments` (optional): Extra `dn run` flags, e.g. `["--flavor=dev"]`,
    `"[--dart-define=KEY=value]"`, `["--no-pub"]`. Device/entrypoint selection
    flags (`-d`, `-t`, `--machine`, `--pid-file`, `--vmservice-out-file`,
    `--use-application-binary`) are rejected — use `device`/`target`/
    `useApplicationBinary` instead.
  - `timeout` (optional): Milliseconds to wait for startup readiness.
    Defaults to `90000`; raise it for a first build or a cold simulator
    (e.g. `300000`).
- **Readiness & failure signals**: readiness is reported when output contains
  `Dart VM Service`, `Syncing files to device`, or `is available at:`;
  `Could not build`, `Failed to install`, `No devices found`, and
  `Error launching application` end the wait with an error. On a timeout the
  process is still running — poll `dn_app_logs` instead of relaunching.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "dn_run",
    "Arguments": {
      "root": "file:///path/to/project",
      "device": "<device-id-from-dn_devices>"
    }
  }
  ```
- *Full end-to-end launch workflow (including debugger attach verification)*:
  See [`simulator_run_workflow.md`](./simulator_run_workflow.md).
- *Skip-build fast path*: See [`fast_run_without_build.md`](./fast_run_without_build.md).

---

### `dn_app_logs`
- **Purpose**: Reads recent stdout/stderr lines from an application started by `dn_run`.
- **Parameters**:
  - `pid` (required): The integer process ID returned by `dn_run`.
  - `lines` (optional): Number of recent lines to retrieve.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "dn_app_logs",
    "Arguments": {
      "pid": 12345,
      "lines": 50
    }
  }
  ```

---

### `dn_stop_app`
- **Purpose**: Stops a running application process previously launched with `dn_run`.
- **Rule**: Always stop running applications when testing or debugging completes so system and device resources are freed.
- **Parameters**:
  - `pid` (required): The integer process ID of the app to stop.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "dn_stop_app",
    "Arguments": {
      "pid": 12345
    }
  }
  ```

---

### `dn_install`
- **Purpose**: Installs the compiled application package directly onto a target device without starting a live session.
- **Parameters**:
  - `device` (optional): Target device ID from `dn_devices`.
  - `roots` (optional): Project root URI.

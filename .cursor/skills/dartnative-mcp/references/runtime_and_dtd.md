# Runtime Diagnostics & Dart Tooling Daemon (DTD)

This guide covers discovering and connecting to the Dart Tooling Daemon (DTD), triggering hot reload and hot restart, taking screenshots, and capturing runtime errors.

---

## 1. Overview

Tools that interact with a running application (`hot_reload`, `hot_restart`, `get_runtime_errors`) require an active connection to the Dart Tooling Daemon (DTD) or directly to the app's VM service.

**Automatic attach**: apps launched through `dn_run` are connected
automatically — the server returns the VM Service URI and connects it for MCP
runtime tools. It also reads `.dart_tool/dartnative_dtd.json` and asks the IDE
to attach its debugger through `Editor.attachToVmService`. The `dn_run` result
contains the VM Service URI and an `ideAttach` status. If the descriptor is
missing or stale, the app can still be controlled through the MCP VM Service;
report that the IDE attach was skipped/failed rather than treating the app
launch as failed. Never read, log, or copy the descriptor capability manually.

For an app launched outside this server, use `attach_ide_debugger` (below).
The DTD can supply a VM Service URI only for apps it already knows; it cannot
infer the URI of an unregistered process. In that case provide the URI from the
app's VM Service startup output.

---

## 2. Tools

### `dtd`
- **Purpose**: Manages connections to the Dart Tooling Daemon.
- **Commands**:
  - `listDtdUris`: Discovers active DTD WebSocket URIs.
  - `connect`: Connects the MCP server to a chosen DTD URI.
  - `listConnectedApps`: Lists applications currently connected to the DTD.
  - `disconnect`: Disconnects from a DTD instance (omit `uri` when only one is connected).
- **How `listDtdUris` discovers instances**:
  1. **DTD pid files** (preferred): newer Dart SDKs write a JSON pid file per
     running DTD instance into `<dart data home>/dtd` (for example
     `~/Library/Application Support/Dart/dtd/<pid>` on macOS). The server reads
     these, drops instances that are no longer reachable, and prints them in
     the same format as `dart tooling-daemon --list`.
  2. **`dart tooling-daemon --list` fallback**: used when no pid files are
     found, for SDKs that still support the flag.
  3. **No discovery available**: some Dart SDKs removed the `--list` flag and
     don't write pid files. `listDtdUris` then returns guidance (not an error)
     pointing at the `vm_service` fallback below.
- **Workflow**:
  1. Find URI:
     ```json
     {
       "ServerName": "dartnative",
       "ToolName": "dtd",
       "Arguments": {
         "command": "listDtdUris"
       }
     }
     ```
  2. Connect (prefer an instance whose working directory is your project; instances with a home-directory working dir usually belong to an IDE):
     ```json
     {
       "ServerName": "dartnative",
       "ToolName": "dtd",
       "Arguments": {
         "command": "connect",
         "uri": "ws://127.0.0.1:58585/token="
       }
     }
     ```
  3. (Optional) Verify apps:
     ```json
     {
       "ServerName": "dartnative",
       "ToolName": "dtd",
       "Arguments": {
         "command": "listConnectedApps"
       }
      }
      ```

---

### `attach_ide_debugger`

- **Purpose**: Reads the project's short-lived
  `.dart_tool/dartnative_dtd.json` descriptor and asks its IDE to attach to a
  VM Service. The MCP server handles the DTD request; do not use a Python
  helper or manually extract the descriptor capability.
- **Automatic path**: `dn_run` calls the same attach flow after the app becomes
  ready and includes the URI and attach status in its result.
- **Parameters**:
  - `root` (required): Project root containing the IDE descriptor.
  - `vmServiceUri` (optional): URI printed by the app launch. If omitted, the
    tool uses a URI only when the IDE DTD reports exactly one registered VM
    service. With multiple services, pass the intended URI. With no registered
    services, supply the URI from the app's startup output.
  - `name` (optional): Display name for the IDE debug session.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "attach_ide_debugger",
    "Arguments": {
      "root": "file:///path/to/project",
      "vmServiceUri": "http://127.0.0.1:8181/token=/",
      "name": "My app"
    }
  }
  ```
- The tool validates that DTD and VM Service endpoints are loopback. The
  descriptor capability and VM Service URI are credentials; do not log them.

---

### `hot_reload`
- **Purpose**: Applies code modifications to the running application without losing application state.
- **When to use**: Changes to widget build methods, styling, layout, or functions inside UI widgets.
- **Parameters**:
  - `appUri` (optional): VM service URI of the connected app. **Required when
    multiple apps are connected** (get URIs from `dtd` `listConnectedApps`).
  - `clearRuntimeErrors` (optional, bool): Clear stale errors before reloading.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "hot_reload",
    "Arguments": {}
  }
  ```

---

### `hot_restart`
- **Purpose**: Restarts the running application and re-initializes all state, rerun `main()`.
- **When to use**: Changes to `initState`, `dispose`, global/static variables, `const` constructors, or app lifecycle setup.
- **Parameters**:
  - `appUri` (optional): VM service URI of the connected app. **Required when
    multiple apps are connected.**
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "hot_restart",
    "Arguments": {}
  }
  ```

---

### `dn_screenshot`
- **Purpose**: Takes a screenshot with `dn screenshot`.
- **When to use**: You need to see the running app or the whole device screen.
- **Screenshot types**:
  - `device` (default): Captures the entire screen with the device's native
    screenshot support. Pass `device` to select a device when several are
    connected; otherwise `dn screenshot` uses the only connected device.
    Returns the screenshot as PNG image content.
  - `skia`: Captures the app's rendered content through the connected
    debugger. Requires an active app connection (DTD or VM service); the VM
    service URI is resolved automatically. If several apps are connected,
    pass `appUri`. The result is a Skia picture (`.skp`) file; its path is
    returned.
- **Parameters**:
  - `type` (optional): `device` or `skia` (default `device`).
  - `appUri` (optional): VM service URI, used for `skia` screenshots.
  - `device` (optional): Device ID from `dn_devices`, used for `device`
    screenshots.
  - `out` (optional): Output path. Defaults to a unique file in the system
    temp directory.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "dn_screenshot",
    "Arguments": {
      "type": "skia"
    }
  }
  ```

---

### `get_runtime_errors`
- **Purpose**: Retrieves recent runtime exceptions, stack traces, and unhandled errors from the running app.
- **Parameters**:
  - `appUri` (optional): Connected application URI. **Required when multiple
    apps are connected.**
  - `clearRuntimeErrors` (optional, bool): Clear the errors after reading them.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "get_runtime_errors",
    "Arguments": {}
  }
  ```

---

### `vm_service`
- **Purpose**: Direct VM service connection fallback. Use when DTD discovery
  is unavailable or no DTD instance has the app — connect straight to the VM
  service URI printed by `dn run` (`ws://127.0.0.1:PORT/TOKEN=/ws`).
- **Commands**:
  - `connect`: Attach to an app by its VM service URI (`appUri`, required).
  - `disconnect`: Detach from an app (`appUri`, required).
  - `callMethod`: Invoke a VM service method directly (`method` required; optional `isolateId`, `arguments`).
  - `listRegisteredServices`: List services registered by other VM service clients.
- **After connecting**, all app tools (`hot_reload`, `hot_restart`,
  `get_runtime_errors`) work the same as with a DTD connection.
- **Example Call**:
  ```json
  {
    "ServerName": "dartnative",
    "ToolName": "vm_service",
    "Arguments": {
      "command": "connect",
      "appUri": "ws://127.0.0.1:54321/TOKEN=/ws"
    }
  }
  ```

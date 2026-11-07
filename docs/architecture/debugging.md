# Debugging

Breakpoints, stepping state, and IDE/agent integration.

## Files

| File | Role |
| :--- | :--- |
| `interpreter/debug_controller.dart` | `debugger()`/line breakpoints; pause and resume in the interpreter. |
| `lib/src/dap/dap_server.dart`, `protocol.dart`, `variable_store.dart` | DAP server (stdio/TCP) bridging VS Code to the dev server (`dart_go dap`). |
| `lib/src/widgets/breakpoint_overlay.dart` | On-device pause banner/barrier. |
| `lib/src/widgets/guest_error_banner.dart`, `interpreter_error_view.dart` | Guest failure surfaces on the device. |

## Flow

```text
IDE <-DAP-> dap_server <-WS /ws-> dev server <-WS /ws-> device
breakpoint hit: device -> breakpoint_hit -> dev server -> DAP `stopped`
resume: DAP continue -> dev server -> device
```

Known issue: the DAP hot reload/restart handlers first POST `/reload` and
`/restart`, which `server.dart` does not route; they succeed only through the
WebSocket fallback (`origin: test`). Either add the routes or drop the POST.

## Status

The standalone debug bridge and MCP server were removed; debug state now lives
in the DAP server plus the shared `debug_controller`. IDE integration is
`dart_go dap` (DAP over stdio/TCP).

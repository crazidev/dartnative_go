# Debugging

Breakpoints, stepping state, and IDE/agent integration.

## Files

| File | Role |
| :--- | :--- |
| `interpreter/debug_controller.dart` | `debugger()`/line breakpoints; pause and resume in the interpreter. |
| `lib/src/dap/dap_server.dart`, `protocol.dart`, `variable_store.dart` | DAP server (stdio/TCP) bridging VS Code to the dev server (`dart_go dap`). |
| `lib/src/debug/debug_bridge.dart` | Shared debug state (logs, stack frames, events) for DAP and MCP. |
| `lib/src/mcp/mcp_server.dart` | MCP JSON-RPC/SSE server exposing debug and reload tools. |
| `lib/src/widgets/breakpoint_overlay.dart` | On-device pause banner/barrier. |

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

`debug_bridge.dart` and `mcp_server.dart` are not imported by the CLI or the
DAP server today (only their own tests); wiring them into `dart_go start` is
open work.

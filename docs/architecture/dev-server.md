# Dev server and bundling

`dart_go start` serves the guest project to devices and pushes reloads.

## Files

| File | Role |
| :--- | :--- |
| `lib/src/cli/server/server.dart` | `DartGoServer`: lifecycle, file watchers, HTTP routing, manifest assembly. |
| `lib/src/cli/server/dev_socket_hub.dart` | WebSocket registry, reload/breakpoint broadcast, UI-automation relay. |
| `lib/src/cli/server/http_support.dart` | Shared response helpers (text, JSON, bytes, ETag/304). |
| `lib/src/cli/server/terminal_ui.dart` | Banner and interactive stdin keys (`h`/`r`/`v`/`q`/`c`). |
| `lib/src/cli/packaging/ast_builder.dart` | Incremental analyzer -> `guest.ast` build; delta patches; content fingerprints; `AstBuildWorker` isolate. |
| `lib/src/cli/packaging/safe_ast_converter.dart` | Analyzer -> serializable AST with shims for unmapped node types. |
| `lib/src/cli/packaging/dep_packager.dart` | Per-package ZIPs from `.dart_tool/package_config.json`. |
| `lib/src/cli/server/broadcaster.dart` | Port-range binding, LAN IP lookup, UDP discovery beacons. |

## Request surface

| Path | Purpose |
| :--- | :--- |
| `/manifest.json`, `/health`, `/dart_go/discover` | Project metadata and discovery. |
| `/guest.ast`, `/guest.ast.patch` | Full AST bundle and delta (ETag/304 aware). Patches carry lineage: `?base=` must match the generation the delta was computed against, else 404 and the client full-fetches; `X-Ast-Bundle` tracks generations both ways. |
| `/user-code.zip`, `/user-code-hash`, `/bundle.json`, `/deps.json`, `/pkg/*` | Source-mode payloads and dependency ZIPs. |
| `/assets/*`, `/asset`, `/assets.json`, icon/splash | Project assets. |
| `/server-components/*`, `/client-module-index.json` | See server-components.md. |
| `/ws` | Reload, verbose sync, breakpoints, UI-automation relay. |

## Flow

```text
file change -> debounce (120 ms) -> batch
  rebuildAst ? AstBuildWorker.build -> guest.ast (+ patch) : skip
  -> broadcast reload{files} over /ws -> devices fetch patch or bundle
```

## Invariants

- A failed AST build keeps the previous `guest.ast` and broadcasts nothing.
- Only one rebuild runs at a time; changes arriving meanwhile are queued.
- Bundle writes under `.dart_tool/bundles/` (and the legacy `assets/bundles/`)
  are ignored by the asset watcher (the code change already triggered the
  reload).
- Only `origin: test` reload/restart messages are relayed from sockets.
- `user-code.zip` is byte-stable for unchanged sources: entries are sorted and
  timestamps pinned, so `userCodeHash` only changes when the code does.

## Known debt

`server.dart` still owns the whole HTTP routing table as one `if`/`else`
chain; a router with per-route handlers is the natural next split. The
watcher/rebuild scheduler and stdin handler have already moved out (to
`AstBuildWorker` and `terminal_ui.dart`).

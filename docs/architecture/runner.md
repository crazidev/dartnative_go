# Runner (device side)

Downloads guest code, evaluates it, and keeps state across reloads.

## Files

| File | Role |
| :--- | :--- |
| `bundle_loader.dart` | Fetches manifest/bundles/deps; in-memory cache across reloads. |
| `ast_bundle_codec.dart` | Decodes `/guest.ast` bytes (ZIP, gzip, or JSON). |
| `ast_interpreter_runner.dart` | AST engine (default): one persistent core runner, generations. |
| `interpreter_runner.dart` | Source engine (analyzer-based, legacy). |
| `runtime_mode.dart` | `RuntimeMode { source, ast }`. |
| `live_connection.dart` | WebSocket client: reload, verbose sync, device logs, probes. |
| `app_cache.dart`, `dep_cache.dart` | Persistent offline caches for bundles and packages. |
| `native_bottomsheet_manager.dart` | Rebinds bottom sheets (own reconciler) on reload. |
| `logger.dart` | `DartGoLogger`: info/warn/error always; debug/bench when verbose. |

## Flow

```text
LiveConnection(reload) -> BundleLoader (patch with ?base= lineage, or full bundle)
  -> AstInterpreterRunner.evaluate as new generation
  -> WidgetGenerationTracker marks changed classes -> remount only those
  -> pushed routes + sheets rebind via loaded-module lookup
```

## Invariants

- A reload that throws keeps the mounted tree; only an initial load shows the
  error screen.
- The core runner, bridges, and stdlib parent are built once; only restart,
  mode switch, or unmount tears them down.
- Overlapping reloads are ordered by monotonic sequence tokens.
- A patch applies only to its recorded base; on mismatch the client takes
  the full bundle instead of building a franken-bundle.
- Errors always reach the CLI (trimmed stack; full under `-v`).

Reload internals (declaration cells, module reuse, transactions): root
[ARCHITECTURE.md](../../ARCHITECTURE.md) section 4.3.

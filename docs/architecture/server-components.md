# Server components

Widgets annotated `@ServerComponent`/`@Server` are bundled separately and
fetched on demand.

## Files

| File | Role |
| :--- | :--- |
| `lib/server.dart`, `lib/src/server/server_annotation.dart` | Guest-facing annotations. |
| `lib/server_component.dart` | Guest-facing `ServerComponentView`. |
| `lib/src/cli/server_annotation_scanner.dart` | Finds annotated classes in parsed modules. |
| `lib/src/cli/server_annotation_source.dart` | Annotation library source for source mode. |
| `lib/src/cli/client_module_index.dart` | Module URIs already shipped with the app. |
| `lib/src/cli/server_component_bundler.dart` | Per-component delta bundles (client modules subtracted). |
| `lib/src/widgets/server_component_{view,loader}.dart` | Mounting and imperative loading on device. |
| `interpreter/ast/server_component_bridge.dart`, `interpreter/server_component_source_bridge.dart` | Expose the host widget to each engine. |

## Flow

```text
build: scan annotations -> index client modules -> delta bundle per component
serve: /server-components/manifest.json, /client-module-index.json
device: ServerComponentView -> fetch bundle -> resolve shared modules from
        the running interpreter -> instantiate -> wrap as native widget
```

## Invariants

- The bridged `server_component.dart` library is skipped by the bundler; the
  bridge supplies it at runtime.
- A component bundle contains only code unique to it.
- Props are passed as named constructor arguments.

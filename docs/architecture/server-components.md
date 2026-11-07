# Server components

Widgets annotated `@ServerComponent`/`@Server` are bundled separately and
fetched on demand.

## Files

| File | Role |
| :--- | :--- |
| `lib/server.dart`, `lib/src/server/server_annotation.dart` | Guest-facing annotations. |
| `lib/server_component.dart` | Guest-facing `ServerComponentView`. |
| `lib/src/cli/server_components/server_annotation_scanner.dart` | Finds annotated classes in parsed modules. |
| `lib/src/cli/server_components/server_annotation_source.dart` | Annotation library source, injected into builds so guests need no dependency. |
| `lib/src/cli/server_components/client_module_index.dart` | Module URIs already shipped with the app. |
| `lib/src/cli/server_components/server_component_bundler.dart` | Per-component delta bundles (client modules subtracted). |
| `lib/src/widgets/server_component_{view,loader}.dart` | Mounting and imperative loading on device. |
| `lib/src/interpreter/ast/server_component_bridge.dart`, `lib/src/interpreter/server_component_source_bridge.dart` | Expose the host widget to each engine. |
| `tool/export_server_components.dart` | CDN export: rebuilds, then rewrites the manifest with absolute URLs. |

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
- A component bundle contains only code unique to it. The entry module is the
  one exception: it is always included so `AstBundle.entryPointUri` stays
  valid, and re-declaration is idempotent in the declaration registry.
- Props are passed as named constructor arguments.
- A component module must be reachable from the guest entrypoint for the
  bundler to see the annotation (v1 discovery). Server-only modules that are
  *not* reachable are still resolved from disk when a delta needs them.

## Status

The build pipeline, dev-server endpoints, client view/loader, both engine
bridges and the headless harness are implemented and covered by
`test/server_component/` plus `test/server/server_components_endpoints_test.dart`.

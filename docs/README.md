# DartNative Go Documentation

Welcome to the DartNative Go documentation. DartNative Go is an on-device
dynamic client runtime for DartNative apps (think *Expo Go* for React Native):
write multi-file Dart apps and hot-reload them on a real device over Wi-Fi in
under 50 ms — no native recompilation.

## Guides

| Document | What it covers |
| :--- | :--- |
| [Getting Started](getting_started.md) | Install the CLI, start the dev server, connect the app, make your first hot reload. |
| [CLI Reference](cli.md) | Every `dart_go` command, flag, and interactive key. |
| [Architecture](architecture.md) | A plain-language map of how the pieces fit together. |
| [Architecture by feature](architecture/README.md) | Per-feature ownership, flows, and invariants. |
| [Dev Server & Protocol](dev_server.md) | HTTP endpoints, WebSocket messages, discovery beacons, dependency packaging. |
| [Runtime Modes](runtime_modes.md) | AST mode vs Source mode — what they are and when to use which. |
| [Hot Reload](hot_reload.md) | How state survives a reload: declaration cells, generations, module reuse. |
| [Testing](testing.md) | The test lab layout, how to run suites, and the UI automation protocol. |
| [Tools & Code Generation](tools.md) | Bridge generation, AST bundling, app assets, theme tokens. |
| [Troubleshooting](troubleshooting.md) | Common errors and how to fix them. |

## Other key documents

- [Root README](../README.md) — project overview and quick start.
- [ARCHITECTURE.md](../ARCHITECTURE.md) — the exhaustive deep-dive (bridge
  internals, widget proxies, reload pipeline internals).
- [example/README.md](../example/README.md) — the bundled example guest app.

## The 30-second version

```sh
# 1. Install the CLI once
dart run tool/install_global.dart

# 2. Run the DartNative Go shell app on your device
dn pub get
dn run -d <device-id>

# 3. In a second terminal, serve your guest app
cd example/            # or any DartNative project
dart_go start

# 4. Edit example/lib/main.dart, save — the device reloads in <50 ms
```

See [Getting Started](getting_started.md) for the full walkthrough.

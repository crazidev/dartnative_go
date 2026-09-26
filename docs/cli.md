# CLI Reference

`dart_go` is the universal command-line tool for DartNative Go development.
It starts the dev server, validates projects against the runtime's plugin
matrix, and reports versions.

Install it globally once:

```sh
dart run tool/install_global.dart
```

Then run `dart_go <command>` from anywhere. Without a global install, use
`dart run bin/dart_go.dart <command>` from this repository instead.

---

## `dart_go start`

Starts the live dev server: HTTP bundle serving, WebSocket hot reload, UDP
discovery beacon, and a terminal QR code. This is the default command, so
`dart_go` alone is equivalent to `dart_go start`.

```sh
dart_go start [options] [project-directory]
```

### Options

| Flag | Default | Description |
| :--- | :--- | :--- |
| `-p, --port=<int>` | `8088` | Base port to listen on. The server scans upward if occupied. |
| `--port-range=<min-max>` | `8088-8098` | Range of ports to scan and broadcast across. |
| `--project=<path>` | current directory | The DartNative project to serve. A positional directory argument also works. |
| `--host=<ip>` | auto-detected | Custom host IP/interface to advertise to devices. Use when auto-detection picks the wrong network interface (VPNs, multiple NICs). |
| `--rebuild-ast` | **on** | Rebuild `assets/bundles/guest.ast` on every Dart change (AST hot reload). Unchanged sources skip the analyzer via content fingerprinting. |
| `--no-rebuild-ast` | — | Disable AST rebuild. Use only for source-mode testing. |
| `--no-broadcast` | broadcast on | Disable the UDP discovery beacon. Devices must connect by QR code or manual URL. |
| `--no-qrcode` | QR on | Disable terminal QR code rendering. |
| `-v, --verbose` | off | Verbose benchmark logs and diagnostic traces. |

### Examples

```sh
dart_go start                                  # serve current directory
dart_go start --project=/path/to/my_app        # serve another project
dart_go start -p 8090                          # custom base port
dart_go start --host=192.168.1.20              # advertise a specific interface
dart_go start -v                               # verbose telemetry
dart_go start --no-rebuild-ast                 # source-mode development
```

### Interactive keys

While the server runs, type into its terminal:

| Key | Action |
| :--- | :--- |
| `r` | Trigger a manual hot reload on all connected devices |
| `v` | Toggle verbose mode (bi-directional: also flips the in-app DevTool switch) |
| `q` | Reprint the connection QR code |
| `c` | Clear the terminal |
| `h` | Show help |
| `Ctrl+C` | Graceful shutdown |

---

## `dart_go doctor`

Inspects a project for DartNative Go compatibility **before** you try to run
it. Two reports:

1. **Plugin validation** — every dependency in `pubspec.yaml` is checked
   against the native plugin versions compiled into this runtime. Mismatches
   print the supported constraint so you can fix your `pubspec.yaml`.
2. **Asset detection** — finds app icons and `dartnative_splash`
   configuration so the server can serve `/assets/icon.png`,
   `/assets/splash.png`, and a correct `/manifest.json`.

```sh
dart_go doctor                       # current directory
dart_go doctor --project=/path/to/app
```

---

## `dart_go version`

Prints the CLI version, the matching mobile runtime version, and the full
compatibility matrix of native plugins compiled into DartNative Go
(`dartnative`, `dartnative_share`, `dartnative_webview`, `riverpod_kit`, …)
with their supported version constraints. Core plugins are tagged `[core]`.

Aliases: `dart_go --version`, `dart_go -v` (only when passed alone).

---

## `dart_go help`

Prints usage. Also triggered by `dart_go -h` / `dart_go --help`.

---

## Exit behavior

- Unknown commands print help and exit with code `1`.
- `SIGINT`/`SIGTERM` (Ctrl+C) stop the server gracefully, closing WebSocket
  connections and the UDP beacon.

## Environment notes

- The server binds the first free port in the configured range and broadcasts
  all candidate ports, so multiple dev servers can coexist on one machine.
- Device discovery uses UDP broadcast on the LAN. If your network blocks
  broadcast (many corporate/guest Wi-Fi networks do), use the QR code or
  manual URL entry in the app.

# CLI Reference

`dngo` is the universal command-line tool for DartNative Go development.
It starts the dev server, validates projects against the runtime's plugin
matrix, and reports versions.

Install it globally once:

```sh
dart run tool/install_global.dart
```

Then run `dngo <command>` from anywhere. Without a global install, use
`dart run bin/dngo.dart <command>` from this repository instead.

---

## `dngo open`

Hands a project to the app through a `dartnativego://` deep link, so it opens
without scanning for a server or typing a URL.

```sh
dngo open --url=<host:port> [--name=<app>] [--device] [--qr]
dngo open dartnativego://open?url=…
```

### Options

| Flag | Default | Description |
| :--- | :--- | :--- |
| `--url=<host:port>` | — | Dev server address to open. A bare `host:port` is normalized to `http://`. |
| `--name=<app>` | — | App name shown on the splash while the project loads. |
| `--device` | off | Deliver the link with `xcrun simctl openurl booted` (iOS simulator) or `adb shell am start` (emulator/physical device). |
| `--qr` | off | Render the link as a terminal QR code for a physical device. |

The link is always printed, so a device without tooling can still be opened by
tapping it. `dngo start` prints the same link for the server it just bound.

### Link format

```text
dartnativego://open?url=http%3A%2F%2F192.168.1.10%3A8088&name=My%20App
dartnativego://open?url=192.168.1.10:8088      # bare address is normalized
dartnativego://192.168.1.10:8088               # authority form
```

Parsing lives in `lib/src/client/deep_link.dart` (`DartGoDeepLink.build` /
`tryParse`). Unknown schemes, non-`http(s)` targets and links without a target
are ignored, so the app never opens something it cannot serve.

### Platform setup

The scheme is registered in `ios/Runner/Info.plist` (`CFBundleURLTypes`) and
`android/app/src/main/AndroidManifest.xml` (a `VIEW` intent filter, with
`launchMode="singleTop"` so a warm link reaches `onNewIntent`). Incoming links
are delivered by the `app_links_kit` plugin — it hooks DartNative's scene
delegate and activity intents itself, so no Swift/Kotlin code is needed.

### Examples

```sh
dngo open --url=192.168.1.10:8088 --device     # open on a simulator
dngo open --url=192.168.1.10:8088 --qr         # scan from a phone
dngo open dartnativego://open?url=10.0.0.5%3A8088
```

---

## `dngo start`

Starts the live dev server: HTTP bundle serving, WebSocket hot reload, UDP
discovery beacon, and a terminal QR code. This is the default command, so
`dngo` alone is equivalent to `dngo start`.

```sh
dngo start [options] [project-directory]
```

### Options

| Flag | Default | Description |
| :--- | :--- | :--- |
| `-p, --port=<int>` | `8088` | Base port to listen on. The server scans upward if occupied. |
| `--port-range=<min-max>` | `8088-8098` | Range of ports to scan and broadcast across. |
| `--project=<path>` | current directory | The DartNative project to serve. A positional directory argument also works. |
| `--host=<ip>` | auto-detected | Custom host IP/interface to advertise to devices. Use when auto-detection picks the wrong network interface (VPNs, multiple NICs). |
| `--rebuild-ast` | **on** | Rebuild `.dart_tool/bundles/guest.ast` on every Dart change (AST hot reload). Unchanged sources skip the analyzer via content fingerprinting. |
| `--no-rebuild-ast` | — | Disable AST rebuild. Use only for source-mode testing. |
| `--no-broadcast` | broadcast on | Disable the UDP discovery beacon. Devices must connect by QR code or manual URL. |
| `--no-qrcode` | QR on | Disable terminal QR code rendering. |
| `-v, --verbose` | off | Verbose benchmark logs and diagnostic traces. |

### Examples

```sh
dngo start                                  # serve current directory
dngo start --project=/path/to/my_app        # serve another project
dngo start -p 8090                          # custom base port
dngo start --host=192.168.1.20              # advertise a specific interface
dngo start -v                               # verbose telemetry
dngo start --no-rebuild-ast                 # source-mode development
```

### Interactive keys

While the server runs, type into its terminal:

| Key | Action |
| :--- | :--- |
| `r` | Trigger a manual hot reload on all connected devices (state preserved) |
| `R` | Trigger a hot restart: drop interpreter state and re-evaluate the current bundle from scratch |
| `v` | Toggle verbose mode (bi-directional: also flips the in-app DevTool switch) |
| `q` | Reprint the connection QR code |
| `c` | Clear the terminal |
| `h` | Show help |
| `Ctrl+C` | Graceful shutdown |

---

## `dngo doctor`

Inspects a project for DartNative Go compatibility **before** you try to run
it. Two reports:

1. **Plugin validation** — every dependency in `pubspec.yaml` is checked
   against the native plugin versions compiled into this runtime. Mismatches
   print the supported constraint so you can fix your `pubspec.yaml`.
2. **Asset detection** — finds app icons and `dartnative_splash`
   configuration so the server can serve `/assets/icon.png`,
   `/assets/splash.png`, and a correct `/manifest.json`.

```sh
dngo doctor                       # current directory
dngo doctor --project=/path/to/app
```

---

## `dngo version`

Prints the CLI version, the matching mobile runtime version, and the full
compatibility matrix of native plugins compiled into DartNative Go
(`dartnative`, `dartnative_share`, `dartnative_webview`, `riverpod_kit`, …)
with their supported version constraints. Core plugins are tagged `[core]`.

Aliases: `dngo --version`, `dngo -v` (only when passed alone).

---

## `dngo help`

Prints usage. Also triggered by `dngo -h` / `dngo --help`.

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

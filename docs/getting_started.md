# Getting Started

This guide takes you from a fresh checkout to hot-reloading your own Dart code
on a real device. Total time: ~10 minutes.

## What you're building

Two processes work together:

1. **DartNative Go app** — a native iOS/Android shell (this repo) installed on
   your device once. It contains a Dart interpreter and all native bridges.
2. **Dev server** (`dart_go start`) — runs on your computer, watches your
   project, and streams code to the app over Wi-Fi.

You edit Dart files in any DartNative project; the app on your phone reloads
in milliseconds. No Xcode/Android Studio builds after the initial install.

```
 your computer                         your phone
┌──────────────────┐   Wi-Fi/HTTP    ┌───────────────────────┐
│ dart_go start    │ ──────────────▶ │ DartNative Go app     │
│  - watches files │   guest.ast     │  - interpreter        │
│  - builds bundle │   + deps        │  - native widgets     │
│  - serves code   │ ◀────────────── │  - your app, live     │
└──────────────────┘   logs/errors   └───────────────────────┘
```

## Prerequisites

| Requirement | Notes |
| :--- | :--- |
| Dart SDK `^3.12.0-192.0.dev` | The DartNative toolchain includes it. |
| `dn` CLI | The DartNative SDK command (use it instead of `flutter`/`dart run` for run/build/pub). |
| DartNative license | Subscribe at [dartpub.dev/framework](https://dartpub.dev/framework), then `dn config --license-key dnk_...`. |
| A device or emulator | iOS or Android, on the **same Wi-Fi network** as your computer. |

## Step 1 — Install the `dart_go` CLI

From the root of this repository:

```sh
dart run tool/install_global.dart
```

This compiles `bin/dart_go.dart` to a native binary and copies it into
`~/.local/bin` and `~/.pub-cache/bin`. Make sure one of those is on your
`PATH`, then verify:

```sh
dart_go version
```

You should see the CLI version and the matrix of native plugins compiled into
the runtime.

> **Don't want a global install?** Every command also works via
> `dart run bin/dart_go.dart <command>` from this repo.

## Step 2 — Install the app on your device

From the repo root:

```sh
dn pub get
dn run -d <device-id>
```

List devices with `dn devices` if you don't know the id. This builds and
installs the DartNative Go shell. You only need to do this again when native
code or bridges change — never for guest Dart edits.

When the app launches you'll see the **launcher screen**: a list of discovered
dev servers plus a field to enter a server URL manually.

## Step 3 — Start the dev server

Open a second terminal and serve the bundled example app (or any DartNative
project):

```sh
cd example/
dart_go start
```

The terminal shows:

- the server URL (e.g. `http://192.168.1.20:8088`),
- a scannable **QR code**,
- `[AST] AST auto-build: on` (hot reload mode),
- an initial `guest.ast ready` line once the first bundle is built.

Keep this terminal open — device logs and errors appear here.

## Step 4 — Connect the app

On the device, your server should appear in the launcher list within a second
or two (UDP discovery). Tap it — or scan the QR code / type the URL manually.

The app downloads your code, interprets it, and mounts your guest app. You are
now running interpreted Dart on a native shell.

## Step 5 — Hot reload

Edit `example/lib/main.dart` — change a string, a color, anything — and save.

The dev server rebuilds the AST bundle, pushes it over WebSocket, and the app
reloads **with state preserved** (Riverpod providers, `State` objects,
scroll positions all survive). Watch the terminal for the reload report.

If the save has an error, nothing breaks: the device keeps running the last
good code and the error prints to your terminal in red. Fix and save again.

## Useful keys while the server runs

Type these into the dev-server terminal:

| Key | Action |
| :--- | :--- |
| `r` | Force a hot reload on all connected devices |
| `v` | Toggle verbose telemetry (syncs with the in-app DevTool) |
| `q` | Reprint the connection QR code |
| `c` | Clear the terminal |
| `h` | Help |

## Next steps

- **Use your own project**: `dart_go start --project=/path/to/my_app`. Check
  compatibility first with `dart_go doctor`.
- **Full CLI options**: see the [CLI Reference](cli.md).
- **Understand what just happened**: read the
  [Architecture overview](architecture.md).
- **Write tests for the runtime**: see [Testing](testing.md).

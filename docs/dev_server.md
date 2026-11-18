# Dev Server & Protocol

The dev server is the half of DartNative Go that runs on your workstation.
You start it with `dngo start`; it lives in
[`lib/src/cli/server.dart`](../lib/src/cli/server.dart) with helpers in the
same directory. This page documents its startup sequence, every HTTP
endpoint, the WebSocket message protocol, the UDP discovery beacon, and how
dependencies are packaged and cached.

For the command/flag surface, see the [CLI Reference](cli.md). For how the
device interprets what it downloads, see [Runtime Modes](runtime_modes.md)
and [Hot Reload](hot_reload.md).

## Startup sequence

`DartGoServer.start()` runs these steps in order. Knowing the order helps
when a step is the one failing (see [Troubleshooting](troubleshooting.md)).

1. **Validate the pubspec** (`PubspecValidator`). Reads `pubspec.yaml` and
   checks every dependency against the native-plugin matrix compiled into the
   shell (`dngo version` prints that matrix). Produces the "Supported
   Native Plugins / Version Mismatches / Unsupported Native Plugins" report.
2. **Detect assets** (`AssetDetector`). Finds the app icon and splash image
   (from `dartnative_splash:` config, `dartnative: assets:`, then a list of
   conventional paths like `assets/icon.png`). Feeds `/manifest.json`,
   `/assets/icon.png`, `/assets/splash.png`.
3. **Detect icon-font usage** (`IconFontDetector`). Regex-scans guest
   `.dart` sources (comments/strings stripped, no analyzer parse) for
   `CupertinoIcons.xxx`, `Icons.xxx`, `MaterialSymbols*.xxx`,
   `FontAwesome*.xxx` and raw `IconData(... fontFamily: ...)` hits, plus
   `flutter: fonts:` declarations and icon-package `.ttf` files in
   `.dart_tool/package_config.json`. Icon registries annotated with the
   SDK's `@staticIconProvider` or the dependency-free `@IconFont`
   (`package:dartnative_go/server.dart`) are discovered from the parsed
   bundle — including external packages guest regex never sees — with a
   source pre-scan on cold start. Feeds `iconFonts`/`iconFontsHash` in
   `/manifest.json` and serves each family's bytes on demand via
   `/fonts/<family>.ttf` — unrequested fonts are never read from disk.
4. **Locate the entrypoint.** Prefers `lib/main.dart`; falls back to
   `guest_app/main.dart`. If neither exists the server prints an error and
   exits non-zero.
5. **Bind HTTP across a port range.** `NetworkHelper.bindInRange` scans from
   `--port`/`--port-range` (default `8088`–`8098`) and takes the first free
   port; if the whole range is busy it falls back to a system-assigned port.
   This is why several dev servers can run side by side on one machine.
6. **Resolve the advertised host.** `--host` if given, otherwise the first
   non-loopback, non-link-local IPv4 address (`NetworkHelper.getLocalIp`).
   On a machine with VPNs or multiple NICs this can pick the wrong interface —
   that's what `--host` is for.
7. **Start the UDP broadcaster** (`DartGoBroadcaster`), unless
   `--no-broadcast`.
8. **Print the banner** and render the QR code (unless `--no-qrcode`).
9. **Kick off an initial AST build** in the background when `--rebuild-ast`
   is on (the default), so `/guest.ast` exists before the first client
   connects. Failures only log a warning — source mode is unaffected.
10. **Install the stdin listener** (the interactive `r`/`R`/`v`/`q`/`c`/`h` keys).
11. **Start the file watchers** (Dart sources and `assets/`), then enter the
    request loop.

## File watching & the reload trigger

Two watchers feed reloads, both debounced by **150 ms**:

- **Code watcher** — `codeDir.watch(recursive: true)` on `lib/` (or
  `guest_app/`). A `.dart` change calls `_onCodeChanged`, which rebuilds the
  AST bundle (when enabled) and then broadcasts a single `reload`. The order
  matters: the device is told to reload only *after* fresh bytes exist, so it
  fetches new source and new AST together.
- **Asset watcher** — `assets/` directory. It deliberately ignores changes
  under `.dart_tool/` (where the AST builder writes `bundles/guest.ast`) and
  the legacy `assets/bundles/` path, because those are written by the AST
  builder and are already covered by the code-change broadcast — reacting to
  them would double-reload every device.

When `--rebuild-ast` is on, `_onCodeChanged` is also **serialized and
coalesced**: if a rebuild is in flight when another save lands, the rebuild is
marked queued and run once when the current one finishes. A failed build
broadcasts *nothing* and leaves the previous `guest.ast` in place, so a bad
save never disturbs a working app.

## HTTP endpoints

All responses set `Access-Control-Allow-Origin: *`. Mutable routes use
`Cache-Control: no-cache`; immutable package zips use a year-long cache.

| Endpoint | Method | Description |
| :--- | :--- | :--- |
| `/health`, `/dart_go/discover` | GET | Liveness + identity: `status`, `protocol: dart_go`, `appName`, version, connected client count. |
| `/manifest.json` | GET | The project descriptor (below). The first thing a device fetches. |
| `/deps.json` | GET | The dependency list: `depsHash` plus each package's `name`, `version`, `zipUrl`, `contentHash`, `byteSize`. |
| `/pkg/<name>@<version>.zip` | GET | One pure-Dart dependency as a ZIP. Immutable (`max-age=31536000`) since it's content-addressed by version. |
| `/user-code.zip` | GET | Your project's `lib/` (or `guest_app/`) Dart files as a single ZIP. Always fresh. |
| `/user-code-hash` | GET | `{ "hash": … }` for the user-code ZIP — a cheap way to poll for changes. |
| `/guest.ast` | GET | The precompiled full AST bundle. 404 when it hasn't been built — the device then stays on source mode. Serves `X-Ast-Bundle` (the source fingerprint of the exact bytes) so devices track their patch base. |
| `/guest.ast.patch` | GET | Delta AST patch containing only modified compilation units for incremental reloads (~20 KB). 404 when no patch is available — or when the client's `?base=` doesn't match the generation the delta was computed against (see [Patch lineage](hot_reload.md#patch-lineage-deltas-apply-only-to-their-base)). Serves `X-Ast-Bundle` with the new generation. |
| `/bundle.json` | GET | Monolithic fallback: manifest + deps + all source files + breakpoints in one JSON. |
| `/app.dart` | GET | Just the entrypoint source (`lib/main.dart`). The last-resort fallback. |
| `/assets.json` | GET | `{ "assets": [relative paths…] }` for everything under `assets/`. |
| `/assets/icon.png`, `/icon.png` | GET | The detected app icon, or a resolved asset file. |
| `/assets/splash.png`, `/splash.png` | GET | The detected splash image (falls back to the icon). |
| `/assets/<path>`, `/asset?path=<p>` | GET | Any project asset, resolved safely (see below). |
| `/icon-fonts.json`, `/fonts.json` | GET | Icon-font subset manifest: `{ hash, iconFonts: [{ family, package, builtIn, hasFontFile, url, glyphCount, names, codePoints }], fonts }`. Refreshed per request (cached by source fingerprint). |
| `/fonts/<family>[.ttf]` | GET | One icon-font's bytes, served only on request (ETag/`304` supported). 404 for built-ins without a resolvable `.ttf` and unknown families. |
| `/breakpoints` | GET/POST | List / add active breakpoints. Adding also broadcasts the new set and a reload. |
| `/resume` | POST | Broadcasts `resume` to continue after a breakpoint hit. |
| `/ws` | GET (upgrade) | The WebSocket channel — see below. |

### `/manifest.json` fields

The manifest is the contract between server and device. Key fields:

- `protocol: "dart_go"`, `appName`, `appVersion`, `dartGoVersion`,
  `runtimeVersion` — identity and compatibility.
- `depMode: true`, `depsHash`, `depsCount`, `depsUrl` — dependency mode is on
  and this is the hash to compare against the on-device cache.
- `userCodeUrl`, `userCodeHash` — where your code is and how to tell it changed.
- `hasAstBundle`, `astUrl` — whether an AST bundle exists and where to get it.
- `astPending` — rebuilds are enabled but no bundle file exists yet (the
  initial build runs in the background). AST-mode devices wait briefly for
  the build instead of falling back to source mode immediately.
- `profile` — `true` only when the server runs with `--profile`. The device
  shows the **AST BUNDLE** explorer in its DevTools sheet only then; off by
  default (see [Runtime Modes → AST bundle explorer](runtime_modes.md)).
- `astModuleFingerprints` — map of module URI → FNV-1a hex of that module's
  serialized AST. The device uses these to skip re-declaring unchanged modules
  on a hot reload (see [Hot Reload](hot_reload.md#module-reuse)).
- `hasIcon`/`iconUrl`, `hasSplash`/`splashUrl`, `splashBackgroundColor`,
  `assets` — asset metadata for the launch experience.
- `iconFonts`, `iconFontsHash`, `fonts` — on-demand icon fonts. `iconFonts`
  lists only the families the guest touches, each with its used-glyph
  subset (`names` + resolved `codePoints`) so the device never parses the
  full 1 236-entry `CupertinoIcons` class or downloads unrequested `.ttf`
  bytes; `iconFontsHash` lets the device skip redundant fetches across
  reloads. `fonts` carries the raw `flutter: fonts:` declarations.
- `supportedPlugins`, `unsupportedPlugins`, `versionMismatches` — the pubspec
  validation result, so the device can warn about plugins the shell doesn't
  have.

### Asset path resolution & traversal safety

`_resolveAssetFile` turns a request path into a file on disk defensively:

- strips a leading `/`, URL-decodes, normalizes `\` → `/`;
- rejects empty paths and any path containing `..`;
- tries the path relative to the project root, then under `assets/`, then with
  a leading `assets/` stripped;
- resolves symlinks on both the project and the candidate and requires the
  file to live **inside** the project.

So a request for `../../etc/passwd` or a symlink that escapes the project is
never served.

## WebSocket protocol (`/ws`)

The WebSocket is the control and telemetry channel. The server tracks every
connected socket and broadcasts to all of them. Messages are JSON objects with
a `type` field.

### Server → device

| `type` | Payload | Meaning |
| :--- | :--- | :--- |
| `reload` | `changedFile?`, `timestamp` | Re-fetch and re-evaluate, preserving state. Sent on save, on the `r` key, and on breakpoint changes. |
| `restart` | `origin: "cli" \| "test"`, `timestamp` | Hot restart: drop interpreter state and evaluate fresh. Sent on the `R` key, and relayed from test scripts. |
| `breakpoints` | `breakpoints: [...]` | The active breakpoint set (sent on connect and on change). |
| `resume` | — | Continue execution after a breakpoint. |
| `set_verbose` | `enabled: bool` | Sync verbose logging (from the `v` key or another device). |
| `set_vm_debugger` | `enabled: bool` | Toggle the VM debugger hook. |
| `ui_probe_request`, `ui_tap`, `ui_hover`, `ui_focus`, `ui_blur`, `ui_submit`, `ui_type`, `ui_scroll` | automation args | UI automation commands relayed from a test script to the device. |

On connect the server immediately sends the current `set_verbose` state and,
if any, the active breakpoints, so a newly attached device is in sync.

### Device → server

| `type` | Payload | Meaning |
| :--- | :--- | :--- |
| `log` | `level`, `message`, `timestamp` | Device stdout/errors. `ERROR` prints red `[Device Error]`, everything else cyan `[Device Log]`. |
| `set_verbose` | `enabled: bool` | The in-app DevTool toggled verbose; the server flips its own flag and re-broadcasts so all clients agree. |
| `breakpoint_hit` | `file`, `line`, `message?`, `variables?` | A breakpoint fired; the CLI prints it and waits for `c` / `/resume`. |
| `reload` / `restart` | `origin: "test"`, `changedFile?` | A test script (with no filesystem access) asks for a reload/restart. Only `origin: test` is relayed, which prevents loops. |
| `ui_tree` | `requestId`, `tree` | Answer to `ui_probe_request`; relayed to the test script. |
| `ui_<action>_result` | `requestId`, `ok`, `error?`, `viewId?` | Outcome of a UI automation command; relayed to the test script. |

### UI automation

A test script connects as a *second* WebSocket client. The server relays
`ui_*` commands to the device and relays `ui_tree` / `*_result` back, so the
script can drive and inspect a live app without filesystem access. The full
protocol and the YAML scenario runner are documented in
[Testing](testing.md#ui-automation-protocol).

## Discovery beacons

`DartGoBroadcaster` sends a JSON UDP datagram every **1.5 s** to
`255.255.255.255` (broadcast), on:

- every port in the configured range (`8088`–`8098` by default), and
- the dedicated discovery port **45454**.

The beacon payload is everything the launcher needs to render a server card
and connect:

```json
{
  "protocol": "dart_go",
  "version": "0.1.0",
  "appName": "my_app",
  "url": "http://192.168.1.20:8088",
  "bundleUrl": "http://192.168.1.20:8088/bundle.json",
  "manifestUrl": "http://192.168.1.20:8088/manifest.json",
  "wsUrl": "ws://192.168.1.20:8088/ws",
  "port": 8088,
  "hasIcon": true,
  "hasSplash": false,
  "timestamp": 1758816000000
}
```

UDP broadcast is a convenience, not a requirement. Networks that block
broadcast (many corporate and guest Wi-Fi networks) can still connect via the
QR code or manual URL — both carry the same `url`.

## Dependency packaging & caching

The server avoids re-sending your whole dependency tree on every save. The
mechanism lives in [`dep_packager.dart`](../lib/src/cli/dep_packager.dart) on
the server and `lib/src/runner/dep_cache.dart` on the device.

- `DepPackager.resolveAndPack` reads `.dart_tool/package_config.json` and
  packs each **pure-Dart** package's `lib/` into a versioned ZIP. It skips the
  host app itself, the native cores (`dartnative`, `dartnative_ios`,
  `dartnative_android`), build/dev tools (`build_runner`, `test`, …), and any
  library the runtime bridges natively (`kAstBridgedLibraries`).
- Each `DepEntry` carries a `contentHash` (SHA-256 of the zip) and a
  deterministic `depsHash` over all `name@version` pairs.
- Results are cached in memory keyed by project path and invalidated on the
  `package_config.json` mtime, so a `pub get` re-packs but ordinary saves don't.
- On the device, `BundleLoader` compares the manifest's `depsHash` to the
  cached one. Only packages not already in `DepCache` are downloaded, then
  unpacked to `<app_support>/dartnative_go/dep_cache/<name>@<version>/`.
  Across reloads the in-memory `_cachedDepSources` is reused, so dependency
  loading is effectively free. The DevTool overlay can inspect and clear this
  cache.

This split — **immutable versioned dependency zips + a tiny always-fresh
user-code zip** — is the Expo-Go-style trick that keeps incremental reloads in
the tens of milliseconds.

## The AST builder

When `--rebuild-ast` is on, the server (and `tool/build_ast_bundle.dart`) call
`buildGuestAstBundle` in
[`ast_builder.dart`](../lib/src/cli/ast_builder.dart). Highlights:

- **Incremental fast path.** A FNV-1a fingerprint over all guest `.dart` files
  plus `package_config.json` is compared to the last successful build.
  Unchanged sources skip the analyzer parse entirely and return in
  milliseconds — the "no changes" fast path you see as `guest.ast up to date
  (cache hit)`.
- **Bridged libraries are excluded.** `kAstBridgedLibraries` lists the DartNative
  SDK, the DartNative plugin set, and whole third-party packages compiled into
  the shell (e.g. `dio` —
  [interpreter.md](architecture/interpreter.md#third-party-packages-compiled-into-the-shell));
  they're never bundled.
- **FFI registrant stub.** The generated `dartnative_plugin_registrant.dart`
  loads native FFI symbols the analyzer-free interpreter can't run, so the
  bundler substitutes a no-op stub (`kRegistrantStub`) under every import
  spelling — matching how the source engine intercepts `registerNativeBindings`.
- **Per-module fingerprints.** After writing the bundle, each module's
  serialized AST is hashed and surfaced via `/manifest.json` as
  `astModuleFingerprints`. This is what powers
  [module reuse](hot_reload.md#module-reuse) on the device.
- **Patch lineage.** Every hot build records which generation its delta
  applies to (`patchBaseFingerprint`, served and enforced as `?base=` on
  `/guest.ast.patch`). See
  [Patch lineage](hot_reload.md#patch-lineage-deltas-apply-only-to-their-base).
- **Sources survive rebuilds.** The incremental DFS only re-parses changed
  files, so the rebuilt bundle's `sources` map is backfilled: changed files
  are re-read from disk and everything still present carries forward from
  the previous bundle. Without this, rebuilt bundles (and everything
  derived from them, like patches) degrade to entry-only sources.
- **`SafeAstConverter`.** Extends the generator's `AstConverter` to handle
  newer analyzer nodes (e.g. `LibraryIdentifier` in `library foo;`) so the
  build doesn't choke on them.

The builder returns an `AstBuildResult` (never throws) carrying `success`,
`moduleCount`, `byteSize`, `entryPointUri`, `cached`, `moduleFingerprints`,
and an `error` string on failure — which is how the server decides whether to
broadcast a reload at all.

## Graceful shutdown

`Ctrl+C` (or `SIGTERM`) restores the terminal, stops the broadcaster and the
file watchers, closes every WebSocket, and force-closes the HTTP server before
exiting.

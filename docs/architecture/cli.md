# CLI

Entry point for everything the developer types: `dngo`.

## Files

| File | Role |
| :--- | :--- |
| `bin/dngo.dart` | Dispatches a parsed command; prints help, version, doctor output. |
| `lib/src/cli/commands/command_line.dart` | Pure argument parsing -> `DartGoCommandLine` (no I/O, unit-testable). |
| `lib/src/cli/diagnostics/pubspec_validator.dart` | Checks `pubspec.yaml` plugins against the supported matrix. |
| `lib/src/cli/diagnostics/dart_go_version.dart` | CLI/runtime versions and `kSupportedNativePlugins`. |
| `lib/src/cli/diagnostics/asset_detector.dart` | Finds app icon and splash from pubspec config or common paths. |
| `lib/src/cli/diagnostics/icon_font_detector.dart` | Detects the icon families/glyphs the guest actually uses, for on-demand font serving. |
| `lib/src/cli/server/qr_code.dart` | Terminal QR rendering. |

Sub-packages: `commands/` (parsing), `diagnostics/` (validation, versions,
assets, icon fonts), `packaging/` (AST build, dependency ZIPs),
`server/` (dev server), `server_components/` (delta bundler).

## Flow

```text
args -> DartGoCommandLine.parse -> command
  start   -> DartGoServer(options).start()      (see dev-server.md)
  doctor  -> PubspecValidator + AssetDetector reports
  version -> version + plugin matrix
  dap     -> runDartNativeDap(args)             (see debugging.md)
  help / unknown
```

## Invariants

- Parsing never touches the filesystem except to resolve a positional project
  directory; execution lives in `bin/`.
- A bare `dngo -v` prints the version; `-v` with other arguments means
  verbose `start`.
- Plugin compatibility is a major-version match (`_isConstraintCompatible`).

## Extending

Add a command: extend `DartGoCommand`, handle it in `parse`, dispatch in
`bin/dngo.dart`, document it in `docs/cli.md`.

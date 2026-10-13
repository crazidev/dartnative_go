# CLI

Entry point for everything the developer types: `dart_go`.

## Files

| File | Role |
| :--- | :--- |
| `bin/dart_go.dart` | Dispatches a parsed command; prints help, version, doctor output. |
| `lib/src/cli/command_line.dart` | Pure argument parsing -> `DartGoCommandLine` (no I/O, unit-testable). |
| `lib/src/cli/pubspec_validator.dart` | Checks `pubspec.yaml` plugins against the supported matrix. |
| `lib/src/cli/dart_go_version.dart` | CLI/runtime versions and `kSupportedNativePlugins`. |
| `lib/src/cli/asset_detector.dart` | Finds app icon and splash from pubspec config or common paths. |
| `lib/src/cli/qr_code.dart` | Terminal QR rendering. |

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
- A bare `dart_go -v` prints the version; `-v` with other arguments means
  verbose `start`.
- Plugin compatibility is a major-version match (`_isConstraintCompatible`).

## Extending

Add a command: extend `DartGoCommand`, handle it in `parse`, dispatch in
`bin/dart_go.dart`, document it in `docs/cli.md`.

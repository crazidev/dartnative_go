# dartnative_go

A **dartnative** client runtime and development shell (similar to _Expo Go_ for React Native), powered by `tom_d4rt`. It allows authoring, interpreting, and live hot-reloading multi-file DartNative apps dynamically over Wi-Fi / localhost.

> 📖 **Docs**: [Website](website/) · [docs/README.md](docs/README.md) · [Prebuild & plugin `build_config`](docs/prebuild.md) · [ARCHITECTURE.md](ARCHITECTURE.md)

## DartNative Go CLI (`dngo`)

The `dngo` CLI is the universal tool to start projects, validate native plugin compatibility, detect assets, and broadcast discovery beacons for the mobile app.

### Install Globally

Install the standalone `dngo` binary globally so you can use it in any terminal and project:

```sh
dart run tool/install_global.dart
```

Once installed, use `dngo` directly anywhere:

```sh
# Start the dev server in any DartNative project
dngo start

# Check plugin compatibility and assets
dngo doctor

# Sync android/ and ios/ from dngo.config.dart (and plugin build_config.dart)
dngo prebuild

# Check versions and supported native plugins
dngo version
```

Plugin authors: ship native permissions in a package-root `build_config.dart`.
See [docs/prebuild.md](docs/prebuild.md).

### Key Features

- **Plugin Version Validation**: Validates that all native plugins in `pubspec.yaml` match the versions compiled into DartNative Go runtime (e.g. `dartnative`, `dartnative_share`, `dartnative_webview` at `^1.0.0`).
- **DartNative Compatibility Layer**: Built-in bridge support for `package:dartnative/flutter_compat.dart` enabling drop-in compatibility for common DartNative widgets and paradigms.
- **VS Code Debug Adapter (DAP)**: Start with `dngo start --dap` to enable IDE breakpoints, stepping, variable inspection, and stack trace navigation directly in VS Code.
- **Asset Detection & Serving**: Auto-discovers app icons and splash screen configurations (`dartnative_splash`), serving them via `/assets/icon.png`, `/assets/splash.png`, and `/manifest.json`.
- **Port Range & Multi-Port UDP Broadcast**: Automatically finds an available port across a range (`8088..8098`) and broadcasts discovery beacons across the local network so mobile clients can auto-connect.
- **Terminal QR Code**: Prints an ANSI half-block QR code directly in the terminal for instant mobile camera connection.

## Run it

```sh
dn pub get
dn run -d <device-id>
```

dartnative apps require a license. Subscribe at
[dartpub.dev/framework](https://dartpub.dev/framework), copy your license key
(`dnk_...`) from the Framework panel, and configure it once:

```sh
dn config --license-key dnk_...
```

After that `dn run` just works, on every platform. (Prefer not to store the
key? Pass it per run instead: `dn run --dart-define=DN_LICENSE_KEY=dnk_...`.)

Always use **`dn`** for run/build/pub commands — not the underlying SDK CLI.

### Release builds

```sh
dn build apk
dn build ipa
```

Release apps ship the **full** icon fonts: icon-font tree shaking is disabled
in [`android/app/build.gradle.kts`](android/app/build.gradle.kts) and
[`ios/DartNative/Release.xcconfig`](ios/DartNative/Release.xcconfig) because the
interpreter creates `IconData` from code points in guest code at runtime, and the
shaker only accepts `const IconData`. Leave it off — enabling it fails the
release build, and a forced subset would draw interpreted icons as blank boxes.

## Attribution

This project uses and extends [`tom_d4rt`](https://github.com/al-the-bear/tom_d4rt), an interpreter and ecosystem created and maintained by [al-the-bear](https://github.com/al-the-bear).

According to `tom_d4rt`'s own attribution notice, the project is an extended clone of the original D4rt project by **Moustapha Kodjo Amadou**, first published in 2025, and is based on his interpreter idea.

- [tom_d4rt repository](https://github.com/al-the-bear/tom_d4rt)
- [Original D4rt attribution](https://github.com/al-the-bear/tom_d4rt#readme)

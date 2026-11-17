# dartnative_go

A **dartnative** client runtime and development shell (similar to *Expo Go* for React Native), powered by `tom_d4rt`. It allows authoring, interpreting, and live hot-reloading multi-file DartNative apps dynamically over Wi-Fi / localhost.

> 📖 **Architecture & Technical Details**: See [ARCHITECTURE.md](ARCHITECTURE.md) for a deep dive into the bridge architecture, widget proxies, lifecycle management, and dev server protocol.

## DartNative Go CLI (`dart_go`)

The `dart_go` CLI is the universal tool to start projects, validate native plugin compatibility, detect assets, and broadcast discovery beacons for the mobile app.

### Install Globally
Install the standalone `dart_go` binary globally so you can use it in any terminal and project:

```sh
dart run tool/install_global.dart
```

Once installed, use `dart_go` directly anywhere:
```sh
# Start the dev server in any DartNative project
dart_go start

# Check plugin compatibility and assets
dart_go doctor

# Check versions and supported native plugins
dart_go version
```

### Key Features
- **Plugin Version Validation**: Validates that all native plugins in `pubspec.yaml` match the versions compiled into DartNative Go runtime (e.g. `dartnative`, `dartnative_share`, `dartnative_webview` at `^1.0.0`).
- **DartNative Compatibility Layer**: Built-in bridge support for `package:dartnative/flutter_compat.dart` enabling drop-in compatibility for common DartNative widgets and paradigms.
- **VS Code Debug Adapter (DAP)**: Start with `dart_go start --dap` to enable IDE breakpoints, stepping, variable inspection, and stack trace navigation directly in VS Code.
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
[`ios/DartNative/*.xcconfig`](ios/DartNative/Release.xcconfig) because the
interpreter creates `IconData` from code points in guest code at runtime, and
the shaker only accepts `const IconData`. Leave it off — enabling it fails the
release build, and a forced subset would draw interpreted icons as blank boxes.

## Make it yours

- **Your UI** — edit `lib/main.dart`.
- **App icon + launch logo** — replace `assets/dn-logo.png` with your logo, then
  regenerate icon **and** splash in one step:
  ```sh
  dart run tool/generate_app_assets.dart --source=assets/dn-logo.png --bg=#000000
  ```
  (Splash only: `dart run dartnative_splash:setup`.)
- **Plugins** — browse **[dartpub.dev](https://dartpub.dev)**. Add a package to
  `pubspec.yaml`, run `dn pub get`, and import it — pure-Dart packages and
  dartnative plugins both work as-is.

## Don't touch (unless you know the runtime)

These files are the dartnative runner glue — they're why the app renders:
`ios/Runner/{AppDelegate,SceneDelegate}.swift` + the scene block in `Info.plist`,
and `android/.../{Application,MainActivity}.kt` + the Material3 themes in
`android/app/src/main/res/values*/styles.xml`.

> Dependency paths in `pubspec.yaml` assume this app sits beside
> `dartnative_framework`. Fix them if you created it elsewhere.

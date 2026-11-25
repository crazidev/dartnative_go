# dngo_config

Typed Dart build configuration for **DartNative Go** (`dngo`) apps and plugins.

With `dngo_config`, you can:

- **Configure native builds in Dart** — declare app identity, icons, splash screens, signing, URL schemes, and permissions in `dngo.config.dart` for `dngo prebuild`.
- **Ship zero-setup plugins** — bundle required Android and iOS permissions in a plugin's `build_config.dart` so `dngo prebuild` applies them automatically.
- **Power launch previews** — supply display name, version, app icon, and splash colors to `dngo start`.

---

## Installation

Add `dngo_config` to `pubspec.yaml`:

```yaml
dependencies:
  dngo_config: ^0.1.0
```

Or install it via the DartNative CLI:

```sh
dn pub add dngo_config
```

Import either library URI:

```dart
import 'package:dngo_config/dngo.dart';
// or:
import 'package:dngo_config/dngo_config.dart';
```

---

## How `dngo prebuild` Works

`dngo prebuild` combines your app's `dngo.config.dart` with any `build_config.dart` files discovered from your plugin dependencies and updates `android/` and `ios/` in place:

```sh
dngo prebuild:init          # Generate dngo.config.dart from an existing native project
dngo prebuild               # Patch android/ and ios/ in place from dngo.config.dart + plugins
dngo prebuild --clean       # Delete android/ and ios/, recreate them, then sync
```

- **Non-destructive & idempotent**: Preserves existing native formatting and leaves manual edits outside managed entries untouched. Repeated runs never create duplicate entries.
- **Automatic cleanup**: Removing a permission, scheme, or plugin dependency and re-running `dngo prebuild` removes the entries previously managed for it.
- **Preview metadata (`dngo start`)**: The dev server reads `AppConfig.name`, `version`, `icon`, and `splash` (plus platform overrides) to serve `/assets/icon.png`, `/assets/splash.png`, and light/dark splash colors in `/manifest.json`.

---

## App Configuration (`dngo.config.dart`)

Create `dngo.config.dart` at your project root and expose a top-level `dngoConfig` getter:

```dart
// dngo.config.dart
import 'package:dngo_config/dngo.dart';

DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: 'My App',
    bundleId: BundleId(
      ios: 'com.example.myapp',
      android: 'com.example.myapp',
    ),
    version: AppVersion(name: '1.0.0', buildNumber: 1),
    icon: AppIcon(
      source: 'assets/app_icon.png',
      androidBackground: ColorValue('#E4ECF8'),
      androidSafeZone: AdaptiveSafeZone.inset(5),
    ),
    splash: SplashConfig(
      image: 'assets/splash.png',
      backgroundColor: ColorValue('#FFFFFF'),
      backgroundDark: ColorValue('#0F172A'),
    ),
  ),
  platforms: PlatformsConfig(
    ios: IosConfig(
      minimumDeploymentTarget: IosVersion(16, 1),
      supportedOrientations: {IosOrientation.portrait},
      querySchemes: {'youtube'},
      urlSchemes: {'myapp'},
      associatedDomains: {'applinks:example.com'},
    ),
    android: AndroidConfig(
      minSdk: 24,
      targetSdk: 35,
      permissions: {
        AndroidPermission.camera,
        AndroidPermission.internet,
      },
      intentQueries: [
        AndroidIntent.view(data: [AndroidIntentData.scheme('youtube')]),
      ],
      intentFilters: [
        AndroidIntentFilter.deepLink(scheme: 'myapp'),
      ],
    ),
  ),
  plugins: [
    mediaPickerConfig(
      photoLibraryUsageDescription: 'Select photos and videos to share.',
    ),
    notificationsConfig(
      permissionDescription: 'Send reminders and activity updates.',
    ),
  ],
);
```

---

## Configuration Reference

### App Identity (`AppConfig`)

| Property | Type | Description |
| :--- | :--- | :--- |
| `name` | `String` | Display name for the native app and dev-server preview. |
| `bundleId` | `BundleId` | `ios` bundle identifier and `android` application ID. |
| `version` | `AppVersion` | Semantic version `name` (e.g. `'1.0.0'`) and integer `buildNumber`. |
| `icon` | `AppIcon?` | Shared icon definition for both platforms. |
| `splash` | `SplashConfig?` | Shared launch-screen / splash definition for both platforms. |
| `deepLinkScheme` | `String?` | Optional default custom URL scheme for the app. |

### Icons & Splash

`ColorValue` accepts hex strings with or without a leading `#` (e.g. `ColorValue('E4ECF8')` or `ColorValue('#E4ECF8')`). Define shared assets on `AppConfig` or supply platform-specific overrides on `IosConfig` / `AndroidConfig`.

#### Icons

| Type | Where Used | Key Options |
| :--- | :--- | :--- |
| `AppIcon` | `AppConfig.icon` | Shared `source`, plus `android*` and `ios*` overrides. |
| `AndroidAppIcon` | `AndroidConfig.icon` | `foreground`, `background`, `monochrome`, `safeZone`, `padding`, `foregroundFormat`, `round`, `iconName`, `legacy`, `playStore`, `effect`, `themed` (`AndroidThemedIcon`). |
| `IosAppIcon` | `IosConfig.icon` | `image`, `background`, `dark`, `backgroundDark`, `tinted`, `padding`. |
| `AdaptiveSafeZone` | Android `safeZone` | `AdaptiveSafeZone.fit`, `AdaptiveSafeZone.inset(pct)`, `AdaptiveSafeZone.none`, `AdaptiveSafeZone.asIs`. |

#### Splash

| Type | Where Used | Key Options |
| :--- | :--- | :--- |
| `SplashConfig` | `AppConfig.splash` | Shared `image`, `imageDark`, `backgroundColor`, `backgroundDark`, `backgroundImage`, `backgroundImageDark`, plus `android*` and `iosLogoSize` options. |
| `AndroidSplash` | `AndroidConfig.splash` | `image`, `background`, dark variants, `animatedIcon`, `duration`, `iconBackground`, `iconPadding`, `imageFit`, `gravity`, `fullscreen`, `screenOrientation`, status/navigation bar styling, and `branding` / `brandingText` / `brandingMode`. |
| `IosSplash` | `IosConfig.splash` | `image`, `imageDark`, `background`, `backgroundDark`, `backgroundImage`, `backgroundImageDark`, `logoSize`. |

### iOS (`IosConfig`)

| Property | Type | Description |
| :--- | :--- | :--- |
| `minimumDeploymentTarget` | `IosVersion` | Minimum iOS version via `IosVersion(major, [minor])` (defaults to `16.1`). |
| `supportedOrientations` | `Set<IosOrientation>` | Allowed orientations (`portrait`, `portraitUpsideDown`, `landscapeLeft`, `landscapeRight`, `IosOrientation.defaults`, `IosOrientation.all`). |
| `supportsIpad` | `bool` | Whether the app supports iPad (defaults to `true`). |
| `appGroup` | `String?` | Optional App Group identifier. |
| `supportsLiveActivities` | `bool` | Enables Live Activities (`NSSupportsLiveActivities`, defaults to `false`). |
| `querySchemes` | `Set<String>` | URL schemes written to `LSApplicationQueriesSchemes` in `Info.plist`. |
| `urlSchemes` | `Set<String>` | Custom URL schemes merged into `CFBundleURLTypes` in `Info.plist`. |
| `associatedDomains` | `Set<String>` | Universal Links domains written to `ios/Runner/Runner.entitlements`. |
| `icon`, `splash` | `IosAppIcon?`, `IosSplash?` | Platform-specific overrides for `AppConfig.icon` and `AppConfig.splash`. |

### Android (`AndroidConfig`)

| Property | Type | Description |
| :--- | :--- | :--- |
| `minSdk`, `targetSdk`, `compileSdk`, `ndkVersion` | `int?`, `String?` | Gradle SDK/NDK overrides (`null` preserves DartNative Gradle defaults). |
| `versionCode`, `versionName` | `int?`, `String?` | Optional Android-only overrides for `AppConfig.version`. |
| `signing` | `AndroidSigningConfig?` | Defaults to `AndroidSigningConfig.debug()`. Use `AndroidSigningConfig(...)` or `AndroidSigningConfig.fromGradleProperty('key.properties')` for release builds. |
| `usesCleartextTraffic` | `bool?` | Sets `android:usesCleartextTraffic` on `<application>`. |
| `permissions` | `Set<AndroidPermission>` | Typed permissions written as `<uses-permission>` entries in `AndroidManifest.xml`. |
| `intentQueries` | `List<AndroidIntent>` | `<queries>` entries in `AndroidManifest.xml` for Android 11+ package visibility (`AndroidIntent.view`, `AndroidIntentData`). |
| `intentFilters` | `List<AndroidIntentFilter>` | `<intent-filter>` entries attached to an activity (e.g. `AndroidIntentFilter.deepLink(scheme: 'myapp', autoVerify: true)`). |
| `icon`, `splash` | `AndroidAppIcon?`, `AndroidSplash?` | Platform-specific overrides for `AppConfig.icon` and `AppConfig.splash`. |

### Built-in Plugin Helpers

| Helper | Package | Managed Permissions |
| :--- | :--- | :--- |
| `mediaPickerConfig(...)` | `dartnative_media_picker` | `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription`, `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`. |
| `notificationsConfig(...)` | `dartnative_notifications` | `NSUserNotificationsUsageDescription`. |

---

## Plugin Authors: `build_config.dart`

Plugins can bundle their own Android manifest permissions and iOS `Info.plist` usage descriptions so apps pick them up automatically without editing `dngo.config.dart`.

### 1. Add `dngo_config` to your plugin

In your plugin's `pubspec.yaml`:

```yaml
dependencies:
  dngo_config: ^0.1.0
```

### 2. Create `build_config.dart`

Place `build_config.dart` at the package root (or at `lib/build_config.dart`):

```dart
// build_config.dart
import 'package:dngo_config/dngo.dart';

/// Applied automatically by `dngo prebuild` when an app depends on this package.
DngoPluginConfig get dngoPluginConfig => const PluginBuildConfig(
  name: 'my_audio_plugin',
  permissions: {
    AndroidPermission.vibrate,
    AndroidPermission.recordAudio,
  },
  iosPermissions: {
    'NSMicrophoneUsageDescription':
        'Records audio clips when you hold the microphone button.',
    'NSSpeechRecognitionUsageDescription':
        'Transcribes recorded voice notes into text.',
  },
);
```

| Field | Type | Effect |
| :--- | :--- | :--- |
| `name` | `String` | Must match the plugin's `pubspec.yaml` name. Used for deduplication and overrides. |
| `permissions` | `Set<AndroidPermission>` | Written as `<uses-permission>` tags in `android/app/src/main/AndroidManifest.xml`. |
| `iosPermissions` | `Map<String, String>` | Written as usage-description keys in `ios/Runner/Info.plist`. |

> [!TIP]
> Keep `build_config.dart` at the package root (outside `lib/` exports) so downstream apps do not import it accidentally.

### 3. Discovery, Overrides & Removal

- **Package-graph discovery**: `dngo prebuild` reads `.dart_tool/package_config.json` (including workspace roots) and scans dependencies for `build_config.dart` or `lib/build_config.dart`.
- **Static parsing**: Prebuild parses `build_config.dart` as source text without executing it. Use `PluginBuildConfig(...)`, `AndroidPermission.*` constants, and quoted string literals (`'Key': 'Value'`).
- **App-level overrides**: Adding an entry with the same `name` to `plugins:` in `dngo.config.dart` overrides the plugin's `build_config.dart` (useful for custom iOS prompt copy or trimming permissions).
- **Automatic removal**: Dropping the plugin from `pubspec.yaml` and running `dn pub get && dngo prebuild` removes the permissions previously added for that plugin while keeping unrelated manual edits intact.

### 4. Verify in an Example App

From an app that depends on your plugin:

```sh
dn pub get
dngo prebuild --project=.
```

Confirm that:

1. `dngo prebuild` prints your plugin under `plugins:` (e.g. `my_audio_plugin (from build_config.dart)`).
2. `AndroidManifest.xml` and `Info.plist` contain the expected entries.
3. Re-running `dngo prebuild` creates no duplicate entries.
4. Removing the plugin from `pubspec.yaml` and re-running `dn pub get && dngo prebuild` removes those entries cleanly.

If your plugin is not picked up, check that `dn pub get` has generated `.dart_tool/package_config.json`, `build_config.dart` is at the package root or `lib/build_config.dart`, and `PluginBuildConfig(name: ...)` matches the package name.

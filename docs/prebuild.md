# Prebuild and plugin `build_config`

`dngo prebuild` syncs Android and iOS project files from typed Dart config.
Apps declare identity and platform options in `dngo.config.dart`. Plugins
ship the native permissions they need in a `build_config.dart` file; prebuild
discovers that file from the app's package graph and applies it automatically.

This is the plugin-owner and app-user guide. Command flags live in the
[CLI reference](cli.md).

---

## App config

At the project root:

```dart
// dngo.config.dart
import 'package:dartnative_go_config/dngo.dart';

DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: 'My App',
    bundleId: BundleId(
      ios: 'com.example.myapp',
      android: 'com.example.myapp',
    ),
    version: AppVersion(name: '1.0.0', buildNumber: 1),
  ),
  platforms: PlatformsConfig(
    ios: IosConfig(
      minimumDeploymentTarget: IosVersion(16, 1),
      querySchemes: {'youtube'},
    ),
    android: AndroidConfig(
      permissions: {AndroidPermission.camera},
    ),
  ),
);
```

Add `dartnative_go_config` to the app `pubspec.yaml`, then:

```sh
dngo prebuild:init          # create dngo.config.dart from the native project
dngo prebuild               # patch android/ and ios/ in place
dngo prebuild --clean       # delete android/ and ios/, recreate, then sync
```

`prebuild:init` asks before overwriting an existing config, and asks whether
to copy Gradle / Info.plist / Podfile / permission values from the current
native folders. Use `--force`, `--sync`, or `--no-sync` to skip the prompts.

Prebuild keeps existing native formatting and only inserts or removes the
entries it manages. Manual edits outside those entries survive.

---

## Plugin owners: ship a `build_config.dart`

Apps should not have to copy your Android permissions and iOS usage strings
into their config. Put them next to the package.

### 1. Depend on `dartnative_go_config`

In the **plugin** `pubspec.yaml`:

```yaml
dependencies:
  dartnative_go_config:
    path: ../dartnative_go/pkgs/dartnative_go_config   # or a hosted version
```

### 2. Add `build_config.dart` at the package root

`lib/build_config.dart` also works. Prebuild looks for both.

```dart
import 'package:dartnative_go_config/dngo.dart';

/// Applied by `dngo prebuild` when an app depends on this package.
DngoPluginConfig get dngoPluginConfig => const PluginBuildConfig(
  name: 'native_bottomsheet',
  permissions: {
    AndroidPermission.vibrate,
    AndroidPermission.recordAudio,
  },
  iosPermissions: {
    'NSMicrophoneUsageDescription':
        'The sheet records a voice note when you hold the microphone button.',
    'NSSpeechRecognitionUsageDescription':
        'Dictation in the comment sheet turns speech into text.',
  },
);
```

| Field | Written to |
| :--- | :--- |
| `name` | Must match the pub package name. Used to detect overrides and skip duplicates. |
| `permissions` | `<uses-permission>` in `AndroidManifest.xml` |
| `iosPermissions` | Usage-description keys in `ios/Runner/Info.plist` |

Keep the file out of your public `lib/` export if you do not want apps to
import it. Discovery reads the file as text; it does not execute it.

### 3. What the app does

The app only adds your package:

```yaml
dependencies:
  native_bottomsheet:
    path: ../   # or a hosted version
```

It does **not** list the plugin under `plugins:` in `dngo.config.dart`. After
`dn pub get`, `dngo prebuild` prints:

```text
Synced native projects for My App.
  plugins:         native_bottomsheet (from build_config.dart)
```

### Override from the app

An explicit `plugins:` entry with the same `name` wins over the discovered
file. Use that when the app needs different copy or a smaller permission set:

```dart
plugins: [
  PluginBuildConfig(
    name: 'native_bottomsheet',
    permissions: {AndroidPermission.vibrate},
    iosPermissions: {
      'NSMicrophoneUsageDescription': 'Custom mic copy for this app.',
    },
  ),
],
```

First-party helpers such as `mediaPickerConfig()` and `notificationsConfig()`
work the same way: if they appear in `plugins:`, they are the source of truth.

### Removal

When the app drops the plugin (or you delete `build_config.dart`) and runs
prebuild again, permissions previously written for that plugin are removed.
Unrelated manual manifest / plist entries are left alone.

---

## How discovery works

1. Walk up from the app directory to `.dart_tool/package_config.json`
   (workspace members reuse the workspace file).
2. For each package, if `build_config.dart` or `lib/build_config.dart` exists,
   parse `PluginBuildConfig(...)`.
3. Skip tooling packages (`dartnative`, `dartnative_go_config`, `ffi`, …).
4. Merge into the app config. App `plugins:` entries with the same name win.

The parser is the same source reader used for `dngo.config.dart`. Stick to
`PluginBuildConfig`, `AndroidPermission.*`, and quoted string maps.

---

## Testing prebuild

### Smoke-test on an example app

From a project that depends on your plugin (for example
`native_bottomsheet/example`):

```sh
dn pub get
dngo prebuild --project=.
```

Confirm the CLI lists your package under `plugins:`. Then check the native
files:

```sh
# Android
grep -n 'android.permission.VIBRATE' \
  android/app/src/main/AndroidManifest.xml
grep -n 'android.permission.RECORD_AUDIO' \
  android/app/src/main/AndroidManifest.xml

# iOS
grep -n 'NSMicrophoneUsageDescription' ios/Runner/Info.plist
grep -n 'NSSpeechRecognitionUsageDescription' ios/Runner/Info.plist
```

Run prebuild a second time: the files should not grow duplicate tags.

Remove the plugin from the example `pubspec.yaml`, run `dn pub get` and
`dngo prebuild` again, and confirm those entries disappear.

### Unit tests in this repo

Discovery, apply, remove, and app override are covered by:

```sh
dn test test/unit/plugin_discovery_test.dart
dn test test/unit/prebuild_test.dart
```

`plugin_discovery_test.dart` builds a fake package with `build_config.dart`
and a `package_config.json`, then asserts that `DngoNativeGenerator` writes
and later removes the permissions.

When you change the parser or the merge rules, add a case there rather than
relying only on a real plugin checkout.

### Testing a new plugin from a temp app

```sh
tmp=$(mktemp -d)
# copy or create a minimal DartNative app in $tmp
# pubspec.yaml depends on your plugin (path: …)
# dngo.config.dart with AppConfig only — empty plugins: []
dn pub get --directory="$tmp"     # or cd "$tmp" && dn pub get
dngo prebuild --project="$tmp"
grep RECORD_AUDIO "$tmp/android/app/src/main/AndroidManifest.xml"
```

If `plugins:` is missing from the prebuild output, the usual causes are:

- `dn pub get` was not run, so there is no `package_config.json`
- `build_config.dart` is not at the package root or `lib/build_config.dart`
- `name:` in `PluginBuildConfig` does not match the pub package name
- the file does not contain a `PluginBuildConfig(...)` constructor

---

## Related files

| Path | Role |
| :--- | :--- |
| `pkgs/dartnative_go_config/lib/src/plugin_config.dart` | `PluginBuildConfig` API |
| `lib/src/prebuild/plugin_discovery.dart` | Package-graph discovery |
| `lib/src/prebuild/native_generator.dart` | Manifest / plist apply and removal |
| `test/unit/plugin_discovery_test.dart` | Discovery and apply tests |

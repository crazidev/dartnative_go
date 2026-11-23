# App Configuration (`dartnative.yaml`)

Status: **design proposal, not implemented.** This page specifies an
Expo-style project configuration file and a `dn prebuild` command that applies
it to the generated `ios/` and `android/` folders, including permissions that
plugins contribute by default.

The tool-side implementation belongs to the `dn` SDK
(`packages/flutter_tools`), not to `dartnative_go`; the paths below are given
relative to that repo. `dartnative_go` is listed only where it consumes the
same values today (the dev server's icon/splash preview).

---

## 1. What exists today

There is no project-level app config. The only files any `dn` command reads
are `pubspec.yaml`, `l10n.yaml`, `build.yaml`, `pubspec_overrides.yaml` and
the code-push manifests.

| Concern | Current mechanism | Evidence |
| :--- | :--- | :--- |
| Display name | `{{projectName}}` / `{{titleCaseProjectName}}` at create time | `templates/app/android.tmpl/app/src/main/AndroidManifest.xml.tmpl`, `templates/app/ios.tmpl/Runner/Info.plist.tmpl` |
| Bundle id / `applicationId` | `--org` + `--project-name` at create time | `lib/src/commands/create_base.dart:337-352`, `project.pbxproj.tmpl`, `build.gradle.kts.tmpl` |
| Icon | A script copied into the app, run by hand | `templates/app/tool/generate_app_assets.dart.copy.tmpl` |
| Splash | Top-level `dartnative_splash:` block, compiled plugin tool | `dartnative_splash` `dn run-tool dartnative_splash:setup` |
| Permissions | Only `android.permission.INTERNET` in the template | `AndroidManifest.xml.tmpl:4-6` |
| Assets / fonts | `pubspec.yaml` `dartnative:` section | `lib/src/flutter_manifest.dart:73-86`, `_validateFlutter` |

`dartnative_splash:` supports `background_color` (required), `image`
(required), `dark_background_color`, `dark_image`, `ios`, `android` — as read
by the compiled `setup` tool. `dartnative_go` also reads it, but only to serve
`/assets/splash.png` and `/manifest.json` in the dev server
(`lib/src/cli/diagnostics/asset_detector.dart:74-90`).

Two constraints shape the design:

- **`dn create` is already a partial prebuild.** *"If run on a project that
  already exists, this will repair the project, recreating any files that are
  missing"* (`lib/src/commands/create.dart:156-159`). It only writes missing
  files unless `--overwrite` is passed, so it cannot be used to *change*
  values.
- **The `dartnative:` pubspec section is a closed schema.** Unknown keys under
  `dartnative:` or `flutter:` are a hard validation error
  (`_validateFlutter`, `default:` branch). Any new pubspec key must be added
  there first.

---

## 2. Goals / non-goals

**Goals**

1. One checked-in `dartnative.yaml` describes app identity, icons, splash and
   native build settings.
2. `dn prebuild` (re)generates `ios/` and `android/` from it, idempotently.
3. Plugins declare the permissions they need; prebuild merges them with the
   app's config, and the app's config always wins.
4. `dn create` and `dn prebuild` share one applier, so `dn create .` in an
   existing app also brings native folders back in line.
5. No regression for projects without the file.

**Non-goals (this pass)**

- Replacing `pubspec.yaml` for dependencies, assets or fonts.
- Flavor/scheme variants as first-class config (available through raw
  escape hatches).
- Code signing, provisioning profiles, store metadata.
- A `.dart` config. It would need evaluation before `pub get`, cannot be
  validated statically, and hurts tooling/IDE support.

---

## 3. File discovery

`dartnative.yaml` at the project root (next to `pubspec.yaml`). Resolution
order for the project root is the existing one used by every `dn` command: an
explicit positional directory, then `--project`, then the current directory.

Rules:

- Missing file → today's behaviour exactly. No prompts, no errors.
- Present but invalid → hard exit with `file:line` diagnostics.
- Present in a `workspace:` member → an error; only the root app may own one.
- A `dartnative_splash:` block found while `dartnative.yaml` exists → ignored
  with a one-time deprecation warning naming the replacement key.

---

## 4. Schema

```yaml
# dartnative.yaml
app:
  name: Acme                        # display name: android:label, CFBundleDisplayName
  package: acme                     # must equal pubspec `name:`
  bundle_id:                        # string or per-platform map
    ios: com.acme.app
    android: com.acme.app

icon:
  image: assets/icon.png            # >= 1024x1024; alpha composited onto background
  background_color: "#000000"

splash:
  image: assets/splash.png
  background_color: "#000000"
  dark:                             # optional dark variant
    image: assets/splash-dark.png
    background_color: "#101010"

ios:
  deployment_target: "13.0"
  orientations: [portrait, landscape_left, landscape_right]
  permissions:
    camera: "Scan receipts with the camera."
    photo_library: true             # true = use the plugin's default text
    location_when_in_use: false     # false = remove even if a plugin asks
  info_plist:                       # raw passthrough, merged last
    ITSAppUsesNonExemptEncryption: false
  entitlements: {}

android:
  min_sdk: 24
  target_sdk: 35
  compile_sdk: 35
  permissions: [camera, notifications]
  manifest: {}                      # raw passthrough for <application> attributes
```

### Validation rules

| Field | Rule |
| :--- | :--- |
| `app.package` | Dart package name; must equal `pubspec.yaml` `name:` |
| `app.bundle_id` | Reverse-DNS; iOS: `[A-Za-z0-9.-]`, Android: dot-separated Java identifiers |
| `app.name` | Non-empty; written to both platforms |
| `icon.image` / `splash.image` | Existing file, decodable, `>= 1024x1024` for the icon |
| `*_color` | `#RGB`, `#RRGGBB` or `#AARRGGBB` |
| `ios.deployment_target` | `>=` the SDK floor for the bundled engine |
| `android.min_sdk` | `>=` the SDK floor; `min_sdk <= target_sdk <= compile_sdk` |
| permission names | must be a key in the canonical table (§5.3) |
| raw maps | `ios.info_plist` values must be plist scalars/arrays/maps; `android.manifest` keys must be `android:*` attributes |

Anything not listed is rejected — the same closed-schema discipline the
pubspec validator already enforces, so typos surface instead of being silently
ignored.

---

## 5. Permissions

### 5.1 Why a canonical name layer

A plugin should not have to know that iOS wants `NSCameraUsageDescription`
while Android wants `android.permission.CAMERA`, and *iOS also refuses to run
the permission dialog without a purpose string*. Declare once by canonical
name; prebuild expands to the platform-specific artefacts and validates that
every Android runtime permission has its iOS counterpart handled.

### 5.2 Plugin contract

Plugins extend the block they already ship:

```yaml
# dartnative_media_picker/pubspec.yaml
dartnative:
  plugin:
    platforms:
      ios: { ffiPlugin: true }
      android: { package: com.dartnative.media_picker, pluginClass: ... }
    permissions:
      ios:
        NSCameraUsageDescription: "dartnative_media_picker needs the camera to take photos."
        NSPhotoLibraryUsageDescription: "…to pick a photo from your library."
      android:
        - android.permission.CAMERA
        - android.permission.READ_MEDIA_IMAGES
```

`permissions` is a new allowed child of `dartnative: plugin:` in
`_validateFlutter` / `Plugin.validatePluginYaml`. Both spellings are accepted
under `permissions`:

- canonical names (`camera`) — preferred, platform expansion comes from the
  table;
- literal strings (`NSCameraUsageDescription`, `android.permission.CAMERA`) —
  for keys the table does not cover yet.

The default text is used only when the app supplies `true` or omits the entry.
A plugin may not force a permission the user disabled.

### 5.3 Canonical table

| Canonical | iOS Info.plist | Android |
| :--- | :--- | :--- |
| `camera` | `NSCameraUsageDescription` | `CAMERA` |
| `microphone` | `NSMicrophoneUsageDescription` | `RECORD_AUDIO` |
| `photo_library` | `NSPhotoLibraryUsageDescription` | `READ_MEDIA_IMAGES` (33+), `READ_EXTERNAL_STORAGE` (≤32) |
| `photo_library_add` | `NSPhotoLibraryAddUsageDescription` | `WRITE_EXTERNAL_STORAGE` (≤29) |
| `location_when_in_use` | `NSLocationWhenInUseUsageDescription` | `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` |
| `location_always` | `NSLocationAlwaysAndWhenInUseUsageDescription`, `NSLocationAlwaysUsageDescription` | `ACCESS_BACKGROUND_LOCATION` |
| `contacts` | `NSContactsUsageDescription` | `READ_CONTACTS` |
| `calendar` | `NSCalendarsUsageDescription` | `READ_CALENDAR`, `WRITE_CALENDAR` |
| `reminders` | `NSRemindersUsageDescription` | — |
| `motion` | `NSMotionUsageDescription` | `ACTIVITY_RECOGNITION` |
| `bluetooth` | `NSBluetoothAlwaysUsageDescription` | `BLUETOOTH_CONNECT`, `BLUETOOTH_SCAN` |
| `notifications` | — (no plist key) | `POST_NOTIFICATIONS` (33+) |
| `tracking` | `NSUserTrackingUsageDescription` | — |
| `face_id` | `NSFaceIDUsageDescription` | — |

Android entries carry an implicit `android.permission.` prefix; a leading
`android.permission.` is accepted and not doubled. Version-gated permissions
resolve against `android.min_sdk` / `target_sdk`.

### 5.4 Merge algorithm

Resolved once per prebuild, over the plugins `dn pub get` already records in
`.dart_tool/dn_plugins-dependencies` (ios/android lists, so plugins not used on
a platform contribute nothing):

1. Start with the template baseline (`INTERNET` — never removable).
2. For each plugin, in dependency-graph order, add its `permissions` entries.
   First writer wins between plugins; a later plugin adding a *different*
   default string for the same key logs a conflict naming both plugins.
3. Apply `ios.permissions` / `android.permissions` from `dartnative.yaml`:
   - string → overrides any default text (iOS) or adds the Android permission;
   - `true` → keep the plugin default; error if no plugin asked for it (unless
     a literal key, where `true` means "present with empty text" → error for
     iOS: a purpose string is mandatory);
   - `false` / `null` → remove, including a plugin default. Removing a
     permission a plugin's native code calls is allowed but warned.
4. Apply raw escape hatches (`ios.info_plist`, `android.manifest`) last.
5. Print a report: `permission: source (plugin|app) → iOS key / Android perm`,
   plus any removal or conflict, and fail on:
   - an Android runtime permission with no iOS purpose string where the table
     maps one;
   - an iOS purpose string that is empty.

---

## 6. Prebuild semantics

`dn prebuild` resolves config → permissions → generates/patches native files.

### 6.1 Two paths

- **Generation** (folder or file missing, or `--clean`): render templates with
  the config already in the template context
  (`appDisplayName`, `iosBundleId`, `androidApplicationId`,
  `iosDeploymentTarget`, `androidMinSdk`, …). This is how the pbxproj and
  Gradle files get correct identifiers on the first pass.
- **Patch** (file exists): edit in place with real parsers, never regex, so
  user edits survive:
  - `Info.plist` → `globals.plistParser` (already a `flutter_tools`
    dependency);
  - `AndroidManifest.xml` → `package:xml` 6.6.1 (already a dependency);
  - `project.pbxproj` / `build.gradle.kts` → the existing targeted setters used
    by `migrate` commands, not text substitution.

The patch path is what makes `dn create .` (repair) agree with `dn prebuild`.

### 6.2 Ownership

`dn prebuild` writes `.dartnative/prebuild.json`:

```json
{
  "version": 1,
  "configHash": "…",
  "files": { "ios/Runner/Info.plist": "sha256:…", "…": "…" }
}
```

- `--clean` deletes only files whose *current* hash still matches the recorded
  one, then regenerates. A file the user edited is kept and patched.
- Nothing outside the recorded set is ever deleted. Hand-written native code in
  `ios/Runner/*.swift` and `android/.../*.kt` is safe by construction.
- Without `--clean`, prebuild is a no-op when `configHash` matches, so it is
  cheap to run from a build hook.

### 6.3 What prebuild never does

- `dn pub get` / dependency resolution (call it if the native plugin set
  changed, or tell the user to).
- Signing, provisioning, `Podfile.lock` edits, `pod install`.
- Touch `lib/`, `assets/` or `test/`.

---

## 7. Icon and splash generation

Folded into prebuild so no per-project script is needed:

- iOS icon: a single opaque 1024×1024 `AppIcon.appiconset/AppIcon.png` plus
  `Contents.json` (Xcode ≥14 generates the variants). Alpha is composited onto
  `icon.background_color` and dropped, because `actool` rejects alpha.
- Android icons: `ic_launcher.png` at mdpi…xxxhdpi; adaptive
  `ic_launcher_foreground.png` (logo at 66/108 dp) and
  `ic_launcher_monochrome.png`; `values/ic_launcher_background.xml`;
  `mipmap-anydpi-v26/ic_launcher.xml`.
- Splash: the existing `dartnative_splash` outputs (iOS `LaunchImage*` /
  `LaunchBackground` / `LaunchScreen.storyboard`; Android `drawable-*/splash.png`
  and `android12splash.png`), fed from `splash:` instead of pubspec.

Implementation options for the image work:

1. **Add `package:image` to `flutter_tools`** (currently only in the app
   template's `dev_dependencies`). Self-contained `dn prebuild`; build-time
   cost only, no app-size impact. *Recommended.*
2. Keep delegating to a project script / `dn run-tool`. Smaller diff, but the
   user still maintains a script and the icon path stays split from splash.

Either way the algorithms already exist in
`templates/app/tool/generate_app_assets.dart.copy.tmpl` and are lifted, not
rewritten.

---

## 8. Command surface

```sh
dn prebuild                      # apply dartnative.yaml; no-op if unchanged
dn prebuild --clean              # regenerate pristine native folders
dn prebuild --platforms=ios      # one platform only
dn prebuild --verbose            # per-file decisions and permission report
dn create . --platforms=ios,android   # unchanged CLI; now also applies config
```

`dn create` keeps its flags for new projects; when `dartnative.yaml` exists,
its values override the flags for anything both describe, and it runs the same
applier afterwards.

`dn doctor` gains a section: unresolved/invalid config, permissions a plugin
needs but the config removed, icon/splash missing or too small, bundle id
mismatch between config and native files.

---

## 9. Backwards compatibility

- No `dartnative.yaml` → no behaviour change.
- `dartnative_splash:` deprecation: `dn prebuild` reads it if `splash:` is
  absent, prints a migration note with both spellings, and keeps working. It
  is removed no earlier than the next major version.
- **Shipped today:** `AssetDetector` reads icon/splash from `dngo.config.dart`
  first (see [Prebuild](prebuild.md)), then `dartnative_splash:` / conventional
  paths — so the dev-server preview and native prebuild agree. The
  `dartnative.yaml` shape below remains a longer-term SDK proposal.
- Adding `permissions` under `dartnative: plugin:` is additive; older `dn`
  versions must tolerate it. `_validateFlutter` in the *current* SDK would
  reject it, so the key must ship in the same release that documents it.

---

## 10. Implementation plan

Ordered so each step is independently testable and shippable.

| # | Change | Files (`packages/flutter_tools`) |
| :--- | :--- | :--- |
| 1 | Config model, parse, validate, schema errors | `lib/src/dartnative/app_config.dart` (new) |
| 2 | Canonical permission table + expansion | `lib/src/dartnative/permissions.dart` (new) |
| 3 | Allow `permissions` in plugin manifests; carry it on `Plugin` | `lib/src/flutter_manifest.dart` (`_validateFlutter`), `lib/src/plugins.dart` |
| 4 | Merge engine + report | `lib/src/dartnative/permission_merge.dart` (new) |
| 5 | Template context from config | `lib/src/commands/create_base.dart:306-352`, `templates/app/**` (`Info.plist.tmpl`, `AndroidManifest.xml.tmpl`, `project.pbxproj.tmpl`, `build.gradle.kts.tmpl`, `pubspec.yaml.tmpl` comments) |
| 6 | Patch path (plist / XML / pbxproj / Gradle) | `lib/src/dartnative/native_patch.dart` (new) |
| 7 | Ownership manifest + `--clean` | `lib/src/dartnative/prebuild_manifest.dart` (new) |
| 8 | `dn prebuild` command, registered | `lib/src/commands/prebuild.dart` (new), `lib/src/runner/flutter_command_runner.dart` |
| 9 | `dn create` calls the applier | `lib/src/commands/create.dart:runCommand` |
| 10 | Icon + splash generation | `lib/src/dartnative/assets_generator.dart` (new), `pubspec.yaml` (+`image`) |
| 11 | Doctor checks | `lib/src/dartnative/app_config_doctor.dart` (new), `lib/src/commands/doctor.dart` |
| 12 | `dartnative_go` preview reads `splash:` from the new file | `lib/src/cli/diagnostics/asset_detector.dart` |
| 13 | Docs + template README | `templates/app/README.md.tmpl`, `docs/` |

Steps 1–4 and 8 are the core; 5–7 are what make output correct; 9–10 make it a
one-command workflow.

### Testing

- Unit: schema accept/reject table; permission expansion per SDK level; merge
  precedence (plugin < app < raw), `false` removal, conflict logging.
- Golden: a fixture project prebuilt twice → byte-identical, `configHash`
  unchanged, no-op second run.
- Idempotency: edit a generated file, rerun → kept and patched; `--clean` →
  restored.
- Compatibility: a project with only `dartnative_splash:` prebuilds and warns;
  a project with no config is untouched.
- Integration: `dn create` in an existing folder with a config produces the
  same files as `dn prebuild --clean`.

---

## 11. Open questions

1. **`app.version`.** Dart requires `version:` in `pubspec.yaml`, so a config
   copy is a second source of truth. Proposal: not supported initially; reuse
   pubspec. Revisit if store builds need per-flavour `+N`.
2. **Where plugin permissions are stored after `dn pub get`.** Reading the
   plugin's `pubspec.yaml` at prebuild time means trusting a file the app may
   not have re-resolved. Alternative: `dn pub get` records the permission
   block in `.dart_tool/dn_plugins-dependencies` (or `module_manifest.json`),
   so prebuild uses exactly what was resolved. *Leaning: record at pub get.*
3. **Per-flavor/per-scheme config.** Out of scope now; the raw escape hatches
   cover single-app needs. Flavours would want `dartnative.yaml` →
   `app.<flavor>` overlays later.
4. **Android 12+ splash coupling.** The splash plugin enforces a 760 px
   safe-zone logo in a 1200×1200 canvas. Confirm whether that rule becomes
   config-driven (`splash.logo_scale`) or stays fixed.

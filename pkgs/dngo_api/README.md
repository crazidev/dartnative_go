# dngo_api

Host runtime API for **DartNative Go** (`dngo`) apps, plugins, and custom shell projects.

With `dngo_api`, you can:

- **Discover and launch projects** — scan local dev servers, manage recent projects, and open `dartnativego://` deep links.
- **Control the active preview** — trigger reloads, return to the launcher, open or customize DevTools, switch themes and runtime modes, toggle verbose logging, and clear the dependency cache.
- **Inspect runtime and session state** — check whether code is running inside `dngo`, read connection/app metadata and SDK/runtime versions, and subscribe to host state changes.
- **Build custom shells** — implement `DartGoHostBinding` to power your own DartNative Go host or launcher UI.

## Installation

Add `dngo_api` to your `pubspec.yaml`:

```yaml
dependencies:
  dngo_api: ^0.1.0
```

Or install it with the DartNative CLI:

```sh
dn pub add dngo_api
```

## Usage

### 1. App Developers

Use `DartGoHost` inside your app to inspect the active preview session, open DevTools, trigger reloads, or toggle host preferences such as theme and verbose logging.

```dart
import 'package:dngo_api/dngo_api.dart';

void inspectSession() {
  // Safe to read anytime (even outside an active host binding):
  print('dngo CLI/shell: ${DartGoHost.dngoVersion}');
  print('DartNative SDK: ${DartGoHost.dartNativeVersion}');
  print('Runtime:        ${DartGoHost.runtimeVersion}');
  print('Previewed:      ${DartGoHost.isPreviewed}');

  if (!DartGoHost.isPreviewed && DartGoHost.binding == null) {
    return; // Running standalone without a DartNative Go host.
  }

  print('App:       ${DartGoHost.appName} (${DartGoHost.appVersion ?? 'unversioned'})');
  print('Server:    ${DartGoHost.serverUrl}');
  print('Connected: ${DartGoHost.isConnected}');
}

Future<void> triggerHostActions() async {
  // Toggle theme (system -> light -> dark -> system) or set explicitly:
  final nextTheme = await DartGoHost.toggleTheme();
  print('Theme is now: $nextTheme');
  await DartGoHost.setTheme('dark');

  // Toggle verbose logging:
  final isVerbose = await DartGoHost.toggleVerbose();
  print('Verbose logging: $isVerbose');

  // Open DevTools, hot-restart the guest, or return to the launcher:
  await DartGoHost.openDevTools();
  await DartGoHost.reload();
  await DartGoHost.goHome();
}
```

---

### 2. Plugin Authors

Plugins can depend on `dngo_api` (pure Dart, zero UI dependencies) to detect when they are running under `dngo`, respect host logging preferences, check SDK/runtime compatibility, and listen for host state changes.

```dart
import 'package:dngo_api/host_api.dart';

class MyPluginDiagnostics {
  late final void Function() _listener;

  /// Whether the app is currently running inside a DartNative Go host.
  bool get isInsideDngo =>
      DartGoHost.isPreviewed || DartGoHost.binding != null;

  /// Safe to call anywhere—does not require an active host binding.
  Map<String, String> versionMetadata() => {
        'dngoVersion': DartGoHost.dngoVersion,
        'runtimeVersion': DartGoHost.runtimeVersion,
        'dartNativeVersion': DartGoHost.dartNativeVersion,
      };

  void attach() {
    if (!isInsideDngo) return;

    _syncVerboseFlag();
    _listener = _syncVerboseFlag;
    DartGoHost.addListener(_listener);
  }

  void detach() {
    if (!isInsideDngo) return;
    DartGoHost.removeListener(_listener);
  }

  void _syncVerboseFlag() {
    if (DartGoHost.verbose) {
      print('[MyPlugin] Verbose mode enabled on ${DartGoHost.appName}');
    }
  }
}
```

> [!NOTE]
> Calling bound members (such as `DartGoHost.verbose`, `DartGoHost.discover()`, or `DartGoHost.addListener(...)`) when neither an active `DartGoHostBinding` nor the `dngo` runtime bridge is present throws a `StateError`. Guard calls with `DartGoHost.isPreviewed || DartGoHost.binding != null` in plugins that also run in standalone builds.

---

### 3. Shell Projects & Custom Launchers

Shell projects can use `dngo_api` in two ways:

- **Consuming the host API** from a custom launcher or DevTools UI (discovering servers, launching projects, managing runtime modes and dependency cache, or claiming DevTools).
- **Providing a host implementation** by implementing `DartGoHostBinding` and registering it with `DartGoHost.bind(...)`.

#### Driving the shell from a custom launcher or DevTools UI

```dart
import 'package:dngo_api/host_api.dart';

Future<void> launchFromScanner() async {
  // Discover local dev servers and read cached snapshots:
  final found = await DartGoHost.discover();
  final recents = DartGoHost.recentProjects;

  if (found.isNotEmpty) {
    await DartGoHost.openProject(found.first);
  } else if (recents.isNotEmpty) {
    await DartGoHost.openWithLink('dartnativego://open?url=${recents.first.url}');
  }
}

Future<void> manageRuntimeAndCache() async {
  print('Available modes: ${DartGoHost.runtimeModes}');
  print('Active mode:     ${DartGoHost.runtimeModeLabel}');
  await DartGoHost.cycleRuntimeMode();

  print('Dep cache: ${DartGoHost.dependencyCacheLabel}');
  await DartGoHost.clearDependencyCache();
}
```

If your custom UI renders its own DevTools overlay during a preview, claim ownership on mount and release it on dispose so the shell hides its built-in DevTools pill:

```dart
Future<void> onCustomDevToolsMounted() => DartGoHost.claimDevTools();
Future<void> onCustomDevToolsDisposed() => DartGoHost.releaseDevTools();
```

#### Implementing `DartGoHostBinding` in a host shell

```dart
import 'package:dngo_api/host_api.dart';

class MyShellBinding implements DartGoHostBinding {
  @override
  Future<List<DartGoProject>> discover() async => const [];

  @override
  Future<List<DartGoProject>> refresh() async => const [];

  // Implement remaining DartGoHostBinding members...
}

void startShell(DartGoHostBinding binding) {
  DartGoHost.bind(binding);
}

void stopShell(DartGoHostBinding binding) {
  DartGoHost.unbind(binding);
}
```

---

## API Reference

### `DartGoHost`

#### Lifecycle & Safe Unbound Members

These members never throw a `StateError` when unbound:

| Member                     | Type                 | Description                                                                                |
| :------------------------- | :------------------- | :----------------------------------------------------------------------------------------- |
| `binding`                  | `DartGoHostBinding?` | The active host binding, or `null` if none is installed.                                   |
| `bind(implementation)`     | `void`               | Installs `implementation` as the process-wide `DartGoHostBinding`.                         |
| `unbind([implementation])` | `void`               | Clears the active binding (or only if it matches `implementation`).                        |
| `isPreviewed`              | `bool`               | `true` when running as a guest previewed inside the `dngo` host bridge; `false` otherwise. |
| `dngoVersion`              | `String`             | DartNative Go CLI / shell version (`kDartGoVersion`).                                      |
| `runtimeVersion`           | `String`             | DartNative Go mobile runtime version (`kDartGoRuntimeVersion`).                            |
| `dartNativeVersion`        | `String`             | DartNative SDK version this release was built against (`kDartNativeVersion`).              |

#### Project Discovery & Navigation

| Member                   | Type                          | Description                                                    |
| :----------------------- | :---------------------------- | :------------------------------------------------------------- |
| `discover()`             | `Future<List<DartGoProject>>` | Ensures discovery is running and returns known projects.       |
| `refresh()`              | `Future<List<DartGoProject>>` | Forces a network rescan and returns discovered projects.       |
| `projects`               | `List<DartGoProject>`         | Projects from the latest discovery snapshot (active + recent). |
| `recentProjects`         | `List<DartGoProject>`         | Persisted projects previously opened by the user.              |
| `isScanning`             | `bool`                        | `true` while a network discovery scan is in flight.            |
| `openProject(project)`   | `Future<void>`                | Opens `project` in the host preview route.                     |
| `removeProject(project)` | `Future<void>`                | Removes `project` from the recent/discovered list and storage. |
| `openWithLink(link)`     | `Future<void>`                | Opens a dev server URL or a `dartnativego://` deep link.       |
| `reload()`               | `Future<void>`                | Restarts the mounted guest app.                                |
| `goHome()`               | `Future<void>`                | Pops the preview route and returns to the launcher.            |

#### Appearance, Runtime Mode & Logging

| Member                  | Type             | Description                                                                |
| :---------------------- | :--------------- | :------------------------------------------------------------------------- |
| `theme`                 | `String`         | Current theme preference (`'system'`, `'light'`, or `'dark'`).             |
| `setTheme(mode)`        | `Future<String>` | Sets the theme preference by name (`'system'`, `'light'`, or `'dark'`).    |
| `toggleTheme()`         | `Future<String>` | Cycles `system` -> `light` -> `dark` -> `system` and returns the new mode. |
| `runtimeModeLabel`      | `String`         | Label of the active runtime mode (e.g. `'Source'` or `'AST'`).             |
| `runtimeModes`          | `List<String>`   | Supported runtime mode labels in selector order.                           |
| `setRuntimeMode(label)` | `Future<void>`   | Selects a runtime mode by label.                                           |
| `cycleRuntimeMode()`    | `Future<void>`   | Cycles to the next runtime mode when multiple exist.                       |
| `verbose`               | `bool`           | Whether verbose host logging is enabled.                                   |
| `setVerbose(enabled)`   | `Future<void>`   | Turns verbose host logs on or off.                                         |
| `toggleVerbose()`       | `Future<bool>`   | Toggles `verbose` and returns the new value.                               |

#### DevTools, Session Info, Cache & Listeners

| Member                     | Type           | Description                                                                          |
| :------------------------- | :------------- | :----------------------------------------------------------------------------------- |
| `openDevTools()`           | `Future<void>` | Opens the host DevTools sheet.                                                       |
| `claimDevTools()`          | `Future<void>` | Claims DevTools rendering so the host hides its built-in overlay.                    |
| `releaseDevTools()`        | `Future<void>` | Releases DevTools ownership back to the host.                                        |
| `appName`                  | `String`       | Name of the currently previewed (or last opened) project.                            |
| `appVersion`               | `String?`      | Version reported by the previewed project's manifest, if any.                        |
| `serverUrl`                | `String`       | Dev server URL of the previewed project (empty on the launcher).                     |
| `isConnected`              | `bool`         | Whether the live-reload socket for the previewed project is connected.               |
| `dependencyCacheLabel`     | `String`       | Human-readable on-device dependency cache size (e.g. `'1.2 MB (4 packages)'`).       |
| `clearDependencyCache()`   | `Future<void>` | Clears the on-device dependency cache.                                               |
| `addListener(listener)`    | `void`         | Registers a callback notified when projects, theme, verbose, or runtime mode change. |
| `removeListener(listener)` | `void`         | Unregisters a previously added listener.                                             |

---

### `DartGoProject`

Represents a dev server discovered on the network or opened by the user.

| Member                         | Type                   | Description                                                              |
| :----------------------------- | :--------------------- | :----------------------------------------------------------------------- |
| `appName`                      | `String`               | Display name of the project.                                             |
| `url`                          | `String`               | Dev server base URL.                                                     |
| `isActive`                     | `bool`                 | Whether the project server is currently reachable (defaults to `false`). |
| `appVersion`                   | `String?`              | Optional project version from its manifest.                              |
| `iconUrl`                      | `String?`              | Optional URL to the project's icon asset.                                |
| `toJson()`                     | `Map<String, Object?>` | Serializes the project to JSON.                                          |
| `DartGoProject.fromJson(json)` | `DartGoProject`        | Deserializes a project from a JSON map.                                  |

Equality (`==` and `hashCode`) compares `url` and `appName`.

---

### `version.dart` Constants

| Constant                | Type     | Description                                           |
| :---------------------- | :------- | :---------------------------------------------------- |
| `kDartGoVersion`        | `String` | Current DartNative Go CLI and shell version.          |
| `kDartGoRuntimeVersion` | `String` | Corresponding DartNative Go mobile runtime version.   |
| `kDartNativeVersion`    | `String` | DartNative SDK version the release was built against. |

---

## Runtime Bridging

When code runs inside `dngo`, the host automatically bridges the library URIs listed in `kDartGoHostApiUris` (`package:dngo_api/host_api.dart`, `package:dngo_api/dngo_api.dart`, and `package:dartnative_go/host_api.dart`), forwarding `DartGoHost` and `DartGoProject` calls directly to the active host shell.

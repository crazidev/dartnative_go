# Host UI

The shell app around the interpreted guest.

## Files

| Path | Role |
| :--- | :--- |
| `lib/main.dart` | Product entrypoint: plugins + theme bootstrap, then the shared shell with an AST-only guest runner. Links no analyzer/source runtime, so profile/release compiles stay small. |
| `lib/main_source.dart` | Development entrypoint that also links the Source engine (`tom_d4rt`) and analyzer; use `dn run -t lib/main_source.dart` when testing Source mode. |
| `lib/src/app_shell.dart` | Shared host shell: launcher is the `App` home route; opening a project pushes the preview route; mount/reload/restart orchestration, probe handler. Takes a `GuestRunnerBuilder`. |
| `lib/src/runner/guest_runner.dart` | Host-facing runtime interface + builder typedef implemented by `AstGuestRunner` and `InterpreterRunner`. |
| `lib/src/preview/` | `PreviewScreen` + `PreviewState`: the pushed launch/preview route (splash → mounted guest). Error surfaces are drawn by the shell layer, not here. |
| `lib/src/launcher/` | Launcher route: recent projects, server URL entry, discovery. |
| `lib/src/client/` | Persistence (`ProjectStorage`, `ThemeStorage`, `ErrorDisplayStorage`, `RuntimeModeStorage`), HTTP client, LAN scanner. |
| `lib/src/devtool/` | Floating DevTools button, sheet (verbose, cache, error mode, theme), shake detector. |
| `lib/src/widgets/` | `GuestErrorBanner`, `InterpreterErrorView`, splash, breakpoint overlay. |
| `lib/src/theme/` | shadcn tokens -> `ThemeData`; `themePreferenceProvider`. |

## Routes

- `/` — the launcher (`App.home`). Permanent root; it does not swap its
  child when a project opens.
- `/preview` — pushed by `Navigator.push` when a project is opened. Shows the
  splash while the bundle downloads, then the mounted guest. `Go Home`
  (DevTools / error view) pops back to the launcher.

## Rules

- The preview is its own native screen, so it is **not** rebuilt with the host
  root. The host publishes `PreviewState` through a `ValueNotifier`; the route
  and the DevTools overlay listen to it. Do not re-decide the `App.home` child
  while a route is pushed.
- The floating DevTools surface is the host `App`'s `builder` (see
  `_buildDevToolsOverlay` in `lib/src/app_shell.dart`), a full-screen layer the
  framework lays above every route. It stays reachable while a guest pushes its
  own screens, and as an ordinary widget layer its button receives taps. Do not
  put it inside a route (a route's widgets vanish when the guest pushes the next
  screen).
- **Guest error surfaces live in that same builder layer**, not in the preview
  route — guest-pushed screens sit *above* `/preview`, so a banner/error view
  inside the route would be hidden. Automatic surface is `GuestErrorBanner`;
  `InterpreterErrorView` opens on banner tap (`expanded`), `failedToStart`, or
  persisted full-screen mode. Inserted in `DevToolOverlay` below the floating
  button.
- DevTools button/shake are enabled **only when `PreviewState.isAppMounted`**.
  The overlay stays mounted (Navigator must not reparent); the pill is hidden
  while the full-screen error view is up.
- Host-owned preview app bars (e.g. `InterpreterErrorView`) set
  `automaticallyImplyLeading: false`; guest app bars keep their own leading.
- **Splash settles before evaluation.** `_launchProject` awaits
  `_awaitSplashSettled()` before `initInterpreter` / `evaluateBundle` so the
  UI-isolate evaluation does not freeze the entrance mid-slide.
- **Only restart/launch shows the splash**; hot reload keeps the live tree and
  adds no extra frame. `_restartApp` clears `isAppMounted`, paints splash, then
  evaluates (old tree torn down while its interpreter is still alive).
- **Pre-first-frame failures are load failures** → full-screen
  `InterpreterErrorView` via `_failGuestLoad` (idempotent; drops the broken
  widget). `_guestRendered` flips two frames after publish.
- **Post-render blank builds keep the banner**; proxies report via
  `onGuestBlankBuild` then `onGuestError`. Tap opens the details view.
- **Recovery is not optimistic**: clear only on `onGuestRecovered`, or remount +
  two clean frames for stateless proxies. Failed reloads never clear a hard
  error. Blank proxies report once per distinct message.
- **Reloads copy `late` field values, not `LateVariable` wrappers**
  (`_transferStateFields` unwraps `.value`; uninitialized late without an
  initializer is skipped).
- **Actions**: Home pops guest routes then `/preview`. DevTools Reload restarts
  to root. Error-view Reload again hot-reloads the failing screen in place when
  mounted. Match `popUntil` with `ModalRoute.withName('/preview')` + `isFirst`
  — DartNative passes synthetic routes, not `PageRoute`.
- **One formatter** (`guest_error_format.dart`): `formatGuestError`,
  `summarizeGuestError`, `parseStackFrames`, `buildCopyText`, `logGuestError`.
  Store `PreviewState.errorMessage` + `errorType` (never raw `toString()`);
  add new host prefixes to `_kErrorNoisePrefixes`. The error view never logs.
- **`InterpreterErrorView`**: title is always "Unhandled Exception"; type or
  stage fills the subtitle. Stack is one horizontal scroll (`#N` gutter +
  member/location); theme colours, no per-row scroll views (they clip).
- **One theme, resolved inside the App tree.** `DartNativeGo.build` gives
  `App` `theme`/`darkTheme`/`themeMode` (native chrome + `Theme.of`), and every
  shell surface wraps in `ShellThemeScope`
  (`lib/src/theme/theme_providers.dart`): the launcher (`home`), the pushed
  preview route, and the DevTools overlay layer (`App.builder`). The scope reads
  `MediaQuery.platformBrightness` **inside `build`**, resolves `system` to a
  concrete light/dark mode (`resolveAppearance`) and hands that to
  `ShadcnTheme` — never `system`, and never a cached brightness.
  - The framework reads metrics from the platform *during a build*, so a value
    comparison cannot detect a device-theme change. The scope therefore forces a
    rebuild every 500 ms **while `system` is selected** (the poll stops for
    explicit modes) and rebuilds on `didChangePlatformBrightness`.
  - **Never pass `brightness:` to a `Scaffold`** in the shell: a Scaffold forces
    that brightness onto its subtree, so descendants and pushed routes read a
    pinned `MediaQuery` and the shell stops observing the device.
  - Never hoist `ShadcnTheme` above `App` (there is no MediaQuery up there).
  - Every pushed route needs its own scope: a native route is a separate screen
    and inherits nothing. `ThemeController` hydrates from `ThemeStorage` when its
    cache is cold rather than defaulting to `system`.
- Settings storages (`ThemeStorage`, `ErrorDisplayStorage`,
  `RuntimeModeStorage`) share one pattern; new settings should follow it.
- Error display is a persisted mode: overlay banner (default) or full screen.
- Theme tokens live in `tool/shadcn_tokens.css`; regenerate
  `shadcn_theme.dart` with `tool/shadcn_to_dart.dart`, never hand-edit.

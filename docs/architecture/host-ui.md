# Host UI

The shell app around the interpreted guest.

## Files

| Path | Role |
| :--- | :--- |
| `lib/main.dart` | Host root: launcher is the `App` home route; opening a project pushes the preview route; mount/reload/restart orchestration, probe handler. |
| `lib/src/preview/` | `PreviewScreen` + `PreviewState`: the pushed launch/preview route (splash → mounted guest → error surfaces). |
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
  `_buildDevToolsOverlay` in `lib/main.dart`), a full-screen layer the framework
  lays above every route. It stays reachable while a guest pushes its own
  screens, and as an ordinary widget layer its button receives taps. Do not put
  it inside a route (a route's widgets vanish when the guest pushes the next
  screen).
- Because `/preview` is pushed above `/`, the framework adds an automatic
  leading back chevron to any app bar on it. Host-owned preview app bars (e.g.
  `InterpreterErrorView`) set `automaticallyImplyLeading: false` and provide
  their own actions; a guest app's own app bar keeps whatever leading the guest
  draws (the host cannot change guest code).
- Settings storages (`ThemeStorage`, `ErrorDisplayStorage`,
  `RuntimeModeStorage`) share one pattern; new settings should follow it.
- Error display is a persisted mode: overlay banner (default) or full screen.
- Theme tokens live in `tool/shadcn_tokens.css`; regenerate
  `shadcn_theme.dart` with `tool/shadcn_to_dart.dart`, never hand-edit.

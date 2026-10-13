# Host UI

The shell app around the interpreted guest.

## Files

| Path | Role |
| :--- | :--- |
| `lib/main.dart` | App root, mount/reload/restart orchestration, probe handler. |
| `lib/src/launcher/` | Launcher screen: recent projects, server URL entry, discovery. |
| `lib/src/client/` | Persistence (`ProjectStorage`, `ThemeStorage`, `ErrorDisplayStorage`, `RuntimeModeStorage`), HTTP client, LAN scanner. |
| `lib/src/devtool/` | Floating DevTools button, sheet (verbose, cache, error mode, theme), shake detector. |
| `lib/src/widgets/` | `GuestErrorBanner`, `InterpreterErrorView`, splash, breakpoint overlay. |
| `lib/src/theme/` | shadcn tokens -> `ThemeData`; `themePreferenceProvider`. |

## Rules

- Settings storages (`ThemeStorage`, `ErrorDisplayStorage`,
  `RuntimeModeStorage`) share one pattern; new settings should follow it.
- Error display is a persisted mode: overlay banner (default) or full screen.
- Theme tokens live in `tool/shadcn_tokens.css`; regenerate
  `shadcn_theme.dart` with `tool/shadcn_to_dart.dart`, never hand-edit.

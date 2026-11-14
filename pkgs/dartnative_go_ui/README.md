# dartnative_go_ui

The host launcher and DevTools, extracted so they can be previewed without a
native rebuild.

The widgets call `package:dartnative_go_api` (`discover`, `refresh`,
`openProject`, `openWithLink`, `toggleTheme`, `openDevTools`, `verbose`,
`reload`, `goHome`). The shell embeds this package as its home screen and
bridges the same API, so an interpreted copy drives the real host.

## Preview without a native build

The host app must already be installed (a build that includes this API).
Then, from this directory:

```sh
dart_go start
```

Open that server from the host launcher (or let auto-connect pick it up).
Edits to this package hot-reload inside the host. Theme, discovery, open,
verbose, reload, and go-home buttons call the shell — they are not fake
callbacks.

## DevTools

`HostDevToolButton` (floating pill) and `HostDevToolSheet` (native bottom
sheet) live in `lib/src/devtool/` and are exported from
`package:dartnative_go_ui/dartnative_go_ui.dart`.

- `HostLauncher` renders the pill and opens the sheet only when it runs as a
  previewed guest; the shell's home route shows no pill, as before. Host
  actions (rescan, theme, mode, verbose, cache, reload, home) live there
  instead of the app-bar menu.
- A previewed copy reads `DartGoHost.isPreviewed == true`, renders its own
  pill, and calls `claimDevTools()`, so the shell hides its own overlay and
  only this editable copy is on screen.
- On teardown the guest calls `releaseDevTools()` and the shell overlay comes
  back for the next project.
- The shell's `DevToolOverlay` still serves guest projects that do not contain
  this package (their only DevTools).

Editing these files while previewing hot-reloads the DevTools UI itself.

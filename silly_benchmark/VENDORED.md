# Vendored: dn-silly-benchmark

Upstream: <https://github.com/Chinmay-KB/dn-silly-benchmark>
Vendored commit: `5eaec14` (2026-11-28)

The bouncing-balls benchmark is kept here as a second headless fixture, beside
`playground/`: where the playground proves *breadth* (every first-party plugin,
43 routes), this proves *depth* — a guest that keeps its own frame clock alive,
reads `ProcessInfo.currentRss` every 500 ms and calls `clock()` through
`dart:ffi` to compute CPU%.

## Changes from upstream

Only what is needed to run it in this repo:

| File | Change | Why |
| :--- | :--- | :--- |
| `pubspec.yaml` | `environment.sdk` widened from `^3.12.0-192.0.dev` to `>=3.9.0 <4.0.0` | match the SDK this repo builds against, so `dn pub get` resolves here |
| `dn_plugins.lock` | rewritten by `dn pub get` (records DartNative 1.8.0) | normal side effect of resolving against the installed SDK |

`lib/`, `assets/`, `ios/` and `android/` are untouched.

## Running it

```sh
cd silly_benchmark && dn pub get
dngo start --project=silly_benchmark          # dev server, hot reload
dn test test/silly_benchmark                  # headless coverage, both engines
```

Headless coverage lives outside this directory, in
`test/silly_benchmark/` — the app itself stays a faithful copy of upstream.

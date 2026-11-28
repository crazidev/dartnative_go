# dn_silly_benchmark

A demo that tries to replicate [this bouncing balls benchmark](https://x.com/mrousavy/status/2126035597626318927) with [DartNative](https://github.com/DartNative/dartnative). My finding: [this post](https://x.com/ChinuKabi/status/2126419148515516854).

Every ball is a real native view (a `UIView` on iOS, a `View` on Android), not a drawing on a canvas. Tap **+50 balls** to add balls and watch the frame rate, CPU and missed frames in the panel at the top.

## Run

Use a real phone and a release build. Debug numbers mean nothing.

```sh
dn pub get
dn run --release
```

## Findings

All runs were on an iPhone 12 (60 Hz), release build.

- **Adding views to one big parent is the slow part.** With every ball in a single `Stack`, each frame that adds balls costs about 0.23 µs × N², where N is the number of balls already there. Ramping to 1000 balls over 30 s, the frame rate fell to 20 fps at 360 balls, 7 fps at 680 and 4 fps at 1000. CPU stayed near 100%, and 1076 frames were missed. Giving the balls keys made no difference.
- **Moving views is cheap.** Once nothing is being added, 1000 to 1500 balls hold 60 fps at about 38% CPU.
- **Grouping fixes it.** Putting the balls in small `Stack`s of 50 keeps each parent small. The same 1000-ball ramp then held 60 fps the whole way, with 0 missed frames and a peak CPU of 47%.
- **Memory stays low.** RSS was about 70 MB with 1000 balls.

## The panel

| Field | What it is |
|---|---|
| BALLS | Number of ball views on screen |
| FPS | Display frames per second |
| CPU | Process CPU time over wall time. It can go past 100% on a phone with several cores. |
| RSS | Resident memory. This is not the "footprint" number Xcode shows. |
| MISSED | Frames the display wanted and the app did not deliver |

Every half second the app also logs a CSV line: `[bench] t_s,balls,fps,cpu_pct,rss_mb,missed_total,refresh_hz`. A release build does not print it to the `dn run` console. On iOS, read it with `idevicesyslog -u <udid> | grep '\[bench\]'`; on Android, use `adb logcat | grep '\[bench\]'`.

## License

MIT. See [LICENSE](LICENSE).

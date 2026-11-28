# Silly benchmark (headless fixture)

The upstream [`Chinmay-KB/dn-silly-benchmark`](https://github.com/Chinmay-KB/dn-silly-benchmark)
app is vendored under `silly_benchmark/` (provenance and local changes in
[`silly_benchmark/VENDORED.md`](../../silly_benchmark/VENDORED.md)). It is the
bouncing-balls benchmark: every ball is a real native view in a `Stack`,
positioned by a `Ticker`, with a HUD that reports frame rate, CPU, RSS and
missed frames.

Where `playground/` proves breadth — every first-party plugin, 43 routes, both
engines — this proves *depth*: a guest that owns its own frame clock and probes
the host process.

Run it with:

```sh
dn test test/silly_benchmark
```

## What the suites prove

| Suite | Engine | Tests |
| :--- | :--- | :--- |
| `silly_benchmark_headless_test.dart` | `tom_d4rt_ast` | boot, screen build (HUD + controls + arena), arena layout, metrics clock, ball construction |
| `silly_benchmark_source_test.dart` | `tom_d4rt` | boot, screen build, metrics clock |

`initState` runs before `build`, as in the playground suite, because the screen
starts its metrics there. Each mounted screen is disposed afterwards: the
benchmark starts a `Timer.periodic` and a `Ticker` in `initState`, and a
mounted-but-undisposed screen would keep the test process alive.

## What it exercises that `playground/` does not

### `dart:ffi`

The guest opens `DynamicLibrary.process()` and looks up `clock()` to compute
CPU%:

```dart
final clock = ffi.DynamicLibrary.process()
    .lookupFunction<ffi.Long Function(), int Function()>('clock');
```

Neither engine could load a module importing `dart:ffi` before this fixture
arrived: the interpreter cannot express a *native* function type, so the loader
rejected the library outright. In the source engine that rejection happens at
module load, before the guest's `try`/`catch` can run, so the whole
`bench/metrics.dart` module was unloadable.

`third_party/{tom_d4rt,tom_d4rt_ast}/lib/src/**/stdlib/ffi.dart` fixes it:

- `DynamicLibrary` is bridged for real — `process()`, `open()` and
  `executable()` return the host library.
- `lookupFunction` maps the guest's type argument onto a real
  `lookupFunction<NativeT, DartT>`. The guest's type arrives as a
  `FunctionRuntimeType` with resolved names, so `ffi.Long Function()` is
  recognisable. A fixed signature table covers zero- and one-argument functions
  returning `int` / `double` / `bool` / `void`; anything else throws
  `UnsupportedError` **at call time**, which a guest that guards its FFI use
  (as this one does) simply catches.
- The `dart:ffi` type names a signature can mention (`Long`, `Int32`, `Pointer`,
  `NativeFunction`, …) are registered so annotations and type arguments resolve.

The suites assert CPU% is a real number, not `na`, which proves the lookup
reached the host `clock()` on both engines.

### `ProcessInfo`

`BenchMetrics` reads `ProcessInfo.currentRss` every sample. The `dart:io`
bridge for it was added for the playground's memory readout; here it is
load-bearing for the RSS column, and the suites assert it is non-zero.

### A guest-owned frame clock

`DartNativePerformance.addFrameTimingCallback` + `Timer.periodic` from
`initState`, and `Ticker(callback)..start()` constructed directly rather than
through `TickerProvider`. `BallArena` is the first fixture that does the latter.

## Known limit

`BallArena._tick` guards on `mounted`, and a state mounted outside an element
tree is never mounted, so the headless suites cannot drive the bounce loop.
They cover the ball *factory* (`_newBall` builds a circular native view) and the
metrics pipeline instead. Driving the loop needs a real element tree, which the
harness does not provide; on a device the app runs the loop normally.

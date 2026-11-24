# Playground headless coverage

The upstream [`DartNative/dartnative` `playground/`](https://github.com/DartNative/dartnative/tree/main/playground)
app is the reference DartNative application: ~100 modules, five tabs and 43
registered routes, touching every first-party plugin. `playground/` is vendored
here as a fixture so the interpreter can be exercised against real app code
instead of toy snippets.

Run it with:

```sh
dn test test/playground/playground_headless_test.dart
```

## What the suite proves

| Test | What runs |
| :--- | :--- |
| `boot` | The real `lib/main.dart`: plugin registrant, Skia factories, `Sqlite.ensureInitialized`, Firebase + notifications setup (both caught), ~43 `registerRoutes` calls, the SharedPreferences-backed theme restore, `runApp`. Asserts the shell mounts and the routes were captured. |
| `routes` | Every captured route is built through its `WidgetBuilder` (proving the interpreted-closure → native-builder coercion) and the screen's `build(context)` runs. |
| `tabs` | The shell's `build` runs, the five tab bodies are reached from its tree, and each one builds. |

Both engine paths are analyzer-free (`tom_d4rt_ast`, the engine `kUseAst`
selects on device). Native-only plugins are shadowed by host fakes installed
through `DnHarness.astBridgeOverrides` — the same policy the per-plugin suites
use: the fake proves bridge wiring + guest logic, the real FFI call needs a
device.

## Results

- **boot**: passes. The shell mounts with only a `SharedPreferences` host fake.
- **routes**: 32/43 build. The 11 that do not are listed in `_knownGaps` in the
  suite with the missing capability; anything outside that list fails the test.
- **tabs**: all five tab bodies build.

### Known gaps (runtime capability, not playground bugs)

| Symptom | Missing capability | Affected |
| :--- | :--- | :--- |
| `AnimationController(vsync: this)` → `expected TickerProvider?, got InterpretedInstance(_…State)` | `TickerProvider` interface proxy for interpreted states using `SingleTickerProviderStateMixin` | `/chatgpt-picker`, `/stickers-keyboard` |
| `CustomPaint(painter: …)` / `CanvasSurface(painter: …)` → `expected CustomPainter?` | `CustomPainter` interface proxy | `/live-text`, `/text-rendering`, `/canvas` |
| `Bridged class 'Signal' has no instance method named 'watch'` | `riverpod_kit` `Signal.watch` is not in the bridged surface | `/state-store` |
| `Late variable '_tab' … accessed before being assigned` | the field is assigned in `initState()`; this suite builds without mounting | `/storage-*` (4 routes) |
| `type 'dynamic Function()' is not a subtype of 'VoidCallback'` | callback coercion for closures inside a collection literal | `/material3-badges` |

## What was added to make this run

### Plugins and bridges

`pubspec.yaml` gained the first-party plugins the playground imports
(`dartnative_skia`, `_sqlite`, `_secure_storage`, `_hive`, `_social_sign_in`,
`_firebase`, `_video_player`, `_audio`, `_permissions`, `_camera`,
`_image_crop`, `_compressor`, `_supertonic_tts`, `_lottie`, `_onnxruntime`).
`buildkit.yaml` and `buildkit_ast.yaml` gained the matching modules, and both
bridge sets were regenerated (`dart run tool/d4rtgen.dart`,
`dart run tool/d4rtgen_ast.dart`).

`kAstBridgedLibraries` (`lib/src/cli/packaging/ast_builder.dart`) now lists
every plugin URI plus `package:dartnative/canvas.dart`, so the bundler leaves
them to the bridges instead of trying to parse native shells.

`package:dartnative/canvas.dart` is not re-exported by `dartnative.dart`, so the
generated bridge set never registered it. `kDartNativeSubBarrelUris`
(`lib/src/interpreter/dartnative_sub_barrels.dart`) plus
`registerDartNativeSubBarrels` / `registerAstDartNativeSubBarrels` register the
UI surface under that URI for both engines.

### Host-side bridges for native-binding calls

Three guest-visible entry points had no host implementation, so any app using
them could not boot headless:

- `runZonedGuarded` (`lib/src/interpreter/zoned_guarded_bridge.dart`) — zones
  are deliberately unbridged, so the bridge keeps the catch-and-report contract
  and ignores the zone plumbing.
- `registerRoutes` (`lib/src/interpreter/routes_bridge.dart`) — captures the
  table in `D4rtRoutes` and coerces each interpreted builder into a native
  `WidgetBuilder`. Registered after the generated bridge, so it wins.
- `SharedPreferences` — the existing host fake only had a `tom_d4rt` variant;
  `test/test_lab/fakes/fake_shared_preferences_ast.dart` is the AST-engine
  equivalent.

`DnHarness` gained `astBridgeOverrides` (and `AstInterpreterRunner.runner`) so
fakes can shadow generated AST bridges.

### Interpreter fixes (`pkgs/tom_d4rt_ast`)

Two library-scope semantics gaps blocked the playground's own code:

- **Top-level getters were returned, not invoked.** Reading `kHomeBg` handed
  back the `InterpretedFunction`, so `Container(color: kTileBg)` received a
  function. `visitSimpleIdentifier` now invokes a library-scope getter.
- **A library getter and setter with the same name clobbered each other.** The
  second declaration overwrote the first in the module environment, so
  `playgroundPalette` resolved to the setter function
  (`Cannot access property 'brightness' on function`). Both halves are now kept
  in a `LibraryProperty` (`library_property.dart`): reads invoke the getter,
  assignments invoke the setter.

`wrapAstInterpretedWidget` also learned about `InheritedWidget`: an interpreted
subclass is wrapped by the new `InterpretedInheritedWidget`, and the build
paths in `ast_widget_proxies.dart` prefer the widget-aware wrapper over
`extractBridgedArg<Widget>`. Without it, the shell's own theme wrapper
(`PlaygroundTheme extends InheritedWidget`) failed its parent's build with
`Invalid parameter "buildResult": expected Widget`.

## Source engine (`tom_d4rt`) — separate, pre-existing limits

The suite targets the AST engine because that is what `kUseAst` selects on
device. Probing the same playground through the source engine
(`InterpreterRunner`, `DnHarness(mode: source)`) surfaces two upstream
interpreter gaps that the AST engine does not have. Both are in the `tom_d4rt`
pub package (not vendored here), so they are recorded rather than patched:

| Symptom | Cause |
| :--- | :--- |
| `Unsupported operation: FrozenNameMap is frozen and cannot be mutated` while loading a module | Two playground modules declare a *private* class with the same name (`_SectionHeader`, `_Card`, …). The second module's Pass‑2 re-registers members on the already-frozen imported class object. |
| `Undefined variable: _byLang` (`screens/media/demo_script.dart`) | A `static const` field is referenced by static getters declared *above* it; the source engine does not defer static-field initialisation for that ordering. |

Until those are fixed upstream, source-mode runs of apps with cross-module
private-name collisions or forward static-const references will fail at module
load; AST mode handles both.

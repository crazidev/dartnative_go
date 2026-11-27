# Playground headless coverage

The upstream [`DartNative/dartnative` `playground/`](https://github.com/DartNative/dartnative/tree/main/playground)
app is the reference DartNative application: ~100 modules, five tabs and 43
registered routes, touching every first-party plugin. `playground/` is vendored
here as a fixture so the interpreter can be exercised against real app code
instead of toy snippets.

Run it with:

```sh
dn test test/playground
```

## What the suites prove

| Test | What runs |
| :--- | :--- |
| `boot` | The real `lib/main.dart`: plugin registrant, Skia factories, `Sqlite.ensureInitialized`, Firebase + notifications setup (both caught), ~43 `registerRoutes` calls, the SharedPreferences-backed theme restore, `runApp`. Asserts the shell mounts and the routes were captured. |
| `routes` | Every captured route is built through its `WidgetBuilder` (proving the interpreted-closure → native-builder coercion) and the screen's `build(context)` runs. |
| `tabs` | The shell's `build` runs, the five tab bodies are reached from its tree, and each one builds. |

`playground_headless_test.dart` drives `tom_d4rt_ast` (analyzer-free, the
engine `kUseAst` selects on device) through
`DnHarness.astBridgeOverrides`; `playground_source_headless_test.dart` drives
`tom_d4rt` through `DnHarness.bridgeOverrides`. Native-only plugins are
shadowed by host fakes in `test/test_lab/fakes/` — the same policy the
per-plugin suites use: the fake proves bridge wiring + guest logic, the real
FFI call needs a device.

## Results

Both engine suites build the whole app:

| Suite | Boot | Routes | Tabs |
| :--- | :--- | :--- | :--- |
| `playground_headless_test.dart` (AST) | passes | 43/43 | all five tab bodies build |
| `playground_source_headless_test.dart` (source) | passes | 43/43 | n/a (AST suite owns the tab walk) |

`_knownGaps` in the AST suite is **empty**: anything that fails a route fails
the test, and a route that starts building again must be removed from the map
(the suite asserts the map has no stale entries).

### Runtime capabilities that were missing (all fixed)

| Symptom | Capability | Fixed by |
| :--- | :--- | :--- |
| `AnimationController(vsync: this)` → `expected TickerProvider?, got InterpretedInstance(_…State)` | `TickerProvider` interface proxy | `InterpretedTickerProvider` in both `*_widget_proxies.dart` |
| `CustomPaint(painter: …)` / `CanvasSurface(painter: …)` → `expected CustomPainter?` | `CustomPainter` interface proxy | `InterpretedCustomPainter` in both proxy files |
| `addObserver(this)` → `expected WidgetsBindingObserver, got InterpretedInstance` | `WidgetsBindingObserver` interface proxy | `InterpretedWidgetsBindingObserver` in both proxy files |
| `Bridged class 'Signal' has no instance method named 'watch'` | `Signal.watch` / `Computed.watch` extension | `lib/src/interpreter/state_signal_extensions.dart` |
| `Late variable '_tab' … accessed before being assigned` | `initState` never ran | harness `_render` drives `initState` + `didChangeDependencies` |
| `type 'dynamic Function()' is not a subtype of 'VoidCallback'` | collection-literal callback coercion | already fixed in the vendored 0.260 engine (`FunctionRuntimeType.isSubtypeOf` accepts a bridged function typedef) |
| `Undefined variable: ProcessInfo` | `dart:io` `ProcessInfo` bridge | `stdlib/io/process_info.dart` in both engines |
| `Undefined variable: MediaGalleryFFIBindings` | the generator never emitted this class | `lib/src/interpreter/media_gallery_ffi_bridge.dart` (hand-written, both engines) |

### The three interface proxies

An interpreted subclass of a bridged abstract type has no native
super-object, so a bridge parameter typed as that abstract type rejects it
(`expected CustomPainter?, got InterpretedInstance(_Painter)`). Each proxy
implements the native interface and forwards only the members the guest
actually declares:

- **`InterpretedTickerProvider`** — one registration serves
  `SingleTickerProviderStateMixin` and `TickerProviderStateMixin`, because both
  mixin bridges list `TickerProvider` in their supertypes. The ticker is the
  framework's own `Ticker(onTick)`; only its lifecycle methods are
  platform-patched.
- **`InterpretedCustomPainter`** — `preferredHeight` returns `null` when the
  guest does not override it (the base implementation throws
  `UnimplementedError`, and the widget wants "use the height I was given");
  `shouldRepaint` receives the previous *guest* instance, not the proxy,
  because the parameter is `covariant CustomPainter` and scripts read their own
  fields off it. `super(repaint: …)` is captured through
  `D4.markProxyCapturesSuperArgs('CustomPainter')`, since the abstract base has
  no constructor adapter to run.
- **`InterpretedWidgetsBindingObserver`** — dispatch reads the guest's own
  methods (`InterpretedClass.findInstanceMethod`), never the bridged mixin
  adapter, which would validate against the proxy and call straight back into
  it. Equality is by guest instance so `removeObserver(this)` pairs with the
  proxy `addObserver` kept.

### `Signal.watch`

`Signal<T>.watch(context)` and `Computed<T>.watch(context)` are declared by
`extension SignalWatch<T> on _SignalBase<T>` in `package:dartnative/src/state.dart`.
`_SignalBase` is library-private, so the bridge generator skips the extension:
a generated bridge lives in another library and cannot name the `on` type.
`state_signal_extensions.dart` registers it by hand against the two public
subclasses (`Signal`, `Computed`) — one definition per type, since extension
lookup is nominal on both engines. When there is no element to subscribe (the
headless suite drives `build` on a synthetic context) the adapter falls back to
`.value` instead of failing the build.

### Host fakes

Native-only plugins are shadowed per plugin, in `test/test_lab/fakes/`. Each
fake `implements` the real class, so it stays assignable wherever the generated
bridge and the guest's own fields expect one:

| Fake | Replaces |
| :--- | :--- |
| `fake_shared_preferences.dart` / `_ast.dart` | `SharedPreferences` FFI store |
| `fake_media_gallery_ast.dart` | `MediaGallery` (throws "gallery is not available" on a host) |
| `fake_connectivity_ast.dart` | `Connectivity` / `InternetConnection` (asserts `loadSymbols()` first, inside an async stream listener the guest's `try` cannot see) |
| `fake_audio_player_ast.dart` | `AudioPlayer` (same `loadSymbols()` assertion, reached from the Spotify demo's `initState`) |
| `fake_system.dart`, `fake_notifications.dart`, `fake_local_auth.dart`, `fake_live_activities.dart` | their plugins, source engine |

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

### Interpreter fixes (`third_party/tom_d4rt_ast`)

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

## Source engine (`tom_d4rt`)

`kUseAst` selects the AST engine on device, so that is the primary suite. The
source engine is covered too, by
`test/playground/playground_source_headless_test.dart`: it boots the same app
through `InterpreterRunner` and builds every captured route (43/43). Probing it
surfaced two upstream interpreter gaps the AST engine never had. Both are
**fixed** in the vendored `third_party/tom_d4rt` (1.279.0):

| Symptom (before) | Cause | Fixed in |
| :--- | :--- | :--- |
| `Unsupported operation: FrozenNameMap is frozen and cannot be mutated` while loading a module | Two modules declared a *private* class with the same name (`_SectionHeader`, `_Card`, …). Imports were merged before the declaration pass, so the second module filled in the *imported* (already frozen) class instead of creating its own placeholder. | `tom_d4rt` 1.244.0 — a library's own class, mixin or enum shadows an imported one of the same name (`Environment.holdsImportedTypeDeclaration`). |
| `Undefined variable: _byLang` (`screens/media/demo_script.dart`) | A `static const` referenced by a member declared *above* it failed, because static initializers ran eagerly in declaration order. | `tom_d4rt` 1.233.0 — static and top-level initializers are lazy and may read later declarations. |

`test/unit/tom_d4rt_source_engine_regressions_test.dart` pins both behaviours
through `DnHarness` in source mode.

Booting the real playground through the source engine added two more gaps,
both fixed by patching the vendored engine (listed in its `pubspec.yaml`):

| Symptom | Cause | Fix |
| :--- | :--- | :--- |
| `Failed to load import "dart:developer": Dart library 'dart:developer' not supported` | the source engine had no `dart:developer` registrar (the AST engine did) | ported `stdlib/developer*` from the AST engine and registered it in `ModuleLoader._stdlibRegistrars` |
| `Undefined variable: ProcessInfo` | `dart:io`'s `ProcessInfo` was never bridged | `stdlib/io/process_info.dart`, gated like `Platform` |

The source engine also rejects statically undefined names at module load, so a
guest `try`/`catch` around a missing bridge cannot run — that is how the
`MediaGalleryFFIBindings` gap (see above) surfaced only here.

### Behaviour change that affects fixtures

`tom_d4rt` 1.235.0 made a block body that runs off its end return `null`
(Dart semantics) instead of its last statement's value. A guest `main()` that
relied on the old behaviour — starting async work and letting `runApp` run in a
continuation, as the playground's `runZonedGuarded(...)` entrypoint does — now
returns `null` before `runApp` has run. Both runners therefore wait briefly for
a late `runApp` capture before reporting a missing root
(`AstInterpreterRunner.evaluateAstBundleAs`, `InterpreterRunner.evaluate`).

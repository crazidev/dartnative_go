# Changelog

All notable changes to **DartNative Go** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- **`dio` compiled into the shell (AST + source bridges)**:
  - `dio` 5.x is now a bridged package in `buildkit.yaml` / `buildkit_ast.yaml` (generated `dio_bridges.b.dart`), so a guest importing `package:dio/dio.dart` receives the compiled host `Dio` and no longer interprets dio's request pipeline.
  - `package:dio/dio.dart` was added to `kAstBridgedLibraries` so the dev server skips it while bundling (its conditional `dart:io` / `dart:html` imports are not AST-safe).
- **Separate launcher & preview routes**:
  - The launcher is now the host `App`'s home route (`/`) and no longer swaps its child when a project opens; opening a project pushes a dedicated launch/preview route (`/preview`) that shows the splash then the mounted guest, and `Go Home` pops back.
  - Added `lib/src/preview/preview_route.dart` (`PreviewScreen` + `PreviewState`) driven by a host-owned `ValueNotifier`, so the pushed route stays in sync across launch, hot reload and errors without the root re-deciding its child.
- **DevTools visible across guest navigation**:
  - The floating DevTools surface is now the host `App`'s `builder` (the framework's full-screen layer above every route) instead of living inside a route, so it stays reachable while the guest pushes its own screens — and, unlike a root `Overlay` entry, its button receives taps.
- **Auto-connect on launch (headless testing)**:
  - The launcher now connects to the first online project the network scanner discovers, so the app reaches a mounted guest without a human tap — enabling simulator/CI automation (`dn run` + `tool/ui_test_run.dart`) to drive the app end-to-end.
  - Enabled by default in JIT/debug builds, disabled in AOT product builds; override either way with `--dart-define=DARTNATIVE_AUTO_CONNECT=true|false`. Runs at most once per app process, so returning to the launcher never causes a reconnect loop.
- **AST pure-Dart dependency compatibility**:
  - Added SDK collection-base and map-view bridges needed to interpret `collection` 1.19.1, including the dependency chain pulled in by `equatable` 3.0.0.
  - Expanded AST standard-library support for typed-data list views, conversion-sink aliases, `WeakReference`, and the host `Zone` observation/delegation API.
  - Added an AST runtime regression test exercising `Equatable` equality through the collection dependency.
- **AST initialization profiler**:
  - Added compile-time-gated `D4rtProfiler` setup measurements for bridge/stdlib registration, module-loader creation, and declaration passes. Enable with `--dart-define=D4RT_PROFILE_INIT=true`; it has no instrumentation cost when disabled.
- **AST library part support**:
  - AST mode now interprets a library's `part` files in the owning library environment, preserving shared private-name visibility for generated code such as `build_runner` output.
  - Parent library cache fingerprints include part URIs and content fingerprints so part-only edits reload the owning library.
  - Added regression tests for entrypoint parts, imported-library parts, and part-only cache invalidation.
- **Interpreted Guest Stack Traces**:
  - Implemented interpreted call frame tracking (`InterpretedCallFrame`) in `tom_d4rt_ast`.
  - Added line and column number resolution mapping from AST byte offsets to source code locations.
  - Formatted guest runtime errors to output standard Dart stack traces (`#0 Class.method (package:uri:line:col)`) pointing directly to interpreted guest application code rather than host interpreter internals.
- **Flutter Compatibility Bridge (`package:dartnative/flutter_compat.dart`)**:
  - Generated native and AST bridges (`DartnativeFlutterCompatBridge`) for `package:dartnative/flutter_compat.dart`.
  - Registered bridge in `buildkit.yaml`, `buildkit_ast.yaml`, `tool/d4rtgen.dart`, and `tool/d4rtgen_ast.dart`.
  - Added `package:dartnative/flutter_compat.dart` to `kAstBridgedLibraries` in `ast_builder.dart`.
  - Added `tool/d4rtgen_compat.dart` for isolated single-library bridge generation.
- **VS Code Debug Adapter Protocol (DAP) Server**:
  - Implemented embedded DAP server (`lib/src/dap/`) supporting line breakpoints, variable inspection, paused stack frames, step-in/out/over, and resume controls directly via standard IDE debuggers.
  - Added `--dap` flag in `dart_go start` to expose the DAP service.
  - Added VS Code launch configurations (`.vscode/launch.json`) and automated test coverage (`test/unit/dap_server_test.dart`).
- **Delta AST Patch Protocol (`/guest.ast.patch`)**:
  - Incremental code reloads now generate and transmit lightweight gzip delta AST bundles containing only modified compilation units (~20 KB vs 1.89 MB full bundle, a **99% network payload reduction**).
  - Added `AstBundle.applyPatch(AstBundle patch)` in `tom_d4rt_ast` for zero-allocation in-memory AST merging on device.
  - Reduced device AST JSON deserialization time from ~2,580ms down to **5–7ms** (**368× speedup**).
- **Dot Shorthands in SafeAstConverter**:
  - Added conversion support for `DotShorthandPropertyAccess` and `DotShorthandInvocation` in `SafeAstConverter`.
- **Zero-Manifest Fast-Path**:
  - Code-only reloads bypass `/manifest.json` completely, eliminating 300–500ms of HTTP roundtrip overhead.
  - Automatic asset change detection triggers manifest fetches only when `assets/` modifications occur.
- **Scale-Proof In-Memory DFS & Build Caching**:
  - Incremental DFS seeding in `AstBuilder` enables rebuild times of **12–19ms** across projects with 500 to 2,000+ modules.
  - Warm file hash caching initialized during server cold start.
- **Isolate & Background Compute**:
  - Integrated `IsolateWorker` bridge and stdlib isolate runtime (`isolate_compute_bridge.dart`, `isolate_worker.dart`).
- **Benchmarking & Testing Infrastructure**:
  - Added `tool/scale_inject.dart` to generate and clean synthetic realistic Cupertino modules for scale benchmarking.
  - Added `tool/benchmark_scale.dart` and `tool/benchmark_speed.dart` for automated AST generation and reload latency profiling.

### Changed
- **Intra-Package AST Canonicalization**:
  - `IncrementalAstBundler` now canonicalizes all entrypoints and intra-package imports inside `lib/` to `package:<packageName>/<path>`, eliminating duplicate module loading and table collision bugs.
- Updated `LauncherAppBar` to use context theme background dynamically in `launcher_screen.dart` and `launcher_app_bar.dart`.
- Refactored `LiveConnection` reload event streaming to prevent duplicate bundle fetches on single change triggers.
- Updated `AstBuildWorker` isolate messaging to return `patchBytes` directly across the isolate boundary.
- Enhanced `WidgetGenerationTracker` and `classFileMap` generation for AST module reload precision.

### Fixed
- **Host preview app bars no longer imply a back chevron**: the preview is a pushed route, so the framework adds an automatic leading back button to any app bar on it. The host-owned `InterpreterErrorView` now passes `automaticallyImplyLeading: false` and keeps only its explicit "Back to Home" action. (The guest app's own app bar is guest code; the host cannot change its leading, so the chevron the guest draws there is unchanged.)
- **`Type`-keyed state now survives a hot reload (fixes `get_it` "not registered")**: the Dart VM keeps a class's `Type` object identical across a hot reload, but DartNative rebuilt each `InterpretedClass` every generation (the `ClassCell` only stabilised *dispatch*). A `Map<Type, …>` populated before a reload — e.g. `GetIt`'s registration map, whose singleton is a `static final` that survives — stayed keyed by the old class object and was unreachable afterwards (looked up with the new one), so `getIt<UserRepository>()` threw `Bad state: Object/factory with type <class UserRepository> is not registered inside GetIt` until something re-registered the container. `InterpretedClass` now implements cross-generation `==`/`hashCode` using the same `declarationIdentity` rule the engine already uses for `is`/`as` (`isSameClassAs`), so same-named classes from different libraries stay distinct. Regression test: `test/runner/ast_reload_imported_static_test.dart`.
- **AST viewer profile no longer rebuilt on every frame**: `_withDevTools` reads `AstInterpreterRunner.lastAstProfile` on every widget build, and that getter re-serialized every module's AST to JSON via `buildAstProfile` on each call. With a realistic bundle (e.g. 183 modules once `dio` is added) this pegged the UI isolate at ~100% CPU and made the whole app (scrolling, navigation, probes) take seconds to respond. The snapshot is now memoized and invalidated only when the decoded bundle or the retained timing maps change (per evaluation), turning the per-build cost into a field read.
- **Interpreted `await` no longer starves the embedder's event loop**: async continuations used to be queued exclusively as microtasks, which all drain before the embedder (Flutter) regains control — so a long chain of interpreted `await`s (dio's request pipeline, for example) blocked the UI thread for hundreds of milliseconds to seconds per request. `InterpretedFunction._scheduleStateMachineRun` now slices async work by wall-clock: while one event-loop turn stays under `InterpretedFunction.asyncSliceBudgetMicros` (default 4000µs) continuations keep the cheap microtask fast path, and once the budget is spent the next continuation is deferred to a zero-duration timer turn so a frame can be rendered in between. Measured on the 20-check headless dio sweep: worst event-loop stall dropped from **866ms to 49ms** with unchanged wall time and no check regressions; set the budget to `0` to disable slicing (historical behaviour).
- **Hot reload no longer fails on `dart:developer` service-extension re-registration**: a reload re-runs the guest top level, so any package that registers a service extension (e.g. get_it's `ext.get_it.getRegistrations`) called `registerExtension` again with the same method name, and the host `dart:developer.registerExtension` throws `ArgumentError('Extension already registered: $method')` — surfacing as `Interpreter Error: Invalid argument(s): Extension already registered` on every reload. The stdlib now registers with the host once per method and rebinds its stored handler on repeat registrations (which also keeps dispatch pointing at the freshly-interpreted handler instead of a stale pre-reload one). Regression test: `test/runner/ast_service_extension_reload_test.dart`.
- Fixed AST loading of cyclic pure-Dart imports by publishing type declarations early enough for dependent classes and mixins to resolve.
- Fixed module exports to expose a library's declarations rather than its imports, preventing accidental name conflicts in package barrels.
- Added the missing `Comparator` bridge required by collection's comparator extension.
- Fixed nullable `is` checks for null against user-defined and applied generic types; this unblocks get_it's nullable `_ObjectRegistration<T, dynamic, dynamic>?` lookup check.
- **Interpreter fidelity fixes for pure-Dart packages (surfaced by `dio`)**:
  - `Instance.get` now honours a subclass getter over an inherited/mixin field of the same name, so `InterceptorsWrapper`'s `onRequest`/`onResponse` callbacks dispatch (dio's `_onRequest` getter vs the mixin's `__onRequest` field).
  - Bare-name lookup for static methods and getters now walks mixins and superclasses, so an inherited method can call a static declared further up the chain (`DioMixin`'s `assureDioException` reached from the inherited `fetch`).
  - Async catch clauses now match against the thrown value's runtime type per clause instead of always taking the first clause, so `on FormatException catch (e)` selects the right handler.
  - Top-level class aliases (`typedef Alias = Target;`) now bind in a module's declaration pass, so a bare `Alias(...)` resolves to `Target` — including from a constructor initializer list, which is the only context dio's `MultipartFile` calls `DioMediaType(...)` from.
  - Declared for-in loop variables now get a fresh binding per iteration, preserving each value captured by a closure; for-in loops also accept interpreted `Iterable` implementations through their `iterator` member.
- Interpreted callable instances now dispatch generic `call<T>()` invocations instead of returning the instance itself.
- Preserved enum type compatibility across reloads using library-qualified declaration identity, avoiding self-type mismatches for generic method parameters.
- **FrozenNameMap Mutation Error**:
  - Resolved `Unsupported operation: FrozenNameMap is frozen and cannot be mutated` by preventing duplicate `lib/main.dart` and `package:<pkg>/main.dart` module collisions in the AST bundler.
  - Added defensive guard in `InterpreterVisitor.visitClassDeclaration` against overwritten frozen class placeholders.
- Fixed duplicate client-side reload handler execution caused by dual `_onReload` listeners.
- Resolved race conditions in `BundleLoader.fetchBundle` when falling back from patch to full bundle.

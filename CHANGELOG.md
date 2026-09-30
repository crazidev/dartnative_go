# Changelog

All notable changes to **DartNative Go** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
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
- **FrozenNameMap Mutation Error**:
  - Resolved `Unsupported operation: FrozenNameMap is frozen and cannot be mutated` by preventing duplicate `lib/main.dart` and `package:<pkg>/main.dart` module collisions in the AST bundler.
  - Added defensive guard in `InterpreterVisitor.visitClassDeclaration` against overwritten frozen class placeholders.
- Fixed duplicate client-side reload handler execution caused by dual `_onReload` listeners.
- Resolved race conditions in `BundleLoader.fetchBundle` when falling back from patch to full bundle.

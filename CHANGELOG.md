# Changelog

All notable changes to **DartNative Go** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- **Delta AST Patch Protocol (`/guest.ast.patch`)**:
  - Incremental code reloads now generate and transmit lightweight gzip delta AST bundles containing only modified compilation units (~20 KB vs 1.89 MB full bundle, a **99% network payload reduction**).
  - Added `AstBundle.applyPatch(AstBundle patch)` in `tom_d4rt_ast` for zero-allocation in-memory AST merging on device.
  - Reduced device AST JSON deserialization time from ~2,580ms down to **5–7ms** (**368× speedup**).
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
- Refactored `LiveConnection` reload event streaming to prevent duplicate bundle fetches on single change triggers.
- Updated `AstBuildWorker` isolate messaging to return `patchBytes` directly across the isolate boundary.
- Enhanced `WidgetGenerationTracker` and `classFileMap` generation for AST module reload precision.

### Fixed
- Fixed duplicate client-side reload handler execution caused by dual `_onReload` listeners.
- Resolved race conditions in `BundleLoader.fetchBundle` when falling back from patch to full bundle.

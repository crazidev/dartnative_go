---
name: dartnative-package-resolution
description: Comprehensive workflow and troubleshooting guide for adding and resolving packages, plugins, and dependencies in DartNative and DartNative Go. Covers package_config.json discovery, AST bundling, bridged vs pure-Dart packages, SafeAstConverter, and dev server hot reload.
---

# DartNative Package Resolution & Dependency Management

This skill provides the standard workflow and architecture reference for adding, resolving, and bundling packages and plugins in DartNative and DartNative Go applications.

---

## 1. Package Architecture Overview

DartNative projects handle three distinct categories of dependencies:

### A. Native Platform Plugins
- **Examples**: `dartnative`, `dartnative_ios`, `dartnative_android`, `dartnative_share`, `dartnative_webview`, `dartnative_shared_preferences`, `dartnative_splash`, `dartnative_supabase`, etc.
- **Characteristics**: Contain native platform code (ObjC/Swift/Java/Kotlin) and FFI bindings.
- **Handling**:
  - Must be declared in `kAstBridgedLibraries` in `lib/src/cli/ast_builder.dart`.
  - Skipped during AST bundling because host runtime bridges handle execution.
  - Native registrant FFI calls (`dartnative_plugin_registrant.dart`) are stubbed out for interpreted AST bundles.

### B. Pure Dart Packages
- **Examples**: `riverpod`, `collection`, `intl`, `equatable`, `crypto`, etc.
- **Characteristics**: Contain 100% Dart code with no platform FFI binaries.
- **Handling**:
  - Resolved automatically from `.dart_tool/package_config.json` by `resolvePackageSources()`.
  - All package `.dart` files are parsed into AST modules and packed into `guest.ast`.

### C. DartNative Bridge Packages
- **Examples**: `riverpod_kit`, `flutter_riverpod` bridges.
- **Characteristics**: Provide high-level UI/State widgets on top of DartNative and pure Dart libraries.
- **Handling**:
  - Registered in `pubspec.yaml` (usually hosted on `https://dartpub.dev`).
  - Source files bundled via `resolvePackageSources()`.
  - Core DartNative framework imports (`package:dartnative/dartnative.dart`, `package:dartnative/plugin.dart`) are skipped as bridged.

---

## 2. Step-by-Step Workflow for Adding a Package

Whenever adding any new dependency to a DartNative project:

### Step 1: Add Dependency to `pubspec.yaml`
```yaml
dependencies:
  dartnative: ^1.0.0
  riverpod_kit:
    hosted: https://dartpub.dev
    version: ^0.1.0
  collection: ^1.19.0
```

### Step 2: Install via `dn pub get`
Always use the DartNative CLI to resolve dependencies:
```bash
/Users/mac/zero/bin/dn pub get
# OR
dn pub get
```
This updates:
1. `.dart_tool/package_config.json`
2. `lib/dartnative_plugin_registrant.dart` (for native plugins)
3. `pubspec.lock`

### Step 3: Verify AST Bundle Build
Test that the bundler resolves and compiles all package sources:
```bash
dart tool/build_ast_bundle.dart --project=example
```
Or run the full test suite:
```bash
dart --enable-asserts test/ast_builder_test.dart
```

### Step 4: Start Dev Server
```bash
dart_go start
```
The server will watch for changes and incrementally compile `assets/bundles/guest.ast`.

---

## 3. Bridged Packages & Generating Bridges via `tool/d4rtgen.dart`

When adding a package that requires native host-level execution (e.g., state management like `riverpod_kit`, or low-level platform bridges):

### Step 1: Configure `buildkit.yaml` & `buildkit_ast.yaml`
Declare the package in the bridge configuration files, specifying the entrypoint barrels and classes to expose.

### Step 2: Generate Bridges with `tool/d4rtgen.dart`
Run the generator runner:
```bash
dart tool/d4rtgen.dart
```
This runs `tom_d4rt_generator` and automatically invokes `_applyBridgePostFixes()` to:
1. Fix known generator syntax skew (e.g., `<dynamic>` type casts, default argument signatures).
2. Cleanly strip unreachable private extension blocks (`ClassBaseX`, `$RefArg`).
3. Inject the appropriate proxy imports (`ast_widget_proxies.dart` for AST, `widget_proxies.dart` for source).
4. Inject `_unwrapInterpretedProxy` and wire it to `watch`, `read`, and `refresh` on `WidgetRef`, `Ref`, and `ProviderContainer`.
5. Patch `NotifierProvider` constructors to wrap `InterpretedInstance` in `InterpretedNotifierProxy`.

### Step 3: Analyze for Compatibility
Always verify the generated code immediately:
```bash
dart analyze lib/src/interpreter/ast/ lib/src/interpreter/
```
If errors occur, patch `_applyBridgePostFixes()` in `tool/d4rtgen.dart` so fixes persist across re-generations.

---

## 4. Headless Fast Testing Without Simulator

Instead of launching the iOS Simulator or Android Emulator (which takes minutes), run headless unit/integration tests directly using the DartNative CLI test runner:

```bash
/Users/mac/zero/bin/dn test test/example_runner_test.dart
```

### Headless ConsumerWidget / Riverpod Testing Pattern:
Tests run in ~18 seconds by creating a headless `ConsumerHost`:
```dart
class _TestConsumerHost implements ConsumerHost {
  @override
  final BuildContext context = _FakeBuildContext();
  @override
  final ProviderContainer container = ProviderContainer();
  @override
  void markNeedsBuild() {}
  @override
  void onNextBuild(void Function() teardown) {}
}
```
1. Resolves `app = await astRunner.evaluateAstBundleAs<Widget>(...)` (or `sourceRunner.evaluate(...)`).
2. Extracts child `HomeScreen` (`InterpretedConsumerWidget`).
3. Calls `(homeScreen as dynamic).build(host.context, ConsumerRef(host))`.
4. Tests button callback execution (`loginBtn.onPressed!()`).
5. Re-calls `build(...)` and verifies that Riverpod state mutated and updated the widget tree.

---

## 5. Troubleshooting Guide

### Issue A: "Cannot resolve import 'package:xyz/xyz.dart' ... is not bridged and not in the same package"
- **Cause 1**: `dn pub get` has not been run, so `.dart_tool/package_config.json` is missing or outdated.
  - **Fix**: Run `dn pub get`.
- **Cause 2**: The package is a native plugin and missing from `kAstBridgedLibraries`.
  - **Fix**: Add `'package:xyz/xyz.dart'` to `kAstBridgedLibraries` in `lib/src/cli/ast_builder.dart`.

### Issue B: "type '_SUnknownNode' is not a subtype of type '...'"
- **Cause**: The analyzer AST produced a node type not yet handled by `AstConverter` (e.g. `LibraryIdentifier`).
  - **Fix**: Add a handler for the node type in `SafeAstConverter` inside `lib/src/cli/ast_builder.dart`.

### Issue C: "Argument Error: Invalid parameter 'callback': expected Notifier<dynamic>, got InterpretedInstance"
- **Cause**: Riverpod's `NotifierProvider` requires a native `Notifier<T>` subclass. The guest code supplies `AppStateNotifier.new`, which creates an `InterpretedInstance`.
  - **Fix**: Wrap `rawNotifier` in `InterpretedNotifierProxy(visitor!, rawNotifier)` in `riverpod_kit_bridges.b.dart` (both AST and source).

### Issue D: "Bridged class 'Notifier' has no instance method named 'login'"
- **Cause**: When interpreted code calls `ref.read(appStateProvider.notifier)`, Riverpod returns the native `InterpretedNotifierProxy`. If not unwrapped, the interpreter looks up guest methods on the native `Notifier` class.
  - **Fix**: Ensure `t.read(provider)`, `t.watch(provider)`, and `t.refresh(provider)` pass the return value through `_unwrapInterpretedProxy`, which returns `proxy.instance` (the `InterpretedInstance`).

### Issue E: "Initial AST build skipped" / "AST rebuild failed" on Dev Server
- **Cause**: Dev server caught an unresolvable import or syntax error.
- **Fix**: Run `dart tool/build_ast_bundle.dart --project=.` with the full stack trace to pinpoint the offending file or directive.


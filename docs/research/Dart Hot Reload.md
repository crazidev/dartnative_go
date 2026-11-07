# DeepWiki Q&A with Code Context for Repository: flutter/flutter
## Q1
I want to learn about the widget hotreload
### Answer
Hot reload is implemented in `flutter_tools` by the `HotRunner` class in `packages/flutter_tools/lib/src/run_hot.dart`. When you press `r` during `flutter run`, it syncs changed sources via DevFS, calls the VM service's `reloadSources`, then triggers a widget reassemble — which is what makes widgets rebuild without losing state.

---

## Triggering a reload

The terminal handler maps keystrokes to `ResidentRunner.restart()`: `r` performs a hot reload, `R` a full hot restart. flutter:1832-1859 

`restart()` defaults to `fullRestart = false`, and the base `ResidentRunner` throws in profile/release mode — hot reload only works in debug. flutter:557-569 

## The reload pipeline

`HotRunner` (extends `ResidentRunner`) implements the reload in `_reloadSources`, which runs these phases, each timed for benchmark/analytics: flutter:79-86 flutter:963-1009 

1. **Setup** — `hotRunnerConfig.setupHotReload()` hook, then `_updateDevFS` recompiles invalidated sources and syncs them to the device (`hotReloadDevFSSyncMilliseconds`). flutter:982-999 
2. **VM reload** — if `invalidatedSourcesCount > 0`, `defaultReloadSourcesHelper` calls `vm_service.reloadSources` on every isolate with `rootLibUri: main.dart.incremental.dill`, then validates the `ReloadReport`. A rejected report resets DevFS compile time so files stay dirty, and returns "Reload rejected". flutter:1193-1260 flutter:1263-1284 
3. **Asset eviction** — `evictDirtyAssets()` clears changed assets from the image cache. flutter:1031-1031 
4. **Reassemble** — `_reassembleHelper` calls `ext.flutter.reassemble` on each Flutter view's UI isolate; this is the step where the widget tree is rebuilt against the new code while `State` objects survive. flutter:1036-1052 

The result message is the familiar `"Reloaded N of M libraries in Xms (compile: ..., reload: ..., reassemble: ...)"`, verified in tests. flutter:647-656 

## Error handling

An `RPCError` with `kIsolateReloadBarred` (e.g., an unrecoverable source change like removing a field from a const class) produces "Unable to hot reload... use R to restart" — an integration test exercises exactly this. flutter:924-956 flutter:47-58 

## Web differences

On web (`ResidentWebRunner.restart`), hot reload is only real with the DDC module format + canary features; otherwise it's forced into `fullRestart = true`. When a true reload is supported, it calls `reloadSources` via DWDS then `flutterReassemble`; non-debug builds just do a `Page.reload`. flutter:460-471 flutter:563-626 

## Notes

- Multiple rapid reloads are debounced/merged (see the integration test expecting 2 reloads from 4 requests). flutter:45-75 
- Hot reload even supports switching a `StatelessWidget` to `StatefulWidget` and back. flutter:16-17 
- I only showed the tool-side pipeline; the framework-side reassemble logic (e.g., `Element.reassemble`, `State` preservation) lives in `packages/flutter` and wasn't in the indexed context shown here.

Wiki pages you might want to explore:
- [Web Development and DevFS (flutter/flutter)](/wiki/flutter/flutter#5.2)
### Citations
**File:** packages/flutter_tools/lib/src/resident_runner.dart (L557-569)
```dart
  /// Perform a hot reload or hot restart of all attached applications.
  ///
  /// If [fullRestart] is true, a hot restart is performed. Otherwise a hot reload
  /// is run instead. On web devices, this only performs a hot restart regardless of
  /// the value of [fullRestart].
  Future<OperationResult> restart({bool fullRestart = false, bool pause = false, String? reason}) {
    final mode = isRunningProfile
        ? 'profile'
        : isRunningRelease
        ? 'release'
        : 'this';
    throw Exception('${fullRestart ? 'Restart' : 'Reload'} is not supported in $mode mode');
  }
```
**File:** packages/flutter_tools/lib/src/resident_runner.dart (L1832-1859)
```dart
      case 'r':
        // Allow hot reload if enabled. Also allow it if reloadIsRestart is true
        // (e.g., web with --no-hot), since in that case the reload will be
        // converted to a restart internally.
        if (!(residentRunner.canHotReload || residentRunner.reloadIsRestart)) {
          return false;
        }
        final OperationResult result = await residentRunner.restart();
        if (result.fatal) {
          throwToolExit(result.message);
        }
        if (!result.isOk) {
          _logger.printStatus('Try again after fixing the above error(s).', emphasis: true);
        }
        return true;
      case 'R':
        // If hot restart is not supported for all devices, ignore the command.
        if (!residentRunner.supportsRestart || !residentRunner.hotMode) {
          return false;
        }
        final OperationResult result = await residentRunner.restart(fullRestart: true);
        if (result.fatal) {
          throwToolExit(result.message);
        }
        if (!result.isOk) {
          _logger.printStatus('Try again after fixing the above error(s).', emphasis: true);
        }
        return true;
```
**File:** packages/flutter_tools/lib/src/run_hot.dart (L79-86)
```dart
class HotRunner extends ResidentRunner {
  HotRunner(
    super.flutterDevices, {
    required super.target,
    required super.debuggingOptions,
    this.benchmarkMode = false,
    this.applicationBinary,
    this.hostIsIde = false,
```
**File:** packages/flutter_tools/lib/src/run_hot.dart (L924-956)
```dart
    } on vm_service.RPCError catch (error) {
      var errorMessage = 'hot reload failed to complete';
      var errorCode = 1;
      if (error.code == kIsolateReloadBarred) {
        errorCode = error.code;
        errorMessage =
            'Unable to hot reload application due to an unrecoverable error in '
            'the source code. Please address the error and then use "R" to '
            'restart the app.\n'
            '${error.message} (error code: ${error.code})';
        _analytics.send(
          Event.hotRunnerInfo(
            label: 'reload-barred',
            targetPlatform: targetPlatform!,
            sdkName: sdkName!,
            emulator: emulator!,
            fullRestart: false,
            reason: reason,
          ),
        );
      } else {
        _analytics.send(
          Event.hotRunnerInfo(
            label: 'exception',
            targetPlatform: targetPlatform!,
            sdkName: sdkName!,
            emulator: emulator!,
            fullRestart: false,
            reason: reason,
          ),
        );
      }
      return OperationResult(errorCode, errorMessage, fatal: true);
```
**File:** packages/flutter_tools/lib/src/run_hot.dart (L963-1009)
```dart
  Future<OperationResult> _reloadSources({
    String? targetPlatform,
    String? sdkName,
    bool? emulator,
    bool? pause = false,
    String? reason,
    void Function(String message)? onSlow,
  }) async {
    final viewCache = <FlutterDevice?, List<FlutterView>>{};
    for (final FlutterDevice? device in flutterDevices) {
      final List<FlutterView> views = await device!.vmService!.getFlutterViews();
      viewCache[device] = views;
      for (final view in views) {
        if (view.uiIsolate == null) {
          return OperationResult(2, 'Application isolate not found', fatal: true);
        }
      }
    }

    final Stopwatch reloadTimer = _stopwatchFactory.createStopwatch('reloadSources:reload')
      ..start();
    if ((await hotRunnerConfig!.setupHotReload()) != true) {
      return OperationResult(1, 'setupHotReload failed');
    }
    final devFSTimer = Stopwatch()..start();
    UpdateFSReport updatedDevFS;
    try {
      updatedDevFS = await _updateDevFS(targetPlatforms: _targetPlatforms);
    } finally {
      hotRunnerConfig!.updateDevFSComplete();
    }
    // Record time it took to synchronize to DevFS.
    var shouldReportReloadTime = true;
    _addBenchmarkData('hotReloadDevFSSyncMilliseconds', devFSTimer.elapsed.inMilliseconds);
    if (!updatedDevFS.success) {
      return OperationResult(1, 'DevFS synchronization failed');
    }

    final extraTimings = <OperationResultExtraTiming>[];
    extraTimings.add(
      OperationResultExtraTiming('compile', updatedDevFS.compileDuration.inMilliseconds),
    );

    var reloadMessage = 'Reloaded 0 libraries';
    final Stopwatch reloadVMTimer = _stopwatchFactory.createStopwatch('reloadSources:vm')..start();
    final firstReloadDetails = <String, Object?>{};
    if (updatedDevFS.invalidatedSourcesCount > 0) {
```
**File:** packages/flutter_tools/lib/src/run_hot.dart (L1031-1031)
```dart
    await evictDirtyAssets();
```
**File:** packages/flutter_tools/lib/src/run_hot.dart (L1036-1052)
```dart
    final ReassembleResult reassembleResult = await _reassembleHelper(
      flutterDevices,
      viewCache,
      onSlow,
      reloadMessage,
    );
    shouldReportReloadTime = reassembleResult.shouldReportReloadTime;
    if (reassembleResult.reassembleViews.isEmpty) {
      return OperationResult(OperationResult.ok.code, reloadMessage);
    }
    // Record time it took for Flutter to reassemble the application.
    reassembleTimer.stop();
    _addBenchmarkData(
      'hotReloadFlutterReassembleMilliseconds',
      reassembleTimer.elapsed.inMilliseconds,
    );
    extraTimings.add(OperationResultExtraTiming('reassemble', reassembleTimer.elapsedMilliseconds));
```
**File:** packages/flutter_tools/lib/src/run_hot.dart (L1193-1260)
```dart
  final vmReloadTimer = Stopwatch()..start();
  const entryPath = 'main.dart.incremental.dill';
  final allReportsFutures = <Future<DeviceReloadReport?>>[];

  for (final device in flutterDevices) {
    final List<Future<vm_service.ReloadReport>> reportFutures = await _reloadDeviceSources(
      device!,
      entryPath,
      pause: pause,
    );
    allReportsFutures.add(
      Future.wait(reportFutures).then<DeviceReloadReport?>((
        List<vm_service.ReloadReport> reports,
      ) async {
        // TODO(aam): Investigate why we are validating only first reload report,
        // which seems to be current behavior
        if (reports.isEmpty) {
          return null;
        }
        final vm_service.ReloadReport firstReport = reports.first;
        // Don't print errors because they will be printed further down when
        // `validateReloadReport` is called again.
        await device.updateReloadStatus(
          HotRunner.validateReloadReport(firstReport, printErrors: false),
        );
        return DeviceReloadReport(device, reports);
      }),
    );
  }
  final Iterable<DeviceReloadReport> reports = (await Future.wait(
    allReportsFutures,
  )).whereType<DeviceReloadReport>();
  final vm_service.ReloadReport? reloadReport = reports.isEmpty ? null : reports.first.reports[0];
  if (reloadReport == null || !HotRunner.validateReloadReport(reloadReport)) {
    analytics.send(
      Event.hotRunnerInfo(
        label: 'reload-reject',
        targetPlatform: targetPlatform!,
        sdkName: sdkName!,
        emulator: emulator!,
        fullRestart: false,
        reason: reason,
      ),
    );
    // Reset devFS lastCompileTime to ensure the file will still be marked
    // as dirty on subsequent reloads.
    _resetDevFSCompileTime(flutterDevices);
    if (reloadReport == null) {
      return OperationResult(1, 'No Dart isolates found');
    }
    final contents = ReloadReportContents.fromReloadReport(reloadReport);
    return OperationResult(1, 'Reload rejected: ${contents.notices.join("\n")}');
  }
  // Collect stats only from the first device. If/when run -d all is
  // refactored, we'll probably need to send one hot reload/restart event
  // per device to analytics.
  firstReloadDetails.addAll(castStringKeyedMap(reloadReport.json!['details'])!);
  final details = reloadReport.json!['details'] as Map<String, dynamic>;
  final loadedLibraryCount = details['loadedLibraryCount'] as int?;
  final finalLibraryCount = details['finalLibraryCount'] as int?;
  globals.printTrace('reloaded $loadedLibraryCount of $finalLibraryCount libraries');
  // reloadMessage = 'Reloaded $loadedLibraryCount of $finalLibraryCount libraries';
  // Record time it took for the VM to reload the sources.
  hotRunner._addBenchmarkData(
    'hotReloadVMReloadMilliseconds',
    vmReloadTimer.elapsed.inMilliseconds,
  );
  return OperationResult(0, 'Reloaded $loadedLibraryCount of $finalLibraryCount libraries');
```
**File:** packages/flutter_tools/lib/src/run_hot.dart (L1263-1284)
```dart
Future<List<Future<vm_service.ReloadReport>>> _reloadDeviceSources(
  FlutterDevice device,
  String entryPath, {
  bool? pause = false,
}) async {
  final deviceEntryUri = device.devFS!.baseUri!.resolve(entryPath).toString();
  final vm_service.VM vm = await device.vmService!.service.getVM();
  return <Future<vm_service.ReloadReport>>[
    for (final vm_service.IsolateRef isolateRef in vm.isolates!)
      device.vmService!.service.reloadSources(
        isolateRef.id!,
        pause: pause,
        rootLibUri: deviceEntryUri,
      ),
  ];
}

void _resetDevFSCompileTime(List<FlutterDevice?> flutterDevices) {
  for (final device in flutterDevices) {
    device!.devFS!.resetLastCompiled();
  }
}
```
**File:** packages/flutter_tools/test/general.shard/resident_runner_test.dart (L647-656)
```dart
        // The actual test: Expect to have compile, reload and reassemble times.
        expect(
          testLogger.statusText,
          contains(
            RegExp(
              r'Reloaded 1 of 42 libraries in \d+ms '
              r'\(compile: \d+ ms, reload: \d+ ms, reassemble: \d+ ms\)\.',
            ),
          ),
        );
```
**File:** packages/flutter_tools/test/integration.shard/test_data/hot_reload_errors_common.dart (L47-58)
```dart
        project.removeFieldFromConstClass();
        await expectLater(
          flutter.hotReload(),
          throwsA(
            isA<Exception>().having(
              (Exception e) => e.toString(),
              'message',
              contains('Try performing a hot restart instead.'),
            ),
          ),
        );
        await expectLater(flutter.hotRestart(), completes);
```
**File:** packages/flutter_tools/lib/src/isolated/resident_web_runner.dart (L460-471)
```dart
    if (debuggingOptions.buildInfo.ddcModuleFormat != DdcModuleFormat.ddc ||
        !debuggingOptions.buildInfo.canaryFeatures) {
      // Triggering hot reload performed hot restart for the old module formats
      // historically. Keep that behavior and only perform hot reload when the
      // new module format is used.
      fullRestart = true;
    }
    if (fullRestart) {
      status = _logger.startProgress('Performing hot restart...', progressId: 'hot.restart');
    } else {
      status = _logger.startProgress('Performing hot reload...', progressId: 'hot.reload');
    }
```
**File:** packages/flutter_tools/lib/src/isolated/resident_web_runner.dart (L563-626)
```dart
          final DateTime reloadStart = _systemClock.now();
          final vmservice.VM vm = await _vmService.service.getVM();
          final String hotReloadMethod =
              _registeredMethodsForService['reloadSources'] ?? 'reloadSources';

          // Check if there are any isolates available
          if (vm.isolates == null || vm.isolates!.isEmpty) {
            _logger.printTrace('No isolates available for hot reload');
            return _handleNoClientsAvailable(status);
          }

          vmservice.ReloadReport report;
          try {
            report = await _vmService.service.reloadSources(vm.isolates!.first.id!);
          } on vmservice.RPCError catch (e) {
            // DWDS throws an RPC error with kIsolateCannotReload code when there are no
            // browser clients currently connected during a hot reload operation.
            if (e.callingMethod == hotReloadMethod &&
                e.code == vmservice.RPCErrorKind.kIsolateCannotReload.code) {
              return _handleNoClientsAvailable(status);
            }
            // Re-throw other RPC errors
            rethrow;
          }

          reloadDuration = _systemClock.now().difference(reloadStart);
          final contents = ReloadReportContents.fromReloadReport(report);
          final bool success = contents.success ?? false;
          if (!success) {
            // Rejections happen at compile-time for the web, so in theory,
            // nothing should go wrong here. However, if DWDS or the DDC runtime
            // has some internal error, we should still surface it to make
            // debugging easier.
            var reloadFailedMessage = 'Hot reload failed:';
            _logger.printError(reloadFailedMessage);
            for (final ReasonForCancelling reason in contents.notices) {
              reloadFailedMessage += reason.toString();
              _logger.printError(reason.toString());
            }
            return OperationResult(1, reloadFailedMessage);
          }
          await evictDirtyAssets();
          String? failedReassemble;
          final DateTime reassembleStart = _systemClock.now();
          await _vmService
              .flutterReassemble(isolateId: null)
              .then(
                (Object? o) => o,
                onError: (Object error, StackTrace stackTrace) {
                  failedReassemble = 'Reassembling failed: $error\n$stackTrace';
                  _logger.printError(failedReassemble!);
                },
              );
          reassembleDuration = _systemClock.now().difference(reassembleStart);
          if (failedReassemble != null) {
            return OperationResult(1, failedReassemble!);
          }
        }
      } else {
        // On non-debug builds, a hard refresh is required to ensure the
        // up to date sources are loaded.
        await _wipConnection?.sendCommand('Page.reload', <String, Object>{
          'ignoreCache': !debuggingOptions.buildInfo.isDebug,
        });
```
**File:** packages/flutter_tools/test/integration.shard/test_data/hot_reload_test_common.dart (L45-75)
```dart
      // Multiple overlapping hot reloads are debounced and queued.

      // Capture how many *real* hot reloads occur.
      var numReloads = 0;
      final StreamSubscription<void> subscription = flutter.stdout
          .map(parseFlutterResponse)
          .where(_isHotReloadCompletionEvent)
          .listen((_) => numReloads++);

      // To reduce tests flaking, override the debounce timer to something higher than
      // the default to ensure the hot reloads that are supposed to arrive within the
      // debounce period will even on slower CI machines.
      const hotReloadDebounceOverrideMs = 250;
      const delay = Duration(milliseconds: hotReloadDebounceOverrideMs * 2);

      Future<void> doReload([void _]) => flutter.hotReload(
        debounce: true,
        debounceDurationOverrideMs: hotReloadDebounceOverrideMs,
      );

      try {
        await Future.wait<void>(<Future<void>>[
          doReload(),
          doReload(),
          Future<void>.delayed(delay).then(doReload),
          Future<void>.delayed(delay).then(doReload),
        ]);

        // We should only get two reloads, as the first two will have been
        // merged together by the debounce, and the second two also.
        expect(numReloads, equals(2));
```
**File:** packages/flutter_tools/test/integration.shard/test_data/stateless_stateful_hot_reload_test_common.dart (L16-17)
```dart
// This test verifies that we can hot reload a stateless widget into a
// stateful one and back.
```
## Q2
What states is reserved when hotreloading & how does it knows which widget to reassemble by rebuilding, or does it just rebuild every widget?
### Answer
## Answer

**What's preserved:** the entire `Element` tree, including every `State` object, `RenderObject`, and `BuildContext` association — `initState` is *not* re-run, and `State` fields keep their values. Only the (immutable) `Widget` objects are discarded and recreated.

**What it rebuilds:** every widget — but in two distinct senses. `BuildOwner.reassemble(root)` calls `Element.reassemble()` on the root, which calls `markNeedsBuild()` and recursively visits *every* child element, so the whole tree is flagged dirty flutter:3464-3483 flutter:3771-3776 . However, during the actual rebuild, `updateChild` matches each newly-built `Widget` to the existing child `Element` by `runtimeType` + `Key` (`Widget.canUpdate`) — matching elements are *updated in place* rather than recreated, which is precisely how `State` survives flutter:5465-5482 .

---

## Details

### State preservation

`State` objects live on `StatefulElement` (`_state` field), not on the widget — the widget is just configuration. Since the element tree is never torn down, all `State` instances (text fields, scroll positions, animation controllers, your own fields) survive. The docs spell this out: on hot reload `reassemble` is called "providing an opportunity to reinitialize any data that was prepared in `initState`" — `initState` itself is not re-invoked flutter:879-896 .

For `StatefulElement` specifically, `reassemble()` forwards to `state.reassemble()` first so your `State` subclass can react, then marks the element dirty flutter:5958-5962 . `State.reassemble` is an overridable no-op hook; `build` is guaranteed to be called afterward flutter:1039-1052 .

### Why it rebuilds everything

There's no diffing of "which widgets changed" — the VM swapped in new code for existing classes, so the framework can't know which `build()` methods would now produce different output. The docs state it plainly: "During a hot reload, every element is marked dirty (using `Element.reassemble`)" flutter:5439-5458 . It's explicitly called "expensive and should not be called except during development" flutter:3464-3470 .

The entry point chain: `ext.flutter.reassemble` service extension → `BindingBase.reassembleApplication()` → `lockEvents(performReassemble)` → `BuildOwner.reassemble(root)` flutter:723-760 .

### How elements are matched during rebuild

When each dirty element rebuilds, its `build()` returns a new widget tree, and `updateChild` decides per-child:

| Condition | Result |
|---|---|
| `child.widget == newWidget` (identical) | Reuse element, just update slot |
| `Widget.canUpdate(old, new)` (same `runtimeType` + `key`) | Update existing element in place → `State` kept, `didUpdateWidget` called |
| Neither | Old element deactivated/disposed, new element inflated → fresh `State` | flutter:3999-4043 

There's even special handling for the hot-reload-only case where a widget's *class* changed between `StatefulWidget`/`StatelessWidget`: `hasSameSuperclass` is forced false so the now-type-mismatched element is discarded rather than crashing on a bad cast flutter:4009-4030 .

So: **every** widget's `build()` runs, but element/state identity is preserved positionally by type+key matching — that's why state survives even though nothing is selectively rebuilt.

## Notes

- A caveat in the `Element.reassemble` docs: ordering isn't guaranteed — a `Timer` or animation can trigger a build with the new code *before* `reassemble` runs, so `reassemble` overrides should be resilient/fizzle rather than throw flutter:3754-3761 .
- Static/global variables and `main()` are also preserved by the VM — hot reload doesn't re-run `main`; that's what distinguishes it from hot restart (`R`), which throws away the isolate's state.
- Things that *don't* survive hot reload cleanly: state whose type changed incompatibly (e.g., enum reordering, changed field types) — these can produce errors requiring a restart, consistent with the `kIsolateReloadBarred` handling shown previously in `run_hot.dart`.

Wiki pages you might want to explore:
- [Framework Architecture (flutter/flutter)](/wiki/flutter/flutter#3)
### Citations
**File:** packages/flutter/lib/src/widgets/framework.dart (L879-896)
```dart
///  * During development, if a hot reload occurs (whether initiated from the
///    command line `flutter` tool by pressing `r`, or from an IDE), the
///    [reassemble] method is called. This provides an opportunity to
///    reinitialize any data that was prepared in the [initState] method.
///  * If the subtree containing the [State] object is removed from the tree
///    (e.g., because the parent built a widget with a different [runtimeType]
///    or [Widget.key]), the framework calls the [deactivate] method. Subclasses
///    should override this method to clean up any links between this object
///    and other elements in the tree (e.g. if you have provided an ancestor
///    with a pointer to a descendant's [RenderObject]).
///  * At this point, the framework might reinsert this subtree into another
///    part of the tree. If that happens, the framework will ensure that it
///    calls [build] to give the [State] object a chance to adapt to its new
///    location in the tree. If the framework does reinsert this subtree, it
///    will do so before the end of the animation frame in which the subtree was
///    removed from the tree. For this reason, [State] objects can defer
///    releasing most resources until the framework calls their [dispose]
///    method.
```
**File:** packages/flutter/lib/src/widgets/framework.dart (L1039-1052)
```dart
  /// {@macro flutter.widgets.Element.reassemble}
  ///
  /// In addition to this method being invoked, it is guaranteed that the
  /// [build] method will be invoked when a reassemble is signaled. Most
  /// widgets therefore do not need to do anything in the [reassemble] method.
  ///
  /// See also:
  ///
  ///  * [Element.reassemble]
  ///  * [BindingBase.reassembleApplication]
  ///  * [Image], which uses this to reload images.
  @protected
  @mustCallSuper
  void reassemble() {}
```
**File:** packages/flutter/lib/src/widgets/framework.dart (L3464-3483)
```dart
  /// Cause the entire subtree rooted at the given [Element] to be entirely
  /// rebuilt. This is used by development tools when the application code has
  /// changed and is being hot-reloaded, to cause the widget tree to pick up any
  /// changed implementations.
  ///
  /// This is expensive and should not be called except during development.
  void reassemble(Element root) {
    if (!kReleaseMode) {
      FlutterTimeline.startSync('Preparing Hot Reload (widgets)');
    }
    try {
      assert(root._parent == null);
      assert(root.owner == this);
      root.reassemble();
    } finally {
      if (!kReleaseMode) {
        FlutterTimeline.finishSync();
      }
    }
  }
```
**File:** packages/flutter/lib/src/widgets/framework.dart (L3754-3761)
```dart
  /// Implementers should not rely on any ordering for hot reload source update,
  /// reassemble, and build methods after a hot reload has been initiated. It is
  /// possible that a [Timer] (e.g. an [Animation]) or a debugging session
  /// attached to the isolate could trigger a build with reloaded code _before_
  /// reassemble is called. Code that expects preconditions to be set by
  /// reassemble after a hot reload must be resilient to being called out of
  /// order, e.g. by fizzling instead of throwing. That said, once reassemble is
  /// called, build will be called after it at least once.
```
**File:** packages/flutter/lib/src/widgets/framework.dart (L3771-3776)
```dart
  void reassemble() {
    markNeedsBuild();
    visitChildren((Element child) {
      child.reassemble();
    });
  }
```
**File:** packages/flutter/lib/src/widgets/framework.dart (L3999-4043)
```dart
  Element? updateChild(Element? child, Widget? newWidget, Object? newSlot) {
    if (newWidget == null) {
      if (child != null) {
        deactivateChild(child);
      }
      return null;
    }

    final Element newChild;
    if (child != null) {
      var hasSameSuperclass = true;
      // When the type of a widget is changed between Stateful and Stateless via
      // hot reload, the element tree will end up in a partially invalid state.
      // That is, if the widget was a StatefulWidget and is now a StatelessWidget,
      // then the element tree currently contains a StatefulElement that is incorrectly
      // referencing a StatelessWidget (and likewise with StatelessElement).
      //
      // To avoid crashing due to type errors, we need to gently guide the invalid
      // element out of the tree. To do so, we ensure that the `hasSameSuperclass` condition
      // returns false which prevents us from trying to update the existing element
      // incorrectly.
      //
      // For the case where the widget becomes Stateful, we also need to avoid
      // accessing `StatelessElement.widget` as the cast on the getter will
      // cause a type error to be thrown. Here we avoid that by short-circuiting
      // the `Widget.canUpdate` check once `hasSameSuperclass` is false.
      assert(() {
        final int oldElementClass = Element._debugConcreteSubtype(child);
        final int newWidgetClass = Widget._debugConcreteSubtype(newWidget);
        hasSameSuperclass = oldElementClass == newWidgetClass;
        return true;
      }());
      if (hasSameSuperclass && child.widget == newWidget) {
        // We don't insert a timeline event here, because otherwise it's
        // confusing that widgets that "don't update" (because they didn't
        // change) get "charged" on the timeline.
        if (child.slot != newSlot) {
          updateSlotForChild(child, newSlot);
        }
        newChild = child;
      } else if (hasSameSuperclass && Widget.canUpdate(child.widget, newWidget)) {
        if (child.slot != newSlot) {
          updateSlotForChild(child, newSlot);
        }
        final bool isTimelineTracked = !kReleaseMode && _isProfileBuildsEnabledFor(newWidget);
```
**File:** packages/flutter/lib/src/widgets/framework.dart (L5439-5458)
```dart
  /// ### Marking an element dirty
  ///
  /// An [Element] can be marked dirty between frames. This can happen for various
  /// reasons, including the following:
  ///
  /// * The [State] of a [StatefulWidget] can cause its [Element] to be marked
  ///   dirty by calling the [State.setState] method.
  ///
  /// * When an [InheritedWidget] changes, descendants that have previously
  ///   subscribed to it will be marked dirty.
  ///
  /// * During a hot reload, every element is marked dirty (using [Element.reassemble]).
  ///
  /// ### Rebuilding
  ///
  /// Dirty elements are rebuilt during the next frame. Precisely how this is
  /// done depends on the kind of element. A [StatelessElement] rebuilds by
  /// using its widget's [StatelessWidget.build] method. A [StatefulElement]
  /// rebuilds by using its widget's state's [State.build] method. A
  /// [RenderObjectElement] rebuilds by updating its [RenderObject].
```
**File:** packages/flutter/lib/src/widgets/framework.dart (L5465-5482)
```dart
  /// correspond to an existing [Element] if it has the same [Type] and [Key].
  /// (In the case of [MultiChildRenderObjectElement]s, some effort is put into
  /// tracking widgets even when they change order; see
  /// [RenderObjectElement.updateChildren].)
  ///
  /// If there was no corresponding previous child, this results in a new
  /// [Element] being created (using [Widget.createElement]); that element is
  /// then itself built, recursively.
  ///
  /// If there was a child previously but the build did not provide a
  /// corresponding child to update it, then the old child is discarded (or, in
  /// cases involving [GlobalKey] reparenting, reused elsewhere in the element
  /// tree).
  ///
  /// The most common case, however, is that there was a corresponding previous
  /// child. This is handled by asking the child [Element] to update itself
  /// using the new child [Widget]. In the case of [StatefulElement]s, this
  /// is what triggers [State.didUpdateWidget].
```
**File:** packages/flutter/lib/src/widgets/framework.dart (L5958-5962)
```dart
  @override
  void reassemble() {
    state.reassemble();
    super.reassemble();
  }
```
**File:** packages/flutter/lib/src/foundation/binding.dart (L723-760)
```dart
  /// Cause the entire application to redraw, e.g. after a hot reload.
  ///
  /// This is used by development tools when the application code has changed,
  /// to cause the application to pick up any changed code. It can be triggered
  /// manually by sending the `ext.flutter.reassemble` service extension signal.
  ///
  /// This method is very computationally expensive and should not be used in
  /// production code. There is never a valid reason to cause the entire
  /// application to repaint in production. All aspects of the Flutter framework
  /// know how to redraw when necessary. It is only necessary in development
  /// when the code is literally changed on the fly (e.g. in hot reload) or when
  /// debug flags are being toggled.
  ///
  /// While this method runs, events are locked (e.g. pointer events are not
  /// dispatched).
  ///
  /// Subclasses (binding classes) should override [performReassemble] to react
  /// to this method being called. This method itself should not be overridden.
  Future<void> reassembleApplication() {
    return lockEvents(performReassemble);
  }

  /// This method is called by [reassembleApplication] to actually cause the
  /// application to reassemble, e.g. after a hot reload.
  ///
  /// Bindings are expected to use this method to re-register anything that uses
  /// closures, so that they do not keep pointing to old code, and to flush any
  /// caches of previously computed values, in case the new code would compute
  /// them differently. For example, the rendering layer triggers the entire
  /// application to repaint when this is called.
  ///
  /// Do not call this method directly. Instead, use [reassembleApplication].
  @mustCallSuper
  @protected
  Future<void> performReassemble() {
    FlutterError.resetErrorCount();
    return Future<void>.value();
  }
```
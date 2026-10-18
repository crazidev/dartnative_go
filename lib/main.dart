import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/dartnative_plugin_registrant.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import 'src/client/network_scanner.dart';
import 'src/client/project_model.dart';
import 'src/client/project_storage.dart';
import 'src/devtool/devtool_overlay.dart';
import 'src/runner/bundle_loader.dart';
import 'src/runner/icon_font_manager.dart';
import 'src/runner/interpreter_runner.dart';
import 'src/runner/live_connection.dart';
import 'src/runner/logger.dart';
import 'src/runner/native_bottomsheet_manager.dart';
import 'src/runner/runtime_mode.dart';
import 'src/client/error_display_storage.dart';
import 'src/client/runtime_mode_storage.dart';
import 'src/client/theme_storage.dart';
import 'src/runner/ui_probe.dart';
import 'src/theme/theme_providers.dart';
import 'src/interpreter/widget_generation_tracker.dart';
import 'src/launcher/launcher_screen.dart';
import 'src/preview/preview_route.dart';

var example = "Hello world";

Future<void> main(List<String> args) async {
  DartNativePluginRegistrant.registerAll();

  // Preload the persisted theme before the first frame so the launcher
  // paints with the right tokens immediately. The ThemeController reads the
  // same in-memory value when the provider initializes.
  final theme = await ThemeStorage.loadPreference();
  ThemeController.applyNativeAppearance(theme);

  runApp(const ProviderScope(child: DartNativeGo()));
}

class DartNativeGo extends StatefulWidget {
  const DartNativeGo({super.key});

  @override
  State<DartNativeGo> createState() => _DartNativeGoState();
}

class _DartNativeGoState extends State<DartNativeGo> {
  final DartGoNetworkScanner _scanner = DartGoNetworkScanner(
    storage: ProjectStorage(),
  );
  final TextEditingController _urlController = TextEditingController();
  StreamSubscription<List<DartGoProject>>? _scannerSub;
  List<DartGoProject> _projects = [];
  bool _isLoading = false;

  /// Auto-connect to the first online dev server the scanner discovers, so the
  /// app reaches the guest without a human tap (simulator/CI automation).
  /// Enabled by default in JIT/debug builds, disabled in AOT product builds.
  /// Force either way with `--dart-define=DARTNATIVE_AUTO_CONNECT=true|false`.
  static const String _autoConnectOverride =
      String.fromEnvironment('DARTNATIVE_AUTO_CONNECT');

  /// True in AOT/release builds (`--release`/`--profile`), false under the JIT.
  static const bool _isProductBuild = bool.fromEnvironment('dart.vm.product');

  bool get _autoConnectEnabled {
    if (_autoConnectOverride == 'true') return true;
    if (_autoConnectOverride == 'false') return false;
    return !_isProductBuild;
  }

  /// Guards [_maybeAutoConnect] so one app launch connects at most once.
  bool _autoConnectAttempted = false;

  // Active Runner & Guest App State
  bool _isAppMounted = false;
  bool _isLoadingBundle = false;
  String _statusMessage = 'Connecting to project...';
  String? _errorMessage;
  String? _errorStackTrace;
  ProjectBundle? _activeBundle;
  Widget? _interpretedWidget;

  final BundleLoader _bundleLoader = BundleLoader();
  late InterpreterRunner _interpreterRunner;
  LiveConnection? _liveConnection;

  /// On-demand icon fonts: rebuilt per server connection, synced after every
  /// bundle fetch. Steady-state reloads no-op on matching `iconFontsHash`.
  IconFontManager? _iconFontManager;

  /// Whether the dev server runs with `--profile` (from the manifest's
  /// `profile` field): the AST BUNDLE explorer shows in the DevTools sheet
  /// only then. Sticky across reloads because the patch fast path skips the
  /// manifest; reset when a new project is started from the launcher.
  bool _astProfileEnabled = false;

  /// Engine mode. AST default; Source fallback.
  bool _useAst = kUseAst;
  bool _verboseLogs = DartGoLogger.verbose;
  ErrorDisplayMode _errorDisplayMode = ErrorDisplayMode.overlay;

  /// Monotonic tokens for lifecycle operations. The dev server pushes
  /// `reload`/`restart` over a WebSocket without awaiting the handler, so two
  /// evaluations can overlap; only the newest token is allowed to commit its
  /// result (bundle swap, widget remount, error state).
  int _reloadSeq = 0;
  int _restartSeq = 0;

  double? _downloadProgress;
  int? _downloadedCount;
  int? _downloadTotal;

  /// Probe anchor: resolves the guest-root `Element` (the reconciled DNTree)
  /// for UI automation — see `lib/src/runner/ui_probe.dart`. Stable across
  /// reloads; the inner `ValueKey('guest_root')` layer below keeps owning
  /// state preservation, so this outer key never changes child type.
  final GlobalKey _guestProbeKey = GlobalKey();

  /// Navigation anchor for the host [App]: the preview route is pushed from
  /// here, and the DevTools "Go Home" pops back through it.
  final GlobalKey _navKey = GlobalKey();

  /// Publishes the launch/preview surface to its pushed route. The preview is a
  /// separate native screen, so it does not rebuild when this state rebuilds;
  /// it listens to this notifier instead. The floating DevTools overlay (held
  /// above every route) also reads from it.
  final ValueNotifier<PreviewState> _previewState =
      ValueNotifier(const PreviewState());

  /// True while the preview route is on the navigator stack.
  bool _previewRouteOpen = false;

  @override
  void initState() {
    super.initState();
    DartGoLogger.logSink = (msg, {level = 'INFO'}) {
      _liveConnection?.sendDeviceLog(msg, level: level);
    };
    _interpreterRunner = InterpreterRunner(
      onLog: (msg) => _liveConnection?.sendDeviceLog(msg),
      onExit: _unmountApp,
      useAst: _useAst,
      onGuestError: (error, stack) => _showGuestErrorBanner(error, stack),
    );
    _restoreSavedRuntimeMode();
    _initScanner();
  }

  Future<void> _restoreSavedRuntimeMode() async {
    final mode = await RuntimeModeStorage.loadMode();
    final useAst = flagsFromRuntimeMode(mode);
    final errorDisplayMode = await ErrorDisplayStorage.loadMode();
    _useAst = useAst;
    _interpreterRunner.useAst = _useAst;
    _errorDisplayMode = errorDisplayMode;
    _publishPreview();
  }

  /// Rebuilds the preview snapshot from the current launch state and hands it
  /// to the pushed preview route and the DevTools overlay. Every path that
  /// changes what the preview shows must funnel through here.
  ///
  /// This does not call `setState`: the preview route and the root-overlay
  /// DevTools surface both listen to [_previewState], so they refresh without
  /// the host root re-deciding its child.
  void _publishPreview() {
    if (!mounted) return;
    _previewState.value = PreviewState(
      appName: _activeBundle?.appName ?? 'DartNative App',
      appVersion: _activeBundle?.appVersion,
      serverUrl: _activeBundle?.serverUrl ?? '',
      isConnected: _liveConnection?.isConnected ?? false,
      isLoadingBundle: _isLoadingBundle,
      isAppMounted: _isAppMounted,
      statusMessage: _statusMessage,
      downloadProgress: _downloadProgress,
      downloadedCount: _downloadedCount,
      downloadTotal: _downloadTotal,
      widget: _interpretedWidget,
      splashUrl: _activeBundle?.splashUrl,
      iconUrl: _activeBundle?.iconUrl,
      splashBackgroundColor: _activeBundle?.splashBackgroundColor,
      errorMessage: _errorMessage,
      errorStackTrace: _errorStackTrace,
      errorDisplayMode: _errorDisplayMode,
    );
  }

  /// Records a guest failure for the on-device error surface without
  /// unmounting the working tree. The same failure is already on the CLI
  /// through [DartGoLogger]; this only decides what the device shows.
  void _showGuestErrorBanner(Object error, [StackTrace? stack]) {
    final msg = 'Guest runtime error: $error';
    if (!mounted || _errorMessage == msg) return;
    _errorMessage = msg;
    _errorStackTrace = stack?.toString();
    _publishPreview();
  }

  void _recordError(String message, [StackTrace? stack]) {
    _errorMessage = message;
    _errorStackTrace = stack?.toString();
    _publishPreview();
  }

  void _clearError() {
    if (_errorMessage == null && _errorStackTrace == null) return;
    _errorMessage = null;
    _errorStackTrace = null;
    _publishPreview();
  }

  void _dismissGuestError() {
    _clearError();
  }

  /// Sets how guest failures surface on the device and persists the choice.
  void _setErrorDisplayMode(ErrorDisplayMode mode) {
    _errorDisplayMode = mode;
    ErrorDisplayStorage.saveMode(mode);
    _publishPreview();
  }

  Future<void> _initScanner() async {
    _scannerSub = _scanner.projectsStream.listen((projects) {
      if (mounted) {
        setState(() {
          _projects = projects;
          _isLoading = false;
        });
        _maybeAutoConnect(projects);
      }
    });

    await _scanner.start();
    if (mounted) {
      setState(() {
        _projects = _scanner.currentProjects;
        _isLoading = false;
      });
      _maybeAutoConnect(_scanner.currentProjects);
    }
  }

  /// Launches the first online project discovered by the scanner, bypassing the
  /// need for a launcher tap. Runs at most once per app process so returning to
  /// the launcher (or a guest exit) never causes a reconnect loop.
  void _maybeAutoConnect(List<DartGoProject> projects) {
    if (!_autoConnectEnabled || _autoConnectAttempted) return;
    if (_isAppMounted || _isLoadingBundle) return;
    final active = projects.where((p) => p.isActive).toList();
    if (active.isEmpty) return;
    final project = active.first;
    _autoConnectAttempted = true;
    DartGoLogger.info(
      'Auto-connecting to ${project.appName} (${project.url})',
    );
    _urlController.text = project.url;
    _startProject(project.url, fallbackAppName: project.appName);
  }

  @override
  void dispose() {
    _scannerSub?.cancel();
    _scanner.dispose();
    _urlController.dispose();
    _liveConnection?.disconnect();
    _bundleLoader.close();
    _interpreterRunner.unmount();
    super.dispose();
  }

  /// Opens the launch/preview route (once) and kicks off the bundle fetch.
  ///
  /// The route shows the splash immediately, then the mounted guest. It is a
  /// separate native screen from the launcher, so returning home is a pop, not
  /// a root swap.
  void _startProject(String rawUrl, {String? fallbackAppName}) {
    _astProfileEnabled = false;
    _openPreviewRoute();
    unawaited(_launchProject(rawUrl, fallbackAppName: fallbackAppName));
  }

  void _openPreviewRoute() {
    if (_previewRouteOpen) return;
    _previewRouteOpen = true;
    // The navigator/App is only ready after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_previewRouteOpen) return;
      final navContext = _navKey.currentContext;
      if (navContext == null) {
        _previewRouteOpen = false;
        return;
      }
      Navigator.push<void>(
        navContext,
        PageRoute(
          settings: '/preview',
          builder: (_) => PreviewScreen(
            state: _previewState,
            probeKey: _guestProbeKey,
            onGoHome: _unmountApp,
            onRetry: () => _restartApp(),
            onLogToTerminal: _logToTerminal,
            onDismissError: _dismissGuestError,
          ),
        ),
      ).whenComplete(() {
        // Route left the stack (user swipe/back, or "Go Home").
        _previewRouteOpen = false;
        _teardownPreview();
      });
    });
  }

  /// Forwards a guest error to the CLI log sink.
  void _logToTerminal(String error) {
    print('[ERROR] [Interpreter Error] $error');
    _liveConnection?.sendDeviceLog(
      '[ERROR] [Interpreter Error] $error',
      level: 'ERROR',
    );
  }

  /// Fetches newly-needed icon-font bytes for [bundle] (no-op when the
  /// `iconFontsHash` matches the last sync). Patch-only reloads skip
  /// `/manifest.json`, so their fonts refresh via `GET /icon-fonts.json`.
  /// Never throws — font failures must not break a reload.
  Future<void> _syncIconFonts(ProjectBundle bundle) async {
    try {
      _iconFontManager ??= IconFontManager.fromLoader(
        _bundleLoader,
        bundle.serverUrl,
      );
      final manager = _iconFontManager!;
      if (bundle.isPatch) {
        final refreshed = await _bundleLoader.fetchIconFontsManifest(
          bundle.serverUrl,
          knownHash: manager.lastHash,
        );
        if (refreshed.hash != manager.lastHash) {
          await manager.syncEntries(refreshed.hash, refreshed.iconFonts);
        }
        return;
      }
      await manager.syncBundle(bundle);
    } catch (_) {}
  }

  /// Launches a project given its server URL.
  Future<void> _launchProject(String rawUrl, {String? fallbackAppName}) async {
    final serverUrl = BundleLoader.normalizeUrl(rawUrl);
    final launchSw = Stopwatch()..start();
    // A fresh launch supersedes any in-flight reload/restart — and any
    // earlier launch still awaiting its fetch.
    _reloadSeq++;
    _restartSeq++;
    final launchSeq = _reloadSeq;
    _isLoadingBundle = true;
    _errorMessage = null;
    _errorStackTrace = null;
    _statusMessage = 'Connecting to dev server...';
    _downloadProgress = null;
    _downloadedCount = null;
    _downloadTotal = null;
    _activeBundle = ProjectBundle(
      appName: fallbackAppName ?? 'DartNative App',
      serverUrl: serverUrl,
      sources: const {},
      entrypointCode: '',
      entrypointLibrary: 'main.dart',
    );
    _publishPreview();

    try {
      final bundleFetchSw = Stopwatch()..start();
      _statusMessage = 'Loading project manifest & bundle...';
      _publishPreview();

      // Load saved runtime mode to guarantee reopening in the configured engine
      final mode = await RuntimeModeStorage.loadMode();
      final useAst = flagsFromRuntimeMode(mode);
      _useAst = useAst;
      _interpreterRunner.useAst = _useAst;

      // 1. Fetch manifest & multi-file bundle
      final bundle = await _bundleLoader.fetchBundle(
        serverUrl,
        onlyAst: _useAst,
        onProgress: (downloaded, total) {
          if (mounted) {
            _downloadedCount = downloaded;
            _downloadTotal = total;
            _downloadProgress = total > 0 ? downloaded / total : null;
            _statusMessage = 'Downloading packages ($downloaded / $total)...';
            _publishPreview();
          }
        },
      );
      final bundleFetchMs = bundleFetchSw.elapsedMilliseconds;
      if (!mounted || launchSeq != _reloadSeq) return;

      // Fresh server connection: drop cached fonts, then fetch only the
      // families this bundle advertises (built-ins short-circuit locally).
      final iconFontsSw = Stopwatch()..start();
      _iconFontManager = IconFontManager.fromLoader(
        _bundleLoader,
        bundle.serverUrl,
      );
      await _syncIconFonts(bundle);
      final iconFontsMs = iconFontsSw.elapsedMilliseconds;
      if (!mounted || launchSeq != _reloadSeq) return;

      _activeBundle = bundle;
      // Sticky: patch-only reloads skip the manifest, so keep the last
      // known `--profile` state of this server connection.
      if (bundle.profileEnabled) _astProfileEnabled = true;
      _statusMessage = 'Connecting live hot reload...';
      _publishPreview();

      // 2. Connect WebSocket for live hot reload and logs
      _liveConnection?.disconnect();
      final websocketSw = Stopwatch()..start();
      _liveConnection = LiveConnection(
        serverUrl: bundle.serverUrl,
        onReload: (changed) => _reloadApp(changedFile: changed),
        onReloadBatch: (changedList, {bool isAssetChange = false}) =>
            _reloadApp(changedFiles: changedList, isAssetChange: isAssetChange),
        onRestart: () => _restartApp(),
        onBreakpoints: (bps) {
          _interpreterRunner.debugController.setBreakpoints(bps);
          _reloadApp();
        },
        onResume: () {
          _interpreterRunner.debugController.resume();
        },
        onSetVerbose: (enabled) {
          if (mounted) {
            _verboseLogs = enabled;
            DartGoLogger.verbose = enabled;
            _publishPreview();
          }
        },
        // UI automation: answer probe/tap requests from test scripts.
        // Probes prefer the reconciled DNTree (native viewIds) via the
        // guest probe key and fall back to the widget walk; taps resolve
        // through mounted elements for the same reason.
        // See `lib/src/runner/ui_probe.dart` + `test/test_lab/ui_automator.dart`.
        onUiProbeRequest: (requestId) {
          final probed = probeGuest(
            elementRoot: probeRootElement(_guestProbeKey),
            widgetRoot: _interpretedWidget,
          );
          _liveConnection?.sendUiTree(requestId, probed.tree);
        },
        onUiTap: (requestId, title, target) {
          final elementRoot = probeRootElement(_guestProbeKey);
          final widget = _interpretedWidget;
          final TargetSpec spec;
          if (target != null && target.isNotEmpty) {
            spec = TargetSpec.fromJson(target);
          } else if (title != null && title.isNotEmpty) {
            spec = TargetSpec(title: title);
          } else {
            spec = const TargetSpec();
          }
          final outcome = tapTarget(
            elementRoot: elementRoot,
            widgetRoot: widget,
            spec: spec,
          );
          if (outcome.ok && mounted) {
            // Rebuild so the tapped callback's effects become visible to the
            // next probe (guest setState/Provider notification still applies).
            setState(() {});
          }
          _liveConnection?.sendUiTapResult(
            requestId,
            outcome.ok,
            outcome.error,
          );
        },
        onUiScroll: (requestId, target, deltaX, deltaY) {
          final outcome = scrollTarget(
            elementRoot: probeRootElement(_guestProbeKey),
            widgetRoot: _interpretedWidget,
            spec: target != null && target.isNotEmpty
                ? TargetSpec.fromJson(target)
                : null,
            deltaX: deltaX,
            deltaY: deltaY,
          );
          if (outcome.ok && mounted) {
            setState(() {});
          }
          _liveConnection?.sendUiActionResult(
            'ui_scroll_result',
            requestId,
            outcome.ok,
            error: outcome.error,
            viewId: outcome.viewId,
          );
        },
        // UI automation triggers: hover / focus / blur / submit / type.
        // Resolve through the reconciled DNTree when available, else the
        // widget walk; state-changing actions rebuild for the next probe.
        onUiHover: (requestId, target) {
          final outcome = hoverTarget(
            widgetRoot: _interpretedWidget,
            elementRoot: probeRootElement(_guestProbeKey),
            spec: TargetSpec.fromJson(target),
          );
          _liveConnection?.sendUiActionResult(
            'ui_hover_result',
            requestId,
            outcome.ok,
            error: outcome.error,
            viewId: outcome.viewId,
          );
        },
        onUiFocus: (requestId, target) {
          final outcome = focusTarget(
            widgetRoot: _interpretedWidget,
            elementRoot: probeRootElement(_guestProbeKey),
            spec: TargetSpec.fromJson(target),
          );
          _liveConnection?.sendUiActionResult(
            'ui_focus_result',
            requestId,
            outcome.ok,
            error: outcome.error,
            viewId: outcome.viewId,
          );
        },
        onUiBlur: (requestId, target) {
          final outcome = blurTarget(
            widgetRoot: _interpretedWidget,
            elementRoot: probeRootElement(_guestProbeKey),
            spec: TargetSpec.fromJson(target),
          );
          _liveConnection?.sendUiActionResult(
            'ui_blur_result',
            requestId,
            outcome.ok,
            error: outcome.error,
            viewId: outcome.viewId,
          );
        },
        onUiSubmit: (requestId, target, text) {
          final outcome = submitTarget(
            widgetRoot: _interpretedWidget,
            elementRoot: probeRootElement(_guestProbeKey),
            spec: TargetSpec.fromJson(target),
            text: text,
          );
          if (outcome.ok && mounted) setState(() {});
          _liveConnection?.sendUiActionResult(
            'ui_submit_result',
            requestId,
            outcome.ok,
            error: outcome.error,
            viewId: outcome.viewId,
          );
        },
        onUiType: (requestId, target, text) {
          final outcome = typeIntoTarget(
            widgetRoot: _interpretedWidget,
            elementRoot: probeRootElement(_guestProbeKey),
            spec: TargetSpec.fromJson(target),
            text: text,
          );
          if (outcome.ok) {
            if (mounted) setState(() {});
            for (final sheet in NativeBottomSheetManager.activeSheets) {
              if (sheet.isScopeActive) {
                try {
                  sheet.triggerRebuild();
                } catch (_) {}
              }
            }
          }
          _liveConnection?.sendUiActionResult(
            'ui_type_result',
            requestId,
            outcome.ok,
            error: outcome.error,
            viewId: outcome.viewId,
          );
        },
      );
      await _liveConnection!.connect();
      final websocketMs = websocketSw.elapsedMilliseconds;
      final gotInitialVerbose = await _liveConnection!.waitForInitialVerbose();
      if (!gotInitialVerbose) {
        DartGoLogger.warn(
          '[WS] Initial verbose setting was not received; cold-load '
          'profiling may be incomplete.',
          tag: 'Runner',
        );
      }
      DartGoLogger.debug(
        '[PROFILE] project preparation: '
        'bundleFetch=${bundleFetchMs}ms, iconFonts=${iconFontsMs}ms, '
        'websocket=${websocketMs}ms',
        tag: 'Runner',
      );

      // 3. Compile and execute in the interpreter
      _statusMessage = 'Compiling & mounting application...';
      _publishPreview();

      WidgetGenerationTracker.resetAll();
      WidgetGenerationTracker.registerSources(bundle.sources);

      _interpreterRunner.currentServerUrl = bundle.serverUrl;
      _interpreterRunner.useAst = _useAst;
      final evaluationSw = Stopwatch()..start();
      _interpreterRunner.initInterpreter();
      final widget = await _interpreterRunner.evaluateBundle(
        bundle,
        isHotReload: false,
      );
      final evaluationMs = evaluationSw.elapsedMilliseconds;
      DartGoLogger.debug(
        '[PROFILE] project launch: '
        'bundleFetch=${bundleFetchMs}ms, iconFonts=${iconFontsMs}ms, '
        'websocket=${websocketMs}ms, evaluation=${evaluationMs}ms, '
        'total=${launchSw.elapsedMilliseconds}ms',
        tag: 'Runner',
      );
      if (_useAst) {
        WidgetGenerationTracker.registerClassFiles(
          _interpreterRunner.astRunner?.classFileMap ?? const {},
        );
      }

      if (!mounted || launchSeq != _reloadSeq) return;
      _interpretedWidget = widget;
      _isAppMounted = true;
      _isLoadingBundle = false;
      _publishPreview();
    } catch (e, stack) {
      final err = e.toString();
      DartGoLogger.error('Interpreter Error: $err', null, stack);
      if (!mounted || launchSeq != _reloadSeq) return;
      _recordError(err, stack);
    }
  }

  /// Re-evaluates updated code upon Hot Reload.
  Future<void> _reloadApp({
    String? changedFile,
    List<String>? changedFiles,
    bool isAssetChange = false,
  }) async {
    if (_activeBundle == null) return;
    final seq = ++_reloadSeq;
    final reloadSw = Stopwatch()..start();
    try {
      final fetchSw = Stopwatch()..start();
      final updatedBundle = await _bundleLoader.fetchBundle(
        _activeBundle!.serverUrl,
        onlyAst: _useAst,
        isHotReload: true,
        hasAssetChanges: isAssetChange,
      );
      final fetchMs = fetchSw.elapsedMilliseconds;
      if (!mounted || seq != _reloadSeq) return;
      _activeBundle = updatedBundle;
      await _syncIconFonts(updatedBundle);
      if (!mounted || seq != _reloadSeq) return;

      final trackSw = Stopwatch()..start();
      WidgetGenerationTracker.registerSources(updatedBundle.sources);
      if (_useAst) {
        WidgetGenerationTracker.registerClassFiles(
          _interpreterRunner.astRunner?.classFileMap ?? const {},
        );
      }
      final filesToNotify = <String>{};
      if (changedFiles != null && changedFiles.isNotEmpty) {
        filesToNotify.addAll(changedFiles);
      } else if (changedFile != null && changedFile.isNotEmpty) {
        filesToNotify.add(changedFile);
      }
      final isManualReload =
          (changedFiles == null || changedFiles.isEmpty) &&
          (changedFile == null || changedFile.isEmpty);
      WidgetGenerationTracker.notifyFilesChanged(
        filesToNotify,
        bumpAllIfEmpty: isManualReload,
      );
      final trackMs = trackSw.elapsedMilliseconds;

      final evalSw = Stopwatch()..start();
      _interpreterRunner.useAst = _useAst;
      final widget = await _interpreterRunner.evaluateBundle(
        updatedBundle,
        isHotReload: true,
      );
      final evalMs = evalSw.elapsedMilliseconds;
      if (_useAst) {
        WidgetGenerationTracker.registerClassFiles(
          _interpreterRunner.astRunner?.classFileMap ?? const {},
        );
      }

      if (!mounted || seq != _reloadSeq) return;
      final remountSw = Stopwatch()..start();
      _interpretedWidget = widget;
      _errorMessage = null;
      _errorStackTrace = null;
      _publishPreview();
      NativeBottomSheetManager.notifyHotReload(
        _interpreterRunner.activeVisitor,
        changedFile:
            changedFile ??
            (changedFiles != null && changedFiles.isNotEmpty
                ? changedFiles.first
                : null),
      );
      if (!isAssetChange) {
        WidgetGenerationTracker.notifyMountedWidgets(
          _interpreterRunner.activeVisitor,
        );
      }
      final remountMs = remountSw.elapsedMilliseconds;
      final totalMs = reloadSw.elapsedMilliseconds;

      DartGoLogger.reload(
        mode: _useAst ? 'AST' : 'Source',
        totalMs: totalMs,
        timings: {
          'fetch': fetchMs,
          'track': trackMs,
          'eval': evalMs,
          'remount': remountMs,
        },
      );
    } catch (e, stack) {
      final err = 'Hot Reload Error: $e';
      DartGoLogger.error(err, null, stack);
      if (!mounted || seq != _reloadSeq) return;
      // A failed RELOAD must not take down the working tree: the interpreter
      // rolled its generation back, so record the error for the on-device
      // surface (overlay banner or error screen, per setting) and keep
      // showing the mounted generation.
      _recordError(err, stack);
    }
  }

  /// Drops interpreter state and evaluates the current bundle fresh upon
  /// Hot Restart (test scripts: `restart` broadcast, usually `origin: test`).
  Future<void> _restartApp() async {
    if (_activeBundle == null) return;
    // A restart supersedes in-flight reloads and earlier restarts.
    _reloadSeq++;
    final seq = ++_restartSeq;
    final restartSw = Stopwatch()..start();
    try {
      if (mounted) {
        _statusMessage = 'Restarting application...';
        _errorMessage = null;
        _errorStackTrace = null;
        _publishPreview();
      }
      final mode = await RuntimeModeStorage.loadMode();
      final useAst = flagsFromRuntimeMode(mode);
      _useAst = useAst;

      final updatedBundle = await _bundleLoader.fetchBundle(
        _activeBundle!.serverUrl,
        onlyAst: _useAst,
      );
      if (!mounted || seq != _restartSeq) return;
      _activeBundle = updatedBundle;
      await _syncIconFonts(updatedBundle);
      if (!mounted || seq != _restartSeq) return;

      WidgetGenerationTracker.resetAll();
      WidgetGenerationTracker.registerSources(updatedBundle.sources);

      _interpreterRunner.unmount();
      _interpreterRunner.currentServerUrl = updatedBundle.serverUrl;
      _interpreterRunner.useAst = _useAst;
      _interpreterRunner.initInterpreter();
      final widget = await _interpreterRunner.evaluateBundle(
        updatedBundle,
        isHotReload: false,
      );

      if (!mounted || seq != _restartSeq) return;
      _interpretedWidget = widget;
      _isAppMounted = true;
      _isLoadingBundle = false;
      _errorMessage = null;
      _errorStackTrace = null;
      _publishPreview();
      DartGoLogger.bench(
        'Runner',
        'Hot Restart (${_useAst ? "AST" : "Source"})',
        restartSw.elapsedMilliseconds,
      );
    } catch (e, stack) {
      final err = 'Hot Restart Error: $e';
      DartGoLogger.error(err, null, stack);
      if (!mounted || seq != _restartSeq) return;
      _recordError(err, stack);
    }
  }

  void _cycleMode() {
    final current = runtimeModeFromBool(_useAst);
    _setMode(current.next);
  }

  /// Sets the active runtime mode directly and persists choice.
  void _setMode(RuntimeMode mode) {
    final nextAst = flagsFromRuntimeMode(mode);
    _useAst = nextAst;
    _interpreterRunner.useAst = _useAst;
    _publishPreview();
    RuntimeModeStorage.saveMode(mode);
    // The launcher app bar shows the active mode label; rebuild it.
    if (mounted) setState(() {});
    if (_isAppMounted) {
      _restartApp();
    }
  }

  /// Toggles verbose benchmark/diagnostic logs.
  void _setVerbose(bool enabled) {
    _verboseLogs = enabled;
    DartGoLogger.verbose = enabled;
    _liveConnection?.sendSetVerbose(enabled);
    _publishPreview();
  }

  /// Returns to the launcher: pops the preview route (and any screens the guest
  /// pushed above it) and tears the guest down.
  void _unmountApp() {
    if (_previewRouteOpen) {
      _previewRouteOpen = false;
      final navContext = _navKey.currentContext;
      if (navContext != null) {
        Navigator.popUntil(navContext, (route) => route.isFirst);
      }
    }
    _teardownPreview();
  }

  /// Clears interpreter/session state without touching the navigator. Called
  /// when the preview route leaves the stack (swipe back or [_unmountApp]).
  void _teardownPreview() {
    // Invalidate any in-flight launch/reload/restart so a pending fetch
    // cannot remount after the user goes home (e.g. bailing out of a
    // stuck load via the floating DevTools button).
    _reloadSeq++;
    _restartSeq++;
    _liveConnection?.disconnect();
    _liveConnection = null;
    WidgetGenerationTracker.resetAll();
    _interpreterRunner.unmount();
    _isAppMounted = false;
    _isLoadingBundle = false;
    _interpretedWidget = null;
    _errorMessage = null;
    _errorStackTrace = null;
    _activeBundle = null;
    _iconFontManager = null;
    _statusMessage = 'Connecting to project...';
    _downloadProgress = null;
    _downloadedCount = null;
    _downloadTotal = null;
    _publishPreview();
  }

  /// Builds the floating DevTools surface laid above every route.
  ///
  /// This is the host `App`'s [App.builder]: the builder's widget is laid out
  /// in a transparent, full-screen layer above every route, so the button stays
  /// reachable while the guest pushes its own screens — and unlike a root
  /// [Overlay] entry it is an ordinary widget layer, so taps reach it. [child]
  /// stands in for the routes (and the app overlay) and shows through the
  /// stack.
  ///
  /// Reload is a no-op while a bundle is loading (there is nothing to restart
  /// yet); Home cancels back to the launcher.
  ///
  /// Listens to [_previewState] so the surface refreshes on every state change
  /// without the host root rebuilding.
  Widget _buildDevToolsOverlay(BuildContext context, Widget? child) {
    return ValueListenableBuilder<PreviewState>(
      valueListenable: _previewState,
      builder: (context, s, _) {
        return DevToolOverlay(
          appName: s.appName,
          appVersion: s.appVersion,
          serverUrl: s.serverUrl,
          isConnected: s.isConnected,
          onGoHome: _unmountApp,
          onReload: () {
            if (_isLoadingBundle) return;
            _restartApp();
          },
          depCache: _bundleLoader.depCache,
          runtimeModeLabel: runtimeModeFromBool(_useAst).label,
          useAst: _useAst,
          onSelectMode: _setMode,
          onCycleMode: _cycleMode,
          verboseLogs: _verboseLogs,
          onToggleVerbose: _setVerbose,
          errorDisplayMode: _errorDisplayMode,
          onSelectErrorMode: _setErrorDisplayMode,
          astProfile: _useAst && _astProfileEnabled
              ? _interpreterRunner.astRunner?.lastAstProfile
              : null,
          // The routes (and the app overlay) show through underneath.
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // The launcher is the App's root route; opening a project pushes the
    // separate launch/preview route on top of it. The floating DevTools
    // surface is the App's builder, a layer above every route, so it stays
    // reachable while the guest pushes its own screens.
    return App(
      key: _navKey,
      builder: _buildDevToolsOverlay,
      home: LauncherScreen(
        projects: _projects,
        isLoading: _isLoading,
        urlController: _urlController,
        onUrlSubmitted: (value) async {
          if (value.trim().isEmpty) return;
          final project = await _scanner.addManualProject(value);
          _urlController.clear();
          _startProject(project.url, fallbackAppName: project.appName);
        },
        onSelectProject: (project) {
          _urlController.text = project.url;
          _startProject(project.url, fallbackAppName: project.appName);
        },
        onRescan: () => _scanner.scanNow(),
        onCycleMode: _cycleMode,
        runtimeModeLabel: runtimeModeFromBool(_useAst).label,
      ),
    );
  }
}

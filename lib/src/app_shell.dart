import 'dart:async';

import 'package:app_links_kit/app_links_kit.dart';
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import 'client/deep_link.dart';
import 'client/error_display_storage.dart';
import 'client/network_scanner.dart';
import 'client/project_model.dart';
import 'client/project_storage.dart';
import 'client/runtime_mode_storage.dart';
import 'devtool/devtool_overlay.dart';
import 'interpreter/widget_generation_tracker.dart';
import 'launcher/launcher_screen.dart';
import 'preview/preview_route.dart';
import 'runner/bundle_loader.dart';
import 'runner/guest_error_format.dart';
import 'runner/guest_runner.dart';
import 'runner/icon_font_manager.dart';
import 'runner/live_connection.dart';
import 'runner/logger.dart';
import 'runner/native_bottomsheet_manager.dart';
import 'runner/runtime_mode.dart';
import 'runner/ui_probe.dart';
import 'theme/theme_providers.dart';

/// Host shell: launcher, preview route, guest mounting and DevTools overlay.
///
/// The runtime is injected as [GuestRunnerBuilder] so both entrypoints share
/// this library without importing either engine directly.
class DartNativeGo extends StatefulWidget {
  const DartNativeGo({super.key, required this.createRunner});

  final GuestRunnerBuilder createRunner;

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

  /// Incoming `dartnativego://` links (see [_listenForDeepLinks]).
  StreamSubscription<Uri>? _deepLinkSub;

  /// Auto-connect to the first online dev server the scanner discovers.
  /// Enabled by default in JIT/debug builds; override with `--dart-define=DARTNATIVE_AUTO_CONNECT=true|false`.
  static const String _autoConnectOverride = String.fromEnvironment(
    'DARTNATIVE_AUTO_CONNECT',
  );

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
  late GuestRunner _interpreterRunner;
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

  /// Monotonic tokens to ensure only the newest lifecycle operation commits.
  int _reloadSeq = 0;
  int _restartSeq = 0;

  /// Keys the guest subtree so hot restart discards and replaces State.
  int _guestEpoch = 0;

  double? _downloadProgress;
  int? _downloadedCount;
  int? _downloadTotal;

  /// Resolves the guest-root element for UI automation probe.
  final GlobalKey _guestProbeKey = GlobalKey();

  /// Root navigator key for pushing preview routes and DevTools navigation.
  final GlobalKey _navKey = GlobalKey();

  /// Publishes preview state updates to the route and DevTools overlay.
  final ValueNotifier<PreviewState> _previewState = ValueNotifier(
    const PreviewState(),
  );

  /// True once the guest paints a frame, distinguishing startup failures.
  bool _guestRendered = false;

  /// Set when a guest exception occurred before the first frame was rendered.
  bool _guestLoadFailed = false;

  /// True while the preview route is active on the navigator.
  bool _previewRouteOpen = false;

  /// Timestamp when the preview route was pushed, used to await splash settle.
  DateTime? _previewRoutePushedAt;

  static const Duration _previewTransition = Duration(milliseconds: 350);
  static const Duration _splashSettle = Duration(milliseconds: 120);

  @override
  void initState() {
    super.initState();
    DartGoLogger.logSink = (msg, {level = 'INFO'}) {
      _liveConnection?.sendDeviceLog(msg, level: level);
    };
    _interpreterRunner = widget.createRunner(
      onLog: (msg) => _liveConnection?.sendDeviceLog(msg),
      onExit: _unmountApp,
      useAst: _useAst,
      onGuestError: (error, stack) => _showGuestErrorBanner(error, stack),
    );
    _bundleLoader.breakpointInstrumenter =
        _interpreterRunner.breakpointInstrumenter;
    _restoreSavedRuntimeMode();
    _initScanner();
    _listenForDeepLinks();
  }

  /// Opens projects handed to the app as `dartnativego://` links.
  ///
  /// `app_links_kit` replays the link that cold-started the app to the first
  /// listener, so one subscription covers both the launch link and warm ones
  /// (a link tapped while the app is already running). Off iOS/Android the
  /// plugin is a no-op, so this is inert in `dn test` and on desktop.
  void _listenForDeepLinks() {
    try {
      _deepLinkSub = AppLinks().uriLinkStream.listen(
        (uri) {
          final link = DartGoDeepLink.tryParse(uri);
          if (link != null) _openDeepLink(link);
        },
        onError: (Object e) {
          DartGoLogger.debug('[DEEPLINK] stream error: $e', tag: 'Runner');
        },
      );
    } catch (e) {
      // A missing native side must never take the app down.
      DartGoLogger.debug('[DEEPLINK] unavailable: $e', tag: 'Runner');
    }
  }

  /// Launches (or switches to) the project a deep link names.
  void _openDeepLink(DartGoDeepLink link) {
    if (!mounted) return;
    final alreadyOpen =
        _previewRouteOpen && _activeBundle?.serverUrl == link.serverUrl;
    if (alreadyOpen) return;

    DartGoLogger.info(
      '[DEEPLINK] Opening ${link.serverUrl}'
      '${link.appName == null ? '' : ' (${link.appName})'}',
    );
    // Switching projects: drop the current guest and session, then reuse the
    // preview route already on screen (no pop/push race). `_startProject`
    // pushes the route when the launcher is showing.
    if (_previewRouteOpen) _teardownPreview();
    _startProject(link.serverUrl, fallbackAppName: link.appName);
  }

  Future<void> _restoreSavedRuntimeMode() async {
    final mode = supportedRuntimeMode(await RuntimeModeStorage.loadMode());
    final useAst = flagsFromRuntimeMode(mode);
    final errorDisplayMode = await ErrorDisplayStorage.loadMode();
    _useAst = useAst;
    _interpreterRunner.useAst = _useAst;
    _errorDisplayMode = errorDisplayMode;
    _publishPreview();
  }

  /// Updates preview state without triggering a host root rebuild.
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
      guestEpoch: _guestEpoch,
      failedToStart: _guestLoadFailed,
    );
  }

  /// Records a guest failure for the on-device error surface without
  /// unmounting the working tree. The same failure is already on the CLI
  /// through [DartGoLogger]; this only decides what the device shows.
  ///
  /// A failure **before the guest has painted its first frame** is a load
  /// failure, not a runtime one: the project never came up, so there is no
  /// working tree to keep behind a banner. Those take over the screen with
  /// [InterpreterErrorView] (see [_failGuestLoad]).
  void _showGuestErrorBanner(Object error, [StackTrace? stack]) {
    if (!mounted) return;
    if (!_guestRendered) {
      _failGuestLoad(error, stack);
      return;
    }
    final formatted = formatGuestError(error, stack);
    final msg = 'Guest runtime error: ${formatted.message}';
    if (_errorMessage == msg) return;
    _errorMessage = msg;
    _errorStackTrace = formatted.stack;
    _publishPreview();
  }

  /// Shows the full-screen error view for a guest that failed to load.
  ///
  /// Drops the mounted widget (so the route hits its `widget == null` branch
  /// regardless of the persisted [ErrorDisplayMode]) and stops the broken tree
  /// from being rebuilt — which is what made the same exception get reported
  /// over and over.
  void _failGuestLoad(Object error, StackTrace? stack) {
    if (_guestLoadFailed) return;
    _guestLoadFailed = true;
    final formatted = formatGuestError(error, stack);
    _errorMessage = 'Guest failed to start: ${formatted.message}';
    _errorStackTrace = formatted.stack;
    _isAppMounted = false;
    _interpretedWidget = null;
    _isLoadingBundle = false;
    // The report comes from inside the guest's build (`_runWithLogCapture`),
    // so publishing here would rebuild the preview route mid-frame. Let the
    // frame finish first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _publishPreview();
    });
  }

  /// Marks the guest as rendered once its first frame has been committed.
  ///
  /// Publishing the mounted tree only marks the preview route dirty, so the
  /// guest actually builds in the *next* frame — and an exception thrown there
  /// (the reported case: a bridged constructor failing inside `build`) is
  /// reported during that build, before any post-frame callback runs. Waiting
  /// two frames therefore guarantees the flag cannot flip before the guest has
  /// had its first build, so such a failure stays a load failure.
  void _markGuestRendered() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // `_isAppMounted` is cleared synchronously by [_failGuestLoad], so a
        // tree that failed to build never marks itself rendered.
        if (mounted && _isAppMounted && !_guestLoadFailed) {
          _guestRendered = true;
        }
      });
    });
  }

  void _recordError(String message, [StackTrace? stack]) {
    _errorMessage = message;
    _errorStackTrace = stack?.toString();
    _publishPreview();
  }

  /// Records a failure that stopped the project from starting (bundle
  /// evaluation threw, or the first build never completed).
  ///
  /// Marks the state as "failed to start" so the full-screen error view says
  /// so, instead of reading like a crash in an app that was running.
  void _recordStartupError(String message, [StackTrace? stack]) {
    _guestLoadFailed = true;
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
    _deepLinkSub?.cancel();
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
      _previewRoutePushedAt = DateTime.now();
      Navigator.push<void>(
        navContext,
        PageRoute(
          settings: '/preview',
          // Its own scope: the route is a separate native screen, so it does
          // not inherit the launcher's inherited widgets. Wrapping here keeps
          // the splash, the guest overlay and the error view on the shell
          // palette (and following `system`).
          builder: (_) => ShellThemeScope(
            child: PreviewScreen(
              state: _previewState,
              probeKey: _guestProbeKey,
              onGoHome: _unmountApp,
              onRetry: () => _restartApp(),
              onDismissError: _dismissGuestError,
            ),
          ),
        ),
      ).whenComplete(() {
        // Route left the stack (user swipe/back, or "Go Home").
        _previewRouteOpen = false;
        _previewRoutePushedAt = null;
        _teardownPreview();
      });
    });
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

  /// Completes after the framework has committed the next frame.
  ///
  /// The dartnative framework's `WidgetsBinding` exposes no `endOfFrame`, so
  /// this awaits the next post-frame callback. Bounded by a timeout: a launch
  /// must never stall waiting for a frame the platform is not scheduling
  /// (backgrounded app, a binding that never got a frame).
  Future<void> _awaitFrame() {
    final done = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!done.isCompleted) done.complete();
    });
    return done.future.timeout(
      const Duration(milliseconds: 250),
      onTimeout: () {},
    );
  }

  /// Waits until the splash has finished its entrance transition and its
  /// newest status frame has painted.
  ///
  /// Guest evaluation (analyzer / AST interpretation) runs on the UI isolate
  /// and can take hundreds of milliseconds. Starting it while the preview
  /// route is still sliding in freezes the transition half-drawn — the splash
  /// visibly sticks mid-animation until the guest is ready. So: paint the
  /// current status, let the route animation finish, then paint once more
  /// before the isolate goes busy.
  Future<void> _awaitSplashSettled() async {
    await _awaitFrame();
    final pushedAt = _previewRoutePushedAt;
    final remaining = pushedAt == null
        ? _splashSettle
        : _previewTransition +
              _splashSettle -
              DateTime.now().difference(pushedAt);
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    await _awaitFrame();
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
    // A fresh launch has not rendered anything yet: failures until the first
    // frame are load failures.
    _guestRendered = false;
    _guestLoadFailed = false;
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
      final mode = supportedRuntimeMode(await RuntimeModeStorage.loadMode());
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
          _interpreterRunner.setBreakpoints(bps);
          _reloadApp();
        },
        onResume: () {
          _interpreterRunner.resumeDebugger();
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

      // Let the splash finish sliding in and paint this status before the
      // synchronous evaluation below blocks the UI isolate — otherwise the
      // transition freezes halfway until the guest is ready.
      await _awaitSplashSettled();
      if (!mounted || launchSeq != _reloadSeq) return;

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
      _markGuestRendered();
    } catch (e, stack) {
      final err = e.toString();
      DartGoLogger.error('Interpreter Error: $err', null, stack);
      if (!mounted || launchSeq != _reloadSeq) return;
      _recordStartupError(err, stack);
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
    // Deliberately no splash here: a hot reload keeps the guest mounted and is
    // the fast path, so it must stay as instant as before. The splash overlay
    // belongs to a restart (DevTools Reload) and to a fresh launch.
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
    // A restart discards interpreter state, so the old tree is torn down
    // *before* the new evaluation (while the old interpreter is still alive to
    // run guest `dispose`). The route then shows the plain splash — exactly as
    // on a fresh launch — instead of a frozen copy of the old UI.
    _statusMessage = 'Restarting application...';
    _errorMessage = null;
    _errorStackTrace = null;
    // The restarted tree has not rendered yet either.
    _guestRendered = false;
    _guestLoadFailed = false;
    _isAppMounted = false;
    _interpretedWidget = null;
    _publishPreview();
    // Paint the splash before the isolate blocks.
    await _awaitFrame();
    if (!mounted || seq != _restartSeq) return;
    try {
      final mode = supportedRuntimeMode(await RuntimeModeStorage.loadMode());
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
      // A hot restart must rebuild the guest from scratch: bump the epoch in
      // the same publish that installs the new tree, so Flutter discards the
      // previous elements (and their State) rather than reusing them.
      _guestEpoch++;
      _publishPreview();
      _markGuestRendered();
      DartGoLogger.bench(
        'Runner',
        'Hot Restart (${_useAst ? "AST" : "Source"})',
        restartSw.elapsedMilliseconds,
      );
    } catch (e, stack) {
      final err = 'Hot Restart Error: $e';
      DartGoLogger.error(err, null, stack);
      if (!mounted || seq != _restartSeq) return;
      // `_isAppMounted` is still false, so the route shows the full-screen
      // error view with its Retry/Home actions rather than a broken tree.
      _recordStartupError(err, stack);
    }
  }

  void _cycleMode() {
    final current = runtimeModeFromBool(_useAst);
    _setMode(current.next);
  }

  /// Sets the active runtime mode directly and persists choice.
  void _setMode(RuntimeMode mode) {
    mode = supportedRuntimeMode(mode);
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
    // cannot remount after the preview route leaves the stack (swipe back,
    // Go Home from DevTools, or an error view's Home action).
    _reloadSeq++;
    _restartSeq++;
    // The next mount must not reuse this session's element tree.
    _guestEpoch++;
    _guestRendered = false;
    _guestLoadFailed = false;
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

  /// Builds the floating DevTools surface overlaid across all routes.
  Widget _buildDevToolsOverlay(BuildContext context, Widget? child) {
    final content = child ?? const SizedBox.shrink();
    return ValueListenableBuilder<PreviewState>(
      valueListenable: _previewState,
      builder: (context, s, _) {
        // Overlay stays mounted; floating button and shake are gated by isAppMounted.
        return ShellThemeScope(
          child: DevToolOverlay(
            isEnabled: s.isAppMounted,
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
            child: content,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return App(
      key: _navKey,
      builder: _buildDevToolsOverlay,
      home: ShellThemeScope(
        child: LauncherScreen(
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
          onCycleMode: selectableRuntimeModes.length > 1 ? _cycleMode : null,
          runtimeModeLabel: runtimeModeFromBool(_useAst).label,
        ),
      ),
    );
  }
}

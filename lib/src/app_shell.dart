import 'dart:async';

import 'package:app_links_kit/app_links_kit.dart';
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go_api/host_api.dart' hide DartGoProject;
import 'package:dartnative_go_ui/dartnative_go_ui.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import 'client/deep_link.dart';
import 'client/error_display_storage.dart';
import 'client/network_scanner.dart';
import 'client/project_model.dart';
import 'client/project_storage.dart';
import 'client/runtime_mode_storage.dart';
import 'devtool/ast_profile_panel.dart';
import 'devtool/devtool_overlay.dart';
import 'host_api/shell_binding.dart';
import 'interpreter/widget_generation_tracker.dart';
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
import 'widgets/guest_error_banner.dart';
import 'widgets/interpreter_error_view.dart';

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
  late final ShellHostBinding _hostBinding;
  void Function()? _stopThemeListen;
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
  // ignore: unused_field
  static const bool _isProductBuild = bool.fromEnvironment('dart.vm.product');

  bool get _autoConnectEnabled {
    if (_autoConnectOverride == 'true') return true;
    if (_autoConnectOverride == 'false') return false;
    return false;
    // return !_isProductBuild;
  }

  /// Guards [_maybeAutoConnect] so one app launch connects at most once.
  bool _autoConnectAttempted = false;

  // Active Runner & Guest App State
  bool _isAppMounted = false;
  bool _isLoadingBundle = false;
  String _statusMessage = 'Connecting to project...';
  String? _errorMessage;

  /// Exception type of the current failure (`Argument Error`, `Bad state`, …),
  /// shown as the error view's subtitle. Null when the message names none.
  String? _errorType;
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

  /// Last failure left no rendered child (blank surface).
  bool _guestBlankBuild = false;

  /// Blank surface cannot repaint in place (stateless) — recovery remounts.
  bool _blankBuildNeedsRemount = false;

  /// Set by [onAstGuestBlankBuild] just before the matching [onAstGuestError].
  bool _pendingBlankBuild = false;
  bool _pendingBlankNeedsRemount = false;

  /// Waiting for [onAstGuestRecovered] before clearing the error surface.
  bool _awaitingScreenRecovery = false;

  /// User opened [InterpreterErrorView] from the floating banner.
  bool _errorViewExpanded = false;

  /// Monotonic guest-failure count; recovery ignores stale clears.
  int _errorSeq = 0;

  /// True while the preview route is active on the navigator.
  bool _previewRouteOpen = false;

  /// True when the previewed UI renders its own DevTools (the UI package).
  ///
  /// The guest claims them through `DartGoHost.claimDevTools()`; the shell then
  /// hides its floating pill and sheet so only the guest's editable copy shows.
  bool _guestOwnsDevTools = false;

  /// Timestamp when the preview route was pushed, used to await splash settle.
  DateTime? _previewRoutePushedAt;

  static const Duration _previewTransition = Duration(milliseconds: 350);
  static const Duration _splashSettle = Duration(milliseconds: 120);

  @override
  void initState() {
    super.initState();
    _hostBinding = ShellHostBinding(
      readProjects: () => _projects,
      readRecentProjects: () => _scanner.recentProjects,
      readScanning: () => _isLoading,
      discoverProjects: _discoverForApi,
      refreshProjects: _refreshForApi,
      openProjectAt: _openProjectForApi,
      removeProjectAt: _removeProjectForApi,
      openLink: _openWithLinkForApi,
      cycleTheme: _toggleThemeForApi,
      readTheme: _readThemeForApi,
      writeTheme: _setThemeForApi,
      showDevTools: DevToolsHost.open,
      setGuestDevTools: _setGuestDevTools,
      readVerboseFlag: () => _verboseLogs,
      writeVerbose: _setVerbose,
      restartGuest: _reloadForApi,
      leavePreview: _unmountApp,
      readRuntimeMode: () => runtimeModeFromBool(_useAst).label,
      readRuntimeModes: () => [
        for (final mode in selectableRuntimeModes) mode.label,
      ],
      selectMode: _setModeByLabel,
      cycleMode: _cycleMode,
      readAppName: () => _activeBundle?.appName ?? 'DartNative App',
      readAppVersion: () => _activeBundle?.appVersion,
      readServerUrl: () => _activeBundle?.serverUrl ?? '',
      readConnected: () => _liveConnection?.isConnected ?? false,
      readCacheLabel: _dependencyCacheLabel,
      clearCache: _clearDependencyCache,
    );
    DartGoHost.bind(_hostBinding);
    DartGoLogger.logSink = (msg, {level = 'INFO'}) {
      _liveConnection?.sendDeviceLog(msg, level: level);
    };
    _interpreterRunner = widget.createRunner(
      onLog: (msg) => _liveConnection?.sendDeviceLog(msg),
      onExit: _unmountApp,
      useAst: _useAst,
      onGuestError: (error, stack) => _showGuestErrorBanner(error, stack),
      onGuestBlankBuild: _showGuestBlankBuild,
      onGuestRecovered: _handleGuestRecovered,
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

  /// Propagates live-socket open/close to the DevTools overlay and host API.
  void _onLiveConnectionChanged(bool _) {
    if (!mounted) return;
    _publishPreview();
    _hostBinding.notify();
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
      splashBackgroundColorDark: _activeBundle?.splashBackgroundColorDark,
      errorMessage: _errorMessage,
      errorType: _errorType,
      errorStackTrace: _errorStackTrace,
      errorDisplayMode: _errorDisplayMode,
      guestEpoch: _guestEpoch,
      failedToStart: _guestLoadFailed,
      guestBlankBuild: _guestBlankBuild,
    );
  }

  /// Records a guest failure for the on-device surface (CLI already logged it).
  ///
  /// Pre-first-frame failures are load failures → [_failGuestLoad].
  void _showGuestErrorBanner(Object error, [StackTrace? stack]) {
    if (!mounted) return;
    _errorSeq++;
    final blank = _pendingBlankBuild;
    final needsRemount = _pendingBlankNeedsRemount;
    _pendingBlankBuild = false;
    _pendingBlankNeedsRemount = false;
    if (!_guestRendered) {
      _guestBlankBuild = blank;
      _blankBuildNeedsRemount = needsRemount;
      _awaitingScreenRecovery = false;
      _errorViewExpanded = false;
      _failGuestLoad(error, stack);
      return;
    }
    final formatted = formatGuestError(error, stack);
    final summary = summarizeGuestError(formatted.message);
    final msg = summary.displayMessage;
    // A blank failure upgrades an already-shown message from banner to the
    // full-screen view; otherwise identical repeat reports are ignored.
    if (_errorMessage == msg &&
        _errorType == summary.type &&
        _guestBlankBuild == blank &&
        _blankBuildNeedsRemount == needsRemount) {
      return;
    }
    _errorMessage = msg;
    _errorType = summary.type;
    _errorStackTrace = formatted.stack;
    _guestBlankBuild = blank;
    _blankBuildNeedsRemount = needsRemount;
    // An in-place screen can report its own recovery; a stateless one is
    // repaired by remounting, so there is no surface to wait for.
    _awaitingScreenRecovery = blank && !needsRemount;
    if (blank) {
      // A blank failure is reported from inside the guest's build (the screen
      // never produced a child). Publishing now would mark the host overlay
      // dirty mid-frame; let the build finish, then show the full-screen view.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _publishPreview();
      });
    } else {
      _publishPreview();
    }
  }

  /// Marks the next guest report as a blank surface (no rendered child).
  void _showGuestBlankBuild(
    Object error,
    StackTrace stack, {
    required bool rebuildsInPlace,
  }) {
    _pendingBlankBuild = true;
    _pendingBlankNeedsRemount = !rebuildsInPlace;
  }

  /// Clears the error once a previously blank surface builds again.
  void _handleGuestRecovered() {
    if (!mounted || !_awaitingScreenRecovery) return;
    _awaitingScreenRecovery = false;
    // The signal comes from inside the successful guest build; publishing now
    // would mark the host overlay dirty mid-frame. Skip the clear if a newer
    // failure arrived in the meantime.
    final errorSeq = _errorSeq;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _errorSeq == errorSeq) _clearError();
    });
  }

  /// Clears the error surface once the rebuilt guest has had two frames to
  /// throw again. A newer failure leaves it in place (see [_errorSeq]).
  void _clearErrorAfterRecovery(int errorSeq) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _errorSeq == errorSeq) _clearError();
      });
    });
  }

  /// Full-screen load failure: drop the broken tree and stop repeat reports.
  void _failGuestLoad(Object error, StackTrace? stack) {
    if (_guestLoadFailed) return;
    _guestLoadFailed = true;
    final formatted = formatGuestError(error, stack);
    final summary = summarizeGuestError(formatted.message);
    _errorMessage = summary.displayMessage;
    _errorType = summary.type;
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

  /// Marks the guest rendered two frames after publish (first build must run
  /// first, or a throw during that build would be misclassified as runtime).
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
    _errorSeq++;
    final summary = summarizeGuestError(message);
    _errorMessage = summary.displayMessage;
    _errorType = summary.type;
    _errorStackTrace = stack?.toString();
    // A failed reload cannot repair a blank screen: keep the hard surface.
    _pendingBlankBuild = false;
    _pendingBlankNeedsRemount = false;
    _publishPreview();
  }

  /// Startup failure (bundle eval / first build); marks `failedToStart`.
  void _recordStartupError(String message, [StackTrace? stack]) {
    _guestLoadFailed = true;
    _errorSeq++;
    final summary = summarizeGuestError(message);
    _errorMessage = summary.displayMessage;
    _errorType = summary.type;
    _errorStackTrace = stack?.toString();
    _guestBlankBuild = false;
    _blankBuildNeedsRemount = false;
    _awaitingScreenRecovery = false;
    _errorViewExpanded = false;
    _pendingBlankBuild = false;
    _pendingBlankNeedsRemount = false;
    _publishPreview();
  }

  void _clearError() {
    if (_errorMessage == null && _errorStackTrace == null) return;
    _errorMessage = null;
    _errorType = null;
    _errorStackTrace = null;
    _guestBlankBuild = false;
    _blankBuildNeedsRemount = false;
    _awaitingScreenRecovery = false;
    _errorViewExpanded = false;
    _pendingBlankBuild = false;
    _pendingBlankNeedsRemount = false;
    _publishPreview();
  }

  void _dismissGuestError() {
    _clearError();
  }

  /// Opens the full-screen error view from the floating banner (opt-in).
  void _openErrorDetails() {
    if (!mounted || _errorMessage == null || _errorViewExpanded) return;
    setState(() => _errorViewExpanded = true);
  }

  /// Closes the full-screen error view, going back to the banner/app.
  void _closeErrorDetails() {
    if (!mounted || !_errorViewExpanded) return;
    setState(() => _errorViewExpanded = false);
  }

  Future<void> _initScanner() async {
    _scannerSub = _scanner.projectsStream.listen((projects) {
      if (mounted) {
        setState(() {
          _projects = projects;
          _isLoading = false;
        });
        _maybeAutoConnect(projects);
        _hostBinding.notify();
      }
    });

    await _scanner.start();
    if (mounted) {
      setState(() {
        _projects = _scanner.currentProjects;
        _isLoading = false;
      });
      _maybeAutoConnect(_scanner.currentProjects);
      _hostBinding.notify();
    }
  }

  Future<List<DartGoProject>> _discoverForApi() async {
    return _scanner.currentProjects;
  }

  Future<List<DartGoProject>> _refreshForApi() async {
    if (mounted) setState(() => _isLoading = true);
    _hostBinding.notify();
    await _scanner.scanNow();
    if (!mounted) return _scanner.currentProjects;
    setState(() {
      _projects = _scanner.currentProjects;
      _isLoading = false;
    });
    return _scanner.currentProjects;
  }

  void _openProjectForApi(String url, {String? appName}) {
    final alreadyOpen = _previewRouteOpen && _activeBundle?.serverUrl == url;
    if (alreadyOpen) return;
    if (_previewRouteOpen) _teardownPreview();
    _urlController.text = url;
    _startProject(url, fallbackAppName: appName);
  }

  Future<void> _removeProjectForApi(String url) async {
    await _scanner.removeProject(url);
    if (!mounted) return;
    setState(() {
      _projects = _scanner.currentProjects;
    });
  }

  Future<void> _openWithLinkForApi(String link) async {
    final trimmed = link.trim();
    if (trimmed.isEmpty) return;
    if (trimmed.toLowerCase().startsWith('dartnativego:')) {
      final parsed = DartGoDeepLink.tryParse(Uri.parse(trimmed));
      if (parsed != null) {
        _openDeepLink(parsed);
        return;
      }
    }
    final project = await _scanner.addManualProject(trimmed);
    if (!mounted) return;
    _openProjectForApi(project.url, appName: project.appName);
  }

  Future<String> _toggleThemeForApi() async {
    final container = ProviderScope.containerOf(context);
    await container.read(themePreferenceProvider.notifier).cycle();
    return container.read(themePreferenceProvider).name;
  }

  /// Selects a theme preference by name from the DevTools sheet.
  Future<String> _setThemeForApi(String mode) async {
    final preference =
        ThemePreference.values.asNameMap()[mode] ?? ThemePreference.system;
    final container = ProviderScope.containerOf(context);
    await container
        .read(themePreferenceProvider.notifier)
        .setPreference(
          preference,
        );
    return container.read(themePreferenceProvider).name;
  }

  /// Shows or hides the shell DevTools while a previewed UI owns its own.
  ///
  /// The guest claims from its `initState`, which runs inside the shell's
  /// build; `setState` there would throw, so the flag lands after the frame.
  void _setGuestDevTools(bool owns) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _guestOwnsDevTools == owns) return;
      setState(() => _guestOwnsDevTools = owns);
    });
  }

  /// Human-readable dependency-cache summary for the DevTools sheet.
  String _dependencyCacheLabel() {
    final cache = _bundleLoader.depCache;
    if (cache == null) return '0 B (0 packages)';
    return '${cache.getFormattedCacheSize()} '
        '(${cache.getCachedPackageCount()} packages)';
  }

  /// Empties the dependency cache from the DevTools sheet.
  Future<void> _clearDependencyCache() async {
    await _bundleLoader.depCache?.clearCache();
    if (mounted) _hostBinding.notify();
  }

  String _readThemeForApi() {
    try {
      return ProviderScope.containerOf(
        context,
      ).read(themePreferenceProvider).name;
    } catch (_) {
      return 'system';
    }
  }

  Future<void> _reloadForApi() async {
    if (_isLoadingBundle) return;
    await _restartApp();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stopThemeListen != null) return;
    final subscription = ProviderScope.containerOf(
      context,
    ).listen(themePreferenceProvider, (_, _) => _hostBinding.notify());
    _stopThemeListen = subscription.close;
  }

  @override
  void dispose() {
    _stopThemeListen?.call();
    DartGoHost.unbind(_hostBinding);
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
    // Persist as a recent only when a project is actually opened — discovery
    // alone must not inflate the Recents list.
    unawaited(
      _scanner.rememberOpenedProject(rawUrl, appName: fallbackAppName),
    );
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
    _guestBlankBuild = false;
    _blankBuildNeedsRemount = false;
    _awaitingScreenRecovery = false;
    _errorViewExpanded = false;
    _pendingBlankBuild = false;
    _pendingBlankNeedsRemount = false;
    _isLoadingBundle = true;
    _errorMessage = null;
    _errorType = null;
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
        onConnectionChanged: _onLiveConnectionChanged,
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
      // A patch has no manifest: keep the app name/version/splash the previous
      // bundle carried, or DevTools falls back to the placeholder name.
      _activeBundle = updatedBundle.withMetadataFrom(_activeBundle!);
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
      // A successful reload is also the recovery path for a hard failure, but
      // the error view must not come down until the fixed surface is actually
      // on screen — clearing it optimistically is what used to leave the user
      // on a blank page when a later rebuild did not repaint.
      //
      //  • A load failure dropped the tree, so the fresh widget is mounted.
      //  • A blank screen from a `State` proxy repaints itself through the
      //    hot-reload tracker below and reports `onGuestRecovered`; the error
      //    view stays until then.
      //  • A blank screen from a stateless proxy has no State to mark, so the
      //    guest tree is remounted (dropping the screens it pushed); the error
      //    is cleared after two clean frames.
      final dropped = _guestLoadFailed || !_isAppMounted;
      final hadError = _errorMessage != null;
      final errorSeq = _errorSeq;
      final resetRoutes =
          !dropped && hadError && _guestBlankBuild && _blankBuildNeedsRemount;
      if (resetRoutes) _popGuestRoutes();
      _interpretedWidget = widget;
      _pendingBlankBuild = false;
      _pendingBlankNeedsRemount = false;
      if (dropped) {
        _guestLoadFailed = false;
        _isAppMounted = true;
        _isLoadingBundle = false;
        _guestRendered = false;
      }
      _publishPreview();
      if (dropped) _markGuestRendered();
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
      if (hadError && !_awaitingScreenRecovery) {
        // Either the tree was remounted or the failure was a soft one: two
        // clean frames are enough to be sure the rebuilt surface did not throw
        // again before the error view is removed.
        _clearErrorAfterRecovery(errorSeq);
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
    // A restart discards interpreter state. Screens the guest pushed were built
    // from that interpreter, so drop them and land on the preview route before
    // re-evaluating: a stale pushed screen would otherwise be left on top.
    _popGuestRoutes();
    // A restart discards interpreter state, so the old tree is torn down
    // *before* the new evaluation (while the old interpreter is still alive to
    // run guest `dispose`). The route then shows the plain splash — exactly as
    // on a fresh launch — instead of a frozen copy of the old UI.
    _statusMessage = 'Restarting application...';
    _errorMessage = null;
    _errorType = null;
    _errorStackTrace = null;
    // The restarted tree has not rendered yet either.
    _guestRendered = false;
    _guestLoadFailed = false;
    _guestBlankBuild = false;
    _blankBuildNeedsRemount = false;
    _awaitingScreenRecovery = false;
    _errorViewExpanded = false;
    _pendingBlankBuild = false;
    _pendingBlankNeedsRemount = false;
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
      _errorType = null;
      _errorStackTrace = null;
      _guestBlankBuild = false;
      _blankBuildNeedsRemount = false;
      _awaitingScreenRecovery = false;
      _errorViewExpanded = false;
      _pendingBlankBuild = false;
      _pendingBlankNeedsRemount = false;
      // A hot restart must rebuild the guest from scratch: bump the epoch in
      // the same publish that installs the new tree, so DartNative discards the
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

  /// Selects a runtime mode by label from the DevTools sheet.
  void _setModeByLabel(String label) {
    for (final mode in selectableRuntimeModes) {
      if (mode.label.toLowerCase() == label.toLowerCase()) {
        _setMode(mode);
        return;
      }
    }
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
    _hostBinding.notify();
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
    _hostBinding.notify();
  }

  /// Pops every guest-pushed screen, leaving the preview route on top.
  ///
  /// A restart discards the interpreter, so screens pushed by the old tree
  /// would keep rendering proxies that no longer exist. The preview route
  /// stays: it is where the fresh tree mounts.
  void _popGuestRoutes() {
    final navContext = _navKey.currentContext;
    if (navContext == null || !_previewRouteOpen) return;
    try {
      Navigator.popUntil(navContext, _stopAtPreviewRoute);
    } catch (_) {
      // The framework may have no matching route (e.g. it was replaced); the
      // restart still publishes a fresh tree, so there is nothing else to do.
    }
  }

  /// `popUntil` predicate that stops at the host preview route.
  ///
  /// DartNative passes a *synthetic* route to the predicate (see
  /// `_SyntheticRoute` in the SDK): it exposes `isFirst` and the name given to
  /// `PageRoute.settings`, not a `PageRoute`. Testing `route is PageRoute` (or
  /// reading `route.settings`) never matched, so `popUntil` popped straight
  /// past the preview to the launcher — which made DevTools Reload go Home.
  static final bool Function(Route) _previewNamePredicate = ModalRoute.withName(
    '/preview',
  );

  static bool _stopAtPreviewRoute(Route route) =>
      stopAtHostPreviewRoute(route, byName: _previewNamePredicate);

  /// Returns to the launcher: pops the preview route (and any screens the guest
  /// pushed above it) and tears the guest down.
  void _unmountApp() {
    if (_previewRouteOpen) {
      final navContext = _navKey.currentContext;
      // Go Home must reach the launcher even when the guest has pushed
      // screens. `isFirst` is not dependable here (a native stack can treat
      // the pushed preview as its first screen, which left Home on the plugin
      // list), so drop guest routes by name and then pop the preview itself.
      if (navContext != null) {
        _popGuestRoutes();
        try {
          Navigator.pop(navContext);
        } catch (_) {
          // The preview may already have left the stack; teardown still
          // clears the session below.
        }
      }
      _previewRouteOpen = false;
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
    _errorType = null;
    _errorStackTrace = null;
    _guestBlankBuild = false;
    _blankBuildNeedsRemount = false;
    _awaitingScreenRecovery = false;
    _errorViewExpanded = false;
    _pendingBlankBuild = false;
    _pendingBlankNeedsRemount = false;
    _activeBundle = null;
    _iconFontManager = null;
    // A previewed UI that crashed before its dispose still must not leave the
    // shell DevTools hidden for the next project.
    _guestOwnsDevTools = false;
    _statusMessage = 'Connecting to project...';
    _downloadProgress = null;
    _downloadedCount = null;
    _downloadTotal = null;
    _publishPreview();
  }

  /// Builds the shell layer overlaid across all routes: DevTools plus the
  /// guest error surfaces.
  ///
  /// `App.builder` is the one layer the framework keeps above every route,
  /// including screens the guest pushes on the shared navigator. A failure on
  /// a pushed screen must surface here: inside the preview route it would be
  /// hidden behind that screen, leaving the user on a blank page.
  Widget _buildDevToolsOverlay(BuildContext context, Widget? child) {
    final content = child ?? const SizedBox.shrink();
    return ValueListenableBuilder<PreviewState>(
      valueListenable: _previewState,
      builder: (context, s, _) {
        final errorSurface = _buildGuestErrorSurface(s);
        // The floating pill defaults to the bottom-right, where it would sit on
        // top of the full-screen error view's actions and steal their taps. The
        // error view owns Home/Reload, so hide the pill while it is up. A
        // previewed UI that claimed DevTools renders its own editable copy.
        final devToolsEnabled =
            s.isAppMounted &&
            !_guestOwnsDevTools &&
            !previewStateNeedsFullScreenError(
              s,
              expanded: _errorViewExpanded,
            );
        final runtimeModeIndex = selectableRuntimeModes.indexOf(
          runtimeModeFromBool(_useAst),
        );
        // Overlay stays mounted; floating button and shake are gated by isAppMounted.
        return ShellThemeScope(
          child: DevToolOverlay(
            isEnabled: devToolsEnabled,
            appName: s.appName,
            appVersion: s.appVersion,
            serverUrl: s.serverUrl,
            isConnected: s.isConnected,
            onGoHome: _unmountApp,
            onReload: () {
              if (_isLoadingBundle) return;
              _restartApp();
            },
            cacheLabel: _dependencyCacheLabel(),
            onClearCache: _clearDependencyCache,
            runtimeModes: [
              for (final mode in selectableRuntimeModes) mode.label,
            ],
            selectedRuntimeModeIndex: runtimeModeIndex < 0
                ? 0
                : runtimeModeIndex,
            onSelectRuntimeMode: (index) =>
                _setMode(selectableRuntimeModes[index]),
            verboseLogs: _verboseLogs,
            onToggleVerbose: _setVerbose,
            extraSection: _useAst && _astProfileEnabled
                ? _buildAstProfileSection()
                : null,
            // A guest failure is drawn above the routes, below the button.
            errorSurface: errorSurface,
            // The routes (and the app overlay) show through underneath.
            child: content,
          ),
        );
      },
    );
  }

  /// The AST bundle explorer section, or null before the first evaluation.
  Widget? _buildAstProfileSection() {
    final profile = _interpreterRunner.astRunner?.lastAstProfile;
    if (profile == null) return null;
    return AstProfilePanel(profile: profile);
  }

  /// The guest failure surface for [s], or null when there is nothing to show.
  ///
  /// The floating banner is the automatic surface, so an invalid save or a
  /// screen that fails for a frame never flashes a full-screen takeover. The
  /// user opens `InterpreterErrorView` by tapping the banner; a project that
  /// never mounted (or the persisted full-screen mode) shows it directly.
  /// See [previewStateNeedsFullScreenError].
  Widget? _buildGuestErrorSurface(PreviewState s) {
    final message = s.errorMessage;
    if (message == null) return null;
    final fullScreen = previewStateNeedsFullScreenError(
      s,
      expanded: _errorViewExpanded,
    );
    if (fullScreen) {
      // A mounted app can retry the failing screen where it is; a project
      // that never came up needs a fresh evaluation (and the splash).
      final retryScreen = s.isAppMounted && !s.failedToStart;
      return InterpreterErrorView(
        errorMessage: message,
        stackTrace: s.errorStackTrace,
        onGoHome: _unmountApp,
        onRetry: retryScreen ? () => _retryFailedScreen() : () => _restartApp(),
        // Only the banner-opened view has somewhere to close back to; a load
        // failure owns the screen until Retry/Home.
        onClose: _errorViewExpanded ? _closeErrorDetails : null,
        // The exception type names what failed; the stage text is the fallback
        // when the message does not name one.
        errorType: s.errorType,
        subtitle: s.failedToStart
            ? 'The project did not finish loading'
            : s.guestBlankBuild
            ? 'This screen did not finish loading'
            : 'Runtime exception during execution',
      );
    }
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: GuestErrorBanner(
        errorMessage: message,
        errorType: s.errorType,
        onOpen: _openErrorDetails,
        onDismiss: _dismissGuestError,
        onRestart: () => _restartApp(),
      ),
    );
  }

  /// Retries the screen that failed without leaving the guest.
  ///
  /// The hot-reload path re-evaluates the bundle and marks mounted screen
  /// proxies dirty, so a pushed route repaints in place; a stateless screen is
  /// remounted by the recovery path in [_reloadApp]. The error view stays up
  /// until the rebuilt surface is on screen (see [_handleGuestRecovered]).
  Future<void> _retryFailedScreen() async {
    if (_activeBundle == null) {
      unawaited(_restartApp());
      return;
    }
    await _reloadApp();
  }

  @override
  Widget build(BuildContext context) {
    return App(
      key: _navKey,
      builder: _buildDevToolsOverlay,
      home: const ShellThemeScope(
        child: HostLauncher(),
      ),
    );
  }
}

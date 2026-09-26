import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/dartnative_plugin_registrant.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import 'src/client/network_scanner.dart';
import 'src/client/project_model.dart';
import 'src/client/project_storage.dart';
import 'src/devtool/devtool_overlay.dart';
import 'src/runner/bundle_loader.dart';
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
import 'src/widgets/guest_error_banner.dart';
import 'src/widgets/interpreter_error_view.dart';
import 'src/widgets/project_splash_screen.dart';
import 'src/launcher/launcher_screen.dart';

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
      onGuestError: (error, stack) =>
          _showGuestErrorBanner(error, stack),
    );
    _restoreSavedRuntimeMode();
    _initScanner();
  }

  Future<void> _restoreSavedRuntimeMode() async {
    final mode = await RuntimeModeStorage.loadMode();
    final useAst = flagsFromRuntimeMode(mode);
    final errorDisplayMode = await ErrorDisplayStorage.loadMode();
    if (!mounted) {
      _useAst = useAst;
      _interpreterRunner.useAst = _useAst;
      _errorDisplayMode = errorDisplayMode;
      return;
    }
    setState(() {
      _useAst = useAst;
      _interpreterRunner.useAst = _useAst;
      _errorDisplayMode = errorDisplayMode;
    });
  }

  /// Records a guest failure for the on-device error surface without
  /// unmounting the working tree. The same failure is already on the CLI
  /// through [DartGoLogger]; this only decides what the device shows.
  void _showGuestErrorBanner(Object error, [StackTrace? stack]) {
    final msg = 'Guest runtime error: $error';
    if (!mounted || _errorMessage == msg) return;
    setState(() {
      _errorMessage = msg;
      _errorStackTrace = stack?.toString();
    });
  }

  void _recordError(String message, [StackTrace? stack]) {
    setState(() {
      _errorMessage = message;
      _errorStackTrace = stack?.toString();
    });
  }

  void _clearError() {
    if (_errorMessage == null && _errorStackTrace == null) return;
    setState(() {
      _errorMessage = null;
      _errorStackTrace = null;
    });
  }

  void _dismissGuestError() {
    _clearError();
  }

  /// Sets how guest failures surface on the device and persists the choice.
  void _setErrorDisplayMode(ErrorDisplayMode mode) {
    setState(() {
      _errorDisplayMode = mode;
    });
    ErrorDisplayStorage.saveMode(mode);
  }

  Future<void> _initScanner() async {
    _scannerSub = _scanner.projectsStream.listen((projects) {
      if (mounted) {
        setState(() {
          _projects = projects;
          _isLoading = false;
        });
      }
    });

    await _scanner.start();
    if (mounted) {
      setState(() {
        _projects = _scanner.currentProjects;
        _isLoading = false;
      });
    }
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

  /// Launches a project given its server URL.
  Future<void> _launchProject(String rawUrl, {String? fallbackAppName}) async {
    final serverUrl = BundleLoader.normalizeUrl(rawUrl);
    // A fresh launch supersedes any in-flight reload/restart.
    _reloadSeq++;
    _restartSeq++;
    setState(() {
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
    });

    try {
      setState(() {
        _statusMessage = 'Loading project manifest & bundle...';
      });

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
            setState(() {
              _downloadedCount = downloaded;
              _downloadTotal = total;
              _downloadProgress = total > 0 ? downloaded / total : null;
              _statusMessage = 'Downloading packages ($downloaded / $total)...';
            });
          }
        },
      );
      if (!mounted) return;

      setState(() {
        _activeBundle = bundle;
        _statusMessage = 'Connecting live hot reload...';
      });

      // 2. Connect WebSocket for live hot reload and logs
      _liveConnection?.disconnect();
      _liveConnection = LiveConnection(
        serverUrl: bundle.serverUrl,
        onReload: (changed) => _reloadApp(changedFile: changed),
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
            setState(() {
              _verboseLogs = enabled;
              DartGoLogger.verbose = enabled;
            });
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

      // 3. Compile and execute in the interpreter
      setState(() {
        _statusMessage = 'Compiling & mounting application...';
      });

      WidgetGenerationTracker.resetAll();
      WidgetGenerationTracker.registerSources(bundle.sources);

      _interpreterRunner.currentServerUrl = bundle.serverUrl;
      _interpreterRunner.useAst = _useAst;
      _interpreterRunner.initInterpreter();
      final widget = await _interpreterRunner.evaluateBundle(
        bundle,
        isHotReload: false,
      );
      if (_useAst) {
        WidgetGenerationTracker.registerClassFiles(
          _interpreterRunner.astRunner?.classFileMap ?? const {},
        );
      }

      if (!mounted) return;
      setState(() {
        _interpretedWidget = widget;
        _isAppMounted = true;
        _isLoadingBundle = false;
      });
    } catch (e, stack) {
      final err = e.toString();
      DartGoLogger.error('Interpreter Error: $err', null, stack);
      if (!mounted) return;
      _recordError(err, stack);
    }
  }

  /// Re-evaluates updated code upon Hot Reload.
  Future<void> _reloadApp({String? changedFile}) async {
    if (_activeBundle == null) return;
    final seq = ++_reloadSeq;
    final reloadSw = Stopwatch()..start();
    try {
      final fetchSw = Stopwatch()..start();
      final updatedBundle = await _bundleLoader.fetchBundle(
        _activeBundle!.serverUrl,
        onlyAst: _useAst,
      );
      final fetchMs = fetchSw.elapsedMilliseconds;
      if (!mounted || seq != _reloadSeq) return;
      _activeBundle = updatedBundle;

      final trackSw = Stopwatch()..start();
      WidgetGenerationTracker.registerSources(updatedBundle.sources);
      if (_useAst) {
        WidgetGenerationTracker.registerClassFiles(
          _interpreterRunner.astRunner?.classFileMap ?? const {},
        );
      }
      if (changedFile != null && changedFile.isNotEmpty) {
        WidgetGenerationTracker.notifyFilesChanged({changedFile});
      } else {
        WidgetGenerationTracker.notifyFilesChanged(const {});
      }
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
      setState(() {
        _interpretedWidget = widget;
        _errorMessage = null;
        _errorStackTrace = null;
      });
      NativeBottomSheetManager.notifyHotReload(
        _interpreterRunner.activeVisitor,
        changedFile: changedFile,
      );
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
        setState(() {
          _statusMessage = 'Restarting application...';
          _errorMessage = null;
          _errorStackTrace = null;
        });
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
      setState(() {
        _interpretedWidget = widget;
        _isAppMounted = true;
        _isLoadingBundle = false;
        _errorMessage = null;
        _errorStackTrace = null;
      });
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
    setState(() {
      _useAst = nextAst;
      _interpreterRunner.useAst = _useAst;
    });
    RuntimeModeStorage.saveMode(mode);
    if (_isAppMounted) {
      _restartApp();
    }
  }

  void _unmountApp() {
    _liveConnection?.disconnect();
    _liveConnection = null;
    WidgetGenerationTracker.resetAll();
    _interpreterRunner.unmount();
    if (!mounted) return;
    setState(() {
      _isAppMounted = false;
      _isLoadingBundle = false;
      _interpretedWidget = null;
      _errorMessage = null;
      _errorStackTrace = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Loading state: Project Splash Screen while fetching bundle
    if (_isLoadingBundle) {
      return ProjectSplashScreen(
        appName: _activeBundle?.appName ?? 'DartNative App',
        splashUrl: _activeBundle?.splashUrl,
        iconUrl: _activeBundle?.iconUrl,
        backgroundColor: ProjectSplashScreen.parseHexColor(
          _activeBundle?.splashBackgroundColor,
        ),
        statusMessage: _statusMessage,
        downloadProgress: _downloadProgress,
        downloadedCount: _downloadedCount,
        downloadTotal: _downloadTotal,
      );
    }

    // 2. Mounted state: Show guest app wrapped in DevToolOverlay. A guest
    // failure either takes over the screen (fullscreen setting, or no tree
    // mounted yet) or floats on top of the working app (overlay setting).
    if (_isAppMounted) {
      if (_errorMessage != null &&
          (_interpretedWidget == null ||
              _errorDisplayMode == ErrorDisplayMode.fullscreen)) {
        return InterpreterErrorView(
          errorMessage: _errorMessage!,
          stackTrace: _errorStackTrace,
          onGoHome: _unmountApp,
          onRetry: () => _restartApp(),
          onLogToTerminal: (error) {
            print('🔴 [Interpreter Error] $error');
            _liveConnection?.sendDeviceLog(
              '🔴 [Interpreter Error] $error',
              level: 'ERROR',
            );
          },
        );
      }

      final overlay = DevToolOverlay(
        appName: _activeBundle?.appName ?? 'DartNative App',
        appVersion: _activeBundle?.appVersion,
        serverUrl: _activeBundle?.serverUrl ?? '',
        isConnected: _liveConnection?.isConnected ?? false,
        onGoHome: _unmountApp,
        onReload: () => _restartApp(),
        depCache: _bundleLoader.depCache,
        runtimeModeLabel: runtimeModeFromBool(_useAst).label,
        useAst: _useAst,
        onSelectMode: _setMode,
        onCycleMode: _cycleMode,
        verboseLogs: _verboseLogs,
        onToggleVerbose: (enabled) {
          setState(() {
            _verboseLogs = enabled;
            DartGoLogger.verbose = enabled;
          });
          _liveConnection?.sendSetVerbose(enabled);
        },
        errorDisplayMode: _errorDisplayMode,
        onSelectErrorMode: _setErrorDisplayMode,
        child: KeyedSubtree(
          key: _guestProbeKey,
          child: KeyedSubtree(
            key: const ValueKey('guest_root'),
            child:
                _interpretedWidget ??
                const Scaffold(
                  body: Center(child: Text('Evaluating widget...')),
                ),
          ),
        ),
      );
      if (_errorMessage != null && _interpretedWidget != null) {
        return Stack(
          fit: StackFit.expand,
          children: [
            overlay,
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GuestErrorBanner(
                errorMessage: _errorMessage!,
                stackTrace: _errorStackTrace,
                onDismiss: _dismissGuestError,
                onRestart: () => _restartApp(),
              ),
            ),
          ],
        );
      }
      return overlay;
    }

    // 3. Default state: Launcher Screen
    return LauncherScreen(
      projects: _projects,
      isLoading: _isLoading,
      urlController: _urlController,
      onUrlSubmitted: (value) async {
        if (value.trim().isNotEmpty) {
          final project = await _scanner.addManualProject(value);
          _urlController.clear();
          _launchProject(
            project.url,
            fallbackAppName: project.appName,
          );
        }
      },
      onSelectProject: (project) {
        print(
          '[DartNativeGo] Selected project from list: ${project.appName} (${project.url})',
        );
        _urlController.text = project.url;
        _launchProject(
          project.url,
          fallbackAppName: project.appName,
        );
      },
      onRescan: () => _scanner.scanNow(),
      onCycleMode: _cycleMode,
      runtimeModeLabel: runtimeModeFromBool(_useAst).label,
    );
  }
}

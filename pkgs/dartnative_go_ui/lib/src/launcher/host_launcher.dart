import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go_api/host_api.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';

import '../devtool/host_devtool_button.dart';
import '../devtool/host_devtool_sheet.dart';
import '../theme/host_ui_theme.dart';
import 'launcher_app_bar.dart';
import 'recent_projects_list.dart';
import 'server_url_input.dart';

/// Launcher the shell embeds, and the root widget `dart_go start` previews.
///
/// Every action goes through [DartGoHost]. When this widget is interpreted,
/// those calls hit the shell bridge; when the shell embeds it, they hit the
/// binding the shell installed.
///
/// The launcher owns its floating DevTools pill and sheet when it is previewed
/// as a guest, so the host actions (rescan, theme, mode, verbose, cache,
/// reload, home) are edited and hot-reloaded with the rest of this package. A
/// previewed copy also asks the shell to hide its overlay; the shell overlay
/// still serves guest projects that do not contain this package.
///
/// On the shell's home route there is no preview in progress, so the launcher
/// renders no pill — DevTools appears only once a project is being previewed,
/// exactly as before.
class HostLauncher extends StatefulWidget {
  const HostLauncher({super.key});

  @override
  State<HostLauncher> createState() => _HostLauncherState();
}

class _HostLauncherState extends State<HostLauncher> {
  static const List<String> _themeNames = ['system', 'light', 'dark'];
  static const List<String> _themeLabels = ['System', 'Light', 'Dark'];

  final TextEditingController _urlController = TextEditingController();
  List<DartGoProject> _projects = const [];
  bool _loading = true;
  String _theme = 'system';
  bool _verbose = false;
  String _appName = 'DartNative App';
  String? _appVersion;
  String _serverUrl = '';
  bool _isConnected = false;
  List<String> _runtimeModes = const ['AST'];
  int _runtimeModeIndex = 0;
  String _cacheLabel = '0 B (0 packages)';

  /// True when this copy runs as an interpreted guest previewed by the shell.
  bool _isPreviewed = false;

  DNSheetController? _devToolsSheet;

  @override
  void initState() {
    super.initState();
    _isPreviewed = DartGoHost.isPreviewed;
    if (_isPreviewed) {
      // Hide the shell's floating DevTools; this package renders its own.
      unawaited(_claimDevTools());
    }
    DartGoHost.addListener(_syncFromHost);
    _bootstrap();
  }

  @override
  void dispose() {
    if (_isPreviewed) {
      unawaited(_releaseDevTools());
    }
    try {
      _devToolsSheet?.dismiss();
    } catch (_) {}
    _devToolsSheet = null;
    DartGoHost.removeListener(_syncFromHost);
    _urlController.dispose();
    super.dispose();
  }

  /// Claims DevTools, tolerating an unbound host (standalone `dart run`).
  Future<void> _claimDevTools() async {
    try {
      await DartGoHost.claimDevTools();
    } catch (_) {}
  }

  /// Releases DevTools, tolerating a host that already tore down.
  Future<void> _releaseDevTools() async {
    try {
      await DartGoHost.releaseDevTools();
    } catch (_) {}
  }

  /// Copies the host snapshot into this widget's fields. Call inside setState.
  void _readHostState() {
    _loading = DartGoHost.isScanning;
    _theme = DartGoHost.theme;
    _verbose = DartGoHost.verbose;
    _runtimeModes = DartGoHost.runtimeModes;
    final modeIndex = _runtimeModes.indexOf(DartGoHost.runtimeModeLabel);
    _runtimeModeIndex = modeIndex < 0 ? 0 : modeIndex;
    _appName = DartGoHost.appName;
    _appVersion = DartGoHost.appVersion;
    _serverUrl = DartGoHost.serverUrl;
    _isConnected = DartGoHost.isConnected;
    _cacheLabel = DartGoHost.dependencyCacheLabel;
  }

  int get _themeIndex {
    final index = _themeNames.indexOf(_theme);
    return index < 0 ? 0 : index;
  }

  Future<void> _bootstrap() async {
    // try {
    //   final projects = await DartGoHost.discover();
    //   if (!mounted) return;
    //   setState(() {
    //     _readHostState();
    //     _projects = projects;
    //   });
    // } catch (_) {
    //   if (mounted) setState(() => _loading = false);
    // }
  }

  void _syncFromHost() {
    if (!mounted) return;
    setState(() {
      try {
        _readHostState();
        _projects = DartGoHost.projects;
      } catch (_) {}
    });
  }

  /// Runs [action], swallows a bridge failure, then re-reads the host state.
  ///
  /// [action] is `Function`, not a typed closure: interpreted callbacks are
  /// `dynamic Function(...)` and an annotated parameter would reject them.
  Future<void> _run(Function action) async {
    try {
      await action();
    } catch (_) {}
    _syncFromHost();
  }

  /// Opens this package's DevTools sheet.
  ///
  /// The launcher owns the sheet in both modes: embedded in the shell (home
  /// route) and previewed as a guest. It is built from this package so edits
  /// hot-reload with the rest of the UI; every action goes through the API.
  void _openDevTools() {
    if (_devToolsSheet != null) return;
    _devToolsSheet = showBottomSheet(
      context,
      detents: const [DNSheetDetent.medium, DNSheetDetent.large],
      initialDetent: DNSheetDetent.medium,
      showGrabber: true,
      builder: (ctx, controller) => HostDevToolSheet(
        controller: controller,
        appName: _appName,
        appVersion: _appVersion,
        serverUrl: _serverUrl,
        isConnected: _isConnected,
        runtimeModes: _runtimeModes,
        selectedRuntimeModeIndex: _runtimeModeIndex,
        onSelectRuntimeMode: (index) => _run(() async {
          await DartGoHost.setRuntimeMode(_runtimeModes[index]);
        }),
        themeModes: _themeLabels,
        selectedThemeIndex: _themeIndex,
        onSelectTheme: (index) => _run(() async {
          await DartGoHost.setTheme(_themeNames[index]);
        }),
        verbose: _verbose,
        onToggleVerbose: (value) => _run(() => DartGoHost.setVerbose(value)),
        cacheLabel: _cacheLabel,
        onClearCache: () => _run(() => DartGoHost.clearDependencyCache()),
        onRescan: () => _run(() async {
          await DartGoHost.refresh();
        }),
        onGoHome: () => _run(() => DartGoHost.goHome()),
        onReload: () => _run(() => DartGoHost.reload()),
      ),
      onDismissed: () {
        _devToolsSheet = null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HostUiTheme(
      mode: _theme,
      child: Builder(
        builder: (context) {
          final theme = context.theme;
          // The pill sits in a full-screen stack above the Scaffold, not in the
          // body: `MediaQuery` reports the screen, and inside the body its
          // origin is shifted down by the app bar, which pushed the default
          // bottom-right corner past the body's bottom edge (the pill then
          // never showed).
          final launcher = Scaffold(
            backgroundColor: theme.background,
            appBar: buildLauncherAppBar(context),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Development Server',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Connect to an active DartNative local dev server.',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ServerUrlInput(
                    controller: _urlController,
                    onSubmitted: (value) async {
                      final trimmed = value.trim();
                      if (trimmed.isEmpty) return;
                      await _run(() => DartGoHost.openWithLink(trimmed));
                      if (mounted) _urlController.clear();
                    },
                  ),
                  const SizedBox(height: 32),
                  RecentProjectsList(
                    projects: _projects,
                    isLoading: _loading,
                    onSelectProject: (project) =>
                        _run(() => DartGoHost.openProject(project)),
                  ),
                ],
              ),
            ),
          );
          // DevTools belongs to a preview in progress: the shell's home route
          // shows no pill, matching the shell overlay, which only appears once
          // a guest is mounted. A previewed copy renders and claims its own.
          final children = _isPreviewed
              ? <Widget>[
                  launcher,
                  HostDevToolButton(
                    theme: theme,
                    isConnected: _isConnected,
                    onTap: _openDevTools,
                  ),
                ]
              : <Widget>[launcher];
          return Stack(fit: StackFit.expand, children: children);
        },
      ),
    );
  }
}

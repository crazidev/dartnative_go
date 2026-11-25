import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:dngo_api/host_api.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';

import '../devtool/host_devtool_button.dart';
import '../devtool/host_devtool_sheet.dart';
import '../theme/host_ui_theme.dart';
import 'launcher_app_bar.dart';
import 'project_card.dart';
import 'recent_projects_list.dart';
import 'package:lucide_kit/lucide_kit.dart';

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
  static const List<String> _themeLabels = [
    'System (Automatic)',
    'Light',
    'Dark',
  ];
  static const List<IconData> _themeIcons = [
    LucideIcons.sunMoon,
    CupertinoIcons.sun_max_fill,
    CupertinoIcons.moon_stars_fill,
  ];
  static const List<String> _statLabels = [
    'DartNative Version',
    'SDK Version',
    'Runtime Version',
  ];

  final TextEditingController _urlController = TextEditingController();
  List<DartGoProject> _projects = const [];
  List<DartGoProject> _recentProjects = const [];
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
  int currentTab = 0;

  /// True when this copy runs as an interpreted guest previewed by the shell.
  bool _isPreviewed = false;

  /// Single sheet for floating DevTools and project long-press / inactive tap.
  DNSheetController? _sheet;

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
      _sheet?.dismiss();
    } catch (_) {}
    _sheet = null;
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

  void _selectTheme(int index) {
    final nextTheme = _themeNames[index];
    if (_theme == nextTheme) return;
    setState(() {
      _theme = nextTheme;
    });
    _run(() => DartGoHost.setTheme(nextTheme));
  }

  Future<void> _bootstrap() async {
    _syncFromHost();
  }

  void _syncFromHost() {
    if (!mounted) return;
    setState(() {
      try {
        _readHostState();
        _projects = DartGoHost.projects;
        _recentProjects = DartGoHost.recentProjects;
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

  List<DartGoProject> get _activeProjects => [
    for (final project in _projects)
      if (project.isActive) project,
  ];

  /// Tap on a recent row: open when online, otherwise show the sheet.
  void _onRecentProjectTap(DartGoProject project) {
    if (project.isActive) {
      _run(() => DartGoHost.openProject(project));
      return;
    }
    _openSheet(project: project);
  }

  /// Opens the shared DevTools sheet.
  ///
  /// With [project], secondary/primary become Remove / Open Project. Without,
  /// they stay Go Home / Reload for the floating pill (preview mode).
  void _openSheet({DartGoProject? project}) {
    if (_sheet != null) return;
    final forProject = project != null;
    _sheet = showBottomSheet(
      context,
      detents: const [DNSheetDetent.medium],
      initialDetent: DNSheetDetent.medium,
      showGrabber: true,
      cornerRadius: 30,
      builder: (ctx, controller) => HostDevToolSheet(
        controller: controller,
        appName: forProject ? project.appName : _appName,
        appVersion: forProject
            ? project.appVersion ?? _appVersion
            : _appVersion,
        serverUrl: forProject ? project.url : _serverUrl,
        isConnected: forProject ? project.isActive : _isConnected,
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
        secondaryActionIsRemove: forProject,
        primaryActionTitle: forProject ? 'Open Project' : 'Reload',
        onGoHome: () => _run(
          () => forProject
              ? DartGoHost.removeProject(project)
              : DartGoHost.goHome(),
        ),
        onReload: () => _run(
          () => forProject
              ? DartGoHost.openProject(project)
              : DartGoHost.reload(),
        ),
      ),
      onDismissed: () {
        _sheet = null;
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
            appBar: buildLauncherAppBar(
              context,
              title: switch (currentTab) {
                1 => "Plugins",
                2 => "Settings",
                _ => "DartNative Go",
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentTab,
              onTap: (value) {
                setState(
                  () {
                    currentTab = value;
                  },
                );
              },
              items: [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(CupertinoIcons.house_alt),
                  activeIcon: Icon(CupertinoIcons.house_alt_fill),
                ),
                BottomNavigationBarItem(
                  label: "Plugins",
                  icon: Icon(CupertinoIcons.app),
                  activeIcon: Icon(CupertinoIcons.app_fill),
                ),
                BottomNavigationBarItem(
                  label: "Settings",
                  icon: Icon(CupertinoIcons.gear_alt),
                  activeIcon: Icon(CupertinoIcons.gear_alt_fill),
                ),
              ],
            ),
            body: IndexedStack(
              index: currentTab,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Development Server'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 3),
                      if (_activeProjects.isEmpty) ...[
                        Text(
                          'Start a local development server with:',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.foreground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: theme.secondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.terminal_2,
                                color: theme.mutedForeground,
                                size: 25,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'dngo start',
                                style: TextStyle(
                                  color: theme.foreground,
                                  fontSize: 14,
                                  fontFamily: 'AndaleMono',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 5, top: 5),
                        //   child: Text(
                        //     'Select a local server when it appears here.',
                        //     style: TextStyle(
                        //       fontSize: 11,
                        //       color: theme.mutedForeground,
                        //     ),
                        //   ),
                        // ),
                      ] else
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListView.separated(
                            itemCount: _activeProjects.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => Divider(
                              color: theme.background,
                              height: 2,
                              thickness: 2,
                            ),
                            itemBuilder: (context, index) {
                              final project = _activeProjects[index];
                              return ProjectCard(
                                project: project,
                                position: ProjectPosition.at(
                                  index,
                                  _activeProjects.length,
                                ),
                                showActiveBadge: true,
                                onTap: (selected) => _run(
                                  () => DartGoHost.openProject(selected),
                                ),
                                onLongPress: (p) => _openSheet(project: p),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 32),
                      RecentProjectsList(
                        projects: _recentProjects,
                        isLoading: _loading,
                        onSelectProject: _onRecentProjectTap,
                        onLongPressProject: (p) => _openSheet(project: p),
                      ),
                    ],
                  ),
                ),

                Container(
                  child: Expanded(
                    child: Center(
                      child: Text("Coming soon"),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'THEME'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListView.separated(
                          itemCount: _themeLabels.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(
                            color: theme.background,
                            height: 2,
                            thickness: 2,
                          ),
                          itemBuilder: (context, index) {
                            final position = ProjectPosition.at(
                              index,
                              _themeLabels.length,
                            );
                            final isSelected = _themeIndex == index;
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _selectTheme(index),
                              child: ClipRRect(
                                borderRadius:
                                    position == ProjectPosition.firstAndLast
                                    ? BorderRadius.circular(15)
                                    : BorderRadius.vertical(
                                        top: position == ProjectPosition.first
                                            ? const Radius.circular(20)
                                            : const Radius.circular(0),
                                        bottom: position == ProjectPosition.last
                                            ? const Radius.circular(20)
                                            : const Radius.circular(0),
                                      ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 120),
                                  curve: Curves.easeOut,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.secondary,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        // decoration: BoxDecoration(
                                        //   color: isSelected
                                        //       ? theme.primary.withOpacity(0.18)
                                        //       : theme.muted,
                                        //   borderRadius: BorderRadius.circular(
                                        //     10,
                                        //   ),
                                        // ),
                                        child: Center(
                                          child: Icon(
                                            _themeIcons[index],
                                            size: 25,
                                            // color: isSelected
                                            //     ? theme.primary
                                            //     : theme.mutedForeground,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _themeLabels[index],
                                          style: TextStyle(
                                            // fontWeight: isSelected
                                            //     ? FontWeight.w600
                                            //     : FontWeight.w500,
                                            fontSize: 16,
                                            color: theme.cardForeground,
                                            // letterSpacing: -0.1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4,
                                        ),
                                        child: Icon(
                                          isSelected
                                              ? CupertinoIcons
                                                    .checkmark_circle_fill
                                              : CupertinoIcons.circle,
                                          size: 22,
                                          // color: isSelected
                                          //     ? theme.primary
                                          //     : theme.mutedForeground
                                          //           .withOpacity(0.45),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'ABOUT'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListView.separated(
                          itemCount: _statLabels.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(
                            color: theme.background,
                            height: 2,
                            thickness: 2,
                          ),
                          itemBuilder: (context, index) {
                            final position = ProjectPosition.at(
                              index,
                              _statLabels.length,
                            );
                            final statValues = [
                              DartGoHost.dartNativeVersion,
                              DartGoHost.dngoVersion,
                              DartGoHost.runtimeVersion,
                            ];
                            return ClipRRect(
                              borderRadius:
                                  position == ProjectPosition.firstAndLast
                                  ? BorderRadius.circular(15)
                                  : BorderRadius.vertical(
                                      top: position == ProjectPosition.first
                                          ? const Radius.circular(20)
                                          : const Radius.circular(0),
                                      bottom: position == ProjectPosition.last
                                          ? const Radius.circular(20)
                                          : const Radius.circular(0),
                                    ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                color: theme.secondary,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _statLabels[index],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: theme.cardForeground,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      statValues[index],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Courier',
                                        color: theme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                    onTap: _openSheet,
                  ),
                ]
              : <Widget>[launcher];
          return Stack(fit: StackFit.expand, children: children);
        },
      ),
    );
  }
}

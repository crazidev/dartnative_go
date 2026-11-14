import 'package:dartnative_go_api/host_api.dart';

import '../client/project_model.dart' as host;

/// Adapts shell callbacks to [DartGoHostBinding].
///
/// The shell owns the scanner, navigator, and theme controller. This class
/// only forwards and notifies listeners so both the embedded UI and an
/// interpreted preview see the same snapshot.
class ShellHostBinding implements DartGoHostBinding {
  ShellHostBinding({
    required this.readProjects,
    required this.readScanning,
    required this.discoverProjects,
    required this.refreshProjects,
    required this.openProjectAt,
    required this.openLink,
    required this.cycleTheme,
    required this.readTheme,
    required this.writeTheme,
    required this.showDevTools,
    required this.setGuestDevTools,
    required this.readVerboseFlag,
    required this.writeVerbose,
    required this.restartGuest,
    required this.leavePreview,
    required this.readRuntimeMode,
    required this.readRuntimeModes,
    required this.selectMode,
    required this.cycleMode,
    required this.readAppName,
    required this.readAppVersion,
    required this.readServerUrl,
    required this.readConnected,
    required this.readCacheLabel,
    required this.clearCache,
  });

  final List<host.DartGoProject> Function() readProjects;
  final bool Function() readScanning;
  final Future<List<host.DartGoProject>> Function() discoverProjects;
  final Future<List<host.DartGoProject>> Function() refreshProjects;
  final void Function(String url, {String? appName}) openProjectAt;
  final Future<void> Function(String link) openLink;
  final Future<String> Function() cycleTheme;
  final String Function() readTheme;
  final Future<String> Function(String mode) writeTheme;
  final void Function() showDevTools;
  final void Function(bool owns) setGuestDevTools;
  final bool Function() readVerboseFlag;
  final void Function(bool enabled) writeVerbose;
  final Future<void> Function() restartGuest;
  final void Function() leavePreview;
  final String Function() readRuntimeMode;
  final List<String> Function() readRuntimeModes;
  final void Function(String label) selectMode;
  final void Function() cycleMode;
  final String Function() readAppName;
  final String? Function() readAppVersion;
  final String Function() readServerUrl;
  final bool Function() readConnected;
  final String Function() readCacheLabel;
  final Future<void> Function() clearCache;

  final List<void Function()> _listeners = [];

  void notify() {
    for (final listener in List<void Function()>.of(_listeners)) {
      try {
        listener();
      } catch (_) {}
    }
  }

  static DartGoProject _convert(host.DartGoProject project) {
    return DartGoProject(
      appName: project.appName,
      url: project.url,
      isActive: project.isActive,
      appVersion: project.appVersion,
      iconUrl: project.iconUrl,
    );
  }

  static List<DartGoProject> _convertAll(List<host.DartGoProject> projects) {
    return [for (final project in projects) _convert(project)];
  }

  @override
  Future<List<DartGoProject>> discover() async {
    return _convertAll(await discoverProjects());
  }

  @override
  Future<List<DartGoProject>> refresh() async {
    final projects = _convertAll(await refreshProjects());
    notify();
    return projects;
  }

  @override
  List<DartGoProject> get projects => _convertAll(readProjects());

  @override
  bool get isScanning => readScanning();

  @override
  Future<void> openProject(DartGoProject project) async {
    openProjectAt(project.url, appName: project.appName);
  }

  @override
  Future<void> openWithLink(String link) => openLink(link);

  @override
  Future<String> toggleTheme() async {
    final next = await cycleTheme();
    notify();
    return next;
  }

  @override
  String get theme => readTheme();

  @override
  Future<String> setTheme(String mode) async {
    final next = await writeTheme(mode);
    notify();
    return next;
  }

  @override
  Future<void> openDevTools() async {
    showDevTools();
  }

  @override
  Future<void> claimDevTools() async {
    setGuestDevTools(true);
  }

  @override
  Future<void> releaseDevTools() async {
    setGuestDevTools(false);
  }

  @override
  bool get verbose => readVerboseFlag();

  @override
  Future<void> setVerbose(bool enabled) async {
    writeVerbose(enabled);
    notify();
  }

  @override
  Future<void> reload() => restartGuest();

  @override
  Future<void> goHome() async {
    leavePreview();
  }

  @override
  String get runtimeModeLabel => readRuntimeMode();

  @override
  List<String> get runtimeModes => readRuntimeModes();

  @override
  Future<void> setRuntimeMode(String label) async {
    selectMode(label);
    notify();
  }

  @override
  Future<void> cycleRuntimeMode() async {
    cycleMode();
    notify();
  }

  @override
  String get appName => readAppName();

  @override
  String? get appVersion => readAppVersion();

  @override
  String get serverUrl => readServerUrl();

  @override
  bool get isConnected => readConnected();

  @override
  String get dependencyCacheLabel => readCacheLabel();

  @override
  Future<void> clearDependencyCache() async {
    await clearCache();
    notify();
  }

  @override
  void addListener(void Function() listener) {
    if (!_listeners.contains(listener)) _listeners.add(listener);
  }

  @override
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }
}

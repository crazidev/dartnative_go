/// Actions the DartNative Go shell exposes to its UI.
///
/// Import this library from host UI code:
///
/// ```dart
/// import 'package:dartnative_go_api/host_api.dart';
///
/// final projects = await DartGoHost.discover();
/// await DartGoHost.openProject(projects.first);
/// ```
///
/// The same surface is re-exported as `package:dartnative_go/host_api.dart`.
/// The UI package imports this library directly so the shell can depend on
/// the UI without a package cycle. Interpreted guests never execute this
/// file: the shell bridges these URIs and forwards each call to the binding
/// it installed at startup.
library;

/// Library URIs the interpreter bridge and the AST bundler agree on.
///
/// A guest that imports any of these gets the host implementation, not a
/// bundled copy of this file (whose [DartGoHost.binding] would be a
/// different static).
const Set<String> kDartGoHostApiUris = {
  'package:dartnative_go_api/host_api.dart',
  'package:dartnative_go_api/dartnative_go_api.dart',
  'package:dartnative_go/host_api.dart',
};

/// A dev server the shell has discovered or the user has opened.
class DartGoProject {
  final String appName;
  final String url;
  final bool isActive;
  final String? appVersion;
  final String? iconUrl;

  const DartGoProject({
    required this.appName,
    required this.url,
    this.isActive = false,
    this.appVersion,
    this.iconUrl,
  });

  Map<String, Object?> toJson() => {
    'appName': appName,
    'url': url,
    'isActive': isActive,
    'appVersion': appVersion,
    'iconUrl': iconUrl,
  };

  factory DartGoProject.fromJson(Map<String, Object?> json) {
    return DartGoProject(
      appName: json['appName'] as String? ?? 'DartNative Project',
      url: json['url'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      appVersion: json['appVersion'] as String?,
      iconUrl: json['iconUrl'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DartGoProject && other.url == url && other.appName == appName;

  @override
  int get hashCode => Object.hash(url, appName);
}

/// What the shell must implement for [DartGoHost].
///
/// The native shell installs one of these at startup. Interpreted UI code
/// does not see this type; the bridge calls the installed binding.
abstract class DartGoHostBinding {
  /// Ensures discovery is running and returns the projects known so far.
  Future<List<DartGoProject>> discover();

  /// Forces a network rescan and returns the projects found.
  Future<List<DartGoProject>> refresh();

  /// Projects from the latest discovery snapshot.
  List<DartGoProject> get projects;

  /// True while a scan is in flight.
  bool get isScanning;

  /// Opens [project] in the host preview route.
  Future<void> openProject(DartGoProject project);

  /// Opens a server URL or a `dartnativego://` link.
  Future<void> openWithLink(String link);

  /// Cycles system → light → dark → system. Returns the new preference name.
  Future<String> toggleTheme();

  /// Current theme preference: `system`, `light`, or `dark`.
  String get theme;

  /// Opens the host DevTools sheet.
  Future<void> openDevTools();

  /// Tells the shell that this UI renders its own DevTools.
  ///
  /// `dartnative_go_ui` calls this from its preview entrypoint: the shell hides
  /// its floating DevTools pill and sheet so the guest's editable copy is the
  /// only one on screen. The shell restores its own DevTools on release or
  /// when the preview tears down.
  Future<void> claimDevTools();

  /// Releases the DevTools claimed with [claimDevTools].
  Future<void> releaseDevTools();

  /// Whether verbose host logs are on.
  bool get verbose;

  /// Turns verbose host logs on or off.
  Future<void> setVerbose(bool enabled);

  /// Restarts the mounted guest (DevTools Reload).
  Future<void> reload();

  /// Pops the preview route and returns to the launcher.
  Future<void> goHome();

  /// Label of the active runtime mode, for the launcher menu.
  String get runtimeModeLabel;

  /// Labels of the runtime modes this build can run, in selector order.
  List<String> get runtimeModes;

  /// Selects a runtime mode by label (`Source` / `AST`).
  Future<void> setRuntimeMode(String label);

  /// Cycles the host runtime mode (Source / AST) when more than one exists.
  Future<void> cycleRuntimeMode();

  /// Selects a theme preference by name (`system`, `light`, `dark`).
  Future<String> setTheme(String mode);

  /// Name of the project currently previewed (or the last one opened).
  String get appName;

  /// Version reported by the previewed project's manifest, when known.
  String? get appVersion;

  /// Dev server URL of the previewed project, empty on the launcher.
  String get serverUrl;

  /// Whether the live reload socket for the previewed project is connected.
  bool get isConnected;

  /// Human-readable dependency cache size, e.g. `1.2 MB (4 packages)`.
  String get dependencyCacheLabel;

  /// Empties the on-device dependency cache.
  Future<void> clearDependencyCache();

  /// Notified when projects, theme, verbose, or the runtime mode change.
  void addListener(void Function() listener);

  /// Drops a listener registered with [addListener].
  void removeListener(void Function() listener);
}

/// Facade the host UI calls. The shell installs the implementation with [bind].
class DartGoHost {
  DartGoHost._();

  static DartGoHostBinding? _binding;

  /// The binding the shell installed, or null before startup / after dispose.
  static DartGoHostBinding? get binding => _binding;

  /// Installs [implementation] as the process-wide host API.
  static void bind(DartGoHostBinding implementation) {
    _binding = implementation;
  }

  /// Drops [implementation] if it is still the active binding.
  static void unbind([DartGoHostBinding? implementation]) {
    if (implementation == null || identical(_binding, implementation)) {
      _binding = null;
    }
  }

  static DartGoHostBinding get _api {
    final binding = _binding;
    if (binding == null) {
      throw StateError(
        'DartGoHost is not bound. The dartnative_go shell installs the '
        'binding at startup; interpreted guests reach it through the host '
        'API bridge.',
      );
    }
    return binding;
  }

  static Future<List<DartGoProject>> discover() => _api.discover();

  static Future<List<DartGoProject>> refresh() => _api.refresh();

  static List<DartGoProject> get projects => _api.projects;

  static bool get isScanning => _api.isScanning;

  static Future<void> openProject(DartGoProject project) =>
      _api.openProject(project);

  static Future<void> openWithLink(String link) => _api.openWithLink(link);

  static Future<String> toggleTheme() => _api.toggleTheme();

  static String get theme => _api.theme;

  static Future<void> openDevTools() => _api.openDevTools();

  /// True when this UI runs as an interpreted guest previewed by the shell.
  ///
  /// The interpreter bridge overrides this getter and returns `true`; the
  /// shell's embedded copy reads the facade's `false`. UI code uses it to
  /// decide whether to render its own DevTools.
  static bool get isPreviewed => false;

  static Future<void> claimDevTools() => _api.claimDevTools();

  static Future<void> releaseDevTools() => _api.releaseDevTools();

  static bool get verbose => _api.verbose;

  static Future<void> setVerbose(bool enabled) => _api.setVerbose(enabled);

  static Future<bool> toggleVerbose() async {
    final next = !verbose;
    await setVerbose(next);
    return next;
  }

  static Future<void> reload() => _api.reload();

  static Future<void> goHome() => _api.goHome();

  static String get runtimeModeLabel => _api.runtimeModeLabel;

  static List<String> get runtimeModes => _api.runtimeModes;

  static Future<void> setRuntimeMode(String label) =>
      _api.setRuntimeMode(label);

  static Future<void> cycleRuntimeMode() => _api.cycleRuntimeMode();

  static Future<String> setTheme(String mode) => _api.setTheme(mode);

  static String get appName => _api.appName;

  static String? get appVersion => _api.appVersion;

  static String get serverUrl => _api.serverUrl;

  static bool get isConnected => _api.isConnected;

  static String get dependencyCacheLabel => _api.dependencyCacheLabel;

  static Future<void> clearDependencyCache() => _api.clearDependencyCache();

  static void addListener(void Function() listener) =>
      _api.addListener(listener);

  static void removeListener(void Function() listener) =>
      _api.removeListener(listener);
}

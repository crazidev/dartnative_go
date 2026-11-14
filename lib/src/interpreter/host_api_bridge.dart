import 'package:dartnative_go_api/host_api.dart';
import 'package:tom_d4rt/tom_d4rt.dart';

import 'host_api_listeners.dart';

/// Source-engine (`tom_d4rt`) bridge for [DartGoHost].
///
/// Guest code imports `package:dartnative_go_api/host_api.dart` (or the
/// `package:dartnative_go/host_api.dart` re-export). Those libraries are
/// not bundled; this bridge supplies the classes and forwards to the
/// binding the shell installed.
final HostApiGuestListeners sourceHostApiListeners = HostApiGuestListeners();
final Map<Object, void Function()> _sourceCallbacks = {};

void detachSourceHostApiListeners() {
  sourceHostApiListeners.detachAll(_sourceCallbacks);
}

void registerSourceHostApiBridge(D4rt interpreter) {
  detachSourceHostApiListeners();
  for (final uri in kDartGoHostApiUris) {
    interpreter.registerBridgedClass(_hostClass(), uri);
    interpreter.registerBridgedClass(_projectClass(), uri);
  }
}

BridgedClass _hostClass() {
  return BridgedClass(
    nativeType: DartGoHost,
    name: 'DartGoHost',
    isAssignable: (value) => value is DartGoHost,
    staticMethods: {
      'discover': (visitor, positional, named, typeArgs) =>
          DartGoHost.discover(),
      'refresh': (visitor, positional, named, typeArgs) => DartGoHost.refresh(),
      'openProject': (visitor, positional, named, typeArgs) {
        return DartGoHost.openProject(_projectArg(positional, named));
      },
      'openWithLink': (visitor, positional, named, typeArgs) {
        return DartGoHost.openWithLink(_stringArg(positional, named, 'link'));
      },
      'toggleTheme': (visitor, positional, named, typeArgs) =>
          DartGoHost.toggleTheme(),
      'openDevTools': (visitor, positional, named, typeArgs) =>
          DartGoHost.openDevTools(),
      'claimDevTools': (visitor, positional, named, typeArgs) =>
          DartGoHost.claimDevTools(),
      'releaseDevTools': (visitor, positional, named, typeArgs) =>
          DartGoHost.releaseDevTools(),
      'setVerbose': (visitor, positional, named, typeArgs) {
        return DartGoHost.setVerbose(_boolArg(positional, named, 'enabled'));
      },
      'toggleVerbose': (visitor, positional, named, typeArgs) =>
          DartGoHost.toggleVerbose(),
      'reload': (visitor, positional, named, typeArgs) => DartGoHost.reload(),
      'goHome': (visitor, positional, named, typeArgs) => DartGoHost.goHome(),
      'setRuntimeMode': (visitor, positional, named, typeArgs) {
        return DartGoHost.setRuntimeMode(
          _stringArg(positional, named, 'label'),
        );
      },
      'setTheme': (visitor, positional, named, typeArgs) {
        return DartGoHost.setTheme(_stringArg(positional, named, 'mode'));
      },
      'clearDependencyCache': (visitor, positional, named, typeArgs) =>
          DartGoHost.clearDependencyCache(),
      'cycleRuntimeMode': (visitor, positional, named, typeArgs) =>
          DartGoHost.cycleRuntimeMode(),
      'addListener': (visitor, positional, named, typeArgs) {
        final callback = positional.isEmpty ? null : positional.first;
        if (callback == null) return null;
        void wrapper() {
          try {
            D4.callInterpreterCallback(visitor, callback, const []);
          } catch (_) {}
        }

        _sourceCallbacks[callback] = wrapper;
        sourceHostApiListeners.track(wrapper);
        return null;
      },
      'removeListener': (visitor, positional, named, typeArgs) {
        final callback = positional.isEmpty ? null : positional.first;
        if (callback == null) return null;
        sourceHostApiListeners.detach(callback, _sourceCallbacks);
        return null;
      },
    },
    staticGetters: {
      // This copy is interpreted inside the shell, so it is by definition a
      // preview. The shell's embedded UI reads the facade's `false`.
      'isPreviewed': (visitor) => true,
      'projects': (visitor) => DartGoHost.projects,
      'isScanning': (visitor) => DartGoHost.isScanning,
      'theme': (visitor) => DartGoHost.theme,
      'verbose': (visitor) => DartGoHost.verbose,
      'runtimeModeLabel': (visitor) => DartGoHost.runtimeModeLabel,
      'runtimeModes': (visitor) => DartGoHost.runtimeModes,
      'appName': (visitor) => DartGoHost.appName,
      'appVersion': (visitor) => DartGoHost.appVersion,
      'serverUrl': (visitor) => DartGoHost.serverUrl,
      'isConnected': (visitor) => DartGoHost.isConnected,
      'dependencyCacheLabel': (visitor) => DartGoHost.dependencyCacheLabel,
    },
    staticMethodSignatures: {
      'discover': 'Future<List<DartGoProject>> discover()',
      'refresh': 'Future<List<DartGoProject>> refresh()',
      'openProject': 'Future<void> openProject(DartGoProject project)',
      'openWithLink': 'Future<void> openWithLink(String link)',
      'toggleTheme': 'Future<String> toggleTheme()',
      'openDevTools': 'Future<void> openDevTools()',
      'claimDevTools': 'Future<void> claimDevTools()',
      'releaseDevTools': 'Future<void> releaseDevTools()',
      'setVerbose': 'Future<void> setVerbose(bool enabled)',
      'toggleVerbose': 'Future<bool> toggleVerbose()',
      'reload': 'Future<void> reload()',
      'goHome': 'Future<void> goHome()',
      'setRuntimeMode': 'Future<void> setRuntimeMode(String label)',
      'setTheme': 'Future<String> setTheme(String mode)',
      'clearDependencyCache': 'Future<void> clearDependencyCache()',
      'cycleRuntimeMode': 'Future<void> cycleRuntimeMode()',
      'addListener': 'void addListener(void Function() listener)',
      'removeListener': 'void removeListener(void Function() listener)',
    },
    staticGetterSignatures: {
      'isPreviewed': 'bool get isPreviewed',
      'projects': 'List<DartGoProject> get projects',
      'isScanning': 'bool get isScanning',
      'theme': 'String get theme',
      'verbose': 'bool get verbose',
      'runtimeModeLabel': 'String get runtimeModeLabel',
      'runtimeModes': 'List<String> get runtimeModes',
      'appName': 'String get appName',
      'appVersion': 'String? get appVersion',
      'serverUrl': 'String get serverUrl',
      'isConnected': 'bool get isConnected',
      'dependencyCacheLabel': 'String get dependencyCacheLabel',
    },
  );
}

BridgedClass _projectClass() {
  return BridgedClass(
    nativeType: DartGoProject,
    name: 'DartGoProject',
    isAssignable: (value) => value is DartGoProject,
    constructors: {
      '': (visitor, positional, named) {
        final appName = named['appName'] as String? ?? 'DartNative Project';
        final url = named['url'] as String? ?? '';
        return DartGoProject(
          appName: appName,
          url: url,
          isActive: named['isActive'] as bool? ?? false,
          appVersion: named['appVersion'] as String?,
          iconUrl: named['iconUrl'] as String?,
        );
      },
    },
    getters: {
      'appName': (visitor, target) => (target as DartGoProject).appName,
      'url': (visitor, target) => (target as DartGoProject).url,
      'isActive': (visitor, target) => (target as DartGoProject).isActive,
      'appVersion': (visitor, target) => (target as DartGoProject).appVersion,
      'iconUrl': (visitor, target) => (target as DartGoProject).iconUrl,
    },
    getterSignatures: {
      'appName': 'String get appName',
      'url': 'String get url',
      'isActive': 'bool get isActive',
      'appVersion': 'String? get appVersion',
      'iconUrl': 'String? get iconUrl',
    },
  );
}

DartGoProject _projectArg(
  List<Object?> positional,
  Map<String, Object?> named,
) {
  final raw = positional.isNotEmpty ? positional.first : named['project'];
  if (raw is DartGoProject) return raw;
  if (raw is Map) {
    return DartGoProject.fromJson(Map<String, Object?>.from(raw));
  }
  if (raw is String && raw.isNotEmpty) {
    return DartGoProject(appName: raw, url: raw);
  }
  throw ArgumentError('openProject requires a DartGoProject');
}

String _stringArg(
  List<Object?> positional,
  Map<String, Object?> named,
  String name,
) {
  final raw = positional.isNotEmpty ? positional.first : named[name];
  if (raw is String) return raw;
  throw ArgumentError('$name requires a String');
}

bool _boolArg(
  List<Object?> positional,
  Map<String, Object?> named,
  String name,
) {
  final raw = positional.isNotEmpty ? positional.first : named[name];
  if (raw is bool) return raw;
  throw ArgumentError('$name requires a bool');
}

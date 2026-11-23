import 'package:dartnative_go_api/host_api.dart';
import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

import '../host_api_listeners.dart';

/// AST-engine bridge for [DartGoHost]. Mirrors
/// `registerSourceHostApiBridge`.
final HostApiGuestListeners astHostApiListeners = HostApiGuestListeners();
final Map<Object, void Function()> _astCallbacks = {};

void detachAstHostApiListeners() {
  astHostApiListeners.detachAll(_astCallbacks);
}

void registerAstHostApiBridge(ast.D4rtRunner runner) {
  detachAstHostApiListeners();
  for (final uri in kDartGoHostApiUris) {
    runner.registerBridgedClass(_hostClass(), uri, sourceUri: uri);
    runner.registerBridgedClass(_projectClass(), uri, sourceUri: uri);
  }
}

ast.BridgedClass _hostClass() {
  return ast.BridgedClass(
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
      'removeProject': (visitor, positional, named, typeArgs) {
        return DartGoHost.removeProject(_projectArg(positional, named));
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

        _astCallbacks[callback] = wrapper;
        astHostApiListeners.track(wrapper);
        return null;
      },
      'removeListener': (visitor, positional, named, typeArgs) {
        final callback = positional.isEmpty ? null : positional.first;
        if (callback == null) return null;
        astHostApiListeners.detach(callback, _astCallbacks);
        return null;
      },
    },
    staticGetters: {
      // Interpreted UI is always a preview; the embedded copy reads `false`.
      'isPreviewed': (visitor) => true,
      'dngoVersion': (visitor) => DartGoHost.dngoVersion,
      'dartNativeVersion': (visitor) => DartGoHost.dartNativeVersion,
      'runtimeVersion': (visitor) => DartGoHost.runtimeVersion,
      'projects': (visitor) => DartGoHost.projects,
      'recentProjects': (visitor) => DartGoHost.recentProjects,
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
      'removeProject': 'Future<void> removeProject(DartGoProject project)',
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
      'dngoVersion': 'String get dngoVersion',
      'dartNativeVersion': 'String get dartNativeVersion',
      'runtimeVersion': 'String get runtimeVersion',
      'projects': 'List<DartGoProject> get projects',
      'recentProjects': 'List<DartGoProject> get recentProjects',
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

ast.BridgedClass _projectClass() {
  return ast.BridgedClass(
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

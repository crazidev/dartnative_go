/// DartNative Go CLI & Runtime Versioning and Supported Plugin Registry.
///
/// Each release of DartNative Go is compiled with a specific set of native
/// plugins and their corresponding versions. Developer projects targeting
/// DartNative Go must match these supported plugin versions.
library;

/// The current version of the DartNative Go CLI.
const String kDartGoVersion = '0.1.0';

/// The corresponding DartNative Go mobile runtime version.
const String kDartGoRuntimeVersion = '0.1.0';

/// Represents a native plugin requirement supported by this DartNative Go version.
class SupportedPlugin {
  final String name;
  final String supportedConstraint;
  final bool isCore;
  final String description;

  const SupportedPlugin({
    required this.name,
    required this.supportedConstraint,
    this.isCore = false,
    this.description = '',
  });
}

/// The registry of native plugins compiled into DartNative Go v0.1.0.
const List<SupportedPlugin> kSupportedNativePlugins = [
  SupportedPlugin(
    name: 'dartnative',
    supportedConstraint: '^1.0.0',
    isCore: true,
    description: 'Core DartNative UI framework and widgets',
  ),
  SupportedPlugin(
    name: 'dartnative_ios',
    supportedConstraint: '^1.0.0',
    isCore: true,
    description: 'iOS platform shell and native bindings',
  ),
  SupportedPlugin(
    name: 'dartnative_android',
    supportedConstraint: '^1.0.0',
    isCore: true,
    description: 'Android platform shell and native bindings',
  ),
  SupportedPlugin(
    name: 'dartnative_share',
    supportedConstraint: '^1.0.0',
    isCore: false,
    description: 'Native sharing sheet and text/file share dialogs',
  ),
  SupportedPlugin(
    name: 'dartnative_webview',
    supportedConstraint: '^1.0.0',
    isCore: false,
    description: 'Platform native WebView component',
  ),
  SupportedPlugin(
    name: 'dartnative_splash',
    supportedConstraint: '^1.0.0',
    isCore: false,
    description: 'Launch splash and app asset management',
  ),
  SupportedPlugin(
    name: 'dartnative_shared_preferences',
    supportedConstraint: '^1.0.1',
    isCore: false,
    description: 'Persistent key-value store for native settings and cache',
  ),
];

/// Map of plugin name to [SupportedPlugin] for fast lookup.
final Map<String, SupportedPlugin> kSupportedPluginsByName = {
  for (final plugin in kSupportedNativePlugins) plugin.name: plugin,
};

/// Returns whether [packageName] looks like a native DartNative plugin.
bool isNativePlugin(String packageName) {
  if (kSupportedPluginsByName.containsKey(packageName)) return true;
  if (packageName.startsWith('dartnative_') || packageName.startsWith('dn_')) {
    return true;
  }
  return false;
}

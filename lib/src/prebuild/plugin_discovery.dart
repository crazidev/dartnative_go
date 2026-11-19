import 'dart:convert';
import 'dart:io';

import 'config.dart';

/// Discovers `build_config.dart` files shipped by packages the app depends on.
///
/// Plugin authors write:
///
/// ```dart
/// DngoPluginConfig get dngoPluginConfig => PluginBuildConfig(
///   name: 'native_bottomsheet',
///   permissions: {AndroidPermission.vibrate},
///   iosPermissions: {'NSMicrophoneUsageDescription': '...'},
/// );
/// ```
///
/// at the package root or in `lib/build_config.dart`. Prebuild reads those
/// files from `.dart_tool/package_config.json` so apps pick up native settings
/// just by depending on the plugin.
List<DngoPluginConfig> discoverPluginBuildConfigs(Directory projectDir) {
  final configFile = _findPackageConfigFile(projectDir);
  if (configFile == null) return const [];
  late final Object? decoded;
  try {
    decoded = jsonDecode(configFile.readAsStringSync());
  } on FormatException {
    return const [];
  }
  if (decoded is! Map) return const [];
  final packages = decoded['packages'];
  if (packages is! List) return const [];

  final discovered = <DngoPluginConfig>[];
  final seen = <String>{};
  for (final package in packages) {
    if (package is! Map) continue;
    final name = package['name'];
    final rootUri = package['rootUri'];
    if (name is! String || rootUri is! String) continue;
    if (name.isEmpty || !_looksLikePluginPackage(name)) continue;
    final root = _packageRoot(configFile, rootUri);
    final file = _buildConfigFile(root);
    if (file == null) continue;
    final parsed = parsePluginBuildConfig(file.readAsStringSync());
    if (parsed == null) continue;
    final pluginName = parsed.name.isEmpty ? name : parsed.name;
    if (!seen.add(pluginName)) continue;
    discovered.add(
      pluginName == parsed.name
          ? parsed
          : PluginBuildConfig(
              name: pluginName,
              permissions: parsed.permissions,
              iosPermissions: parsed.iosPermissions,
            ),
    );
  }
  return discovered;
}

bool _looksLikePluginPackage(String name) {
  const skip = {
    'dartnative',
    'dartnative_ios',
    'dartnative_android',
    'dartnative_go_config',
    'ffi',
    'meta',
    'collection',
    'vector_math',
    'xml',
    'yaml',
  };
  if (skip.contains(name)) return false;
  if (name.startsWith('dartnative_go')) return false;
  return true;
}

File? _findPackageConfigFile(Directory startDir) {
  var dir = startDir.absolute;
  while (true) {
    final candidate = File('${dir.path}/.dart_tool/package_config.json');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) return null;
    dir = parent;
  }
}

Directory _packageRoot(File configFile, String rootUri) {
  final uri = Uri.parse(rootUri);
  final resolved = uri.hasScheme ? uri : configFile.uri.resolve(rootUri);
  return Directory.fromUri(resolved);
}

File? _buildConfigFile(Directory root) {
  for (final relative in const ['build_config.dart', 'lib/build_config.dart']) {
    final file = File('${root.path}/$relative');
    if (file.existsSync()) return file;
  }
  return null;
}

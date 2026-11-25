import 'android_permissions.dart';

abstract class DngoPluginConfig {
  const DngoPluginConfig();
  String get name;
  Map<String, String> get iosPermissions => const {};
  Set<String> get managedIosPermissionKeys => iosPermissions.keys.toSet();
  Set<String> get androidPermissions => const {};
  Set<String> get managedAndroidPermissionKeys => androidPermissions;
}

class GenericPluginConfig extends DngoPluginConfig {
  @override
  final String name;
  const GenericPluginConfig(this.name);
}

DngoPluginConfig pluginConfig(String name) => GenericPluginConfig(name);

/// Native project settings shipped by a plugin in `build_config.dart`.
///
/// Plugin authors put this file at the package root (or `lib/build_config.dart`).
/// `dngo prebuild` discovers it from `.dart_tool/package_config.json` and
/// merges the permissions into the app. An explicit entry in the app's
/// `dngo.config.dart` `plugins:` list wins over the discovered file.
class PluginBuildConfig extends DngoPluginConfig {
  @override
  final String name;

  /// Android permissions this plugin needs, as typed [AndroidPermission]s.
  final Set<AndroidPermission> permissions;

  @override
  final Map<String, String> iosPermissions;

  const PluginBuildConfig({
    required this.name,
    this.permissions = const {},
    this.iosPermissions = const {},
  });

  @override
  Set<String> get androidPermissions => {
    for (final permission in permissions) permission.value,
  };
}

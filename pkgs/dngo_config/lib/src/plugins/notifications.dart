import '../plugin_config.dart';

class NotificationsConfig extends DngoPluginConfig {
  final String permissionDescription;

  const NotificationsConfig({
    this.permissionDescription = 'Allow notifications from this app.',
  });

  @override
  String get name => 'dartnative_notifications';

  @override
  Map<String, String> get iosPermissions => {
    'NSUserNotificationsUsageDescription': permissionDescription,
  };
}

const defaultNotificationsConfig = NotificationsConfig();

NotificationsConfig notificationsConfig({String? permissionDescription}) =>
    NotificationsConfig(
      permissionDescription:
          permissionDescription ??
          defaultNotificationsConfig.permissionDescription,
    );

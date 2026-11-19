import 'plugin_config.dart';
import 'plugins/media_picker.dart';
import 'plugins/notifications.dart';

const Map<String, DngoPluginConfig> defaultPluginConfigs = {
  'dartnative_media_picker': defaultMediaPickerConfig,
  'dartnative_notifications': defaultNotificationsConfig,
};

DngoPluginConfig? defaultPluginConfig(String name) =>
    defaultPluginConfigs[name];

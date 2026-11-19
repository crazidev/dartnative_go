import '../plugin_config.dart';

class MediaPickerConfig extends DngoPluginConfig {
  final String photoLibraryUsageDescription;
  final String photoLibraryAddUsageDescription;

  const MediaPickerConfig({
    this.photoLibraryUsageDescription =
        'Pick photos and videos to use in the app.',
    this.photoLibraryAddUsageDescription =
        'Save photos and videos you create in the app.',
  });

  @override
  String get name => 'dartnative_media_picker';

  @override
  Map<String, String> get iosPermissions => {
    'NSPhotoLibraryUsageDescription': photoLibraryUsageDescription,
    'NSPhotoLibraryAddUsageDescription': photoLibraryAddUsageDescription,
  };

  @override
  Set<String> get androidPermissions => {
    'android.permission.READ_MEDIA_IMAGES',
    'android.permission.READ_MEDIA_VIDEO',
  };
}

const defaultMediaPickerConfig = MediaPickerConfig();

MediaPickerConfig mediaPickerConfig({
  String? photoLibraryUsageDescription,
  String? photoLibraryAddUsageDescription,
}) => MediaPickerConfig(
  photoLibraryUsageDescription:
      photoLibraryUsageDescription ??
      defaultMediaPickerConfig.photoLibraryUsageDescription,
  photoLibraryAddUsageDescription:
      photoLibraryAddUsageDescription ??
      defaultMediaPickerConfig.photoLibraryAddUsageDescription,
);

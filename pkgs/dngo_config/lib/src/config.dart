import 'dart:convert';

import 'app_config.dart';
import 'platform_config.dart';
import 'plugin_config.dart';
import 'plugin_defaults.dart';

class NativeOverrides {
  const NativeOverrides();
}

class DngoConfig {
  final AppConfig app;
  final PlatformsConfig platforms;
  final List<DngoPluginConfig> plugins;
  final NativeOverrides overrides;

  const DngoConfig({
    required this.app,
    this.platforms = const PlatformsConfig(),
    this.plugins = const [],
    this.overrides = const NativeOverrides(),
  });

  Set<String> get pluginNames => {for (final plugin in plugins) plugin.name};
  String get name => app.name;
  String get iosBundleId => app.bundleId.ios;
  String get androidApplicationId => app.bundleId.android;
  String get versionName => app.version.name;
  int get buildNumber => app.version.buildNumber;
  int? get androidMinSdk => platforms.android.minSdk;
  int? get androidTargetSdk => platforms.android.targetSdk;
  int get iosDeploymentTarget => platforms.ios.minimumDeploymentTarget.major;
  AndroidAppIcon? get androidIcon =>
      platforms.android.icon ?? app.icon?.toAndroid();
  IosAppIcon? get iosIcon => platforms.ios.icon ?? app.icon?.toIOS();
  AndroidSplash? get androidSplash =>
      platforms.android.splash ?? app.splash?.toAndroid();
  IosSplash? get iosSplash => platforms.ios.splash ?? app.splash?.toIOS();

  Map<String, String> get iosPermissions => {
    for (final plugin in plugins) ...plugin.iosPermissions,
  };

  Set<String> get managedIosPermissionKeys => {
    for (final plugin in defaultPluginConfigs.values)
      ...plugin.managedIosPermissionKeys,
    for (final plugin in plugins) ...plugin.managedIosPermissionKeys,
  };

  Set<String> get androidPermissions => {
    for (final permission in platforms.android.permissions) permission.value,
    for (final plugin in plugins) ...plugin.androidPermissions,
  };

  Set<String> get managedAndroidPermissionKeys => {
    for (final plugin in defaultPluginConfigs.values)
      ...plugin.managedAndroidPermissionKeys,
    for (final plugin in plugins) ...plugin.managedAndroidPermissionKeys,
  };

  /// Permissions added explicitly by [AndroidConfig.permissions], without the
  /// permissions contributed by plugins.
  Set<String> get configuredAndroidPermissions => {
    for (final permission in platforms.android.permissions) permission.value,
  };

  Map<String, Object?> toJson() => {
    'name': app.name,
    'iosBundleId': app.bundleId.ios,
    'androidApplicationId': app.bundleId.android,
    'versionName': app.version.name,
    'buildNumber': app.version.buildNumber,
    'androidMinSdk': platforms.android.minSdk,
    'androidTargetSdk': platforms.android.targetSdk,
    'iosDeploymentTarget': platforms.ios.minimumDeploymentTarget.toString(),
    'icon': app.icon?.source,
    'splash': app.splash?.image,
    'plugins': plugins.map((plugin) => plugin.name).toList(),
    'androidPermissions': androidPermissions.toList()..sort(),
    'configuredAndroidPermissions': configuredAndroidPermissions.toList()
      ..sort(),
    'androidIntentQueries': [
      for (final intent in platforms.android.intentQueries) intent.toJson(),
    ],
    'androidIntentFilters': [
      for (final filter in platforms.android.intentFilters) filter.toJson(),
    ],
    'iosQuerySchemes': platforms.ios.querySchemes.toList()..sort(),
    'iosUrlSchemes': platforms.ios.urlSchemes.toList()..sort(),
    'iosAssociatedDomains': platforms.ios.associatedDomains.toList()..sort(),
    'iosPermissions': iosPermissions,
  };

  String encode() => jsonEncode(toJson());

  String toAdaptiveStudioYaml() {
    final lines = <String>['flutter_adaptive_studio:'];
    final android = <String>[];
    final ios = <String>[];

    final androidMinSdk = platforms.android.minSdk;
    if (androidMinSdk != null) {
      android.add('    min_sdk: $androidMinSdk');
    }

    final androidIcon = this.androidIcon;
    if (androidIcon != null) android.addAll(_androidIconYaml(androidIcon));
    final androidSplash = this.androidSplash;
    if (androidSplash != null) {
      android.addAll(_androidSplashYaml(androidSplash));
    }
    final iosIcon = this.iosIcon;
    if (iosIcon != null) {
      ios.addAll(_iosIconYaml(iosIcon));
    }
    final iosSplash = this.iosSplash;
    if (iosSplash != null) ios.addAll(_iosSplashYaml(iosSplash));

    if (android.isNotEmpty) {
      lines
        ..add('  android:')
        ..addAll(android);
    }
    if (ios.isNotEmpty) {
      lines
        ..add('  ios:')
        ..addAll(ios);
    }
    return '${lines.join('\n')}\n';
  }
}

DngoConfig applyDngoPluginDefaults(
  DngoConfig config, {
  Iterable<DngoPluginConfig> discovered = const [],
}) {
  final plugins = [...config.plugins];
  final named = config.pluginNames;
  for (final plugin in discovered) {
    if (named.contains(plugin.name)) continue;
    plugins.add(plugin);
    named.add(plugin.name);
  }
  for (final name in named) {
    if (plugins.any((plugin) => plugin.name == name)) continue;
    final defaultConfig = defaultPluginConfig(name);
    if (defaultConfig != null) plugins.add(defaultConfig);
  }
  return DngoConfig(
    app: config.app,
    platforms: config.platforms,
    plugins: plugins,
    overrides: config.overrides,
  );
}

/// Quotes a YAML scalar. Colors must be quoted because a bare `#RRGGBB` starts
/// a YAML comment, and quoting every string keeps generated configs valid for
/// paths, words and values containing punctuation.
String _yaml(String value) =>
    "'${value.replaceAll("'", "''").replaceAll('\n', ' ')}'";

String _yamlColor(ColorValue? value) => value == null ? '' : _yaml(value.value);

List<String> _androidIconYaml(AndroidAppIcon icon) {
  final lines = <String>[
    '    icon:',
    '      adaptive:',
  ];
  if (icon.foreground != null) {
    lines.add('        foreground: ${_yaml(icon.foreground!)}');
  }
  lines.add('        background: ${_yamlColor(icon.background)}');
  if (icon.monochrome != null) {
    lines.add('        monochrome: ${_yaml(icon.monochrome!)}');
  }
  if (icon.safeZone != AdaptiveSafeZone.fit) {
    lines.add('        safe_zone: ${_yaml(icon.safeZone.value)}');
  }
  if (icon.padding != null) {
    lines.add('        padding: ${icon.padding}');
  }
  if (icon.foregroundFormat != IconForegroundFormat.vector) {
    lines.add('        foreground_format: ${icon.foregroundFormatValue}');
  }
  if (icon.round) lines.add('      round: true');
  if (icon.iconName != 'ic_launcher') {
    lines.add('      icon_name: ${_yaml(icon.iconName)}');
  }
  if (icon.legacy != null) lines.add('      legacy: ${icon.legacy}');
  if (icon.legacyPadding != null) {
    lines.add('      legacy_padding: ${icon.legacyPadding}');
  }
  if (icon.playStore) lines.add('      play_store: true');
  if (icon.playStorePadding != null) {
    lines.add('      play_store_padding: ${icon.playStorePadding}');
  }
  if (icon.rasterView != IconRasterView.tile) {
    lines.add('      raster_view: ${icon.rasterViewValue}');
  }
  if (icon.imageFormat != AssetImageFormat.png) {
    lines.add('      image_format: ${icon.imageFormatValue}');
  }
  if (icon.image != null) lines.add('      image: ${_yaml(icon.image!)}');
  if (icon.effect != IconEffect.none) {
    lines.add('      effect: ${icon.effectValue}');
  }
  final themed = icon.themed;
  if (themed != null) {
    lines.add('      themed:');
    if (themed.light != null) {
      lines.add('        light: ${_yaml(themed.light!)}');
    }
    if (themed.dark != null) {
      lines.add('        dark: ${_yaml(themed.dark!)}');
    }
    if (themed.background != null) {
      lines.add('        background: ${_yamlColor(themed.background)}');
    }
    if (themed.backgroundDark != null) {
      lines.add(
        '        background_dark: ${_yamlColor(themed.backgroundDark)}',
      );
    }
  }
  return lines;
}

List<String> _iosIconYaml(IosAppIcon icon) {
  final lines = <String>['    icon:'];
  if (icon.image != null) lines.add('      image: ${_yaml(icon.image!)}');
  lines.add('      background: ${_yamlColor(icon.background)}');
  if (icon.dark != null) lines.add('      dark: ${_yaml(icon.dark!)}');
  lines.add('      background_dark: ${_yamlColor(icon.backgroundDark)}');
  if (icon.tinted != null) lines.add('      tinted: ${_yaml(icon.tinted!)}');
  if (icon.padding != 0) lines.add('      padding: ${icon.padding}');
  return lines;
}

List<String> _androidSplashYaml(AndroidSplash splash) {
  final lines = <String>['    splash:'];
  void add(String key, String value) => lines.add('      $key: $value');
  void addString(String key, String? value) {
    if (value != null) add(key, _yaml(value));
  }

  void addColor(String key, ColorValue? value) {
    if (value != null) add(key, _yamlColor(value));
  }

  addColor('background', splash.background);
  addColor('background_dark', splash.backgroundDark);
  addString('background_image', splash.backgroundImage);
  addString('background_image_dark', splash.backgroundImageDark);
  addString('image', splash.image);
  addString('image_dark', splash.imageDark);
  if (splash.imageFit != SplashImageFit.auto) {
    add('image_fit', splash.imageFitValue);
  }
  if (splash.imageFormat != AssetImageFormat.png) {
    add('image_format', splash.imageFormatValue);
  }
  addString('animated_icon', splash.animatedIcon);
  addString('animated_icon_dark', splash.animatedIconDark);
  if (splash.duration != 1000) add('duration', '${splash.duration}');
  addColor('icon_background', splash.iconBackground);
  addColor('icon_background_dark', splash.iconBackgroundDark);
  if (splash.iconPadding != null) add('icon_padding', '${splash.iconPadding}');
  if (splash.gravity != 'center') addString('gravity', splash.gravity);
  if (splash.fullscreen) add('fullscreen', 'true');
  addString('screen_orientation', splash.screenOrientation);
  addString('status_bar_color', splash.statusBarColor);
  addString('status_bar_color_dark', splash.statusBarColorDark);
  addString(
    'status_bar_icon_brightness',
    splash.statusBarIconBrightnessValue,
  );
  addString(
    'status_bar_icon_brightness_dark',
    splash.statusBarIconBrightnessDarkValue,
  );
  addString('navigation_bar_color', splash.navigationBarColor);
  addString('navigation_bar_color_dark', splash.navigationBarColorDark);
  addString(
    'navigation_bar_icon_brightness',
    splash.navigationBarIconBrightnessValue,
  );
  addString(
    'navigation_bar_icon_brightness_dark',
    splash.navigationBarIconBrightnessDarkValue,
  );
  addString('branding', splash.branding);
  addString('branding_dark', splash.brandingDark);
  addString('branding_text', splash.brandingText);
  addColor('branding_text_color', splash.brandingTextColor);
  addColor('branding_text_color_dark', splash.brandingTextColorDark);
  if (splash.brandingMode != BrandingMode.bottom) {
    add('branding_mode', splash.brandingModeValue);
  }
  if (splash.brandingFit != SplashImageFit.auto) {
    add('branding_fit', splash.brandingFitValue);
  }
  if (splash.brandingBottomPadding != 48) {
    add('branding_bottom_padding', '${splash.brandingBottomPadding}');
  }
  return lines;
}

List<String> _iosSplashYaml(IosSplash splash) {
  final lines = <String>['    splash:'];
  void add(String key, String value) => lines.add('      $key: $value');
  void addString(String key, String? value) {
    if (value != null) add(key, _yaml(value));
  }

  void addColor(String key, ColorValue? value) {
    if (value != null) add(key, _yamlColor(value));
  }

  addColor('background', splash.background);
  addColor('background_dark', splash.backgroundDark);
  addString('background_image', splash.backgroundImage);
  addString('background_image_dark', splash.backgroundImageDark);
  addString('image', splash.image);
  addString('image_dark', splash.imageDark);
  if (splash.logoSize != 192) add('logo_size', '${splash.logoSize}');
  return lines;
}

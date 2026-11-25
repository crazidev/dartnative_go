import 'dart:io';

import '../cli/diagnostics/dart_go_version.dart';
import 'config.dart';
import 'native_generator.dart';

const _corePlugins = {
  'dartnative',
  'dartnative_ios',
  'dartnative_android',
};

List<SupportedPlugin> get _selectablePlugins => [
  for (final plugin in kSupportedNativePlugins)
    if (!_corePlugins.contains(plugin.name) &&
        (plugin.name.startsWith('dartnative_') ||
            plugin.name.startsWith('native_')))
      plugin,
];

class DngoProjectCreator {
  final Directory workingDirectory;
  const DngoProjectCreator(this.workingDirectory);

  Future<void> run({String? name, List<String>? plugins}) async {
    final appName = name ?? _ask('App name: ');
    final requested = plugins ?? _askPlugins();
    final allowed = {for (final plugin in _selectablePlugins) plugin.name};
    final selected = requested.where(allowed.contains).toList();
    final selectedNames = {..._corePlugins, ...selected};
    final slug = _slug(appName);
    await _run('dn', ['create', slug], workingDirectory);
    final project = Directory('${workingDirectory.path}/$slug');
    await _installPlugins(project, selectedNames);
    final permissions = _defaultPermissions(selectedNames);
    final config = DngoConfig(
      app: AppConfig(
        name: appName,
        bundleId: BundleId(
          ios: 'com.example.$slug',
          android: 'com.example.$slug',
        ),
        version: const AppVersion(name: '1.0.0', buildNumber: 1),
      ),
      platforms: PlatformsConfig(
        ios: IosConfig(
          minimumDeploymentTarget: _readIosDeploymentTarget(project),
        ),
        android: AndroidConfig(),
      ),
      plugins: _configuredPlugins(selected, permissions),
    );
    File('${project.path}/dngo.config.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync(renderConfig(config));
    await DngoNativeGenerator(project).generate(config);
    stdout.writeln('Created $slug with ${selected.length} selected plugin(s).');
  }

  Future<void> _installPlugins(Directory project, Set<String> plugins) async {
    final configPath = Directory(
      '${workingDirectory.path}/pkgs/dngo_config',
    );
    final configDependency = configPath.existsSync()
        ? 'dngo_config:{path: ../pkgs/dngo_config}'
        : 'dngo_config:^0.1.0';
    await _run('dn', ['pub', 'add', configDependency], project);
    final supported = {
      for (final plugin in kSupportedNativePlugins) plugin.name: plugin,
    };
    for (final name in plugins) {
      final plugin = supported[name];
      if (plugin == null) continue;
      await _run('dn', [
        'pub',
        'add',
        '$name:${plugin.supportedConstraint}',
      ], project);
    }
  }

  Future<void> _run(String executable, List<String> args, Directory cwd) async {
    final result = await Process.run(
      executable,
      args,
      workingDirectory: cwd.path,
    );
    if (result.exitCode != 0) {
      throw ProcessException(
        executable,
        args,
        result.stderr.toString(),
        result.exitCode,
      );
    }
  }

  List<DngoPluginConfig> _configuredPlugins(
    List<String> plugins,
    Map<String, String> permissions,
  ) => [
    for (final plugin in plugins) ?_pluginConfig(plugin, permissions),
  ];

  DngoPluginConfig? _pluginConfig(
    String name,
    Map<String, String> permissions,
  ) => switch (name) {
    'dartnative_media_picker' => MediaPickerConfig(
      photoLibraryUsageDescription:
          permissions['NSPhotoLibraryUsageDescription']!,
      photoLibraryAddUsageDescription:
          permissions['NSPhotoLibraryAddUsageDescription']!,
    ),
    'dartnative_notifications' => NotificationsConfig(
      permissionDescription:
          permissions['NSUserNotificationsUsageDescription']!,
    ),
    _ => null,
  };

  IosVersion _readIosDeploymentTarget(Directory project) {
    final file = File('${project.path}/ios/Podfile');
    if (file.existsSync()) {
      final match = RegExp(
        r"platform :ios, '([0-9]+)(?:\.([0-9]+))?'",
      ).firstMatch(file.readAsStringSync());
      if (match != null) {
        return IosVersion(
          int.parse(match.group(1)!),
          int.tryParse(match.group(2) ?? '') ?? 0,
        );
      }
    }
    return const IosVersion(16, 1);
  }

  Map<String, String> _defaultPermissions(Set<String> plugins) => {
    if (plugins.contains('dartnative_media_picker'))
      'NSPhotoLibraryUsageDescription':
          'Pick photos and videos to use in the app.',
    if (plugins.contains('dartnative_media_picker'))
      'NSPhotoLibraryAddUsageDescription':
          'Save photos and videos you create in the app.',
    if (plugins.contains('dartnative_notifications'))
      'NSUserNotificationsUsageDescription':
          'Allow notifications from this app.',
  };

  List<String> _askPlugins() {
    final plugins = _selectablePlugins;
    final selected = <int>{};
    if (!stdin.hasTerminal) return const [];
    stdin.lineMode = false;
    stdin.echoMode = false;
    try {
      var cursor = 0;
      while (true) {
        stdout.write('\x1B[2J\x1B[H');
        stdout.writeln('Select plugins with ↑/↓, space, and enter:\n');
        for (var i = 0; i < plugins.length; i++) {
          final mark = selected.contains(i) ? 'x' : ' ';
          final pointer = i == cursor ? '>' : ' ';
          stdout.writeln(
            '$pointer [$mark] ${plugins[i].name} (${plugins[i].supportedConstraint})',
          );
        }
        final byte = stdin.readByteSync();
        if (byte == 10 || byte == 13) break;
        if (byte == 32) {
          selected.contains(cursor)
              ? selected.remove(cursor)
              : selected.add(cursor);
        } else if (byte == 27 && stdin.readByteSync() == 91) {
          final direction = stdin.readByteSync();
          if (direction == 65 && cursor > 0) cursor--;
          if (direction == 66 && cursor < plugins.length - 1) cursor++;
        }
      }
    } finally {
      stdin.lineMode = true;
      stdin.echoMode = true;
      stdout.write('\n');
    }
    return [for (final index in selected) plugins[index].name];
  }

  String _ask(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync()?.trim() ?? '';
  }

  String _slug(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}

String renderConfig(DngoConfig config) {
  final imports = <String>[
    "import 'package:dngo_config/dngo.dart';",
  ];
  final pluginLines = config.plugins
      .where(
        (plugin) =>
            plugin is MediaPickerConfig ||
            plugin is NotificationsConfig ||
            plugin is PluginBuildConfig,
      )
      .map(_renderPlugin)
      .join(',\n    ');
  final android = config.platforms.android;
  final ios = config.platforms.ios;
  final androidSource = _renderAndroidConfig(android);
  return '''// ==== Auto generated by dngo_config ====
${imports.join('\n')}

DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: '${_quote(config.app.name)}',
    bundleId: BundleId(
      ios: '${_quote(config.app.bundleId.ios)}',
      android: '${_quote(config.app.bundleId.android)}',
    ),
    version: AppVersion(
      name: '${_quote(config.app.version.name)}',
      buildNumber: ${config.app.version.buildNumber},
    ),
    ${config.app.icon == null ? '' : 'icon: ${_renderAppIcon(config.app.icon!)},'}
    ${config.app.splash == null ? '' : 'splash: ${_renderSplashConfig(config.app.splash!)},'}
  ),
  platforms: PlatformsConfig(
    ios: IosConfig(
      minimumDeploymentTarget: IosVersion(${ios.minimumDeploymentTarget.major}, ${ios.minimumDeploymentTarget.minor}),
      supportedOrientations: ${_renderOrientations(ios.supportedOrientations)},
      supportsIpad: ${ios.supportsIpad},
      ${ios.appGroup == null ? '' : "appGroup: '${_quote(ios.appGroup!)}',"}
      ${ios.supportsLiveActivities ? 'supportsLiveActivities: true,' : ''}
      ${ios.querySchemes.isEmpty ? '' : 'querySchemes: ${_renderStringSet(ios.querySchemes)},'}
      ${ios.urlSchemes.isEmpty ? '' : 'urlSchemes: ${_renderStringSet(ios.urlSchemes)},'}
      ${ios.associatedDomains.isEmpty ? '' : 'associatedDomains: ${_renderStringSet(ios.associatedDomains)},'}
      ${ios.icon == null ? '' : 'icon: ${_renderIosIcon(ios.icon!)},'}
      ${ios.splash == null ? '' : 'splash: ${_renderIosSplash(ios.splash!)},'}
    ),
    android: $androidSource,
  ),
  plugins: [
    $pluginLines
  ],
);

// ==== Auto generated by dngo_config ====
''';
}

String _renderAndroidConfig(AndroidConfig android) {
  final args = <String>[];
  void add(String key, String value) => args.add('$key: $value');
  if (android.minSdk != null) add('minSdk', '${android.minSdk}');
  if (android.targetSdk != null) add('targetSdk', '${android.targetSdk}');
  if (android.compileSdk != null) add('compileSdk', '${android.compileSdk}');
  if (android.ndkVersion != null) {
    add('ndkVersion', "'${_quote(android.ndkVersion!)}'");
  }
  if (android.versionCode != null) add('versionCode', '${android.versionCode}');
  if (android.versionName != null) {
    add('versionName', "'${_quote(android.versionName!)}'");
  }
  if (android.usesCleartextTraffic != null) {
    add('usesCleartextTraffic', '${android.usesCleartextTraffic}');
  }
  if (android.permissions.isNotEmpty) {
    add('permissions', _renderAndroidPermissions(android.permissions));
  }
  if (android.intentQueries.isNotEmpty) {
    add('intentQueries', _renderAndroidIntentQueries(android.intentQueries));
  }
  if (android.intentFilters.isNotEmpty) {
    add('intentFilters', _renderAndroidIntentFilters(android.intentFilters));
  }
  if (android.icon != null) add('icon', _renderAndroidIcon(android.icon!));
  if (android.splash != null) {
    add('splash', _renderAndroidSplash(android.splash!));
  }
  if (!(android.signing?.isDebug ?? true)) {
    add('signing', _renderSigning(android.signing));
  }
  return args.isEmpty ? 'AndroidConfig()' : 'AndroidConfig(${args.join(', ')})';
}

String _renderAndroidPermissions(Set<AndroidPermission> permissions) {
  final sorted = permissions.toList()
    ..sort((a, b) => a.index.compareTo(b.index));
  return '{${sorted.map((permission) => 'AndroidPermission.${permission.name}').join(', ')}}';
}

String _renderStringSet(Set<String> values) {
  final sorted = values.toList()..sort();
  return '{${sorted.map((value) => "'${_quote(value)}'").join(', ')}}';
}

String _renderAndroidIntentQueries(List<AndroidIntent> intents) =>
    '[${intents.map(_renderAndroidIntent).join(', ')}]';

String _renderAndroidIntentFilters(List<AndroidIntentFilter> filters) =>
    '[${filters.map(_renderAndroidIntentFilter).join(', ')}]';

String _renderAndroidIntent(AndroidIntent intent) =>
    'AndroidIntent(${_renderIntentContent(intent).join(', ')})';

String _renderAndroidIntentFilter(AndroidIntentFilter filter) {
  if (_isDeepLinkFilter(filter)) {
    final item = filter.data.single;
    final args = <String>[
      "scheme: '${_quote(item.scheme!)}'",
      if (item.host != null) "host: '${_quote(item.host!)}'",
      if (item.port != null) "port: '${_quote(item.port!)}'",
      if (item.path != null) "path: '${_quote(item.path!)}'",
      if (item.pathPrefix != null) "pathPrefix: '${_quote(item.pathPrefix!)}'",
      if (item.pathPattern != null)
        "pathPattern: '${_quote(item.pathPattern!)}'",
      if (item.mimeType != null) "mimeType: '${_quote(item.mimeType!)}'",
      if (filter.activity != null) "activity: '${_quote(filter.activity!)}'",
      if (filter.autoVerify) 'autoVerify: true',
    ];
    return 'AndroidIntentFilter.deepLink(${args.join(', ')})';
  }
  return 'AndroidIntentFilter(${[
    if (filter.activity != null) "activity: '${_quote(filter.activity!)}'",
    if (filter.autoVerify) 'autoVerify: true',
    ..._renderIntentContent(filter),
  ].join(', ')})';
}

bool _isDeepLinkFilter(AndroidIntentFilter filter) {
  if (filter.action != AndroidIntent.viewAction ||
      filter.data.length != 1 ||
      filter.data.single.scheme == null ||
      filter.categories.length != 2 ||
      !filter.categories.contains(AndroidIntent.defaultCategory) ||
      !filter.categories.contains(AndroidIntent.browsableCategory)) {
    return false;
  }
  final item = filter.data.single;
  return item.pathAdvancedPattern == null &&
      item.ssp == null &&
      item.sspPrefix == null &&
      item.sspPattern == null &&
      item.sspAdvancedPattern == null;
}

List<String> _renderIntentContent(AndroidIntent intent) => [
  if (intent.action != null) "action: '${_quote(intent.action!)}'",
  if (intent.categories.isNotEmpty)
    'categories: {${(intent.categories.toList()..sort()).map((category) => "'${_quote(category)}'").join(', ')}}',
  if (intent.data.isNotEmpty)
    'data: [${intent.data.map(_renderAndroidIntentData).join(', ')}]',
];

String _renderAndroidIntentData(AndroidIntentData data) {
  final args = <String>[
    if (data.scheme != null) "scheme: '${_quote(data.scheme!)}'",
    if (data.host != null) "host: '${_quote(data.host!)}'",
    if (data.port != null) "port: '${_quote(data.port!)}'",
    if (data.path != null) "path: '${_quote(data.path!)}'",
    if (data.pathPrefix != null) "pathPrefix: '${_quote(data.pathPrefix!)}'",
    if (data.pathPattern != null) "pathPattern: '${_quote(data.pathPattern!)}'",
    if (data.pathAdvancedPattern != null)
      "pathAdvancedPattern: '${_quote(data.pathAdvancedPattern!)}'",
    if (data.ssp != null) "ssp: '${_quote(data.ssp!)}'",
    if (data.sspPrefix != null) "sspPrefix: '${_quote(data.sspPrefix!)}'",
    if (data.sspPattern != null) "sspPattern: '${_quote(data.sspPattern!)}'",
    if (data.sspAdvancedPattern != null)
      "sspAdvancedPattern: '${_quote(data.sspAdvancedPattern!)}'",
    if (data.mimeType != null) "mimeType: '${_quote(data.mimeType!)}'",
  ];
  return 'AndroidIntentData(${args.join(', ')})';
}

String _renderAppIcon(AppIcon icon) {
  final args = <String>["source: '${_quote(icon.source)}'"];
  void add(String key, String value) => args.add('$key: $value');
  if (icon.androidForeground != null) {
    add('androidForeground', "'${_quote(icon.androidForeground!)}'");
  }
  if (icon.androidBackground != null) {
    add('androidBackground', _renderColor(icon.androidBackground!));
  }
  if (icon.androidMonochrome != null) {
    add('androidMonochrome', "'${_quote(icon.androidMonochrome!)}'");
  }
  if (icon.androidSafeZone != AdaptiveSafeZone.fit) {
    add('androidSafeZone', _renderSafeZone(icon.androidSafeZone));
  }
  if (icon.androidPadding != null) {
    add('androidPadding', '${icon.androidPadding}');
  }
  if (icon.androidForegroundFormat != IconForegroundFormat.vector) {
    add(
      'androidForegroundFormat',
      'IconForegroundFormat.${icon.androidForegroundFormat.name}',
    );
  }
  if (icon.androidRound) add('androidRound', 'true');
  if (icon.androidIconName != 'ic_launcher') {
    add('androidIconName', "'${_quote(icon.androidIconName)}'");
  }
  if (icon.androidLegacy != null) add('androidLegacy', '${icon.androidLegacy}');
  if (icon.androidLegacyPadding != null) {
    add('androidLegacyPadding', '${icon.androidLegacyPadding}');
  }
  if (icon.androidPlayStore) add('androidPlayStore', 'true');
  if (icon.androidPlayStorePadding != null) {
    add('androidPlayStorePadding', '${icon.androidPlayStorePadding}');
  }
  if (icon.androidRasterView != IconRasterView.tile) {
    add('androidRasterView', 'IconRasterView.${icon.androidRasterView.name}');
  }
  if (icon.androidImageFormat != AssetImageFormat.png) {
    add(
      'androidImageFormat',
      'AssetImageFormat.${icon.androidImageFormat.name}',
    );
  }
  if (icon.androidImage != null) {
    add('androidImage', "'${_quote(icon.androidImage!)}'");
  }
  if (icon.androidEffect != IconEffect.none) {
    add('androidEffect', 'IconEffect.${icon.androidEffect.name}');
  }
  if (icon.androidThemed != null) {
    add('androidThemed', _renderThemed(icon.androidThemed!));
  }
  if (icon.iosImage != null) add('iosImage', "'${_quote(icon.iosImage!)}'");
  if (icon.iosBackground != null) {
    add('iosBackground', _renderColor(icon.iosBackground!));
  }
  if (icon.iosDark != null) add('iosDark', "'${_quote(icon.iosDark!)}'");
  if (icon.iosBackgroundDark != null) {
    add('iosBackgroundDark', _renderColor(icon.iosBackgroundDark!));
  }
  if (icon.iosTinted != null) add('iosTinted', "'${_quote(icon.iosTinted!)}'");
  if (icon.iosPadding != 0) add('iosPadding', '${icon.iosPadding}');
  return 'AppIcon(${args.join(', ')})';
}

String _renderIosIcon(IosAppIcon icon) {
  final args = <String>[
    if (icon.image != null) "image: '${_quote(icon.image!)}'",
    'background: ${_renderColor(icon.background)}',
    if (icon.dark != null) "dark: '${_quote(icon.dark!)}'",
    'backgroundDark: ${_renderColor(icon.backgroundDark)}',
    if (icon.tinted != null) "tinted: '${_quote(icon.tinted!)}'",
    if (icon.padding != 0) 'padding: ${icon.padding}',
  ];
  return 'IosAppIcon(${args.join(', ')})';
}

String _renderAndroidIcon(AndroidAppIcon icon) {
  final args = <String>[
    if (icon.foreground != null) "foreground: '${_quote(icon.foreground!)}'",
    'background: ${_renderColor(icon.background)}',
    if (icon.monochrome != null) "monochrome: '${_quote(icon.monochrome!)}'",
    if (icon.safeZone != AdaptiveSafeZone.fit)
      'safeZone: ${_renderSafeZone(icon.safeZone)}',
    if (icon.padding != null) 'padding: ${icon.padding}',
    if (icon.foregroundFormat != IconForegroundFormat.vector)
      'foregroundFormat: IconForegroundFormat.${icon.foregroundFormat.name}',
    if (icon.round) 'round: true',
    if (icon.iconName != 'ic_launcher') "iconName: '${_quote(icon.iconName)}'",
    if (icon.legacy != null) 'legacy: ${icon.legacy}',
    if (icon.legacyPadding != null) 'legacyPadding: ${icon.legacyPadding}',
    if (icon.playStore) 'playStore: true',
    if (icon.playStorePadding != null)
      'playStorePadding: ${icon.playStorePadding}',
    if (icon.rasterView != IconRasterView.tile)
      'rasterView: IconRasterView.${icon.rasterView.name}',
    if (icon.imageFormat != AssetImageFormat.png)
      'imageFormat: AssetImageFormat.${icon.imageFormat.name}',
    if (icon.image != null) "image: '${_quote(icon.image!)}'",
    if (icon.effect != IconEffect.none)
      'effect: IconEffect.${icon.effect.name}',
    if (icon.themed != null) 'themed: ${_renderThemed(icon.themed!)}',
  ];
  return 'AndroidAppIcon(${args.join(', ')})';
}

String _renderThemed(AndroidThemedIcon themed) {
  final args = <String>[
    if (themed.light != null) "light: '${_quote(themed.light!)}'",
    if (themed.dark != null) "dark: '${_quote(themed.dark!)}'",
    if (themed.background != null)
      'background: ${_renderColor(themed.background!)}',
    if (themed.backgroundDark != null)
      'backgroundDark: ${_renderColor(themed.backgroundDark!)}',
  ];
  return 'AndroidThemedIcon(${args.join(', ')})';
}

String _renderSplashConfig(SplashConfig splash) {
  final args = <String>[
    "image: '${_quote(splash.image)}'",
    'backgroundColor:  ${splash.backgroundColor == null ? null : _renderColor(splash.backgroundColor!)}',
    if (splash.backgroundDark != null)
      'backgroundDark: ${_renderColor(splash.backgroundDark!)}',
    if (splash.backgroundImage != null)
      "backgroundImage: '${_quote(splash.backgroundImage!)}'",
    if (splash.backgroundImageDark != null)
      "backgroundImageDark: '${_quote(splash.backgroundImageDark!)}'",
    if (splash.imageDark != null) "imageDark: '${_quote(splash.imageDark!)}'",
    if (splash.androidImageFit != SplashImageFit.auto)
      'androidImageFit: SplashImageFit.${splash.androidImageFit.name}',
    if (splash.androidImageFormat != AssetImageFormat.png)
      'androidImageFormat: AssetImageFormat.${splash.androidImageFormat.name}',
    if (splash.androidAnimatedIcon != null)
      "androidAnimatedIcon: '${_quote(splash.androidAnimatedIcon!)}'",
    if (splash.androidAnimatedIconDark != null)
      "androidAnimatedIconDark: '${_quote(splash.androidAnimatedIconDark!)}'",
    if (splash.androidDuration != 1000)
      'androidDuration: ${splash.androidDuration}',
    if (splash.androidIconBackground != null)
      'androidIconBackground: ${_renderColor(splash.androidIconBackground!)}',
    if (splash.androidIconBackgroundDark != null)
      'androidIconBackgroundDark: ${_renderColor(splash.androidIconBackgroundDark!)}',
    if (splash.androidIconPadding != null)
      'androidIconPadding: ${splash.androidIconPadding}',
    if (splash.androidGravity != 'center')
      "androidGravity: '${_quote(splash.androidGravity)}'",
    if (splash.androidFullscreen) 'androidFullscreen: true',
    if (splash.androidScreenOrientation != null)
      "androidScreenOrientation: '${_quote(splash.androidScreenOrientation!)}'",
    if (splash.androidStatusBarColor != null)
      "androidStatusBarColor: '${_quote(splash.androidStatusBarColor!)}'",
    if (splash.androidStatusBarColorDark != null)
      "androidStatusBarColorDark: '${_quote(splash.androidStatusBarColorDark!)}'",
    if (splash.androidStatusBarIconBrightness != null)
      'androidStatusBarIconBrightness: StatusBarIconBrightness.${splash.androidStatusBarIconBrightness!.name}',
    if (splash.androidStatusBarIconBrightnessDark != null)
      'androidStatusBarIconBrightnessDark: StatusBarIconBrightness.${splash.androidStatusBarIconBrightnessDark!.name}',
    if (splash.androidNavigationBarColor != null)
      "androidNavigationBarColor: '${_quote(splash.androidNavigationBarColor!)}'",
    if (splash.androidNavigationBarColorDark != null)
      "androidNavigationBarColorDark: '${_quote(splash.androidNavigationBarColorDark!)}'",
    if (splash.androidNavigationBarIconBrightness != null)
      'androidNavigationBarIconBrightness: StatusBarIconBrightness.${splash.androidNavigationBarIconBrightness!.name}',
    if (splash.androidNavigationBarIconBrightnessDark != null)
      'androidNavigationBarIconBrightnessDark: StatusBarIconBrightness.${splash.androidNavigationBarIconBrightnessDark!.name}',
    if (splash.androidBranding != null)
      "androidBranding: '${_quote(splash.androidBranding!)}'",
    if (splash.androidBrandingDark != null)
      "androidBrandingDark: '${_quote(splash.androidBrandingDark!)}'",
    if (splash.androidBrandingText != null)
      "androidBrandingText: '${_quote(splash.androidBrandingText!)}'",
    if (splash.androidBrandingTextColor != null)
      'androidBrandingTextColor: ${_renderColor(splash.androidBrandingTextColor!)}',
    if (splash.androidBrandingTextColorDark != null)
      'androidBrandingTextColorDark: ${_renderColor(splash.androidBrandingTextColorDark!)}',
    if (splash.androidBrandingMode != BrandingMode.bottom)
      'androidBrandingMode: BrandingMode.${splash.androidBrandingMode.name}',
    if (splash.androidBrandingFit != SplashImageFit.auto)
      'androidBrandingFit: SplashImageFit.${splash.androidBrandingFit.name}',
    if (splash.androidBrandingBottomPadding != 48)
      'androidBrandingBottomPadding: ${splash.androidBrandingBottomPadding}',
    if (splash.iosLogoSize != 192) 'iosLogoSize: ${splash.iosLogoSize}',
  ];
  return 'SplashConfig(${args.join(', ')})';
}

String _renderIosSplash(IosSplash splash) {
  final args = <String>[
    if (splash.background != null)
      'background: ${_renderColor(splash.background!)}',
    if (splash.backgroundDark != null)
      'backgroundDark: ${_renderColor(splash.backgroundDark!)}',
    if (splash.backgroundImage != null)
      "backgroundImage: '${_quote(splash.backgroundImage!)}'",
    if (splash.backgroundImageDark != null)
      "backgroundImageDark: '${_quote(splash.backgroundImageDark!)}'",
    if (splash.image != null) "image: '${_quote(splash.image!)}'",
    if (splash.imageDark != null) "imageDark: '${_quote(splash.imageDark!)}'",
    if (splash.logoSize != 192) 'logoSize: ${splash.logoSize}',
  ];
  return 'IosSplash(${args.join(', ')})';
}

String _renderAndroidSplash(AndroidSplash splash) {
  final args = <String>[
    if (splash.background != null)
      'background: ${_renderColor(splash.background!)}',
    if (splash.backgroundDark != null)
      'backgroundDark: ${_renderColor(splash.backgroundDark!)}',
    if (splash.backgroundImage != null)
      "backgroundImage: '${_quote(splash.backgroundImage!)}'",
    if (splash.backgroundImageDark != null)
      "backgroundImageDark: '${_quote(splash.backgroundImageDark!)}'",
    if (splash.image != null) "image: '${_quote(splash.image!)}'",
    if (splash.imageDark != null) "imageDark: '${_quote(splash.imageDark!)}'",
    if (splash.imageFit != SplashImageFit.auto)
      'imageFit: SplashImageFit.${splash.imageFit.name}',
    if (splash.imageFormat != AssetImageFormat.png)
      'imageFormat: AssetImageFormat.${splash.imageFormat.name}',
    if (splash.animatedIcon != null)
      "animatedIcon: '${_quote(splash.animatedIcon!)}'",
    if (splash.animatedIconDark != null)
      "animatedIconDark: '${_quote(splash.animatedIconDark!)}'",
    if (splash.duration != 1000) 'duration: ${splash.duration}',
    if (splash.iconBackground != null)
      'iconBackground: ${_renderColor(splash.iconBackground!)}',
    if (splash.iconBackgroundDark != null)
      'iconBackgroundDark: ${_renderColor(splash.iconBackgroundDark!)}',
    if (splash.iconPadding != null) 'iconPadding: ${splash.iconPadding}',
    if (splash.gravity != 'center') "gravity: '${_quote(splash.gravity)}'",
    if (splash.fullscreen) 'fullscreen: true',
    if (splash.screenOrientation != null)
      "screenOrientation: '${_quote(splash.screenOrientation!)}'",
    if (splash.statusBarColor != null)
      "statusBarColor: '${_quote(splash.statusBarColor!)}'",
    if (splash.statusBarColorDark != null)
      "statusBarColorDark: '${_quote(splash.statusBarColorDark!)}'",
    if (splash.statusBarIconBrightness != null)
      'statusBarIconBrightness: StatusBarIconBrightness.${splash.statusBarIconBrightness!.name}',
    if (splash.statusBarIconBrightnessDark != null)
      'statusBarIconBrightnessDark: StatusBarIconBrightness.${splash.statusBarIconBrightnessDark!.name}',
    if (splash.navigationBarColor != null)
      "navigationBarColor: '${_quote(splash.navigationBarColor!)}'",
    if (splash.navigationBarColorDark != null)
      "navigationBarColorDark: '${_quote(splash.navigationBarColorDark!)}'",
    if (splash.navigationBarIconBrightness != null)
      'navigationBarIconBrightness: StatusBarIconBrightness.${splash.navigationBarIconBrightness!.name}',
    if (splash.navigationBarIconBrightnessDark != null)
      'navigationBarIconBrightnessDark: StatusBarIconBrightness.${splash.navigationBarIconBrightnessDark!.name}',
    if (splash.branding != null) "branding: '${_quote(splash.branding!)}'",
    if (splash.brandingDark != null)
      "brandingDark: '${_quote(splash.brandingDark!)}'",
    if (splash.brandingText != null)
      "brandingText: '${_quote(splash.brandingText!)}'",
    if (splash.brandingTextColor != null)
      'brandingTextColor: ${_renderColor(splash.brandingTextColor!)}',
    if (splash.brandingTextColorDark != null)
      'brandingTextColorDark: ${_renderColor(splash.brandingTextColorDark!)}',
    if (splash.brandingMode != BrandingMode.bottom)
      'brandingMode: BrandingMode.${splash.brandingMode.name}',
    if (splash.brandingFit != SplashImageFit.auto)
      'brandingFit: SplashImageFit.${splash.brandingFit.name}',
    if (splash.brandingBottomPadding != 48)
      'brandingBottomPadding: ${splash.brandingBottomPadding}',
  ];
  return 'AndroidSplash(${args.join(', ')})';
}

String _renderColor(ColorValue value) => "ColorValue('${_quote(value.value)}')";

String _renderSafeZone(AdaptiveSafeZone value) => switch (value.mode) {
  AdaptiveSafeZoneMode.fit => 'AdaptiveSafeZone.fit',
  AdaptiveSafeZoneMode.inset => 'AdaptiveSafeZone.inset(${value.percent})',
  AdaptiveSafeZoneMode.none => 'AdaptiveSafeZone.none',
  AdaptiveSafeZoneMode.asIs => 'AdaptiveSafeZone.asIs',
};
String _renderSigning(AndroidSigningConfig? signing) {
  if (signing == null || signing.isDebug) return 'AndroidSigningConfig.debug()';
  if (signing.propertyPath != null) {
    return "AndroidSigningConfig.fromGradleProperty('${_quote(signing.propertyPath!)}')";
  }
  return "AndroidSigningConfig(storeFile: '${_quote(signing.storeFile ?? '')}', storePassword: '${_quote(signing.storePassword ?? '')}', keyAlias: '${_quote(signing.keyAlias ?? '')}', keyPassword: '${_quote(signing.keyPassword ?? '')}')";
}

String _renderOrientations(Set<IosOrientation> orientations) {
  if (orientations.length == IosOrientation.all.length &&
      orientations.containsAll(IosOrientation.all)) {
    return 'IosOrientation.all';
  }
  if (orientations.length == IosOrientation.defaults.length &&
      orientations.containsAll(IosOrientation.defaults)) {
    return 'IosOrientation.defaults';
  }
  return '{${orientations.map((orientation) => 'IosOrientation.${orientation.name}').join(', ')}}';
}

String _renderPlugin(DngoPluginConfig plugin) => switch (plugin) {
  MediaPickerConfig config =>
    "mediaPickerConfig(photoLibraryUsageDescription: '${_quote(config.photoLibraryUsageDescription)}', photoLibraryAddUsageDescription: '${_quote(config.photoLibraryAddUsageDescription)}')",
  NotificationsConfig config =>
    "notificationsConfig(permissionDescription: '${_quote(config.permissionDescription)}')",
  PluginBuildConfig config => _renderPluginBuildConfig(config),
  _ => "pluginConfig('${_quote(plugin.name)}')",
};

String _renderPluginBuildConfig(PluginBuildConfig config) {
  final args = <String>["name: '${_quote(config.name)}'"];
  if (config.permissions.isNotEmpty) {
    args.add('permissions: ${_renderAndroidPermissions(config.permissions)}');
  }
  if (config.iosPermissions.isNotEmpty) {
    final entries = config.iosPermissions.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    args.add(
      'iosPermissions: {${entries.map((entry) => "'${_quote(entry.key)}': '${_quote(entry.value)}'").join(', ')}}',
    );
  }
  return 'PluginBuildConfig(${args.join(', ')})';
}

String _quote(String value) =>
    value.replaceAll('\\', '\\\\').replaceAll("'", "\\'");

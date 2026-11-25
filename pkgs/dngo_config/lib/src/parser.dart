import 'android_intent.dart';
import 'android_permissions.dart';
import 'app_config.dart';
import 'config.dart';
import 'platform_config.dart';
import 'plugin_config.dart';
import 'plugins/media_picker.dart';
import 'plugins/notifications.dart';

/// Temporary source reader until the generated Dart runner is available.
class DngoConfigParser {
  static DngoConfig parse(String source, {String? baseDirectory}) {
    source = _stripComments(source);
    final app = _section(source, 'app: AppConfig');
    final platforms = _section(source, 'platforms: PlatformsConfig');
    final ios = _section(platforms, 'ios: IosConfig');
    final android = _section(platforms, 'android: AndroidConfig');
    final bundle = _section(app, 'bundleId: BundleId');
    final version = _section(app, 'version: AppVersion');
    final signingPath = RegExp(
      r"AndroidSigningConfig\.fromGradleProperty\(\s*'([^']+)'",
    ).firstMatch(android)?.group(1);
    final signing = signingPath == null
        ? const AndroidSigningConfig.debug()
        : AndroidSigningConfig.fromGradleProperty(
            signingPath,
            baseDirectory: baseDirectory,
          );
    final appIcon = _parseAppIcon(_section(app, 'icon: AppIcon'));
    final appSplash = _parseSplashConfig(
      _section(app, 'splash: SplashConfig'),
    );
    final iosIcon = _parseIosConfigIcon(ios);
    final iosSplash = _parseIosConfigSplash(ios);
    final androidIcon = _parseAndroidConfigIcon(android);
    final androidSplash = _parseAndroidConfigSplash(android);
    final androidConfig = AndroidConfig(
      minSdk: _int(android, 'minSdk'),
      targetSdk: _int(android, 'targetSdk'),
      compileSdk: _int(android, 'compileSdk'),
      ndkVersion: _string(android, 'ndkVersion'),
      versionCode: _int(android, 'versionCode'),
      versionName: _string(android, 'versionName'),
      signing: signing,
      usesCleartextTraffic: _bool(android, 'usesCleartextTraffic'),
      permissions: _parseAndroidPermissions(android),
      intentQueries: _parseAndroidIntentQueries(android),
      intentFilters: _parseAndroidIntentFilters(android),
      icon: androidIcon,
      splash: androidSplash,
    );
    final appConfig = AppConfig(
      name: _string(app, 'name') ?? 'Unnamed App',
      bundleId: BundleId(
        ios: _string(bundle, 'ios') ?? 'com.example.app',
        android: _string(bundle, 'android') ?? 'com.example.app',
      ),
      version: AppVersion(
        name: _string(version, 'name') ?? '1.0.0',
        buildNumber: _int(version, 'buildNumber') ?? 1,
      ),
      icon: appIcon,
      splash: appSplash,
    );
    return DngoConfig(
      app: appConfig,
      platforms: PlatformsConfig(
        ios: IosConfig(
          minimumDeploymentTarget: IosVersion(
            _int(ios, 'major') ?? 16,
            _int(ios, 'minor') ?? 0,
          ),
          supportedOrientations: _parseIosOrientations(ios),
          supportsIpad: _bool(ios, 'supportsIpad') ?? true,
          appGroup: _string(ios, 'appGroup'),
          supportsLiveActivities: _bool(ios, 'supportsLiveActivities') ?? false,
          querySchemes: _parseStringCollection(ios, 'querySchemes'),
          urlSchemes: _parseStringCollection(ios, 'urlSchemes'),
          associatedDomains: _parseStringCollection(ios, 'associatedDomains'),
          icon: iosIcon,
          splash: iosSplash,
        ),
        android: androidConfig,
      ),
      plugins: _parsePlugins(source),
    );
  }
}

/// Removes `//` comments while preserving string literals (for example asset
/// paths or URLs) so commented-out configuration never takes effect.
String _stripComments(String source) {
  final out = StringBuffer();
  var quote = '';
  var escaped = false;
  for (var i = 0; i < source.length; i++) {
    final char = source[i];
    if (quote.isNotEmpty) {
      out.write(char);
      if (escaped) {
        escaped = false;
      } else if (char == r'\') {
        escaped = true;
      } else if (char == quote) {
        quote = '';
      }
      continue;
    }
    if (char == "'" || char == '"') {
      quote = char;
      out.write(char);
      continue;
    }
    if (char == '/' && i + 1 < source.length && source[i + 1] == '/') {
      while (i < source.length && source[i] != '\n') {
        i++;
      }
      if (i < source.length) out.write('\n');
      continue;
    }
    out.write(char);
  }
  return out.toString();
}

Set<IosOrientation> _parseIosOrientations(String source) {
  if (!source.contains('supportedOrientations')) {
    return IosOrientation.defaults;
  }
  if (source.contains('IosOrientation.all')) {
    return IosOrientation.all;
  }
  if (source.contains('IosOrientation.defaults')) {
    return IosOrientation.defaults;
  }
  final orientations = <IosOrientation>{};
  for (final match in RegExp(
    r'IosOrientation\.([A-Za-z]+)',
  ).allMatches(source)) {
    final orientation = switch (match.group(1)) {
      'portrait' => IosOrientation.portrait,
      'portraitUpsideDown' => IosOrientation.portraitUpsideDown,
      'landscapeLeft' => IosOrientation.landscapeLeft,
      'landscapeRight' => IosOrientation.landscapeRight,
      _ => null,
    };
    if (orientation != null) orientations.add(orientation);
  }
  return orientations;
}

Set<AndroidPermission> _parseAndroidPermissions(String source) {
  final match = RegExp(
    r'permissions\s*:\s*(?:const\s*)?[\{\[]([^\}\]]*)[\}\]]',
  ).firstMatch(source);
  if (match == null) return const {};
  final byName = {
    for (final permission in AndroidPermission.values)
      permission.name: permission,
  };
  final permissions = <AndroidPermission>{};
  for (final entry in RegExp(
    r'AndroidPermission\.([A-Za-z0-9_]+)',
  ).allMatches(match.group(1)!)) {
    final permission = byName[entry.group(1)];
    if (permission != null) permissions.add(permission);
  }
  return permissions;
}

List<AndroidIntent> _parseAndroidIntentQueries(String source) {
  final block = _bracketBlock(source, 'intentQueries');
  if (block == null) return const [];
  final intents = <AndroidIntent>[];
  for (final match in RegExp(
    r'AndroidIntent(\.view)?\s*\(',
  ).allMatches(block)) {
    final args = _parenthesizedBlock(block, match.end - 1);
    if (args == null) continue;
    intents.add(
      AndroidIntent(
        action:
            _string(args, 'action') ??
            (match.group(1) == null ? null : AndroidIntent.viewAction),
        categories: _parseStringCollection(args, 'categories'),
        data: _parseAndroidIntentData(args),
      ),
    );
  }
  return intents;
}

List<AndroidIntentFilter> _parseAndroidIntentFilters(String source) {
  final block = _bracketBlock(source, 'intentFilters');
  if (block == null) return const [];
  final filters = <AndroidIntentFilter>[];
  for (final match in RegExp(
    r'AndroidIntentFilter(\.deepLink)?\s*\(',
  ).allMatches(block)) {
    final args = _parenthesizedBlock(block, match.end - 1);
    if (args == null) continue;
    final activity = _string(args, 'activity');
    final autoVerify = _bool(args, 'autoVerify') ?? false;
    final scheme = _string(args, 'scheme');
    if (match.group(1) != null && scheme != null) {
      filters.add(
        AndroidIntentFilter.deepLink(
          scheme: scheme,
          host: _string(args, 'host'),
          port: _string(args, 'port'),
          path: _string(args, 'path'),
          pathPrefix: _string(args, 'pathPrefix'),
          pathPattern: _string(args, 'pathPattern'),
          mimeType: _string(args, 'mimeType'),
          activity: activity,
          autoVerify: autoVerify,
        ),
      );
      continue;
    }
    filters.add(
      AndroidIntentFilter(
        activity: activity,
        autoVerify: autoVerify,
        action: _string(args, 'action'),
        categories: _parseStringCollection(args, 'categories'),
        data: _parseAndroidIntentData(args),
      ),
    );
  }
  return filters;
}

List<AndroidIntentData> _parseAndroidIntentData(String source) {
  final block = _bracketBlock(source, 'data');
  if (block == null) return const [];
  final data = <AndroidIntentData>[];
  for (final match in RegExp(r'AndroidIntentData\s*\(').allMatches(block)) {
    final args = _parenthesizedBlock(block, match.end - 1);
    if (args == null) continue;
    data.add(
      AndroidIntentData(
        scheme: _string(args, 'scheme'),
        host: _string(args, 'host'),
        port: _string(args, 'port'),
        path: _string(args, 'path'),
        pathPrefix: _string(args, 'pathPrefix'),
        pathPattern: _string(args, 'pathPattern'),
        pathAdvancedPattern: _string(args, 'pathAdvancedPattern'),
        ssp: _string(args, 'ssp'),
        sspPrefix: _string(args, 'sspPrefix'),
        sspPattern: _string(args, 'sspPattern'),
        sspAdvancedPattern: _string(args, 'sspAdvancedPattern'),
        mimeType: _string(args, 'mimeType'),
      ),
    );
  }
  for (final match in RegExp(
    r"AndroidIntentData\.scheme\s*\(\s*'([^']*)'\s*\)",
  ).allMatches(block)) {
    data.add(AndroidIntentData.scheme(match.group(1)!));
  }
  return data;
}

Set<String> _parseStringCollection(String source, String key) {
  final block = _bracketBlock(source, key);
  if (block == null) return const {};
  return {
    for (final match in RegExp(r"'([^']*)'").allMatches(block)) match.group(1)!,
  };
}

/// Returns the text inside the first `{...}` or `[...]` following [key].
String? _bracketBlock(String source, String key) {
  final match = RegExp(
    '(?<![A-Za-z0-9_])${RegExp.escape(key)}\\s*:\\s*([\\[{])',
  ).firstMatch(source);
  if (match == null) return null;
  final open = match.end - 1;
  return _balancedBlock(
    source,
    open,
    source[open],
    source[open] == '[' ? ']' : '}',
  );
}

String? _parenthesizedBlock(String source, int open) =>
    _balancedBlock(source, open, '(', ')');

String? _balancedBlock(
  String source,
  int open,
  String openChar,
  String closeChar,
) {
  var depth = 0;
  var quote = '';
  var escaped = false;
  for (var i = open; i < source.length; i++) {
    final char = source[i];
    if (quote.isNotEmpty) {
      if (escaped) {
        escaped = false;
      } else if (char == r'\') {
        escaped = true;
      } else if (char == quote) {
        quote = '';
      }
      continue;
    }
    if (char == "'" || char == '"') {
      quote = char;
      continue;
    }
    if (char == openChar) depth++;
    if (char == closeChar && --depth == 0) {
      return source.substring(open + 1, i);
    }
  }
  return null;
}

AppIcon? _parseAppIcon(String source) {
  final image = _string(source, 'source');
  if (image == null) return null;
  return AppIcon(
    source: image,
    androidForeground: _string(source, 'androidForeground'),
    androidBackground: _colorValue(source, 'androidBackground'),
    androidMonochrome: _string(source, 'androidMonochrome'),
    androidSafeZone: _safeZone(source, 'androidSafeZone'),
    androidPadding: _int(source, 'androidPadding'),
    androidForegroundFormat: _foregroundFormat(
      _enumName(source, 'androidForegroundFormat'),
    ),
    androidRound: _bool(source, 'androidRound') ?? false,
    androidIconName: _string(source, 'androidIconName') ?? 'ic_launcher',
    androidLegacy: _bool(source, 'androidLegacy'),
    androidLegacyPadding: _int(source, 'androidLegacyPadding'),
    androidPlayStore: _bool(source, 'androidPlayStore') ?? false,
    androidPlayStorePadding: _int(source, 'androidPlayStorePadding'),
    androidRasterView: _rasterView(_enumName(source, 'androidRasterView')),
    androidImageFormat: _imageFormat(_enumName(source, 'androidImageFormat')),
    androidImage: _string(source, 'androidImage'),
    androidEffect: _effect(_enumName(source, 'androidEffect')),
    androidThemed: _parseThemed(
      _section(source, 'androidThemed: AndroidThemedIcon'),
    ),
    iosImage: _string(source, 'iosImage'),
    iosBackground: _colorValue(source, 'iosBackground'),
    iosDark: _string(source, 'iosDark'),
    iosBackgroundDark: _colorValue(source, 'iosBackgroundDark'),
    iosTinted: _string(source, 'iosTinted'),
    iosPadding: _int(source, 'iosPadding') ?? 0,
  );
}

IosAppIcon? _parseIosConfigIcon(String ios) {
  final dedicated = _section(ios, 'icon: IosAppIcon');
  if (dedicated.isNotEmpty) return _parseIosIcon(dedicated);
  final legacy = _parseAppIcon(_section(ios, 'icon: AppIcon'));
  return legacy?.toIOS();
}

AndroidAppIcon? _parseAndroidConfigIcon(String android) {
  final dedicated = _section(android, 'icon: AndroidAppIcon');
  if (dedicated.isNotEmpty) return _parseAndroidIcon(dedicated);
  final legacy = _parseAppIcon(_section(android, 'icon: AppIcon'));
  return legacy?.toAndroid();
}

IosAppIcon? _parseIosIcon(String source) {
  final image = _string(source, 'image');
  return IosAppIcon(
    image: image,
    background:
        _colorValue(source, 'background') ?? const ColorValue('#FFFFFF'),
    dark: _string(source, 'dark'),
    backgroundDark:
        _colorValue(source, 'backgroundDark') ?? const ColorValue('#000000'),
    tinted: _string(source, 'tinted'),
    padding: _int(source, 'padding') ?? 0,
  );
}

AndroidAppIcon? _parseAndroidIcon(String source) {
  final foreground = _string(source, 'foreground');
  final image = _string(source, 'image');
  if (foreground == null && image == null) return null;
  return AndroidAppIcon(
    foreground: foreground,
    background:
        _colorValue(source, 'background') ?? const ColorValue('#000000'),
    monochrome: _string(source, 'monochrome'),
    safeZone: _safeZone(source, 'safeZone'),
    padding: _int(source, 'padding'),
    foregroundFormat: _foregroundFormat(
      _enumName(source, 'foregroundFormat'),
    ),
    round: _bool(source, 'round') ?? false,
    iconName: _string(source, 'iconName') ?? 'ic_launcher',
    legacy: _bool(source, 'legacy'),
    legacyPadding: _int(source, 'legacyPadding'),
    playStore: _bool(source, 'playStore') ?? false,
    playStorePadding: _int(source, 'playStorePadding'),
    rasterView: _rasterView(_enumName(source, 'rasterView')),
    imageFormat: _imageFormat(_enumName(source, 'imageFormat')),
    image: image,
    effect: _effect(_enumName(source, 'effect')),
    themed: _parseThemed(
      _section(source, 'themed: AndroidThemedIcon'),
    ),
  );
}

AndroidThemedIcon? _parseThemed(String source) {
  if (source.isEmpty) return null;
  return AndroidThemedIcon(
    light: _string(source, 'light'),
    dark: _string(source, 'dark'),
    background: _colorValue(source, 'background'),
    backgroundDark: _colorValue(source, 'backgroundDark'),
  );
}

SplashConfig? _parseSplashConfig(String source) {
  final image = _string(source, 'image');
  if (image == null) return null;
  return SplashConfig(
    image: image,
    backgroundColor:
        _colorValue(source, 'backgroundColor') ?? const ColorValue('#000000'),
    backgroundDark: _colorValue(source, 'backgroundDark'),
    backgroundImage: _string(source, 'backgroundImage'),
    backgroundImageDark: _string(source, 'backgroundImageDark'),
    imageDark: _string(source, 'imageDark'),
    androidImageFit: _splashFit(_enumName(source, 'androidImageFit')),
    androidImageFormat: _imageFormat(
      _enumName(source, 'androidImageFormat'),
    ),
    androidAnimatedIcon: _string(source, 'androidAnimatedIcon'),
    androidAnimatedIconDark: _string(source, 'androidAnimatedIconDark'),
    androidDuration: _int(source, 'androidDuration') ?? 1000,
    androidIconBackground: _colorValue(source, 'androidIconBackground'),
    androidIconBackgroundDark: _colorValue(
      source,
      'androidIconBackgroundDark',
    ),
    androidIconPadding: _int(source, 'androidIconPadding'),
    androidGravity: _string(source, 'androidGravity') ?? 'center',
    androidFullscreen: _bool(source, 'androidFullscreen') ?? false,
    androidScreenOrientation: _string(source, 'androidScreenOrientation'),
    androidStatusBarColor: _string(source, 'androidStatusBarColor'),
    androidStatusBarColorDark: _string(
      source,
      'androidStatusBarColorDark',
    ),
    androidStatusBarIconBrightness: _barBrightness(
      _enumName(source, 'androidStatusBarIconBrightness'),
    ),
    androidStatusBarIconBrightnessDark: _barBrightness(
      _enumName(source, 'androidStatusBarIconBrightnessDark'),
    ),
    androidNavigationBarColor: _string(
      source,
      'androidNavigationBarColor',
    ),
    androidNavigationBarColorDark: _string(
      source,
      'androidNavigationBarColorDark',
    ),
    androidNavigationBarIconBrightness: _barBrightness(
      _enumName(source, 'androidNavigationBarIconBrightness'),
    ),
    androidNavigationBarIconBrightnessDark: _barBrightness(
      _enumName(source, 'androidNavigationBarIconBrightnessDark'),
    ),
    androidBranding: _string(source, 'androidBranding'),
    androidBrandingDark: _string(source, 'androidBrandingDark'),
    androidBrandingText: _string(source, 'androidBrandingText'),
    androidBrandingTextColor: _colorValue(
      source,
      'androidBrandingTextColor',
    ),
    androidBrandingTextColorDark: _colorValue(
      source,
      'androidBrandingTextColorDark',
    ),
    androidBrandingMode: _brandingMode(
      _enumName(source, 'androidBrandingMode'),
    ),
    androidBrandingFit: _splashFit(
      _enumName(source, 'androidBrandingFit'),
    ),
    androidBrandingBottomPadding:
        _int(source, 'androidBrandingBottomPadding') ?? 48,
    iosLogoSize: _int(source, 'iosLogoSize') ?? 192,
  );
}

IosSplash? _parseIosConfigSplash(String ios) {
  final dedicated = _section(ios, 'splash: IosSplash');
  if (dedicated.isNotEmpty) return _parseIosSplash(dedicated);
  final legacy = _parseSplashConfig(_section(ios, 'splash: SplashConfig'));
  return legacy?.toIOS();
}

AndroidSplash? _parseAndroidConfigSplash(String android) {
  final dedicated = _section(android, 'splash: AndroidSplash');
  if (dedicated.isNotEmpty) return _parseAndroidSplash(dedicated);
  final legacy = _parseSplashConfig(
    _section(android, 'splash: SplashConfig'),
  );
  return legacy?.toAndroid();
}

IosSplash? _parseIosSplash(String source) {
  return IosSplash(
    background: _colorValue(source, 'background'),
    backgroundDark: _colorValue(source, 'backgroundDark'),
    backgroundImage: _string(source, 'backgroundImage'),
    backgroundImageDark: _string(source, 'backgroundImageDark'),
    image: _string(source, 'image'),
    imageDark: _string(source, 'imageDark'),
    logoSize: _int(source, 'logoSize') ?? 192,
  );
}

AndroidSplash? _parseAndroidSplash(String source) {
  return AndroidSplash(
    background: _colorValue(source, 'background'),
    backgroundDark: _colorValue(source, 'backgroundDark'),
    backgroundImage: _string(source, 'backgroundImage'),
    backgroundImageDark: _string(source, 'backgroundImageDark'),
    image: _string(source, 'image'),
    imageDark: _string(source, 'imageDark'),
    imageFit: _splashFit(_enumName(source, 'imageFit')),
    imageFormat: _imageFormat(_enumName(source, 'imageFormat')),
    animatedIcon: _string(source, 'animatedIcon'),
    animatedIconDark: _string(source, 'animatedIconDark'),
    duration: _int(source, 'duration') ?? 1000,
    iconBackground: _colorValue(source, 'iconBackground'),
    iconBackgroundDark: _colorValue(source, 'iconBackgroundDark'),
    iconPadding: _int(source, 'iconPadding'),
    gravity: _string(source, 'gravity') ?? 'center',
    fullscreen: _bool(source, 'fullscreen') ?? false,
    screenOrientation: _string(source, 'screenOrientation'),
    statusBarColor: _string(source, 'statusBarColor'),
    statusBarColorDark: _string(source, 'statusBarColorDark'),
    statusBarIconBrightness: _barBrightness(
      _enumName(source, 'statusBarIconBrightness'),
    ),
    statusBarIconBrightnessDark: _barBrightness(
      _enumName(source, 'statusBarIconBrightnessDark'),
    ),
    navigationBarColor: _string(source, 'navigationBarColor'),
    navigationBarColorDark: _string(source, 'navigationBarColorDark'),
    navigationBarIconBrightness: _barBrightness(
      _enumName(source, 'navigationBarIconBrightness'),
    ),
    navigationBarIconBrightnessDark: _barBrightness(
      _enumName(source, 'navigationBarIconBrightnessDark'),
    ),
    branding: _string(source, 'branding'),
    brandingDark: _string(source, 'brandingDark'),
    brandingText: _string(source, 'brandingText'),
    brandingTextColor: _colorValue(source, 'brandingTextColor'),
    brandingTextColorDark: _colorValue(source, 'brandingTextColorDark'),
    brandingMode: _brandingMode(_enumName(source, 'brandingMode')),
    brandingFit: _splashFit(_enumName(source, 'brandingFit')),
    brandingBottomPadding: _int(source, 'brandingBottomPadding') ?? 48,
  );
}

ColorValue? _colorValue(String source, String key) {
  final match = RegExp(
    '(?<![A-Za-z0-9_])${RegExp.escape(key)}\\s*:\\s*ColorValue\\(\\s*\'([^\']*)\'',
  ).firstMatch(source);
  if (match != null) return ColorValue(match.group(1)!);
  final raw = _string(source, key);
  return raw == null ? null : ColorValue(raw);
}

AdaptiveSafeZone _safeZone(String source, String key) {
  final inset = RegExp(
    '(?<![A-Za-z0-9_])${RegExp.escape(key)}\\s*:\\s*AdaptiveSafeZone\\.inset\\(\\s*([0-9.]+)\\s*\\)',
  ).firstMatch(source);
  if (inset != null) {
    return AdaptiveSafeZone.inset(num.parse(inset.group(1)!));
  }
  final name = _enumName(source, key);
  return switch (name) {
    'none' => AdaptiveSafeZone.none,
    'asIs' => AdaptiveSafeZone.asIs,
    'inset' => AdaptiveSafeZone.inset(AdaptiveSafeZone.fit.percent ?? 15),
    _ => AdaptiveSafeZone.fit,
  };
}

IconForegroundFormat _foregroundFormat(String? value) => value == 'raster'
    ? IconForegroundFormat.raster
    : IconForegroundFormat.vector;

IconRasterView _rasterView(String? value) =>
    value == 'launcher' ? IconRasterView.launcher : IconRasterView.tile;

IconEffect _effect(String? value) =>
    value == 'elevate' ? IconEffect.elevate : IconEffect.none;

AssetImageFormat _imageFormat(String? value) =>
    value == 'webp' ? AssetImageFormat.webp : AssetImageFormat.png;

SplashImageFit _splashFit(String? value) =>
    value == 'asIs' ? SplashImageFit.asIs : SplashImageFit.auto;

BrandingMode _brandingMode(String? value) => switch (value) {
  'bottomLeft' => BrandingMode.bottomLeft,
  'bottomRight' => BrandingMode.bottomRight,
  _ => BrandingMode.bottom,
};

StatusBarIconBrightness? _barBrightness(String? value) => switch (value) {
  'dark' => StatusBarIconBrightness.dark,
  'light' => StatusBarIconBrightness.light,
  _ => null,
};

String? _enumName(String source, String key) {
  final match = RegExp(
    '(?<![A-Za-z0-9_])${RegExp.escape(key)}\\s*:\\s*([A-Za-z0-9_.]+)',
  ).firstMatch(source);
  if (match == null) return null;
  final value = match.group(1)!;
  return value.split('.').last;
}

String _section(String source, String marker) {
  final start = source.indexOf(marker);
  if (start < 0) return '';
  final open = source.indexOf('(', start);
  if (open < 0) return '';
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    if (source[i] == '(') depth++;
    if (source[i] == ')' && --depth == 0) {
      return source.substring(open + 1, i);
    }
  }
  return source.substring(open + 1);
}

String? _string(String source, String key) => RegExp(
  '(?<![A-Za-z0-9_])${RegExp.escape(key)}\\s*:\\s*\'([^\']*)\'',
).firstMatch(source)?.group(1);

bool? _bool(String source, String key) {
  final match = RegExp(
    '(?<![A-Za-z0-9_])${RegExp.escape(key)}\\s*:\\s*(true|false)',
  ).firstMatch(source);
  return match == null ? null : match.group(1) == 'true';
}

int? _int(String source, String key) => int.tryParse(
  RegExp(
        '(?<![A-Za-z0-9_])${RegExp.escape(key)}\\s*:\\s*(\\d+)',
      ).firstMatch(source)?.group(1) ??
      '',
);

List<DngoPluginConfig> _parsePlugins(String source) {
  final result = <DngoPluginConfig>[];
  final media = RegExp(
    r'mediaPickerConfig\((.*?)\)',
    dotAll: true,
  ).firstMatch(source)?.group(1);
  if (media != null) {
    result.add(
      MediaPickerConfig(
        photoLibraryUsageDescription:
            _argument(
              media,
              'photoLibraryUsageDescription',
            ) ??
            defaultMediaPickerConfig.photoLibraryUsageDescription,
        photoLibraryAddUsageDescription:
            _argument(
              media,
              'photoLibraryAddUsageDescription',
            ) ??
            defaultMediaPickerConfig.photoLibraryAddUsageDescription,
      ),
    );
  }
  final notifications = RegExp(
    r'notificationsConfig\((.*?)\)',
    dotAll: true,
  ).firstMatch(source)?.group(1);
  if (notifications != null) {
    result.add(
      NotificationsConfig(
        permissionDescription:
            _argument(
              notifications,
              'permissionDescription',
            ) ??
            defaultNotificationsConfig.permissionDescription,
      ),
    );
  }
  for (final match in RegExp(
    r'PluginBuildConfig\s*\(',
  ).allMatches(source)) {
    final args = _parenthesizedBlock(source, match.end - 1);
    if (args == null) continue;
    final parsed = parsePluginBuildConfig('PluginBuildConfig($args)');
    if (parsed != null) result.add(parsed);
  }
  return result;
}

/// Parses a plugin `build_config.dart` (or a `PluginBuildConfig(...)` snippet).
PluginBuildConfig? parsePluginBuildConfig(String source) {
  source = _stripComments(source);
  final args = _section(source, 'PluginBuildConfig');
  if (args.isEmpty) return null;
  final name = _string(args, 'name');
  if (name == null || name.isEmpty) return null;
  return PluginBuildConfig(
    name: name,
    permissions: _parseAndroidPermissions(args),
    iosPermissions: _parseStringMap(args, 'iosPermissions'),
  );
}

Map<String, String> _parseStringMap(String source, String key) {
  final block = _bracketBlock(source, key);
  if (block == null) return const {};
  final values = <String, String>{};
  for (final match in RegExp(
    r'''['"]([^'"]+)['"]\s*:\s*['"]([^'"]*)['"]''',
  ).allMatches(block)) {
    values[match.group(1)!] = match.group(2)!;
  }
  return values;
}

String? _argument(String source, String name) => RegExp(
  "${RegExp.escape(name)}\\s*:\\s*'([^']*)'",
).firstMatch(source)?.group(1);

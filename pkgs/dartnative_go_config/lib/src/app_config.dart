class BundleId {
  final String ios;
  final String android;
  const BundleId({required this.ios, required this.android});
}

class AppVersion {
  final String name;
  final int buildNumber;
  const AppVersion({required this.name, required this.buildNumber});
}

/// A colour accepted by the native asset generators.
///
/// Values may be written with or without a leading `#`; [value] always returns
/// the canonical `#`-prefixed form so a typo such as `ColorValue('E4ECF8')`
/// still reaches the generator as a valid colour.
class ColorValue {
  /// The colour exactly as it was declared.
  final String hex;

  const ColorValue(this.hex);

  /// Canonical `#RRGGBB` / `#AARRGGBB` form used by the generators.
  String get value {
    final trimmed = hex.trim();
    if (trimmed.isEmpty) return '#000000';
    return trimmed.startsWith('#') ? trimmed : '#$trimmed';
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) => other is ColorValue && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// How foreground art is fit into the Android adaptive-icon canvas.
///
/// Mirrors flutter_adaptive_studio's `safe_zone`:
/// `fit`, `inset:<pct>`, `none`, and `as_is`.
class AdaptiveSafeZone {
  final AdaptiveSafeZoneMode mode;
  final num? percent;

  const AdaptiveSafeZone._(this.mode, [this.percent]);

  /// Measure the art and scale it into the centred safe square with the
  /// generator's default breathing room.
  static const fit = AdaptiveSafeZone._(AdaptiveSafeZoneMode.fit);

  /// Measure and scale the art with [percent] of extra padding.
  const AdaptiveSafeZone.inset(num percent)
    : this._(AdaptiveSafeZoneMode.inset, percent);

  /// Fill the whole canvas without safe-zone handling.
  static const none = AdaptiveSafeZone._(AdaptiveSafeZoneMode.none);

  /// Keep the source's own framing, padding and aspect ratio.
  static const asIs = AdaptiveSafeZone._(AdaptiveSafeZoneMode.asIs);

  /// Value written to `safe_zone`.
  String get value => switch (mode) {
    AdaptiveSafeZoneMode.fit => 'fit',
    AdaptiveSafeZoneMode.inset => 'inset:$percent',
    AdaptiveSafeZoneMode.none => 'none',
    AdaptiveSafeZoneMode.asIs => 'as_is',
  };

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      other is AdaptiveSafeZone &&
      other.mode == mode &&
      other.percent == percent;

  @override
  int get hashCode => Object.hash(mode, percent);
}

enum AdaptiveSafeZoneMode { fit, inset, none, asIs }

enum AssetImageFormat { png, webp }

enum IconForegroundFormat { vector, raster }

enum IconEffect { none, elevate }

enum IconRasterView { tile, launcher }

enum SplashImageFit { auto, asIs }

enum BrandingMode { bottom, bottomLeft, bottomRight }

enum StatusBarIconBrightness { dark, light }

String _enumValue(Enum value) => value.name.replaceAllMapped(
  RegExp(r'[A-Z]'),
  (match) => '_${match.group(0)!.toLowerCase()}',
);

/// Full-colour light/dark Android icon emitted through an activity-alias.
class AndroidThemedIcon {
  final String? light;
  final String? dark;
  final ColorValue? background;
  final ColorValue? backgroundDark;

  const AndroidThemedIcon({
    this.light,
    this.dark,
    this.background,
    this.backgroundDark,
  });
}

/// iOS app-icon configuration (only iOS properties).
class IosAppIcon {
  final String? image;
  final ColorValue background;
  final String? dark;
  final ColorValue backgroundDark;
  final String? tinted;
  final int padding;

  const IosAppIcon({
    this.image,
    this.background = const ColorValue('#FFFFFF'),
    this.dark,
    this.backgroundDark = const ColorValue('#000000'),
    this.tinted,
    this.padding = 0,
  });
}

/// Android app-icon configuration (only Android properties).
class AndroidAppIcon {
  final String? foreground;
  final ColorValue background;
  final String? monochrome;
  final AdaptiveSafeZone safeZone;

  /// Alias for `safe_zone: inset:<pct>`; wins when both are given.
  final int? padding;
  final IconForegroundFormat foregroundFormat;
  final bool round;
  final String iconName;
  final bool? legacy;
  final int? legacyPadding;
  final bool playStore;
  final int? playStorePadding;
  final IconRasterView rasterView;
  final AssetImageFormat imageFormat;

  /// Finished-icon source for the legacy mipmaps and the Play Store icon.
  final String? image;
  final IconEffect effect;
  final AndroidThemedIcon? themed;

  const AndroidAppIcon({
    this.foreground,
    this.background = const ColorValue('#000000'),
    this.monochrome,
    this.safeZone = AdaptiveSafeZone.fit,
    this.padding,
    this.foregroundFormat = IconForegroundFormat.vector,
    this.round = false,
    this.iconName = 'ic_launcher',
    this.legacy,
    this.legacyPadding,
    this.playStore = false,
    this.playStorePadding,
    this.rasterView = IconRasterView.tile,
    this.imageFormat = AssetImageFormat.png,
    this.image,
    this.effect = IconEffect.none,
    this.themed,
  });

  String get safeZoneValue => safeZone.value;
  String get imageFormatValue => _enumValue(imageFormat);
  String get foregroundFormatValue => _enumValue(foregroundFormat);
  String get rasterViewValue => _enumValue(rasterView);
  String get effectValue => _enumValue(effect);
}

/// Platform-neutral app-icon configuration.
///
/// Shared art comes from [source]. Everything that is specific to a platform
/// is prefixed with `android` / `ios`; [toAndroid] and [toIOS] flatten the
/// matching values into the platform-only classes the native configs use.
class AppIcon {
  /// Shared icon art used by both platforms when a platform-specific source is
  /// not provided.
  final String source;

  final String? androidForeground;
  final ColorValue? androidBackground;
  final String? androidMonochrome;
  final AdaptiveSafeZone androidSafeZone;
  final int? androidPadding;
  final IconForegroundFormat androidForegroundFormat;
  final bool androidRound;
  final String androidIconName;
  final bool? androidLegacy;
  final int? androidLegacyPadding;
  final bool androidPlayStore;
  final int? androidPlayStorePadding;
  final IconRasterView androidRasterView;
  final AssetImageFormat androidImageFormat;
  final String? androidImage;
  final IconEffect androidEffect;
  final AndroidThemedIcon? androidThemed;

  final String? iosImage;
  final ColorValue? iosBackground;
  final String? iosDark;
  final ColorValue? iosBackgroundDark;
  final String? iosTinted;
  final int iosPadding;

  const AppIcon({
    required this.source,
    this.androidForeground,
    this.androidBackground,
    this.androidMonochrome,
    this.androidSafeZone = AdaptiveSafeZone.fit,
    this.androidPadding,
    this.androidForegroundFormat = IconForegroundFormat.vector,
    this.androidRound = false,
    this.androidIconName = 'ic_launcher',
    this.androidLegacy,
    this.androidLegacyPadding,
    this.androidPlayStore = false,
    this.androidPlayStorePadding,
    this.androidRasterView = IconRasterView.tile,
    this.androidImageFormat = AssetImageFormat.png,
    this.androidImage,
    this.androidEffect = IconEffect.none,
    this.androidThemed,
    this.iosImage,
    this.iosBackground,
    this.iosDark,
    this.iosBackgroundDark,
    this.iosTinted,
    this.iosPadding = 0,
  });

  /// Android-only view of this icon.
  AndroidAppIcon toAndroid() => AndroidAppIcon(
    foreground: androidForeground ?? source,
    background: androidBackground ?? const ColorValue('#000000'),
    monochrome: androidMonochrome,
    safeZone: androidSafeZone,
    padding: androidPadding,
    foregroundFormat: androidForegroundFormat,
    round: androidRound,
    iconName: androidIconName,
    legacy: androidLegacy,
    legacyPadding: androidLegacyPadding,
    playStore: androidPlayStore,
    playStorePadding: androidPlayStorePadding,
    rasterView: androidRasterView,
    imageFormat: androidImageFormat,
    image: androidImage,
    effect: androidEffect,
    themed: androidThemed,
  );

  /// iOS-only view of this icon.
  IosAppIcon toIOS() => IosAppIcon(
    image: iosImage ?? source,
    background: iosBackground ?? const ColorValue('#FFFFFF'),
    dark: iosDark,
    backgroundDark: iosBackgroundDark ?? const ColorValue('#000000'),
    tinted: iosTinted,
    padding: iosPadding,
  );
}

/// iOS launch-screen configuration (only iOS properties).
class IosSplash {
  final ColorValue? background;
  final ColorValue? backgroundDark;
  final String? backgroundImage;
  final String? backgroundImageDark;
  final String? image;
  final String? imageDark;

  /// Logo edge length in points on the launch screen.
  final int logoSize;

  const IosSplash({
    this.background,
    this.backgroundDark,
    this.backgroundImage,
    this.backgroundImageDark,
    this.image,
    this.imageDark,
    this.logoSize = 192,
  });
}

/// Android splash configuration (only Android properties).
class AndroidSplash {
  final ColorValue? background;
  final ColorValue? backgroundDark;
  final String? backgroundImage;
  final String? backgroundImageDark;
  final String? image;
  final String? imageDark;
  final SplashImageFit imageFit;
  final AssetImageFormat imageFormat;

  /// Ready-made AnimatedVectorDrawable for Android 12+.
  final String? animatedIcon;
  final String? animatedIconDark;

  /// Native animated-icon playback length in milliseconds.
  final int duration;
  final ColorValue? iconBackground;
  final ColorValue? iconBackgroundDark;

  /// Extra percent the native splash icon is inset.
  final int? iconPadding;
  final String gravity;
  final bool fullscreen;
  final String? screenOrientation;

  /// Hex colour or `transparent`.
  final String? statusBarColor;
  final String? statusBarColorDark;
  final StatusBarIconBrightness? statusBarIconBrightness;
  final StatusBarIconBrightness? statusBarIconBrightnessDark;

  /// Hex colour or `transparent`.
  final String? navigationBarColor;
  final String? navigationBarColorDark;
  final StatusBarIconBrightness? navigationBarIconBrightness;
  final StatusBarIconBrightness? navigationBarIconBrightnessDark;

  final String? branding;
  final String? brandingDark;
  final String? brandingText;
  final ColorValue? brandingTextColor;
  final ColorValue? brandingTextColorDark;
  final BrandingMode brandingMode;
  final SplashImageFit brandingFit;
  final int brandingBottomPadding;

  const AndroidSplash({
    this.background,
    this.backgroundDark,
    this.backgroundImage,
    this.backgroundImageDark,
    this.image,
    this.imageDark,
    this.imageFit = SplashImageFit.auto,
    this.imageFormat = AssetImageFormat.png,
    this.animatedIcon,
    this.animatedIconDark,
    this.duration = 1000,
    this.iconBackground,
    this.iconBackgroundDark,
    this.iconPadding,
    this.gravity = 'center',
    this.fullscreen = false,
    this.screenOrientation,
    this.statusBarColor,
    this.statusBarColorDark,
    this.statusBarIconBrightness,
    this.statusBarIconBrightnessDark,
    this.navigationBarColor,
    this.navigationBarColorDark,
    this.navigationBarIconBrightness,
    this.navigationBarIconBrightnessDark,
    this.branding,
    this.brandingDark,
    this.brandingText,
    this.brandingTextColor,
    this.brandingTextColorDark,
    this.brandingMode = BrandingMode.bottom,
    this.brandingFit = SplashImageFit.auto,
    this.brandingBottomPadding = 48,
  });

  String get imageFitValue => _enumValue(imageFit);
  String get imageFormatValue => _enumValue(imageFormat);
  String get brandingModeValue => _enumValue(brandingMode);
  String get brandingFitValue => _enumValue(brandingFit);
  String? get statusBarIconBrightnessValue => statusBarIconBrightness == null
      ? null
      : _enumValue(statusBarIconBrightness!);
  String? get statusBarIconBrightnessDarkValue =>
      statusBarIconBrightnessDark == null
      ? null
      : _enumValue(statusBarIconBrightnessDark!);
  String? get navigationBarIconBrightnessValue =>
      navigationBarIconBrightness == null
      ? null
      : _enumValue(navigationBarIconBrightness!);
  String? get navigationBarIconBrightnessDarkValue =>
      navigationBarIconBrightnessDark == null
      ? null
      : _enumValue(navigationBarIconBrightnessDark!);
}

/// Platform-neutral splash configuration.
///
/// Art and colours shared by both platforms are unprefixed. Android-only knobs
/// are prefixed with `android`; the iOS-only knob is prefixed with `ios`.
/// [toAndroid] / [toIOS] flatten the result into [AndroidSplash] / [IosSplash].
/// Flutter-only options (in-app splash behaviour) are intentionally excluded.
class SplashConfig {
  final String image;
  final ColorValue backgroundColor;
  final ColorValue? backgroundDark;
  final String? backgroundImage;
  final String? backgroundImageDark;
  final String? imageDark;

  final SplashImageFit androidImageFit;
  final AssetImageFormat androidImageFormat;
  final String? androidAnimatedIcon;
  final String? androidAnimatedIconDark;
  final int androidDuration;
  final ColorValue? androidIconBackground;
  final ColorValue? androidIconBackgroundDark;
  final int? androidIconPadding;
  final String androidGravity;
  final bool androidFullscreen;
  final String? androidScreenOrientation;
  final String? androidStatusBarColor;
  final String? androidStatusBarColorDark;
  final StatusBarIconBrightness? androidStatusBarIconBrightness;
  final StatusBarIconBrightness? androidStatusBarIconBrightnessDark;
  final String? androidNavigationBarColor;
  final String? androidNavigationBarColorDark;
  final StatusBarIconBrightness? androidNavigationBarIconBrightness;
  final StatusBarIconBrightness? androidNavigationBarIconBrightnessDark;
  final String? androidBranding;
  final String? androidBrandingDark;
  final String? androidBrandingText;
  final ColorValue? androidBrandingTextColor;
  final ColorValue? androidBrandingTextColorDark;
  final BrandingMode androidBrandingMode;
  final SplashImageFit androidBrandingFit;
  final int androidBrandingBottomPadding;

  final int iosLogoSize;

  const SplashConfig({
    required this.image,
    required this.backgroundColor,
    this.backgroundDark,
    this.backgroundImage,
    this.backgroundImageDark,
    this.imageDark,
    this.androidImageFit = SplashImageFit.auto,
    this.androidImageFormat = AssetImageFormat.png,
    this.androidAnimatedIcon,
    this.androidAnimatedIconDark,
    this.androidDuration = 1000,
    this.androidIconBackground,
    this.androidIconBackgroundDark,
    this.androidIconPadding,
    this.androidGravity = 'center',
    this.androidFullscreen = false,
    this.androidScreenOrientation,
    this.androidStatusBarColor,
    this.androidStatusBarColorDark,
    this.androidStatusBarIconBrightness,
    this.androidStatusBarIconBrightnessDark,
    this.androidNavigationBarColor,
    this.androidNavigationBarColorDark,
    this.androidNavigationBarIconBrightness,
    this.androidNavigationBarIconBrightnessDark,
    this.androidBranding,
    this.androidBrandingDark,
    this.androidBrandingText,
    this.androidBrandingTextColor,
    this.androidBrandingTextColorDark,
    this.androidBrandingMode = BrandingMode.bottom,
    this.androidBrandingFit = SplashImageFit.auto,
    this.androidBrandingBottomPadding = 48,
    this.iosLogoSize = 192,
  });

  AndroidSplash toAndroid() => AndroidSplash(
    background: backgroundColor,
    backgroundDark: backgroundDark,
    backgroundImage: backgroundImage,
    backgroundImageDark: backgroundImageDark,
    image: image,
    imageDark: imageDark,
    imageFit: androidImageFit,
    imageFormat: androidImageFormat,
    animatedIcon: androidAnimatedIcon,
    animatedIconDark: androidAnimatedIconDark,
    duration: androidDuration,
    iconBackground: androidIconBackground,
    iconBackgroundDark: androidIconBackgroundDark,
    iconPadding: androidIconPadding,
    gravity: androidGravity,
    fullscreen: androidFullscreen,
    screenOrientation: androidScreenOrientation,
    statusBarColor: androidStatusBarColor,
    statusBarColorDark: androidStatusBarColorDark,
    statusBarIconBrightness: androidStatusBarIconBrightness,
    statusBarIconBrightnessDark: androidStatusBarIconBrightnessDark,
    navigationBarColor: androidNavigationBarColor,
    navigationBarColorDark: androidNavigationBarColorDark,
    navigationBarIconBrightness: androidNavigationBarIconBrightness,
    navigationBarIconBrightnessDark: androidNavigationBarIconBrightnessDark,
    branding: androidBranding,
    brandingDark: androidBrandingDark,
    brandingText: androidBrandingText,
    brandingTextColor: androidBrandingTextColor,
    brandingTextColorDark: androidBrandingTextColorDark,
    brandingMode: androidBrandingMode,
    brandingFit: androidBrandingFit,
    brandingBottomPadding: androidBrandingBottomPadding,
  );

  IosSplash toIOS() => IosSplash(
    background: backgroundColor,
    backgroundDark: backgroundDark,
    backgroundImage: backgroundImage,
    backgroundImageDark: backgroundImageDark,
    image: image,
    imageDark: imageDark,
    logoSize: iosLogoSize,
  );
}

class AppConfig {
  final String name;
  final BundleId bundleId;
  final AppVersion version;
  final AppIcon? icon;
  final SplashConfig? splash;
  final String? deepLinkScheme;
  const AppConfig({
    required this.name,
    required this.bundleId,
    required this.version,
    this.icon,
    this.splash,
    this.deepLinkScheme,
  });
}

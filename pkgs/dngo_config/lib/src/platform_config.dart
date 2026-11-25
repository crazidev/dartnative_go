import 'dart:io';

import 'android_intent.dart';
import 'android_permissions.dart';
import 'app_config.dart';

class IosVersion {
  final int major;
  final int minor;
  const IosVersion(this.major, [this.minor = 0]);
  @override
  String toString() => '$major.$minor';
}

enum IosOrientation {
  portrait,
  portraitUpsideDown,
  landscapeLeft,
  landscapeRight;

  /// Portrait plus both landscapes. Upside-down portrait is omitted because
  /// it is rarely wanted on iPhone and is no longer a DartNative default.
  static const Set<IosOrientation> defaults = {
    portrait,
    landscapeLeft,
    landscapeRight,
  };

  static const Set<IosOrientation> all = {
    portrait,
    portraitUpsideDown,
    landscapeLeft,
    landscapeRight,
  };
}

class IosConfig {
  final IosVersion minimumDeploymentTarget;
  final Set<IosOrientation> supportedOrientations;
  final String? appGroup;
  final bool supportsLiveActivities;
  final bool supportsIpad;

  /// URL schemes the app may probe with `canOpenURL(_:)`.
  ///
  /// Written to `LSApplicationQueriesSchemes` in `Info.plist`.
  final Set<String> querySchemes;

  /// Custom URL schemes the app handles, for example `dngo`.
  ///
  /// Merged into `CFBundleURLTypes` in `Info.plist`; existing schemes such as
  /// the scaffold's `dartnativego` are kept.
  final Set<String> urlSchemes;

  /// Associated domains for Universal Links, for example `applinks:acme.com`.
  ///
  /// Written to `com.apple.developer.associated-domains` in
  /// `ios/Runner/Runner.entitlements`.
  final Set<String> associatedDomains;
  final IosAppIcon? icon;
  final IosSplash? splash;
  const IosConfig({
    this.minimumDeploymentTarget = const IosVersion(16, 1),
    this.supportedOrientations = IosOrientation.defaults,
    this.appGroup,
    this.supportsLiveActivities = false,
    this.supportsIpad = true,
    this.querySchemes = const {},
    this.urlSchemes = const {},
    this.associatedDomains = const {},
    this.icon,
    this.splash,
  });
}

class AndroidSigningConfig {
  final String? storeFile;
  final String? storePassword;
  final String? keyAlias;
  final String? keyPassword;
  final String? propertyPath;
  final bool isDebug;

  const AndroidSigningConfig._({
    this.storeFile,
    this.storePassword,
    this.keyAlias,
    this.keyPassword,
    this.propertyPath,
    this.isDebug = false,
  });

  const AndroidSigningConfig({
    required String storeFile,
    required String storePassword,
    required String keyAlias,
    required String keyPassword,
  }) : this._(
         storeFile: storeFile,
         storePassword: storePassword,
         keyAlias: keyAlias,
         keyPassword: keyPassword,
       );

  const AndroidSigningConfig.debug() : this._(isDebug: true);

  factory AndroidSigningConfig.fromGradleProperty(
    String path, {
    String? baseDirectory,
  }) {
    final file = File(
      path.startsWith('/')
          ? path
          : '${baseDirectory ?? Directory.current.path}/$path',
    );
    if (!file.existsSync()) {
      throw StateError('Signing properties file not found: ${file.path}');
    }
    final values = <String, String>{};
    for (final line in file.readAsLinesSync()) {
      final value = line.trim();
      if (value.isEmpty || value.startsWith('#')) continue;
      final separator = value.indexOf('=');
      if (separator < 0) continue;
      values[value.substring(0, separator).trim()] = value
          .substring(separator + 1)
          .trim();
    }
    return AndroidSigningConfig._(
      storeFile: values['storeFile'],
      storePassword: values['storePassword'],
      keyAlias: values['keyAlias'],
      keyPassword: values['keyPassword'],
      propertyPath: path,
    );
  }
}

/// Null fields preserve values supplied by the DartNative Gradle extension.
class AndroidConfig {
  final int? minSdk;
  final int? targetSdk;
  final int? compileSdk;
  final String? ndkVersion;
  final int? versionCode;
  final String? versionName;
  final AndroidSigningConfig? signing;
  final bool? usesCleartextTraffic;
  final Set<AndroidPermission> permissions;

  /// Intents written to the `<queries>` element of `AndroidManifest.xml`.
  ///
  /// Needed on Android 11+ before checking whether another app can handle an
  /// intent or URL.
  final List<AndroidIntent> intentQueries;

  /// Intent filters added to an activity in `AndroidManifest.xml`.
  ///
  /// Unlike [intentQueries], these make the app itself handle the matching
  /// actions, links and MIME types.
  final List<AndroidIntentFilter> intentFilters;
  final AndroidAppIcon? icon;
  final AndroidSplash? splash;
  const AndroidConfig({
    this.minSdk,
    this.targetSdk,
    this.compileSdk,
    this.ndkVersion,
    this.versionCode,
    this.versionName,
    this.signing = const AndroidSigningConfig.debug(),
    this.usesCleartextTraffic,
    this.permissions = const {},
    this.intentQueries = const [],
    this.intentFilters = const [],
    this.icon,
    this.splash,
  });
}

class PlatformsConfig {
  final IosConfig ios;
  final AndroidConfig android;
  const PlatformsConfig({
    this.ios = const IosConfig(),
    this.android = const AndroidConfig(),
  });
}

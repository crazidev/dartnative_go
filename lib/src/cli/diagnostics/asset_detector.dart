import 'dart:io';

import 'package:dartnative_go_config/dngo.dart';
import 'package:yaml/yaml.dart';

/// Detected assets for a DartNative project (App Icon and Splash Screen).
class ProjectAssets {
  final File? iconFile;
  final String? iconPath;
  final File? splashFile;
  final String? splashPath;

  /// Explicit splash background from `dngo.config.dart` or
  /// `dartnative_splash` / `flutter_native_splash`.
  ///
  /// Null when the project has no configured color — the host splash then
  /// follows the shell light/dark theme instead of a hard-coded black.
  final String? splashBackgroundColor;

  /// Optional dark-mode splash background.
  final String? splashBackgroundColorDark;

  const ProjectAssets({
    this.iconFile,
    this.iconPath,
    this.splashFile,
    this.splashPath,
    this.splashBackgroundColor,
    this.splashBackgroundColorDark,
  });

  bool get hasIcon => iconFile != null && iconFile!.existsSync();
  bool get hasSplash => splashFile != null && splashFile!.existsSync();
  bool get hasConfiguredSplashColor => splashBackgroundColor != null;

  String formatReport() {
    final buffer = StringBuffer();
    if (hasIcon) {
      buffer.writeln('[ICON] \x1B[32mApp Icon:\x1B[0m $iconPath');
    } else {
      buffer.writeln(
        '[ICON] \x1B[33mApp Icon:\x1B[0m (default DartNative logo will be used)',
      );
    }

    if (hasSplash) {
      final bg = hasConfiguredSplashColor
          ? ' (Background: \x1B[1m$splashBackgroundColor\x1B[0m'
                '${splashBackgroundColorDark != null ? ' / dark $splashBackgroundColorDark' : ''})'
          : ' (Background: theme)';
      buffer.writeln(
        '[SPLASH] \x1B[32mSplash Screen:\x1B[0m $splashPath$bg',
      );
    } else {
      buffer.writeln(
        '[SPLASH] \x1B[33mSplash Screen:\x1B[0m (default launcher splash will be used)',
      );
    }

    if (!hasIcon || !hasSplash) {
      buffer.writeln(
        '   \x1B[90m[TIP] Set app.icon / app.splash in dngo.config.dart '
        '(or assets/icon.png) to personalize your launch experience.\x1B[0m',
      );
    }

    return buffer.toString();
  }
}

/// Detects app icon and splash screen configuration and image files in a project.
///
/// Precedence:
/// 1. `dngo.config.dart` via [DngoConfigParser]
/// 2. Legacy `pubspec.yaml` splash / `dartnative.assets` entries
/// 3. Common on-disk asset paths
class AssetDetector {
  final Directory projectDir;

  AssetDetector(this.projectDir);

  ProjectAssets detect() {
    File? iconFile;
    String? iconPath;
    File? splashFile;
    String? splashPath;
    String? splashBgColor;
    String? splashBgColorDark;

    final config = _tryParseDngoConfig();
    if (config != null) {
      final configIcon = _iconPathFromConfig(config);
      if (configIcon != null) {
        final candidate = File('${projectDir.path}/$configIcon');
        if (candidate.existsSync()) {
          iconFile = candidate;
          iconPath = configIcon;
        }
      }

      final configSplash = _splashPathFromConfig(config);
      if (configSplash != null) {
        final candidate = File('${projectDir.path}/$configSplash');
        if (candidate.existsSync()) {
          splashFile = candidate;
          splashPath = configSplash;
        }
      }

      splashBgColor = _splashBackgroundFromConfig(config);
      splashBgColorDark = _splashBackgroundDarkFromConfig(config);
    }

    // Legacy pubspec.yaml splash / dartnative.assets (fill only missing fields).
    final pubspecFile = File('${projectDir.path}/pubspec.yaml');
    if (pubspecFile.existsSync()) {
      try {
        final content = pubspecFile.readAsStringSync();
        final dynamic yamlMap = loadYaml(content);
        if (yamlMap is YamlMap) {
          final splashConfig =
              yamlMap['dartnative_splash'] ?? yamlMap['flutter_native_splash'];
          if (splashConfig is YamlMap) {
            splashBgColor ??=
                splashConfig['color']?.toString() ??
                splashConfig['background_color']?.toString();
            splashBgColorDark ??=
                splashConfig['color_dark']?.toString() ??
                splashConfig['background_color_dark']?.toString();

            if (splashFile == null) {
              final imgPath = splashConfig['image']?.toString();
              if (imgPath != null) {
                final candidate = File('${projectDir.path}/$imgPath');
                if (candidate.existsSync()) {
                  splashFile = candidate;
                  splashPath = imgPath;
                }
              }
            }
          }

          if (iconFile == null) {
            final dnConfig = yamlMap['dartnative'];
            if (dnConfig is YamlMap && dnConfig['assets'] is YamlList) {
              for (final item in dnConfig['assets'] as YamlList) {
                final pathStr = item.toString();
                if (pathStr.contains('logo') || pathStr.contains('icon')) {
                  final candidate = File('${projectDir.path}/$pathStr');
                  if (candidate.existsSync()) {
                    iconFile = candidate;
                    iconPath = pathStr;
                    break;
                  }
                }
              }
            }
          }
        }
      } catch (_) {}
    }

    // Common on-disk locations for anything still missing.
    if (iconFile == null) {
      const iconCandidates = [
        'assets/icon.png',
        'assets/app_icon.png',
        'assets/logo.png',
        'assets/dn-logo.png',
        'assets/dartnative.png',
        'assets/images/icon.png',
        'assets/images/logo.png',
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/AppIcon.png',
        'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png',
      ];
      for (final rel in iconCandidates) {
        final candidate = File('${projectDir.path}/$rel');
        if (candidate.existsSync()) {
          iconFile = candidate;
          iconPath = rel;
          break;
        }
      }
    }

    if (splashFile == null) {
      const splashCandidates = [
        'assets/splash.png',
        'assets/launch.png',
        'assets/splash_screen.png',
        'assets/images/splash.png',
      ];
      for (final rel in splashCandidates) {
        final candidate = File('${projectDir.path}/$rel');
        if (candidate.existsSync()) {
          splashFile = candidate;
          splashPath = rel;
          break;
        }
      }
    }

    // If splash not found, use icon as fallback splash image if available.
    if (splashFile == null && iconFile != null) {
      splashFile = iconFile;
      splashPath = iconPath;
    }

    return ProjectAssets(
      iconFile: iconFile,
      iconPath: iconPath,
      splashFile: splashFile,
      splashPath: splashPath,
      splashBackgroundColor: splashBgColor,
      splashBackgroundColorDark: splashBgColorDark,
    );
  }

  DngoConfig? _tryParseDngoConfig() {
    final configFile = File('${projectDir.path}/dngo.config.dart');
    if (!configFile.existsSync()) return null;
    try {
      return DngoConfigParser.parse(
        configFile.readAsStringSync(),
        baseDirectory: projectDir.path,
      );
    } catch (_) {
      return null;
    }
  }

  /// Host-facing icon art: shared app icon, then iOS, then Android foreground.
  static String? _iconPathFromConfig(DngoConfig config) {
    return config.app.icon?.source ??
        config.iosIcon?.image ??
        config.androidIcon?.foreground ??
        config.androidIcon?.image;
  }

  /// Host-facing splash image: shared splash, then platform splash images.
  static String? _splashPathFromConfig(DngoConfig config) {
    return config.app.splash?.image ??
        config.iosSplash?.image ??
        config.androidSplash?.image;
  }

  static String? _splashBackgroundFromConfig(DngoConfig config) {
    final color =
        config.app.splash?.backgroundColor ??
        config.iosSplash?.background ??
        config.androidSplash?.background;
    return color?.value;
  }

  static String? _splashBackgroundDarkFromConfig(DngoConfig config) {
    final color =
        config.app.splash?.backgroundDark ??
        config.iosSplash?.backgroundDark ??
        config.androidSplash?.backgroundDark;
    return color?.value;
  }
}

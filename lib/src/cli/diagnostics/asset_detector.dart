import 'dart:io';
import 'package:yaml/yaml.dart';

/// Detected assets for a DartNative project (App Icon and Splash Screen).
class ProjectAssets {
  final File? iconFile;
  final String? iconPath;
  final File? splashFile;
  final String? splashPath;
  final String splashBackgroundColor;

  const ProjectAssets({
    this.iconFile,
    this.iconPath,
    this.splashFile,
    this.splashPath,
    this.splashBackgroundColor = '#000000',
  });

  bool get hasIcon => iconFile != null && iconFile!.existsSync();
  bool get hasSplash => splashFile != null && splashFile!.existsSync();

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
      buffer.writeln(
        '[SPLASH] \x1B[32mSplash Screen:\x1B[0m $splashPath '
        '(Background: \x1B[1m$splashBackgroundColor\x1B[0m)',
      );
    } else {
      buffer.writeln(
        '[SPLASH] \x1B[33mSplash Screen:\x1B[0m (default launcher splash will be used)',
      );
    }

    if (!hasIcon || !hasSplash) {
      buffer.writeln(
        '   \x1B[90m[TIP] Add dartnative_splash config or assets/icon.png to personalize your launch experience.\x1B[0m',
      );
    }

    return buffer.toString();
  }
}

/// Detects app icon and splash screen configuration and image files in a project.
class AssetDetector {
  final Directory projectDir;

  AssetDetector(this.projectDir);

  ProjectAssets detect() {
    File? iconFile;
    String? iconPath;
    File? splashFile;
    String? splashPath;
    String splashBgColor = '#000000';

    // 1. Inspect pubspec.yaml for configurations
    final pubspecFile = File('${projectDir.path}/pubspec.yaml');
    if (pubspecFile.existsSync()) {
      try {
        final content = pubspecFile.readAsStringSync();
        final dynamic yamlMap = loadYaml(content);
        if (yamlMap is YamlMap) {
          // Check dartnative_splash / flutter_native_splash
          final splashConfig =
              yamlMap['dartnative_splash'] ?? yamlMap['flutter_native_splash'];
          if (splashConfig is YamlMap) {
            if (splashConfig['color'] != null) {
              splashBgColor = splashConfig['color'].toString();
            } else if (splashConfig['background_color'] != null) {
              splashBgColor = splashConfig['background_color'].toString();
            }

            final imgPath = splashConfig['image']?.toString();
            if (imgPath != null) {
              final candidate = File('${projectDir.path}/$imgPath');
              if (candidate.existsSync()) {
                splashFile = candidate;
                splashPath = imgPath;
              }
            }
          }

          // Check dartnative: assets: for logo/icon
          final dnConfig = yamlMap['dartnative'];
          if (dnConfig is YamlMap && dnConfig['assets'] is YamlList) {
            for (final item in dnConfig['assets'] as YamlList) {
              final pathStr = item.toString();
              if (pathStr.contains('logo') || pathStr.contains('icon')) {
                final candidate = File('${projectDir.path}/$pathStr');
                if (candidate.existsSync()) {
                  iconFile ??= candidate;
                  iconPath ??= pathStr;
                }
              }
            }
          }
        }
      } catch (_) {}
    }

    // 2. Search common locations for App Icon
    if (iconFile == null) {
      final iconCandidates = [
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

    // 3. Search common locations for Splash Screen
    if (splashFile == null) {
      final splashCandidates = [
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

    // If splash not found, use icon as fallback splash image if available
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
    );
  }
}

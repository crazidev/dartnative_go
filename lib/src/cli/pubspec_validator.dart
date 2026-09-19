import 'dart:io';
import 'package:yaml/yaml.dart';

import 'dart_go_version.dart';

/// Represents a mismatch in a plugin's version constraint.
class VersionMismatch {
  final String pluginName;
  final String declaredConstraint;
  final String requiredConstraint;

  const VersionMismatch({
    required this.pluginName,
    required this.declaredConstraint,
    required this.requiredConstraint,
  });
}

/// The result of validating a project's `pubspec.yaml` against DartNative Go.
class PubspecValidationResult {
  final String appName;
  final String appVersion;
  final Map<String, String> validSupportedPlugins;
  final List<VersionMismatch> versionMismatches;
  final List<String> unsupportedNativePlugins;
  final List<String> pureDartDependencies;
  final bool hasPubspec;

  const PubspecValidationResult({
    required this.appName,
    required this.appVersion,
    required this.validSupportedPlugins,
    required this.versionMismatches,
    required this.unsupportedNativePlugins,
    required this.pureDartDependencies,
    required this.hasPubspec,
  });

  bool get isFullyCompatible =>
      versionMismatches.isEmpty && unsupportedNativePlugins.isEmpty;

  /// Formats the validation report for terminal display.
  String formatReport() {
    final buffer = StringBuffer();
    buffer.writeln('📋 \x1B[1mProject: $appName ($appVersion)\x1B[0m');
    buffer.writeln('   DartNative Go Target: v$kDartGoVersion');
    buffer.writeln('──────────────────────────────────────────────────');

    if (validSupportedPlugins.isNotEmpty) {
      buffer.writeln('\x1B[32m✔ Supported Native Plugins:\x1B[0m');
      for (final entry in validSupportedPlugins.entries) {
        buffer.writeln('   • ${entry.key}: ${entry.value}');
      }
    }

    if (versionMismatches.isNotEmpty) {
      buffer.writeln('\n\x1B[33m⚠ Plugin Version Mismatches:\x1B[0m');
      for (final mismatch in versionMismatches) {
        buffer.writeln(
          '   • \x1B[1m${mismatch.pluginName}\x1B[0m: declared '
          '\x1B[31m${mismatch.declaredConstraint}\x1B[0m, '
          'DartNative Go v$kDartGoVersion requires \x1B[32m${mismatch.requiredConstraint}\x1B[0m',
        );
      }
      buffer.writeln(
        '\n   \x1B[36m💡 Action Required: Update your pubspec.yaml to match DartNative Go v$kDartGoVersion plugin versions.\x1B[0m',
      );
    }

    if (unsupportedNativePlugins.isNotEmpty) {
      buffer.writeln('\n\x1B[31m✖ Unsupported Native Plugins:\x1B[0m');
      for (final plugin in unsupportedNativePlugins) {
        buffer.writeln(
          '   • \x1B[1m$plugin\x1B[0m (native code not compiled into DartNative Go runtime)',
        );
      }
      buffer.writeln(
        '   \x1B[33m⚠ This project includes native plugins not bundled in DartNative Go.\n'
        '     Native method calls for these packages may fail at runtime.\x1B[0m',
      );
    }

    if (isFullyCompatible) {
      buffer.writeln('\n\x1B[32m✔ All dependencies are 100% compatible with DartNative Go v$kDartGoVersion.\x1B[0m');
    }

    return buffer.toString();
  }
}

/// Validates the `pubspec.yaml` in [projectDir].
class PubspecValidator {
  final Directory projectDir;

  PubspecValidator(this.projectDir);

  PubspecValidationResult validate() {
    final pubspecFile = File('${projectDir.path}/pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      return const PubspecValidationResult(
        appName: 'Unknown',
        appVersion: '0.0.0',
        validSupportedPlugins: {},
        versionMismatches: [],
        unsupportedNativePlugins: [],
        pureDartDependencies: [],
        hasPubspec: false,
      );
    }

    final content = pubspecFile.readAsStringSync();
    final dynamic yamlMap;
    try {
      yamlMap = loadYaml(content);
    } catch (_) {
      return const PubspecValidationResult(
        appName: 'Invalid YAML',
        appVersion: '0.0.0',
        validSupportedPlugins: {},
        versionMismatches: [],
        unsupportedNativePlugins: [],
        pureDartDependencies: [],
        hasPubspec: false,
      );
    }

    final appName = yamlMap['name']?.toString() ?? 'Unnamed App';
    final appVersion = yamlMap['version']?.toString() ?? '0.1.0';

    final dependencies = <String, String>{};
    if (yamlMap['dependencies'] is YamlMap) {
      for (final entry in (yamlMap['dependencies'] as YamlMap).entries) {
        final key = entry.key.toString();
        final value = entry.value;
        if (value is String) {
          dependencies[key] = value;
        } else if (value is YamlMap && value.containsKey('path')) {
          dependencies[key] = 'path: ${value['path']}';
        } else if (value is YamlMap && value.containsKey('git')) {
          dependencies[key] = 'git';
        } else {
          dependencies[key] = value?.toString() ?? 'any';
        }
      }
    }

    final validSupportedPlugins = <String, String>{};
    final versionMismatches = <VersionMismatch>[];
    final unsupportedNativePlugins = <String>[];
    final pureDartDependencies = <String>[];

    for (final entry in dependencies.entries) {
      final name = entry.key;
      final constraint = entry.value;

      final supported = kSupportedPluginsByName[name];
      if (supported != null) {
        if (_isConstraintCompatible(constraint, supported.supportedConstraint)) {
          validSupportedPlugins[name] = constraint;
        } else {
          versionMismatches.add(
            VersionMismatch(
              pluginName: name,
              declaredConstraint: constraint,
              requiredConstraint: supported.supportedConstraint,
            ),
          );
        }
      } else if (isNativePlugin(name)) {
        unsupportedNativePlugins.add(name);
      } else {
        pureDartDependencies.add(name);
      }
    }

    return PubspecValidationResult(
      appName: appName,
      appVersion: appVersion,
      validSupportedPlugins: validSupportedPlugins,
      versionMismatches: versionMismatches,
      unsupportedNativePlugins: unsupportedNativePlugins,
      pureDartDependencies: pureDartDependencies,
      hasPubspec: true,
    );
  }

  /// Checks if [declared] is compatible with [required].
  /// Matches exact strings, `any`, or caret/semver approximations.
  bool _isConstraintCompatible(String declared, String required) {
    if (declared == 'any') return true;
    if (declared == required) return true;

    // Normalize: strip leading ^
    final normDeclared = declared.replaceAll('^', '').trim();
    final normRequired = required.replaceAll('^', '').trim();

    // Check major version match
    final decMajor = int.tryParse(normDeclared.split('.').first);
    final reqMajor = int.tryParse(normRequired.split('.').first);

    if (decMajor != null && reqMajor != null) {
      return decMajor == reqMajor;
    }

    return false;
  }
}

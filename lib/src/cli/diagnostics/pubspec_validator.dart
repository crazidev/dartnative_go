import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
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
    buffer.writeln('[INFO] \x1B[1mProject: $appName ($appVersion)\x1B[0m');
    buffer.writeln('   DartNative Go Target: v$kDartGoVersion');
    buffer.writeln('──────────────────────────────────────────────────');

    if (validSupportedPlugins.isNotEmpty) {
      buffer.writeln('\x1B[32m+ Supported Native Plugins:\x1B[0m');
      for (final entry in validSupportedPlugins.entries) {
        buffer.writeln('   • ${entry.key}: ${entry.value}');
      }
    }

    if (versionMismatches.isNotEmpty) {
      buffer.writeln('\n\x1B[33m! Plugin Version Mismatches:\x1B[0m');
      for (final mismatch in versionMismatches) {
        buffer.writeln(
          '   • \x1B[1m${mismatch.pluginName}\x1B[0m: declared '
          '\x1B[31m${mismatch.declaredConstraint}\x1B[0m, '
          'DartNative Go v$kDartGoVersion requires \x1B[32m${mismatch.requiredConstraint}\x1B[0m',
        );
      }
      buffer.writeln(
        '\n   \x1B[36m[TIP] Action Required: Update your pubspec.yaml to match DartNative Go v$kDartGoVersion plugin versions.\x1B[0m',
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
        '   \x1B[33m! This project includes native plugins not bundled in DartNative Go.\n'
        '     Native method calls for these packages may fail at runtime.\x1B[0m',
      );
    }

    if (isFullyCompatible) {
      buffer.writeln(
        '\n\x1B[32m✔ All dependencies are 100% compatible with DartNative Go v$kDartGoVersion.\x1B[0m',
      );
    }

    return buffer.toString();
  }
}

/// A dependency entry as declared in `pubspec.yaml`, normalized for display
/// and version checking.
class _DependencySpec {
  final String name;

  /// How the dependency is written in `pubspec.yaml` (`^1.0.0`,
  /// `path: ../plugin`, `git`, …) — shown in mismatch diagnostics.
  final String display;

  /// Semver constraint when it can be determined. `null` when the version is
  /// unknown (git dependencies or an unreadable path target).
  final String? constraint;

  const _DependencySpec(this.name, this.display, this.constraint);
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

    final dependencies = _parseDependencies(yamlMap['dependencies']);

    final validSupportedPlugins = <String, String>{};
    final versionMismatches = <VersionMismatch>[];
    final unsupportedNativePlugins = <String>[];
    final pureDartDependencies = <String>[];

    for (final dependency in dependencies.values) {
      final name = dependency.name;

      final supported = kSupportedPluginsByName[name];
      if (supported != null) {
        final constraint = dependency.constraint;
        if (constraint != null &&
            _isConstraintCompatible(
              constraint,
              supported.supportedConstraint,
            )) {
          validSupportedPlugins[name] = dependency.display;
        } else {
          versionMismatches.add(
            VersionMismatch(
              pluginName: name,
              declaredConstraint: dependency.display,
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

  /// Normalizes the `dependencies:` map, keeping the declared display form and
  /// extracting a semver constraint where one exists.
  ///
  /// Handles plain strings, `hosted:` maps with a `version:` key (for example
  /// `riverpod_kit`), `path:` dependencies (version read from the target
  /// package's `pubspec.yaml`) and `git:` dependencies (version unknown).
  Map<String, _DependencySpec> _parseDependencies(Object? node) {
    final result = <String, _DependencySpec>{};
    if (node is! YamlMap) return result;

    for (final entry in node.entries) {
      final name = entry.key.toString();
      final value = entry.value;

      if (value == null) {
        result[name] = _DependencySpec(name, 'any', 'any');
      } else if (value is String) {
        result[name] = _DependencySpec(name, value, value);
      } else if (value is YamlMap) {
        final path = value['path']?.toString();
        if (path != null) {
          result[name] = _DependencySpec(
            name,
            'path: $path',
            _readPathPackageVersion(path),
          );
          continue;
        }
        final version = value['version']?.toString();
        if (version != null) {
          result[name] = _DependencySpec(name, version, version);
          continue;
        }
        if (value.containsKey('git')) {
          result[name] = _DependencySpec(name, 'git', null);
          continue;
        }
        // Other map forms (e.g. `hosted:` without an explicit version) mean
        // "any version".
        result[name] = _DependencySpec(name, 'any', 'any');
      } else {
        final display = value.toString();
        result[name] = _DependencySpec(name, display, display);
      }
    }
    return result;
  }

  /// Reads the `version:` from a `path:` dependency's target `pubspec.yaml`.
  ///
  /// Returns `null` when the target cannot be read, so it is reported as an
  /// unverifiable constraint instead of silently passing.
  String? _readPathPackageVersion(String path) {
    try {
      final resolved = p.isAbsolute(path)
          ? path
          : p.join(projectDir.path, path);
      final pubspec = File(p.join(resolved, 'pubspec.yaml'));
      if (!pubspec.existsSync()) return null;
      final yaml = loadYaml(pubspec.readAsStringSync());
      if (yaml is! YamlMap) return null;
      return yaml['version']?.toString();
    } catch (_) {
      return null;
    }
  }

  /// Checks whether [declared] overlaps [required] (e.g. a path package's
  /// `0.1.0` satisfies `^0.1.0`).
  bool _isConstraintCompatible(String declared, String required) {
    if (declared.isEmpty || declared == 'any') return true;
    if (declared == required) return true;

    try {
      final declaredConstraint = VersionConstraint.parse(declared);
      final requiredConstraint = VersionConstraint.parse(required);
      return !declaredConstraint.intersect(requiredConstraint).isEmpty;
    } catch (_) {
      return false;
    }
  }
}

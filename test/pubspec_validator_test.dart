import 'dart:io';
import 'package:dartnative_go/src/cli/pubspec_validator.dart';

void main() {
  final tempDir = Directory.systemTemp.createTempSync('dart_go_test_');

  try {
    // Case 1: Fully compatible pubspec
    final pubspec1 = File('${tempDir.path}/pubspec.yaml');
    pubspec1.writeAsStringSync('''
name: valid_app
version: 1.2.3
dependencies:
  dartnative: ^1.0.0
  dartnative_ios: ^1.0.0
  dartnative_share: ^1.0.0
  path: ^1.8.0
''');

    final validator1 = PubspecValidator(tempDir);
    final res1 = validator1.validate();
    assert(res1.isFullyCompatible, 'Expected valid_app to be fully compatible');
    assert(res1.validSupportedPlugins.containsKey('dartnative_share'));
    assert(res1.pureDartDependencies.contains('path'));
    assert(res1.versionMismatches.isEmpty);
    assert(res1.unsupportedNativePlugins.isEmpty);

    // Case 2: Version mismatch
    pubspec1.writeAsStringSync('''
name: mismatch_app
version: 1.0.0
dependencies:
  dartnative: ^1.0.0
  dartnative_share: ^2.0.0
''');

    final res2 = validator1.validate();
    assert(!res2.isFullyCompatible);
    assert(res2.versionMismatches.length == 1);
    assert(res2.versionMismatches.first.pluginName == 'dartnative_share');
    assert(res2.versionMismatches.first.declaredConstraint == '^2.0.0');
    assert(res2.versionMismatches.first.requiredConstraint == '^1.0.0');

    // Case 3: Unsupported native plugin
    pubspec1.writeAsStringSync('''
name: unsupported_app
version: 1.0.0
dependencies:
  dartnative: ^1.0.0
  dartnative_bluetooth: ^0.5.0
''');

    final res3 = validator1.validate();
    assert(!res3.isFullyCompatible);
    assert(res3.unsupportedNativePlugins.contains('dartnative_bluetooth'));

    print('All PubspecValidator tests passed successfully!');
  } finally {
    tempDir.deleteSync(recursive: true);
  }
}

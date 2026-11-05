import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:test/test.dart';

/// Pub workspaces keep a single `.dart_tool/package_config.json` at the
/// workspace root; member packages have none of their own. The AST bundler
/// must walk up to that config or pure-Dart imports in members (for example
/// `package:get_it/get_it.dart`) fail to resolve.
void main() {
  test('resolvePackageSources finds the workspace root package config', () {
    final temp = Directory.systemTemp.createTempSync('dn_workspace_config_');
    try {
      final member = Directory('${temp.path}/member')..createSync();
      File('${member.path}/pubspec.yaml').writeAsStringSync(
        'name: member\nversion: 0.1.0\n',
      );

      final helperLib = Directory('${temp.path}/helper/lib')
        ..createSync(recursive: true);
      File('${helperLib.path}/helper.dart').writeAsStringSync(
        'int answer() => 42;\n',
      );

      final config = File('${temp.path}/.dart_tool/package_config.json');
      config.parent.createSync(recursive: true);
      config.writeAsStringSync(
        jsonEncode({
          'configVersion': 2,
          'packages': [
            {
              'name': 'member',
              'rootUri': '../member',
              'packageUri': 'lib/',
            },
            {
              'name': 'helper',
              'rootUri': '../helper',
              'packageUri': 'lib/',
            },
          ],
        }),
      );

      expect(findPackageConfigFile(member)?.path, equals(config.path));

      final sources = resolvePackageSources(member, packageName: 'member');
      expect(sources, contains('package:helper/helper.dart'));
      expect(sources, isNot(contains('package:member/helper.dart')));
    } finally {
      try {
        temp.deleteSync(recursive: true);
      } catch (_) {}
    }
  });

  test('resolvePackageSources returns no sources without any config', () {
    final temp = Directory.systemTemp.createTempSync('dn_no_config_');
    try {
      expect(findPackageConfigFile(temp), isNull);
      expect(resolvePackageSources(temp), isEmpty);
    } finally {
      try {
        temp.deleteSync(recursive: true);
      } catch (_) {}
    }
  });
}

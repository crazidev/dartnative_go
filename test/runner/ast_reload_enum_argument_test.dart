import 'dart:io';

import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

void main() {
  test('enum arguments stay type-compatible after a library reload', () async {
    final project = Directory.systemTemp.createTempSync('dn_enum_reload_');
    final lib = Directory('${project.path}/lib')..createSync(recursive: true);
    final mainFile = File('${lib.path}/main.dart');
    final registryFile = File('${lib.path}/registry.dart');
    mainFile.writeAsStringSync('''
import 'registry.dart';

class ApiClient {}

void main() => registry.register<ApiClient>(RegistrationType.constant);
''');
    registryFile.writeAsStringSync('''
enum RegistrationType { constant }

class Registry {
  void register<T extends Object>(RegistrationType type) {
    if (type != RegistrationType.constant) throw StateError('wrong kind');
  }
}

final registry = Registry();
''');

    try {
      Future<ast.AstBundle> build() => AstBundler(
        projectRoot: project.path,
      ).createFromFile(mainFile.path);

      final runner = ast.D4rtRunner(
        declarationRegistry: ast.DeclarationRegistry(),
      );
      final first = await build();
      expect(
        runner.executeBundle(
          first,
          moduleFingerprints: {
            'lib/main.dart': 'main-1',
            'lib/registry.dart': 'registry-1',
          },
        ),
        isNull,
      );

      // Force the library containing the enum and the method signature to be
      // re-declared while the owning Registry instance survives in its cell.
      registryFile.writeAsStringSync('''
enum RegistrationType { constant }

class Registry {
  void register<T extends Object>(RegistrationType type) {
    final stillTheSameEnum = type == RegistrationType.constant;
    if (!stillTheSameEnum) throw StateError('wrong kind after reload');
  }
}

final registry = Registry();
''');
      final second = await build();
      expect(
        runner.executeBundle(
          second,
          moduleFingerprints: {
            'lib/main.dart': 'main-1',
            'lib/registry.dart': 'registry-2',
          },
        ),
        isNull,
      );
    } finally {
      project.deleteSync(recursive: true);
    }
  });
}

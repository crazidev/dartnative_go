import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/cli/packaging/safe_ast_converter.dart';
import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart';

void main() {
  test('AST runtime loads collection through equatable', () async {
    final exampleDir = Directory('example');
    if (!File('${exampleDir.path}/.dart_tool/package_config.json')
        .existsSync()) {
      markTestSkipped('Resolve example dependencies before running this test.');
    }

    final temp = Directory.systemTemp.createTempSync('collection_dependency_');
    try {
      File('${temp.path}/pubspec.yaml').writeAsStringSync('name: test_app\n');
      Directory('${temp.path}/lib').createSync();
      File('${temp.path}/lib/main.dart').writeAsStringSync('''
import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final String name;
  const Person(this.name);

  @override
  List<Object?> get props => [name];
}

int verifyEquality() {
  final first = Person('Ada');
  final same = Person('Ada');
  final different = Person('Grace');
  if (first != same) return 1;
  if (first == different) return 2;
  return 42;
}

void main() {}
''');

      final explicitSources = resolvePackageSources(
        exampleDir,
        packageName: 'example',
      );
      final bundler = IncrementalAstBundler(
        bridgedLibraries: kAstBridgedLibraries,
        explicitSources: explicitSources,
        packageName: 'test_app',
        projectRoot: temp.path,
        converter: SafeAstConverter(),
      );
      final bundle = await bundler.createFromFile('${temp.path}/lib/main.dart');

      expect(D4rtRunner().executeBundle(bundle, name: 'verifyEquality'), 42);
    } finally {
      temp.deleteSync(recursive: true);
    }
  });
}

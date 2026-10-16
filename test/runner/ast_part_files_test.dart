import 'dart:io';

import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

void main() {
  group('AST library parts', () {
    late Directory project;

    setUp(() {
      project = Directory.systemTemp.createTempSync('dn_ast_parts_');
      Directory('${project.path}/lib').createSync(recursive: true);
    });

    tearDown(() {
      if (project.existsSync()) project.deleteSync(recursive: true);
    });

    test(
      'entrypoint declarations share a private namespace with parts',
      () async {
        File('${project.path}/lib/main.dart').writeAsStringSync('''
part 'main.g.dart';

abstract class AppValue {
  static final AppValue instance = _GeneratedValue();
  int get value;
}

int main() => AppValue.instance.value;
''');
        File('${project.path}/lib/main.g.dart').writeAsStringSync('''
part of 'main.dart';

class _GeneratedValue implements AppValue {
  @override
  int get value => _generatedValue;
}

const int _generatedValue = 42;
''');

        final bundle = await AstBundler(projectRoot: project.path)
            .createFromFile(
              '${project.path}/lib/main.dart',
            );
        expect(bundle.modules.keys, contains('lib/main.g.dart'));

        final runner = ast.D4rtRunner();
        expect(runner.executeBundleAs<int>(bundle, name: 'main'), 42);
      },
    );

    test(
      'imported library declarations share a private namespace with parts',
      () async {
        File('${project.path}/lib/main.dart').writeAsStringSync('''
import 'service.dart';

int main() => serviceValue();
''');
        File('${project.path}/lib/service.dart').writeAsStringSync('''
part 'service.g.dart';

abstract class Service {
  static final Service instance = _ServiceImplementation();
  int get value;
}

int serviceValue() => Service.instance.value;
''');
        File('${project.path}/lib/service.g.dart').writeAsStringSync('''
part of 'service.dart';

class _ServiceImplementation implements Service {
  @override
  int get value => _serviceValue;
}

const int _serviceValue = 42;
''');

        final bundle = await AstBundler(projectRoot: project.path)
            .createFromFile(
              '${project.path}/lib/main.dart',
            );
        expect(bundle.modules.keys, contains('lib/service.g.dart'));

        final runner = ast.D4rtRunner(
          declarationRegistry: ast.DeclarationRegistry(),
        );
        expect(runner.executeBundleAs<int>(bundle, name: 'main'), 42);

        // The parent library is unchanged; only its part fingerprint changes.
        // The owning library must be invalidated so the new part declaration
        // is visible to the next execution generation.
        File('${project.path}/lib/service.g.dart').writeAsStringSync('''
part of 'service.dart';

class _ServiceImplementation implements Service {
  @override
  int get value => _serviceValue;
}

const int _serviceValue = 7;
''');
        final editedBundle = await AstBundler(
          projectRoot: project.path,
        ).createFromFile('${project.path}/lib/main.dart');
        final fingerprints = {
          for (final uri in editedBundle.modules.keys)
            uri: uri == 'lib/service.g.dart' ? 'part-v2' : 'unchanged',
        };
        expect(
          runner.executeBundle(
            editedBundle,
            name: 'main',
            moduleFingerprints: fingerprints,
          ),
          7,
        );
      },
    );
  });
}

import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

void main() {
  test(
    'generic invocation dispatches to an interpreted object call method',
    () async {
      const source = '''
class Resolver {
  T call<T extends Object>(T value) => value;
}

String main() {
  final resolver = Resolver();
  return resolver<String>('resolved');
}
''';
      final bundle = await AstBundler().createFromSource(
        source,
        sourcePath: 'callable_instance_test.dart',
      );

      expect(
        ast.D4rtRunner().executeBundleAs<String>(bundle, name: 'main'),
        'resolved',
      );
    },
  );
}

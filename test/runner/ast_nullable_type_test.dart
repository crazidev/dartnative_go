import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

void main() {
  test('null matches a nullable applied user type argument', () async {
    const source = '''
class Registration<T extends Object, P1, P2> {}

bool isNullableRegistration<T extends Object>(Object? value) =>
    value is Registration<T, dynamic, dynamic>?;

bool isNonNullableRegistration<T extends Object>(Object? value) =>
    value is Registration<T, dynamic, dynamic>;

bool main() =>
    isNullableRegistration<int>(null) &&
    !isNonNullableRegistration<int>(null);
''';
    final bundle = await AstBundler().createFromSource(
      source,
      sourcePath: 'nullable_type_test.dart',
    );

    expect(
      ast.D4rtRunner().executeBundleAs<bool>(bundle, name: 'main'),
      isTrue,
    );
  });
}

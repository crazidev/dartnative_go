import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;
import 'package:tom_ast_generator/tom_ast_generator.dart';

/// A top-level class alias (`typedef Alias = Target;`) has no runtime
/// representation, but a bare reference to it — above all a constructor call
/// `Alias(...)` — must resolve to `Target`.
///
/// dio's `MultipartFile` depends on this: `DioMediaType` is a top-level alias
/// for `http_parser`'s `MediaType`, and its constructors call
/// `DioMediaType('application', 'octet-stream')` from their initializer lists.
/// An initializer expression is evaluated outside any statement, so nothing but
/// the declaration pass can plant the binding.
void main() {
  test(
    'a class typedef is callable from a constructor initializer list',
    () async {
      const source = '''
typedef Alias = Target;

class Target {
  final String tag;
  Target(this.tag);
}

class Holder {
  final Alias? value;

  Holder({Alias? value}) : value = value ?? Alias('default');

  // Mirrors dio's `contentType ?? lookup() ?? DioMediaType(...)`: the alias sits
  // at the end of a `??` chain, so it is only reached when the earlier terms are
  // null.
  Holder.chained({Alias? value}) : value = value ?? Alias('chained');
}

String main() {
  final a = Holder().value!.tag;
  final b = Holder(value: Alias('explicit')).value!.tag;
  final c = Holder.chained().value!.tag;
  return '\$a|\$b|\$c';
}
''';
      final bundle = await AstBundler().createFromSource(
        source,
        sourcePath: 'class_typedef_alias_test.dart',
      );

      expect(
        ast.D4rtRunner().executeBundleAs<String>(bundle, name: 'main'),
        'default|explicit|chained',
      );
    },
  );

  test(
    'a class typedef is callable in an ordinary expression position',
    () async {
      const source = '''
typedef Handle = Widget;

class Widget {
  final int id;
  Widget(this.id);
}

String main() {
  final w = Handle(7);
  return '\${w.id}';
}
''';
      final bundle = await AstBundler().createFromSource(
        source,
        sourcePath: 'class_typedef_expression_test.dart',
      );

      expect(
        ast.D4rtRunner().executeBundleAs<String>(bundle, name: 'main'),
        '7',
      );
    },
  );

  test('a generic typedef alias does not shadow the target class', () async {
    // Only the plain rename form is bound; `typedef Box<T> = Holder<T>;` needs
    // per-use instantiation and must keep working through the ordinary type
    // paths (here: the alias is simply unused).
    const source = '''
typedef Box<T> = Holder<T>;

class Holder<T> {
  final T value;
  Holder(this.value);
}

String main() {
  final h = Holder<int>(3);
  return '\${h.value}';
}
''';
    final bundle = await AstBundler().createFromSource(
      source,
      sourcePath: 'class_typedef_generic_test.dart',
    );

    expect(
      ast.D4rtRunner().executeBundleAs<String>(bundle, name: 'main'),
      '3',
    );
  });
}

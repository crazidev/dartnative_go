/// Regression test for the vendored `tom_d4rt_ast` patch: an empty `{}` in a
/// Set context must evaluate to a Set.
///
/// The analyzer resolves `final Set<String> s = {};` with `isSet: true` on
/// the [SSetOrMapLiteral], but the interpreter used to ignore those flags
/// and default every empty literal to Map. Every Set member access then
/// failed at runtime with "Bridged class 'Map' has no instance method named
/// 'contains'" (seen in the gallery demo's `_selected` field).
///
/// Runs on the plain host VM: the visitor + model are pure Dart.
library;

import 'package:test/test.dart';
import 'package:tom_ast_model/tom_ast_model.dart';
import 'package:tom_d4rt_ast/runtime.dart';

InterpreterVisitor _visitor() {
  final env = Environment();
  final ctx = NoOpModuleContext(globalEnvironment: env);
  return InterpreterVisitor(globalEnvironment: env, moduleContext: ctx);
}

void main() {
  group('SSetOrMapLiteral empty-literal kind', () {
    test('isSet literal evaluates to a Set', () {
      final result = _visitor().visitSetOrMapLiteral(
        SSetOrMapLiteral(offset: 0, length: 0, isSet: true),
      );
      expect(result, isA<Set>());
    });

    test('isMap literal evaluates to a Map', () {
      final result = _visitor().visitSetOrMapLiteral(
        SSetOrMapLiteral(offset: 0, length: 0, isMap: true),
      );
      expect(result, isA<Map>());
    });

    test('ambiguous literal keeps the Map default', () {
      final result = _visitor().visitSetOrMapLiteral(
        SSetOrMapLiteral(offset: 0, length: 0),
      );
      expect(result, isA<Map>());
    });

    test('evaluated set supports add/contains', () {
      final set = _visitor().visitSetOrMapLiteral(
        SSetOrMapLiteral(offset: 0, length: 0, isSet: true),
      ) as Set;
      set.add('x');
      expect(set.contains('x'), isTrue);
    });
  });
}

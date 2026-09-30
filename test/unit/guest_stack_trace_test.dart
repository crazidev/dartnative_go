import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_ast_model/tom_ast_model.dart';
import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';

void main() {
  group('Guest Stack Trace', () {
    test('captures interpreted stack frames with project line and column numbers', () async {
      const source = '''class Calculator {
  void compute() {
    triggerError();
  }

  void triggerError() {
    var x = undefinedVariable;
  }
}

void main() {
  final calc = Calculator();
  calc.compute();
}''';

      final parseResult = parseString(content: source);
      final converter = AstConverter();
      final unit = converter.convertCompilationUnit(parseResult.unit) as SCompilationUnit;
      final moduleUri = 'package:sample/main.dart';
      final bundle = AstBundle(
        entryPointUri: moduleUri,
        modules: {moduleUri: unit},
        sources: {moduleUri: source},
      );

      final runner = D4rtRunner();
      String? caughtGuestStack;
      try {
        await runner.executeBundle(bundle);
      } on D4rtException catch (e) {
        caughtGuestStack = e.guestStackTrace;
      }

      expect(caughtGuestStack, isNotNull);
      expect(caughtGuestStack, contains('#0      Calculator.triggerError (package:sample/main.dart:6:23)'));
      expect(caughtGuestStack, contains('#1      Calculator.compute (package:sample/main.dart:2:18)'));
      expect(caughtGuestStack, contains('#2      main (package:sample/main.dart:11:13)'));
    });
  });
}

import 'package:tom_d4rt/tom_d4rt.dart';
import 'package:dartnative_go/src/interpreter/auto_import_parser.dart';

void transferStateFields(
  InterpretedInstance oldState,
  InterpretedInstance newState,
  InterpreterVisitor currentVisitor,
) {
  try {
    final fieldNames = oldState.klass.getInstanceFieldNames();
    for (final fieldName in fieldNames) {
      if (fieldName == 'widget' || fieldName == 'context') continue;
      Object? val;
      bool hasVal = false;
      try {
        val = oldState.getField(fieldName);
        hasVal = true;
      } catch (_) {
        try {
          val = oldState.get(fieldName, visitor: currentVisitor);
          hasVal = true;
        } catch (_) {}
      }
      if (hasVal) {
        try {
          newState.set(fieldName, val);
        } catch (_) {}
      }
    }
  } catch (_) {}
}

void main() {
  print('Testing Hot Reload State Preservation & Field Transfer...');

  // Gen 1: Counter class with _count = 0 and increment()
  final sourcesV1 = {
    'main.dart': '''
class CounterState {
  int _count = 0;
  String label = 'V1';

  void increment() {
    _count++;
  }

  int get count => _count;
}

CounterState createState() => CounterState();
''',
  };

  var interpreter = D4rt();
  final virtualV1 = AutoImportParser.buildVirtualSourceMap(sourcesV1);

  final state1 = interpreter.execute(
    source: virtualV1['main.dart']!,
    name: 'createState',
    library: 'package:guest_app/main.dart',
    sources: virtualV1,
  ) as InterpretedInstance;

  assert(state1.getField('_count') == 0, 'Initial count must be 0');

  // Simulate user incrementing state up to 10
  final incMethod1 = state1.klass.findInstanceMethod('increment')!;
  final callable1 = state1.bindMethodCached(incMethod1);
  for (var i = 0; i < 10; i++) {
    callable1.call(interpreter.visitor!, [], {});
  }
  assert(state1.getField('_count') == 10, 'Count should be 10');
  print('✓ Gen 1 count before reload: ${state1.getField('_count')}');

  // Gen 2: User edits code to change label to 'V2' and add a step property
  final sourcesV2 = {
    'main.dart': '''
class CounterState {
  int _count = 0;
  String label = 'V2';
  int step = 5;

  void increment() {
    _count += step;
  }

  int get count => _count;
}

CounterState createState() => CounterState();
''',
  };

  interpreter.dispose();
  interpreter = D4rt();

  final virtualV2 = AutoImportParser.buildVirtualSourceMap(sourcesV2);
  final state2 = interpreter.execute(
    source: virtualV2['main.dart']!,
    name: 'createState',
    library: 'package:guest_app/main.dart',
    sources: virtualV2,
  ) as InterpretedInstance;

  // Before transfer, state2 has default count 0
  assert(state2.getField('_count') == 0, 'Fresh state2 should have default 0');
  assert(state2.get('label') == 'V2', 'Fresh state2 has new label V2');
  assert(state2.get('step') == 5, 'Fresh state2 has step 5');

  // Perform Hot Reload State Transfer
  transferStateFields(state1, state2, interpreter.visitor!);

  // VERIFY: _count is preserved at 10!
  assert(state2.getField('_count') == 10, 'Count must be preserved as 10 after reload!');
  print('✓ Gen 2 count preserved at: ${state2.getField('_count')}');

  // VERIFY: new fields (step = 5) and new methods are active on the preserved state!
  final incMethod2 = state2.klass.findInstanceMethod('increment')!;
  final callable2 = state2.bindMethodCached(incMethod2);
  callable2.call(interpreter.visitor!, [], {});
  assert(state2.getField('_count') == 15, 'Count should increment by new step (5) to 15');
  print('✓ Gen 2 incremented with new logic to: ${state2.getField('_count')}');

  print('\n🎉 Hot Reload State Preservation test passed successfully!');
}

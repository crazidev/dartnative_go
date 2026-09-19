import 'package:dartnative_go/src/interpreter/widget_generation_tracker.dart';

void main() {
  print('Testing Granular Generational Remounting...');

  final projectSources = {
    'main.dart': '''
import 'package:dartnative/dartnative.dart';
import 'my_buttons.dart';
import 'reset_button.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});
  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _count = 0;
  @override
  Widget build(BuildContext context) => Container();
}
''',
    'reset_button.dart': '''
import 'package:dartnative/dartnative.dart';

class ResetButton extends StatefulWidget {
  const ResetButton({super.key});
  @override
  State<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
  @override
  Widget build(BuildContext context) => Container();
}
''',
    'my_buttons.dart': '''
import 'package:dartnative/dartnative.dart';

class MyButtons extends StatelessWidget {
  const MyButtons({super.key});
  @override
  Widget build(BuildContext context) => Container();
}
''',
  };

  WidgetGenerationTracker.resetAll();
  WidgetGenerationTracker.registerSources(projectSources);

  // Initial state: all generations are 0
  assert(WidgetGenerationTracker.getGeneration('CounterApp') == 0);
  assert(WidgetGenerationTracker.getGeneration('ResetButton') == 0);
  assert(WidgetGenerationTracker.getGeneration('MyButtons') == 0);
  print('✓ Initial generation for all widgets is 0');

  // Case 1: Editing ONLY reset_button.dart
  final bumped1 = WidgetGenerationTracker.notifyFilesChanged({'reset_button.dart'});
  print('✓ Bumped classes when editing reset_button.dart: $bumped1');
  assert(bumped1.contains('ResetButton'), 'ResetButton must be bumped');
  assert(bumped1.contains('_ResetButtonState'), '_ResetButtonState must be bumped');
  assert(!bumped1.contains('CounterApp'), 'CounterApp must NOT be bumped');
  assert(!bumped1.contains('MyButtons'), 'MyButtons must NOT be bumped');

  assert(WidgetGenerationTracker.getGeneration('ResetButton') == 1, 'ResetButton gen should be 1');
  assert(WidgetGenerationTracker.getGeneration('CounterApp') == 0, 'CounterApp gen should remain 0');
  assert(WidgetGenerationTracker.getGeneration('MyButtons') == 0, 'MyButtons gen should remain 0');
  print('✓ ONLY ResetButton generation bumped to 1. CounterApp and MyButtons remain 0.');

  // Case 2: Editing ONLY my_buttons.dart
  final bumped2 = WidgetGenerationTracker.notifyFilesChanged({'my_buttons.dart'});
  print('✓ Bumped classes when editing my_buttons.dart: $bumped2');
  assert(bumped2.contains('MyButtons'), 'MyButtons must be bumped');
  assert(!bumped2.contains('CounterApp'), 'CounterApp must NOT be bumped');
  assert(!bumped2.contains('ResetButton'), 'ResetButton must NOT be bumped');

  assert(WidgetGenerationTracker.getGeneration('MyButtons') == 1, 'MyButtons gen should be 1');
  assert(WidgetGenerationTracker.getGeneration('ResetButton') == 1, 'ResetButton gen should remain 1');
  assert(WidgetGenerationTracker.getGeneration('CounterApp') == 0, 'CounterApp gen should remain 0');
  print('✓ ONLY MyButtons generation bumped to 1. CounterApp remains 0.');

  // Case 3: Editing main.dart
  final bumped3 = WidgetGenerationTracker.notifyFilesChanged({'main.dart'});
  print('✓ Bumped classes when editing main.dart: $bumped3');
  assert(bumped3.contains('CounterApp'), 'CounterApp must be bumped');
  assert(!bumped3.contains('ResetButton'), 'ResetButton must NOT be bumped');
  assert(!bumped3.contains('MyButtons'), 'MyButtons must NOT be bumped');

  assert(WidgetGenerationTracker.getGeneration('CounterApp') == 1, 'CounterApp gen should now be 1');
  assert(WidgetGenerationTracker.getGeneration('ResetButton') == 1, 'ResetButton gen remains 1');
  assert(WidgetGenerationTracker.getGeneration('MyButtons') == 1, 'MyButtons gen remains 1');
  print('✓ Granular remounting targeting confirmed!');

  print('\n🎉 Granular Generational Remounting tests passed successfully!');
}

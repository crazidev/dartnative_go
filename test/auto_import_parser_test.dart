import 'package:dartnative_go/src/interpreter/auto_import_parser.dart';

void main() {
  print('Running AutoImportParser tests...');

  // Test 1: Injects dartnative import when framework symbols are used
  final rawGuestCode = '''
class MyCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello DartNative'),
    );
  }
}
''';
  final processed = AutoImportParser.processAndAutoImport(rawGuestCode);
  assert(
    processed.contains("import 'package:dartnative/dartnative.dart';"),
    'Should auto-inject dartnative import',
  );
  print('✓ Test 1 passed: Injects package:dartnative/dartnative.dart');

  // Test 2: Injects dart:math when math functions are used
  final mathCode = '''
void calculate() {
  final val = min(10, 20);
  final r = Random().nextInt(100);
}
''';
  final processedMath = AutoImportParser.processAndAutoImport(mathCode);
  assert(
    processedMath.contains("import 'dart:math';"),
    'Should auto-inject dart:math',
  );
  print('✓ Test 2 passed: Injects dart:math');

  // Test 3: Relative path calculation
  final relPath = AutoImportParser.computeRelativePath(
    'components/buttons/reset_button.dart',
    'screens/home.dart',
  );
  assert(relPath == '../../screens/home.dart', 'Relative path should match: $relPath');
  print('✓ Test 3 passed: Relative path calculation');

  // Test 4: Project-wide symbol auto-import
  final projectFiles = {
    'main.dart': '''
Widget main() {
  return ResetButton(reset: () {});
}
''',
    'reset_button.dart': '''
class ResetButton extends StatefulWidget {
  final void Function() reset;
  const ResetButton({required this.reset});
}
''',
  };

  final virtualMap = AutoImportParser.buildVirtualSourceMap(projectFiles);
  final processedMain = virtualMap['main.dart']!;

  assert(
    processedMain.contains("import 'reset_button.dart';"),
    'Should auto-inject cross-file dependency: $processedMain',
  );
  assert(
    virtualMap.containsKey('package:guest_app/reset_button.dart'),
    'Should register package:guest_app alias',
  );
  assert(
    virtualMap.containsKey('package:dartnative_ios/dartnative_ios.dart'),
    'Should register package:dartnative_ios stub',
  );
  assert(
    virtualMap.containsKey('package:dartnative_android/dartnative_android.dart'),
    'Should register package:dartnative_android stub',
  );
  print('✓ Test 4 passed: Multi-file project auto-import & virtual source map');

  // Test 5: Extracted widget with package import (e.g. package:example/home_screen.dart)
  final extractedFiles = {
    'main.dart': '''
import 'package:example/home_screen.dart';

void main() {
  runApp(const HomeScreen());
}
''',
    'home_screen.dart': '''
import 'package:dartnative/dartnative.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Text('Home');
}
''',
  };

  final exampleMap = AutoImportParser.buildVirtualSourceMap(
    extractedFiles,
    packageName: 'example',
  );

  assert(
    exampleMap.containsKey('package:example/home_screen.dart'),
    'Should register package:example/home_screen.dart alias',
  );
  assert(
    exampleMap.containsKey('package:example/main.dart'),
    'Should register package:example/main.dart alias',
  );
  assert(
    exampleMap.containsKey('package:guest_app/home_screen.dart'),
    'Should retain fallback package:guest_app/home_screen.dart alias',
  );
  print('✓ Test 5 passed: Extracted widget package:example/home_screen.dart import alias');

  print('\n🎉 All AutoImportParser tests passed successfully!');
}

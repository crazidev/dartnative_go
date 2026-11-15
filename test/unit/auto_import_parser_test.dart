import 'package:dartnative_go/src/interpreter/auto_import_parser.dart';
import 'package:test/test.dart';

void main() {
  group('AutoImportParser', () {
    test('injects dartnative import when framework symbols are used', () {
      const rawGuestCode = '''
class MyCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello DartNative'),
    );
  }
}
''';
      expect(
        AutoImportParser.processAndAutoImport(rawGuestCode),
        contains("import 'package:dartnative/dartnative.dart';"),
      );
    });

    test('injects dart:math when math symbols are used', () {
      const mathCode = '''
void calculate() {
  final val = min(10, 20);
  final r = Random().nextInt(100);
}
''';
      expect(
        AutoImportParser.processAndAutoImport(mathCode),
        contains("import 'dart:math';"),
      );
    });

    test('computes relative paths between project files', () {
      expect(
        AutoImportParser.computeRelativePath(
          'components/buttons/reset_button.dart',
          'screens/home.dart',
        ),
        equals('../../screens/home.dart'),
      );
    });

    test('builds multi-file virtual source map with aliases + stubs', () {
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
      expect(
        virtualMap['main.dart'],
        contains("import 'reset_button.dart';"),
      );
      expect(
        virtualMap,
        contains('package:guest_app/reset_button.dart'),
      );
      expect(
        virtualMap,
        contains('package:dartnative_ios/dartnative_ios.dart'),
      );
      expect(
        virtualMap,
        contains('package:dartnative_android/dartnative_android.dart'),
      );
    });

    test('registers extracted-widget package aliases', () {
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
      expect(exampleMap, contains('package:example/home_screen.dart'));
      expect(exampleMap, contains('package:example/main.dart'));
      expect(exampleMap, contains('package:guest_app/home_screen.dart'));
    });

    test('injects imports after the library directive', () {
      const codeWithLibrary = '''
/// Some documentation
library my_custom_lib;

class MyCustomWidget extends StatelessWidget {
  Widget build(BuildContext context) => Container();
}
''';
      final processed = AutoImportParser.processAndAutoImport(codeWithLibrary);
      expect(
        processed.indexOf('library my_custom_lib;'),
        lessThan(
          processed.indexOf("import 'package:dartnative/dartnative.dart';"),
        ),
      );
    });

    test('words in comments/strings do not trigger auto-imports', () {
      const codeWithCommentsOnly = '''
/// Table and column names for the local SQLite database.
library;

/// ── Note ──
const String noteTableName = 'Note';
''';
      final processed = AutoImportParser.processAndAutoImport(
        codeWithCommentsOnly,
        currentFilePath: 'tables.dart',
        projectFiles: {'notes_state.dart': 'class Note {}'},
      );
      expect(processed, isNot(contains('notes_state.dart')));
    });
  });
}

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

const _guestSource = r'''
import 'package:dartnative/dartnative.dart';

void main() {
  final callbacks = <void Function()>[];
  for (final label in ['statement-first', 'statement-second']) {
    callbacks.add(() => print('statement:$label'));
  }
  for (final callback in callbacks) {
    callback();
  }
  runApp(
    Column(
      children: [
        for (final label in ['first', 'second', 'third'])
          Button(
            child: Text(label),
            onPressed: () => print('tapped:$label'),
          ),
      ],
    ),
  );
}
''';

void main() {
  group('AST for-in closure bindings', () {
    late Directory tempDir;
    late Directory guestDir;
    late AstInterpreterRunner runner;
    late List<String> logs;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('dn_for_in_closure_');
      guestDir = Directory('${tempDir.path}/guest')
        ..createSync(recursive: true);
      File(
        '${guestDir.path}/pubspec.yaml',
      ).writeAsStringSync('name: for_in_closure_guest\n');
      Directory('${guestDir.path}/lib').createSync();
      File('${guestDir.path}/lib/main.dart').writeAsStringSync(_guestSource);
      logs = <String>[];
      runner = AstInterpreterRunner(onLog: logs.add);
    });

    tearDown(() {
      runner.dispose();
      tempDir.deleteSync(recursive: true);
    });

    test('declared for-in closures retain their own iteration value', () async {
      final bundleFile = File('${guestDir.path}/app.ast');
      final result = await buildGuestAstBundle(
        guestDir,
        outputArg: bundleFile.path,
        force: true,
      );
      expect(result.success, isTrue, reason: result.error);

      final root = await runner.evaluateAstBundleAs<Widget>(
        await bundleFile.readAsBytes(),
      );

      final buttons = (root as Column).children.cast<Button>();
      for (final button in buttons) {
        button.onPressed!();
      }

      expect(
        logs.where((message) => message.startsWith('tapped:')).toList(),
        ['tapped:first', 'tapped:second', 'tapped:third'],
      );
      expect(
        logs.where((message) => message.startsWith('statement:')).toList(),
        ['statement:statement-first', 'statement:statement-second'],
      );
    });
  });
}

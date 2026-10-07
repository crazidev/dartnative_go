import 'dart:io';

import 'package:dartnative/dartnative.dart' show Text, Widget;
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/cli/safe_ast_converter.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/widgets/server_component_view.dart';
import 'package:test/test.dart';

/// Proves the `package:dartnative_go/server_component.dart` bridge:
/// interpreted guest code constructs the host [ServerComponentView]
/// (no codegen), and the constructed view is wired to the same runner
/// that evaluated it.
void main() {
  group('ServerComponentView bridge', () {
    late Directory tmp;
    late AstInterpreterRunner runner;

    setUpAll(() async {
      tmp = Directory.systemTemp.createTempSync('dn_server_bridge_');
      final lib = Directory('${tmp.path}/lib')..createSync();
      File('${tmp.path}/pubspec.yaml')
          .writeAsStringSync('name: bridge_app\n');
      File('${lib.path}/main.dart').writeAsStringSync(
        "import 'package:dartnative/dartnative.dart';\n"
        "import 'package:dartnative_go/server_component.dart';\n"
        'void main() {\n'
        '  runApp(ServerComponentView(\n'
        "    componentId: 'profile_card',\n"
        "    props: {'userId': 7},\n"
        '  ));\n'
        '}\n',
      );
      File('${lib.path}/main_getter.dart').writeAsStringSync(
        "import 'package:dartnative/dartnative.dart';\n"
        "import 'package:dartnative_go/server_component.dart';\n"
        'void main() {\n'
        '  final view = ServerComponentView(componentId: \'badge_x\');\n'
        '  runApp(Text(view.componentId));\n'
        '}\n',
      );
      runner = AstInterpreterRunner();
    });

    tearDownAll(() {
      runner.dispose();
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('guest import is skipped by the bundler (bridged)', () async {
      final bundler = IncrementalAstBundler(
        bridgedLibraries: kAstBridgedLibraries,
        packageName: 'bridge_app',
        projectRoot: tmp.path,
        converter: SafeAstConverter(),
      );
      final bundle =
          await bundler.createFromFile('${tmp.path}/lib/main.dart');
      expect(
        bundle.modules.keys,
        isNot(contains('package:dartnative_go/server_component.dart')),
        reason: 'the host view must never be bundled into guest code',
      );
    });

    test('guest constructs the host view with props', () async {
      final bundler = IncrementalAstBundler(
        bridgedLibraries: kAstBridgedLibraries,
        packageName: 'bridge_app',
        projectRoot: tmp.path,
        converter: SafeAstConverter(),
      );
      final bundle =
          await bundler.createFromFile('${tmp.path}/lib/main.dart');
      final widget = await runner.evaluateAstBundleAs<Widget>(
        bundle.toBytes(),
      );
      expect(widget, isA<ServerComponentView>());
      final view = widget as ServerComponentView;
      expect(view.componentId, equals('profile_card'));
      expect(view.props, equals({'userId': 7}));
      // Wired to the evaluating interpreter: loads resolve against it.
      expect(identical(view.runner, runner), isTrue);
      expect(view.loadComponent, isNotNull);
    });

    test('guest reads back the bridged componentId getter', () async {
      // Exercises the getters map from interpreted code: the guest reads
      // a property off the native view and renders it.
      final bundler = IncrementalAstBundler(
        bridgedLibraries: kAstBridgedLibraries,
        packageName: 'bridge_app',
        projectRoot: tmp.path,
        converter: SafeAstConverter(),
      );
      final bundle =
          await bundler.createFromFile('${tmp.path}/lib/main_getter.dart');
      final widget = await runner.evaluateAstBundleAs<Widget>(
        bundle.toBytes(),
      );
      expect(widget, isA<Text>());
      expect((widget as Text).data, equals('badge_x'));
    });
  });
}

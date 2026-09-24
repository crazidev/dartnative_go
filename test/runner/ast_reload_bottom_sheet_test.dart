/// Hot reload of a native bottom sheet's interpreted content.
///
/// A sheet's guest content is built once, by the bridge, and then lives in the
/// sheet's own DNTree. On reload the host rebinds the sheet's proxies to the new
/// generation: the visitor must advance, state fields must survive, and the next
/// build must run the edited code.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/ast/ast_widget_proxies.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/runner/native_bottomsheet_manager.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';
import 'package:test/test.dart';

String _main(String tag) => '''
import 'package:dartnative/dartnative.dart';
import 'panel.dart';

void main() {
  runApp(CreateNotePanel(label: '$tag'));
}
''';

String _statefulPanel(String label) => '''
import 'package:dartnative/dartnative.dart';

class CreateNotePanel extends StatefulWidget {
  final String label;

  const CreateNotePanel({required this.label});

  @override
  State<CreateNotePanel> createState() => _CreateNotePanelState();
}

class _CreateNotePanelState extends State<CreateNotePanel> {
  int taps = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$label'),
        Text('taps=\$taps'),
      ],
    );
  }
}
''';

String _statelessPanel(String label) => '''
import 'package:dartnative/dartnative.dart';

class CreateNotePanel extends StatelessWidget {
  final String label;

  const CreateNotePanel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('$label')]);
  }
}
''';

List<String> _labels(Widget w) {
  if (w is Text) return [w.data];
  if (w is Column) {
    return [
      for (final child in w.children) ..._labels(child),
    ];
  }
  throw StateError('unexpected widget ${w.runtimeType}');
}

void main() {
  group('AST native bottom sheet hot reload', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;
    late AstInterpreterRunner runner;
    late String Function(String) panelSource;

    setUp(() {
      logs = <String>[];
      tmp = Directory.systemTemp.createTempSync('dn_sheet_reload_');
      projectDir = Directory('${tmp.path}/sheet_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: sheet_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      runner = AstInterpreterRunner(onLog: logs.add);
      panelSource = _statefulPanel;
    });

    tearDown(() {
      runner.dispose();
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    Future<({List<int> bytes, Map<String, String> fingerprints})> build(
      String tag,
    ) async {
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(_main(tag));
      File('${projectDir.path}/lib/panel.dart')
          .writeAsStringSync(panelSource(tag));
      final out = File('${projectDir.path}/$tag.ast');
      final result = await buildGuestAstBundle(
        projectDir,
        outputArg: out.path,
        force: true,
      );
      expect(result.success, isTrue, reason: result.error);
      return (
        bytes: await out.readAsBytes(),
        fingerprints: result.moduleFingerprints,
      );
    }

    NativeBottomSheetScopeState openSheet(Widget content) {
      final controller = DNSheetController.create(
        sheetId: 4242,
        detents: const [DNSheetDetent.large],
        initialDetent: DNSheetDetent.large,
      );
      final scope = NativeBottomSheetScope(
        controller: controller,
        child: content,
      );
      final state = scope.createState() as NativeBottomSheetScopeState;
      state.initState();
      addTearDown(state.dispose);
      return state;
    }

    test('an edited sheet panel rebuilds with new code and keeps its state',
        () async {
      final v1 = await build('v1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      final visitorV1 = runner.visitor;
      expect(rootV1, isA<InterpretedStatefulWidget>());

      final scopeState = openSheet(rootV1);
      final stateProxy = (rootV1 as InterpretedStatefulWidget).createState()
          as InterpretedStateProxy;
      scopeState.registerProxy(stateProxy);

      expect(
        _labels(stateProxy.build(_FakeContext())),
        ['v1', 'taps=0'],
        reason: 'precondition: the sheet renders generation 1',
      );
      stateProxy.stateInstance.set('taps', 3);

      final v2 = await build('v2');
      await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      expect(identical(visitorV1, runner.visitor), isFalse);

      NativeBottomSheetManager.notifyHotReload(
        runner.visitor,
        changedFile: 'panel.dart',
      );

      expect(
        identical(stateProxy.visitor, runner.visitor),
        isTrue,
        reason: 'the sheet proxy must run on the new generation',
      );
      expect(
        _labels(stateProxy.build(_FakeContext())),
        ['v2', 'taps=3'],
        reason: 'edited panel code must render while state fields survive',
      );
    });

    test('a stateless sheet panel is rebound to the new code', () async {
      panelSource = _statelessPanel;

      final v1 = await build('v1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      expect(rootV1, isA<InterpretedStatelessWidget>());

      openSheet(rootV1);
      final panel = rootV1 as InterpretedStatelessWidget;
      expect(_labels(panel.build(_FakeContext())), ['v1']);

      final v2 = await build('v2');
      await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      NativeBottomSheetManager.notifyHotReload(
        runner.visitor,
        changedFile: 'panel.dart',
      );

      expect(identical(panel.visitor, runner.visitor), isTrue);
      expect(_labels(panel.build(_FakeContext())), ['v2']);
    });
  });
}

class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

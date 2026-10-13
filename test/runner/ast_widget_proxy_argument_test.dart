/// A native Flutter widget proxy handed to guest code as an argument of an
/// interpreted class type — `didUpdateWidget(covariant StickyNote oldWidget)` is
/// the canonical case. The declared parameter is an interpreted class while the
/// value's runtime type is the host's proxy class, so the argument check has to
/// consult the interpreted value the proxy stands for.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/ast/ast_widget_proxies.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart' show D4rtTypeError;

String _main(String label) => '''
import 'package:dartnative/dartnative.dart';
import 'sticky_note.dart';

void main() {
  runApp(makeNote());
}

StickyNote makeNote() => const StickyNote(label: 'v1');
''';

String _note(String label) => '''
import 'package:dartnative/dartnative.dart';

class StickyNote extends StatefulWidget {
  final String label;

  const StickyNote({required this.label});

  @override
  State<StickyNote> createState() => _StickyNoteState();
}

class _StickyNoteState extends State<StickyNote> {
  int taps = 0;

  @override
  void didUpdateWidget(covariant StickyNote oldWidget) {
    print('didUpdateWidget old=\${oldWidget.label} taps=\$taps');
  }

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

void main() {
  group('interpreted parameter typed as an interpreted class', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;
    late AstInterpreterRunner runner;

    setUp(() {
      logs = <String>[];
      tmp = Directory.systemTemp.createTempSync('dn_covariant_');
      projectDir = Directory('${tmp.path}/covariant_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: covariant_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      runner = AstInterpreterRunner(onLog: logs.add);
    });

    tearDown(() {
      runner.dispose();
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    Future<({List<int> bytes, Map<String, String> fingerprints})> build(
      String label,
    ) async {
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(_main(label));
      File('${projectDir.path}/lib/sticky_note.dart')
          .writeAsStringSync(_note(label));
      final out = File('${projectDir.path}/$label.ast');
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

    test('a widget proxy satisfies a covariant widget parameter', () async {
      final v1 = await build('v1');
      final root = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      final oldWidget = root as InterpretedStatefulWidget;
      final stateProxy = oldWidget.createState() as InterpretedStateProxy;
      stateProxy.stateInstance.set('taps', 2);

      // Exactly what the mounted framework path does at
      // `InterpretedStateProxy.didUpdateWidget`: the guest method is called
      // with the native widget object as the covariant argument.
      logs.clear();
      final state = stateProxy.stateInstance;
      final method = state.klass.findInstanceMethod('didUpdateWidget');
      expect(method, isNotNull);
      state
          .bindMethodCached(method!)
          .call(stateProxy.visitor, [oldWidget], {});

      expect(
        logs.where((l) => l.startsWith('didUpdateWidget')).toList(),
        ['didUpdateWidget old=v1 taps=2'],
        reason: 'the covariant parameter must accept the host proxy, and the '
            'body must be able to read interpreted fields off it',
      );

      expect(
        () => state.bindMethodCached(method).call(
          stateProxy.visitor,
          [const Scaffold(body: SizedBox.shrink())],
          {},
        ),
        throwsA(
          isA<D4rtTypeError>().having(
            (e) => e.message,
            'message',
            contains("is not a subtype of type 'StickyNote'"),
          ),
        ),
        reason: 'the argument check must stay in force for values that are not '
            'a StickyNote',
      );
    });
  });
}

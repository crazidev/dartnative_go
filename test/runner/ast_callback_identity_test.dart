/// Regression: binary `==` / `!=` must never invoke function values.
///
/// A zero-arg callback compared against null (the standard
/// `onTap == null` guard) used to be auto-invoked by the binary-expression
/// visitor, executing the callback as a side effect of a comparison — e.g.
/// a share button's handler firing on every build. Dart compares function
/// objects by identity and never invokes them.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

import '../test_lab/widget_probe.dart';

const _guestMain = r'''
import 'package:dartnative/dartnative.dart';

int eqCalls = 0;
int neqCalls = 0;
int asyncCalls = 0;
int argCalls = 0;

void fEq() {
  eqCalls++;
}

void fNeq() {
  neqCalls++;
}

Future<void> fAsync() async {
  asyncCalls++;
  await Future.delayed(const Duration(milliseconds: 50));
  asyncCalls += 100;
}

void fArg() {
  argCalls++;
}

String takeCb(void Function()? cb) => 'x';

Future<void> main() async {
  final isNull = fEq == null;
  final isNotNull = fNeq != null;
  final c = fArg;
  final sameIdent = c == c;
  takeCb(fEq);
  final b = fAsync;
  final asyncNull = b == null;
  await Future.delayed(const Duration(milliseconds: 200));
  runApp(
    Text(
      'eq=$eqCalls neq=$neqCalls async=$asyncCalls arg=$argCalls '
      'n1=$isNull nn=$isNotNull same=$sameIdent an=$asyncNull',
    ),
  );
}
''';

void main() {
  test(
    'equality never invokes callbacks, identity holds',
    () async {
      final tmp = Directory.systemTemp.createTempSync('cbid_guest_');
      try {
        Directory('${tmp.path}/lib').createSync();
        File('${tmp.path}/pubspec.yaml')
            .writeAsStringSync('name: cbid_guest\n');
        File('${tmp.path}/lib/main.dart').writeAsStringSync(_guestMain);
        final out = File('${tmp.path}/cbid.ast');
        final result = await buildGuestAstBundle(
          tmp,
          outputArg: out.path,
          force: true,
        );
        expect(result.success, isTrue, reason: result.error);

        final runner = AstInterpreterRunner(onLog: (_) {});
        addTearDown(runner.dispose);
        final root = await runner.evaluateAstBundleAs<Widget>(
          await out.readAsBytes(),
          moduleFingerprints: result.moduleFingerprints,
        );
        final texts = findTexts(root).map((t) => t.data).toList();
        expect(texts, hasLength(1));
        final report = texts.single ?? '';
        expect(report, contains('eq=0'), reason: '== must not invoke: $report');
        expect(report, contains('neq=0'), reason: '!= must not invoke: $report');
        expect(report, contains('async=0'),
            reason: 'async tear-off must not run: $report');
        expect(report, contains('arg=0'),
            reason: 'arg passing must not invoke: $report');
        expect(report, contains('n1=false'), reason: 'fn != null: $report');
        expect(report, contains('nn=true'), reason: 'fn != null: $report');
        expect(report, contains('same=true'),
            reason: 'same closure is identical: $report');
        expect(report, contains('an=false'), reason: 'async fn != null: $report');
      } finally {
        try {
          tmp.deleteSync(recursive: true);
        } catch (_) {}
      }
    },
    timeout: const Timeout(Duration(seconds: 120)),
  );
}

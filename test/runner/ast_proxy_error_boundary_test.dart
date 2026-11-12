/// A proxy whose guest build starts throwing renders its last good child
/// instead of failing the tree: the working UI stays up while the error goes
/// to the host error channel. The next reload with fixed code builds fresh.
///
/// Before a proxy has a good child, a throwing build renders a neutral
/// placeholder rather than rethrowing: the host is already showing its styled
/// error view, and rethrowing would make the framework paint its own red error
/// screen for the frame in between.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/ast/ast_widget_proxies.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/runner/native_bottomsheet_manager.dart'
    show findUserClassInVisitor;
import 'package:test/test.dart';

String _main({required bool explode}) =>
    '''
import 'package:dartnative/dartnative.dart';

class Panel extends StatelessWidget {
  const Panel({super.key});

  @override
  Widget build(BuildContext context) {
    ${explode ? "throw StateError('panel blew up');" : "return const Text('panel ok');"}
  }
}

void main() {
  runApp(const Panel());
}
''';

/// Same failure, but from a `State.build` — a surface the hot-reload tracker
/// can mark dirty, so it repaints itself once the code is fixed.
String _statefulMain({required bool explode}) =>
    '''
import 'package:dartnative/dartnative.dart';

class Panel extends StatefulWidget {
  const Panel({super.key});

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  @override
  Widget build(BuildContext context) {
    ${explode ? "throw StateError('state panel blew up');" : "return const Text('state ok');"}
  }
}

void main() {
  runApp(const Panel());
}
''';

/// A `late final` field that is never read before the failure. The reload
/// rebind must copy its *value*, not the `LateVariable` wrapper.
String _statefulLateMain({required bool explode}) =>
    '''
import 'package:dartnative/dartnative.dart';

class Panel extends StatefulWidget {
  const Panel({super.key});

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  late final String label = 'late ok';

  @override
  Widget build(BuildContext context) {
    ${explode ? "throw StateError('late panel blew up');" : "return Text(label);"}
  }
}

void main() {
  runApp(const Panel());
}
''';

void main() {
  group('AST proxy error boundary', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;
    late List<String> errors;
    late List<String> blankErrors;
    late int remountsNeeded;
    late int recoveries;
    late AstInterpreterRunner runner;

    setUp(() {
      logs = <String>[];
      errors = <String>[];
      blankErrors = <String>[];
      remountsNeeded = 0;
      recoveries = 0;
      tmp = Directory.systemTemp.createTempSync('dn_boundary_');
      projectDir = Directory('${tmp.path}/boundary_guest')
        ..createSync(recursive: true);
      File(
        '${projectDir.path}/pubspec.yaml',
      ).writeAsStringSync('name: boundary_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      runner = AstInterpreterRunner(
        onLog: logs.add,
        onGuestError: (error, stack) => errors.add('$error'),
        onGuestBlankBuild: (error, stack, {required rebuildsInPlace}) {
          blankErrors.add('$error');
          if (!rebuildsInPlace) remountsNeeded++;
        },
        onGuestRecovered: () => recoveries++,
      );
    });

    tearDown(() {
      runner.dispose();
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    Future<({List<int> bytes, Map<String, String> fingerprints})> build(
      bool explode,
      String tag, {
      String Function({required bool explode})? source,
    }) async {
      File(
        '${projectDir.path}/lib/main.dart',
      ).writeAsStringSync((source ?? _main)(explode: explode));
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

    test('a throwing build falls back to the last good child', () async {
      final v1 = await build(false, 'ok');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      final panel = rootV1 as InterpretedStatelessWidget;
      final first = panel.build(_FakeContext());
      expect((first as Text).data, 'panel ok');

      final v2 = await build(true, 'boom');
      await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );

      expect(
        panel.build(_FakeContext()),
        same(first),
        reason: 'the working UI stays up instead of failing the tree',
      );
      expect(
        errors.where((e) => e.contains('panel blew up')),
        isNotEmpty,
        reason: 'the failure is still reported to the host channel',
      );
      expect(
        blankErrors,
        isEmpty,
        reason:
            'a failure with a last good child still has a surface to show, '
            'so it must not take over the screen',
      );

      final v3 = await build(false, 'fixed');
      await runner.evaluateAstBundleAs<Widget>(
        v3.bytes,
        isHotReload: true,
        moduleFingerprints: v3.fingerprints,
      );
      expect(
        (panel.build(_FakeContext()) as Text).data,
        'panel ok',
        reason: 'fixed code builds fresh again',
      );
    });

    test('a first build that throws renders a neutral placeholder', () async {
      final v1 = await build(true, 'boom_initial');
      final root = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      final panel = root as InterpretedStatelessWidget;

      late Widget placeholder;
      expect(
        () => placeholder = panel.build(_FakeContext()),
        returnsNormally,
        reason:
            'rethrowing would make the framework paint its red error screen '
            'for a frame before the host error view replaces the tree',
      );
      expect(placeholder, isA<SizedBox>());
      final box = placeholder as SizedBox;
      expect(box.width, 0);
      expect(box.height, 0);
      expect(
        errors.where((e) => e.contains('panel blew up')),
        isNotEmpty,
        reason: 'the failure still reaches the host error channel',
      );
      expect(
        blankErrors.where((e) => e.contains('panel blew up')),
        isNotEmpty,
        reason:
            'a first build with no child left the surface blank; the host '
            'must show the full-screen error view, not a banner',
      );
      expect(
        remountsNeeded,
        1,
        reason:
            'a stateless proxy has no State to mark dirty, so the host must '
            'remount the tree to recover after the code is fixed',
      );

      // The broken tree keeps rebuilding: the same exception must not be
      // reported again on every frame.
      final reportsBefore = errors.length;
      final blanksBefore = blankErrors.length;
      panel.build(_FakeContext());
      panel.build(_FakeContext());
      expect(errors.length, reportsBefore, reason: 'no repeat reports');
      expect(
        blankErrors.length,
        blanksBefore,
        reason: 'no repeat blank reports',
      );
    });

    test('a state build with no child asks for an in-place rebuild', () async {
      final v1 = await build(
        true,
        'state_boom',
        source: _statefulMain,
      );
      final root = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      final widget = root as InterpretedStatefulWidget;
      final state = widget.createState() as InterpretedStateProxy;

      expect(state.build(_FakeContext()), isA<SizedBox>());
      expect(
        blankErrors.where((e) => e.contains('state panel blew up')),
        isNotEmpty,
        reason: 'a blank state build is still a hard exception',
      );
      expect(
        remountsNeeded,
        0,
        reason:
            'a State proxy is marked dirty on the next reload, so the fixed '
            'screen repaints in place and the user keeps their navigation',
      );
    });

    test('a proxy that builds again reports recovery to the host', () async {
      final v1 = await build(true, 'boom_recover');
      final root = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      final panel = root as InterpretedStatelessWidget;
      expect(panel.build(_FakeContext()), isA<SizedBox>());
      expect(recoveries, 0);

      final v2 = await build(false, 'fixed_recover');
      await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      panel.rebindForHotReload(
        runner.visitor,
        findUserClassInVisitor(runner.visitor, 'Panel'),
      );

      expect(panel.build(_FakeContext()), isA<Text>());
      expect(
        recoveries,
        1,
        reason:
            'the host only removes the error view once the surface is back; '
            'otherwise a later silent rebuild failure would expose a blank page',
      );
    });

    test('a reload copies late field values, not their wrappers', () async {
      final v1 = await build(true, 'late_boom', source: _statefulLateMain);
      final root = await runner.evaluateAstBundleAs<Widget>(
        v1.bytes,
        moduleFingerprints: v1.fingerprints,
      );
      final widget = root as InterpretedStatefulWidget;
      final state = widget.createState() as InterpretedStateProxy;
      expect(state.build(_FakeContext()), isA<SizedBox>());

      final v2 = await build(false, 'late_fixed', source: _statefulLateMain);
      await runner.evaluateAstBundleAs<Widget>(
        v2.bytes,
        isHotReload: true,
        moduleFingerprints: v2.fingerprints,
      );
      state.rebindForHotReload(
        runner.visitor,
        findUserClassInVisitor(runner.visitor, '_PanelState'),
      );

      expect(
        state.stateInstance.getField('label'),
        isA<String>(),
        reason:
            'copying the raw LateVariable made a bridged constructor receive '
            'the wrapper (e.g. TextField.controller), so the recovered screen '
            'threw again instead of rendering',
      );
      expect((state.build(_FakeContext()) as Text).data, 'late ok');
    });
  });
}

class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

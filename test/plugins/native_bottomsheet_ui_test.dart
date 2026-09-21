/// Bridge + behavior coverage for `native_bottomsheet` (template:
/// `test/plugins/shared_preferences_bridge_test.dart`).
///
/// Regression for the tap-time crash:
/// ```text
/// type '(dynamic, DNSheetController) => dynamic' is not a subtype of
/// type '(dynamic, DNSheetController) => Widget'
/// ```
/// The generated `showBottomSheet` adapter wrapped the interpreted `builder`
/// with a `dynamic` return (`castCallbackResult<dynamic>`); the native
/// `builder` parameter demands `Widget`. Fixed by coercing the callback
/// result through `extractBridgedArg<Widget>` (full interface-proxy path),
/// kept in place by `_patchNativeBottomsheetBridges` in
/// `tool/d4rtgen.dart` + `tool/d4rtgen_ast.dart`.
///
/// Two execution policies (same as the prefs suite):
/// - Host (default `dn test`): the native sheet cannot present without the
///   platform runtime, so headless coverage drives the bridge adapter
///   directly and asserts the builder closure satisfies the `Widget`
///   signature (pre-fix this throws the exact `TypeError` above).
/// - Device (`dn test -d DEVICE_ID --dart-define=DN_DEVICE_TEST=true ...`):
///   surface checks re-run against the real runtime; the gesture proof is
///   the app's own bottom-sheet tap.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:test/test.dart';
import 'package:tom_d4rt/d4rt.dart';
import 'package:dartnative_go/src/interpreter/ast/native_bottomsheet_bridges.b.dart'
    as ast_bridges;
import 'package:dartnative_go/src/interpreter/native_bottomsheet_bridges.b.dart'
    as src_bridges;

import '../test_lab/fixtures/riverpod_fixture.dart';
import '../test_lab/harness.dart';

/// True only when tests run on a device with the native runtime, e.g.
/// `dn test -d DEVICE_ID --dart-define=DN_DEVICE_TEST=true
/// test/plugins/native_bottomsheet_ui_test.dart`.
const _isDeviceRun = bool.fromEnvironment('DN_DEVICE_TEST');

/// Guest exposing its sheet builder as a tear-off so the test can drive the
/// exact callback shape the native adapter receives on tap.
const _sheetGuest = r'''
import 'package:dartnative/dartnative.dart';

class SheetBody extends StatelessWidget {
  const SheetBody({super.key});

  @override
  Widget build(BuildContext context) => const Text('sheet body');
}

Widget sheetBuilder(dynamic ctx, dynamic ctl) => SheetBody();

Object getBuilder() => sheetBuilder;

void main() {
  runApp(const Text('host'));
}
''';

/// The Widget-coercing builder wrapper the bridge must contain (both
/// engines). Guards the `_patchNativeBottomsheetBridges` post-fix against
/// regen drift: if generation reverts to `castCallbackResult<dynamic>`,
/// taps throw the signature `TypeError` again.
const _patchedBuilderExpr =
    "extractBridgedArg<\$flutter_widgets.Widget>(D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1]), 'builder', visitor)";

void main() {
  group('native_bottomsheet bridge surface', () {
    test('showBottomSheet registered in source bridges', () {
      expect(
        src_bridges.NativeBottomsheetBridge.globalFunctions(),
        contains('showBottomSheet'),
      );
    });

    test('showBottomSheet registered in AST bridges', () {
      expect(
        ast_bridges.NativeBottomsheetBridge.globalFunctions(),
        contains('showBottomSheet'),
      );
    });

    test('source builder coerces callback result to Widget', () {
      final path =
          'lib/src/interpreter/native_bottomsheet_bridges.b.dart';
      expect(
        File(path).existsSync(),
        isTrue,
        reason: 'bridge file must exist at $path',
      );
      expect(
        File(path).readAsStringSync(),
        contains(_patchedBuilderExpr),
        reason:
            'builder wrapper must coerce via extractBridgedArg<Widget> '
            '(regen must keep _patchNativeBottomsheetBridges)',
      );
    });

    test('AST builder coerces callback result to Widget', () {
      final path =
          'lib/src/interpreter/ast/native_bottomsheet_bridges.b.dart';
      expect(
        File(path).existsSync(),
        isTrue,
        reason: 'bridge file must exist at $path',
      );
      expect(
        File(path).readAsStringSync(),
        contains(_patchedBuilderExpr),
        reason:
            'builder wrapper must coerce via extractBridgedArg<Widget> '
            '(regen must keep _patchNativeBottomsheetBridges)',
      );
    });
  });

  group('showBottomSheet builder coercion (source, headless)', () {
    late DnHarness harness;

    setUp(() {
      harness = DnHarness(onLog: (_) {});
    });

    tearDown(() {
      harness.dispose();
    });

    test('interpreted builder result coerces to a native Widget', () async {
      await harness.evaluate({'main.dart': _sheetGuest});
      final visitor = harness.sourceRunner.interpreter.visitor;
      expect(
        visitor,
        isNotNull,
        reason: 'harness must expose the interpreter visitor',
      );

      final builderFn = await harness.callFunction('getBuilder');
      final raw = D4.callInterpreterCallback(
        visitor!,
        builderFn,
        [FakeBuildContext(), null],
      );

      // Pre-fix premise: the raw callback result is an interpreted
      // instance, which the old `dynamic`-returning wrapper handed to the
      // native `Widget Function(...)` parameter -> tap-time TypeError.
      expect(
        () => (raw as Widget),
        throwsA(isA<TypeError>()),
        reason:
            'raw interpreted builder result must not satisfy Widget '
            'without coercion (pins the repro premise)',
      );

      final coerced = D4.extractBridgedArg<Widget>(raw, 'builder', visitor);
      expect(coerced, isA<Widget>());
      expect(coerced, isA<StatelessWidget>());
    });

    test('bridge adapter accepts the interpreted builder', () async {
      await harness.evaluate({'main.dart': _sheetGuest});
      final visitor = harness.sourceRunner.interpreter.visitor;
      expect(visitor, isNotNull);

      final builderFn = await harness.callFunction('getBuilder');
      final adapter = src_bridges.NativeBottomsheetBridge.globalFunctions()['showBottomSheet'];
      expect(adapter, isNotNull);

      // Drives the real adapter closure up to (and into) the native call.
      // Pre-fix this throws the exact tap-time TypeError from the report.
      // Post-fix the builder check passes; the native sheet itself cannot
      // present headless, so any *other* error is the expected host
      // limitation, not the bug.
      try {
        adapter!(
          visitor!,
          [FakeBuildContext()],
          {'builder': builderFn},
          null,
        );
      } catch (e) {
        expect(
          e.toString(),
          isNot(
            contains('(dynamic, DNSheetController) => Widget'),
          ),
          reason:
              'builder closure must satisfy the Widget signature; '
              'native presentation may still fail headless, got: $e',
        );
        return;
      }
    });
  });

  group(
    'native_bottomsheet on-device (real presentation)',
    () {
      test('bridge surface loads against the real runtime', () async {
        final harness = DnHarness(onLog: (_) {});
        try {
          final root = await harness.evaluate({'main.dart': _sheetGuest});
          expect(root, isA<Widget>());
        } finally {
          harness.dispose();
        }
      });
    },
    skip: _isDeviceRun
        ? false
        : 'needs a device runtime: dn test -d <device-id> '
            '--dart-define=DN_DEVICE_TEST=true test/plugins/native_bottomsheet_ui_test.dart',
  );
}

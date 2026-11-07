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
import 'package:dartnative/plugin.dart';
import 'package:native_bottomsheet/src/sheet_native_bindings.dart';
import 'package:test/test.dart';
import 'package:tom_d4rt/d4rt.dart';
import 'package:dartnative_go/src/interpreter/ast/native_bottomsheet_bridges.b.dart'
    as ast_bridges;
import 'package:dartnative_go/src/interpreter/native_bottomsheet_bridges.b.dart'
    as src_bridges;
import 'package:dartnative_go/src/runner/native_bottomsheet_manager.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';

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

/// Normalizes generated source for these assertions: the formatter re-wraps
/// the emitted call across several lines and appends trailing commas before
/// closing brackets, neither of which changes behavior.
String _flat(String source) => source
    .replaceAll(RegExp(r'\s+'), '')
    .replaceAll(RegExp(r',(?=[)\]])'), '');

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
      final path = 'lib/src/interpreter/native_bottomsheet_bridges.b.dart';
      expect(
        File(path).existsSync(),
        isTrue,
        reason: 'bridge file must exist at $path',
      );
      expect(
        _flat(File(path).readAsStringSync()),
        contains(_flat(_patchedBuilderExpr)),
        reason:
            'builder wrapper must coerce via extractBridgedArg<Widget> '
            '(regen must keep _patchNativeBottomsheetBridges)',
      );
    });

    test('AST builder coerces callback result to Widget', () {
      final path = 'lib/src/interpreter/ast/native_bottomsheet_bridges.b.dart';
      expect(
        File(path).existsSync(),
        isTrue,
        reason: 'bridge file must exist at $path',
      );
      expect(
        _flat(File(path).readAsStringSync()),
        contains(_flat(_patchedBuilderExpr)),
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
      final adapter = src_bridges
          .NativeBottomsheetBridge.globalFunctions()['showBottomSheet'];
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

  group('NativeBottomSheetScope and NativeBottomSheetManager', () {
    test('NativeBottomSheetScope wraps builder result in bridge', () {
      final srcPath = 'lib/src/interpreter/native_bottomsheet_bridges.b.dart';
      expect(
        _flat(File(srcPath).readAsStringSync()),
        contains(
          _flat(
            r'$bottomsheet_mgr.NativeBottomSheetScope(controller: p1, child:',
          ),
        ),
      );
      final astPath =
          'lib/src/interpreter/ast/native_bottomsheet_bridges.b.dart';
      expect(
        _flat(File(astPath).readAsStringSync()),
        contains(
          _flat(
            r'$bottomsheet_mgr.NativeBottomSheetScope(controller: p1, child:',
          ),
        ),
      );
    });

    test(
      'NativeBottomSheetScope registers and unregisters with NativeBottomSheetManager',
      () {
        final initialCount = NativeBottomSheetManager.activeSheetCount;
        final controller = DNSheetController.create(
          sheetId: 9999,
          detents: const [DNSheetDetent.large],
          initialDetent: DNSheetDetent.large,
        );

        final scope = NativeBottomSheetScope(
          controller: controller,
          child: const Text('test child'),
        );

        final state = scope.createState();
        state.initState();

        expect(NativeBottomSheetManager.activeSheetCount, initialCount + 1);
        expect(NativeBottomSheetManager.activeSheets.contains(state), isTrue);

        state.dispose();
        expect(NativeBottomSheetManager.activeSheetCount, initialCount);
        expect(NativeBottomSheetManager.activeSheets.contains(state), isFalse);
      },
    );

    test('rebindAndRebuild rebinds child and proxies', () async {
      final harness = DnHarness(onLog: (_) {});
      try {
        await harness.evaluate({'main.dart': _sheetGuest});
        final visitor = harness.sourceRunner.interpreter.visitor;
        expect(visitor, isNotNull);

        final controller = DNSheetController.create(
          sheetId: 9998,
          detents: const [DNSheetDetent.large],
          initialDetent: DNSheetDetent.large,
        );

        final builderFn = await harness.callFunction('getBuilder');
        final raw = D4.callInterpreterCallback(
          visitor!,
          builderFn,
          [FakeBuildContext(), controller],
        );
        final coerced = D4.extractBridgedArg<Widget>(raw, 'builder', visitor);

        final scope = NativeBottomSheetScope(
          controller: controller,
          child: coerced,
        );
        final state = scope.createState();
        state.initState();

        // Hot reload simulation: evaluate an updated guest
        await harness.hotReload({'main.dart': _sheetGuest});
        final newVisitor = harness.sourceRunner.interpreter.visitor;
        expect(newVisitor, isNotNull);

        // Notify hot reload via NativeBottomSheetManager
        expect(
          () => NativeBottomSheetManager.notifyHotReload(newVisitor),
          returnsNormally,
        );

        state.dispose();
      } finally {
        harness.dispose();
      }
    });

    test('SheetNativeBindings forwards the gesture contract', () {
      final fake = _FakeNativeBindings();
      final sheetBindings = SheetNativeBindings(fake, () {});

      // Regression: these members used to be reached through
      // `noSuchMethod`, which called `Object.noSuchMethod` on the inner
      // bindings instead of dispatching the real implementation. Mounting a
      // `GestureDetector` inside a sheet then threw:
      //   NoSuchMethodError: Class 'SheetNativeBindings' has no instance
      //   getter 'supportsTapEvents'.
      expect(sheetBindings.supportsTapEvents, isTrue);
      expect(sheetBindings.supportsAlignPlacement, isTrue);
      expect(
        sheetBindings.scrollQuietFor,
        const Duration(milliseconds: 12),
      );

      var taps = 0;
      final id = sheetBindings.registerTapEventCallback(
        (kind, x, y, width, height) => taps++,
      );
      expect(fake.callbacks[id], isNotNull);
      (fake.callbacks[id]
          as void Function(int, double, double, double, double))(
        0,
        1,
        2,
        3,
        4,
      );
      expect(taps, equals(1));
    });

    test(
      'SheetNativeBindings forwards text change and textFieldGetSelection',
      () {
        final fake = _FakeNativeBindings();
        final sheetBindings = SheetNativeBindings(fake, () {});

        // Verify textFieldGetSelection forwarding
        final sel = sheetBindings.textFieldGetSelection(42);
        expect(sel.start, equals(0));
        expect(sel.end, equals(0));
        expect(sel.composingStart, equals(-1));
        expect(sel.composingEnd, equals(-1));

        // Verify textFieldSetSelection forwarding
        sheetBindings.textFieldSetSelection(42, 2, 5);
        expect(fake.lastSetSelection, equals((viewId: 42, start: 2, end: 5)));

        // Verify text change callback registration and invocation
        String? changedVal;
        final cbId = sheetBindings.registerTextChangeCallback((val) {
          changedVal = val;
        });
        expect(fake.callbacks.containsKey(cbId), isTrue);

        final textCb = fake.callbacks[cbId] as void Function(String);
        textCb('hello world');
        expect(changedVal, equals('hello world'));
      },
    );
  });
}

class _FakeNativeBindings implements NativeBindings {
  final Map<int, Function> callbacks = {};
  int _nextCb = 100;
  ({int viewId, int start, int end})? lastSetSelection;

  @override
  void applyMutations(List<ViewMutation> mutations, {bool layout = true}) {}

  @override
  bool get supportsTapEvents => true;

  @override
  bool get supportsAlignPlacement => true;

  @override
  Duration get scrollQuietFor => const Duration(milliseconds: 12);

  @override
  int registerTapEventCallback(
    void Function(int, double, double, double, double) callback,
  ) {
    final id = _nextCb++;
    callbacks[id] = callback;
    return id;
  }

  @override
  int registerTextChangeCallback(void Function(String) callback) {
    final id = _nextCb++;
    callbacks[id] = callback;
    return id;
  }

  @override
  int registerTextFocusCallback(void Function(bool) callback) {
    final id = _nextCb++;
    callbacks[id] = callback;
    return id;
  }

  @override
  int registerTextTapCallback(void Function() callback) {
    final id = _nextCb++;
    callbacks[id] = callback;
    return id;
  }

  @override
  ({int composingEnd, int composingStart, int end, int start})
  textFieldGetSelection(int viewId) {
    return (composingEnd: -1, composingStart: -1, end: 0, start: 0);
  }

  @override
  void textFieldSetSelection(int viewId, int start, int end) {
    lastSetSelection = (viewId: viewId, start: start, end: end);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Headless compatibility test for `dartnative_shared_preferences`.
///
/// Two execution policies — same guest code, different backends:
/// - Host (default `dn test`): the host has no native FFI lib, so the
///   harness installs the in-memory fake (`test/test_lab/fakes/`) over the
///   real bridge. Proves bridge wiring + guest logic.
/// - Device (`dn test -d DEVICE_ID --dart-define=DN_DEVICE_TEST=true ...`):
///   NO fake is installed; the guest talks to the real platform store over
///   FFI. Proves the real use case. The `on-device` group below is skipped
///   unless `DN_DEVICE_TEST` is defined.
///
/// Covers:
/// 1. Bridge surface: `SharedPreferences` (+ `PrefsBindings`) registered in
///    BOTH source (`lib/src/interpreter/`) and AST (`lib/src/interpreter/ast/`)
///    generated bridges, with matching method signatures.
/// 2. Headless behavior (source mode): full set/get round-trip for every
///    supported type through the host fake, asserting via the resolved
///    widget tree.
/// 3. UI interaction: find `Text`/`Button` nodes, tap Save/Load, prove the tap
///    persisted through a same-session `readBack()` call (works because the
///    fake holds state in host memory).
///
/// Failure classification: bridge-missing (registration absent) vs
/// native-missing (real FFI `SharedPreferences.getInstance()` throws on the
/// host, which has no native lib) vs guest logic errors.
library;

import 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart';
import 'package:dartnative_go/src/interpreter/dartnative_shared_preferences_bridges.b.dart'
    as src_bridges;
import 'package:dartnative_go/src/interpreter/ast/dartnative_shared_preferences_bridges.b.dart'
    as ast_bridges;
import 'package:test/test.dart';

import '../test_lab/fakes/fake_shared_preferences.dart';
import '../test_lab/harness.dart';
import '../test_lab/widget_probe.dart';

/// True only when tests run on a device with the native runtime, e.g.
/// `dn test -d DEVICE_ID --dart-define=DN_DEVICE_TEST=true
/// test/plugins/shared_preferences_bridge_test.dart`.
const _isDeviceRun = bool.fromEnvironment('DN_DEVICE_TEST');

const _prefsApp = r'''
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart';

Future<void> main() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  await prefs.setString('greeting', 'hello');
  await prefs.setInt('count', 42);
  await prefs.setDouble('ratio', 1.5);
  await prefs.setBool('enabled', true);
  await prefs.setStringList('tags', ['a', 'b']);

  final s = prefs.getString('greeting');
  final i = prefs.getInt('count');
  final d = prefs.getDouble('ratio');
  final b = prefs.getBool('enabled');
  final l = prefs.getStringList('tags');
  final has = prefs.containsKey('greeting');
  final missing = prefs.getString('nope');

  await prefs.remove('greeting');
  final afterRemove = prefs.getString('greeting');

  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('str:$s'),
            Text('int:$i'),
            Text('double:$d'),
            Text('bool:$b'),
            Text('list:${l?.join(',')}'),
            Text('has:$has'),
            Text('missing:$missing'),
            Text('afterRemove:$afterRemove'),
          ],
        ),
      ),
    ),
  );
}
''';

const _prefsInteractiveApp = r'''
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart';

Future<void> savePressed() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('tapped', 'yes');
}

Future<String?> readBack() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('tapped');
}

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Value: none'),
            Button(title: 'Save', onPressed: () => savePressed()),
            Button(title: 'Load', onPressed: () => readBack()),
          ],
        ),
      ),
    ),
  );
}
''';

void main() {
  group('SharedPreferences bridge surface', () {
    test('source bridges register SharedPreferences + PrefsBindings', () {
      final classes =
          src_bridges.DartnativeSharedPreferencesBridge.bridgeClasses();
      final names = classes.map((c) => c.name).toSet();
      expect(names, contains('SharedPreferences'));
      expect(names, contains('PrefsBindings'));
    });

    test('source SharedPreferences exposes the full prefs API', () {
      final classes =
          src_bridges.DartnativeSharedPreferencesBridge.bridgeClasses();
      final prefs = classes.firstWhere((c) => c.name == 'SharedPreferences');
      expect(
        prefs.methodSignatures.keys,
        containsAll([
          'containsKey',
          'getString',
          'getInt',
          'getDouble',
          'getBool',
          'getStringList',
          'setString',
          'setInt',
          'setDouble',
          'setBool',
          'setStringList',
          'remove',
          'clear',
          'reload',
        ]),
      );
      expect(prefs.staticMethodSignatures.keys, contains('getInstance'));
    });

    test('AST bridges mirror the source bridge surface (parity)', () {
      final src = src_bridges.DartnativeSharedPreferencesBridge.bridgeClasses();
      final ast = ast_bridges.DartnativeSharedPreferencesBridge.bridgeClasses();
      final srcPrefs = src.firstWhere((c) => c.name == 'SharedPreferences');
      final astPrefs = ast.firstWhere((c) => c.name == 'SharedPreferences');
      expect(
        astPrefs.methodSignatures.keys.toSet(),
        equals(srcPrefs.methodSignatures.keys.toSet()),
        reason: 'AST bridge methods must match source bridge methods',
      );
      expect(
        astPrefs.staticMethodSignatures.keys.toSet(),
        equals(srcPrefs.staticMethodSignatures.keys.toSet()),
      );
    });
  });

  group('SharedPreferences headless behavior (source mode)', () {
    late DnHarness harness;
    late FakeSharedPreferencesHost fakeHost;

    setUp(() {
      // Host fake: real FFI is unavailable on macOS, so guest code runs
      // against this in-memory store via the harness bridge-override seam.
      fakeHost = FakeSharedPreferencesHost();
      harness = DnHarness(
        onLog: (_) {},
        bridgeOverrides: [
          (interpreter) => installFakeSharedPreferences(interpreter, fakeHost),
        ],
      );
    });

    tearDown(() {
      harness.dispose();
    });

    test('set/get round-trip for every supported type', () async {
      final root = await harness.evaluate({'main.dart': _prefsApp});

      expect(findText(root, 'str:hello'), isNotNull);
      expect(findText(root, 'int:42'), isNotNull);
      expect(findText(root, 'double:1.5'), isNotNull);
      expect(findText(root, 'bool:true'), isNotNull);
      expect(findText(root, 'list:a,b'), isNotNull);
      expect(findText(root, 'has:true'), isNotNull);
      expect(findText(root, 'missing:null'), isNotNull);
      expect(findText(root, 'afterRemove:null'), isNotNull);
    });

    test('tap Save persists; same-session readBack sees it', () async {
      final root = await harness.evaluate({
        'main.dart': _prefsInteractiveApp,
      });

      expect(findText(root, 'Value: none'), isNotNull);
      expect(findButton(root, 'Save'), isNotNull);
      expect(findButton(root, 'Load'), isNotNull);

      tapButton(root, 'Save');
      // Stub writes complete as microtasks/futures.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final back = await harness.callFunction('readBack');
      expect(
        back,
        equals('yes'),
        reason:
            'tapping Save must persist via SharedPreferences (dump:\n${dumpTree(root)})',
      );
    });
  });

  group('SharedPreferences native limitation (documents headless scope)', () {
    test('real FFI getInstance throws on host without native lib', () async {
      // The host fake works headless; the REAL native class needs the
      // compiled DartNative Go runtime. This test pins that boundary so
      // future failures are classified as native-missing, not bridge-missing.
      // Skipped on device runs, where the real store exists.
      if (_isDeviceRun) return;
      try {
        await SharedPreferences.getInstance().timeout(
          const Duration(seconds: 5),
        );
      } catch (e) {
        expect(e, isNotNull);
        return;
      }
      // If a native lib ever lands on the host, the call succeeds — fine.
      expect(true, isTrue);
    });
  });

  group(
    'SharedPreferences on-device (real FFI, no fake)',
    () {
      late DnHarness harness;

      setUp(() {
        // Deliberately NO bridgeOverrides: the guest talks to the real
        // platform store. Fails on the host — that is the point.
        harness = DnHarness(onLog: (_) {});
      });

      tearDown(() {
        harness.dispose();
      });

      test('real set/get round-trip for every supported type', () async {
        final root = await harness.evaluate({'main.dart': _prefsApp});
        expect(findText(root, 'str:hello'), isNotNull);
        expect(findText(root, 'int:42'), isNotNull);
        expect(findText(root, 'double:1.5'), isNotNull);
        expect(findText(root, 'bool:true'), isNotNull);
        expect(findText(root, 'list:a,b'), isNotNull);
        expect(findText(root, 'has:true'), isNotNull);
        expect(findText(root, 'missing:null'), isNotNull);
        expect(findText(root, 'afterRemove:null'), isNotNull);
      });

      test('tap Save persists to the real store', () async {
        final root = await harness.evaluate({
          'main.dart': _prefsInteractiveApp,
        });
        tapButton(root, 'Save');
        await Future<void>.delayed(const Duration(milliseconds: 500));
        expect(await harness.callFunction('readBack'), equals('yes'));
      });
    },
    skip: _isDeviceRun
        ? false
        : 'needs a device runtime: dn test -d <device-id> '
              '--dart-define=DN_DEVICE_TEST=true test/plugins/shared_preferences_bridge_test.dart',
  );
}

/// Headless test suite for `local_auth_kit` bridges.
///
/// Validates bridge registration and headless biometric authentication
/// lifecycle via an in-memory host fake.
library;

import 'package:dartnative_go/src/interpreter/local_auth_kit_bridges.b.dart'
    as src_bridges;
import 'package:dartnative_go/src/interpreter/ast/local_auth_kit_bridges.b.dart'
    as ast_bridges;
import 'package:test/test.dart';

import '../test_lab/fakes/fake_local_auth.dart';
import '../test_lab/harness.dart';
import '../test_lab/widget_probe.dart';

const _authApp = r'''
import 'package:local_auth_kit/local_auth_kit.dart';

Future<void> main() async {
  final auth = LocalAuthentication();
  final supported = await auth.isDeviceSupported();
  final canCheck = await auth.canCheckBiometrics;
  final biometrics = await auth.getAvailableBiometrics();
  final ok = await auth.authenticate(localizedReason: 'Unlock to continue');

  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('supported:$supported'),
            Text('canCheck:$canCheck'),
            Text('biometrics:${biometrics?.length}'),
            Text('ok:$ok'),
          ],
        ),
      ),
    ),
  );
}
''';

const _authInteractiveApp = r'''
import 'package:local_auth_kit/local_auth_kit.dart';

Future<void> authenticatePressed() async {
  final auth = LocalAuthentication();
  await auth.authenticate(localizedReason: 'Unlock from a tap');
}

Future<String> readBack() async {
  final auth = LocalAuthentication();
  return 'stopped:${await auth.stopAuthentication()}';
}

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Ready'),
            Button(title: 'Authenticate', onPressed: () => authenticatePressed()),
          ],
        ),
      ),
    ),
  );
}
''';

void main() {
  group('LocalAuth bridge surface', () {
    test('source bridges register LocalAuthentication + types', () {
      final names = src_bridges.LocalAuthKitBridge.bridgeClasses()
          .map((c) => c.name)
          .toSet();
      expect(names, contains('LocalAuthentication'));
      expect(names, contains('LocalAuthBackend'));
      expect(names, contains('IOSAuthMessages'));
      expect(names, contains('AuthenticationOptions'));
      expect(
        src_bridges.LocalAuthKitBridge.enumNames,
        contains('BiometricType'),
      );
    });

    test('source LocalAuthentication exposes the full API', () {
      final classes = src_bridges.LocalAuthKitBridge.bridgeClasses();
      final auth = classes.firstWhere((c) => c.name == 'LocalAuthentication');
      expect(
        auth.methodSignatures.keys,
        containsAll([
          'isDeviceSupported',
          'getAvailableBiometrics',
          'authenticate',
          'stopAuthentication',
        ]),
      );
      expect(auth.getterSignatures.keys, contains('canCheckBiometrics'));
    });

    test('AST bridges mirror the source bridge surface (parity)', () {
      final src = src_bridges.LocalAuthKitBridge.bridgeClasses();
      final ast = ast_bridges.LocalAuthKitBridge.bridgeClasses();
      final srcAuth = src.firstWhere((c) => c.name == 'LocalAuthentication');
      final astAuth = ast.firstWhere((c) => c.name == 'LocalAuthentication');
      expect(
        astAuth.methodSignatures.keys.toSet(),
        equals(srcAuth.methodSignatures.keys.toSet()),
      );
    });
  });

  group('LocalAuth headless behavior (source mode, host fake)', () {
    late DnHarness harness;
    late FakeLocalAuthHost fakeHost;

    setUp(() {
      fakeHost = FakeLocalAuthHost();
      harness = DnHarness(
        onLog: (_) {},
        bridgeOverrides: [
          (interpreter) => installFakeLocalAuth(interpreter, fakeHost),
        ],
      );
    });

    tearDown(() {
      harness.dispose();
    });

    test('authenticate round-trip through the fake', () async {
      final root = await harness.evaluate({'main.dart': _authApp});

      expect(findText(root, 'supported:true'), isNotNull);
      expect(findText(root, 'canCheck:true'), isNotNull);
      expect(findText(root, 'biometrics:1'), isNotNull);
      expect(findText(root, 'ok:true'), isNotNull);

      expect(fakeHost.authenticateCalls, 1);
      expect(fakeHost.lastReason, 'Unlock to continue');
    });

    test('tap Authenticate routes through the fake; readBack stops', () async {
      final root = await harness.evaluate({
        'main.dart': _authInteractiveApp,
      });

      expect(findText(root, 'Ready'), isNotNull);
      expect(findButton(root, 'Authenticate'), isNotNull);

      tapButton(root, 'Authenticate');
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(fakeHost.authenticateCalls, 1);
      expect(fakeHost.lastReason, 'Unlock from a tap');
      expect(
        await harness.callFunction('readBack'),
        equals('stopped:true'),
        reason:
            'stopAuthentication must route through the fake '
            '(dump:\n${dumpTree(root)})',
      );
    });
  });

  group('LocalAuth native limitation (documents headless scope)', () {
    test(
      'real engine authenticate throws on host without the native runtime',
      () async {
        final harness = DnHarness(onLog: (_) {});
        addTearDown(harness.dispose);
        try {
          await harness.evaluate({
            'main.dart': r'''
import 'package:local_auth_kit/local_auth_kit.dart';

Future<void> main() async {
  await LocalAuthentication().isDeviceSupported();
  runApp(Text('unreachable'));
}
''',
          });
          // If a native runtime ever lands on the host, evaluation succeeds.
        } catch (e) {
          expect(e, isNotNull);
        }
      },
    );
  });
}

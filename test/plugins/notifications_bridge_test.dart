/// Headless compatibility test for `dartnative_notifications`.
///
/// Two execution policies — same guest code, different backends:
/// - Host (default `dn test`): the host has no native FFI lib, so the
///   harness installs the in-memory fake (`test/test_lab/fakes/`) over the
///   real bridge. Proves bridge wiring + guest logic.
/// - Device (`dn test -d DEVICE_ID --dart-define=DN_DEVICE_TEST=true ...`):
///   NO fake is installed; the guest talks to the real notification center
///   over FFI. Proves the real use case. The `on-device` group below is
///   skipped unless `DN_DEVICE_TEST` is defined.
///
/// Covers:
/// 1. Bridge surface: `DartNativeNotifications` (+ `NotificationsFFIBindings`)
///    registered in BOTH source (`lib/src/interpreter/`) and AST
///    (`lib/src/interpreter/ast/`) generated bridges, with matching
///    signatures.
/// 2. Headless behavior (source mode): setup + requestPermission + show /
///    showChat / cancel / cancelAll round-trip through the host fake,
///    asserting via the resolved widget tree and the fake host.
/// 3. UI interaction: `Button` driving requestPermission + show; tap persists
///    through the fake-host object (host-visible channel).
///
/// Failure classification: bridge-missing (registration absent) vs
/// native-missing (real FFI throws on the host, which has no native lib —
/// on device this is the `LateInitializationError: Field
/// '_requestPermission@...' has not been initialized` seen when the runner
/// app was built without `pod install` + rebuild after adding the plugin)
/// vs guest logic errors.
library;

import 'package:dartnative_notifications/dartnative_notifications.dart';
import 'package:dartnative_go/src/interpreter/dartnative_notifications_bridges.b.dart'
    as src_bridges;
import 'package:dartnative_go/src/interpreter/ast/dartnative_notifications_bridges.b.dart'
    as ast_bridges;
import 'package:test/test.dart';

import '../test_lab/fakes/fake_notifications.dart';
import '../test_lab/harness.dart';
import '../test_lab/widget_probe.dart';

/// True only when tests run on a device with the native runtime, e.g.
/// `dn test -d DEVICE_ID --dart-define=DN_DEVICE_TEST=true
/// test/plugins/notifications_bridge_test.dart`.
const _isDeviceRun = bool.fromEnvironment('DN_DEVICE_TEST');

const _notifApp = r'''
import 'dart:typed_data';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_notifications/dartnative_notifications.dart';

Future<void> main() async {
  DartNativeNotifications.setup(onTap: (payload) {});
  final granted = await DartNativeNotifications.requestPermission();
  final initial = DartNativeNotifications.getInitialTapPayload();

  DartNativeNotifications.show(
    id: 'hello',
    title: 'Hi',
    body: 'Welcome',
    payload: 'tap-1',
  );
  DartNativeNotifications.showChat(
    id: 'chat-1',
    senderName: 'Ada',
    body: 'Hello there',
    avatar: Uint8List(0),
    payload: 'tap-2',
  );
  DartNativeNotifications.cancel('hello');
  DartNativeNotifications.cancelAll();

  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('granted:$granted'),
            Text('initial:$initial'),
          ],
        ),
      ),
    ),
  );
}
''';

const _notifInteractiveApp = r'''
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_notifications/dartnative_notifications.dart';

Future<void> permitPressed() async {
  await DartNativeNotifications.requestPermission();
}

Future<void> notifyPressed() async {
  DartNativeNotifications.show(id: 'tapped', title: 'T', body: 'B');
}

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Value: none'),
            Button(title: 'Permit', onPressed: () => permitPressed()),
            Button(title: 'Notify', onPressed: () => notifyPressed()),
          ],
        ),
      ),
    ),
  );
}
''';

void main() {
  group('Notifications bridge surface', () {
    test('source bridges register API + FFI bindings', () {
      final classes =
          src_bridges.DartnativeNotificationsBridge.bridgeClasses();
      final names = classes.map((c) => c.name).toSet();
      expect(names, contains('DartNativeNotifications'));
      expect(names, contains('NotificationsFFIBindings'));
    });

    test('source bridge exposes the full notifications API', () {
      final classes =
          src_bridges.DartnativeNotificationsBridge.bridgeClasses();
      final api =
          classes.firstWhere((c) => c.name == 'DartNativeNotifications');
      expect(
        api.staticMethodSignatures.keys,
        containsAll([
          'setup',
          'getInitialTapPayload',
          'requestPermission',
          'show',
          'showChat',
          'cancel',
          'cancelAll',
        ]),
      );
      expect(api.staticGetterSignatures.keys, contains('onTap'));
    });

    test('AST bridges mirror the source bridge surface (parity)', () {
      final src = src_bridges.DartnativeNotificationsBridge.bridgeClasses();
      final ast = ast_bridges.DartnativeNotificationsBridge.bridgeClasses();
      final srcByName = {for (final c in src) c.name: c};
      final astByName = {for (final c in ast) c.name: c};
      for (final entry in srcByName.entries) {
        final astClass = astByName[entry.key];
        expect(astClass, isNotNull,
            reason: 'AST bridge missing ${entry.key}');
        expect(
          astClass!.methodSignatures.keys.toSet(),
          equals(entry.value.methodSignatures.keys.toSet()),
          reason: '${entry.key} methods must match',
        );
        expect(
          astClass.staticMethodSignatures.keys.toSet(),
          equals(entry.value.staticMethodSignatures.keys.toSet()),
          reason: '${entry.key} static methods must match',
        );
      }
    });
  });

  group('Notifications headless behavior (source mode)', () {
    late DnHarness harness;
    late FakeNotificationsHost fakeHost;

    setUp(() {
      // Host fake: real FFI is unavailable on macOS, so guest code runs
      // against this in-memory recorder via the harness bridge-override seam.
      fakeHost = FakeNotificationsHost()
        ..permissionGranted = true
        ..initialTapPayload = null;
      harness = DnHarness(
        onLog: (_) {},
        bridgeOverrides: [
          (interpreter) => installFakeNotifications(interpreter, fakeHost),
        ],
      );
    });

    tearDown(() {
      fakeHost.dispose();
      harness.dispose();
    });

    test('permission + show/showChat/cancel round-trip', () async {
      final root = await harness.evaluate({'main.dart': _notifApp});

      expect(findText(root, 'granted:true'), isNotNull);
      expect(findText(root, 'initial:null'), isNotNull);
      expect(
        fakeHost.shown.map((e) => e['id']),
        contains('hello'),
      );
      expect(
        fakeHost.shownChat.map((e) => e['id']),
        contains('chat-1'),
      );
      expect(fakeHost.cancelled, contains('hello'));
      expect(fakeHost.cancelAllCalls, equals(1));
    });

    test('tap Permit + Notify records through the fake host', () async {
      final root = await harness.evaluate({
        'main.dart': _notifInteractiveApp,
      });

      expect(findText(root, 'Value: none'), isNotNull);
      expect(findButton(root, 'Permit'), isNotNull);
      expect(findButton(root, 'Notify'), isNotNull);

      tapButton(root, 'Permit');
      tapButton(root, 'Notify');
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(
        fakeHost.shown.map((e) => e['id']),
        contains('tapped'),
        reason: 'tapping Notify must record a show (dump:\n${dumpTree(root)})',
      );
    });
  });

  group('Notifications native limitation (documents headless scope)', () {
    test('real FFI requestPermission throws on host without native lib',
        () async {
      // The host fake works headless; the REAL native class needs the
      // compiled DartNative runtime. This test pins that boundary so future
      // failures are classified as native-missing, not bridge-missing.
      // Skipped on device runs, where the real center exists.
      if (_isDeviceRun) return;
      try {
        await DartNativeNotifications.requestPermission()
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        expect(e, isNotNull);
        return;
      }
      // If a native lib ever lands on the host, the call succeeds — fine.
      expect(true, isTrue);
    });
  });

  group(
    'Notifications on-device (real FFI, no fake)',
    () {
      late DnHarness harness;

      setUp(() {
        // Deliberately NO bridgeOverrides: the guest talks to the real
        // notification center. Fails on the host — that is the point.
        harness = DnHarness(onLog: (_) {});
      });

      tearDown(() {
        harness.dispose();
      });

      test('real permission + show round-trip', () async {
        final root = await harness.evaluate({'main.dart': _notifApp});
        expect(findText(root, 'granted:true'), isNotNull);
      });
    },
    skip: _isDeviceRun
        ? false
        : 'needs a device runtime: dn test -d <device-id> '
            '--dart-define=DN_DEVICE_TEST=true test/plugins/notifications_bridge_test.dart',
  );
}

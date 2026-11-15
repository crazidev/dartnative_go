/// Headless compatibility test for `dartnative_system`.
///
/// - Host (default `dn test`): the harness installs the in-memory fake
///   (`test/test_lab/fakes/fake_system.dart`) over the real bridge. Proves
///   bridge wiring + guest logic.
/// - Device (`dn test -d DEVICE_ID --dart-define=DN_DEVICE_TEST=true`): NO
///   fake; the guest talks to the real FFI APIs. Skipped off-device.
///
/// Covers: bridge surface (source + AST parity), the full exposed API
/// (`PackageInfo.fromPlatform` + getters, `AppBadgePlus.isSupported` /
/// `updateBadge`, `SystemFFIBindings.instance` methods), UI interaction, and
/// the plugin's documented flows (badge set + clear, info display).
library;

import 'package:dartnative_go/src/interpreter/dartnative_system_bridges.b.dart'
    as src_bridges;
import 'package:dartnative_go/src/interpreter/ast/dartnative_system_bridges.b.dart'
    as ast_bridges;
import 'package:dartnative_go/src/interpreter/dartscript.b.dart' as gen;
import 'package:test/test.dart';

import '../test_lab/fakes/fake_system.dart';
import '../test_lab/harness.dart';
import '../test_lab/widget_probe.dart';

/// True only when tests run on a device with the native runtime, e.g.
/// `dn test -d DEVICE_ID --dart-define=DN_DEVICE_TEST=true
/// test/plugins/system_bridge_test.dart`.
const _isDeviceRun = bool.fromEnvironment('DN_DEVICE_TEST');

const _systemApp = r'''
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_system/dartnative_system.dart';

Future<void> main() async {
  final info = await PackageInfo.fromPlatform();
  final supported = await AppBadgePlus.isSupported();

  await AppBadgePlus.updateBadge(3);
  final setBadge = await AppBadgePlus.isSupported();
  await AppBadgePlus.updateBadge(0);

  // The FFI layer mirrors the same badge writes.
  SystemFFIBindings.instance.updateBadge(7);

  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('app:${info.appName}'),
            Text('pkg:${info.packageName}'),
            Text('ver:${info.version}'),
            Text('build:${info.buildNumber}'),
            Text('supported:$supported'),
            Text('afterSet:$setBadge'),
          ],
        ),
      ),
    ),
  );
}
''';

void main() {
  group('dartnative_system bridge surface', () {
    test(
      'source bridges register PackageInfo + AppBadgePlus + FFI bindings',
      () {
        final classes = src_bridges.DartnativeSystemBridge.bridgeClasses();
        final names = classes.map((c) => c.name).toSet();
        expect(
          names,
          containsAll(<String>[
            'PackageInfo',
            'AppBadgePlus',
            'SystemFFIBindings',
          ]),
        );
      },
    );

    test('source bridge exposes the full dartnative_system API', () {
      final classes = src_bridges.DartnativeSystemBridge.bridgeClasses();
      final byName = {for (final c in classes) c.name: c};

      final info = byName['PackageInfo']!;
      expect(info.staticMethodSignatures.keys, contains('fromPlatform'));
      expect(
        info.getterSignatures.keys,
        containsAll(<String>[
          'appName',
          'packageName',
          'version',
          'buildNumber',
        ]),
      );

      final badge = byName['AppBadgePlus']!;
      expect(
        badge.staticMethodSignatures.keys,
        containsAll(<String>['isSupported', 'updateBadge']),
      );

      final ffi = byName['SystemFFIBindings']!;
      expect(
        ffi.methodSignatures.keys,
        containsAll(<String>['getPackageInfo', 'updateBadge']),
      );
      expect(ffi.staticMethodSignatures.keys, contains('loadSymbols'));
    });

    test('AST bridges mirror the source bridge surface (parity)', () {
      final src = src_bridges.DartnativeSystemBridge.bridgeClasses();
      final ast = ast_bridges.DartnativeSystemBridge.bridgeClasses();
      final srcByName = {for (final c in src) c.name: c};
      final astByName = {for (final c in ast) c.name: c};
      for (final entry in srcByName.entries) {
        final astClass = astByName[entry.key];
        expect(astClass, isNotNull, reason: 'AST bridge missing ${entry.key}');
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

  group('dartnative_system headless behavior (source mode)', () {
    late DnHarness harness;
    late FakeSystemHost fakeHost;

    setUp(() {
      fakeHost = FakeSystemHost();
      harness = DnHarness(
        onLog: (_) {},
        bridgeOverrides: [
          // The generator's combined registration MUST have run first so the
          // fake's fixed nativeTypes can shadow the real ones deterministically.
          gen.DartnativeGoBridges.register,
          (interpreter) => installFakeSystem(interpreter, fakeHost),
        ],
      );
    });

    tearDown(() {
      harness.dispose();
    });

    test('README flow: package info + badge set/clear round-trip', () async {
      final root = await harness.evaluate({'main.dart': _systemApp});

      expect(findText(root, 'app:HeadlessDemo'), isNotNull);
      expect(findText(root, 'pkg:com.example.headlessdemo'), isNotNull);
      expect(findText(root, 'ver:1.2.3'), isNotNull);
      expect(findText(root, 'build:42'), isNotNull);
      expect(findText(root, 'supported:true'), isNotNull);
      expect(findText(root, 'afterSet:true'), isNotNull);

      expect(
        fakeHost.badgeCalls,
        equals(<int>[3, 0, 7]),
        reason: 'badge writes must be recorded in order',
      );
      expect(fakeHost.badge, equals(7));
    });
  });

  group(
    'dartnative_system on-device (real FFI, no fake)',
    () {
      late DnHarness harness;

      setUp(() {
        // Deliberately NO bridgeOverrides: the guest talks to the real
        // platform FFI. Fails on the host — that is the point.
        harness = DnHarness(onLog: (_) {});
      });

      tearDown(() {
        harness.dispose();
      });

      test('real package info + badge round-trip', () async {
        final root = await harness.evaluate({'main.dart': _systemApp});
        expect(findText(root, 'supported:true'), isNotNull);
        expect(findText(root, 'afterSet:true'), isNotNull);
      });
    },
    skip: _isDeviceRun
        ? false
        : 'needs a device runtime: dn test -d <device-id> '
              '--dart-define=DN_DEVICE_TEST=true test/plugins/system_bridge_test.dart',
  );
}

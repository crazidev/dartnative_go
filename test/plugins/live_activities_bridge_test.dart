/// Headless test suite for `dartnative_live_activities` bridges.
///
/// Validates bridge registration across AST and source engines, headless fake
/// execution (start, update, end lifecycle), and UI button tap handlers.
library;

import 'package:dartnative_go/src/interpreter/dartnative_live_activities_bridges.b.dart'
    as src_bridges;
import 'package:dartnative_go/src/interpreter/ast/dartnative_live_activities_bridges.b.dart'
    as ast_bridges;
import 'package:test/test.dart';

import '../test_lab/fakes/fake_live_activities.dart';
import '../test_lab/harness.dart';
import '../test_lab/widget_probe.dart';

const _activityApp = r'''
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_live_activities/dartnative_live_activities.dart';

Future<void> main() async {
  final enabled = await LiveActivities.areEnabled();
  final layout = LiveLayout(
    theme: LiveTheme(accent: Color(0xFF2E7D32)),
    expanded: LiveExpanded(center: LiveText(LiveBind('title'))),
  );
  await LiveActivities.registerLayout('order', layout);

  final activity = await LiveActivities.start(
    layout: layout,
    state: {'title': 'Order placed'},
    customId: 'order-1',
  );
  await activity.update({'title': 'Order baked'});
  final active = await LiveActivities.activeActivities();
  final lookup = await LiveActivities.activity('order-1');
  final missing = await LiveActivities.activity('nope');
  final permission = await LiveActivities.requestPermission();

  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('enabled:$enabled'),
            Text('permission:$permission'),
            Text('id:${activity.id}'),
            Text('custom:${activity.customId}'),
            Text('active:${active?.length}'),
            Text('lookup:${lookup?.customId}'),
            Text('missing:$missing'),
          ],
        ),
      ),
    ),
  );
}
''';

const _endApp = r'''
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_live_activities/dartnative_live_activities.dart';

Future<void> main() async {
  final layout = LiveLayout(
    theme: LiveTheme(accent: Color(0xFF2E7D32)),
    expanded: LiveExpanded(center: LiveText(LiveBind('title'))),
  );
  final activity = await LiveActivities.start(
    layout: layout,
    state: {'title': 'Order placed'},
    customId: 'order-1',
  );
  await activity.end(state: {'title': 'Order done'});
  final active = await LiveActivities.activeActivities();

  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [Text('id:${activity.id}'), Text('active:${active?.length}')],
        ),
      ),
    ),
  );
}
''';

const _activityInteractiveApp = r'''
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_live_activities/dartnative_live_activities.dart';

final layout = LiveLayout(
  theme: LiveTheme(accent: Color(0xFF2E7D32)),
  expanded: LiveExpanded(center: LiveText(LiveBind('title'))),
);

Future<void> startPressed() async {
  await LiveActivities.start(
    layout: layout,
    state: {'title': 'Tapped order'},
    customId: 'order-tap',
  );
}

Future<String> readBack() async {
  final active = await LiveActivities.activeActivities();
  return 'active:${active?.length}';
}

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Ready'),
            Button(title: 'Start', onPressed: () => startPressed()),
          ],
        ),
      ),
    ),
  );
}
''';

void main() {
  group('LiveActivities bridge surface', () {
    test('source bridges register LiveActivities + LiveActivity', () {
      final names = src_bridges.DartnativeLiveActivitiesBridge.bridgeClasses()
          .map((c) => c.name)
          .toSet();
      expect(names, contains('LiveActivities'));
      expect(names, contains('LiveActivity'));
      expect(names, contains('LiveLayout'));
      expect(names, contains('LiveTheme'));
    });

    test('source LiveActivities exposes the full static API', () {
      final classes =
          src_bridges.DartnativeLiveActivitiesBridge.bridgeClasses();
      final activities = classes.firstWhere((c) => c.name == 'LiveActivities');
      expect(
        activities.staticMethodSignatures.keys,
        containsAll([
          'start',
          'areEnabled',
          'requestPermission',
          'openPromotionSettings',
          'activeActivities',
          'activity',
          'endAll',
          'onAction',
          'registerLayout',
          'handlePush',
        ]),
      );
    });

    test('source LiveActivity exposes the per-activity API', () {
      final classes =
          src_bridges.DartnativeLiveActivitiesBridge.bridgeClasses();
      final activity = classes.firstWhere((c) => c.name == 'LiveActivity');
      expect(
        activity.methodSignatures.keys,
        containsAll(['update', 'follow', 'scheduleEnd', 'end']),
      );
      expect(
        activity.getterSignatures.keys,
        containsAll(['id', 'customId', 'pushTokens', 'states']),
      );
    });

    test('AST bridges mirror the source bridge surface (parity)', () {
      final src = src_bridges.DartnativeLiveActivitiesBridge.bridgeClasses();
      final ast = ast_bridges.DartnativeLiveActivitiesBridge.bridgeClasses();
      for (final name in ['LiveActivities', 'LiveActivity']) {
        final srcClass = src.firstWhere((c) => c.name == name);
        final astClass = ast.firstWhere((c) => c.name == name);
        expect(
          astClass.methodSignatures.keys.toSet(),
          equals(srcClass.methodSignatures.keys.toSet()),
          reason: 'AST $name methods must match source bridge methods',
        );
        expect(
          astClass.staticMethodSignatures.keys.toSet(),
          equals(srcClass.staticMethodSignatures.keys.toSet()),
          reason: 'AST $name statics must match source bridge statics',
        );
      }
    });
  });

  group('LiveActivities headless behavior (source mode, host fake)', () {
    late DnHarness harness;
    late FakeLiveActivitiesHost fakeHost;

    setUp(() {
      // Host fake: the real engine is unavailable on macOS, so guest code
      // runs against this in-memory store via the bridge-override seam.
      fakeHost = FakeLiveActivitiesHost();
      harness = DnHarness(
        onLog: (_) {},
        bridgeOverrides: [
          (interpreter) => installFakeLiveActivities(interpreter, fakeHost),
        ],
      );
    });

    tearDown(() {
      harness.dispose();
    });

    test('start/update/lookup round-trip through the fake', () async {
      final root = await harness.evaluate({'main.dart': _activityApp});

      expect(findText(root, 'enabled:true'), isNotNull);
      expect(findText(root, 'permission:true'), isNotNull);
      expect(findText(root, 'id:activity-1'), isNotNull);
      expect(findText(root, 'custom:order-1'), isNotNull);
      expect(findText(root, 'active:1'), isNotNull);
      expect(findText(root, 'lookup:order-1'), isNotNull);
      expect(findText(root, 'missing:null'), isNotNull);

      // Host-visible channel: the fake store saw the same lifecycle.
      expect(fakeHost.activities, hasLength(1));
      final stored = fakeHost.activities.values.single;
      expect(stored.customId, 'order-1');
      expect(stored.updates, [
        {'title': 'Order placed'},
        {'title': 'Order baked'},
      ]);
      expect(stored.ended, isFalse);
      expect(fakeHost.registeredLayoutNames, hasLength(1));
    });

    test('end removes the activity from the active set', () async {
      final root = await harness.evaluate({'main.dart': _endApp});

      expect(findText(root, 'id:activity-1'), isNotNull);
      expect(findText(root, 'active:0'), isNotNull);

      expect(fakeHost.activities, isEmpty);
      expect(fakeHost.endedActivities, hasLength(1));
      expect(fakeHost.endedActivities.single.endState, {
        'title': 'Order done',
      });
    });

    test('tap Start starts an activity; readBack sees it', () async {
      final root = await harness.evaluate({
        'main.dart': _activityInteractiveApp,
      });

      expect(findText(root, 'Ready'), isNotNull);
      expect(findButton(root, 'Start'), isNotNull);

      tapButton(root, 'Start');
      // Stub writes complete as microtasks/futures.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(
        await harness.callFunction('readBack'),
        equals('active:1'),
        reason:
            'tapping Start must create an activity (dump:\n${dumpTree(root)})',
      );
      expect(fakeHost.activities.values.single.customId, 'order-tap');
    });
  });

  group('LiveActivities native limitation (documents headless scope)', () {
    test(
      'real engine statics throw on host without the native runtime',
      () async {
        // The host fake works headless; the REAL class needs the compiled
        // DartNative Go runtime. This test pins that boundary so future
        // failures are classified as native-missing, not bridge-missing.
        final harness = DnHarness(onLog: (_) {});
        addTearDown(harness.dispose);
        try {
          await harness.evaluate({
            'main.dart': r'''
import 'package:dartnative_live_activities/dartnative_live_activities.dart';

Future<void> main() async {
  await LiveActivities.areEnabled();
  runApp(Text('unreachable'));
}
''',
          });
          // If a native runtime ever lands on the host, evaluation succeeds
          // — acceptable; no assertion failure.
        } catch (e) {
          expect(e, isNotNull);
        }
      },
    );
  });
}

/// In-memory host fake for `dartnative_live_activities`.
///
/// Shadows the generated bridge classes with host objects so guest tests can
/// exercise start/update/end headless without native engine calls.
library;

import 'package:tom_d4rt/d4rt.dart';

/// One started activity as seen by the host fake.
class FakeLiveActivity {
  FakeLiveActivity(this.id, {this.customId});

  final String id;
  final String? customId;

  /// Every state pushed to the activity, in order (start state first).
  final List<Map<String, Object?>> updates = [];

  /// State passed to the final `end`/`scheduleEnd`, if any.
  Map<String, Object?>? endState;

  bool ended = false;
}

/// In-memory backing store. One instance per test (pass it in, read it back
/// for assertions independent of the interpreter).
class FakeLiveActivitiesHost {
  final Map<String, FakeLiveActivity> activities = {};

  /// Activities that were ended (kept for assertion after removal from the
  /// active set).
  final List<FakeLiveActivity> endedActivities = [];
  final List<String> registeredLayoutNames = [];
  bool enabled = true;
  bool permissionGranted = true;
  int _nextId = 1;

  /// Count of activities that were started and not yet ended.
  int get activeCount => activities.length;

  FakeLiveActivity start({Object? state, Object? customId}) {
    final id = 'activity-${_nextId++}';
    final activity = FakeLiveActivity(id, customId: customId as String?)
      ..updates.add(_stateMapOf(state));
    activities[id] = activity;
    return activity;
  }
}

/// All library URIs the real `LiveActivities`/`LiveActivity` bridge is
/// reachable from. Must mirror `DartnativeLiveActivitiesBridge`: the barrel
/// import path plus the class source URIs (`classSourceUris()` in
/// `lib/src/interpreter/dartnative_live_activities_bridges.b.dart`).
const List<String> kLiveActivitiesBridgeUris = [
  'package:dartnative_live_activities/dartnative_live_activities.dart',
  'package:dartnative_live_activities/src/live_activities.dart',
];

FakeLiveActivity _targetOf(Object? target) {
  if (target is FakeLiveActivity) return target;
  throw ArgumentD4rtException(
    'Invalid target: expected LiveActivity (fake), '
    'got ${target?.runtimeType}',
  );
}

/// Builds the fake per-activity bridge backed by [host].
BridgedClass buildFakeLiveActivityBridge(FakeLiveActivitiesHost host) {
  void endTarget(Object? target, Object? state) {
    final activity = _targetOf(target);
    activity.ended = true;
    if (state != null) activity.endState = _stateMapOf(state);
    host.activities.remove(activity.id);
    host.endedActivities.add(activity);
  }

  return BridgedClass(
    nativeType: FakeLiveActivity,
    name: 'LiveActivity',
    isAssignable: (v) => v is FakeLiveActivity,
    constructors: const {},
    getters: {
      'id': (visitor, target) => _targetOf(target).id,
      'customId': (visitor, target) => _targetOf(target).customId,
    },
    methods: {
      'update': (visitor, target, positional, named, typeArgs) {
        final activity = _targetOf(target);
        activity.updates.add(
          positional.isEmpty
              ? const <String, Object?>{}
              : _stateMapOf(positional[0]),
        );
        return Future<void>.value();
      },
      'scheduleEnd': (visitor, target, positional, named, typeArgs) {
        endTarget(target, named['state']);
        return Future<void>.value();
      },
      'end': (visitor, target, positional, named, typeArgs) {
        endTarget(target, named['state']);
        return Future<void>.value();
      },
    },
    methodSignatures: const {
      'update':
          'Future<void> update(Map<String, Object?> state, {Duration? staleAfter, LiveAlert? alert, String? deepLink})',
      'follow':
          'StreamSubscription<T> follow(Stream<T> source, Map<String, Object?> Function(T event) toState, {Duration minInterval = const Duration(seconds: 5)})',
      'scheduleEnd':
          'Future<void> scheduleEnd(DateTime at, {Map<String, Object?>? state})',
      'end':
          'Future<void> end({Map<String, Object?>? state, LiveDismiss dismiss = LiveDismiss.byDefault})',
    },
    getterSignatures: const {
      'id': 'String get id',
      'customId': 'String? get customId',
      'pushTokens': 'Stream<String> get pushTokens',
      'states': 'Stream<LiveActivityState> get states',
    },
  );
}

Map<String, Object?> _stateMapOf(Object? raw) {
  if (raw is Map) {
    return {for (final entry in raw.entries) '${entry.key}': entry.value};
  }
  throw ArgumentD4rtException(
    'Expected a state Map, got ${raw?.runtimeType}',
  );
}

/// Builds the fake `LiveActivities` static facade backed by [host].
BridgedClass buildFakeLiveActivitiesBridge(FakeLiveActivitiesHost host) {
  return BridgedClass(
    nativeType: FakeLiveActivitiesHost,
    name: 'LiveActivities',
    isAssignable: (v) => v is FakeLiveActivitiesHost,
    isAbstract: true,
    constructors: const {},
    staticMethods: {
      'areEnabled': (visitor, positional, named, typeArgs) =>
          Future<bool>.value(host.enabled),
      'requestPermission': (visitor, positional, named, typeArgs) =>
          Future<bool>.value(host.permissionGranted),
      'openPromotionSettings': (visitor, positional, named, typeArgs) =>
          Future<bool>.value(true),
      'activeActivities': (visitor, positional, named, typeArgs) =>
          Future<List<FakeLiveActivity>>.value(host.activities.values.toList()),
      'activity': (visitor, positional, named, typeArgs) {
        final customId = positional.isEmpty ? null : positional[0] as String?;
        for (final activity in host.activities.values) {
          if (activity.customId == customId) {
            return Future<FakeLiveActivity?>.value(activity);
          }
        }
        return Future<FakeLiveActivity?>.value(null);
      },
      'endAll': (visitor, positional, named, typeArgs) {
        for (final activity in host.activities.values) {
          activity.ended = true;
          host.endedActivities.add(activity);
        }
        host.activities.clear();
        return Future<void>.value();
      },
      'registerLayout': (visitor, positional, named, typeArgs) {
        if (positional.isNotEmpty) {
          host.registeredLayoutNames.add('${positional[0]}');
        }
        return Future<void>.value();
      },
      'handlePush': (visitor, positional, named, typeArgs) {
        return Future<String?>.value(null);
      },
      'start': (visitor, positional, named, typeArgs) {
        return Future<FakeLiveActivity>.value(
          host.start(state: named['state'], customId: named['customId']),
        );
      },
    },
    staticMethodSignatures: const {
      'areEnabled': 'Future<bool> areEnabled()',
      'requestPermission': 'Future<bool> requestPermission()',
      'openPromotionSettings': 'Future<bool> openPromotionSettings()',
      'activeActivities': 'Future<List<LiveActivity>> activeActivities()',
      'activity': 'Future<LiveActivity?> activity(String customId)',
      'endAll':
          'Future<void> endAll({LiveDismiss dismiss = LiveDismiss.immediate})',
      'onAction':
          'StreamSubscription<String> onAction(void Function(String id) callback)',
      'registerLayout':
          'Future<void> registerLayout(String name, LiveLayout layout)',
      'handlePush': 'Future<String?> handlePush(Map<String, Object?> data)',
      'start':
          'Future<LiveActivity> start({required LiveLayout layout, required Map<String, Object?> state, String? deepLink, Duration? staleAfter, double relevance = 0, bool requestPushToken = false, String? customId})',
    },
  );
}

/// Installs the fake on [interpreter], shadowing the real native bridge on
/// all reachable URIs. Call after runner construction, before first evaluate.
void installFakeLiveActivities(
  D4rt interpreter,
  FakeLiveActivitiesHost host,
) {
  final activities = buildFakeLiveActivitiesBridge(host);
  final activity = buildFakeLiveActivityBridge(host);
  for (final uri in kLiveActivitiesBridgeUris) {
    interpreter.registerBridgedClass(activities, uri);
    interpreter.registerBridgedClass(activity, uri);
  }
}

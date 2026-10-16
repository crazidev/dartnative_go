import 'dart:developer';
import 'package:tom_d4rt_ast/runtime.dart';

/// Bridge for `Timeline` / `TimelineTask` (part of `dart:developer`).
///
/// Ported from upstream `d4rt` (`lib/src/stdlib/developer/timeline.dart`),
/// adapted to `tom_d4rt_ast` bridge signatures (4-arg static adapters,
/// 5-arg instance adapters, `isAssignable` instead of `isSubtypeOfFunc`,
/// `RuntimeD4rtException` instead of `RuntimeError`).
class TimelineDeveloper {
  static BridgedClass get definition => BridgedClass(
    nativeType: Timeline,
    name: 'Timeline',
    isAssignable: (v) => v is Timeline,
    staticGetters: {'now': (visitor) => Timeline.now},
    staticMethods: {
      'startSync': (visitor, positionalArgs, namedArgs, _) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! String) {
          throw RuntimeD4rtException(
            'Timeline.startSync expects a String name.',
          );
        }
        final name = positionalArgs[0] as String;
        final arguments = namedArgs['arguments'] as Map?;
        Timeline.startSync(
          name,
          arguments: arguments != null ? Map.from(arguments) : null,
        );
        return null;
      },
      'finishSync': (visitor, positionalArgs, namedArgs, _) {
        Timeline.finishSync();
        return null;
      },
      'timeSync': (visitor, positionalArgs, namedArgs, _) {
        if (positionalArgs.length < 2 || positionalArgs[0] is! String) {
          throw RuntimeD4rtException(
            'Timeline.timeSync expects a String name and a function callback.',
          );
        }
        final name = positionalArgs[0] as String;
        final callback = positionalArgs[1];
        final arguments = namedArgs['arguments'] as Map?;
        return Timeline.timeSync(
          name,
          () {
            if (callback is InterpretedFunction) {
              return callback.call(visitor, []);
            } else if (callback is Callable) {
              return callback.call(visitor, [], {});
            } else if (callback is Function) {
              return (callback as dynamic)();
            }
            throw RuntimeD4rtException(
              'Invalid callback for Timeline.timeSync.',
            );
          },
          arguments: arguments != null ? Map.from(arguments) : null,
        );
      },
      'instantSync': (visitor, positionalArgs, namedArgs, _) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! String) {
          throw RuntimeD4rtException(
            'Timeline.instantSync expects a String name.',
          );
        }
        final name = positionalArgs[0] as String;
        final arguments = namedArgs['arguments'] as Map?;
        Timeline.instantSync(
          name,
          arguments: arguments != null ? Map.from(arguments) : null,
        );
        return null;
      },
      'now': (visitor, positionalArgs, namedArgs, _) {
        return Timeline.now;
      },
    },
  );
}

class TimelineTaskDeveloper {
  static BridgedClass get definition => BridgedClass(
    nativeType: TimelineTask,
    name: 'TimelineTask',
    isAssignable: (v) => v is TimelineTask,
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        final parent = namedArgs['parent'] as TimelineTask?;
        final filterKey = namedArgs['filterKey'] as String?;
        return TimelineTask(parent: parent, filterKey: filterKey);
      },
      'withTaskId': (visitor, positionalArgs, namedArgs) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! int) {
          throw RuntimeD4rtException(
            'TimelineTask.withTaskId expects an int taskId.',
          );
        }
        final filterKey = namedArgs['filterKey'] as String?;
        return TimelineTask.withTaskId(
          positionalArgs[0] as int,
          filterKey: filterKey,
        );
      },
    },
    methods: {
      'start': (visitor, target, positionalArgs, namedArgs, _) {
        if (target is TimelineTask &&
            positionalArgs.isNotEmpty &&
            positionalArgs[0] is String) {
          final name = positionalArgs[0] as String;
          final arguments = namedArgs['arguments'] as Map?;
          target.start(
            name,
            arguments: arguments != null ? Map.from(arguments) : null,
          );
          return null;
        }
        throw RuntimeD4rtException('TimelineTask.start expects a String name.');
      },
      'finish': (visitor, target, positionalArgs, namedArgs, _) {
        if (target is TimelineTask) {
          final arguments = namedArgs['arguments'] as Map?;
          target.finish(
            arguments: arguments != null ? Map.from(arguments) : null,
          );
          return null;
        }
        throw RuntimeD4rtException('Target is not a TimelineTask for finish.');
      },
      'instant': (visitor, target, positionalArgs, namedArgs, _) {
        if (target is TimelineTask &&
            positionalArgs.isNotEmpty &&
            positionalArgs[0] is String) {
          final name = positionalArgs[0] as String;
          final arguments = namedArgs['arguments'] as Map?;
          target.instant(
            name,
            arguments: arguments != null ? Map.from(arguments) : null,
          );
          return null;
        }
        throw RuntimeD4rtException(
          'TimelineTask.instant expects a String name.',
        );
      },
      'pass': (visitor, target, positionalArgs, namedArgs, _) {
        if (target is TimelineTask) {
          return target.pass();
        }
        throw RuntimeD4rtException('Target is not a TimelineTask for pass.');
      },
      'toString': (visitor, target, positionalArgs, namedArgs, _) {
        return (target as TimelineTask).toString();
      },
    },
    getters: {
      'hashCode': (visitor, target) => (target as TimelineTask).hashCode,
      'runtimeType': (visitor, target) => (target as TimelineTask).runtimeType,
    },
  );
}

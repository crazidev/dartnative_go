import 'dart:developer';
import 'package:tom_d4rt/d4rt.dart';

/// Bridge for `Flow` (part of `dart:developer`).
///
/// Ported from upstream `d4rt` (`lib/src/stdlib/developer/flow.dart`).
class FlowDeveloper {
  static BridgedClass get definition => BridgedClass(
    nativeType: Flow,
    name: 'Flow',
    isAssignable: (v) => v is Flow,
    staticMethods: {
      'begin': (visitor, positionalArgs, namedArgs, _) {
        final id =
            namedArgs['id'] as int? ??
            (positionalArgs.isNotEmpty ? positionalArgs[0] as int? : null);
        return id != null ? Flow.begin(id: id) : Flow.begin();
      },
      'step': (visitor, positionalArgs, namedArgs, _) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! int) {
          throw RuntimeD4rtException('Flow.step requires an int id.');
        }
        return Flow.step(positionalArgs[0] as int);
      },
      'end': (visitor, positionalArgs, namedArgs, _) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! int) {
          throw RuntimeD4rtException('Flow.end requires an int id.');
        }
        return Flow.end(positionalArgs[0] as int);
      },
    },
    constructors: {
      'begin': (visitor, positionalArgs, namedArgs) {
        final id =
            namedArgs['id'] as int? ??
            (positionalArgs.isNotEmpty ? positionalArgs[0] as int? : null);
        return id != null ? Flow.begin(id: id) : Flow.begin();
      },
      'step': (visitor, positionalArgs, namedArgs) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! int) {
          throw RuntimeD4rtException('Flow.step requires an int id.');
        }
        return Flow.step(positionalArgs[0] as int);
      },
      'end': (visitor, positionalArgs, namedArgs) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! int) {
          throw RuntimeD4rtException('Flow.end requires an int id.');
        }
        return Flow.end(positionalArgs[0] as int);
      },
    },
    getters: {
      'id': (visitor, target) => (target as Flow).id,
      'hashCode': (visitor, target) => (target as Flow).hashCode,
      'runtimeType': (visitor, target) => (target as Flow).runtimeType,
    },
  );
}

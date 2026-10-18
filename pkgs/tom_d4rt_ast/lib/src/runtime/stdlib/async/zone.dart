import 'dart:async';
import 'package:tom_d4rt_ast/runtime.dart';

/// Bridge for `dart:async`'s [Zone].
///
/// Deliberately tight: only the ambient observation and delegation members
/// (`current`, `handleUncaughtError`, `run`/`runUnary`/`runBinary`, `fork`,
/// `parent`). These execute honestly atop the host zone —
/// guest async code already runs on host microtasks/timers, so `Zone.current`
/// inside a guest callback is a real zone and routing an error through it
/// (dio's interceptor error path) behaves as on the VM.
///
/// The interception members (`runZoned`, `runZonedGuarded`) stay unbridged:
/// a guest-installed zone would claim control flow, scheduling and error
/// handling the interpreter owns, so a bridge there could only be a no-op
/// shell. See `unbridged_reasons.dart`.
class ZoneAsync {
  static void register(Environment environment) {
    environment.defineBridge(definition);
  }

  static BridgedClass get definition => BridgedClass(
    nativeType: Zone,
    name: 'Zone',
    isAssignable: (v) => v is Zone,
    staticGetters: {
      'current': (visitor) => Zone.current,
      'root': (visitor) => Zone.root,
    },
    methods: {
      'handleUncaughtError': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 2) {
          throw RuntimeD4rtException(
            'Zone.handleUncaughtError expects (Object error, StackTrace stackTrace).',
          );
        }
        (target as Zone).handleUncaughtError(
          positionalArgs[0]!,
          positionalArgs[1] as StackTrace,
        );
        return null;
      },
      'run': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 1) {
          throw RuntimeD4rtException(
            'Zone.run expects one function argument.',
          );
        }
        final fn = positionalArgs[0];
        if (fn is Callable) {
          return (target as Zone).run(() => fn.call(visitor, []));
        }
        if (fn is Function) return (target as Zone).run(() => fn());
        throw RuntimeD4rtException(
          'Argument to Zone.run must be a function.',
        );
      },
      'runUnary': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 2) {
          throw RuntimeD4rtException(
            'Zone.runUnary expects (function, argument).',
          );
        }
        final fn = positionalArgs[0];
        final arg = positionalArgs[1];
        if (fn is Callable) {
          return (target as Zone).runUnary((a) => fn.call(visitor, [a]), arg);
        }
        if (fn is Function) {
          return (target as Zone).runUnary((a) => fn(a), arg);
        }
        throw RuntimeD4rtException(
          'Argument to Zone.runUnary must be a function.',
        );
      },
      'runBinary': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 3) {
          throw RuntimeD4rtException(
            'Zone.runBinary expects (function, arg1, arg2).',
          );
        }
        final fn = positionalArgs[0];
        if (fn is Callable) {
          return (target as Zone).runBinary(
            (a, b) => fn.call(visitor, [a, b]),
            positionalArgs[1],
            positionalArgs[2],
          );
        }
        if (fn is Function) {
          return (target as Zone).runBinary(
            (a, b) => fn(a, b),
            positionalArgs[1],
            positionalArgs[2],
          );
        }
        throw RuntimeD4rtException(
          'Argument to Zone.runBinary must be a function.',
        );
      },
      'fork': (visitor, target, positionalArgs, namedArgs, _) {
        // Named zone-specification parameters mirror the SDK; values pass
        // through to the host zone untouched.
        ZoneSpecification? specification;
        final spec = namedArgs['specification'];
        if (spec is ZoneSpecification) specification = spec;
        Map<dynamic, dynamic>? zoneValues;
        final values = namedArgs['zoneValues'];
        if (values is Map) zoneValues = values;
        return (target as Zone).fork(
          specification: specification,
          zoneValues: zoneValues,
        );
      },
    },
    getters: {
      'parent': (visitor, target) => (target as Zone).parent,
      'hashCode': (visitor, target) => (target as Zone).hashCode,
      'runtimeType': (visitor, target) => (target as Zone).runtimeType,
    },
  );
}

import 'dart:developer';
import 'package:tom_d4rt/d4rt.dart';

/// Bridge for `UserTag` (part of `dart:developer`).
///
/// Ported from upstream `d4rt` (`lib/src/stdlib/developer/user_tag.dart`).
class UserTagDeveloper {
  static BridgedClass get definition => BridgedClass(
    nativeType: UserTag,
    name: 'UserTag',
    isAssignable: (v) => v is UserTag,
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! String) {
          throw RuntimeD4rtException(
            'UserTag constructor expects a String label.',
          );
        }
        return UserTag(positionalArgs[0] as String);
      },
    },
    staticGetters: {'defaultTag': (visitor) => UserTag.defaultTag},
    staticMethods: {
      'defaultTag': (visitor, positionalArgs, namedArgs, _) =>
          UserTag.defaultTag,
    },
    methods: {
      'makeCurrent': (visitor, target, positionalArgs, namedArgs, _) {
        if (target is UserTag) {
          return target.makeCurrent();
        }
        throw RuntimeD4rtException('Target is not a UserTag for makeCurrent.');
      },
      'toString': (visitor, target, positionalArgs, namedArgs, _) {
        return (target as UserTag).toString();
      },
    },
    getters: {
      'label': (visitor, target) {
        if (target is UserTag) {
          return target.label;
        }
        throw RuntimeD4rtException(
          "Target is not a UserTag for getter 'label'.",
        );
      },
      'hashCode': (visitor, target) => (target as UserTag).hashCode,
      'runtimeType': (visitor, target) => (target as UserTag).runtimeType,
    },
  );
}

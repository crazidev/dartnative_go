/// AST-engine host fake for `dartnative_shared_preferences`.
///
/// The source-engine fake (`fake_shared_preferences.dart`) registers a
/// `tom_d4rt` `BridgedClass`; the analyzer-free engine has its own type, so it
/// needs its own fake. Same contract: register an in-memory
/// `SharedPreferences` under the SAME class name and library URIs as the
/// generated AST bridge, so guest code keeps its real import path.
///
/// Install via `DnHarness(astBridgeOverrides: [installFakeSharedPreferencesAst(host)])`.
library;

import 'package:tom_d4rt_ast/d4rt.dart';

/// In-memory backing store. Pass it in so a test can assert on the state the
/// guest wrote, independent of the interpreter.
class FakeSharedPreferencesAstHost {
  final Map<String, Object?> store = {};
}

/// Library URIs the generated AST `SharedPreferences` bridge is reachable
/// from (barrel + re-export targets).
const List<String> kSharedPreferencesAstBridgeUris = [
  'package:dartnative_shared_preferences/dartnative_shared_preferences.dart',
  'package:dartnative_shared_preferences/src/shared_preferences.dart',
  'package:dartnative_shared_preferences/src/prefs_bindings.dart',
];

/// Builds the fake `SharedPreferences` bridge backed by [host].
BridgedClass buildFakeSharedPreferencesAstBridge(
  FakeSharedPreferencesAstHost host,
) {
  FakeSharedPreferencesAstHost targetOf(Object? target) {
    if (target is FakeSharedPreferencesAstHost) return target;
    throw ArgumentD4rtException(
      'Invalid target: expected SharedPreferences (fake), '
      'got ${target?.runtimeType}',
    );
  }

  String keyOf(List<Object?> positional) {
    if (positional.isEmpty || positional[0] is! String) {
      throw ArgumentD4rtException('Missing required String argument "key"');
    }
    return positional[0] as String;
  }

  return BridgedClass(
    nativeType: FakeSharedPreferencesAstHost,
    name: 'SharedPreferences',
    isAssignable: (v) => v is FakeSharedPreferencesAstHost,
    constructors: const {},
    methods: {
      'containsKey': (visitor, target, positional, named, typeArgs) =>
          targetOf(target).store.containsKey(keyOf(positional)),
      'getString': (visitor, target, positional, named, typeArgs) =>
          targetOf(target).store[keyOf(positional)] as String?,
      'getInt': (visitor, target, positional, named, typeArgs) =>
          targetOf(target).store[keyOf(positional)] as int?,
      'getDouble': (visitor, target, positional, named, typeArgs) =>
          targetOf(target).store[keyOf(positional)] as double?,
      'getBool': (visitor, target, positional, named, typeArgs) =>
          targetOf(target).store[keyOf(positional)] as bool?,
      'getStringList': (visitor, target, positional, named, typeArgs) {
        final v = targetOf(target).store[keyOf(positional)];
        return v == null ? null : List<String>.from(v as List);
      },
      'setString': (visitor, target, positional, named, typeArgs) {
        targetOf(target).store[keyOf(positional)] = positional[1] as String;
        return Future.value(true);
      },
      'setInt': (visitor, target, positional, named, typeArgs) {
        targetOf(target).store[keyOf(positional)] = positional[1] as int;
        return Future.value(true);
      },
      'setDouble': (visitor, target, positional, named, typeArgs) {
        targetOf(target).store[keyOf(positional)] = positional[1] as double;
        return Future.value(true);
      },
      'setBool': (visitor, target, positional, named, typeArgs) {
        targetOf(target).store[keyOf(positional)] = positional[1] as bool;
        return Future.value(true);
      },
      'setStringList': (visitor, target, positional, named, typeArgs) {
        targetOf(target).store[keyOf(positional)] = List<String>.from(
          positional[1] as List,
        );
        return Future.value(true);
      },
      'remove': (visitor, target, positional, named, typeArgs) {
        targetOf(target).store.remove(keyOf(positional));
        return Future.value(true);
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        targetOf(target).store.clear();
        return Future.value(true);
      },
      'reload': (visitor, target, positional, named, typeArgs) =>
          Future.value(null),
    },
    staticMethods: {
      'getInstance': (visitor, positional, named, typeArgs) =>
          Future.value(host),
    },
    methodSignatures: const {
      'containsKey': 'bool containsKey(String key)',
      'getString': 'String? getString(String key)',
      'getInt': 'int? getInt(String key)',
      'getDouble': 'double? getDouble(String key)',
      'getBool': 'bool? getBool(String key)',
      'getStringList': 'List<String>? getStringList(String key)',
      'setString': 'Future<bool> setString(String key, String value)',
      'setInt': 'Future<bool> setInt(String key, int value)',
      'setDouble': 'Future<bool> setDouble(String key, double value)',
      'setBool': 'Future<bool> setBool(String key, bool value)',
      'setStringList':
          'Future<bool> setStringList(String key, List<String> value)',
      'remove': 'Future<bool> remove(String key)',
      'clear': 'Future<bool> clear()',
      'reload': 'Future<void> reload()',
    },
    staticMethodSignatures: const {
      'getInstance': 'Future<SharedPreferences> getInstance()',
    },
  );
}

/// Returns an override for `DnHarness(astBridgeOverrides: [...])`.
void Function(D4rtRunner runner) installFakeSharedPreferencesAst(
  FakeSharedPreferencesAstHost host,
) {
  final fake = buildFakeSharedPreferencesAstBridge(host);
  return (runner) {
    for (final uri in kSharedPreferencesAstBridgeUris) {
      runner.registerBridgedClass(fake, uri);
    }
  };
}

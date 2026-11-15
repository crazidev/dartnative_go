/// Host-side fake for `dartnative_shared_preferences`.
///
/// The real plugin reaches the platform store over FFI, which is unavailable
/// on the host VM (`Unsupported operation: ... is not supported on macos`).
/// This fake registers an in-memory `BridgedClass` under the SAME class name
/// (`SharedPreferences`) and library URIs as the generated bridge, so guest
/// code under test keeps its real import path while reads/writes hit a plain
/// `Map`. Last registration wins — install AFTER the runner is constructed
/// (see `DnHarness.bridgeOverrides`) and BEFORE the first `evaluate`, while
/// no bridged module env has been built yet.
///
/// Pattern for future plugins: one `test/test_lab/fakes/fake_<plugin>.dart`
/// per native plugin, installed the same way.
library;

import 'package:tom_d4rt/d4rt.dart';

/// In-memory backing store. One instance per test (pass it in, read it back
/// for assertions independent of the interpreter).
class FakeSharedPreferencesHost {
  final Map<String, Object?> store = {};
}

/// All library URIs the real `SharedPreferences` bridge is reachable from.
/// Must mirror `DartnativeSharedPreferencesBridge`: the barrel, plus the
/// re-export targets merged into the barrel module env
/// (`bridgeReExports()` in
/// `lib/src/interpreter/dartnative_shared_preferences_bridges.b.dart`).
const List<String> kSharedPreferencesBridgeUris = [
  'package:dartnative_shared_preferences/dartnative_shared_preferences.dart',
  'package:dartnative_shared_preferences/src/shared_preferences.dart',
  'package:dartnative_shared_preferences/src/prefs_bindings.dart',
];

/// Builds the fake `SharedPreferences` bridge backed by [host].
BridgedClass buildFakeSharedPreferencesBridge(FakeSharedPreferencesHost host) {
  FakeSharedPreferencesHost targetOf(Object? target) {
    if (target is FakeSharedPreferencesHost) return target;
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
    nativeType: FakeSharedPreferencesHost,
    name: 'SharedPreferences',
    isAssignable: (v) => v is FakeSharedPreferencesHost,
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

/// Installs the fake on [interpreter], shadowing the real FFI bridge on all
/// reachable URIs. Call after runner construction, before first evaluate.
void installFakeSharedPreferences(
  D4rt interpreter,
  FakeSharedPreferencesHost host,
) {
  final fake = buildFakeSharedPreferencesBridge(host);
  for (final uri in kSharedPreferencesBridgeUris) {
    interpreter.registerBridgedClass(fake, uri);
  }
}

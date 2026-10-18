// D4rt Bridge - Generated file, do not edit
// Sources: 2 files
// Generated: 2026-10-17T21:07:44.257331 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'dart:ffi';

import 'package:dartnative_shared_preferences/src/prefs_bindings.dart' as $dartnative_shared_preferences_1;
import 'package:dartnative_shared_preferences/src/shared_preferences.dart' as $dartnative_shared_preferences_2;
import 'package:ffi/src/utf8.dart' as $ffi_1;

/// Bridge class for dartnative_shared_preferences module.
class DartnativeSharedPreferencesBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createSharedPreferencesBridge(),
      _createPrefsBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'SharedPreferences': _createSharedPreferencesBridge,
      'PrefsBindings': _createPrefsBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'SharedPreferences': $dartnative_shared_preferences_2.SharedPreferences,
      'PrefsBindings': $dartnative_shared_preferences_1.PrefsBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'SharedPreferences': 'package:dartnative_shared_preferences/src/shared_preferences.dart',
      'PrefsBindings': 'package:dartnative_shared_preferences/src/prefs_bindings.dart',
    };
  }

  /// Returns a map of class names to their flattened (transitive)
  /// native supertype names (superclasses, interfaces and mixins).
  ///
  /// Fed to `BridgedClass.registerSupertypes` so interpreted subclasses
  /// of bridged classes pass `is`/subtype checks against bridged
  /// ancestors and the interface-proxy supertype walk resolves up the
  /// chain.
  static Map<String, List<String>> classSupertypes() {
    return {
    };
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {
    };
  }

  /// Returns the list of function typedef names declared in this library.
  ///
  /// Function typedefs like `typedef VoidCallback = void Function()` are
  /// registered so that they can be used as type arguments in D4rt scripts.
  static List<String> functionTypedefs() {
    return [
      '_GetStringDart',
      '_SetStringDart',
      '_KeyOnlyDart',
      '_NoArgDart',
      '_ContainsDart',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
    };
  }

  /// Returns all bridged extension definitions.
  static List<BridgedExtensionDefinition> bridgedExtensions() {
    return [
    ];
  }

  /// Returns a map of extension identifiers to their canonical source URIs.
  static Map<String, String> extensionSourceUris() {
    return {
    };
  }

  /// GEN-107: Library re-exports declared by the bridged source
  /// libraries. Each tuple mirrors a Dart `export '…'` directive.
  /// Consumed by `registerBridges` via `D4rt.registerLibraryReExport`
  /// (mirrored on `D4rtRunner` in tom_d4rt_ast).
  static List<({String source, String target, Set<String>? show, Set<String>? hide})>
  bridgeReExports() {
    return [
      (source: 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart', target: 'package:dartnative_shared_preferences/src/shared_preferences.dart', show: null, hide: null),
      (source: 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart', target: 'package:dartnative_shared_preferences/src/prefs_bindings.dart', show: {'PrefsBindings'}, hide: null),
    ];
  }

  /// Registers all bridges with an interpreter.
  ///
  /// [importPath] is the package import path that D4rt scripts will use
  /// to access these classes (e.g., 'package:tom_build/tom.dart').
  static void registerBridges(D4rt interpreter, String importPath) {
    // Step #17 — register deferred factory thunks (not pre-built
    // BridgedClass objects): a script touching N of the M classes
    // materializes ≈N (each thunk builds its class on first resolve).
    final classThunks = bridgeClassThunks();
    final classTypes = bridgeClassTypes();
    final classSources = classSourceUris();
    for (final entry in classThunks.entries) {
      interpreter.registerBridgedClassLazy(
        entry.key,
        classTypes[entry.key]!,
        entry.value,
        importPath,
        sourceUri: classSources[entry.key],
      );
    }

    // Register the flattened native supertype table so
    // interpreted subclasses pass subtype checks against bridged
    // ancestors. Idempotent — safe to call per barrel.
    BridgedClass.registerSupertypes(classSupertypes());

    // Register function typedefs for type resolution
    final typedefs = functionTypedefs();
    for (final name in typedefs) {
      interpreter.registerFunctionTypedef(name, importPath);
    }

    // GEN-107: Register library re-exports
    for (final r in bridgeReExports()) {
      interpreter.registerLibraryReExport(r.source, r.target, show: r.show, hide: r.hide);
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {};
  }

  /// Returns a map of global function names to their canonical source URIs.
  static Map<String, String> globalFunctionSourceUris() {
    return {};
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {};
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative_shared_preferences/src/prefs_bindings.dart',
      'package:dartnative_shared_preferences/src/shared_preferences.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart';";
  }

  /// Returns barrel import URIs for sub-packages discovered through re-exports.
  ///
  /// When a module follows re-exports into sub-packages (e.g., dcli re-exports
  /// dcli_core), D4rt scripts may import those sub-packages directly.
  /// These barrels need to be registered with the interpreter separately
  /// so that module resolution finds content for those URIs.
  static List<String> subPackageBarrels() {
    return [];
  }

}

// =============================================================================
// SharedPreferences Bridge
// =============================================================================

BridgedClass _createSharedPreferencesBridge() {
  return BridgedClass(
    nativeType: $dartnative_shared_preferences_2.SharedPreferences,
    name: 'SharedPreferences',
    isAssignable: (v) => v is $dartnative_shared_preferences_2.SharedPreferences,
    constructors: {
    },
    methods: {
      'containsKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 1, 'containsKey');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'containsKey');
        return t.containsKey(key);
      },
      'getString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 1, 'getString');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'getString');
        return t.getString(key);
      },
      'getInt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 1, 'getInt');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'getInt');
        return t.getInt(key);
      },
      'getDouble': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 1, 'getDouble');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'getDouble');
        return t.getDouble(key);
      },
      'getBool': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 1, 'getBool');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'getBool');
        return t.getBool(key);
      },
      'getStringList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 1, 'getStringList');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'getStringList');
        return t.getStringList(key);
      },
      'setString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 2, 'setString');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'setString');
        final value = D4.getRequiredArg<String>(positional, 1, 'value', 'setString');
        return t.setString(key, value);
      },
      'setInt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 2, 'setInt');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'setInt');
        final value = D4.getRequiredArg<int>(positional, 1, 'value', 'setInt');
        return t.setInt(key, value);
      },
      'setDouble': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 2, 'setDouble');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'setDouble');
        final value = D4.getRequiredArg<double>(positional, 1, 'value', 'setDouble');
        return t.setDouble(key, value);
      },
      'setBool': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 2, 'setBool');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'setBool');
        final value = D4.getRequiredArg<bool>(positional, 1, 'value', 'setBool');
        return t.setBool(key, value);
      },
      'setStringList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 2, 'setStringList');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'setStringList');
        if (positional.length <= 1) {
          throw ArgumentError('setStringList: Missing required argument "value" at position 1');
        }
        final value = D4.coerceList<String>(positional[1], 'value');
        return t.setStringList(key, value);
      },
      'remove': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        D4.requireMinArgs(positional, 1, 'remove');
        final key = D4.getRequiredArg<String>(positional, 0, 'key', 'remove');
        return t.remove(key);
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        return t.clear();
      },
      'reload': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_2.SharedPreferences>(target, 'SharedPreferences');
        return t.reload();
      },
    },
    staticMethods: {
      'getInstance': (visitor, positional, named, typeArgs) {
        return $dartnative_shared_preferences_2.SharedPreferences.getInstance();
      },
    },
    methodSignatures: {
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
      'setStringList': 'Future<bool> setStringList(String key, List<String> value)',
      'remove': 'Future<bool> remove(String key)',
      'clear': 'Future<bool> clear()',
      'reload': 'Future<void> reload()',
    },
    staticMethodSignatures: {
      'getInstance': 'Future<SharedPreferences> getInstance()',
    },
  );
}

// =============================================================================
// PrefsBindings Bridge
// =============================================================================

BridgedClass _createPrefsBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_shared_preferences_1.PrefsBindings,
    name: 'PrefsBindings',
    isAssignable: (v) => v is $dartnative_shared_preferences_1.PrefsBindings,
    constructors: {
    },
    getters: {
      'get': (visitor, target) => D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').get,
      'set': (visitor, target) => D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').set,
      'remove': (visitor, target) => D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').remove,
      'clear': (visitor, target) => D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').clear,
      'synchronize': (visitor, target) => D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').synchronize,
      'containsKey': (visitor, target) => D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').containsKey,
    },
    setters: {
      'get': (visitor, target, value) {
        final getRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'get');
        D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').get = ((Pointer<$ffi_1.Utf8> p0, Pointer<$ffi_1.Utf8> p1, int p2) { return D4.callInterpreterCallback(visitor!, getRaw, [p0, p1, p2]) as int; }) as int Function(Pointer<$ffi_1.Utf8>, Pointer<$ffi_1.Utf8>, int);
      },
      'set': (visitor, target, value) {
        final setRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'set');
        D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').set = (Pointer<$ffi_1.Utf8> p0, Pointer<$ffi_1.Utf8> p1) { D4.callInterpreterCallback(visitor!, setRaw, [p0, p1]); };
      },
      'remove': (visitor, target, value) {
        final removeRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'remove');
        D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').remove = (Pointer<$ffi_1.Utf8> p0) { D4.callInterpreterCallback(visitor!, removeRaw, [p0]); };
      },
      'clear': (visitor, target, value) {
        final clearRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'clear');
        D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').clear = () { D4.callInterpreterCallback(visitor!, clearRaw, []); };
      },
      'synchronize': (visitor, target, value) {
        final synchronizeRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'synchronize');
        D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').synchronize = () { D4.callInterpreterCallback(visitor!, synchronizeRaw, []); };
      },
      'containsKey': (visitor, target, value) {
        final containsKeyRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'containsKey');
        D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings').containsKey = ((Pointer<$ffi_1.Utf8> p0) { return D4.callInterpreterCallback(visitor!, containsKeyRaw, [p0]) as int; }) as int Function(Pointer<$ffi_1.Utf8>);
      },
    },
    methods: {
      'load': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_shared_preferences_1.PrefsBindings>(target, 'PrefsBindings');
        t.load();
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) => $dartnative_shared_preferences_1.PrefsBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_shared_preferences_1.PrefsBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'load': 'void load()',
    },
    getterSignatures: {
      'get': '_GetStringDart get get',
      'set': '_SetStringDart get set',
      'remove': '_KeyOnlyDart get remove',
      'clear': '_NoArgDart get clear',
      'synchronize': '_NoArgDart get synchronize',
      'containsKey': '_ContainsDart get containsKey',
    },
    setterSignatures: {
      'get': 'set get(dynamic value)',
      'set': 'set set(dynamic value)',
      'remove': 'set remove(dynamic value)',
      'clear': 'set clear(dynamic value)',
      'synchronize': 'set synchronize(dynamic value)',
      'containsKey': 'set containsKey(dynamic value)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'PrefsBindings get instance',
    },
  );
}


// D4rt Bridge - Generated file, do not edit
// Sources: 4 files
// Generated: 2026-11-06T23:49:53.568468 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';

import 'package:dartnative_connectivity/src/connectivity.dart'
    as $dartnative_connectivity_1;
import 'package:dartnative_connectivity/src/connectivity_ffi_bindings.dart'
    as $dartnative_connectivity_2;
import 'package:dartnative_connectivity/src/connectivity_result.dart'
    as $dartnative_connectivity_3;
import 'package:dartnative_connectivity/src/internet_connection.dart'
    as $dartnative_connectivity_4;

/// Bridge class for dartnative_connectivity module.
class DartnativeConnectivityBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createConnectivityBridge(),
      _createConnectivityFFIBindingsBridge(),
      _createInternetConnectionBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'Connectivity': _createConnectivityBridge,
      'ConnectivityFFIBindings': _createConnectivityFFIBindingsBridge,
      'InternetConnection': _createInternetConnectionBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'Connectivity': $dartnative_connectivity_1.Connectivity,
      'ConnectivityFFIBindings':
          $dartnative_connectivity_2.ConnectivityFFIBindings,
      'InternetConnection': $dartnative_connectivity_4.InternetConnection,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'Connectivity': 'package:dartnative_connectivity/src/connectivity.dart',
      'ConnectivityFFIBindings':
          'package:dartnative_connectivity/src/connectivity_ffi_bindings.dart',
      'InternetConnection':
          'package:dartnative_connectivity/src/internet_connection.dart',
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
    return {};
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {};
  }

  /// Returns the list of function typedef names declared in this library.
  ///
  /// Function typedefs like `typedef VoidCallback = void Function()` are
  /// registered so that they can be used as type arguments in D4rt scripts.
  static List<String> functionTypedefs() {
    return [];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dartnative_connectivity_3.ConnectivityType>(
        name: 'ConnectivityType',
        values: $dartnative_connectivity_3.ConnectivityType.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'ConnectivityType':
          'package:dartnative_connectivity/src/connectivity_result.dart',
    };
  }

  /// Returns all bridged extension definitions.
  static List<BridgedExtensionDefinition> bridgedExtensions() {
    return [];
  }

  /// Returns a map of extension identifiers to their canonical source URIs.
  static Map<String, String> extensionSourceUris() {
    return {};
  }

  /// GEN-107: Library re-exports declared by the bridged source
  /// libraries. Each tuple mirrors a Dart `export '…'` directive.
  /// Consumed by `registerBridges` via `D4rt.registerLibraryReExport`
  /// (mirrored on `D4rtRunner` in tom_d4rt_ast).
  static List<
    ({String source, String target, Set<String>? show, Set<String>? hide})
  >
  bridgeReExports() {
    return [
      (
        source: 'package:dartnative_connectivity/connectivity.dart',
        target: 'package:dartnative_connectivity/src/connectivity.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_connectivity/connectivity.dart',
        target:
            'package:dartnative_connectivity/src/connectivity_ffi_bindings.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_connectivity/connectivity.dart',
        target: 'package:dartnative_connectivity/src/connectivity_result.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_connectivity/connectivity.dart',
        target: 'package:dartnative_connectivity/src/internet_connection.dart',
        show: null,
        hide: null,
      ),
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

    // Register bridged enums with source URIs for deduplication
    final enums = bridgedEnums();
    final enumSources = enumSourceUris();
    for (final enumDef in enums) {
      interpreter.registerBridgedEnum(
        enumDef,
        importPath,
        sourceUri: enumSources[enumDef.name],
      );
    }

    // Register global functions with source URIs for deduplication
    final funcs = globalFunctions();
    final funcSources = globalFunctionSourceUris();
    final funcSigs = globalFunctionSignatures();
    for (final entry in funcs.entries) {
      interpreter.registertopLevelFunction(
        entry.key,
        entry.value,
        importPath,
        sourceUri: funcSources[entry.key],
        signature: funcSigs[entry.key],
      );
    }

    // GEN-107: Register library re-exports
    for (final r in bridgeReExports()) {
      interpreter.registerLibraryReExport(
        r.source,
        r.target,
        show: r.show,
        hide: r.hide,
      );
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {
      'connectivityTypeFromBitmask': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'connectivityTypeFromBitmask');
        final mask = D4.getRequiredArg<int>(
          positional,
          0,
          'mask',
          'connectivityTypeFromBitmask',
        );
        return $dartnative_connectivity_3.connectivityTypeFromBitmask(mask);
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'connectivityTypeFromBitmask':
          'package:dartnative_connectivity/src/connectivity_result.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'connectivityTypeFromBitmask':
          'ConnectivityType connectivityTypeFromBitmask(int mask)',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative_connectivity/src/connectivity.dart',
      'package:dartnative_connectivity/src/connectivity_ffi_bindings.dart',
      'package:dartnative_connectivity/src/connectivity_result.dart',
      'package:dartnative_connectivity/src/internet_connection.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_connectivity/connectivity.dart';";
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

  /// Returns a list of bridged enum names.
  static List<String> get enumNames => [
    'ConnectivityType',
  ];
}

// =============================================================================
// Connectivity Bridge
// =============================================================================

BridgedClass _createConnectivityBridge() {
  return BridgedClass(
    nativeType: $dartnative_connectivity_1.Connectivity,
    name: 'Connectivity',
    isAssignable: (v) => v is $dartnative_connectivity_1.Connectivity,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_connectivity_1.Connectivity();
      },
    },
    getters: {
      'onConnectivityTypeChanged': (visitor, target) => D4
          .validateTarget<$dartnative_connectivity_1.Connectivity>(
            target,
            'Connectivity',
          )
          .onConnectivityTypeChanged,
    },
    methods: {
      'checkConnectivityType': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_connectivity_1.Connectivity>(
          target,
          'Connectivity',
        );
        return t.checkConnectivityType();
      },
    },
    constructorSignatures: {
      '': 'factory Connectivity()',
    },
    methodSignatures: {
      'checkConnectivityType':
          'Future<ConnectivityType> checkConnectivityType()',
    },
    getterSignatures: {
      'onConnectivityTypeChanged':
          'Stream<ConnectivityType> get onConnectivityTypeChanged',
    },
  );
}

// =============================================================================
// ConnectivityFFIBindings Bridge
// =============================================================================

BridgedClass _createConnectivityFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_connectivity_2.ConnectivityFFIBindings,
    name: 'ConnectivityFFIBindings',
    isAssignable: (v) =>
        v is $dartnative_connectivity_2.ConnectivityFFIBindings,
    constructors: {},
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_connectivity_2.ConnectivityFFIBindings.loadSymbols();
      },
      'checkRaw': (visitor, positional, named, typeArgs) {
        return $dartnative_connectivity_2.ConnectivityFFIBindings.checkRaw();
      },
      'startMonitor': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'startMonitor');
        if (positional.isEmpty) {
          throw ArgumentError(
            'startMonitor: Missing required argument "onUpdate" at position 0',
          );
        }
        final onUpdateRaw = positional[0];
        final onUpdate = (int p0) {
          D4.callInterpreterCallback(visitor!, onUpdateRaw, [p0]);
        };
        return $dartnative_connectivity_2.ConnectivityFFIBindings.startMonitor(
          onUpdate,
        );
      },
      'stopMonitor': (visitor, positional, named, typeArgs) {
        return $dartnative_connectivity_2.ConnectivityFFIBindings.stopMonitor();
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'checkRaw': 'int checkRaw()',
      'startMonitor': 'void startMonitor(void Function(int bitmask) onUpdate)',
      'stopMonitor': 'void stopMonitor()',
    },
  );
}

// =============================================================================
// InternetConnection Bridge
// =============================================================================

BridgedClass _createInternetConnectionBridge() {
  return BridgedClass(
    nativeType: $dartnative_connectivity_4.InternetConnection,
    name: 'InternetConnection',
    isAssignable: (v) => v is $dartnative_connectivity_4.InternetConnection,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_connectivity_4.InternetConnection();
      },
    },
    getters: {
      'checkInterval': (visitor, target) => D4
          .validateTarget<$dartnative_connectivity_4.InternetConnection>(
            target,
            'InternetConnection',
          )
          .checkInterval,
      'hasInternet': (visitor, target) => D4
          .validateTarget<$dartnative_connectivity_4.InternetConnection>(
            target,
            'InternetConnection',
          )
          .hasInternet,
      'isConnected': (visitor, target) => D4
          .validateTarget<$dartnative_connectivity_4.InternetConnection>(
            target,
            'InternetConnection',
          )
          .isConnected,
      'onInternetChanged': (visitor, target) => D4
          .validateTarget<$dartnative_connectivity_4.InternetConnection>(
            target,
            'InternetConnection',
          )
          .onInternetChanged,
    },
    setters: {
      'checkInterval': (visitor, target, value) =>
          D4
              .validateTarget<$dartnative_connectivity_4.InternetConnection>(
                target,
                'InternetConnection',
              )
              .checkInterval = D4.extractBridgedArg<Duration>(
            value,
            'checkInterval',
          ),
    },
    constructorSignatures: {
      '': 'factory InternetConnection()',
    },
    getterSignatures: {
      'checkInterval': 'Duration get checkInterval',
      'hasInternet': 'Future<bool> get hasInternet',
      'isConnected': 'bool? get isConnected',
      'onInternetChanged': 'Stream<bool> get onInternetChanged',
    },
    setterSignatures: {
      'checkInterval': 'set checkInterval(dynamic value)',
    },
  );
}

// D4rt Bridge - Generated file, do not edit
// Sources: 6 files
// Generated: 2026-11-24T16:21:24.939275 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:dartnative_onnxruntime/src/onnxruntime.dart'
    as $dartnative_onnxruntime_1;
import 'package:dartnative_onnxruntime/src/ort_ffi_bindings.dart'
    as $dartnative_onnxruntime_2;
import 'package:dartnative_onnxruntime/src/ort_model_metadata.dart'
    as $dartnative_onnxruntime_3;
import 'package:dartnative_onnxruntime/src/ort_provider.dart'
    as $dartnative_onnxruntime_4;
import 'package:dartnative_onnxruntime/src/ort_session.dart'
    as $dartnative_onnxruntime_5;
import 'package:dartnative_onnxruntime/src/ort_value.dart'
    as $dartnative_onnxruntime_6;

/// Bridge class for dartnative_onnxruntime module.
class DartnativeOnnxruntimeBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createOnnxRuntimeBridge(),
      _createOrtSessionBridge(),
      _createOrtSessionOptionsBridge(),
      _createOrtRunOptionsBridge(),
      _createOrtValueBridge(),
      _createOrtModelMetadataBridge(),
      _createOrtFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'OnnxRuntime': _createOnnxRuntimeBridge,
      'OrtSession': _createOrtSessionBridge,
      'OrtSessionOptions': _createOrtSessionOptionsBridge,
      'OrtRunOptions': _createOrtRunOptionsBridge,
      'OrtValue': _createOrtValueBridge,
      'OrtModelMetadata': _createOrtModelMetadataBridge,
      'OrtFFIBindings': _createOrtFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'OnnxRuntime': $dartnative_onnxruntime_1.OnnxRuntime,
      'OrtSession': $dartnative_onnxruntime_5.OrtSession,
      'OrtSessionOptions': $dartnative_onnxruntime_5.OrtSessionOptions,
      'OrtRunOptions': $dartnative_onnxruntime_5.OrtRunOptions,
      'OrtValue': $dartnative_onnxruntime_6.OrtValue,
      'OrtModelMetadata': $dartnative_onnxruntime_3.OrtModelMetadata,
      'OrtFFIBindings': $dartnative_onnxruntime_2.OrtFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'OnnxRuntime': 'package:dartnative_onnxruntime/src/onnxruntime.dart',
      'OrtSession': 'package:dartnative_onnxruntime/src/ort_session.dart',
      'OrtSessionOptions':
          'package:dartnative_onnxruntime/src/ort_session.dart',
      'OrtRunOptions': 'package:dartnative_onnxruntime/src/ort_session.dart',
      'OrtValue': 'package:dartnative_onnxruntime/src/ort_value.dart',
      'OrtModelMetadata':
          'package:dartnative_onnxruntime/src/ort_model_metadata.dart',
      'OrtFFIBindings':
          'package:dartnative_onnxruntime/src/ort_ffi_bindings.dart',
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
      BridgedEnumDefinition<$dartnative_onnxruntime_6.OrtDataType>(
        name: 'OrtDataType',
        values: $dartnative_onnxruntime_6.OrtDataType.values,
      ),
      BridgedEnumDefinition<$dartnative_onnxruntime_4.OrtProvider>(
        name: 'OrtProvider',
        values: $dartnative_onnxruntime_4.OrtProvider.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'OrtDataType': 'package:dartnative_onnxruntime/src/ort_value.dart',
      'OrtProvider': 'package:dartnative_onnxruntime/src/ort_provider.dart',
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
        source: 'package:dartnative_onnxruntime/dartnative_onnxruntime.dart',
        target: 'package:dartnative_onnxruntime/src/onnxruntime.dart',
        show: {'OnnxRuntime'},
        hide: null,
      ),
      (
        source: 'package:dartnative_onnxruntime/dartnative_onnxruntime.dart',
        target: 'package:dartnative_onnxruntime/src/ort_session.dart',
        show: {'OrtSession', 'OrtSessionOptions', 'OrtRunOptions'},
        hide: null,
      ),
      (
        source: 'package:dartnative_onnxruntime/dartnative_onnxruntime.dart',
        target: 'package:dartnative_onnxruntime/src/ort_value.dart',
        show: {'OrtValue', 'OrtDataType'},
        hide: null,
      ),
      (
        source: 'package:dartnative_onnxruntime/dartnative_onnxruntime.dart',
        target: 'package:dartnative_onnxruntime/src/ort_provider.dart',
        show: {'OrtProvider'},
        hide: null,
      ),
      (
        source: 'package:dartnative_onnxruntime/dartnative_onnxruntime.dart',
        target: 'package:dartnative_onnxruntime/src/ort_model_metadata.dart',
        show: {'OrtModelMetadata'},
        hide: null,
      ),
      (
        source: 'package:dartnative_onnxruntime/dartnative_onnxruntime.dart',
        target: 'package:dartnative_onnxruntime/src/ort_ffi_bindings.dart',
        show: {'OrtFFIBindings'},
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
      'package:dartnative_onnxruntime/src/onnxruntime.dart',
      'package:dartnative_onnxruntime/src/ort_ffi_bindings.dart',
      'package:dartnative_onnxruntime/src/ort_model_metadata.dart',
      'package:dartnative_onnxruntime/src/ort_provider.dart',
      'package:dartnative_onnxruntime/src/ort_session.dart',
      'package:dartnative_onnxruntime/src/ort_value.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_onnxruntime/dartnative_onnxruntime.dart';";
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
    'OrtDataType',
    'OrtProvider',
  ];
}

// =============================================================================
// OnnxRuntime Bridge
// =============================================================================

BridgedClass _createOnnxRuntimeBridge() {
  return BridgedClass(
    nativeType: $dartnative_onnxruntime_1.OnnxRuntime,
    name: 'OnnxRuntime',
    isAssignable: (v) => v is $dartnative_onnxruntime_1.OnnxRuntime,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_onnxruntime_1.OnnxRuntime();
      },
    },
    methods: {
      'createSession': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_1.OnnxRuntime>(
          target,
          'OnnxRuntime',
        );
        D4.requireMinArgs(positional, 1, 'createSession');
        final modelPath = D4.getRequiredArg<String>(
          positional,
          0,
          'modelPath',
          'createSession',
        );
        final options = D4
            .getOptionalNamedArg<$dartnative_onnxruntime_5.OrtSessionOptions?>(
              named,
              'options',
            );
        return t.createSession(modelPath, options: options);
      },
      'getAvailableProviders': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_1.OnnxRuntime>(
          target,
          'OnnxRuntime',
        );
        return t.getAvailableProviders();
      },
    },
    constructorSignatures: {
      '': 'OnnxRuntime()',
    },
    methodSignatures: {
      'createSession':
          'Future<OrtSession> createSession(String modelPath, {OrtSessionOptions? options})',
      'getAvailableProviders':
          'Future<List<OrtProvider>> getAvailableProviders()',
    },
  );
}

// =============================================================================
// OrtSession Bridge
// =============================================================================

BridgedClass _createOrtSessionBridge() {
  return BridgedClass(
    nativeType: $dartnative_onnxruntime_5.OrtSession,
    name: 'OrtSession',
    isAssignable: (v) => v is $dartnative_onnxruntime_5.OrtSession,
    constructors: {
      'fromMap': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'OrtSession');
        if (positional.isEmpty) {
          throw ArgumentError(
            'OrtSession: Missing required argument "map" at position 0',
          );
        }
        final map = D4.coerceMap<String, dynamic>(positional[0], 'map');
        return $dartnative_onnxruntime_5.OrtSession.fromMap(map);
      },
    },
    getters: {
      'id': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtSession>(
            target,
            'OrtSession',
          )
          .id,
      'inputNames': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtSession>(
            target,
            'OrtSession',
          )
          .inputNames,
      'outputNames': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtSession>(
            target,
            'OrtSession',
          )
          .outputNames,
    },
    methods: {
      'run': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_5.OrtSession>(
          target,
          'OrtSession',
        );
        D4.requireMinArgs(positional, 1, 'run');
        if (positional.isEmpty) {
          throw ArgumentError(
            'run: Missing required argument "inputs" at position 0',
          );
        }
        final inputs = D4.coerceMap<String, $dartnative_onnxruntime_6.OrtValue>(
          positional[0],
          'inputs',
        );
        final options = D4
            .getOptionalNamedArg<$dartnative_onnxruntime_5.OrtRunOptions?>(
              named,
              'options',
            );
        return t.run(inputs, options: options);
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_5.OrtSession>(
          target,
          'OrtSession',
        );
        return t.close();
      },
      'getMetadata': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_5.OrtSession>(
          target,
          'OrtSession',
        );
        return t.getMetadata();
      },
      'getInputInfo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_5.OrtSession>(
          target,
          'OrtSession',
        );
        return t.getInputInfo();
      },
      'getOutputInfo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_5.OrtSession>(
          target,
          'OrtSession',
        );
        return t.getOutputInfo();
      },
    },
    constructorSignatures: {
      'fromMap': 'factory OrtSession.fromMap(Map<String, dynamic> map)',
    },
    methodSignatures: {
      'run':
          'Future<Map<String, OrtValue>> run(Map<String, OrtValue> inputs, {OrtRunOptions? options})',
      'close': 'Future<void> close()',
      'getMetadata': 'Future<OrtModelMetadata> getMetadata()',
      'getInputInfo': 'Future<List<Map<String, dynamic>>> getInputInfo()',
      'getOutputInfo': 'Future<List<Map<String, dynamic>>> getOutputInfo()',
    },
    getterSignatures: {
      'id': 'String get id',
      'inputNames': 'List<String> get inputNames',
      'outputNames': 'List<String> get outputNames',
    },
  );
}

// =============================================================================
// OrtSessionOptions Bridge
// =============================================================================

BridgedClass _createOrtSessionOptionsBridge() {
  return BridgedClass(
    nativeType: $dartnative_onnxruntime_5.OrtSessionOptions,
    name: 'OrtSessionOptions',
    isAssignable: (v) => v is $dartnative_onnxruntime_5.OrtSessionOptions,
    constructors: {
      '': (visitor, positional, named) {
        final intraOpNumThreads = D4.getOptionalNamedArg<int?>(
          named,
          'intraOpNumThreads',
        );
        final interOpNumThreads = D4.getOptionalNamedArg<int?>(
          named,
          'interOpNumThreads',
        );
        final providers = D4
            .coerceListOrNull<$dartnative_onnxruntime_4.OrtProvider>(
              named['providers'],
              'providers',
            );
        final useArena = D4.getOptionalNamedArg<bool?>(named, 'useArena');
        final deviceId = D4.getOptionalNamedArg<int?>(named, 'deviceId');
        return $dartnative_onnxruntime_5.OrtSessionOptions(
          intraOpNumThreads: intraOpNumThreads,
          interOpNumThreads: interOpNumThreads,
          providers: providers,
          useArena: useArena,
          deviceId: deviceId,
        );
      },
    },
    getters: {
      'intraOpNumThreads': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtSessionOptions>(
            target,
            'OrtSessionOptions',
          )
          .intraOpNumThreads,
      'interOpNumThreads': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtSessionOptions>(
            target,
            'OrtSessionOptions',
          )
          .interOpNumThreads,
      'providers': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtSessionOptions>(
            target,
            'OrtSessionOptions',
          )
          .providers,
      'useArena': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtSessionOptions>(
            target,
            'OrtSessionOptions',
          )
          .useArena,
      'deviceId': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtSessionOptions>(
            target,
            'OrtSessionOptions',
          )
          .deviceId,
    },
    methods: {
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_onnxruntime_5.OrtSessionOptions>(
              target,
              'OrtSessionOptions',
            );
        return t.toMap();
      },
    },
    constructorSignatures: {
      '': 'OrtSessionOptions({int? intraOpNumThreads, int? interOpNumThreads, List<OrtProvider>? providers, bool? useArena, int? deviceId})',
    },
    methodSignatures: {
      'toMap': 'Map<String, dynamic> toMap()',
    },
    getterSignatures: {
      'intraOpNumThreads': 'int? get intraOpNumThreads',
      'interOpNumThreads': 'int? get interOpNumThreads',
      'providers': 'List<OrtProvider>? get providers',
      'useArena': 'bool? get useArena',
      'deviceId': 'int? get deviceId',
    },
  );
}

// =============================================================================
// OrtRunOptions Bridge
// =============================================================================

BridgedClass _createOrtRunOptionsBridge() {
  return BridgedClass(
    nativeType: $dartnative_onnxruntime_5.OrtRunOptions,
    name: 'OrtRunOptions',
    isAssignable: (v) => v is $dartnative_onnxruntime_5.OrtRunOptions,
    constructors: {
      '': (visitor, positional, named) {
        final logSeverityLevel = D4.getOptionalNamedArg<int?>(
          named,
          'logSeverityLevel',
        );
        final logVerbosityLevel = D4.getOptionalNamedArg<int?>(
          named,
          'logVerbosityLevel',
        );
        final terminate = D4.getOptionalNamedArg<bool?>(named, 'terminate');
        return $dartnative_onnxruntime_5.OrtRunOptions(
          logSeverityLevel: logSeverityLevel,
          logVerbosityLevel: logVerbosityLevel,
          terminate: terminate,
        );
      },
    },
    getters: {
      'logSeverityLevel': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtRunOptions>(
            target,
            'OrtRunOptions',
          )
          .logSeverityLevel,
      'logVerbosityLevel': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtRunOptions>(
            target,
            'OrtRunOptions',
          )
          .logVerbosityLevel,
      'terminate': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_5.OrtRunOptions>(
            target,
            'OrtRunOptions',
          )
          .terminate,
    },
    methods: {
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_5.OrtRunOptions>(
          target,
          'OrtRunOptions',
        );
        return t.toMap();
      },
    },
    constructorSignatures: {
      '': 'OrtRunOptions({int? logSeverityLevel, int? logVerbosityLevel, bool? terminate})',
    },
    methodSignatures: {
      'toMap': 'Map<String, dynamic> toMap()',
    },
    getterSignatures: {
      'logSeverityLevel': 'int? get logSeverityLevel',
      'logVerbosityLevel': 'int? get logVerbosityLevel',
      'terminate': 'bool? get terminate',
    },
  );
}

// =============================================================================
// OrtValue Bridge
// =============================================================================

BridgedClass _createOrtValueBridge() {
  return BridgedClass(
    nativeType: $dartnative_onnxruntime_6.OrtValue,
    name: 'OrtValue',
    isAssignable: (v) => v is $dartnative_onnxruntime_6.OrtValue,
    constructors: {
      'fromMap': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'OrtValue');
        if (positional.isEmpty) {
          throw ArgumentError(
            'OrtValue: Missing required argument "map" at position 0',
          );
        }
        final map = D4.coerceMap<String, dynamic>(positional[0], 'map');
        return $dartnative_onnxruntime_6.OrtValue.fromMap(map);
      },
    },
    getters: {
      'id': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_6.OrtValue>(
            target,
            'OrtValue',
          )
          .id,
      'dataType': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_6.OrtValue>(
            target,
            'OrtValue',
          )
          .dataType,
      'shape': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_6.OrtValue>(
            target,
            'OrtValue',
          )
          .shape,
    },
    methods: {
      'to': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_6.OrtValue>(
          target,
          'OrtValue',
        );
        D4.requireMinArgs(positional, 1, 'to');
        final targetType = D4
            .getRequiredArg<$dartnative_onnxruntime_6.OrtDataType>(
              positional,
              0,
              'targetType',
              'to',
            );
        return t.to(targetType);
      },
      'asFlattenedList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_6.OrtValue>(
          target,
          'OrtValue',
        );
        return t.asFlattenedList();
      },
      'asList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_6.OrtValue>(
          target,
          'OrtValue',
        );
        return t.asList();
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_6.OrtValue>(
          target,
          'OrtValue',
        );
        return (t as dynamic).dispose();
      },
    },
    staticMethods: {
      'fromList': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'fromList');
        final data = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'data',
          'fromList',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'fromList: Missing required argument "shape" at position 1',
          );
        }
        final shape = D4.coerceList<int>(positional[1], 'shape');
        return $dartnative_onnxruntime_6.OrtValue.fromList(data, shape);
      },
    },
    constructorSignatures: {
      'fromMap': 'factory OrtValue.fromMap(Map<String, dynamic> map)',
    },
    methodSignatures: {
      'to': 'Future<OrtValue> to(OrtDataType targetType)',
      'asFlattenedList': 'Future<List> asFlattenedList()',
      'asList': 'Future<List> asList()',
      'dispose': 'Future<void> dispose()',
    },
    getterSignatures: {
      'id': 'String get id',
      'dataType': 'OrtDataType get dataType',
      'shape': 'List<int> get shape',
    },
    staticMethodSignatures: {
      'fromList': 'Future<OrtValue> fromList(dynamic data, List<int> shape)',
    },
  );
}

// =============================================================================
// OrtModelMetadata Bridge
// =============================================================================

BridgedClass _createOrtModelMetadataBridge() {
  return BridgedClass(
    nativeType: $dartnative_onnxruntime_3.OrtModelMetadata,
    name: 'OrtModelMetadata',
    isAssignable: (v) => v is $dartnative_onnxruntime_3.OrtModelMetadata,
    constructors: {
      '': (visitor, positional, named) {
        final producerName = D4.getRequiredNamedArg<String>(
          named,
          'producerName',
          'OrtModelMetadata',
        );
        final graphName = D4.getRequiredNamedArg<String>(
          named,
          'graphName',
          'OrtModelMetadata',
        );
        final domain = D4.getRequiredNamedArg<String>(
          named,
          'domain',
          'OrtModelMetadata',
        );
        final description = D4.getRequiredNamedArg<String>(
          named,
          'description',
          'OrtModelMetadata',
        );
        final version = D4.getRequiredNamedArg<int>(
          named,
          'version',
          'OrtModelMetadata',
        );
        if (!named.containsKey('customMetadataMap') ||
            named['customMetadataMap'] == null) {
          throw ArgumentError(
            'OrtModelMetadata: Missing required named argument "customMetadataMap"',
          );
        }
        final customMetadataMap = D4.coerceMap<String, String>(
          named['customMetadataMap'],
          'customMetadataMap',
        );
        return $dartnative_onnxruntime_3.OrtModelMetadata(
          producerName: producerName,
          graphName: graphName,
          domain: domain,
          description: description,
          version: version,
          customMetadataMap: customMetadataMap,
        );
      },
      'fromMap': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'OrtModelMetadata');
        if (positional.isEmpty) {
          throw ArgumentError(
            'OrtModelMetadata: Missing required argument "map" at position 0',
          );
        }
        final map = D4.coerceMap<String, dynamic>(positional[0], 'map');
        return $dartnative_onnxruntime_3.OrtModelMetadata.fromMap(map);
      },
    },
    getters: {
      'producerName': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_3.OrtModelMetadata>(
            target,
            'OrtModelMetadata',
          )
          .producerName,
      'graphName': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_3.OrtModelMetadata>(
            target,
            'OrtModelMetadata',
          )
          .graphName,
      'domain': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_3.OrtModelMetadata>(
            target,
            'OrtModelMetadata',
          )
          .domain,
      'description': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_3.OrtModelMetadata>(
            target,
            'OrtModelMetadata',
          )
          .description,
      'version': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_3.OrtModelMetadata>(
            target,
            'OrtModelMetadata',
          )
          .version,
      'customMetadataMap': (visitor, target) => D4
          .validateTarget<$dartnative_onnxruntime_3.OrtModelMetadata>(
            target,
            'OrtModelMetadata',
          )
          .customMetadataMap,
    },
    methods: {
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_3.OrtModelMetadata>(
          target,
          'OrtModelMetadata',
        );
        return t.toMap();
      },
    },
    constructorSignatures: {
      '': 'OrtModelMetadata({required String producerName, required String graphName, required String domain, required String description, required int version, required Map<String, String> customMetadataMap})',
      'fromMap': 'factory OrtModelMetadata.fromMap(Map<String, dynamic> map)',
    },
    methodSignatures: {
      'toMap': 'Map<String, dynamic> toMap()',
    },
    getterSignatures: {
      'producerName': 'String get producerName',
      'graphName': 'String get graphName',
      'domain': 'String get domain',
      'description': 'String get description',
      'version': 'int get version',
      'customMetadataMap': 'Map<String, String> get customMetadataMap',
    },
  );
}

// =============================================================================
// OrtFFIBindings Bridge
// =============================================================================

BridgedClass _createOrtFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_onnxruntime_2.OrtFFIBindings,
    name: 'OrtFFIBindings',
    isAssignable: (v) => v is $dartnative_onnxruntime_2.OrtFFIBindings,
    constructors: {},
    methods: {
      'createSession': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 2, 'createSession');
        final modelPath = D4.getRequiredArg<String>(
          positional,
          0,
          'modelPath',
          'createSession',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'createSession: Missing required argument "options" at position 1',
          );
        }
        final options = D4.coerceMap<String, dynamic>(positional[1], 'options');
        return t.createSession(modelPath, options);
      },
      'closeSession': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 1, 'closeSession');
        final sessionId = D4.getRequiredArg<String>(
          positional,
          0,
          'sessionId',
          'closeSession',
        );
        t.closeSession(sessionId);
        return null;
      },
      'runInference': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 3, 'runInference');
        final sessionId = D4.getRequiredArg<String>(
          positional,
          0,
          'sessionId',
          'runInference',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'runInference: Missing required argument "inputs" at position 1',
          );
        }
        final inputs = D4.coerceMap<String, String>(positional[1], 'inputs');
        if (positional.length <= 2) {
          throw ArgumentError(
            'runInference: Missing required argument "runOptions" at position 2',
          );
        }
        final runOptions = D4.coerceMap<String, dynamic>(
          positional[2],
          'runOptions',
        );
        return t.runInference(sessionId, inputs, runOptions);
      },
      'getMetadata': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 1, 'getMetadata');
        final sessionId = D4.getRequiredArg<String>(
          positional,
          0,
          'sessionId',
          'getMetadata',
        );
        return t.getMetadata(sessionId);
      },
      'getInputInfo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 1, 'getInputInfo');
        final sessionId = D4.getRequiredArg<String>(
          positional,
          0,
          'sessionId',
          'getInputInfo',
        );
        return t.getInputInfo(sessionId);
      },
      'getOutputInfo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 1, 'getOutputInfo');
        final sessionId = D4.getRequiredArg<String>(
          positional,
          0,
          'sessionId',
          'getOutputInfo',
        );
        return t.getOutputInfo(sessionId);
      },
      'getAvailableProviders': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        return t.getAvailableProviders();
      },
      'createValue': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 3, 'createValue');
        final sourceType = D4.getRequiredArg<String>(
          positional,
          0,
          'sourceType',
          'createValue',
        );
        final dataBytes = D4.getRequiredArg<Uint8List>(
          positional,
          1,
          'dataBytes',
          'createValue',
        );
        if (positional.length <= 2) {
          throw ArgumentError(
            'createValue: Missing required argument "shape" at position 2',
          );
        }
        final shape = D4.coerceList<int>(positional[2], 'shape');
        return t.createValue(sourceType, dataBytes, shape);
      },
      'convertValue': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 2, 'convertValue');
        final valueId = D4.getRequiredArg<String>(
          positional,
          0,
          'valueId',
          'convertValue',
        );
        final targetType = D4.getRequiredArg<String>(
          positional,
          1,
          'targetType',
          'convertValue',
        );
        return t.convertValue(valueId, targetType);
      },
      'getValueInfo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 1, 'getValueInfo');
        final valueId = D4.getRequiredArg<String>(
          positional,
          0,
          'valueId',
          'getValueInfo',
        );
        return t.getValueInfo(valueId);
      },
      'getValueBytes': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 1, 'getValueBytes');
        final valueId = D4.getRequiredArg<String>(
          positional,
          0,
          'valueId',
          'getValueBytes',
        );
        return t.getValueBytes(valueId);
      },
      'releaseValue': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_onnxruntime_2.OrtFFIBindings>(
          target,
          'OrtFFIBindings',
        );
        D4.requireMinArgs(positional, 1, 'releaseValue');
        final valueId = D4.getRequiredArg<String>(
          positional,
          0,
          'valueId',
          'releaseValue',
        );
        t.releaseValue(valueId);
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) =>
          $dartnative_onnxruntime_2.OrtFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_onnxruntime_2.OrtFFIBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'createSession':
          'Future<Map<String, dynamic>> createSession(String modelPath, Map<String, dynamic> options)',
      'closeSession': 'void closeSession(String sessionId)',
      'runInference':
          'Future<Map<String, dynamic>> runInference(String sessionId, Map<String, String> inputs, Map<String, dynamic> runOptions)',
      'getMetadata': 'Map<String, dynamic> getMetadata(String sessionId)',
      'getInputInfo':
          'List<Map<String, dynamic>> getInputInfo(String sessionId)',
      'getOutputInfo':
          'List<Map<String, dynamic>> getOutputInfo(String sessionId)',
      'getAvailableProviders': 'List<String> getAvailableProviders()',
      'createValue':
          'Map<String, dynamic> createValue(String sourceType, Uint8List dataBytes, List<int> shape)',
      'convertValue':
          'Map<String, dynamic> convertValue(String valueId, String targetType)',
      'getValueInfo': 'Map<String, dynamic> getValueInfo(String valueId)',
      'getValueBytes': 'Uint8List getValueBytes(String valueId)',
      'releaseValue': 'void releaseValue(String valueId)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'OrtFFIBindings get instance',
    },
  );
}

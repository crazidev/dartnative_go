// D4rt Bridge - Generated file, do not edit
// Sources: 2 files
// Generated: 2026-10-17T21:08:31.486351 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';

import 'package:dartnative_background/src/options.dart' as $dartnative_background_1;
import 'package:dartnative_background/src/task_manager.dart' as $dartnative_background_2;

/// Bridge class for dartnative_background module.
class DartnativeBackgroundBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createConstraintsBridge(),
      _createTaskManagerBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'Constraints': _createConstraintsBridge,
      'TaskManager': _createTaskManagerBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'Constraints': $dartnative_background_1.Constraints,
      'TaskManager': $dartnative_background_2.TaskManager,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'Constraints': 'package:dartnative_background/src/options.dart',
      'TaskManager': 'package:dartnative_background/src/task_manager.dart',
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
      'BackgroundTaskHandler',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dartnative_background_1.ExistingTaskPolicy>(
        name: 'ExistingTaskPolicy',
        values: $dartnative_background_1.ExistingTaskPolicy.values,
      ),
      BridgedEnumDefinition<$dartnative_background_1.NetworkType>(
        name: 'NetworkType',
        values: $dartnative_background_1.NetworkType.values,
      ),
      BridgedEnumDefinition<$dartnative_background_1.OutOfQuotaPolicy>(
        name: 'OutOfQuotaPolicy',
        values: $dartnative_background_1.OutOfQuotaPolicy.values,
      ),
      BridgedEnumDefinition<$dartnative_background_1.BackoffPolicy>(
        name: 'BackoffPolicy',
        values: $dartnative_background_1.BackoffPolicy.values,
      ),
      BridgedEnumDefinition<$dartnative_background_1.BackgroundRefreshPermissionState>(
        name: 'BackgroundRefreshPermissionState',
        values: $dartnative_background_1.BackgroundRefreshPermissionState.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'ExistingTaskPolicy': 'package:dartnative_background/src/options.dart',
      'NetworkType': 'package:dartnative_background/src/options.dart',
      'OutOfQuotaPolicy': 'package:dartnative_background/src/options.dart',
      'BackoffPolicy': 'package:dartnative_background/src/options.dart',
      'BackgroundRefreshPermissionState': 'package:dartnative_background/src/options.dart',
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
      (source: 'package:dartnative_background/dartnative_background.dart', target: 'package:dartnative_background/task_manager.dart', show: null, hide: null),
      (source: 'package:dartnative_background/task_manager.dart', target: 'package:dartnative_background/src/options.dart', show: null, hide: null),
      (source: 'package:dartnative_background/task_manager.dart', target: 'package:dartnative_background/src/task_manager.dart', show: {'TaskManager'}, hide: null),
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
      interpreter.registerBridgedEnum(enumDef, importPath, sourceUri: enumSources[enumDef.name]);
    }

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
      'package:dartnative_background/src/options.dart',
      'package:dartnative_background/src/task_manager.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_background/dartnative_background.dart';";
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
    'ExistingTaskPolicy',
    'NetworkType',
    'OutOfQuotaPolicy',
    'BackoffPolicy',
    'BackgroundRefreshPermissionState',
  ];

}

// =============================================================================
// Constraints Bridge
// =============================================================================

BridgedClass _createConstraintsBridge() {
  return BridgedClass(
    nativeType: $dartnative_background_1.Constraints,
    name: 'Constraints',
    isAssignable: (v) => v is $dartnative_background_1.Constraints,
    constructors: {
      '': (visitor, positional, named) {
        final networkType = D4.getRequiredNamedArg<$dartnative_background_1.NetworkType>(named, 'networkType', 'Constraints');
        final requiresBatteryNotLow = D4.getOptionalNamedArg<bool?>(named, 'requiresBatteryNotLow');
        final requiresCharging = D4.getOptionalNamedArg<bool?>(named, 'requiresCharging');
        final requiresDeviceIdle = D4.getOptionalNamedArg<bool?>(named, 'requiresDeviceIdle');
        final requiresStorageNotLow = D4.getOptionalNamedArg<bool?>(named, 'requiresStorageNotLow');
        return $dartnative_background_1.Constraints(networkType: networkType, requiresBatteryNotLow: requiresBatteryNotLow, requiresCharging: requiresCharging, requiresDeviceIdle: requiresDeviceIdle, requiresStorageNotLow: requiresStorageNotLow);
      },
    },
    getters: {
      'networkType': (visitor, target) => D4.validateTarget<$dartnative_background_1.Constraints>(target, 'Constraints').networkType,
      'requiresBatteryNotLow': (visitor, target) => D4.validateTarget<$dartnative_background_1.Constraints>(target, 'Constraints').requiresBatteryNotLow,
      'requiresCharging': (visitor, target) => D4.validateTarget<$dartnative_background_1.Constraints>(target, 'Constraints').requiresCharging,
      'requiresDeviceIdle': (visitor, target) => D4.validateTarget<$dartnative_background_1.Constraints>(target, 'Constraints').requiresDeviceIdle,
      'requiresStorageNotLow': (visitor, target) => D4.validateTarget<$dartnative_background_1.Constraints>(target, 'Constraints').requiresStorageNotLow,
    },
    constructorSignatures: {
      '': 'Constraints({required NetworkType networkType, bool? requiresBatteryNotLow, bool? requiresCharging, bool? requiresDeviceIdle, bool? requiresStorageNotLow})',
    },
    getterSignatures: {
      'networkType': 'NetworkType get networkType',
      'requiresBatteryNotLow': 'bool? get requiresBatteryNotLow',
      'requiresCharging': 'bool? get requiresCharging',
      'requiresDeviceIdle': 'bool? get requiresDeviceIdle',
      'requiresStorageNotLow': 'bool? get requiresStorageNotLow',
    },
  );
}

// =============================================================================
// TaskManager Bridge
// =============================================================================

BridgedClass _createTaskManagerBridge() {
  return BridgedClass(
    nativeType: $dartnative_background_2.TaskManager,
    name: 'TaskManager',
    isAssignable: (v) => v is $dartnative_background_2.TaskManager,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_background_2.TaskManager();
      },
    },
    methods: {
      'loadSymbols': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        t.loadSymbols();
        return null;
      },
      'executeTask': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        D4.requireMinArgs(positional, 1, 'executeTask');
        if (positional.isEmpty) {
          throw ArgumentError('executeTask: Missing required argument "backgroundTask" at position 0');
        }
        final backgroundTaskRaw = positional[0];
        t.executeTask(((String p0, Map<String, dynamic>? p1) { return Future.value(D4.callInterpreterCallback(visitor!, backgroundTaskRaw, [p0, p1])).then((v) => v as bool); }) as Future<bool> Function(String, Map<String, dynamic>?));
        return null;
      },
      'initialize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        D4.requireMinArgs(positional, 1, 'initialize');
        final callbackDispatcher = D4.getRequiredArg<Function>(positional, 0, 'callbackDispatcher', 'initialize');
        final isInDebugMode = D4.getNamedArgWithDefault<bool>(named, 'isInDebugMode', false);
        return t.initialize(callbackDispatcher, isInDebugMode: isInDebugMode);
      },
      'registerOneOffTask': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        D4.requireMinArgs(positional, 2, 'registerOneOffTask');
        final uniqueName = D4.getRequiredArg<String>(positional, 0, 'uniqueName', 'registerOneOffTask');
        final taskName = D4.getRequiredArg<String>(positional, 1, 'taskName', 'registerOneOffTask');
        final tag = D4.getOptionalNamedArg<String?>(named, 'tag');
        final existingWorkPolicy = D4.getOptionalNamedArg<$dartnative_background_1.ExistingTaskPolicy?>(named, 'existingWorkPolicy');
        final initialDelay = D4.getNamedArgWithDefault<Duration>(named, 'initialDelay', Duration.zero);
        final constraints = D4.getOptionalNamedArg<$dartnative_background_1.Constraints?>(named, 'constraints');
        final backoffPolicy = D4.getOptionalNamedArg<$dartnative_background_1.BackoffPolicy?>(named, 'backoffPolicy');
        final backoffPolicyDelay = D4.getNamedArgWithDefault<Duration>(named, 'backoffPolicyDelay', Duration.zero);
        final outOfQuotaPolicy = D4.getOptionalNamedArg<$dartnative_background_1.OutOfQuotaPolicy?>(named, 'outOfQuotaPolicy');
        final inputData = D4.coerceMapOrNull<String, dynamic>(named['inputData'], 'inputData');
        return t.registerOneOffTask(uniqueName, taskName, tag: tag, existingWorkPolicy: existingWorkPolicy, initialDelay: initialDelay, constraints: constraints, backoffPolicy: backoffPolicy, backoffPolicyDelay: backoffPolicyDelay, outOfQuotaPolicy: outOfQuotaPolicy, inputData: inputData);
      },
      'registerPeriodicTask': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        D4.requireMinArgs(positional, 2, 'registerPeriodicTask');
        final uniqueName = D4.getRequiredArg<String>(positional, 0, 'uniqueName', 'registerPeriodicTask');
        final taskName = D4.getRequiredArg<String>(positional, 1, 'taskName', 'registerPeriodicTask');
        final frequency = D4.getOptionalNamedArg<Duration?>(named, 'frequency');
        final tag = D4.getOptionalNamedArg<String?>(named, 'tag');
        final existingWorkPolicy = D4.getOptionalNamedArg<$dartnative_background_1.ExistingTaskPolicy?>(named, 'existingWorkPolicy');
        final initialDelay = D4.getNamedArgWithDefault<Duration>(named, 'initialDelay', Duration.zero);
        final constraints = D4.getOptionalNamedArg<$dartnative_background_1.Constraints?>(named, 'constraints');
        final backoffPolicy = D4.getOptionalNamedArg<$dartnative_background_1.BackoffPolicy?>(named, 'backoffPolicy');
        final backoffPolicyDelay = D4.getNamedArgWithDefault<Duration>(named, 'backoffPolicyDelay', Duration.zero);
        final outOfQuotaPolicy = D4.getOptionalNamedArg<$dartnative_background_1.OutOfQuotaPolicy?>(named, 'outOfQuotaPolicy');
        final inputData = D4.coerceMapOrNull<String, dynamic>(named['inputData'], 'inputData');
        return t.registerPeriodicTask(uniqueName, taskName, frequency: frequency, tag: tag, existingWorkPolicy: existingWorkPolicy, initialDelay: initialDelay, constraints: constraints, backoffPolicy: backoffPolicy, backoffPolicyDelay: backoffPolicyDelay, outOfQuotaPolicy: outOfQuotaPolicy, inputData: inputData);
      },
      'registerProcessingTask': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        D4.requireMinArgs(positional, 2, 'registerProcessingTask');
        final uniqueName = D4.getRequiredArg<String>(positional, 0, 'uniqueName', 'registerProcessingTask');
        final taskName = D4.getRequiredArg<String>(positional, 1, 'taskName', 'registerProcessingTask');
        final initialDelay = D4.getNamedArgWithDefault<Duration>(named, 'initialDelay', Duration.zero);
        final constraints = D4.getOptionalNamedArg<$dartnative_background_1.Constraints?>(named, 'constraints');
        return t.registerProcessingTask(uniqueName, taskName, initialDelay: initialDelay, constraints: constraints);
      },
      'checkBackgroundRefreshPermission': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        return t.checkBackgroundRefreshPermission();
      },
      'cancelByUniqueName': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        D4.requireMinArgs(positional, 1, 'cancelByUniqueName');
        final uniqueName = D4.getRequiredArg<String>(positional, 0, 'uniqueName', 'cancelByUniqueName');
        return t.cancelByUniqueName(uniqueName);
      },
      'cancelByTag': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        D4.requireMinArgs(positional, 1, 'cancelByTag');
        final tag = D4.getRequiredArg<String>(positional, 0, 'tag', 'cancelByTag');
        return t.cancelByTag(tag);
      },
      'cancelAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        return t.cancelAll();
      },
      'printScheduledTasks': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_background_2.TaskManager>(target, 'TaskManager');
        return t.printScheduledTasks();
      },
    },
    staticGetters: {
      'iOSBackgroundTask': (visitor) => $dartnative_background_2.TaskManager.iOSBackgroundTask,
      'iOSBackgroundProcessingTask': (visitor) => $dartnative_background_2.TaskManager.iOSBackgroundProcessingTask,
    },
    constructorSignatures: {
      '': 'factory TaskManager()',
    },
    methodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'executeTask': 'void executeTask(BackgroundTaskHandler backgroundTask)',
      'initialize': 'Future<void> initialize(Function callbackDispatcher, {bool isInDebugMode = false})',
      'registerOneOffTask': 'Future<void> registerOneOffTask(String uniqueName, String taskName, {String? tag, ExistingTaskPolicy? existingWorkPolicy, Duration initialDelay = Duration.zero, Constraints? constraints, BackoffPolicy? backoffPolicy, Duration backoffPolicyDelay = Duration.zero, OutOfQuotaPolicy? outOfQuotaPolicy, Map<String, dynamic>? inputData})',
      'registerPeriodicTask': 'Future<void> registerPeriodicTask(String uniqueName, String taskName, {Duration? frequency, String? tag, ExistingTaskPolicy? existingWorkPolicy, Duration initialDelay = Duration.zero, Constraints? constraints, BackoffPolicy? backoffPolicy, Duration backoffPolicyDelay = Duration.zero, OutOfQuotaPolicy? outOfQuotaPolicy, Map<String, dynamic>? inputData})',
      'registerProcessingTask': 'Future<void> registerProcessingTask(String uniqueName, String taskName, {Duration initialDelay = Duration.zero, Constraints? constraints})',
      'checkBackgroundRefreshPermission': 'Future<BackgroundRefreshPermissionState> checkBackgroundRefreshPermission()',
      'cancelByUniqueName': 'Future<void> cancelByUniqueName(String uniqueName)',
      'cancelByTag': 'Future<void> cancelByTag(String tag)',
      'cancelAll': 'Future<void> cancelAll()',
      'printScheduledTasks': 'Future<void> printScheduledTasks()',
    },
    staticGetterSignatures: {
      'iOSBackgroundTask': 'String get iOSBackgroundTask',
      'iOSBackgroundProcessingTask': 'String get iOSBackgroundProcessingTask',
    },
  );
}


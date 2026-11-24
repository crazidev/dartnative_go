// D4rt Bridge - Generated file, do not edit
// Sources: 4 files
// Generated: 2026-11-24T16:21:01.506139 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';

import 'package:dartnative_permissions/src/permission.dart'
    as $dartnative_permissions_1;
import 'package:dartnative_permissions/src/permission_ffi_bindings.dart'
    as $dartnative_permissions_2;
import 'package:dartnative_permissions/src/permission_status.dart'
    as $dartnative_permissions_3;

/// Bridge class for dartnative_permissions module.
class DartnativePermissionsBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createPermissionBridge(),
      _createPermissionFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'Permission': _createPermissionBridge,
      'PermissionFFIBindings': _createPermissionFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'Permission': $dartnative_permissions_1.Permission,
      'PermissionFFIBindings': $dartnative_permissions_2.PermissionFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'Permission': 'package:dartnative_permissions/src/permission.dart',
      'PermissionFFIBindings':
          'package:dartnative_permissions/src/permission_ffi_bindings.dart',
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
      BridgedEnumDefinition<$dartnative_permissions_3.PermissionStatus>(
        name: 'PermissionStatus',
        values: $dartnative_permissions_3.PermissionStatus.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'PermissionStatus':
          'package:dartnative_permissions/src/permission_status.dart',
    };
  }

  /// Returns all bridged extension definitions.
  static List<BridgedExtensionDefinition> bridgedExtensions() {
    return [
      BridgedExtensionDefinition(
        name: 'PermissionStatusExtension',
        onTypeName: 'PermissionStatus',
        getters: {
          'isGranted': (visitor, target) =>
              (target as $dartnative_permissions_3.PermissionStatus).isGranted,
          'isDenied': (visitor, target) =>
              (target as $dartnative_permissions_3.PermissionStatus).isDenied,
          'isPermanentlyDenied': (visitor, target) =>
              (target as $dartnative_permissions_3.PermissionStatus)
                  .isPermanentlyDenied,
          'isLimited': (visitor, target) =>
              (target as $dartnative_permissions_3.PermissionStatus).isLimited,
        },
      ),
    ];
  }

  /// Returns a map of extension identifiers to their canonical source URIs.
  static Map<String, String> extensionSourceUris() {
    return {
      'PermissionStatusExtension@PermissionStatus':
          'package:dartnative_permissions/src/permission_status.dart',
    };
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
        source: 'package:dartnative_permissions/dartnative_permissions.dart',
        target: 'package:dartnative_permissions/src/permission.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_permissions/dartnative_permissions.dart',
        target: 'package:dartnative_permissions/src/permission_status.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_permissions/dartnative_permissions.dart',
        target:
            'package:dartnative_permissions/src/permission_ffi_bindings.dart',
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

    // Register bridged extensions with source URIs for deduplication
    final extensions = bridgedExtensions();
    final extSources = extensionSourceUris();
    for (final extDef in extensions) {
      final extKey = '${extDef.name ?? '<unnamed>'}@${extDef.onTypeName}';
      interpreter.registerBridgedExtension(
        extDef,
        importPath,
        sourceUri: extSources[extKey],
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
      'openAppSettings': (visitor, positional, named, typeArgs) {
        return $dartnative_permissions_1.openAppSettings();
      },
      'permissionStatusFromNative': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'permissionStatusFromNative');
        final code = D4.getRequiredArg<int>(
          positional,
          0,
          'code',
          'permissionStatusFromNative',
        );
        return $dartnative_permissions_3.permissionStatusFromNative(code);
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'openAppSettings': 'package:dartnative_permissions/src/permission.dart',
      'permissionStatusFromNative':
          'package:dartnative_permissions/src/permission_status.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'openAppSettings': 'void openAppSettings()',
      'permissionStatusFromNative':
          'PermissionStatus permissionStatusFromNative(int code)',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative_permissions/src/permission.dart',
      'package:dartnative_permissions/src/permission_ffi_bindings.dart',
      'package:dartnative_permissions/src/permission_status.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_permissions/dartnative_permissions.dart';";
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
    'PermissionStatus',
  ];
}

// =============================================================================
// Permission Bridge
// =============================================================================

BridgedClass _createPermissionBridge() {
  return BridgedClass(
    nativeType: $dartnative_permissions_1.Permission,
    name: 'Permission',
    isAssignable: (v) => v is $dartnative_permissions_1.Permission,
    constructors: {},
    getters: {
      'status': (visitor, target) => D4
          .validateTarget<$dartnative_permissions_1.Permission>(
            target,
            'Permission',
          )
          .status,
      'isGranted': (visitor, target) => D4
          .validateTarget<$dartnative_permissions_1.Permission>(
            target,
            'Permission',
          )
          .isGranted,
      'isLimited': (visitor, target) => D4
          .validateTarget<$dartnative_permissions_1.Permission>(
            target,
            'Permission',
          )
          .isLimited,
      'hashCode': (visitor, target) => D4
          .validateTarget<$dartnative_permissions_1.Permission>(
            target,
            'Permission',
          )
          .hashCode,
    },
    methods: {
      'request': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_permissions_1.Permission>(
          target,
          'Permission',
        );
        return t.request();
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_permissions_1.Permission>(
          target,
          'Permission',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_permissions_1.Permission>(
          target,
          'Permission',
        );
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(
          positional,
          0,
          'other',
          'operator==',
        );
        return t == other;
      },
    },
    staticGetters: {
      'microphone': (visitor) =>
          $dartnative_permissions_1.Permission.microphone,
      'notification': (visitor) =>
          $dartnative_permissions_1.Permission.notification,
      'photos': (visitor) => $dartnative_permissions_1.Permission.photos,
      'camera': (visitor) => $dartnative_permissions_1.Permission.camera,
      'location': (visitor) => $dartnative_permissions_1.Permission.location,
      'locationWhenInUse': (visitor) =>
          $dartnative_permissions_1.Permission.locationWhenInUse,
      'contacts': (visitor) => $dartnative_permissions_1.Permission.contacts,
      'storage': (visitor) => $dartnative_permissions_1.Permission.storage,
      'videos': (visitor) => $dartnative_permissions_1.Permission.videos,
      'ignoreBatteryOptimizations': (visitor) =>
          $dartnative_permissions_1.Permission.ignoreBatteryOptimizations,
      'accessNotificationPolicy': (visitor) =>
          $dartnative_permissions_1.Permission.accessNotificationPolicy,
    },
    methodSignatures: {
      'request': 'Future<PermissionStatus> request()',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'status': 'Future<PermissionStatus> get status',
      'isGranted': 'Future<bool> get isGranted',
      'isLimited': 'Future<bool> get isLimited',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'microphone': 'Permission get microphone',
      'notification': 'Permission get notification',
      'photos': 'Permission get photos',
      'camera': 'Permission get camera',
      'location': 'Permission get location',
      'locationWhenInUse': 'Permission get locationWhenInUse',
      'contacts': 'Permission get contacts',
      'storage': 'Permission get storage',
      'videos': 'Permission get videos',
      'ignoreBatteryOptimizations': 'Permission get ignoreBatteryOptimizations',
      'accessNotificationPolicy': 'Permission get accessNotificationPolicy',
    },
  );
}

// =============================================================================
// PermissionFFIBindings Bridge
// =============================================================================

BridgedClass _createPermissionFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_permissions_2.PermissionFFIBindings,
    name: 'PermissionFFIBindings',
    isAssignable: (v) => v is $dartnative_permissions_2.PermissionFFIBindings,
    constructors: {},
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_permissions_2.PermissionFFIBindings.loadSymbols();
      },
      'request': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'request');
        final permissionId = D4.getRequiredArg<int>(
          positional,
          0,
          'permissionId',
          'request',
        );
        return $dartnative_permissions_2.PermissionFFIBindings.request(
          permissionId,
        );
      },
      'checkStatus': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'checkStatus');
        final permissionId = D4.getRequiredArg<int>(
          positional,
          0,
          'permissionId',
          'checkStatus',
        );
        return $dartnative_permissions_2.PermissionFFIBindings.checkStatus(
          permissionId,
        );
      },
      'openAppSettings': (visitor, positional, named, typeArgs) {
        return $dartnative_permissions_2
            .PermissionFFIBindings.openAppSettings();
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'request': 'Future<PermissionStatus> request(int permissionId)',
      'checkStatus': 'Future<PermissionStatus> checkStatus(int permissionId)',
      'openAppSettings': 'void openAppSettings()',
    },
  );
}

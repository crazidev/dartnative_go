// D4rt Bridge - Generated file, do not edit
// Sources: 3 files
// Generated: 2026-11-16T04:48:40.906787 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';

import 'package:dartnative_system/src/app_badge.dart' as $dartnative_system_1;
import 'package:dartnative_system/src/package_info.dart'
    as $dartnative_system_2;
import 'package:dartnative_system/src/system_ffi_bindings.dart'
    as $dartnative_system_3;

/// Bridge class for dartnative_system module.
class DartnativeSystemBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createPackageInfoBridge(),
      _createAppBadgePlusBridge(),
      _createSystemFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'PackageInfo': _createPackageInfoBridge,
      'AppBadgePlus': _createAppBadgePlusBridge,
      'SystemFFIBindings': _createSystemFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'PackageInfo': $dartnative_system_2.PackageInfo,
      'AppBadgePlus': $dartnative_system_1.AppBadgePlus,
      'SystemFFIBindings': $dartnative_system_3.SystemFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'PackageInfo': 'package:dartnative_system/src/package_info.dart',
      'AppBadgePlus': 'package:dartnative_system/src/app_badge.dart',
      'SystemFFIBindings':
          'package:dartnative_system/src/system_ffi_bindings.dart',
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
    return [];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {};
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
        source: 'package:dartnative_system/dartnative_system.dart',
        target: 'package:dartnative_system/src/package_info.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_system/dartnative_system.dart',
        target: 'package:dartnative_system/src/app_badge.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_system/dartnative_system.dart',
        target: 'package:dartnative_system/src/system_ffi_bindings.dart',
        show: {'SystemFFIBindings'},
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
      'package:dartnative_system/src/app_badge.dart',
      'package:dartnative_system/src/package_info.dart',
      'package:dartnative_system/src/system_ffi_bindings.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_system/dartnative_system.dart';";
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
// PackageInfo Bridge
// =============================================================================

BridgedClass _createPackageInfoBridge() {
  return BridgedClass(
    nativeType: $dartnative_system_2.PackageInfo,
    name: 'PackageInfo',
    isAssignable: (v) => v is $dartnative_system_2.PackageInfo,
    constructors: {
      '': (visitor, positional, named) {
        final appName = D4.getRequiredNamedArg<String>(
          named,
          'appName',
          'PackageInfo',
        );
        final packageName = D4.getRequiredNamedArg<String>(
          named,
          'packageName',
          'PackageInfo',
        );
        final version = D4.getRequiredNamedArg<String>(
          named,
          'version',
          'PackageInfo',
        );
        final buildNumber = D4.getRequiredNamedArg<String>(
          named,
          'buildNumber',
          'PackageInfo',
        );
        return $dartnative_system_2.PackageInfo(
          appName: appName,
          packageName: packageName,
          version: version,
          buildNumber: buildNumber,
        );
      },
    },
    getters: {
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_system_2.PackageInfo>(
            target,
            'PackageInfo',
          )
          .appName,
      'packageName': (visitor, target) => D4
          .validateTarget<$dartnative_system_2.PackageInfo>(
            target,
            'PackageInfo',
          )
          .packageName,
      'version': (visitor, target) => D4
          .validateTarget<$dartnative_system_2.PackageInfo>(
            target,
            'PackageInfo',
          )
          .version,
      'buildNumber': (visitor, target) => D4
          .validateTarget<$dartnative_system_2.PackageInfo>(
            target,
            'PackageInfo',
          )
          .buildNumber,
    },
    staticMethods: {
      'fromPlatform': (visitor, positional, named, typeArgs) {
        return $dartnative_system_2.PackageInfo.fromPlatform();
      },
    },
    constructorSignatures: {
      '': 'const PackageInfo({required String appName, required String packageName, required String version, required String buildNumber})',
    },
    getterSignatures: {
      'appName': 'String get appName',
      'packageName': 'String get packageName',
      'version': 'String get version',
      'buildNumber': 'String get buildNumber',
    },
    staticMethodSignatures: {
      'fromPlatform': 'Future<PackageInfo> fromPlatform()',
    },
  );
}

// =============================================================================
// AppBadgePlus Bridge
// =============================================================================

BridgedClass _createAppBadgePlusBridge() {
  return BridgedClass(
    nativeType: $dartnative_system_1.AppBadgePlus,
    name: 'AppBadgePlus',
    isAssignable: (v) => v is $dartnative_system_1.AppBadgePlus,
    constructors: {},
    staticMethods: {
      'isSupported': (visitor, positional, named, typeArgs) {
        return $dartnative_system_1.AppBadgePlus.isSupported();
      },
      'updateBadge': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'updateBadge');
        final count = D4.getRequiredArg<int>(
          positional,
          0,
          'count',
          'updateBadge',
        );
        return $dartnative_system_1.AppBadgePlus.updateBadge(count);
      },
    },
    staticMethodSignatures: {
      'isSupported': 'Future<bool> isSupported()',
      'updateBadge': 'Future<void> updateBadge(int count)',
    },
  );
}

// =============================================================================
// SystemFFIBindings Bridge
// =============================================================================

BridgedClass _createSystemFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_system_3.SystemFFIBindings,
    name: 'SystemFFIBindings',
    isAssignable: (v) => v is $dartnative_system_3.SystemFFIBindings,
    constructors: {},
    methods: {
      'getPackageInfo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_system_3.SystemFFIBindings>(
          target,
          'SystemFFIBindings',
        );
        return t.getPackageInfo();
      },
      'updateBadge': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_system_3.SystemFFIBindings>(
          target,
          'SystemFFIBindings',
        );
        D4.requireMinArgs(positional, 1, 'updateBadge');
        final count = D4.getRequiredArg<int>(
          positional,
          0,
          'count',
          'updateBadge',
        );
        t.updateBadge(count);
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) => $dartnative_system_3.SystemFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_system_3.SystemFFIBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'getPackageInfo': 'PackageInfo getPackageInfo()',
      'updateBadge': 'void updateBadge(int count)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'SystemFFIBindings get instance',
    },
  );
}

// D4rt Bridge - Generated file, do not edit
// Sources: 3 files
// Generated: 2026-09-21T20:33:09.372855 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';

import 'package:dartnative_url_launcher/src/dartnative_url_launcher.dart' as $dartnative_url_launcher_1;
import 'package:dartnative_url_launcher/src/url_launcher_ffi_bindings.dart' as $dartnative_url_launcher_2;
import 'package:dartnative_url_launcher/src/url_launcher_helper.dart' as $dartnative_url_launcher_3;

/// Bridge class for dartnative_url_launcher module.
class DartnativeUrlLauncherBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createDartNativeUrlLauncherBridge(),
      _createUrlLauncherFFIBindingsBridge(),
      _createUrlLauncherHelperBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'DartNativeUrlLauncher': _createDartNativeUrlLauncherBridge,
      'UrlLauncherFFIBindings': _createUrlLauncherFFIBindingsBridge,
      'UrlLauncherHelper': _createUrlLauncherHelperBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'DartNativeUrlLauncher': $dartnative_url_launcher_1.DartNativeUrlLauncher,
      'UrlLauncherFFIBindings': $dartnative_url_launcher_2.UrlLauncherFFIBindings,
      'UrlLauncherHelper': $dartnative_url_launcher_3.UrlLauncherHelper,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'DartNativeUrlLauncher': 'package:dartnative_url_launcher/src/dartnative_url_launcher.dart',
      'UrlLauncherFFIBindings': 'package:dartnative_url_launcher/src/url_launcher_ffi_bindings.dart',
      'UrlLauncherHelper': 'package:dartnative_url_launcher/src/url_launcher_helper.dart',
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
      (source: 'package:dartnative_url_launcher/dartnative_url_launcher.dart', target: 'package:dartnative_url_launcher/src/dartnative_url_launcher.dart', show: null, hide: null),
      (source: 'package:dartnative_url_launcher/dartnative_url_launcher.dart', target: 'package:dartnative_url_launcher/src/url_launcher_ffi_bindings.dart', show: {'UrlLauncherFFIBindings'}, hide: null),
      (source: 'package:dartnative_url_launcher/dartnative_url_launcher.dart', target: 'package:dartnative_url_launcher/src/url_launcher_helper.dart', show: null, hide: null),
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
      'package:dartnative_url_launcher/src/dartnative_url_launcher.dart',
      'package:dartnative_url_launcher/src/url_launcher_ffi_bindings.dart',
      'package:dartnative_url_launcher/src/url_launcher_helper.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_url_launcher/dartnative_url_launcher.dart';";
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
// DartNativeUrlLauncher Bridge
// =============================================================================

BridgedClass _createDartNativeUrlLauncherBridge() {
  return BridgedClass(
    nativeType: $dartnative_url_launcher_1.DartNativeUrlLauncher,
    name: 'DartNativeUrlLauncher',
    isAssignable: (v) => v is $dartnative_url_launcher_1.DartNativeUrlLauncher,
    constructors: {
    },
    staticMethods: {
      'canLaunch': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'canLaunch');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'canLaunch');
        return $dartnative_url_launcher_1.DartNativeUrlLauncher.canLaunch(url);
      },
      'launch': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'launch');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'launch');
        return $dartnative_url_launcher_1.DartNativeUrlLauncher.launch(url);
      },
    },
    staticMethodSignatures: {
      'canLaunch': 'bool canLaunch(String url)',
      'launch': 'Future<bool> launch(String url)',
    },
  );
}

// =============================================================================
// UrlLauncherFFIBindings Bridge
// =============================================================================

BridgedClass _createUrlLauncherFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_url_launcher_2.UrlLauncherFFIBindings,
    name: 'UrlLauncherFFIBindings',
    isAssignable: (v) => v is $dartnative_url_launcher_2.UrlLauncherFFIBindings,
    constructors: {
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_url_launcher_2.UrlLauncherFFIBindings.loadSymbols();
      },
      'canLaunch': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'canLaunch');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'canLaunch');
        return $dartnative_url_launcher_2.UrlLauncherFFIBindings.canLaunch(url);
      },
      'launch': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'launch');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'launch');
        return $dartnative_url_launcher_2.UrlLauncherFFIBindings.launch(url);
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'canLaunch': 'bool canLaunch(String url)',
      'launch': 'Future<bool> launch(String url)',
    },
  );
}

// =============================================================================
// UrlLauncherHelper Bridge
// =============================================================================

BridgedClass _createUrlLauncherHelperBridge() {
  return BridgedClass(
    nativeType: $dartnative_url_launcher_3.UrlLauncherHelper,
    name: 'UrlLauncherHelper',
    isAssignable: (v) => v is $dartnative_url_launcher_3.UrlLauncherHelper,
    isAbstract: true,
    constructors: {
    },
    staticMethods: {
      'open': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'open');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'open');
        return $dartnative_url_launcher_3.UrlLauncherHelper.open(url);
      },
    },
    staticMethodSignatures: {
      'open': 'Future<(bool, String)> open(String url)',
    },
  );
}


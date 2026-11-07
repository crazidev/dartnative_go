// D4rt Bridge - Generated file, do not edit
// Sources: 2 files
// Generated: 2026-11-06T23:46:44.472125 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';

import 'package:dartnative_share/src/share.dart' as $dartnative_share_1;
import 'package:dartnative_share/src/share_ffi_bindings.dart'
    as $dartnative_share_2;

/// Bridge class for dartnative_share module.
class DartnativeShareBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createShareResultBridge(),
      _createShareBridge(),
      _createShareFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'ShareResult': _createShareResultBridge,
      'Share': _createShareBridge,
      'ShareFFIBindings': _createShareFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'ShareResult': $dartnative_share_1.ShareResult,
      'Share': $dartnative_share_1.Share,
      'ShareFFIBindings': $dartnative_share_2.ShareFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'ShareResult': 'package:dartnative_share/src/share.dart',
      'Share': 'package:dartnative_share/src/share.dart',
      'ShareFFIBindings':
          'package:dartnative_share/src/share_ffi_bindings.dart',
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
      BridgedEnumDefinition<$dartnative_share_1.ShareResultStatus>(
        name: 'ShareResultStatus',
        values: $dartnative_share_1.ShareResultStatus.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'ShareResultStatus': 'package:dartnative_share/src/share.dart',
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
        source: 'package:dartnative_share/dartnative_share.dart',
        target: 'package:dartnative_share/src/share.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_share/dartnative_share.dart',
        target: 'package:dartnative_share/src/share_ffi_bindings.dart',
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
      'package:dartnative_share/src/share.dart',
      'package:dartnative_share/src/share_ffi_bindings.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_share/dartnative_share.dart';";
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
    'ShareResultStatus',
  ];
}

// =============================================================================
// ShareResult Bridge
// =============================================================================

BridgedClass _createShareResultBridge() {
  return BridgedClass(
    nativeType: $dartnative_share_1.ShareResult,
    name: 'ShareResult',
    isAssignable: (v) => v is $dartnative_share_1.ShareResult,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'ShareResult');
        final status = D4.getRequiredArg<$dartnative_share_1.ShareResultStatus>(
          positional,
          0,
          'status',
          'ShareResult',
        );
        final raw = D4.getNamedArgWithDefault<String>(named, 'raw', '');
        return $dartnative_share_1.ShareResult(status, raw: raw);
      },
    },
    getters: {
      'status': (visitor, target) => D4
          .validateTarget<$dartnative_share_1.ShareResult>(
            target,
            'ShareResult',
          )
          .status,
      'raw': (visitor, target) => D4
          .validateTarget<$dartnative_share_1.ShareResult>(
            target,
            'ShareResult',
          )
          .raw,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_share_1.ShareResult>(
          target,
          'ShareResult',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const ShareResult(ShareResultStatus status, {String raw = \'\'})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'status': 'ShareResultStatus get status',
      'raw': 'String get raw',
    },
  );
}

// =============================================================================
// Share Bridge
// =============================================================================

BridgedClass _createShareBridge() {
  return BridgedClass(
    nativeType: $dartnative_share_1.Share,
    name: 'Share',
    isAssignable: (v) => v is $dartnative_share_1.Share,
    constructors: {},
    staticMethods: {
      'share': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'share');
        final text = D4.getRequiredArg<String>(positional, 0, 'text', 'share');
        return $dartnative_share_1.Share.share(text);
      },
      'shareFile': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shareFile');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'shareFile',
        );
        final mimeType = D4.getOptionalNamedArg<String?>(named, 'mimeType');
        final text = D4.getOptionalNamedArg<String?>(named, 'text');
        return $dartnative_share_1.Share.shareFile(
          path,
          mimeType: mimeType,
          text: text,
        );
      },
      'shareFiles': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shareFiles');
        if (positional.isEmpty) {
          throw ArgumentError(
            'shareFiles: Missing required argument "paths" at position 0',
          );
        }
        final paths = D4.coerceList<String>(positional[0], 'paths');
        final mimeTypes = D4.coerceListOrNull<String>(
          named['mimeTypes'],
          'mimeTypes',
        );
        final text = D4.getOptionalNamedArg<String?>(named, 'text');
        return $dartnative_share_1.Share.shareFiles(
          paths,
          mimeTypes: mimeTypes,
          text: text,
        );
      },
      'shareWithResult': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shareWithResult');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'shareWithResult',
        );
        return $dartnative_share_1.Share.shareWithResult(text);
      },
      'shareFileWithResult': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shareFileWithResult');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'shareFileWithResult',
        );
        final mimeType = D4.getOptionalNamedArg<String?>(named, 'mimeType');
        final text = D4.getOptionalNamedArg<String?>(named, 'text');
        return $dartnative_share_1.Share.shareFileWithResult(
          path,
          mimeType: mimeType,
          text: text,
        );
      },
      'shareFilesWithResult': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shareFilesWithResult');
        if (positional.isEmpty) {
          throw ArgumentError(
            'shareFilesWithResult: Missing required argument "paths" at position 0',
          );
        }
        final paths = D4.coerceList<String>(positional[0], 'paths');
        final mimeTypes = D4.coerceListOrNull<String>(
          named['mimeTypes'],
          'mimeTypes',
        );
        final text = D4.getOptionalNamedArg<String?>(named, 'text');
        return $dartnative_share_1.Share.shareFilesWithResult(
          paths,
          mimeTypes: mimeTypes,
          text: text,
        );
      },
    },
    staticMethodSignatures: {
      'share': 'void share(String text)',
      'shareFile':
          'void shareFile(String path, {String? mimeType, String? text})',
      'shareFiles':
          'void shareFiles(List<String> paths, {List<String>? mimeTypes, String? text})',
      'shareWithResult': 'Future<ShareResult> shareWithResult(String text)',
      'shareFileWithResult':
          'Future<ShareResult> shareFileWithResult(String path, {String? mimeType, String? text})',
      'shareFilesWithResult':
          'Future<ShareResult> shareFilesWithResult(List<String> paths, {List<String>? mimeTypes, String? text})',
    },
  );
}

// =============================================================================
// ShareFFIBindings Bridge
// =============================================================================

BridgedClass _createShareFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_share_2.ShareFFIBindings,
    name: 'ShareFFIBindings',
    isAssignable: (v) => v is $dartnative_share_2.ShareFFIBindings,
    constructors: {},
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_share_2.ShareFFIBindings.loadSymbols();
      },
      'shareText': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shareText');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'shareText',
        );
        return $dartnative_share_2.ShareFFIBindings.shareText(text);
      },
      'shareTextWithResult': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shareTextWithResult');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'shareTextWithResult',
        );
        return $dartnative_share_2.ShareFFIBindings.shareTextWithResult(text);
      },
      'shareFiles': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shareFiles');
        if (positional.isEmpty) {
          throw ArgumentError(
            'shareFiles: Missing required argument "paths" at position 0',
          );
        }
        final paths = D4.coerceList<String>(positional[0], 'paths');
        final mimeTypes = D4.coerceListOrNull<String>(
          named['mimeTypes'],
          'mimeTypes',
        );
        final text = D4.getOptionalNamedArg<String?>(named, 'text');
        return $dartnative_share_2.ShareFFIBindings.shareFiles(
          paths,
          mimeTypes: mimeTypes,
          text: text,
        );
      },
      'shareFilesWithResult': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shareFilesWithResult');
        if (positional.isEmpty) {
          throw ArgumentError(
            'shareFilesWithResult: Missing required argument "paths" at position 0',
          );
        }
        final paths = D4.coerceList<String>(positional[0], 'paths');
        final mimeTypes = D4.coerceListOrNull<String>(
          named['mimeTypes'],
          'mimeTypes',
        );
        final text = D4.getOptionalNamedArg<String?>(named, 'text');
        return $dartnative_share_2.ShareFFIBindings.shareFilesWithResult(
          paths,
          mimeTypes: mimeTypes,
          text: text,
        );
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'shareText': 'void shareText(String text)',
      'shareTextWithResult':
          'Future<ShareResult> shareTextWithResult(String text)',
      'shareFiles':
          'void shareFiles(List<String> paths, {List<String>? mimeTypes, String? text})',
      'shareFilesWithResult':
          'Future<ShareResult> shareFilesWithResult(List<String> paths, {List<String>? mimeTypes, String? text})',
    },
  );
}

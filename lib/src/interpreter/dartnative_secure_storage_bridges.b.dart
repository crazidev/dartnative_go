// D4rt Bridge - Generated file, do not edit
// Sources: 2 files
// Generated: 2026-11-24T16:20:40.880252 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'dart:ffi';

import 'package:dartnative_secure_storage/src/secure_bindings.dart'
    as $dartnative_secure_storage_1;
import 'package:dartnative_secure_storage/src/secure_storage.dart'
    as $dartnative_secure_storage_2;
import 'package:ffi/src/utf8.dart' as $ffi_1;

/// Bridge class for dartnative_secure_storage module.
class DartnativeSecureStorageBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createIOSOptionsBridge(),
      _createAndroidOptionsBridge(),
      _createSecureStorageBridge(),
      _createSecureBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'IOSOptions': _createIOSOptionsBridge,
      'AndroidOptions': _createAndroidOptionsBridge,
      'SecureStorage': _createSecureStorageBridge,
      'SecureBindings': _createSecureBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'IOSOptions': $dartnative_secure_storage_2.IOSOptions,
      'AndroidOptions': $dartnative_secure_storage_2.AndroidOptions,
      'SecureStorage': $dartnative_secure_storage_2.SecureStorage,
      'SecureBindings': $dartnative_secure_storage_1.SecureBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'IOSOptions': 'package:dartnative_secure_storage/src/secure_storage.dart',
      'AndroidOptions':
          'package:dartnative_secure_storage/src/secure_storage.dart',
      'SecureStorage':
          'package:dartnative_secure_storage/src/secure_storage.dart',
      'SecureBindings':
          'package:dartnative_secure_storage/src/secure_bindings.dart',
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
    return [
      '_ReadDart',
      '_WriteDart',
      '_DeleteDart',
      '_NoArgDart',
      '_ContainsDart',
      '_ReadAllDart',
    ];
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
        source:
            'package:dartnative_secure_storage/dartnative_secure_storage.dart',
        target: 'package:dartnative_secure_storage/src/secure_storage.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_secure_storage/dartnative_secure_storage.dart',
        target: 'package:dartnative_secure_storage/src/secure_bindings.dart',
        show: {'SecureBindings'},
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

    // Register function typedefs for type resolution
    final typedefs = functionTypedefs();
    for (final name in typedefs) {
      interpreter.registerFunctionTypedef(name, importPath);
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
      'package:dartnative_secure_storage/src/secure_bindings.dart',
      'package:dartnative_secure_storage/src/secure_storage.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_secure_storage/dartnative_secure_storage.dart';";
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
// IOSOptions Bridge
// =============================================================================

BridgedClass _createIOSOptionsBridge() {
  return BridgedClass(
    nativeType: $dartnative_secure_storage_2.IOSOptions,
    name: 'IOSOptions',
    isAssignable: (v) => v is $dartnative_secure_storage_2.IOSOptions,
    constructors: {
      '': (visitor, positional, named) {
        final accessibility = D4.getOptionalNamedArg<Object?>(
          named,
          'accessibility',
        );
        final synchronizable = D4.getOptionalNamedArg<bool?>(
          named,
          'synchronizable',
        );
        final groupId = D4.getOptionalNamedArg<String?>(named, 'groupId');
        return $dartnative_secure_storage_2.IOSOptions(
          accessibility: accessibility,
          synchronizable: synchronizable,
          groupId: groupId,
        );
      },
    },
    getters: {
      'accessibility': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_2.IOSOptions>(
            target,
            'IOSOptions',
          )
          .accessibility,
      'synchronizable': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_2.IOSOptions>(
            target,
            'IOSOptions',
          )
          .synchronizable,
      'groupId': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_2.IOSOptions>(
            target,
            'IOSOptions',
          )
          .groupId,
    },
    staticGetters: {
      'defaultOptions': (visitor) =>
          $dartnative_secure_storage_2.IOSOptions.defaultOptions,
    },
    constructorSignatures: {
      '': 'const IOSOptions({Object? accessibility, bool? synchronizable, String? groupId})',
    },
    getterSignatures: {
      'accessibility': 'Object? get accessibility',
      'synchronizable': 'bool? get synchronizable',
      'groupId': 'String? get groupId',
    },
    staticGetterSignatures: {
      'defaultOptions': 'IOSOptions get defaultOptions',
    },
  );
}

// =============================================================================
// AndroidOptions Bridge
// =============================================================================

BridgedClass _createAndroidOptionsBridge() {
  return BridgedClass(
    nativeType: $dartnative_secure_storage_2.AndroidOptions,
    name: 'AndroidOptions',
    isAssignable: (v) => v is $dartnative_secure_storage_2.AndroidOptions,
    constructors: {
      '': (visitor, positional, named) {
        final encryptedSharedPreferences = D4.getNamedArgWithDefault<bool>(
          named,
          'encryptedSharedPreferences',
          true,
        );
        final resetOnError = D4.getNamedArgWithDefault<bool>(
          named,
          'resetOnError',
          true,
        );
        return $dartnative_secure_storage_2.AndroidOptions(
          encryptedSharedPreferences: encryptedSharedPreferences,
          resetOnError: resetOnError,
        );
      },
    },
    getters: {
      'encryptedSharedPreferences': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_2.AndroidOptions>(
            target,
            'AndroidOptions',
          )
          .encryptedSharedPreferences,
      'resetOnError': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_2.AndroidOptions>(
            target,
            'AndroidOptions',
          )
          .resetOnError,
    },
    staticGetters: {
      'defaultOptions': (visitor) =>
          $dartnative_secure_storage_2.AndroidOptions.defaultOptions,
    },
    constructorSignatures: {
      '': 'const AndroidOptions({bool encryptedSharedPreferences = true, bool resetOnError = true})',
    },
    getterSignatures: {
      'encryptedSharedPreferences': 'bool get encryptedSharedPreferences',
      'resetOnError': 'bool get resetOnError',
    },
    staticGetterSignatures: {
      'defaultOptions': 'AndroidOptions get defaultOptions',
    },
  );
}

// =============================================================================
// SecureStorage Bridge
// =============================================================================

BridgedClass _createSecureStorageBridge() {
  return BridgedClass(
    nativeType: $dartnative_secure_storage_2.SecureStorage,
    name: 'SecureStorage',
    isAssignable: (v) => v is $dartnative_secure_storage_2.SecureStorage,
    constructors: {
      '': (visitor, positional, named) {
        final iOptions = D4
            .getNamedArgWithDefault<$dartnative_secure_storage_2.IOSOptions>(
              named,
              'iOptions',
              $dartnative_secure_storage_2.IOSOptions.defaultOptions,
            );
        final aOptions = D4
            .getNamedArgWithDefault<
              $dartnative_secure_storage_2.AndroidOptions
            >(
              named,
              'aOptions',
              $dartnative_secure_storage_2.AndroidOptions.defaultOptions,
            );
        return $dartnative_secure_storage_2.SecureStorage(
          iOptions: iOptions,
          aOptions: aOptions,
        );
      },
    },
    getters: {
      'iOptions': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_2.SecureStorage>(
            target,
            'SecureStorage',
          )
          .iOptions,
      'aOptions': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_2.SecureStorage>(
            target,
            'SecureStorage',
          )
          .aOptions,
    },
    methods: {
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_secure_storage_2.SecureStorage>(
          target,
          'SecureStorage',
        );
        final key = D4.getRequiredNamedArg<String>(named, 'key', 'read');
        final iOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.IOSOptions?>(
              named,
              'iOptions',
            );
        final aOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.AndroidOptions?>(
              named,
              'aOptions',
            );
        return t.read(key: key, iOptions: iOptions, aOptions: aOptions);
      },
      'write': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_secure_storage_2.SecureStorage>(
          target,
          'SecureStorage',
        );
        final key = D4.getRequiredNamedArg<String>(named, 'key', 'write');
        final value = D4.getRequiredNamedArg<String?>(named, 'value', 'write');
        final iOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.IOSOptions?>(
              named,
              'iOptions',
            );
        final aOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.AndroidOptions?>(
              named,
              'aOptions',
            );
        return t.write(
          key: key,
          value: value,
          iOptions: iOptions,
          aOptions: aOptions,
        );
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_secure_storage_2.SecureStorage>(
          target,
          'SecureStorage',
        );
        final key = D4.getRequiredNamedArg<String>(named, 'key', 'delete');
        final iOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.IOSOptions?>(
              named,
              'iOptions',
            );
        final aOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.AndroidOptions?>(
              named,
              'aOptions',
            );
        return t.delete(key: key, iOptions: iOptions, aOptions: aOptions);
      },
      'deleteAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_secure_storage_2.SecureStorage>(
          target,
          'SecureStorage',
        );
        final iOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.IOSOptions?>(
              named,
              'iOptions',
            );
        final aOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.AndroidOptions?>(
              named,
              'aOptions',
            );
        return t.deleteAll(iOptions: iOptions, aOptions: aOptions);
      },
      'containsKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_secure_storage_2.SecureStorage>(
          target,
          'SecureStorage',
        );
        final key = D4.getRequiredNamedArg<String>(named, 'key', 'containsKey');
        final iOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.IOSOptions?>(
              named,
              'iOptions',
            );
        final aOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.AndroidOptions?>(
              named,
              'aOptions',
            );
        return t.containsKey(key: key, iOptions: iOptions, aOptions: aOptions);
      },
      'readAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_secure_storage_2.SecureStorage>(
          target,
          'SecureStorage',
        );
        final iOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.IOSOptions?>(
              named,
              'iOptions',
            );
        final aOptions = D4
            .getOptionalNamedArg<$dartnative_secure_storage_2.AndroidOptions?>(
              named,
              'aOptions',
            );
        return t.readAll(iOptions: iOptions, aOptions: aOptions);
      },
    },
    constructorSignatures: {
      '': 'const SecureStorage({IOSOptions iOptions = IOSOptions.defaultOptions, AndroidOptions aOptions = AndroidOptions.defaultOptions})',
    },
    methodSignatures: {
      'read':
          'Future<String?> read({required String key, IOSOptions? iOptions, AndroidOptions? aOptions})',
      'write':
          'Future<void> write({required String key, required String? value, IOSOptions? iOptions, AndroidOptions? aOptions})',
      'delete':
          'Future<void> delete({required String key, IOSOptions? iOptions, AndroidOptions? aOptions})',
      'deleteAll':
          'Future<void> deleteAll({IOSOptions? iOptions, AndroidOptions? aOptions})',
      'containsKey':
          'Future<bool> containsKey({required String key, IOSOptions? iOptions, AndroidOptions? aOptions})',
      'readAll':
          'Future<Map<String, String>> readAll({IOSOptions? iOptions, AndroidOptions? aOptions})',
    },
    getterSignatures: {
      'iOptions': 'IOSOptions get iOptions',
      'aOptions': 'AndroidOptions get aOptions',
    },
  );
}

// =============================================================================
// SecureBindings Bridge
// =============================================================================

BridgedClass _createSecureBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_secure_storage_1.SecureBindings,
    name: 'SecureBindings',
    isAssignable: (v) => v is $dartnative_secure_storage_1.SecureBindings,
    constructors: {},
    getters: {
      'read': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
            target,
            'SecureBindings',
          )
          .read,
      'write': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
            target,
            'SecureBindings',
          )
          .write,
      'delete': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
            target,
            'SecureBindings',
          )
          .delete,
      'deleteAll': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
            target,
            'SecureBindings',
          )
          .deleteAll,
      'containsKey': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
            target,
            'SecureBindings',
          )
          .containsKey,
      'readAll': (visitor, target) => D4
          .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
            target,
            'SecureBindings',
          )
          .readAll,
    },
    setters: {
      'read': (visitor, target, value) {
        final readRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'read');
        D4
            .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
              target,
              'SecureBindings',
            )
            .read = (Pointer<$ffi_1.Utf8> p0, Pointer<$ffi_1.Utf8> p1, int p2) {
          D4.callInterpreterCallback(visitor!, readRaw, [p0, p1, p2]);
        };
      },
      'write': (visitor, target, value) {
        final writeRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'write');
        D4
                .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
                  target,
                  'SecureBindings',
                )
                .write =
            ((Pointer<$ffi_1.Utf8> p0, Pointer<$ffi_1.Utf8> p1) {
                  return D4.callInterpreterCallback(visitor!, writeRaw, [
                        p0,
                        p1,
                      ])
                      as int;
                })
                as int Function(Pointer<$ffi_1.Utf8>, Pointer<$ffi_1.Utf8>);
      },
      'delete': (visitor, target, value) {
        final deleteRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'delete');
        D4
            .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
              target,
              'SecureBindings',
            )
            .delete = (Pointer<$ffi_1.Utf8> p0) {
          D4.callInterpreterCallback(visitor!, deleteRaw, [p0]);
        };
      },
      'deleteAll': (visitor, target, value) {
        final deleteAllRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'deleteAll',
        );
        D4
            .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
              target,
              'SecureBindings',
            )
            .deleteAll = () {
          D4.callInterpreterCallback(visitor!, deleteAllRaw, []);
        };
      },
      'containsKey': (visitor, target, value) {
        final containsKeyRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'containsKey',
        );
        D4
                .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
                  target,
                  'SecureBindings',
                )
                .containsKey =
            ((Pointer<$ffi_1.Utf8> p0) {
                  return D4.callInterpreterCallback(visitor!, containsKeyRaw, [
                        p0,
                      ])
                      as int;
                })
                as int Function(Pointer<$ffi_1.Utf8>);
      },
      'readAll': (visitor, target, value) {
        final readAllRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'readAll',
        );
        D4
                .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
                  target,
                  'SecureBindings',
                )
                .readAll =
            ((Pointer<$ffi_1.Utf8> p0, int p1) {
                  return D4.callInterpreterCallback(visitor!, readAllRaw, [
                        p0,
                        p1,
                      ])
                      as int;
                })
                as int Function(Pointer<$ffi_1.Utf8>, int);
      },
    },
    methods: {
      'setResetOnError': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
              target,
              'SecureBindings',
            );
        D4.requireMinArgs(positional, 1, 'setResetOnError');
        final enabled = D4.getRequiredArg<bool>(
          positional,
          0,
          'enabled',
          'setResetOnError',
        );
        t.setResetOnError(enabled);
        return null;
      },
      'load': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_secure_storage_1.SecureBindings>(
              target,
              'SecureBindings',
            );
        t.load();
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) =>
          $dartnative_secure_storage_1.SecureBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_secure_storage_1.SecureBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'setResetOnError': 'void setResetOnError(bool enabled)',
      'load': 'void load()',
    },
    getterSignatures: {
      'read': '_ReadDart get read',
      'write': '_WriteDart get write',
      'delete': '_DeleteDart get delete',
      'deleteAll': '_NoArgDart get deleteAll',
      'containsKey': '_ContainsDart get containsKey',
      'readAll': '_ReadAllDart get readAll',
    },
    setterSignatures: {
      'read': 'set read(dynamic value)',
      'write': 'set write(dynamic value)',
      'delete': 'set delete(dynamic value)',
      'deleteAll': 'set deleteAll(dynamic value)',
      'containsKey': 'set containsKey(dynamic value)',
      'readAll': 'set readAll(dynamic value)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'SecureBindings get instance',
    },
  );
}

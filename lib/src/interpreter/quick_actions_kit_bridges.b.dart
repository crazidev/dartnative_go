// D4rt Bridge - Generated file, do not edit
// Sources: 3 files
// Generated: 2026-11-16T04:48:57.127204 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';

import 'package:quick_actions_kit/src/platform.dart' as $quick_actions_kit_1;
import 'package:quick_actions_kit/src/quick_actions_kit.dart'
    as $quick_actions_kit_2;
import 'package:quick_actions_kit/src/quick_actions_kit_bindings.dart'
    as $quick_actions_kit_3;

/// Bridge class for quick_actions_kit module.
class QuickActionsKitBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createShortcutItemBridge(),
      _createQuickActionsBridge(),
      _createQuickActionsExceptionBridge(),
      _createQuickActionsKitBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'ShortcutItem': _createShortcutItemBridge,
      'QuickActions': _createQuickActionsBridge,
      'QuickActionsException': _createQuickActionsExceptionBridge,
      'QuickActionsKitBindings': _createQuickActionsKitBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'ShortcutItem': $quick_actions_kit_2.ShortcutItem,
      'QuickActions': $quick_actions_kit_2.QuickActions,
      'QuickActionsException': $quick_actions_kit_1.QuickActionsException,
      'QuickActionsKitBindings': $quick_actions_kit_3.QuickActionsKitBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'ShortcutItem': 'package:quick_actions_kit/src/quick_actions_kit.dart',
      'QuickActions': 'package:quick_actions_kit/src/quick_actions_kit.dart',
      'QuickActionsException': 'package:quick_actions_kit/src/platform.dart',
      'QuickActionsKitBindings':
          'package:quick_actions_kit/src/quick_actions_kit_bindings.dart',
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
      'QuickActionsException': ['Exception'],
      'QuickActionsKitBindings': ['QuickActionsPlatform'],
    };
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
        source: 'package:quick_actions_kit/quick_actions_kit.dart',
        target: 'package:quick_actions_kit/src/quick_actions_kit.dart',
        show: {'QuickActions', 'ShortcutItem'},
        hide: null,
      ),
      (
        source: 'package:quick_actions_kit/quick_actions_kit.dart',
        target: 'package:quick_actions_kit/src/platform.dart',
        show: {'QuickActionsException'},
        hide: null,
      ),
      (
        source: 'package:quick_actions_kit/quick_actions_kit.dart',
        target: 'package:quick_actions_kit/src/quick_actions_kit_bindings.dart',
        show: {'QuickActionsKitBindings'},
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
      'package:quick_actions_kit/src/platform.dart',
      'package:quick_actions_kit/src/quick_actions_kit.dart',
      'package:quick_actions_kit/src/quick_actions_kit_bindings.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:quick_actions_kit/quick_actions_kit.dart';";
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
// ShortcutItem Bridge
// =============================================================================

BridgedClass _createShortcutItemBridge() {
  return BridgedClass(
    nativeType: $quick_actions_kit_2.ShortcutItem,
    name: 'ShortcutItem',
    isAssignable: (v) => v is $quick_actions_kit_2.ShortcutItem,
    constructors: {
      '': (visitor, positional, named) {
        final type = D4.getRequiredNamedArg<String>(
          named,
          'type',
          'ShortcutItem',
        );
        final localizedTitle = D4.getRequiredNamedArg<String>(
          named,
          'localizedTitle',
          'ShortcutItem',
        );
        final localizedSubtitle = D4.getOptionalNamedArg<String?>(
          named,
          'localizedSubtitle',
        );
        final icon = D4.getOptionalNamedArg<String?>(named, 'icon');
        return $quick_actions_kit_2.ShortcutItem(
          type: type,
          localizedTitle: localizedTitle,
          localizedSubtitle: localizedSubtitle,
          icon: icon,
        );
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$quick_actions_kit_2.ShortcutItem>(
            target,
            'ShortcutItem',
          )
          .type,
      'localizedTitle': (visitor, target) => D4
          .validateTarget<$quick_actions_kit_2.ShortcutItem>(
            target,
            'ShortcutItem',
          )
          .localizedTitle,
      'localizedSubtitle': (visitor, target) => D4
          .validateTarget<$quick_actions_kit_2.ShortcutItem>(
            target,
            'ShortcutItem',
          )
          .localizedSubtitle,
      'icon': (visitor, target) => D4
          .validateTarget<$quick_actions_kit_2.ShortcutItem>(
            target,
            'ShortcutItem',
          )
          .icon,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$quick_actions_kit_2.ShortcutItem>(
          target,
          'ShortcutItem',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const ShortcutItem({required String type, required String localizedTitle, String? localizedSubtitle, String? icon})',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'localizedTitle': 'String get localizedTitle',
      'localizedSubtitle': 'String? get localizedSubtitle',
      'icon': 'String? get icon',
    },
  );
}

// =============================================================================
// QuickActions Bridge
// =============================================================================

BridgedClass _createQuickActionsBridge() {
  return BridgedClass(
    nativeType: $quick_actions_kit_2.QuickActions,
    name: 'QuickActions',
    isAssignable: (v) => v is $quick_actions_kit_2.QuickActions,
    constructors: {
      '': (visitor, positional, named) {
        return $quick_actions_kit_2.QuickActions();
      },
      'withPlatform': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'QuickActions');
        final platform = D4
            .getRequiredArg<$quick_actions_kit_1.QuickActionsPlatform>(
              positional,
              0,
              '_platform',
              'QuickActions',
            );
        return $quick_actions_kit_2.QuickActions.withPlatform(platform);
      },
    },
    methods: {
      'initialize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$quick_actions_kit_2.QuickActions>(
          target,
          'QuickActions',
        );
        D4.requireMinArgs(positional, 1, 'initialize');
        if (positional.isEmpty) {
          throw ArgumentError(
            'initialize: Missing required argument "handler" at position 0',
          );
        }
        final handlerRaw = positional[0];
        return t.initialize((String p0) {
          D4.callInterpreterCallback(visitor!, handlerRaw, [p0]);
        });
      },
      'setShortcutItems': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$quick_actions_kit_2.QuickActions>(
          target,
          'QuickActions',
        );
        D4.requireMinArgs(positional, 1, 'setShortcutItems');
        if (positional.isEmpty) {
          throw ArgumentError(
            'setShortcutItems: Missing required argument "items" at position 0',
          );
        }
        final items = D4.coerceList<$quick_actions_kit_2.ShortcutItem>(
          positional[0],
          'items',
        );
        return t.setShortcutItems(items);
      },
      'clearShortcutItems': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$quick_actions_kit_2.QuickActions>(
          target,
          'QuickActions',
        );
        return t.clearShortcutItems();
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$quick_actions_kit_2.QuickActions>(
          target,
          'QuickActions',
        );
        return (t as dynamic).dispose();
      },
    },
    constructorSignatures: {
      '': 'factory QuickActions()',
      'withPlatform':
          'QuickActions.withPlatform(QuickActionsPlatform _platform)',
    },
    methodSignatures: {
      'initialize':
          'Future<void> initialize(void Function(String type) handler)',
      'setShortcutItems':
          'Future<void> setShortcutItems(List<ShortcutItem> items)',
      'clearShortcutItems': 'Future<void> clearShortcutItems()',
      'dispose': 'Future<void> dispose()',
    },
  );
}

// =============================================================================
// QuickActionsException Bridge
// =============================================================================

BridgedClass _createQuickActionsExceptionBridge() {
  return BridgedClass(
    nativeType: $quick_actions_kit_1.QuickActionsException,
    name: 'QuickActionsException',
    isAssignable: (v) => v is $quick_actions_kit_1.QuickActionsException,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'QuickActionsException');
        final code = D4.getRequiredArg<String>(
          positional,
          0,
          'code',
          'QuickActionsException',
        );
        final message = D4.getRequiredArg<String>(
          positional,
          1,
          'message',
          'QuickActionsException',
        );
        return $quick_actions_kit_1.QuickActionsException(code, message);
      },
    },
    getters: {
      'code': (visitor, target) => D4
          .validateTarget<$quick_actions_kit_1.QuickActionsException>(
            target,
            'QuickActionsException',
          )
          .code,
      'message': (visitor, target) => D4
          .validateTarget<$quick_actions_kit_1.QuickActionsException>(
            target,
            'QuickActionsException',
          )
          .message,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$quick_actions_kit_1.QuickActionsException>(
          target,
          'QuickActionsException',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const QuickActionsException(String code, String message)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'code': 'String get code',
      'message': 'String get message',
    },
  );
}

// =============================================================================
// QuickActionsKitBindings Bridge
// =============================================================================

BridgedClass _createQuickActionsKitBindingsBridge() {
  return BridgedClass(
    nativeType: $quick_actions_kit_3.QuickActionsKitBindings,
    name: 'QuickActionsKitBindings',
    isAssignable: (v) => v is $quick_actions_kit_3.QuickActionsKitBindings,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'actions': (visitor, target) => D4
          .validateTarget<$quick_actions_kit_3.QuickActionsKitBindings>(
            target,
            'QuickActionsKitBindings',
          )
          .actions,
    },
    methods: {
      'invoke': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$quick_actions_kit_3.QuickActionsKitBindings>(
              target,
              'QuickActionsKitBindings',
            );
        D4.requireMinArgs(positional, 1, 'invoke');
        final operation = D4.getRequiredArg<String>(
          positional,
          0,
          'operation',
          'invoke',
        );
        final payload = D4.getOptionalArg<Object?>(positional, 1, 'payload');
        return t.invoke(operation, payload);
      },
      'deliver': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$quick_actions_kit_3.QuickActionsKitBindings>(
              target,
              'QuickActionsKitBindings',
            );
        D4.requireMinArgs(positional, 3, 'deliver');
        final token = D4.getRequiredArg<int>(positional, 0, 'token', 'deliver');
        final kind = D4.getRequiredArg<int>(positional, 1, 'kind', 'deliver');
        final payload = D4.getRequiredArg<String>(
          positional,
          2,
          'payload',
          'deliver',
        );
        t.deliver(token, kind, payload);
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) =>
          $quick_actions_kit_3.QuickActionsKitBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $quick_actions_kit_3.QuickActionsKitBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'invoke': 'Future<void> invoke(String operation, [Object? payload])',
      'deliver': 'void deliver(int token, int kind, String payload)',
    },
    getterSignatures: {
      'actions': 'Stream<String> get actions',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'QuickActionsKitBindings get instance',
    },
  );
}

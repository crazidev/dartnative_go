// D4rt Bridge - Generated file, do not edit
// Sources: 2 files
// Generated: 2026-11-15T01:15:14.895906 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:dartnative_notifications/src/dartnative_notifications.dart'
    as $dartnative_notifications_1;
import 'package:dartnative_notifications/src/notifications_ffi_bindings.dart'
    as $dartnative_notifications_2;

/// Bridge class for dartnative_notifications module.
class DartnativeNotificationsBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createDartNativeNotificationsBridge(),
      _createNotificationsFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'DartNativeNotifications': _createDartNativeNotificationsBridge,
      'NotificationsFFIBindings': _createNotificationsFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'DartNativeNotifications':
          $dartnative_notifications_1.DartNativeNotifications,
      'NotificationsFFIBindings':
          $dartnative_notifications_2.NotificationsFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'DartNativeNotifications':
          'package:dartnative_notifications/src/dartnative_notifications.dart',
      'NotificationsFFIBindings':
          'package:dartnative_notifications/src/notifications_ffi_bindings.dart',
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
        source:
            'package:dartnative_notifications/dartnative_notifications.dart',
        target:
            'package:dartnative_notifications/src/dartnative_notifications.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_notifications/dartnative_notifications.dart',
        target:
            'package:dartnative_notifications/src/notifications_ffi_bindings.dart',
        show: {'NotificationsFFIBindings'},
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
      'package:dartnative_notifications/src/dartnative_notifications.dart',
      'package:dartnative_notifications/src/notifications_ffi_bindings.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_notifications/dartnative_notifications.dart';";
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
// DartNativeNotifications Bridge
// =============================================================================

BridgedClass _createDartNativeNotificationsBridge() {
  return BridgedClass(
    nativeType: $dartnative_notifications_1.DartNativeNotifications,
    name: 'DartNativeNotifications',
    isAssignable: (v) =>
        v is $dartnative_notifications_1.DartNativeNotifications,
    constructors: {},
    staticGetters: {
      'onTap': (visitor) =>
          $dartnative_notifications_1.DartNativeNotifications.onTap,
    },
    staticMethods: {
      'setup': (visitor, positional, named, typeArgs) {
        final onTapRaw = named['onTap'];
        final onTap = onTapRaw == null
            ? null
            : (String p0) {
                D4.callInterpreterCallback(visitor!, onTapRaw, [p0]);
              };
        return $dartnative_notifications_1.DartNativeNotifications.setup(
          onTap: onTap,
        );
      },
      'getInitialTapPayload': (visitor, positional, named, typeArgs) {
        return $dartnative_notifications_1
            .DartNativeNotifications.getInitialTapPayload();
      },
      'requestPermission': (visitor, positional, named, typeArgs) {
        return $dartnative_notifications_1
            .DartNativeNotifications.requestPermission();
      },
      'show': (visitor, positional, named, typeArgs) {
        final id = D4.getRequiredNamedArg<String>(named, 'id', 'show');
        final title = D4.getRequiredNamedArg<String>(named, 'title', 'show');
        final body = D4.getRequiredNamedArg<String>(named, 'body', 'show');
        final payload = D4.getNamedArgWithDefault<String>(named, 'payload', '');
        final delaySeconds = D4.getNamedArgWithDefault<int>(
          named,
          'delaySeconds',
          0,
        );
        return $dartnative_notifications_1.DartNativeNotifications.show(
          id: id,
          title: title,
          body: body,
          payload: payload,
          delaySeconds: delaySeconds,
        );
      },
      'showChat': (visitor, positional, named, typeArgs) {
        final id = D4.getRequiredNamedArg<String>(named, 'id', 'showChat');
        final senderName = D4.getRequiredNamedArg<String>(
          named,
          'senderName',
          'showChat',
        );
        final body = D4.getRequiredNamedArg<String>(named, 'body', 'showChat');
        final avatar = D4.getRequiredNamedArg<Uint8List>(
          named,
          'avatar',
          'showChat',
        );
        final payload = D4.getNamedArgWithDefault<String>(named, 'payload', '');
        final delaySeconds = D4.getNamedArgWithDefault<int>(
          named,
          'delaySeconds',
          0,
        );
        return $dartnative_notifications_1.DartNativeNotifications.showChat(
          id: id,
          senderName: senderName,
          body: body,
          avatar: avatar,
          payload: payload,
          delaySeconds: delaySeconds,
        );
      },
      'cancel': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'cancel');
        final id = D4.getRequiredArg<String>(positional, 0, 'id', 'cancel');
        return $dartnative_notifications_1.DartNativeNotifications.cancel(id);
      },
      'cancelAll': (visitor, positional, named, typeArgs) {
        return $dartnative_notifications_1.DartNativeNotifications.cancelAll();
      },
    },
    staticMethodSignatures: {
      'setup': 'void setup({void Function(String payload)? onTap})',
      'getInitialTapPayload': 'String? getInitialTapPayload()',
      'requestPermission': 'Future<bool> requestPermission()',
      'show':
          'void show({required String id, required String title, required String body, String payload = \'\', int delaySeconds = 0})',
      'showChat':
          'void showChat({required String id, required String senderName, required String body, required Uint8List avatar, String payload = \'\', int delaySeconds = 0})',
      'cancel': 'void cancel(String id)',
      'cancelAll': 'void cancelAll()',
    },
    staticGetterSignatures: {
      'onTap': 'Stream<String> get onTap',
    },
  );
}

// =============================================================================
// NotificationsFFIBindings Bridge
// =============================================================================

BridgedClass _createNotificationsFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_notifications_2.NotificationsFFIBindings,
    name: 'NotificationsFFIBindings',
    isAssignable: (v) =>
        v is $dartnative_notifications_2.NotificationsFFIBindings,
    constructors: {},
    getters: {
      'onNotificationTap': (visitor, target) => D4
          .validateTarget<$dartnative_notifications_2.NotificationsFFIBindings>(
            target,
            'NotificationsFFIBindings',
          )
          .onNotificationTap,
    },
    methods: {
      'getInitialTapPayload': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_notifications_2.NotificationsFFIBindings
            >(target, 'NotificationsFFIBindings');
        return t.getInitialTapPayload();
      },
      'requestPermission': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_notifications_2.NotificationsFFIBindings
            >(target, 'NotificationsFFIBindings');
        return t.requestPermission();
      },
      'show': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_notifications_2.NotificationsFFIBindings
            >(target, 'NotificationsFFIBindings');
        final id = D4.getRequiredNamedArg<String>(named, 'id', 'show');
        final title = D4.getRequiredNamedArg<String>(named, 'title', 'show');
        final body = D4.getRequiredNamedArg<String>(named, 'body', 'show');
        final payload = D4.getNamedArgWithDefault<String>(named, 'payload', '');
        final delaySeconds = D4.getNamedArgWithDefault<int>(
          named,
          'delaySeconds',
          0,
        );
        t.show(
          id: id,
          title: title,
          body: body,
          payload: payload,
          delaySeconds: delaySeconds,
        );
        return null;
      },
      'showChat': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_notifications_2.NotificationsFFIBindings
            >(target, 'NotificationsFFIBindings');
        final id = D4.getRequiredNamedArg<String>(named, 'id', 'showChat');
        final senderName = D4.getRequiredNamedArg<String>(
          named,
          'senderName',
          'showChat',
        );
        final body = D4.getRequiredNamedArg<String>(named, 'body', 'showChat');
        final avatar = D4.getRequiredNamedArg<Uint8List>(
          named,
          'avatar',
          'showChat',
        );
        final payload = D4.getNamedArgWithDefault<String>(named, 'payload', '');
        final delaySeconds = D4.getNamedArgWithDefault<int>(
          named,
          'delaySeconds',
          0,
        );
        t.showChat(
          id: id,
          senderName: senderName,
          body: body,
          avatar: avatar,
          payload: payload,
          delaySeconds: delaySeconds,
        );
        return null;
      },
      'cancel': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_notifications_2.NotificationsFFIBindings
            >(target, 'NotificationsFFIBindings');
        D4.requireMinArgs(positional, 1, 'cancel');
        final id = D4.getRequiredArg<String>(positional, 0, 'id', 'cancel');
        t.cancel(id);
        return null;
      },
      'cancelAll': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_notifications_2.NotificationsFFIBindings
            >(target, 'NotificationsFFIBindings');
        t.cancelAll();
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) =>
          $dartnative_notifications_2.NotificationsFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        final registerTapHandler = D4.getNamedArgWithDefault<bool>(
          named,
          'registerTapHandler',
          true,
        );
        return $dartnative_notifications_2.NotificationsFFIBindings.loadSymbols(
          registerTapHandler: registerTapHandler,
        );
      },
    },
    methodSignatures: {
      'getInitialTapPayload': 'String? getInitialTapPayload()',
      'requestPermission': 'Future<bool> requestPermission()',
      'show':
          'void show({required String id, required String title, required String body, String payload = \'\', int delaySeconds = 0})',
      'showChat':
          'void showChat({required String id, required String senderName, required String body, required Uint8List avatar, String payload = \'\', int delaySeconds = 0})',
      'cancel': 'void cancel(String id)',
      'cancelAll': 'void cancelAll()',
    },
    getterSignatures: {
      'onNotificationTap': 'Stream<String> get onNotificationTap',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols({bool registerTapHandler = true})',
    },
    staticGetterSignatures: {
      'instance': 'NotificationsFFIBindings get instance',
    },
  );
}

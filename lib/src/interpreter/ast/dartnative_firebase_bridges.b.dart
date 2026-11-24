// D4rt Bridge - Generated file, do not edit
// Sources: 3 files
// Generated: 2026-11-24T16:25:25.805187 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';

import 'package:dartnative_firebase/src/firebase_core.dart'
    as $dartnative_firebase_1;
import 'package:dartnative_firebase/src/firebase_crashlytics.dart'
    as $dartnative_firebase_2;
import 'package:dartnative_firebase/src/firebase_messaging.dart'
    as $dartnative_firebase_3;

/// Bridge class for dartnative_firebase module.
class DartnativeFirebaseBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createFirebaseBridge(),
      _createFirebaseCrashlyticsBridge(),
      _createRemoteMessageBridge(),
      _createFirebaseMessagingBridge(),
      _createDNFirebaseBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'Firebase': _createFirebaseBridge,
      'FirebaseCrashlytics': _createFirebaseCrashlyticsBridge,
      'RemoteMessage': _createRemoteMessageBridge,
      'FirebaseMessaging': _createFirebaseMessagingBridge,
      'DNFirebase': _createDNFirebaseBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'Firebase': $dartnative_firebase_1.Firebase,
      'FirebaseCrashlytics': $dartnative_firebase_2.FirebaseCrashlytics,
      'RemoteMessage': $dartnative_firebase_3.RemoteMessage,
      'FirebaseMessaging': $dartnative_firebase_3.FirebaseMessaging,
      'DNFirebase': $dartnative_firebase_3.DNFirebase,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'Firebase': 'package:dartnative_firebase/src/firebase_core.dart',
      'FirebaseCrashlytics':
          'package:dartnative_firebase/src/firebase_crashlytics.dart',
      'RemoteMessage':
          'package:dartnative_firebase/src/firebase_messaging.dart',
      'FirebaseMessaging':
          'package:dartnative_firebase/src/firebase_messaging.dart',
      'DNFirebase': 'package:dartnative_firebase/src/firebase_messaging.dart',
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
        source: 'package:dartnative_firebase/dartnative_firebase.dart',
        target: 'package:dartnative_firebase/src/firebase_core.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_firebase/dartnative_firebase.dart',
        target: 'package:dartnative_firebase/src/firebase_crashlytics.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_firebase/dartnative_firebase.dart',
        target: 'package:dartnative_firebase/src/firebase_messaging.dart',
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
      'package:dartnative_firebase/src/firebase_core.dart',
      'package:dartnative_firebase/src/firebase_crashlytics.dart',
      'package:dartnative_firebase/src/firebase_messaging.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_firebase/dartnative_firebase.dart';";
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
// Firebase Bridge
// =============================================================================

BridgedClass _createFirebaseBridge() {
  return BridgedClass(
    nativeType: $dartnative_firebase_1.Firebase,
    name: 'Firebase',
    isAssignable: (v) => v is $dartnative_firebase_1.Firebase,
    constructors: {},
    staticMethods: {
      'initializeApp': (visitor, positional, named, typeArgs) {
        return $dartnative_firebase_1.Firebase.initializeApp();
      },
    },
    staticMethodSignatures: {
      'initializeApp': 'Future<void> initializeApp()',
    },
  );
}

// =============================================================================
// FirebaseCrashlytics Bridge
// =============================================================================

BridgedClass _createFirebaseCrashlyticsBridge() {
  return BridgedClass(
    nativeType: $dartnative_firebase_2.FirebaseCrashlytics,
    name: 'FirebaseCrashlytics',
    isAssignable: (v) => v is $dartnative_firebase_2.FirebaseCrashlytics,
    constructors: {},
    getters: {
      'isCrashlyticsCollectionEnabled': (visitor, target) => D4
          .validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
            target,
            'FirebaseCrashlytics',
          )
          .isCrashlyticsCollectionEnabled,
    },
    methods: {
      'setCrashlyticsCollectionEnabled':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
                  target,
                  'FirebaseCrashlytics',
                );
            D4.requireMinArgs(positional, 1, 'setCrashlyticsCollectionEnabled');
            final enabled = D4.getRequiredArg<bool>(
              positional,
              0,
              'enabled',
              'setCrashlyticsCollectionEnabled',
            );
            return t.setCrashlyticsCollectionEnabled(enabled);
          },
      'recordError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        D4.requireMinArgs(positional, 2, 'recordError');
        final exception = D4.getRequiredArg<Object>(
          positional,
          0,
          'exception',
          'recordError',
        );
        final stack = D4.getRequiredArg<StackTrace?>(
          positional,
          1,
          'stack',
          'recordError',
        );
        final reason = D4.getOptionalNamedArg<Object?>(named, 'reason');
        final information =
            named.containsKey('information') && named['information'] != null
            ? D4.coerceList<Object>(named['information'], 'information')
            : const <Object>[];
        final fatal = D4.getNamedArgWithDefault<bool>(named, 'fatal', false);
        return t.recordError(
          exception,
          stack,
          reason: reason,
          information: information,
          fatal: fatal,
        );
      },
      'recordFatalError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        D4.requireMinArgs(positional, 2, 'recordFatalError');
        final exception = D4.getRequiredArg<Object>(
          positional,
          0,
          'exception',
          'recordFatalError',
        );
        final stack = D4.getRequiredArg<StackTrace?>(
          positional,
          1,
          'stack',
          'recordFatalError',
        );
        return t.recordFatalError(exception, stack);
      },
      'recordFlutterFatalError':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
                  target,
                  'FirebaseCrashlytics',
                );
            D4.requireMinArgs(positional, 2, 'recordFlutterFatalError');
            final exception = D4.getRequiredArg<Object>(
              positional,
              0,
              'exception',
              'recordFlutterFatalError',
            );
            final stack = D4.getRequiredArg<StackTrace?>(
              positional,
              1,
              'stack',
              'recordFlutterFatalError',
            );
            final reason = D4.getOptionalNamedArg<Object?>(named, 'reason');
            final information =
                named.containsKey('information') && named['information'] != null
                ? D4.coerceList<Object>(named['information'], 'information')
                : const <Object>[];
            return t.recordFlutterFatalError(
              exception,
              stack,
              reason: reason,
              information: information,
            );
          },
      'recordFlutterError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        D4.requireMinArgs(positional, 2, 'recordFlutterError');
        final exception = D4.getRequiredArg<Object>(
          positional,
          0,
          'exception',
          'recordFlutterError',
        );
        final stack = D4.getRequiredArg<StackTrace?>(
          positional,
          1,
          'stack',
          'recordFlutterError',
        );
        final reason = D4.getOptionalNamedArg<Object?>(named, 'reason');
        final information =
            named.containsKey('information') && named['information'] != null
            ? D4.coerceList<Object>(named['information'], 'information')
            : const <Object>[];
        final fatal = D4.getNamedArgWithDefault<bool>(named, 'fatal', false);
        return t.recordFlutterError(
          exception,
          stack,
          reason: reason,
          information: information,
          fatal: fatal,
        );
      },
      'log': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        D4.requireMinArgs(positional, 1, 'log');
        final message = D4.getRequiredArg<String>(
          positional,
          0,
          'message',
          'log',
        );
        return t.log(message);
      },
      'setUserIdentifier': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        D4.requireMinArgs(positional, 1, 'setUserIdentifier');
        final identifier = D4.getRequiredArg<String>(
          positional,
          0,
          'identifier',
          'setUserIdentifier',
        );
        return t.setUserIdentifier(identifier);
      },
      'setCustomKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        D4.requireMinArgs(positional, 2, 'setCustomKey');
        final key = D4.getRequiredArg<String>(
          positional,
          0,
          'key',
          'setCustomKey',
        );
        final value = D4.getRequiredArg<Object>(
          positional,
          1,
          'value',
          'setCustomKey',
        );
        return t.setCustomKey(key, value);
      },
      'checkForUnsentReports': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        return t.checkForUnsentReports();
      },
      'sendUnsentReports': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        return t.sendUnsentReports();
      },
      'deleteUnsentReports': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        return t.deleteUnsentReports();
      },
      'didCrashOnPreviousExecution':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
                  target,
                  'FirebaseCrashlytics',
                );
            return t.didCrashOnPreviousExecution();
          },
      'crash': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_2.FirebaseCrashlytics>(
          target,
          'FirebaseCrashlytics',
        );
        t.crash();
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) =>
          $dartnative_firebase_2.FirebaseCrashlytics.instance,
    },
    methodSignatures: {
      'setCrashlyticsCollectionEnabled':
          'Future<void> setCrashlyticsCollectionEnabled(bool enabled)',
      'recordError':
          'Future<void> recordError(Object exception, StackTrace? stack, {Object? reason, Iterable<Object> information = const [], bool fatal = false})',
      'recordFatalError':
          'Future<void> recordFatalError(Object exception, StackTrace? stack)',
      'recordFlutterFatalError':
          'Future<void> recordFlutterFatalError(Object exception, StackTrace? stack, {Object? reason, Iterable<Object> information = const []})',
      'recordFlutterError':
          'Future<void> recordFlutterError(Object exception, StackTrace? stack, {Object? reason, Iterable<Object> information = const [], bool fatal = false})',
      'log': 'Future<void> log(String message)',
      'setUserIdentifier': 'Future<void> setUserIdentifier(String identifier)',
      'setCustomKey': 'Future<void> setCustomKey(String key, Object value)',
      'checkForUnsentReports': 'Future<bool> checkForUnsentReports()',
      'sendUnsentReports': 'Future<void> sendUnsentReports()',
      'deleteUnsentReports': 'Future<void> deleteUnsentReports()',
      'didCrashOnPreviousExecution':
          'Future<bool> didCrashOnPreviousExecution()',
      'crash': 'void crash()',
    },
    getterSignatures: {
      'isCrashlyticsCollectionEnabled':
          'bool get isCrashlyticsCollectionEnabled',
    },
    staticGetterSignatures: {
      'instance': 'FirebaseCrashlytics get instance',
    },
  );
}

// =============================================================================
// RemoteMessage Bridge
// =============================================================================

BridgedClass _createRemoteMessageBridge() {
  return BridgedClass(
    nativeType: $dartnative_firebase_3.RemoteMessage,
    name: 'RemoteMessage',
    isAssignable: (v) => v is $dartnative_firebase_3.RemoteMessage,
    constructors: {
      '': (visitor, positional, named) {
        final messageId = D4.getRequiredNamedArg<String>(
          named,
          'messageId',
          'RemoteMessage',
        );
        final from = D4.getRequiredNamedArg<String>(
          named,
          'from',
          'RemoteMessage',
        );
        final collapseKey = D4.getRequiredNamedArg<String>(
          named,
          'collapseKey',
          'RemoteMessage',
        );
        final notificationTitle = D4.getOptionalNamedArg<String?>(
          named,
          'notificationTitle',
        );
        final notificationBody = D4.getOptionalNamedArg<String?>(
          named,
          'notificationBody',
        );
        final data = named.containsKey('data') && named['data'] != null
            ? D4.coerceMap<String, String>(named['data'], 'data')
            : const <String, String>{};
        return $dartnative_firebase_3.RemoteMessage(
          messageId: messageId,
          from: from,
          collapseKey: collapseKey,
          notificationTitle: notificationTitle,
          notificationBody: notificationBody,
          data: data,
        );
      },
    },
    getters: {
      'messageId': (visitor, target) => D4
          .validateTarget<$dartnative_firebase_3.RemoteMessage>(
            target,
            'RemoteMessage',
          )
          .messageId,
      'from': (visitor, target) => D4
          .validateTarget<$dartnative_firebase_3.RemoteMessage>(
            target,
            'RemoteMessage',
          )
          .from,
      'collapseKey': (visitor, target) => D4
          .validateTarget<$dartnative_firebase_3.RemoteMessage>(
            target,
            'RemoteMessage',
          )
          .collapseKey,
      'notificationTitle': (visitor, target) => D4
          .validateTarget<$dartnative_firebase_3.RemoteMessage>(
            target,
            'RemoteMessage',
          )
          .notificationTitle,
      'notificationBody': (visitor, target) => D4
          .validateTarget<$dartnative_firebase_3.RemoteMessage>(
            target,
            'RemoteMessage',
          )
          .notificationBody,
      'data': (visitor, target) => D4
          .validateTarget<$dartnative_firebase_3.RemoteMessage>(
            target,
            'RemoteMessage',
          )
          .data,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_firebase_3.RemoteMessage>(
          target,
          'RemoteMessage',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const RemoteMessage({required String messageId, required String from, required String collapseKey, String? notificationTitle, String? notificationBody, Map<String, String> data = const {}})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'messageId': 'String get messageId',
      'from': 'String get from',
      'collapseKey': 'String get collapseKey',
      'notificationTitle': 'String? get notificationTitle',
      'notificationBody': 'String? get notificationBody',
      'data': 'Map<String, String> get data',
    },
  );
}

// =============================================================================
// FirebaseMessaging Bridge
// =============================================================================

BridgedClass _createFirebaseMessagingBridge() {
  return BridgedClass(
    nativeType: $dartnative_firebase_3.FirebaseMessaging,
    name: 'FirebaseMessaging',
    isAssignable: (v) => v is $dartnative_firebase_3.FirebaseMessaging,
    constructors: {},
    staticGetters: {
      'onTokenRefresh': (visitor) =>
          $dartnative_firebase_3.FirebaseMessaging.onTokenRefresh,
      'onMessage': (visitor) =>
          $dartnative_firebase_3.FirebaseMessaging.onMessage,
      'onMessageOpenedApp': (visitor) =>
          $dartnative_firebase_3.FirebaseMessaging.onMessageOpenedApp,
    },
    staticMethods: {
      'setup': (visitor, positional, named, typeArgs) {
        return $dartnative_firebase_3.FirebaseMessaging.setup();
      },
      'getToken': (visitor, positional, named, typeArgs) {
        return $dartnative_firebase_3.FirebaseMessaging.getToken();
      },
      'getInitialMessage': (visitor, positional, named, typeArgs) {
        return $dartnative_firebase_3.FirebaseMessaging.getInitialMessage();
      },
      'subscribeToTopic': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'subscribeToTopic');
        final topic = D4.getRequiredArg<String>(
          positional,
          0,
          'topic',
          'subscribeToTopic',
        );
        return $dartnative_firebase_3.FirebaseMessaging.subscribeToTopic(topic);
      },
      'unsubscribeFromTopic': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'unsubscribeFromTopic');
        final topic = D4.getRequiredArg<String>(
          positional,
          0,
          'topic',
          'unsubscribeFromTopic',
        );
        return $dartnative_firebase_3.FirebaseMessaging.unsubscribeFromTopic(
          topic,
        );
      },
      'getAPNSToken': (visitor, positional, named, typeArgs) {
        return $dartnative_firebase_3.FirebaseMessaging.getAPNSToken();
      },
      'requestPermission': (visitor, positional, named, typeArgs) {
        return $dartnative_firebase_3.FirebaseMessaging.requestPermission();
      },
      'setForegroundNotificationPresentationOptions':
          (visitor, positional, named, typeArgs) {
            final alert = D4.getNamedArgWithDefault<bool>(named, 'alert', true);
            final badge = D4.getNamedArgWithDefault<bool>(
              named,
              'badge',
              false,
            );
            final sound = D4.getNamedArgWithDefault<bool>(named, 'sound', true);
            return $dartnative_firebase_3
                .FirebaseMessaging.setForegroundNotificationPresentationOptions(
              alert: alert,
              badge: badge,
              sound: sound,
            );
          },
      'onBackgroundMessage': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'onBackgroundMessage');
        if (positional.isEmpty) {
          throw ArgumentError(
            'onBackgroundMessage: Missing required argument "handler" at position 0',
          );
        }
        final handlerRaw = positional[0];
        final handler = handlerRaw == null
            ? null
            : ($dartnative_firebase_3.RemoteMessage p0) {
                D4.callInterpreterCallback(visitor!, handlerRaw, [p0]);
              };
        return $dartnative_firebase_3.FirebaseMessaging.onBackgroundMessage(
          handler,
        );
      },
    },
    staticMethodSignatures: {
      'setup': 'void setup()',
      'getToken': 'Future<String?> getToken()',
      'getInitialMessage': 'Future<RemoteMessage?> getInitialMessage()',
      'subscribeToTopic': 'Future<void> subscribeToTopic(String topic)',
      'unsubscribeFromTopic': 'Future<void> unsubscribeFromTopic(String topic)',
      'getAPNSToken': 'Future<String?> getAPNSToken()',
      'requestPermission': 'Future<bool> requestPermission()',
      'setForegroundNotificationPresentationOptions':
          'void setForegroundNotificationPresentationOptions({bool alert = true, bool badge = false, bool sound = true})',
      'onBackgroundMessage':
          'bool onBackgroundMessage(void Function(RemoteMessage message)? handler)',
    },
    staticGetterSignatures: {
      'onTokenRefresh': 'Stream<String> get onTokenRefresh',
      'onMessage': 'Stream<RemoteMessage> get onMessage',
      'onMessageOpenedApp': 'Stream<RemoteMessage> get onMessageOpenedApp',
    },
  );
}

// =============================================================================
// DNFirebase Bridge
// =============================================================================

BridgedClass _createDNFirebaseBridge() {
  return BridgedClass(
    nativeType: $dartnative_firebase_3.DNFirebase,
    name: 'DNFirebase',
    isAssignable: (v) => v is $dartnative_firebase_3.DNFirebase,
    constructors: {},
    staticMethods: {
      'handleRemoteNotification': (visitor, positional, named, typeArgs) {
        final userInfoJson = D4.getRequiredNamedArg<String>(
          named,
          'userInfoJson',
          'handleRemoteNotification',
        );
        final isBackground = D4.getNamedArgWithDefault<bool>(
          named,
          'isBackground',
          true,
        );
        return $dartnative_firebase_3.DNFirebase.handleRemoteNotification(
          userInfoJson: userInfoJson,
          isBackground: isBackground,
        );
      },
    },
    staticMethodSignatures: {
      'handleRemoteNotification':
          'void handleRemoteNotification({required String userInfoJson, bool isBackground = true})',
    },
  );
}

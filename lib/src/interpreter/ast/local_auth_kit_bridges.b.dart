// D4rt Bridge - Generated file, do not edit
// Sources: 5 files
// Generated: 2026-11-16T04:51:31.361462 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';

import 'package:local_auth_kit/src/auth_messages.dart' as $local_auth_kit_1;
import 'package:local_auth_kit/src/backend.dart' as $local_auth_kit_2;
import 'package:local_auth_kit/src/local_auth.dart' as $local_auth_kit_3;
import 'package:local_auth_kit/src/local_auth_ffi_bindings.dart'
    as $local_auth_kit_4;
import 'package:local_auth_kit/src/types.dart' as $local_auth_kit_5;

/// Bridge class for local_auth_kit module.
class LocalAuthKitBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createLocalAuthBackendBridge(),
      _createAuthMessagesBridge(),
      _createAndroidAuthMessagesBridge(),
      _createIOSAuthMessagesBridge(),
      _createLocalAuthExceptionCodesBridge(),
      _createLocalAuthExceptionBridge(),
      _createAuthenticationOptionsBridge(),
      _createLocalAuthNativeResultBridge(),
      _createLocalAuthBiometricBitsBridge(),
      _createLocalAuthOptionBitsBridge(),
      _createLocalAuthenticationBridge(),
      _createLocalAuthFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'LocalAuthBackend': _createLocalAuthBackendBridge,
      'AuthMessages': _createAuthMessagesBridge,
      'AndroidAuthMessages': _createAndroidAuthMessagesBridge,
      'IOSAuthMessages': _createIOSAuthMessagesBridge,
      'LocalAuthExceptionCodes': _createLocalAuthExceptionCodesBridge,
      'LocalAuthException': _createLocalAuthExceptionBridge,
      'AuthenticationOptions': _createAuthenticationOptionsBridge,
      'LocalAuthNativeResult': _createLocalAuthNativeResultBridge,
      'LocalAuthBiometricBits': _createLocalAuthBiometricBitsBridge,
      'LocalAuthOptionBits': _createLocalAuthOptionBitsBridge,
      'LocalAuthentication': _createLocalAuthenticationBridge,
      'LocalAuthFFIBindings': _createLocalAuthFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'LocalAuthBackend': $local_auth_kit_2.LocalAuthBackend,
      'AuthMessages': $local_auth_kit_1.AuthMessages,
      'AndroidAuthMessages': $local_auth_kit_1.AndroidAuthMessages,
      'IOSAuthMessages': $local_auth_kit_1.IOSAuthMessages,
      'LocalAuthExceptionCodes': $local_auth_kit_5.LocalAuthExceptionCodes,
      'LocalAuthException': $local_auth_kit_5.LocalAuthException,
      'AuthenticationOptions': $local_auth_kit_5.AuthenticationOptions,
      'LocalAuthNativeResult': $local_auth_kit_5.LocalAuthNativeResult,
      'LocalAuthBiometricBits': $local_auth_kit_5.LocalAuthBiometricBits,
      'LocalAuthOptionBits': $local_auth_kit_5.LocalAuthOptionBits,
      'LocalAuthentication': $local_auth_kit_3.LocalAuthentication,
      'LocalAuthFFIBindings': $local_auth_kit_4.LocalAuthFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'LocalAuthBackend': 'package:local_auth_kit/src/backend.dart',
      'AuthMessages': 'package:local_auth_kit/src/auth_messages.dart',
      'AndroidAuthMessages': 'package:local_auth_kit/src/auth_messages.dart',
      'IOSAuthMessages': 'package:local_auth_kit/src/auth_messages.dart',
      'LocalAuthExceptionCodes': 'package:local_auth_kit/src/types.dart',
      'LocalAuthException': 'package:local_auth_kit/src/types.dart',
      'AuthenticationOptions': 'package:local_auth_kit/src/types.dart',
      'LocalAuthNativeResult': 'package:local_auth_kit/src/types.dart',
      'LocalAuthBiometricBits': 'package:local_auth_kit/src/types.dart',
      'LocalAuthOptionBits': 'package:local_auth_kit/src/types.dart',
      'LocalAuthentication': 'package:local_auth_kit/src/local_auth.dart',
      'LocalAuthFFIBindings':
          'package:local_auth_kit/src/local_auth_ffi_bindings.dart',
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
      'AndroidAuthMessages': ['AuthMessages'],
      'IOSAuthMessages': ['AuthMessages'],
      'LocalAuthException': ['Exception'],
      'LocalAuthFFIBindings': ['LocalAuthBackend'],
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
    return [
      BridgedEnumDefinition<$local_auth_kit_5.BiometricType>(
        name: 'BiometricType',
        values: $local_auth_kit_5.BiometricType.values,
      ),
      BridgedEnumDefinition<$local_auth_kit_5.LocalAuthExceptionCode>(
        name: 'LocalAuthExceptionCode',
        values: $local_auth_kit_5.LocalAuthExceptionCode.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'BiometricType': 'package:local_auth_kit/src/types.dart',
      'LocalAuthExceptionCode': 'package:local_auth_kit/src/types.dart',
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
        source: 'package:local_auth_kit/local_auth_kit.dart',
        target: 'package:local_auth_kit/src/local_auth.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:local_auth_kit/local_auth_kit.dart',
        target: 'package:local_auth_kit/src/local_auth_ffi_bindings.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:local_auth_kit/local_auth_kit.dart',
        target: 'package:local_auth_kit/src/types.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:local_auth_kit/src/types.dart',
        target: 'package:local_auth_kit/src/auth_messages.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:local_auth_kit/src/local_auth.dart',
        target: 'package:local_auth_kit/src/backend.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:local_auth_kit/src/local_auth.dart',
        target: 'package:local_auth_kit/src/types.dart',
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

    // Register global variables
    registerGlobalVariables(interpreter, importPath);

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

  /// Registers all global variables with the interpreter.
  ///
  /// [importPath] is the package import path for library-scoped registration.
  /// Collects all registration errors and throws a single exception
  /// with all error details if any registrations fail.
  static void registerGlobalVariables(D4rt interpreter, String importPath) {
    final errors = <String>[];

    try {
      interpreter.registerGlobalVariable(
        'androidSignInTitle',
        $local_auth_kit_1.androidSignInTitle,
        importPath,
        sourceUri: 'package:local_auth_kit/src/auth_messages.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "androidSignInTitle": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'androidSignInHint',
        $local_auth_kit_1.androidSignInHint,
        importPath,
        sourceUri: 'package:local_auth_kit/src/auth_messages.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "androidSignInHint": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'androidCancelButton',
        $local_auth_kit_1.androidCancelButton,
        importPath,
        sourceUri: 'package:local_auth_kit/src/auth_messages.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "androidCancelButton": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'iosCancelButton',
        $local_auth_kit_1.iosCancelButton,
        importPath,
        sourceUri: 'package:local_auth_kit/src/auth_messages.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "iosCancelButton": $e');
    }

    if (errors.isNotEmpty) {
      throw StateError(
        'Bridge registration errors (local_auth_kit):\n${errors.join("\n")}',
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
      'package:local_auth_kit/src/auth_messages.dart',
      'package:local_auth_kit/src/backend.dart',
      'package:local_auth_kit/src/local_auth.dart',
      'package:local_auth_kit/src/local_auth_ffi_bindings.dart',
      'package:local_auth_kit/src/types.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:local_auth_kit/local_auth_kit.dart';";
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
    'BiometricType',
    'LocalAuthExceptionCode',
  ];
}

// =============================================================================
// LocalAuthBackend Bridge
// =============================================================================

BridgedClass _createLocalAuthBackendBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_2.LocalAuthBackend,
    name: 'LocalAuthBackend',
    isAssignable: (v) => v is $local_auth_kit_2.LocalAuthBackend,
    isAbstract: true,
    constructors: {},
    methods: {
      'isDeviceSupported': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_2.LocalAuthBackend>(
          target,
          'LocalAuthBackend',
        );
        return t.isDeviceSupported();
      },
      'canCheckBiometrics': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_2.LocalAuthBackend>(
          target,
          'LocalAuthBackend',
        );
        return t.canCheckBiometrics();
      },
      'availableBiometrics': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_2.LocalAuthBackend>(
          target,
          'LocalAuthBackend',
        );
        return t.availableBiometrics();
      },
      'authenticate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_2.LocalAuthBackend>(
          target,
          'LocalAuthBackend',
        );
        final token = D4.getRequiredNamedArg<int>(
          named,
          'token',
          'authenticate',
        );
        final reason = D4.getRequiredNamedArg<String>(
          named,
          'reason',
          'authenticate',
        );
        final options = D4.getRequiredNamedArg<int>(
          named,
          'options',
          'authenticate',
        );
        final messages = D4.getRequiredNamedArg<String>(
          named,
          'messages',
          'authenticate',
        );
        if (!named.containsKey('complete') || named['complete'] == null) {
          throw ArgumentError(
            'authenticate: Missing required named argument "complete"',
          );
        }
        final completeRaw = named['complete'];
        t.authenticate(
          token: token,
          reason: reason,
          options: options,
          messages: messages,
          complete: (int p0, int p1, String p2) {
            D4.callInterpreterCallback(visitor!, completeRaw, [p0, p1, p2]);
          },
        );
        return null;
      },
      'stopAuthentication': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_2.LocalAuthBackend>(
          target,
          'LocalAuthBackend',
        );
        return t.stopAuthentication();
      },
    },
    methodSignatures: {
      'isDeviceSupported': 'int isDeviceSupported()',
      'canCheckBiometrics': 'int canCheckBiometrics()',
      'availableBiometrics': 'int availableBiometrics()',
      'authenticate':
          'void authenticate({required int token, required String reason, required int options, required String messages, required void Function(int token, int result, String message) complete})',
      'stopAuthentication': 'int stopAuthentication()',
    },
  );
}

// =============================================================================
// AuthMessages Bridge
// =============================================================================

BridgedClass _createAuthMessagesBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_1.AuthMessages,
    name: 'AuthMessages',
    isAssignable: (v) => v is $local_auth_kit_1.AuthMessages,
    isAbstract: true,
    constructors: {},
  );
}

// =============================================================================
// AndroidAuthMessages Bridge
// =============================================================================

BridgedClass _createAndroidAuthMessagesBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_1.AndroidAuthMessages,
    name: 'AndroidAuthMessages',
    isAssignable: (v) => v is $local_auth_kit_1.AndroidAuthMessages,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final signInHint = D4.getOptionalNamedArg<String?>(named, 'signInHint');
        final cancelButton = D4.getOptionalNamedArg<String?>(
          named,
          'cancelButton',
        );
        final signInTitle = D4.getOptionalNamedArg<String?>(
          named,
          'signInTitle',
        );
        return $local_auth_kit_1.AndroidAuthMessages(
          signInHint: signInHint,
          cancelButton: cancelButton,
          signInTitle: signInTitle,
        );
      },
    },
    getters: {
      'signInHint': (visitor, target) => D4
          .validateTarget<$local_auth_kit_1.AndroidAuthMessages>(
            target,
            'AndroidAuthMessages',
          )
          .signInHint,
      'cancelButton': (visitor, target) => D4
          .validateTarget<$local_auth_kit_1.AndroidAuthMessages>(
            target,
            'AndroidAuthMessages',
          )
          .cancelButton,
      'signInTitle': (visitor, target) => D4
          .validateTarget<$local_auth_kit_1.AndroidAuthMessages>(
            target,
            'AndroidAuthMessages',
          )
          .signInTitle,
      'hashCode': (visitor, target) => D4
          .validateTarget<$local_auth_kit_1.AndroidAuthMessages>(
            target,
            'AndroidAuthMessages',
          )
          .hashCode,
    },
    methods: {
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_1.AndroidAuthMessages>(
          target,
          'AndroidAuthMessages',
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
    constructorSignatures: {
      '': 'const AndroidAuthMessages({String? signInHint, String? cancelButton, String? signInTitle})',
    },
    getterSignatures: {
      'signInHint': 'String? get signInHint',
      'cancelButton': 'String? get cancelButton',
      'signInTitle': 'String? get signInTitle',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// IOSAuthMessages Bridge
// =============================================================================

BridgedClass _createIOSAuthMessagesBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_1.IOSAuthMessages,
    name: 'IOSAuthMessages',
    isAssignable: (v) => v is $local_auth_kit_1.IOSAuthMessages,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final cancelButton = D4.getOptionalNamedArg<String?>(
          named,
          'cancelButton',
        );
        final localizedFallbackTitle = D4.getOptionalNamedArg<String?>(
          named,
          'localizedFallbackTitle',
        );
        return $local_auth_kit_1.IOSAuthMessages(
          cancelButton: cancelButton,
          localizedFallbackTitle: localizedFallbackTitle,
        );
      },
    },
    getters: {
      'cancelButton': (visitor, target) => D4
          .validateTarget<$local_auth_kit_1.IOSAuthMessages>(
            target,
            'IOSAuthMessages',
          )
          .cancelButton,
      'localizedFallbackTitle': (visitor, target) => D4
          .validateTarget<$local_auth_kit_1.IOSAuthMessages>(
            target,
            'IOSAuthMessages',
          )
          .localizedFallbackTitle,
      'hashCode': (visitor, target) => D4
          .validateTarget<$local_auth_kit_1.IOSAuthMessages>(
            target,
            'IOSAuthMessages',
          )
          .hashCode,
    },
    methods: {
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_1.IOSAuthMessages>(
          target,
          'IOSAuthMessages',
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
    constructorSignatures: {
      '': 'const IOSAuthMessages({String? cancelButton, String? localizedFallbackTitle})',
    },
    getterSignatures: {
      'cancelButton': 'String? get cancelButton',
      'localizedFallbackTitle': 'String? get localizedFallbackTitle',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// LocalAuthExceptionCodes Bridge
// =============================================================================

BridgedClass _createLocalAuthExceptionCodesBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_5.LocalAuthExceptionCodes,
    name: 'LocalAuthExceptionCodes',
    isAssignable: (v) => v is $local_auth_kit_5.LocalAuthExceptionCodes,
    isAbstract: true,
    constructors: {},
    staticGetters: {
      'notAvailable': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.notAvailable,
      'notEnrolled': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.notEnrolled,
      'lockedOut': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.lockedOut,
      'permanentlyLockedOut': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.permanentlyLockedOut,
      'userCanceled': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.userCanceled,
      'systemCanceled': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.systemCanceled,
      'timeout': (visitor) => $local_auth_kit_5.LocalAuthExceptionCodes.timeout,
      'passcodeNotSet': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.passcodeNotSet,
      'biometricOnlyNotSupported': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.biometricOnlyNotSupported,
      'noActivity': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.noActivity,
      'uiUnavailable': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.uiUnavailable,
      'unknownError': (visitor) =>
          $local_auth_kit_5.LocalAuthExceptionCodes.unknownError,
    },
    staticGetterSignatures: {
      'notAvailable': 'LocalAuthExceptionCode get notAvailable',
      'notEnrolled': 'LocalAuthExceptionCode get notEnrolled',
      'lockedOut': 'LocalAuthExceptionCode get lockedOut',
      'permanentlyLockedOut': 'LocalAuthExceptionCode get permanentlyLockedOut',
      'userCanceled': 'LocalAuthExceptionCode get userCanceled',
      'systemCanceled': 'LocalAuthExceptionCode get systemCanceled',
      'timeout': 'LocalAuthExceptionCode get timeout',
      'passcodeNotSet': 'LocalAuthExceptionCode get passcodeNotSet',
      'biometricOnlyNotSupported':
          'LocalAuthExceptionCode get biometricOnlyNotSupported',
      'noActivity': 'LocalAuthExceptionCode get noActivity',
      'uiUnavailable': 'LocalAuthExceptionCode get uiUnavailable',
      'unknownError': 'LocalAuthExceptionCode get unknownError',
    },
  );
}

// =============================================================================
// LocalAuthException Bridge
// =============================================================================

BridgedClass _createLocalAuthExceptionBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_5.LocalAuthException,
    name: 'LocalAuthException',
    isAssignable: (v) => v is $local_auth_kit_5.LocalAuthException,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final code = D4
            .getRequiredNamedArg<$local_auth_kit_5.LocalAuthExceptionCode>(
              named,
              'code',
              'LocalAuthException',
            );
        final description = D4.getOptionalNamedArg<String?>(
          named,
          'description',
        );
        final details = D4.getOptionalNamedArg<Object?>(named, 'details');
        return $local_auth_kit_5.LocalAuthException(
          code: code,
          description: description,
          details: details,
        );
      },
    },
    getters: {
      'code': (visitor, target) => D4
          .validateTarget<$local_auth_kit_5.LocalAuthException>(
            target,
            'LocalAuthException',
          )
          .code,
      'description': (visitor, target) => D4
          .validateTarget<$local_auth_kit_5.LocalAuthException>(
            target,
            'LocalAuthException',
          )
          .description,
      'details': (visitor, target) => D4
          .validateTarget<$local_auth_kit_5.LocalAuthException>(
            target,
            'LocalAuthException',
          )
          .details,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_5.LocalAuthException>(
          target,
          'LocalAuthException',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const LocalAuthException({required LocalAuthExceptionCode code, String? description, Object? details})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'code': 'LocalAuthExceptionCode get code',
      'description': 'String? get description',
      'details': 'Object? get details',
    },
  );
}

// =============================================================================
// AuthenticationOptions Bridge
// =============================================================================

BridgedClass _createAuthenticationOptionsBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_5.AuthenticationOptions,
    name: 'AuthenticationOptions',
    isAssignable: (v) => v is $local_auth_kit_5.AuthenticationOptions,
    constructors: {
      '': (visitor, positional, named) {
        final biometricOnly = D4.getNamedArgWithDefault<bool>(
          named,
          'biometricOnly',
          false,
        );
        final sensitiveTransaction = D4.getNamedArgWithDefault<bool>(
          named,
          'sensitiveTransaction',
          true,
        );
        final persistAcrossBackgrounding = D4.getNamedArgWithDefault<bool>(
          named,
          'persistAcrossBackgrounding',
          false,
        );
        final stickyAuth = D4.getNamedArgWithDefault<bool>(
          named,
          'stickyAuth',
          false,
        );
        final useErrorDialogs = D4.getNamedArgWithDefault<bool>(
          named,
          'useErrorDialogs',
          true,
        );
        return $local_auth_kit_5.AuthenticationOptions(
          biometricOnly: biometricOnly,
          sensitiveTransaction: sensitiveTransaction,
          persistAcrossBackgrounding: persistAcrossBackgrounding,
          stickyAuth: stickyAuth,
          useErrorDialogs: useErrorDialogs,
        );
      },
    },
    getters: {
      'biometricOnly': (visitor, target) => D4
          .validateTarget<$local_auth_kit_5.AuthenticationOptions>(
            target,
            'AuthenticationOptions',
          )
          .biometricOnly,
      'sensitiveTransaction': (visitor, target) => D4
          .validateTarget<$local_auth_kit_5.AuthenticationOptions>(
            target,
            'AuthenticationOptions',
          )
          .sensitiveTransaction,
      'persistAcrossBackgrounding': (visitor, target) => D4
          .validateTarget<$local_auth_kit_5.AuthenticationOptions>(
            target,
            'AuthenticationOptions',
          )
          .persistAcrossBackgrounding,
      'stickyAuth': (visitor, target) => D4
          .validateTarget<$local_auth_kit_5.AuthenticationOptions>(
            target,
            'AuthenticationOptions',
          )
          .stickyAuth,
      'useErrorDialogs': (visitor, target) => D4
          .validateTarget<$local_auth_kit_5.AuthenticationOptions>(
            target,
            'AuthenticationOptions',
          )
          .useErrorDialogs,
      'persist': (visitor, target) => D4
          .validateTarget<$local_auth_kit_5.AuthenticationOptions>(
            target,
            'AuthenticationOptions',
          )
          .persist,
    },
    constructorSignatures: {
      '': 'const AuthenticationOptions({bool biometricOnly = false, bool sensitiveTransaction = true, bool persistAcrossBackgrounding = false, bool stickyAuth = false, bool useErrorDialogs = true})',
    },
    getterSignatures: {
      'biometricOnly': 'bool get biometricOnly',
      'sensitiveTransaction': 'bool get sensitiveTransaction',
      'persistAcrossBackgrounding': 'bool get persistAcrossBackgrounding',
      'stickyAuth': 'bool get stickyAuth',
      'useErrorDialogs': 'bool get useErrorDialogs',
      'persist': 'bool get persist',
    },
  );
}

// =============================================================================
// LocalAuthNativeResult Bridge
// =============================================================================

BridgedClass _createLocalAuthNativeResultBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_5.LocalAuthNativeResult,
    name: 'LocalAuthNativeResult',
    isAssignable: (v) => v is $local_auth_kit_5.LocalAuthNativeResult,
    isAbstract: true,
    constructors: {},
    staticGetters: {
      'success': (visitor) => $local_auth_kit_5.LocalAuthNativeResult.success,
      'userCanceled': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.userCanceled,
      'systemCanceled': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.systemCanceled,
      'notAvailable': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.notAvailable,
      'notEnrolled': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.notEnrolled,
      'lockedOut': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.lockedOut,
      'permanentlyLockedOut': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.permanentlyLockedOut,
      'timeout': (visitor) => $local_auth_kit_5.LocalAuthNativeResult.timeout,
      'passcodeNotSet': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.passcodeNotSet,
      'biometricOnlyNotSupported': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.biometricOnlyNotSupported,
      'noActivity': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.noActivity,
      'uiUnavailable': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.uiUnavailable,
      'error': (visitor) => $local_auth_kit_5.LocalAuthNativeResult.error,
      'userRequestedFallback': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.userRequestedFallback,
      'authInProgress': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.authInProgress,
      'hardwareUnavailable': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.hardwareUnavailable,
      'deviceError': (visitor) =>
          $local_auth_kit_5.LocalAuthNativeResult.deviceError,
    },
    staticGetterSignatures: {
      'success': 'int get success',
      'userCanceled': 'int get userCanceled',
      'systemCanceled': 'int get systemCanceled',
      'notAvailable': 'int get notAvailable',
      'notEnrolled': 'int get notEnrolled',
      'lockedOut': 'int get lockedOut',
      'permanentlyLockedOut': 'int get permanentlyLockedOut',
      'timeout': 'int get timeout',
      'passcodeNotSet': 'int get passcodeNotSet',
      'biometricOnlyNotSupported': 'int get biometricOnlyNotSupported',
      'noActivity': 'int get noActivity',
      'uiUnavailable': 'int get uiUnavailable',
      'error': 'int get error',
      'userRequestedFallback': 'int get userRequestedFallback',
      'authInProgress': 'int get authInProgress',
      'hardwareUnavailable': 'int get hardwareUnavailable',
      'deviceError': 'int get deviceError',
    },
  );
}

// =============================================================================
// LocalAuthBiometricBits Bridge
// =============================================================================

BridgedClass _createLocalAuthBiometricBitsBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_5.LocalAuthBiometricBits,
    name: 'LocalAuthBiometricBits',
    isAssignable: (v) => v is $local_auth_kit_5.LocalAuthBiometricBits,
    isAbstract: true,
    constructors: {},
    staticGetters: {
      'fingerprint': (visitor) =>
          $local_auth_kit_5.LocalAuthBiometricBits.fingerprint,
      'face': (visitor) => $local_auth_kit_5.LocalAuthBiometricBits.face,
      'iris': (visitor) => $local_auth_kit_5.LocalAuthBiometricBits.iris,
      'weak': (visitor) => $local_auth_kit_5.LocalAuthBiometricBits.weak,
      'strong': (visitor) => $local_auth_kit_5.LocalAuthBiometricBits.strong,
    },
    staticGetterSignatures: {
      'fingerprint': 'int get fingerprint',
      'face': 'int get face',
      'iris': 'int get iris',
      'weak': 'int get weak',
      'strong': 'int get strong',
    },
  );
}

// =============================================================================
// LocalAuthOptionBits Bridge
// =============================================================================

BridgedClass _createLocalAuthOptionBitsBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_5.LocalAuthOptionBits,
    name: 'LocalAuthOptionBits',
    isAssignable: (v) => v is $local_auth_kit_5.LocalAuthOptionBits,
    isAbstract: true,
    constructors: {},
    staticGetters: {
      'biometricOnly': (visitor) =>
          $local_auth_kit_5.LocalAuthOptionBits.biometricOnly,
      'sensitiveTransaction': (visitor) =>
          $local_auth_kit_5.LocalAuthOptionBits.sensitiveTransaction,
      'persistAcrossBackgrounding': (visitor) =>
          $local_auth_kit_5.LocalAuthOptionBits.persistAcrossBackgrounding,
    },
    staticGetterSignatures: {
      'biometricOnly': 'int get biometricOnly',
      'sensitiveTransaction': 'int get sensitiveTransaction',
      'persistAcrossBackgrounding': 'int get persistAcrossBackgrounding',
    },
  );
}

// =============================================================================
// LocalAuthentication Bridge
// =============================================================================

BridgedClass _createLocalAuthenticationBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_3.LocalAuthentication,
    name: 'LocalAuthentication',
    isAssignable: (v) => v is $local_auth_kit_3.LocalAuthentication,
    constructors: {
      '': (visitor, positional, named) {
        return $local_auth_kit_3.LocalAuthentication();
      },
      'withBackend': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LocalAuthentication');
        final backend = D4.getRequiredArg<$local_auth_kit_2.LocalAuthBackend>(
          positional,
          0,
          '_backend',
          'LocalAuthentication',
        );
        return $local_auth_kit_3.LocalAuthentication.withBackend(backend);
      },
    },
    getters: {
      'canCheckBiometrics': (visitor, target) => D4
          .validateTarget<$local_auth_kit_3.LocalAuthentication>(
            target,
            'LocalAuthentication',
          )
          .canCheckBiometrics,
    },
    methods: {
      'isDeviceSupported': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_3.LocalAuthentication>(
          target,
          'LocalAuthentication',
        );
        return t.isDeviceSupported();
      },
      'getAvailableBiometrics': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_3.LocalAuthentication>(
          target,
          'LocalAuthentication',
        );
        return t.getAvailableBiometrics();
      },
      'authenticate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_3.LocalAuthentication>(
          target,
          'LocalAuthentication',
        );
        final localizedReason = D4.getRequiredNamedArg<String>(
          named,
          'localizedReason',
          'authenticate',
        );
        final biometricOnly = D4.getNamedArgWithDefault<bool>(
          named,
          'biometricOnly',
          false,
        );
        final sensitiveTransaction = D4.getNamedArgWithDefault<bool>(
          named,
          'sensitiveTransaction',
          true,
        );
        final persistAcrossBackgrounding = D4.getNamedArgWithDefault<bool>(
          named,
          'persistAcrossBackgrounding',
          false,
        );
        final options = D4
            .getOptionalNamedArg<$local_auth_kit_5.AuthenticationOptions?>(
              named,
              'options',
            );
        if (!named.containsKey('authMessages')) {
          return t.authenticate(
            localizedReason: localizedReason,
            biometricOnly: biometricOnly,
            sensitiveTransaction: sensitiveTransaction,
            persistAcrossBackgrounding: persistAcrossBackgrounding,
            options: options,
          );
        }
        if (named.containsKey('authMessages')) {
          final authMessages = D4.coerceList<$local_auth_kit_1.AuthMessages>(
            named['authMessages'],
            'authMessages',
          );
          return t.authenticate(
            localizedReason: localizedReason,
            biometricOnly: biometricOnly,
            sensitiveTransaction: sensitiveTransaction,
            persistAcrossBackgrounding: persistAcrossBackgrounding,
            options: options,
            authMessages: authMessages,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'stopAuthentication': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_3.LocalAuthentication>(
          target,
          'LocalAuthentication',
        );
        return t.stopAuthentication();
      },
    },
    constructorSignatures: {
      '': 'LocalAuthentication()',
      'withBackend':
          'LocalAuthentication.withBackend(LocalAuthBackend _backend)',
    },
    methodSignatures: {
      'isDeviceSupported': 'Future<bool> isDeviceSupported()',
      'getAvailableBiometrics':
          'Future<List<BiometricType>> getAvailableBiometrics()',
      'authenticate':
          'Future<bool> authenticate({required String localizedReason, bool biometricOnly = false, bool sensitiveTransaction = true, bool persistAcrossBackgrounding = false, AuthenticationOptions? options, Iterable<AuthMessages> authMessages = const [AndroidAuthMessages(), IOSAuthMessages()]})',
      'stopAuthentication': 'Future<bool> stopAuthentication()',
    },
    getterSignatures: {
      'canCheckBiometrics': 'Future<bool> get canCheckBiometrics',
    },
  );
}

// =============================================================================
// LocalAuthFFIBindings Bridge
// =============================================================================

BridgedClass _createLocalAuthFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $local_auth_kit_4.LocalAuthFFIBindings,
    name: 'LocalAuthFFIBindings',
    isAssignable: (v) => v is $local_auth_kit_4.LocalAuthFFIBindings,
    hierarchyDepth: 1,
    constructors: {},
    methods: {
      'isDeviceSupported': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_4.LocalAuthFFIBindings>(
          target,
          'LocalAuthFFIBindings',
        );
        return t.isDeviceSupported();
      },
      'canCheckBiometrics': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_4.LocalAuthFFIBindings>(
          target,
          'LocalAuthFFIBindings',
        );
        return t.canCheckBiometrics();
      },
      'availableBiometrics': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_4.LocalAuthFFIBindings>(
          target,
          'LocalAuthFFIBindings',
        );
        return t.availableBiometrics();
      },
      'authenticate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_4.LocalAuthFFIBindings>(
          target,
          'LocalAuthFFIBindings',
        );
        final token = D4.getRequiredNamedArg<int>(
          named,
          'token',
          'authenticate',
        );
        final reason = D4.getRequiredNamedArg<String>(
          named,
          'reason',
          'authenticate',
        );
        final options = D4.getRequiredNamedArg<int>(
          named,
          'options',
          'authenticate',
        );
        final messages = D4.getRequiredNamedArg<String>(
          named,
          'messages',
          'authenticate',
        );
        if (!named.containsKey('complete') || named['complete'] == null) {
          throw ArgumentError(
            'authenticate: Missing required named argument "complete"',
          );
        }
        final completeRaw = named['complete'];
        t.authenticate(
          token: token,
          reason: reason,
          options: options,
          messages: messages,
          complete: (int p0, int p1, String p2) {
            D4.callInterpreterCallback(visitor!, completeRaw, [p0, p1, p2]);
          },
        );
        return null;
      },
      'stopAuthentication': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$local_auth_kit_4.LocalAuthFFIBindings>(
          target,
          'LocalAuthFFIBindings',
        );
        return t.stopAuthentication();
      },
    },
    staticGetters: {
      'instance': (visitor) => $local_auth_kit_4.LocalAuthFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $local_auth_kit_4.LocalAuthFFIBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'isDeviceSupported': 'int isDeviceSupported()',
      'canCheckBiometrics': 'int canCheckBiometrics()',
      'availableBiometrics': 'int availableBiometrics()',
      'authenticate':
          'void authenticate({required int token, required String reason, required int options, required String messages, required void Function(int token, int result, String message) complete})',
      'stopAuthentication': 'int stopAuthentication()',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'LocalAuthFFIBindings get instance',
    },
  );
}

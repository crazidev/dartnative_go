// D4rt Bridge - Generated file, do not edit
// Sources: 8 files
// Generated: 2026-11-24T16:25:22.613651 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';

import 'package:dartnative_social_sign_in/src/apple_id_authorization_scopes.dart'
    as $dartnative_social_sign_in_1;
import 'package:dartnative_social_sign_in/src/authorization_credential_apple_id.dart'
    as $dartnative_social_sign_in_2;
import 'package:dartnative_social_sign_in/src/google_sign_in.dart'
    as $dartnative_social_sign_in_3;
import 'package:dartnative_social_sign_in/src/google_sign_in_account.dart'
    as $dartnative_social_sign_in_4;
import 'package:dartnative_social_sign_in/src/google_sign_in_ffi_bindings.dart'
    as $dartnative_social_sign_in_5;
import 'package:dartnative_social_sign_in/src/sign_in_with_apple.dart'
    as $dartnative_social_sign_in_6;
import 'package:dartnative_social_sign_in/src/sign_in_with_apple_exception.dart'
    as $dartnative_social_sign_in_7;
import 'package:dartnative_social_sign_in/src/sign_in_with_apple_ffi_bindings.dart'
    as $dartnative_social_sign_in_8;

/// Bridge class for dartnative_social_sign_in module.
class DartnativeSocialSignInBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createAuthorizationCredentialAppleIDBridge(),
      _createSignInWithAppleBridge(),
      _createSignInWithAppleExceptionBridge(),
      _createSignInWithAppleAuthorizationExceptionBridge(),
      _createSignInWithAppleFFIBindingsBridge(),
      _createGoogleSignInAuthenticationBridge(),
      _createGoogleSignInAccountBridge(),
      _createGoogleSignInExceptionBridge(),
      _createGoogleSignInBridge(),
      _createGoogleSignInFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'AuthorizationCredentialAppleID':
          _createAuthorizationCredentialAppleIDBridge,
      'SignInWithApple': _createSignInWithAppleBridge,
      'SignInWithAppleException': _createSignInWithAppleExceptionBridge,
      'SignInWithAppleAuthorizationException':
          _createSignInWithAppleAuthorizationExceptionBridge,
      'SignInWithAppleFFIBindings': _createSignInWithAppleFFIBindingsBridge,
      'GoogleSignInAuthentication': _createGoogleSignInAuthenticationBridge,
      'GoogleSignInAccount': _createGoogleSignInAccountBridge,
      'GoogleSignInException': _createGoogleSignInExceptionBridge,
      'GoogleSignIn': _createGoogleSignInBridge,
      'GoogleSignInFFIBindings': _createGoogleSignInFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'AuthorizationCredentialAppleID':
          $dartnative_social_sign_in_2.AuthorizationCredentialAppleID,
      'SignInWithApple': $dartnative_social_sign_in_6.SignInWithApple,
      'SignInWithAppleException':
          $dartnative_social_sign_in_7.SignInWithAppleException,
      'SignInWithAppleAuthorizationException':
          $dartnative_social_sign_in_7.SignInWithAppleAuthorizationException,
      'SignInWithAppleFFIBindings':
          $dartnative_social_sign_in_8.SignInWithAppleFFIBindings,
      'GoogleSignInAuthentication':
          $dartnative_social_sign_in_4.GoogleSignInAuthentication,
      'GoogleSignInAccount': $dartnative_social_sign_in_4.GoogleSignInAccount,
      'GoogleSignInException':
          $dartnative_social_sign_in_3.GoogleSignInException,
      'GoogleSignIn': $dartnative_social_sign_in_3.GoogleSignIn,
      'GoogleSignInFFIBindings':
          $dartnative_social_sign_in_5.GoogleSignInFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'AuthorizationCredentialAppleID':
          'package:dartnative_social_sign_in/src/authorization_credential_apple_id.dart',
      'SignInWithApple':
          'package:dartnative_social_sign_in/src/sign_in_with_apple.dart',
      'SignInWithAppleException':
          'package:dartnative_social_sign_in/src/sign_in_with_apple_exception.dart',
      'SignInWithAppleAuthorizationException':
          'package:dartnative_social_sign_in/src/sign_in_with_apple_exception.dart',
      'SignInWithAppleFFIBindings':
          'package:dartnative_social_sign_in/src/sign_in_with_apple_ffi_bindings.dart',
      'GoogleSignInAuthentication':
          'package:dartnative_social_sign_in/src/google_sign_in_account.dart',
      'GoogleSignInAccount':
          'package:dartnative_social_sign_in/src/google_sign_in_account.dart',
      'GoogleSignInException':
          'package:dartnative_social_sign_in/src/google_sign_in.dart',
      'GoogleSignIn':
          'package:dartnative_social_sign_in/src/google_sign_in.dart',
      'GoogleSignInFFIBindings':
          'package:dartnative_social_sign_in/src/google_sign_in_ffi_bindings.dart',
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
      'SignInWithAppleException': ['Exception'],
      'SignInWithAppleAuthorizationException': [
        'SignInWithAppleException',
        'Exception',
      ],
      'GoogleSignInException': ['Exception'],
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
      BridgedEnumDefinition<
        $dartnative_social_sign_in_1.AppleIDAuthorizationScopes
      >(
        name: 'AppleIDAuthorizationScopes',
        values: $dartnative_social_sign_in_1.AppleIDAuthorizationScopes.values,
      ),
      BridgedEnumDefinition<
        $dartnative_social_sign_in_7.AuthorizationErrorCode
      >(
        name: 'AuthorizationErrorCode',
        values: $dartnative_social_sign_in_7.AuthorizationErrorCode.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'AppleIDAuthorizationScopes':
          'package:dartnative_social_sign_in/src/apple_id_authorization_scopes.dart',
      'AuthorizationErrorCode':
          'package:dartnative_social_sign_in/src/sign_in_with_apple_exception.dart',
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
        source: 'package:dartnative_social_sign_in/social_sign_in.dart',
        target:
            'package:dartnative_social_sign_in/src/apple_id_authorization_scopes.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_social_sign_in/social_sign_in.dart',
        target:
            'package:dartnative_social_sign_in/src/authorization_credential_apple_id.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_social_sign_in/social_sign_in.dart',
        target: 'package:dartnative_social_sign_in/src/sign_in_with_apple.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_social_sign_in/social_sign_in.dart',
        target:
            'package:dartnative_social_sign_in/src/sign_in_with_apple_exception.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_social_sign_in/social_sign_in.dart',
        target:
            'package:dartnative_social_sign_in/src/sign_in_with_apple_ffi_bindings.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_social_sign_in/social_sign_in.dart',
        target:
            'package:dartnative_social_sign_in/src/google_sign_in_account.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_social_sign_in/social_sign_in.dart',
        target: 'package:dartnative_social_sign_in/src/google_sign_in.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_social_sign_in/social_sign_in.dart',
        target:
            'package:dartnative_social_sign_in/src/google_sign_in_ffi_bindings.dart',
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
      'package:dartnative_social_sign_in/src/apple_id_authorization_scopes.dart',
      'package:dartnative_social_sign_in/src/authorization_credential_apple_id.dart',
      'package:dartnative_social_sign_in/src/google_sign_in.dart',
      'package:dartnative_social_sign_in/src/google_sign_in_account.dart',
      'package:dartnative_social_sign_in/src/google_sign_in_ffi_bindings.dart',
      'package:dartnative_social_sign_in/src/sign_in_with_apple.dart',
      'package:dartnative_social_sign_in/src/sign_in_with_apple_exception.dart',
      'package:dartnative_social_sign_in/src/sign_in_with_apple_ffi_bindings.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_social_sign_in/social_sign_in.dart';";
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
    'AppleIDAuthorizationScopes',
    'AuthorizationErrorCode',
  ];
}

// =============================================================================
// AuthorizationCredentialAppleID Bridge
// =============================================================================

BridgedClass _createAuthorizationCredentialAppleIDBridge() {
  return BridgedClass(
    nativeType: $dartnative_social_sign_in_2.AuthorizationCredentialAppleID,
    name: 'AuthorizationCredentialAppleID',
    isAssignable: (v) =>
        v is $dartnative_social_sign_in_2.AuthorizationCredentialAppleID,
    constructors: {
      '': (visitor, positional, named) {
        final userIdentifier = D4.getRequiredNamedArg<String>(
          named,
          'userIdentifier',
          'AuthorizationCredentialAppleID',
        );
        final authorizationCode = D4.getRequiredNamedArg<String?>(
          named,
          'authorizationCode',
          'AuthorizationCredentialAppleID',
        );
        final identityToken = D4.getOptionalNamedArg<String?>(
          named,
          'identityToken',
        );
        final givenName = D4.getOptionalNamedArg<String?>(named, 'givenName');
        final familyName = D4.getOptionalNamedArg<String?>(named, 'familyName');
        final email = D4.getOptionalNamedArg<String?>(named, 'email');
        final state = D4.getOptionalNamedArg<String?>(named, 'state');
        return $dartnative_social_sign_in_2.AuthorizationCredentialAppleID(
          userIdentifier: userIdentifier,
          authorizationCode: authorizationCode,
          identityToken: identityToken,
          givenName: givenName,
          familyName: familyName,
          email: email,
          state: state,
        );
      },
    },
    getters: {
      'userIdentifier': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_2.AuthorizationCredentialAppleID
          >(target, 'AuthorizationCredentialAppleID')
          .userIdentifier,
      'identityToken': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_2.AuthorizationCredentialAppleID
          >(target, 'AuthorizationCredentialAppleID')
          .identityToken,
      'authorizationCode': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_2.AuthorizationCredentialAppleID
          >(target, 'AuthorizationCredentialAppleID')
          .authorizationCode,
      'givenName': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_2.AuthorizationCredentialAppleID
          >(target, 'AuthorizationCredentialAppleID')
          .givenName,
      'familyName': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_2.AuthorizationCredentialAppleID
          >(target, 'AuthorizationCredentialAppleID')
          .familyName,
      'email': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_2.AuthorizationCredentialAppleID
          >(target, 'AuthorizationCredentialAppleID')
          .email,
      'state': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_2.AuthorizationCredentialAppleID
          >(target, 'AuthorizationCredentialAppleID')
          .state,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_social_sign_in_2.AuthorizationCredentialAppleID
            >(target, 'AuthorizationCredentialAppleID');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const AuthorizationCredentialAppleID({required String userIdentifier, required String? authorizationCode, String? identityToken, String? givenName, String? familyName, String? email, String? state})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'userIdentifier': 'String get userIdentifier',
      'identityToken': 'String? get identityToken',
      'authorizationCode': 'String? get authorizationCode',
      'givenName': 'String? get givenName',
      'familyName': 'String? get familyName',
      'email': 'String? get email',
      'state': 'String? get state',
    },
  );
}

// =============================================================================
// SignInWithApple Bridge
// =============================================================================

BridgedClass _createSignInWithAppleBridge() {
  return BridgedClass(
    nativeType: $dartnative_social_sign_in_6.SignInWithApple,
    name: 'SignInWithApple',
    isAssignable: (v) => v is $dartnative_social_sign_in_6.SignInWithApple,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_social_sign_in_6.SignInWithApple();
      },
    },
    staticMethods: {
      'getAppleIDCredential': (visitor, positional, named, typeArgs) {
        if (!named.containsKey('scopes') || named['scopes'] == null) {
          throw ArgumentError(
            'getAppleIDCredential: Missing required named argument "scopes"',
          );
        }
        final scopes = D4
            .coerceList<
              $dartnative_social_sign_in_1.AppleIDAuthorizationScopes
            >(named['scopes'], 'scopes');
        final nonce = D4.getOptionalNamedArg<String?>(named, 'nonce');
        final state = D4.getOptionalNamedArg<String?>(named, 'state');
        final maxAttempts = D4.getNamedArgWithDefault<int>(
          named,
          'maxAttempts',
          2,
        );
        final retryDelay = D4.getNamedArgWithDefault<Duration>(
          named,
          'retryDelay',
          const Duration(milliseconds: 500),
        );
        return $dartnative_social_sign_in_6
            .SignInWithApple.getAppleIDCredential(
          scopes: scopes,
          nonce: nonce,
          state: state,
          maxAttempts: maxAttempts,
          retryDelay: retryDelay,
        );
      },
    },
    constructorSignatures: {
      '': 'SignInWithApple()',
    },
    staticMethodSignatures: {
      'getAppleIDCredential':
          'Future<AuthorizationCredentialAppleID> getAppleIDCredential({required List<AppleIDAuthorizationScopes> scopes, String? nonce, String? state, int maxAttempts = 2, Duration retryDelay = const Duration(milliseconds: 500)})',
    },
  );
}

// =============================================================================
// SignInWithAppleException Bridge
// =============================================================================

BridgedClass _createSignInWithAppleExceptionBridge() {
  return BridgedClass(
    nativeType: $dartnative_social_sign_in_7.SignInWithAppleException,
    name: 'SignInWithAppleException',
    isAssignable: (v) =>
        v is $dartnative_social_sign_in_7.SignInWithAppleException,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'SignInWithAppleException');
        final message = D4.getRequiredArg<String>(
          positional,
          0,
          'message',
          'SignInWithAppleException',
        );
        return $dartnative_social_sign_in_7.SignInWithAppleException(message);
      },
    },
    getters: {
      'message': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_7.SignInWithAppleException
          >(target, 'SignInWithAppleException')
          .message,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_social_sign_in_7.SignInWithAppleException
            >(target, 'SignInWithAppleException');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const SignInWithAppleException(String message)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'message': 'String get message',
    },
  );
}

// =============================================================================
// SignInWithAppleAuthorizationException Bridge
// =============================================================================

BridgedClass _createSignInWithAppleAuthorizationExceptionBridge() {
  return BridgedClass(
    nativeType:
        $dartnative_social_sign_in_7.SignInWithAppleAuthorizationException,
    name: 'SignInWithAppleAuthorizationException',
    isAssignable: (v) =>
        v is $dartnative_social_sign_in_7.SignInWithAppleAuthorizationException,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(
          positional,
          1,
          'SignInWithAppleAuthorizationException',
        );
        final message = D4.getRequiredArg<String>(
          positional,
          0,
          'message',
          'SignInWithAppleAuthorizationException',
        );
        final code = D4
            .getRequiredNamedArg<
              $dartnative_social_sign_in_7.AuthorizationErrorCode
            >(named, 'code', 'SignInWithAppleAuthorizationException');
        return $dartnative_social_sign_in_7.SignInWithAppleAuthorizationException(
          message,
          code: code,
        );
      },
    },
    getters: {
      'message': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_7.SignInWithAppleAuthorizationException
          >(target, 'SignInWithAppleAuthorizationException')
          .message,
      'code': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_7.SignInWithAppleAuthorizationException
          >(target, 'SignInWithAppleAuthorizationException')
          .code,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_social_sign_in_7.SignInWithAppleAuthorizationException
            >(target, 'SignInWithAppleAuthorizationException');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const SignInWithAppleAuthorizationException(String message, {required AuthorizationErrorCode code})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'message': 'String get message',
      'code': 'AuthorizationErrorCode get code',
    },
  );
}

// =============================================================================
// SignInWithAppleFFIBindings Bridge
// =============================================================================

BridgedClass _createSignInWithAppleFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_social_sign_in_8.SignInWithAppleFFIBindings,
    name: 'SignInWithAppleFFIBindings',
    isAssignable: (v) =>
        v is $dartnative_social_sign_in_8.SignInWithAppleFFIBindings,
    constructors: {},
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_8
            .SignInWithAppleFFIBindings.loadSymbols();
      },
      'performRequest': (visitor, positional, named, typeArgs) {
        final scopesMask = D4.getRequiredNamedArg<int>(
          named,
          'scopesMask',
          'performRequest',
        );
        final nonce = D4.getRequiredNamedArg<String>(
          named,
          'nonce',
          'performRequest',
        );
        return $dartnative_social_sign_in_8
            .SignInWithAppleFFIBindings.performRequest(
          scopesMask: scopesMask,
          nonce: nonce,
        );
      },
      'readIdentityToken': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_8
            .SignInWithAppleFFIBindings.readIdentityToken();
      },
      'readUserIdentifier': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_8
            .SignInWithAppleFFIBindings.readUserIdentifier();
      },
      'readGivenName': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_8
            .SignInWithAppleFFIBindings.readGivenName();
      },
      'readFamilyName': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_8
            .SignInWithAppleFFIBindings.readFamilyName();
      },
      'readEmail': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_8
            .SignInWithAppleFFIBindings.readEmail();
      },
      'readAuthCode': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_8
            .SignInWithAppleFFIBindings.readAuthCode();
      },
      'readError': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_8
            .SignInWithAppleFFIBindings.readError();
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'performRequest':
          'Future<int> performRequest({required int scopesMask, required String nonce})',
      'readIdentityToken': 'String readIdentityToken()',
      'readUserIdentifier': 'String readUserIdentifier()',
      'readGivenName': 'String? readGivenName()',
      'readFamilyName': 'String? readFamilyName()',
      'readEmail': 'String? readEmail()',
      'readAuthCode': 'String? readAuthCode()',
      'readError': 'String readError()',
    },
  );
}

// =============================================================================
// GoogleSignInAuthentication Bridge
// =============================================================================

BridgedClass _createGoogleSignInAuthenticationBridge() {
  return BridgedClass(
    nativeType: $dartnative_social_sign_in_4.GoogleSignInAuthentication,
    name: 'GoogleSignInAuthentication',
    isAssignable: (v) =>
        v is $dartnative_social_sign_in_4.GoogleSignInAuthentication,
    constructors: {
      '': (visitor, positional, named) {
        final idToken = D4.getOptionalNamedArg<String?>(named, 'idToken');
        final accessToken = D4.getOptionalNamedArg<String?>(
          named,
          'accessToken',
        );
        return $dartnative_social_sign_in_4.GoogleSignInAuthentication(
          idToken: idToken,
          accessToken: accessToken,
        );
      },
    },
    getters: {
      'idToken': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_4.GoogleSignInAuthentication
          >(target, 'GoogleSignInAuthentication')
          .idToken,
      'accessToken': (visitor, target) => D4
          .validateTarget<
            $dartnative_social_sign_in_4.GoogleSignInAuthentication
          >(target, 'GoogleSignInAuthentication')
          .accessToken,
    },
    constructorSignatures: {
      '': 'const GoogleSignInAuthentication({String? idToken, String? accessToken})',
    },
    getterSignatures: {
      'idToken': 'String? get idToken',
      'accessToken': 'String? get accessToken',
    },
  );
}

// =============================================================================
// GoogleSignInAccount Bridge
// =============================================================================

BridgedClass _createGoogleSignInAccountBridge() {
  return BridgedClass(
    nativeType: $dartnative_social_sign_in_4.GoogleSignInAccount,
    name: 'GoogleSignInAccount',
    isAssignable: (v) => v is $dartnative_social_sign_in_4.GoogleSignInAccount,
    constructors: {
      '': (visitor, positional, named) {
        final email = D4.getRequiredNamedArg<String>(
          named,
          'email',
          'GoogleSignInAccount',
        );
        final displayName = D4.getRequiredNamedArg<String?>(
          named,
          'displayName',
          'GoogleSignInAccount',
        );
        final authentication = D4
            .getRequiredNamedArg<
              $dartnative_social_sign_in_4.GoogleSignInAuthentication
            >(named, 'authentication', 'GoogleSignInAccount');
        return $dartnative_social_sign_in_4.GoogleSignInAccount(
          email: email,
          displayName: displayName,
          authentication: authentication,
        );
      },
    },
    getters: {
      'email': (visitor, target) => D4
          .validateTarget<$dartnative_social_sign_in_4.GoogleSignInAccount>(
            target,
            'GoogleSignInAccount',
          )
          .email,
      'displayName': (visitor, target) => D4
          .validateTarget<$dartnative_social_sign_in_4.GoogleSignInAccount>(
            target,
            'GoogleSignInAccount',
          )
          .displayName,
      'authentication': (visitor, target) => D4
          .validateTarget<$dartnative_social_sign_in_4.GoogleSignInAccount>(
            target,
            'GoogleSignInAccount',
          )
          .authentication,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_social_sign_in_4.GoogleSignInAccount>(
              target,
              'GoogleSignInAccount',
            );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const GoogleSignInAccount({required String email, required String? displayName, required GoogleSignInAuthentication authentication})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'email': 'String get email',
      'displayName': 'String? get displayName',
      'authentication': 'GoogleSignInAuthentication get authentication',
    },
  );
}

// =============================================================================
// GoogleSignInException Bridge
// =============================================================================

BridgedClass _createGoogleSignInExceptionBridge() {
  return BridgedClass(
    nativeType: $dartnative_social_sign_in_3.GoogleSignInException,
    name: 'GoogleSignInException',
    isAssignable: (v) =>
        v is $dartnative_social_sign_in_3.GoogleSignInException,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'GoogleSignInException');
        final message = D4.getRequiredArg<String>(
          positional,
          0,
          'message',
          'GoogleSignInException',
        );
        final canceled = D4.getNamedArgWithDefault<bool>(
          named,
          'canceled',
          false,
        );
        return $dartnative_social_sign_in_3.GoogleSignInException(
          message,
          canceled: canceled,
        );
      },
    },
    getters: {
      'message': (visitor, target) => D4
          .validateTarget<$dartnative_social_sign_in_3.GoogleSignInException>(
            target,
            'GoogleSignInException',
          )
          .message,
      'canceled': (visitor, target) => D4
          .validateTarget<$dartnative_social_sign_in_3.GoogleSignInException>(
            target,
            'GoogleSignInException',
          )
          .canceled,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_social_sign_in_3.GoogleSignInException>(
              target,
              'GoogleSignInException',
            );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const GoogleSignInException(String message, {bool canceled = false})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'message': 'String get message',
      'canceled': 'bool get canceled',
    },
  );
}

// =============================================================================
// GoogleSignIn Bridge
// =============================================================================

BridgedClass _createGoogleSignInBridge() {
  return BridgedClass(
    nativeType: $dartnative_social_sign_in_3.GoogleSignIn,
    name: 'GoogleSignIn',
    isAssignable: (v) => v is $dartnative_social_sign_in_3.GoogleSignIn,
    constructors: {
      '': (visitor, positional, named) {
        final serverClientId = D4.getOptionalNamedArg<String?>(
          named,
          'serverClientId',
        );
        return $dartnative_social_sign_in_3.GoogleSignIn(
          serverClientId: serverClientId,
        );
      },
    },
    getters: {
      'serverClientId': (visitor, target) => D4
          .validateTarget<$dartnative_social_sign_in_3.GoogleSignIn>(
            target,
            'GoogleSignIn',
          )
          .serverClientId,
    },
    methods: {
      'signIn': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_social_sign_in_3.GoogleSignIn>(
          target,
          'GoogleSignIn',
        );
        final maxAttempts = D4.getNamedArgWithDefault<int>(
          named,
          'maxAttempts',
          2,
        );
        final retryDelay = D4.getNamedArgWithDefault<Duration>(
          named,
          'retryDelay',
          const Duration(milliseconds: 500),
        );
        return t.signIn(maxAttempts: maxAttempts, retryDelay: retryDelay);
      },
    },
    constructorSignatures: {
      '': 'const GoogleSignIn({String? serverClientId})',
    },
    methodSignatures: {
      'signIn':
          'Future<GoogleSignInAccount?> signIn({int maxAttempts = 2, Duration retryDelay = const Duration(milliseconds: 500)})',
    },
    getterSignatures: {
      'serverClientId': 'String? get serverClientId',
    },
  );
}

// =============================================================================
// GoogleSignInFFIBindings Bridge
// =============================================================================

BridgedClass _createGoogleSignInFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_social_sign_in_5.GoogleSignInFFIBindings,
    name: 'GoogleSignInFFIBindings',
    isAssignable: (v) =>
        v is $dartnative_social_sign_in_5.GoogleSignInFFIBindings,
    constructors: {},
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_5
            .GoogleSignInFFIBindings.loadSymbols();
      },
      'performRequest': (visitor, positional, named, typeArgs) {
        final serverClientId = D4.getRequiredNamedArg<String>(
          named,
          'serverClientId',
          'performRequest',
        );
        return $dartnative_social_sign_in_5
            .GoogleSignInFFIBindings.performRequest(
          serverClientId: serverClientId,
        );
      },
      'readIdToken': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_5
            .GoogleSignInFFIBindings.readIdToken();
      },
      'readAccessToken': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_5
            .GoogleSignInFFIBindings.readAccessToken();
      },
      'readEmail': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_5.GoogleSignInFFIBindings.readEmail();
      },
      'readDisplayName': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_5
            .GoogleSignInFFIBindings.readDisplayName();
      },
      'readError': (visitor, positional, named, typeArgs) {
        return $dartnative_social_sign_in_5.GoogleSignInFFIBindings.readError();
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'performRequest':
          'Future<int> performRequest({required String serverClientId})',
      'readIdToken': 'String? readIdToken()',
      'readAccessToken': 'String readAccessToken()',
      'readEmail': 'String readEmail()',
      'readDisplayName': 'String? readDisplayName()',
      'readError': 'String readError()',
    },
  );
}

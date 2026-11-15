// D4rt Bridge - Generated file, do not edit
// Sources: 17 files
// Generated: 2026-11-15T01:15:42.455783 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';

import 'package:dartnative_passkeys/src/passkey_authenticator.dart'
    as $dartnative_passkeys_1;
import 'package:dartnative_passkeys/src/passkey_exception.dart'
    as $dartnative_passkeys_2;
import 'package:dartnative_passkeys/src/passkeys_ffi_bindings.dart'
    as $dartnative_passkeys_3;
import 'package:passkeys_platform_interface/passkey_authenticator_interface.dart'
    as $passkeys_platform_interface_1;
import 'package:passkeys_platform_interface/types/authenticate_request.dart'
    as $passkeys_platform_interface_2;
import 'package:passkeys_platform_interface/types/authenticate_response.dart'
    as $passkeys_platform_interface_3;
import 'package:passkeys_platform_interface/types/authenticator_selection.dart'
    as $passkeys_platform_interface_4;
import 'package:passkeys_platform_interface/types/availability.dart'
    as $passkeys_platform_interface_5;
import 'package:passkeys_platform_interface/types/credential.dart'
    as $passkeys_platform_interface_6;
import 'package:passkeys_platform_interface/types/mediation.dart'
    as $passkeys_platform_interface_7;
import 'package:passkeys_platform_interface/types/password_credential.dart'
    as $passkeys_platform_interface_8;
import 'package:passkeys_platform_interface/types/pubkeycred_param.dart'
    as $passkeys_platform_interface_9;
import 'package:passkeys_platform_interface/types/register_request.dart'
    as $passkeys_platform_interface_10;
import 'package:passkeys_platform_interface/types/register_response.dart'
    as $passkeys_platform_interface_11;
import 'package:passkeys_platform_interface/types/relying_party.dart'
    as $passkeys_platform_interface_12;
import 'package:passkeys_platform_interface/types/signal_request.dart'
    as $passkeys_platform_interface_13;
import 'package:passkeys_platform_interface/types/user.dart'
    as $passkeys_platform_interface_14;

/// Bridge class for dartnative_passkeys module.
class DartnativePasskeysBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createRestoreCredentialInterfaceBridge(),
      _createAuthenticateRequestTypeBridge(),
      _createAuthenticateResponseTypeBridge(),
      _createAuthenticatorSelectionTypeBridge(),
      _createAvailabilityTypeBridge(),
      _createAvailabilityTypeWebBridge(),
      _createAvailabilityTypeAndroidBridge(),
      _createAvailabilityTypeIOSBridge(),
      _createAvailabilityTypeWindowsBridge(),
      _createPasswordCredentialTypeBridge(),
      _createPasswordOrPasskeyResponseTypeBridge(),
      _createRegisterRequestTypeBridge(),
      _createRegisterResponseTypeBridge(),
      _createRelyingPartyTypeBridge(),
      _createSignalUnknownCredentialRequestTypeBridge(),
      _createSignalAllAcceptedCredentialsRequestTypeBridge(),
      _createUserTypeBridge(),
      _createCredentialTypeBridge(),
      _createPubKeyCredParamTypeBridge(),
      _createPasskeyAuthenticatorBridge(),
      _createPasskeyExceptionBridge(),
      _createPasskeysFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'RestoreCredentialInterface': _createRestoreCredentialInterfaceBridge,
      'AuthenticateRequestType': _createAuthenticateRequestTypeBridge,
      'AuthenticateResponseType': _createAuthenticateResponseTypeBridge,
      'AuthenticatorSelectionType': _createAuthenticatorSelectionTypeBridge,
      'AvailabilityType': _createAvailabilityTypeBridge,
      'AvailabilityTypeWeb': _createAvailabilityTypeWebBridge,
      'AvailabilityTypeAndroid': _createAvailabilityTypeAndroidBridge,
      'AvailabilityTypeIOS': _createAvailabilityTypeIOSBridge,
      'AvailabilityTypeWindows': _createAvailabilityTypeWindowsBridge,
      'PasswordCredentialType': _createPasswordCredentialTypeBridge,
      'PasswordOrPasskeyResponseType':
          _createPasswordOrPasskeyResponseTypeBridge,
      'RegisterRequestType': _createRegisterRequestTypeBridge,
      'RegisterResponseType': _createRegisterResponseTypeBridge,
      'RelyingPartyType': _createRelyingPartyTypeBridge,
      'SignalUnknownCredentialRequestType':
          _createSignalUnknownCredentialRequestTypeBridge,
      'SignalAllAcceptedCredentialsRequestType':
          _createSignalAllAcceptedCredentialsRequestTypeBridge,
      'UserType': _createUserTypeBridge,
      'CredentialType': _createCredentialTypeBridge,
      'PubKeyCredParamType': _createPubKeyCredParamTypeBridge,
      'PasskeyAuthenticator': _createPasskeyAuthenticatorBridge,
      'PasskeyException': _createPasskeyExceptionBridge,
      'PasskeysFFIBindings': _createPasskeysFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'RestoreCredentialInterface':
          $passkeys_platform_interface_1.RestoreCredentialInterface,
      'AuthenticateRequestType':
          $passkeys_platform_interface_2.AuthenticateRequestType,
      'AuthenticateResponseType':
          $passkeys_platform_interface_3.AuthenticateResponseType,
      'AuthenticatorSelectionType':
          $passkeys_platform_interface_4.AuthenticatorSelectionType,
      'AvailabilityType': $passkeys_platform_interface_5.AvailabilityType,
      'AvailabilityTypeWeb': $passkeys_platform_interface_5.AvailabilityTypeWeb,
      'AvailabilityTypeAndroid':
          $passkeys_platform_interface_5.AvailabilityTypeAndroid,
      'AvailabilityTypeIOS': $passkeys_platform_interface_5.AvailabilityTypeIOS,
      'AvailabilityTypeWindows':
          $passkeys_platform_interface_5.AvailabilityTypeWindows,
      'PasswordCredentialType':
          $passkeys_platform_interface_8.PasswordCredentialType,
      'PasswordOrPasskeyResponseType':
          $passkeys_platform_interface_8.PasswordOrPasskeyResponseType,
      'RegisterRequestType':
          $passkeys_platform_interface_10.RegisterRequestType,
      'RegisterResponseType':
          $passkeys_platform_interface_11.RegisterResponseType,
      'RelyingPartyType': $passkeys_platform_interface_12.RelyingPartyType,
      'SignalUnknownCredentialRequestType':
          $passkeys_platform_interface_13.SignalUnknownCredentialRequestType,
      'SignalAllAcceptedCredentialsRequestType': $passkeys_platform_interface_13
          .SignalAllAcceptedCredentialsRequestType,
      'UserType': $passkeys_platform_interface_14.UserType,
      'CredentialType': $passkeys_platform_interface_6.CredentialType,
      'PubKeyCredParamType': $passkeys_platform_interface_9.PubKeyCredParamType,
      'PasskeyAuthenticator': $dartnative_passkeys_1.PasskeyAuthenticator,
      'PasskeyException': $dartnative_passkeys_2.PasskeyException,
      'PasskeysFFIBindings': $dartnative_passkeys_3.PasskeysFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'RestoreCredentialInterface':
          'package:passkeys_platform_interface/passkey_authenticator_interface.dart',
      'AuthenticateRequestType':
          'package:passkeys_platform_interface/types/authenticate_request.dart',
      'AuthenticateResponseType':
          'package:passkeys_platform_interface/types/authenticate_response.dart',
      'AuthenticatorSelectionType':
          'package:passkeys_platform_interface/types/authenticator_selection.dart',
      'AvailabilityType':
          'package:passkeys_platform_interface/types/availability.dart',
      'AvailabilityTypeWeb':
          'package:passkeys_platform_interface/types/availability.dart',
      'AvailabilityTypeAndroid':
          'package:passkeys_platform_interface/types/availability.dart',
      'AvailabilityTypeIOS':
          'package:passkeys_platform_interface/types/availability.dart',
      'AvailabilityTypeWindows':
          'package:passkeys_platform_interface/types/availability.dart',
      'PasswordCredentialType':
          'package:passkeys_platform_interface/types/password_credential.dart',
      'PasswordOrPasskeyResponseType':
          'package:passkeys_platform_interface/types/password_credential.dart',
      'RegisterRequestType':
          'package:passkeys_platform_interface/types/register_request.dart',
      'RegisterResponseType':
          'package:passkeys_platform_interface/types/register_response.dart',
      'RelyingPartyType':
          'package:passkeys_platform_interface/types/relying_party.dart',
      'SignalUnknownCredentialRequestType':
          'package:passkeys_platform_interface/types/signal_request.dart',
      'SignalAllAcceptedCredentialsRequestType':
          'package:passkeys_platform_interface/types/signal_request.dart',
      'UserType': 'package:passkeys_platform_interface/types/user.dart',
      'CredentialType':
          'package:passkeys_platform_interface/types/credential.dart',
      'PubKeyCredParamType':
          'package:passkeys_platform_interface/types/pubkeycred_param.dart',
      'PasskeyAuthenticator':
          'package:dartnative_passkeys/src/passkey_authenticator.dart',
      'PasskeyException':
          'package:dartnative_passkeys/src/passkey_exception.dart',
      'PasskeysFFIBindings':
          'package:dartnative_passkeys/src/passkeys_ffi_bindings.dart',
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
      'AvailabilityTypeWeb': ['AvailabilityType'],
      'AvailabilityTypeAndroid': ['AvailabilityType'],
      'AvailabilityTypeIOS': ['AvailabilityType'],
      'AvailabilityTypeWindows': ['AvailabilityType'],
      'PasskeyAuthenticator': ['RestoreCredentialInterface'],
      'PasskeyException': ['Exception'],
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
      BridgedEnumDefinition<$passkeys_platform_interface_7.MediationType>(
        name: 'MediationType',
        values: $passkeys_platform_interface_7.MediationType.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'MediationType':
          'package:passkeys_platform_interface/types/mediation.dart',
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
        source: 'package:dartnative_passkeys/dartnative_passkeys.dart',
        target:
            'package:passkeys_platform_interface/passkey_authenticator_interface.dart',
        show: {'RestoreCredentialInterface'},
        hide: null,
      ),
      (
        source: 'package:dartnative_passkeys/dartnative_passkeys.dart',
        target: 'package:passkeys_platform_interface/types/types.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_passkeys/dartnative_passkeys.dart',
        target: 'package:passkeys_platform_interface/types/credential.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_passkeys/dartnative_passkeys.dart',
        target:
            'package:passkeys_platform_interface/types/pubkeycred_param.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_passkeys/dartnative_passkeys.dart',
        target: 'package:dartnative_passkeys/src/passkey_authenticator.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_passkeys/dartnative_passkeys.dart',
        target: 'package:dartnative_passkeys/src/passkey_exception.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_passkeys/dartnative_passkeys.dart',
        target: 'package:dartnative_passkeys/src/passkeys_ffi_bindings.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target:
            'package:passkeys_platform_interface/types/authenticate_request.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target:
            'package:passkeys_platform_interface/types/authenticate_response.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target:
            'package:passkeys_platform_interface/types/authenticator_selection.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target: 'package:passkeys_platform_interface/types/availability.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target: 'package:passkeys_platform_interface/types/mediation.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target:
            'package:passkeys_platform_interface/types/password_credential.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target:
            'package:passkeys_platform_interface/types/register_request.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target:
            'package:passkeys_platform_interface/types/register_response.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target: 'package:passkeys_platform_interface/types/relying_party.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target: 'package:passkeys_platform_interface/types/signal_request.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:passkeys_platform_interface/types/types.dart',
        target: 'package:passkeys_platform_interface/types/user.dart',
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
      'package:dartnative_passkeys/src/passkey_authenticator.dart',
      'package:dartnative_passkeys/src/passkey_exception.dart',
      'package:dartnative_passkeys/src/passkeys_ffi_bindings.dart',
      'package:passkeys_platform_interface/passkey_authenticator_interface.dart',
      'package:passkeys_platform_interface/types/authenticate_request.dart',
      'package:passkeys_platform_interface/types/authenticate_response.dart',
      'package:passkeys_platform_interface/types/authenticator_selection.dart',
      'package:passkeys_platform_interface/types/availability.dart',
      'package:passkeys_platform_interface/types/credential.dart',
      'package:passkeys_platform_interface/types/mediation.dart',
      'package:passkeys_platform_interface/types/password_credential.dart',
      'package:passkeys_platform_interface/types/pubkeycred_param.dart',
      'package:passkeys_platform_interface/types/register_request.dart',
      'package:passkeys_platform_interface/types/register_response.dart',
      'package:passkeys_platform_interface/types/relying_party.dart',
      'package:passkeys_platform_interface/types/signal_request.dart',
      'package:passkeys_platform_interface/types/user.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    final imports = StringBuffer();
    imports.writeln(
      "import 'package:dartnative_passkeys/dartnative_passkeys.dart';",
    );
    imports.writeln(
      "import 'package:passkeys_platform_interface/passkeys_platform_interface.dart';",
    );
    return imports.toString();
  }

  /// Returns barrel import URIs for sub-packages discovered through re-exports.
  ///
  /// When a module follows re-exports into sub-packages (e.g., dcli re-exports
  /// dcli_core), D4rt scripts may import those sub-packages directly.
  /// These barrels need to be registered with the interpreter separately
  /// so that module resolution finds content for those URIs.
  static List<String> subPackageBarrels() {
    return [
      'package:passkeys_platform_interface/passkeys_platform_interface.dart',
    ];
  }

  /// Returns a list of bridged enum names.
  static List<String> get enumNames => [
    'MediationType',
  ];
}

// =============================================================================
// RestoreCredentialInterface Bridge
// =============================================================================

BridgedClass _createRestoreCredentialInterfaceBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_1.RestoreCredentialInterface,
    name: 'RestoreCredentialInterface',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_1.RestoreCredentialInterface,
    isAbstract: true,
    constructors: {},
    methods: {
      'createRestoreCredential':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<
                  $passkeys_platform_interface_1.RestoreCredentialInterface
                >(target, 'RestoreCredentialInterface');
            D4.requireMinArgs(positional, 1, 'createRestoreCredential');
            final request = D4
                .getRequiredArg<
                  $passkeys_platform_interface_10.RegisterRequestType
                >(positional, 0, 'request', 'createRestoreCredential');
            final isCloudBackupEnabled = D4.getNamedArgWithDefault<bool>(
              named,
              'isCloudBackupEnabled',
              true,
            );
            return t.createRestoreCredential(
              request,
              isCloudBackupEnabled: isCloudBackupEnabled,
            );
          },
      'getRestoreCredential': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_1.RestoreCredentialInterface
            >(target, 'RestoreCredentialInterface');
        D4.requireMinArgs(positional, 1, 'getRestoreCredential');
        final request = D4
            .getRequiredArg<
              $passkeys_platform_interface_2.AuthenticateRequestType
            >(positional, 0, 'request', 'getRestoreCredential');
        return t.getRestoreCredential(request);
      },
      'clearRestoreCredential': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_1.RestoreCredentialInterface
            >(target, 'RestoreCredentialInterface');
        return t.clearRestoreCredential();
      },
    },
    methodSignatures: {
      'createRestoreCredential':
          'Future<RegisterResponseType> createRestoreCredential(RegisterRequestType request, {bool isCloudBackupEnabled = true})',
      'getRestoreCredential':
          'Future<AuthenticateResponseType> getRestoreCredential(AuthenticateRequestType request)',
      'clearRestoreCredential': 'Future<void> clearRestoreCredential()',
    },
  );
}

// =============================================================================
// AuthenticateRequestType Bridge
// =============================================================================

BridgedClass _createAuthenticateRequestTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_2.AuthenticateRequestType,
    name: 'AuthenticateRequestType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_2.AuthenticateRequestType,
    constructors: {
      '': (visitor, positional, named) {
        final relyingPartyId = D4.getRequiredNamedArg<String>(
          named,
          'relyingPartyId',
          'AuthenticateRequestType',
        );
        final challenge = D4.getRequiredNamedArg<String>(
          named,
          'challenge',
          'AuthenticateRequestType',
        );
        final mediation = D4
            .getRequiredNamedArg<$passkeys_platform_interface_7.MediationType>(
              named,
              'mediation',
              'AuthenticateRequestType',
            );
        final preferImmediatelyAvailableCredentials = D4
            .getRequiredNamedArg<bool>(
              named,
              'preferImmediatelyAvailableCredentials',
              'AuthenticateRequestType',
            );
        final timeout = D4.getOptionalNamedArg<int?>(named, 'timeout');
        final userVerification = D4.getOptionalNamedArg<String?>(
          named,
          'userVerification',
        );
        final allowCredentials = D4
            .coerceListOrNull<$passkeys_platform_interface_6.CredentialType>(
              named['allowCredentials'],
              'allowCredentials',
            );
        final prf = D4.getOptionalNamedArg<String?>(named, 'prf');
        final canBeSecurityKey = D4.getNamedArgWithDefault<bool>(
          named,
          'canBeSecurityKey',
          true,
        );
        return $passkeys_platform_interface_2.AuthenticateRequestType(
          relyingPartyId: relyingPartyId,
          challenge: challenge,
          mediation: mediation,
          preferImmediatelyAvailableCredentials:
              preferImmediatelyAvailableCredentials,
          timeout: timeout,
          userVerification: userVerification,
          allowCredentials: allowCredentials,
          prf: prf,
          canBeSecurityKey: canBeSecurityKey,
        );
      },
      'fromJsonString': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AuthenticateRequestType');
        final jsonString = D4.getRequiredArg<String>(
          positional,
          0,
          'jsonString',
          'AuthenticateRequestType',
        );
        final preferImmediatelyAvailableCredentials = D4
            .getNamedArgWithDefault<bool>(
              named,
              'preferImmediatelyAvailableCredentials',
              true,
            );
        final canBeSecurityKey = D4.getNamedArgWithDefault<bool>(
          named,
          'canBeSecurityKey',
          true,
        );
        if (!named.containsKey('mediation')) {
          return $passkeys_platform_interface_2
              .AuthenticateRequestType.fromJsonString(
            jsonString,
            preferImmediatelyAvailableCredentials:
                preferImmediatelyAvailableCredentials,
            canBeSecurityKey: canBeSecurityKey,
          );
        }
        if (named.containsKey('mediation')) {
          final mediation = D4
              .getRequiredNamedArg<
                $passkeys_platform_interface_7.MediationType
              >(named, 'mediation', 'AuthenticateRequestType');
          return $passkeys_platform_interface_2
              .AuthenticateRequestType.fromJsonString(
            jsonString,
            preferImmediatelyAvailableCredentials:
                preferImmediatelyAvailableCredentials,
            canBeSecurityKey: canBeSecurityKey,
            mediation: mediation,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AuthenticateRequestType');
        if (positional.isEmpty) {
          throw ArgumentError(
            'AuthenticateRequestType: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        final preferImmediatelyAvailableCredentials = D4
            .getNamedArgWithDefault<bool>(
              named,
              'preferImmediatelyAvailableCredentials',
              true,
            );
        final canBeSecurityKey = D4.getNamedArgWithDefault<bool>(
          named,
          'canBeSecurityKey',
          true,
        );
        if (!named.containsKey('mediation')) {
          return $passkeys_platform_interface_2
              .AuthenticateRequestType.fromJson(
            json,
            preferImmediatelyAvailableCredentials:
                preferImmediatelyAvailableCredentials,
            canBeSecurityKey: canBeSecurityKey,
          );
        }
        if (named.containsKey('mediation')) {
          final mediation = D4
              .getRequiredNamedArg<
                $passkeys_platform_interface_7.MediationType
              >(named, 'mediation', 'AuthenticateRequestType');
          return $passkeys_platform_interface_2
              .AuthenticateRequestType.fromJson(
            json,
            preferImmediatelyAvailableCredentials:
                preferImmediatelyAvailableCredentials,
            canBeSecurityKey: canBeSecurityKey,
            mediation: mediation,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
    },
    getters: {
      'relyingPartyId': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_2.AuthenticateRequestType
          >(target, 'AuthenticateRequestType')
          .relyingPartyId,
      'challenge': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_2.AuthenticateRequestType
          >(target, 'AuthenticateRequestType')
          .challenge,
      'timeout': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_2.AuthenticateRequestType
          >(target, 'AuthenticateRequestType')
          .timeout,
      'userVerification': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_2.AuthenticateRequestType
          >(target, 'AuthenticateRequestType')
          .userVerification,
      'allowCredentials': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_2.AuthenticateRequestType
          >(target, 'AuthenticateRequestType')
          .allowCredentials,
      'mediation': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_2.AuthenticateRequestType
          >(target, 'AuthenticateRequestType')
          .mediation,
      'preferImmediatelyAvailableCredentials': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_2.AuthenticateRequestType
          >(target, 'AuthenticateRequestType')
          .preferImmediatelyAvailableCredentials,
      'prf': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_2.AuthenticateRequestType
          >(target, 'AuthenticateRequestType')
          .prf,
      'canBeSecurityKey': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_2.AuthenticateRequestType
          >(target, 'AuthenticateRequestType')
          .canBeSecurityKey,
    },
    methods: {
      'toJsonString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_2.AuthenticateRequestType
            >(target, 'AuthenticateRequestType');
        return t.toJsonString();
      },
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_2.AuthenticateRequestType
            >(target, 'AuthenticateRequestType');
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const AuthenticateRequestType({required String relyingPartyId, required String challenge, required MediationType mediation, required bool preferImmediatelyAvailableCredentials, int? timeout, String? userVerification, List<CredentialType>? allowCredentials, String? prf, bool canBeSecurityKey = true})',
      'fromJsonString':
          'factory AuthenticateRequestType.fromJsonString(String jsonString, {MediationType mediation = MediationType.Optional, bool preferImmediatelyAvailableCredentials = true, bool canBeSecurityKey = true})',
      'fromJson':
          'factory AuthenticateRequestType.fromJson(Map<String, dynamic> json, {MediationType mediation = MediationType.Optional, bool preferImmediatelyAvailableCredentials = true, bool canBeSecurityKey = true})',
    },
    methodSignatures: {
      'toJsonString': 'String toJsonString()',
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'relyingPartyId': 'String get relyingPartyId',
      'challenge': 'String get challenge',
      'timeout': 'int? get timeout',
      'userVerification': 'String? get userVerification',
      'allowCredentials': 'List<CredentialType>? get allowCredentials',
      'mediation': 'MediationType get mediation',
      'preferImmediatelyAvailableCredentials':
          'bool get preferImmediatelyAvailableCredentials',
      'prf': 'String? get prf',
      'canBeSecurityKey': 'bool get canBeSecurityKey',
    },
  );
}

// =============================================================================
// AuthenticateResponseType Bridge
// =============================================================================

BridgedClass _createAuthenticateResponseTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_3.AuthenticateResponseType,
    name: 'AuthenticateResponseType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_3.AuthenticateResponseType,
    constructors: {
      '': (visitor, positional, named) {
        final id = D4.getRequiredNamedArg<String>(
          named,
          'id',
          'AuthenticateResponseType',
        );
        final rawId = D4.getRequiredNamedArg<String>(
          named,
          'rawId',
          'AuthenticateResponseType',
        );
        final clientDataJSON = D4.getRequiredNamedArg<String>(
          named,
          'clientDataJSON',
          'AuthenticateResponseType',
        );
        final authenticatorData = D4.getRequiredNamedArg<String>(
          named,
          'authenticatorData',
          'AuthenticateResponseType',
        );
        final signature = D4.getRequiredNamedArg<String>(
          named,
          'signature',
          'AuthenticateResponseType',
        );
        final userHandle = D4.getRequiredNamedArg<String>(
          named,
          'userHandle',
          'AuthenticateResponseType',
        );
        final clientExtensionResults = D4.coerceMapOrNull<String?, Object?>(
          named['clientExtensionResults'],
          'clientExtensionResults',
        );
        return $passkeys_platform_interface_3.AuthenticateResponseType(
          id: id,
          rawId: rawId,
          clientDataJSON: clientDataJSON,
          authenticatorData: authenticatorData,
          signature: signature,
          userHandle: userHandle,
          clientExtensionResults: clientExtensionResults,
        );
      },
      'fromJsonString': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AuthenticateResponseType');
        final jsonString = D4.getRequiredArg<String>(
          positional,
          0,
          'jsonString',
          'AuthenticateResponseType',
        );
        return $passkeys_platform_interface_3
            .AuthenticateResponseType.fromJsonString(jsonString);
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AuthenticateResponseType');
        if (positional.isEmpty) {
          throw ArgumentError(
            'AuthenticateResponseType: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        return $passkeys_platform_interface_3.AuthenticateResponseType.fromJson(
          json,
        );
      },
    },
    getters: {
      'id': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_3.AuthenticateResponseType
          >(target, 'AuthenticateResponseType')
          .id,
      'rawId': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_3.AuthenticateResponseType
          >(target, 'AuthenticateResponseType')
          .rawId,
      'clientDataJSON': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_3.AuthenticateResponseType
          >(target, 'AuthenticateResponseType')
          .clientDataJSON,
      'authenticatorData': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_3.AuthenticateResponseType
          >(target, 'AuthenticateResponseType')
          .authenticatorData,
      'signature': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_3.AuthenticateResponseType
          >(target, 'AuthenticateResponseType')
          .signature,
      'userHandle': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_3.AuthenticateResponseType
          >(target, 'AuthenticateResponseType')
          .userHandle,
      'clientExtensionResults': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_3.AuthenticateResponseType
          >(target, 'AuthenticateResponseType')
          .clientExtensionResults,
    },
    methods: {
      'toJsonString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_3.AuthenticateResponseType
            >(target, 'AuthenticateResponseType');
        return t.toJsonString();
      },
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_3.AuthenticateResponseType
            >(target, 'AuthenticateResponseType');
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const AuthenticateResponseType({required String id, required String rawId, required String clientDataJSON, required String authenticatorData, required String signature, required String userHandle, Map<String?, Object?>? clientExtensionResults})',
      'fromJsonString':
          'factory AuthenticateResponseType.fromJsonString(String jsonString)',
      'fromJson':
          'factory AuthenticateResponseType.fromJson(Map<String, dynamic> json)',
    },
    methodSignatures: {
      'toJsonString': 'String toJsonString()',
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'id': 'String get id',
      'rawId': 'String get rawId',
      'clientDataJSON': 'String get clientDataJSON',
      'authenticatorData': 'String get authenticatorData',
      'signature': 'String get signature',
      'userHandle': 'String get userHandle',
      'clientExtensionResults':
          'Map<String?, Object?>? get clientExtensionResults',
    },
  );
}

// =============================================================================
// AuthenticatorSelectionType Bridge
// =============================================================================

BridgedClass _createAuthenticatorSelectionTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_4.AuthenticatorSelectionType,
    name: 'AuthenticatorSelectionType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_4.AuthenticatorSelectionType,
    constructors: {
      '': (visitor, positional, named) {
        final requireResidentKey = D4.getRequiredNamedArg<bool>(
          named,
          'requireResidentKey',
          'AuthenticatorSelectionType',
        );
        final residentKey = D4.getRequiredNamedArg<String>(
          named,
          'residentKey',
          'AuthenticatorSelectionType',
        );
        final userVerification = D4.getRequiredNamedArg<String>(
          named,
          'userVerification',
          'AuthenticatorSelectionType',
        );
        final authenticatorAttachment = D4.getOptionalNamedArg<String?>(
          named,
          'authenticatorAttachment',
        );
        return $passkeys_platform_interface_4.AuthenticatorSelectionType(
          requireResidentKey: requireResidentKey,
          residentKey: residentKey,
          userVerification: userVerification,
          authenticatorAttachment: authenticatorAttachment,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AuthenticatorSelectionType');
        if (positional.isEmpty) {
          throw ArgumentError(
            'AuthenticatorSelectionType: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        return $passkeys_platform_interface_4
            .AuthenticatorSelectionType.fromJson(json);
      },
    },
    getters: {
      'authenticatorAttachment': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_4.AuthenticatorSelectionType
          >(target, 'AuthenticatorSelectionType')
          .authenticatorAttachment,
      'requireResidentKey': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_4.AuthenticatorSelectionType
          >(target, 'AuthenticatorSelectionType')
          .requireResidentKey,
      'residentKey': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_4.AuthenticatorSelectionType
          >(target, 'AuthenticatorSelectionType')
          .residentKey,
      'userVerification': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_4.AuthenticatorSelectionType
          >(target, 'AuthenticatorSelectionType')
          .userVerification,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_4.AuthenticatorSelectionType
            >(target, 'AuthenticatorSelectionType');
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'AuthenticatorSelectionType({required bool requireResidentKey, required String residentKey, required String userVerification, String? authenticatorAttachment})',
      'fromJson':
          'factory AuthenticatorSelectionType.fromJson(Map<String, dynamic> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'authenticatorAttachment': 'String? get authenticatorAttachment',
      'requireResidentKey': 'bool get requireResidentKey',
      'residentKey': 'String get residentKey',
      'userVerification': 'String get userVerification',
    },
  );
}

// =============================================================================
// AvailabilityType Bridge
// =============================================================================

BridgedClass _createAvailabilityTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_5.AvailabilityType,
    name: 'AvailabilityType',
    isAssignable: (v) => v is $passkeys_platform_interface_5.AvailabilityType,
    constructors: {},
    getters: {
      'hasPasskeySupport': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_5.AvailabilityType>(
            target,
            'AvailabilityType',
          )
          .hasPasskeySupport,
      'isNative': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_5.AvailabilityType>(
            target,
            'AvailabilityType',
          )
          .isNative,
    },
    getterSignatures: {
      'hasPasskeySupport': 'bool get hasPasskeySupport',
      'isNative': 'bool get isNative',
    },
  );
}

// =============================================================================
// AvailabilityTypeWeb Bridge
// =============================================================================

BridgedClass _createAvailabilityTypeWebBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_5.AvailabilityTypeWeb,
    name: 'AvailabilityTypeWeb',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_5.AvailabilityTypeWeb,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final hasPasskeySupport = D4.getRequiredNamedArg<bool>(
          named,
          'hasPasskeySupport',
          'AvailabilityTypeWeb',
        );
        final isNative = D4.getRequiredNamedArg<bool>(
          named,
          'isNative',
          'AvailabilityTypeWeb',
        );
        final isUserVerifyingPlatformAuthenticatorAvailable = D4
            .getRequiredNamedArg<bool?>(
              named,
              'isUserVerifyingPlatformAuthenticatorAvailable',
              'AvailabilityTypeWeb',
            );
        final isConditionalMediationAvailable = D4.getRequiredNamedArg<bool?>(
          named,
          'isConditionalMediationAvailable',
          'AvailabilityTypeWeb',
        );
        return $passkeys_platform_interface_5.AvailabilityTypeWeb(
          hasPasskeySupport: hasPasskeySupport,
          isNative: isNative,
          isUserVerifyingPlatformAuthenticatorAvailable:
              isUserVerifyingPlatformAuthenticatorAvailable,
          isConditionalMediationAvailable: isConditionalMediationAvailable,
        );
      },
    },
    getters: {
      'hasPasskeySupport': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_5.AvailabilityTypeWeb>(
            target,
            'AvailabilityTypeWeb',
          )
          .hasPasskeySupport,
      'isNative': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_5.AvailabilityTypeWeb>(
            target,
            'AvailabilityTypeWeb',
          )
          .isNative,
      'isUserVerifyingPlatformAuthenticatorAvailable': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_5.AvailabilityTypeWeb>(
            target,
            'AvailabilityTypeWeb',
          )
          .isUserVerifyingPlatformAuthenticatorAvailable,
      'isConditionalMediationAvailable': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_5.AvailabilityTypeWeb>(
            target,
            'AvailabilityTypeWeb',
          )
          .isConditionalMediationAvailable,
    },
    constructorSignatures: {
      '': 'AvailabilityTypeWeb({required bool hasPasskeySupport, required bool isNative, required bool? isUserVerifyingPlatformAuthenticatorAvailable, required bool? isConditionalMediationAvailable})',
    },
    getterSignatures: {
      'hasPasskeySupport': 'bool get hasPasskeySupport',
      'isNative': 'bool get isNative',
      'isUserVerifyingPlatformAuthenticatorAvailable':
          'bool? get isUserVerifyingPlatformAuthenticatorAvailable',
      'isConditionalMediationAvailable':
          'bool? get isConditionalMediationAvailable',
    },
  );
}

// =============================================================================
// AvailabilityTypeAndroid Bridge
// =============================================================================

BridgedClass _createAvailabilityTypeAndroidBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_5.AvailabilityTypeAndroid,
    name: 'AvailabilityTypeAndroid',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_5.AvailabilityTypeAndroid,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final hasPasskeySupport = D4.getRequiredNamedArg<bool>(
          named,
          'hasPasskeySupport',
          'AvailabilityTypeAndroid',
        );
        final isNative = D4.getRequiredNamedArg<bool>(
          named,
          'isNative',
          'AvailabilityTypeAndroid',
        );
        final isUserVerifyingPlatformAuthenticatorAvailable = D4
            .getRequiredNamedArg<bool?>(
              named,
              'isUserVerifyingPlatformAuthenticatorAvailable',
              'AvailabilityTypeAndroid',
            );
        return $passkeys_platform_interface_5.AvailabilityTypeAndroid(
          hasPasskeySupport: hasPasskeySupport,
          isNative: isNative,
          isUserVerifyingPlatformAuthenticatorAvailable:
              isUserVerifyingPlatformAuthenticatorAvailable,
        );
      },
    },
    getters: {
      'hasPasskeySupport': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_5.AvailabilityTypeAndroid
          >(target, 'AvailabilityTypeAndroid')
          .hasPasskeySupport,
      'isNative': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_5.AvailabilityTypeAndroid
          >(target, 'AvailabilityTypeAndroid')
          .isNative,
      'isUserVerifyingPlatformAuthenticatorAvailable': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_5.AvailabilityTypeAndroid
          >(target, 'AvailabilityTypeAndroid')
          .isUserVerifyingPlatformAuthenticatorAvailable,
    },
    constructorSignatures: {
      '': 'AvailabilityTypeAndroid({required bool hasPasskeySupport, required bool isNative, required bool? isUserVerifyingPlatformAuthenticatorAvailable})',
    },
    getterSignatures: {
      'hasPasskeySupport': 'bool get hasPasskeySupport',
      'isNative': 'bool get isNative',
      'isUserVerifyingPlatformAuthenticatorAvailable':
          'bool? get isUserVerifyingPlatformAuthenticatorAvailable',
    },
  );
}

// =============================================================================
// AvailabilityTypeIOS Bridge
// =============================================================================

BridgedClass _createAvailabilityTypeIOSBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_5.AvailabilityTypeIOS,
    name: 'AvailabilityTypeIOS',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_5.AvailabilityTypeIOS,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final hasPasskeySupport = D4.getRequiredNamedArg<bool>(
          named,
          'hasPasskeySupport',
          'AvailabilityTypeIOS',
        );
        final isNative = D4.getRequiredNamedArg<bool>(
          named,
          'isNative',
          'AvailabilityTypeIOS',
        );
        final hasBiometrics = D4.getRequiredNamedArg<bool>(
          named,
          'hasBiometrics',
          'AvailabilityTypeIOS',
        );
        return $passkeys_platform_interface_5.AvailabilityTypeIOS(
          hasPasskeySupport: hasPasskeySupport,
          isNative: isNative,
          hasBiometrics: hasBiometrics,
        );
      },
    },
    getters: {
      'hasPasskeySupport': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_5.AvailabilityTypeIOS>(
            target,
            'AvailabilityTypeIOS',
          )
          .hasPasskeySupport,
      'isNative': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_5.AvailabilityTypeIOS>(
            target,
            'AvailabilityTypeIOS',
          )
          .isNative,
      'hasBiometrics': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_5.AvailabilityTypeIOS>(
            target,
            'AvailabilityTypeIOS',
          )
          .hasBiometrics,
    },
    constructorSignatures: {
      '': 'AvailabilityTypeIOS({required bool hasPasskeySupport, required bool isNative, required bool hasBiometrics})',
    },
    getterSignatures: {
      'hasPasskeySupport': 'bool get hasPasskeySupport',
      'isNative': 'bool get isNative',
      'hasBiometrics': 'bool get hasBiometrics',
    },
  );
}

// =============================================================================
// AvailabilityTypeWindows Bridge
// =============================================================================

BridgedClass _createAvailabilityTypeWindowsBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_5.AvailabilityTypeWindows,
    name: 'AvailabilityTypeWindows',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_5.AvailabilityTypeWindows,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final hasPasskeySupport = D4.getRequiredNamedArg<bool>(
          named,
          'hasPasskeySupport',
          'AvailabilityTypeWindows',
        );
        final isNative = D4.getRequiredNamedArg<bool>(
          named,
          'isNative',
          'AvailabilityTypeWindows',
        );
        final isUserVerifyingPlatformAuthenticatorAvailable = D4
            .getRequiredNamedArg<bool>(
              named,
              'isUserVerifyingPlatformAuthenticatorAvailable',
              'AvailabilityTypeWindows',
            );
        return $passkeys_platform_interface_5.AvailabilityTypeWindows(
          hasPasskeySupport: hasPasskeySupport,
          isNative: isNative,
          isUserVerifyingPlatformAuthenticatorAvailable:
              isUserVerifyingPlatformAuthenticatorAvailable,
        );
      },
    },
    getters: {
      'hasPasskeySupport': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_5.AvailabilityTypeWindows
          >(target, 'AvailabilityTypeWindows')
          .hasPasskeySupport,
      'isNative': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_5.AvailabilityTypeWindows
          >(target, 'AvailabilityTypeWindows')
          .isNative,
      'isUserVerifyingPlatformAuthenticatorAvailable': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_5.AvailabilityTypeWindows
          >(target, 'AvailabilityTypeWindows')
          .isUserVerifyingPlatformAuthenticatorAvailable,
    },
    constructorSignatures: {
      '': 'AvailabilityTypeWindows({required bool hasPasskeySupport, required bool isNative, required bool isUserVerifyingPlatformAuthenticatorAvailable})',
    },
    getterSignatures: {
      'hasPasskeySupport': 'bool get hasPasskeySupport',
      'isNative': 'bool get isNative',
      'isUserVerifyingPlatformAuthenticatorAvailable':
          'bool get isUserVerifyingPlatformAuthenticatorAvailable',
    },
  );
}

// =============================================================================
// PasswordCredentialType Bridge
// =============================================================================

BridgedClass _createPasswordCredentialTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_8.PasswordCredentialType,
    name: 'PasswordCredentialType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_8.PasswordCredentialType,
    constructors: {
      '': (visitor, positional, named) {
        final username = D4.getRequiredNamedArg<String>(
          named,
          'username',
          'PasswordCredentialType',
        );
        final password = D4.getRequiredNamedArg<String>(
          named,
          'password',
          'PasswordCredentialType',
        );
        return $passkeys_platform_interface_8.PasswordCredentialType(
          username: username,
          password: password,
        );
      },
    },
    getters: {
      'username': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_8.PasswordCredentialType
          >(target, 'PasswordCredentialType')
          .username,
      'password': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_8.PasswordCredentialType
          >(target, 'PasswordCredentialType')
          .password,
    },
    constructorSignatures: {
      '': 'const PasswordCredentialType({required String username, required String password})',
    },
    getterSignatures: {
      'username': 'String get username',
      'password': 'String get password',
    },
  );
}

// =============================================================================
// PasswordOrPasskeyResponseType Bridge
// =============================================================================

BridgedClass _createPasswordOrPasskeyResponseTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_8.PasswordOrPasskeyResponseType,
    name: 'PasswordOrPasskeyResponseType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_8.PasswordOrPasskeyResponseType,
    constructors: {
      'password': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'PasswordOrPasskeyResponseType');
        final password = D4
            .getRequiredArg<
              $passkeys_platform_interface_8.PasswordCredentialType
            >(positional, 0, 'password', 'PasswordOrPasskeyResponseType');
        return $passkeys_platform_interface_8
            .PasswordOrPasskeyResponseType.password(password);
      },
      'passkey': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'PasswordOrPasskeyResponseType');
        final passkey = D4
            .getRequiredArg<
              $passkeys_platform_interface_3.AuthenticateResponseType
            >(positional, 0, 'passkey', 'PasswordOrPasskeyResponseType');
        return $passkeys_platform_interface_8
            .PasswordOrPasskeyResponseType.passkey(passkey);
      },
    },
    getters: {
      'password': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_8.PasswordOrPasskeyResponseType
          >(target, 'PasswordOrPasskeyResponseType')
          .password,
      'passkey': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_8.PasswordOrPasskeyResponseType
          >(target, 'PasswordOrPasskeyResponseType')
          .passkey,
    },
    constructorSignatures: {
      'password':
          'const PasswordOrPasskeyResponseType.password(PasswordCredentialType password)',
      'passkey':
          'const PasswordOrPasskeyResponseType.passkey(AuthenticateResponseType passkey)',
    },
    getterSignatures: {
      'password': 'PasswordCredentialType? get password',
      'passkey': 'AuthenticateResponseType? get passkey',
    },
  );
}

// =============================================================================
// RegisterRequestType Bridge
// =============================================================================

BridgedClass _createRegisterRequestTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_10.RegisterRequestType,
    name: 'RegisterRequestType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_10.RegisterRequestType,
    constructors: {
      '': (visitor, positional, named) {
        final challenge = D4.getRequiredNamedArg<String>(
          named,
          'challenge',
          'RegisterRequestType',
        );
        final relyingParty = D4
            .getRequiredNamedArg<
              $passkeys_platform_interface_12.RelyingPartyType
            >(named, 'relyingParty', 'RegisterRequestType');
        final user = D4
            .getRequiredNamedArg<$passkeys_platform_interface_14.UserType>(
              named,
              'user',
              'RegisterRequestType',
            );
        if (!named.containsKey('excludeCredentials') ||
            named['excludeCredentials'] == null) {
          throw ArgumentError(
            'RegisterRequestType: Missing required named argument "excludeCredentials"',
          );
        }
        final excludeCredentials = D4
            .coerceList<$passkeys_platform_interface_6.CredentialType>(
              named['excludeCredentials'],
              'excludeCredentials',
            );
        final authSelectionType = D4
            .getOptionalNamedArg<
              $passkeys_platform_interface_4.AuthenticatorSelectionType?
            >(named, 'authSelectionType');
        final pubKeyCredParams = D4
            .coerceListOrNull<
              $passkeys_platform_interface_9.PubKeyCredParamType
            >(named['pubKeyCredParams'], 'pubKeyCredParams');
        final timeout = D4.getOptionalNamedArg<int?>(named, 'timeout');
        final attestation = D4.getOptionalNamedArg<String?>(
          named,
          'attestation',
        );
        final prf = D4.getOptionalNamedArg<String?>(named, 'prf');
        if (!named.containsKey('mediation')) {
          return $passkeys_platform_interface_10.RegisterRequestType(
            challenge: challenge,
            relyingParty: relyingParty,
            user: user,
            excludeCredentials: excludeCredentials,
            authSelectionType: authSelectionType,
            pubKeyCredParams: pubKeyCredParams,
            timeout: timeout,
            attestation: attestation,
            prf: prf,
          );
        }
        if (named.containsKey('mediation')) {
          final mediation = D4
              .getRequiredNamedArg<
                $passkeys_platform_interface_7.MediationType
              >(named, 'mediation', 'RegisterRequestType');
          return $passkeys_platform_interface_10.RegisterRequestType(
            challenge: challenge,
            relyingParty: relyingParty,
            user: user,
            excludeCredentials: excludeCredentials,
            authSelectionType: authSelectionType,
            pubKeyCredParams: pubKeyCredParams,
            timeout: timeout,
            attestation: attestation,
            prf: prf,
            mediation: mediation,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'fromJsonString': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'RegisterRequestType');
        final jsonString = D4.getRequiredArg<String>(
          positional,
          0,
          'jsonString',
          'RegisterRequestType',
        );
        if (!named.containsKey('mediation')) {
          return $passkeys_platform_interface_10
              .RegisterRequestType.fromJsonString(jsonString);
        }
        if (named.containsKey('mediation')) {
          final mediation = D4
              .getRequiredNamedArg<
                $passkeys_platform_interface_7.MediationType
              >(named, 'mediation', 'RegisterRequestType');
          return $passkeys_platform_interface_10
              .RegisterRequestType.fromJsonString(
            jsonString,
            mediation: mediation,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'RegisterRequestType');
        if (positional.isEmpty) {
          throw ArgumentError(
            'RegisterRequestType: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        if (!named.containsKey('mediation')) {
          return $passkeys_platform_interface_10.RegisterRequestType.fromJson(
            json,
          );
        }
        if (named.containsKey('mediation')) {
          final mediation = D4
              .getRequiredNamedArg<
                $passkeys_platform_interface_7.MediationType
              >(named, 'mediation', 'RegisterRequestType');
          return $passkeys_platform_interface_10.RegisterRequestType.fromJson(
            json,
            mediation: mediation,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
    },
    getters: {
      'challenge': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .challenge,
      'relyingParty': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .relyingParty,
      'user': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .user,
      'authSelectionType': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .authSelectionType,
      'pubKeyCredParams': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .pubKeyCredParams,
      'excludeCredentials': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .excludeCredentials,
      'timeout': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .timeout,
      'attestation': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .attestation,
      'prf': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .prf,
      'mediation': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .mediation,
      'isConditional': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_10.RegisterRequestType>(
            target,
            'RegisterRequestType',
          )
          .isConditional,
    },
    methods: {
      'toJsonString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_10.RegisterRequestType
            >(target, 'RegisterRequestType');
        return t.toJsonString();
      },
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_10.RegisterRequestType
            >(target, 'RegisterRequestType');
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const RegisterRequestType({required String challenge, required RelyingPartyType relyingParty, required UserType user, required List<CredentialType> excludeCredentials, AuthenticatorSelectionType? authSelectionType, List<PubKeyCredParamType>? pubKeyCredParams, int? timeout, String? attestation, String? prf, MediationType mediation = MediationType.Optional})',
      'fromJsonString':
          'factory RegisterRequestType.fromJsonString(String jsonString, {MediationType mediation = MediationType.Optional})',
      'fromJson':
          'factory RegisterRequestType.fromJson(Map<String, dynamic> json, {MediationType mediation = MediationType.Optional})',
    },
    methodSignatures: {
      'toJsonString': 'String toJsonString()',
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'challenge': 'String get challenge',
      'relyingParty': 'RelyingPartyType get relyingParty',
      'user': 'UserType get user',
      'authSelectionType': 'AuthenticatorSelectionType? get authSelectionType',
      'pubKeyCredParams': 'List<PubKeyCredParamType>? get pubKeyCredParams',
      'excludeCredentials': 'List<CredentialType> get excludeCredentials',
      'timeout': 'int? get timeout',
      'attestation': 'String? get attestation',
      'prf': 'String? get prf',
      'mediation': 'MediationType get mediation',
      'isConditional': 'bool get isConditional',
    },
  );
}

// =============================================================================
// RegisterResponseType Bridge
// =============================================================================

BridgedClass _createRegisterResponseTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_11.RegisterResponseType,
    name: 'RegisterResponseType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_11.RegisterResponseType,
    constructors: {
      '': (visitor, positional, named) {
        final id = D4.getRequiredNamedArg<String>(
          named,
          'id',
          'RegisterResponseType',
        );
        final rawId = D4.getRequiredNamedArg<String>(
          named,
          'rawId',
          'RegisterResponseType',
        );
        final clientDataJSON = D4.getRequiredNamedArg<String>(
          named,
          'clientDataJSON',
          'RegisterResponseType',
        );
        final attestationObject = D4.getRequiredNamedArg<String>(
          named,
          'attestationObject',
          'RegisterResponseType',
        );
        if (!named.containsKey('transports') || named['transports'] == null) {
          throw ArgumentError(
            'RegisterResponseType: Missing required named argument "transports"',
          );
        }
        final transports = D4.coerceList<String?>(
          named['transports'],
          'transports',
        );
        final clientExtensionResults = D4.coerceMapOrNull<String?, Object?>(
          named['clientExtensionResults'],
          'clientExtensionResults',
        );
        return $passkeys_platform_interface_11.RegisterResponseType(
          id: id,
          rawId: rawId,
          clientDataJSON: clientDataJSON,
          attestationObject: attestationObject,
          transports: transports,
          clientExtensionResults: clientExtensionResults,
        );
      },
      'fromJsonString': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'RegisterResponseType');
        final jsonString = D4.getRequiredArg<String>(
          positional,
          0,
          'jsonString',
          'RegisterResponseType',
        );
        return $passkeys_platform_interface_11
            .RegisterResponseType.fromJsonString(jsonString);
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'RegisterResponseType');
        if (positional.isEmpty) {
          throw ArgumentError(
            'RegisterResponseType: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        return $passkeys_platform_interface_11.RegisterResponseType.fromJson(
          json,
        );
      },
    },
    getters: {
      'id': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_11.RegisterResponseType>(
            target,
            'RegisterResponseType',
          )
          .id,
      'rawId': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_11.RegisterResponseType>(
            target,
            'RegisterResponseType',
          )
          .rawId,
      'clientDataJSON': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_11.RegisterResponseType>(
            target,
            'RegisterResponseType',
          )
          .clientDataJSON,
      'attestationObject': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_11.RegisterResponseType>(
            target,
            'RegisterResponseType',
          )
          .attestationObject,
      'transports': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_11.RegisterResponseType>(
            target,
            'RegisterResponseType',
          )
          .transports,
      'clientExtensionResults': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_11.RegisterResponseType>(
            target,
            'RegisterResponseType',
          )
          .clientExtensionResults,
    },
    methods: {
      'toJsonString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_11.RegisterResponseType
            >(target, 'RegisterResponseType');
        return t.toJsonString();
      },
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $passkeys_platform_interface_11.RegisterResponseType
            >(target, 'RegisterResponseType');
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const RegisterResponseType({required String id, required String rawId, required String clientDataJSON, required String attestationObject, required List<String?> transports, Map<String?, Object?>? clientExtensionResults})',
      'fromJsonString':
          'factory RegisterResponseType.fromJsonString(String jsonString)',
      'fromJson':
          'factory RegisterResponseType.fromJson(Map<String, dynamic> json)',
    },
    methodSignatures: {
      'toJsonString': 'String toJsonString()',
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'id': 'String get id',
      'rawId': 'String get rawId',
      'clientDataJSON': 'String get clientDataJSON',
      'attestationObject': 'String get attestationObject',
      'transports': 'List<String?> get transports',
      'clientExtensionResults':
          'Map<String?, Object?>? get clientExtensionResults',
    },
  );
}

// =============================================================================
// RelyingPartyType Bridge
// =============================================================================

BridgedClass _createRelyingPartyTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_12.RelyingPartyType,
    name: 'RelyingPartyType',
    isAssignable: (v) => v is $passkeys_platform_interface_12.RelyingPartyType,
    constructors: {
      '': (visitor, positional, named) {
        final name = D4.getRequiredNamedArg<String>(
          named,
          'name',
          'RelyingPartyType',
        );
        final id = D4.getRequiredNamedArg<String>(
          named,
          'id',
          'RelyingPartyType',
        );
        return $passkeys_platform_interface_12.RelyingPartyType(
          name: name,
          id: id,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'RelyingPartyType');
        if (positional.isEmpty) {
          throw ArgumentError(
            'RelyingPartyType: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        return $passkeys_platform_interface_12.RelyingPartyType.fromJson(json);
      },
    },
    getters: {
      'name': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_12.RelyingPartyType>(
            target,
            'RelyingPartyType',
          )
          .name,
      'id': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_12.RelyingPartyType>(
            target,
            'RelyingPartyType',
          )
          .id,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$passkeys_platform_interface_12.RelyingPartyType>(
              target,
              'RelyingPartyType',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'RelyingPartyType({required String name, required String id})',
      'fromJson':
          'factory RelyingPartyType.fromJson(Map<String, dynamic> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'name': 'String get name',
      'id': 'String get id',
    },
  );
}

// =============================================================================
// SignalUnknownCredentialRequestType Bridge
// =============================================================================

BridgedClass _createSignalUnknownCredentialRequestTypeBridge() {
  return BridgedClass(
    nativeType:
        $passkeys_platform_interface_13.SignalUnknownCredentialRequestType,
    name: 'SignalUnknownCredentialRequestType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_13.SignalUnknownCredentialRequestType,
    constructors: {
      '': (visitor, positional, named) {
        final relyingPartyId = D4.getRequiredNamedArg<String>(
          named,
          'relyingPartyId',
          'SignalUnknownCredentialRequestType',
        );
        final credentialId = D4.getRequiredNamedArg<String>(
          named,
          'credentialId',
          'SignalUnknownCredentialRequestType',
        );
        return $passkeys_platform_interface_13.SignalUnknownCredentialRequestType(
          relyingPartyId: relyingPartyId,
          credentialId: credentialId,
        );
      },
    },
    getters: {
      'relyingPartyId': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_13.SignalUnknownCredentialRequestType
          >(target, 'SignalUnknownCredentialRequestType')
          .relyingPartyId,
      'credentialId': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_13.SignalUnknownCredentialRequestType
          >(target, 'SignalUnknownCredentialRequestType')
          .credentialId,
    },
    constructorSignatures: {
      '': 'const SignalUnknownCredentialRequestType({required String relyingPartyId, required String credentialId})',
    },
    getterSignatures: {
      'relyingPartyId': 'String get relyingPartyId',
      'credentialId': 'String get credentialId',
    },
  );
}

// =============================================================================
// SignalAllAcceptedCredentialsRequestType Bridge
// =============================================================================

BridgedClass _createSignalAllAcceptedCredentialsRequestTypeBridge() {
  return BridgedClass(
    nativeType:
        $passkeys_platform_interface_13.SignalAllAcceptedCredentialsRequestType,
    name: 'SignalAllAcceptedCredentialsRequestType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_13.SignalAllAcceptedCredentialsRequestType,
    constructors: {
      '': (visitor, positional, named) {
        final relyingPartyId = D4.getRequiredNamedArg<String>(
          named,
          'relyingPartyId',
          'SignalAllAcceptedCredentialsRequestType',
        );
        final userId = D4.getRequiredNamedArg<String>(
          named,
          'userId',
          'SignalAllAcceptedCredentialsRequestType',
        );
        if (!named.containsKey('allAcceptedCredentialIds') ||
            named['allAcceptedCredentialIds'] == null) {
          throw ArgumentError(
            'SignalAllAcceptedCredentialsRequestType: Missing required named argument "allAcceptedCredentialIds"',
          );
        }
        final allAcceptedCredentialIds = D4.coerceList<String>(
          named['allAcceptedCredentialIds'],
          'allAcceptedCredentialIds',
        );
        return $passkeys_platform_interface_13.SignalAllAcceptedCredentialsRequestType(
          relyingPartyId: relyingPartyId,
          userId: userId,
          allAcceptedCredentialIds: allAcceptedCredentialIds,
        );
      },
    },
    getters: {
      'relyingPartyId': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_13.SignalAllAcceptedCredentialsRequestType
          >(target, 'SignalAllAcceptedCredentialsRequestType')
          .relyingPartyId,
      'userId': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_13.SignalAllAcceptedCredentialsRequestType
          >(target, 'SignalAllAcceptedCredentialsRequestType')
          .userId,
      'allAcceptedCredentialIds': (visitor, target) => D4
          .validateTarget<
            $passkeys_platform_interface_13.SignalAllAcceptedCredentialsRequestType
          >(target, 'SignalAllAcceptedCredentialsRequestType')
          .allAcceptedCredentialIds,
    },
    constructorSignatures: {
      '': 'const SignalAllAcceptedCredentialsRequestType({required String relyingPartyId, required String userId, required List<String> allAcceptedCredentialIds})',
    },
    getterSignatures: {
      'relyingPartyId': 'String get relyingPartyId',
      'userId': 'String get userId',
      'allAcceptedCredentialIds': 'List<String> get allAcceptedCredentialIds',
    },
  );
}

// =============================================================================
// UserType Bridge
// =============================================================================

BridgedClass _createUserTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_14.UserType,
    name: 'UserType',
    isAssignable: (v) => v is $passkeys_platform_interface_14.UserType,
    constructors: {
      '': (visitor, positional, named) {
        final displayName = D4.getRequiredNamedArg<String>(
          named,
          'displayName',
          'UserType',
        );
        final name = D4.getRequiredNamedArg<String>(named, 'name', 'UserType');
        final id = D4.getRequiredNamedArg<String>(named, 'id', 'UserType');
        return $passkeys_platform_interface_14.UserType(
          displayName: displayName,
          name: name,
          id: id,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'UserType');
        if (positional.isEmpty) {
          throw ArgumentError(
            'UserType: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        return $passkeys_platform_interface_14.UserType.fromJson(json);
      },
    },
    getters: {
      'displayName': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_14.UserType>(
            target,
            'UserType',
          )
          .displayName,
      'name': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_14.UserType>(
            target,
            'UserType',
          )
          .name,
      'id': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_14.UserType>(
            target,
            'UserType',
          )
          .id,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$passkeys_platform_interface_14.UserType>(
          target,
          'UserType',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const UserType({required String displayName, required String name, required String id})',
      'fromJson': 'factory UserType.fromJson(Map<String, dynamic> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'displayName': 'String get displayName',
      'name': 'String get name',
      'id': 'String get id',
    },
  );
}

// =============================================================================
// CredentialType Bridge
// =============================================================================

BridgedClass _createCredentialTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_6.CredentialType,
    name: 'CredentialType',
    isAssignable: (v) => v is $passkeys_platform_interface_6.CredentialType,
    constructors: {
      '': (visitor, positional, named) {
        final type = D4.getRequiredNamedArg<String>(
          named,
          'type',
          'CredentialType',
        );
        final id = D4.getRequiredNamedArg<String>(
          named,
          'id',
          'CredentialType',
        );
        if (!named.containsKey('transports') || named['transports'] == null) {
          throw ArgumentError(
            'CredentialType: Missing required named argument "transports"',
          );
        }
        final transports = D4.coerceList<String>(
          named['transports'],
          'transports',
        );
        return $passkeys_platform_interface_6.CredentialType(
          type: type,
          id: id,
          transports: transports,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'CredentialType');
        if (positional.isEmpty) {
          throw ArgumentError(
            'CredentialType: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        return $passkeys_platform_interface_6.CredentialType.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_6.CredentialType>(
            target,
            'CredentialType',
          )
          .type,
      'id': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_6.CredentialType>(
            target,
            'CredentialType',
          )
          .id,
      'transports': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_6.CredentialType>(
            target,
            'CredentialType',
          )
          .transports,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$passkeys_platform_interface_6.CredentialType>(
              target,
              'CredentialType',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'CredentialType({required String type, required String id, required List<String> transports})',
      'fromJson': 'factory CredentialType.fromJson(Map<String, dynamic> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'id': 'String get id',
      'transports': 'List<String> get transports',
    },
  );
}

// =============================================================================
// PubKeyCredParamType Bridge
// =============================================================================

BridgedClass _createPubKeyCredParamTypeBridge() {
  return BridgedClass(
    nativeType: $passkeys_platform_interface_9.PubKeyCredParamType,
    name: 'PubKeyCredParamType',
    isAssignable: (v) =>
        v is $passkeys_platform_interface_9.PubKeyCredParamType,
    constructors: {
      '': (visitor, positional, named) {
        final type = D4.getRequiredNamedArg<String>(
          named,
          'type',
          'PubKeyCredParamType',
        );
        final alg = D4.getRequiredNamedArg<int>(
          named,
          'alg',
          'PubKeyCredParamType',
        );
        return $passkeys_platform_interface_9.PubKeyCredParamType(
          type: type,
          alg: alg,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'PubKeyCredParamType');
        if (positional.isEmpty) {
          throw ArgumentError(
            'PubKeyCredParamType: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        return $passkeys_platform_interface_9.PubKeyCredParamType.fromJson(
          json,
        );
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_9.PubKeyCredParamType>(
            target,
            'PubKeyCredParamType',
          )
          .type,
      'alg': (visitor, target) => D4
          .validateTarget<$passkeys_platform_interface_9.PubKeyCredParamType>(
            target,
            'PubKeyCredParamType',
          )
          .alg,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$passkeys_platform_interface_9.PubKeyCredParamType>(
              target,
              'PubKeyCredParamType',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'PubKeyCredParamType({required String type, required int alg})',
      'fromJson':
          'factory PubKeyCredParamType.fromJson(Map<String, dynamic> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'alg': 'int get alg',
    },
  );
}

// =============================================================================
// PasskeyAuthenticator Bridge
// =============================================================================

BridgedClass _createPasskeyAuthenticatorBridge() {
  return BridgedClass(
    nativeType: $dartnative_passkeys_1.PasskeyAuthenticator,
    name: 'PasskeyAuthenticator',
    isAssignable: (v) => v is $dartnative_passkeys_1.PasskeyAuthenticator,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_passkeys_1.PasskeyAuthenticator();
      },
    },
    methods: {
      'createRestoreCredential':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<$dartnative_passkeys_1.PasskeyAuthenticator>(
                  target,
                  'PasskeyAuthenticator',
                );
            D4.requireMinArgs(positional, 1, 'createRestoreCredential');
            final request = D4
                .getRequiredArg<
                  $passkeys_platform_interface_10.RegisterRequestType
                >(positional, 0, 'request', 'createRestoreCredential');
            final isCloudBackupEnabled = D4.getNamedArgWithDefault<bool>(
              named,
              'isCloudBackupEnabled',
              true,
            );
            return t.createRestoreCredential(
              request,
              isCloudBackupEnabled: isCloudBackupEnabled,
            );
          },
      'getRestoreCredential': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_passkeys_1.PasskeyAuthenticator>(
              target,
              'PasskeyAuthenticator',
            );
        D4.requireMinArgs(positional, 1, 'getRestoreCredential');
        final request = D4
            .getRequiredArg<
              $passkeys_platform_interface_2.AuthenticateRequestType
            >(positional, 0, 'request', 'getRestoreCredential');
        return t.getRestoreCredential(request);
      },
      'clearRestoreCredential': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_passkeys_1.PasskeyAuthenticator>(
              target,
              'PasskeyAuthenticator',
            );
        return t.clearRestoreCredential();
      },
    },
    staticGetters: {
      'isSupported': (visitor) =>
          $dartnative_passkeys_1.PasskeyAuthenticator.isSupported,
    },
    constructorSignatures: {
      '': 'const PasskeyAuthenticator()',
    },
    methodSignatures: {
      'createRestoreCredential':
          'Future<RegisterResponseType> createRestoreCredential(RegisterRequestType request, {bool isCloudBackupEnabled = true})',
      'getRestoreCredential':
          'Future<AuthenticateResponseType> getRestoreCredential(AuthenticateRequestType request)',
      'clearRestoreCredential': 'Future<void> clearRestoreCredential()',
    },
    staticGetterSignatures: {
      'isSupported': 'bool get isSupported',
    },
  );
}

// =============================================================================
// PasskeyException Bridge
// =============================================================================

BridgedClass _createPasskeyExceptionBridge() {
  return BridgedClass(
    nativeType: $dartnative_passkeys_2.PasskeyException,
    name: 'PasskeyException',
    isAssignable: (v) => v is $dartnative_passkeys_2.PasskeyException,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final code = D4.getRequiredNamedArg<String>(
          named,
          'code',
          'PasskeyException',
        );
        final message = D4.getOptionalNamedArg<String?>(named, 'message');
        final details = D4.getOptionalNamedArg<Object?>(named, 'details');
        return $dartnative_passkeys_2.PasskeyException(
          code: code,
          message: message,
          details: details,
        );
      },
    },
    getters: {
      'code': (visitor, target) => D4
          .validateTarget<$dartnative_passkeys_2.PasskeyException>(
            target,
            'PasskeyException',
          )
          .code,
      'message': (visitor, target) => D4
          .validateTarget<$dartnative_passkeys_2.PasskeyException>(
            target,
            'PasskeyException',
          )
          .message,
      'details': (visitor, target) => D4
          .validateTarget<$dartnative_passkeys_2.PasskeyException>(
            target,
            'PasskeyException',
          )
          .details,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_passkeys_2.PasskeyException>(
          target,
          'PasskeyException',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const PasskeyException({required String code, String? message, Object? details})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'code': 'String get code',
      'message': 'String? get message',
      'details': 'Object? get details',
    },
  );
}

// =============================================================================
// PasskeysFFIBindings Bridge
// =============================================================================

BridgedClass _createPasskeysFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_passkeys_3.PasskeysFFIBindings,
    name: 'PasskeysFFIBindings',
    isAssignable: (v) => v is $dartnative_passkeys_3.PasskeysFFIBindings,
    constructors: {},
    staticGetters: {
      'isRestoreSupported': (visitor) =>
          $dartnative_passkeys_3.PasskeysFFIBindings.isRestoreSupported,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_passkeys_3.PasskeysFFIBindings.loadSymbols();
      },
      'createRestoreCredential': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'createRestoreCredential');
        final requestJson = D4.getRequiredArg<String>(
          positional,
          0,
          'requestJson',
          'createRestoreCredential',
        );
        final isCloudBackupEnabled = D4.getRequiredNamedArg<bool>(
          named,
          'isCloudBackupEnabled',
          'createRestoreCredential',
        );
        return $dartnative_passkeys_3
            .PasskeysFFIBindings.createRestoreCredential(
          requestJson,
          isCloudBackupEnabled: isCloudBackupEnabled,
        );
      },
      'getRestoreCredential': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'getRestoreCredential');
        final requestJson = D4.getRequiredArg<String>(
          positional,
          0,
          'requestJson',
          'getRestoreCredential',
        );
        return $dartnative_passkeys_3.PasskeysFFIBindings.getRestoreCredential(
          requestJson,
        );
      },
      'clearRestoreCredential': (visitor, positional, named, typeArgs) {
        return $dartnative_passkeys_3
            .PasskeysFFIBindings.clearRestoreCredential();
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'createRestoreCredential':
          'Future<String> createRestoreCredential(String requestJson, {required bool isCloudBackupEnabled})',
      'getRestoreCredential':
          'Future<String> getRestoreCredential(String requestJson)',
      'clearRestoreCredential': 'Future<void> clearRestoreCredential()',
    },
    staticGetterSignatures: {
      'isRestoreSupported': 'bool get isRestoreSupported',
    },
  );
}

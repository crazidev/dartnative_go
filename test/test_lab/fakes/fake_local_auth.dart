/// In-memory host fake for `local_auth_kit`.
///
/// Shadows `LocalAuthentication` with host state for headless testing without
/// native biometric engine calls.
library;

import 'package:local_auth_kit/local_auth_kit.dart';
import 'package:tom_d4rt/d4rt.dart';

/// In-memory backing store.
class FakeLocalAuthHost {
  bool deviceSupported = true;
  bool canCheck = true;
  List<BiometricType> biometrics = const [BiometricType.face];
  bool authenticateResult = true;
  int authenticateCalls = 0;
  int stopCalls = 0;
  Object? lastReason;
}

class FakeLocalAuth {
  FakeLocalAuth(this.host);
  final FakeLocalAuthHost host;
}

/// All library URIs the real `LocalAuthentication` bridge is reachable from.
/// Must mirror `LocalAuthKitBridge` (barrel + `classSourceUris()`).
const List<String> kLocalAuthBridgeUris = [
  'package:local_auth_kit/local_auth_kit.dart',
  'package:local_auth_kit/src/local_auth.dart',
];

FakeLocalAuth _targetOf(Object? target) {
  if (target is FakeLocalAuth) return target;
  throw ArgumentD4rtException(
    'Invalid target: expected LocalAuthentication (fake), '
    'got ${target?.runtimeType}',
  );
}

/// Builds the fake `LocalAuthentication` bridge backed by [host].
BridgedClass buildFakeLocalAuthBridge(FakeLocalAuthHost host) {
  return BridgedClass(
    nativeType: FakeLocalAuth,
    name: 'LocalAuthentication',
    isAssignable: (v) => v is FakeLocalAuth,
    constructors: {
      '': (visitor, positional, named) => FakeLocalAuth(host),
    },
    getters: {
      'canCheckBiometrics': (visitor, target) =>
          Future<bool>.value(_targetOf(target).host.canCheck),
    },
    methods: {
      'isDeviceSupported': (visitor, target, positional, named, typeArgs) =>
          Future<bool>.value(_targetOf(target).host.deviceSupported),
      'getAvailableBiometrics':
          (visitor, target, positional, named, typeArgs) =>
              Future<List<BiometricType>>.value(
                _targetOf(target).host.biometrics,
              ),
      'authenticate': (visitor, target, positional, named, typeArgs) {
        final auth = _targetOf(target).host;
        auth.authenticateCalls++;
        auth.lastReason = named['localizedReason'];
        return Future<bool>.value(auth.authenticateResult);
      },
      'stopAuthentication': (visitor, target, positional, named, typeArgs) {
        _targetOf(target).host.stopCalls++;
        return Future<bool>.value(true);
      },
    },
    methodSignatures: const {
      'isDeviceSupported': 'Future<bool> isDeviceSupported()',
      'getAvailableBiometrics':
          'Future<List<BiometricType>> getAvailableBiometrics()',
      'authenticate':
          'Future<bool> authenticate({required String localizedReason, Iterable<AuthMessages> authMessages = const [IOSAuthMessages(), AndroidAuthMessages()], AuthenticationOptions options = const AuthenticationOptions()})',
      'stopAuthentication': 'Future<bool> stopAuthentication()',
    },
    getterSignatures: const {
      'canCheckBiometrics': 'Future<bool> get canCheckBiometrics',
    },
  );
}

/// Installs the fake on [interpreter], shadowing the real native bridge on
/// all reachable URIs. Call after runner construction, before first evaluate.
void installFakeLocalAuth(D4rt interpreter, FakeLocalAuthHost host) {
  final fake = buildFakeLocalAuthBridge(host);
  for (final uri in kLocalAuthBridgeUris) {
    interpreter.registerBridgedClass(fake, uri);
  }
}

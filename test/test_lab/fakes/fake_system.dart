/// Host-side fake for `dartnative_system`.
///
/// The real plugin reads the app bundle / launcher badge over FFI, which is
/// unavailable on the host VM. This fake registers in-memory `BridgedClass`es
/// under the SAME class names and library URIs as the generated bridge, so
/// guest code keeps its real import path while calls record into plain host
/// objects. Last registration wins — install AFTER the runner is constructed
/// (see `DnHarness.bridgeOverrides`) and BEFORE the first `evaluate`.
library;

import 'package:tom_d4rt/d4rt.dart';

/// Use a DISTINCT host class for `SystemFFIBindings`. If every fake class
/// used [FakeSystemHost] as `nativeType`, the shared `BridgedInstance`
/// casting/lookup could resolve a member on the wrong bridge (the guest saw
/// 'Undefined property appName on SystemFFIBindings'). Distinct native types
/// keep each bridge unambiguous.
class FakeSystemFfiHost {
  FakeSystemFfiHost(this.host);

  final FakeSystemHost host;

  String appName = 'HeadlessDemo';
}

/// Distinct native type for the static-only `AppBadgePlus` bridge.
///
/// It never wraps a real instance: the class only exposes static members, so
/// giving it its own type keeps `toBridgedInstance` from mistaking a
/// [FakeSystemHost] (PackageInfo) for an AppBadgePlus instance.
class FakeAppBadgeHost {
  const FakeAppBadgeHost();
}

/// In-memory backing store visible to the host test.
class FakeSystemHost {
  String appName = 'HeadlessDemo';
  String packageName = 'com.example.headlessdemo';
  String version = '1.2.3';
  String buildNumber = '42';

  int badge = 0;

  /// Every `updateBadge` call, in order.
  final List<int> badgeCalls = [];
}

/// All library URIs the real system bridge is reachable from. Mirrors
/// `DartnativeSystemBridge.bridgeReExports()` / registration set.
const List<String> kSystemBridgeUris = [
  'package:dartnative_system/dartnative_system.dart',
  'package:dartnative_system/src/package_info.dart',
  'package:dartnative_system/src/app_badge.dart',
  'package:dartnative_system/src/system_ffi_bindings.dart',
];

FakeSystemHost targetOf(Object? target) {
  if (target is FakeSystemHost) return target;
  throw ArgumentD4rtException(
    'Invalid target: expected a fake dartnative_system object, '
    'got ${target?.runtimeType}',
  );
}

FakeSystemHost ffiTargetOf(Object? target) {
  if (target is FakeSystemFfiHost) return target.host;
  return targetOf(target);
}

BridgedClass _buildPackageInfoBridge(FakeSystemHost host) {
  return BridgedClass(
    nativeType: FakeSystemHost,
    name: 'PackageInfo',
    isAssignable: (v) => v is FakeSystemHost,
    constructors: {
      '': (visitor, positional, named) {
        final appName = D4.getRequiredNamedArg<String>(
          named,
          'appName',
          'PackageInfo',
        );
        final packageName = D4.getRequiredNamedArg<String>(
          named,
          'packageName',
          'PackageInfo',
        );
        final version = D4.getRequiredNamedArg<String>(
          named,
          'version',
          'PackageInfo',
        );
        final buildNumber = D4.getRequiredNamedArg<String>(
          named,
          'buildNumber',
          'PackageInfo',
        );
        return host;
      },
    },
    getters: {
      'appName': (visitor, target) => targetOf(target).appName,
      'packageName': (visitor, target) => targetOf(target).packageName,
      'version': (visitor, target) => targetOf(target).version,
      'buildNumber': (visitor, target) => targetOf(target).buildNumber,
    },
    staticMethods: {
      'fromPlatform': (visitor, positional, named, typeArgs) =>
          Future.value(host),
    },
    constructorSignatures: const {
      '': 'const PackageInfo({required String appName, required String packageName, required String version, required String buildNumber})',
    },
    getterSignatures: const {
      'appName': 'String get appName',
      'packageName': 'String get packageName',
      'version': 'String get version',
      'buildNumber': 'String get buildNumber',
    },
    staticMethodSignatures: const {
      'fromPlatform': 'Future<PackageInfo> fromPlatform()',
    },
  );
}

BridgedClass _buildAppBadgePlusBridge(FakeSystemHost host) {
  return BridgedClass(
    nativeType: FakeAppBadgeHost,
    name: 'AppBadgePlus',
    isAssignable: (v) => v is FakeAppBadgeHost,
    constructors: const {},
    staticMethods: {
      'isSupported': (visitor, positional, named, typeArgs) =>
          Future.value(true),
      'updateBadge': (visitor, positional, named, typeArgs) {
        if (positional.isEmpty || positional[0] is! int) {
          throw ArgumentD4rtException('updateBadge requires an int count');
        }
        host.badge = positional[0] as int;
        host.badgeCalls.add(host.badge);
        return Future.value(null);
      },
    },
    staticMethodSignatures: const {
      'isSupported': 'Future<bool> isSupported()',
      'updateBadge': 'Future<void> updateBadge(int count)',
    },
  );
}

BridgedClass _buildSystemFfiBridge(FakeSystemHost host) {
  return BridgedClass(
    nativeType: FakeSystemFfiHost,
    name: 'SystemFFIBindings',
    isAssignable: (v) => v is FakeSystemFfiHost,
    constructors: const {},
    methods: {
      'getPackageInfo': (visitor, target, positional, named, typeArgs) => host,
      'updateBadge': (visitor, target, positional, named, typeArgs) {
        if (positional.isEmpty || positional[0] is! int) {
          throw ArgumentD4rtException('updateBadge requires an int count');
        }
        final ffiHost = ffiTargetOf(target);
        ffiHost.badge = positional[0] as int;
        ffiHost.badgeCalls.add(ffiHost.badge);
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) => FakeSystemFfiHost(host),
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) => null,
    },
    methodSignatures: const {
      'getPackageInfo': 'PackageInfo getPackageInfo()',
      'updateBadge': 'void updateBadge(int count)',
    },
    staticMethodSignatures: const {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: const {
      'instance': 'SystemFFIBindings get instance',
    },
  );
}

/// Installs the fake on [interpreter], shadowing the real FFI bridge on all
/// reachable URIs. Call after runner construction, before first evaluate.
void installFakeSystem(D4rt interpreter, FakeSystemHost host) {
  for (final uri in kSystemBridgeUris) {
    interpreter.registerBridgedClass(_buildPackageInfoBridge(host), uri);
    interpreter.registerBridgedClass(_buildAppBadgePlusBridge(host), uri);
    interpreter.registerBridgedClass(_buildSystemFfiBridge(host), uri);
  }
}

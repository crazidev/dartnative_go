import 'dart:developer';
import 'dart:isolate';
import 'package:tom_d4rt/d4rt.dart';

/// Bridge for `Service` / `ServiceExtensionResponse` / `ServiceProtocolInfo`
/// (part of `dart:developer`).
///
/// Ported from upstream `d4rt` (`lib/src/stdlib/developer/service.dart`).
class ServiceDeveloper {
  static BridgedClass get definition => BridgedClass(
    nativeType: Service,
    name: 'Service',
    isAssignable: (v) => v is Service,
    staticMethods: {
      'getInfo': (visitor, positionalArgs, namedArgs, _) {
        return Service.getInfo();
      },
      'getIsolateId': (visitor, positionalArgs, namedArgs, _) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! Isolate) {
          throw RuntimeD4rtException(
            'Service.getIsolateId expects an Isolate argument.',
          );
        }
        return Service.getIsolateId(positionalArgs[0] as Isolate);
      },
      'getObjectId': (visitor, positionalArgs, namedArgs, _) {
        if (positionalArgs.isEmpty) {
          throw RuntimeD4rtException(
            'Service.getObjectId expects an Object argument.',
          );
        }
        return Service.getObjectId(positionalArgs[0] as Object);
      },
      'controlWebServer': (visitor, positionalArgs, namedArgs, _) {
        final enable = namedArgs['enable'] as bool? ?? false;
        final silenceOutput = namedArgs['silenceOutput'] as bool?;
        return Service.controlWebServer(
          enable: enable,
          silenceOutput: silenceOutput,
        );
      },
    },
  );
}

class ServiceExtensionResponseDeveloper {
  static BridgedClass get definition => BridgedClass(
    nativeType: ServiceExtensionResponse,
    name: 'ServiceExtensionResponse',
    isAssignable: (v) => v is ServiceExtensionResponse,
    staticGetters: {
      'invalidParams': (visitor) => ServiceExtensionResponse.invalidParams,
      'kInvalidParams': (visitor) => ServiceExtensionResponse.invalidParams,
      'extensionError': (visitor) => ServiceExtensionResponse.extensionError,
      'kExtensionError': (visitor) => ServiceExtensionResponse.extensionError,
      'extensionErrorMin': (visitor) =>
          ServiceExtensionResponse.extensionErrorMin,
      'kExtensionErrorMin': (visitor) =>
          ServiceExtensionResponse.extensionErrorMin,
      'extensionErrorMax': (visitor) =>
          ServiceExtensionResponse.extensionErrorMax,
      'kExtensionErrorMax': (visitor) =>
          ServiceExtensionResponse.extensionErrorMax,
    },
    constructors: {
      'result': (visitor, positionalArgs, namedArgs) {
        if (positionalArgs.isEmpty || positionalArgs[0] is! String) {
          throw RuntimeD4rtException(
            'ServiceExtensionResponse.result expects a String result.',
          );
        }
        return ServiceExtensionResponse.result(positionalArgs[0] as String);
      },
      'error': (visitor, positionalArgs, namedArgs) {
        if (positionalArgs.length < 2 ||
            positionalArgs[0] is! int ||
            positionalArgs[1] is! String) {
          throw RuntimeD4rtException(
            'ServiceExtensionResponse.error expects an int errorCode and a String errorDetail.',
          );
        }
        return ServiceExtensionResponse.error(
          positionalArgs[0] as int,
          positionalArgs[1] as String,
        );
      },
    },
    staticMethods: {
      'result': (visitor, positionalArgs, namedArgs, _) {
        return ServiceExtensionResponse.result(positionalArgs[0] as String);
      },
      'error': (visitor, positionalArgs, namedArgs, _) {
        return ServiceExtensionResponse.error(
          positionalArgs[0] as int,
          positionalArgs[1] as String,
        );
      },
    },
    getters: {
      'result': (visitor, target) =>
          (target as ServiceExtensionResponse).result,
      'errorCode': (visitor, target) =>
          (target as ServiceExtensionResponse).errorCode,
      'errorDetail': (visitor, target) =>
          (target as ServiceExtensionResponse).errorDetail,
      'hashCode': (visitor, target) =>
          (target as ServiceExtensionResponse).hashCode,
      'runtimeType': (visitor, target) =>
          (target as ServiceExtensionResponse).runtimeType,
    },
  );
}

class ServiceProtocolInfoDeveloper {
  static BridgedClass get definition => BridgedClass(
    nativeType: ServiceProtocolInfo,
    name: 'ServiceProtocolInfo',
    isAssignable: (v) => v is ServiceProtocolInfo,
    getters: {
      'majorVersion': (visitor, target) =>
          (target as ServiceProtocolInfo).majorVersion,
      'minorVersion': (visitor, target) =>
          (target as ServiceProtocolInfo).minorVersion,
      'serverUri': (visitor, target) =>
          (target as ServiceProtocolInfo).serverUri,
      'serverWebSocketUri': (visitor, target) =>
          (target as ServiceProtocolInfo).serverWebSocketUri,
      'hashCode': (visitor, target) => (target as ServiceProtocolInfo).hashCode,
      'runtimeType': (visitor, target) =>
          (target as ServiceProtocolInfo).runtimeType,
    },
    methods: {
      'toString': (visitor, target, positionalArgs, namedArgs, _) =>
          (target as ServiceProtocolInfo).toString(),
    },
  );
}

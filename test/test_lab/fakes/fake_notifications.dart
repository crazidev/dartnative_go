/// Host-side fake for `dartnative_notifications`.
///
/// The real plugin talks to UNUserNotificationCenter / NotificationManager
/// over FFI, which is unavailable on the host VM. This fake registers
/// in-memory `BridgedClass`es under the SAME class names and library URIs as
/// the generated bridge, so guest code keeps its real import path while calls
/// record into plain host objects. Last registration wins — install AFTER the
/// runner is constructed (see `DnHarness.bridgeOverrides`) and BEFORE the
/// first `evaluate`.
library;

import 'dart:async';

import 'package:tom_d4rt/d4rt.dart';

/// In-memory backing store visible to the host test.
class FakeNotificationsHost {
  bool permissionGranted = true;
  String? initialTapPayload;
  final List<String> setupTapPayloads = [];
  final List<Map<String, Object?>> shown = [];
  final List<Map<String, Object?>> shownChat = [];
  final List<String> cancelled = [];
  int cancelAllCalls = 0;
  final StreamController<String> tapController =
      StreamController<String>.broadcast();

  void dispose() {
    tapController.close();
  }
}

/// All library URIs the real notifications bridge is reachable from. Mirrors
/// `DartnativeNotificationsBridge.bridgeReExports()` / registration set.
const List<String> kNotificationsBridgeUris = [
  'package:dartnative_notifications/dartnative_notifications.dart',
  'package:dartnative_notifications/src/dartnative_notifications.dart',
  'package:dartnative_notifications/src/notifications_ffi_bindings.dart',
];

FakeNotificationsHost _targetOf(Object? target) {
  if (target is FakeNotificationsHost) return target;
  throw ArgumentD4rtException(
    'Invalid target: expected notifications fake host, '
    'got ${target?.runtimeType}',
  );
}

BridgedClass _buildNotificationsBridge(FakeNotificationsHost host) {
  return BridgedClass(
    nativeType: FakeNotificationsHost,
    name: 'DartNativeNotifications',
    isAssignable: (v) => v is FakeNotificationsHost,
    constructors: const {},
    staticGetters: {
      'onTap': (visitor) => host.tapController.stream,
    },
    staticMethods: {
      'setup': (visitor, positional, named, typeArgs) => null,
      'getInitialTapPayload': (visitor, positional, named, typeArgs) =>
          host.initialTapPayload,
      'requestPermission': (visitor, positional, named, typeArgs) =>
          Future.value(host.permissionGranted),
      'show': (visitor, positional, named, typeArgs) {
        host.shown.add({
          'id': named['id'] as String,
          'title': named['title'] as String,
          'body': named['body'] as String,
          'payload': (named['payload'] as String?) ?? '',
          'delaySeconds': (named['delaySeconds'] as int?) ?? 0,
        });
        return null;
      },
      'showChat': (visitor, positional, named, typeArgs) {
        host.shownChat.add({
          'id': named['id'] as String,
          'senderName': named['senderName'] as String,
          'body': named['body'] as String,
          'payload': (named['payload'] as String?) ?? '',
          'delaySeconds': (named['delaySeconds'] as int?) ?? 0,
        });
        return null;
      },
      'cancel': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'cancel');
        host.cancelled.add(positional[0] as String);
        return null;
      },
      'cancelAll': (visitor, positional, named, typeArgs) {
        host.cancelAllCalls++;
        return null;
      },
    },
    staticMethodSignatures: const {
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
    staticGetterSignatures: const {
      'onTap': 'Stream<String> get onTap',
    },
  );
}

BridgedClass _buildNotificationsFfiBridge(FakeNotificationsHost host) {
  return BridgedClass(
    nativeType: FakeNotificationsHost,
    name: 'NotificationsFFIBindings',
    isAssignable: (v) => v is FakeNotificationsHost,
    constructors: const {},
    getters: {
      'onNotificationTap': (visitor, target) =>
          _targetOf(target).tapController.stream,
    },
    methods: {
      'getInitialTapPayload': (visitor, target, positional, named, typeArgs) =>
          _targetOf(target).initialTapPayload,
      'requestPermission': (visitor, target, positional, named, typeArgs) =>
          Future.value(_targetOf(target).permissionGranted),
      'show': (visitor, target, positional, named, typeArgs) {
        _targetOf(target).shown.add({
          'id': named['id'] as String,
          'title': named['title'] as String,
          'body': named['body'] as String,
        });
        return null;
      },
      'showChat': (visitor, target, positional, named, typeArgs) {
        _targetOf(target).shownChat.add({
          'id': named['id'] as String,
          'senderName': named['senderName'] as String,
          'body': named['body'] as String,
        });
        return null;
      },
      'cancel': (visitor, target, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'cancel');
        _targetOf(target).cancelled.add(positional[0] as String);
        return null;
      },
      'cancelAll': (visitor, target, positional, named, typeArgs) {
        _targetOf(target).cancelAllCalls++;
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) => host,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) => null,
    },
    methodSignatures: const {
      'getInitialTapPayload': 'String? getInitialTapPayload()',
      'requestPermission': 'Future<bool> requestPermission()',
      'show':
          'void show({required String id, required String title, required String body, String payload = \'\', int delaySeconds = 0})',
      'showChat':
          'void showChat({required String id, required String senderName, required String body, required Uint8List avatar, String payload = \'\', int delaySeconds = 0})',
      'cancel': 'void cancel(String id)',
      'cancelAll': 'void cancelAll()',
    },
    staticMethodSignatures: const {
      'loadSymbols': 'void loadSymbols({bool registerTapHandler = true})',
    },
    staticGetterSignatures: const {
      'instance': 'NotificationsFFIBindings get instance',
    },
  );
}

/// Installs the fake on [interpreter], shadowing the real FFI bridge on all
/// reachable URIs. Call after runner construction, before first evaluate.
void installFakeNotifications(
  D4rt interpreter,
  FakeNotificationsHost host,
) {
  final api = _buildNotificationsBridge(host);
  final ffi = _buildNotificationsFfiBridge(host);
  for (final uri in kNotificationsBridgeUris) {
    interpreter.registerBridgedClass(api, uri);
    interpreter.registerBridgedClass(ffi, uri);
  }
}

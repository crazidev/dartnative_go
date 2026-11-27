/// AST-engine host fake for `dartnative_connectivity`.
///
/// Both generated bridges construct the real classes, whose members go through
/// `ConnectivityFFIBindings`, which asserts
/// `Call ConnectivityFFIBindings.loadSymbols() first` without a native library.
/// The playground's system screen subscribes to the transport stream from
/// `initState`; the assertion is raised inside the stream's `listen` (an async
/// gap), so the guest's own `try`/`catch` cannot see it and it lands as an
/// unhandled error that fails the whole suite.
///
/// [FakeConnectivity] and [FakeInternetConnection] `implements` the real types,
/// so they stay assignable wherever the generated bridges and guest fields
/// expect one. Both report a wired connection with internet access and emit
/// one event immediately on subscribe — the same shape the real transport
/// stream has ("emits the current type on first subscription").
///
/// Both engines are covered: [installFakeConnectivityAst] shadows the AST
/// bridge set, [installFakeConnectivitySource] the source one.
library;

import 'dart:async';

import 'package:dartnative_connectivity/src/connectivity.dart';
import 'package:dartnative_connectivity/src/connectivity_result.dart';
import 'package:dartnative_connectivity/src/internet_connection.dart';
import 'package:tom_d4rt/d4rt.dart' as src;
import 'package:tom_d4rt_ast/d4rt.dart' as ast;

/// Library URIs the generated connectivity bridges are reachable from.
const List<String> kConnectivityAstBridgeUris = [
  'package:dartnative_connectivity/connectivity.dart',
  'package:dartnative_connectivity/src/connectivity.dart',
  'package:dartnative_connectivity/src/connectivity_result.dart',
  'package:dartnative_connectivity/src/internet_connection.dart',
];

/// Always-on wired transport.
class FakeConnectivity implements Connectivity {
  @override
  Stream<ConnectivityType> get onConnectivityTypeChanged =>
      Stream<ConnectivityType>.value(ConnectivityType.ethernet);

  @override
  Future<ConnectivityType> checkConnectivityType() =>
      Future.value(ConnectivityType.ethernet);
}

/// Always-online reachability.
class FakeInternetConnection implements InternetConnection {
  @override
  Duration checkInterval = const Duration(seconds: 5);

  @override
  Future<bool> get hasInternet => Future.value(true);

  @override
  bool? get isConnected => true;

  @override
  Stream<bool> get onInternetChanged => Stream<bool>.value(true);
}

/// Builds the fake `Connectivity` bridge.
ast.BridgedClass buildFakeConnectivityAstBridge() {
  return ast.BridgedClass(
    nativeType: Connectivity,
    name: 'Connectivity',
    isAssignable: (v) => v is Connectivity,
    constructors: {
      '': (visitor, positional, named) => FakeConnectivity(),
    },
    getters: {
      'onConnectivityTypeChanged': (visitor, target) =>
          (target as Connectivity).onConnectivityTypeChanged,
    },
    methods: {
      'checkConnectivityType': (visitor, target, positional, named, typeArgs) =>
          (target as Connectivity).checkConnectivityType(),
    },
    constructorSignatures: const {
      '': 'factory Connectivity()',
    },
    getterSignatures: const {
      'onConnectivityTypeChanged':
          'Stream<ConnectivityType> get onConnectivityTypeChanged',
    },
    methodSignatures: const {
      'checkConnectivityType':
          'Future<ConnectivityType> checkConnectivityType()',
    },
  );
}

/// Builds the fake `InternetConnection` bridge.
ast.BridgedClass buildFakeInternetConnectionAstBridge() {
  return ast.BridgedClass(
    nativeType: InternetConnection,
    name: 'InternetConnection',
    isAssignable: (v) => v is InternetConnection,
    constructors: {
      '': (visitor, positional, named) => FakeInternetConnection(),
    },
    getters: {
      'checkInterval': (visitor, target) =>
          (target as InternetConnection).checkInterval,
      'hasInternet': (visitor, target) =>
          (target as InternetConnection).hasInternet,
      'isConnected': (visitor, target) =>
          (target as InternetConnection).isConnected,
      'onInternetChanged': (visitor, target) =>
          (target as InternetConnection).onInternetChanged,
    },
    setters: {
      'checkInterval': (visitor, target, value) =>
          (target as InternetConnection).checkInterval =
              ast.D4.extractBridgedArg<Duration>(value, 'checkInterval'),
    },
    constructorSignatures: const {
      '': 'factory InternetConnection()',
    },
    getterSignatures: const {
      'checkInterval': 'Duration get checkInterval',
      'hasInternet': 'Future<bool> get hasInternet',
      'isConnected': 'bool? get isConnected',
      'onInternetChanged': 'Stream<bool> get onInternetChanged',
    },
    setterSignatures: const {
      'checkInterval': 'set checkInterval(dynamic value)',
    },
  );
}

/// Returns an override for `DnHarness(astBridgeOverrides: [...])`.
void Function(ast.D4rtRunner runner) installFakeConnectivityAst() {
  final connectivity = buildFakeConnectivityAstBridge();
  final internet = buildFakeInternetConnectionAstBridge();
  return (runner) {
    for (final uri in kConnectivityAstBridgeUris) {
      runner.registerBridgedClass(connectivity, uri);
      runner.registerBridgedClass(internet, uri);
    }
  };
}

/// Source-engine counterpart, for `DnHarness(bridgeOverrides: [...])`.
void installFakeConnectivitySource(src.D4rt interpreter) {
  final connectivity = src.BridgedClass(
    nativeType: Connectivity,
    name: 'Connectivity',
    isAssignable: (v) => v is Connectivity,
    constructors: {
      '': (visitor, positional, named) => FakeConnectivity(),
    },
    getters: {
      'onConnectivityTypeChanged': (visitor, target) =>
          (target as Connectivity).onConnectivityTypeChanged,
    },
    methods: {
      'checkConnectivityType': (visitor, target, positional, named, typeArgs) =>
          (target as Connectivity).checkConnectivityType(),
    },
    constructorSignatures: const {
      '': 'factory Connectivity()',
    },
    getterSignatures: const {
      'onConnectivityTypeChanged':
          'Stream<ConnectivityType> get onConnectivityTypeChanged',
    },
    methodSignatures: const {
      'checkConnectivityType':
          'Future<ConnectivityType> checkConnectivityType()',
    },
  );
  final internet = src.BridgedClass(
    nativeType: InternetConnection,
    name: 'InternetConnection',
    isAssignable: (v) => v is InternetConnection,
    constructors: {
      '': (visitor, positional, named) => FakeInternetConnection(),
    },
    getters: {
      'checkInterval': (visitor, target) =>
          (target as InternetConnection).checkInterval,
      'hasInternet': (visitor, target) =>
          (target as InternetConnection).hasInternet,
      'isConnected': (visitor, target) =>
          (target as InternetConnection).isConnected,
      'onInternetChanged': (visitor, target) =>
          (target as InternetConnection).onInternetChanged,
    },
    setters: {
      'checkInterval': (visitor, target, value) =>
          (target as InternetConnection).checkInterval =
              src.D4.extractBridgedArg<Duration>(value, 'checkInterval'),
    },
    constructorSignatures: const {
      '': 'factory InternetConnection()',
    },
    getterSignatures: const {
      'checkInterval': 'Duration get checkInterval',
      'hasInternet': 'Future<bool> get hasInternet',
      'isConnected': 'bool? get isConnected',
      'onInternetChanged': 'Stream<bool> get onInternetChanged',
    },
    setterSignatures: const {
      'checkInterval': 'set checkInterval(dynamic value)',
    },
  );
  for (final uri in kConnectivityAstBridgeUris) {
    interpreter.registerBridgedClass(connectivity, uri);
    interpreter.registerBridgedClass(internet, uri);
  }
}

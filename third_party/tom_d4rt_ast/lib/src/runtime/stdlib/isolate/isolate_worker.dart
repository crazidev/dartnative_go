import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:tom_d4rt_ast/runtime.dart';

/// Worker isolate runner for interpreted Dart tasks.
///
/// Allows executing top-level interpreted functions in real background Dart
/// isolates with true multi-core parallel execution.
class D4rtIsolateWorker {
  /// Provider for the active AST bundle bytes in the current process/runner.
  static List<int>? Function()? bundleBytesProvider;

  /// Active AST bundle bytes cached by the runner.
  static List<int>? activeBundleBytes;

  /// Runs [entryFunction] inside a real native Dart worker isolate.
  ///
  /// [bundleBytes] contains the serialized [AstBundle] (ZIP/gzip/JSON). If omitted,
  /// uses [activeBundleBytes] or [bundleBytesProvider].
  /// [entryPoint] is the module URI where the function is declared.
  /// [args] can be positional arguments (as a List) or named arguments (as a Map).
  static Future<Object?> run({
    required String entryFunction,
    String? entryPoint,
    List<Object?>? positionalArgs,
    Map<String, Object?>? namedArgs,
    Map<String, Object?>? args,
    List<int>? bundleBytes,
  }) async {
    final bytes =
        bundleBytes ?? activeBundleBytes ?? bundleBytesProvider?.call();
    if (bytes == null || bytes.isEmpty) {
      throw StateError(
        'D4rtIsolateWorker: No AST bundle bytes available to run worker isolate.',
      );
    }

    final effectivePositional = positionalArgs;
    final effectiveNamed = namedArgs ?? args;

    return _runInIsolate(
      bytes,
      entryFunction,
      entryPoint,
      effectivePositional,
      effectiveNamed,
    );
  }

  static Future<Object?> _runInIsolate(
    List<int> bundleBytes,
    String functionName,
    String? entryPoint,
    List<Object?>? positionalArgs,
    Map<String, Object?>? namedArgs,
  ) async {
    final responsePort = ReceivePort();
    final errorPort = ReceivePort();
    final exitPort = ReceivePort();
    Isolate? isolate;

    try {
      isolate = await Isolate.spawn(
        _workerEntryPoint,
        [
          responsePort.sendPort,
          bundleBytes,
          functionName,
          entryPoint,
          positionalArgs,
          namedArgs,
        ],
        onError: errorPort.sendPort,
        onExit: exitPort.sendPort,
        errorsAreFatal: true,
      );

      final completer = Completer<Object?>();
      late StreamSubscription subResp;
      late StreamSubscription subErr;
      late StreamSubscription subExit;

      void cleanup() {
        subResp.cancel();
        subErr.cancel();
        subExit.cancel();
      }

      subResp = responsePort.listen((msg) {
        cleanup();
        if (!completer.isCompleted) {
          if (msg is Map && msg['status'] == 'error') {
            completer.completeError(Exception(msg['error']));
          } else if (msg is Map && msg.containsKey('result')) {
            completer.complete(msg['result']);
          } else {
            completer.complete(msg);
          }
        }
      });

      subErr = errorPort.listen((errorMsg) {
        cleanup();
        if (!completer.isCompleted) {
          completer.completeError(Exception('Worker isolate error: $errorMsg'));
        }
      });

      subExit = exitPort.listen((_) {
        cleanup();
        if (!completer.isCompleted) {
          completer.completeError(
            Exception('Worker isolate exited without returning a result'),
          );
        }
      });

      return await completer.future;
    } finally {
      responsePort.close();
      errorPort.close();
      exitPort.close();
      isolate?.kill(priority: Isolate.immediate);
    }
  }

  static void _registerComputeBridges(D4rtRunner runner) {
    for (final lib in [
      'package:flutter/foundation.dart',
      'package:dartnative/dartnative.dart',
      'package:flutter/widgets.dart',
      'package:flutter/material.dart',
    ]) {
      runner.registertopLevelFunction(
        'compute',
        (visitor, pos, named, typeArgs) async {
          throw StateError(
            'Nested compute() inside an isolate worker is not supported',
          );
        },
        lib,
        signature: 'Future<R> compute<Q, R>(Function callback, Q message)',
      );
      runner.registertopLevelFunction(
        'debugPrint',
        (visitor, pos, named, typeArgs) {
          print(pos.isNotEmpty ? pos[0] : '');
          return null;
        },
        lib,
      );
    }
  }

  static void _workerEntryPoint(List<Object?> message) async {
    final replyPort = message[0] as SendPort;
    final bundleBytes = message[1] as List<int>;
    final functionName = message[2] as String;
    final entryPoint = message[3] as String?;
    final positionalArgs = message[4] as List<Object?>?;
    final namedArgs = message[5] as Map<String, Object?>?;

    try {
      final runner = D4rtRunner();
      _registerComputeBridges(runner);
      runner.finalizeBridges();
      final bundle = decodeBundleBytes(bundleBytes);
      var result = runner.executeBundle(
        bundle,
        entryPoint: entryPoint,
        name: functionName,
        positionalArgs: positionalArgs,
        namedArgs: namedArgs,
      );
      if (result is Future) {
        result = await result;
      }
      replyPort.send({'status': 'ok', 'result': result});
    } catch (e, st) {
      replyPort.send({'status': 'error', 'error': '$e\n$st'});
    }
  }

  static AstBundle decodeBundleBytes(List<int> bytes) {
    if (bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4B) {
      return AstBundle.fromZip(bytes);
    }
    if (bytes.length >= 2 && bytes[0] == 0x1F && bytes[1] == 0x8B) {
      return AstBundle.fromBytes(bytes);
    }
    try {
      final json = jsonDecode(utf8.decode(bytes));
      if (json is Map<String, dynamic>) {
        return AstBundle.fromJson(json);
      }
    } catch (_) {}
    throw ArgumentError('Unrecognized AST bundle format');
  }
}

/// Bridge registering [D4rtIsolateWorker] into the interpreted environment.
class D4rtIsolateWorkerBridge {
  static BridgedClass get definition => BridgedClass(
    nativeType: D4rtIsolateWorker,
    name: 'D4rtIsolateWorker',
    isAssignable: (v) => v is D4rtIsolateWorker,
    staticMethods: {
      'run': (visitor, positionalArgs, namedArgs, _) {
        final entryFunction =
            namedArgs.get<String?>('entryFunction') ??
            (positionalArgs.isNotEmpty ? positionalArgs[0].toString() : null);
        if (entryFunction == null) {
          throw ArgumentError('D4rtIsolateWorker.run requires entryFunction');
        }
        final args = namedArgs.get<Map<String, Object?>?>('args');
        final pos =
            namedArgs.get<List<Object?>?>('positionalArgs') ??
            (positionalArgs.length > 1 ? positionalArgs.sublist(1) : null);
        return D4rtIsolateWorker.run(
          entryFunction: entryFunction,
          positionalArgs: pos,
          namedArgs: args,
        );
      },
    },
  );
}

import 'dart:async';
import 'dart:isolate';

import 'package:tom_d4rt_ast/runtime.dart' as ast;
import 'package:tom_d4rt_ast/runtime.dart' show D4rtIsolateWorker;

/// Registers the `compute()` top-level bridge mirroring the `compute()` API.
///
/// Executes [callback] in a real background Dart isolate using [D4rtIsolateWorker]
/// when given a named top-level interpreted function and bundle bytes.
/// Falls back to executing in the current isolate if run as an interpreted closure
/// or when bundle bytes are not provided.
void registerAstComputeBridge(ast.D4rtRunner runner) {
  Future<Object?> computeBridge(
    ast.InterpreterVisitor visitor,
    List<Object?> positional,
    Map<String, Object?> named,
    List<ast.RuntimeType>? typeArgs,
  ) async {
    if (positional.isEmpty) {
      throw ArgumentError('compute requires a callback function argument');
    }
    final callback = positional[0];
    final message = positional.length > 1 ? positional[1] : null;

    if (callback is ast.InterpretedFunction) {
      final fnName =
          callback.codeCell?.key.qualifiedName ?? callback.currentCode.name;
      final moduleUri = callback.codeCell?.key.moduleUri;
      final bytes =
          D4rtIsolateWorker.activeBundleBytes ??
          D4rtIsolateWorker.bundleBytesProvider?.call();
      final isTopLevel =
          callback.codeCell != null &&
          !callback.codeCell!.key.qualifiedName.contains('#');

      if (fnName != null && isTopLevel && bytes != null && bytes.isNotEmpty) {
        return D4rtIsolateWorker.run(
          entryFunction: fnName,
          entryPoint: moduleUri,
          positionalArgs: message != null ? [message] : [],
          bundleBytes: bytes,
        );
      }
      final res = callback.call(visitor, message != null ? [message] : []);
      if (res is Future) return await res;
      return res;
    } else if (callback is Function) {
      return Isolate.run(() => callback(message));
    }
    throw ArgumentError('First argument to compute must be a function');
  }

  for (final lib in [
    'package:flutter/foundation.dart',
    'package:dartnative/dartnative.dart',
  ]) {
    runner.registertopLevelFunction(
      'compute',
      computeBridge,
      lib,
      signature: 'Future<R> compute<Q, R>(Function callback, Q message)',
    );
  }
}

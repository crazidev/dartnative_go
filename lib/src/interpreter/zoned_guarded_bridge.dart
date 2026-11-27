/// `runZonedGuarded` bridge for both interpreter engines.
///
/// Guest apps routinely wrap `main()` in `runZonedGuarded` (the upstream
/// playground does) to funnel every uncaught error into one handler. The
/// interpreters deliberately do **not** bridge `Zone` — zones intercept
/// control flow, scheduling and error handling the interpreter owns, so a
/// bridged `Zone` would be a no-op shell (see `doc/d4rt_limitations.md`). That
/// leaves `runZonedGuarded` reported as "not bridged" and the whole entrypoint
/// fails to load.
///
/// What the guest actually uses it for is catch-and-report, so that is what
/// this bridge implements: run `body()` in the current zone, route synchronous
/// throws and async errors from a returned `Future` to `onError`, and return
/// the body's result. `zoneValues` / `zoneSpecification` are accepted and
/// ignored — the guest-visible behaviour (errors reach the handler) matches.
library;

import 'package:tom_d4rt/tom_d4rt.dart' as src;
import 'package:tom_d4rt_ast/d4rt.dart' as ast;

/// Calls the interpreted `onError(error, stackTrace)` callback, ignoring any
/// failure inside the handler itself (Dart does the same: a throwing error
/// handler takes down the zone).
void _report(
  Object? handler,
  Object error,
  StackTrace stack, {
  required Object? Function(Object? handler, List<Object?> args) invoke,
}) {
  if (handler == null) return;
  try {
    invoke(handler, [error, stack]);
  } catch (_) {}
}

/// Source engine (`tom_d4rt`) implementation.
Object? runZonedGuardedSource(
  src.InterpreterVisitor visitor,
  List<Object?> positional,
) {
  final body = positional.isNotEmpty ? positional[0] : null;
  final onError = positional.length > 1 ? positional[1] : null;

  Object? invoke(Object? cb, List<Object?> args) =>
      src.D4.callInterpreterCallback(visitor, cb, args);

  final Object? result;
  try {
    result = invoke(body, const []);
  } catch (error, stack) {
    _report(onError, error, stack, invoke: invoke);
    return null;
  }

  if (result is Future) {
    return result.catchError((Object error, StackTrace stack) {
      _report(onError, error, stack, invoke: invoke);
      return null;
    });
  }
  return result;
}

/// AST engine (`tom_d4rt_ast`) implementation.
Object? runZonedGuardedAst(
  ast.InterpreterVisitor visitor,
  List<Object?> positional,
) {
  final body = positional.isNotEmpty ? positional[0] : null;
  final onError = positional.length > 1 ? positional[1] : null;

  Object? invoke(Object? cb, List<Object?> args) =>
      ast.D4.callInterpreterCallback(visitor, cb, args);

  final Object? result;
  try {
    result = invoke(body, const []);
  } catch (error, stack) {
    _report(onError, error, stack, invoke: invoke);
    return null;
  }

  if (result is Future) {
    return result.catchError((Object error, StackTrace stack) {
      _report(onError, error, stack, invoke: invoke);
      return null;
    });
  }
  return result;
}

/// Libraries `runZonedGuarded` must resolve from in guest code.
const kRunZonedGuardedLibraries = <String>[
  'dart:async',
  'package:dartnative/dartnative.dart',
  'package:dartnative/flutter_compat.dart',
  'package:dartnative/src/framework.dart',
];

/// The guest-facing signature the interpreters advertise for
/// `runZonedGuarded`:
/// `R? runZonedGuarded<R>(R Function() body, void Function(Object, StackTrace) onError)`.
const kRunZonedGuardedSignature =
    'R? runZonedGuarded<R>(R Function() body, '
    'void Function(Object, StackTrace) onError)';

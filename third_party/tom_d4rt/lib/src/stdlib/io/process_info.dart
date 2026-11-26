import 'dart:io';
import 'package:tom_d4rt/d4rt.dart';

/// Bridged implementation of `dart:io`'s [ProcessInfo].
///
/// Both members are host values (resident-set sizes in bytes) — the playground
/// reads `ProcessInfo.currentRss` from `initState` for its memory readout, so
/// without this bridge the whole class is an undefined name.
///
/// Gated like [PlatformIo]: a resident-set size is a fact about the host
/// process, so it needs the same dangerous permission.
class ProcessInfoIo {
  static BridgedClass get definition => BridgedClass(
    nativeType: ProcessInfo,
    name: 'ProcessInfo',
    isAssignable: (v) => v is ProcessInfo,
    typeParameterCount: 0,
    staticGetters: {
      'currentRss': (visitor) {
        _checkDangerousPermission(visitor);
        return ProcessInfo.currentRss;
      },
      'maxRss': (visitor) {
        _checkDangerousPermission(visitor);
        return ProcessInfo.maxRss;
      },
    },
  );

  /// Helper method to check if DangerousPermission is granted
  static void _checkDangerousPermission(InterpreterVisitor visitor) {
    // No interpreter instance means no permission set to enforce — the
    // bridges are being driven directly (e.g. from a unit test), not
    // sandboxed. Mirrors PlatformIo.
    final d4rt = visitor.moduleLoader.d4rt;
    if (d4rt == null) return;

    if (!d4rt.checkPermission({'type': 'dangerous'})) {
      throw RuntimeD4rtException(
        'Access to ProcessInfo requires DangerousPermission. '
        'Use d4rt.grant(DangerousPermission.any) to allow ProcessInfo access.',
      );
    }
  }
}

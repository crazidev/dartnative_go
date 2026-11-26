import 'dart:convert';

import 'package:tom_d4rt_ast/runtime.dart';

/// Name bridges for `dart:convert`'s class typedefs.
///
/// The SDK aliases the chunked-conversion sinks for backwards compatibility:
///
/// * `typedef ByteConversionSinkBase = ByteConversionSink`
/// * `typedef StringConversionSinkBase = StringConversionSink`
/// * `typedef StringConversionSinkMixin = StringConversionSink`
///
/// Interpreted code names the aliases (e.g. `class _Sink extends
/// ByteConversionSinkBase` in `package:http_parser`), so each needs a bridge
/// even though there is no distinct native type behind it. Like the
/// collection typedef stubs, these carry no `isAssignable` — concrete sinks
/// stay owned by the `ByteConversionSink` / `StringConversionSink` bridges —
/// and no members: they exist so `extends` wiring and `is` checks resolve.
class SinkAliasesConvert {
  static BridgedClass get byteConversionSinkBase => BridgedClass(
    nativeType: ByteConversionSink,
    name: 'ByteConversionSinkBase',
  );

  static BridgedClass get stringConversionSinkBase => BridgedClass(
    nativeType: StringConversionSink,
    name: 'StringConversionSinkBase',
  );

  static BridgedClass get stringConversionSinkMixin => BridgedClass(
    nativeType: StringConversionSink,
    name: 'StringConversionSinkMixin',
  );

  static void register(Environment environment) {
    environment.defineBridge(byteConversionSinkBase);
    environment.defineBridge(stringConversionSinkBase);
    environment.defineBridge(stringConversionSinkMixin);
  }
}

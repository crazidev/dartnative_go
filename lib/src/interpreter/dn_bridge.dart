import 'package:tom_d4rt/tom_d4rt.dart';
import '../../d4rt_bridges.b.dart';
import 'widget_proxies.dart';

/// Helper to unwrap native Dart objects from d4rt's [BridgedInstance] or raw objects.
T? unwrap<T>(Object? arg) {
  if (arg == null) return null;
  try {
    return D4.extractBridgedArg<T>(arg, 'result');
  } catch (_) {
    if (arg is T) return arg as T;
    return null;
  }
}

/// Registers the complete generated DartNative bridges into a [D4rt] interpreter.
void registerDartNativeBridges(D4rt interpreter, {void Function(String message)? onLog}) {
  DartnativeUiBridge.registerBridges(
    interpreter,
    'package:dartnative/dartnative.dart',
  );
  registerWidgetInterfaceProxies(interpreter, onLog: onLog);
}


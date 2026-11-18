import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'd4rt_dartnative_application.dart';
import 'dartscript.b.dart';
import 'widget_proxies.dart';

/// Helper to unwrap native Dart objects from d4rt's [BridgedInstance], interpreted widgets, or raw objects.
T? unwrap<T>(Object? arg, {InterpreterVisitor? visitor}) {
  if (arg == null) return null;
  if (arg is D4rtDartNativeApplication) {
    if (T == Widget) return arg.root as T;
    if (arg is T) return arg as T;
  }
  if (T == Widget || arg is InterpretedInstance) {
    final w = wrapInterpretedWidget(arg, visitor: visitor);
    if (w != null && w is T) return w as T;
  }
  try {
    return D4.extractBridgedArg<T>(arg, 'result', visitor);
  } catch (_) {
    if (arg is T) return arg as T;
    return null;
  }
}

/// Registers the complete generated DartNative bridges into a [D4rt] interpreter.
void registerDartNativeBridges(
  D4rt interpreter, {
  void Function(String message)? onLog,
}) {
  DartnativeGoBridges.register(interpreter);
  registerWidgetInterfaceProxies(interpreter, onLog: onLog);
}

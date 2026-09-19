library;

import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt_ast/d4rt.dart';

import '../debug_controller.dart';
import '../widget_generation_tracker.dart';

/// Analyzer-free port of `../widget_proxies.dart` for `tom_d4rt_ast`.
///
/// Faithful 1:1 port — same classes, same lifecycle semantics — with AST
/// visitor types. Only the names below differ (to avoid clashes when both
/// engines are linked): `onAstGuestLog`, `wrapAstInterpretedWidget`,
/// `registerAstWidgetInterfaceProxies`. Proxy *classes* keep their names for
/// diff fidelity; never import both proxy libraries into one file.
///
/// Registered from `AstInterpreterRunner` via
/// [registerAstWidgetInterfaceProxies] + `DartnativeGoAstBridges.register`.

/// Global log handler for AST-interpreted guest code.
void Function(String message)? onAstGuestLog;

R _runWithLogCapture<R>(R Function() action) {
  final handler = onAstGuestLog;
  if (handler == null) return action();
  return runZoned(
    action,
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        handler(line);
      },
    ),
  );
}

/// Native proxy for AST-interpreted classes that extend [StatelessWidget].
class InterpretedStatelessWidget extends StatelessWidget {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedStatelessWidget(this.visitor, this.instance, {Key? key})
      : super(key: key ?? _resolveKey(instance)) {
    instance.nativeProxy = this;
  }

  static Key _resolveKey(InterpretedInstance instance) {
    final gen = WidgetGenerationTracker.getGeneration(instance.klass.name);
    try {
      if (instance.hasInstanceMember('key')) {
        final k = instance.get('key');
        if (k is Key) return ValueKey('${k}_gen_$gen');
      }
    } catch (_) {}
    return ValueKey('Stateless_${instance.klass.name}_gen_$gen');
  }

  @override
  Widget build(BuildContext context) {
    return _runWithLogCapture(() {
      final method = instance.get('build', visitor: visitor);
      if (method is Callable) {
        final rawResult = method.call(visitor, [context], {});
        final widget = D4.extractBridgedArg<Widget>(rawResult, 'buildResult', visitor);
        return widget;
      }
      throw StateError('Interpreted StatelessWidget has no callable build(context) method');
    });
  }
}

/// Native proxy for AST-interpreted classes that extend [StatefulWidget].
class InterpretedStatefulWidget extends StatefulWidget {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedStatefulWidget(this.visitor, this.instance, {Key? key})
      : super(key: key ?? _resolveKey(instance)) {
    instance.nativeProxy = this;
  }

  static Key _resolveKey(InterpretedInstance instance) {
    final gen = WidgetGenerationTracker.getGeneration(instance.klass.name);
    try {
      if (instance.hasInstanceMember('key')) {
        final k = instance.get('key');
        if (k is Key) return ValueKey('${k}_gen_$gen');
      }
    } catch (_) {}
    return ValueKey('Stateful_${instance.klass.name}_gen_$gen');
  }

  @override
  State<StatefulWidget> createState() {
    return _runWithLogCapture(() {
      final method = instance.get('createState', visitor: visitor);
      if (method is Callable) {
        final stateResult = method.call(visitor, [], {});
        if (stateResult is InterpretedInstance) {
          return InterpretedStateProxy(visitor, stateResult, this);
        } else if (stateResult is State<StatefulWidget>) {
          return stateResult;
        }
      }
      throw StateError('Interpreted StatefulWidget failed to create state');
    });
  }
}

/// Native proxy for AST-interpreted classes that extend [State].
class InterpretedStateProxy extends State<StatefulWidget> {
  InterpreterVisitor visitor;
  InterpretedInstance stateInstance;
  InterpretedStatefulWidget ownerWidget;

  bool _isDispatchingInitState = false;
  bool _isDispatchingDidChangeDependencies = false;
  bool _isDispatchingDidUpdateWidget = false;
  bool _isDispatchingDispose = false;

  InterpretedStateProxy(this.visitor, this.stateInstance, this.ownerWidget) {
    _wireStateInstance(stateInstance, ownerWidget.instance);
  }

  void _wireStateInstance(
      InterpretedInstance state, InterpretedInstance widgetInstance) {
    state.nativeProxy = this;
    state.bridgedSuperObject = this;
    state.nativeStateProxy = this;
    state.interpretedStatefulWidget = widgetInstance;
  }

  @override
  void initState() {
    super.initState();
    if (_isDispatchingInitState) {
      // Re-entrant call originating from guest code's super.initState()
      return;
    }
    _isDispatchingInitState = true;
    try {
      _runWithLogCapture(() {
        final method = stateInstance.klass.findInstanceMethod('initState');
        if (method != null) {
          final callable = stateInstance.bindMethodCached(method);
          callable.call(visitor, [], {});
        }
      });
    } finally {
      _isDispatchingInitState = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isDispatchingDidChangeDependencies) return;
    _isDispatchingDidChangeDependencies = true;
    try {
      _runWithLogCapture(() {
        final method = stateInstance.klass.findInstanceMethod('didChangeDependencies');
        if (method != null) {
          final callable = stateInstance.bindMethodCached(method);
          callable.call(visitor, [], {});
        }
      });
    } finally {
      _isDispatchingDidChangeDependencies = false;
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    if (DebugController().isPaused) {
      DebugController().waitIfPaused().then((_) {
        if (mounted) {
          setState(fn);
        }
      });
      return;
    }
    try {
      super.setState(fn);
    } catch (_) {
      // If called during build or layout pass, defer execution cleanly
      scheduleMicrotask(() {
        if (mounted) {
          super.setState(fn);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isDispatchingDidUpdateWidget) return;
    _isDispatchingDidUpdateWidget = true;
    try {
      _runWithLogCapture(() {
        if (widget is InterpretedStatefulWidget) {
          final newOwner = widget as InterpretedStatefulWidget;
          final newVisitor = newOwner.visitor;
          visitor = newVisitor;
          ownerWidget = newOwner;

          // Re-create state instance from updated class definition in the new interpreter,
          // while preserving all existing state fields (like counter values).
          try {
            final createStateMethod =
                newOwner.instance.get('createState', visitor: newVisitor);
            if (createStateMethod is Callable) {
              final newStateResult =
                  createStateMethod.call(newVisitor, [], {});
              if (newStateResult is InterpretedInstance) {
                final oldState = stateInstance;
                final newState = newStateResult;

                _transferStateFields(oldState, newState, newVisitor);
                _wireStateInstance(newState, newOwner.instance);

                stateInstance = newState;
              }
            }
          } catch (e) {
            // Fallback: wire updated widget reference to existing state
            stateInstance.interpretedStatefulWidget = newOwner.instance;
          }
        }
        final method = stateInstance.klass.findInstanceMethod('didUpdateWidget');
        if (method != null) {
          final callable = stateInstance.bindMethodCached(method);
          callable.call(visitor, [oldWidget], {});
        }
        // Ensure stateful widget triggers rebuild with new properties and closures
        setState(() {});
      });
    } finally {
      _isDispatchingDidUpdateWidget = false;
    }
  }

  /// Transfers all state fields from [oldState] to [newState] across reloads
  void _transferStateFields(
    InterpretedInstance oldState,
    InterpretedInstance newState,
    InterpreterVisitor currentVisitor,
  ) {
    try {
      final fieldNames = oldState.klass.getInstanceFieldNames();
      for (final fieldName in fieldNames) {
        if (fieldName == 'widget' || fieldName == 'context') continue;
        Object? val;
        bool hasVal = false;
        try {
          val = oldState.getField(fieldName);
          hasVal = true;
        } catch (_) {
          try {
            val = oldState.get(fieldName, visitor: currentVisitor);
            hasVal = true;
          } catch (_) {}
        }
        if (hasVal) {
          try {
            newState.set(fieldName, val);
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return _runWithLogCapture(() {
      final method = stateInstance.get('build', visitor: visitor);
      if (method is Callable) {
        final rawResult = method.call(visitor, [context], {});
        final widget = D4.extractBridgedArg<Widget>(rawResult, 'buildResult', visitor);
        return widget;
      }
      throw StateError('Interpreted State has no callable build(context) method');
    });
  }

  @override
  void dispose() {
    if (_isDispatchingDispose) return;
    _isDispatchingDispose = true;
    try {
      _runWithLogCapture(() {
        final method = stateInstance.klass.findInstanceMethod('dispose');
        if (method != null) {
          final callable = stateInstance.bindMethodCached(method);
          callable.call(visitor, [], {});
        }
      });
    } finally {
      _isDispatchingDispose = false;
    }
    super.dispose();
  }
}

/// Resolves and wraps an AST-interpreted widget or native proxy into a native [Widget].
Widget? wrapAstInterpretedWidget(Object? arg, {InterpreterVisitor? visitor}) {
  if (arg == null) return null;
  if (arg is Widget) return arg;
  if (arg is InterpretedInstance) {
    if (arg.nativeProxy is Widget) return arg.nativeProxy as Widget;
    if (arg.bridgedSuperObject is Widget) return arg.bridgedSuperObject as Widget;
    final effectiveVisitor = visitor ?? D4.activeVisitor;
    if (effectiveVisitor != null) {
      // Walk class inheritance chain to find StatefulWidget or StatelessWidget
      var cur = arg.klass;
      while (true) {
        if (cur.name == 'StatefulWidget' || cur.bridgedSuperclass?.name == 'StatefulWidget') {
          return InterpretedStatefulWidget(effectiveVisitor, arg);
        }
        if (cur.name == 'StatelessWidget' || cur.bridgedSuperclass?.name == 'StatelessWidget') {
          return InterpretedStatelessWidget(effectiveVisitor, arg);
        }
        if (cur.superclass == null) break;
        cur = cur.superclass!;
      }
      try {
        return D4.withActiveVisitor(
          effectiveVisitor,
          () => D4.extractBridgedArg<Widget>(arg, 'widget', effectiveVisitor),
        );
      } catch (_) {}
    }
  }
  return null;
}

/// Registers interface proxies for [StatelessWidget] and [StatefulWidget]
/// into the [tom_d4rt_ast] interpreter runtime with log interception support.
void registerAstWidgetInterfaceProxies(
  D4rt interpreter, {
  void Function(String message)? onLog,
}) {
  if (onLog != null) {
    onAstGuestLog = onLog;
  }

  // Intercept top-level print calls directly in interpreted scripts
  Object? printHandler(
    InterpreterVisitor visitor,
    List<Object?> positional,
    Map<String, Object?> named,
    List<RuntimeType>? typeArgs,
  ) {
    final msg = positional.isNotEmpty ? positional[0].toString() : '';
    if (onAstGuestLog != null) {
      onAstGuestLog!(msg);
    } else {
      print('[GuestApp] $msg');
    }
    return null;
  }

  interpreter.registertopLevelFunction(
    'print',
    printHandler,
    'package:dartnative/dartnative.dart',
    signature: 'void print(Object? object)',
  );

  D4.registerInterfaceProxy('StatelessWidget', (visitor, instance) {
    return InterpretedStatelessWidget(visitor, instance);
  });

  D4.registerInterfaceProxy('StatefulWidget', (visitor, instance) {
    return InterpretedStatefulWidget(visitor, instance);
  });
}

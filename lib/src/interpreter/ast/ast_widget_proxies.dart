library;

import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
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

/// Native proxy for AST-interpreted classes that extend [ConsumerWidget].
class InterpretedConsumerWidget extends ConsumerWidget {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedConsumerWidget(this.visitor, this.instance, {Key? key})
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
    return ValueKey('Consumer_${instance.klass.name}_gen_$gen');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _runWithLogCapture(() {
      final method = instance.get('build', visitor: visitor);
      if (method is Callable) {
        final rawResult = method.call(visitor, [context, ref], {});
        final widget = D4.extractBridgedArg<Widget>(rawResult, 'buildResult', visitor);
        return widget;
      }
      throw StateError('Interpreted ConsumerWidget has no callable build(context, ref) method');
    });
  }
}

/// Native proxy for AST-interpreted classes that extend [Notifier].
///
/// Riverpod's [NotifierProvider] requires its factory to return a real
/// `Notifier<ValueT>` subclass. When interpreted code supplies
/// `AppStateNotifier.new`, the interpreter returns an [InterpretedInstance].
/// This proxy bridges the gap: it extends `Notifier<dynamic>` and delegates
/// the required [build] method back into the interpreter.
class InterpretedNotifierProxy extends Notifier<dynamic> {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedNotifierProxy(this.visitor, this.instance) {
    // Store the native proxy on the instance so that getter/setter
    // access on `state` routes through this native object.
    instance.nativeProxy = this;
    instance.bridgedSuperObject = this;
  }

  @override
  dynamic build() {
    return _runWithLogCapture(() {
      final method = instance.klass.findInstanceMethod('build');
      if (method != null) {
        final callable = instance.bindMethodCached(method);
        return callable.call(visitor, [], {});
      }
      // Fallback: try dynamic dispatch
      final m2 = instance.get('build', visitor: visitor);
      if (m2 is Callable) {
        return m2.call(visitor, [], {});
      }
      throw StateError(
        'InterpretedNotifierProxy: ${instance.klass.name} has no build() method',
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Route `state` reads/writes from interpreter into the native Notifier state.
  // The interpreter may call `state = value` on the instance; we intercept this
  // via a field override below. Riverpod calls build() on this native object
  // and uses `this.state` to store the result, so no extra wiring is needed
  // for reads.  Writes from interpreted code go through the setter.
  // ---------------------------------------------------------------------------
}

/// Native proxy for AST-interpreted classes that extend [AsyncNotifier].
class InterpretedAsyncNotifierProxy extends AsyncNotifier<dynamic> {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedAsyncNotifierProxy(this.visitor, this.instance) {
    instance.nativeProxy = this;
    instance.bridgedSuperObject = this;
  }

  @override
  FutureOr<dynamic> build() {
    return _runWithLogCapture(() {
      final method = instance.klass.findInstanceMethod('build');
      if (method != null) {
        final callable = instance.bindMethodCached(method);
        return callable.call(visitor, [], {});
      }
      final m2 = instance.get('build', visitor: visitor);
      if (m2 is Callable) {
        return m2.call(visitor, [], {});
      }
      throw StateError(
        'InterpretedAsyncNotifierProxy: ${instance.klass.name} has no build() method',
      );
    });
  }
}

/// Native proxy for AST-interpreted classes that extend [StreamNotifier].
class InterpretedStreamNotifierProxy extends StreamNotifier<dynamic> {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedStreamNotifierProxy(this.visitor, this.instance) {
    instance.nativeProxy = this;
    instance.bridgedSuperObject = this;
  }

  @override
  Stream<dynamic> build() {
    return _runWithLogCapture(() {
      final method = instance.klass.findInstanceMethod('build');
      if (method != null) {
        final callable = instance.bindMethodCached(method);
        final res = callable.call(visitor, [], {});
        return res is Stream<dynamic> ? res : Stream.value(res);
      }
      final m2 = instance.get('build', visitor: visitor);
      if (m2 is Callable) {
        final res = m2.call(visitor, [], {});
        return res is Stream<dynamic> ? res : Stream.value(res);
      }
      throw StateError(
        'InterpretedStreamNotifierProxy: ${instance.klass.name} has no build() method',
      );
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

/// Hot-reload rebind core for [InterpretedConsumerStateProxy].
///
/// AST-engine twin of `rebindConsumerStateForReload` in
/// `../widget_proxies.dart`: recreates the interpreted state from
/// [newOwner]'s (new) interpreter, carries over the previous state's
/// fields, and rewires [proxy] to delegate to it. Throws when the new
/// interpreter cannot produce a state.
void rebindAstConsumerStateForReload(
  InterpretedConsumerStateProxy proxy,
  InterpretedConsumerStatefulWidget newOwner,
) {
  proxy.visitor = newOwner.visitor;
  proxy.ownerWidget = newOwner;
  final createStateMethod =
      newOwner.instance.get('createState', visitor: proxy.visitor);
  if (createStateMethod is! Callable) {
    throw StateError(
      'Hot reload rebind: ${newOwner.instance.klass.name} has no callable createState',
    );
  }
  final newStateResult = createStateMethod.call(proxy.visitor, [], {});
  if (newStateResult is! InterpretedInstance) {
    throw StateError(
      'Hot reload rebind: createState did not return an interpreted state '
      '(got ${newStateResult.runtimeType})',
    );
  }
  proxy.transferStateFields(proxy.stateInstance, newStateResult);
  proxy.wireStateInstance(newStateResult, newOwner.instance);
  proxy.stateInstance = newStateResult;
}

/// Native proxy for AST-interpreted classes that extend [ConsumerStatefulWidget].
///
/// See `../widget_proxies.dart` — `ConsumerStatefulWidget extends
/// StatefulWidget` natively, but the generated `classSupertypes()` table
/// drops that cross-barrel edge, so the generic `StatefulWidget` proxy never
/// matches. Registered under the exact name `ConsumerStatefulWidget`.
class InterpretedConsumerStatefulWidget extends ConsumerStatefulWidget {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedConsumerStatefulWidget(this.visitor, this.instance, {Key? key})
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
    return ValueKey('ConsumerStateful_${instance.klass.name}_gen_$gen');
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _runWithLogCapture(() {
      final method = instance.get('createState', visitor: visitor);
      if (method is Callable) {
        final stateResult = method.call(visitor, [], {});
        if (stateResult is InterpretedInstance) {
          final existing = stateResult.nativeProxy;
          if (existing is ConsumerState<ConsumerStatefulWidget>) {
            return existing;
          }
          return InterpretedConsumerStateProxy(visitor, stateResult, this);
        } else if (stateResult is ConsumerState<ConsumerStatefulWidget>) {
          return stateResult;
        }
      }
      throw StateError('Interpreted ConsumerStatefulWidget failed to create state');
    });
  }
}

/// Native proxy for AST-interpreted classes that extend [ConsumerState].
///
/// Extends the real [ConsumerState] so interpreted code gets the native
/// `ref` getter. Field snapshot/restore cannot synthesize this lifecycle.
class InterpretedConsumerStateProxy extends ConsumerState<ConsumerStatefulWidget> {
  InterpreterVisitor visitor;
  InterpretedInstance stateInstance;
  InterpretedConsumerStatefulWidget? ownerWidget;

  bool _isDispatchingInitState = false;
  bool _isDispatchingDidChangeDependencies = false;
  bool _isDispatchingDidUpdateWidget = false;
  bool _isDispatchingDispose = false;

  InterpretedConsumerStateProxy(this.visitor, this.stateInstance, [this.ownerWidget]) {
    _wireStateInstance(stateInstance, ownerWidget?.instance);
  }

  void _wireStateInstance(InterpretedInstance state, InterpretedInstance? widgetInstance) {
    state.nativeProxy = this;
    state.bridgedSuperObject = this;
    state.nativeStateProxy = this;
    if (widgetInstance != null) {
      state.interpretedStatefulWidget = widgetInstance;
    }
  }

  @override
  void initState() {
    super.initState();
    if (_isDispatchingInitState) return;
    _isDispatchingInitState = true;
    try {
      _runWithLogCapture(() {
        final method = stateInstance.klass.findInstanceMethod('initState');
        if (method != null) {
          stateInstance.bindMethodCached(method).call(visitor, [], {});
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
          stateInstance.bindMethodCached(method).call(visitor, [], {});
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
        if (mounted) setState(fn);
      });
      return;
    }
    try {
      super.setState(fn);
    } catch (_) {
      scheduleMicrotask(() {
        if (mounted) super.setState(fn);
      });
    }
  }

  @override
  void didUpdateWidget(covariant ConsumerStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isDispatchingDidUpdateWidget) return;
    _isDispatchingDidUpdateWidget = true;
    try {
      _runWithLogCapture(() {
        if (widget is InterpretedConsumerStatefulWidget) {
          final newOwner = widget as InterpretedConsumerStatefulWidget;
          try {
            rebindAstConsumerStateForReload(this, newOwner);
            onAstGuestLog?.call(
              '[HotReload] ${newOwner.instance.klass.name} rebound to new '
              'code, state fields preserved',
            );
          } catch (e) {
            onAstGuestLog?.call(
              '[HotReload] rebind failed for '
              '${newOwner.instance.klass.name}: $e — keeping previous state',
            );
            stateInstance.interpretedStatefulWidget = newOwner.instance;
          }
        }
        final method = stateInstance.klass.findInstanceMethod('didUpdateWidget');
        if (method != null) {
          stateInstance.bindMethodCached(method).call(visitor, [oldWidget], {});
        }
        setState(() {});
      });
    } finally {
      _isDispatchingDidUpdateWidget = false;
    }
  }

  /// Re-points [state] at [widgetInstance] (or detaches when null).
  ///
  /// Public so [rebindAstConsumerStateForReload] can share the exact wiring
  /// used at construction.
  void wireStateInstance(
      InterpretedInstance state, InterpretedInstance? widgetInstance) {
    _wireStateInstance(state, widgetInstance);
  }

  /// Copies setState fields from [oldState] to [newState] across reloads.
  ///
  /// Public so [rebindAstConsumerStateForReload] (and tests) share the exact
  /// transfer used by `didUpdateWidget`. Uses the proxy's current visitor
  /// for member reads.
  void transferStateFields(
    InterpretedInstance oldState,
    InterpretedInstance newState,
  ) {
    _transferStateFields(oldState, newState, visitor);
  }

  void _transferStateFields(
    InterpretedInstance oldState,
    InterpretedInstance newState,
    InterpreterVisitor currentVisitor,
  ) {
    try {
      for (final fieldName in oldState.klass.getInstanceFieldNames()) {
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
        return D4.extractBridgedArg<Widget>(rawResult, 'buildResult', visitor);
      }
      throw StateError('Interpreted ConsumerState has no callable build(context) method');
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
          stateInstance.bindMethodCached(method).call(visitor, [], {});
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
      // ConsumerStatefulWidget first: it extends StatefulWidget natively,
      // but the generated supertype table drops that cross-barrel edge.
      var cur = arg.klass;
      while (true) {
        if (cur.name == 'ConsumerStatefulWidget' ||
            cur.bridgedSuperclass?.name == 'ConsumerStatefulWidget') {
          return InterpretedConsumerStatefulWidget(effectiveVisitor, arg);
        }
        if (cur.name == 'ConsumerWidget' || cur.bridgedSuperclass?.name == 'ConsumerWidget') {
          return InterpretedConsumerWidget(effectiveVisitor, arg);
        }
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

/// Registers interface proxies for [StatelessWidget], [StatefulWidget], and
/// [ConsumerWidget] into the [tom_d4rt_ast] interpreter runtime with log interception support.
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

  D4.registerInterfaceProxy('ConsumerWidget', (visitor, instance) {
    return InterpretedConsumerWidget(visitor, instance);
  });

  D4.registerInterfaceProxy('ConsumerStatefulWidget', (visitor, instance) {
    final existing = instance.nativeProxy;
    if (existing is ConsumerStatefulWidget) return existing;
    return InterpretedConsumerStatefulWidget(visitor, instance);
  });

  D4.registerInterfaceProxy('ConsumerState', (visitor, instance) {
    final existing = instance.nativeProxy;
    if (existing is ConsumerState<ConsumerStatefulWidget>) return existing;
    return InterpretedConsumerStateProxy(visitor, instance, null);
  });

  _registerAstConsumerStateSupplements();

  // Register Notifier proxy so NotifierProvider(MyNotifier.new) works.
  // extractBridgedArg<Notifier<dynamic>> will find this proxy factory when
  // it encounters an InterpretedInstance that extends Notifier.
  D4.registerInterfaceProxy('Notifier', (visitor, instance) {
    return InterpretedNotifierProxy(visitor, instance);
  });

  // Belt-and-suspenders: also register as a GenericTypeWrapper so the
  // generic resolution path (Notifier<X>) can wrap the instance too.
  D4.registerGenericTypeWrapper('Notifier', (value, innerTypeArg) {
    if (value is InterpretedInstance) {
      final effectiveVisitor = D4.activeVisitor;
      if (effectiveVisitor != null) {
        return InterpretedNotifierProxy(effectiveVisitor, value);
      }
    }
    return null;
  });
}

/// AST-engine twin of `_registerConsumerStateSupplements` in
/// `../widget_proxies.dart`.
///
/// The analyzer-free `InterpretedInstance.get` consults only the direct
/// bridged superclass (`ConsumerState`, which exposes just `ref`/`dispose`),
/// so `setState`/`initState`/`didChangeDependencies`/`didUpdateWidget`
/// inherited from `State` are unresolvable on interpreted consumer states
/// without these RC-5 adapters.
void _registerAstConsumerStateSupplements() {
  D4.registerSupplementaryMethod(
    'ConsumerState',
    'setState',
    (visitor, target, positional, named, typeArgs) {
      final t = D4.validateTarget<State>(target, 'ConsumerState');
      D4.requireMinArgs(positional, 1, 'setState');
      final fnRaw = positional[0];
      t.setState(() {
        D4.callInterpreterCallback(visitor, fnRaw, []);
      });
      return null;
    },
  );
  D4.registerSupplementaryMethod(
    'ConsumerState',
    'initState',
    (visitor, target, positional, named, typeArgs) {
      final t = D4.validateTarget<State>(target, 'ConsumerState');
      (t as dynamic).initState();
      return null;
    },
  );
  D4.registerSupplementaryMethod(
    'ConsumerState',
    'didChangeDependencies',
    (visitor, target, positional, named, typeArgs) {
      final t = D4.validateTarget<State>(target, 'ConsumerState');
      (t as dynamic).didChangeDependencies();
      return null;
    },
  );
  D4.registerSupplementaryMethod(
    'ConsumerState',
    'didUpdateWidget',
    (visitor, target, positional, named, typeArgs) {
      final t = D4.validateTarget<State>(target, 'ConsumerState');
      D4.requireMinArgs(positional, 1, 'didUpdateWidget');
      final oldWidget = D4.getRequiredArg<StatefulWidget>(
        positional,
        0,
        'oldWidget',
        'didUpdateWidget',
      );
      (t as dynamic).didUpdateWidget(oldWidget);
      return null;
    },
  );
}

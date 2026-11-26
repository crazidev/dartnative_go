import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';

import 'debug_controller.dart';
import 'widget_generation_tracker.dart';
import '../runner/native_bottomsheet_manager.dart';

export 'widget_generation_tracker.dart';

/// Global log handler for interpreted guest code
void Function(String message)? onGuestLog;

R _runWithLogCapture<R>(R Function() action) {
  final handler = onGuestLog;
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

/// Native proxy for interpreted classes that extend [StatelessWidget].
class InterpretedStatelessWidget extends StatelessWidget {
  InterpreterVisitor visitor;
  InterpretedInstance instance;

  InterpretedStatelessWidget(this.visitor, this.instance, {Key? key})
    : super(key: key ?? _resolveKey(instance)) {
    instance.nativeProxy = this;
  }

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    visitor = newVisitor as InterpreterVisitor;
    if (newClass is InterpretedClass) {
      final newInstance = InterpretedInstance(newClass);
      for (final f in instance.klass.getInstanceFieldNames()) {
        try {
          newInstance.set(f, instance.getField(f));
        } catch (_) {}
      }
      newInstance.nativeProxy = this;
      instance = newInstance;
    }
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
        final widget = D4.extractBridgedArg<Widget>(
          rawResult,
          'buildResult',
          visitor,
        );
        return widget;
      }
      throw StateError(
        'Interpreted StatelessWidget has no callable build(context) method',
      );
    });
  }
}

/// Native proxy for interpreted classes that extend [ConsumerWidget].
class InterpretedConsumerWidget extends ConsumerWidget {
  InterpreterVisitor visitor;
  InterpretedInstance instance;

  InterpretedConsumerWidget(this.visitor, this.instance, {Key? key})
    : super(key: key ?? _resolveKey(instance)) {
    instance.nativeProxy = this;
  }

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    visitor = newVisitor as InterpreterVisitor;
    if (newClass is InterpretedClass) {
      final newInstance = InterpretedInstance(newClass);
      for (final f in instance.klass.getInstanceFieldNames()) {
        try {
          newInstance.set(f, instance.getField(f));
        } catch (_) {}
      }
      newInstance.nativeProxy = this;
      instance = newInstance;
    }
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
        final widget = D4.extractBridgedArg<Widget>(
          rawResult,
          'buildResult',
          visitor,
        );
        return widget;
      }
      throw StateError(
        'Interpreted ConsumerWidget has no callable build(context, ref) method',
      );
    });
  }
}

/// Native proxy for interpreted classes that extend [Notifier].
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
}

/// Native proxy for interpreted classes that extend [AsyncNotifier].
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

/// Native proxy for interpreted classes that extend [StreamNotifier].
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

/// Native proxy for interpreted classes that extend [StatefulWidget].
class InterpretedStatefulWidget extends StatefulWidget {
  InterpreterVisitor visitor;
  InterpretedInstance instance;

  InterpretedStatefulWidget(this.visitor, this.instance, {Key? key})
    : super(key: key ?? _resolveKey(instance)) {
    instance.nativeProxy = this;
  }

  void rebindForHotReload(
    InterpreterVisitor newVisitor,
    InterpretedClass newClass,
  ) {
    visitor = newVisitor;
    final newInstance = InterpretedInstance(newClass);
    for (final fieldName in instance.klass.getInstanceFieldNames()) {
      try {
        newInstance.set(fieldName, instance.getField(fieldName));
      } catch (_) {}
    }
    newInstance.nativeProxy = this;
    instance = newInstance;
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

/// Native proxy for interpreted classes that extend [State].
class InterpretedStateProxy extends State<StatefulWidget> {
  InterpreterVisitor visitor;
  InterpretedInstance stateInstance;
  InterpretedStatefulWidget ownerWidget;

  bool _isDispatchingInitState = false;
  bool _isDispatchingDidChangeDependencies = false;
  bool _isDispatchingDidUpdateWidget = false;
  bool _isDispatchingDispose = false;
  NativeBottomSheetScopeState? _sheetScope;
  late final MountedWidgetReloadListener _reloadListener = _onHotReload;

  InterpretedStateProxy(this.visitor, this.stateInstance, this.ownerWidget) {
    _wireStateInstance(stateInstance, ownerWidget.instance);
  }

  void _wireStateInstance(
    InterpretedInstance state,
    InterpretedInstance widgetInstance,
  ) {
    state.nativeProxy = this;
    state.bridgedSuperObject = this;
    state.nativeStateProxy = this;
    state.interpretedStatefulWidget = widgetInstance;
  }

  @override
  void initState() {
    super.initState();
    WidgetGenerationTracker.registerMountedWidget(_reloadListener);
    try {
      final scope = NativeBottomSheetScope.of(context);
      if (scope != null) {
        _sheetScope = scope;
        scope.registerProxy(this);
      }
    } catch (_) {}
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
    try {
      final scope = NativeBottomSheetScope.of(context);
      if (scope != null && scope != _sheetScope) {
        _sheetScope?.unregisterProxy(this);
        _sheetScope = scope;
        scope.registerProxy(this);
      }
    } catch (_) {}
    if (_isDispatchingDidChangeDependencies) return;
    _isDispatchingDidChangeDependencies = true;
    try {
      _runWithLogCapture(() {
        final method = stateInstance.klass.findInstanceMethod(
          'didChangeDependencies',
        );
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
            final createStateMethod = newOwner.instance.get(
              'createState',
              visitor: newVisitor,
            );
            if (createStateMethod is Callable) {
              final newStateResult = createStateMethod.call(newVisitor, [], {});
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
        final method = stateInstance.klass.findInstanceMethod(
          'didUpdateWidget',
        );
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
          // A `late` field is stored as a LateVariable. Copying the wrapper
          // itself makes the next read return the wrapper instead of its value
          // (e.g. TextField received a LateVariable for `controller`), so
          // unwrap it. An uninitialized late field without an initializer
          // throws here and is skipped, leaving the new state's slot untouched.
          if (val is LateVariable) val = val.value;
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
        final widget = D4.extractBridgedArg<Widget>(
          rawResult,
          'buildResult',
          visitor,
        );
        return widget;
      }
      throw StateError(
        'Interpreted State has no callable build(context) method',
      );
    });
  }

  void _rebuildIfMounted() {
    if (!mounted) return;
    try {
      setState(() {});
    } catch (_) {}
  }

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    try {
      visitor = newVisitor as InterpreterVisitor;
      if (newClass is InterpretedClass) {
        final oldState = stateInstance;
        final newState = InterpretedInstance(newClass);
        _transferStateFields(oldState, newState, visitor);
        _wireStateInstance(newState, ownerWidget.instance);
        stateInstance = newState;
      }
    } catch (_) {}
    _rebuildIfMounted();
  }

  void _onHotReload(Object? newVisitor) {
    if (_sheetScope != null || newVisitor is! InterpreterVisitor) return;
    final ownerClass = findUserClassInVisitor(
      newVisitor,
      ownerWidget.instance.klass.name,
    );
    if (ownerClass is! InterpretedClass) {
      onGuestLog?.call(
        '[HotReload] could not find ${ownerWidget.instance.klass.name} '
        'in the updated interpreter',
      );
      return;
    }
    final stateClass = findUserClassInVisitor(
      newVisitor,
      stateInstance.klass.name,
    );
    if (stateClass is! InterpretedClass) {
      onGuestLog?.call(
        '[HotReload] could not find ${stateInstance.klass.name} '
        'in the updated interpreter',
      );
      return;
    }
    ownerWidget.rebindForHotReload(newVisitor, ownerClass);
    rebindForHotReload(newVisitor, stateClass);
  }

  @override
  void dispose() {
    WidgetGenerationTracker.unregisterMountedWidget(_reloadListener);
    _sheetScope?.unregisterProxy(this);
    _sheetScope = null;
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
/// Recreates the interpreted state from [newOwner]'s (new) interpreter,
/// carries over the previous state's fields (e.g. `setState` values like
/// `layout`/`isCreating`), and rewires [proxy] to delegate to it.
///
/// Extracted from `didUpdateWidget` so the mount-dependent parts
/// (`super.didUpdateWidget`, `setState` mark-dirty) stay in the override
/// while this pure interpreter handoff is unit-testable headless with two
/// interpreters. Throws when the new interpreter cannot produce a state
/// (caller falls back to the previous instance and logs).
void rebindConsumerStateForReload(
  InterpretedConsumerStateProxy proxy,
  InterpretedConsumerStatefulWidget newOwner,
) {
  proxy.visitor = newOwner.visitor;
  proxy.ownerWidget = newOwner;
  final createStateMethod = newOwner.instance.get(
    'createState',
    visitor: proxy.visitor,
  );
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

/// Native proxy for interpreted classes that extend [ConsumerStatefulWidget].
///
/// `ConsumerStatefulWidget extends StatefulWidget` (riverpod_kit), but the
/// generated `classSupertypes()` table drops that cross-barrel edge, so the
/// generic `StatefulWidget` proxy never matches. Registered under the exact
/// name `ConsumerStatefulWidget` so `D4.tryCreateInterfaceProxyWithVisitor`
/// resolves `TodoScreen`-style classes passed as `Widget` (e.g.
/// `ProviderScope(child: TodoScreen())`).
class InterpretedConsumerStatefulWidget extends ConsumerStatefulWidget {
  InterpreterVisitor visitor;
  InterpretedInstance instance;

  InterpretedConsumerStatefulWidget(this.visitor, this.instance, {Key? key})
    : super(key: key ?? _resolveKey(instance)) {
    instance.nativeProxy = this;
  }

  void rebindForHotReload(
    InterpreterVisitor newVisitor,
    InterpretedClass newClass,
  ) {
    visitor = newVisitor;
    final newInstance = InterpretedInstance(newClass);
    for (final fieldName in instance.klass.getInstanceFieldNames()) {
      try {
        newInstance.set(fieldName, instance.getField(fieldName));
      } catch (_) {}
    }
    newInstance.nativeProxy = this;
    instance = newInstance;
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
        } else if (stateResult is State<ConsumerStatefulWidget>) {
          // Fallback: plain State returned for a consumer widget — wrap its
          // fields into a consumer proxy so `ref` is available.
          return InterpretedConsumerStateProxy(
            visitor,
            stateResult as dynamic,
            this,
          );
        }
      }
      throw StateError(
        'Interpreted ConsumerStatefulWidget failed to create state',
      );
    });
  }
}

/// Native proxy for interpreted classes that extend [ConsumerState].
///
/// Extends the real [ConsumerState] so interpreted code gets the native
/// `ref` getter (`ConsumerRef(_StateHost(this))`, container lookup,
/// subscription teardown). A plain `State` proxy cannot provide `ref`;
/// field snapshot/restore only copies interpreted fields and cannot
/// synthesize this lifecycle.
class InterpretedConsumerStateProxy
    extends ConsumerState<ConsumerStatefulWidget> {
  InterpreterVisitor visitor;
  InterpretedInstance stateInstance;
  InterpretedConsumerStatefulWidget? ownerWidget;

  bool _isDispatchingInitState = false;
  bool _isDispatchingDidChangeDependencies = false;
  bool _isDispatchingDidUpdateWidget = false;
  bool _isDispatchingDispose = false;
  NativeBottomSheetScopeState? _sheetScope;
  late final MountedWidgetReloadListener _reloadListener = _onHotReload;

  InterpretedConsumerStateProxy(
    this.visitor,
    this.stateInstance, [
    this.ownerWidget,
  ]) {
    _wireStateInstance(stateInstance, ownerWidget?.instance);
  }

  void _wireStateInstance(
    InterpretedInstance state,
    InterpretedInstance? widgetInstance,
  ) {
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
    WidgetGenerationTracker.registerMountedWidget(_reloadListener);
    try {
      final scope = NativeBottomSheetScope.of(context);
      if (scope != null) {
        _sheetScope = scope;
        scope.registerProxy(this);
      }
    } catch (_) {}
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
    try {
      final scope = NativeBottomSheetScope.of(context);
      if (scope != null && scope != _sheetScope) {
        _sheetScope?.unregisterProxy(this);
        _sheetScope = scope;
        scope.registerProxy(this);
      }
    } catch (_) {}
    if (_isDispatchingDidChangeDependencies) return;
    _isDispatchingDidChangeDependencies = true;
    try {
      _runWithLogCapture(() {
        final method = stateInstance.klass.findInstanceMethod(
          'didChangeDependencies',
        );
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
            rebindConsumerStateForReload(this, newOwner);
            onGuestLog?.call(
              '[HotReload] ${newOwner.instance.klass.name} rebound to new '
              'code, state fields preserved',
            );
          } catch (e) {
            // Never leave the UI silently stale: the previous instance is
            // bound to the disposed interpreter, so surface the cause.
            onGuestLog?.call(
              '[HotReload] rebind failed for '
              '${newOwner.instance.klass.name}: $e — keeping previous state',
            );
            stateInstance.interpretedStatefulWidget = newOwner.instance;
          }
        }
        final method = stateInstance.klass.findInstanceMethod(
          'didUpdateWidget',
        );
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
  /// Public so [rebindConsumerStateForReload] can share the exact wiring
  /// used at construction.
  void wireStateInstance(
    InterpretedInstance state,
    InterpretedInstance? widgetInstance,
  ) {
    _wireStateInstance(state, widgetInstance);
  }

  /// Copies setState fields from [oldState] to [newState] across reloads.
  ///
  /// Public so [rebindConsumerStateForReload] (and tests) share the exact
  /// transfer used by [didUpdateWidget]. Uses the proxy's current visitor
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
          // A `late` field is stored as a LateVariable. Copying the wrapper
          // itself makes the next read return the wrapper instead of its value
          // (e.g. TextField received a LateVariable for `controller`), so
          // unwrap it. An uninitialized late field without an initializer
          // throws here and is skipped, leaving the new state's slot untouched.
          if (val is LateVariable) val = val.value;
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
      throw StateError(
        'Interpreted ConsumerState has no callable build(context) method',
      );
    });
  }

  void _rebuildIfMounted() {
    if (!mounted) return;
    try {
      setState(() {});
    } catch (_) {}
  }

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    try {
      visitor = newVisitor as InterpreterVisitor;
      if (newClass is InterpretedClass) {
        final oldState = stateInstance;
        final newState = InterpretedInstance(newClass);
        _transferStateFields(oldState, newState, visitor);
        _wireStateInstance(newState, ownerWidget?.instance);
        stateInstance = newState;
      }
    } catch (_) {}
    _rebuildIfMounted();
  }

  void _onHotReload(Object? newVisitor) {
    if (_sheetScope != null || newVisitor is! InterpreterVisitor) return;
    final owner = ownerWidget;
    if (owner != null) {
      final ownerClass = findUserClassInVisitor(
        newVisitor,
        owner.instance.klass.name,
      );
      if (ownerClass is! InterpretedClass) {
        onGuestLog?.call(
          '[HotReload] could not find ${owner.instance.klass.name} '
          'in the updated interpreter',
        );
        return;
      }
      owner.rebindForHotReload(newVisitor, ownerClass);
    }
    final stateClass = findUserClassInVisitor(
      newVisitor,
      stateInstance.klass.name,
    );
    if (stateClass is! InterpretedClass) {
      onGuestLog?.call(
        '[HotReload] could not find ${stateInstance.klass.name} '
        'in the updated interpreter',
      );
      return;
    }
    rebindForHotReload(newVisitor, stateClass);
  }

  @override
  void dispose() {
    WidgetGenerationTracker.unregisterMountedWidget(_reloadListener);
    _sheetScope?.unregisterProxy(this);
    _sheetScope = null;
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

/// Resolves and wraps an interpreted widget or native proxy into a native [Widget].
Widget? wrapInterpretedWidget(Object? arg, {InterpreterVisitor? visitor}) {
  if (arg == null) return null;
  if (arg is Widget) return arg;
  if (arg is InterpretedInstance) {
    if (arg.nativeProxy is Widget) return arg.nativeProxy as Widget;
    if (arg.bridgedSuperObject is Widget) {
      return arg.bridgedSuperObject as Widget;
    }
    final effectiveVisitor = visitor ?? D4.activeVisitor;
    if (effectiveVisitor != null) {
      // Walk class inheritance chain to find Consumer/Stateful/Stateless widgets.
      // ConsumerStatefulWidget is checked first: it extends StatefulWidget
      // natively, but the generated supertype table drops that cross-barrel
      // edge, so a StatefulWidget-only check would miss TodoScreen-style
      // classes whose direct bridged super is ConsumerStatefulWidget.
      var cur = arg.klass;
      while (true) {
        if (cur.name == 'ConsumerStatefulWidget' ||
            cur.bridgedSuperclass?.name == 'ConsumerStatefulWidget') {
          return InterpretedConsumerStatefulWidget(effectiveVisitor, arg);
        }
        if (cur.name == 'ConsumerWidget' ||
            cur.bridgedSuperclass?.name == 'ConsumerWidget') {
          return InterpretedConsumerWidget(effectiveVisitor, arg);
        }
        if (cur.name == 'StatefulWidget' ||
            cur.bridgedSuperclass?.name == 'StatefulWidget') {
          return InterpretedStatefulWidget(effectiveVisitor, arg);
        }
        if (cur.name == 'StatelessWidget' ||
            cur.bridgedSuperclass?.name == 'StatelessWidget') {
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

/// Native proxy for source-engine classes that are [TickerProvider]s.
///
/// Mirror of `InterpretedTickerProvider` in `ast/ast_widget_proxies.dart`:
/// `SingleTickerProviderStateMixin` / `TickerProviderStateMixin` list
/// `TickerProvider` in their bridged supertypes, so one registration serves
/// both, and `AnimationController(vsync: this)` stops failing with
/// `expected TickerProvider?, got InterpretedInstance(_…State)`.
class InterpretedTickerProvider implements TickerProvider, D4InterpretedProxy {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedTickerProvider(this.visitor, this.instance);

  @override
  Object get d4rtInstance => instance;

  @override
  Ticker createTicker(TickerCallback onTick) {
    // Honour a script override; the mixin bridge's createTicker is not an
    // InterpretedFunction, so this only finds a guest-declared method.
    final method = instance.klass.findInstanceMethod('createTicker');
    if (method != null) {
      final result = instance
          .bindMethodCached(method)
          .call(visitor, [onTick], {});
      if (result is Ticker) return result;
    }
    return Ticker(onTick);
  }
}

/// Native proxy for source-engine classes that mix in
/// [WidgetsBindingObserver].
///
/// Mirror of `InterpretedWidgetsBindingObserver` in
/// `ast/ast_widget_proxies.dart`: dispatch reads the guest's own methods only,
/// so the bridged mixin adapter (which would call back into this proxy)
/// cannot recurse, and equality by guest instance lets `removeObserver(this)`
/// pair with the proxy `addObserver` kept.
class InterpretedWidgetsBindingObserver extends WidgetsBindingObserver
    implements D4InterpretedProxy {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedWidgetsBindingObserver(this.visitor, this.instance);

  @override
  Object get d4rtInstance => instance;

  void _dispatch(String name, List<Object?> args) {
    final method = instance.klass.findInstanceMethod(name);
    if (method == null) return;
    _runWithLogCapture(
      () => instance.bindMethodCached(method).call(visitor, args, {}),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      _dispatch('didChangeAppLifecycleState', [state]);

  @override
  void didChangeMetrics() => _dispatch('didChangeMetrics', const []);

  @override
  void didChangePlatformBrightness() =>
      _dispatch('didChangePlatformBrightness', const []);

  @override
  void didChangeAccessibilityFeatures() =>
      _dispatch('didChangeAccessibilityFeatures', const []);

  @override
  void didHaveMemoryPressure() => _dispatch('didHaveMemoryPressure', const []);

  @override
  bool operator ==(Object other) =>
      other is InterpretedWidgetsBindingObserver &&
      identical(other.instance, instance);

  @override
  int get hashCode => identityHashCode(instance);
}

/// Native proxy for source-engine [CustomPainter] subclasses.
///
/// Mirror of `InterpretedCustomPainter` in `ast/ast_widget_proxies.dart`.
/// Only members the guest declares are forwarded: `preferredHeight` is not
/// abstract and the base implementation throws `UnimplementedError`, so a
/// painter that does not override it must get `null`.
class InterpretedCustomPainter extends CustomPainter
    implements D4InterpretedProxy {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedCustomPainter(this.visitor, this.instance)
    : super(repaint: _repaintOf(instance));

  /// `super(repaint: …)` from the guest constructor, when it passed one. The
  /// super-call is skipped for a proxy-backed abstract base, so the argument
  /// is only available because `CustomPainter` is marked as super-arg
  /// capturing at registration.
  static Listenable? _repaintOf(InterpretedInstance instance) {
    final captured = instance.superCallNamedArgs?['repaint'];
    return captured is Listenable ? captured : null;
  }

  @override
  Object get d4rtInstance => instance;

  @override
  void paint(Canvas canvas, Size size) {
    final method = instance.klass.findInstanceMethod('paint');
    if (method == null) return;
    _runWithLogCapture(
      () => instance.bindMethodCached(method).call(visitor, [
        canvas,
        size,
      ], {}),
    );
  }

  @override
  double? preferredHeight(double availableWidth) {
    final method = instance.klass.findInstanceMethod('preferredHeight');
    if (method == null) return null;
    final result = _runWithLogCapture(
      () => instance.bindMethodCached(method).call(visitor, [
        availableWidth,
      ], {}),
    );
    return result is num ? result.toDouble() : null;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final method = instance.klass.findInstanceMethod('shouldRepaint');
    if (method == null) return true;
    // The parameter is `covariant CustomPainter`, so a script reads its own
    // fields off it (`oldDelegate.progress`) — pass the guest instance, not
    // the proxy.
    final CustomPainter delegate = oldDelegate;
    final previous = delegate is D4InterpretedProxy
        ? (delegate as D4InterpretedProxy).d4rtInstance
        : delegate;
    final result = _runWithLogCapture(
      () => instance.bindMethodCached(method).call(visitor, [previous], {}),
    );
    return result == true;
  }
}

/// Registers interface proxies for [StatelessWidget], [StatefulWidget], and
/// [ConsumerWidget] into the [tom_d4rt] interpreter runtime with log interception support.
void registerWidgetInterfaceProxies(
  D4rt interpreter, {
  void Function(String message)? onLog,
}) {
  if (onLog != null) {
    onGuestLog = onLog;
  }

  // Intercept top-level print calls directly in interpreted scripts
  Object? printHandler(
    InterpreterVisitor visitor,
    List<Object?> positional,
    Map<String, Object?> named,
    List<RuntimeType>? typeArgs,
  ) {
    final msg = positional.isNotEmpty ? positional[0].toString() : '';
    if (onGuestLog != null) {
      onGuestLog!(msg);
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

  // `AnimationController(vsync: this)` from a State using
  // `SingleTickerProviderStateMixin` / `TickerProviderStateMixin`. Both mixin
  // bridges list `TickerProvider` in their supertypes, so one registration
  // serves both.
  D4.registerInterfaceProxy('TickerProvider', (visitor, instance) {
    return InterpretedTickerProvider(visitor, instance);
  });

  // `WidgetsBinding.instance.addObserver(this)` from a State mixing in
  // `WidgetsBindingObserver`. Equality is by guest instance (see the class) so
  // `removeObserver(this)` pairs with the observer `addObserver` kept.
  D4.registerInterfaceProxy('WidgetsBindingObserver', (visitor, instance) {
    return InterpretedWidgetsBindingObserver(visitor, instance);
  });

  // `CustomPaint(painter: …)` / `CanvasSurface(painter: …)`. Cached on the
  // instance so the same painter object comes back for the same guest painter
  // (the framework compares painters between builds).
  D4.registerInterfaceProxy('CustomPainter', (visitor, instance) {
    final existing = instance.nativeProxy;
    if (existing is CustomPainter) return existing;
    return InterpretedCustomPainter(visitor, instance);
  });
  // `super(repaint: …)` is skipped for the abstract base (no constructor
  // adapter), so the argument has to be captured for the proxy to honour it.
  D4.markProxyCapturesSuperArgs('CustomPainter');

  D4.registerInterfaceProxy('ConsumerWidget', (visitor, instance) {
    return InterpretedConsumerWidget(visitor, instance);
  });

  // Exact-name registration for the riverpod_kit intermediate base. The
  // generated classSupertypes() table omits
  // ConsumerStatefulWidget -> StatefulWidget, so the StatefulWidget factory
  // above never fires for TodoScreen-style classes. Registering under the
  // exact bridged-superclass name bypasses the supertype walk.
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

  _registerConsumerStateSupplements();

  // Register Notifier proxy so NotifierProvider(MyNotifier.new) works.
  D4.registerInterfaceProxy('Notifier', (visitor, instance) {
    return InterpretedNotifierProxy(visitor, instance);
  });

  // Belt-and-suspenders: generic wrapper for Notifier<X> resolution.
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

/// Closes the inherited-member gap for interpreted `ConsumerState`
/// subclasses (e.g. `_TodoScreenState`).
///
/// Member lookup (`InterpretedInstance.get`) consults only each level's
/// DIRECT bridged superclass — never the native chain — and the generated
/// `ConsumerState` bridge carries just `ref`/`dispose`. Without these,
/// `setState(...)` inside an interpreted consumer state throws
/// `Undefined property 'setState' on _TodoScreenState` on tap.
///
/// RC-5 supplementary adapters fill the gap with the generated `State`
/// semantics; the native target is the `InterpretedConsumerStateProxy`,
/// which IS a `State`, so `validateTarget<State>` accepts it and
/// `setState` routes through the proxy's mounted-guarded override.
void _registerConsumerStateSupplements() {
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

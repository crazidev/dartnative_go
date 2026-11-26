library;

import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:tom_d4rt_ast/d4rt.dart';

import '../debug_controller.dart';
import '../widget_generation_tracker.dart';
import '../../runner/native_bottomsheet_manager.dart';

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

/// Reports guest code that threw inside a framework callback (a build, a
/// lifecycle method, `createState`) so the host can surface it in its own
/// diagnostics — the `dart_go` CLI included.
void Function(Object error, StackTrace stack)? onAstGuestError;

/// Reports a guest build that failed before the proxy ever rendered a child —
/// the screen (or slot) is blank, so the host must take over with its
/// full-screen error view instead of an overlay banner over a working tree.
///
/// Fires just before [onAstGuestError] for the same failure and only refines
/// *how* the host shows it: it must not log or report the error a second time.
///
/// [rebuildsInPlace] says whether a later hot reload can repair this surface on
/// its own: a `State` proxy is registered with the hot-reload tracker and is
/// marked dirty, so fixed code repaints it. A stateless proxy has no State to
/// mark, so the host has to remount the guest tree instead.
void Function(
  Object error,
  StackTrace stack, {
  required bool rebuildsInPlace,
})?
onAstGuestBlankBuild;

/// Reports that a proxy which previously left its surface blank now built a
/// child again.
///
/// The host keeps the full-screen error view up until this fires (or a new
/// failure replaces it), so a fixed screen never flashes blank while the view
/// is being removed.
void Function()? onAstGuestRecovered;

R _runWithLogCapture<R>(R Function() action, {bool reportError = true}) {
  try {
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
  } catch (error, stack) {
    if (reportError) _reportGuestError(error, stack);
    rethrow;
  }
}

/// Sends [error] to [onAstGuestError] with the guest stack when the engine
/// carries one.
///
/// Build proxies defer this call to their own `catch` so a failure that left
/// no rendered child can report the blank surface first (see
/// [onAstGuestBlankBuild]) and then publish the message once.
void _reportGuestError(Object error, StackTrace stack) {
  final report = onAstGuestError;
  if (report == null) return;
  try {
    final guestStack =
        (error is D4rtException &&
            error.guestStackTrace != null &&
            error.guestStackTrace!.isNotEmpty)
        ? StackTrace.fromString(error.guestStackTrace!)
        : stack;
    report(error, guestStack);
  } catch (_) {}
}

/// Tells the host that a blank surface renders again (see
/// [onAstGuestRecovered]).
void _notifyGuestRecovered() {
  try {
    onAstGuestRecovered?.call();
  } catch (_) {}
}

/// Placeholder for a monitored build that threw before producing a child.
///
/// The host already received the failure and shows its error surface next
/// frame; rethrowing would flash the framework's red screen in between.
/// Without a listener the proxy rethrows instead.
const Widget _failedBuildPlaceholder = SizedBox.shrink();

/// Native proxy for AST-interpreted classes that extend [StatelessWidget].
class InterpretedStatelessWidget extends StatelessWidget
    implements D4InterpretedProxy {
  InterpreterVisitor visitor;
  InterpretedInstance instance;

  /// Last successful child; rendered when a later build throws.
  /// Before the first success, [_failedBuildPlaceholder] is used instead.
  Widget? _lastGoodChild;

  /// True when the last build left [_failedBuildPlaceholder]; the next
  /// success reports recovery via [_notifyGuestRecovered].
  bool _blankFailed = false;

  /// Last blank-surface failure signature; suppresses per-frame repeats.
  String? _blankErrorSignature;

  /// A stateless widget has no state to mark; a parent rebuild (or the sheet's
  /// per-reload subtree key) is what re-runs its build.
  void markNeedsRebuild() {}

  @override
  Object get d4rtInstance => instance;

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
    try {
      final built = _runWithLogCapture(() {
        final method = instance.get('build', visitor: visitor);
        if (method is Callable) {
          final rawResult = method.call(visitor, [context], {});
          // `wrapAstInterpretedWidget` first: a build result may be an
          // interpreted subclass of an abstract widget (InheritedWidget,
          // CustomPainter host widgets, …) that `extractBridgedArg` cannot
          // coerce because there is no native instance to unwrap.
          final widget =
              wrapAstInterpretedWidget(rawResult, visitor: visitor) ??
              D4.extractBridgedArg<Widget>(
                rawResult,
                'buildResult',
                visitor,
              );
          return widget;
        }
        throw StateError(
          'Interpreted StatelessWidget has no callable build(context) method',
        );
      }, reportError: false);
      _lastGoodChild = built;
      if (_blankFailed) {
        _blankFailed = false;
        _blankErrorSignature = null;
        _notifyGuestRecovered();
      }
      return built;
    } catch (error, stack) {
      final cached = _lastGoodChild;
      if (cached != null) {
        // The working UI stays up; report the failure for the banner.
        _reportGuestError(error, stack);
        return cached;
      }
      // Monitored blank failure: placeholder instead of framework red screen.
      if (onAstGuestError == null) rethrow;
      // Report once per distinct message; repeat rebuilds stay quiet.
      final signature = error.toString();
      final isRepeat = _blankFailed && _blankErrorSignature == signature;
      _blankFailed = true;
      _blankErrorSignature = signature;
      if (isRepeat) return _failedBuildPlaceholder;
      onAstGuestBlankBuild?.call(
        error,
        stack,
        rebuildsInPlace: false,
      );
      _reportGuestError(error, stack);
      return _failedBuildPlaceholder;
    }
  }
}

/// Native proxy for AST-interpreted classes that extend [ConsumerWidget].
class InterpretedConsumerWidget extends ConsumerWidget
    implements D4InterpretedProxy {
  InterpreterVisitor visitor;
  InterpretedInstance instance;

  @override
  Object get d4rtInstance => instance;

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

  /// See [InterpretedStatelessWidget._lastGoodChild].
  Widget? _lastGoodChild;

  /// True when the last build left [_failedBuildPlaceholder]; the next
  /// success reports recovery via [_notifyGuestRecovered].
  bool _blankFailed = false;

  /// Last blank-surface failure signature; suppresses per-frame repeats.
  String? _blankErrorSignature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final built = _runWithLogCapture(() {
        final method = instance.get('build', visitor: visitor);
        if (method is Callable) {
          final rawResult = method.call(visitor, [context, ref], {});
          // `wrapAstInterpretedWidget` first: a build result may be an
          // interpreted subclass of an abstract widget (InheritedWidget,
          // CustomPainter host widgets, …) that `extractBridgedArg` cannot
          // coerce because there is no native instance to unwrap.
          final widget =
              wrapAstInterpretedWidget(rawResult, visitor: visitor) ??
              D4.extractBridgedArg<Widget>(
                rawResult,
                'buildResult',
                visitor,
              );
          return widget;
        }
        throw StateError(
          'Interpreted ConsumerWidget has no callable build(context, ref) method',
        );
      }, reportError: false);
      _lastGoodChild = built;
      if (_blankFailed) {
        _blankFailed = false;
        _blankErrorSignature = null;
        _notifyGuestRecovered();
      }
      return built;
    } catch (error, stack) {
      final cached = _lastGoodChild;
      if (cached != null) {
        // The working UI stays up; report the failure for the banner.
        _reportGuestError(error, stack);
        return cached;
      }
      // Monitored blank failure: placeholder instead of framework red screen.
      if (onAstGuestError == null) rethrow;
      // Report once per distinct message; repeat rebuilds stay quiet.
      final signature = error.toString();
      final isRepeat = _blankFailed && _blankErrorSignature == signature;
      _blankFailed = true;
      _blankErrorSignature = signature;
      if (isRepeat) return _failedBuildPlaceholder;
      onAstGuestBlankBuild?.call(
        error,
        stack,
        rebuildsInPlace: false,
      );
      _reportGuestError(error, stack);
      return _failedBuildPlaceholder;
    }
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
class InterpretedStatefulWidget extends StatefulWidget
    implements D4InterpretedProxy {
  InterpreterVisitor visitor;
  InterpretedInstance instance;

  @override
  Object get d4rtInstance => instance;

  InterpretedStatefulWidget(this.visitor, this.instance, {Key? key})
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
    return ValueKey('Stateful_${instance.klass.name}_gen_$gen');
  }

  /// The state proxy this widget last created.
  ///
  /// A bottom sheet's content lives in its own reconciler, where the framework
  /// gives the child no new widget object on reload. Rebuilding it therefore
  /// means marking that state dirty, and the sheet's scope cannot reach it
  /// through the element tree alone.
  InterpretedStateProxy? lastStateProxy;

  void markNeedsRebuild() {
    lastStateProxy?.markNeedsRebuild();
  }

  @override
  State<StatefulWidget> createState() {
    return _runWithLogCapture(() {
      final method = instance.get('createState', visitor: visitor);
      if (method is Callable) {
        final stateResult = method.call(visitor, [], {});
        if (stateResult is InterpretedInstance) {
          final proxy = InterpretedStateProxy(visitor, stateResult, this);
          lastStateProxy = proxy;
          return proxy;
        } else if (stateResult is State<StatefulWidget>) {
          return stateResult;
        }
      }
      throw StateError('Interpreted StatefulWidget failed to create state');
    });
  }
}

/// Native proxy for AST-interpreted classes that extend [State].
class InterpretedStateProxy extends State<StatefulWidget>
    implements D4InterpretedProxy {
  InterpreterVisitor visitor;
  InterpretedInstance stateInstance;
  InterpretedStatefulWidget ownerWidget;

  @override
  Object get d4rtInstance => stateInstance;

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
          if (val is LateVariable) val = val.value;
          // A `late` field is stored as a LateVariable. Copying the wrapper
          // itself makes the next read return the wrapper instead of its value
          // (e.g. TextField received a LateVariable for `controller`), so
          // unwrap it. An uninitialized late field without an initializer
          // throws here and is skipped, leaving the new state's slot untouched.
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

  /// See [InterpretedStatelessWidget._lastGoodChild].
  Widget? _lastGoodChild;

  /// True when the last build left [_failedBuildPlaceholder]; the next
  /// success reports recovery via [_notifyGuestRecovered].
  bool _blankFailed = false;

  /// Last blank-surface failure signature; suppresses per-frame repeats.
  String? _blankErrorSignature;

  @override
  Widget build(BuildContext context) {
    try {
      final built = _runWithLogCapture(() {
        final method = stateInstance.get('build', visitor: visitor);
        if (method is Callable) {
          final rawResult = method.call(visitor, [context], {});
          // `wrapAstInterpretedWidget` first: a build result may be an
          // interpreted subclass of an abstract widget (InheritedWidget,
          // CustomPainter host widgets, …) that `extractBridgedArg` cannot
          // coerce because there is no native instance to unwrap.
          final widget =
              wrapAstInterpretedWidget(rawResult, visitor: visitor) ??
              D4.extractBridgedArg<Widget>(
                rawResult,
                'buildResult',
                visitor,
              );
          return widget;
        }
        throw StateError(
          'Interpreted State has no callable build(context) method',
        );
      }, reportError: false);
      _lastGoodChild = built;
      if (_blankFailed) {
        _blankFailed = false;
        _blankErrorSignature = null;
        _notifyGuestRecovered();
      }
      return built;
    } catch (error, stack) {
      final cached = _lastGoodChild;
      if (cached != null) {
        // The working UI stays up; report the failure for the banner.
        _reportGuestError(error, stack);
        return cached;
      }
      // Monitored blank failure: placeholder instead of framework red screen.
      if (onAstGuestError == null) rethrow;
      // Report once per distinct message; repeat rebuilds stay quiet.
      final signature = error.toString();
      final isRepeat = _blankFailed && _blankErrorSignature == signature;
      _blankFailed = true;
      _blankErrorSignature = signature;
      if (isRepeat) return _failedBuildPlaceholder;
      onAstGuestBlankBuild?.call(
        error,
        stack,
        rebuildsInPlace: true,
      );
      _reportGuestError(error, stack);
      return _failedBuildPlaceholder;
    }
  }

  void _rebuildIfMounted() {
    // `mounted` is a native accessor; treat a host stub (or a disposed state)
    // as "not mounted" instead of throwing out of the reload path.
    bool isMounted;
    try {
      isMounted = mounted;
    } catch (_) {
      isMounted = false;
    }
    if (!isMounted) return;
    try {
      setState(() {});
    } catch (_) {}
  }

  /// Marks this proxy dirty so its build runs again — used by a bottom sheet
  /// whose child widget object never changes across a reload.
  void markNeedsRebuild() {
    _rebuildIfMounted();
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
      onAstGuestLog?.call(
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
      onAstGuestLog?.call(
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

/// Native proxy for AST-interpreted classes that extend [ConsumerStatefulWidget].
///
/// See `../widget_proxies.dart` — `ConsumerStatefulWidget extends
/// StatefulWidget` natively, but the generated `classSupertypes()` table
/// drops that cross-barrel edge, so the generic `StatefulWidget` proxy never
/// matches. Registered under the exact name `ConsumerStatefulWidget`.
class InterpretedConsumerStatefulWidget extends ConsumerStatefulWidget
    implements D4InterpretedProxy {
  InterpreterVisitor visitor;
  InterpretedInstance instance;

  @override
  Object get d4rtInstance => instance;

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
        }
      }
      throw StateError(
        'Interpreted ConsumerStatefulWidget failed to create state',
      );
    });
  }
}

/// Native proxy for AST-interpreted classes that extend [ConsumerState].
///
/// Extends the real [ConsumerState] so interpreted code gets the native
/// `ref` getter. Field snapshot/restore cannot synthesize this lifecycle.
class InterpretedConsumerStateProxy
    extends ConsumerState<ConsumerStatefulWidget>
    implements D4InterpretedProxy {
  InterpreterVisitor visitor;
  InterpretedInstance stateInstance;
  InterpretedConsumerStatefulWidget? ownerWidget;

  @override
  Object get d4rtInstance => stateInstance;

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
  /// Public so [rebindAstConsumerStateForReload] can share the exact wiring
  /// used at construction.
  void wireStateInstance(
    InterpretedInstance state,
    InterpretedInstance? widgetInstance,
  ) {
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
          if (val is LateVariable) val = val.value;
          // A `late` field is stored as a LateVariable. Copying the wrapper
          // itself makes the next read return the wrapper instead of its value
          // (e.g. TextField received a LateVariable for `controller`), so
          // unwrap it. An uninitialized late field without an initializer
          // throws here and is skipped, leaving the new state's slot untouched.
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

  /// See [InterpretedStatelessWidget._lastGoodChild].
  Widget? _lastGoodChild;

  /// True when the last build left [_failedBuildPlaceholder]; the next
  /// success reports recovery via [_notifyGuestRecovered].
  bool _blankFailed = false;

  /// Last blank-surface failure signature; suppresses per-frame repeats.
  String? _blankErrorSignature;

  @override
  Widget build(BuildContext context) {
    try {
      final built = _runWithLogCapture(() {
        final method = stateInstance.get('build', visitor: visitor);
        if (method is Callable) {
          final rawResult = method.call(visitor, [context], {});
          return wrapAstInterpretedWidget(rawResult, visitor: visitor) ??
              D4.extractBridgedArg<Widget>(
                rawResult,
                'buildResult',
                visitor,
              );
        }
        throw StateError(
          'Interpreted ConsumerState has no callable build(context) method',
        );
      }, reportError: false);
      _lastGoodChild = built;
      if (_blankFailed) {
        _blankFailed = false;
        _blankErrorSignature = null;
        _notifyGuestRecovered();
      }
      return built;
    } catch (error, stack) {
      final cached = _lastGoodChild;
      if (cached != null) {
        // The working UI stays up; report the failure for the banner.
        _reportGuestError(error, stack);
        return cached;
      }
      // Monitored blank failure: placeholder instead of framework red screen.
      if (onAstGuestError == null) rethrow;
      // Report once per distinct message; repeat rebuilds stay quiet.
      final signature = error.toString();
      final isRepeat = _blankFailed && _blankErrorSignature == signature;
      _blankFailed = true;
      _blankErrorSignature = signature;
      if (isRepeat) return _failedBuildPlaceholder;
      onAstGuestBlankBuild?.call(
        error,
        stack,
        rebuildsInPlace: true,
      );
      _reportGuestError(error, stack);
      return _failedBuildPlaceholder;
    }
  }

  void _rebuildIfMounted() {
    // `mounted` is a native accessor; treat a host stub (or a disposed state)
    // as "not mounted" instead of throwing out of the reload path.
    bool isMounted;
    try {
      isMounted = mounted;
    } catch (_) {
      isMounted = false;
    }
    if (!isMounted) return;
    try {
      setState(() {});
    } catch (_) {}
  }

  /// Marks this proxy dirty so its build runs again — used by a bottom sheet
  /// whose child widget object never changes across a reload.
  void markNeedsRebuild() {
    _rebuildIfMounted();
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
        onAstGuestLog?.call(
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
      onAstGuestLog?.call(
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

/// Resolves and wraps an AST-interpreted widget or native proxy into a native [Widget].
Widget? wrapAstInterpretedWidget(Object? arg, {InterpreterVisitor? visitor}) {
  if (arg == null) return null;
  if (arg is Widget) return arg;
  if (arg is InterpretedInstance) {
    if (arg.nativeProxy is Widget) return arg.nativeProxy as Widget;
    if (arg.bridgedSuperObject is Widget) {
      return arg.bridgedSuperObject as Widget;
    }
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
        if (cur.name == 'InheritedWidget' ||
            cur.bridgedSuperclass?.name == 'InheritedWidget') {
          return InterpretedInheritedWidget(effectiveVisitor, arg);
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

/// Native proxy for AST-interpreted classes that extend [InheritedWidget].
///
/// `InheritedWidget` is abstract, so the interpreter cannot build a native
/// super-object for a guest subclass — `bridgedSuperObject` stays null and the
/// instance is not a `Widget`. Without this proxy, any guest that publishes
/// state through an inherited widget (`PlaygroundTheme.of(context)`,
/// `MyScope.of(context)`, …) fails its parent's build with
/// `Invalid parameter "buildResult": expected Widget, got
/// InterpretedInstance(PlaygroundTheme)`.
///
/// `child` comes from the guest instance; `updateShouldNotify` is forwarded to
/// the interpreted method (defaulting to `true`, the safe answer: rebuild).
class InterpretedInheritedWidget extends InheritedWidget
    implements D4InterpretedProxy {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedInheritedWidget(this.visitor, this.instance, {Key? key})
    : super(
        key: key ?? _keyFor(instance),
        child: _childFor(visitor, instance),
      ) {
    instance.nativeProxy = this;
  }

  static Key _keyFor(InterpretedInstance instance) =>
      ValueKey('Inherited_${instance.klass.name}');

  static Widget _childFor(
    InterpreterVisitor visitor,
    InterpretedInstance instance,
  ) {
    Object? raw;
    try {
      if (instance.hasInstanceMember('child')) {
        raw = instance.get('child', visitor: visitor);
      }
    } catch (_) {}
    return wrapAstInterpretedWidget(raw, visitor: visitor) ??
        const SizedBox.shrink();
  }

  @override
  Object get d4rtInstance => instance;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    try {
      final method = instance.get('updateShouldNotify', visitor: visitor);
      if (method is Callable) {
        final previous = oldWidget is InterpretedInheritedWidget
            ? oldWidget.instance
            : oldWidget;
        final result = method.call(visitor, [previous], {});
        return result == true;
      }
    } catch (_) {}
    // Unknown: rebuild dependants rather than silently keep stale state.
    return true;
  }
}

/// Native proxy for AST-interpreted classes that are [TickerProvider]s.
///
/// `class _DemoState extends State<Demo> with SingleTickerProviderStateMixin`
/// records the bridged mixin, and the mixin bridge declares
/// `TickerProvider` in its supertypes — so `tryCreateInterfaceProxyWithVisitor`
/// reaches this factory for both `SingleTickerProviderStateMixin` and
/// `TickerProviderStateMixin` states.
///
/// Without it `AnimationController(vsync: this)` fails with
/// `Invalid parameter "vsync": expected TickerProvider?, got
/// InterpretedInstance(_DemoState)`.
///
/// The ticker is the framework's own (`Ticker(onTick)`): its constructor is
/// real, only its lifecycle methods are supplied by the platform, so building
/// one here is exactly what a native `State` does.
class InterpretedTickerProvider implements TickerProvider, D4InterpretedProxy {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedTickerProvider(this.visitor, this.instance);

  @override
  Object get d4rtInstance => instance;

  @override
  Ticker createTicker(TickerCallback onTick) {
    // A script may override createTicker(); honour it when it does. The mixin
    // bridge's own `createTicker` is not an InterpretedFunction, so
    // findInstanceMethod only returns a method the guest actually declared.
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

/// Native proxy for AST-interpreted classes that mix in
/// [WidgetsBindingObserver].
///
/// `WidgetsBinding.instance.addObserver(this)` takes a native
/// `WidgetsBindingObserver`; a `State` mixed with the observer mixin is an
/// `InterpretedInstance`, so the bridge rejects it with
/// `expected WidgetsBindingObserver, got InterpretedInstance(_…State)`.
///
/// Dispatch looks at the **guest's own methods** only
/// ([InterpretedClass.findInstanceMethod]), never the bridged mixin adapter:
/// the adapter validates against this proxy and would call straight back into
/// [didChangeAppLifecycleState], recursing forever.
///
/// Equality is by guest instance so the binding's `removeObserver(this)` can
/// pair with the proxy created for `addObserver`, even though a fresh proxy
/// is built at each bridge boundary.
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

/// Native proxy for AST-interpreted [CustomPainter] subclasses.
///
/// `CustomPaint(painter: …)` / `CanvasSurface(painter: …)` take a native
/// `CustomPainter`; an interpreted subclass has no native super-object (the
/// bridge registers no constructors for the abstract base), so it fails with
/// `Invalid parameter "painter": expected CustomPainter?`.
///
/// Only members the guest actually declares are forwarded:
/// `preferredHeight` is not abstract and the base implementation throws
/// `UnimplementedError`, so a painter that does not override it must get
/// `null` ("use the height I was given"), not an exception.
class InterpretedCustomPainter extends CustomPainter
    implements D4InterpretedProxy {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedCustomPainter(this.visitor, this.instance)
    : super(repaint: _repaintOf(instance));

  /// `super(repaint: …)` from the guest constructor, when it passed one.
  ///
  /// The super-call is skipped for a proxy-backed abstract base (there is no
  /// constructor adapter to run), so the argument is only available when
  /// [D4.markProxyCapturesSuperArgs] was set for `CustomPainter`.
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
    // Compare against the previous guest instance, not the proxy: the
    // parameter is `covariant CustomPainter`, so a script reads its own
    // fields off it (`oldDelegate.progress`).
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
/// [ConsumerWidget] into the [tom_d4rt_ast] interpreter runtime with log interception support.
void registerAstWidgetInterfaceProxies(
  D4rt interpreter, {
  void Function(String message)? onLog,
  void Function(Object error, StackTrace stack)? onError,
  void Function(
    Object error,
    StackTrace stack, {
    required bool rebuildsInPlace,
  })?
  onBlankBuild,
  VoidCallback? onRecovered,
}) {
  if (onLog != null) {
    onAstGuestLog = onLog;
  }
  if (onError != null) {
    onAstGuestError = onError;
    D4.onCallbackError = onError;
  }
  if (onBlankBuild != null) {
    onAstGuestBlankBuild = onBlankBuild;
  }
  if (onRecovered != null) {
    onAstGuestRecovered = onRecovered;
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

  D4.registerInterfaceProxy('InheritedWidget', (visitor, instance) {
    return InterpretedInheritedWidget(visitor, instance);
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

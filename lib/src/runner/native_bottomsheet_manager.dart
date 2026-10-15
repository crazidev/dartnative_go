import 'package:dartnative/dartnative.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';

// ignore: implementation_imports
import 'package:dartnative/src/reconciler/element.dart';

/// Global manager tracking active native bottom sheets and dispatching hot reload
/// events to their independent DNTrees.
class NativeBottomSheetManager {
  static final List<NativeBottomSheetScopeState> _activeSheets = [];

  /// Registers an active bottom sheet scope.
  static void register(NativeBottomSheetScopeState state) {
    if (!_activeSheets.contains(state)) {
      _activeSheets.add(state);
    }
  }

  /// Unregisters an open bottom sheet scope upon dismissal.
  static void unregister(NativeBottomSheetScopeState state) {
    _activeSheets.remove(state);
  }

  /// The count of currently open native bottom sheets.
  static int get activeSheetCount => _activeSheets.length;

  /// Returns an unmodifiable copy of currently active bottom sheets.
  static List<NativeBottomSheetScopeState> get activeSheets =>
      List.unmodifiable(_activeSheets);

  /// Dispatches hot reload to all currently open bottom sheets, rebinding their
  /// state proxies to the new interpreter session and triggering a re-layout.
  static void notifyHotReload(Object? newVisitor, {String? changedFile}) {
    if (newVisitor == null) return;
    for (final sheet in List.of(_activeSheets)) {
      if (sheet.isScopeActive) {
        sheet.rebindAndRebuild(newVisitor, changedFile: changedFile);
      }
    }
  }
}

/// Root wrapper mounted at the top of every native bottom sheet DNTree.
///
/// Holds a reference to the [DNSheetController], tracks all descendant
/// interpreted state proxies, and orchestrates state-preserving rebinds
/// during hot reload.
class NativeBottomSheetScope extends StatefulWidget {
  final DNSheetController controller;
  final Widget child;

  const NativeBottomSheetScope({
    super.key,
    required this.controller,
    required this.child,
  });

  static NativeBottomSheetScopeState? of(BuildContext context) {
    try {
      return (context.getInheritedWidgetOfExactType<_InheritedNativeBottomSheetScope>() ??
              context.dependOnInheritedWidgetOfExactType<_InheritedNativeBottomSheetScope>())
          ?.state;
    } catch (_) {
      try {
        return context
            .dependOnInheritedWidgetOfExactType<_InheritedNativeBottomSheetScope>()
            ?.state;
      } catch (_) {
        return null;
      }
    }
  }

  @override
  State<NativeBottomSheetScope> createState() {
    final state = NativeBottomSheetScopeState();
    state._scopeWidget = this;
    return state;
  }
}

class _InheritedNativeBottomSheetScope extends InheritedWidget {
  final NativeBottomSheetScopeState state;

  const _InheritedNativeBottomSheetScope({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedNativeBottomSheetScope oldWidget) => false;
}

class NativeBottomSheetScopeState extends State<NativeBottomSheetScope> {
  NativeBottomSheetScope? _scopeWidget;

  NativeBottomSheetScope get scopeWidget {
    try {
      return widget;
    } catch (_) {
      return _scopeWidget!;
    }
  }

  final Set<dynamic> _proxies = {};
  bool _isDisposed = false;
  int _contentGeneration = 0;

  bool get isScopeActive => !_isDisposed;

  /// The root Element of this sheet in its Reconciler, if mounted.
  Element? get elementRoot {
    if (_isDisposed) return null;
    try {
      if (mounted) {
        final c = context;
        if (c is Element) return c;
      }
    } catch (_) {}
    return null;
  }

  @override
  void didUpdateWidget(covariant NativeBottomSheetScope oldWidget) {
    try {
      super.didUpdateWidget(oldWidget);
    } catch (_) {}
    try {
      _scopeWidget = widget;
    } catch (_) {}
  }

  @override
  void initState() {
    try {
      super.initState();
    } catch (_) {}
    _isDisposed = false;
    NativeBottomSheetManager.register(this);
  }

  @override
  void dispose() {
    _isDisposed = true;
    NativeBottomSheetManager.unregister(this);
    _proxies.clear();
    try {
      super.dispose();
    } catch (_) {}
  }

  /// Registers a descendant state proxy (e.g. `InterpretedStateProxy` or
  /// `InterpretedConsumerStateProxy`).
  void registerProxy(dynamic proxy) {
    _proxies.add(proxy);
  }

  /// Unregisters a descendant state proxy.
  void unregisterProxy(dynamic proxy) {
    _proxies.remove(proxy);
  }

  /// Public read-only view of registered descendant proxies.
  Set<dynamic> get proxies => _proxies;

  /// Triggers an immediate rebuild of this bottom sheet scope and all
  /// registered descendant proxies (e.g. `_CreateNotePanelState`).
  void triggerRebuild() {
    if (_isDisposed) return;
    try {
      if (!mounted) return;
    } catch (_) {}
    for (final proxy in List.of(_proxies)) {
      try {
        proxy.setState(() {});
      } catch (_) {}
    }
    try {
      setState(() {});
    } catch (_) {}
  }

  /// Rebinds all registered state proxies within this bottom sheet to the updated
  /// class definitions in [newVisitor] and re-measures native layout.
  void rebindAndRebuild(dynamic newVisitor, {String? changedFile}) {
    if (_isDisposed) return;

    // 1. Rebind descendant state proxies (e.g. _CreateNotePanelState)
    for (final proxy in List.of(_proxies)) {
      try {
        bool isDisposed = false;
        try {
          if (proxy._mounted == false) isDisposed = true;
        } catch (_) {}
        if (!isDisposed) {
          String? className;
          try {
            className = proxy.stateInstance?.klass?.name?.toString();
          } catch (_) {}
          try {
            proxy.visitor = newVisitor;
          } catch (_) {}
          try {
            proxy.vm = newVisitor;
          } catch (_) {}
          if (className != null) {
            final newClass = findUserClassInVisitor(newVisitor, className);
            if (newClass != null) {
              try {
                proxy.rebindForHotReload(newVisitor, newClass);
                continue;
              } catch (_) {}
            }
          }
          try {
            proxy.setState(() {});
          } catch (_) {}
        }
      } catch (_) {}
    }

    // 2. If the root child itself is a stateless or consumer widget, rebind it
    try {
      final c = scopeWidget.child as dynamic;
      String? childClassName;
      try {
        childClassName = c.instance?.klass?.name?.toString();
      } catch (_) {}
      try {
        c.visitor = newVisitor;
      } catch (_) {}
      try {
        c.vm = newVisitor;
      } catch (_) {}
      if (childClassName != null) {
        final newClass = findUserClassInVisitor(newVisitor, childClassName);
        if (newClass != null) {
          try {
            c.rebindForHotReload(newVisitor, newClass);
          } catch (_) {}
        }
      }
      // The child widget object is the same one the sheet mounted, so a rebuild
      // of this scope does not reach it: mark it dirty explicitly.
      try {
        c.markNeedsRebuild();
      } catch (_) {}
    } catch (_) {}

    _contentGeneration += 1;

    // 3. Trigger rebuild of this scope in the sheet's DNTree
    try {
      setState(() {});
    } catch (_) {}

    // 4. Invalidate detents so the native sheet adjusts its height post-frame
    try {
      final controller = scopeWidget.controller;
      try {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            controller.invalidateDetents();
          } catch (_) {}
        });
      } catch (_) {
        controller.invalidateDetents();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child;
    final isStateless = child is StatelessWidget && child is! StatefulWidget;
    return _InheritedNativeBottomSheetScope(
      state: this,
      child: isStateless
          ? KeyedSubtree(
              key: ValueKey('sheet_content_gen_$_contentGeneration'),
              child: child,
            )
          : child,
    );
  }
}

/// Helper that resolves an updated [InterpretedClass] by name across all user modules
/// in [visitor], supporting both Source mode and AST mode.
dynamic findUserClassInVisitor(dynamic visitor, String className) {
  if (visitor == null) return null;

  // 1. Try visitor's current environment chain
  try {
    dynamic env = visitor.environment;
    while (env != null) {
      if (env.values is Map && env.values.containsKey(className)) {
        return env.values[className];
      }
      env = env.enclosing;
    }
  } catch (_) {}

  // 2. Try globalEnvironment
  try {
    dynamic gEnv = visitor.globalEnvironment;
    if (gEnv != null && gEnv.values is Map && gEnv.values.containsKey(className)) {
      return gEnv.values[className];
    }
  } catch (_) {}

  // 3. Loaded module environments (authoritative in AST mode): the
  // loader's per-execution module cache holds every module's live
  // environment for the current generation — including classes never merged
  // into the entry environment (e.g. pushed-route screens), which steps 1-2
  // cannot see. This is what makes post-reload rebinding work on device,
  // where bundle sources are usually absent.
  dynamic loader;
  try {
    loader = visitor.moduleLoader;
  } catch (_) {
    try {
      loader = visitor.moduleContext;
    } catch (_) {}
  }
  try {
    final cache = loader?.moduleCache;
    if (cache is Map) {
      for (final mod in cache.values) {
        try {
          final env = mod?.environment;
          if (env?.values is Map && env.values.containsKey(className)) {
            return env.values[className];
          }
          final exported = mod?.exportedEnvironment;
          if (exported?.values is Map &&
              exported.values.containsKey(className)) {
            return exported.values[className];
          }
        } catch (_) {}
      }
    }
  } catch (_) {}

  // 4. Try moduleLoader (Source mode) or moduleContext (AST mode)
  try {
    if (loader != null) {
      try {
        final modules = loader.modules;
        if (modules is Map) {
          for (final mod in modules.values) {
            try {
              if (mod?.environment?.values?.containsKey(className) == true) {
                return mod.environment.values[className];
              }
              if (mod?.exportedEnvironment?.values?.containsKey(className) == true) {
                return mod.exportedEnvironment.values[className];
              }
            } catch (_) {}
          }
        }
      } catch (_) {}

      try {
        final sources = loader.sources;
        if (sources is Map) {
          for (final key in sources.keys) {
            try {
              final mod = loader.loadModule(Uri.parse(key.toString()));
              if (mod?.environment?.values?.containsKey(className) == true) {
                return mod.environment.values[className];
              }
              if (mod?.exportedEnvironment?.values?.containsKey(className) == true) {
                return mod.exportedEnvironment.values[className];
              }
            } catch (_) {}
          }
        }
      } catch (_) {}
    }
  } catch (_) {}

  return null;
}

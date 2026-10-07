import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

import '../interpreter/ast/ast_widget_proxies.dart';
import '../runner/ast_interpreter_runner.dart';

/// Instantiates an already-loaded server-component [cls] as a native [Widget].
///
/// Calls the interpreted unnamed constructor with [props] as named arguments
/// and wraps the resulting instance with [wrapAstInterpretedWidget] (so
/// `StatelessWidget`, `StatefulWidget` and Consumer variants all mount).
/// Returns null when the runner has no live visitor yet or the instance
/// cannot be wrapped as a widget.
///
/// This is the shared mount path used by [ServerComponent] and the headless
/// `ServerComponentHarness` — keep it behavior-compatible for both.
Widget? mountServerComponent({
  required AstInterpreterRunner runner,
  required ast.InterpretedClass cls,
  Map<String, dynamic>? props,
}) {
  final visitor = runner.visitor;
  if (visitor == null) return null;
  final named = <String, Object?>{};
  (props ?? const {}).forEach((key, value) {
    named[key] = value;
  });
  try {
    final instance = cls.call(visitor, const <Object?>[], named);
    if (instance is Widget) return instance;
    return wrapAstInterpretedWidget(instance, visitor: visitor);
  } catch (_) {
    return null;
  }
}

/// Host mount point for a `@ServerComponent` / `@Server` widget.
///
/// The component's AST bundle is fetched and loaded on demand; while loading
/// [fallback] is shown, and load failures render [errorBuilder]'s widget.
///
/// The actual fetch + interpreter load is supplied by the host app via
/// [loadComponent] (e.g. an HTTP fetch from the dev server's
/// `/server-components/` endpoints followed by
/// `AstInterpreterRunner.loadServerComponent`). When the component is
/// already registered in [runner] (pre-loaded by the harness or a previous
/// mount), [loadComponent] is not called.
///
/// ```dart
/// ServerComponent(
///   componentId: 'profile_card',
///   props: {'userId': 42},
///   runner: sharedRunner,
///   loadComponent: (id) => fetchAndLoad(id, sharedRunner),
///   fallback: const Text('Loading…'),
/// )
/// ```
class ServerComponent extends StatefulWidget {
  /// Component id from the `@ServerComponent(id: ...)` annotation.
  final String componentId;

  /// Props forwarded as named arguments to the interpreted constructor.
  final Map<String, dynamic>? props;

  /// Shown while the component bundle loads. Defaults to an empty box.
  final Widget? fallback;

  /// Builds the error UI for load/mount failures. Defaults to a [Text].
  final Widget Function(Object error)? errorBuilder;

  /// Fetches the component bundle and loads it into [runner].
  /// Skipped when the component already resolves in the interpreter.
  final Future<ast.InterpretedClass?> Function(String componentId)?
      loadComponent;

  /// Shared interpreter. When null, the widget owns a private runner
  /// (disposed with the state) — prefer passing the app's runner so
  /// components resolve against the live client modules.
  final AstInterpreterRunner? runner;

  const ServerComponent({
    super.key,
    required this.componentId,
    this.props,
    this.fallback,
    this.errorBuilder,
    this.loadComponent,
    this.runner,
  });

  @override
  State<ServerComponent> createState() => _ServerComponentState();
}

class _ServerComponentState extends State<ServerComponent> {
  AstInterpreterRunner? _ownedRunner;
  AstInterpreterRunner get _effectiveRunner =>
      widget.runner ?? (_ownedRunner ??= AstInterpreterRunner());

  Widget? _mounted;
  Object? _error;
  bool _loading = true;
  ast.InterpretedClass? _cls;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(ServerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.componentId != widget.componentId) {
      _cls = null;
      _load();
    } else if (!_propsEqual(oldWidget.props, widget.props) &&
        _cls != null) {
      _remount();
    }
  }

  @override
  void dispose() {
    _ownedRunner?.dispose();
    _ownedRunner = null;
    super.dispose();
  }

  static bool _propsEqual(
    Map<String, dynamic>? a,
    Map<String, dynamic>? b,
  ) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return a == null && b == null;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _mounted = null;
    });
    try {
      final runner = _effectiveRunner;
      var cls = runner.resolveTopLevel(widget.componentId);
      cls ??= await widget.loadComponent?.call(widget.componentId);
      if (cls == null) {
        throw StateError(
          "ServerComponent '${widget.componentId}' is not registered in the "
          'interpreter and no loadComponent callback was provided (or it '
          'returned null). Supply loadComponent to fetch + load the bundle.',
        );
      }
      _cls = cls;
      final mounted = mountServerComponent(
        runner: runner,
        cls: cls,
        props: widget.props,
      );
      if (mounted == null) {
        throw StateError(
          "ServerComponent '${widget.componentId}' loaded but could not be "
          'mounted as a Widget (constructor threw or the class is not a '
          'Widget subtype).',
        );
      }
      _mounted = mounted;
    } catch (e) {
      _error = e;
    }
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  void _remount() {
    final cls = _cls;
    if (cls == null) {
      _load();
      return;
    }
    final mounted = mountServerComponent(
      runner: _effectiveRunner,
      cls: cls,
      props: widget.props,
    );
    setState(() {
      _mounted = mounted;
      _loading = false;
      if (mounted == null) {
        _error = StateError(
          "ServerComponent '${widget.componentId}' failed to remount with "
          'updated props.',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error != null) {
      final builder = widget.errorBuilder;
      if (builder != null) return builder(error);
      return Text('Server component '
          "'${widget.componentId}' failed to load: $error");
    }
    final mounted = _mounted;
    if (!_loading && mounted != null) return mounted;
    return widget.fallback ?? const SizedBox.shrink();
  }
}

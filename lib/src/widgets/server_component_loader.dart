import 'package:dartnative/dartnative.dart' show Widget;
import 'package:tom_d4rt_ast/runtime.dart' as ast;

import '../cli/server_annotation_scanner.dart';
import '../runner/ast_interpreter_runner.dart';
import '../runner/bundle_loader.dart';
import 'server_component.dart' show mountServerComponent;

/// Manual (imperative) loading API for `@ServerComponent`s.
///
/// Use this when the [ServerComponent] widget's automatic loading is not
/// what you want: preloading components at app start, refreshing one on
/// demand, or mounting the same loaded class in several places.
///
/// The loader plugs straight into the widget when you do want it — its
/// [loadComponent] signature matches the widget's `loadComponent` callback:
///
/// ```dart
/// final loader = ServerComponentLoader(
///   serverUrl: serverUrl,
///   runner: interpreterRunner.astRunner!,
/// );
/// await loader.preloadAll(['profile_card', 'badge']);
///
/// ServerComponent(
///   componentId: 'profile_card',
///   props: const {'userId': 7},
///   runner: interpreterRunner.astRunner,
///   loadComponent: loader.loadComponent, // instant: already loaded
/// )
/// ```
///
/// CRITICAL: [runner] must be the same interpreter instance that evaluated
/// the client bundle — component deltas resolve shared imports from it.
class ServerComponentLoader {
  final BundleLoader bundleLoader;
  final AstInterpreterRunner runner;
  final String serverUrl;

  /// Overrides the network fetch (tests serve in-memory bytes through this).
  final Future<List<int>?> Function(String componentId)? fetchBytes;

  /// Component id → annotated class name, learned from each loaded bundle.
  final Map<String, String> _componentClassNames = {};

  /// Component id → manifest fingerprint of the currently loaded bytes.
  final Map<String, String> _loadedFingerprints = {};

  ServerComponentLoader({
    required this.serverUrl,
    required this.runner,
    BundleLoader? bundleLoader,
    this.fetchBytes,
  }) : bundleLoader = bundleLoader ?? BundleLoader();

  /// Fetches (unless fingerprint-identical bytes are already loaded) and
  /// loads [componentId], returning its class or null when unavailable.
  ///
  /// Set [forceReload] to skip the fingerprint check (e.g. after editing
  /// the component's sources on the dev server).
  Future<ast.InterpretedClass?> loadComponent(
    String componentId, {
    bool forceReload = false,
  }) async {
    final manifest =
        await bundleLoader.fetchServerComponentsManifest(serverUrl);
    final fingerprint = manifest[componentId]?['fingerprint'];
    if (!forceReload &&
        fingerprint != null &&
        _loadedFingerprints[componentId] == fingerprint) {
      final cached = _resolveClass(componentId);
      if (cached != null) return cached;
    }
    final bytes = await _fetch(componentId);
    if (bytes == null) return null;
    final cls = await runner.loadServerComponent(
      componentId: componentId,
      astBytes: bytes,
    );
    if (cls == null) return null;
    _rememberClass(componentId, bytes);
    if (fingerprint != null) {
      _loadedFingerprints[componentId] = fingerprint;
    }
    return cls;
  }

  /// Loads [primaryId], falling back to [fallbackId] when the primary is
  /// missing or fails to load. Returns null only when both fail.
  Future<ast.InterpretedClass?> loadComponentWithFallback(
    String primaryId, {
    String? fallbackId,
    bool forceReload = false,
  }) async {
    try {
      final primary = await loadComponent(primaryId, forceReload: forceReload);
      if (primary != null) return primary;
    } catch (_) {
      // Fall through to the fallback component.
    }
    if (fallbackId == null) return null;
    try {
      return await loadComponent(fallbackId, forceReload: forceReload);
    } catch (_) {
      return null;
    }
  }

  /// Loads every id in [componentIds] sequentially (shared interpreter
  /// state — never in parallel) and returns the resolved classes.
  Future<Map<String, ast.InterpretedClass?>> preloadAll(
    Iterable<String> componentIds, {
    bool forceReload = false,
  }) async {
    final out = <String, ast.InterpretedClass?>{};
    for (final id in componentIds) {
      out[id] = await loadComponent(id, forceReload: forceReload);
    }
    return out;
  }

  /// Instantiates an already-loaded component as a native [Widget].
  ///
  /// Returns null when [componentId] was never loaded (call [loadComponent]
  /// first) or the instance cannot be wrapped.
  Widget? mountComponent(
    String componentId, {
    Map<String, dynamic>? props,
  }) {
    final cls = _resolveClass(componentId);
    if (cls == null) return null;
    return mountServerComponent(runner: runner, cls: cls, props: props);
  }

  /// Whether [componentId] currently resolves in the interpreter.
  bool isLoaded(String componentId) => _resolveClass(componentId) != null;

  ast.InterpretedClass? _resolveClass(String componentId) {
    return runner.resolveTopLevel(
      _componentClassNames[componentId] ?? componentId,
    );
  }

  Future<List<int>?> _fetch(String componentId) {
    final fetch = fetchBytes;
    if (fetch != null) return fetch(componentId);
    return bundleLoader.fetchServerComponentBytes(serverUrl, componentId);
  }

  void _rememberClass(String componentId, List<int> bytes) {
    try {
      final bundle = ast.AstBundle.fromBytes(bytes);
      for (final component in ServerAnnotationScanner.scanBundle(bundle)) {
        if (component.componentId == componentId) {
          _componentClassNames[componentId] = component.className;
        }
      }
    } catch (_) {
      // Mapping stays id-based; resolution falls back to the component id.
    }
  }
}

/// Host-side bridge for `MediaGalleryFFIBindings`, which the generator never
/// emitted.
///
/// `package:dartnative_media_picker/gallery.dart` re-exports the class from
/// `src/gallery_ffi_bindings.dart`, and the generated bridge set records that
/// as a *library re-export* — but no `BridgedClass` for the name itself. The
/// playground's plugin registrant calls
/// `MediaGalleryFFIBindings.loadSymbols()`, so the gap is visible on the
/// source engine, where the static undefined-name check rejects the whole
/// module before `_load`'s `try`/`catch` can swallow it. (On the AST engine
/// the same call throws at runtime and is caught, which is why only the
/// source path failed.)
///
/// Regenerating the module is not an option yet: the vendored
/// `tom_d4rt_generator` 1.67 emits `registerFunctionTypedef(requiredPositional: …)`
/// for this module, which the committed 1.26-era output does not use, so a
/// regeneration fails its own verification pass. A hand-written bridge is the
/// supported escape hatch — the same one `routes_bridge.dart` and
/// `zoned_guarded_bridge.dart` use for entry points the generator cannot
/// express.
///
/// Every member forwards to the real class: the bodies in the shipped SDK
/// source are `throw UnimplementedError()` stubs that the platform patches on
/// device, so forwarding is exactly what a generated bridge would do.
library;

// ignore: implementation_imports
import 'package:dartnative_media_picker/src/gallery_ffi_bindings.dart';
import 'package:tom_d4rt/tom_d4rt.dart' as src;
import 'package:tom_d4rt_ast/d4rt.dart' as ast;

/// The library URIs the class is reachable from in guest code.
const kMediaGalleryFfiLibraries = <String>[
  'package:dartnative_media_picker/dartnative_media_picker.dart',
  'package:dartnative_media_picker/gallery.dart',
  'package:dartnative_media_picker/src/gallery_ffi_bindings.dart',
];

/// Canonical source URI, used for cross-bridge deduplication.
const kMediaGalleryFfiSourceUri =
    'package:dartnative_media_picker/src/gallery_ffi_bindings.dart';

MediaGalleryFFIBindings _target(Object? value) =>
    value as MediaGalleryFFIBindings;

/// Builds the bridge. Shared by both engines: `BridgedClass` is the same
/// shape in `tom_d4rt` and `tom_d4rt_ast`, and the adapters only use members
/// present on both (`extractBridgedArg` lives on each engine's `D4`).
///
/// Typed separately per engine because the factory signature is engine
/// specific; see [registerAstMediaGalleryFfiBridge] and
/// [registerSourceMediaGalleryFfiBridge].
Map<String, String> get _methodSignatures => const {
  'permission': 'Future<String> permission({required bool request})',
  'albums': 'Future<String> albums(int type)',
  'assets':
      'Future<String> assets({required String albumId, required int type, '
      'required int offset, required int limit, String order = \'\'})',
  'preheat': 'Future<String> preheat(String assetIds, int size)',
  'cancelPreheat': 'Future<String> cancelPreheat()',
  'thumbnail': 'Future<String> thumbnail(String assetId, int width, int height)',
  'file': 'Future<String> file(String assetId)',
  'save':
      'Future<String> save({required String path, required bool isVideo, '
      'required String albumName})',
  'delete': 'Future<String> delete(String idsJson)',
};

/// AST-engine registration (`tom_d4rt_ast`).
void registerAstMediaGalleryFfiBridge(ast.D4rtRunner runner) {
  final bridge = ast.BridgedClass(
    nativeType: MediaGalleryFFIBindings,
    name: 'MediaGalleryFFIBindings',
    isAssignable: (v) => v is MediaGalleryFFIBindings,
    constructors: const {},
    getters: {
      'isAvailable': (visitor, value) => _target(value).isAvailable,
    },
    staticGetters: {
      'instance': (visitor) => MediaGalleryFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        MediaGalleryFFIBindings.loadSymbols();
        return null;
      },
    },
    methods: {
      'permission': (visitor, value, positional, named, typeArgs) {
        final request = ast.D4.getNamedArgWithDefault<bool>(
          named,
          'request',
          false,
        );
        return _target(value).permission(request: request);
      },
      'albums': (visitor, value, positional, named, typeArgs) {
        ast.D4.requireMinArgs(positional, 1, 'albums');
        return _target(
          value,
        ).albums(ast.D4.getRequiredArg<int>(positional, 0, 'type', 'albums'));
      },
      'assets': (visitor, value, positional, named, typeArgs) {
        final albumId = ast.D4.getRequiredNamedArg<String>(
          named,
          'albumId',
          'assets',
        );
        final type = ast.D4.getRequiredNamedArg<int>(named, 'type', 'assets');
        final offset = ast.D4.getRequiredNamedArg<int>(
          named,
          'offset',
          'assets',
        );
        final limit = ast.D4.getRequiredNamedArg<int>(named, 'limit', 'assets');
        final order = ast.D4.getNamedArgWithDefault<String>(named, 'order', '');
        return _target(value).assets(
          albumId: albumId,
          type: type,
          offset: offset,
          limit: limit,
          order: order,
        );
      },
      'preheat': (visitor, value, positional, named, typeArgs) {
        ast.D4.requireMinArgs(positional, 2, 'preheat');
        return _target(value).preheat(
          ast.D4.getRequiredArg<String>(positional, 0, 'assetIds', 'preheat'),
          ast.D4.getRequiredArg<int>(positional, 1, 'size', 'preheat'),
        );
      },
      'cancelPreheat': (visitor, value, positional, named, typeArgs) =>
          _target(value).cancelPreheat(),
      'thumbnail': (visitor, value, positional, named, typeArgs) {
        ast.D4.requireMinArgs(positional, 3, 'thumbnail');
        return _target(value).thumbnail(
          ast.D4.getRequiredArg<String>(positional, 0, 'assetId', 'thumbnail'),
          ast.D4.getRequiredArg<int>(positional, 1, 'width', 'thumbnail'),
          ast.D4.getRequiredArg<int>(positional, 2, 'height', 'thumbnail'),
        );
      },
      'file': (visitor, value, positional, named, typeArgs) {
        ast.D4.requireMinArgs(positional, 1, 'file');
        return _target(
          value,
        ).file(ast.D4.getRequiredArg<String>(positional, 0, 'assetId', 'file'));
      },
      'save': (visitor, value, positional, named, typeArgs) {
        final path = ast.D4.getRequiredNamedArg<String>(named, 'path', 'save');
        final isVideo = ast.D4.getRequiredNamedArg<bool>(
          named,
          'isVideo',
          'save',
        );
        final albumName = ast.D4.getRequiredNamedArg<String>(
          named,
          'albumName',
          'save',
        );
        return _target(value).save(
          path: path,
          isVideo: isVideo,
          albumName: albumName,
        );
      },
      'delete': (visitor, value, positional, named, typeArgs) {
        ast.D4.requireMinArgs(positional, 1, 'delete');
        return _target(
          value,
        ).delete(ast.D4.getRequiredArg<String>(positional, 0, 'idsJson', 'delete'));
      },
    },
    getterSignatures: const {'isAvailable': 'bool get isAvailable'},
    staticGetterSignatures: const {
      'instance': 'MediaGalleryFFIBindings get instance',
    },
    staticMethodSignatures: const {'loadSymbols': 'void loadSymbols()'},
    methodSignatures: _methodSignatures,
  );
  for (final uri in kMediaGalleryFfiLibraries) {
    runner.registerBridgedClass(bridge, uri);
  }
}

/// Source-engine counterpart of [registerAstMediaGalleryFfiBridge].
void registerSourceMediaGalleryFfiBridge(src.D4rt interpreter) {
  final bridge = src.BridgedClass(
    nativeType: MediaGalleryFFIBindings,
    name: 'MediaGalleryFFIBindings',
    isAssignable: (v) => v is MediaGalleryFFIBindings,
    constructors: const {},
    getters: {
      'isAvailable': (visitor, value) => _target(value).isAvailable,
    },
    staticGetters: {
      'instance': (visitor) => MediaGalleryFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        MediaGalleryFFIBindings.loadSymbols();
        return null;
      },
    },
    methods: {
      'permission': (visitor, value, positional, named, typeArgs) {
        final request = src.D4.getNamedArgWithDefault<bool>(
          named,
          'request',
          false,
        );
        return _target(value).permission(request: request);
      },
      'albums': (visitor, value, positional, named, typeArgs) {
        src.D4.requireMinArgs(positional, 1, 'albums');
        return _target(
          value,
        ).albums(src.D4.getRequiredArg<int>(positional, 0, 'type', 'albums'));
      },
      'assets': (visitor, value, positional, named, typeArgs) {
        final albumId = src.D4.getRequiredNamedArg<String>(
          named,
          'albumId',
          'assets',
        );
        final type = src.D4.getRequiredNamedArg<int>(named, 'type', 'assets');
        final offset = src.D4.getRequiredNamedArg<int>(
          named,
          'offset',
          'assets',
        );
        final limit = src.D4.getRequiredNamedArg<int>(named, 'limit', 'assets');
        final order = src.D4.getNamedArgWithDefault<String>(named, 'order', '');
        return _target(value).assets(
          albumId: albumId,
          type: type,
          offset: offset,
          limit: limit,
          order: order,
        );
      },
      'preheat': (visitor, value, positional, named, typeArgs) {
        src.D4.requireMinArgs(positional, 2, 'preheat');
        return _target(value).preheat(
          src.D4.getRequiredArg<String>(positional, 0, 'assetIds', 'preheat'),
          src.D4.getRequiredArg<int>(positional, 1, 'size', 'preheat'),
        );
      },
      'cancelPreheat': (visitor, value, positional, named, typeArgs) =>
          _target(value).cancelPreheat(),
      'thumbnail': (visitor, value, positional, named, typeArgs) {
        src.D4.requireMinArgs(positional, 3, 'thumbnail');
        return _target(value).thumbnail(
          src.D4.getRequiredArg<String>(positional, 0, 'assetId', 'thumbnail'),
          src.D4.getRequiredArg<int>(positional, 1, 'width', 'thumbnail'),
          src.D4.getRequiredArg<int>(positional, 2, 'height', 'thumbnail'),
        );
      },
      'file': (visitor, value, positional, named, typeArgs) {
        src.D4.requireMinArgs(positional, 1, 'file');
        return _target(
          value,
        ).file(src.D4.getRequiredArg<String>(positional, 0, 'assetId', 'file'));
      },
      'save': (visitor, value, positional, named, typeArgs) {
        final path = src.D4.getRequiredNamedArg<String>(named, 'path', 'save');
        final isVideo = src.D4.getRequiredNamedArg<bool>(
          named,
          'isVideo',
          'save',
        );
        final albumName = src.D4.getRequiredNamedArg<String>(
          named,
          'albumName',
          'save',
        );
        return _target(value).save(
          path: path,
          isVideo: isVideo,
          albumName: albumName,
        );
      },
      'delete': (visitor, value, positional, named, typeArgs) {
        src.D4.requireMinArgs(positional, 1, 'delete');
        return _target(
          value,
        ).delete(src.D4.getRequiredArg<String>(positional, 0, 'idsJson', 'delete'));
      },
    },
    getterSignatures: const {'isAvailable': 'bool get isAvailable'},
    staticGetterSignatures: const {
      'instance': 'MediaGalleryFFIBindings get instance',
    },
    staticMethodSignatures: const {'loadSymbols': 'void loadSymbols()'},
    methodSignatures: _methodSignatures,
  );
  for (final uri in kMediaGalleryFfiLibraries) {
    interpreter.registerBridgedClass(bridge, uri);
  }
}

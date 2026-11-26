/// AST-engine host fake for the `MediaGallery` half of
/// `dartnative_media_picker`.
///
/// The generated bridge is real FFI: `permission()` asks the platform for
/// access and throws `MediaGalleryException('The gallery is not available on
/// this platform.')` on a host without one. The playground's ChatGPT picker
/// primes the photo library from `initState`, so that throw becomes an
/// unhandled async error in a headless suite rather than a caught sync one.
///
/// This fake answers as a granted, empty library: enough for the screen to
/// finish its mount (permission → first page → change subscription) and build
/// its empty state. Only the statics the guest calls are registered; the rest
/// of the barrel keeps its generated bridges.
///
/// Both engines are covered: [installFakeMediaGalleryAst] shadows the AST
/// bridge set, [installFakeMediaGallerySource] the source one.
library;

import 'package:dartnative_media_picker/gallery.dart';
import 'package:tom_d4rt/d4rt.dart' as src;
import 'package:tom_d4rt_ast/d4rt.dart' as ast;

/// Library URIs the generated `MediaGallery` bridge is reachable from. Guest
/// code imports the gallery barrel; the package barrel re-exports it.
const List<String> kMediaGalleryAstBridgeUris = [
  'package:dartnative_media_picker/gallery.dart',
  'package:dartnative_media_picker/dartnative_media_picker.dart',
];

/// Builds the fake `MediaGallery` bridge.
ast.BridgedClass buildFakeMediaGalleryAstBridge() {
  return ast.BridgedClass(
    nativeType: MediaGallery,
    name: 'MediaGallery',
    isAbstract: true,
    isAssignable: (v) => v is MediaGallery,
    constructors: const {},
    staticGetters: {
      'allAlbumId': (visitor) => MediaGallery.allAlbumId,
      'changes': (visitor) => const Stream<void>.empty(),
    },
    staticMethods: {
      'permission': (visitor, positional, named, typeArgs) =>
          Future.value(GalleryPermission.granted),
      'albums': (visitor, positional, named, typeArgs) =>
          Future.value(const <MediaAlbum>[]),
      'assets': (visitor, positional, named, typeArgs) =>
          Future.value(const <MediaAsset>[]),
      'preheat': (visitor, positional, named, typeArgs) => Future.value(null),
      'cancelPreheat': (visitor, positional, named, typeArgs) =>
          Future.value(null),
      'thumbnail': (visitor, positional, named, typeArgs) =>
          Future.value(''),
      'save': (visitor, positional, named, typeArgs) => Future.value(''),
      'delete': (visitor, positional, named, typeArgs) =>
          Future.value(const <String>[]),
      'file': (visitor, positional, named, typeArgs) => Future.value(
        const GalleryFile(path: '', name: '', isVideo: false),
      ),
    },
    staticGetterSignatures: const {
      'allAlbumId': 'String get allAlbumId',
      'changes': 'Stream<void> get changes',
    },
    staticMethodSignatures: const {
      'permission':
          'Future<GalleryPermission> permission({bool request = false})',
      'albums':
          'Future<List<MediaAlbum>> albums({GalleryMediaType type = GalleryMediaType.images})',
      'assets':
          'Future<List<MediaAsset>> assets({String albumId = allAlbumId, GalleryMediaType type = GalleryMediaType.images, int offset = 0, int limit = 80, List<GalleryOrder> order = const []})',
      'preheat':
          'Future<void> preheat(List<String> assetIds, {int size = 200})',
      'cancelPreheat': 'Future<void> cancelPreheat()',
      'thumbnail':
          'Future<String> thumbnail(String assetId, {int width = 256, int height = 256})',
      'save':
          'Future<String> save(String path, {bool isVideo = false, String albumName = \'\'})',
      'delete': 'Future<List<String>> delete(List<String> assetIds)',
      'file': 'Future<GalleryFile> file(String assetId)',
    },
  );
}

/// Returns an override for `DnHarness(astBridgeOverrides: [...])`.
void Function(ast.D4rtRunner runner) installFakeMediaGalleryAst() {
  final fake = buildFakeMediaGalleryAstBridge();
  return (runner) {
    for (final uri in kMediaGalleryAstBridgeUris) {
      runner.registerBridgedClass(fake, uri);
    }
  };
}

/// Source-engine counterpart, for `DnHarness(bridgeOverrides: [...])`.
void installFakeMediaGallerySource(src.D4rt interpreter) {
  final bridge = src.BridgedClass(
    nativeType: MediaGallery,
    name: 'MediaGallery',
    isAbstract: true,
    isAssignable: (v) => v is MediaGallery,
    constructors: const {},
    staticGetters: {
      'allAlbumId': (visitor) => MediaGallery.allAlbumId,
      'changes': (visitor) => const Stream<void>.empty(),
    },
    staticMethods: {
      'permission': (visitor, positional, named, typeArgs) =>
          Future.value(GalleryPermission.granted),
      'albums': (visitor, positional, named, typeArgs) =>
          Future.value(const <MediaAlbum>[]),
      'assets': (visitor, positional, named, typeArgs) =>
          Future.value(const <MediaAsset>[]),
      'preheat': (visitor, positional, named, typeArgs) => Future.value(null),
      'cancelPreheat': (visitor, positional, named, typeArgs) =>
          Future.value(null),
      'thumbnail': (visitor, positional, named, typeArgs) => Future.value(''),
      'save': (visitor, positional, named, typeArgs) => Future.value(''),
      'delete': (visitor, positional, named, typeArgs) =>
          Future.value(const <String>[]),
      'file': (visitor, positional, named, typeArgs) => Future.value(
        const GalleryFile(path: '', name: '', isVideo: false),
      ),
    },
    staticGetterSignatures: const {
      'allAlbumId': 'String get allAlbumId',
      'changes': 'Stream<void> get changes',
    },
    staticMethodSignatures: const {
      'permission':
          'Future<GalleryPermission> permission({bool request = false})',
      'albums':
          'Future<List<MediaAlbum>> albums({GalleryMediaType type = GalleryMediaType.images})',
      'assets':
          'Future<List<MediaAsset>> assets({String albumId = allAlbumId, GalleryMediaType type = GalleryMediaType.images, int offset = 0, int limit = 80, List<GalleryOrder> order = const []})',
      'preheat':
          'Future<void> preheat(List<String> assetIds, {int size = 200})',
      'cancelPreheat': 'Future<void> cancelPreheat()',
      'thumbnail':
          'Future<String> thumbnail(String assetId, {int width = 256, int height = 256})',
      'save':
          'Future<String> save(String path, {bool isVideo = false, String albumName = \'\'})',
      'delete': 'Future<List<String>> delete(List<String> assetIds)',
      'file': 'Future<GalleryFile> file(String assetId)',
    },
  );
  for (final uri in kMediaGalleryAstBridgeUris) {
    interpreter.registerBridgedClass(bridge, uri);
  }
}

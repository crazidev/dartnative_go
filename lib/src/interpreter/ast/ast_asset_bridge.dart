library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_audio/dartnative_audio.dart' as dn_audio;
import 'package:dartnative_lottie/dartnative_lottie.dart' as dn_lottie;
import 'package:dartnative_path_provider/dartnative_path_provider.dart'
    as dn_path_provider;
import 'package:tom_d4rt_ast/d4rt.dart';

import '../../runner/native_font_registrar.dart';

/// Provides the active dev server URL and optional local disk cache lookup
/// for AST asset resolution.
///
/// Mirrors `AssetResolver` for the source engine; kept separate so each
/// engine tracks its own server URL.
class AstAssetResolver {
  static String? activeServerUrl;

  /// Optional resolver returning a locally cached [File] for an asset path
  /// (used for offline mode and disk-cached assets).
  static File? Function(String assetPath)? cachedAssetFileProvider;

  /// Optional callback to persist downloaded guest asset bytes into disk cache.
  static Future<File?> Function(String assetPath, Uint8List bytes)?
  saveCachedAssetProvider;

  /// In-memory cache for warmed Lottie JSON strings keyed by resolved URL.
  static final Map<String, String> _lottieJsonCache = {};

  /// Clears in-memory asset caches (e.g. on project unmount or asset reload).
  static void clearInMemoryCaches() {
    _lottieJsonCache.clear();
  }

  /// Evicts a single resolved asset URL from in-memory caches.
  static void evictUrl(String url) {
    _lottieJsonCache.remove(url);
  }

  /// Rewrites a guest asset path (e.g. `assets/logo.png` or `logo.png`) onto
  /// [serverUrl]. Preserves `http://` / `https://` URLs unchanged.
  static String resolveAssetUrl(String serverUrl, String assetName) {
    final trimmed = assetName.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final base = serverUrl.endsWith('/')
        ? serverUrl.substring(0, serverUrl.length - 1)
        : serverUrl;
    final clean = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    if (clean.startsWith('assets/')) {
      return '$base/$clean';
    }
    return '$base/assets/$clean';
  }
}

/// Registers asset-aware bridges for [Image] and [AssetImage] on the
/// analyzer-free runtime, so `Image.asset(...)`, `AssetImage(...)`,
/// `Image(image: AssetImage(...))`, and `CircleAvatar(backgroundImage: ...)`
/// resolve over HTTP (or local disk cache) when running with DartNative Go.
void registerAstAssetAwareBridges(
  D4rt interpreter, {
  String? Function()? serverUrlProvider,
  File? Function(String assetPath)? cachedFileProvider,
}) {
  final provider = serverUrlProvider ?? () => AstAssetResolver.activeServerUrl;
  final fileProvider =
      cachedFileProvider ??
      (path) => AstAssetResolver.cachedAssetFileProvider?.call(path);

  ImageProvider resolveAssetProvider(String name) {
    if (name.startsWith('http://') || name.startsWith('https://')) {
      return NetworkImage(name);
    }
    final cached = fileProvider(name);
    if (cached != null && cached.existsSync()) {
      return FileImage(cached);
    }
    final serverUrl = provider();
    if (serverUrl != null && serverUrl.isNotEmpty) {
      return NetworkImage(AstAssetResolver.resolveAssetUrl(serverUrl, name));
    }
    return AssetImage(name);
  }

  final imageBridge = BridgedClass(
    nativeType: Image,
    name: 'Image',
    isAssignable: (v) => v is Image,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Image');
        final image = D4.getRequiredArg<ImageProvider>(
          positional,
          0,
          'image',
          'Image',
        );
        final key = D4.getOptionalNamedArg<Key?>(named, 'key');
        final width = D4.getOptionalNamedArg<double?>(named, 'width');
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final fit = D4.getOptionalNamedArg<BoxFit?>(named, 'fit');
        final color = D4.getOptionalNamedArg<Color?>(named, 'color');
        final alignment = D4.getNamedArgWithDefault<AlignmentGeometry>(
          named,
          'alignment',
          Alignment.center,
        );
        final cachePolicy = D4.getNamedArgWithDefault<ImageCachePolicy>(
          named,
          'cachePolicy',
          ImageCachePolicy.standard,
        );
        final fadeInDuration = D4.getNamedArgWithDefault<Duration>(
          named,
          'fadeInDuration',
          Duration.zero,
        );
        final placeholder = D4.getOptionalNamedArg<Widget?>(
          named,
          'placeholder',
        );
        final placeholderMinDuration = D4.getNamedArgWithDefault<Duration>(
          named,
          'placeholderMinDuration',
          Duration.zero,
        );
        final errorWidget = D4.getOptionalNamedArg<Widget?>(
          named,
          'errorWidget',
        );
        final cacheWidth = D4.getOptionalNamedArg<int?>(named, 'cacheWidth');
        final cacheHeight = D4.getOptionalNamedArg<int?>(named, 'cacheHeight');
        final semanticLabel = D4.getOptionalNamedArg<String?>(
          named,
          'semanticLabel',
        );
        final excludeFromSemantics = D4.getNamedArgWithDefault<bool>(
          named,
          'excludeFromSemantics',
          false,
        );
        return Image(
          key: key,
          image: image,
          width: width,
          height: height,
          fit: fit,
          color: color,
          alignment: alignment,
          cachePolicy: cachePolicy,
          fadeInDuration: fadeInDuration,
          placeholder: placeholder,
          placeholderMinDuration: placeholderMinDuration,
          errorWidget: errorWidget,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
        );
      },
      'network': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Image');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'Image');
        final key = D4.getOptionalNamedArg<Key?>(named, 'key');
        final width = D4.getOptionalNamedArg<double?>(named, 'width');
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final fit = D4.getOptionalNamedArg<BoxFit?>(named, 'fit');
        final alignment = D4.getNamedArgWithDefault<AlignmentGeometry>(
          named,
          'alignment',
          Alignment.center,
        );
        final cachePolicy = D4.getNamedArgWithDefault<ImageCachePolicy>(
          named,
          'cachePolicy',
          ImageCachePolicy.standard,
        );
        final fadeInDuration = D4.getNamedArgWithDefault<Duration>(
          named,
          'fadeInDuration',
          Duration.zero,
        );
        final placeholder = D4.getOptionalNamedArg<Widget?>(
          named,
          'placeholder',
        );
        final placeholderMinDuration = D4.getNamedArgWithDefault<Duration>(
          named,
          'placeholderMinDuration',
          Duration.zero,
        );
        final errorWidget = D4.getOptionalNamedArg<Widget?>(
          named,
          'errorWidget',
        );
        final cacheWidth = D4.getOptionalNamedArg<int?>(named, 'cacheWidth');
        final cacheHeight = D4.getOptionalNamedArg<int?>(named, 'cacheHeight');
        final semanticLabel = D4.getOptionalNamedArg<String?>(
          named,
          'semanticLabel',
        );
        final excludeFromSemantics = D4.getNamedArgWithDefault<bool>(
          named,
          'excludeFromSemantics',
          false,
        );
        final headers = D4.getOptionalNamedArg<Map<String, String>?>(
          named,
          'headers',
        );
        return Image.network(
          url,
          key: key,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          cachePolicy: cachePolicy,
          fadeInDuration: fadeInDuration,
          placeholder: placeholder,
          placeholderMinDuration: placeholderMinDuration,
          errorWidget: errorWidget,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          headers: headers,
        );
      },
      'asset': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Image');
        final name = D4.getRequiredArg<String>(positional, 0, 'name', 'Image');
        final key = D4.getOptionalNamedArg<Key?>(named, 'key');
        final width = D4.getOptionalNamedArg<double?>(named, 'width');
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final fit = D4.getOptionalNamedArg<BoxFit?>(named, 'fit');
        final color = D4.getOptionalNamedArg<Color?>(named, 'color');
        final alignment = D4.getNamedArgWithDefault<AlignmentGeometry>(
          named,
          'alignment',
          Alignment.center,
        );
        final cachePolicy = D4.getNamedArgWithDefault<ImageCachePolicy>(
          named,
          'cachePolicy',
          ImageCachePolicy.standard,
        );
        final fadeInDuration = D4.getNamedArgWithDefault<Duration>(
          named,
          'fadeInDuration',
          Duration.zero,
        );
        final placeholder = D4.getOptionalNamedArg<Widget?>(
          named,
          'placeholder',
        );
        final placeholderMinDuration = D4.getNamedArgWithDefault<Duration>(
          named,
          'placeholderMinDuration',
          Duration.zero,
        );
        final errorWidget = D4.getOptionalNamedArg<Widget?>(
          named,
          'errorWidget',
        );
        final cacheWidth = D4.getOptionalNamedArg<int?>(named, 'cacheWidth');
        final cacheHeight = D4.getOptionalNamedArg<int?>(named, 'cacheHeight');
        final semanticLabel = D4.getOptionalNamedArg<String?>(
          named,
          'semanticLabel',
        );
        final excludeFromSemantics = D4.getNamedArgWithDefault<bool>(
          named,
          'excludeFromSemantics',
          false,
        );

        final resolvedProvider = resolveAssetProvider(name);
        if (resolvedProvider is NetworkImage || resolvedProvider is FileImage) {
          return Image(
            key: key,
            image: resolvedProvider,
            width: width,
            height: height,
            fit: fit,
            color: color,
            alignment: alignment,
            cachePolicy: cachePolicy,
            fadeInDuration: fadeInDuration,
            placeholder: placeholder,
            placeholderMinDuration: placeholderMinDuration,
            errorWidget:
                errorWidget ??
                Image.asset(
                  name,
                  key: key,
                  width: width,
                  height: height,
                  fit: fit,
                  color: color,
                  alignment: alignment,
                  cacheWidth: cacheWidth,
                  cacheHeight: cacheHeight,
                  semanticLabel: semanticLabel,
                  excludeFromSemantics: excludeFromSemantics,
                ),
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            semanticLabel: semanticLabel,
            excludeFromSemantics: excludeFromSemantics,
          );
        }
        return Image.asset(
          name,
          key: key,
          width: width,
          height: height,
          fit: fit,
          color: color,
          alignment: alignment,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
        );
      },
      'file': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Image');
        final file = D4.getRequiredArg<File>(positional, 0, 'file', 'Image');
        final key = D4.getOptionalNamedArg<Key?>(named, 'key');
        final width = D4.getOptionalNamedArg<double?>(named, 'width');
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final fit = D4.getOptionalNamedArg<BoxFit?>(named, 'fit');
        final cacheWidth = D4.getOptionalNamedArg<int?>(named, 'cacheWidth');
        final cacheHeight = D4.getOptionalNamedArg<int?>(named, 'cacheHeight');
        final semanticLabel = D4.getOptionalNamedArg<String?>(
          named,
          'semanticLabel',
        );
        final excludeFromSemantics = D4.getNamedArgWithDefault<bool>(
          named,
          'excludeFromSemantics',
          false,
        );
        return Image.file(
          file,
          key: key,
          width: width,
          height: height,
          fit: fit,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
        );
      },
      'memory': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Image');
        final bytes = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'bytes',
          'Image',
        );
        final key = D4.getOptionalNamedArg<Key?>(named, 'key');
        final width = D4.getOptionalNamedArg<double?>(named, 'width');
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final fit = D4.getOptionalNamedArg<BoxFit?>(named, 'fit');
        final cacheWidth = D4.getOptionalNamedArg<int?>(named, 'cacheWidth');
        final cacheHeight = D4.getOptionalNamedArg<int?>(named, 'cacheHeight');
        final semanticLabel = D4.getOptionalNamedArg<String?>(
          named,
          'semanticLabel',
        );
        final excludeFromSemantics = D4.getNamedArgWithDefault<bool>(
          named,
          'excludeFromSemantics',
          false,
        );
        return Image.memory(
          bytes,
          key: key,
          width: width,
          height: height,
          fit: fit,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
        );
      },
    },
    getters: {
      'key': (visitor, target) => D4.validateTarget<Image>(target, 'Image').key,
      'image': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').image,
      'width': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').width,
      'height': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').height,
      'fit': (visitor, target) => D4.validateTarget<Image>(target, 'Image').fit,
      'color': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').color,
      'alignment': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').alignment,
      'cachePolicy': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').cachePolicy,
      'fadeInDuration': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').fadeInDuration,
      'placeholder': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').placeholder,
      'placeholderMinDuration': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').placeholderMinDuration,
      'errorWidget': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').errorWidget,
      'cacheWidth': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').cacheWidth,
      'cacheHeight': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').cacheHeight,
      'semanticLabel': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').semanticLabel,
      'excludeFromSemantics': (visitor, target) =>
          D4.validateTarget<Image>(target, 'Image').excludeFromSemantics,
    },
  );

  final assetImageBridge = BridgedClass(
    nativeType: AssetImage,
    name: 'AssetImage',
    isAssignable: (v) => v is AssetImage || v is NetworkImage || v is FileImage,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AssetImage');
        final assetName = D4.getRequiredArg<String>(
          positional,
          0,
          'assetName',
          'AssetImage',
        );
        return resolveAssetProvider(assetName);
      },
    },
    getters: {
      'assetName': (visitor, target) {
        if (target is AssetImage) return target.assetName;
        if (target is NetworkImage) return target.url;
        if (target is FileImage) return target.file.path;
        return target.toString();
      },
    },
  );

  final iconDataBridge = BridgedClass(
    nativeType: IconData,
    name: 'IconData',
    isAssignable: (v) => v is IconData,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'IconData');
        final codePoint = D4.getRequiredArg<int>(
          positional,
          0,
          'codePoint',
          'IconData',
        );
        final rawFamily = D4.getNamedArgWithDefault<String?>(
          named,
          'fontFamily',
          'MaterialSymbolsRounded',
        );
        final fontPackage = D4.getOptionalNamedArg<String?>(
          named,
          'fontPackage',
        );
        final resolvedFamily = FontFamilyResolver.resolve(rawFamily);
        return IconData(
          codePoint,
          fontFamily: resolvedFamily,
          fontPackage: fontPackage,
        );
      },
    },
    getters: {
      'codePoint': (visitor, target) =>
          D4.validateTarget<IconData>(target, 'IconData').codePoint,
      'fontFamily': (visitor, target) =>
          D4.validateTarget<IconData>(target, 'IconData').fontFamily,
      'fontPackage': (visitor, target) =>
          D4.validateTarget<IconData>(target, 'IconData').fontPackage,
    },
  );

  for (final lib in [
    'package:dartnative/dartnative.dart',
    'package:dartnative/flutter_compat.dart',
    'package:dartnative/src/widgets/image.dart',
    'package:flutter/material.dart',
    'package:flutter/widgets.dart',
    'package:flutter/painting.dart',
    'package:flutter/cupertino.dart',
  ]) {
    interpreter.registerBridgedClass(imageBridge, lib);
    interpreter.registerBridgedClass(assetImageBridge, lib);
  }
  for (final lib in [
    'package:dartnative/dartnative.dart',
    'package:dartnative/flutter_compat.dart',
    'package:dartnative/src/widgets/icon_data.dart',
    'package:flutter/material.dart',
    'package:flutter/widgets.dart',
    'package:flutter/cupertino.dart',
  ]) {
    interpreter.registerBridgedClass(iconDataBridge, lib);
  }

  // ── Helper: download a guest asset over HTTP and persist to disk cache ────
  Future<Uint8List?> downloadAssetBytes(String assetPath) async {
    final serverUrl = provider();
    if (serverUrl == null || serverUrl.isEmpty) return null;
    final url = AstAssetResolver.resolveAssetUrl(serverUrl, assetPath);
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    try {
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close().timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) {
        await res.drain<void>();
        return null;
      }
      final builder = BytesBuilder(copy: false);
      await for (final chunk in res) {
        builder.add(chunk);
      }
      final bytes = builder.takeBytes();
      final saver = AstAssetResolver.saveCachedAssetProvider;
      if (saver != null && bytes.isNotEmpty) {
        await saver(assetPath, bytes);
      }
      return bytes;
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  // ── Top-level `loadAssetBytes(String assetKey)` override ──────────────────
  // Guest code (e.g. Spotify lyrics.lrc, canvas_loop.mp4) reads bundled guest
  // assets synchronously via `loadAssetBytes`. Check local disk cache first
  // before falling back to the host app bundle.
  Object? loadAssetBytesHandler(
    InterpreterVisitor visitor,
    List<Object?> positional,
    Map<String, Object?> named,
    List<RuntimeType>? typeArgs,
  ) {
    D4.requireMinArgs(positional, 1, 'loadAssetBytes');
    final assetKey = D4.getRequiredArg<String>(
      positional,
      0,
      'assetKey',
      'loadAssetBytes',
    );
    final cached = fileProvider(assetKey);
    if (cached != null && cached.existsSync()) {
      try {
        return cached.readAsBytesSync();
      } catch (_) {}
    }
    final native = loadAssetBytes(assetKey);
    if (native != null) return native;
    // Kick off a background fetch so a subsequent read hits disk cache.
    unawaited(downloadAssetBytes(assetKey));
    return null;
  }

  for (final lib in [
    'package:dartnative/dartnative.dart',
    'package:dartnative/flutter_compat.dart',
    'package:dartnative/src/framework.dart',
  ]) {
    interpreter.registertopLevelFunction(
      'loadAssetBytes',
      loadAssetBytesHandler,
      lib,
      signature: 'Uint8List? loadAssetBytes(String assetKey)',
    );
  }

  // ── Asset-aware `Lottie` & `LottiePreWarm` overrides ──────────────────────
  // `Lottie(asset: 'assets/stickers/...')` normally reads from the host iOS/Android
  // app bundle where guest stickers don't exist. Resolve via in-memory warmed
  // JSON cache -> disk cache -> HTTP URL so both Stickers Keyboard and
  // Sticker Grid (Assets) render immediately.
  final lottieBridge = BridgedClass(
    nativeType: dn_lottie.Lottie,
    name: 'Lottie',
    isAssignable: (v) => v is dn_lottie.Lottie,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<Key?>(named, 'key');
        var asset = D4.getOptionalNamedArg<String?>(named, 'asset');
        var json = D4.getOptionalNamedArg<String?>(named, 'json');
        var url = D4.getOptionalNamedArg<String?>(named, 'url');
        final cachePolicy = D4
            .getNamedArgWithDefault<dn_lottie.LottieCachePolicy>(
              named,
              'cachePolicy',
              dn_lottie.LottieCachePolicy.disk,
            );
        final loop = D4.getNamedArgWithDefault<bool>(named, 'loop', false);
        final autoplay = D4.getNamedArgWithDefault<bool>(
          named,
          'autoplay',
          true,
        );
        final speed = D4.getNamedArgWithDefault<double>(named, 'speed', 1.0);
        final fit = D4.getNamedArgWithDefault<dn_lottie.LottieFit>(
          named,
          'fit',
          dn_lottie.LottieFit.contain,
        );
        final controller = D4.getOptionalNamedArg<dn_lottie.LottieController?>(
          named,
          'controller',
        );
        final renderCache = D4.getNamedArgWithDefault<dn_lottie.RenderCache>(
          named,
          'renderCache',
          dn_lottie.RenderCache.none,
        );
        final placeholder = D4.getOptionalNamedArg<Widget?>(
          named,
          'placeholder',
        );

        if (asset != null && json == null && url == null) {
          final serverUrl = provider();
          final resolvedUrl = (serverUrl != null && serverUrl.isNotEmpty)
              ? AstAssetResolver.resolveAssetUrl(serverUrl, asset)
              : null;
          final memJson = resolvedUrl != null
              ? AstAssetResolver._lottieJsonCache[resolvedUrl]
              : null;
          if (memJson != null) {
            json = memJson;
            asset = null;
          } else {
            final cached = fileProvider(asset);
            if (cached != null && cached.existsSync()) {
              try {
                final text = cached.readAsStringSync();
                if (resolvedUrl != null) {
                  AstAssetResolver._lottieJsonCache[resolvedUrl] = text;
                }
                json = text;
                asset = null;
              } catch (_) {}
            } else if (resolvedUrl != null) {
              url = resolvedUrl;
              asset = null;
            }
          }
        }

        return dn_lottie.Lottie(
          key: key,
          asset: asset,
          json: json,
          url: url,
          cachePolicy: cachePolicy,
          loop: loop,
          autoplay: autoplay,
          speed: speed,
          fit: fit,
          controller: controller,
          renderCache: renderCache,
          placeholder: placeholder,
        );
      },
      'network': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Lottie');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'Lottie');
        final key = D4.getOptionalNamedArg<Key?>(named, 'key');
        final cachePolicy = D4
            .getNamedArgWithDefault<dn_lottie.LottieCachePolicy>(
              named,
              'cachePolicy',
              dn_lottie.LottieCachePolicy.disk,
            );
        final loop = D4.getNamedArgWithDefault<bool>(named, 'loop', false);
        final autoplay = D4.getNamedArgWithDefault<bool>(
          named,
          'autoplay',
          true,
        );
        final speed = D4.getNamedArgWithDefault<double>(named, 'speed', 1.0);
        final fit = D4.getNamedArgWithDefault<dn_lottie.LottieFit>(
          named,
          'fit',
          dn_lottie.LottieFit.contain,
        );
        final controller = D4.getOptionalNamedArg<dn_lottie.LottieController?>(
          named,
          'controller',
        );
        final renderCache = D4.getNamedArgWithDefault<dn_lottie.RenderCache>(
          named,
          'renderCache',
          dn_lottie.RenderCache.none,
        );
        final placeholder = D4.getOptionalNamedArg<Widget?>(
          named,
          'placeholder',
        );
        return dn_lottie.Lottie.network(
          url,
          key: key,
          cachePolicy: cachePolicy,
          loop: loop,
          autoplay: autoplay,
          speed: speed,
          fit: fit,
          controller: controller,
          renderCache: renderCache,
          placeholder: placeholder,
        );
      },
    },
    getters: {
      'asset': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').asset,
      'json': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').json,
      'url': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').url,
      'cachePolicy': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').cachePolicy,
      'loop': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').loop,
      'autoplay': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').autoplay,
      'speed': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').speed,
      'fit': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').fit,
      'controller': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').controller,
      'renderCache': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').renderCache,
      'placeholder': (visitor, target) =>
          D4.validateTarget<dn_lottie.Lottie>(target, 'Lottie').placeholder,
    },
  );

  final lottiePreWarmBridge = BridgedClass(
    nativeType: dn_lottie.LottiePreWarm,
    name: 'LottiePreWarm',
    isAssignable: (v) => v is dn_lottie.LottiePreWarm,
    constructors: {},
    staticMethods: {
      'warmAssets': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'warmAssets');
        final assetPaths = D4.coerceList<String>(positional[0], 'assetPaths');
        final size = D4.getOptionalNamedArg<Size?>(named, 'size');
        final renderCache = D4.getNamedArgWithDefault<dn_lottie.RenderCache>(
          named,
          'renderCache',
          dn_lottie.RenderCache.none,
        );
        final onProgressRaw = named['onProgress'];
        final onProgress = onProgressRaw == null
            ? null
            : (int p0, int p1) {
                D4.callInterpreterCallback(visitor, onProgressRaw, [p0, p1]);
              };
        final serverUrl = provider();
        if (serverUrl == null || serverUrl.isEmpty) {
          return dn_lottie.LottiePreWarm.warmAssets(
            assetPaths,
            size: size,
            renderCache: renderCache,
            onProgress: onProgress,
          );
        }
        // Pre-fetch guest Lottie JSON assets over HTTP into memory + disk cache
        // (up to 8 concurrent requests) so opening the sticker sheet renders
        // instantaneously with zero bundle misses.
        return () async {
          final total = assetPaths.length;
          var done = 0;
          var next = 0;
          Future<void> worker() async {
            while (true) {
              final idx = next++;
              if (idx >= total) return;
              final path = assetPaths[idx];
              final resolvedUrl = AstAssetResolver.resolveAssetUrl(
                serverUrl,
                path,
              );
              if (!AstAssetResolver._lottieJsonCache.containsKey(resolvedUrl)) {
                final cached = fileProvider(path);
                if (cached != null && cached.existsSync()) {
                  try {
                    AstAssetResolver._lottieJsonCache[resolvedUrl] =
                        await cached.readAsString();
                  } catch (_) {}
                } else {
                  final bytes = await downloadAssetBytes(path);
                  if (bytes != null && bytes.isNotEmpty) {
                    try {
                      AstAssetResolver._lottieJsonCache[resolvedUrl] =
                          String.fromCharCodes(bytes);
                    } catch (_) {}
                  }
                }
              }
              done++;
              onProgress?.call(done, total);
            }
          }

          final workers = total < 8 ? total : 8;
          await Future.wait([for (var i = 0; i < workers; i++) worker()]);
        }();
      },
    },
  );

  for (final lib in [
    'package:dartnative_lottie/dartnative_lottie.dart',
    'package:dartnative_lottie/src/lottie.dart',
  ]) {
    interpreter.registerBridgedClass(lottieBridge, lib);
  }
  for (final lib in [
    'package:dartnative_lottie/dartnative_lottie.dart',
    'package:dartnative_lottie/src/lottie_prewarm.dart',
  ]) {
    interpreter.registerBridgedClass(lottiePreWarmBridge, lib);
  }

  // ── Asset-aware `AudioPlayer.setAsset` override ───────────────────────────
  // Tracks players currently downloading a cold guest audio asset so a
  // back-to-back `a.setAsset(key); a.play();` replays `play()` once `setPath`
  // lands on disk.
  final loadingPlayers = <dn_audio.AudioPlayer, bool>{};
  final disposedPlayers = Expando<bool>('dngo.audioDisposed');

  final audioPlayerBridge = BridgedClass(
    nativeType: dn_audio.AudioPlayer,
    name: 'AudioPlayer',
    isAssignable: (v) => v is dn_audio.AudioPlayer,
    constructors: {
      '': (visitor, positional, named) => dn_audio.AudioPlayer(),
    },
    getters: {
      'positionUpdateInterval': (visitor, target) => D4
          .validateTarget<dn_audio.AudioPlayer>(
            target,
            'AudioPlayer',
          )
          .positionUpdateInterval,
      'events': (visitor, target) =>
          D4.validateTarget<dn_audio.AudioPlayer>(target, 'AudioPlayer').events,
      'positionStream': (visitor, target) => D4
          .validateTarget<dn_audio.AudioPlayer>(target, 'AudioPlayer')
          .positionStream,
      'isPlaying': (visitor, target) => D4
          .validateTarget<dn_audio.AudioPlayer>(target, 'AudioPlayer')
          .isPlaying,
      'duration': (visitor, target) => D4
          .validateTarget<dn_audio.AudioPlayer>(target, 'AudioPlayer')
          .duration,
      'position': (visitor, target) => D4
          .validateTarget<dn_audio.AudioPlayer>(target, 'AudioPlayer')
          .position,
    },
    setters: {
      'positionUpdateInterval': (visitor, target, value) =>
          D4
              .validateTarget<dn_audio.AudioPlayer>(target, 'AudioPlayer')
              .positionUpdateInterval = D4.extractBridgedArg<Duration>(
            value,
            'positionUpdateInterval',
          ),
    },
    methods: {
      'setAsset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<dn_audio.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'setAsset');
        final assetKey = D4.getRequiredArg<String>(
          positional,
          0,
          'assetKey',
          'setAsset',
        );
        final cached = fileProvider(assetKey);
        if (cached != null && cached.existsSync()) {
          t.setPath(cached.path);
          return null;
        }
        final serverUrl = provider();
        if (serverUrl != null && serverUrl.isNotEmpty) {
          loadingPlayers[t] = false;
          unawaited(
            downloadAssetBytes(assetKey).then((bytes) async {
              final shouldPlay = loadingPlayers.remove(t) ?? false;
              if (disposedPlayers[t] == true) return;
              if (bytes == null || bytes.isEmpty) {
                t.setAsset(assetKey);
                if (shouldPlay) t.play();
                return;
              }
              var file = fileProvider(assetKey);
              if (file == null || !file.existsSync()) {
                final safe = assetKey.replaceAll(
                  RegExp(r'[^A-Za-z0-9._-]'),
                  '_',
                );
                file = File('${Directory.systemTemp.path}/dngo_audio_$safe');
                await file.writeAsBytes(bytes, flush: true);
              }
              if (disposedPlayers[t] == true) return;
              t.setPath(file.path);
              if (shouldPlay) t.play();
            }),
          );
          return null;
        }
        t.setAsset(assetKey);
        return null;
      },
      'setPath': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<dn_audio.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'setPath');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'setPath',
        );
        loadingPlayers.remove(t);
        t.setPath(path);
        return null;
      },
      'play': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<dn_audio.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        if (loadingPlayers.containsKey(t)) {
          loadingPlayers[t] = true;
          return null;
        }
        t.play();
        return null;
      },
      'pause': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<dn_audio.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        if (loadingPlayers.containsKey(t)) {
          loadingPlayers[t] = false;
          return null;
        }
        t.pause();
        return null;
      },
      'stop': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<dn_audio.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        loadingPlayers.remove(t);
        t.stop();
        return null;
      },
      'seek': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<dn_audio.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'seek');
        final position = D4.getRequiredArg<Duration>(
          positional,
          0,
          'position',
          'seek',
        );
        t.seek(position);
        return null;
      },
      'setVolume': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<dn_audio.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'setVolume');
        final v = D4.getRequiredArg<double>(positional, 0, 'v', 'setVolume');
        t.setVolume(v);
        return null;
      },
      'setLooping': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<dn_audio.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'setLooping');
        final loop = D4.getRequiredArg<bool>(
          positional,
          0,
          'loop',
          'setLooping',
        );
        t.setLooping(loop);
        return null;
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<dn_audio.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        disposedPlayers[t] = true;
        loadingPlayers.remove(t);
        (t as dynamic).dispose();
        return null;
      },
    },
  );

  for (final lib in [
    'package:dartnative_audio/dartnative_audio.dart',
    'package:dartnative_audio/src/audio_player.dart',
  ]) {
    interpreter.registerBridgedClass(audioPlayerBridge, lib);
  }

  // ── `dartnative_path_provider` x86_64 simulator fallback ──────────────────
  // `dartnative_path_provider.xcframework` ships an arm64-only simulator slice,
  // so `dlsym` throws `ArgumentError` on Intel x86_64 simulators. Call the real
  // native plugin first and fall back to standard iOS sandbox dirs via dart:io.
  String fallbackSandboxDir(String subDir) {
    final home = Platform.environment['HOME'];
    final base = (home != null && home.isNotEmpty)
        ? '$home/$subDir'
        : '${Directory.systemTemp.path}/dngo_${subDir.replaceAll('/', '_')}';
    final dir = Directory(base);
    if (!dir.existsSync()) {
      try {
        dir.createSync(recursive: true);
      } catch (_) {}
    }
    return dir.path;
  }

  String safePathCall(String Function() nativeFn, String Function() fallback) {
    try {
      return nativeFn();
    } on ArgumentError {
      return fallback();
    } on UnsupportedError {
      return fallback();
    }
  }

  final pathFns = <String, NativeFunctionImpl>{
    'getTemporaryDirectory': (v, p, n, t) => safePathCall(
      dn_path_provider.getTemporaryDirectory,
      () => Directory.systemTemp.path,
    ),
    'getApplicationDocumentsDirectory': (v, p, n, t) => safePathCall(
      dn_path_provider.getApplicationDocumentsDirectory,
      () => fallbackSandboxDir('Documents'),
    ),
    'getApplicationSupportDirectory': (v, p, n, t) => safePathCall(
      dn_path_provider.getApplicationSupportDirectory,
      () => fallbackSandboxDir('Library/Application Support'),
    ),
    'getApplicationCacheDirectory': (v, p, n, t) => safePathCall(
      dn_path_provider.getApplicationCacheDirectory,
      () => fallbackSandboxDir('Library/Caches'),
    ),
  };
  for (final lib in [
    'package:dartnative_path_provider/dartnative_path_provider.dart',
    'package:dartnative_path_provider/src/path_provider_ios.dart',
  ]) {
    pathFns.forEach((name, fn) {
      interpreter.registertopLevelFunction(
        name,
        fn,
        lib,
        signature: 'String $name()',
      );
    });
  }
}

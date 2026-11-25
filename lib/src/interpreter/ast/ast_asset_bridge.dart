library;

import 'dart:io';
import 'dart:typed_data';

import 'package:dartnative/dartnative.dart';
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
}

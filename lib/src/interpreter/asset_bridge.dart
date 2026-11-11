import 'dart:io';
import 'dart:typed_data';

import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt/tom_d4rt.dart';

/// Provides the active dev server URL for asset resolution.
class AssetResolver {
  static String? activeServerUrl;
}

/// Registers asset-aware bridges for [Image] and [AssetImage] so that
/// `Image.asset(...)` and `AssetImage(...)` resolve over HTTP when running
/// with a live DartNative Go dev server.
void registerAssetAwareBridges(
  D4rt interpreter, {
  String? Function()? serverUrlProvider,
}) {
  final provider = serverUrlProvider ?? () => AssetResolver.activeServerUrl;

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
        final cacheWidth = D4.getOptionalNamedArg<int?>(named, 'cacheWidth');
        final cacheHeight = D4.getOptionalNamedArg<int?>(named, 'cacheHeight');

        final serverUrl = provider();
        if (serverUrl != null && serverUrl.isNotEmpty) {
          final cleanName = name.startsWith('/') ? name.substring(1) : name;
          final networkUrl = '$serverUrl/$cleanName';
          return Image.network(
            networkUrl,
            key: key,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
            errorWidget: Image.asset(
              name,
              key: key,
              width: width,
              height: height,
              fit: fit,
              color: color,
              alignment: alignment,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
            ),
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
        return Image.file(
          file,
          key: key,
          width: width,
          height: height,
          fit: fit,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
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
        return Image.memory(
          bytes,
          key: key,
          width: width,
          height: height,
          fit: fit,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
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
    },
  );

  final assetImageBridge = BridgedClass(
    nativeType: AssetImage,
    name: 'AssetImage',
    isAssignable: (v) => v is AssetImage || v is NetworkImage,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AssetImage');
        final assetName = D4.getRequiredArg<String>(
          positional,
          0,
          'assetName',
          'AssetImage',
        );
        final serverUrl = provider();
        if (serverUrl != null && serverUrl.isNotEmpty) {
          final cleanName = assetName.startsWith('/')
              ? assetName.substring(1)
              : assetName;
          return NetworkImage('$serverUrl/$cleanName');
        }
        return AssetImage(assetName);
      },
    },
    getters: {
      'assetName': (visitor, target) {
        if (target is AssetImage) return target.assetName;
        if (target is NetworkImage) return target.url;
        return target.toString();
      },
    },
  );

  for (final lib in [
    'package:dartnative/dartnative.dart',
    'package:dartnative/src/widgets/image.dart',
    'package:flutter/material.dart',
    'package:flutter/widgets.dart',
    'package:flutter/painting.dart',
  ]) {
    interpreter.registerBridgedClass(imageBridge, lib);
    interpreter.registerBridgedClass(assetImageBridge, lib);
  }
}

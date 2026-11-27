// D4rt Bridge - Generated file, do not edit
// Sources: 3 files
// Generated: 2026-11-24T16:25:48.979789 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';
import 'dart:io';

import 'package:dartnative_compressor/src/compressor_ffi_bindings.dart'
    as $dartnative_compressor_1;
import 'package:dartnative_compressor/src/dartnative_compressor.dart'
    as $dartnative_compressor_2;
import 'package:dartnative_compressor/src/media_info.dart'
    as $dartnative_compressor_3;

/// Bridge class for dartnative_compressor module.
class DartnativeCompressorBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createDartNativeCompressorBridge(),
      _createCompressorFFIBindingsBridge(),
      _createMediaInfoBridge(),
      _createVideoInfoBridge(),
      _createImageInfoBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'DartNativeCompressor': _createDartNativeCompressorBridge,
      'CompressorFFIBindings': _createCompressorFFIBindingsBridge,
      'MediaInfo': _createMediaInfoBridge,
      'VideoInfo': _createVideoInfoBridge,
      'ImageInfo': _createImageInfoBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'DartNativeCompressor': $dartnative_compressor_2.DartNativeCompressor,
      'CompressorFFIBindings': $dartnative_compressor_1.CompressorFFIBindings,
      'MediaInfo': $dartnative_compressor_3.MediaInfo,
      'VideoInfo': $dartnative_compressor_3.VideoInfo,
      'ImageInfo': $dartnative_compressor_3.ImageInfo,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'DartNativeCompressor':
          'package:dartnative_compressor/src/dartnative_compressor.dart',
      'CompressorFFIBindings':
          'package:dartnative_compressor/src/compressor_ffi_bindings.dart',
      'MediaInfo': 'package:dartnative_compressor/src/media_info.dart',
      'VideoInfo': 'package:dartnative_compressor/src/media_info.dart',
      'ImageInfo': 'package:dartnative_compressor/src/media_info.dart',
    };
  }

  /// Returns a map of class names to their flattened (transitive)
  /// native supertype names (superclasses, interfaces and mixins).
  ///
  /// Fed to `BridgedClass.registerSupertypes` so interpreted subclasses
  /// of bridged classes pass `is`/subtype checks against bridged
  /// ancestors and the interface-proxy supertype walk resolves up the
  /// chain.
  static Map<String, List<String>> classSupertypes() {
    return {
      'VideoInfo': ['MediaInfo'],
      'ImageInfo': ['MediaInfo'],
    };
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {};
  }

  /// Returns the list of function typedef names declared in this library.
  ///
  /// Function typedefs like `typedef VoidCallback = void Function()` are
  /// registered so that they can be used as type arguments in D4rt scripts.
  static List<String> functionTypedefs() {
    return [];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dartnative_compressor_2.VideoQuality>(
        name: 'VideoQuality',
        values: $dartnative_compressor_2.VideoQuality.values,
      ),
      BridgedEnumDefinition<$dartnative_compressor_2.CropAnchor>(
        name: 'CropAnchor',
        values: $dartnative_compressor_2.CropAnchor.values,
        getters: {
          'value': (visitor, target) =>
              (target as $dartnative_compressor_2.CropAnchor).value,
        },
      ),
      BridgedEnumDefinition<$dartnative_compressor_2.CropAspectRatio>(
        name: 'CropAspectRatio',
        values: $dartnative_compressor_2.CropAspectRatio.values,
        getters: {
          'value': (visitor, target) =>
              (target as $dartnative_compressor_2.CropAspectRatio).value,
        },
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'VideoQuality':
          'package:dartnative_compressor/src/dartnative_compressor.dart',
      'CropAnchor':
          'package:dartnative_compressor/src/dartnative_compressor.dart',
      'CropAspectRatio':
          'package:dartnative_compressor/src/dartnative_compressor.dart',
    };
  }

  /// Returns all bridged extension definitions.
  static List<BridgedExtensionDefinition> bridgedExtensions() {
    return [];
  }

  /// Returns a map of extension identifiers to their canonical source URIs.
  static Map<String, String> extensionSourceUris() {
    return {};
  }

  /// GEN-107: Library re-exports declared by the bridged source
  /// libraries. Each tuple mirrors a Dart `export '…'` directive.
  /// Consumed by `registerBridges` via `D4rt.registerLibraryReExport`
  /// (mirrored on `D4rtRunner` in tom_d4rt_ast).
  static List<
    ({String source, String target, Set<String>? show, Set<String>? hide})
  >
  bridgeReExports() {
    return [
      (
        source: 'package:dartnative_compressor/dartnative_compressor.dart',
        target: 'package:dartnative_compressor/src/dartnative_compressor.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_compressor/dartnative_compressor.dart',
        target:
            'package:dartnative_compressor/src/compressor_ffi_bindings.dart',
        show: {'CompressorFFIBindings'},
        hide: null,
      ),
      (
        source: 'package:dartnative_compressor/dartnative_compressor.dart',
        target: 'package:dartnative_compressor/src/media_info.dart',
        show: null,
        hide: null,
      ),
    ];
  }

  /// Registers all bridges with an interpreter.
  ///
  /// [importPath] is the package import path that D4rt scripts will use
  /// to access these classes (e.g., 'package:tom_build/tom.dart').
  static void registerBridges(D4rt interpreter, String importPath) {
    // Step #17 — register deferred factory thunks (not pre-built
    // BridgedClass objects): a script touching N of the M classes
    // materializes ≈N (each thunk builds its class on first resolve).
    final classThunks = bridgeClassThunks();
    final classTypes = bridgeClassTypes();
    final classSources = classSourceUris();
    for (final entry in classThunks.entries) {
      interpreter.registerBridgedClassLazy(
        entry.key,
        classTypes[entry.key]!,
        entry.value,
        importPath,
        sourceUri: classSources[entry.key],
      );
    }

    // Register the flattened native supertype table so
    // interpreted subclasses pass subtype checks against bridged
    // ancestors. Idempotent — safe to call per barrel.
    BridgedClass.registerSupertypes(classSupertypes());

    // Register bridged enums with source URIs for deduplication
    final enums = bridgedEnums();
    final enumSources = enumSourceUris();
    for (final enumDef in enums) {
      interpreter.registerBridgedEnum(
        enumDef,
        importPath,
        sourceUri: enumSources[enumDef.name],
      );
    }

    // GEN-107: Register library re-exports
    for (final r in bridgeReExports()) {
      interpreter.registerLibraryReExport(
        r.source,
        r.target,
        show: r.show,
        hide: r.hide,
      );
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {};
  }

  /// Returns a map of global function names to their canonical source URIs.
  static Map<String, String> globalFunctionSourceUris() {
    return {};
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {};
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative_compressor/src/compressor_ffi_bindings.dart',
      'package:dartnative_compressor/src/dartnative_compressor.dart',
      'package:dartnative_compressor/src/media_info.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_compressor/dartnative_compressor.dart';";
  }

  /// Returns barrel import URIs for sub-packages discovered through re-exports.
  ///
  /// When a module follows re-exports into sub-packages (e.g., dcli re-exports
  /// dcli_core), D4rt scripts may import those sub-packages directly.
  /// These barrels need to be registered with the interpreter separately
  /// so that module resolution finds content for those URIs.
  static List<String> subPackageBarrels() {
    return [];
  }

  /// Returns a list of bridged enum names.
  static List<String> get enumNames => [
    'VideoQuality',
    'CropAnchor',
    'CropAspectRatio',
  ];
}

// =============================================================================
// DartNativeCompressor Bridge
// =============================================================================

BridgedClass _createDartNativeCompressorBridge() {
  return BridgedClass(
    nativeType: $dartnative_compressor_2.DartNativeCompressor,
    name: 'DartNativeCompressor',
    isAssignable: (v) => v is $dartnative_compressor_2.DartNativeCompressor,
    constructors: {},
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_compressor_2.DartNativeCompressor.loadSymbols();
      },
      'compressVideo': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'compressVideo');
        final file = D4.getRequiredArg<File>(
          positional,
          0,
          'file',
          'compressVideo',
        );
        final outputPath = D4.getOptionalNamedArg<String?>(named, 'outputPath');
        final quality = D4
            .getNamedArgWithDefault<$dartnative_compressor_2.VideoQuality>(
              named,
              'quality',
              $dartnative_compressor_2.VideoQuality.p720,
            );
        final customBitRate = D4.getNamedArgWithDefault<int>(
          named,
          'customBitRate',
          5,
        );
        final onProgressRaw = named['onProgress'];
        final onProgress = onProgressRaw == null
            ? null
            : (double p0) {
                D4.callInterpreterCallback(visitor!, onProgressRaw, [p0]);
              };
        return $dartnative_compressor_2.DartNativeCompressor.compressVideo(
          file,
          outputPath: outputPath,
          quality: quality,
          customBitRate: customBitRate,
          onProgress: onProgress,
        );
      },
      'compressImage': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'compressImage');
        final filePath = D4.getRequiredArg<String>(
          positional,
          0,
          'filePath',
          'compressImage',
        );
        final outputPath = D4.getOptionalNamedArg<String?>(named, 'outputPath');
        final quality = D4.getNamedArgWithDefault<int>(named, 'quality', 80);
        final maxWidth = D4.getOptionalNamedArg<int?>(named, 'maxWidth');
        final maxHeight = D4.getOptionalNamedArg<int?>(named, 'maxHeight');
        final maxDimension = D4.getOptionalNamedArg<int?>(
          named,
          'maxDimension',
        );
        final crop = D4.getNamedArgWithDefault<double>(named, 'crop', 1.0);
        final cropAnchor = D4
            .getNamedArgWithDefault<$dartnative_compressor_2.CropAnchor>(
              named,
              'cropAnchor',
              $dartnative_compressor_2.CropAnchor.center,
            );
        final cropAspectRatio = D4
            .getNamedArgWithDefault<$dartnative_compressor_2.CropAspectRatio>(
              named,
              'cropAspectRatio',
              $dartnative_compressor_2.CropAspectRatio.original,
            );
        final aspectRatioWidth = D4.getNamedArgWithDefault<double>(
          named,
          'aspectRatioWidth',
          1.0,
        );
        final aspectRatioHeight = D4.getNamedArgWithDefault<double>(
          named,
          'aspectRatioHeight',
          1.0,
        );
        final onProgressRaw = named['onProgress'];
        final onProgress = onProgressRaw == null
            ? null
            : (double p0) {
                D4.callInterpreterCallback(visitor!, onProgressRaw, [p0]);
              };
        return $dartnative_compressor_2.DartNativeCompressor.compressImage(
          filePath,
          outputPath: outputPath,
          quality: quality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          maxDimension: maxDimension,
          crop: crop,
          cropAnchor: cropAnchor,
          cropAspectRatio: cropAspectRatio,
          aspectRatioWidth: aspectRatioWidth,
          aspectRatioHeight: aspectRatioHeight,
          onProgress: onProgress,
        );
      },
      'getVideoInfo': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'getVideoInfo');
        final file = D4.getRequiredArg<File>(
          positional,
          0,
          'file',
          'getVideoInfo',
        );
        return $dartnative_compressor_2.DartNativeCompressor.getVideoInfo(file);
      },
      'getImageInfo': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'getImageInfo');
        final file = D4.getRequiredArg<File>(
          positional,
          0,
          'file',
          'getImageInfo',
        );
        return $dartnative_compressor_2.DartNativeCompressor.getImageInfo(file);
      },
      'getVideoThumbnail': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'getVideoThumbnail');
        final file = D4.getRequiredArg<File>(
          positional,
          0,
          'file',
          'getVideoThumbnail',
        );
        final thumbnailPath = D4.getOptionalNamedArg<String?>(
          named,
          'thumbnailPath',
        );
        final quality = D4.getNamedArgWithDefault<int>(named, 'quality', 100);
        final timeMs = D4.getOptionalNamedArg<int?>(named, 'timeMs');
        return $dartnative_compressor_2.DartNativeCompressor.getVideoThumbnail(
          file,
          thumbnailPath: thumbnailPath,
          quality: quality,
          timeMs: timeMs,
        );
      },
      'saveToGallery': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'saveToGallery');
        final file = D4.getRequiredArg<File>(
          positional,
          0,
          'file',
          'saveToGallery',
        );
        final mediaType = D4.getNamedArgWithDefault<String>(
          named,
          'mediaType',
          'image',
        );
        return $dartnative_compressor_2.DartNativeCompressor.saveToGallery(
          file,
          mediaType: mediaType,
        );
      },
      'cancelCompression': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'cancelCompression');
        final compressionId = D4.getRequiredArg<String>(
          positional,
          0,
          'compressionId',
          'cancelCompression',
        );
        return $dartnative_compressor_2.DartNativeCompressor.cancelCompression(
          compressionId,
        );
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'compressVideo':
          'Future<File?> compressVideo(File file, {String? outputPath, VideoQuality quality = VideoQuality.p720, int customBitRate = 5, void Function(double)? onProgress})',
      'compressImage':
          'Future<File?> compressImage(String filePath, {String? outputPath, int quality = 80, int? maxWidth, int? maxHeight, int? maxDimension, double crop = 1.0, CropAnchor cropAnchor = CropAnchor.center, CropAspectRatio cropAspectRatio = CropAspectRatio.original, double aspectRatioWidth = 1.0, double aspectRatioHeight = 1.0, void Function(double)? onProgress})',
      'getVideoInfo': 'Future<VideoInfo> getVideoInfo(File file)',
      'getImageInfo': 'Future<ImageInfo> getImageInfo(File file)',
      'getVideoThumbnail':
          'Future<File?> getVideoThumbnail(File file, {String? thumbnailPath, int quality = 100, int? timeMs})',
      'saveToGallery':
          'Future<bool> saveToGallery(File file, {String mediaType = \'image\'})',
      'cancelCompression': 'void cancelCompression(String compressionId)',
    },
  );
}

// =============================================================================
// CompressorFFIBindings Bridge
// =============================================================================

BridgedClass _createCompressorFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_compressor_1.CompressorFFIBindings,
    name: 'CompressorFFIBindings',
    isAssignable: (v) => v is $dartnative_compressor_1.CompressorFFIBindings,
    constructors: {},
    methods: {
      'compressVideo': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_compressor_1.CompressorFFIBindings>(
              target,
              'CompressorFFIBindings',
            );
        final path = D4.getRequiredNamedArg<String>(
          named,
          'path',
          'compressVideo',
        );
        final outputPath = D4.getOptionalNamedArg<String?>(named, 'outputPath');
        final quality = D4.getRequiredNamedArg<String>(
          named,
          'quality',
          'compressVideo',
        );
        final customBitRate = D4.getNamedArgWithDefault<int>(
          named,
          'customBitRate',
          5,
        );
        final progressCallbackRaw = named['progressCallback'];
        return t.compressVideo(
          path: path,
          outputPath: outputPath,
          quality: quality,
          customBitRate: customBitRate,
          progressCallback: progressCallbackRaw == null
              ? null
              : (double p0) {
                  D4.callInterpreterCallback(visitor!, progressCallbackRaw, [
                    p0,
                  ]);
                },
        );
      },
      'compressImage': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_compressor_1.CompressorFFIBindings>(
              target,
              'CompressorFFIBindings',
            );
        final path = D4.getRequiredNamedArg<String>(
          named,
          'path',
          'compressImage',
        );
        final outputPath = D4.getOptionalNamedArg<String?>(named, 'outputPath');
        final quality = D4.getNamedArgWithDefault<int>(named, 'quality', 80);
        final maxWidth = D4.getNamedArgWithDefault<int>(named, 'maxWidth', 0);
        final maxHeight = D4.getNamedArgWithDefault<int>(named, 'maxHeight', 0);
        final maxDimension = D4.getNamedArgWithDefault<int>(
          named,
          'maxDimension',
          0,
        );
        final crop = D4.getNamedArgWithDefault<int>(named, 'crop', 100);
        final cropAnchor = D4.getNamedArgWithDefault<int>(
          named,
          'cropAnchor',
          0,
        );
        final cropAspectRatio = D4.getNamedArgWithDefault<int>(
          named,
          'cropAspectRatio',
          1,
        );
        final aspectW = D4.getNamedArgWithDefault<int>(named, 'aspectW', 100);
        final aspectH = D4.getNamedArgWithDefault<int>(named, 'aspectH', 100);
        return t.compressImage(
          path: path,
          outputPath: outputPath,
          quality: quality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          maxDimension: maxDimension,
          crop: crop,
          cropAnchor: cropAnchor,
          cropAspectRatio: cropAspectRatio,
          aspectW: aspectW,
          aspectH: aspectH,
        );
      },
      'getVideoInfo': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_compressor_1.CompressorFFIBindings>(
              target,
              'CompressorFFIBindings',
            );
        D4.requireMinArgs(positional, 1, 'getVideoInfo');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'getVideoInfo',
        );
        return t.getVideoInfo(path);
      },
      'getImageInfo': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_compressor_1.CompressorFFIBindings>(
              target,
              'CompressorFFIBindings',
            );
        D4.requireMinArgs(positional, 1, 'getImageInfo');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'getImageInfo',
        );
        return t.getImageInfo(path);
      },
      'getVideoThumbnail': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_compressor_1.CompressorFFIBindings>(
              target,
              'CompressorFFIBindings',
            );
        final path = D4.getRequiredNamedArg<String>(
          named,
          'path',
          'getVideoThumbnail',
        );
        final thumbnailPath = D4.getOptionalNamedArg<String?>(
          named,
          'thumbnailPath',
        );
        final quality = D4.getNamedArgWithDefault<int>(named, 'quality', 100);
        final timeMs = D4.getOptionalNamedArg<int?>(named, 'timeMs');
        return t.getVideoThumbnail(
          path: path,
          thumbnailPath: thumbnailPath,
          quality: quality,
          timeMs: timeMs,
        );
      },
      'saveToGallery': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_compressor_1.CompressorFFIBindings>(
              target,
              'CompressorFFIBindings',
            );
        D4.requireMinArgs(positional, 2, 'saveToGallery');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'saveToGallery',
        );
        final mediaType = D4.getRequiredArg<String>(
          positional,
          1,
          'mediaType',
          'saveToGallery',
        );
        return t.saveToGallery(path, mediaType);
      },
      'cancelCompression': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_compressor_1.CompressorFFIBindings>(
              target,
              'CompressorFFIBindings',
            );
        D4.requireMinArgs(positional, 1, 'cancelCompression');
        final compressionId = D4.getRequiredArg<String>(
          positional,
          0,
          'compressionId',
          'cancelCompression',
        );
        t.cancelCompression(compressionId);
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) =>
          $dartnative_compressor_1.CompressorFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_compressor_1.CompressorFFIBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'compressVideo':
          'Future<CompressionResult> compressVideo({required String path, String? outputPath, required String quality, int customBitRate = 5, void Function(double)? progressCallback})',
      'compressImage':
          'Future<String?> compressImage({required String path, String? outputPath, int quality = 80, int maxWidth = 0, int maxHeight = 0, int maxDimension = 0, int crop = 100, int cropAnchor = 0, int cropAspectRatio = 1, int aspectW = 100, int aspectH = 100})',
      'getVideoInfo': 'Future<String> getVideoInfo(String path)',
      'getImageInfo': 'Future<String> getImageInfo(String path)',
      'getVideoThumbnail':
          'Future<String?> getVideoThumbnail({required String path, String? thumbnailPath, int quality = 100, int? timeMs})',
      'saveToGallery':
          'Future<bool> saveToGallery(String path, String mediaType)',
      'cancelCompression': 'void cancelCompression(String compressionId)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'CompressorFFIBindings get instance',
    },
  );
}

// =============================================================================
// MediaInfo Bridge
// =============================================================================

BridgedClass _createMediaInfoBridge() {
  return BridgedClass(
    nativeType: $dartnative_compressor_3.MediaInfo,
    name: 'MediaInfo',
    isAssignable: (v) => v is $dartnative_compressor_3.MediaInfo,
    isAbstract: true,
    constructors: {},
    getters: {
      'path': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.MediaInfo>(
            target,
            'MediaInfo',
          )
          .path,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.MediaInfo>(
            target,
            'MediaInfo',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.MediaInfo>(
            target,
            'MediaInfo',
          )
          .height,
      'filesize': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.MediaInfo>(
            target,
            'MediaInfo',
          )
          .filesize,
      'file': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.MediaInfo>(
            target,
            'MediaInfo',
          )
          .file,
    },
    methods: {
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_compressor_3.MediaInfo>(
          target,
          'MediaInfo',
        );
        return t.toMap();
      },
    },
    methodSignatures: {
      'toMap': 'Map<String, dynamic> toMap()',
    },
    getterSignatures: {
      'path': 'String get path',
      'width': 'int? get width',
      'height': 'int? get height',
      'filesize': 'int? get filesize',
      'file': 'File? get file',
    },
  );
}

// =============================================================================
// VideoInfo Bridge
// =============================================================================

BridgedClass _createVideoInfoBridge() {
  return BridgedClass(
    nativeType: $dartnative_compressor_3.VideoInfo,
    name: 'VideoInfo',
    isAssignable: (v) => v is $dartnative_compressor_3.VideoInfo,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final path = D4.getRequiredNamedArg<String>(named, 'path', 'VideoInfo');
        final title = D4.getOptionalNamedArg<String?>(named, 'title');
        final author = D4.getOptionalNamedArg<String?>(named, 'author');
        final width = D4.getOptionalNamedArg<int?>(named, 'width');
        final height = D4.getOptionalNamedArg<int?>(named, 'height');
        final filesize = D4.getOptionalNamedArg<int?>(named, 'filesize');
        final duration = D4.getOptionalNamedArg<double?>(named, 'duration');
        final rotation = D4.getOptionalNamedArg<int?>(named, 'rotation');
        return $dartnative_compressor_3.VideoInfo(
          path: path,
          title: title,
          author: author,
          width: width,
          height: height,
          filesize: filesize,
          duration: duration,
          rotation: rotation,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'VideoInfo');
        final str = D4.getRequiredArg<String>(
          positional,
          0,
          'str',
          'VideoInfo',
        );
        return $dartnative_compressor_3.VideoInfo.fromJson(str);
      },
      'fromMap': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'VideoInfo');
        if (positional.isEmpty) {
          throw ArgumentError(
            'VideoInfo: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        return $dartnative_compressor_3.VideoInfo.fromMap(json);
      },
    },
    getters: {
      'path': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.VideoInfo>(
            target,
            'VideoInfo',
          )
          .path,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.VideoInfo>(
            target,
            'VideoInfo',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.VideoInfo>(
            target,
            'VideoInfo',
          )
          .height,
      'filesize': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.VideoInfo>(
            target,
            'VideoInfo',
          )
          .filesize,
      'file': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.VideoInfo>(
            target,
            'VideoInfo',
          )
          .file,
      'title': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.VideoInfo>(
            target,
            'VideoInfo',
          )
          .title,
      'author': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.VideoInfo>(
            target,
            'VideoInfo',
          )
          .author,
      'duration': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.VideoInfo>(
            target,
            'VideoInfo',
          )
          .duration,
      'rotation': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.VideoInfo>(
            target,
            'VideoInfo',
          )
          .rotation,
    },
    methods: {
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_compressor_3.VideoInfo>(
          target,
          'VideoInfo',
        );
        return t.toMap();
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_compressor_3.VideoInfo>(
          target,
          'VideoInfo',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'VideoInfo({required String path, String? title, String? author, int? width, int? height, int? filesize, double? duration, int? rotation})',
      'fromJson': 'factory VideoInfo.fromJson(String str)',
      'fromMap': 'factory VideoInfo.fromMap(Map<String, dynamic> json)',
    },
    methodSignatures: {
      'toMap': 'Map<String, dynamic> toMap()',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'path': 'String get path',
      'width': 'int? get width',
      'height': 'int? get height',
      'filesize': 'int? get filesize',
      'file': 'File? get file',
      'title': 'String? get title',
      'author': 'String? get author',
      'duration': 'double? get duration',
      'rotation': 'int? get rotation',
    },
  );
}

// =============================================================================
// ImageInfo Bridge
// =============================================================================

BridgedClass _createImageInfoBridge() {
  return BridgedClass(
    nativeType: $dartnative_compressor_3.ImageInfo,
    name: 'ImageInfo',
    isAssignable: (v) => v is $dartnative_compressor_3.ImageInfo,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final path = D4.getRequiredNamedArg<String>(named, 'path', 'ImageInfo');
        final width = D4.getOptionalNamedArg<int?>(named, 'width');
        final height = D4.getOptionalNamedArg<int?>(named, 'height');
        final filesize = D4.getOptionalNamedArg<int?>(named, 'filesize');
        final orientation = D4.getOptionalNamedArg<int?>(named, 'orientation');
        return $dartnative_compressor_3.ImageInfo(
          path: path,
          width: width,
          height: height,
          filesize: filesize,
          orientation: orientation,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'ImageInfo');
        final str = D4.getRequiredArg<String>(
          positional,
          0,
          'str',
          'ImageInfo',
        );
        return $dartnative_compressor_3.ImageInfo.fromJson(str);
      },
      'fromMap': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'ImageInfo');
        if (positional.isEmpty) {
          throw ArgumentError(
            'ImageInfo: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, dynamic>(positional[0], 'json');
        return $dartnative_compressor_3.ImageInfo.fromMap(json);
      },
    },
    getters: {
      'path': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.ImageInfo>(
            target,
            'ImageInfo',
          )
          .path,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.ImageInfo>(
            target,
            'ImageInfo',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.ImageInfo>(
            target,
            'ImageInfo',
          )
          .height,
      'filesize': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.ImageInfo>(
            target,
            'ImageInfo',
          )
          .filesize,
      'file': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.ImageInfo>(
            target,
            'ImageInfo',
          )
          .file,
      'orientation': (visitor, target) => D4
          .validateTarget<$dartnative_compressor_3.ImageInfo>(
            target,
            'ImageInfo',
          )
          .orientation,
    },
    methods: {
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_compressor_3.ImageInfo>(
          target,
          'ImageInfo',
        );
        return t.toMap();
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_compressor_3.ImageInfo>(
          target,
          'ImageInfo',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'ImageInfo({required String path, int? width, int? height, int? filesize, int? orientation})',
      'fromJson': 'factory ImageInfo.fromJson(String str)',
      'fromMap': 'factory ImageInfo.fromMap(Map<String, dynamic> json)',
    },
    methodSignatures: {
      'toMap': 'Map<String, dynamic> toMap()',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'path': 'String get path',
      'width': 'int? get width',
      'height': 'int? get height',
      'filesize': 'int? get filesize',
      'file': 'File? get file',
      'orientation': 'int? get orientation',
    },
  );
}

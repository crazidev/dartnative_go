// D4rt Bridge - Generated file, do not edit
// Sources: 3 files
// Generated: 2026-11-24T16:21:07.996093 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'dart:io';

import 'package:dartnative/src/core.dart' as $dartnative_1;
import 'package:dartnative/src/painting.dart' as $dartnative_2;
import 'package:dartnative_image_crop/src/crop.dart'
    as $dartnative_image_crop_1;
import 'package:dartnative_image_crop/src/dartnative_image_crop.dart'
    as $dartnative_image_crop_2;
import 'package:dartnative_image_crop/src/image_crop_ffi_bindings.dart'
    as $dartnative_image_crop_3;

/// Bridge class for dartnative_image_crop module.
class DartnativeImageCropBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createImageOptionsBridge(),
      _createDartNativeImageCropBridge(),
      _createCropBridge(),
      _createCropStateBridge(),
      _createImageCropFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'ImageOptions': _createImageOptionsBridge,
      'DartNativeImageCrop': _createDartNativeImageCropBridge,
      'Crop': _createCropBridge,
      'CropState': _createCropStateBridge,
      'ImageCropFFIBindings': _createImageCropFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'ImageOptions': $dartnative_image_crop_2.ImageOptions,
      'DartNativeImageCrop': $dartnative_image_crop_2.DartNativeImageCrop,
      'Crop': $dartnative_image_crop_1.Crop,
      'CropState': $dartnative_image_crop_1.CropState,
      'ImageCropFFIBindings': $dartnative_image_crop_3.ImageCropFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'ImageOptions':
          'package:dartnative_image_crop/src/dartnative_image_crop.dart',
      'DartNativeImageCrop':
          'package:dartnative_image_crop/src/dartnative_image_crop.dart',
      'Crop': 'package:dartnative_image_crop/src/crop.dart',
      'CropState': 'package:dartnative_image_crop/src/crop.dart',
      'ImageCropFFIBindings':
          'package:dartnative_image_crop/src/image_crop_ffi_bindings.dart',
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
      'Crop': ['StatefulWidget', 'Widget'],
      'CropState': ['State'],
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
    return [
      'VoidCallback',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {};
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
        source: 'package:dartnative_image_crop/dartnative_image_crop.dart',
        target: 'package:dartnative_image_crop/src/dartnative_image_crop.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_image_crop/dartnative_image_crop.dart',
        target: 'package:dartnative_image_crop/src/crop.dart',
        show: {'Crop', 'CropState'},
        hide: null,
      ),
      (
        source: 'package:dartnative_image_crop/dartnative_image_crop.dart',
        target:
            'package:dartnative_image_crop/src/image_crop_ffi_bindings.dart',
        show: {'ImageCropFFIBindings'},
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

    // Register function typedefs for type resolution
    final typedefs = functionTypedefs();
    for (final name in typedefs) {
      interpreter.registerFunctionTypedef(name, importPath);
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
      'package:dartnative_image_crop/src/crop.dart',
      'package:dartnative_image_crop/src/dartnative_image_crop.dart',
      'package:dartnative_image_crop/src/image_crop_ffi_bindings.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_image_crop/dartnative_image_crop.dart';";
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
}

// =============================================================================
// ImageOptions Bridge
// =============================================================================

BridgedClass _createImageOptionsBridge() {
  return BridgedClass(
    nativeType: $dartnative_image_crop_2.ImageOptions,
    name: 'ImageOptions',
    isAssignable: (v) => v is $dartnative_image_crop_2.ImageOptions,
    constructors: {
      '': (visitor, positional, named) {
        final width = D4.getRequiredNamedArg<int>(
          named,
          'width',
          'ImageOptions',
        );
        final height = D4.getRequiredNamedArg<int>(
          named,
          'height',
          'ImageOptions',
        );
        return $dartnative_image_crop_2.ImageOptions(
          width: width,
          height: height,
        );
      },
    },
    getters: {
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_2.ImageOptions>(
            target,
            'ImageOptions',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_2.ImageOptions>(
            target,
            'ImageOptions',
          )
          .height,
      'hashCode': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_2.ImageOptions>(
            target,
            'ImageOptions',
          )
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_image_crop_2.ImageOptions>(
          target,
          'ImageOptions',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_image_crop_2.ImageOptions>(
          target,
          'ImageOptions',
        );
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(
          positional,
          0,
          'other',
          'operator==',
        );
        return t == other;
      },
    },
    constructorSignatures: {
      '': 'const ImageOptions({required int width, required int height})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'width': 'int get width',
      'height': 'int get height',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// DartNativeImageCrop Bridge
// =============================================================================

BridgedClass _createDartNativeImageCropBridge() {
  return BridgedClass(
    nativeType: $dartnative_image_crop_2.DartNativeImageCrop,
    name: 'DartNativeImageCrop',
    isAssignable: (v) => v is $dartnative_image_crop_2.DartNativeImageCrop,
    constructors: {},
    staticMethods: {
      'setup': (visitor, positional, named, typeArgs) {
        return $dartnative_image_crop_2.DartNativeImageCrop.setup();
      },
      'getImageOptions': (visitor, positional, named, typeArgs) {
        final file = D4.getRequiredNamedArg<File>(
          named,
          'file',
          'getImageOptions',
        );
        return $dartnative_image_crop_2.DartNativeImageCrop.getImageOptions(
          file: file,
        );
      },
      'cropImage': (visitor, positional, named, typeArgs) {
        final file = D4.getRequiredNamedArg<File>(named, 'file', 'cropImage');
        final area = D4.getRequiredNamedArg<$dartnative_2.Rect>(
          named,
          'area',
          'cropImage',
        );
        final scale = D4.getNamedArgWithDefault<double>(named, 'scale', 1.0);
        return $dartnative_image_crop_2.DartNativeImageCrop.cropImage(
          file: file,
          area: area,
          scale: scale,
        );
      },
      'sampleImage': (visitor, positional, named, typeArgs) {
        final file = D4.getRequiredNamedArg<File>(named, 'file', 'sampleImage');
        final preferredSize = D4.getOptionalNamedArg<int?>(
          named,
          'preferredSize',
        );
        final preferredWidth = D4.getOptionalNamedArg<int?>(
          named,
          'preferredWidth',
        );
        final preferredHeight = D4.getOptionalNamedArg<int?>(
          named,
          'preferredHeight',
        );
        return $dartnative_image_crop_2.DartNativeImageCrop.sampleImage(
          file: file,
          preferredSize: preferredSize,
          preferredWidth: preferredWidth,
          preferredHeight: preferredHeight,
        );
      },
    },
    staticMethodSignatures: {
      'setup': 'void setup()',
      'getImageOptions':
          'Future<ImageOptions> getImageOptions({required File file})',
      'cropImage':
          'Future<File> cropImage({required File file, required Rect area, double scale = 1.0})',
      'sampleImage':
          'Future<File> sampleImage({required File file, int? preferredSize, int? preferredWidth, int? preferredHeight})',
    },
  );
}

// =============================================================================
// Crop Bridge
// =============================================================================

BridgedClass _createCropBridge() {
  return BridgedClass(
    nativeType: $dartnative_image_crop_1.Crop,
    name: 'Crop',
    isAssignable: (v) => v is $dartnative_image_crop_1.Crop,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final file = D4.getRequiredNamedArg<File>(named, 'file', 'Crop');
        final aspectRatio = D4.getOptionalNamedArg<double?>(
          named,
          'aspectRatio',
        );
        final alwaysShowGrid = D4.getNamedArgWithDefault<bool>(
          named,
          'alwaysShowGrid',
          false,
        );
        if (!named.containsKey('maximumScale')) {
          return $dartnative_image_crop_1.Crop(
            key: key,
            file: file,
            aspectRatio: aspectRatio,
            alwaysShowGrid: alwaysShowGrid,
          );
        }
        if (named.containsKey('maximumScale')) {
          final maximumScale = D4.getRequiredNamedArg<double>(
            named,
            'maximumScale',
            'Crop',
          );
          return $dartnative_image_crop_1.Crop(
            key: key,
            file: file,
            aspectRatio: aspectRatio,
            alwaysShowGrid: alwaysShowGrid,
            maximumScale: maximumScale,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'file': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Crop');
        final file = D4.getRequiredArg<File>(positional, 0, 'file', 'Crop');
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final aspectRatio = D4.getOptionalNamedArg<double?>(
          named,
          'aspectRatio',
        );
        final alwaysShowGrid = D4.getNamedArgWithDefault<bool>(
          named,
          'alwaysShowGrid',
          false,
        );
        if (!named.containsKey('maximumScale')) {
          return $dartnative_image_crop_1.Crop.file(
            file,
            key: key,
            aspectRatio: aspectRatio,
            alwaysShowGrid: alwaysShowGrid,
          );
        }
        if (named.containsKey('maximumScale')) {
          final maximumScale = D4.getRequiredNamedArg<double>(
            named,
            'maximumScale',
            'Crop',
          );
          return $dartnative_image_crop_1.Crop.file(
            file,
            key: key,
            aspectRatio: aspectRatio,
            alwaysShowGrid: alwaysShowGrid,
            maximumScale: maximumScale,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
    },
    getters: {
      'file': (visitor, target) =>
          D4.validateTarget<$dartnative_image_crop_1.Crop>(target, 'Crop').file,
      'aspectRatio': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_1.Crop>(target, 'Crop')
          .aspectRatio,
      'alwaysShowGrid': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_1.Crop>(target, 'Crop')
          .alwaysShowGrid,
      'maximumScale': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_1.Crop>(target, 'Crop')
          .maximumScale,
      'key': (visitor, target) =>
          D4.validateTarget<$dartnative_image_crop_1.Crop>(target, 'Crop').key,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_image_crop_1.Crop>(
          target,
          'Crop',
        );
        return t.createState();
      },
    },
    constructorSignatures: {
      '': 'const Crop({Key? key, required File file, double? aspectRatio, bool alwaysShowGrid = false, double maximumScale = _kMaxScale})',
      'file':
          'factory Crop.file(File file, {Key? key, double? aspectRatio, bool alwaysShowGrid = false, double maximumScale = _kMaxScale})',
    },
    methodSignatures: {
      'createState': 'State<Crop> createState()',
    },
    getterSignatures: {
      'file': 'File get file',
      'aspectRatio': 'double? get aspectRatio',
      'alwaysShowGrid': 'bool get alwaysShowGrid',
      'maximumScale': 'double get maximumScale',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// CropState Bridge
// =============================================================================

BridgedClass _createCropStateBridge() {
  return BridgedClass(
    nativeType: $dartnative_image_crop_1.CropState,
    name: 'CropState',
    isAssignable: (v) => v is $dartnative_image_crop_1.CropState,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_image_crop_1.CropState();
      },
    },
    getters: {
      'scale': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_1.CropState>(
            target,
            'CropState',
          )
          .scale,
      'area': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_1.CropState>(
            target,
            'CropState',
          )
          .area,
      'widget': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_1.CropState>(
            target,
            'CropState',
          )
          .widget,
      'context': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_1.CropState>(
            target,
            'CropState',
          )
          .context,
      'mounted': (visitor, target) => D4
          .validateTarget<$dartnative_image_crop_1.CropState>(
            target,
            'CropState',
          )
          .mounted,
    },
    methods: {
      'initState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_image_crop_1.CropState>(
          target,
          'CropState',
        );
        (t as dynamic).initState();
        return null;
      },
      'didUpdateWidget': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_image_crop_1.CropState>(
          target,
          'CropState',
        );
        D4.requireMinArgs(positional, 1, 'didUpdateWidget');
        final oldWidget = D4.getRequiredArg<$dartnative_image_crop_1.Crop>(
          positional,
          0,
          'oldWidget',
          'didUpdateWidget',
        );
        (t as dynamic).didUpdateWidget(oldWidget);
        return null;
      },
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_image_crop_1.CropState>(
          target,
          'CropState',
        );
        D4.requireMinArgs(positional, 1, 'build');
        final context = D4.getRequiredArg<$dartnative_1.BuildContext>(
          positional,
          0,
          'context',
          'build',
        );
        return (t as dynamic).build(context);
      },
      'didChangeDependencies': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_image_crop_1.CropState>(
          target,
          'CropState',
        );
        (t as dynamic).didChangeDependencies();
        return null;
      },
      'setState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_image_crop_1.CropState>(
          target,
          'CropState',
        );
        D4.requireMinArgs(positional, 1, 'setState');
        if (positional.isEmpty) {
          throw ArgumentError(
            'setState: Missing required argument "fn" at position 0',
          );
        }
        final fnRaw = positional[0];
        t.setState(() {
          D4.callInterpreterCallback(visitor!, fnRaw, []);
        });
        return null;
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_image_crop_1.CropState>(
          target,
          'CropState',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    constructorSignatures: {
      '': 'CropState()',
    },
    methodSignatures: {
      'initState': 'void initState()',
      'didUpdateWidget': 'void didUpdateWidget(Crop oldWidget)',
      'build': 'Widget build(BuildContext context)',
      'didChangeDependencies': 'void didChangeDependencies()',
      'setState': 'void setState(VoidCallback fn)',
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'scale': 'double get scale',
      'area': 'Rect? get area',
      'widget': 'Crop get widget',
      'context': 'BuildContext get context',
      'mounted': 'bool get mounted',
    },
  );
}

// =============================================================================
// ImageCropFFIBindings Bridge
// =============================================================================

BridgedClass _createImageCropFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_image_crop_3.ImageCropFFIBindings,
    name: 'ImageCropFFIBindings',
    isAssignable: (v) => v is $dartnative_image_crop_3.ImageCropFFIBindings,
    constructors: {},
    methods: {
      'setup': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_image_crop_3.ImageCropFFIBindings>(
              target,
              'ImageCropFFIBindings',
            );
        t.setup();
        return null;
      },
      'nativeGetImageOptions': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_image_crop_3.ImageCropFFIBindings>(
              target,
              'ImageCropFFIBindings',
            );
        D4.requireMinArgs(positional, 2, 'nativeGetImageOptions');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'nativeGetImageOptions',
        );
        final callbackPtr = D4.getRequiredArg<int>(
          positional,
          1,
          'callbackPtr',
          'nativeGetImageOptions',
        );
        t.nativeGetImageOptions(path, callbackPtr);
        return null;
      },
      'nativeCropImage': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_image_crop_3.ImageCropFFIBindings>(
              target,
              'ImageCropFFIBindings',
            );
        D4.requireMinArgs(positional, 7, 'nativeCropImage');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'nativeCropImage',
        );
        final left = D4.getRequiredArg<double>(
          positional,
          1,
          'left',
          'nativeCropImage',
        );
        final top = D4.getRequiredArg<double>(
          positional,
          2,
          'top',
          'nativeCropImage',
        );
        final right = D4.getRequiredArg<double>(
          positional,
          3,
          'right',
          'nativeCropImage',
        );
        final bottom = D4.getRequiredArg<double>(
          positional,
          4,
          'bottom',
          'nativeCropImage',
        );
        final scale = D4.getRequiredArg<double>(
          positional,
          5,
          'scale',
          'nativeCropImage',
        );
        final callbackPtr = D4.getRequiredArg<int>(
          positional,
          6,
          'callbackPtr',
          'nativeCropImage',
        );
        t.nativeCropImage(path, left, top, right, bottom, scale, callbackPtr);
        return null;
      },
      'nativeSampleImage': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_image_crop_3.ImageCropFFIBindings>(
              target,
              'ImageCropFFIBindings',
            );
        D4.requireMinArgs(positional, 4, 'nativeSampleImage');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'nativeSampleImage',
        );
        final maximumWidth = D4.getRequiredArg<int>(
          positional,
          1,
          'maximumWidth',
          'nativeSampleImage',
        );
        final maximumHeight = D4.getRequiredArg<int>(
          positional,
          2,
          'maximumHeight',
          'nativeSampleImage',
        );
        final callbackPtr = D4.getRequiredArg<int>(
          positional,
          3,
          'callbackPtr',
          'nativeSampleImage',
        );
        t.nativeSampleImage(path, maximumWidth, maximumHeight, callbackPtr);
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) =>
          $dartnative_image_crop_3.ImageCropFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_image_crop_3.ImageCropFFIBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'setup': 'void setup()',
      'nativeGetImageOptions':
          'void nativeGetImageOptions(String path, int callbackPtr)',
      'nativeCropImage':
          'void nativeCropImage(String path, double left, double top, double right, double bottom, double scale, int callbackPtr)',
      'nativeSampleImage':
          'void nativeSampleImage(String path, int maximumWidth, int maximumHeight, int callbackPtr)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'ImageCropFFIBindings get instance',
    },
  );
}

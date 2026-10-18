// D4rt Bridge - Generated file, do not edit
// Sources: 5 files
// Generated: 2026-10-17T21:08:27.355138 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';

import 'package:dartnative/src/core.dart' as $dartnative_1;
import 'package:dartnative_media_picker/src/gallery.dart' as $dartnative_media_picker_1;
import 'package:dartnative_media_picker/src/gallery_ffi_bindings.dart' as $dartnative_media_picker_2;
import 'package:dartnative_media_picker/src/gallery_thumb.dart' as $dartnative_media_picker_3;
import 'package:dartnative_media_picker/src/media_picker.dart' as $dartnative_media_picker_4;
import 'package:dartnative_media_picker/src/media_picker_ffi_bindings.dart' as $dartnative_media_picker_5;

/// Bridge class for dartnative_media_picker module.
class DartnativeMediaPickerBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createMediaFileBridge(),
      _createMediaPickerFFIBindingsBridge(),
      _createMediaGalleryExceptionBridge(),
      _createMediaAlbumBridge(),
      _createMediaAssetBridge(),
      _createGalleryFileBridge(),
      _createMediaGalleryBridge(),
      _createGalleryThumbBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'MediaFile': _createMediaFileBridge,
      'MediaPickerFFIBindings': _createMediaPickerFFIBindingsBridge,
      'MediaGalleryException': _createMediaGalleryExceptionBridge,
      'MediaAlbum': _createMediaAlbumBridge,
      'MediaAsset': _createMediaAssetBridge,
      'GalleryFile': _createGalleryFileBridge,
      'MediaGallery': _createMediaGalleryBridge,
      'GalleryThumb': _createGalleryThumbBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'MediaFile': $dartnative_media_picker_4.MediaFile,
      'MediaPickerFFIBindings': $dartnative_media_picker_5.MediaPickerFFIBindings,
      'MediaGalleryException': $dartnative_media_picker_2.MediaGalleryException,
      'MediaAlbum': $dartnative_media_picker_1.MediaAlbum,
      'MediaAsset': $dartnative_media_picker_1.MediaAsset,
      'GalleryFile': $dartnative_media_picker_1.GalleryFile,
      'MediaGallery': $dartnative_media_picker_1.MediaGallery,
      'GalleryThumb': $dartnative_media_picker_3.GalleryThumb,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'MediaFile': 'package:dartnative_media_picker/src/media_picker.dart',
      'MediaPickerFFIBindings': 'package:dartnative_media_picker/src/media_picker_ffi_bindings.dart',
      'MediaGalleryException': 'package:dartnative_media_picker/src/gallery_ffi_bindings.dart',
      'MediaAlbum': 'package:dartnative_media_picker/src/gallery.dart',
      'MediaAsset': 'package:dartnative_media_picker/src/gallery.dart',
      'GalleryFile': 'package:dartnative_media_picker/src/gallery.dart',
      'MediaGallery': 'package:dartnative_media_picker/src/gallery.dart',
      'GalleryThumb': 'package:dartnative_media_picker/src/gallery_thumb.dart',
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
      'MediaGalleryException': ['Exception'],
      'GalleryThumb': ['StatelessWidget', 'Widget'],
    };
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {
    };
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
    return [
      BridgedEnumDefinition<$dartnative_media_picker_4.MediaPickerType>(
        name: 'MediaPickerType',
        values: $dartnative_media_picker_4.MediaPickerType.values,
      ),
      BridgedEnumDefinition<$dartnative_media_picker_1.GalleryPermission>(
        name: 'GalleryPermission',
        values: $dartnative_media_picker_1.GalleryPermission.values,
      ),
      BridgedEnumDefinition<$dartnative_media_picker_1.GalleryMediaType>(
        name: 'GalleryMediaType',
        values: $dartnative_media_picker_1.GalleryMediaType.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'MediaPickerType': 'package:dartnative_media_picker/src/media_picker.dart',
      'GalleryPermission': 'package:dartnative_media_picker/src/gallery.dart',
      'GalleryMediaType': 'package:dartnative_media_picker/src/gallery.dart',
    };
  }

  /// Returns all bridged extension definitions.
  static List<BridgedExtensionDefinition> bridgedExtensions() {
    return [
    ];
  }

  /// Returns a map of extension identifiers to their canonical source URIs.
  static Map<String, String> extensionSourceUris() {
    return {
    };
  }

  /// GEN-107: Library re-exports declared by the bridged source
  /// libraries. Each tuple mirrors a Dart `export '…'` directive.
  /// Consumed by `registerBridges` via `D4rt.registerLibraryReExport`
  /// (mirrored on `D4rtRunner` in tom_d4rt_ast).
  static List<({String source, String target, Set<String>? show, Set<String>? hide})>
  bridgeReExports() {
    return [
      (source: 'package:dartnative_media_picker/dartnative_media_picker.dart', target: 'package:dartnative_media_picker/src/media_picker.dart', show: {'MediaPickerType', 'MediaFile', 'showMediaPicker'}, hide: null),
      (source: 'package:dartnative_media_picker/dartnative_media_picker.dart', target: 'package:dartnative_media_picker/src/media_picker_ffi_bindings.dart', show: {'MediaPickerFFIBindings'}, hide: null),
      (source: 'package:dartnative_media_picker/gallery.dart', target: 'package:dartnative_media_picker/src/gallery.dart', show: {'GalleryFile', 'GalleryMediaType', 'GalleryPermission', 'MediaAlbum', 'MediaAsset', 'MediaGallery', 'MediaGalleryException'}, hide: null),
      (source: 'package:dartnative_media_picker/gallery.dart', target: 'package:dartnative_media_picker/src/gallery_ffi_bindings.dart', show: {'MediaGalleryFFIBindings'}, hide: null),
      (source: 'package:dartnative_media_picker/gallery.dart', target: 'package:dartnative_media_picker/src/gallery_thumb.dart', show: {'GalleryThumb'}, hide: null),
      (source: 'package:dartnative_media_picker/src/gallery.dart', target: 'package:dartnative_media_picker/src/gallery_ffi_bindings.dart', show: {'MediaGalleryException'}, hide: null),
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
      interpreter.registerBridgedEnum(enumDef, importPath, sourceUri: enumSources[enumDef.name]);
    }

    // Register global functions with source URIs for deduplication
    final funcs = globalFunctions();
    final funcSources = globalFunctionSourceUris();
    final funcSigs = globalFunctionSignatures();
    for (final entry in funcs.entries) {
      interpreter.registertopLevelFunction(entry.key, entry.value, importPath, sourceUri: funcSources[entry.key], signature: funcSigs[entry.key]);
    }

    // Register function typedefs for type resolution
    final typedefs = functionTypedefs();
    for (final name in typedefs) {
      interpreter.registerFunctionTypedef(name, importPath);
    }

    // GEN-107: Register library re-exports
    for (final r in bridgeReExports()) {
      interpreter.registerLibraryReExport(r.source, r.target, show: r.show, hide: r.hide);
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {
      'showMediaPicker': (visitor, positional, named, typeArgs) {
        final type = D4.getNamedArgWithDefault<$dartnative_media_picker_4.MediaPickerType>(named, 'type', $dartnative_media_picker_4.MediaPickerType.images);
        final maxSelection = D4.getNamedArgWithDefault<int>(named, 'maxSelection', 1);
        return $dartnative_media_picker_4.showMediaPicker(type: type, maxSelection: maxSelection);
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'showMediaPicker': 'package:dartnative_media_picker/src/media_picker.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'showMediaPicker': 'Future<List<MediaFile>> showMediaPicker({MediaPickerType type = MediaPickerType.images, int maxSelection = 1})',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative_media_picker/src/gallery.dart',
      'package:dartnative_media_picker/src/gallery_ffi_bindings.dart',
      'package:dartnative_media_picker/src/gallery_thumb.dart',
      'package:dartnative_media_picker/src/media_picker.dart',
      'package:dartnative_media_picker/src/media_picker_ffi_bindings.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    final imports = StringBuffer();
    imports.writeln("import 'package:dartnative_media_picker/dartnative_media_picker.dart';");
    imports.writeln("import 'package:dartnative_media_picker/gallery.dart';");
    return imports.toString();
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
    'MediaPickerType',
    'GalleryPermission',
    'GalleryMediaType',
  ];

}

// =============================================================================
// MediaFile Bridge
// =============================================================================

BridgedClass _createMediaFileBridge() {
  return BridgedClass(
    nativeType: $dartnative_media_picker_4.MediaFile,
    name: 'MediaFile',
    isAssignable: (v) => v is $dartnative_media_picker_4.MediaFile,
    constructors: {
      '': (visitor, positional, named) {
        final path = D4.getRequiredNamedArg<String>(named, 'path', 'MediaFile');
        final name = D4.getRequiredNamedArg<String>(named, 'name', 'MediaFile');
        final type = D4.getRequiredNamedArg<String>(named, 'type', 'MediaFile');
        return $dartnative_media_picker_4.MediaFile(path: path, name: name, type: type);
      },
    },
    getters: {
      'path': (visitor, target) => D4.validateTarget<$dartnative_media_picker_4.MediaFile>(target, 'MediaFile').path,
      'name': (visitor, target) => D4.validateTarget<$dartnative_media_picker_4.MediaFile>(target, 'MediaFile').name,
      'type': (visitor, target) => D4.validateTarget<$dartnative_media_picker_4.MediaFile>(target, 'MediaFile').type,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_media_picker_4.MediaFile>(target, 'MediaFile');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const MediaFile({required String path, required String name, required String type})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'path': 'String get path',
      'name': 'String get name',
      'type': 'String get type',
    },
  );
}

// =============================================================================
// MediaPickerFFIBindings Bridge
// =============================================================================

BridgedClass _createMediaPickerFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_media_picker_5.MediaPickerFFIBindings,
    name: 'MediaPickerFFIBindings',
    isAssignable: (v) => v is $dartnative_media_picker_5.MediaPickerFFIBindings,
    constructors: {
    },
    methods: {
      'show': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_media_picker_5.MediaPickerFFIBindings>(target, 'MediaPickerFFIBindings');
        D4.requireMinArgs(positional, 2, 'show');
        final type = D4.getRequiredArg<int>(positional, 0, 'type', 'show');
        final maxSelection = D4.getRequiredArg<int>(positional, 1, 'maxSelection', 'show');
        return t.show(type, maxSelection);
      },
    },
    staticGetters: {
      'instance': (visitor) => $dartnative_media_picker_5.MediaPickerFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_media_picker_5.MediaPickerFFIBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'show': 'Future<String> show(int type, int maxSelection)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'MediaPickerFFIBindings get instance',
    },
  );
}

// =============================================================================
// MediaGalleryException Bridge
// =============================================================================

BridgedClass _createMediaGalleryExceptionBridge() {
  return BridgedClass(
    nativeType: $dartnative_media_picker_2.MediaGalleryException,
    name: 'MediaGalleryException',
    isAssignable: (v) => v is $dartnative_media_picker_2.MediaGalleryException,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'MediaGalleryException');
        final message = D4.getRequiredArg<String>(positional, 0, 'message', 'MediaGalleryException');
        return $dartnative_media_picker_2.MediaGalleryException(message);
      },
    },
    getters: {
      'message': (visitor, target) => D4.validateTarget<$dartnative_media_picker_2.MediaGalleryException>(target, 'MediaGalleryException').message,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_media_picker_2.MediaGalleryException>(target, 'MediaGalleryException');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const MediaGalleryException(String message)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'message': 'String get message',
    },
  );
}

// =============================================================================
// MediaAlbum Bridge
// =============================================================================

BridgedClass _createMediaAlbumBridge() {
  return BridgedClass(
    nativeType: $dartnative_media_picker_1.MediaAlbum,
    name: 'MediaAlbum',
    isAssignable: (v) => v is $dartnative_media_picker_1.MediaAlbum,
    constructors: {
      '': (visitor, positional, named) {
        final id = D4.getRequiredNamedArg<String>(named, 'id', 'MediaAlbum');
        final name = D4.getRequiredNamedArg<String>(named, 'name', 'MediaAlbum');
        final count = D4.getRequiredNamedArg<int>(named, 'count', 'MediaAlbum');
        final isAll = D4.getRequiredNamedArg<bool>(named, 'isAll', 'MediaAlbum');
        return $dartnative_media_picker_1.MediaAlbum(id: id, name: name, count: count, isAll: isAll);
      },
    },
    getters: {
      'id': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAlbum>(target, 'MediaAlbum').id,
      'name': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAlbum>(target, 'MediaAlbum').name,
      'count': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAlbum>(target, 'MediaAlbum').count,
      'isAll': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAlbum>(target, 'MediaAlbum').isAll,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_media_picker_1.MediaAlbum>(target, 'MediaAlbum');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const MediaAlbum({required String id, required String name, required int count, required bool isAll})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'id': 'String get id',
      'name': 'String get name',
      'count': 'int get count',
      'isAll': 'bool get isAll',
    },
  );
}

// =============================================================================
// MediaAsset Bridge
// =============================================================================

BridgedClass _createMediaAssetBridge() {
  return BridgedClass(
    nativeType: $dartnative_media_picker_1.MediaAsset,
    name: 'MediaAsset',
    isAssignable: (v) => v is $dartnative_media_picker_1.MediaAsset,
    constructors: {
      '': (visitor, positional, named) {
        final id = D4.getRequiredNamedArg<String>(named, 'id', 'MediaAsset');
        final uri = D4.getRequiredNamedArg<String>(named, 'uri', 'MediaAsset');
        final isVideo = D4.getRequiredNamedArg<bool>(named, 'isVideo', 'MediaAsset');
        final width = D4.getRequiredNamedArg<int>(named, 'width', 'MediaAsset');
        final height = D4.getRequiredNamedArg<int>(named, 'height', 'MediaAsset');
        final duration = D4.getRequiredNamedArg<Duration>(named, 'duration', 'MediaAsset');
        final createdAt = D4.getRequiredNamedArg<DateTime>(named, 'createdAt', 'MediaAsset');
        return $dartnative_media_picker_1.MediaAsset(id: id, uri: uri, isVideo: isVideo, width: width, height: height, duration: duration, createdAt: createdAt);
      },
    },
    getters: {
      'id': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAsset>(target, 'MediaAsset').id,
      'uri': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAsset>(target, 'MediaAsset').uri,
      'isVideo': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAsset>(target, 'MediaAsset').isVideo,
      'width': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAsset>(target, 'MediaAsset').width,
      'height': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAsset>(target, 'MediaAsset').height,
      'duration': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAsset>(target, 'MediaAsset').duration,
      'createdAt': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.MediaAsset>(target, 'MediaAsset').createdAt,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_media_picker_1.MediaAsset>(target, 'MediaAsset');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const MediaAsset({required String id, required String uri, required bool isVideo, required int width, required int height, required Duration duration, required DateTime createdAt})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'id': 'String get id',
      'uri': 'String get uri',
      'isVideo': 'bool get isVideo',
      'width': 'int get width',
      'height': 'int get height',
      'duration': 'Duration get duration',
      'createdAt': 'DateTime get createdAt',
    },
  );
}

// =============================================================================
// GalleryFile Bridge
// =============================================================================

BridgedClass _createGalleryFileBridge() {
  return BridgedClass(
    nativeType: $dartnative_media_picker_1.GalleryFile,
    name: 'GalleryFile',
    isAssignable: (v) => v is $dartnative_media_picker_1.GalleryFile,
    constructors: {
      '': (visitor, positional, named) {
        final path = D4.getRequiredNamedArg<String>(named, 'path', 'GalleryFile');
        final name = D4.getRequiredNamedArg<String>(named, 'name', 'GalleryFile');
        final isVideo = D4.getRequiredNamedArg<bool>(named, 'isVideo', 'GalleryFile');
        return $dartnative_media_picker_1.GalleryFile(path: path, name: name, isVideo: isVideo);
      },
    },
    getters: {
      'path': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.GalleryFile>(target, 'GalleryFile').path,
      'name': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.GalleryFile>(target, 'GalleryFile').name,
      'isVideo': (visitor, target) => D4.validateTarget<$dartnative_media_picker_1.GalleryFile>(target, 'GalleryFile').isVideo,
    },
    constructorSignatures: {
      '': 'const GalleryFile({required String path, required String name, required bool isVideo})',
    },
    getterSignatures: {
      'path': 'String get path',
      'name': 'String get name',
      'isVideo': 'bool get isVideo',
    },
  );
}

// =============================================================================
// MediaGallery Bridge
// =============================================================================

BridgedClass _createMediaGalleryBridge() {
  return BridgedClass(
    nativeType: $dartnative_media_picker_1.MediaGallery,
    name: 'MediaGallery',
    isAssignable: (v) => v is $dartnative_media_picker_1.MediaGallery,
    isAbstract: true,
    constructors: {
    },
    staticGetters: {
      'allAlbumId': (visitor) => $dartnative_media_picker_1.MediaGallery.allAlbumId,
      'changes': (visitor) => $dartnative_media_picker_1.MediaGallery.changes,
    },
    staticMethods: {
      'permission': (visitor, positional, named, typeArgs) {
        final request = D4.getNamedArgWithDefault<bool>(named, 'request', false);
        return $dartnative_media_picker_1.MediaGallery.permission(request: request);
      },
      'albums': (visitor, positional, named, typeArgs) {
        final type = D4.getNamedArgWithDefault<$dartnative_media_picker_1.GalleryMediaType>(named, 'type', $dartnative_media_picker_1.GalleryMediaType.images);
        return $dartnative_media_picker_1.MediaGallery.albums(type: type);
      },
      'assets': (visitor, positional, named, typeArgs) {
        final type = D4.getNamedArgWithDefault<$dartnative_media_picker_1.GalleryMediaType>(named, 'type', $dartnative_media_picker_1.GalleryMediaType.images);
        final offset = D4.getNamedArgWithDefault<int>(named, 'offset', 0);
        final limit = D4.getNamedArgWithDefault<int>(named, 'limit', 80);
        final order = named.containsKey('order') && named['order'] != null
            ? D4.coerceList<$dartnative_media_picker_1.GalleryOrder>(named['order'], 'order')
            : const <$dartnative_media_picker_1.GalleryOrder>[];
        if (!named.containsKey('albumId')) {
          return $dartnative_media_picker_1.MediaGallery.assets(type: type, offset: offset, limit: limit, order: order);
        }
        if (named.containsKey('albumId')) {
          final albumId = D4.getRequiredNamedArg<String>(named, 'albumId', 'assets');
          return $dartnative_media_picker_1.MediaGallery.assets(type: type, offset: offset, limit: limit, order: order, albumId: albumId);
        }
        throw StateError('Unreachable: all named parameter combinations should be covered');
      },
      'preheat': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'preheat');
        if (positional.isEmpty) {
          throw ArgumentError('preheat: Missing required argument "assetIds" at position 0');
        }
        final assetIds = D4.coerceList<String>(positional[0], 'assetIds');
        final size = D4.getNamedArgWithDefault<int>(named, 'size', 200);
        return $dartnative_media_picker_1.MediaGallery.preheat(assetIds, size: size);
      },
      'cancelPreheat': (visitor, positional, named, typeArgs) {
        return $dartnative_media_picker_1.MediaGallery.cancelPreheat();
      },
      'thumbnail': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'thumbnail');
        final assetId = D4.getRequiredArg<String>(positional, 0, 'assetId', 'thumbnail');
        final width = D4.getNamedArgWithDefault<int>(named, 'width', 256);
        final height = D4.getNamedArgWithDefault<int>(named, 'height', 256);
        return $dartnative_media_picker_1.MediaGallery.thumbnail(assetId, width: width, height: height);
      },
      'save': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'save');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'save');
        final isVideo = D4.getNamedArgWithDefault<bool>(named, 'isVideo', false);
        final albumName = D4.getNamedArgWithDefault<String>(named, 'albumName', '');
        return $dartnative_media_picker_1.MediaGallery.save(path, isVideo: isVideo, albumName: albumName);
      },
      'delete': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'delete');
        if (positional.isEmpty) {
          throw ArgumentError('delete: Missing required argument "assetIds" at position 0');
        }
        final assetIds = D4.coerceList<String>(positional[0], 'assetIds');
        return $dartnative_media_picker_1.MediaGallery.delete(assetIds);
      },
      'file': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'file');
        final assetId = D4.getRequiredArg<String>(positional, 0, 'assetId', 'file');
        return $dartnative_media_picker_1.MediaGallery.file(assetId);
      },
    },
    staticMethodSignatures: {
      'permission': 'Future<GalleryPermission> permission({bool request = false})',
      'albums': 'Future<List<MediaAlbum>> albums({GalleryMediaType type = GalleryMediaType.images})',
      'assets': 'Future<List<MediaAsset>> assets({String albumId = allAlbumId, GalleryMediaType type = GalleryMediaType.images, int offset = 0, int limit = 80, List<GalleryOrder> order = const []})',
      'preheat': 'Future<void> preheat(List<String> assetIds, {int size = 200})',
      'cancelPreheat': 'Future<void> cancelPreheat()',
      'thumbnail': 'Future<String> thumbnail(String assetId, {int width = 256, int height = 256})',
      'save': 'Future<String> save(String path, {bool isVideo = false, String albumName = \'\'})',
      'delete': 'Future<List<String>> delete(List<String> assetIds)',
      'file': 'Future<GalleryFile> file(String assetId)',
    },
    staticGetterSignatures: {
      'allAlbumId': 'String get allAlbumId',
      'changes': 'Stream<void> get changes',
    },
  );
}

// =============================================================================
// GalleryThumb Bridge
// =============================================================================

BridgedClass _createGalleryThumbBridge() {
  return BridgedClass(
    nativeType: $dartnative_media_picker_3.GalleryThumb,
    name: 'GalleryThumb',
    isAssignable: (v) => v is $dartnative_media_picker_3.GalleryThumb,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final assetId = D4.getRequiredNamedArg<String>(named, 'assetId', 'GalleryThumb');
        final size = D4.getNamedArgWithDefault<int>(named, 'size', 240);
        return $dartnative_media_picker_3.GalleryThumb(key: key, assetId: assetId, size: size);
      },
    },
    getters: {
      'assetId': (visitor, target) => D4.validateTarget<$dartnative_media_picker_3.GalleryThumb>(target, 'GalleryThumb').assetId,
      'size': (visitor, target) => D4.validateTarget<$dartnative_media_picker_3.GalleryThumb>(target, 'GalleryThumb').size,
      'key': (visitor, target) => D4.validateTarget<$dartnative_media_picker_3.GalleryThumb>(target, 'GalleryThumb').key,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_media_picker_3.GalleryThumb>(target, 'GalleryThumb');
        D4.requireMinArgs(positional, 1, 'build');
        final context = D4.getRequiredArg<$dartnative_1.BuildContext>(positional, 0, 'context', 'build');
        return (t as dynamic).build(context);
      },
    },
    constructorSignatures: {
      '': 'const GalleryThumb({Key? key, required String assetId, int size = 240})',
    },
    methodSignatures: {
      'build': 'Widget build(BuildContext context)',
    },
    getterSignatures: {
      'assetId': 'String get assetId',
      'size': 'int get size',
      'key': 'Key? get key',
    },
  );
}


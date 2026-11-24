// D4rt Bridge - Generated file, do not edit
// Sources: 5 files
// Generated: 2026-11-24T16:25:42.146554 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:dartnative/src/core.dart' as $dartnative_1;
import 'package:dartnative/src/painting.dart' as $dartnative_2;
import 'package:dartnative_camera/src/camera_controller.dart'
    as $dartnative_camera_1;
import 'package:dartnative_camera/src/camera_ffi_bindings.dart'
    as $dartnative_camera_2;
import 'package:dartnative_camera/src/camera_preview.dart'
    as $dartnative_camera_3;
import 'package:dartnative_camera/src/camera_types.dart'
    as $dartnative_camera_4;
import 'package:dartnative_camera/src/dartnative_camera.dart'
    as $dartnative_camera_5;

/// Bridge class for dartnative_camera module.
class DartnativeCameraBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createCameraDescriptionBridge(),
      _createRecordingEventBridge(),
      _createCameraImageBridge(),
      _createScannedCodeBridge(),
      _createCameraExceptionBridge(),
      _createCameraControllerBridge(),
      _createDartNativeCameraBridge(),
      _createCameraPreviewBridge(),
      _createCameraFfiBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'CameraDescription': _createCameraDescriptionBridge,
      'RecordingEvent': _createRecordingEventBridge,
      'CameraImage': _createCameraImageBridge,
      'ScannedCode': _createScannedCodeBridge,
      'CameraException': _createCameraExceptionBridge,
      'CameraController': _createCameraControllerBridge,
      'DartNativeCamera': _createDartNativeCameraBridge,
      'CameraPreview': _createCameraPreviewBridge,
      'CameraFfiBindings': _createCameraFfiBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'CameraDescription': $dartnative_camera_4.CameraDescription,
      'RecordingEvent': $dartnative_camera_4.RecordingEvent,
      'CameraImage': $dartnative_camera_4.CameraImage,
      'ScannedCode': $dartnative_camera_4.ScannedCode,
      'CameraException': $dartnative_camera_4.CameraException,
      'CameraController': $dartnative_camera_1.CameraController,
      'DartNativeCamera': $dartnative_camera_5.DartNativeCamera,
      'CameraPreview': $dartnative_camera_3.CameraPreview,
      'CameraFfiBindings': $dartnative_camera_2.CameraFfiBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'CameraDescription': 'package:dartnative_camera/src/camera_types.dart',
      'RecordingEvent': 'package:dartnative_camera/src/camera_types.dart',
      'CameraImage': 'package:dartnative_camera/src/camera_types.dart',
      'ScannedCode': 'package:dartnative_camera/src/camera_types.dart',
      'CameraException': 'package:dartnative_camera/src/camera_types.dart',
      'CameraController':
          'package:dartnative_camera/src/camera_controller.dart',
      'DartNativeCamera':
          'package:dartnative_camera/src/dartnative_camera.dart',
      'CameraPreview': 'package:dartnative_camera/src/camera_preview.dart',
      'CameraFfiBindings':
          'package:dartnative_camera/src/camera_ffi_bindings.dart',
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
      'CameraException': ['Exception'],
      'CameraController': ['ChangeNotifier'],
      'CameraPreview': ['StatefulWidget', 'Widget'],
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
      'RecordingEventListener',
      'ImageFrameListener',
      'CodeScanListener',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dartnative_camera_4.CameraLensDirection>(
        name: 'CameraLensDirection',
        values: $dartnative_camera_4.CameraLensDirection.values,
        getters: {
          'value': (visitor, target) =>
              (target as $dartnative_camera_4.CameraLensDirection).value,
        },
        staticMethods: {
          'fromInt': (visitor, positional, named, typeArgs) {
            return Function.apply(
              $dartnative_camera_4.CameraLensDirection.fromInt,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedEnumDefinition<$dartnative_camera_4.ResolutionPreset>(
        name: 'ResolutionPreset',
        values: $dartnative_camera_4.ResolutionPreset.values,
      ),
      BridgedEnumDefinition<$dartnative_camera_4.VideoQuality>(
        name: 'VideoQuality',
        values: $dartnative_camera_4.VideoQuality.values,
        getters: {
          'value': (visitor, target) =>
              (target as $dartnative_camera_4.VideoQuality).value,
        },
      ),
      BridgedEnumDefinition<$dartnative_camera_4.VideoAspectRatio>(
        name: 'VideoAspectRatio',
        values: $dartnative_camera_4.VideoAspectRatio.values,
        getters: {
          'value': (visitor, target) =>
              (target as $dartnative_camera_4.VideoAspectRatio).value,
        },
      ),
      BridgedEnumDefinition<$dartnative_camera_4.FlashMode>(
        name: 'FlashMode',
        values: $dartnative_camera_4.FlashMode.values,
        getters: {
          'value': (visitor, target) =>
              (target as $dartnative_camera_4.FlashMode).value,
        },
      ),
      BridgedEnumDefinition<$dartnative_camera_4.RecordingEventKind>(
        name: 'RecordingEventKind',
        values: $dartnative_camera_4.RecordingEventKind.values,
        getters: {
          'value': (visitor, target) =>
              (target as $dartnative_camera_4.RecordingEventKind).value,
        },
        staticMethods: {
          'fromInt': (visitor, positional, named, typeArgs) {
            return Function.apply(
              $dartnative_camera_4.RecordingEventKind.fromInt,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedEnumDefinition<$dartnative_camera_4.CodeFormat>(
        name: 'CodeFormat',
        values: $dartnative_camera_4.CodeFormat.values,
        staticGetters: {
          'all': () => $dartnative_camera_4.CodeFormat.all,
        },
      ),
      BridgedEnumDefinition<$dartnative_camera_4.CaptureOrientation>(
        name: 'CaptureOrientation',
        values: $dartnative_camera_4.CaptureOrientation.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'CameraLensDirection': 'package:dartnative_camera/src/camera_types.dart',
      'ResolutionPreset': 'package:dartnative_camera/src/camera_types.dart',
      'VideoQuality': 'package:dartnative_camera/src/camera_types.dart',
      'VideoAspectRatio': 'package:dartnative_camera/src/camera_types.dart',
      'FlashMode': 'package:dartnative_camera/src/camera_types.dart',
      'RecordingEventKind': 'package:dartnative_camera/src/camera_types.dart',
      'CodeFormat': 'package:dartnative_camera/src/camera_types.dart',
      'CaptureOrientation': 'package:dartnative_camera/src/camera_types.dart',
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
        source: 'package:dartnative_camera/dartnative_camera.dart',
        target: 'package:dartnative_camera/src/camera_types.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_camera/dartnative_camera.dart',
        target: 'package:dartnative_camera/src/camera_controller.dart',
        show: null,
        hide: {'ChangeNotifier'},
      ),
      (
        source: 'package:dartnative_camera/dartnative_camera.dart',
        target: 'package:dartnative_camera/src/dartnative_camera.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_camera/dartnative_camera.dart',
        target: 'package:dartnative_camera/src/camera_preview.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_camera/dartnative_camera.dart',
        target: 'package:dartnative_camera/src/camera_ffi_bindings.dart',
        show: {'CameraFfiBindings'},
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

    // Register global functions with source URIs for deduplication
    final funcs = globalFunctions();
    final funcSources = globalFunctionSourceUris();
    final funcSigs = globalFunctionSignatures();
    for (final entry in funcs.entries) {
      interpreter.registertopLevelFunction(
        entry.key,
        entry.value,
        importPath,
        sourceUri: funcSources[entry.key],
        signature: funcSigs[entry.key],
      );
    }

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
    return {
      'registerCameraElementFactory': (visitor, positional, named, typeArgs) {
        return $dartnative_camera_3.registerCameraElementFactory();
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'registerCameraElementFactory':
          'package:dartnative_camera/src/camera_preview.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'registerCameraElementFactory': 'void registerCameraElementFactory()',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative_camera/src/camera_controller.dart',
      'package:dartnative_camera/src/camera_ffi_bindings.dart',
      'package:dartnative_camera/src/camera_preview.dart',
      'package:dartnative_camera/src/camera_types.dart',
      'package:dartnative_camera/src/dartnative_camera.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_camera/dartnative_camera.dart';";
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
    'CameraLensDirection',
    'ResolutionPreset',
    'VideoQuality',
    'VideoAspectRatio',
    'FlashMode',
    'RecordingEventKind',
    'CodeFormat',
    'CaptureOrientation',
  ];
}

// =============================================================================
// CameraDescription Bridge
// =============================================================================

BridgedClass _createCameraDescriptionBridge() {
  return BridgedClass(
    nativeType: $dartnative_camera_4.CameraDescription,
    name: 'CameraDescription',
    isAssignable: (v) => v is $dartnative_camera_4.CameraDescription,
    constructors: {
      '': (visitor, positional, named) {
        final name = D4.getRequiredNamedArg<String>(
          named,
          'name',
          'CameraDescription',
        );
        final lensDirection = D4
            .getRequiredNamedArg<$dartnative_camera_4.CameraLensDirection>(
              named,
              'lensDirection',
              'CameraDescription',
            );
        final sensorOrientation = D4.getRequiredNamedArg<int>(
          named,
          'sensorOrientation',
          'CameraDescription',
        );
        return $dartnative_camera_4.CameraDescription(
          name: name,
          lensDirection: lensDirection,
          sensorOrientation: sensorOrientation,
        );
      },
    },
    getters: {
      'name': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraDescription>(
            target,
            'CameraDescription',
          )
          .name,
      'lensDirection': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraDescription>(
            target,
            'CameraDescription',
          )
          .lensDirection,
      'sensorOrientation': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraDescription>(
            target,
            'CameraDescription',
          )
          .sensorOrientation,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_4.CameraDescription>(
          target,
          'CameraDescription',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const CameraDescription({required String name, required CameraLensDirection lensDirection, required int sensorOrientation})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'name': 'String get name',
      'lensDirection': 'CameraLensDirection get lensDirection',
      'sensorOrientation': 'int get sensorOrientation',
    },
  );
}

// =============================================================================
// RecordingEvent Bridge
// =============================================================================

BridgedClass _createRecordingEventBridge() {
  return BridgedClass(
    nativeType: $dartnative_camera_4.RecordingEvent,
    name: 'RecordingEvent',
    isAssignable: (v) => v is $dartnative_camera_4.RecordingEvent,
    constructors: {
      '': (visitor, positional, named) {
        final kind = D4
            .getRequiredNamedArg<$dartnative_camera_4.RecordingEventKind>(
              named,
              'kind',
              'RecordingEvent',
            );
        final durationUs = D4.getRequiredNamedArg<int>(
          named,
          'durationUs',
          'RecordingEvent',
        );
        final sizeBytes = D4.getRequiredNamedArg<int>(
          named,
          'sizeBytes',
          'RecordingEvent',
        );
        return $dartnative_camera_4.RecordingEvent(
          kind: kind,
          durationUs: durationUs,
          sizeBytes: sizeBytes,
        );
      },
    },
    getters: {
      'kind': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.RecordingEvent>(
            target,
            'RecordingEvent',
          )
          .kind,
      'durationUs': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.RecordingEvent>(
            target,
            'RecordingEvent',
          )
          .durationUs,
      'sizeBytes': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.RecordingEvent>(
            target,
            'RecordingEvent',
          )
          .sizeBytes,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_4.RecordingEvent>(
          target,
          'RecordingEvent',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const RecordingEvent({required RecordingEventKind kind, required int durationUs, required int sizeBytes})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'kind': 'RecordingEventKind get kind',
      'durationUs': 'int get durationUs',
      'sizeBytes': 'int get sizeBytes',
    },
  );
}

// =============================================================================
// CameraImage Bridge
// =============================================================================

BridgedClass _createCameraImageBridge() {
  return BridgedClass(
    nativeType: $dartnative_camera_4.CameraImage,
    name: 'CameraImage',
    isAssignable: (v) => v is $dartnative_camera_4.CameraImage,
    constructors: {
      '': (visitor, positional, named) {
        final format = D4.getRequiredNamedArg<int>(
          named,
          'format',
          'CameraImage',
        );
        final width = D4.getRequiredNamedArg<int>(
          named,
          'width',
          'CameraImage',
        );
        final height = D4.getRequiredNamedArg<int>(
          named,
          'height',
          'CameraImage',
        );
        final bytes = D4.getRequiredNamedArg<Uint8List>(
          named,
          'bytes',
          'CameraImage',
        );
        final timestampNs = D4.getRequiredNamedArg<int>(
          named,
          'timestampNs',
          'CameraImage',
        );
        return $dartnative_camera_4.CameraImage(
          format: format,
          width: width,
          height: height,
          bytes: bytes,
          timestampNs: timestampNs,
        );
      },
    },
    getters: {
      'format': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraImage>(
            target,
            'CameraImage',
          )
          .format,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraImage>(
            target,
            'CameraImage',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraImage>(
            target,
            'CameraImage',
          )
          .height,
      'bytes': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraImage>(
            target,
            'CameraImage',
          )
          .bytes,
      'timestampNs': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraImage>(
            target,
            'CameraImage',
          )
          .timestampNs,
    },
    constructorSignatures: {
      '': 'const CameraImage({required int format, required int width, required int height, required Uint8List bytes, required int timestampNs})',
    },
    getterSignatures: {
      'format': 'int get format',
      'width': 'int get width',
      'height': 'int get height',
      'bytes': 'Uint8List get bytes',
      'timestampNs': 'int get timestampNs',
    },
  );
}

// =============================================================================
// ScannedCode Bridge
// =============================================================================

BridgedClass _createScannedCodeBridge() {
  return BridgedClass(
    nativeType: $dartnative_camera_4.ScannedCode,
    name: 'ScannedCode',
    isAssignable: (v) => v is $dartnative_camera_4.ScannedCode,
    constructors: {
      '': (visitor, positional, named) {
        final format = D4.getRequiredNamedArg<$dartnative_camera_4.CodeFormat>(
          named,
          'format',
          'ScannedCode',
        );
        final value = D4.getRequiredNamedArg<String>(
          named,
          'value',
          'ScannedCode',
        );
        if (!named.containsKey('corners') || named['corners'] == null) {
          throw ArgumentError(
            'ScannedCode: Missing required named argument "corners"',
          );
        }
        final corners = D4.coerceList<$dartnative_2.Offset>(
          named['corners'],
          'corners',
        );
        return $dartnative_camera_4.ScannedCode(
          format: format,
          value: value,
          corners: corners,
        );
      },
    },
    getters: {
      'format': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.ScannedCode>(
            target,
            'ScannedCode',
          )
          .format,
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.ScannedCode>(
            target,
            'ScannedCode',
          )
          .value,
      'corners': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.ScannedCode>(
            target,
            'ScannedCode',
          )
          .corners,
      'bounds': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.ScannedCode>(
            target,
            'ScannedCode',
          )
          .bounds,
    },
    constructorSignatures: {
      '': 'const ScannedCode({required CodeFormat format, required String value, required List<Offset> corners})',
    },
    getterSignatures: {
      'format': 'CodeFormat get format',
      'value': 'String get value',
      'corners': 'List<Offset> get corners',
      'bounds': 'Rect? get bounds',
    },
  );
}

// =============================================================================
// CameraException Bridge
// =============================================================================

BridgedClass _createCameraExceptionBridge() {
  return BridgedClass(
    nativeType: $dartnative_camera_4.CameraException,
    name: 'CameraException',
    isAssignable: (v) => v is $dartnative_camera_4.CameraException,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'CameraException');
        final code = D4.getRequiredArg<String>(
          positional,
          0,
          'code',
          'CameraException',
        );
        final description = D4.getOptionalArg<String?>(
          positional,
          1,
          'description',
        );
        return $dartnative_camera_4.CameraException(code, description);
      },
    },
    getters: {
      'code': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraException>(
            target,
            'CameraException',
          )
          .code,
      'description': (visitor, target) => D4
          .validateTarget<$dartnative_camera_4.CameraException>(
            target,
            'CameraException',
          )
          .description,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_4.CameraException>(
          target,
          'CameraException',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const CameraException(String code, [String? description])',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'code': 'String get code',
      'description': 'String? get description',
    },
  );
}

// =============================================================================
// CameraController Bridge
// =============================================================================

BridgedClass _createCameraControllerBridge() {
  return BridgedClass(
    nativeType: $dartnative_camera_1.CameraController,
    name: 'CameraController',
    isAssignable: (v) => v is $dartnative_camera_1.CameraController,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'CameraController');
        final description = D4
            .getRequiredArg<$dartnative_camera_4.CameraDescription>(
              positional,
              0,
              'description',
              'CameraController',
            );
        final resolutionPreset = D4
            .getRequiredArg<$dartnative_camera_4.ResolutionPreset>(
              positional,
              1,
              'resolutionPreset',
              'CameraController',
            );
        final enableAudio = D4.getNamedArgWithDefault<bool>(
          named,
          'enableAudio',
          true,
        );
        final videoQuality = D4
            .getNamedArgWithDefault<$dartnative_camera_4.VideoQuality>(
              named,
              'videoQuality',
              $dartnative_camera_4.VideoQuality.hd,
            );
        final videoAspectRatio = D4
            .getNamedArgWithDefault<$dartnative_camera_4.VideoAspectRatio>(
              named,
              'videoAspectRatio',
              $dartnative_camera_4.VideoAspectRatio.defaultRatio,
            );
        final videoBitRateBps = D4.getNamedArgWithDefault<int>(
          named,
          'videoBitRateBps',
          0,
        );
        return $dartnative_camera_1.CameraController(
          description,
          resolutionPreset,
          enableAudio: enableAudio,
          videoQuality: videoQuality,
          videoAspectRatio: videoAspectRatio,
          videoBitRateBps: videoBitRateBps,
        );
      },
    },
    getters: {
      'description': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .description,
      'resolutionPreset': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .resolutionPreset,
      'enableAudio': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .enableAudio,
      'videoQuality': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .videoQuality,
      'videoAspectRatio': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .videoAspectRatio,
      'videoBitRateBps': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .videoBitRateBps,
      'isInitialized': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .isInitialized,
      'isRecordingVideo': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .isRecordingVideo,
      'previewHandle': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .previewHandle,
      'flashMode': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .flashMode,
      'recordingEvents': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .recordingEvents,
      'imageStream': (visitor, target) => D4
          .validateTarget<$dartnative_camera_1.CameraController>(
            target,
            'CameraController',
          )
          .imageStream,
    },
    methods: {
      'initialize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        return t.initialize();
      },
      'takePicture': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        return t.takePicture();
      },
      'setFlashMode': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 1, 'setFlashMode');
        final mode = D4.getRequiredArg<$dartnative_camera_4.FlashMode>(
          positional,
          0,
          'mode',
          'setFlashMode',
        );
        t.setFlashMode(mode);
        return null;
      },
      'startVideoRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        return t.startVideoRecording();
      },
      'setVideoAspectRatio': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 1, 'setVideoAspectRatio');
        final aspect = D4.getRequiredArg<$dartnative_camera_4.VideoAspectRatio>(
          positional,
          0,
          'aspect',
          'setVideoAspectRatio',
        );
        return t.setVideoAspectRatio(aspect);
      },
      'warmupVideoSensor': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        return t.warmupVideoSensor();
      },
      'setResolutionPreset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 1, 'setResolutionPreset');
        final preset = D4.getRequiredArg<$dartnative_camera_4.ResolutionPreset>(
          positional,
          0,
          'preset',
          'setResolutionPreset',
        );
        return t.setResolutionPreset(preset);
      },
      'stopVideoRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        return t.stopVideoRecording();
      },
      'pauseVideoRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        t.pauseVideoRecording();
        return null;
      },
      'resumeVideoRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        t.resumeVideoRecording();
        return null;
      },
      'setCaptureOrientation': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 1, 'setCaptureOrientation');
        final orientation = D4
            .getRequiredArg<$dartnative_camera_4.CaptureOrientation>(
              positional,
              0,
              'orientation',
              'setCaptureOrientation',
            );
        t.setCaptureOrientation(orientation);
        return null;
      },
      'setZoomLevel': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 1, 'setZoomLevel');
        final zoom = D4.getRequiredArg<double>(
          positional,
          0,
          'zoom',
          'setZoomLevel',
        );
        t.setZoomLevel(zoom);
        return null;
      },
      'setFocusPoint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 2, 'setFocusPoint');
        final x = D4.getRequiredArg<double>(
          positional,
          0,
          'x',
          'setFocusPoint',
        );
        final y = D4.getRequiredArg<double>(
          positional,
          1,
          'y',
          'setFocusPoint',
        );
        t.setFocusPoint(x, y);
        return null;
      },
      'setExposurePoint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 2, 'setExposurePoint');
        final x = D4.getRequiredArg<double>(
          positional,
          0,
          'x',
          'setExposurePoint',
        );
        final y = D4.getRequiredArg<double>(
          positional,
          1,
          'y',
          'setExposurePoint',
        );
        t.setExposurePoint(x, y);
        return null;
      },
      'saveToGallery': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 1, 'saveToGallery');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'saveToGallery',
        );
        final isVideo = D4.getNamedArgWithDefault<bool>(
          named,
          'isVideo',
          false,
        );
        return t.saveToGallery(path, isVideo: isVideo);
      },
      'openGallery': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        t.openGallery();
        return null;
      },
      'startImageStream': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        return t.startImageStream();
      },
      'stopImageStream': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        return t.stopImageStream();
      },
      'startCodeScan': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        final onCodeRaw = named['onCode'];
        if (!named.containsKey('formats')) {
          return t.startCodeScan(
            onCode: onCodeRaw == null
                ? null
                : (($dartnative_camera_4.ScannedCode p0) {
                        return D4.extractBridgedArg<FutureOr<void>>(
                              D4.callInterpreterCallback(visitor!, onCodeRaw, [
                                p0,
                              ]),
                              'callback',
                              visitor,
                            )
                            as FutureOr<void>;
                      })
                      as FutureOr<void> Function(
                        $dartnative_camera_4.ScannedCode,
                      ),
          );
        }
        if (named.containsKey('formats')) {
          final formats = D4.coerceSet<$dartnative_camera_4.CodeFormat>(
            named['formats'],
            'formats',
          );
          return t.startCodeScan(
            onCode: onCodeRaw == null
                ? null
                : (($dartnative_camera_4.ScannedCode p0) {
                        return D4.extractBridgedArg<FutureOr<void>>(
                              D4.callInterpreterCallback(visitor!, onCodeRaw, [
                                p0,
                              ]),
                              'callback',
                              visitor,
                            )
                            as FutureOr<void>;
                      })
                      as FutureOr<void> Function(
                        $dartnative_camera_4.ScannedCode,
                      ),
            formats: formats,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'stopCodeScan': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        return t.stopCodeScan();
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        (t as dynamic).dispose();
        return null;
      },
      'addListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 1, 'addListener');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addListener: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        t.addListener(() {
          D4.callInterpreterCallback(visitor!, listenerRaw, []);
        });
        return null;
      },
      'removeListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        D4.requireMinArgs(positional, 1, 'removeListener');
        if (positional.isEmpty) {
          throw ArgumentError(
            'removeListener: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        t.removeListener(() {
          D4.callInterpreterCallback(visitor!, listenerRaw, []);
        });
        return null;
      },
      'notifyListeners': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_1.CameraController>(
          target,
          'CameraController',
        );
        t.notifyListeners();
        return null;
      },
    },
    constructorSignatures: {
      '': 'CameraController(CameraDescription description, ResolutionPreset resolutionPreset, {bool enableAudio = true, VideoQuality videoQuality = VideoQuality.hd, VideoAspectRatio videoAspectRatio = VideoAspectRatio.defaultRatio, int videoBitRateBps = 0})',
    },
    methodSignatures: {
      'initialize': 'Future<void> initialize()',
      'takePicture': 'Future<String> takePicture()',
      'setFlashMode': 'void setFlashMode(FlashMode mode)',
      'startVideoRecording': 'Future<void> startVideoRecording()',
      'setVideoAspectRatio':
          'Future<void> setVideoAspectRatio(VideoAspectRatio aspect)',
      'warmupVideoSensor': 'Future<void> warmupVideoSensor()',
      'setResolutionPreset':
          'Future<void> setResolutionPreset(ResolutionPreset preset)',
      'stopVideoRecording': 'Future<String> stopVideoRecording()',
      'pauseVideoRecording': 'void pauseVideoRecording()',
      'resumeVideoRecording': 'void resumeVideoRecording()',
      'setCaptureOrientation':
          'void setCaptureOrientation(CaptureOrientation orientation)',
      'setZoomLevel': 'void setZoomLevel(double zoom)',
      'setFocusPoint': 'void setFocusPoint(double x, double y)',
      'setExposurePoint': 'void setExposurePoint(double x, double y)',
      'saveToGallery':
          'Future<bool> saveToGallery(String path, {bool isVideo = false})',
      'openGallery': 'void openGallery()',
      'startImageStream': 'Future<Stream<CameraImage>> startImageStream()',
      'stopImageStream': 'Future<void> stopImageStream()',
      'startCodeScan':
          'Future<Stream<List<ScannedCode>>> startCodeScan({Set<CodeFormat> formats = const {CodeFormat.qr}, FutureOr<void> Function(ScannedCode code)? onCode})',
      'stopCodeScan': 'Future<void> stopCodeScan()',
      'dispose': 'void dispose()',
      'addListener': 'void addListener(void Function() listener)',
      'removeListener': 'void removeListener(void Function() listener)',
      'notifyListeners': 'void notifyListeners()',
    },
    getterSignatures: {
      'description': 'CameraDescription get description',
      'resolutionPreset': 'ResolutionPreset get resolutionPreset',
      'enableAudio': 'bool get enableAudio',
      'videoQuality': 'VideoQuality get videoQuality',
      'videoAspectRatio': 'VideoAspectRatio get videoAspectRatio',
      'videoBitRateBps': 'int get videoBitRateBps',
      'isInitialized': 'bool get isInitialized',
      'isRecordingVideo': 'bool get isRecordingVideo',
      'previewHandle': 'int? get previewHandle',
      'flashMode': 'FlashMode get flashMode',
      'recordingEvents': 'Stream<RecordingEvent> get recordingEvents',
      'imageStream': 'Stream<CameraImage>? get imageStream',
    },
  );
}

// =============================================================================
// DartNativeCamera Bridge
// =============================================================================

BridgedClass _createDartNativeCameraBridge() {
  return BridgedClass(
    nativeType: $dartnative_camera_5.DartNativeCamera,
    name: 'DartNativeCamera',
    isAssignable: (v) => v is $dartnative_camera_5.DartNativeCamera,
    isAbstract: true,
    constructors: {},
    staticMethods: {
      'availableCameras': (visitor, positional, named, typeArgs) {
        return $dartnative_camera_5.DartNativeCamera.availableCameras();
      },
      'requestGalleryAddPermission': (visitor, positional, named, typeArgs) {
        return $dartnative_camera_5
            .DartNativeCamera.requestGalleryAddPermission();
      },
      'requestMicrophonePermission': (visitor, positional, named, typeArgs) {
        return $dartnative_camera_5
            .DartNativeCamera.requestMicrophonePermission();
      },
    },
    staticMethodSignatures: {
      'availableCameras': 'Future<List<CameraDescription>> availableCameras()',
      'requestGalleryAddPermission':
          'Future<bool> requestGalleryAddPermission()',
      'requestMicrophonePermission':
          'Future<bool> requestMicrophonePermission()',
    },
  );
}

// =============================================================================
// CameraPreview Bridge
// =============================================================================

BridgedClass _createCameraPreviewBridge() {
  return BridgedClass(
    nativeType: $dartnative_camera_3.CameraPreview,
    name: 'CameraPreview',
    isAssignable: (v) => v is $dartnative_camera_3.CameraPreview,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final controller = D4
            .getRequiredNamedArg<$dartnative_camera_1.CameraController>(
              named,
              'controller',
              'CameraPreview',
            );
        final enablePinchToZoom = D4.getNamedArgWithDefault<bool>(
          named,
          'enablePinchToZoom',
          true,
        );
        final enableTapToFocus = D4.getNamedArgWithDefault<bool>(
          named,
          'enableTapToFocus',
          true,
        );
        return $dartnative_camera_3.CameraPreview(
          key: key,
          controller: controller,
          enablePinchToZoom: enablePinchToZoom,
          enableTapToFocus: enableTapToFocus,
        );
      },
    },
    getters: {
      'controller': (visitor, target) =>
          (D4.validateTarget<$dartnative_camera_3.CameraPreview>(
                    target,
                    'CameraPreview',
                  )
                  as dynamic)
              .controller,
      'enablePinchToZoom': (visitor, target) => D4
          .validateTarget<$dartnative_camera_3.CameraPreview>(
            target,
            'CameraPreview',
          )
          .enablePinchToZoom,
      'enableTapToFocus': (visitor, target) => D4
          .validateTarget<$dartnative_camera_3.CameraPreview>(
            target,
            'CameraPreview',
          )
          .enableTapToFocus,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_camera_3.CameraPreview>(
            target,
            'CameraPreview',
          )
          .key,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_3.CameraPreview>(
          target,
          'CameraPreview',
        );
        return t.createState();
      },
    },
    constructorSignatures: {
      '': 'const CameraPreview({Key? key, required CameraController controller, bool enablePinchToZoom = true, bool enableTapToFocus = true})',
    },
    methodSignatures: {
      'createState': 'State<CameraPreview> createState()',
    },
    getterSignatures: {
      'controller': 'CameraController get controller',
      'enablePinchToZoom': 'bool get enablePinchToZoom',
      'enableTapToFocus': 'bool get enableTapToFocus',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// CameraFfiBindings Bridge
// =============================================================================

BridgedClass _createCameraFfiBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_camera_2.CameraFfiBindings,
    name: 'CameraFfiBindings',
    isAssignable: (v) => v is $dartnative_camera_2.CameraFfiBindings,
    constructors: {},
    setters: {
      'recordingEventListener': (visitor, target, value) {
        final recordingEventListenerRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'recordingEventListener',
        );
        D4
            .validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            )
            .recordingEventListener = recordingEventListenerRaw == null
            ? null
            : (int p0, int p1, int p2, int p3) {
                D4.callInterpreterCallback(
                  visitor!,
                  recordingEventListenerRaw,
                  [p0, p1, p2, p3],
                );
              };
      },
      'imageFrameListener': (visitor, target, value) {
        final imageFrameListenerRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'imageFrameListener',
        );
        D4
            .validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            )
            .imageFrameListener = imageFrameListenerRaw == null
            ? null
            : (int p0, int p1, int p2, Pointer<Uint8> p3, int p4, int p5) {
                D4.callInterpreterCallback(visitor!, imageFrameListenerRaw, [
                  p0,
                  p1,
                  p2,
                  p3,
                  p4,
                  p5,
                ]);
              };
      },
      'codeScanListener': (visitor, target, value) {
        final codeScanListenerRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'codeScanListener',
        );
        D4
            .validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            )
            .codeScanListener = codeScanListenerRaw == null
            ? null
            : (String p0) {
                D4.callInterpreterCallback(visitor!, codeScanListenerRaw, [p0]);
              };
      },
    },
    methods: {
      'iosAvailableCamerasJson':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            return t.iosAvailableCamerasJson();
          },
      'iosCreate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        return t.iosCreate();
      },
      'iosDispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'iosDispose');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosDispose',
        );
        t.iosDispose(cameraId);
        return null;
      },
      'iosInitialize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        final cameraId = D4.getRequiredNamedArg<int>(
          named,
          'cameraId',
          'iosInitialize',
        );
        final cameraName = D4.getRequiredNamedArg<String>(
          named,
          'cameraName',
          'iosInitialize',
        );
        final preset = D4.getRequiredNamedArg<String>(
          named,
          'preset',
          'iosInitialize',
        );
        final enableAudio = D4.getRequiredNamedArg<bool>(
          named,
          'enableAudio',
          'iosInitialize',
        );
        return t.iosInitialize(
          cameraId: cameraId,
          cameraName: cameraName,
          preset: preset,
          enableAudio: enableAudio,
        );
      },
      'iosTakePicture': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'iosTakePicture');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosTakePicture',
        );
        return t.iosTakePicture(cameraId);
      },
      'iosSetFlashMode': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 2, 'iosSetFlashMode');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosSetFlashMode',
        );
        final mode = D4.getRequiredArg<String>(
          positional,
          1,
          'mode',
          'iosSetFlashMode',
        );
        t.iosSetFlashMode(cameraId, mode);
        return null;
      },
      'iosSetZoomLevel': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 2, 'iosSetZoomLevel');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosSetZoomLevel',
        );
        final zoom = D4.getRequiredArg<double>(
          positional,
          1,
          'zoom',
          'iosSetZoomLevel',
        );
        t.iosSetZoomLevel(cameraId, zoom);
        return null;
      },
      'iosPausePreview': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'iosPausePreview');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosPausePreview',
        );
        t.iosPausePreview(cameraId);
        return null;
      },
      'iosResumePreview': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'iosResumePreview');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosResumePreview',
        );
        t.iosResumePreview(cameraId);
        return null;
      },
      'iosLockOrientation': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 2, 'iosLockOrientation');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosLockOrientation',
        );
        final orientation = D4.getRequiredArg<String>(
          positional,
          1,
          'orientation',
          'iosLockOrientation',
        );
        t.iosLockOrientation(cameraId, orientation);
        return null;
      },
      'iosUnlockOrientation': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'iosUnlockOrientation');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosUnlockOrientation',
        );
        t.iosUnlockOrientation(cameraId);
        return null;
      },
      'iosStartVideoRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'iosStartVideoRecording');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosStartVideoRecording',
        );
        return t.iosStartVideoRecording(cameraId);
      },
      'iosStopVideoRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'iosStopVideoRecording');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosStopVideoRecording',
        );
        return t.iosStopVideoRecording(cameraId);
      },
      'iosPauseVideoRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'iosPauseVideoRecording');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosPauseVideoRecording',
        );
        t.iosPauseVideoRecording(cameraId);
        return null;
      },
      'iosResumeVideoRecording':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 1, 'iosResumeVideoRecording');
            final cameraId = D4.getRequiredArg<int>(
              positional,
              0,
              'cameraId',
              'iosResumeVideoRecording',
            );
            t.iosResumeVideoRecording(cameraId);
            return null;
          },
      'iosImageStreamSetEnabled':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 2, 'iosImageStreamSetEnabled');
            final cameraId = D4.getRequiredArg<int>(
              positional,
              0,
              'cameraId',
              'iosImageStreamSetEnabled',
            );
            final enabled = D4.getRequiredArg<bool>(
              positional,
              1,
              'enabled',
              'iosImageStreamSetEnabled',
            );
            t.iosImageStreamSetEnabled(cameraId, enabled);
            return null;
          },
      'iosCodeScanSetEnabled': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 3, 'iosCodeScanSetEnabled');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosCodeScanSetEnabled',
        );
        final enabled = D4.getRequiredArg<bool>(
          positional,
          1,
          'enabled',
          'iosCodeScanSetEnabled',
        );
        final formatsMask = D4.getRequiredArg<int>(
          positional,
          2,
          'formatsMask',
          'iosCodeScanSetEnabled',
        );
        t.iosCodeScanSetEnabled(cameraId, enabled, formatsMask);
        return null;
      },
      'iosGetPreviewView': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'iosGetPreviewView');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosGetPreviewView',
        );
        return t.iosGetPreviewView(cameraId);
      },
      'iosSetFocusPoint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 3, 'iosSetFocusPoint');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosSetFocusPoint',
        );
        final x = D4.getRequiredArg<double>(
          positional,
          1,
          'x',
          'iosSetFocusPoint',
        );
        final y = D4.getRequiredArg<double>(
          positional,
          2,
          'y',
          'iosSetFocusPoint',
        );
        t.iosSetFocusPoint(cameraId, x, y);
        return null;
      },
      'iosSetExposurePoint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 3, 'iosSetExposurePoint');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosSetExposurePoint',
        );
        final x = D4.getRequiredArg<double>(
          positional,
          1,
          'x',
          'iosSetExposurePoint',
        );
        final y = D4.getRequiredArg<double>(
          positional,
          2,
          'y',
          'iosSetExposurePoint',
        );
        t.iosSetExposurePoint(cameraId, x, y);
        return null;
      },
      'iosSetSessionPreset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 2, 'iosSetSessionPreset');
        final cameraId = D4.getRequiredArg<int>(
          positional,
          0,
          'cameraId',
          'iosSetSessionPreset',
        );
        final presetKey = D4.getRequiredArg<String>(
          positional,
          1,
          'presetKey',
          'iosSetSessionPreset',
        );
        return t.iosSetSessionPreset(cameraId, presetKey);
      },
      'providerGetInstance': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        return t.providerGetInstance();
      },
      'requestCameraPermissions':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            final enableAudio = D4.getRequiredNamedArg<bool>(
              named,
              'enableAudio',
              'requestCameraPermissions',
            );
            return t.requestCameraPermissions(enableAudio: enableAudio);
          },
      'providerGetAvailableCameraInfos':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 1, 'providerGetAvailableCameraInfos');
            final providerId = D4.getRequiredArg<int>(
              positional,
              0,
              'providerId',
              'providerGetAvailableCameraInfos',
            );
            return t.providerGetAvailableCameraInfos(providerId);
          },
      'providerBindToLifecycle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 3, 'providerBindToLifecycle');
        final providerId = D4.getRequiredArg<int>(
          positional,
          0,
          'providerId',
          'providerBindToLifecycle',
        );
        final selectorId = D4.getRequiredArg<int>(
          positional,
          1,
          'selectorId',
          'providerBindToLifecycle',
        );
        if (positional.length <= 2) {
          throw ArgumentError(
            'providerBindToLifecycle: Missing required argument "useCaseIds" at position 2',
          );
        }
        final useCaseIds = D4.coerceList<int>(positional[2], 'useCaseIds');
        return t.providerBindToLifecycle(providerId, selectorId, useCaseIds);
      },
      'providerUnbindAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'providerUnbindAll');
        final providerId = D4.getRequiredArg<int>(
          positional,
          0,
          'providerId',
          'providerUnbindAll',
        );
        t.providerUnbindAll(providerId);
        return null;
      },
      'providerRebindVideoCapture':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 4, 'providerRebindVideoCapture');
            final providerId = D4.getRequiredArg<int>(
              positional,
              0,
              'providerId',
              'providerRebindVideoCapture',
            );
            final cameraSelectorId = D4.getRequiredArg<int>(
              positional,
              1,
              'cameraSelectorId',
              'providerRebindVideoCapture',
            );
            final oldVideoCaptureId = D4.getRequiredArg<int>(
              positional,
              2,
              'oldVideoCaptureId',
              'providerRebindVideoCapture',
            );
            final newVideoCaptureId = D4.getRequiredArg<int>(
              positional,
              3,
              'newVideoCaptureId',
              'providerRebindVideoCapture',
            );
            return t.providerRebindVideoCapture(
              providerId,
              cameraSelectorId,
              oldVideoCaptureId,
              newVideoCaptureId,
            );
          },
      'cameraInfoGetLensFacing':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 1, 'cameraInfoGetLensFacing');
            final cameraInfoId = D4.getRequiredArg<int>(
              positional,
              0,
              'cameraInfoId',
              'cameraInfoGetLensFacing',
            );
            return t.cameraInfoGetLensFacing(cameraInfoId);
          },
      'cameraInfoGetSensorRotation':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 1, 'cameraInfoGetSensorRotation');
            final cameraInfoId = D4.getRequiredArg<int>(
              positional,
              0,
              'cameraInfoId',
              'cameraInfoGetSensorRotation',
            );
            return t.cameraInfoGetSensorRotation(cameraInfoId);
          },
      'selectorCreate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'selectorCreate');
        final lensFacing = D4.getRequiredArg<int>(
          positional,
          0,
          'lensFacing',
          'selectorCreate',
        );
        return t.selectorCreate(lensFacing);
      },
      'imageCaptureCreate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'imageCaptureCreate');
        final flashMode = D4.getRequiredArg<int>(
          positional,
          0,
          'flashMode',
          'imageCaptureCreate',
        );
        return t.imageCaptureCreate(flashMode);
      },
      'imageCaptureSetFlashMode':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 2, 'imageCaptureSetFlashMode');
            final captureId = D4.getRequiredArg<int>(
              positional,
              0,
              'captureId',
              'imageCaptureSetFlashMode',
            );
            final flashMode = D4.getRequiredArg<int>(
              positional,
              1,
              'flashMode',
              'imageCaptureSetFlashMode',
            );
            t.imageCaptureSetFlashMode(captureId, flashMode);
            return null;
          },
      'imageCaptureSetTargetRotation':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 2, 'imageCaptureSetTargetRotation');
            final captureId = D4.getRequiredArg<int>(
              positional,
              0,
              'captureId',
              'imageCaptureSetTargetRotation',
            );
            final surfaceRotation = D4.getRequiredArg<int>(
              positional,
              1,
              'surfaceRotation',
              'imageCaptureSetTargetRotation',
            );
            t.imageCaptureSetTargetRotation(captureId, surfaceRotation);
            return null;
          },
      'videoCaptureSetTargetRotation':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 2, 'videoCaptureSetTargetRotation');
            final captureId = D4.getRequiredArg<int>(
              positional,
              0,
              'captureId',
              'videoCaptureSetTargetRotation',
            );
            final surfaceRotation = D4.getRequiredArg<int>(
              positional,
              1,
              'surfaceRotation',
              'videoCaptureSetTargetRotation',
            );
            t.videoCaptureSetTargetRotation(captureId, surfaceRotation);
            return null;
          },
      'imageCaptureTakePicture':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 1, 'imageCaptureTakePicture');
            final captureId = D4.getRequiredArg<int>(
              positional,
              0,
              'captureId',
              'imageCaptureTakePicture',
            );
            return t.imageCaptureTakePicture(captureId);
          },
      'recorderCreate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        final aspectRatio = D4.getNamedArgWithDefault<int>(
          named,
          'aspectRatio',
          -1,
        );
        final bitRateBps = D4.getNamedArgWithDefault<int>(
          named,
          'bitRateBps',
          0,
        );
        final qualityHandle = D4.getNamedArgWithDefault<int>(
          named,
          'qualityHandle',
          0,
        );
        return t.recorderCreate(
          aspectRatio: aspectRatio,
          bitRateBps: bitRateBps,
          qualityHandle: qualityHandle,
        );
      },
      'qualitySelectorFromQuality':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 1, 'qualitySelectorFromQuality');
            final qualityIndex = D4.getRequiredArg<int>(
              positional,
              0,
              'qualityIndex',
              'qualitySelectorFromQuality',
            );
            return t.qualitySelectorFromQuality(qualityIndex);
          },
      'imageAnalysisCreate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 2, 'imageAnalysisCreate');
        final qualityIndex = D4.getRequiredArg<int>(
          positional,
          0,
          'qualityIndex',
          'imageAnalysisCreate',
        );
        final aspectRatioValue = D4.getRequiredArg<int>(
          positional,
          1,
          'aspectRatioValue',
          'imageAnalysisCreate',
        );
        return t.imageAnalysisCreate(qualityIndex, aspectRatioValue);
      },
      'imageStreamSetEnabled': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'imageStreamSetEnabled');
        final enabled = D4.getRequiredArg<bool>(
          positional,
          0,
          'enabled',
          'imageStreamSetEnabled',
        );
        t.imageStreamSetEnabled(enabled);
        return null;
      },
      'codeScanSetEnabled': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 2, 'codeScanSetEnabled');
        final enabled = D4.getRequiredArg<bool>(
          positional,
          0,
          'enabled',
          'codeScanSetEnabled',
        );
        final formatsMask = D4.getRequiredArg<int>(
          positional,
          1,
          'formatsMask',
          'codeScanSetEnabled',
        );
        t.codeScanSetEnabled(enabled, formatsMask);
        return null;
      },
      'videoCaptureWithOutput': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'videoCaptureWithOutput');
        final recorderId = D4.getRequiredArg<int>(
          positional,
          0,
          'recorderId',
          'videoCaptureWithOutput',
        );
        return t.videoCaptureWithOutput(recorderId);
      },
      'videoStartRecorder': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'videoStartRecorder');
        final recorderId = D4.getRequiredArg<int>(
          positional,
          0,
          'recorderId',
          'videoStartRecorder',
        );
        return t.videoStartRecorder(recorderId);
      },
      'videoStopRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'videoStopRecording');
        final recordingId = D4.getRequiredArg<int>(
          positional,
          0,
          'recordingId',
          'videoStopRecording',
        );
        return t.videoStopRecording(recordingId);
      },
      'videoWarmupSensor': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'videoWarmupSensor');
        final recorderId = D4.getRequiredArg<int>(
          positional,
          0,
          'recorderId',
          'videoWarmupSensor',
        );
        return t.videoWarmupSensor(recorderId);
      },
      'videoPauseRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'videoPauseRecording');
        final recordingId = D4.getRequiredArg<int>(
          positional,
          0,
          'recordingId',
          'videoPauseRecording',
        );
        t.videoPauseRecording(recordingId);
        return null;
      },
      'videoResumeRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'videoResumeRecording');
        final recordingId = D4.getRequiredArg<int>(
          positional,
          0,
          'recordingId',
          'videoResumeRecording',
        );
        t.videoResumeRecording(recordingId);
        return null;
      },
      'previewCreate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        return t.previewCreate();
      },
      'androidSetZoomRatio': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 1, 'androidSetZoomRatio');
        final zoom = D4.getRequiredArg<double>(
          positional,
          0,
          'zoom',
          'androidSetZoomRatio',
        );
        t.androidSetZoomRatio(zoom);
        return null;
      },
      'androidSetFocusPoint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        D4.requireMinArgs(positional, 2, 'androidSetFocusPoint');
        final x = D4.getRequiredArg<double>(
          positional,
          0,
          'x',
          'androidSetFocusPoint',
        );
        final y = D4.getRequiredArg<double>(
          positional,
          1,
          'y',
          'androidSetFocusPoint',
        );
        t.androidSetFocusPoint(x, y);
        return null;
      },
      'androidSetExposurePoint':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            D4.requireMinArgs(positional, 2, 'androidSetExposurePoint');
            final x = D4.getRequiredArg<double>(
              positional,
              0,
              'x',
              'androidSetExposurePoint',
            );
            final y = D4.getRequiredArg<double>(
              positional,
              1,
              'y',
              'androidSetExposurePoint',
            );
            t.androidSetExposurePoint(x, y);
            return null;
          },
      'disposeAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        t.disposeAll();
        return null;
      },
      'saveToGallery': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
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
      'openGallery': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        t.openGallery();
        return null;
      },
      'requestGalleryAddPermission':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
              target,
              'CameraFfiBindings',
            );
            return t.requestGalleryAddPermission();
          },
      'requestMicPermission': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_camera_2.CameraFfiBindings>(
          target,
          'CameraFfiBindings',
        );
        return t.requestMicPermission();
      },
    },
    staticGetters: {
      'instance': (visitor) => $dartnative_camera_2.CameraFfiBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_camera_2.CameraFfiBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'iosAvailableCamerasJson': 'String iosAvailableCamerasJson()',
      'iosCreate': 'int iosCreate()',
      'iosDispose': 'void iosDispose(int cameraId)',
      'iosInitialize':
          'Future<int> iosInitialize({required int cameraId, required String cameraName, required String preset, required bool enableAudio})',
      'iosTakePicture': 'Future<String> iosTakePicture(int cameraId)',
      'iosSetFlashMode': 'void iosSetFlashMode(int cameraId, String mode)',
      'iosSetZoomLevel': 'void iosSetZoomLevel(int cameraId, double zoom)',
      'iosPausePreview': 'void iosPausePreview(int cameraId)',
      'iosResumePreview': 'void iosResumePreview(int cameraId)',
      'iosLockOrientation':
          'void iosLockOrientation(int cameraId, String orientation)',
      'iosUnlockOrientation': 'void iosUnlockOrientation(int cameraId)',
      'iosStartVideoRecording':
          'Future<int> iosStartVideoRecording(int cameraId)',
      'iosStopVideoRecording':
          'Future<String> iosStopVideoRecording(int cameraId)',
      'iosPauseVideoRecording': 'void iosPauseVideoRecording(int cameraId)',
      'iosResumeVideoRecording': 'void iosResumeVideoRecording(int cameraId)',
      'iosImageStreamSetEnabled':
          'void iosImageStreamSetEnabled(int cameraId, bool enabled)',
      'iosCodeScanSetEnabled':
          'void iosCodeScanSetEnabled(int cameraId, bool enabled, int formatsMask)',
      'iosGetPreviewView': 'int iosGetPreviewView(int cameraId)',
      'iosSetFocusPoint':
          'void iosSetFocusPoint(int cameraId, double x, double y)',
      'iosSetExposurePoint':
          'void iosSetExposurePoint(int cameraId, double x, double y)',
      'iosSetSessionPreset':
          'int iosSetSessionPreset(int cameraId, String presetKey)',
      'providerGetInstance': 'Future<int> providerGetInstance()',
      'requestCameraPermissions':
          'Future<bool> requestCameraPermissions({required bool enableAudio})',
      'providerGetAvailableCameraInfos':
          'List<int> providerGetAvailableCameraInfos(int providerId)',
      'providerBindToLifecycle':
          'int providerBindToLifecycle(int providerId, int selectorId, List<int> useCaseIds)',
      'providerUnbindAll': 'void providerUnbindAll(int providerId)',
      'providerRebindVideoCapture':
          'int providerRebindVideoCapture(int providerId, int cameraSelectorId, int oldVideoCaptureId, int newVideoCaptureId)',
      'cameraInfoGetLensFacing':
          'int cameraInfoGetLensFacing(int cameraInfoId)',
      'cameraInfoGetSensorRotation':
          'int cameraInfoGetSensorRotation(int cameraInfoId)',
      'selectorCreate': 'int selectorCreate(int lensFacing)',
      'imageCaptureCreate': 'int imageCaptureCreate(int flashMode)',
      'imageCaptureSetFlashMode':
          'void imageCaptureSetFlashMode(int captureId, int flashMode)',
      'imageCaptureSetTargetRotation':
          'void imageCaptureSetTargetRotation(int captureId, int surfaceRotation)',
      'videoCaptureSetTargetRotation':
          'void videoCaptureSetTargetRotation(int captureId, int surfaceRotation)',
      'imageCaptureTakePicture':
          'Future<String> imageCaptureTakePicture(int captureId)',
      'recorderCreate':
          'int recorderCreate({int aspectRatio = -1, int bitRateBps = 0, int qualityHandle = 0})',
      'qualitySelectorFromQuality':
          'int qualitySelectorFromQuality(int qualityIndex)',
      'imageAnalysisCreate':
          'int imageAnalysisCreate(int qualityIndex, int aspectRatioValue)',
      'imageStreamSetEnabled': 'void imageStreamSetEnabled(bool enabled)',
      'codeScanSetEnabled':
          'void codeScanSetEnabled(bool enabled, int formatsMask)',
      'videoCaptureWithOutput': 'int videoCaptureWithOutput(int recorderId)',
      'videoStartRecorder': 'Future<int> videoStartRecorder(int recorderId)',
      'videoStopRecording':
          'Future<String> videoStopRecording(int recordingId)',
      'videoWarmupSensor': 'Future<int> videoWarmupSensor(int recorderId)',
      'videoPauseRecording': 'void videoPauseRecording(int recordingId)',
      'videoResumeRecording': 'void videoResumeRecording(int recordingId)',
      'previewCreate': 'int previewCreate()',
      'androidSetZoomRatio': 'void androidSetZoomRatio(double zoom)',
      'androidSetFocusPoint': 'void androidSetFocusPoint(double x, double y)',
      'androidSetExposurePoint':
          'void androidSetExposurePoint(double x, double y)',
      'disposeAll': 'void disposeAll()',
      'saveToGallery':
          'Future<bool> saveToGallery(String path, String mediaType)',
      'openGallery': 'void openGallery()',
      'requestGalleryAddPermission':
          'Future<bool> requestGalleryAddPermission()',
      'requestMicPermission': 'Future<bool> requestMicPermission()',
    },
    setterSignatures: {
      'recordingEventListener':
          'set recordingEventListener(RecordingEventListener? value)',
      'imageFrameListener': 'set imageFrameListener(ImageFrameListener? value)',
      'codeScanListener': 'set codeScanListener(CodeScanListener? value)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'CameraFfiBindings get instance',
    },
  );
}

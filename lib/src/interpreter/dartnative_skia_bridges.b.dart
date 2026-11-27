// D4rt Bridge - Generated file, do not edit
// Sources: 5 files
// Generated: 2026-11-24T16:20:34.415483 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:dartnative/src/core.dart' as $dartnative_1;
import 'package:dartnative/src/framework.dart' as $dartnative_2;
import 'package:dartnative/src/painting.dart' as $dartnative_3;
import 'package:dartnative/src/reconciler/element.dart' as $dartnative_4;
import 'package:dartnative/src/reconciler/mutations.dart' as $dartnative_5;
import 'package:dartnative/src/widgets/custom_paint.dart' as $dartnative_6;
import 'package:dartnative_skia/src/canvas_surface.dart' as $dartnative_skia_1;
import 'package:dartnative_skia/src/canvas_widget.dart' as $dartnative_skia_2;
import 'package:dartnative_skia/src/skia_bindings.dart' as $dartnative_skia_3;
import 'package:dartnative_skia/src/text_particle_effect.dart'
    as $dartnative_skia_4;

/// Bridge class for dartnative_skia module.
class DartnativeSkiaBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createCanvasSurfaceBridge(),
      _createCanvasDiagnosticsBridge(),
      _createCanvasSurfaceNativeElementBridge(),
      _createPaintBridge(),
      _createShaderBridge(),
      _createGradientBridge(),
      _createMaskFilterBridge(),
      _createImageFilterBridge(),
      _createBlurImageFilterBridge(),
      _createRRectBridge(),
      _createPathBridge(),
      _createPathOperationBridge(),
      _createPathMoveToBridge(),
      _createPathLineToBridge(),
      _createPathCubicToBridge(),
      _createPathArcToBridge(),
      _createPathCloseBridge(),
      _createPathAddOvalBridge(),
      _createPathAddRectBridge(),
      _createPathAddRRectBridge(),
      _createCanvasImageBridge(),
      _createNetworkCanvasImageBridge(),
      _createParagraphBridge(),
      _createParagraphConstraintsBridge(),
      _createLineMetricsBridge(),
      _createTextBoxBridge(),
      _createParagraphStyleBridge(),
      _createParagraphBuilderBridge(),
      _createCanvasBridge(),
      _createCustomPainterBridge(),
      _createCustomPaintBridge(),
      _createBinaryCanvasRecorderBridge(),
      _createDisposableShaderBridge(),
      _createSkiaImageBridge(),
      _createSkiaPictureRecorderBridge(),
      _createSimpleParagraphBridge(),
      _createRuntimeEffectBridge(),
      _createFragmentProgramBridge(),
      _createFragmentShaderBridge(),
      _createCanvasLinearGradientBridge(),
      _createCanvasRadialGradientBridge(),
      _createSkiaBindingsBridge(),
      _createTextParticleEffectBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'CanvasSurface': _createCanvasSurfaceBridge,
      'CanvasDiagnostics': _createCanvasDiagnosticsBridge,
      'CanvasSurfaceNativeElement': _createCanvasSurfaceNativeElementBridge,
      'Paint': _createPaintBridge,
      'Shader': _createShaderBridge,
      'Gradient': _createGradientBridge,
      'MaskFilter': _createMaskFilterBridge,
      'ImageFilter': _createImageFilterBridge,
      'BlurImageFilter': _createBlurImageFilterBridge,
      'RRect': _createRRectBridge,
      'Path': _createPathBridge,
      'PathOperation': _createPathOperationBridge,
      'PathMoveTo': _createPathMoveToBridge,
      'PathLineTo': _createPathLineToBridge,
      'PathCubicTo': _createPathCubicToBridge,
      'PathArcTo': _createPathArcToBridge,
      'PathClose': _createPathCloseBridge,
      'PathAddOval': _createPathAddOvalBridge,
      'PathAddRect': _createPathAddRectBridge,
      'PathAddRRect': _createPathAddRRectBridge,
      'CanvasImage': _createCanvasImageBridge,
      'NetworkCanvasImage': _createNetworkCanvasImageBridge,
      'Paragraph': _createParagraphBridge,
      'ParagraphConstraints': _createParagraphConstraintsBridge,
      'LineMetrics': _createLineMetricsBridge,
      'TextBox': _createTextBoxBridge,
      'ParagraphStyle': _createParagraphStyleBridge,
      'ParagraphBuilder': _createParagraphBuilderBridge,
      'Canvas': _createCanvasBridge,
      'CustomPainter': _createCustomPainterBridge,
      'CustomPaint': _createCustomPaintBridge,
      'BinaryCanvasRecorder': _createBinaryCanvasRecorderBridge,
      'DisposableShader': _createDisposableShaderBridge,
      'SkiaImage': _createSkiaImageBridge,
      'SkiaPictureRecorder': _createSkiaPictureRecorderBridge,
      'SimpleParagraph': _createSimpleParagraphBridge,
      'RuntimeEffect': _createRuntimeEffectBridge,
      'FragmentProgram': _createFragmentProgramBridge,
      'FragmentShader': _createFragmentShaderBridge,
      'CanvasLinearGradient': _createCanvasLinearGradientBridge,
      'CanvasRadialGradient': _createCanvasRadialGradientBridge,
      'SkiaBindings': _createSkiaBindingsBridge,
      'TextParticleEffect': _createTextParticleEffectBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'CanvasSurface': $dartnative_skia_1.CanvasSurface,
      'CanvasDiagnostics': $dartnative_skia_1.CanvasDiagnostics,
      'CanvasSurfaceNativeElement':
          $dartnative_skia_1.CanvasSurfaceNativeElement,
      'Paint': $dartnative_6.Paint,
      'Shader': $dartnative_6.Shader,
      'Gradient': $dartnative_6.Gradient,
      'MaskFilter': $dartnative_6.MaskFilter,
      'ImageFilter': $dartnative_6.ImageFilter,
      'BlurImageFilter': $dartnative_6.BlurImageFilter,
      'RRect': $dartnative_6.RRect,
      'Path': $dartnative_6.Path,
      'PathOperation': $dartnative_6.PathOperation,
      'PathMoveTo': $dartnative_6.PathMoveTo,
      'PathLineTo': $dartnative_6.PathLineTo,
      'PathCubicTo': $dartnative_6.PathCubicTo,
      'PathArcTo': $dartnative_6.PathArcTo,
      'PathClose': $dartnative_6.PathClose,
      'PathAddOval': $dartnative_6.PathAddOval,
      'PathAddRect': $dartnative_6.PathAddRect,
      'PathAddRRect': $dartnative_6.PathAddRRect,
      'CanvasImage': $dartnative_6.CanvasImage,
      'NetworkCanvasImage': $dartnative_6.NetworkCanvasImage,
      'Paragraph': $dartnative_6.Paragraph,
      'ParagraphConstraints': $dartnative_6.ParagraphConstraints,
      'LineMetrics': $dartnative_6.LineMetrics,
      'TextBox': $dartnative_6.TextBox,
      'ParagraphStyle': $dartnative_6.ParagraphStyle,
      'ParagraphBuilder': $dartnative_6.ParagraphBuilder,
      'Canvas': $dartnative_6.Canvas,
      'CustomPainter': $dartnative_6.CustomPainter,
      'CustomPaint': $dartnative_6.CustomPaint,
      'BinaryCanvasRecorder': $dartnative_6.BinaryCanvasRecorder,
      'DisposableShader': $dartnative_skia_2.DisposableShader,
      'SkiaImage': $dartnative_skia_2.SkiaImage,
      'SkiaPictureRecorder': $dartnative_skia_2.SkiaPictureRecorder,
      'SimpleParagraph': $dartnative_skia_2.SimpleParagraph,
      'RuntimeEffect': $dartnative_skia_2.RuntimeEffect,
      'FragmentProgram': $dartnative_skia_2.FragmentProgram,
      'FragmentShader': $dartnative_skia_2.FragmentShader,
      'CanvasLinearGradient': $dartnative_skia_2.CanvasLinearGradient,
      'CanvasRadialGradient': $dartnative_skia_2.CanvasRadialGradient,
      'SkiaBindings': $dartnative_skia_3.SkiaBindings,
      'TextParticleEffect': $dartnative_skia_4.TextParticleEffect,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'CanvasSurface': 'package:dartnative_skia/src/canvas_surface.dart',
      'CanvasDiagnostics': 'package:dartnative_skia/src/canvas_surface.dart',
      'CanvasSurfaceNativeElement':
          'package:dartnative_skia/src/canvas_surface.dart',
      'Paint': 'package:dartnative/src/widgets/custom_paint.dart',
      'Shader': 'package:dartnative/src/widgets/custom_paint.dart',
      'Gradient': 'package:dartnative/src/widgets/custom_paint.dart',
      'MaskFilter': 'package:dartnative/src/widgets/custom_paint.dart',
      'ImageFilter': 'package:dartnative/src/widgets/custom_paint.dart',
      'BlurImageFilter': 'package:dartnative/src/widgets/custom_paint.dart',
      'RRect': 'package:dartnative/src/widgets/custom_paint.dart',
      'Path': 'package:dartnative/src/widgets/custom_paint.dart',
      'PathOperation': 'package:dartnative/src/widgets/custom_paint.dart',
      'PathMoveTo': 'package:dartnative/src/widgets/custom_paint.dart',
      'PathLineTo': 'package:dartnative/src/widgets/custom_paint.dart',
      'PathCubicTo': 'package:dartnative/src/widgets/custom_paint.dart',
      'PathArcTo': 'package:dartnative/src/widgets/custom_paint.dart',
      'PathClose': 'package:dartnative/src/widgets/custom_paint.dart',
      'PathAddOval': 'package:dartnative/src/widgets/custom_paint.dart',
      'PathAddRect': 'package:dartnative/src/widgets/custom_paint.dart',
      'PathAddRRect': 'package:dartnative/src/widgets/custom_paint.dart',
      'CanvasImage': 'package:dartnative/src/widgets/custom_paint.dart',
      'NetworkCanvasImage': 'package:dartnative/src/widgets/custom_paint.dart',
      'Paragraph': 'package:dartnative/src/widgets/custom_paint.dart',
      'ParagraphConstraints':
          'package:dartnative/src/widgets/custom_paint.dart',
      'LineMetrics': 'package:dartnative/src/widgets/custom_paint.dart',
      'TextBox': 'package:dartnative/src/widgets/custom_paint.dart',
      'ParagraphStyle': 'package:dartnative/src/widgets/custom_paint.dart',
      'ParagraphBuilder': 'package:dartnative/src/widgets/custom_paint.dart',
      'Canvas': 'package:dartnative/src/widgets/custom_paint.dart',
      'CustomPainter': 'package:dartnative/src/widgets/custom_paint.dart',
      'CustomPaint': 'package:dartnative/src/widgets/custom_paint.dart',
      'BinaryCanvasRecorder':
          'package:dartnative/src/widgets/custom_paint.dart',
      'DisposableShader': 'package:dartnative_skia/src/canvas_widget.dart',
      'SkiaImage': 'package:dartnative_skia/src/canvas_widget.dart',
      'SkiaPictureRecorder': 'package:dartnative_skia/src/canvas_widget.dart',
      'SimpleParagraph': 'package:dartnative_skia/src/canvas_widget.dart',
      'RuntimeEffect': 'package:dartnative_skia/src/canvas_widget.dart',
      'FragmentProgram': 'package:dartnative_skia/src/canvas_widget.dart',
      'FragmentShader': 'package:dartnative_skia/src/canvas_widget.dart',
      'CanvasLinearGradient': 'package:dartnative_skia/src/canvas_widget.dart',
      'CanvasRadialGradient': 'package:dartnative_skia/src/canvas_widget.dart',
      'SkiaBindings': 'package:dartnative_skia/src/skia_bindings.dart',
      'TextParticleEffect':
          'package:dartnative_skia/src/text_particle_effect.dart',
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
      'CanvasSurface': ['Widget'],
      'CanvasSurfaceNativeElement': [
        'NativeElement',
        'Element',
        'BuildContext',
      ],
      'Gradient': ['Shader'],
      'BlurImageFilter': ['ImageFilter'],
      'PathMoveTo': ['PathOperation'],
      'PathLineTo': ['PathOperation'],
      'PathCubicTo': ['PathOperation'],
      'PathArcTo': ['PathOperation'],
      'PathClose': ['PathOperation'],
      'PathAddOval': ['PathOperation'],
      'PathAddRect': ['PathOperation'],
      'PathAddRRect': ['PathOperation'],
      'NetworkCanvasImage': ['CanvasImage'],
      'CustomPaint': ['Widget'],
      'BinaryCanvasRecorder': ['Canvas'],
      'DisposableShader': ['Shader'],
      'SkiaImage': ['CanvasImage'],
      'SimpleParagraph': ['Paragraph'],
      'FragmentShader': ['Shader'],
      'TextParticleEffect': ['CustomPainter'],
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
    return [
      BridgedEnumDefinition<$dartnative_skia_1.CanvasSkipReason>(
        name: 'CanvasSkipReason',
        values: $dartnative_skia_1.CanvasSkipReason.values,
      ),
      BridgedEnumDefinition<$dartnative_6.PaintingStyle>(
        name: 'PaintingStyle',
        values: $dartnative_6.PaintingStyle.values,
      ),
      BridgedEnumDefinition<$dartnative_6.StrokeCap>(
        name: 'StrokeCap',
        values: $dartnative_6.StrokeCap.values,
      ),
      BridgedEnumDefinition<$dartnative_6.StrokeJoin>(
        name: 'StrokeJoin',
        values: $dartnative_6.StrokeJoin.values,
      ),
      BridgedEnumDefinition<$dartnative_6.BlendMode>(
        name: 'BlendMode',
        values: $dartnative_6.BlendMode.values,
      ),
      BridgedEnumDefinition<$dartnative_6.MaskFilterBlurStyle>(
        name: 'MaskFilterBlurStyle',
        values: $dartnative_6.MaskFilterBlurStyle.values,
      ),
      BridgedEnumDefinition<$dartnative_6.TileMode>(
        name: 'TileMode',
        values: $dartnative_6.TileMode.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'CanvasSkipReason': 'package:dartnative_skia/src/canvas_surface.dart',
      'PaintingStyle': 'package:dartnative/src/widgets/custom_paint.dart',
      'StrokeCap': 'package:dartnative/src/widgets/custom_paint.dart',
      'StrokeJoin': 'package:dartnative/src/widgets/custom_paint.dart',
      'BlendMode': 'package:dartnative/src/widgets/custom_paint.dart',
      'MaskFilterBlurStyle': 'package:dartnative/src/widgets/custom_paint.dart',
      'TileMode': 'package:dartnative/src/widgets/custom_paint.dart',
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
        source: 'package:dartnative_skia/dartnative_skia.dart',
        target: 'package:dartnative_skia/src/canvas_surface.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_skia/dartnative_skia.dart',
        target: 'package:dartnative_skia/src/canvas_widget.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_skia/dartnative_skia.dart',
        target: 'package:dartnative_skia/src/skia_bindings.dart',
        show: {'SkiaBindings'},
        hide: null,
      ),
      (
        source: 'package:dartnative_skia/dartnative_skia.dart',
        target: 'package:dartnative_skia/src/text_particle_effect.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_skia/src/canvas_widget.dart',
        target: 'package:dartnative/src/widgets/custom_paint.dart',
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

    // Register global variables
    registerGlobalVariables(interpreter, importPath);

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

  /// Registers all global variables with the interpreter.
  ///
  /// [importPath] is the package import path for library-scoped registration.
  /// Collects all registration errors and throws a single exception
  /// with all error details if any registrations fail.
  static void registerGlobalVariables(D4rt interpreter, String importPath) {
    final errors = <String>[];

    try {
      interpreter.registerGlobalVariable(
        'kUseThreadedRaster',
        $dartnative_skia_1.kUseThreadedRaster,
        importPath,
        sourceUri: 'package:dartnative_skia/src/canvas_surface.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "kUseThreadedRaster": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'kCanvasDriverWatchdog',
        $dartnative_skia_1.kCanvasDriverWatchdog,
        importPath,
        sourceUri: 'package:dartnative_skia/src/canvas_surface.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "kCanvasDriverWatchdog": $e');
    }

    if (errors.isNotEmpty) {
      throw StateError(
        'Bridge registration errors (dartnative_skia):\n${errors.join("\n")}',
      );
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {
      'registerSkiaFactories': (visitor, positional, named, typeArgs) {
        return $dartnative_skia_1.registerSkiaFactories();
      },
      'loadSkiaImageFromBytes': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'loadSkiaImageFromBytes');
        final bytes = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'bytes',
          'loadSkiaImageFromBytes',
        );
        return $dartnative_skia_2.loadSkiaImageFromBytes(bytes);
      },
      'createNativeCanvas': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'createNativeCanvas');
        final ptr = D4.getRequiredArg<Pointer<Void>>(
          positional,
          0,
          'ptr',
          'createNativeCanvas',
        );
        return $dartnative_skia_2.createNativeCanvas(ptr);
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'registerSkiaFactories':
          'package:dartnative_skia/src/canvas_surface.dart',
      'loadSkiaImageFromBytes':
          'package:dartnative_skia/src/canvas_widget.dart',
      'createNativeCanvas': 'package:dartnative_skia/src/canvas_widget.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'registerSkiaFactories': 'void registerSkiaFactories()',
      'loadSkiaImageFromBytes':
          'SkiaImage? loadSkiaImageFromBytes(Uint8List bytes)',
      'createNativeCanvas': 'Canvas createNativeCanvas(Pointer<Void> ptr)',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative/src/widgets/custom_paint.dart',
      'package:dartnative_skia/src/canvas_surface.dart',
      'package:dartnative_skia/src/canvas_widget.dart',
      'package:dartnative_skia/src/skia_bindings.dart',
      'package:dartnative_skia/src/text_particle_effect.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    final imports = StringBuffer();
    imports.writeln("import 'package:dartnative_skia/dartnative_skia.dart';");
    imports.writeln("import 'package:dartnative/dartnative.dart';");
    return imports.toString();
  }

  /// Returns barrel import URIs for sub-packages discovered through re-exports.
  ///
  /// When a module follows re-exports into sub-packages (e.g., dcli re-exports
  /// dcli_core), D4rt scripts may import those sub-packages directly.
  /// These barrels need to be registered with the interpreter separately
  /// so that module resolution finds content for those URIs.
  static List<String> subPackageBarrels() {
    return [
      'package:dartnative/dartnative.dart',
    ];
  }

  /// Returns a list of bridged enum names.
  static List<String> get enumNames => [
    'CanvasSkipReason',
    'PaintingStyle',
    'StrokeCap',
    'StrokeJoin',
    'BlendMode',
    'MaskFilterBlurStyle',
    'TileMode',
  ];
}

// =============================================================================
// CanvasSurface Bridge
// =============================================================================

BridgedClass _createCanvasSurfaceBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_1.CanvasSurface,
    name: 'CanvasSurface',
    isAssignable: (v) => v is $dartnative_skia_1.CanvasSurface,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final width = D4.getOptionalNamedArg<double?>(named, 'width');
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final padding = D4.getNamedArgWithDefault<$dartnative_3.EdgeInsets>(
          named,
          'padding',
          $dartnative_3.EdgeInsets.zero,
        );
        final decoration = D4.getOptionalNamedArg<$dartnative_3.BoxDecoration?>(
          named,
          'decoration',
        );
        final backgroundColor = D4.getOptionalNamedArg<$dartnative_3.Color?>(
          named,
          'backgroundColor',
        );
        final painter = D4.getOptionalNamedArg<$dartnative_6.CustomPainter?>(
          named,
          'painter',
        );
        final animating = D4.getNamedArgWithDefault<bool>(
          named,
          'animating',
          true,
        );
        return $dartnative_skia_1.CanvasSurface(
          key: key,
          width: width,
          height: height,
          padding: padding,
          decoration: decoration,
          backgroundColor: backgroundColor,
          painter: painter,
          animating: animating,
        );
      },
      'static': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final width = D4.getOptionalNamedArg<double?>(named, 'width');
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final padding = D4.getNamedArgWithDefault<$dartnative_3.EdgeInsets>(
          named,
          'padding',
          $dartnative_3.EdgeInsets.zero,
        );
        final decoration = D4.getOptionalNamedArg<$dartnative_3.BoxDecoration?>(
          named,
          'decoration',
        );
        final backgroundColor = D4.getOptionalNamedArg<$dartnative_3.Color?>(
          named,
          'backgroundColor',
        );
        final painter = D4.getOptionalNamedArg<$dartnative_6.CustomPainter?>(
          named,
          'painter',
        );
        return $dartnative_skia_1.CanvasSurface.static(
          key: key,
          width: width,
          height: height,
          padding: padding,
          decoration: decoration,
          backgroundColor: backgroundColor,
          painter: painter,
        );
      },
    },
    getters: {
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurface>(
            target,
            'CanvasSurface',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurface>(
            target,
            'CanvasSurface',
          )
          .height,
      'padding': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurface>(
            target,
            'CanvasSurface',
          )
          .padding,
      'decoration': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurface>(
            target,
            'CanvasSurface',
          )
          .decoration,
      'backgroundColor': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurface>(
            target,
            'CanvasSurface',
          )
          .backgroundColor,
      'painter': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurface>(
            target,
            'CanvasSurface',
          )
          .painter,
      'animating': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurface>(
            target,
            'CanvasSurface',
          )
          .animating,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurface>(
            target,
            'CanvasSurface',
          )
          .key,
    },
    constructorSignatures: {
      '': 'const CanvasSurface({Key? key, double? width, double? height, EdgeInsets padding = EdgeInsets.zero, BoxDecoration? decoration, Color? backgroundColor, CustomPainter? painter, bool animating = true})',
      'static':
          'const CanvasSurface.static({Key? key, double? width, double? height, EdgeInsets padding = EdgeInsets.zero, BoxDecoration? decoration, Color? backgroundColor, CustomPainter? painter})',
    },
    getterSignatures: {
      'width': 'double? get width',
      'height': 'double? get height',
      'padding': 'EdgeInsets get padding',
      'decoration': 'BoxDecoration? get decoration',
      'backgroundColor': 'Color? get backgroundColor',
      'painter': 'CustomPainter? get painter',
      'animating': 'bool get animating',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// CanvasDiagnostics Bridge
// =============================================================================

BridgedClass _createCanvasDiagnosticsBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_1.CanvasDiagnostics,
    name: 'CanvasDiagnostics',
    isAssignable: (v) => v is $dartnative_skia_1.CanvasDiagnostics,
    constructors: {},
    getters: {
      'driverRunning': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
            target,
            'CanvasDiagnostics',
          )
          .driverRunning,
      'driverKind': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
            target,
            'CanvasDiagnostics',
          )
          .driverKind,
      'mountedSurfaces': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
            target,
            'CanvasDiagnostics',
          )
          .mountedSurfaces,
      'appPaused': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
            target,
            'CanvasDiagnostics',
          )
          .appPaused,
      'ticksDelivered': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
            target,
            'CanvasDiagnostics',
          )
          .ticksDelivered,
      'framesPainted': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
            target,
            'CanvasDiagnostics',
          )
          .framesPainted,
      'sinceLastTick': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
            target,
            'CanvasDiagnostics',
          )
          .sinceLastTick,
      'sinceLastPaint': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
            target,
            'CanvasDiagnostics',
          )
          .sinceLastPaint,
      'skipReasons': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
            target,
            'CanvasDiagnostics',
          )
          .skipReasons,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_1.CanvasDiagnostics>(
          target,
          'CanvasDiagnostics',
        );
        return t.toString();
      },
    },
    staticMethods: {
      'now': (visitor, positional, named, typeArgs) {
        return $dartnative_skia_1.CanvasDiagnostics.now();
      },
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'driverRunning': 'bool get driverRunning',
      'driverKind': 'String get driverKind',
      'mountedSurfaces': 'int get mountedSurfaces',
      'appPaused': 'bool get appPaused',
      'ticksDelivered': 'int get ticksDelivered',
      'framesPainted': 'int get framesPainted',
      'sinceLastTick': 'Duration? get sinceLastTick',
      'sinceLastPaint': 'Duration? get sinceLastPaint',
      'skipReasons': 'List<CanvasSkipReason> get skipReasons',
    },
    staticMethodSignatures: {
      'now': 'CanvasDiagnostics now()',
    },
  );
}

// =============================================================================
// CanvasSurfaceNativeElement Bridge
// =============================================================================

BridgedClass _createCanvasSurfaceNativeElementBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_1.CanvasSurfaceNativeElement,
    name: 'CanvasSurfaceNativeElement',
    isAssignable: (v) => v is $dartnative_skia_1.CanvasSurfaceNativeElement,
    hierarchyDepth: 3,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'CanvasSurfaceNativeElement');
        final widget = D4.getRequiredArg<$dartnative_1.Widget>(
          positional,
          0,
          'widget',
          'CanvasSurfaceNativeElement',
        );
        return $dartnative_skia_1.CanvasSurfaceNativeElement(widget);
      },
    },
    getters: {
      'viewType': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .viewType,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .children,
      'stretchAsStackFlowChild': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .stretchAsStackFlowChild,
      'isConstraintTransparent': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .isConstraintTransparent,
      'keepsOwnSizeAtRoot': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .keepsOwnSizeAtRoot,
      'widget': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .widget,
      'parent': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .parent,
      'isInsetSensitive': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .isInsetSensitive,
      'viewId': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .viewId,
      'reconciler': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .reconciler,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .size,
      'isScrollViewport': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .isScrollViewport,
      'ownRenderObject': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .ownRenderObject,
      'mounted': (visitor, target) => D4
          .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
            target,
            'CanvasSurfaceNativeElement',
          )
          .mounted,
    },
    methods: {
      'buildProps': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        return t.buildProps();
      },
      'mount': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 2, 'mount');
        final parent = D4.getRequiredArg<$dartnative_4.Element?>(
          positional,
          0,
          'parent',
          'mount',
        );
        final rec = D4.getRequiredArg<$dartnative_4.UIKitReconciler>(
          positional,
          1,
          'rec',
          'mount',
        );
        t.mount(parent, rec);
        return null;
      },
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 1, 'update');
        final newWidget = D4.getRequiredArg<$dartnative_1.Widget>(
          positional,
          0,
          'newWidget',
          'update',
        );
        t.update(newWidget);
        return null;
      },
      'unmount': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        (t as dynamic).unmount();
        return null;
      },
      'emitMutation': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 1, 'emitMutation');
        final mutation = D4.getRequiredArg<$dartnative_5.ViewMutation>(
          positional,
          0,
          'mutation',
          'emitMutation',
        );
        t.emitMutation(mutation);
        return null;
      },
      'setSideSafeInset': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 2, 'setSideSafeInset');
        final left = D4.getRequiredArg<double>(
          positional,
          0,
          'left',
          'setSideSafeInset',
        );
        final right = D4.getRequiredArg<double>(
          positional,
          1,
          'right',
          'setSideSafeInset',
        );
        t.setSideSafeInset(left, right);
        return null;
      },
      'rebuild': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        t.rebuild();
        return null;
      },
      'propsEqual': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 2, 'propsEqual');
        final oldProps = D4.getRequiredArg<$dartnative_5.ViewProps?>(
          positional,
          0,
          'oldProps',
          'propsEqual',
        );
        final newProps = D4.getRequiredArg<$dartnative_5.ViewProps>(
          positional,
          1,
          'newProps',
          'propsEqual',
        );
        return t.propsEqual(oldProps, newProps);
      },
      'findRenderObject': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        return t.findRenderObject();
      },
      'fillClaimUnder': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        final parentIsRow = D4.getRequiredNamedArg<bool>(
          named,
          'parentIsRow',
          'fillClaimUnder',
        );
        return t.fillClaimUnder(parentIsRow: parentIsRow);
      },
      'addSubscription': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 1, 'addSubscription');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addSubscription: Missing required argument "teardown" at position 0',
          );
        }
        final teardownRaw = positional[0];
        t.addSubscription(() {
          D4.callInterpreterCallback(visitor!, teardownRaw, []);
        });
        return null;
      },
      'dependOnInheritedWidgetOfExactType':
          (visitor, target, positional, named, typeArgs) {
            final _interceptor = D4.findBridgedMethodInterceptor(
              'Element',
              'dependOnInheritedWidgetOfExactType',
            );
            if (_interceptor != null) {
              return _interceptor(visitor, target, positional, named, typeArgs);
            }
            final t = D4
                .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
                  target,
                  'CanvasSurfaceNativeElement',
                );
            return t.dependOnInheritedWidgetOfExactType();
          },
      'getInheritedWidgetOfExactType':
          (visitor, target, positional, named, typeArgs) {
            final _interceptor = D4.findBridgedMethodInterceptor(
              'Element',
              'getInheritedWidgetOfExactType',
            );
            if (_interceptor != null) {
              return _interceptor(visitor, target, positional, named, typeArgs);
            }
            final t = D4
                .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
                  target,
                  'CanvasSurfaceNativeElement',
                );
            return t.getInheritedWidgetOfExactType();
          },
      'visitChildElements': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 1, 'visitChildElements');
        if (positional.isEmpty) {
          throw ArgumentError(
            'visitChildElements: Missing required argument "visitor" at position 0',
          );
        }
        final visitor_Raw = positional[0];
        t.visitChildElements(($dartnative_1.BuildContext p0) {
          D4.callInterpreterCallback(visitor!, visitor_Raw, [p0]);
        });
        return null;
      },
      'visitAncestorElements': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 1, 'visitAncestorElements');
        if (positional.isEmpty) {
          throw ArgumentError(
            'visitAncestorElements: Missing required argument "visitor" at position 0',
          );
        }
        final visitor_Raw = positional[0];
        t.visitAncestorElements(
          (($dartnative_1.BuildContext p0) {
                return D4.callInterpreterCallback(visitor!, visitor_Raw, [p0])
                    as bool;
              })
              as bool Function($dartnative_1.BuildContext),
        );
        return null;
      },
      'dispatchNotification': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 1, 'dispatchNotification');
        final notification = D4.getRequiredArg<$dartnative_1.Notification>(
          positional,
          0,
          'notification',
          'dispatchNotification',
        );
        t.dispatchNotification(notification);
        return null;
      },
      'findAncestorWidgetOfExactType':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
                  target,
                  'CanvasSurfaceNativeElement',
                );
            return t.findAncestorWidgetOfExactType();
          },
      'findAncestorStateOfType':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
                  target,
                  'CanvasSurfaceNativeElement',
                );
            return t.findAncestorStateOfType();
          },
      'findRootAncestorStateOfType':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
                  target,
                  'CanvasSurfaceNativeElement',
                );
            return t.findRootAncestorStateOfType();
          },
      'findAncestorRenderObjectOfType':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
                  target,
                  'CanvasSurfaceNativeElement',
                );
            return t.findAncestorRenderObjectOfType();
          },
      'replaceChild': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        D4.requireMinArgs(positional, 2, 'replaceChild');
        final oldChild = D4.getRequiredArg<$dartnative_4.Element>(
          positional,
          0,
          'oldChild',
          'replaceChild',
        );
        final newChild = D4.getRequiredArg<$dartnative_4.Element>(
          positional,
          1,
          'newChild',
          'replaceChild',
        );
        t.replaceChild(oldChild, newChild);
        return null;
      },
      'markDirty': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
              target,
              'CanvasSurfaceNativeElement',
            );
        t.markDirty();
        return null;
      },
      'notifyDependencyChanged':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<$dartnative_skia_1.CanvasSurfaceNativeElement>(
                  target,
                  'CanvasSurfaceNativeElement',
                );
            t.notifyDependencyChanged();
            return null;
          },
    },
    constructorSignatures: {
      '': 'CanvasSurfaceNativeElement(Widget widget)',
    },
    methodSignatures: {
      'buildProps': 'ViewProps buildProps()',
      'mount': 'void mount(Element? parent, UIKitReconciler rec)',
      'update': 'void update(Widget newWidget)',
      'unmount': 'void unmount()',
      'emitMutation': 'void emitMutation(ViewMutation mutation)',
      'setSideSafeInset': 'void setSideSafeInset(double left, double right)',
      'rebuild': 'void rebuild()',
      'propsEqual': 'bool propsEqual(ViewProps? oldProps, ViewProps newProps)',
      'findRenderObject': 'RenderObject? findRenderObject()',
      'fillClaimUnder': 'int fillClaimUnder({required bool parentIsRow})',
      'addSubscription': 'void addSubscription(VoidCallback teardown)',
      'dependOnInheritedWidgetOfExactType':
          'T? dependOnInheritedWidgetOfExactType()',
      'getInheritedWidgetOfExactType': 'T? getInheritedWidgetOfExactType()',
      'visitChildElements':
          'void visitChildElements(void Function(BuildContext element) visitor)',
      'visitAncestorElements':
          'void visitAncestorElements(bool Function(BuildContext element) visitor)',
      'dispatchNotification':
          'void dispatchNotification(Notification notification)',
      'findAncestorWidgetOfExactType': 'T? findAncestorWidgetOfExactType()',
      'findAncestorStateOfType': 'T? findAncestorStateOfType()',
      'findRootAncestorStateOfType': 'T? findRootAncestorStateOfType()',
      'findAncestorRenderObjectOfType': 'T? findAncestorRenderObjectOfType()',
      'replaceChild': 'void replaceChild(Element oldChild, Element newChild)',
      'markDirty': 'void markDirty()',
      'notifyDependencyChanged': 'void notifyDependencyChanged()',
    },
    getterSignatures: {
      'viewType': 'int get viewType',
      'children': 'List<Element> get children',
      'stretchAsStackFlowChild': 'bool get stretchAsStackFlowChild',
      'isConstraintTransparent': 'bool get isConstraintTransparent',
      'keepsOwnSizeAtRoot': 'bool get keepsOwnSizeAtRoot',
      'widget': 'Widget get widget',
      'parent': 'Element? get parent',
      'isInsetSensitive': 'bool get isInsetSensitive',
      'viewId': 'int? get viewId',
      'reconciler': 'UIKitReconciler get reconciler',
      'size': 'Size? get size',
      'isScrollViewport': 'bool get isScrollViewport',
      'ownRenderObject': 'RenderObject? get ownRenderObject',
      'mounted': 'bool get mounted',
    },
  );
}

// =============================================================================
// Paint Bridge
// =============================================================================

BridgedClass _createPaintBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.Paint,
    name: 'Paint',
    isAssignable: (v) => v is $dartnative_6.Paint,
    constructors: {
      '': (visitor, positional, named) {
        final color = D4.getNamedArgWithDefault<$dartnative_3.Color>(
          named,
          'color',
          const $dartnative_3.Color(0xFF000000),
        );
        final style = D4.getNamedArgWithDefault<$dartnative_6.PaintingStyle>(
          named,
          'style',
          $dartnative_6.PaintingStyle.fill,
        );
        final strokeWidth = D4.getNamedArgWithDefault<double>(
          named,
          'strokeWidth',
          1.0,
        );
        final strokeCap = D4.getNamedArgWithDefault<$dartnative_6.StrokeCap>(
          named,
          'strokeCap',
          $dartnative_6.StrokeCap.butt,
        );
        final strokeJoin = D4.getNamedArgWithDefault<$dartnative_6.StrokeJoin>(
          named,
          'strokeJoin',
          $dartnative_6.StrokeJoin.miter,
        );
        final isAntiAlias = D4.getNamedArgWithDefault<bool>(
          named,
          'isAntiAlias',
          true,
        );
        final shader = D4.getOptionalNamedArg<$dartnative_6.Shader?>(
          named,
          'shader',
        );
        final blendMode = D4.getNamedArgWithDefault<$dartnative_6.BlendMode>(
          named,
          'blendMode',
          $dartnative_6.BlendMode.srcOver,
        );
        final maskFilter = D4.getOptionalNamedArg<$dartnative_6.MaskFilter?>(
          named,
          'maskFilter',
        );
        final imageFilter = D4.getOptionalNamedArg<$dartnative_6.ImageFilter?>(
          named,
          'imageFilter',
        );
        return $dartnative_6.Paint(
          color: color,
          style: style,
          strokeWidth: strokeWidth,
          strokeCap: strokeCap,
          strokeJoin: strokeJoin,
          isAntiAlias: isAntiAlias,
          shader: shader,
          blendMode: blendMode,
          maskFilter: maskFilter,
          imageFilter: imageFilter,
        );
      },
    },
    getters: {
      'color': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').color,
      'style': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').style,
      'strokeWidth': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').strokeWidth,
      'strokeCap': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').strokeCap,
      'strokeJoin': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').strokeJoin,
      'isAntiAlias': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').isAntiAlias,
      'shader': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').shader,
      'blendMode': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').blendMode,
      'maskFilter': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').maskFilter,
      'imageFilter': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').imageFilter,
    },
    setters: {
      'color': (visitor, target, value) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').color = D4
              .extractBridgedArg<$dartnative_3.Color>(value, 'color'),
      'style': (visitor, target, value) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').style = D4
              .extractBridgedArg<$dartnative_6.PaintingStyle>(value, 'style'),
      'strokeWidth': (visitor, target, value) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').strokeWidth =
              D4.extractBridgedArg<double>(value, 'strokeWidth'),
      'strokeCap': (visitor, target, value) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').strokeCap = D4
              .extractBridgedArg<$dartnative_6.StrokeCap>(value, 'strokeCap'),
      'strokeJoin': (visitor, target, value) =>
          D4
              .validateTarget<$dartnative_6.Paint>(target, 'Paint')
              .strokeJoin = D4.extractBridgedArg<$dartnative_6.StrokeJoin>(
            value,
            'strokeJoin',
          ),
      'isAntiAlias': (visitor, target, value) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').isAntiAlias =
              D4.extractBridgedArg<bool>(value, 'isAntiAlias'),
      'shader': (visitor, target, value) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').shader = D4
              .extractBridgedArgOrNull<$dartnative_6.Shader>(value, 'shader'),
      'blendMode': (visitor, target, value) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').blendMode = D4
              .extractBridgedArg<$dartnative_6.BlendMode>(value, 'blendMode'),
      'maskFilter': (visitor, target, value) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').maskFilter =
              D4.extractBridgedArgOrNull<$dartnative_6.MaskFilter>(
                value,
                'maskFilter',
              ),
      'imageFilter': (visitor, target, value) =>
          D4.validateTarget<$dartnative_6.Paint>(target, 'Paint').imageFilter =
              D4.extractBridgedArgOrNull<$dartnative_6.ImageFilter>(
                value,
                'imageFilter',
              ),
    },
    constructorSignatures: {
      '': 'Paint({Color color = const Color(0xFF000000), PaintingStyle style = PaintingStyle.fill, double strokeWidth = 1.0, StrokeCap strokeCap = StrokeCap.butt, StrokeJoin strokeJoin = StrokeJoin.miter, bool isAntiAlias = true, Shader? shader, BlendMode blendMode = BlendMode.srcOver, MaskFilter? maskFilter, ImageFilter? imageFilter})',
    },
    getterSignatures: {
      'color': 'Color get color',
      'style': 'PaintingStyle get style',
      'strokeWidth': 'double get strokeWidth',
      'strokeCap': 'StrokeCap get strokeCap',
      'strokeJoin': 'StrokeJoin get strokeJoin',
      'isAntiAlias': 'bool get isAntiAlias',
      'shader': 'Shader? get shader',
      'blendMode': 'BlendMode get blendMode',
      'maskFilter': 'MaskFilter? get maskFilter',
      'imageFilter': 'ImageFilter? get imageFilter',
    },
    setterSignatures: {
      'color': 'set color(dynamic value)',
      'style': 'set style(dynamic value)',
      'strokeWidth': 'set strokeWidth(dynamic value)',
      'strokeCap': 'set strokeCap(dynamic value)',
      'strokeJoin': 'set strokeJoin(dynamic value)',
      'isAntiAlias': 'set isAntiAlias(dynamic value)',
      'shader': 'set shader(dynamic value)',
      'blendMode': 'set blendMode(dynamic value)',
      'maskFilter': 'set maskFilter(dynamic value)',
      'imageFilter': 'set imageFilter(dynamic value)',
    },
  );
}

// =============================================================================
// Shader Bridge
// =============================================================================

BridgedClass _createShaderBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.Shader,
    name: 'Shader',
    isAssignable: (v) => v is $dartnative_6.Shader,
    isAbstract: true,
    constructors: {},
  );
}

// =============================================================================
// Gradient Bridge
// =============================================================================

BridgedClass _createGradientBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.Gradient,
    name: 'Gradient',
    isAssignable: (v) => v is $dartnative_6.Gradient,
    hierarchyDepth: 1,
    constructors: {
      'linear': (visitor, positional, named) {
        D4.requireMinArgs(positional, 3, 'Gradient');
        final from = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          0,
          'from',
          'Gradient',
        );
        final to = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          1,
          'to',
          'Gradient',
        );
        if (positional.length <= 2) {
          throw ArgumentError(
            'Gradient: Missing required argument "colors" at position 2',
          );
        }
        final colors = D4.coerceList<$dartnative_3.Color>(
          positional[2],
          'colors',
        );
        final colorStops = positional.length > 3
            ? D4.coerceListOrNull<double>(positional[3], 'colorStops')
            : null;
        final tileMode = D4.getOptionalArgWithDefault<$dartnative_6.TileMode>(
          positional,
          4,
          'tileMode',
          $dartnative_6.TileMode.clamp,
        );
        final matrix4 = positional.length > 5
            ? D4.coerceListOrNull<double>(positional[5], 'matrix4')
            : null;
        return $dartnative_6.Gradient.linear(
          from,
          to,
          colors,
          colorStops,
          tileMode,
          matrix4,
        );
      },
      'radial': (visitor, positional, named) {
        D4.requireMinArgs(positional, 3, 'Gradient');
        final center = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          0,
          'center',
          'Gradient',
        );
        final radius = D4.getRequiredArg<double>(
          positional,
          1,
          'radius',
          'Gradient',
        );
        if (positional.length <= 2) {
          throw ArgumentError(
            'Gradient: Missing required argument "colors" at position 2',
          );
        }
        final colors = D4.coerceList<$dartnative_3.Color>(
          positional[2],
          'colors',
        );
        final colorStops = positional.length > 3
            ? D4.coerceListOrNull<double>(positional[3], 'colorStops')
            : null;
        final tileMode = D4.getOptionalArgWithDefault<$dartnative_6.TileMode>(
          positional,
          4,
          'tileMode',
          $dartnative_6.TileMode.clamp,
        );
        final matrix4 = positional.length > 5
            ? D4.coerceListOrNull<double>(positional[5], 'matrix4')
            : null;
        final focal = D4.getOptionalArg<$dartnative_3.Offset?>(
          positional,
          6,
          'focal',
        );
        final focalRadius = D4.getOptionalArgWithDefault<double>(
          positional,
          7,
          'focalRadius',
          0.0,
        );
        return $dartnative_6.Gradient.radial(
          center,
          radius,
          colors,
          colorStops,
          tileMode,
          matrix4,
          focal,
          focalRadius,
        );
      },
    },
    getters: {
      'colors': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Gradient>(target, 'Gradient').colors,
      'colorStops': (visitor, target) => D4
          .validateTarget<$dartnative_6.Gradient>(target, 'Gradient')
          .colorStops,
      'tileMode': (visitor, target) => D4
          .validateTarget<$dartnative_6.Gradient>(target, 'Gradient')
          .tileMode,
      'isLinear': (visitor, target) => D4
          .validateTarget<$dartnative_6.Gradient>(target, 'Gradient')
          .isLinear,
      'isRadial': (visitor, target) => D4
          .validateTarget<$dartnative_6.Gradient>(target, 'Gradient')
          .isRadial,
      'linearFrom': (visitor, target) => D4
          .validateTarget<$dartnative_6.Gradient>(target, 'Gradient')
          .linearFrom,
      'linearTo': (visitor, target) => D4
          .validateTarget<$dartnative_6.Gradient>(target, 'Gradient')
          .linearTo,
      'radialCenter': (visitor, target) => D4
          .validateTarget<$dartnative_6.Gradient>(target, 'Gradient')
          .radialCenter,
      'radialRadius': (visitor, target) => D4
          .validateTarget<$dartnative_6.Gradient>(target, 'Gradient')
          .radialRadius,
    },
    constructorSignatures: {
      'linear':
          'factory Gradient.linear(Offset from, Offset to, List<Color> colors, [List<double>? colorStops, TileMode tileMode = TileMode.clamp, List<double>? matrix4])',
      'radial':
          'factory Gradient.radial(Offset center, double radius, List<Color> colors, [List<double>? colorStops, TileMode tileMode = TileMode.clamp, List<double>? matrix4, Offset? focal, double focalRadius = 0.0])',
    },
    getterSignatures: {
      'colors': 'List<Color> get colors',
      'colorStops': 'List<double>? get colorStops',
      'tileMode': 'TileMode get tileMode',
      'isLinear': 'bool get isLinear',
      'isRadial': 'bool get isRadial',
      'linearFrom': 'Offset get linearFrom',
      'linearTo': 'Offset get linearTo',
      'radialCenter': 'Offset get radialCenter',
      'radialRadius': 'double get radialRadius',
    },
  );
}

// =============================================================================
// MaskFilter Bridge
// =============================================================================

BridgedClass _createMaskFilterBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.MaskFilter,
    name: 'MaskFilter',
    isAssignable: (v) => v is $dartnative_6.MaskFilter,
    constructors: {
      'blur': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'MaskFilter');
        final p = D4.getRequiredArg<$dartnative_6.MaskFilterBlurStyle>(
          positional,
          0,
          '_',
          'MaskFilter',
        );
        final sigma = D4.getRequiredArg<double>(
          positional,
          1,
          'sigma',
          'MaskFilter',
        );
        return $dartnative_6.MaskFilter.blur(p, sigma);
      },
    },
    getters: {
      'sigma': (visitor, target) => D4
          .validateTarget<$dartnative_6.MaskFilter>(target, 'MaskFilter')
          .sigma,
    },
    constructorSignatures: {
      'blur': 'const MaskFilter.blur(MaskFilterBlurStyle _, double sigma)',
    },
    getterSignatures: {
      'sigma': 'double get sigma',
    },
  );
}

// =============================================================================
// ImageFilter Bridge
// =============================================================================

BridgedClass _createImageFilterBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.ImageFilter,
    name: 'ImageFilter',
    isAssignable: (v) => v is $dartnative_6.ImageFilter,
    constructors: {
      'blur': (visitor, positional, named) {
        final sigmaX = D4.getRequiredNamedArg<double>(
          named,
          'sigmaX',
          'ImageFilter',
        );
        final sigmaY = D4.getRequiredNamedArg<double>(
          named,
          'sigmaY',
          'ImageFilter',
        );
        return $dartnative_6.ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY);
      },
    },
    constructorSignatures: {
      'blur':
          'const factory ImageFilter.blur({required double sigmaX, required double sigmaY})',
    },
  );
}

// =============================================================================
// BlurImageFilter Bridge
// =============================================================================

BridgedClass _createBlurImageFilterBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.BlurImageFilter,
    name: 'BlurImageFilter',
    isAssignable: (v) => v is $dartnative_6.BlurImageFilter,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final sigmaX = D4.getRequiredNamedArg<double>(
          named,
          'sigmaX',
          'BlurImageFilter',
        );
        final sigmaY = D4.getRequiredNamedArg<double>(
          named,
          'sigmaY',
          'BlurImageFilter',
        );
        return $dartnative_6.BlurImageFilter(sigmaX: sigmaX, sigmaY: sigmaY);
      },
    },
    getters: {
      'sigmaX': (visitor, target) => D4
          .validateTarget<$dartnative_6.BlurImageFilter>(
            target,
            'BlurImageFilter',
          )
          .sigmaX,
      'sigmaY': (visitor, target) => D4
          .validateTarget<$dartnative_6.BlurImageFilter>(
            target,
            'BlurImageFilter',
          )
          .sigmaY,
    },
    constructorSignatures: {
      '': 'const BlurImageFilter({required double sigmaX, required double sigmaY})',
    },
    getterSignatures: {
      'sigmaX': 'double get sigmaX',
      'sigmaY': 'double get sigmaY',
    },
  );
}

// =============================================================================
// RRect Bridge
// =============================================================================

BridgedClass _createRRectBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.RRect,
    name: 'RRect',
    isAssignable: (v) => v is $dartnative_6.RRect,
    constructors: {
      'fromRectAndRadius': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'RRect');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'RRect',
        );
        final radius = D4.getRequiredArg<double>(
          positional,
          1,
          'radius',
          'RRect',
        );
        return $dartnative_6.RRect.fromRectAndRadius(rect, radius);
      },
      'fromLTRBAndCornerRadii': (visitor, positional, named) {
        D4.requireMinArgs(positional, 4, 'RRect');
        final left = D4.getRequiredArg<double>(positional, 0, 'left', 'RRect');
        final top = D4.getRequiredArg<double>(positional, 1, 'top', 'RRect');
        final right = D4.getRequiredArg<double>(
          positional,
          2,
          'right',
          'RRect',
        );
        final bottom = D4.getRequiredArg<double>(
          positional,
          3,
          'bottom',
          'RRect',
        );
        final tlRadius = D4.getNamedArgWithDefault<double>(
          named,
          'tlRadius',
          0,
        );
        final trRadius = D4.getNamedArgWithDefault<double>(
          named,
          'trRadius',
          0,
        );
        final brRadius = D4.getNamedArgWithDefault<double>(
          named,
          'brRadius',
          0,
        );
        final blRadius = D4.getNamedArgWithDefault<double>(
          named,
          'blRadius',
          0,
        );
        return $dartnative_6.RRect.fromLTRBAndCornerRadii(
          left,
          top,
          right,
          bottom,
          tlRadius: tlRadius,
          trRadius: trRadius,
          brRadius: brRadius,
          blRadius: blRadius,
        );
      },
    },
    getters: {
      'rect': (visitor, target) =>
          D4.validateTarget<$dartnative_6.RRect>(target, 'RRect').rect,
      'tlRadius': (visitor, target) =>
          D4.validateTarget<$dartnative_6.RRect>(target, 'RRect').tlRadius,
      'trRadius': (visitor, target) =>
          D4.validateTarget<$dartnative_6.RRect>(target, 'RRect').trRadius,
      'brRadius': (visitor, target) =>
          D4.validateTarget<$dartnative_6.RRect>(target, 'RRect').brRadius,
      'blRadius': (visitor, target) =>
          D4.validateTarget<$dartnative_6.RRect>(target, 'RRect').blRadius,
    },
    constructorSignatures: {
      'fromRectAndRadius':
          'const RRect.fromRectAndRadius(Rect rect, double radius)',
      'fromLTRBAndCornerRadii':
          'RRect.fromLTRBAndCornerRadii(double left, double top, double right, double bottom, {double tlRadius = 0, double trRadius = 0, double brRadius = 0, double blRadius = 0})',
    },
    getterSignatures: {
      'rect': 'Rect get rect',
      'tlRadius': 'double get tlRadius',
      'trRadius': 'double get trRadius',
      'brRadius': 'double get brRadius',
      'blRadius': 'double get blRadius',
    },
  );
}

// =============================================================================
// Path Bridge
// =============================================================================

BridgedClass _createPathBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.Path,
    name: 'Path',
    isAssignable: (v) => v is $dartnative_6.Path,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_6.Path();
      },
    },
    getters: {
      'operations': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Path>(target, 'Path').operations,
    },
    methods: {
      'moveTo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Path>(target, 'Path');
        D4.requireMinArgs(positional, 2, 'moveTo');
        final x = D4.getRequiredArg<double>(positional, 0, 'x', 'moveTo');
        final y = D4.getRequiredArg<double>(positional, 1, 'y', 'moveTo');
        t.moveTo(x, y);
        return null;
      },
      'lineTo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Path>(target, 'Path');
        D4.requireMinArgs(positional, 2, 'lineTo');
        final x = D4.getRequiredArg<double>(positional, 0, 'x', 'lineTo');
        final y = D4.getRequiredArg<double>(positional, 1, 'y', 'lineTo');
        t.lineTo(x, y);
        return null;
      },
      'cubicTo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Path>(target, 'Path');
        D4.requireMinArgs(positional, 6, 'cubicTo');
        final x1 = D4.getRequiredArg<double>(positional, 0, 'x1', 'cubicTo');
        final y1 = D4.getRequiredArg<double>(positional, 1, 'y1', 'cubicTo');
        final x2 = D4.getRequiredArg<double>(positional, 2, 'x2', 'cubicTo');
        final y2 = D4.getRequiredArg<double>(positional, 3, 'y2', 'cubicTo');
        final x3 = D4.getRequiredArg<double>(positional, 4, 'x3', 'cubicTo');
        final y3 = D4.getRequiredArg<double>(positional, 5, 'y3', 'cubicTo');
        t.cubicTo(x1, y1, x2, y2, x3, y3);
        return null;
      },
      'arcTo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Path>(target, 'Path');
        D4.requireMinArgs(positional, 4, 'arcTo');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'arcTo',
        );
        final startAngle = D4.getRequiredArg<double>(
          positional,
          1,
          'startAngle',
          'arcTo',
        );
        final sweepAngle = D4.getRequiredArg<double>(
          positional,
          2,
          'sweepAngle',
          'arcTo',
        );
        final forceMoveTo = D4.getRequiredArg<bool>(
          positional,
          3,
          'forceMoveTo',
          'arcTo',
        );
        t.arcTo(rect, startAngle, sweepAngle, forceMoveTo);
        return null;
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Path>(target, 'Path');
        t.close();
        return null;
      },
      'addOval': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Path>(target, 'Path');
        D4.requireMinArgs(positional, 1, 'addOval');
        final oval = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'oval',
          'addOval',
        );
        t.addOval(oval);
        return null;
      },
      'addRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Path>(target, 'Path');
        D4.requireMinArgs(positional, 1, 'addRect');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'addRect',
        );
        t.addRect(rect);
        return null;
      },
      'addRRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Path>(target, 'Path');
        D4.requireMinArgs(positional, 1, 'addRRect');
        final rrect = D4.getRequiredArg<$dartnative_6.RRect>(
          positional,
          0,
          'rrect',
          'addRRect',
        );
        t.addRRect(rrect);
        return null;
      },
    },
    constructorSignatures: {
      '': 'Path()',
    },
    methodSignatures: {
      'moveTo': 'void moveTo(double x, double y)',
      'lineTo': 'void lineTo(double x, double y)',
      'cubicTo':
          'void cubicTo(double x1, double y1, double x2, double y2, double x3, double y3)',
      'arcTo':
          'void arcTo(Rect rect, double startAngle, double sweepAngle, bool forceMoveTo)',
      'close': 'void close()',
      'addOval': 'void addOval(Rect oval)',
      'addRect': 'void addRect(Rect rect)',
      'addRRect': 'void addRRect(RRect rrect)',
    },
    getterSignatures: {
      'operations': 'List<PathOperation> get operations',
    },
  );
}

// =============================================================================
// PathOperation Bridge
// =============================================================================

BridgedClass _createPathOperationBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.PathOperation,
    name: 'PathOperation',
    isAssignable: (v) => v is $dartnative_6.PathOperation,
    constructors: {},
  );
}

// =============================================================================
// PathMoveTo Bridge
// =============================================================================

BridgedClass _createPathMoveToBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.PathMoveTo,
    name: 'PathMoveTo',
    isAssignable: (v) => v is $dartnative_6.PathMoveTo,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'PathMoveTo');
        final x = D4.getRequiredArg<double>(positional, 0, 'x', 'PathMoveTo');
        final y = D4.getRequiredArg<double>(positional, 1, 'y', 'PathMoveTo');
        return $dartnative_6.PathMoveTo(x, y);
      },
    },
    getters: {
      'x': (visitor, target) =>
          D4.validateTarget<$dartnative_6.PathMoveTo>(target, 'PathMoveTo').x,
      'y': (visitor, target) =>
          D4.validateTarget<$dartnative_6.PathMoveTo>(target, 'PathMoveTo').y,
    },
    constructorSignatures: {
      '': 'const PathMoveTo(double x, double y)',
    },
    getterSignatures: {
      'x': 'double get x',
      'y': 'double get y',
    },
  );
}

// =============================================================================
// PathLineTo Bridge
// =============================================================================

BridgedClass _createPathLineToBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.PathLineTo,
    name: 'PathLineTo',
    isAssignable: (v) => v is $dartnative_6.PathLineTo,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'PathLineTo');
        final x = D4.getRequiredArg<double>(positional, 0, 'x', 'PathLineTo');
        final y = D4.getRequiredArg<double>(positional, 1, 'y', 'PathLineTo');
        return $dartnative_6.PathLineTo(x, y);
      },
    },
    getters: {
      'x': (visitor, target) =>
          D4.validateTarget<$dartnative_6.PathLineTo>(target, 'PathLineTo').x,
      'y': (visitor, target) =>
          D4.validateTarget<$dartnative_6.PathLineTo>(target, 'PathLineTo').y,
    },
    constructorSignatures: {
      '': 'const PathLineTo(double x, double y)',
    },
    getterSignatures: {
      'x': 'double get x',
      'y': 'double get y',
    },
  );
}

// =============================================================================
// PathCubicTo Bridge
// =============================================================================

BridgedClass _createPathCubicToBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.PathCubicTo,
    name: 'PathCubicTo',
    isAssignable: (v) => v is $dartnative_6.PathCubicTo,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 6, 'PathCubicTo');
        final x1 = D4.getRequiredArg<double>(
          positional,
          0,
          'x1',
          'PathCubicTo',
        );
        final y1 = D4.getRequiredArg<double>(
          positional,
          1,
          'y1',
          'PathCubicTo',
        );
        final x2 = D4.getRequiredArg<double>(
          positional,
          2,
          'x2',
          'PathCubicTo',
        );
        final y2 = D4.getRequiredArg<double>(
          positional,
          3,
          'y2',
          'PathCubicTo',
        );
        final x3 = D4.getRequiredArg<double>(
          positional,
          4,
          'x3',
          'PathCubicTo',
        );
        final y3 = D4.getRequiredArg<double>(
          positional,
          5,
          'y3',
          'PathCubicTo',
        );
        return $dartnative_6.PathCubicTo(x1, y1, x2, y2, x3, y3);
      },
    },
    getters: {
      'x1': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathCubicTo>(target, 'PathCubicTo')
          .x1,
      'y1': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathCubicTo>(target, 'PathCubicTo')
          .y1,
      'x2': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathCubicTo>(target, 'PathCubicTo')
          .x2,
      'y2': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathCubicTo>(target, 'PathCubicTo')
          .y2,
      'x3': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathCubicTo>(target, 'PathCubicTo')
          .x3,
      'y3': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathCubicTo>(target, 'PathCubicTo')
          .y3,
    },
    constructorSignatures: {
      '': 'const PathCubicTo(double x1, double y1, double x2, double y2, double x3, double y3)',
    },
    getterSignatures: {
      'x1': 'double get x1',
      'y1': 'double get y1',
      'x2': 'double get x2',
      'y2': 'double get y2',
      'x3': 'double get x3',
      'y3': 'double get y3',
    },
  );
}

// =============================================================================
// PathArcTo Bridge
// =============================================================================

BridgedClass _createPathArcToBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.PathArcTo,
    name: 'PathArcTo',
    isAssignable: (v) => v is $dartnative_6.PathArcTo,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 4, 'PathArcTo');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'PathArcTo',
        );
        final startAngle = D4.getRequiredArg<double>(
          positional,
          1,
          'startAngle',
          'PathArcTo',
        );
        final sweepAngle = D4.getRequiredArg<double>(
          positional,
          2,
          'sweepAngle',
          'PathArcTo',
        );
        final forceMoveTo = D4.getRequiredArg<bool>(
          positional,
          3,
          'forceMoveTo',
          'PathArcTo',
        );
        return $dartnative_6.PathArcTo(
          rect,
          startAngle,
          sweepAngle,
          forceMoveTo,
        );
      },
    },
    getters: {
      'rect': (visitor, target) =>
          D4.validateTarget<$dartnative_6.PathArcTo>(target, 'PathArcTo').rect,
      'startAngle': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathArcTo>(target, 'PathArcTo')
          .startAngle,
      'sweepAngle': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathArcTo>(target, 'PathArcTo')
          .sweepAngle,
      'forceMoveTo': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathArcTo>(target, 'PathArcTo')
          .forceMoveTo,
    },
    constructorSignatures: {
      '': 'const PathArcTo(Rect rect, double startAngle, double sweepAngle, bool forceMoveTo)',
    },
    getterSignatures: {
      'rect': 'Rect get rect',
      'startAngle': 'double get startAngle',
      'sweepAngle': 'double get sweepAngle',
      'forceMoveTo': 'bool get forceMoveTo',
    },
  );
}

// =============================================================================
// PathClose Bridge
// =============================================================================

BridgedClass _createPathCloseBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.PathClose,
    name: 'PathClose',
    isAssignable: (v) => v is $dartnative_6.PathClose,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_6.PathClose();
      },
    },
    constructorSignatures: {
      '': 'const PathClose()',
    },
  );
}

// =============================================================================
// PathAddOval Bridge
// =============================================================================

BridgedClass _createPathAddOvalBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.PathAddOval,
    name: 'PathAddOval',
    isAssignable: (v) => v is $dartnative_6.PathAddOval,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'PathAddOval');
        final oval = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'oval',
          'PathAddOval',
        );
        return $dartnative_6.PathAddOval(oval);
      },
    },
    getters: {
      'oval': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathAddOval>(target, 'PathAddOval')
          .oval,
    },
    constructorSignatures: {
      '': 'const PathAddOval(Rect oval)',
    },
    getterSignatures: {
      'oval': 'Rect get oval',
    },
  );
}

// =============================================================================
// PathAddRect Bridge
// =============================================================================

BridgedClass _createPathAddRectBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.PathAddRect,
    name: 'PathAddRect',
    isAssignable: (v) => v is $dartnative_6.PathAddRect,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'PathAddRect');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'PathAddRect',
        );
        return $dartnative_6.PathAddRect(rect);
      },
    },
    getters: {
      'rect': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathAddRect>(target, 'PathAddRect')
          .rect,
    },
    constructorSignatures: {
      '': 'const PathAddRect(Rect rect)',
    },
    getterSignatures: {
      'rect': 'Rect get rect',
    },
  );
}

// =============================================================================
// PathAddRRect Bridge
// =============================================================================

BridgedClass _createPathAddRRectBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.PathAddRRect,
    name: 'PathAddRRect',
    isAssignable: (v) => v is $dartnative_6.PathAddRRect,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'PathAddRRect');
        final rrect = D4.getRequiredArg<$dartnative_6.RRect>(
          positional,
          0,
          'rrect',
          'PathAddRRect',
        );
        return $dartnative_6.PathAddRRect(rrect);
      },
    },
    getters: {
      'rrect': (visitor, target) => D4
          .validateTarget<$dartnative_6.PathAddRRect>(target, 'PathAddRRect')
          .rrect,
    },
    constructorSignatures: {
      '': 'const PathAddRRect(RRect rrect)',
    },
    getterSignatures: {
      'rrect': 'RRect get rrect',
    },
  );
}

// =============================================================================
// CanvasImage Bridge
// =============================================================================

BridgedClass _createCanvasImageBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.CanvasImage,
    name: 'CanvasImage',
    isAssignable: (v) => v is $dartnative_6.CanvasImage,
    isAbstract: true,
    constructors: {
      'network': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'CanvasImage');
        final url = D4.getRequiredArg<String>(
          positional,
          0,
          'url',
          'CanvasImage',
        );
        final width = D4.getNamedArgWithDefault<int>(named, 'width', 0);
        final height = D4.getNamedArgWithDefault<int>(named, 'height', 0);
        return $dartnative_6.CanvasImage.network(
          url,
          width: width,
          height: height,
        );
      },
      'asset': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'CanvasImage');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'CanvasImage',
        );
        final width = D4.getNamedArgWithDefault<int>(named, 'width', 0);
        final height = D4.getNamedArgWithDefault<int>(named, 'height', 0);
        return $dartnative_6.CanvasImage.asset(
          name,
          width: width,
          height: height,
        );
      },
    },
    getters: {
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_6.CanvasImage>(target, 'CanvasImage')
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_6.CanvasImage>(target, 'CanvasImage')
          .height,
      'cacheKey': (visitor, target) => D4
          .validateTarget<$dartnative_6.CanvasImage>(target, 'CanvasImage')
          .cacheKey,
    },
    methods: {
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.CanvasImage>(
          target,
          'CanvasImage',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    constructorSignatures: {
      'network':
          'factory CanvasImage.network(String url, {int width = 0, int height = 0})',
      'asset':
          'factory CanvasImage.asset(String name, {int width = 0, int height = 0})',
    },
    methodSignatures: {
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'width': 'int get width',
      'height': 'int get height',
      'cacheKey': 'String get cacheKey',
    },
  );
}

// =============================================================================
// NetworkCanvasImage Bridge
// =============================================================================

BridgedClass _createNetworkCanvasImageBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.NetworkCanvasImage,
    name: 'NetworkCanvasImage',
    isAssignable: (v) => v is $dartnative_6.NetworkCanvasImage,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final cacheKey = D4.getRequiredNamedArg<String>(
          named,
          'cacheKey',
          'NetworkCanvasImage',
        );
        final width = D4.getNamedArgWithDefault<int>(named, 'width', 0);
        final height = D4.getNamedArgWithDefault<int>(named, 'height', 0);
        return $dartnative_6.NetworkCanvasImage(
          cacheKey: cacheKey,
          width: width,
          height: height,
        );
      },
    },
    getters: {
      'cacheKey': (visitor, target) => D4
          .validateTarget<$dartnative_6.NetworkCanvasImage>(
            target,
            'NetworkCanvasImage',
          )
          .cacheKey,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_6.NetworkCanvasImage>(
            target,
            'NetworkCanvasImage',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_6.NetworkCanvasImage>(
            target,
            'NetworkCanvasImage',
          )
          .height,
    },
    methods: {
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.NetworkCanvasImage>(
          target,
          'NetworkCanvasImage',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    constructorSignatures: {
      '': 'const NetworkCanvasImage({required String cacheKey, int width = 0, int height = 0})',
    },
    methodSignatures: {
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'cacheKey': 'String get cacheKey',
      'width': 'int get width',
      'height': 'int get height',
    },
  );
}

// =============================================================================
// Paragraph Bridge
// =============================================================================

BridgedClass _createParagraphBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.Paragraph,
    name: 'Paragraph',
    isAssignable: (v) => v is $dartnative_6.Paragraph,
    isAbstract: true,
    constructors: {},
    getters: {
      'width': (visitor, target) =>
          D4.validateTarget<$dartnative_6.Paragraph>(target, 'Paragraph').width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_6.Paragraph>(target, 'Paragraph')
          .height,
      'longestLine': (visitor, target) => D4
          .validateTarget<$dartnative_6.Paragraph>(target, 'Paragraph')
          .longestLine,
      'lineCount': (visitor, target) => D4
          .validateTarget<$dartnative_6.Paragraph>(target, 'Paragraph')
          .lineCount,
      'didExceedMaxLines': (visitor, target) => D4
          .validateTarget<$dartnative_6.Paragraph>(target, 'Paragraph')
          .didExceedMaxLines,
      'minIntrinsicWidth': (visitor, target) => D4
          .validateTarget<$dartnative_6.Paragraph>(target, 'Paragraph')
          .minIntrinsicWidth,
      'maxIntrinsicWidth': (visitor, target) => D4
          .validateTarget<$dartnative_6.Paragraph>(target, 'Paragraph')
          .maxIntrinsicWidth,
      'alphabeticBaseline': (visitor, target) => D4
          .validateTarget<$dartnative_6.Paragraph>(target, 'Paragraph')
          .alphabeticBaseline,
      'ideographicBaseline': (visitor, target) => D4
          .validateTarget<$dartnative_6.Paragraph>(target, 'Paragraph')
          .ideographicBaseline,
    },
    methods: {
      'layout': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Paragraph>(
          target,
          'Paragraph',
        );
        D4.requireMinArgs(positional, 1, 'layout');
        final constraints = D4
            .getRequiredArg<$dartnative_6.ParagraphConstraints>(
              positional,
              0,
              'constraints',
              'layout',
            );
        t.layout(constraints);
        return null;
      },
      'getLineMetrics': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Paragraph>(
          target,
          'Paragraph',
        );
        return t.getLineMetrics();
      },
      'getBoxesForRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Paragraph>(
          target,
          'Paragraph',
        );
        D4.requireMinArgs(positional, 2, 'getBoxesForRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'getBoxesForRange',
        );
        final end = D4.getRequiredArg<int>(
          positional,
          1,
          'end',
          'getBoxesForRange',
        );
        final boxHeightStyle = D4.getNamedArgWithDefault<int>(
          named,
          'boxHeightStyle',
          0,
        );
        final boxWidthStyle = D4.getNamedArgWithDefault<int>(
          named,
          'boxWidthStyle',
          0,
        );
        return t.getBoxesForRange(
          start,
          end,
          boxHeightStyle: boxHeightStyle,
          boxWidthStyle: boxWidthStyle,
        );
      },
      'getPositionForOffset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Paragraph>(
          target,
          'Paragraph',
        );
        D4.requireMinArgs(positional, 1, 'getPositionForOffset');
        final offset = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          0,
          'offset',
          'getPositionForOffset',
        );
        return t.getPositionForOffset(offset);
      },
    },
    methodSignatures: {
      'layout': 'void layout(ParagraphConstraints constraints)',
      'getLineMetrics': 'List<LineMetrics> getLineMetrics()',
      'getBoxesForRange':
          'List<TextBox> getBoxesForRange(int start, int end, {int boxHeightStyle = 0, int boxWidthStyle = 0})',
      'getPositionForOffset':
          'TextPosition getPositionForOffset(Offset offset)',
    },
    getterSignatures: {
      'width': 'double get width',
      'height': 'double get height',
      'longestLine': 'double get longestLine',
      'lineCount': 'int get lineCount',
      'didExceedMaxLines': 'bool get didExceedMaxLines',
      'minIntrinsicWidth': 'double get minIntrinsicWidth',
      'maxIntrinsicWidth': 'double get maxIntrinsicWidth',
      'alphabeticBaseline': 'double get alphabeticBaseline',
      'ideographicBaseline': 'double get ideographicBaseline',
    },
  );
}

// =============================================================================
// ParagraphConstraints Bridge
// =============================================================================

BridgedClass _createParagraphConstraintsBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.ParagraphConstraints,
    name: 'ParagraphConstraints',
    isAssignable: (v) => v is $dartnative_6.ParagraphConstraints,
    constructors: {
      '': (visitor, positional, named) {
        final width = D4.getRequiredNamedArg<double>(
          named,
          'width',
          'ParagraphConstraints',
        );
        return $dartnative_6.ParagraphConstraints(width: width);
      },
    },
    getters: {
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphConstraints>(
            target,
            'ParagraphConstraints',
          )
          .width,
    },
    constructorSignatures: {
      '': 'const ParagraphConstraints({required double width})',
    },
    getterSignatures: {
      'width': 'double get width',
    },
  );
}

// =============================================================================
// LineMetrics Bridge
// =============================================================================

BridgedClass _createLineMetricsBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.LineMetrics,
    name: 'LineMetrics',
    isAssignable: (v) => v is $dartnative_6.LineMetrics,
    constructors: {
      '': (visitor, positional, named) {
        final hardBreak = D4.getRequiredNamedArg<bool>(
          named,
          'hardBreak',
          'LineMetrics',
        );
        final ascent = D4.getRequiredNamedArg<double>(
          named,
          'ascent',
          'LineMetrics',
        );
        final descent = D4.getRequiredNamedArg<double>(
          named,
          'descent',
          'LineMetrics',
        );
        final unscaledAscent = D4.getRequiredNamedArg<double>(
          named,
          'unscaledAscent',
          'LineMetrics',
        );
        final height = D4.getRequiredNamedArg<double>(
          named,
          'height',
          'LineMetrics',
        );
        final width = D4.getRequiredNamedArg<double>(
          named,
          'width',
          'LineMetrics',
        );
        final left = D4.getRequiredNamedArg<double>(
          named,
          'left',
          'LineMetrics',
        );
        final baseline = D4.getRequiredNamedArg<double>(
          named,
          'baseline',
          'LineMetrics',
        );
        final lineNumber = D4.getRequiredNamedArg<int>(
          named,
          'lineNumber',
          'LineMetrics',
        );
        return $dartnative_6.LineMetrics(
          hardBreak: hardBreak,
          ascent: ascent,
          descent: descent,
          unscaledAscent: unscaledAscent,
          height: height,
          width: width,
          left: left,
          baseline: baseline,
          lineNumber: lineNumber,
        );
      },
    },
    getters: {
      'hardBreak': (visitor, target) => D4
          .validateTarget<$dartnative_6.LineMetrics>(target, 'LineMetrics')
          .hardBreak,
      'ascent': (visitor, target) => D4
          .validateTarget<$dartnative_6.LineMetrics>(target, 'LineMetrics')
          .ascent,
      'descent': (visitor, target) => D4
          .validateTarget<$dartnative_6.LineMetrics>(target, 'LineMetrics')
          .descent,
      'unscaledAscent': (visitor, target) => D4
          .validateTarget<$dartnative_6.LineMetrics>(target, 'LineMetrics')
          .unscaledAscent,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_6.LineMetrics>(target, 'LineMetrics')
          .height,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_6.LineMetrics>(target, 'LineMetrics')
          .width,
      'left': (visitor, target) => D4
          .validateTarget<$dartnative_6.LineMetrics>(target, 'LineMetrics')
          .left,
      'baseline': (visitor, target) => D4
          .validateTarget<$dartnative_6.LineMetrics>(target, 'LineMetrics')
          .baseline,
      'lineNumber': (visitor, target) => D4
          .validateTarget<$dartnative_6.LineMetrics>(target, 'LineMetrics')
          .lineNumber,
    },
    staticGetters: {
      'wireFloatsPerLine': (visitor) =>
          $dartnative_6.LineMetrics.wireFloatsPerLine,
    },
    constructorSignatures: {
      '': 'const LineMetrics({required bool hardBreak, required double ascent, required double descent, required double unscaledAscent, required double height, required double width, required double left, required double baseline, required int lineNumber})',
    },
    getterSignatures: {
      'hardBreak': 'bool get hardBreak',
      'ascent': 'double get ascent',
      'descent': 'double get descent',
      'unscaledAscent': 'double get unscaledAscent',
      'height': 'double get height',
      'width': 'double get width',
      'left': 'double get left',
      'baseline': 'double get baseline',
      'lineNumber': 'int get lineNumber',
    },
    staticGetterSignatures: {
      'wireFloatsPerLine': 'int get wireFloatsPerLine',
    },
  );
}

// =============================================================================
// TextBox Bridge
// =============================================================================

BridgedClass _createTextBoxBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.TextBox,
    name: 'TextBox',
    isAssignable: (v) => v is $dartnative_6.TextBox,
    constructors: {
      'fromLTRBD': (visitor, positional, named) {
        D4.requireMinArgs(positional, 5, 'TextBox');
        final left = D4.getRequiredArg<double>(
          positional,
          0,
          'left',
          'TextBox',
        );
        final top = D4.getRequiredArg<double>(positional, 1, 'top', 'TextBox');
        final right = D4.getRequiredArg<double>(
          positional,
          2,
          'right',
          'TextBox',
        );
        final bottom = D4.getRequiredArg<double>(
          positional,
          3,
          'bottom',
          'TextBox',
        );
        final direction = D4.getRequiredArg<$dartnative_3.TextDirection>(
          positional,
          4,
          'direction',
          'TextBox',
        );
        return $dartnative_6.TextBox.fromLTRBD(
          left,
          top,
          right,
          bottom,
          direction,
        );
      },
    },
    getters: {
      'left': (visitor, target) =>
          D4.validateTarget<$dartnative_6.TextBox>(target, 'TextBox').left,
      'top': (visitor, target) =>
          D4.validateTarget<$dartnative_6.TextBox>(target, 'TextBox').top,
      'right': (visitor, target) =>
          D4.validateTarget<$dartnative_6.TextBox>(target, 'TextBox').right,
      'bottom': (visitor, target) =>
          D4.validateTarget<$dartnative_6.TextBox>(target, 'TextBox').bottom,
      'direction': (visitor, target) =>
          D4.validateTarget<$dartnative_6.TextBox>(target, 'TextBox').direction,
      'width': (visitor, target) =>
          D4.validateTarget<$dartnative_6.TextBox>(target, 'TextBox').width,
      'height': (visitor, target) =>
          D4.validateTarget<$dartnative_6.TextBox>(target, 'TextBox').height,
    },
    methods: {
      'toRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.TextBox>(target, 'TextBox');
        return t.toRect();
      },
    },
    staticGetters: {
      'wireFloatsPerBox': (visitor) => $dartnative_6.TextBox.wireFloatsPerBox,
    },
    constructorSignatures: {
      'fromLTRBD':
          'const TextBox.fromLTRBD(double left, double top, double right, double bottom, TextDirection direction)',
    },
    methodSignatures: {
      'toRect': 'Rect toRect()',
    },
    getterSignatures: {
      'left': 'double get left',
      'top': 'double get top',
      'right': 'double get right',
      'bottom': 'double get bottom',
      'direction': 'TextDirection get direction',
      'width': 'double get width',
      'height': 'double get height',
    },
    staticGetterSignatures: {
      'wireFloatsPerBox': 'int get wireFloatsPerBox',
    },
  );
}

// =============================================================================
// ParagraphStyle Bridge
// =============================================================================

BridgedClass _createParagraphStyleBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.ParagraphStyle,
    name: 'ParagraphStyle',
    isAssignable: (v) => v is $dartnative_6.ParagraphStyle,
    constructors: {
      '': (visitor, positional, named) {
        final textAlign = D4.getOptionalNamedArg<$dartnative_3.TextAlign?>(
          named,
          'textAlign',
        );
        final textDirection = D4
            .getOptionalNamedArg<$dartnative_3.TextDirection?>(
              named,
              'textDirection',
            );
        final fontFamily = D4.getOptionalNamedArg<String?>(named, 'fontFamily');
        final fontSize = D4.getOptionalNamedArg<double?>(named, 'fontSize');
        final fontWeight = D4.getOptionalNamedArg<$dartnative_3.FontWeight?>(
          named,
          'fontWeight',
        );
        final fontStyle = D4.getOptionalNamedArg<$dartnative_3.FontStyle?>(
          named,
          'fontStyle',
        );
        final maxLines = D4.getOptionalNamedArg<int?>(named, 'maxLines');
        final ellipsis = D4.getOptionalNamedArg<String?>(named, 'ellipsis');
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final locale = D4.getOptionalNamedArg<String?>(named, 'locale');
        final strutStyle = D4.getOptionalNamedArg<$dartnative_2.StrutStyle?>(
          named,
          'strutStyle',
        );
        final leadingDistribution = D4
            .getOptionalNamedArg<$dartnative_3.TextLeadingDistribution?>(
              named,
              'leadingDistribution',
            );
        return $dartnative_6.ParagraphStyle(
          textAlign: textAlign,
          textDirection: textDirection,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          maxLines: maxLines,
          ellipsis: ellipsis,
          height: height,
          locale: locale,
          strutStyle: strutStyle,
          leadingDistribution: leadingDistribution,
        );
      },
    },
    getters: {
      'textAlign': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .textAlign,
      'textDirection': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .textDirection,
      'fontFamily': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .fontFamily,
      'fontSize': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .fontSize,
      'fontWeight': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .fontWeight,
      'fontStyle': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .fontStyle,
      'maxLines': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .maxLines,
      'ellipsis': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .ellipsis,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .height,
      'locale': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .locale,
      'strutStyle': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .strutStyle,
      'leadingDistribution': (visitor, target) => D4
          .validateTarget<$dartnative_6.ParagraphStyle>(
            target,
            'ParagraphStyle',
          )
          .leadingDistribution,
    },
    constructorSignatures: {
      '': 'const ParagraphStyle({TextAlign? textAlign, TextDirection? textDirection, String? fontFamily, double? fontSize, FontWeight? fontWeight, FontStyle? fontStyle, int? maxLines, String? ellipsis, double? height, String? locale, StrutStyle? strutStyle, TextLeadingDistribution? leadingDistribution})',
    },
    getterSignatures: {
      'textAlign': 'TextAlign? get textAlign',
      'textDirection': 'TextDirection? get textDirection',
      'fontFamily': 'String? get fontFamily',
      'fontSize': 'double? get fontSize',
      'fontWeight': 'FontWeight? get fontWeight',
      'fontStyle': 'FontStyle? get fontStyle',
      'maxLines': 'int? get maxLines',
      'ellipsis': 'String? get ellipsis',
      'height': 'double? get height',
      'locale': 'String? get locale',
      'strutStyle': 'StrutStyle? get strutStyle',
      'leadingDistribution': 'TextLeadingDistribution? get leadingDistribution',
    },
  );
}

// =============================================================================
// ParagraphBuilder Bridge
// =============================================================================

BridgedClass _createParagraphBuilderBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.ParagraphBuilder,
    name: 'ParagraphBuilder',
    isAssignable: (v) => v is $dartnative_6.ParagraphBuilder,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'ParagraphBuilder');
        final paragraphStyle = D4.getRequiredArg<$dartnative_6.ParagraphStyle>(
          positional,
          0,
          '_paragraphStyle',
          'ParagraphBuilder',
        );
        return $dartnative_6.ParagraphBuilder(paragraphStyle);
      },
    },
    methods: {
      'pushStyle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.ParagraphBuilder>(
          target,
          'ParagraphBuilder',
        );
        D4.requireMinArgs(positional, 1, 'pushStyle');
        final style = D4.getRequiredArg<$dartnative_3.TextStyle>(
          positional,
          0,
          'style',
          'pushStyle',
        );
        t.pushStyle(style);
        return null;
      },
      'popStyle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.ParagraphBuilder>(
          target,
          'ParagraphBuilder',
        );
        t.popStyle();
        return null;
      },
      'addText': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.ParagraphBuilder>(
          target,
          'ParagraphBuilder',
        );
        D4.requireMinArgs(positional, 1, 'addText');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'addText',
        );
        t.addText(text);
        return null;
      },
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.ParagraphBuilder>(
          target,
          'ParagraphBuilder',
        );
        return (t as dynamic).build();
      },
    },
    constructorSignatures: {
      '': 'ParagraphBuilder(ParagraphStyle _paragraphStyle)',
    },
    methodSignatures: {
      'pushStyle': 'void pushStyle(TextStyle style)',
      'popStyle': 'void popStyle()',
      'addText': 'void addText(String text)',
      'build': 'Paragraph build()',
    },
  );
}

// =============================================================================
// Canvas Bridge
// =============================================================================

BridgedClass _createCanvasBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.Canvas,
    name: 'Canvas',
    isAssignable: (v) => v is $dartnative_6.Canvas,
    isAbstract: true,
    constructors: {},
    methods: {
      'save': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        t.save();
        return null;
      },
      'saveLayer': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 2, 'saveLayer');
        final bounds = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'bounds',
          'saveLayer',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          1,
          'paint',
          'saveLayer',
        );
        t.saveLayer(bounds, paint);
        return null;
      },
      'restore': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        t.restore();
        return null;
      },
      'translate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 2, 'translate');
        final dx = D4.getRequiredArg<double>(positional, 0, 'dx', 'translate');
        final dy = D4.getRequiredArg<double>(positional, 1, 'dy', 'translate');
        t.translate(dx, dy);
        return null;
      },
      'rotate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 1, 'rotate');
        final radians = D4.getRequiredArg<double>(
          positional,
          0,
          'radians',
          'rotate',
        );
        t.rotate(radians);
        return null;
      },
      'scale': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 1, 'scale');
        final sx = D4.getRequiredArg<double>(positional, 0, 'sx', 'scale');
        final sy = D4.getOptionalArg<double?>(positional, 1, 'sy');
        t.scale(sx, sy);
        return null;
      },
      'drawRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 2, 'drawRect');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'drawRect',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          1,
          'paint',
          'drawRect',
        );
        t.drawRect(rect, paint);
        return null;
      },
      'drawRRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 2, 'drawRRect');
        final rrect = D4.getRequiredArg<$dartnative_6.RRect>(
          positional,
          0,
          'rrect',
          'drawRRect',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          1,
          'paint',
          'drawRRect',
        );
        t.drawRRect(rrect, paint);
        return null;
      },
      'drawCircle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 3, 'drawCircle');
        final center = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          0,
          'center',
          'drawCircle',
        );
        final radius = D4.getRequiredArg<double>(
          positional,
          1,
          'radius',
          'drawCircle',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          2,
          'paint',
          'drawCircle',
        );
        t.drawCircle(center, radius, paint);
        return null;
      },
      'drawLine': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 3, 'drawLine');
        final p1 = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          0,
          'p1',
          'drawLine',
        );
        final p2 = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          1,
          'p2',
          'drawLine',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          2,
          'paint',
          'drawLine',
        );
        t.drawLine(p1, p2, paint);
        return null;
      },
      'drawPath': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 2, 'drawPath');
        final path = D4.getRequiredArg<$dartnative_6.Path>(
          positional,
          0,
          'path',
          'drawPath',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          1,
          'paint',
          'drawPath',
        );
        t.drawPath(path, paint);
        return null;
      },
      'drawArc': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 5, 'drawArc');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'drawArc',
        );
        final startAngle = D4.getRequiredArg<double>(
          positional,
          1,
          'startAngle',
          'drawArc',
        );
        final sweepAngle = D4.getRequiredArg<double>(
          positional,
          2,
          'sweepAngle',
          'drawArc',
        );
        final useCenter = D4.getRequiredArg<bool>(
          positional,
          3,
          'useCenter',
          'drawArc',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          4,
          'paint',
          'drawArc',
        );
        t.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
        return null;
      },
      'drawParagraph': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 2, 'drawParagraph');
        final paragraph = D4.getRequiredArg<$dartnative_6.Paragraph>(
          positional,
          0,
          'paragraph',
          'drawParagraph',
        );
        final offset = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          1,
          'offset',
          'drawParagraph',
        );
        t.drawParagraph(paragraph, offset);
        return null;
      },
      'drawText': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 2, 'drawText');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'drawText',
        );
        final offset = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          1,
          'offset',
          'drawText',
        );
        final fontSize = D4.getRequiredNamedArg<double>(
          named,
          'fontSize',
          'drawText',
        );
        final color = D4.getRequiredNamedArg<$dartnative_3.Color>(
          named,
          'color',
          'drawText',
        );
        final fontFamily = D4.getOptionalNamedArg<String?>(named, 'fontFamily');
        final fontWeight = D4.getNamedArgWithDefault<int>(
          named,
          'fontWeight',
          400,
        );
        final italic = D4.getNamedArgWithDefault<bool>(named, 'italic', false);
        final textAlign = D4.getNamedArgWithDefault<int>(named, 'textAlign', 0);
        t.drawText(
          text,
          offset,
          fontSize: fontSize,
          color: color,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          italic: italic,
          textAlign: textAlign,
        );
        return null;
      },
      'drawImage': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 3, 'drawImage');
        final image = D4.getRequiredArg<$dartnative_6.CanvasImage>(
          positional,
          0,
          'image',
          'drawImage',
        );
        final offset = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          1,
          'offset',
          'drawImage',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          2,
          'paint',
          'drawImage',
        );
        t.drawImage(image, offset, paint);
        return null;
      },
      'drawImageRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 4, 'drawImageRect');
        final image = D4.getRequiredArg<$dartnative_6.CanvasImage>(
          positional,
          0,
          'image',
          'drawImageRect',
        );
        final src = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          1,
          'src',
          'drawImageRect',
        );
        final dst = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          2,
          'dst',
          'drawImageRect',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          3,
          'paint',
          'drawImageRect',
        );
        t.drawImageRect(image, src, dst, paint);
        return null;
      },
      'clipRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 1, 'clipRect');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'clipRect',
        );
        t.clipRect(rect);
        return null;
      },
      'clipRRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 1, 'clipRRect');
        final rrect = D4.getRequiredArg<$dartnative_6.RRect>(
          positional,
          0,
          'rrect',
          'clipRRect',
        );
        t.clipRRect(rrect);
        return null;
      },
      'clipPath': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 1, 'clipPath');
        final path = D4.getRequiredArg<$dartnative_6.Path>(
          positional,
          0,
          'path',
          'clipPath',
        );
        t.clipPath(path);
        return null;
      },
      'drawPaint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 1, 'drawPaint');
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          0,
          'paint',
          'drawPaint',
        );
        t.drawPaint(paint);
        return null;
      },
      'drawShadow': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.Canvas>(target, 'Canvas');
        D4.requireMinArgs(positional, 4, 'drawShadow');
        final path = D4.getRequiredArg<$dartnative_6.Path>(
          positional,
          0,
          'path',
          'drawShadow',
        );
        final color = D4.getRequiredArg<$dartnative_3.Color>(
          positional,
          1,
          'color',
          'drawShadow',
        );
        final elevation = D4.getRequiredArg<double>(
          positional,
          2,
          'elevation',
          'drawShadow',
        );
        final transparentOccluder = D4.getRequiredArg<bool>(
          positional,
          3,
          'transparentOccluder',
          'drawShadow',
        );
        t.drawShadow(path, color, elevation, transparentOccluder);
        return null;
      },
    },
    methodSignatures: {
      'save': 'void save()',
      'saveLayer': 'void saveLayer(Rect bounds, Paint paint)',
      'restore': 'void restore()',
      'translate': 'void translate(double dx, double dy)',
      'rotate': 'void rotate(double radians)',
      'scale': 'void scale(double sx, [double? sy])',
      'drawRect': 'void drawRect(Rect rect, Paint paint)',
      'drawRRect': 'void drawRRect(RRect rrect, Paint paint)',
      'drawCircle':
          'void drawCircle(Offset center, double radius, Paint paint)',
      'drawLine': 'void drawLine(Offset p1, Offset p2, Paint paint)',
      'drawPath': 'void drawPath(Path path, Paint paint)',
      'drawArc':
          'void drawArc(Rect rect, double startAngle, double sweepAngle, bool useCenter, Paint paint)',
      'drawParagraph': 'void drawParagraph(Paragraph paragraph, Offset offset)',
      'drawText':
          'void drawText(String text, Offset offset, {required double fontSize, required Color color, String? fontFamily, int fontWeight = 400, bool italic = false, int textAlign = 0})',
      'drawImage':
          'void drawImage(CanvasImage image, Offset offset, Paint paint)',
      'drawImageRect':
          'void drawImageRect(CanvasImage image, Rect src, Rect dst, Paint paint)',
      'clipRect': 'void clipRect(Rect rect)',
      'clipRRect': 'void clipRRect(RRect rrect)',
      'clipPath': 'void clipPath(Path path)',
      'drawPaint': 'void drawPaint(Paint paint)',
      'drawShadow':
          'void drawShadow(Path path, Color color, double elevation, bool transparentOccluder)',
    },
  );
}

// =============================================================================
// CustomPainter Bridge
// =============================================================================

BridgedClass _createCustomPainterBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.CustomPainter,
    name: 'CustomPainter',
    isAssignable: (v) => v is $dartnative_6.CustomPainter,
    isAbstract: true,
    constructors: {},
    getters: {
      'repaint': (visitor, target) => D4
          .validateTarget<$dartnative_6.CustomPainter>(target, 'CustomPainter')
          .repaint,
    },
    methods: {
      'paint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.CustomPainter>(
          target,
          'CustomPainter',
        );
        D4.requireMinArgs(positional, 2, 'paint');
        final canvas = D4.getRequiredArg<$dartnative_6.Canvas>(
          positional,
          0,
          'canvas',
          'paint',
        );
        final size = D4.getRequiredArg<$dartnative_3.Size>(
          positional,
          1,
          'size',
          'paint',
        );
        t.paint(canvas, size);
        return null;
      },
      'preferredHeight': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.CustomPainter>(
          target,
          'CustomPainter',
        );
        D4.requireMinArgs(positional, 1, 'preferredHeight');
        final availableWidth = D4.getRequiredArg<double>(
          positional,
          0,
          'availableWidth',
          'preferredHeight',
        );
        return t.preferredHeight(availableWidth);
      },
      'shouldRepaint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.CustomPainter>(
          target,
          'CustomPainter',
        );
        D4.requireMinArgs(positional, 1, 'shouldRepaint');
        final oldDelegate = D4.getRequiredArg<$dartnative_6.CustomPainter>(
          positional,
          0,
          'oldDelegate',
          'shouldRepaint',
        );
        return t.shouldRepaint(oldDelegate);
      },
    },
    methodSignatures: {
      'paint': 'void paint(Canvas canvas, Size size)',
      'preferredHeight': 'double? preferredHeight(double availableWidth)',
      'shouldRepaint': 'bool shouldRepaint(CustomPainter oldDelegate)',
    },
    getterSignatures: {
      'repaint': 'Listenable? get repaint',
    },
  );
}

// =============================================================================
// CustomPaint Bridge
// =============================================================================

BridgedClass _createCustomPaintBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.CustomPaint,
    name: 'CustomPaint',
    isAssignable: (v) => v is $dartnative_6.CustomPaint,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final painter = D4.getOptionalNamedArg<$dartnative_6.CustomPainter?>(
          named,
          'painter',
        );
        final foregroundPainter = D4
            .getOptionalNamedArg<$dartnative_6.CustomPainter?>(
              named,
              'foregroundPainter',
            );
        final child = D4.getOptionalNamedArg<$dartnative_1.Widget?>(
          named,
          'child',
        );
        final size = D4.getOptionalNamedArg<$dartnative_3.Size?>(named, 'size');
        return $dartnative_6.CustomPaint(
          key: key,
          painter: painter,
          foregroundPainter: foregroundPainter,
          child: child,
          size: size,
        );
      },
    },
    getters: {
      'painter': (visitor, target) => D4
          .validateTarget<$dartnative_6.CustomPaint>(target, 'CustomPaint')
          .painter,
      'foregroundPainter': (visitor, target) => D4
          .validateTarget<$dartnative_6.CustomPaint>(target, 'CustomPaint')
          .foregroundPainter,
      'child': (visitor, target) => D4
          .validateTarget<$dartnative_6.CustomPaint>(target, 'CustomPaint')
          .child,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_6.CustomPaint>(target, 'CustomPaint')
          .size,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_6.CustomPaint>(target, 'CustomPaint')
          .key,
    },
    constructorSignatures: {
      '': 'const CustomPaint({Key? key, CustomPainter? painter, CustomPainter? foregroundPainter, Widget? child, Size? size})',
    },
    getterSignatures: {
      'painter': 'CustomPainter? get painter',
      'foregroundPainter': 'CustomPainter? get foregroundPainter',
      'child': 'Widget? get child',
      'size': 'Size? get size',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// BinaryCanvasRecorder Bridge
// =============================================================================

BridgedClass _createBinaryCanvasRecorderBridge() {
  return BridgedClass(
    nativeType: $dartnative_6.BinaryCanvasRecorder,
    name: 'BinaryCanvasRecorder',
    isAssignable: (v) => v is $dartnative_6.BinaryCanvasRecorder,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final initialCapacity = D4.getOptionalArgWithDefault<int>(
          positional,
          0,
          'initialCapacity',
          1024,
        );
        return $dartnative_6.BinaryCanvasRecorder(initialCapacity);
      },
    },
    getters: {
      'bytesWritten': (visitor, target) => D4
          .validateTarget<$dartnative_6.BinaryCanvasRecorder>(
            target,
            'BinaryCanvasRecorder',
          )
          .bytesWritten,
    },
    methods: {
      'save': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        t.save();
        return null;
      },
      'saveLayer': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 2, 'saveLayer');
        final bounds = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'bounds',
          'saveLayer',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          1,
          'paint',
          'saveLayer',
        );
        t.saveLayer(bounds, paint);
        return null;
      },
      'restore': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        t.restore();
        return null;
      },
      'translate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 2, 'translate');
        final dx = D4.getRequiredArg<double>(positional, 0, 'dx', 'translate');
        final dy = D4.getRequiredArg<double>(positional, 1, 'dy', 'translate');
        t.translate(dx, dy);
        return null;
      },
      'rotate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 1, 'rotate');
        final radians = D4.getRequiredArg<double>(
          positional,
          0,
          'radians',
          'rotate',
        );
        t.rotate(radians);
        return null;
      },
      'scale': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 1, 'scale');
        final sx = D4.getRequiredArg<double>(positional, 0, 'sx', 'scale');
        final sy = D4.getOptionalArg<double?>(positional, 1, 'sy');
        t.scale(sx, sy);
        return null;
      },
      'drawRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 2, 'drawRect');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'drawRect',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          1,
          'paint',
          'drawRect',
        );
        t.drawRect(rect, paint);
        return null;
      },
      'drawRRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 2, 'drawRRect');
        final rrect = D4.getRequiredArg<$dartnative_6.RRect>(
          positional,
          0,
          'rrect',
          'drawRRect',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          1,
          'paint',
          'drawRRect',
        );
        t.drawRRect(rrect, paint);
        return null;
      },
      'drawCircle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 3, 'drawCircle');
        final center = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          0,
          'center',
          'drawCircle',
        );
        final radius = D4.getRequiredArg<double>(
          positional,
          1,
          'radius',
          'drawCircle',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          2,
          'paint',
          'drawCircle',
        );
        t.drawCircle(center, radius, paint);
        return null;
      },
      'drawLine': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 3, 'drawLine');
        final p1 = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          0,
          'p1',
          'drawLine',
        );
        final p2 = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          1,
          'p2',
          'drawLine',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          2,
          'paint',
          'drawLine',
        );
        t.drawLine(p1, p2, paint);
        return null;
      },
      'drawPath': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 2, 'drawPath');
        final path = D4.getRequiredArg<$dartnative_6.Path>(
          positional,
          0,
          'path',
          'drawPath',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          1,
          'paint',
          'drawPath',
        );
        t.drawPath(path, paint);
        return null;
      },
      'drawArc': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 5, 'drawArc');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'drawArc',
        );
        final startAngle = D4.getRequiredArg<double>(
          positional,
          1,
          'startAngle',
          'drawArc',
        );
        final sweepAngle = D4.getRequiredArg<double>(
          positional,
          2,
          'sweepAngle',
          'drawArc',
        );
        final useCenter = D4.getRequiredArg<bool>(
          positional,
          3,
          'useCenter',
          'drawArc',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          4,
          'paint',
          'drawArc',
        );
        t.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
        return null;
      },
      'drawParagraph': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 2, 'drawParagraph');
        final paragraph = D4.getRequiredArg<$dartnative_6.Paragraph>(
          positional,
          0,
          'paragraph',
          'drawParagraph',
        );
        final offset = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          1,
          'offset',
          'drawParagraph',
        );
        t.drawParagraph(paragraph, offset);
        return null;
      },
      'drawText': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 2, 'drawText');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'drawText',
        );
        final offset = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          1,
          'offset',
          'drawText',
        );
        final fontSize = D4.getRequiredNamedArg<double>(
          named,
          'fontSize',
          'drawText',
        );
        final color = D4.getRequiredNamedArg<$dartnative_3.Color>(
          named,
          'color',
          'drawText',
        );
        final fontFamily = D4.getOptionalNamedArg<String?>(named, 'fontFamily');
        final fontWeight = D4.getNamedArgWithDefault<int>(
          named,
          'fontWeight',
          400,
        );
        final italic = D4.getNamedArgWithDefault<bool>(named, 'italic', false);
        final textAlign = D4.getNamedArgWithDefault<int>(named, 'textAlign', 0);
        t.drawText(
          text,
          offset,
          fontSize: fontSize,
          color: color,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          italic: italic,
          textAlign: textAlign,
        );
        return null;
      },
      'drawImage': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 3, 'drawImage');
        final image = D4.getRequiredArg<$dartnative_6.CanvasImage>(
          positional,
          0,
          'image',
          'drawImage',
        );
        final offset = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          1,
          'offset',
          'drawImage',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          2,
          'paint',
          'drawImage',
        );
        t.drawImage(image, offset, paint);
        return null;
      },
      'drawImageRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 4, 'drawImageRect');
        final image = D4.getRequiredArg<$dartnative_6.CanvasImage>(
          positional,
          0,
          'image',
          'drawImageRect',
        );
        final src = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          1,
          'src',
          'drawImageRect',
        );
        final dst = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          2,
          'dst',
          'drawImageRect',
        );
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          3,
          'paint',
          'drawImageRect',
        );
        t.drawImageRect(image, src, dst, paint);
        return null;
      },
      'clipRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 1, 'clipRect');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'clipRect',
        );
        t.clipRect(rect);
        return null;
      },
      'clipRRect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 1, 'clipRRect');
        final rrect = D4.getRequiredArg<$dartnative_6.RRect>(
          positional,
          0,
          'rrect',
          'clipRRect',
        );
        t.clipRRect(rrect);
        return null;
      },
      'clipPath': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 1, 'clipPath');
        final path = D4.getRequiredArg<$dartnative_6.Path>(
          positional,
          0,
          'path',
          'clipPath',
        );
        t.clipPath(path);
        return null;
      },
      'drawPaint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 1, 'drawPaint');
        final paint = D4.getRequiredArg<$dartnative_6.Paint>(
          positional,
          0,
          'paint',
          'drawPaint',
        );
        t.drawPaint(paint);
        return null;
      },
      'drawShadow': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        D4.requireMinArgs(positional, 4, 'drawShadow');
        final path = D4.getRequiredArg<$dartnative_6.Path>(
          positional,
          0,
          'path',
          'drawShadow',
        );
        final color = D4.getRequiredArg<$dartnative_3.Color>(
          positional,
          1,
          'color',
          'drawShadow',
        );
        final elevation = D4.getRequiredArg<double>(
          positional,
          2,
          'elevation',
          'drawShadow',
        );
        final transparentOccluder = D4.getRequiredArg<bool>(
          positional,
          3,
          'transparentOccluder',
          'drawShadow',
        );
        t.drawShadow(path, color, elevation, transparentOccluder);
        return null;
      },
      'reset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        t.reset();
        return null;
      },
      'finish': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
          target,
          'BinaryCanvasRecorder',
        );
        return t.finish();
      },
      'writeParagraphForMeasure':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$dartnative_6.BinaryCanvasRecorder>(
              target,
              'BinaryCanvasRecorder',
            );
            D4.requireMinArgs(positional, 1, 'writeParagraphForMeasure');
            final paragraph = D4.getRequiredArg<$dartnative_6.Paragraph>(
              positional,
              0,
              'paragraph',
              'writeParagraphForMeasure',
            );
            t.writeParagraphForMeasure(paragraph);
            return null;
          },
    },
    constructorSignatures: {
      '': 'BinaryCanvasRecorder([int initialCapacity = 1024])',
    },
    methodSignatures: {
      'save': 'void save()',
      'saveLayer': 'void saveLayer(Rect bounds, Paint paint)',
      'restore': 'void restore()',
      'translate': 'void translate(double dx, double dy)',
      'rotate': 'void rotate(double radians)',
      'scale': 'void scale(double sx, [double? sy])',
      'drawRect': 'void drawRect(Rect rect, Paint paint)',
      'drawRRect': 'void drawRRect(RRect rrect, Paint paint)',
      'drawCircle':
          'void drawCircle(Offset center, double radius, Paint paint)',
      'drawLine': 'void drawLine(Offset p1, Offset p2, Paint paint)',
      'drawPath': 'void drawPath(Path path, Paint paint)',
      'drawArc':
          'void drawArc(Rect rect, double startAngle, double sweepAngle, bool useCenter, Paint paint)',
      'drawParagraph': 'void drawParagraph(Paragraph paragraph, Offset offset)',
      'drawText':
          'void drawText(String text, Offset offset, {required double fontSize, required Color color, String? fontFamily, int fontWeight = 400, bool italic = false, int textAlign = 0})',
      'drawImage':
          'void drawImage(CanvasImage image, Offset offset, Paint paint)',
      'drawImageRect':
          'void drawImageRect(CanvasImage image, Rect src, Rect dst, Paint paint)',
      'clipRect': 'void clipRect(Rect rect)',
      'clipRRect': 'void clipRRect(RRect rrect)',
      'clipPath': 'void clipPath(Path path)',
      'drawPaint': 'void drawPaint(Paint paint)',
      'drawShadow':
          'void drawShadow(Path path, Color color, double elevation, bool transparentOccluder)',
      'reset': 'void reset()',
      'finish': 'Uint8List finish()',
      'writeParagraphForMeasure':
          'void writeParagraphForMeasure(Paragraph paragraph)',
    },
    getterSignatures: {
      'bytesWritten': 'int get bytesWritten',
    },
  );
}

// =============================================================================
// DisposableShader Bridge
// =============================================================================

BridgedClass _createDisposableShaderBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_2.DisposableShader,
    name: 'DisposableShader',
    isAssignable: (v) => v is $dartnative_skia_2.DisposableShader,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    getters: {
      'ptrAddress': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.DisposableShader>(
            target,
            'DisposableShader',
          )
          .ptrAddress,
    },
    methods: {
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.DisposableShader>(
          target,
          'DisposableShader',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    methodSignatures: {
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'ptrAddress': 'int get ptrAddress',
    },
  );
}

// =============================================================================
// SkiaImage Bridge
// =============================================================================

BridgedClass _createSkiaImageBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_2.SkiaImage,
    name: 'SkiaImage',
    isAssignable: (v) => v is $dartnative_skia_2.SkiaImage,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    getters: {
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SkiaImage>(target, 'SkiaImage')
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SkiaImage>(target, 'SkiaImage')
          .height,
      'cacheKey': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SkiaImage>(target, 'SkiaImage')
          .cacheKey,
    },
    methods: {
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SkiaImage>(
          target,
          'SkiaImage',
        );
        (t as dynamic).dispose();
        return null;
      },
      'asShader': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SkiaImage>(
          target,
          'SkiaImage',
        );
        return t.asShader();
      },
      'readPixels': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SkiaImage>(
          target,
          'SkiaImage',
        );
        return t.readPixels();
      },
    },
    methodSignatures: {
      'dispose': 'void dispose()',
      'asShader': 'DisposableShader asShader()',
      'readPixels': 'Uint8List? readPixels()',
    },
    getterSignatures: {
      'width': 'int get width',
      'height': 'int get height',
      'cacheKey': 'String get cacheKey',
    },
  );
}

// =============================================================================
// SkiaPictureRecorder Bridge
// =============================================================================

BridgedClass _createSkiaPictureRecorderBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_2.SkiaPictureRecorder,
    name: 'SkiaPictureRecorder',
    isAssignable: (v) => v is $dartnative_skia_2.SkiaPictureRecorder,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'SkiaPictureRecorder');
        final width = D4.getRequiredArg<int>(
          positional,
          0,
          'width',
          'SkiaPictureRecorder',
        );
        final height = D4.getRequiredArg<int>(
          positional,
          1,
          'height',
          'SkiaPictureRecorder',
        );
        return $dartnative_skia_2.SkiaPictureRecorder(width, height);
      },
    },
    getters: {
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SkiaPictureRecorder>(
            target,
            'SkiaPictureRecorder',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SkiaPictureRecorder>(
            target,
            'SkiaPictureRecorder',
          )
          .height,
      'canvas': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SkiaPictureRecorder>(
            target,
            'SkiaPictureRecorder',
          )
          .canvas,
    },
    methods: {
      'endRecording': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SkiaPictureRecorder>(
          target,
          'SkiaPictureRecorder',
        );
        return t.endRecording();
      },
      'readPixels': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SkiaPictureRecorder>(
          target,
          'SkiaPictureRecorder',
        );
        return t.readPixels();
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SkiaPictureRecorder>(
          target,
          'SkiaPictureRecorder',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    constructorSignatures: {
      '': 'SkiaPictureRecorder(int width, int height)',
    },
    methodSignatures: {
      'endRecording': 'SkiaImage endRecording()',
      'readPixels': 'Uint8List? readPixels()',
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'width': 'int get width',
      'height': 'int get height',
      'canvas': 'Canvas get canvas',
    },
  );
}

// =============================================================================
// SimpleParagraph Bridge
// =============================================================================

BridgedClass _createSimpleParagraphBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_2.SimpleParagraph,
    name: 'SimpleParagraph',
    isAssignable: (v) => v is $dartnative_skia_2.SimpleParagraph,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'SimpleParagraph');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'SimpleParagraph',
        );
        final fontSize = D4.getRequiredArg<double>(
          positional,
          1,
          'fontSize',
          'SimpleParagraph',
        );
        final color = D4.getOptionalArgWithDefault<$dartnative_3.Color>(
          positional,
          2,
          'color',
          const $dartnative_3.Color(0xFF000000),
        );
        final maxWidth = D4.getOptionalArgWithDefault<double>(
          positional,
          3,
          'maxWidth',
          1e6,
        );
        return $dartnative_skia_2.SimpleParagraph(
          text,
          fontSize,
          color,
          maxWidth,
        );
      },
    },
    getters: {
      'text': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .text,
      'fontSize': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .fontSize,
      'color': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .color,
      'maxWidth': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .maxWidth,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .height,
      'longestLine': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .longestLine,
      'lineCount': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .lineCount,
      'didExceedMaxLines': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .didExceedMaxLines,
      'minIntrinsicWidth': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .minIntrinsicWidth,
      'maxIntrinsicWidth': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .maxIntrinsicWidth,
      'alphabeticBaseline': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .alphabeticBaseline,
      'ideographicBaseline': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.SimpleParagraph>(
            target,
            'SimpleParagraph',
          )
          .ideographicBaseline,
    },
    methods: {
      'layout': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SimpleParagraph>(
          target,
          'SimpleParagraph',
        );
        D4.requireMinArgs(positional, 1, 'layout');
        final constraints = D4
            .getRequiredArg<$dartnative_6.ParagraphConstraints>(
              positional,
              0,
              'constraints',
              'layout',
            );
        t.layout(constraints);
        return null;
      },
      'getLineMetrics': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SimpleParagraph>(
          target,
          'SimpleParagraph',
        );
        return t.getLineMetrics();
      },
      'getBoxesForRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SimpleParagraph>(
          target,
          'SimpleParagraph',
        );
        D4.requireMinArgs(positional, 2, 'getBoxesForRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'getBoxesForRange',
        );
        final end = D4.getRequiredArg<int>(
          positional,
          1,
          'end',
          'getBoxesForRange',
        );
        final boxHeightStyle = D4.getNamedArgWithDefault<int>(
          named,
          'boxHeightStyle',
          0,
        );
        final boxWidthStyle = D4.getNamedArgWithDefault<int>(
          named,
          'boxWidthStyle',
          0,
        );
        return t.getBoxesForRange(
          start,
          end,
          boxHeightStyle: boxHeightStyle,
          boxWidthStyle: boxWidthStyle,
        );
      },
      'getPositionForOffset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SimpleParagraph>(
          target,
          'SimpleParagraph',
        );
        D4.requireMinArgs(positional, 1, 'getPositionForOffset');
        final offset = D4.getRequiredArg<$dartnative_3.Offset>(
          positional,
          0,
          'offset',
          'getPositionForOffset',
        );
        return t.getPositionForOffset(offset);
      },
      'measure': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.SimpleParagraph>(
          target,
          'SimpleParagraph',
        );
        return t.measure();
      },
    },
    constructorSignatures: {
      '': 'const SimpleParagraph(String text, double fontSize, [Color color = const Color(0xFF000000), double maxWidth = 1e6])',
    },
    methodSignatures: {
      'layout': 'void layout(ParagraphConstraints constraints)',
      'getLineMetrics': 'List<LineMetrics> getLineMetrics()',
      'getBoxesForRange':
          'List<TextBox> getBoxesForRange(int start, int end, {int boxHeightStyle = 0, int boxWidthStyle = 0})',
      'getPositionForOffset':
          'TextPosition getPositionForOffset(Offset offset)',
      'measure': 'Size measure()',
    },
    getterSignatures: {
      'text': 'String get text',
      'fontSize': 'double get fontSize',
      'color': 'Color get color',
      'maxWidth': 'double get maxWidth',
      'width': 'double get width',
      'height': 'double get height',
      'longestLine': 'double get longestLine',
      'lineCount': 'int get lineCount',
      'didExceedMaxLines': 'bool get didExceedMaxLines',
      'minIntrinsicWidth': 'double get minIntrinsicWidth',
      'maxIntrinsicWidth': 'double get maxIntrinsicWidth',
      'alphabeticBaseline': 'double get alphabeticBaseline',
      'ideographicBaseline': 'double get ideographicBaseline',
    },
  );
}

// =============================================================================
// RuntimeEffect Bridge
// =============================================================================

BridgedClass _createRuntimeEffectBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_2.RuntimeEffect,
    name: 'RuntimeEffect',
    isAssignable: (v) => v is $dartnative_skia_2.RuntimeEffect,
    constructors: {},
    methods: {
      'makeShader': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.RuntimeEffect>(
          target,
          'RuntimeEffect',
        );
        D4.requireMinArgs(positional, 1, 'makeShader');
        if (positional.isEmpty) {
          throw ArgumentError(
            'makeShader: Missing required argument "uniforms" at position 0',
          );
        }
        final uniforms = D4.coerceList<double>(positional[0], 'uniforms');
        return t.makeShader(uniforms);
      },
      'makeShaderWithChildren': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.RuntimeEffect>(
          target,
          'RuntimeEffect',
        );
        D4.requireMinArgs(positional, 2, 'makeShaderWithChildren');
        if (positional.isEmpty) {
          throw ArgumentError(
            'makeShaderWithChildren: Missing required argument "uniforms" at position 0',
          );
        }
        final uniforms = D4.coerceList<double>(positional[0], 'uniforms');
        if (positional.length <= 1) {
          throw ArgumentError(
            'makeShaderWithChildren: Missing required argument "children" at position 1',
          );
        }
        final children = D4.coerceList<$dartnative_skia_2.DisposableShader>(
          positional[1],
          'children',
        );
        return t.makeShaderWithChildren(uniforms, children);
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.RuntimeEffect>(
          target,
          'RuntimeEffect',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    staticMethods: {
      'make': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'make');
        final sksl = D4.getRequiredArg<String>(positional, 0, 'sksl', 'make');
        return $dartnative_skia_2.RuntimeEffect.make(sksl);
      },
    },
    methodSignatures: {
      'makeShader': '_NativeShader makeShader(List<double> uniforms)',
      'makeShaderWithChildren':
          '_NativeShader makeShaderWithChildren(List<double> uniforms, List<DisposableShader> children)',
      'dispose': 'void dispose()',
    },
    staticMethodSignatures: {
      'make': 'RuntimeEffect? make(String sksl)',
    },
  );
}

// =============================================================================
// FragmentProgram Bridge
// =============================================================================

BridgedClass _createFragmentProgramBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_2.FragmentProgram,
    name: 'FragmentProgram',
    isAssignable: (v) => v is $dartnative_skia_2.FragmentProgram,
    constructors: {},
    methods: {
      'fragmentShader': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.FragmentProgram>(
          target,
          'FragmentProgram',
        );
        return t.fragmentShader();
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.FragmentProgram>(
          target,
          'FragmentProgram',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    staticMethods: {
      'fromSource': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'fromSource');
        final sksl = D4.getRequiredArg<String>(
          positional,
          0,
          'sksl',
          'fromSource',
        );
        return $dartnative_skia_2.FragmentProgram.fromSource(sksl);
      },
      'fromAsset': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'fromAsset');
        final assetKey = D4.getRequiredArg<String>(
          positional,
          0,
          'assetKey',
          'fromAsset',
        );
        return $dartnative_skia_2.FragmentProgram.fromAsset(assetKey);
      },
    },
    methodSignatures: {
      'fragmentShader': 'FragmentShader fragmentShader()',
      'dispose': 'void dispose()',
    },
    staticMethodSignatures: {
      'fromSource': 'FragmentProgram fromSource(String sksl)',
      'fromAsset': 'Future<FragmentProgram> fromAsset(String assetKey)',
    },
  );
}

// =============================================================================
// FragmentShader Bridge
// =============================================================================

BridgedClass _createFragmentShaderBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_2.FragmentShader,
    name: 'FragmentShader',
    isAssignable: (v) => v is $dartnative_skia_2.FragmentShader,
    hierarchyDepth: 1,
    constructors: {},
    methods: {
      'setFloat': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.FragmentShader>(
          target,
          'FragmentShader',
        );
        D4.requireMinArgs(positional, 2, 'setFloat');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'setFloat',
        );
        final value = D4.getRequiredArg<double>(
          positional,
          1,
          'value',
          'setFloat',
        );
        t.setFloat(index, value);
        return null;
      },
      'toNativeShader': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.FragmentShader>(
          target,
          'FragmentShader',
        );
        return t.toNativeShader();
      },
    },
    methodSignatures: {
      'setFloat': 'void setFloat(int index, double value)',
      'toNativeShader': '_NativeShader toNativeShader()',
    },
  );
}

// =============================================================================
// CanvasLinearGradient Bridge
// =============================================================================

BridgedClass _createCanvasLinearGradientBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_2.CanvasLinearGradient,
    name: 'CanvasLinearGradient',
    isAssignable: (v) => v is $dartnative_skia_2.CanvasLinearGradient,
    constructors: {
      '': (visitor, positional, named) {
        final begin = D4.getRequiredNamedArg<$dartnative_3.Offset>(
          named,
          'begin',
          'CanvasLinearGradient',
        );
        final end = D4.getRequiredNamedArg<$dartnative_3.Offset>(
          named,
          'end',
          'CanvasLinearGradient',
        );
        if (!named.containsKey('colors') || named['colors'] == null) {
          throw ArgumentError(
            'CanvasLinearGradient: Missing required named argument "colors"',
          );
        }
        final colors = D4.coerceList<$dartnative_3.Color>(
          named['colors'],
          'colors',
        );
        final stops = D4.coerceListOrNull<double>(named['stops'], 'stops');
        return $dartnative_skia_2.CanvasLinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
        );
      },
    },
    getters: {
      'begin': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.CanvasLinearGradient>(
            target,
            'CanvasLinearGradient',
          )
          .begin,
      'end': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.CanvasLinearGradient>(
            target,
            'CanvasLinearGradient',
          )
          .end,
      'colors': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.CanvasLinearGradient>(
            target,
            'CanvasLinearGradient',
          )
          .colors,
      'stops': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.CanvasLinearGradient>(
            target,
            'CanvasLinearGradient',
          )
          .stops,
    },
    methods: {
      'createShader': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.CanvasLinearGradient>(
          target,
          'CanvasLinearGradient',
        );
        D4.requireMinArgs(positional, 1, 'createShader');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'createShader',
        );
        return t.createShader(rect);
      },
    },
    constructorSignatures: {
      '': 'const CanvasLinearGradient({required Offset begin, required Offset end, required List<Color> colors, List<double>? stops})',
    },
    methodSignatures: {
      'createShader': 'DisposableShader createShader(Rect rect)',
    },
    getterSignatures: {
      'begin': 'Offset get begin',
      'end': 'Offset get end',
      'colors': 'List<Color> get colors',
      'stops': 'List<double>? get stops',
    },
  );
}

// =============================================================================
// CanvasRadialGradient Bridge
// =============================================================================

BridgedClass _createCanvasRadialGradientBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_2.CanvasRadialGradient,
    name: 'CanvasRadialGradient',
    isAssignable: (v) => v is $dartnative_skia_2.CanvasRadialGradient,
    constructors: {
      '': (visitor, positional, named) {
        final radius = D4.getNamedArgWithDefault<double>(named, 'radius', 0.5);
        if (!named.containsKey('colors') || named['colors'] == null) {
          throw ArgumentError(
            'CanvasRadialGradient: Missing required named argument "colors"',
          );
        }
        final colors = D4.coerceList<$dartnative_3.Color>(
          named['colors'],
          'colors',
        );
        final stops = D4.coerceListOrNull<double>(named['stops'], 'stops');
        return $dartnative_skia_2.CanvasRadialGradient(
          radius: radius,
          colors: colors,
          stops: stops,
        );
      },
    },
    getters: {
      'radius': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.CanvasRadialGradient>(
            target,
            'CanvasRadialGradient',
          )
          .radius,
      'colors': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.CanvasRadialGradient>(
            target,
            'CanvasRadialGradient',
          )
          .colors,
      'stops': (visitor, target) => D4
          .validateTarget<$dartnative_skia_2.CanvasRadialGradient>(
            target,
            'CanvasRadialGradient',
          )
          .stops,
    },
    methods: {
      'createShader': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_2.CanvasRadialGradient>(
          target,
          'CanvasRadialGradient',
        );
        D4.requireMinArgs(positional, 1, 'createShader');
        final rect = D4.getRequiredArg<$dartnative_3.Rect>(
          positional,
          0,
          'rect',
          'createShader',
        );
        return t.createShader(rect);
      },
    },
    constructorSignatures: {
      '': 'const CanvasRadialGradient({double radius = 0.5, required List<Color> colors, List<double>? stops})',
    },
    methodSignatures: {
      'createShader': 'DisposableShader createShader(Rect rect)',
    },
    getterSignatures: {
      'radius': 'double get radius',
      'colors': 'List<Color> get colors',
      'stops': 'List<double>? get stops',
    },
  );
}

// =============================================================================
// SkiaBindings Bridge
// =============================================================================

BridgedClass _createSkiaBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_3.SkiaBindings,
    name: 'SkiaBindings',
    isAssignable: (v) => v is $dartnative_skia_3.SkiaBindings,
    constructors: {},
    getters: {
      'dn_begin_frame': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_begin_frame,
      'dn_end_frame': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_end_frame,
      'dnSkiaPrewarm': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dnSkiaPrewarm,
      'dn_get_view_size': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_get_view_size,
      'dn_skia_set_verbose': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_skia_set_verbose,
      'dn_skia_set_threaded_raster': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_skia_set_threaded_raster,
      'dn_paint_create': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_create,
      'dn_paint_destroy': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_destroy,
      'dn_paint_set_color': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_set_color,
      'dn_paint_set_alpha': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_set_alpha,
      'dn_paint_set_style': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_set_style,
      'dn_paint_set_stroke_width': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_set_stroke_width,
      'dn_paint_set_stroke_cap': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_set_stroke_cap,
      'dn_paint_set_antialias': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_set_antialias,
      'dn_paint_set_shader': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_set_shader,
      'dn_paint_set_blend_mode': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_set_blend_mode,
      'dn_paint_set_image_filter': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_paint_set_image_filter,
      'dn_path_create': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_create,
      'dn_path_destroy': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_destroy,
      'dn_path_reset': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_reset,
      'dn_path_move_to': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_move_to,
      'dn_path_line_to': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_line_to,
      'dn_path_quad_to': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_quad_to,
      'dn_path_cubic_to': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_cubic_to,
      'dn_path_arc_to': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_arc_to,
      'dn_path_close': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_close,
      'dn_path_add_oval': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_add_oval,
      'dn_path_add_rect': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_path_add_rect,
      'dn_canvas_save': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_save,
      'dn_canvas_restore': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_restore,
      'dn_canvas_translate': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_translate,
      'dn_canvas_scale': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_scale,
      'dn_canvas_rotate': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_rotate,
      'dn_canvas_clear': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_clear,
      'dn_canvas_draw_paint': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_draw_paint,
      'dn_canvas_draw_rect': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_draw_rect,
      'dn_canvas_draw_rrect': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_draw_rrect,
      'dn_canvas_draw_circle': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_draw_circle,
      'dn_canvas_draw_line': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_draw_line,
      'dn_canvas_draw_path': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_draw_path,
      'dn_canvas_draw_arc': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_draw_arc,
      'dn_canvas_draw_text': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_draw_text,
      'dn_measure_text': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_measure_text,
      'dn_canvas_clip_rect': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_clip_rect,
      'dn_canvas_clip_rrect': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_clip_rrect,
      'dn_canvas_clip_path': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_clip_path,
      'dn_canvas_save_layer': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_save_layer,
      'dn_image_filter_blur_create': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_image_filter_blur_create,
      'dn_image_filter_destroy': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_image_filter_destroy,
      'dn_runtime_effect_make': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_runtime_effect_make,
      'dn_runtime_effect_destroy': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_runtime_effect_destroy,
      'dn_runtime_effect_make_shader': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_runtime_effect_make_shader,
      'dn_runtime_effect_make_shader_with_children': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_runtime_effect_make_shader_with_children,
      'dn_image_make_raster_from_encoded': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_image_make_raster_from_encoded,
      'dn_image_unref': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_image_unref,
      'dn_image_width': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_image_width,
      'dn_image_height': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_image_height,
      'dn_image_make_shader': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_image_make_shader,
      'dn_canvas_draw_image_rect': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_canvas_draw_image_rect,
      'dn_shader_linear_gradient': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_shader_linear_gradient,
      'dn_shader_radial_gradient': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_shader_radial_gradient,
      'dn_shader_unref': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_shader_unref,
      'dn_image_read_pixels': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_image_read_pixels,
      'dn_surface_create_raster': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_surface_create_raster,
      'dn_surface_get_canvas': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_surface_get_canvas,
      'dn_surface_snapshot': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_surface_snapshot,
      'dn_surface_read_pixels': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_surface_read_pixels,
      'dn_surface_destroy': (visitor, target) => D4
          .validateTarget<$dartnative_skia_3.SkiaBindings>(
            target,
            'SkiaBindings',
          )
          .dn_surface_destroy,
    },
    staticGetters: {
      'instance': (visitor) => $dartnative_skia_3.SkiaBindings.instance,
    },
    getterSignatures: {
      'dn_begin_frame': 'int Function(int) get dn_begin_frame',
      'dn_end_frame': 'void Function(int) get dn_end_frame',
      'dnSkiaPrewarm': 'void Function() get dnSkiaPrewarm',
      'dn_get_view_size':
          'void Function(int, Pointer<Double>, Pointer<Double>) get dn_get_view_size',
      'dn_skia_set_verbose': 'void Function(int) get dn_skia_set_verbose',
      'dn_skia_set_threaded_raster':
          'void Function(int) get dn_skia_set_threaded_raster',
      'dn_paint_create': 'Pointer<Void> Function() get dn_paint_create',
      'dn_paint_destroy': 'void Function(Pointer<Void>) get dn_paint_destroy',
      'dn_paint_set_color':
          'void Function(Pointer<Void>, int) get dn_paint_set_color',
      'dn_paint_set_alpha':
          'void Function(Pointer<Void>, int) get dn_paint_set_alpha',
      'dn_paint_set_style':
          'void Function(Pointer<Void>, int) get dn_paint_set_style',
      'dn_paint_set_stroke_width':
          'void Function(Pointer<Void>, double) get dn_paint_set_stroke_width',
      'dn_paint_set_stroke_cap':
          'void Function(Pointer<Void>, int) get dn_paint_set_stroke_cap',
      'dn_paint_set_antialias':
          'void Function(Pointer<Void>, bool) get dn_paint_set_antialias',
      'dn_paint_set_shader':
          'void Function(Pointer<Void>, Pointer<Void>) get dn_paint_set_shader',
      'dn_paint_set_blend_mode':
          'void Function(Pointer<Void>, int) get dn_paint_set_blend_mode',
      'dn_paint_set_image_filter':
          'void Function(Pointer<Void>, Pointer<Void>) get dn_paint_set_image_filter',
      'dn_path_create': 'Pointer<Void> Function() get dn_path_create',
      'dn_path_destroy': 'void Function(Pointer<Void>) get dn_path_destroy',
      'dn_path_reset': 'void Function(Pointer<Void>) get dn_path_reset',
      'dn_path_move_to':
          'void Function(Pointer<Void>, double, double) get dn_path_move_to',
      'dn_path_line_to':
          'void Function(Pointer<Void>, double, double) get dn_path_line_to',
      'dn_path_quad_to':
          'void Function(Pointer<Void>, double, double, double, double) get dn_path_quad_to',
      'dn_path_cubic_to':
          'void Function(Pointer<Void>, double, double, double, double, double, double) get dn_path_cubic_to',
      'dn_path_arc_to':
          'void Function(Pointer<Void>, double, double, double, double, double, double, bool) get dn_path_arc_to',
      'dn_path_close': 'void Function(Pointer<Void>) get dn_path_close',
      'dn_path_add_oval':
          'void Function(Pointer<Void>, double, double, double, double) get dn_path_add_oval',
      'dn_path_add_rect':
          'void Function(Pointer<Void>, double, double, double, double) get dn_path_add_rect',
      'dn_canvas_save': 'void Function(Pointer<Void>) get dn_canvas_save',
      'dn_canvas_restore': 'void Function(Pointer<Void>) get dn_canvas_restore',
      'dn_canvas_translate':
          'void Function(Pointer<Void>, double, double) get dn_canvas_translate',
      'dn_canvas_scale':
          'void Function(Pointer<Void>, double, double) get dn_canvas_scale',
      'dn_canvas_rotate':
          'void Function(Pointer<Void>, double) get dn_canvas_rotate',
      'dn_canvas_clear':
          'void Function(Pointer<Void>, int) get dn_canvas_clear',
      'dn_canvas_draw_paint':
          'void Function(Pointer<Void>, Pointer<Void>) get dn_canvas_draw_paint',
      'dn_canvas_draw_rect':
          'void Function(Pointer<Void>, double, double, double, double, Pointer<Void>) get dn_canvas_draw_rect',
      'dn_canvas_draw_rrect':
          'void Function(Pointer<Void>, double, double, double, double, double, double, Pointer<Void>) get dn_canvas_draw_rrect',
      'dn_canvas_draw_circle':
          'void Function(Pointer<Void>, double, double, double, Pointer<Void>) get dn_canvas_draw_circle',
      'dn_canvas_draw_line':
          'void Function(Pointer<Void>, double, double, double, double, Pointer<Void>) get dn_canvas_draw_line',
      'dn_canvas_draw_path':
          'void Function(Pointer<Void>, Pointer<Void>, Pointer<Void>) get dn_canvas_draw_path',
      'dn_canvas_draw_arc':
          'void Function(Pointer<Void>, double, double, double, double, double, double, bool, Pointer<Void>) get dn_canvas_draw_arc',
      'dn_canvas_draw_text':
          'void Function(Pointer<Void>, Pointer<Uint8>, double, double, double, double, Pointer<Void>) get dn_canvas_draw_text',
      'dn_measure_text':
          'int Function(Pointer<Uint8>, double, double, Pointer<Float>, Pointer<Float>) get dn_measure_text',
      'dn_canvas_clip_rect':
          'void Function(Pointer<Void>, double, double, double, double) get dn_canvas_clip_rect',
      'dn_canvas_clip_rrect':
          'void Function(Pointer<Void>, double, double, double, double, double, double) get dn_canvas_clip_rrect',
      'dn_canvas_clip_path':
          'void Function(Pointer<Void>, Pointer<Void>) get dn_canvas_clip_path',
      'dn_canvas_save_layer':
          'void Function(Pointer<Void>, double, double, double, double, Pointer<Void>) get dn_canvas_save_layer',
      'dn_image_filter_blur_create':
          'Pointer<Void> Function(double, double) get dn_image_filter_blur_create',
      'dn_image_filter_destroy':
          'void Function(Pointer<Void>) get dn_image_filter_destroy',
      'dn_runtime_effect_make':
          'Pointer<Void> Function(Pointer<Uint8>, int, Pointer<Uint8>, int) get dn_runtime_effect_make',
      'dn_runtime_effect_destroy':
          'void Function(Pointer<Void>) get dn_runtime_effect_destroy',
      'dn_runtime_effect_make_shader':
          'Pointer<Void> Function(Pointer<Void>, Pointer<Float>, int) get dn_runtime_effect_make_shader',
      'dn_runtime_effect_make_shader_with_children':
          'Pointer<Void> Function(Pointer<Void>, Pointer<Float>, int, Pointer<Pointer<Void>>, int) get dn_runtime_effect_make_shader_with_children',
      'dn_image_make_raster_from_encoded':
          'Pointer<Void> Function(Pointer<Uint8>, int, Pointer<Int32>, Pointer<Int32>) get dn_image_make_raster_from_encoded',
      'dn_image_unref': 'void Function(Pointer<Void>) get dn_image_unref',
      'dn_image_width': 'int Function(Pointer<Void>) get dn_image_width',
      'dn_image_height': 'int Function(Pointer<Void>) get dn_image_height',
      'dn_image_make_shader':
          'Pointer<Void> Function(Pointer<Void>) get dn_image_make_shader',
      'dn_canvas_draw_image_rect':
          'void Function(Pointer<Void>, Pointer<Void>, double, double, double, double, Pointer<Void>) get dn_canvas_draw_image_rect',
      'dn_shader_linear_gradient':
          'Pointer<Void> Function(double, double, double, double, Pointer<Uint32>, Pointer<Float>, int) get dn_shader_linear_gradient',
      'dn_shader_radial_gradient':
          'Pointer<Void> Function(double, double, double, Pointer<Uint32>, Pointer<Float>, int) get dn_shader_radial_gradient',
      'dn_shader_unref': 'void Function(Pointer<Void>) get dn_shader_unref',
      'dn_image_read_pixels':
          'bool Function(Pointer<Void>, Pointer<Uint8>, int, int) get dn_image_read_pixels',
      'dn_surface_create_raster':
          'Pointer<Void> Function(int, int) get dn_surface_create_raster',
      'dn_surface_get_canvas':
          'Pointer<Void> Function(Pointer<Void>) get dn_surface_get_canvas',
      'dn_surface_snapshot':
          'Pointer<Void> Function(Pointer<Void>) get dn_surface_snapshot',
      'dn_surface_read_pixels':
          'bool Function(Pointer<Void>, Pointer<Uint8>, int, int) get dn_surface_read_pixels',
      'dn_surface_destroy':
          'void Function(Pointer<Void>) get dn_surface_destroy',
    },
    staticGetterSignatures: {
      'instance': 'SkiaBindings get instance',
    },
  );
}

// =============================================================================
// TextParticleEffect Bridge
// =============================================================================

BridgedClass _createTextParticleEffectBridge() {
  return BridgedClass(
    nativeType: $dartnative_skia_4.TextParticleEffect,
    name: 'TextParticleEffect',
    isAssignable: (v) => v is $dartnative_skia_4.TextParticleEffect,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final text = D4.getRequiredNamedArg<String>(
          named,
          'text',
          'TextParticleEffect',
        );
        final fontSize = D4.getNamedArgWithDefault<double>(
          named,
          'fontSize',
          120,
        );
        final textureWidth = D4.getNamedArgWithDefault<int>(
          named,
          'textureWidth',
          400,
        );
        final textureHeight = D4.getNamedArgWithDefault<int>(
          named,
          'textureHeight',
          260,
        );
        final textColor = D4.getNamedArgWithDefault<$dartnative_3.Color>(
          named,
          'textColor',
          const $dartnative_3.Color(0xFFFFFFFF),
        );
        final backgroundColor = D4.getNamedArgWithDefault<$dartnative_3.Color>(
          named,
          'backgroundColor',
          const $dartnative_3.Color(0xFF0A0A1A),
        );
        final period = D4.getNamedArgWithDefault<double>(named, 'period', 10.0);
        final textOffset = D4.getNamedArgWithDefault<$dartnative_3.Offset>(
          named,
          'textOffset',
          const $dartnative_3.Offset(40, 50),
        );
        final sampleStep = D4.getNamedArgWithDefault<int>(
          named,
          'sampleStep',
          1,
        );
        final brightnessThreshold = D4.getNamedArgWithDefault<int>(
          named,
          'brightnessThreshold',
          48,
        );
        return $dartnative_skia_4.TextParticleEffect(
          text: text,
          fontSize: fontSize,
          textureWidth: textureWidth,
          textureHeight: textureHeight,
          textColor: textColor,
          backgroundColor: backgroundColor,
          period: period,
          textOffset: textOffset,
          sampleStep: sampleStep,
          brightnessThreshold: brightnessThreshold,
        );
      },
    },
    getters: {
      'repaint': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .repaint,
      'text': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .text,
      'fontSize': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .fontSize,
      'textureWidth': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .textureWidth,
      'textureHeight': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .textureHeight,
      'textColor': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .textColor,
      'backgroundColor': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .backgroundColor,
      'period': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .period,
      'textOffset': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .textOffset,
      'sampleStep': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .sampleStep,
      'brightnessThreshold': (visitor, target) => D4
          .validateTarget<$dartnative_skia_4.TextParticleEffect>(
            target,
            'TextParticleEffect',
          )
          .brightnessThreshold,
    },
    methods: {
      'paint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_4.TextParticleEffect>(
          target,
          'TextParticleEffect',
        );
        D4.requireMinArgs(positional, 2, 'paint');
        final canvas = D4.getRequiredArg<$dartnative_6.Canvas>(
          positional,
          0,
          'canvas',
          'paint',
        );
        final size = D4.getRequiredArg<$dartnative_3.Size>(
          positional,
          1,
          'size',
          'paint',
        );
        t.paint(canvas, size);
        return null;
      },
      'preferredHeight': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_4.TextParticleEffect>(
          target,
          'TextParticleEffect',
        );
        D4.requireMinArgs(positional, 1, 'preferredHeight');
        final availableWidth = D4.getRequiredArg<double>(
          positional,
          0,
          'availableWidth',
          'preferredHeight',
        );
        return t.preferredHeight(availableWidth);
      },
      'shouldRepaint': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_skia_4.TextParticleEffect>(
          target,
          'TextParticleEffect',
        );
        D4.requireMinArgs(positional, 1, 'shouldRepaint');
        final oldDelegate = D4.getRequiredArg<$dartnative_6.CustomPainter>(
          positional,
          0,
          'oldDelegate',
          'shouldRepaint',
        );
        return t.shouldRepaint(oldDelegate);
      },
    },
    constructorSignatures: {
      '': 'TextParticleEffect({required String text, double fontSize = 120, int textureWidth = 400, int textureHeight = 260, Color textColor = const Color(0xFFFFFFFF), Color backgroundColor = const Color(0xFF0A0A1A), double period = 10.0, Offset textOffset = const Offset(40, 50), int sampleStep = 1, int brightnessThreshold = 48})',
    },
    methodSignatures: {
      'paint': 'void paint(Canvas canvas, Size size)',
      'preferredHeight': 'double? preferredHeight(double availableWidth)',
      'shouldRepaint': 'bool shouldRepaint(CustomPainter oldDelegate)',
    },
    getterSignatures: {
      'repaint': 'Listenable? get repaint',
      'text': 'String get text',
      'fontSize': 'double get fontSize',
      'textureWidth': 'int get textureWidth',
      'textureHeight': 'int get textureHeight',
      'textColor': 'Color get textColor',
      'backgroundColor': 'Color get backgroundColor',
      'period': 'double get period',
      'textOffset': 'Offset get textOffset',
      'sampleStep': 'int get sampleStep',
      'brightnessThreshold': 'int get brightnessThreshold',
    },
  );
}

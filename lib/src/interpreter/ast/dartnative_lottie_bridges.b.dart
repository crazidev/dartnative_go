// D4rt Bridge - Generated file, do not edit
// Sources: 5 files
// Generated: 2026-11-24T16:25:59.800656 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';

import 'package:dartnative/src/core.dart' as $dartnative_1;
import 'package:dartnative/src/painting.dart' as $dartnative_2;
import 'package:dartnative_lottie/src/lottie.dart' as $dartnative_lottie_1;
import 'package:dartnative_lottie/src/lottie_cache.dart'
    as $dartnative_lottie_2;
import 'package:dartnative_lottie/src/lottie_census.dart'
    as $dartnative_lottie_3;
import 'package:dartnative_lottie/src/lottie_ffi_bindings.dart'
    as $dartnative_lottie_4;
import 'package:dartnative_lottie/src/lottie_prewarm.dart'
    as $dartnative_lottie_5;

/// Bridge class for dartnative_lottie module.
class DartnativeLottieBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createLottieControllerBridge(),
      _createLottieBridge(),
      _createLottieCacheBridge(),
      _createLottieCensusBridge(),
      _createLottieFFIBindingsBridge(),
      _createLottiePreWarmBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'LottieController': _createLottieControllerBridge,
      'Lottie': _createLottieBridge,
      'LottieCache': _createLottieCacheBridge,
      'LottieCensus': _createLottieCensusBridge,
      'LottieFFIBindings': _createLottieFFIBindingsBridge,
      'LottiePreWarm': _createLottiePreWarmBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'LottieController': $dartnative_lottie_1.LottieController,
      'Lottie': $dartnative_lottie_1.Lottie,
      'LottieCache': $dartnative_lottie_2.LottieCache,
      'LottieCensus': $dartnative_lottie_3.LottieCensus,
      'LottieFFIBindings': $dartnative_lottie_4.LottieFFIBindings,
      'LottiePreWarm': $dartnative_lottie_5.LottiePreWarm,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'LottieController': 'package:dartnative_lottie/src/lottie.dart',
      'Lottie': 'package:dartnative_lottie/src/lottie.dart',
      'LottieCache': 'package:dartnative_lottie/src/lottie_cache.dart',
      'LottieCensus': 'package:dartnative_lottie/src/lottie_census.dart',
      'LottieFFIBindings':
          'package:dartnative_lottie/src/lottie_ffi_bindings.dart',
      'LottiePreWarm': 'package:dartnative_lottie/src/lottie_prewarm.dart',
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
      'LottieController': ['ChangeNotifier', 'Listenable'],
      'Lottie': ['StatelessWidget', 'Widget'],
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
      BridgedEnumDefinition<$dartnative_lottie_1.LottieLoopMode>(
        name: 'LottieLoopMode',
        values: $dartnative_lottie_1.LottieLoopMode.values,
      ),
      BridgedEnumDefinition<$dartnative_lottie_1.LottieFit>(
        name: 'LottieFit',
        values: $dartnative_lottie_1.LottieFit.values,
      ),
      BridgedEnumDefinition<$dartnative_lottie_1.LottieCachePolicy>(
        name: 'LottieCachePolicy',
        values: $dartnative_lottie_1.LottieCachePolicy.values,
      ),
      BridgedEnumDefinition<$dartnative_lottie_1.RenderCache>(
        name: 'RenderCache',
        values: $dartnative_lottie_1.RenderCache.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'LottieLoopMode': 'package:dartnative_lottie/src/lottie.dart',
      'LottieFit': 'package:dartnative_lottie/src/lottie.dart',
      'LottieCachePolicy': 'package:dartnative_lottie/src/lottie.dart',
      'RenderCache': 'package:dartnative_lottie/src/lottie.dart',
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
        source: 'package:dartnative_lottie/dartnative_lottie.dart',
        target: 'package:dartnative_lottie/src/lottie.dart',
        show: {
          'Lottie',
          'LottieController',
          'LottieCachePolicy',
          'LottieLoopMode',
          'LottieFit',
          'RenderCache',
        },
        hide: null,
      ),
      (
        source: 'package:dartnative_lottie/dartnative_lottie.dart',
        target: 'package:dartnative_lottie/src/lottie_cache.dart',
        show: {'LottieCache'},
        hide: null,
      ),
      (
        source: 'package:dartnative_lottie/dartnative_lottie.dart',
        target: 'package:dartnative_lottie/src/lottie_census.dart',
        show: {'LottieCensus'},
        hide: null,
      ),
      (
        source: 'package:dartnative_lottie/dartnative_lottie.dart',
        target: 'package:dartnative_lottie/src/lottie_ffi_bindings.dart',
        show: {'LottieFFIBindings'},
        hide: null,
      ),
      (
        source: 'package:dartnative_lottie/dartnative_lottie.dart',
        target: 'package:dartnative_lottie/src/lottie_prewarm.dart',
        show: {'LottiePreWarm'},
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
      'package:dartnative_lottie/src/lottie.dart',
      'package:dartnative_lottie/src/lottie_cache.dart',
      'package:dartnative_lottie/src/lottie_census.dart',
      'package:dartnative_lottie/src/lottie_ffi_bindings.dart',
      'package:dartnative_lottie/src/lottie_prewarm.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_lottie/dartnative_lottie.dart';";
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
    'LottieLoopMode',
    'LottieFit',
    'LottieCachePolicy',
    'RenderCache',
  ];
}

// =============================================================================
// LottieController Bridge
// =============================================================================

BridgedClass _createLottieControllerBridge() {
  return BridgedClass(
    nativeType: $dartnative_lottie_1.LottieController,
    name: 'LottieController',
    isAssignable: (v) => v is $dartnative_lottie_1.LottieController,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_lottie_1.LottieController();
      },
    },
    getters: {
      'progress': (visitor, target) => D4
          .validateTarget<$dartnative_lottie_1.LottieController>(
            target,
            'LottieController',
          )
          .progress,
    },
    methods: {
      'play': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
        );
        t.play();
        return null;
      },
      'pause': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
        );
        t.pause();
        return null;
      },
      'stop': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
        );
        t.stop();
        return null;
      },
      'setProgress': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
        );
        D4.requireMinArgs(positional, 1, 'setProgress');
        final value = D4.getRequiredArg<double>(
          positional,
          0,
          'value',
          'setProgress',
        );
        t.setProgress(value);
        return null;
      },
      'setSpeed': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
        );
        D4.requireMinArgs(positional, 1, 'setSpeed');
        final speed = D4.getRequiredArg<double>(
          positional,
          0,
          'speed',
          'setSpeed',
        );
        t.setSpeed(speed);
        return null;
      },
      'setLoopMode': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
        );
        D4.requireMinArgs(positional, 1, 'setLoopMode');
        final mode = D4.getRequiredArg<$dartnative_lottie_1.LottieLoopMode>(
          positional,
          0,
          'mode',
          'setLoopMode',
        );
        t.setLoopMode(mode);
        return null;
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
        );
        (t as dynamic).dispose();
        return null;
      },
      'addListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
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
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
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
        final t = D4.validateTarget<$dartnative_lottie_1.LottieController>(
          target,
          'LottieController',
        );
        t.notifyListeners();
        return null;
      },
    },
    constructorSignatures: {
      '': 'LottieController()',
    },
    methodSignatures: {
      'play': 'void play()',
      'pause': 'void pause()',
      'stop': 'void stop()',
      'setProgress': 'void setProgress(double value)',
      'setSpeed': 'void setSpeed(double speed)',
      'setLoopMode': 'void setLoopMode(LottieLoopMode mode)',
      'dispose': 'void dispose()',
      'addListener': 'void addListener(VoidCallback listener)',
      'removeListener': 'void removeListener(VoidCallback listener)',
      'notifyListeners': 'void notifyListeners()',
    },
    getterSignatures: {
      'progress': 'ValueNotifier<double> get progress',
    },
  );
}

// =============================================================================
// Lottie Bridge
// =============================================================================

BridgedClass _createLottieBridge() {
  return BridgedClass(
    nativeType: $dartnative_lottie_1.Lottie,
    name: 'Lottie',
    isAssignable: (v) => v is $dartnative_lottie_1.Lottie,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final asset = D4.getOptionalNamedArg<String?>(named, 'asset');
        final json = D4.getOptionalNamedArg<String?>(named, 'json');
        final url = D4.getOptionalNamedArg<String?>(named, 'url');
        final cachePolicy = D4
            .getNamedArgWithDefault<$dartnative_lottie_1.LottieCachePolicy>(
              named,
              'cachePolicy',
              $dartnative_lottie_1.LottieCachePolicy.disk,
            );
        final loop = D4.getNamedArgWithDefault<bool>(named, 'loop', false);
        final autoplay = D4.getNamedArgWithDefault<bool>(
          named,
          'autoplay',
          true,
        );
        final speed = D4.getNamedArgWithDefault<double>(named, 'speed', 1.0);
        final fit = D4.getNamedArgWithDefault<$dartnative_lottie_1.LottieFit>(
          named,
          'fit',
          $dartnative_lottie_1.LottieFit.contain,
        );
        final controller = D4
            .getOptionalNamedArg<$dartnative_lottie_1.LottieController?>(
              named,
              'controller',
            );
        final renderCache = D4
            .getNamedArgWithDefault<$dartnative_lottie_1.RenderCache>(
              named,
              'renderCache',
              $dartnative_lottie_1.RenderCache.none,
            );
        final placeholder = D4.getOptionalNamedArg<$dartnative_1.Widget?>(
          named,
          'placeholder',
        );
        return $dartnative_lottie_1.Lottie(
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
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final cachePolicy = D4
            .getNamedArgWithDefault<$dartnative_lottie_1.LottieCachePolicy>(
              named,
              'cachePolicy',
              $dartnative_lottie_1.LottieCachePolicy.disk,
            );
        final loop = D4.getNamedArgWithDefault<bool>(named, 'loop', false);
        final autoplay = D4.getNamedArgWithDefault<bool>(
          named,
          'autoplay',
          true,
        );
        final speed = D4.getNamedArgWithDefault<double>(named, 'speed', 1.0);
        final fit = D4.getNamedArgWithDefault<$dartnative_lottie_1.LottieFit>(
          named,
          'fit',
          $dartnative_lottie_1.LottieFit.contain,
        );
        final controller = D4
            .getOptionalNamedArg<$dartnative_lottie_1.LottieController?>(
              named,
              'controller',
            );
        final renderCache = D4
            .getNamedArgWithDefault<$dartnative_lottie_1.RenderCache>(
              named,
              'renderCache',
              $dartnative_lottie_1.RenderCache.none,
            );
        final placeholder = D4.getOptionalNamedArg<$dartnative_1.Widget?>(
          named,
          'placeholder',
        );
        return $dartnative_lottie_1.Lottie.network(
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
      'asset': (visitor, target) => D4
          .validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie')
          .asset,
      'json': (visitor, target) =>
          D4.validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie').json,
      'url': (visitor, target) =>
          D4.validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie').url,
      'cachePolicy': (visitor, target) => D4
          .validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie')
          .cachePolicy,
      'loop': (visitor, target) =>
          D4.validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie').loop,
      'autoplay': (visitor, target) => D4
          .validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie')
          .autoplay,
      'speed': (visitor, target) => D4
          .validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie')
          .speed,
      'fit': (visitor, target) =>
          D4.validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie').fit,
      'controller': (visitor, target) =>
          (D4.validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie')
                  as dynamic)
              .controller,
      'renderCache': (visitor, target) => D4
          .validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie')
          .renderCache,
      'placeholder': (visitor, target) => D4
          .validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie')
          .placeholder,
      'key': (visitor, target) =>
          D4.validateTarget<$dartnative_lottie_1.Lottie>(target, 'Lottie').key,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_lottie_1.Lottie>(
          target,
          'Lottie',
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
    },
    constructorSignatures: {
      '': 'const Lottie({Key? key, String? asset, String? json, String? url, LottieCachePolicy cachePolicy = LottieCachePolicy.disk, bool loop = false, bool autoplay = true, double speed = 1.0, LottieFit fit = LottieFit.contain, LottieController? controller, RenderCache renderCache = RenderCache.none, Widget? placeholder})',
      'network':
          'factory Lottie.network(String url, {Key? key, LottieCachePolicy cachePolicy = LottieCachePolicy.disk, bool loop = false, bool autoplay = true, double speed = 1.0, LottieFit fit = LottieFit.contain, LottieController? controller, RenderCache renderCache = RenderCache.none, Widget? placeholder})',
    },
    methodSignatures: {
      'build': 'Widget build(BuildContext context)',
    },
    getterSignatures: {
      'asset': 'String? get asset',
      'json': 'String? get json',
      'url': 'String? get url',
      'cachePolicy': 'LottieCachePolicy get cachePolicy',
      'loop': 'bool get loop',
      'autoplay': 'bool get autoplay',
      'speed': 'double get speed',
      'fit': 'LottieFit get fit',
      'controller': 'LottieController? get controller',
      'renderCache': 'RenderCache get renderCache',
      'placeholder': 'Widget? get placeholder',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// LottieCache Bridge
// =============================================================================

BridgedClass _createLottieCacheBridge() {
  return BridgedClass(
    nativeType: $dartnative_lottie_2.LottieCache,
    name: 'LottieCache',
    isAssignable: (v) => v is $dartnative_lottie_2.LottieCache,
    constructors: {},
    staticGetters: {
      'maximumSize': (visitor) => $dartnative_lottie_2.LottieCache.maximumSize,
      'storagePath': (visitor) => $dartnative_lottie_2.LottieCache.storagePath,
      'onNativeWarm': (visitor) =>
          $dartnative_lottie_2.LottieCache.onNativeWarm,
      'downloadProgress': (visitor) =>
          $dartnative_lottie_2.LottieCache.downloadProgress,
      'progressStream': (visitor) =>
          $dartnative_lottie_2.LottieCache.progressStream,
    },
    staticMethods: {
      'preload': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'preload');
        if (positional.isEmpty) {
          throw ArgumentError(
            'preload: Missing required argument "urls" at position 0',
          );
        }
        final urls = D4.coerceList<String>(positional[0], 'urls');
        return $dartnative_lottie_2.LottieCache.preload(urls);
      },
      'filePath': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'filePath');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'filePath');
        return $dartnative_lottie_2.LottieCache.filePath(url);
      },
      'resolve': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'resolve');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'resolve');
        return $dartnative_lottie_2.LottieCache.resolve(url);
      },
      'isFullyCached': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'isFullyCached');
        if (positional.isEmpty) {
          throw ArgumentError(
            'isFullyCached: Missing required argument "urls" at position 0',
          );
        }
        final urls = D4.coerceList<String>(positional[0], 'urls');
        return $dartnative_lottie_2.LottieCache.isFullyCached(urls);
      },
      'warmNativeCache': (visitor, positional, named, typeArgs) {
        return $dartnative_lottie_2.LottieCache.warmNativeCache();
      },
      'clear': (visitor, positional, named, typeArgs) {
        return $dartnative_lottie_2.LottieCache.clear();
      },
      'fetchJsonNoPersist': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'fetchJsonNoPersist');
        final url = D4.getRequiredArg<String>(
          positional,
          0,
          'url',
          'fetchJsonNoPersist',
        );
        return $dartnative_lottie_2.LottieCache.fetchJsonNoPersist(url);
      },
    },
    staticSetters: {
      'maximumSize': (visitor, value) =>
          $dartnative_lottie_2.LottieCache.maximumSize = D4
              .extractBridgedArg<int>(value, 'maximumSize'),
      'storagePath': (visitor, value) =>
          $dartnative_lottie_2.LottieCache.storagePath = D4
              .extractBridgedArgOrNull<String>(value, 'storagePath'),
      'onNativeWarm': (visitor, value) {
        final onNativeWarmRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'onNativeWarm',
        );
        $dartnative_lottie_2.LottieCache.onNativeWarm = onNativeWarmRaw == null
            ? null
            : (List<String> p0) {
                D4.callInterpreterCallback(visitor!, onNativeWarmRaw, [p0]);
              };
      },
    },
    staticMethodSignatures: {
      'preload': 'void preload(List<String> urls)',
      'filePath': 'String? filePath(String url)',
      'resolve': 'Future<String?> resolve(String url)',
      'isFullyCached': 'bool isFullyCached(List<String> urls)',
      'warmNativeCache': 'void warmNativeCache()',
      'clear': 'void clear()',
      'fetchJsonNoPersist': 'Future<String?> fetchJsonNoPersist(String url)',
    },
    staticGetterSignatures: {
      'maximumSize': 'int get maximumSize',
      'storagePath': 'String? get storagePath',
      'onNativeWarm': 'void Function(List<String> paths)? get onNativeWarm',
      'downloadProgress': 'double get downloadProgress',
      'progressStream': 'Stream<double> get progressStream',
    },
    staticSetterSignatures: {
      'maximumSize': 'set maximumSize(dynamic value)',
      'storagePath': 'set storagePath(dynamic value)',
      'onNativeWarm': 'set onNativeWarm(dynamic value)',
    },
  );
}

// =============================================================================
// LottieCensus Bridge
// =============================================================================

BridgedClass _createLottieCensusBridge() {
  return BridgedClass(
    nativeType: $dartnative_lottie_3.LottieCensus,
    name: 'LottieCensus',
    isAssignable: (v) => v is $dartnative_lottie_3.LottieCensus,
    constructors: {},
    staticMethods: {
      'report': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'report');
        final label = D4.getRequiredArg<String>(
          positional,
          0,
          'label',
          'report',
        );
        return $dartnative_lottie_3.LottieCensus.report(label);
      },
      'resetSlots': (visitor, positional, named, typeArgs) {
        return $dartnative_lottie_3.LottieCensus.resetSlots();
      },
    },
    staticMethodSignatures: {
      'report': 'void report(String label)',
      'resetSlots': 'void resetSlots()',
    },
  );
}

// =============================================================================
// LottieFFIBindings Bridge
// =============================================================================

BridgedClass _createLottieFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_lottie_4.LottieFFIBindings,
    name: 'LottieFFIBindings',
    isAssignable: (v) => v is $dartnative_lottie_4.LottieFFIBindings,
    constructors: {},
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_lottie_4.LottieFFIBindings.loadSymbols();
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
  );
}

// =============================================================================
// LottiePreWarm Bridge
// =============================================================================

BridgedClass _createLottiePreWarmBridge() {
  return BridgedClass(
    nativeType: $dartnative_lottie_5.LottiePreWarm,
    name: 'LottiePreWarm',
    isAssignable: (v) => v is $dartnative_lottie_5.LottiePreWarm,
    constructors: {},
    staticMethods: {
      'warmAssets': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'warmAssets');
        if (positional.isEmpty) {
          throw ArgumentError(
            'warmAssets: Missing required argument "assetPaths" at position 0',
          );
        }
        final assetPaths = D4.coerceList<String>(positional[0], 'assetPaths');
        final size = D4.getOptionalNamedArg<$dartnative_2.Size?>(named, 'size');
        final renderCache = D4
            .getNamedArgWithDefault<$dartnative_lottie_1.RenderCache>(
              named,
              'renderCache',
              $dartnative_lottie_1.RenderCache.none,
            );
        final onProgressRaw = named['onProgress'];
        final onProgress = onProgressRaw == null
            ? null
            : (int p0, int p1) {
                D4.callInterpreterCallback(visitor!, onProgressRaw, [p0, p1]);
              };
        return $dartnative_lottie_5.LottiePreWarm.warmAssets(
          assetPaths,
          size: size,
          renderCache: renderCache,
          onProgress: onProgress,
        );
      },
    },
    staticMethodSignatures: {
      'warmAssets':
          'Future<void> warmAssets(List<String> assetPaths, {Size? size, RenderCache renderCache = RenderCache.none, void Function(int done, int total)? onProgress})',
    },
  );
}

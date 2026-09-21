// D4rt Bridge - Generated file, do not edit
// Sources: 5 files
// Generated: 2026-09-21T20:32:05.404708 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'package:dartnative/dartnative.dart' as $flutter_widgets;

import 'package:native_bottomsheet/src/ffi_bindings.dart' as $native_bottomsheet_1;
import 'package:native_bottomsheet/src/sheet_controller.dart' as $native_bottomsheet_2;
import 'package:native_bottomsheet/src/sheet_detent.dart' as $native_bottomsheet_3;
import 'package:native_bottomsheet/src/sheet_platform_config.dart' as $native_bottomsheet_4;
import 'package:native_bottomsheet/src/show_bottom_sheet.dart' as $native_bottomsheet_5;

/// Bridge class for native_bottomsheet module.
class NativeBottomsheetBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createDNSheetDetentBridge(),
      _createDNSheetControllerBridge(),
      _createDNSheetIOSConfigBridge(),
      _createDNSheetAndroidConfigBridge(),
      _createDNSheetPlatformConfigBridge(),
      _createBottomSheetFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'DNSheetDetent': _createDNSheetDetentBridge,
      'DNSheetController': _createDNSheetControllerBridge,
      'DNSheetIOSConfig': _createDNSheetIOSConfigBridge,
      'DNSheetAndroidConfig': _createDNSheetAndroidConfigBridge,
      'DNSheetPlatformConfig': _createDNSheetPlatformConfigBridge,
      'BottomSheetFFIBindings': _createBottomSheetFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'DNSheetDetent': $native_bottomsheet_3.DNSheetDetent,
      'DNSheetController': $native_bottomsheet_2.DNSheetController,
      'DNSheetIOSConfig': $native_bottomsheet_4.DNSheetIOSConfig,
      'DNSheetAndroidConfig': $native_bottomsheet_4.DNSheetAndroidConfig,
      'DNSheetPlatformConfig': $native_bottomsheet_4.DNSheetPlatformConfig,
      'BottomSheetFFIBindings': $native_bottomsheet_1.BottomSheetFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'DNSheetDetent': 'package:native_bottomsheet/src/sheet_detent.dart',
      'DNSheetController': 'package:native_bottomsheet/src/sheet_controller.dart',
      'DNSheetIOSConfig': 'package:native_bottomsheet/src/sheet_platform_config.dart',
      'DNSheetAndroidConfig': 'package:native_bottomsheet/src/sheet_platform_config.dart',
      'DNSheetPlatformConfig': 'package:native_bottomsheet/src/sheet_platform_config.dart',
      'BottomSheetFFIBindings': 'package:native_bottomsheet/src/ffi_bindings.dart',
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
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$native_bottomsheet_4.DNSecureFlagPolicy>(
        name: 'DNSecureFlagPolicy',
        values: $native_bottomsheet_4.DNSecureFlagPolicy.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'DNSecureFlagPolicy': 'package:native_bottomsheet/src/sheet_platform_config.dart',
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
      (source: 'package:native_bottomsheet/native_bottomsheet.dart', target: 'package:native_bottomsheet/src/sheet_detent.dart', show: null, hide: null),
      (source: 'package:native_bottomsheet/native_bottomsheet.dart', target: 'package:native_bottomsheet/src/sheet_controller.dart', show: null, hide: null),
      (source: 'package:native_bottomsheet/native_bottomsheet.dart', target: 'package:native_bottomsheet/src/sheet_platform_config.dart', show: null, hide: null),
      (source: 'package:native_bottomsheet/native_bottomsheet.dart', target: 'package:native_bottomsheet/src/show_bottom_sheet.dart', show: null, hide: null),
      (source: 'package:native_bottomsheet/native_bottomsheet.dart', target: 'package:native_bottomsheet/src/ffi_bindings.dart', show: {'BottomSheetFFIBindings'}, hide: null),
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

    // GEN-107: Register library re-exports
    for (final r in bridgeReExports()) {
      interpreter.registerLibraryReExport(r.source, r.target, show: r.show, hide: r.hide);
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {
      'showBottomSheet': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'showBottomSheet');
        final context = D4.getRequiredArg<dynamic>(positional, 0, 'context', 'showBottomSheet');
        final builderRaw = named['builder'];
        if (builderRaw == null) {
          throw ArgumentError('showBottomSheet: Missing required named argument "builder"');
        }
        final dynamic builder = (dynamic p0, $native_bottomsheet_2.DNSheetController p1) { return D4.extractBridgedArg<$flutter_widgets.Widget>(D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1]), 'builder', visitor); };
        final initialDetent = D4.getOptionalNamedArg<$native_bottomsheet_3.DNSheetDetent?>(named, 'initialDetent');
        final showGrabber = D4.getNamedArgWithDefault<bool>(named, 'showGrabber', true);
        final cornerRadius = D4.getOptionalNamedArg<double?>(named, 'cornerRadius');
        final scrimOpacity = D4.getOptionalNamedArg<double?>(named, 'scrimOpacity');
        final adaptToContainerBackground = D4.getNamedArgWithDefault<bool>(named, 'adaptToContainerBackground', true);
        final isDismissable = D4.getNamedArgWithDefault<bool>(named, 'isDismissable', true);
        final scrollExpandsSheet = D4.getNamedArgWithDefault<bool>(named, 'scrollExpandsSheet', true);
        final routerEnabled = D4.getNamedArgWithDefault<bool>(named, 'routerEnabled', false);
        final onDetentChangedRaw = named['onDetentChanged'];
        final onDetentChanged = onDetentChangedRaw == null ? null : ($native_bottomsheet_3.DNSheetDetent p0) { D4.callInterpreterCallback(visitor!, onDetentChangedRaw, [p0]); };
        final onPresentedRaw = named['onPresented'];
        final onPresented = onPresentedRaw == null ? null : () { D4.callInterpreterCallback(visitor!, onPresentedRaw, []); };
        final onDismissedRaw = named['onDismissed'];
        final onDismissed = onDismissedRaw == null ? null : () { D4.callInterpreterCallback(visitor!, onDismissedRaw, []); };
        final onDismissAttemptedRaw = named['onDismissAttempted'];
        final onDismissAttempted = onDismissAttemptedRaw == null ? null : () { D4.callInterpreterCallback(visitor!, onDismissAttemptedRaw, []); };
        final platformConfig = D4.getOptionalNamedArg<$native_bottomsheet_4.DNSheetPlatformConfig?>(named, 'platformConfig');
        if (!named.containsKey('detents') && !named.containsKey('backgroundColor')) {
          return $native_bottomsheet_5.showBottomSheet(context, builder: builder, initialDetent: initialDetent, showGrabber: showGrabber, cornerRadius: cornerRadius, scrimOpacity: scrimOpacity, adaptToContainerBackground: adaptToContainerBackground, isDismissable: isDismissable, scrollExpandsSheet: scrollExpandsSheet, routerEnabled: routerEnabled, onDetentChanged: onDetentChanged, onPresented: onPresented, onDismissed: onDismissed, onDismissAttempted: onDismissAttempted, platformConfig: platformConfig);
        }
        if (named.containsKey('detents') && !named.containsKey('backgroundColor')) {
          final detents = D4.coerceList<$native_bottomsheet_3.DNSheetDetent>(named['detents'], 'detents');
          return $native_bottomsheet_5.showBottomSheet(context, builder: builder, initialDetent: initialDetent, showGrabber: showGrabber, cornerRadius: cornerRadius, scrimOpacity: scrimOpacity, adaptToContainerBackground: adaptToContainerBackground, isDismissable: isDismissable, scrollExpandsSheet: scrollExpandsSheet, routerEnabled: routerEnabled, onDetentChanged: onDetentChanged, onPresented: onPresented, onDismissed: onDismissed, onDismissAttempted: onDismissAttempted, platformConfig: platformConfig, detents: detents);
        }
        if (!named.containsKey('detents') && named.containsKey('backgroundColor')) {
          final backgroundColor = D4.getRequiredNamedArg<dynamic>(named, 'backgroundColor', 'showBottomSheet');
          return $native_bottomsheet_5.showBottomSheet(context, builder: builder, initialDetent: initialDetent, showGrabber: showGrabber, cornerRadius: cornerRadius, scrimOpacity: scrimOpacity, adaptToContainerBackground: adaptToContainerBackground, isDismissable: isDismissable, scrollExpandsSheet: scrollExpandsSheet, routerEnabled: routerEnabled, onDetentChanged: onDetentChanged, onPresented: onPresented, onDismissed: onDismissed, onDismissAttempted: onDismissAttempted, platformConfig: platformConfig, backgroundColor: backgroundColor);
        }
        if (named.containsKey('detents') && named.containsKey('backgroundColor')) {
          final detents = D4.coerceList<$native_bottomsheet_3.DNSheetDetent>(named['detents'], 'detents');
          final backgroundColor = D4.getRequiredNamedArg<dynamic>(named, 'backgroundColor', 'showBottomSheet');
          return $native_bottomsheet_5.showBottomSheet(context, builder: builder, initialDetent: initialDetent, showGrabber: showGrabber, cornerRadius: cornerRadius, scrimOpacity: scrimOpacity, adaptToContainerBackground: adaptToContainerBackground, isDismissable: isDismissable, scrollExpandsSheet: scrollExpandsSheet, routerEnabled: routerEnabled, onDetentChanged: onDetentChanged, onPresented: onPresented, onDismissed: onDismissed, onDismissAttempted: onDismissAttempted, platformConfig: platformConfig, detents: detents, backgroundColor: backgroundColor);
        }
        throw StateError('Unreachable: all named parameter combinations should be covered');
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'showBottomSheet': 'package:native_bottomsheet/src/show_bottom_sheet.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'showBottomSheet': 'DNSheetController showBottomSheet(dynamic context, {required InvalidType Function(dynamic context, DNSheetController controller) builder, List<DNSheetDetent> detents = const [DNSheetDetent.large], DNSheetDetent? initialDetent, bool showGrabber = true, double? cornerRadius, double? scrimOpacity, InvalidType backgroundColor, bool adaptToContainerBackground = true, bool isDismissable = true, bool scrollExpandsSheet = true, bool routerEnabled = false, void Function(DNSheetDetent detent)? onDetentChanged, void Function()? onPresented, void Function()? onDismissed, void Function()? onDismissAttempted, DNSheetPlatformConfig? platformConfig})',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:native_bottomsheet/src/ffi_bindings.dart',
      'package:native_bottomsheet/src/sheet_controller.dart',
      'package:native_bottomsheet/src/sheet_detent.dart',
      'package:native_bottomsheet/src/sheet_platform_config.dart',
      'package:native_bottomsheet/src/show_bottom_sheet.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:native_bottomsheet/native_bottomsheet.dart';";
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
    'DNSecureFlagPolicy',
  ];

}

// =============================================================================
// DNSheetDetent Bridge
// =============================================================================

BridgedClass _createDNSheetDetentBridge() {
  return BridgedClass(
    nativeType: $native_bottomsheet_3.DNSheetDetent,
    name: 'DNSheetDetent',
    isAssignable: (v) => v is $native_bottomsheet_3.DNSheetDetent,
    constructors: {
      'fraction': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'DNSheetDetent');
        final fraction = D4.getRequiredArg<double>(positional, 0, 'fraction', 'DNSheetDetent');
        return $native_bottomsheet_3.DNSheetDetent.fraction(fraction);
      },
      'pixels': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'DNSheetDetent');
        final height = D4.getRequiredArg<double>(positional, 0, 'height', 'DNSheetDetent');
        return $native_bottomsheet_3.DNSheetDetent.pixels(height);
      },
    },
    getters: {
      'label': (visitor, target) => D4.validateTarget<$native_bottomsheet_3.DNSheetDetent>(target, 'DNSheetDetent').label,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_3.DNSheetDetent>(target, 'DNSheetDetent');
        return t.toJson();
      },
    },
    staticGetters: {
      'medium': (visitor) => $native_bottomsheet_3.DNSheetDetent.medium,
      'large': (visitor) => $native_bottomsheet_3.DNSheetDetent.large,
      'contentFit': (visitor) => $native_bottomsheet_3.DNSheetDetent.contentFit,
    },
    constructorSignatures: {
      'fraction': 'const factory DNSheetDetent.fraction(double fraction)',
      'pixels': 'const factory DNSheetDetent.pixels(double height)',
    },
    methodSignatures: {
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'label': 'String get label',
    },
    staticGetterSignatures: {
      'medium': 'DNSheetDetent get medium',
      'large': 'DNSheetDetent get large',
      'contentFit': 'DNSheetDetent get contentFit',
    },
  );
}

// =============================================================================
// DNSheetController Bridge
// =============================================================================

BridgedClass _createDNSheetControllerBridge() {
  return BridgedClass(
    nativeType: $native_bottomsheet_2.DNSheetController,
    name: 'DNSheetController',
    isAssignable: (v) => v is $native_bottomsheet_2.DNSheetController,
    constructors: {
      'create': (visitor, positional, named) {
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'DNSheetController');
        if (!named.containsKey('detents') || named['detents'] == null) {
          throw ArgumentError('DNSheetController: Missing required named argument "detents"');
        }
        final detents = D4.coerceList<$native_bottomsheet_3.DNSheetDetent>(named['detents'], 'detents');
        final initialDetent = D4.getOptionalNamedArg<$native_bottomsheet_3.DNSheetDetent?>(named, 'initialDetent');
        return $native_bottomsheet_2.DNSheetController.create(sheetId: sheetId, detents: detents, initialDetent: initialDetent);
      },
    },
    getters: {
      'currentDetent': (visitor, target) => D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController').currentDetent,
      'detents': (visitor, target) => D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController').detents,
      'isVisible': (visitor, target) => D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController').isVisible,
      'isPresented': (visitor, target) => D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController').isPresented,
    },
    methods: {
      'addPresentedListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'addPresentedListener');
        if (positional.isEmpty) {
          throw ArgumentError('addPresentedListener: Missing required argument "listener" at position 0');
        }
        final listenerRaw = positional[0];
        t.addPresentedListener(() { D4.callInterpreterCallback(visitor!, listenerRaw, []); });
        return null;
      },
      'removePresentedListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'removePresentedListener');
        if (positional.isEmpty) {
          throw ArgumentError('removePresentedListener: Missing required argument "listener" at position 0');
        }
        final listenerRaw = positional[0];
        t.removePresentedListener(() { D4.callInterpreterCallback(visitor!, listenerRaw, []); });
        return null;
      },
      'addDetentListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'addDetentListener');
        if (positional.isEmpty) {
          throw ArgumentError('addDetentListener: Missing required argument "listener" at position 0');
        }
        final listenerRaw = positional[0];
        t.addDetentListener(($native_bottomsheet_3.DNSheetDetent p0) { D4.callInterpreterCallback(visitor!, listenerRaw, [p0]); });
        return null;
      },
      'removeDetentListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'removeDetentListener');
        if (positional.isEmpty) {
          throw ArgumentError('removeDetentListener: Missing required argument "listener" at position 0');
        }
        final listenerRaw = positional[0];
        t.removeDetentListener(($native_bottomsheet_3.DNSheetDetent p0) { D4.callInterpreterCallback(visitor!, listenerRaw, [p0]); });
        return null;
      },
      'addPushListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'addPushListener');
        if (positional.isEmpty) {
          throw ArgumentError('addPushListener: Missing required argument "listener" at position 0');
        }
        final listenerRaw = positional[0];
        t.addPushListener((Object p0) { D4.callInterpreterCallback(visitor!, listenerRaw, [p0]); });
        return null;
      },
      'removePushListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'removePushListener');
        if (positional.isEmpty) {
          throw ArgumentError('removePushListener: Missing required argument "listener" at position 0');
        }
        final listenerRaw = positional[0];
        t.removePushListener((Object p0) { D4.callInterpreterCallback(visitor!, listenerRaw, [p0]); });
        return null;
      },
      'addPopListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'addPopListener');
        if (positional.isEmpty) {
          throw ArgumentError('addPopListener: Missing required argument "listener" at position 0');
        }
        final listenerRaw = positional[0];
        t.addPopListener(() { D4.callInterpreterCallback(visitor!, listenerRaw, []); });
        return null;
      },
      'removePopListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'removePopListener');
        if (positional.isEmpty) {
          throw ArgumentError('removePopListener: Missing required argument "listener" at position 0');
        }
        final listenerRaw = positional[0];
        t.removePopListener(() { D4.callInterpreterCallback(visitor!, listenerRaw, []); });
        return null;
      },
      'snapTo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'snapTo');
        final detent = D4.getRequiredArg<$native_bottomsheet_3.DNSheetDetent>(positional, 0, 'detent', 'snapTo');
        final animated = D4.getNamedArgWithDefault<bool>(named, 'animated', true);
        t.snapTo(detent, animated: animated);
        return null;
      },
      'dismiss': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        final animated = D4.getNamedArgWithDefault<bool>(named, 'animated', true);
        t.dismiss(animated: animated);
        return null;
      },
      'invalidateDetents': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        t.invalidateDetents();
        return null;
      },
      'animateChanges': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'animateChanges');
        if (positional.isEmpty) {
          throw ArgumentError('animateChanges: Missing required argument "block" at position 0');
        }
        final blockRaw = positional[0];
        t.animateChanges(() { D4.callInterpreterCallback(visitor!, blockRaw, []); });
        return null;
      },
      'push': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'push');
        final page = D4.getRequiredArg<Object>(positional, 0, 'page', 'push');
        final expandsTo = D4.getOptionalNamedArg<$native_bottomsheet_3.DNSheetDetent?>(named, 'expandsTo');
        t.push(page, expandsTo: expandsTo);
        return null;
      },
      'pop': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        t.pop();
        return null;
      },
      'updateDetent': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        D4.requireMinArgs(positional, 1, 'updateDetent');
        final detent = D4.getRequiredArg<$native_bottomsheet_3.DNSheetDetent>(positional, 0, 'detent', 'updateDetent');
        t.updateDetent(detent);
        return null;
      },
      'markPresented': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        t.markPresented();
        return null;
      },
      'markDismissed': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_2.DNSheetController>(target, 'DNSheetController');
        t.markDismissed();
        return null;
      },
    },
    constructorSignatures: {
      'create': 'DNSheetController.create({required int sheetId, required List<DNSheetDetent> detents, DNSheetDetent? initialDetent})',
    },
    methodSignatures: {
      'addPresentedListener': 'void addPresentedListener(void Function() listener)',
      'removePresentedListener': 'void removePresentedListener(void Function() listener)',
      'addDetentListener': 'void addDetentListener(void Function(DNSheetDetent detent) listener)',
      'removeDetentListener': 'void removeDetentListener(void Function(DNSheetDetent detent) listener)',
      'addPushListener': 'void addPushListener(void Function(Object page) listener)',
      'removePushListener': 'void removePushListener(void Function(Object page) listener)',
      'addPopListener': 'void addPopListener(void Function() listener)',
      'removePopListener': 'void removePopListener(void Function() listener)',
      'snapTo': 'void snapTo(DNSheetDetent detent, {bool animated = true})',
      'dismiss': 'void dismiss({bool animated = true})',
      'invalidateDetents': 'void invalidateDetents()',
      'animateChanges': 'void animateChanges(void Function() block)',
      'push': 'void push(Object page, {DNSheetDetent? expandsTo})',
      'pop': 'void pop()',
      'updateDetent': 'void updateDetent(DNSheetDetent detent)',
      'markPresented': 'void markPresented()',
      'markDismissed': 'void markDismissed()',
    },
    getterSignatures: {
      'currentDetent': 'DNSheetDetent? get currentDetent',
      'detents': 'List<DNSheetDetent> get detents',
      'isVisible': 'bool get isVisible',
      'isPresented': 'bool get isPresented',
    },
  );
}

// =============================================================================
// DNSheetIOSConfig Bridge
// =============================================================================

BridgedClass _createDNSheetIOSConfigBridge() {
  return BridgedClass(
    nativeType: $native_bottomsheet_4.DNSheetIOSConfig,
    name: 'DNSheetIOSConfig',
    isAssignable: (v) => v is $native_bottomsheet_4.DNSheetIOSConfig,
    constructors: {
      '': (visitor, positional, named) {
        final largestUndimmedDetent = D4.getOptionalNamedArg<$native_bottomsheet_3.DNSheetDetent?>(named, 'largestUndimmedDetent');
        final edgeAttachedInCompactHeight = D4.getNamedArgWithDefault<bool>(named, 'edgeAttachedInCompactHeight', false);
        final widthFollowsContentSizeWhenEdgeAttached = D4.getNamedArgWithDefault<bool>(named, 'widthFollowsContentSizeWhenEdgeAttached', false);
        final prefersPageSizing = D4.getNamedArgWithDefault<bool>(named, 'prefersPageSizing', true);
        return $native_bottomsheet_4.DNSheetIOSConfig(largestUndimmedDetent: largestUndimmedDetent, edgeAttachedInCompactHeight: edgeAttachedInCompactHeight, widthFollowsContentSizeWhenEdgeAttached: widthFollowsContentSizeWhenEdgeAttached, prefersPageSizing: prefersPageSizing);
      },
    },
    getters: {
      'largestUndimmedDetent': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetIOSConfig>(target, 'DNSheetIOSConfig').largestUndimmedDetent,
      'edgeAttachedInCompactHeight': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetIOSConfig>(target, 'DNSheetIOSConfig').edgeAttachedInCompactHeight,
      'widthFollowsContentSizeWhenEdgeAttached': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetIOSConfig>(target, 'DNSheetIOSConfig').widthFollowsContentSizeWhenEdgeAttached,
      'prefersPageSizing': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetIOSConfig>(target, 'DNSheetIOSConfig').prefersPageSizing,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_4.DNSheetIOSConfig>(target, 'DNSheetIOSConfig');
        D4.requireMinArgs(positional, 1, 'toJson');
        if (positional.isEmpty) {
          throw ArgumentError('toJson: Missing required argument "detents" at position 0');
        }
        final detents = D4.coerceList<$native_bottomsheet_3.DNSheetDetent>(positional[0], 'detents');
        return t.toJson(detents);
      },
    },
    constructorSignatures: {
      '': 'const DNSheetIOSConfig({DNSheetDetent? largestUndimmedDetent, bool edgeAttachedInCompactHeight = false, bool widthFollowsContentSizeWhenEdgeAttached = false, bool prefersPageSizing = true})',
    },
    methodSignatures: {
      'toJson': 'Map<String, dynamic> toJson(List<DNSheetDetent> detents)',
    },
    getterSignatures: {
      'largestUndimmedDetent': 'DNSheetDetent? get largestUndimmedDetent',
      'edgeAttachedInCompactHeight': 'bool get edgeAttachedInCompactHeight',
      'widthFollowsContentSizeWhenEdgeAttached': 'bool get widthFollowsContentSizeWhenEdgeAttached',
      'prefersPageSizing': 'bool get prefersPageSizing',
    },
  );
}

// =============================================================================
// DNSheetAndroidConfig Bridge
// =============================================================================

BridgedClass _createDNSheetAndroidConfigBridge() {
  return BridgedClass(
    nativeType: $native_bottomsheet_4.DNSheetAndroidConfig,
    name: 'DNSheetAndroidConfig',
    isAssignable: (v) => v is $native_bottomsheet_4.DNSheetAndroidConfig,
    constructors: {
      '': (visitor, positional, named) {
        final tonalElevation = D4.getOptionalNamedArg<double?>(named, 'tonalElevation');
        final scrimOpacity = D4.getOptionalNamedArg<double?>(named, 'scrimOpacity');
        final sheetGesturesEnabled = D4.getOptionalNamedArg<bool?>(named, 'sheetGesturesEnabled');
        final sheetMaxWidthDp = D4.getOptionalNamedArg<double?>(named, 'sheetMaxWidthDp');
        final shouldDismissOnBackPress = D4.getOptionalNamedArg<bool?>(named, 'shouldDismissOnBackPress');
        final shouldDismissOnClickOutside = D4.getOptionalNamedArg<bool?>(named, 'shouldDismissOnClickOutside');
        final securePolicy = D4.getOptionalNamedArg<$native_bottomsheet_4.DNSecureFlagPolicy?>(named, 'securePolicy');
        final isAppearanceLightStatusBars = D4.getOptionalNamedArg<bool?>(named, 'isAppearanceLightStatusBars');
        final isAppearanceLightNavigationBars = D4.getOptionalNamedArg<bool?>(named, 'isAppearanceLightNavigationBars');
        final floatingGrabber = D4.getNamedArgWithDefault<bool>(named, 'floatingGrabber', true);
        if (!named.containsKey('containerColor') && !named.containsKey('scrimColor') && !named.containsKey('contentColor')) {
          return $native_bottomsheet_4.DNSheetAndroidConfig(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber);
        }
        if (named.containsKey('containerColor') && !named.containsKey('scrimColor') && !named.containsKey('contentColor')) {
          final containerColor = D4.getRequiredNamedArg<dynamic>(named, 'containerColor', 'DNSheetAndroidConfig');
          return $native_bottomsheet_4.DNSheetAndroidConfig(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, containerColor: containerColor);
        }
        if (!named.containsKey('containerColor') && named.containsKey('scrimColor') && !named.containsKey('contentColor')) {
          final scrimColor = D4.getRequiredNamedArg<dynamic>(named, 'scrimColor', 'DNSheetAndroidConfig');
          return $native_bottomsheet_4.DNSheetAndroidConfig(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, scrimColor: scrimColor);
        }
        if (named.containsKey('containerColor') && named.containsKey('scrimColor') && !named.containsKey('contentColor')) {
          final containerColor = D4.getRequiredNamedArg<dynamic>(named, 'containerColor', 'DNSheetAndroidConfig');
          final scrimColor = D4.getRequiredNamedArg<dynamic>(named, 'scrimColor', 'DNSheetAndroidConfig');
          return $native_bottomsheet_4.DNSheetAndroidConfig(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, containerColor: containerColor, scrimColor: scrimColor);
        }
        if (!named.containsKey('containerColor') && !named.containsKey('scrimColor') && named.containsKey('contentColor')) {
          final contentColor = D4.getRequiredNamedArg<dynamic>(named, 'contentColor', 'DNSheetAndroidConfig');
          return $native_bottomsheet_4.DNSheetAndroidConfig(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, contentColor: contentColor);
        }
        if (named.containsKey('containerColor') && !named.containsKey('scrimColor') && named.containsKey('contentColor')) {
          final containerColor = D4.getRequiredNamedArg<dynamic>(named, 'containerColor', 'DNSheetAndroidConfig');
          final contentColor = D4.getRequiredNamedArg<dynamic>(named, 'contentColor', 'DNSheetAndroidConfig');
          return $native_bottomsheet_4.DNSheetAndroidConfig(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, containerColor: containerColor, contentColor: contentColor);
        }
        if (!named.containsKey('containerColor') && named.containsKey('scrimColor') && named.containsKey('contentColor')) {
          final scrimColor = D4.getRequiredNamedArg<dynamic>(named, 'scrimColor', 'DNSheetAndroidConfig');
          final contentColor = D4.getRequiredNamedArg<dynamic>(named, 'contentColor', 'DNSheetAndroidConfig');
          return $native_bottomsheet_4.DNSheetAndroidConfig(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, scrimColor: scrimColor, contentColor: contentColor);
        }
        if (named.containsKey('containerColor') && named.containsKey('scrimColor') && named.containsKey('contentColor')) {
          final containerColor = D4.getRequiredNamedArg<dynamic>(named, 'containerColor', 'DNSheetAndroidConfig');
          final scrimColor = D4.getRequiredNamedArg<dynamic>(named, 'scrimColor', 'DNSheetAndroidConfig');
          final contentColor = D4.getRequiredNamedArg<dynamic>(named, 'contentColor', 'DNSheetAndroidConfig');
          return $native_bottomsheet_4.DNSheetAndroidConfig(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, containerColor: containerColor, scrimColor: scrimColor, contentColor: contentColor);
        }
        throw StateError('Unreachable: all named parameter combinations should be covered');
      },
    },
    getters: {
      'tonalElevation': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').tonalElevation,
      'containerColor': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').containerColor,
      'scrimColor': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').scrimColor,
      'scrimOpacity': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').scrimOpacity,
      'contentColor': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').contentColor,
      'sheetGesturesEnabled': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').sheetGesturesEnabled,
      'sheetMaxWidthDp': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').sheetMaxWidthDp,
      'shouldDismissOnBackPress': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').shouldDismissOnBackPress,
      'shouldDismissOnClickOutside': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').shouldDismissOnClickOutside,
      'securePolicy': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').securePolicy,
      'isAppearanceLightStatusBars': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').isAppearanceLightStatusBars,
      'isAppearanceLightNavigationBars': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').isAppearanceLightNavigationBars,
      'floatingGrabber': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig').floatingGrabber,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_4.DNSheetAndroidConfig>(target, 'DNSheetAndroidConfig');
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const DNSheetAndroidConfig({double? tonalElevation, InvalidType containerColor, InvalidType scrimColor, double? scrimOpacity, InvalidType contentColor, bool? sheetGesturesEnabled, double? sheetMaxWidthDp, bool? shouldDismissOnBackPress, bool? shouldDismissOnClickOutside, DNSecureFlagPolicy? securePolicy, bool? isAppearanceLightStatusBars, bool? isAppearanceLightNavigationBars, bool floatingGrabber = true})',
    },
    methodSignatures: {
      'toJson': 'Map<String, dynamic> toJson()',
    },
    getterSignatures: {
      'tonalElevation': 'double? get tonalElevation',
      'containerColor': 'InvalidType get containerColor',
      'scrimColor': 'InvalidType get scrimColor',
      'scrimOpacity': 'double? get scrimOpacity',
      'contentColor': 'InvalidType get contentColor',
      'sheetGesturesEnabled': 'bool? get sheetGesturesEnabled',
      'sheetMaxWidthDp': 'double? get sheetMaxWidthDp',
      'shouldDismissOnBackPress': 'bool? get shouldDismissOnBackPress',
      'shouldDismissOnClickOutside': 'bool? get shouldDismissOnClickOutside',
      'securePolicy': 'DNSecureFlagPolicy? get securePolicy',
      'isAppearanceLightStatusBars': 'bool? get isAppearanceLightStatusBars',
      'isAppearanceLightNavigationBars': 'bool? get isAppearanceLightNavigationBars',
      'floatingGrabber': 'bool get floatingGrabber',
    },
  );
}

// =============================================================================
// DNSheetPlatformConfig Bridge
// =============================================================================

BridgedClass _createDNSheetPlatformConfigBridge() {
  return BridgedClass(
    nativeType: $native_bottomsheet_4.DNSheetPlatformConfig,
    name: 'DNSheetPlatformConfig',
    isAssignable: (v) => v is $native_bottomsheet_4.DNSheetPlatformConfig,
    constructors: {
      '': (visitor, positional, named) {
        final ios = D4.getOptionalNamedArg<$native_bottomsheet_4.DNSheetIOSConfig?>(named, 'ios');
        final android = D4.getOptionalNamedArg<$native_bottomsheet_4.DNSheetAndroidConfig?>(named, 'android');
        return $native_bottomsheet_4.DNSheetPlatformConfig(ios: ios, android: android);
      },
      'ios': (visitor, positional, named) {
        final largestUndimmedDetent = D4.getOptionalNamedArg<$native_bottomsheet_3.DNSheetDetent?>(named, 'largestUndimmedDetent');
        final edgeAttachedInCompactHeight = D4.getNamedArgWithDefault<bool>(named, 'edgeAttachedInCompactHeight', false);
        final widthFollowsContentSizeWhenEdgeAttached = D4.getNamedArgWithDefault<bool>(named, 'widthFollowsContentSizeWhenEdgeAttached', false);
        final prefersPageSizing = D4.getNamedArgWithDefault<bool>(named, 'prefersPageSizing', true);
        return $native_bottomsheet_4.DNSheetPlatformConfig.ios(largestUndimmedDetent: largestUndimmedDetent, edgeAttachedInCompactHeight: edgeAttachedInCompactHeight, widthFollowsContentSizeWhenEdgeAttached: widthFollowsContentSizeWhenEdgeAttached, prefersPageSizing: prefersPageSizing);
      },
      'android': (visitor, positional, named) {
        final tonalElevation = D4.getOptionalNamedArg<double?>(named, 'tonalElevation');
        final scrimOpacity = D4.getOptionalNamedArg<double?>(named, 'scrimOpacity');
        final sheetGesturesEnabled = D4.getOptionalNamedArg<bool?>(named, 'sheetGesturesEnabled');
        final sheetMaxWidthDp = D4.getOptionalNamedArg<double?>(named, 'sheetMaxWidthDp');
        final shouldDismissOnBackPress = D4.getOptionalNamedArg<bool?>(named, 'shouldDismissOnBackPress');
        final shouldDismissOnClickOutside = D4.getOptionalNamedArg<bool?>(named, 'shouldDismissOnClickOutside');
        final securePolicy = D4.getOptionalNamedArg<$native_bottomsheet_4.DNSecureFlagPolicy?>(named, 'securePolicy');
        final isAppearanceLightStatusBars = D4.getOptionalNamedArg<bool?>(named, 'isAppearanceLightStatusBars');
        final isAppearanceLightNavigationBars = D4.getOptionalNamedArg<bool?>(named, 'isAppearanceLightNavigationBars');
        final floatingGrabber = D4.getNamedArgWithDefault<bool>(named, 'floatingGrabber', true);
        if (!named.containsKey('containerColor') && !named.containsKey('scrimColor') && !named.containsKey('contentColor')) {
          return $native_bottomsheet_4.DNSheetPlatformConfig.android(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber);
        }
        if (named.containsKey('containerColor') && !named.containsKey('scrimColor') && !named.containsKey('contentColor')) {
          final containerColor = D4.getRequiredNamedArg<dynamic>(named, 'containerColor', 'DNSheetPlatformConfig');
          return $native_bottomsheet_4.DNSheetPlatformConfig.android(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, containerColor: containerColor);
        }
        if (!named.containsKey('containerColor') && named.containsKey('scrimColor') && !named.containsKey('contentColor')) {
          final scrimColor = D4.getRequiredNamedArg<dynamic>(named, 'scrimColor', 'DNSheetPlatformConfig');
          return $native_bottomsheet_4.DNSheetPlatformConfig.android(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, scrimColor: scrimColor);
        }
        if (named.containsKey('containerColor') && named.containsKey('scrimColor') && !named.containsKey('contentColor')) {
          final containerColor = D4.getRequiredNamedArg<dynamic>(named, 'containerColor', 'DNSheetPlatformConfig');
          final scrimColor = D4.getRequiredNamedArg<dynamic>(named, 'scrimColor', 'DNSheetPlatformConfig');
          return $native_bottomsheet_4.DNSheetPlatformConfig.android(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, containerColor: containerColor, scrimColor: scrimColor);
        }
        if (!named.containsKey('containerColor') && !named.containsKey('scrimColor') && named.containsKey('contentColor')) {
          final contentColor = D4.getRequiredNamedArg<dynamic>(named, 'contentColor', 'DNSheetPlatformConfig');
          return $native_bottomsheet_4.DNSheetPlatformConfig.android(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, contentColor: contentColor);
        }
        if (named.containsKey('containerColor') && !named.containsKey('scrimColor') && named.containsKey('contentColor')) {
          final containerColor = D4.getRequiredNamedArg<dynamic>(named, 'containerColor', 'DNSheetPlatformConfig');
          final contentColor = D4.getRequiredNamedArg<dynamic>(named, 'contentColor', 'DNSheetPlatformConfig');
          return $native_bottomsheet_4.DNSheetPlatformConfig.android(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, containerColor: containerColor, contentColor: contentColor);
        }
        if (!named.containsKey('containerColor') && named.containsKey('scrimColor') && named.containsKey('contentColor')) {
          final scrimColor = D4.getRequiredNamedArg<dynamic>(named, 'scrimColor', 'DNSheetPlatformConfig');
          final contentColor = D4.getRequiredNamedArg<dynamic>(named, 'contentColor', 'DNSheetPlatformConfig');
          return $native_bottomsheet_4.DNSheetPlatformConfig.android(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, scrimColor: scrimColor, contentColor: contentColor);
        }
        if (named.containsKey('containerColor') && named.containsKey('scrimColor') && named.containsKey('contentColor')) {
          final containerColor = D4.getRequiredNamedArg<dynamic>(named, 'containerColor', 'DNSheetPlatformConfig');
          final scrimColor = D4.getRequiredNamedArg<dynamic>(named, 'scrimColor', 'DNSheetPlatformConfig');
          final contentColor = D4.getRequiredNamedArg<dynamic>(named, 'contentColor', 'DNSheetPlatformConfig');
          return $native_bottomsheet_4.DNSheetPlatformConfig.android(tonalElevation: tonalElevation, scrimOpacity: scrimOpacity, sheetGesturesEnabled: sheetGesturesEnabled, sheetMaxWidthDp: sheetMaxWidthDp, shouldDismissOnBackPress: shouldDismissOnBackPress, shouldDismissOnClickOutside: shouldDismissOnClickOutside, securePolicy: securePolicy, isAppearanceLightStatusBars: isAppearanceLightStatusBars, isAppearanceLightNavigationBars: isAppearanceLightNavigationBars, floatingGrabber: floatingGrabber, containerColor: containerColor, scrimColor: scrimColor, contentColor: contentColor);
        }
        throw StateError('Unreachable: all named parameter combinations should be covered');
      },
    },
    getters: {
      'ios': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetPlatformConfig>(target, 'DNSheetPlatformConfig').ios,
      'android': (visitor, target) => D4.validateTarget<$native_bottomsheet_4.DNSheetPlatformConfig>(target, 'DNSheetPlatformConfig').android,
    },
    constructorSignatures: {
      '': 'const DNSheetPlatformConfig({DNSheetIOSConfig? ios, DNSheetAndroidConfig? android})',
      'ios': 'factory DNSheetPlatformConfig.ios({DNSheetDetent? largestUndimmedDetent, bool edgeAttachedInCompactHeight = false, bool widthFollowsContentSizeWhenEdgeAttached = false, bool prefersPageSizing = true})',
      'android': 'factory DNSheetPlatformConfig.android({double? tonalElevation, InvalidType containerColor, InvalidType scrimColor, double? scrimOpacity, InvalidType contentColor, bool? sheetGesturesEnabled, double? sheetMaxWidthDp, bool? shouldDismissOnBackPress, bool? shouldDismissOnClickOutside, DNSecureFlagPolicy? securePolicy, bool? isAppearanceLightStatusBars, bool? isAppearanceLightNavigationBars, bool floatingGrabber = true})',
    },
    getterSignatures: {
      'ios': 'DNSheetIOSConfig? get ios',
      'android': 'DNSheetAndroidConfig? get android',
    },
  );
}

// =============================================================================
// BottomSheetFFIBindings Bridge
// =============================================================================

BridgedClass _createBottomSheetFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $native_bottomsheet_1.BottomSheetFFIBindings,
    name: 'BottomSheetFFIBindings',
    isAssignable: (v) => v is $native_bottomsheet_1.BottomSheetFFIBindings,
    constructors: {
    },
    methods: {
      'show': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        D4.requireMinArgs(positional, 2, 'show');
        if (positional.isEmpty) {
          throw ArgumentError('show: Missing required argument "config" at position 0');
        }
        final config = D4.coerceMap<String, dynamic>(positional[0], 'config');
        if (positional.length <= 1) {
          throw ArgumentError('show: Missing required argument "handler" at position 1');
        }
        final handlerRaw = positional[1];
        return t.show(config, (int p0, String p1) { D4.callInterpreterCallback(visitor!, handlerRaw, [p0, p1]); });
      },
      'dismiss': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'dismiss');
        final animated = D4.getRequiredNamedArg<bool>(named, 'animated', 'dismiss');
        t.dismiss(sheetId: sheetId, animated: animated);
        return null;
      },
      'snapTo': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'snapTo');
        final detentIndex = D4.getRequiredNamedArg<int>(named, 'detentIndex', 'snapTo');
        final animated = D4.getRequiredNamedArg<bool>(named, 'animated', 'snapTo');
        t.snapTo(sheetId: sheetId, detentIndex: detentIndex, animated: animated);
        return null;
      },
      'invalidateDetents': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'invalidateDetents');
        t.invalidateDetents(sheetId: sheetId);
        return null;
      },
      'beginAnimateChanges': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'beginAnimateChanges');
        t.beginAnimateChanges(sheetId: sheetId);
        return null;
      },
      'endAnimateChanges': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'endAnimateChanges');
        t.endAnimateChanges(sheetId: sheetId);
        return null;
      },
      'mountContent': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'mountContent');
        final viewId = D4.getRequiredNamedArg<int>(named, 'viewId', 'mountContent');
        t.mountContent(sheetId: sheetId, viewId: viewId);
        return null;
      },
      'layoutContent': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'layoutContent');
        t.layoutContent(sheetId: sheetId);
        return null;
      },
      'push': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'push');
        final expandsToDetentIndex = D4.getRequiredNamedArg<int>(named, 'expandsToDetentIndex', 'push');
        t.push(sheetId: sheetId, expandsToDetentIndex: expandsToDetentIndex);
        return null;
      },
      'pop': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        final sheetId = D4.getRequiredNamedArg<int>(named, 'sheetId', 'pop');
        t.pop(sheetId: sheetId);
        return null;
      },
      'removeHandler': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$native_bottomsheet_1.BottomSheetFFIBindings>(target, 'BottomSheetFFIBindings');
        D4.requireMinArgs(positional, 1, 'removeHandler');
        final sheetId = D4.getRequiredArg<int>(positional, 0, 'sheetId', 'removeHandler');
        t.removeHandler(sheetId);
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) => $native_bottomsheet_1.BottomSheetFFIBindings.instance,
      'eventDetentChanged': (visitor) => $native_bottomsheet_1.BottomSheetFFIBindings.eventDetentChanged,
      'eventDismissed': (visitor) => $native_bottomsheet_1.BottomSheetFFIBindings.eventDismissed,
      'eventDismissAttempted': (visitor) => $native_bottomsheet_1.BottomSheetFFIBindings.eventDismissAttempted,
      'eventPresented': (visitor) => $native_bottomsheet_1.BottomSheetFFIBindings.eventPresented,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $native_bottomsheet_1.BottomSheetFFIBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'show': 'int show(Map<String, dynamic> config, void Function(int, String) handler)',
      'dismiss': 'void dismiss({required int sheetId, required bool animated})',
      'snapTo': 'void snapTo({required int sheetId, required int detentIndex, required bool animated})',
      'invalidateDetents': 'void invalidateDetents({required int sheetId})',
      'beginAnimateChanges': 'void beginAnimateChanges({required int sheetId})',
      'endAnimateChanges': 'void endAnimateChanges({required int sheetId})',
      'mountContent': 'void mountContent({required int sheetId, required int viewId})',
      'layoutContent': 'void layoutContent({required int sheetId})',
      'push': 'void push({required int sheetId, required int expandsToDetentIndex})',
      'pop': 'void pop({required int sheetId})',
      'removeHandler': 'void removeHandler(int sheetId)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'BottomSheetFFIBindings get instance',
      'eventDetentChanged': 'int get eventDetentChanged',
      'eventDismissed': 'int get eventDismissed',
      'eventDismissAttempted': 'int get eventDismissAttempted',
      'eventPresented': 'int get eventPresented',
    },
  );
}


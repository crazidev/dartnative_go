// D4rt Bridge - Generated file, do not edit
// Sources: 3 files
// Generated: 2026-11-15T01:14:43.948890 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';

import 'package:dartnative_splash/src/android_generator.dart'
    as $dartnative_splash_1;
import 'package:dartnative_splash/src/config.dart' as $dartnative_splash_2;
import 'package:dartnative_splash/src/ios_generator.dart'
    as $dartnative_splash_3;

/// Bridge class for dartnative_splash module.
class DartnativeSplashBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createSplashConfigBridge(),
      _createIosGeneratorBridge(),
      _createAndroidGeneratorBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'SplashConfig': _createSplashConfigBridge,
      'IosGenerator': _createIosGeneratorBridge,
      'AndroidGenerator': _createAndroidGeneratorBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'SplashConfig': $dartnative_splash_2.SplashConfig,
      'IosGenerator': $dartnative_splash_3.IosGenerator,
      'AndroidGenerator': $dartnative_splash_1.AndroidGenerator,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'SplashConfig': 'package:dartnative_splash/src/config.dart',
      'IosGenerator': 'package:dartnative_splash/src/ios_generator.dart',
      'AndroidGenerator':
          'package:dartnative_splash/src/android_generator.dart',
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
    return {};
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
        source: 'package:dartnative_splash/dartnative_splash.dart',
        target: 'package:dartnative_splash/src/config.dart',
        show: {'SplashConfig'},
        hide: null,
      ),
      (
        source: 'package:dartnative_splash/dartnative_splash.dart',
        target: 'package:dartnative_splash/src/ios_generator.dart',
        show: {'IosGenerator'},
        hide: null,
      ),
      (
        source: 'package:dartnative_splash/dartnative_splash.dart',
        target: 'package:dartnative_splash/src/android_generator.dart',
        show: {'AndroidGenerator'},
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
      'package:dartnative_splash/src/android_generator.dart',
      'package:dartnative_splash/src/config.dart',
      'package:dartnative_splash/src/ios_generator.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_splash/dartnative_splash.dart';";
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
// SplashConfig Bridge
// =============================================================================

BridgedClass _createSplashConfigBridge() {
  return BridgedClass(
    nativeType: $dartnative_splash_2.SplashConfig,
    name: 'SplashConfig',
    isAssignable: (v) => v is $dartnative_splash_2.SplashConfig,
    constructors: {
      '': (visitor, positional, named) {
        final backgroundColor = D4.getRequiredNamedArg<String>(
          named,
          'backgroundColor',
          'SplashConfig',
        );
        final image = D4.getRequiredNamedArg<String>(
          named,
          'image',
          'SplashConfig',
        );
        final darkBackgroundColor = D4.getOptionalNamedArg<String?>(
          named,
          'darkBackgroundColor',
        );
        final darkImage = D4.getOptionalNamedArg<String?>(named, 'darkImage');
        final generateIos = D4.getNamedArgWithDefault<bool>(
          named,
          'generateIos',
          true,
        );
        final generateAndroid = D4.getNamedArgWithDefault<bool>(
          named,
          'generateAndroid',
          true,
        );
        return $dartnative_splash_2.SplashConfig(
          backgroundColor: backgroundColor,
          image: image,
          darkBackgroundColor: darkBackgroundColor,
          darkImage: darkImage,
          generateIos: generateIos,
          generateAndroid: generateAndroid,
        );
      },
      'fromPubspec': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'SplashConfig');
        final pubspecPath = D4.getRequiredArg<String>(
          positional,
          0,
          'pubspecPath',
          'SplashConfig',
        );
        return $dartnative_splash_2.SplashConfig.fromPubspec(pubspecPath);
      },
    },
    getters: {
      'backgroundColor': (visitor, target) => D4
          .validateTarget<$dartnative_splash_2.SplashConfig>(
            target,
            'SplashConfig',
          )
          .backgroundColor,
      'image': (visitor, target) => D4
          .validateTarget<$dartnative_splash_2.SplashConfig>(
            target,
            'SplashConfig',
          )
          .image,
      'darkBackgroundColor': (visitor, target) => D4
          .validateTarget<$dartnative_splash_2.SplashConfig>(
            target,
            'SplashConfig',
          )
          .darkBackgroundColor,
      'darkImage': (visitor, target) => D4
          .validateTarget<$dartnative_splash_2.SplashConfig>(
            target,
            'SplashConfig',
          )
          .darkImage,
      'generateIos': (visitor, target) => D4
          .validateTarget<$dartnative_splash_2.SplashConfig>(
            target,
            'SplashConfig',
          )
          .generateIos,
      'generateAndroid': (visitor, target) => D4
          .validateTarget<$dartnative_splash_2.SplashConfig>(
            target,
            'SplashConfig',
          )
          .generateAndroid,
      'effectiveDarkBackgroundColor': (visitor, target) => D4
          .validateTarget<$dartnative_splash_2.SplashConfig>(
            target,
            'SplashConfig',
          )
          .effectiveDarkBackgroundColor,
      'effectiveDarkImage': (visitor, target) => D4
          .validateTarget<$dartnative_splash_2.SplashConfig>(
            target,
            'SplashConfig',
          )
          .effectiveDarkImage,
    },
    staticMethods: {
      'parseColor': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'parseColor');
        final hex = D4.getRequiredArg<String>(
          positional,
          0,
          'hex',
          'parseColor',
        );
        return $dartnative_splash_2.SplashConfig.parseColor(hex);
      },
    },
    constructorSignatures: {
      '': 'const SplashConfig({required String backgroundColor, required String image, String? darkBackgroundColor, String? darkImage, bool generateIos = true, bool generateAndroid = true})',
      'fromPubspec': 'factory SplashConfig.fromPubspec(String pubspecPath)',
    },
    getterSignatures: {
      'backgroundColor': 'String get backgroundColor',
      'image': 'String get image',
      'darkBackgroundColor': 'String? get darkBackgroundColor',
      'darkImage': 'String? get darkImage',
      'generateIos': 'bool get generateIos',
      'generateAndroid': 'bool get generateAndroid',
      'effectiveDarkBackgroundColor': 'String get effectiveDarkBackgroundColor',
      'effectiveDarkImage': 'String get effectiveDarkImage',
    },
    staticMethodSignatures: {
      'parseColor': '({int a, int b, int g, int r}) parseColor(String hex)',
    },
  );
}

// =============================================================================
// IosGenerator Bridge
// =============================================================================

BridgedClass _createIosGeneratorBridge() {
  return BridgedClass(
    nativeType: $dartnative_splash_3.IosGenerator,
    name: 'IosGenerator',
    isAssignable: (v) => v is $dartnative_splash_3.IosGenerator,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'IosGenerator');
        final config = D4.getRequiredArg<$dartnative_splash_2.SplashConfig>(
          positional,
          0,
          'config',
          'IosGenerator',
        );
        return $dartnative_splash_3.IosGenerator(config);
      },
    },
    getters: {
      'config': (visitor, target) => D4
          .validateTarget<$dartnative_splash_3.IosGenerator>(
            target,
            'IosGenerator',
          )
          .config,
    },
    methods: {
      'generate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_splash_3.IosGenerator>(
          target,
          'IosGenerator',
        );
        t.generate();
        return null;
      },
    },
    constructorSignatures: {
      '': 'const IosGenerator(SplashConfig config)',
    },
    methodSignatures: {
      'generate': 'void generate()',
    },
    getterSignatures: {
      'config': 'SplashConfig get config',
    },
  );
}

// =============================================================================
// AndroidGenerator Bridge
// =============================================================================

BridgedClass _createAndroidGeneratorBridge() {
  return BridgedClass(
    nativeType: $dartnative_splash_1.AndroidGenerator,
    name: 'AndroidGenerator',
    isAssignable: (v) => v is $dartnative_splash_1.AndroidGenerator,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AndroidGenerator');
        final config = D4.getRequiredArg<$dartnative_splash_2.SplashConfig>(
          positional,
          0,
          'config',
          'AndroidGenerator',
        );
        return $dartnative_splash_1.AndroidGenerator(config);
      },
    },
    getters: {
      'config': (visitor, target) => D4
          .validateTarget<$dartnative_splash_1.AndroidGenerator>(
            target,
            'AndroidGenerator',
          )
          .config,
    },
    methods: {
      'generate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_splash_1.AndroidGenerator>(
          target,
          'AndroidGenerator',
        );
        t.generate();
        return null;
      },
    },
    constructorSignatures: {
      '': 'const AndroidGenerator(SplashConfig config)',
    },
    methodSignatures: {
      'generate': 'void generate()',
    },
    getterSignatures: {
      'config': 'SplashConfig get config',
    },
  );
}

// D4rt Bridge - Generated file, do not edit
// Sources: 7 files
// Generated: 2026-11-24T16:21:18.138121 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:dartnative_supertonic_tts/src/model_manager.dart'
    as $dartnative_supertonic_tts_1;
import 'package:dartnative_supertonic_tts/src/supertonic_tts.dart'
    as $dartnative_supertonic_tts_2;
import 'package:dartnative_supertonic_tts/src/tokenizer.dart'
    as $dartnative_supertonic_tts_3;
import 'package:dartnative_supertonic_tts/src/tts_config.dart'
    as $dartnative_supertonic_tts_4;
import 'package:dartnative_supertonic_tts/src/tts_languages.dart'
    as $dartnative_supertonic_tts_5;
import 'package:dartnative_supertonic_tts/src/tts_result.dart'
    as $dartnative_supertonic_tts_6;
import 'package:dartnative_supertonic_tts/src/tts_voices.dart'
    as $dartnative_supertonic_tts_7;

/// Bridge class for dartnative_supertonic_tts module.
class DartnativeSupertonicTtsBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createSuperTonicTTSBridge(),
      _createModelManagerBridge(),
      _createTTSConfigBridge(),
      _createTTSResultBridge(),
      _createTTSVoiceStyleBridge(),
      _createTTSLanguageBridge(),
      _createTTSTestStringsBridge(),
      _createTokenizerBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'SuperTonicTTS': _createSuperTonicTTSBridge,
      'ModelManager': _createModelManagerBridge,
      'TTSConfig': _createTTSConfigBridge,
      'TTSResult': _createTTSResultBridge,
      'TTSVoiceStyle': _createTTSVoiceStyleBridge,
      'TTSLanguage': _createTTSLanguageBridge,
      'TTSTestStrings': _createTTSTestStringsBridge,
      'Tokenizer': _createTokenizerBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'SuperTonicTTS': $dartnative_supertonic_tts_2.SuperTonicTTS,
      'ModelManager': $dartnative_supertonic_tts_1.ModelManager,
      'TTSConfig': $dartnative_supertonic_tts_4.TTSConfig,
      'TTSResult': $dartnative_supertonic_tts_6.TTSResult,
      'TTSVoiceStyle': $dartnative_supertonic_tts_7.TTSVoiceStyle,
      'TTSLanguage': $dartnative_supertonic_tts_5.TTSLanguage,
      'TTSTestStrings': $dartnative_supertonic_tts_5.TTSTestStrings,
      'Tokenizer': $dartnative_supertonic_tts_3.Tokenizer,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'SuperTonicTTS':
          'package:dartnative_supertonic_tts/src/supertonic_tts.dart',
      'ModelManager':
          'package:dartnative_supertonic_tts/src/model_manager.dart',
      'TTSConfig': 'package:dartnative_supertonic_tts/src/tts_config.dart',
      'TTSResult': 'package:dartnative_supertonic_tts/src/tts_result.dart',
      'TTSVoiceStyle': 'package:dartnative_supertonic_tts/src/tts_voices.dart',
      'TTSLanguage': 'package:dartnative_supertonic_tts/src/tts_languages.dart',
      'TTSTestStrings':
          'package:dartnative_supertonic_tts/src/tts_languages.dart',
      'Tokenizer': 'package:dartnative_supertonic_tts/src/tokenizer.dart',
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
    return [
      BridgedEnumDefinition<$dartnative_supertonic_tts_1.SuperTonicVariant>(
        name: 'SuperTonicVariant',
        values: $dartnative_supertonic_tts_1.SuperTonicVariant.values,
        staticMethods: {
          'fromName': (visitor, positional, named, typeArgs) {
            return Function.apply(
              $dartnative_supertonic_tts_1.SuperTonicVariant.fromName,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
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
      'SuperTonicVariant':
          'package:dartnative_supertonic_tts/src/model_manager.dart',
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
        source:
            'package:dartnative_supertonic_tts/dartnative_supertonic_tts.dart',
        target: 'package:dartnative_supertonic_tts/src/supertonic_tts.dart',
        show: {'SuperTonicTTS', 'supertonicVoices'},
        hide: null,
      ),
      (
        source:
            'package:dartnative_supertonic_tts/dartnative_supertonic_tts.dart',
        target: 'package:dartnative_supertonic_tts/src/model_manager.dart',
        show: {'ModelManager', 'SuperTonicVariant', 'kSuperTonicVoiceFiles'},
        hide: null,
      ),
      (
        source:
            'package:dartnative_supertonic_tts/dartnative_supertonic_tts.dart',
        target: 'package:dartnative_supertonic_tts/src/tts_config.dart',
        show: {'TTSConfig'},
        hide: null,
      ),
      (
        source:
            'package:dartnative_supertonic_tts/dartnative_supertonic_tts.dart',
        target: 'package:dartnative_supertonic_tts/src/tts_result.dart',
        show: {'TTSResult'},
        hide: null,
      ),
      (
        source:
            'package:dartnative_supertonic_tts/dartnative_supertonic_tts.dart',
        target: 'package:dartnative_supertonic_tts/src/tts_voices.dart',
        show: {'TTSVoiceStyle'},
        hide: null,
      ),
      (
        source:
            'package:dartnative_supertonic_tts/dartnative_supertonic_tts.dart',
        target: 'package:dartnative_supertonic_tts/src/tts_languages.dart',
        show: {'TTSLanguage', 'TTSTestStrings'},
        hide: null,
      ),
      (
        source:
            'package:dartnative_supertonic_tts/dartnative_supertonic_tts.dart',
        target: 'package:dartnative_supertonic_tts/src/tokenizer.dart',
        show: {'Tokenizer'},
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
        'supertonicVoices',
        $dartnative_supertonic_tts_2.supertonicVoices,
        importPath,
        sourceUri: 'package:dartnative_supertonic_tts/src/supertonic_tts.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "supertonicVoices": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'kSuperTonicVoiceFiles',
        $dartnative_supertonic_tts_1.kSuperTonicVoiceFiles,
        importPath,
        sourceUri: 'package:dartnative_supertonic_tts/src/model_manager.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "kSuperTonicVoiceFiles": $e');
    }

    if (errors.isNotEmpty) {
      throw StateError(
        'Bridge registration errors (dartnative_supertonic_tts):\n${errors.join("\n")}',
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
      'package:dartnative_supertonic_tts/src/model_manager.dart',
      'package:dartnative_supertonic_tts/src/supertonic_tts.dart',
      'package:dartnative_supertonic_tts/src/tokenizer.dart',
      'package:dartnative_supertonic_tts/src/tts_config.dart',
      'package:dartnative_supertonic_tts/src/tts_languages.dart',
      'package:dartnative_supertonic_tts/src/tts_result.dart',
      'package:dartnative_supertonic_tts/src/tts_voices.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_supertonic_tts/dartnative_supertonic_tts.dart';";
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
    'SuperTonicVariant',
  ];
}

// =============================================================================
// SuperTonicTTS Bridge
// =============================================================================

BridgedClass _createSuperTonicTTSBridge() {
  return BridgedClass(
    nativeType: $dartnative_supertonic_tts_2.SuperTonicTTS,
    name: 'SuperTonicTTS',
    isAssignable: (v) => v is $dartnative_supertonic_tts_2.SuperTonicTTS,
    constructors: {
      '': (visitor, positional, named) {
        final variant = D4
            .getNamedArgWithDefault<
              $dartnative_supertonic_tts_1.SuperTonicVariant
            >(
              named,
              'variant',
              $dartnative_supertonic_tts_1.SuperTonicVariant.mobile,
            );
        return $dartnative_supertonic_tts_2.SuperTonicTTS(variant: variant);
      },
      'fromName': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'SuperTonicTTS');
        final variant = D4.getRequiredArg<String>(
          positional,
          0,
          'variant',
          'SuperTonicTTS',
        );
        return $dartnative_supertonic_tts_2.SuperTonicTTS.fromName(variant);
      },
      'withManager': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'SuperTonicTTS');
        final manager = D4
            .getRequiredArg<$dartnative_supertonic_tts_1.ModelManager>(
              positional,
              0,
              'manager',
              'SuperTonicTTS',
            );
        return $dartnative_supertonic_tts_2.SuperTonicTTS.withManager(manager);
      },
    },
    getters: {
      'isInitialized': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
            target,
            'SuperTonicTTS',
          )
          .isInitialized,
      'modelManager': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
            target,
            'SuperTonicTTS',
          )
          .modelManager,
      'sampleRate': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
            target,
            'SuperTonicTTS',
          )
          .sampleRate,
      'baseChunkSize': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
            target,
            'SuperTonicTTS',
          )
          .baseChunkSize,
      'chunkCompressFactor': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
            target,
            'SuperTonicTTS',
          )
          .chunkCompressFactor,
      'ldim': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
            target,
            'SuperTonicTTS',
          )
          .ldim,
      'availableVoices': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
            target,
            'SuperTonicTTS',
          )
          .availableVoices,
      'availableLanguages': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
            target,
            'SuperTonicTTS',
          )
          .availableLanguages,
    },
    methods: {
      'initialize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
          target,
          'SuperTonicTTS',
        );
        final onProgressRaw = named['onProgress'];
        final intraOpNumThreads = D4.getOptionalNamedArg<int?>(
          named,
          'intraOpNumThreads',
        );
        return t.initialize(
          onProgress: onProgressRaw == null
              ? null
              : (double p0, String p1) {
                  D4.callInterpreterCallback(visitor!, onProgressRaw, [p0, p1]);
                },
          intraOpNumThreads: intraOpNumThreads,
        );
      },
      'generateStream': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
          target,
          'SuperTonicTTS',
        );
        D4.requireMinArgs(positional, 1, 'generateStream');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'generateStream',
        );
        final voice = D4.getNamedArgWithDefault<String>(named, 'voice', 'F1');
        final lang = D4.getNamedArgWithDefault<String>(named, 'lang', 'en');
        final speed = D4.getNamedArgWithDefault<double>(named, 'speed', 1.0);
        final steps = D4.getNamedArgWithDefault<int>(named, 'steps', 5);
        final maxLen = D4.getOptionalNamedArg<int?>(named, 'maxLen');
        final voiceStylePath = D4.getOptionalNamedArg<String?>(
          named,
          'voiceStylePath',
        );
        return t.generateStream(
          text,
          voice: voice,
          lang: lang,
          speed: speed,
          steps: steps,
          maxLen: maxLen,
          voiceStylePath: voiceStylePath,
        );
      },
      'generate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
          target,
          'SuperTonicTTS',
        );
        D4.requireMinArgs(positional, 1, 'generate');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'generate',
        );
        final voice = D4.getNamedArgWithDefault<String>(named, 'voice', 'F1');
        final lang = D4.getNamedArgWithDefault<String>(named, 'lang', 'en');
        final speed = D4.getNamedArgWithDefault<double>(named, 'speed', 1.0);
        final steps = D4.getNamedArgWithDefault<int>(named, 'steps', 5);
        final silenceDuration = D4.getNamedArgWithDefault<double>(
          named,
          'silenceDuration',
          0.3,
        );
        final voiceStylePath = D4.getOptionalNamedArg<String?>(
          named,
          'voiceStylePath',
        );
        return t.generate(
          text,
          voice: voice,
          lang: lang,
          speed: speed,
          steps: steps,
          silenceDuration: silenceDuration,
          voiceStylePath: voiceStylePath,
        );
      },
      'generateChunk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
          target,
          'SuperTonicTTS',
        );
        D4.requireMinArgs(positional, 1, 'generateChunk');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'generateChunk',
        );
        final voice = D4.getNamedArgWithDefault<String>(named, 'voice', 'F1');
        final lang = D4.getNamedArgWithDefault<String>(named, 'lang', 'en');
        final speed = D4.getNamedArgWithDefault<double>(named, 'speed', 1.0);
        final steps = D4.getNamedArgWithDefault<int>(named, 'steps', 5);
        final voiceStylePath = D4.getOptionalNamedArg<String?>(
          named,
          'voiceStylePath',
        );
        return t.generateChunk(
          text,
          voice: voice,
          lang: lang,
          speed: speed,
          steps: steps,
          voiceStylePath: voiceStylePath,
        );
      },
      'splitText': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
          target,
          'SuperTonicTTS',
        );
        D4.requireMinArgs(positional, 1, 'splitText');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'splitText',
        );
        final maxLen = D4.getNamedArgWithDefault<int>(named, 'maxLen', 300);
        return t.splitText(text, maxLen: maxLen);
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_2.SuperTonicTTS>(
          target,
          'SuperTonicTTS',
        );
        return (t as dynamic).dispose();
      },
    },
    staticGetters: {
      'verboseLogging': (visitor) =>
          $dartnative_supertonic_tts_2.SuperTonicTTS.verboseLogging,
    },
    staticSetters: {
      'verboseLogging': (visitor, value) =>
          $dartnative_supertonic_tts_2.SuperTonicTTS.verboseLogging = D4
              .extractBridgedArg<bool>(value, 'verboseLogging'),
    },
    constructorSignatures: {
      '': 'SuperTonicTTS({SuperTonicVariant variant = SuperTonicVariant.mobile})',
      'fromName': 'SuperTonicTTS.fromName(String variant)',
      'withManager': 'SuperTonicTTS.withManager(ModelManager manager)',
    },
    methodSignatures: {
      'initialize':
          'Future<void> initialize({void Function(double progress, String status)? onProgress, int? intraOpNumThreads})',
      'generateStream':
          'Stream<Float32List> generateStream(String text, {String voice = \'F1\', String lang = \'en\', double speed = 1.0, int steps = 5, int? maxLen, String? voiceStylePath})',
      'generate':
          'Future<Float32List> generate(String text, {String voice = \'F1\', String lang = \'en\', double speed = 1.0, int steps = 5, double silenceDuration = 0.3, String? voiceStylePath})',
      'generateChunk':
          'Future<Float32List> generateChunk(String text, {String voice = \'F1\', String lang = \'en\', double speed = 1.0, int steps = 5, String? voiceStylePath})',
      'splitText': 'List<String> splitText(String text, {int maxLen = 300})',
      'dispose': 'Future<void> dispose()',
    },
    getterSignatures: {
      'isInitialized': 'bool get isInitialized',
      'modelManager': 'ModelManager get modelManager',
      'sampleRate': 'int get sampleRate',
      'baseChunkSize': 'int get baseChunkSize',
      'chunkCompressFactor': 'int get chunkCompressFactor',
      'ldim': 'int get ldim',
      'availableVoices': 'List<String> get availableVoices',
      'availableLanguages': 'List<String> get availableLanguages',
    },
    staticGetterSignatures: {
      'verboseLogging': 'bool get verboseLogging',
    },
    staticSetterSignatures: {
      'verboseLogging': 'set verboseLogging(dynamic value)',
    },
  );
}

// =============================================================================
// ModelManager Bridge
// =============================================================================

BridgedClass _createModelManagerBridge() {
  return BridgedClass(
    nativeType: $dartnative_supertonic_tts_1.ModelManager,
    name: 'ModelManager',
    isAssignable: (v) => v is $dartnative_supertonic_tts_1.ModelManager,
    constructors: {
      '': (visitor, positional, named) {
        final variant = D4
            .getNamedArgWithDefault<
              $dartnative_supertonic_tts_1.SuperTonicVariant
            >(
              named,
              'variant',
              $dartnative_supertonic_tts_1.SuperTonicVariant.mobile,
            );
        final bundledDir = D4.getOptionalNamedArg<String?>(named, 'bundledDir');
        final r2BaseUrl = D4.getOptionalNamedArg<String?>(named, 'r2BaseUrl');
        return $dartnative_supertonic_tts_1.ModelManager(
          variant: variant,
          bundledDir: bundledDir,
          r2BaseUrl: r2BaseUrl,
        );
      },
    },
    getters: {
      'variant': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
            target,
            'ModelManager',
          )
          .variant,
      'bundledDir': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
            target,
            'ModelManager',
          )
          .bundledDir,
      'r2BaseUrl': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
            target,
            'ModelManager',
          )
          .r2BaseUrl,
      'modelDir': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
            target,
            'ModelManager',
          )
          .modelDir,
      'ttsJsonPath': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
            target,
            'ModelManager',
          )
          .ttsJsonPath,
      'unicodeIndexerPath': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
            target,
            'ModelManager',
          )
          .unicodeIndexerPath,
    },
    methods: {
      'onnxPath': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        D4.requireMinArgs(positional, 1, 'onnxPath');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'onnxPath',
        );
        return t.onnxPath(name);
      },
      'voiceStylePath': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        D4.requireMinArgs(positional, 1, 'voiceStylePath');
        final voice = D4.getRequiredArg<String>(
          positional,
          0,
          'voice',
          'voiceStylePath',
        );
        return t.voiceStylePath(voice);
      },
      'resolve': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        D4.requireMinArgs(positional, 1, 'resolve');
        final localRel = D4.getRequiredArg<String>(
          positional,
          0,
          'localRel',
          'resolve',
        );
        return t.resolve(localRel);
      },
      'pendingDownloadBytes': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        return t.pendingDownloadBytes();
      },
      'pendingDownloadMB': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        return t.pendingDownloadMB();
      },
      'downloadSizeBytes': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        return t.downloadSizeBytes();
      },
      'downloadSizeMB': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        return t.downloadSizeMB();
      },
      'isReady': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        return t.isReady();
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        t.delete();
        return null;
      },
      'cancelDownload': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        t.cancelDownload();
        return null;
      },
      'download': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_1.ModelManager>(
          target,
          'ModelManager',
        );
        final onProgressRaw = named['onProgress'];
        return t.download(
          onProgress: onProgressRaw == null
              ? null
              : (double p0, String p1) {
                  D4.callInterpreterCallback(visitor!, onProgressRaw, [p0, p1]);
                },
        );
      },
    },
    constructorSignatures: {
      '': 'ModelManager({SuperTonicVariant variant = SuperTonicVariant.mobile, String? bundledDir, String? r2BaseUrl})',
    },
    methodSignatures: {
      'onnxPath': 'String onnxPath(String name)',
      'voiceStylePath': 'String voiceStylePath(String voice)',
      'resolve': 'String resolve(String localRel)',
      'pendingDownloadBytes': 'int pendingDownloadBytes()',
      'pendingDownloadMB': 'int pendingDownloadMB()',
      'downloadSizeBytes': 'int downloadSizeBytes()',
      'downloadSizeMB': 'int downloadSizeMB()',
      'isReady': 'bool isReady()',
      'delete': 'void delete()',
      'cancelDownload': 'void cancelDownload()',
      'download':
          'Future<void> download({void Function(double progress, String status)? onProgress})',
    },
    getterSignatures: {
      'variant': 'SuperTonicVariant get variant',
      'bundledDir': 'String? get bundledDir',
      'r2BaseUrl': 'String? get r2BaseUrl',
      'modelDir': 'String get modelDir',
      'ttsJsonPath': 'String get ttsJsonPath',
      'unicodeIndexerPath': 'String get unicodeIndexerPath',
    },
  );
}

// =============================================================================
// TTSConfig Bridge
// =============================================================================

BridgedClass _createTTSConfigBridge() {
  return BridgedClass(
    nativeType: $dartnative_supertonic_tts_4.TTSConfig,
    name: 'TTSConfig',
    isAssignable: (v) => v is $dartnative_supertonic_tts_4.TTSConfig,
    constructors: {
      '': (visitor, positional, named) {
        final denoisingSteps = D4.getNamedArgWithDefault<int>(
          named,
          'denoisingSteps',
          5,
        );
        final speechSpeed = D4.getNamedArgWithDefault<double>(
          named,
          'speechSpeed',
          1.05,
        );
        final silenceDuration = D4.getNamedArgWithDefault<double>(
          named,
          'silenceDuration',
          0.3,
        );
        return $dartnative_supertonic_tts_4.TTSConfig(
          denoisingSteps: denoisingSteps,
          speechSpeed: speechSpeed,
          silenceDuration: silenceDuration,
        );
      },
    },
    getters: {
      'denoisingSteps': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_4.TTSConfig>(
            target,
            'TTSConfig',
          )
          .denoisingSteps,
      'speechSpeed': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_4.TTSConfig>(
            target,
            'TTSConfig',
          )
          .speechSpeed,
      'silenceDuration': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_4.TTSConfig>(
            target,
            'TTSConfig',
          )
          .silenceDuration,
    },
    methods: {
      'copyWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_4.TTSConfig>(
          target,
          'TTSConfig',
        );
        final denoisingSteps = D4.getOptionalNamedArg<int?>(
          named,
          'denoisingSteps',
        );
        final speechSpeed = D4.getOptionalNamedArg<double?>(
          named,
          'speechSpeed',
        );
        final silenceDuration = D4.getOptionalNamedArg<double?>(
          named,
          'silenceDuration',
        );
        return t.copyWith(
          denoisingSteps: denoisingSteps,
          speechSpeed: speechSpeed,
          silenceDuration: silenceDuration,
        );
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_4.TTSConfig>(
          target,
          'TTSConfig',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const TTSConfig({int denoisingSteps = 5, double speechSpeed = 1.05, double silenceDuration = 0.3})',
    },
    methodSignatures: {
      'copyWith':
          'TTSConfig copyWith({int? denoisingSteps, double? speechSpeed, double? silenceDuration})',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'denoisingSteps': 'int get denoisingSteps',
      'speechSpeed': 'double get speechSpeed',
      'silenceDuration': 'double get silenceDuration',
    },
  );
}

// =============================================================================
// TTSResult Bridge
// =============================================================================

BridgedClass _createTTSResultBridge() {
  return BridgedClass(
    nativeType: $dartnative_supertonic_tts_6.TTSResult,
    name: 'TTSResult',
    isAssignable: (v) => v is $dartnative_supertonic_tts_6.TTSResult,
    constructors: {
      '': (visitor, positional, named) {
        final audioData = D4.getRequiredNamedArg<Float64List>(
          named,
          'audioData',
          'TTSResult',
        );
        final sampleRate = D4.getRequiredNamedArg<int>(
          named,
          'sampleRate',
          'TTSResult',
        );
        final duration = D4.getRequiredNamedArg<double>(
          named,
          'duration',
          'TTSResult',
        );
        return $dartnative_supertonic_tts_6.TTSResult(
          audioData: audioData,
          sampleRate: sampleRate,
          duration: duration,
        );
      },
    },
    getters: {
      'audioData': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_6.TTSResult>(
            target,
            'TTSResult',
          )
          .audioData,
      'sampleRate': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_6.TTSResult>(
            target,
            'TTSResult',
          )
          .sampleRate,
      'duration': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_6.TTSResult>(
            target,
            'TTSResult',
          )
          .duration,
    },
    methods: {
      'toWavBytes': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_6.TTSResult>(
          target,
          'TTSResult',
        );
        return t.toWavBytes();
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_6.TTSResult>(
          target,
          'TTSResult',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const TTSResult({required Float64List audioData, required int sampleRate, required double duration})',
    },
    methodSignatures: {
      'toWavBytes': 'Uint8List toWavBytes()',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'audioData': 'Float64List get audioData',
      'sampleRate': 'int get sampleRate',
      'duration': 'double get duration',
    },
  );
}

// =============================================================================
// TTSVoiceStyle Bridge
// =============================================================================

BridgedClass _createTTSVoiceStyleBridge() {
  return BridgedClass(
    nativeType: $dartnative_supertonic_tts_7.TTSVoiceStyle,
    name: 'TTSVoiceStyle',
    isAssignable: (v) => v is $dartnative_supertonic_tts_7.TTSVoiceStyle,
    constructors: {
      '': (visitor, positional, named) {
        final code = D4.getRequiredNamedArg<String>(
          named,
          'code',
          'TTSVoiceStyle',
        );
        final description = D4.getRequiredNamedArg<String>(
          named,
          'description',
          'TTSVoiceStyle',
        );
        final useCases = D4.getRequiredNamedArg<String>(
          named,
          'useCases',
          'TTSVoiceStyle',
        );
        final example = D4.getOptionalNamedArg<String?>(named, 'example');
        return $dartnative_supertonic_tts_7.TTSVoiceStyle(
          code: code,
          description: description,
          useCases: useCases,
          example: example,
        );
      },
    },
    getters: {
      'code': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_7.TTSVoiceStyle>(
            target,
            'TTSVoiceStyle',
          )
          .code,
      'description': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_7.TTSVoiceStyle>(
            target,
            'TTSVoiceStyle',
          )
          .description,
      'useCases': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_7.TTSVoiceStyle>(
            target,
            'TTSVoiceStyle',
          )
          .useCases,
      'example': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_7.TTSVoiceStyle>(
            target,
            'TTSVoiceStyle',
          )
          .example,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_7.TTSVoiceStyle>(
          target,
          'TTSVoiceStyle',
        );
        return t.toString();
      },
    },
    staticGetters: {
      'm1': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.m1,
      'm2': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.m2,
      'm3': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.m3,
      'm4': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.m4,
      'm5': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.m5,
      'f1': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.f1,
      'f2': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.f2,
      'f3': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.f3,
      'f4': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.f4,
      'f5': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.f5,
      'all': (visitor) => $dartnative_supertonic_tts_7.TTSVoiceStyle.all,
    },
    staticMethods: {
      'fromCode': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'fromCode');
        final code = D4.getRequiredArg<String>(
          positional,
          0,
          'code',
          'fromCode',
        );
        return $dartnative_supertonic_tts_7.TTSVoiceStyle.fromCode(code);
      },
    },
    constructorSignatures: {
      '': 'const TTSVoiceStyle({required String code, required String description, required String useCases, String? example})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'code': 'String get code',
      'description': 'String get description',
      'useCases': 'String get useCases',
      'example': 'String? get example',
    },
    staticMethodSignatures: {
      'fromCode': 'TTSVoiceStyle fromCode(String code)',
    },
    staticGetterSignatures: {
      'm1': 'TTSVoiceStyle get m1',
      'm2': 'TTSVoiceStyle get m2',
      'm3': 'TTSVoiceStyle get m3',
      'm4': 'TTSVoiceStyle get m4',
      'm5': 'TTSVoiceStyle get m5',
      'f1': 'TTSVoiceStyle get f1',
      'f2': 'TTSVoiceStyle get f2',
      'f3': 'TTSVoiceStyle get f3',
      'f4': 'TTSVoiceStyle get f4',
      'f5': 'TTSVoiceStyle get f5',
      'all': 'Map<String, TTSVoiceStyle> get all',
    },
  );
}

// =============================================================================
// TTSLanguage Bridge
// =============================================================================

BridgedClass _createTTSLanguageBridge() {
  return BridgedClass(
    nativeType: $dartnative_supertonic_tts_5.TTSLanguage,
    name: 'TTSLanguage',
    isAssignable: (v) => v is $dartnative_supertonic_tts_5.TTSLanguage,
    constructors: {
      '': (visitor, positional, named) {
        final code = D4.getRequiredNamedArg<String>(
          named,
          'code',
          'TTSLanguage',
        );
        final name = D4.getRequiredNamedArg<String>(
          named,
          'name',
          'TTSLanguage',
        );
        final nativeName = D4.getRequiredNamedArg<String>(
          named,
          'nativeName',
          'TTSLanguage',
        );
        return $dartnative_supertonic_tts_5.TTSLanguage(
          code: code,
          name: name,
          nativeName: nativeName,
        );
      },
    },
    getters: {
      'code': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_5.TTSLanguage>(
            target,
            'TTSLanguage',
          )
          .code,
      'name': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_5.TTSLanguage>(
            target,
            'TTSLanguage',
          )
          .name,
      'nativeName': (visitor, target) => D4
          .validateTarget<$dartnative_supertonic_tts_5.TTSLanguage>(
            target,
            'TTSLanguage',
          )
          .nativeName,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_5.TTSLanguage>(
          target,
          'TTSLanguage',
        );
        return t.toString();
      },
    },
    staticGetters: {
      'english': (visitor) => $dartnative_supertonic_tts_5.TTSLanguage.english,
      'korean': (visitor) => $dartnative_supertonic_tts_5.TTSLanguage.korean,
      'spanish': (visitor) => $dartnative_supertonic_tts_5.TTSLanguage.spanish,
      'portuguese': (visitor) =>
          $dartnative_supertonic_tts_5.TTSLanguage.portuguese,
      'french': (visitor) => $dartnative_supertonic_tts_5.TTSLanguage.french,
      'italian': (visitor) => $dartnative_supertonic_tts_5.TTSLanguage.italian,
      'all': (visitor) => $dartnative_supertonic_tts_5.TTSLanguage.all,
    },
    staticMethods: {
      'fromCode': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'fromCode');
        final code = D4.getRequiredArg<String>(
          positional,
          0,
          'code',
          'fromCode',
        );
        return $dartnative_supertonic_tts_5.TTSLanguage.fromCode(code);
      },
    },
    constructorSignatures: {
      '': 'const TTSLanguage({required String code, required String name, required String nativeName})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'code': 'String get code',
      'name': 'String get name',
      'nativeName': 'String get nativeName',
    },
    staticMethodSignatures: {
      'fromCode': 'TTSLanguage fromCode(String code)',
    },
    staticGetterSignatures: {
      'english': 'TTSLanguage get english',
      'korean': 'TTSLanguage get korean',
      'spanish': 'TTSLanguage get spanish',
      'portuguese': 'TTSLanguage get portuguese',
      'french': 'TTSLanguage get french',
      'italian': 'TTSLanguage get italian',
      'all': 'List<TTSLanguage> get all',
    },
  );
}

// =============================================================================
// TTSTestStrings Bridge
// =============================================================================

BridgedClass _createTTSTestStringsBridge() {
  return BridgedClass(
    nativeType: $dartnative_supertonic_tts_5.TTSTestStrings,
    name: 'TTSTestStrings',
    isAssignable: (v) => v is $dartnative_supertonic_tts_5.TTSTestStrings,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_supertonic_tts_5.TTSTestStrings();
      },
    },
    staticMethods: {
      'forLanguage': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'forLanguage');
        final langCode = D4.getRequiredArg<String>(
          positional,
          0,
          'langCode',
          'forLanguage',
        );
        return $dartnative_supertonic_tts_5.TTSTestStrings.forLanguage(
          langCode,
        );
      },
      'shortForLanguage': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'shortForLanguage');
        final langCode = D4.getRequiredArg<String>(
          positional,
          0,
          'langCode',
          'shortForLanguage',
        );
        return $dartnative_supertonic_tts_5.TTSTestStrings.shortForLanguage(
          langCode,
        );
      },
    },
    constructorSignatures: {
      '': 'TTSTestStrings()',
    },
    staticMethodSignatures: {
      'forLanguage': 'String forLanguage(String langCode)',
      'shortForLanguage': 'String shortForLanguage(String langCode)',
    },
  );
}

// =============================================================================
// Tokenizer Bridge
// =============================================================================

BridgedClass _createTokenizerBridge() {
  return BridgedClass(
    nativeType: $dartnative_supertonic_tts_3.Tokenizer,
    name: 'Tokenizer',
    isAssignable: (v) => v is $dartnative_supertonic_tts_3.Tokenizer,
    constructors: {},
    methods: {
      'encode': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_supertonic_tts_3.Tokenizer>(
          target,
          'Tokenizer',
        );
        D4.requireMinArgs(positional, 2, 'encode');
        final text = D4.getRequiredArg<String>(positional, 0, 'text', 'encode');
        final lang = D4.getRequiredArg<String>(positional, 1, 'lang', 'encode');
        return t.encode(text, lang);
      },
    },
    staticMethods: {
      'fromFile': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'fromFile');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'fromFile',
        );
        return $dartnative_supertonic_tts_3.Tokenizer.fromFile(path);
      },
      'preprocessText': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'preprocessText');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'preprocessText',
        );
        final lang = D4.getRequiredArg<String>(
          positional,
          1,
          'lang',
          'preprocessText',
        );
        return $dartnative_supertonic_tts_3.Tokenizer.preprocessText(
          text,
          lang,
        );
      },
    },
    methodSignatures: {
      'encode': 'List<int> encode(String text, String lang)',
    },
    staticMethodSignatures: {
      'fromFile': 'Future<Tokenizer> fromFile(String path)',
      'preprocessText': 'String preprocessText(String text, String lang)',
    },
  );
}

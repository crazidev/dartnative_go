// D4rt Bridge - Generated file, do not edit
// Sources: 6 files
// Generated: 2026-11-24T16:25:35.697968 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:dartnative_audio/src/audio_events.dart' as $dartnative_audio_1;
import 'package:dartnative_audio/src/audio_ffi_bindings.dart'
    as $dartnative_audio_2;
import 'package:dartnative_audio/src/audio_player.dart' as $dartnative_audio_3;
import 'package:dartnative_audio/src/audio_recorder.dart'
    as $dartnative_audio_4;
import 'package:dartnative_audio/src/audio_session.dart' as $dartnative_audio_5;
import 'package:dartnative_audio/src/pcm_stream_player.dart'
    as $dartnative_audio_6;
import 'package:ffi/src/utf8.dart' as $ffi_1;

/// Bridge class for dartnative_audio module.
class DartnativeAudioBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createAudioPlayerBridge(),
      _createPcmStreamPlayerBridge(),
      _createRecordConfigBridge(),
      _createAudioRecorderBridge(),
      _createAudioSessionBridge(),
      _createAudioPlayerEventDataBridge(),
      _createAudioFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'AudioPlayer': _createAudioPlayerBridge,
      'PcmStreamPlayer': _createPcmStreamPlayerBridge,
      'RecordConfig': _createRecordConfigBridge,
      'AudioRecorder': _createAudioRecorderBridge,
      'AudioSession': _createAudioSessionBridge,
      'AudioPlayerEventData': _createAudioPlayerEventDataBridge,
      'AudioFFIBindings': _createAudioFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'AudioPlayer': $dartnative_audio_3.AudioPlayer,
      'PcmStreamPlayer': $dartnative_audio_6.PcmStreamPlayer,
      'RecordConfig': $dartnative_audio_4.RecordConfig,
      'AudioRecorder': $dartnative_audio_4.AudioRecorder,
      'AudioSession': $dartnative_audio_5.AudioSession,
      'AudioPlayerEventData': $dartnative_audio_1.AudioPlayerEventData,
      'AudioFFIBindings': $dartnative_audio_2.AudioFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'AudioPlayer': 'package:dartnative_audio/src/audio_player.dart',
      'PcmStreamPlayer': 'package:dartnative_audio/src/pcm_stream_player.dart',
      'RecordConfig': 'package:dartnative_audio/src/audio_recorder.dart',
      'AudioRecorder': 'package:dartnative_audio/src/audio_recorder.dart',
      'AudioSession': 'package:dartnative_audio/src/audio_session.dart',
      'AudioPlayerEventData': 'package:dartnative_audio/src/audio_events.dart',
      'AudioFFIBindings':
          'package:dartnative_audio/src/audio_ffi_bindings.dart',
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
    return [
      '_DNAudioPlayerCreateDart',
      '_DNAudioPlayerVoidDart',
      '_DNAudioPlayerSetEventCallbackDart',
      '_DNAudioPlayerSetPathDart',
      '_DNAudioPlayerSetVolumeDart',
      '_DNAudioPlayerSetLoopingDart',
      '_DNAudioPlayerGetDurationMsDart',
      '_DNAudioPlayerSeekDart',
      '_DNAudioPlayerIsPlayingDart',
      '_DNPcmCreateDart',
      '_DNPcmVoidDart',
      '_DNPcmConfigureDart',
      '_DNRecorderCreateDart',
      '_DNRecorderVoidDart',
      '_DNRecorderStartDart',
      '_DNRecorderGetAmplitudeDart',
      '_DNAudioSessionSetCategoryDart',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dartnative_audio_5.AudioSessionCategory>(
        name: 'AudioSessionCategory',
        values: $dartnative_audio_5.AudioSessionCategory.values,
      ),
      BridgedEnumDefinition<$dartnative_audio_5.AudioSessionMode>(
        name: 'AudioSessionMode',
        values: $dartnative_audio_5.AudioSessionMode.values,
      ),
      BridgedEnumDefinition<$dartnative_audio_1.AudioPlayerEvent>(
        name: 'AudioPlayerEvent',
        values: $dartnative_audio_1.AudioPlayerEvent.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'AudioSessionCategory': 'package:dartnative_audio/src/audio_session.dart',
      'AudioSessionMode': 'package:dartnative_audio/src/audio_session.dart',
      'AudioPlayerEvent': 'package:dartnative_audio/src/audio_events.dart',
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
        source: 'package:dartnative_audio/dartnative_audio.dart',
        target: 'package:dartnative_audio/src/audio_player.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_audio/dartnative_audio.dart',
        target: 'package:dartnative_audio/src/pcm_stream_player.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_audio/dartnative_audio.dart',
        target: 'package:dartnative_audio/src/audio_recorder.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_audio/dartnative_audio.dart',
        target: 'package:dartnative_audio/src/audio_session.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_audio/dartnative_audio.dart',
        target: 'package:dartnative_audio/src/audio_events.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_audio/dartnative_audio.dart',
        target: 'package:dartnative_audio/src/audio_ffi_bindings.dart',
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
      'package:dartnative_audio/src/audio_events.dart',
      'package:dartnative_audio/src/audio_ffi_bindings.dart',
      'package:dartnative_audio/src/audio_player.dart',
      'package:dartnative_audio/src/audio_recorder.dart',
      'package:dartnative_audio/src/audio_session.dart',
      'package:dartnative_audio/src/pcm_stream_player.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_audio/dartnative_audio.dart';";
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
    'AudioSessionCategory',
    'AudioSessionMode',
    'AudioPlayerEvent',
  ];
}

// =============================================================================
// AudioPlayer Bridge
// =============================================================================

BridgedClass _createAudioPlayerBridge() {
  return BridgedClass(
    nativeType: $dartnative_audio_3.AudioPlayer,
    name: 'AudioPlayer',
    isAssignable: (v) => v is $dartnative_audio_3.AudioPlayer,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_audio_3.AudioPlayer();
      },
    },
    getters: {
      'positionUpdateInterval': (visitor, target) => D4
          .validateTarget<$dartnative_audio_3.AudioPlayer>(
            target,
            'AudioPlayer',
          )
          .positionUpdateInterval,
      'durationMs': (visitor, target) => D4
          .validateTarget<$dartnative_audio_3.AudioPlayer>(
            target,
            'AudioPlayer',
          )
          .durationMs,
      'duration': (visitor, target) => D4
          .validateTarget<$dartnative_audio_3.AudioPlayer>(
            target,
            'AudioPlayer',
          )
          .duration,
      'positionMs': (visitor, target) => D4
          .validateTarget<$dartnative_audio_3.AudioPlayer>(
            target,
            'AudioPlayer',
          )
          .positionMs,
      'position': (visitor, target) => D4
          .validateTarget<$dartnative_audio_3.AudioPlayer>(
            target,
            'AudioPlayer',
          )
          .position,
      'isPlaying': (visitor, target) => D4
          .validateTarget<$dartnative_audio_3.AudioPlayer>(
            target,
            'AudioPlayer',
          )
          .isPlaying,
      'positionStream': (visitor, target) => D4
          .validateTarget<$dartnative_audio_3.AudioPlayer>(
            target,
            'AudioPlayer',
          )
          .positionStream,
      'events': (visitor, target) => D4
          .validateTarget<$dartnative_audio_3.AudioPlayer>(
            target,
            'AudioPlayer',
          )
          .events,
    },
    setters: {
      'positionUpdateInterval': (visitor, target, value) =>
          D4
              .validateTarget<$dartnative_audio_3.AudioPlayer>(
                target,
                'AudioPlayer',
              )
              .positionUpdateInterval = D4.extractBridgedArg<Duration>(
            value,
            'positionUpdateInterval',
          ),
    },
    methods: {
      'setAsset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_3.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'setAsset');
        final assetKey = D4.getRequiredArg<String>(
          positional,
          0,
          'assetKey',
          'setAsset',
        );
        t.setAsset(assetKey);
        return null;
      },
      'setPath': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_3.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'setPath');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'setPath',
        );
        t.setPath(path);
        return null;
      },
      'play': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_3.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        t.play();
        return null;
      },
      'pause': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_3.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        t.pause();
        return null;
      },
      'stop': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_3.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        t.stop();
        return null;
      },
      'seek': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_3.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'seek');
        final position = D4.getRequiredArg<Duration>(
          positional,
          0,
          'position',
          'seek',
        );
        t.seek(position);
        return null;
      },
      'setVolume': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_3.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'setVolume');
        final v = D4.getRequiredArg<double>(positional, 0, 'v', 'setVolume');
        t.setVolume(v);
        return null;
      },
      'setLooping': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_3.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        D4.requireMinArgs(positional, 1, 'setLooping');
        final loop = D4.getRequiredArg<bool>(
          positional,
          0,
          'loop',
          'setLooping',
        );
        t.setLooping(loop);
        return null;
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_3.AudioPlayer>(
          target,
          'AudioPlayer',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    constructorSignatures: {
      '': 'AudioPlayer()',
    },
    methodSignatures: {
      'setAsset': 'void setAsset(String assetKey)',
      'setPath': 'void setPath(String path)',
      'play': 'void play()',
      'pause': 'void pause()',
      'stop': 'void stop()',
      'seek': 'void seek(Duration position)',
      'setVolume': 'void setVolume(double v)',
      'setLooping': 'void setLooping(bool loop)',
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'positionUpdateInterval': 'Duration get positionUpdateInterval',
      'durationMs': 'int get durationMs',
      'duration': 'Duration get duration',
      'positionMs': 'int get positionMs',
      'position': 'Duration get position',
      'isPlaying': 'bool get isPlaying',
      'positionStream': 'Stream<Duration> get positionStream',
      'events': 'Stream<AudioPlayerEventData> get events',
    },
    setterSignatures: {
      'positionUpdateInterval': 'set positionUpdateInterval(dynamic value)',
    },
  );
}

// =============================================================================
// PcmStreamPlayer Bridge
// =============================================================================

BridgedClass _createPcmStreamPlayerBridge() {
  return BridgedClass(
    nativeType: $dartnative_audio_6.PcmStreamPlayer,
    name: 'PcmStreamPlayer',
    isAssignable: (v) => v is $dartnative_audio_6.PcmStreamPlayer,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_audio_6.PcmStreamPlayer();
      },
    },
    methods: {
      'configure': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_6.PcmStreamPlayer>(
          target,
          'PcmStreamPlayer',
        );
        final sampleRate = D4.getRequiredNamedArg<int>(
          named,
          'sampleRate',
          'configure',
        );
        final channels = D4.getNamedArgWithDefault<int>(named, 'channels', 1);
        final bitsPerSample = D4.getNamedArgWithDefault<int>(
          named,
          'bitsPerSample',
          16,
        );
        t.configure(
          sampleRate: sampleRate,
          channels: channels,
          bitsPerSample: bitsPerSample,
        );
        return null;
      },
      'feedChunk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_6.PcmStreamPlayer>(
          target,
          'PcmStreamPlayer',
        );
        D4.requireMinArgs(positional, 1, 'feedChunk');
        final bytes = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'bytes',
          'feedChunk',
        );
        t.feedChunk(bytes);
        return null;
      },
      'stop': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_6.PcmStreamPlayer>(
          target,
          'PcmStreamPlayer',
        );
        t.stop();
        return null;
      },
      'flush': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_6.PcmStreamPlayer>(
          target,
          'PcmStreamPlayer',
        );
        t.flush();
        return null;
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_6.PcmStreamPlayer>(
          target,
          'PcmStreamPlayer',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    constructorSignatures: {
      '': 'PcmStreamPlayer()',
    },
    methodSignatures: {
      'configure':
          'void configure({required int sampleRate, int channels = 1, int bitsPerSample = 16})',
      'feedChunk': 'void feedChunk(Uint8List bytes)',
      'stop': 'void stop()',
      'flush': 'void flush()',
      'dispose': 'void dispose()',
    },
  );
}

// =============================================================================
// RecordConfig Bridge
// =============================================================================

BridgedClass _createRecordConfigBridge() {
  return BridgedClass(
    nativeType: $dartnative_audio_4.RecordConfig,
    name: 'RecordConfig',
    isAssignable: (v) => v is $dartnative_audio_4.RecordConfig,
    constructors: {
      '': (visitor, positional, named) {
        final sampleRate = D4.getNamedArgWithDefault<int>(
          named,
          'sampleRate',
          16000,
        );
        final channels = D4.getNamedArgWithDefault<int>(named, 'channels', 1);
        return $dartnative_audio_4.RecordConfig(
          sampleRate: sampleRate,
          channels: channels,
        );
      },
    },
    getters: {
      'sampleRate': (visitor, target) => D4
          .validateTarget<$dartnative_audio_4.RecordConfig>(
            target,
            'RecordConfig',
          )
          .sampleRate,
      'channels': (visitor, target) => D4
          .validateTarget<$dartnative_audio_4.RecordConfig>(
            target,
            'RecordConfig',
          )
          .channels,
    },
    constructorSignatures: {
      '': 'const RecordConfig({int sampleRate = 16000, int channels = 1})',
    },
    getterSignatures: {
      'sampleRate': 'int get sampleRate',
      'channels': 'int get channels',
    },
  );
}

// =============================================================================
// AudioRecorder Bridge
// =============================================================================

BridgedClass _createAudioRecorderBridge() {
  return BridgedClass(
    nativeType: $dartnative_audio_4.AudioRecorder,
    name: 'AudioRecorder',
    isAssignable: (v) => v is $dartnative_audio_4.AudioRecorder,
    constructors: {
      '': (visitor, positional, named) {
        final amplitudePollInterval = D4.getNamedArgWithDefault<Duration>(
          named,
          'amplitudePollInterval',
          const Duration(milliseconds: 100),
        );
        return $dartnative_audio_4.AudioRecorder(
          amplitudePollInterval: amplitudePollInterval,
        );
      },
    },
    getters: {
      'amplitudePollInterval': (visitor, target) => D4
          .validateTarget<$dartnative_audio_4.AudioRecorder>(
            target,
            'AudioRecorder',
          )
          .amplitudePollInterval,
      'amplitudeStream': (visitor, target) => D4
          .validateTarget<$dartnative_audio_4.AudioRecorder>(
            target,
            'AudioRecorder',
          )
          .amplitudeStream,
    },
    methods: {
      'start': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_4.AudioRecorder>(
          target,
          'AudioRecorder',
        );
        D4.requireMinArgs(positional, 1, 'start');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'start');
        final config = D4
            .getNamedArgWithDefault<$dartnative_audio_4.RecordConfig>(
              named,
              'config',
              const $dartnative_audio_4.RecordConfig(),
            );
        return t.start(path, config: config);
      },
      'stop': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_4.AudioRecorder>(
          target,
          'AudioRecorder',
        );
        return t.stop();
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_4.AudioRecorder>(
          target,
          'AudioRecorder',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    constructorSignatures: {
      '': 'AudioRecorder({Duration amplitudePollInterval = const Duration(milliseconds: 100)})',
    },
    methodSignatures: {
      'start':
          'bool start(String path, {RecordConfig config = const RecordConfig()})',
      'stop': 'String? stop()',
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'amplitudePollInterval': 'Duration get amplitudePollInterval',
      'amplitudeStream': 'Stream<double> get amplitudeStream',
    },
  );
}

// =============================================================================
// AudioSession Bridge
// =============================================================================

BridgedClass _createAudioSessionBridge() {
  return BridgedClass(
    nativeType: $dartnative_audio_5.AudioSession,
    name: 'AudioSession',
    isAssignable: (v) => v is $dartnative_audio_5.AudioSession,
    constructors: {},
    staticMethods: {
      'setCategory': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'setCategory');
        final category = D4
            .getRequiredArg<$dartnative_audio_5.AudioSessionCategory>(
              positional,
              0,
              'category',
              'setCategory',
            );
        final mode = D4
            .getNamedArgWithDefault<$dartnative_audio_5.AudioSessionMode>(
              named,
              'mode',
              $dartnative_audio_5.AudioSessionMode.defaultMode,
            );
        final defaultToSpeaker = D4.getNamedArgWithDefault<bool>(
          named,
          'defaultToSpeaker',
          true,
        );
        return $dartnative_audio_5.AudioSession.setCategory(
          category,
          mode: mode,
          defaultToSpeaker: defaultToSpeaker,
        );
      },
    },
    staticMethodSignatures: {
      'setCategory':
          'void setCategory(AudioSessionCategory category, {AudioSessionMode mode = AudioSessionMode.defaultMode, bool defaultToSpeaker = true})',
    },
  );
}

// =============================================================================
// AudioPlayerEventData Bridge
// =============================================================================

BridgedClass _createAudioPlayerEventDataBridge() {
  return BridgedClass(
    nativeType: $dartnative_audio_1.AudioPlayerEventData,
    name: 'AudioPlayerEventData',
    isAssignable: (v) => v is $dartnative_audio_1.AudioPlayerEventData,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AudioPlayerEventData');
        final type = D4.getRequiredArg<$dartnative_audio_1.AudioPlayerEvent>(
          positional,
          0,
          'type',
          'AudioPlayerEventData',
        );
        final durationMs = D4.getOptionalNamedArg<int?>(named, 'durationMs');
        return $dartnative_audio_1.AudioPlayerEventData(
          type,
          durationMs: durationMs,
        );
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_audio_1.AudioPlayerEventData>(
            target,
            'AudioPlayerEventData',
          )
          .type,
      'durationMs': (visitor, target) => D4
          .validateTarget<$dartnative_audio_1.AudioPlayerEventData>(
            target,
            'AudioPlayerEventData',
          )
          .durationMs,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_audio_1.AudioPlayerEventData>(
          target,
          'AudioPlayerEventData',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const AudioPlayerEventData(AudioPlayerEvent type, {int? durationMs})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'type': 'AudioPlayerEvent get type',
      'durationMs': 'int? get durationMs',
    },
  );
}

// =============================================================================
// AudioFFIBindings Bridge
// =============================================================================

BridgedClass _createAudioFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_audio_2.AudioFFIBindings,
    name: 'AudioFFIBindings',
    isAssignable: (v) => v is $dartnative_audio_2.AudioFFIBindings,
    constructors: {},
    staticGetters: {
      'dnAudioPlayerCreate': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerCreate,
      'dnAudioPlayerDispose': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerDispose,
      'dnAudioPlayerSetEventCallback': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetEventCallback,
      'dnAudioPlayerSetPath': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetPath,
      'dnAudioPlayerSetAsset': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetAsset,
      'dnAudioPlayerPlay': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerPlay,
      'dnAudioPlayerPause': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerPause,
      'dnAudioPlayerStop': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerStop,
      'dnAudioPlayerSetVolume': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetVolume,
      'dnAudioPlayerSetLooping': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetLooping,
      'dnAudioPlayerGetDurationMs': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerGetDurationMs,
      'dnAudioPlayerSeek': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSeek,
      'dnAudioPlayerGetPositionMs': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerGetPositionMs,
      'dnAudioPlayerIsPlaying': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerIsPlaying,
      'dnPcmCreate': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnPcmCreate,
      'dnPcmDispose': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnPcmDispose,
      'dnPcmConfigure': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnPcmConfigure,
      'dnPcmPlay': (visitor) => $dartnative_audio_2.AudioFFIBindings.dnPcmPlay,
      'dnPcmStop': (visitor) => $dartnative_audio_2.AudioFFIBindings.dnPcmStop,
      'dnPcmFlush': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnPcmFlush,
      'dnRecorderCreate': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnRecorderCreate,
      'dnRecorderDispose': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnRecorderDispose,
      'dnRecorderStart': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnRecorderStart,
      'dnRecorderStop': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnRecorderStop,
      'dnRecorderGetAmplitude': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnRecorderGetAmplitude,
      'dnAudioSessionSetCategory': (visitor) =>
          $dartnative_audio_2.AudioFFIBindings.dnAudioSessionSetCategory,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_audio_2.AudioFFIBindings.loadSymbols();
      },
      'assertLoaded': (visitor, positional, named, typeArgs) {
        return $dartnative_audio_2.AudioFFIBindings.assertLoaded();
      },
      'registerPlayer': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'registerPlayer');
        final id = D4.getRequiredArg<int>(
          positional,
          0,
          'id',
          'registerPlayer',
        );
        final player = D4.getRequiredArg<$dartnative_audio_3.AudioPlayer>(
          positional,
          1,
          'player',
          'registerPlayer',
        );
        return $dartnative_audio_2.AudioFFIBindings.registerPlayer(id, player);
      },
      'unregisterPlayer': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'unregisterPlayer');
        final id = D4.getRequiredArg<int>(
          positional,
          0,
          'id',
          'unregisterPlayer',
        );
        return $dartnative_audio_2.AudioFFIBindings.unregisterPlayer(id);
      },
      'dnPcmFeedChunk': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 3, 'dnPcmFeedChunk');
        final id = D4.getRequiredArg<int>(
          positional,
          0,
          'id',
          'dnPcmFeedChunk',
        );
        final ptr = D4.getRequiredArg<Pointer<Uint8>>(
          positional,
          1,
          'ptr',
          'dnPcmFeedChunk',
        );
        final byteCount = D4.getRequiredArg<int>(
          positional,
          2,
          'byteCount',
          'dnPcmFeedChunk',
        );
        return $dartnative_audio_2.AudioFFIBindings.dnPcmFeedChunk(
          id,
          ptr,
          byteCount,
        );
      },
    },
    staticSetters: {
      'dnAudioPlayerCreate': (visitor, value) {
        final dnAudioPlayerCreateRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerCreate',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerCreate =
            (() {
                  return D4.callInterpreterCallback(
                        visitor!,
                        dnAudioPlayerCreateRaw,
                        [],
                      )
                      as int;
                })
                as int Function();
      },
      'dnAudioPlayerDispose': (visitor, value) {
        final dnAudioPlayerDisposeRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerDispose',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerDispose = (int p0) {
          D4.callInterpreterCallback(visitor!, dnAudioPlayerDisposeRaw, [p0]);
        };
      },
      'dnAudioPlayerSetEventCallback': (visitor, value) {
        final dnAudioPlayerSetEventCallbackRaw = D4
            .extractBridgedArgOrNull<dynamic>(
              value,
              'dnAudioPlayerSetEventCallback',
            );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetEventCallback =
            (int p0, int p1) {
              D4.callInterpreterCallback(
                visitor!,
                dnAudioPlayerSetEventCallbackRaw,
                [p0, p1],
              );
            };
      },
      'dnAudioPlayerSetPath': (visitor, value) {
        final dnAudioPlayerSetPathRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerSetPath',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetPath =
            (int p0, Pointer<$ffi_1.Utf8> p1) {
              D4.callInterpreterCallback(visitor!, dnAudioPlayerSetPathRaw, [
                p0,
                p1,
              ]);
            };
      },
      'dnAudioPlayerSetAsset': (visitor, value) {
        final dnAudioPlayerSetAssetRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerSetAsset',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetAsset =
            (int p0, Pointer<$ffi_1.Utf8> p1) {
              D4.callInterpreterCallback(visitor!, dnAudioPlayerSetAssetRaw, [
                p0,
                p1,
              ]);
            };
      },
      'dnAudioPlayerPlay': (visitor, value) {
        final dnAudioPlayerPlayRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerPlay',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerPlay = (int p0) {
          D4.callInterpreterCallback(visitor!, dnAudioPlayerPlayRaw, [p0]);
        };
      },
      'dnAudioPlayerPause': (visitor, value) {
        final dnAudioPlayerPauseRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerPause',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerPause = (int p0) {
          D4.callInterpreterCallback(visitor!, dnAudioPlayerPauseRaw, [p0]);
        };
      },
      'dnAudioPlayerStop': (visitor, value) {
        final dnAudioPlayerStopRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerStop',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerStop = (int p0) {
          D4.callInterpreterCallback(visitor!, dnAudioPlayerStopRaw, [p0]);
        };
      },
      'dnAudioPlayerSetVolume': (visitor, value) {
        final dnAudioPlayerSetVolumeRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerSetVolume',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetVolume =
            (int p0, double p1) {
              D4.callInterpreterCallback(visitor!, dnAudioPlayerSetVolumeRaw, [
                p0,
                p1,
              ]);
            };
      },
      'dnAudioPlayerSetLooping': (visitor, value) {
        final dnAudioPlayerSetLoopingRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerSetLooping',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerSetLooping =
            (int p0, int p1) {
              D4.callInterpreterCallback(visitor!, dnAudioPlayerSetLoopingRaw, [
                p0,
                p1,
              ]);
            };
      },
      'dnAudioPlayerGetDurationMs': (visitor, value) {
        final dnAudioPlayerGetDurationMsRaw = D4
            .extractBridgedArgOrNull<dynamic>(
              value,
              'dnAudioPlayerGetDurationMs',
            );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerGetDurationMs =
            ((int p0) {
                  return D4.callInterpreterCallback(
                        visitor!,
                        dnAudioPlayerGetDurationMsRaw,
                        [p0],
                      )
                      as int;
                })
                as int Function(int);
      },
      'dnAudioPlayerSeek': (visitor, value) {
        final dnAudioPlayerSeekRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerSeek',
        );
        $dartnative_audio_2
            .AudioFFIBindings
            .dnAudioPlayerSeek = (int p0, int p1) {
          D4.callInterpreterCallback(visitor!, dnAudioPlayerSeekRaw, [p0, p1]);
        };
      },
      'dnAudioPlayerGetPositionMs': (visitor, value) {
        final dnAudioPlayerGetPositionMsRaw = D4
            .extractBridgedArgOrNull<dynamic>(
              value,
              'dnAudioPlayerGetPositionMs',
            );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerGetPositionMs =
            ((int p0) {
                  return D4.callInterpreterCallback(
                        visitor!,
                        dnAudioPlayerGetPositionMsRaw,
                        [p0],
                      )
                      as int;
                })
                as int Function(int);
      },
      'dnAudioPlayerIsPlaying': (visitor, value) {
        final dnAudioPlayerIsPlayingRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnAudioPlayerIsPlaying',
        );
        $dartnative_audio_2.AudioFFIBindings.dnAudioPlayerIsPlaying =
            ((int p0) {
                  return D4.callInterpreterCallback(
                        visitor!,
                        dnAudioPlayerIsPlayingRaw,
                        [p0],
                      )
                      as int;
                })
                as int Function(int);
      },
      'dnPcmCreate': (visitor, value) {
        final dnPcmCreateRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnPcmCreate',
        );
        $dartnative_audio_2.AudioFFIBindings.dnPcmCreate =
            (() {
                  return D4.callInterpreterCallback(
                        visitor!,
                        dnPcmCreateRaw,
                        [],
                      )
                      as int;
                })
                as int Function();
      },
      'dnPcmDispose': (visitor, value) {
        final dnPcmDisposeRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnPcmDispose',
        );
        $dartnative_audio_2.AudioFFIBindings.dnPcmDispose = (int p0) {
          D4.callInterpreterCallback(visitor!, dnPcmDisposeRaw, [p0]);
        };
      },
      'dnPcmConfigure': (visitor, value) {
        final dnPcmConfigureRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnPcmConfigure',
        );
        $dartnative_audio_2.AudioFFIBindings.dnPcmConfigure =
            (int p0, int p1, int p2, int p3) {
              D4.callInterpreterCallback(visitor!, dnPcmConfigureRaw, [
                p0,
                p1,
                p2,
                p3,
              ]);
            };
      },
      'dnPcmPlay': (visitor, value) {
        final dnPcmPlayRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnPcmPlay',
        );
        $dartnative_audio_2.AudioFFIBindings.dnPcmPlay = (int p0) {
          D4.callInterpreterCallback(visitor!, dnPcmPlayRaw, [p0]);
        };
      },
      'dnPcmStop': (visitor, value) {
        final dnPcmStopRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnPcmStop',
        );
        $dartnative_audio_2.AudioFFIBindings.dnPcmStop = (int p0) {
          D4.callInterpreterCallback(visitor!, dnPcmStopRaw, [p0]);
        };
      },
      'dnPcmFlush': (visitor, value) {
        final dnPcmFlushRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnPcmFlush',
        );
        $dartnative_audio_2.AudioFFIBindings.dnPcmFlush = (int p0) {
          D4.callInterpreterCallback(visitor!, dnPcmFlushRaw, [p0]);
        };
      },
      'dnRecorderCreate': (visitor, value) {
        final dnRecorderCreateRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnRecorderCreate',
        );
        $dartnative_audio_2.AudioFFIBindings.dnRecorderCreate =
            (() {
                  return D4.callInterpreterCallback(
                        visitor!,
                        dnRecorderCreateRaw,
                        [],
                      )
                      as int;
                })
                as int Function();
      },
      'dnRecorderDispose': (visitor, value) {
        final dnRecorderDisposeRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnRecorderDispose',
        );
        $dartnative_audio_2.AudioFFIBindings.dnRecorderDispose = (int p0) {
          D4.callInterpreterCallback(visitor!, dnRecorderDisposeRaw, [p0]);
        };
      },
      'dnRecorderStart': (visitor, value) {
        final dnRecorderStartRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnRecorderStart',
        );
        $dartnative_audio_2.AudioFFIBindings.dnRecorderStart =
            ((int p0, Pointer<$ffi_1.Utf8> p1, int p2, int p3) {
                  return D4.callInterpreterCallback(
                        visitor!,
                        dnRecorderStartRaw,
                        [p0, p1, p2, p3],
                      )
                      as int;
                })
                as int Function(int, Pointer<$ffi_1.Utf8>, int, int);
      },
      'dnRecorderStop': (visitor, value) {
        final dnRecorderStopRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnRecorderStop',
        );
        $dartnative_audio_2.AudioFFIBindings.dnRecorderStop = (int p0) {
          D4.callInterpreterCallback(visitor!, dnRecorderStopRaw, [p0]);
        };
      },
      'dnRecorderGetAmplitude': (visitor, value) {
        final dnRecorderGetAmplitudeRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'dnRecorderGetAmplitude',
        );
        $dartnative_audio_2.AudioFFIBindings.dnRecorderGetAmplitude =
            ((int p0) {
                  return D4.callInterpreterCallback(
                        visitor!,
                        dnRecorderGetAmplitudeRaw,
                        [p0],
                      )
                      as double;
                })
                as double Function(int);
      },
      'dnAudioSessionSetCategory': (visitor, value) {
        final dnAudioSessionSetCategoryRaw = D4
            .extractBridgedArgOrNull<dynamic>(
              value,
              'dnAudioSessionSetCategory',
            );
        $dartnative_audio_2.AudioFFIBindings.dnAudioSessionSetCategory =
            (Pointer<$ffi_1.Utf8> p0, Pointer<$ffi_1.Utf8> p1, int p2) {
              D4.callInterpreterCallback(
                visitor!,
                dnAudioSessionSetCategoryRaw,
                [p0, p1, p2],
              );
            };
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
      'assertLoaded': 'void assertLoaded()',
      'registerPlayer': 'void registerPlayer(int id, AudioPlayer player)',
      'unregisterPlayer': 'void unregisterPlayer(int id)',
      'dnPcmFeedChunk':
          'void dnPcmFeedChunk(int id, Pointer<Uint8> ptr, int byteCount)',
    },
    staticGetterSignatures: {
      'dnAudioPlayerCreate': '_DNAudioPlayerCreateDart get dnAudioPlayerCreate',
      'dnAudioPlayerDispose': '_DNAudioPlayerVoidDart get dnAudioPlayerDispose',
      'dnAudioPlayerSetEventCallback':
          '_DNAudioPlayerSetEventCallbackDart get dnAudioPlayerSetEventCallback',
      'dnAudioPlayerSetPath':
          '_DNAudioPlayerSetPathDart get dnAudioPlayerSetPath',
      'dnAudioPlayerSetAsset':
          '_DNAudioPlayerSetPathDart get dnAudioPlayerSetAsset',
      'dnAudioPlayerPlay': '_DNAudioPlayerVoidDart get dnAudioPlayerPlay',
      'dnAudioPlayerPause': '_DNAudioPlayerVoidDart get dnAudioPlayerPause',
      'dnAudioPlayerStop': '_DNAudioPlayerVoidDart get dnAudioPlayerStop',
      'dnAudioPlayerSetVolume':
          '_DNAudioPlayerSetVolumeDart get dnAudioPlayerSetVolume',
      'dnAudioPlayerSetLooping':
          '_DNAudioPlayerSetLoopingDart get dnAudioPlayerSetLooping',
      'dnAudioPlayerGetDurationMs':
          '_DNAudioPlayerGetDurationMsDart get dnAudioPlayerGetDurationMs',
      'dnAudioPlayerSeek': '_DNAudioPlayerSeekDart get dnAudioPlayerSeek',
      'dnAudioPlayerGetPositionMs':
          '_DNAudioPlayerGetDurationMsDart get dnAudioPlayerGetPositionMs',
      'dnAudioPlayerIsPlaying':
          '_DNAudioPlayerIsPlayingDart get dnAudioPlayerIsPlaying',
      'dnPcmCreate': '_DNPcmCreateDart get dnPcmCreate',
      'dnPcmDispose': '_DNPcmVoidDart get dnPcmDispose',
      'dnPcmConfigure': '_DNPcmConfigureDart get dnPcmConfigure',
      'dnPcmPlay': '_DNPcmVoidDart get dnPcmPlay',
      'dnPcmStop': '_DNPcmVoidDart get dnPcmStop',
      'dnPcmFlush': '_DNPcmVoidDart get dnPcmFlush',
      'dnRecorderCreate': '_DNRecorderCreateDart get dnRecorderCreate',
      'dnRecorderDispose': '_DNRecorderVoidDart get dnRecorderDispose',
      'dnRecorderStart': '_DNRecorderStartDart get dnRecorderStart',
      'dnRecorderStop': '_DNRecorderVoidDart get dnRecorderStop',
      'dnRecorderGetAmplitude':
          '_DNRecorderGetAmplitudeDart get dnRecorderGetAmplitude',
      'dnAudioSessionSetCategory':
          '_DNAudioSessionSetCategoryDart get dnAudioSessionSetCategory',
    },
    staticSetterSignatures: {
      'dnAudioPlayerCreate': 'set dnAudioPlayerCreate(dynamic value)',
      'dnAudioPlayerDispose': 'set dnAudioPlayerDispose(dynamic value)',
      'dnAudioPlayerSetEventCallback':
          'set dnAudioPlayerSetEventCallback(dynamic value)',
      'dnAudioPlayerSetPath': 'set dnAudioPlayerSetPath(dynamic value)',
      'dnAudioPlayerSetAsset': 'set dnAudioPlayerSetAsset(dynamic value)',
      'dnAudioPlayerPlay': 'set dnAudioPlayerPlay(dynamic value)',
      'dnAudioPlayerPause': 'set dnAudioPlayerPause(dynamic value)',
      'dnAudioPlayerStop': 'set dnAudioPlayerStop(dynamic value)',
      'dnAudioPlayerSetVolume': 'set dnAudioPlayerSetVolume(dynamic value)',
      'dnAudioPlayerSetLooping': 'set dnAudioPlayerSetLooping(dynamic value)',
      'dnAudioPlayerGetDurationMs':
          'set dnAudioPlayerGetDurationMs(dynamic value)',
      'dnAudioPlayerSeek': 'set dnAudioPlayerSeek(dynamic value)',
      'dnAudioPlayerGetPositionMs':
          'set dnAudioPlayerGetPositionMs(dynamic value)',
      'dnAudioPlayerIsPlaying': 'set dnAudioPlayerIsPlaying(dynamic value)',
      'dnPcmCreate': 'set dnPcmCreate(dynamic value)',
      'dnPcmDispose': 'set dnPcmDispose(dynamic value)',
      'dnPcmConfigure': 'set dnPcmConfigure(dynamic value)',
      'dnPcmPlay': 'set dnPcmPlay(dynamic value)',
      'dnPcmStop': 'set dnPcmStop(dynamic value)',
      'dnPcmFlush': 'set dnPcmFlush(dynamic value)',
      'dnRecorderCreate': 'set dnRecorderCreate(dynamic value)',
      'dnRecorderDispose': 'set dnRecorderDispose(dynamic value)',
      'dnRecorderStart': 'set dnRecorderStart(dynamic value)',
      'dnRecorderStop': 'set dnRecorderStop(dynamic value)',
      'dnRecorderGetAmplitude': 'set dnRecorderGetAmplitude(dynamic value)',
      'dnAudioSessionSetCategory':
          'set dnAudioSessionSetCategory(dynamic value)',
    },
  );
}

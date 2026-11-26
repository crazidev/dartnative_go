/// AST-engine host fake for `dartnative_audio`'s `AudioPlayer`.
///
/// The generated bridge constructs the real player, and its FFI bindings
/// assert `Call AudioFFIBindings.loadSymbols() first` when no native library
/// is loaded. The Spotify demo starts playback from `initState`, so a headless
/// route build reaches that assertion before it has drawn anything.
///
/// [FakeAudioPlayer] `implements AudioPlayer`, so it is assignable everywhere
/// the generated bridge's `isAssignable` and the guest's `AudioPlayer?` field
/// expect one: only the constructor and the member adapters differ. Playback
/// is silent: no events and no positions are emitted, which leaves the demo on
/// its initial ("loading") state — exactly what the empty native fake for the
/// other plugins does.
///
/// Both engines are covered: [installFakeAudioPlayerAst] shadows the AST
/// bridge set, [installFakeAudioPlayerSource] the source one.
library;

import 'package:dartnative_audio/dartnative_audio.dart';
import 'package:tom_d4rt/d4rt.dart' as src;
import 'package:tom_d4rt_ast/d4rt.dart' as ast;

/// Library URIs the generated `AudioPlayer` bridge is reachable from.
const List<String> kAudioPlayerAstBridgeUris = [
  'package:dartnative_audio/dartnative_audio.dart',
  'package:dartnative_audio/src/audio_player.dart',
];

/// Silent [AudioPlayer] implementation.
class FakeAudioPlayer implements AudioPlayer {
  @override
  Duration positionUpdateInterval = const Duration(milliseconds: 200);

  bool _playing = false;

  @override
  int get durationMs => 0;

  @override
  Duration get duration => Duration.zero;

  @override
  int get positionMs => 0;

  @override
  Duration get position => Duration.zero;

  @override
  bool get isPlaying => _playing;

  @override
  Stream<Duration> get positionStream => const Stream<Duration>.empty();

  @override
  Stream<AudioPlayerEventData> get events =>
      const Stream<AudioPlayerEventData>.empty();

  @override
  void setAsset(String assetKey) {}

  @override
  void setPath(String path) {}

  @override
  void play() => _playing = true;

  @override
  void pause() => _playing = false;

  @override
  void stop() => _playing = false;

  @override
  void seek(Duration position) {}

  @override
  void setVolume(double v) {}

  @override
  void setLooping(bool loop) {}

  @override
  void dispose() => _playing = false;
}

/// Builds the fake `AudioPlayer` bridge.
ast.BridgedClass buildFakeAudioPlayerAstBridge() {
  AudioPlayer target(Object? value) => value as AudioPlayer;

  return ast.BridgedClass(
    nativeType: AudioPlayer,
    name: 'AudioPlayer',
    isAssignable: (v) => v is AudioPlayer,
    constructors: {
      '': (visitor, positional, named) => FakeAudioPlayer(),
    },
    getters: {
      'positionUpdateInterval': (visitor, value) =>
          target(value).positionUpdateInterval,
      'durationMs': (visitor, value) => target(value).durationMs,
      'duration': (visitor, value) => target(value).duration,
      'positionMs': (visitor, value) => target(value).positionMs,
      'position': (visitor, value) => target(value).position,
      'isPlaying': (visitor, value) => target(value).isPlaying,
      'positionStream': (visitor, value) => target(value).positionStream,
      'events': (visitor, value) => target(value).events,
    },
    setters: {
      'positionUpdateInterval': (visitor, value, interval) =>
          target(value).positionUpdateInterval = ast.D4
              .extractBridgedArg<Duration>(interval, 'positionUpdateInterval'),
    },
    methods: {
      'setAsset': (visitor, value, positional, named, typeArgs) =>
          target(value).setAsset(positional[0] as String),
      'setPath': (visitor, value, positional, named, typeArgs) =>
          target(value).setPath(positional[0] as String),
      'play': (visitor, value, positional, named, typeArgs) =>
          target(value).play(),
      'pause': (visitor, value, positional, named, typeArgs) =>
          target(value).pause(),
      'stop': (visitor, value, positional, named, typeArgs) =>
          target(value).stop(),
      'seek': (visitor, value, positional, named, typeArgs) =>
          target(value).seek(positional[0] as Duration),
      'setVolume': (visitor, value, positional, named, typeArgs) =>
          target(value).setVolume(positional[0] as double),
      'setLooping': (visitor, value, positional, named, typeArgs) =>
          target(value).setLooping(positional[0] as bool),
      'dispose': (visitor, value, positional, named, typeArgs) =>
          target(value).dispose(),
    },
    constructorSignatures: const {
      '': 'AudioPlayer()',
    },
    getterSignatures: const {
      'positionUpdateInterval': 'Duration positionUpdateInterval',
      'durationMs': 'int get durationMs',
      'duration': 'Duration get duration',
      'positionMs': 'int get positionMs',
      'position': 'Duration get position',
      'isPlaying': 'bool get isPlaying',
      'positionStream': 'Stream<Duration> get positionStream',
      'events': 'Stream<AudioPlayerEventData> get events',
    },
    setterSignatures: const {
      'positionUpdateInterval': 'void positionUpdateInterval=(Duration value)',
    },
    methodSignatures: const {
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
  );
}

/// Returns an override for `DnHarness(astBridgeOverrides: [...])`.
void Function(ast.D4rtRunner runner) installFakeAudioPlayerAst() {
  final fake = buildFakeAudioPlayerAstBridge();
  return (runner) {
    for (final uri in kAudioPlayerAstBridgeUris) {
      runner.registerBridgedClass(fake, uri);
    }
  };
}

/// Source-engine counterpart, for `DnHarness(bridgeOverrides: [...])`.
void installFakeAudioPlayerSource(src.D4rt interpreter) {
  AudioPlayer target(Object? value) => value as AudioPlayer;

  final bridge = src.BridgedClass(
    nativeType: AudioPlayer,
    name: 'AudioPlayer',
    isAssignable: (v) => v is AudioPlayer,
    constructors: {
      '': (visitor, positional, named) => FakeAudioPlayer(),
    },
    getters: {
      'positionUpdateInterval': (visitor, value) =>
          target(value).positionUpdateInterval,
      'durationMs': (visitor, value) => target(value).durationMs,
      'duration': (visitor, value) => target(value).duration,
      'positionMs': (visitor, value) => target(value).positionMs,
      'position': (visitor, value) => target(value).position,
      'isPlaying': (visitor, value) => target(value).isPlaying,
      'positionStream': (visitor, value) => target(value).positionStream,
      'events': (visitor, value) => target(value).events,
    },
    setters: {
      'positionUpdateInterval': (visitor, value, interval) =>
          target(value).positionUpdateInterval = src.D4.extractBridgedArg<
            Duration
          >(interval, 'positionUpdateInterval'),
    },
    methods: {
      'setAsset': (visitor, value, positional, named, typeArgs) =>
          target(value).setAsset(positional[0] as String),
      'setPath': (visitor, value, positional, named, typeArgs) =>
          target(value).setPath(positional[0] as String),
      'play': (visitor, value, positional, named, typeArgs) =>
          target(value).play(),
      'pause': (visitor, value, positional, named, typeArgs) =>
          target(value).pause(),
      'stop': (visitor, value, positional, named, typeArgs) =>
          target(value).stop(),
      'seek': (visitor, value, positional, named, typeArgs) =>
          target(value).seek(positional[0] as Duration),
      'setVolume': (visitor, value, positional, named, typeArgs) =>
          target(value).setVolume(positional[0] as double),
      'setLooping': (visitor, value, positional, named, typeArgs) =>
          target(value).setLooping(positional[0] as bool),
      'dispose': (visitor, value, positional, named, typeArgs) =>
          target(value).dispose(),
    },
    constructorSignatures: const {
      '': 'AudioPlayer()',
    },
    getterSignatures: const {
      'positionUpdateInterval': 'Duration positionUpdateInterval',
      'durationMs': 'int get durationMs',
      'duration': 'Duration get duration',
      'positionMs': 'int get positionMs',
      'position': 'Duration get position',
      'isPlaying': 'bool get isPlaying',
      'positionStream': 'Stream<Duration> get positionStream',
      'events': 'Stream<AudioPlayerEventData> get events',
    },
    setterSignatures: const {
      'positionUpdateInterval': 'void positionUpdateInterval=(Duration value)',
    },
    methodSignatures: const {
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
  );
  for (final uri in kAudioPlayerAstBridgeUris) {
    interpreter.registerBridgedClass(bridge, uri);
  }
}

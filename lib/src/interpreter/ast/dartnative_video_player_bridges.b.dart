// D4rt Bridge - Generated file, do not edit
// Sources: 16 files
// Generated: 2026-11-24T16:25:32.671473 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';

import 'package:dartnative/src/core.dart' as $dartnative_1;
import 'package:dartnative/src/painting.dart' as $dartnative_2;
import 'package:dartnative/src/reconciler/element.dart' as $dartnative_3;
import 'package:dartnative/src/reconciler/mutations.dart' as $dartnative_4;
import 'package:dartnative/src/state.dart' as $dartnative_5;
import 'package:dartnative/src/widgets/icon_data.dart' as $dartnative_6;
import 'package:dartnative/src/widgets/image.dart' as $dartnative_7;
import 'package:dartnative_video_player/src/airplay_button.dart'
    as $dartnative_video_player_1;
import 'package:dartnative_video_player/src/controls/video_bottom_bar_controls.dart'
    as $dartnative_video_player_2;
import 'package:dartnative_video_player/src/controls/video_controls_theme.dart'
    as $dartnative_video_player_3;
import 'package:dartnative_video_player/src/controls/video_overlay_controls.dart'
    as $dartnative_video_player_4;
import 'package:dartnative_video_player/src/controls/video_player_with_controls.dart'
    as $dartnative_video_player_5;
import 'package:dartnative_video_player/src/controls/video_progress_bar.dart'
    as $dartnative_video_player_6;
import 'package:dartnative_video_player/src/video_buffering_config.dart'
    as $dartnative_video_player_7;
import 'package:dartnative_video_player/src/video_cache.dart'
    as $dartnative_video_player_8;
import 'package:dartnative_video_player/src/video_cache_config.dart'
    as $dartnative_video_player_9;
import 'package:dartnative_video_player/src/video_data_source.dart'
    as $dartnative_video_player_10;
import 'package:dartnative_video_player/src/video_events.dart'
    as $dartnative_video_player_11;
import 'package:dartnative_video_player/src/video_ffi_bindings.dart'
    as $dartnative_video_player_12;
import 'package:dartnative_video_player/src/video_player.dart'
    as $dartnative_video_player_13;
import 'package:dartnative_video_player/src/video_player_controller.dart'
    as $dartnative_video_player_14;
import 'package:dartnative/dartnative.dart' as $aux_dartnative;

/// Bridge class for dartnative_video_player module.
class DartnativeVideoPlayerBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createVideoPlayerBridge(),
      _createVideoPlayerViewBridge(),
      _createVideoPlayerViewNativeElementBridge(),
      _createNowPlayingInfoBridge(),
      _createVideoPlayerControllerBridge(),
      _createVideoDataSourceBridge(),
      _createVideoCacheBridge(),
      _createVideoCacheConfigBridge(),
      _createVideoBufferingConfigBridge(),
      _createVideoEventBridge(),
      _createVideoFFIBindingsBridge(),
      _createAirPlayButtonBridge(),
      _createVideoControlsThemeBridge(),
      _createVideoOverlayControlsBridge(),
      _createVideoBottomBarControlsBridge(),
      _createVideoProgressColorsBridge(),
      _createVideoProgressBarBridge(),
      _createVideoPlayerWithControlsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'VideoPlayer': _createVideoPlayerBridge,
      'VideoPlayerView': _createVideoPlayerViewBridge,
      'VideoPlayerViewNativeElement': _createVideoPlayerViewNativeElementBridge,
      'NowPlayingInfo': _createNowPlayingInfoBridge,
      'VideoPlayerController': _createVideoPlayerControllerBridge,
      'VideoDataSource': _createVideoDataSourceBridge,
      'VideoCache': _createVideoCacheBridge,
      'VideoCacheConfig': _createVideoCacheConfigBridge,
      'VideoBufferingConfig': _createVideoBufferingConfigBridge,
      'VideoEvent': _createVideoEventBridge,
      'VideoFFIBindings': _createVideoFFIBindingsBridge,
      'AirPlayButton': _createAirPlayButtonBridge,
      'VideoControlsTheme': _createVideoControlsThemeBridge,
      'VideoOverlayControls': _createVideoOverlayControlsBridge,
      'VideoBottomBarControls': _createVideoBottomBarControlsBridge,
      'VideoProgressColors': _createVideoProgressColorsBridge,
      'VideoProgressBar': _createVideoProgressBarBridge,
      'VideoPlayerWithControls': _createVideoPlayerWithControlsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'VideoPlayer': $dartnative_video_player_13.VideoPlayer,
      'VideoPlayerView': $dartnative_video_player_13.VideoPlayerView,
      'VideoPlayerViewNativeElement':
          $dartnative_video_player_13.VideoPlayerViewNativeElement,
      'NowPlayingInfo': $dartnative_video_player_14.NowPlayingInfo,
      'VideoPlayerController':
          $dartnative_video_player_14.VideoPlayerController,
      'VideoDataSource': $dartnative_video_player_10.VideoDataSource,
      'VideoCache': $dartnative_video_player_8.VideoCache,
      'VideoCacheConfig': $dartnative_video_player_9.VideoCacheConfig,
      'VideoBufferingConfig': $dartnative_video_player_7.VideoBufferingConfig,
      'VideoEvent': $dartnative_video_player_11.VideoEvent,
      'VideoFFIBindings': $dartnative_video_player_12.VideoFFIBindings,
      'AirPlayButton': $dartnative_video_player_1.AirPlayButton,
      'VideoControlsTheme': $dartnative_video_player_3.VideoControlsTheme,
      'VideoOverlayControls': $dartnative_video_player_4.VideoOverlayControls,
      'VideoBottomBarControls':
          $dartnative_video_player_2.VideoBottomBarControls,
      'VideoProgressColors': $dartnative_video_player_6.VideoProgressColors,
      'VideoProgressBar': $dartnative_video_player_6.VideoProgressBar,
      'VideoPlayerWithControls':
          $dartnative_video_player_5.VideoPlayerWithControls,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'VideoPlayer': 'package:dartnative_video_player/src/video_player.dart',
      'VideoPlayerView':
          'package:dartnative_video_player/src/video_player.dart',
      'VideoPlayerViewNativeElement':
          'package:dartnative_video_player/src/video_player.dart',
      'NowPlayingInfo':
          'package:dartnative_video_player/src/video_player_controller.dart',
      'VideoPlayerController':
          'package:dartnative_video_player/src/video_player_controller.dart',
      'VideoDataSource':
          'package:dartnative_video_player/src/video_data_source.dart',
      'VideoCache': 'package:dartnative_video_player/src/video_cache.dart',
      'VideoCacheConfig':
          'package:dartnative_video_player/src/video_cache_config.dart',
      'VideoBufferingConfig':
          'package:dartnative_video_player/src/video_buffering_config.dart',
      'VideoEvent': 'package:dartnative_video_player/src/video_events.dart',
      'VideoFFIBindings':
          'package:dartnative_video_player/src/video_ffi_bindings.dart',
      'AirPlayButton':
          'package:dartnative_video_player/src/airplay_button.dart',
      'VideoControlsTheme':
          'package:dartnative_video_player/src/controls/video_controls_theme.dart',
      'VideoOverlayControls':
          'package:dartnative_video_player/src/controls/video_overlay_controls.dart',
      'VideoBottomBarControls':
          'package:dartnative_video_player/src/controls/video_bottom_bar_controls.dart',
      'VideoProgressColors':
          'package:dartnative_video_player/src/controls/video_progress_bar.dart',
      'VideoProgressBar':
          'package:dartnative_video_player/src/controls/video_progress_bar.dart',
      'VideoPlayerWithControls':
          'package:dartnative_video_player/src/controls/video_player_with_controls.dart',
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
      'VideoPlayer': ['StatefulWidget', 'Widget'],
      'VideoPlayerView': ['Widget'],
      'VideoPlayerViewNativeElement': [
        'NativeElement',
        'Element',
        'BuildContext',
      ],
      'AirPlayButton': ['StatefulWidget', 'Widget'],
      'VideoOverlayControls': ['StatefulWidget', 'Widget'],
      'VideoBottomBarControls': ['StatefulWidget', 'Widget'],
      'VideoProgressBar': ['StatefulWidget', 'Widget'],
      'VideoPlayerWithControls': ['StatefulWidget', 'Widget'],
    };
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {
      'ViewId': 'int',
      'MaterialApp': 'App',
      'MaterialPageRoute': 'PageRoute',
    };
  }

  /// Returns the list of function typedef names declared in this library.
  ///
  /// Function typedefs like `typedef VoidCallback = void Function()` are
  /// registered so that they can be used as type arguments in D4rt scripts.
  static List<String> functionTypedefs() {
    return [
      'VoidCallback',
      'ValueChanged',
      'WidgetBuilder',
      'IndexedWidgetBuilder',
      'TransitionBuilder',
      'NotificationListenerCallback',
      'FrameCallback',
      'TextInputFormatFunction',
      'ScrollNotificationPredicate',
      'TickerCallback',
      'DismissDirectionCallback',
      'ConfirmDismissCallback',
      'DismissUpdateCallback',
      'FastScrollCallback',
      'ReorderCallback',
      'NestedScrollViewHeaderSliversBuilder',
      'ReorderItemProxyDecorator',
      'RefreshCallback',
      'RefreshIndicatorBuilder',
      'TooltipTriggeredCallback',
      'AnimatableCallback',
      'ShaderCallback',
      'ArrangementPaneCallback',
      'CodePushAttach',
      'ComputeCallback',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dartnative_7.BoxFit>(
        name: 'BoxFit',
        values: $dartnative_7.BoxFit.values,
      ),
      BridgedEnumDefinition<$dartnative_video_player_10.VideoDataSourceType>(
        name: 'VideoDataSourceType',
        values: $dartnative_video_player_10.VideoDataSourceType.values,
      ),
      BridgedEnumDefinition<$dartnative_video_player_11.VideoEventType>(
        name: 'VideoEventType',
        values: $dartnative_video_player_11.VideoEventType.values,
      ),
      BridgedEnumDefinition<$dartnative_video_player_11.RemoteCommand>(
        name: 'RemoteCommand',
        values: $dartnative_video_player_11.RemoteCommand.values,
      ),
      BridgedEnumDefinition<$dartnative_video_player_5.VideoControlsMode>(
        name: 'VideoControlsMode',
        values: $dartnative_video_player_5.VideoControlsMode.values,
      ),
      BridgedEnumDefinition<
        $dartnative_video_player_5.VideoPlayerCenteringMode
      >(
        name: 'VideoPlayerCenteringMode',
        values: $dartnative_video_player_5.VideoPlayerCenteringMode.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'BoxFit': 'package:dartnative/src/widgets/image.dart',
      'VideoDataSourceType':
          'package:dartnative_video_player/src/video_data_source.dart',
      'VideoEventType': 'package:dartnative_video_player/src/video_events.dart',
      'RemoteCommand': 'package:dartnative_video_player/src/video_events.dart',
      'VideoControlsMode':
          'package:dartnative_video_player/src/controls/video_player_with_controls.dart',
      'VideoPlayerCenteringMode':
          'package:dartnative_video_player/src/controls/video_player_with_controls.dart',
    };
  }

  /// Returns all bridged extension definitions.
  static List<BridgedExtensionDefinition> bridgedExtensions() {
    return [
      BridgedExtensionDefinition(
        name: 'ListenableWatch',
        onTypeName: 'Listenable',
        methods: {
          'watch': (visitor, target, positional, named, typeArgs) {
            final t = target as $dartnative_1.Listenable;
            return Function.apply(
              t.watch,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
    ];
  }

  /// Returns a map of extension identifiers to their canonical source URIs.
  static Map<String, String> extensionSourceUris() {
    return {
      'ListenableWatch@Listenable': 'package:dartnative/src/state.dart',
    };
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
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target: 'package:dartnative_video_player/src/video_player.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target:
            'package:dartnative_video_player/src/video_player_controller.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target: 'package:dartnative_video_player/src/video_data_source.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target: 'package:dartnative_video_player/src/video_cache.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target: 'package:dartnative_video_player/src/video_cache_config.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target:
            'package:dartnative_video_player/src/video_buffering_config.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target: 'package:dartnative_video_player/src/video_events.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target: 'package:dartnative_video_player/src/video_ffi_bindings.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target: 'package:dartnative_video_player/src/airplay_button.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target:
            'package:dartnative_video_player/src/controls/video_controls_theme.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target:
            'package:dartnative_video_player/src/controls/video_overlay_controls.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target:
            'package:dartnative_video_player/src/controls/video_bottom_bar_controls.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target:
            'package:dartnative_video_player/src/controls/video_progress_bar.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_video_player/dartnative_video_player.dart',
        target:
            'package:dartnative_video_player/src/controls/video_player_with_controls.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/core.dart',
        target: 'package:dartnative/src/curves.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets/scaffold.dart',
        target: 'package:dartnative/src/reconciler/mutations.dart',
        show: {'ShowNativeToast', 'ToastPosition'},
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets/buttons.dart',
        target: 'package:dartnative/src/widgets/icon_data.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/flex.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/stack.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/container.dart',
        show: null,
        hide: {'SafeAreaTaken'},
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/visibility.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/layout_extra.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/text.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/text_field.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/text_input_formatter.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/scroll.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/scroll_notification.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/matrix4.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/sliver.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/scaffold.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/slider_menu.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/buttons.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/cupertino_icons.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/material_icons.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/material_symbols_outlined.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/material_symbols_rounded.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/material_symbols_sharp.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/gesture.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/dismissible.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/focus.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/image.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/interactive_viewer.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/fast_list.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/keep_alive.dart',
        show: null,
        hide: {'KeepAliveListHost', 'keepAliveChanged', 'wantsKeepAlive'},
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/tabs.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/nested_scroll_view.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/reorderable_list_view.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/page_view.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/refresh_indicator.dart',
        show: null,
        hide: {'RefreshHost', 'RefreshScope', 'PullBandFollower'},
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/fast_grid.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/masonry_fast_grid.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/grid_view.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/system_chrome.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/dynamic_color.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/search_bar.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/segmented_control.dart',
        show: null,
        hide: {'SegmentedButtonStyle'},
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/tooltip.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/display_feature.dart',
        show: null,
        hide: {
          'DisplayFeatureHost',
          'displayFeaturesFromList',
          'startDeviceHingeIfListening',
        },
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/arrangement_view.dart',
        show: null,
        hide: {'ArrangementHost', 'ArrangementPaneBox'},
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/semantics.dart',
        show: null,
        hide: {'OwnSemantics'},
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/overlay.dart',
        show: null,
        hide: {'RootOverlayLayer'},
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/dropdown_button.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/switch_control.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/slider.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/button.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/bottom_navigation_bar.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/native_alert.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/native_color_picker.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/native_date_picker.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/progress_indicator.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/checkbox.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/floating_action_button.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/shimmer.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/card.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/builders.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/table.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/animation.dart',
        show: null,
        hide: {'transformMatrixOf'},
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/custom_paint.dart',
        show: null,
        hide: {'Gradient', 'TileMode'},
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/clipboard.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/text_painter.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/backdrop_filter.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/shader_mask.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/widgets.dart',
        target: 'package:dartnative/src/widgets/glass_effect_container.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/src/device_orientation_listener.dart',
        target: 'package:dartnative/src/widgets/system_chrome.dart',
        show: {'DeviceOrientation'},
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/core.dart',
        show: null,
        hide: {
          'setFrameTimeStampReader',
          'restartFrameTimerIfNeeded',
          'setAccessibilityFeatures',
          'deliverNotification',
          'setScrollActivity',
        },
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/painting.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/widgets.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/framework.dart',
        show: null,
        hide: {'dnWindowSize', 'dnSystemSetting', 'dnBindingsReady'},
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/state.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/device_orientation_listener.dart',
        show: {'DeviceOrientation', 'DeviceOrientationListener'},
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/logging.dart',
        show: {'DartNativeLogger', 'debugPrint', 'dnLog'},
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/bindings/uikit_bindings.dart',
        show: {'NativeBindings'},
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/callbacks.dart',
        show: {'DnCallbacks'},
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/skia_view_registry.dart',
        show: {
          'registerSkiaViewAddress',
          'unregisterSkiaViewAddress',
          'skiaViewAddresses',
        },
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/license/license.dart',
        show: {
          'DartNativeLicense',
          'LicenseStatus',
          'LicenseException',
          'UpdatePrompt',
        },
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/font_registrant.dart',
        show: {'DartNativeFontRegistrant'},
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/code_push.dart',
        show: {'CodePush', 'CodePushResult', 'CodePushStatus'},
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/json/json_decode.dart',
        show: {'jsonDecodeNative', 'jsonDecodeInBackground'},
        hide: null,
      ),
      (
        source: 'package:dartnative/dartnative.dart',
        target: 'package:dartnative/src/background.dart',
        show: {'runInBackground', 'compute', 'ComputeCallback'},
        hide: null,
      ),
      (
        source:
            'package:dartnative_video_player/src/video_player_controller.dart',
        target: 'package:dartnative/dartnative.dart',
        show: {'BoxFit'},
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

    // Register bridged extensions with source URIs for deduplication
    final extensions = bridgedExtensions();
    final extSources = extensionSourceUris();
    for (final extDef in extensions) {
      final extKey = '${extDef.name ?? '<unnamed>'}@${extDef.onTypeName}';
      interpreter.registerBridgedExtension(
        extDef,
        importPath,
        sourceUri: extSources[extKey],
      );
    }

    // Register class aliases (typedef type aliases)
    final aliases = classAliases();
    for (final entry in aliases.entries) {
      interpreter.registerClassAlias(entry.key, entry.value, importPath);
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
      'registerVideoElementFactory': (visitor, positional, named, typeArgs) {
        return $dartnative_video_player_13.registerVideoElementFactory();
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'registerVideoElementFactory':
          'package:dartnative_video_player/src/video_player.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'registerVideoElementFactory': 'void registerVideoElementFactory()',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative/src/widgets/image.dart',
      'package:dartnative_video_player/src/airplay_button.dart',
      'package:dartnative_video_player/src/controls/video_bottom_bar_controls.dart',
      'package:dartnative_video_player/src/controls/video_controls_theme.dart',
      'package:dartnative_video_player/src/controls/video_overlay_controls.dart',
      'package:dartnative_video_player/src/controls/video_player_with_controls.dart',
      'package:dartnative_video_player/src/controls/video_progress_bar.dart',
      'package:dartnative_video_player/src/video_buffering_config.dart',
      'package:dartnative_video_player/src/video_cache.dart',
      'package:dartnative_video_player/src/video_cache_config.dart',
      'package:dartnative_video_player/src/video_data_source.dart',
      'package:dartnative_video_player/src/video_events.dart',
      'package:dartnative_video_player/src/video_ffi_bindings.dart',
      'package:dartnative_video_player/src/video_player.dart',
      'package:dartnative_video_player/src/video_player_controller.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    final imports = StringBuffer();
    imports.writeln(
      "import 'package:dartnative_video_player/dartnative_video_player.dart';",
    );
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
    'BoxFit',
    'VideoDataSourceType',
    'VideoEventType',
    'RemoteCommand',
    'VideoControlsMode',
    'VideoPlayerCenteringMode',
  ];
}

// =============================================================================
// VideoPlayer Bridge
// =============================================================================

BridgedClass _createVideoPlayerBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_13.VideoPlayer,
    name: 'VideoPlayer',
    isAssignable: (v) => v is $dartnative_video_player_13.VideoPlayer,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final controller = D4
            .getRequiredNamedArg<
              $dartnative_video_player_14.VideoPlayerController
            >(named, 'controller', 'VideoPlayer');
        final aspectRatio = D4.getOptionalNamedArg<double?>(
          named,
          'aspectRatio',
        );
        final fit = D4.getNamedArgWithDefault<$dartnative_7.BoxFit>(
          named,
          'fit',
          $dartnative_7.BoxFit.fill,
        );
        final expandToFill = D4.getNamedArgWithDefault<bool>(
          named,
          'expandToFill',
          true,
        );
        final showControls = D4.getNamedArgWithDefault<bool>(
          named,
          'showControls',
          false,
        );
        return $dartnative_video_player_13.VideoPlayer(
          key: key,
          controller: controller,
          aspectRatio: aspectRatio,
          fit: fit,
          expandToFill: expandToFill,
          showControls: showControls,
        );
      },
    },
    getters: {
      'controller': (visitor, target) =>
          (D4.validateTarget<$dartnative_video_player_13.VideoPlayer>(
                    target,
                    'VideoPlayer',
                  )
                  as dynamic)
              .controller,
      'aspectRatio': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_13.VideoPlayer>(
            target,
            'VideoPlayer',
          )
          .aspectRatio,
      'fit': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_13.VideoPlayer>(
            target,
            'VideoPlayer',
          )
          .fit,
      'expandToFill': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_13.VideoPlayer>(
            target,
            'VideoPlayer',
          )
          .expandToFill,
      'showControls': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_13.VideoPlayer>(
            target,
            'VideoPlayer',
          )
          .showControls,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_13.VideoPlayer>(
            target,
            'VideoPlayer',
          )
          .key,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_video_player_13.VideoPlayer>(
          target,
          'VideoPlayer',
        );
        return t.createState();
      },
    },
    constructorSignatures: {
      '': 'const VideoPlayer({Key? key, required VideoPlayerController controller, double? aspectRatio, BoxFit fit = BoxFit.fill, bool expandToFill = true, bool showControls = false})',
    },
    methodSignatures: {
      'createState': 'State<VideoPlayer> createState()',
    },
    getterSignatures: {
      'controller': 'VideoPlayerController get controller',
      'aspectRatio': 'double? get aspectRatio',
      'fit': 'BoxFit get fit',
      'expandToFill': 'bool get expandToFill',
      'showControls': 'bool get showControls',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// VideoPlayerView Bridge
// =============================================================================

BridgedClass _createVideoPlayerViewBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_13.VideoPlayerView,
    name: 'VideoPlayerView',
    isAssignable: (v) => v is $dartnative_video_player_13.VideoPlayerView,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final controller = D4
            .getRequiredNamedArg<
              $dartnative_video_player_14.VideoPlayerController
            >(named, 'controller', 'VideoPlayerView');
        final aspectRatio = D4.getRequiredNamedArg<double>(
          named,
          'aspectRatio',
          'VideoPlayerView',
        );
        return $dartnative_video_player_13.VideoPlayerView(
          key: key,
          controller: controller,
          aspectRatio: aspectRatio,
        );
      },
    },
    getters: {
      'controller': (visitor, target) =>
          (D4.validateTarget<$dartnative_video_player_13.VideoPlayerView>(
                    target,
                    'VideoPlayerView',
                  )
                  as dynamic)
              .controller,
      'aspectRatio': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_13.VideoPlayerView>(
            target,
            'VideoPlayerView',
          )
          .aspectRatio,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_13.VideoPlayerView>(
            target,
            'VideoPlayerView',
          )
          .key,
    },
    constructorSignatures: {
      '': 'const VideoPlayerView({Key? key, required VideoPlayerController controller, required double aspectRatio})',
    },
    getterSignatures: {
      'controller': 'VideoPlayerController get controller',
      'aspectRatio': 'double get aspectRatio',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// VideoPlayerViewNativeElement Bridge
// =============================================================================

BridgedClass _createVideoPlayerViewNativeElementBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_13.VideoPlayerViewNativeElement,
    name: 'VideoPlayerViewNativeElement',
    isAssignable: (v) =>
        v is $dartnative_video_player_13.VideoPlayerViewNativeElement,
    hierarchyDepth: 3,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'VideoPlayerViewNativeElement');
        final widget = D4.getRequiredArg<$dartnative_1.Widget>(
          positional,
          0,
          'widget',
          'VideoPlayerViewNativeElement',
        );
        return $dartnative_video_player_13.VideoPlayerViewNativeElement(widget);
      },
    },
    getters: {
      'viewType': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .viewType,
      'stretchAsStackFlowChild': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .stretchAsStackFlowChild,
      'isConstraintTransparent': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .isConstraintTransparent,
      'keepsOwnSizeAtRoot': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .keepsOwnSizeAtRoot,
      'widget': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .widget,
      'parent': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .parent,
      'isInsetSensitive': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .isInsetSensitive,
      'viewId': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .viewId,
      'reconciler': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .reconciler,
      'size': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .size,
      'isScrollViewport': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .isScrollViewport,
      'ownRenderObject': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .ownRenderObject,
      'mounted': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .mounted,
      'children': (visitor, target) => D4
          .validateTarget<
            $dartnative_video_player_13.VideoPlayerViewNativeElement
          >(target, 'VideoPlayerViewNativeElement')
          .children,
    },
    methods: {
      'buildProps': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        return t.buildProps();
      },
      'mount': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        D4.requireMinArgs(positional, 2, 'mount');
        final parent = D4.getRequiredArg<$dartnative_3.Element?>(
          positional,
          0,
          'parent',
          'mount',
        );
        final rec = D4.getRequiredArg<$dartnative_3.UIKitReconciler>(
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
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
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
      'emitMutation': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        D4.requireMinArgs(positional, 1, 'emitMutation');
        final mutation = D4.getRequiredArg<$dartnative_4.ViewMutation>(
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
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
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
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        t.rebuild();
        return null;
      },
      'propsEqual': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        D4.requireMinArgs(positional, 2, 'propsEqual');
        final oldProps = D4.getRequiredArg<$dartnative_4.ViewProps?>(
          positional,
          0,
          'oldProps',
          'propsEqual',
        );
        final newProps = D4.getRequiredArg<$dartnative_4.ViewProps>(
          positional,
          1,
          'newProps',
          'propsEqual',
        );
        return t.propsEqual(oldProps, newProps);
      },
      'findRenderObject': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        return t.findRenderObject();
      },
      'fillClaimUnder': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        final parentIsRow = D4.getRequiredNamedArg<bool>(
          named,
          'parentIsRow',
          'fillClaimUnder',
        );
        return t.fillClaimUnder(parentIsRow: parentIsRow);
      },
      'addSubscription': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
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
                .validateTarget<
                  $dartnative_video_player_13.VideoPlayerViewNativeElement
                >(target, 'VideoPlayerViewNativeElement');
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
                .validateTarget<
                  $dartnative_video_player_13.VideoPlayerViewNativeElement
                >(target, 'VideoPlayerViewNativeElement');
            return t.getInheritedWidgetOfExactType();
          },
      'visitChildElements': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
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
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
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
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
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
                .validateTarget<
                  $dartnative_video_player_13.VideoPlayerViewNativeElement
                >(target, 'VideoPlayerViewNativeElement');
            return t.findAncestorWidgetOfExactType();
          },
      'findAncestorStateOfType':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<
                  $dartnative_video_player_13.VideoPlayerViewNativeElement
                >(target, 'VideoPlayerViewNativeElement');
            return t.findAncestorStateOfType();
          },
      'findRootAncestorStateOfType':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<
                  $dartnative_video_player_13.VideoPlayerViewNativeElement
                >(target, 'VideoPlayerViewNativeElement');
            return t.findRootAncestorStateOfType();
          },
      'findAncestorRenderObjectOfType':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<
                  $dartnative_video_player_13.VideoPlayerViewNativeElement
                >(target, 'VideoPlayerViewNativeElement');
            return t.findAncestorRenderObjectOfType();
          },
      'unmount': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        (t as dynamic).unmount();
        return null;
      },
      'replaceChild': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        D4.requireMinArgs(positional, 2, 'replaceChild');
        final oldChild = D4.getRequiredArg<$dartnative_3.Element>(
          positional,
          0,
          'oldChild',
          'replaceChild',
        );
        final newChild = D4.getRequiredArg<$dartnative_3.Element>(
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
            .validateTarget<
              $dartnative_video_player_13.VideoPlayerViewNativeElement
            >(target, 'VideoPlayerViewNativeElement');
        t.markDirty();
        return null;
      },
      'notifyDependencyChanged':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<
                  $dartnative_video_player_13.VideoPlayerViewNativeElement
                >(target, 'VideoPlayerViewNativeElement');
            t.notifyDependencyChanged();
            return null;
          },
    },
    constructorSignatures: {
      '': 'VideoPlayerViewNativeElement(Widget widget)',
    },
    methodSignatures: {
      'buildProps': 'ViewProps buildProps()',
      'mount': 'void mount(Element? parent, UIKitReconciler rec)',
      'update': 'void update(Widget newWidget)',
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
      'unmount': 'void unmount()',
      'replaceChild': 'void replaceChild(Element oldChild, Element newChild)',
      'markDirty': 'void markDirty()',
      'notifyDependencyChanged': 'void notifyDependencyChanged()',
    },
    getterSignatures: {
      'viewType': 'int get viewType',
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
      'children': 'List<Element> get children',
    },
  );
}

// =============================================================================
// NowPlayingInfo Bridge
// =============================================================================

BridgedClass _createNowPlayingInfoBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_14.NowPlayingInfo,
    name: 'NowPlayingInfo',
    isAssignable: (v) => v is $dartnative_video_player_14.NowPlayingInfo,
    constructors: {
      '': (visitor, positional, named) {
        final title = D4.getRequiredNamedArg<String>(
          named,
          'title',
          'NowPlayingInfo',
        );
        final artist = D4.getOptionalNamedArg<String?>(named, 'artist');
        final artworkUrl = D4.getOptionalNamedArg<String?>(named, 'artworkUrl');
        final hasNext = D4.getNamedArgWithDefault<bool>(
          named,
          'hasNext',
          false,
        );
        final hasPrevious = D4.getNamedArgWithDefault<bool>(
          named,
          'hasPrevious',
          false,
        );
        return $dartnative_video_player_14.NowPlayingInfo(
          title: title,
          artist: artist,
          artworkUrl: artworkUrl,
          hasNext: hasNext,
          hasPrevious: hasPrevious,
        );
      },
    },
    getters: {
      'title': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.NowPlayingInfo>(
            target,
            'NowPlayingInfo',
          )
          .title,
      'artist': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.NowPlayingInfo>(
            target,
            'NowPlayingInfo',
          )
          .artist,
      'artworkUrl': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.NowPlayingInfo>(
            target,
            'NowPlayingInfo',
          )
          .artworkUrl,
      'hasNext': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.NowPlayingInfo>(
            target,
            'NowPlayingInfo',
          )
          .hasNext,
      'hasPrevious': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.NowPlayingInfo>(
            target,
            'NowPlayingInfo',
          )
          .hasPrevious,
    },
    constructorSignatures: {
      '': 'const NowPlayingInfo({required String title, String? artist, String? artworkUrl, bool hasNext = false, bool hasPrevious = false})',
    },
    getterSignatures: {
      'title': 'String get title',
      'artist': 'String? get artist',
      'artworkUrl': 'String? get artworkUrl',
      'hasNext': 'bool get hasNext',
      'hasPrevious': 'bool get hasPrevious',
    },
  );
}

// =============================================================================
// VideoPlayerController Bridge
// =============================================================================

BridgedClass _createVideoPlayerControllerBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_14.VideoPlayerController,
    name: 'VideoPlayerController',
    isAssignable: (v) => v is $dartnative_video_player_14.VideoPlayerController,
    constructors: {
      '': (visitor, positional, named) {
        final dataSource = D4
            .getRequiredNamedArg<$dartnative_video_player_10.VideoDataSource>(
              named,
              'dataSource',
              'VideoPlayerController',
            );
        final autoPlay = D4.getNamedArgWithDefault<bool>(
          named,
          'autoPlay',
          false,
        );
        final autoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'autoDispose',
          true,
        );
        final autoPictureInPicture = D4.getNamedArgWithDefault<bool>(
          named,
          'autoPictureInPicture',
          false,
        );
        final allowBackgroundPlayback = D4.getNamedArgWithDefault<bool>(
          named,
          'allowBackgroundPlayback',
          false,
        );
        return $dartnative_video_player_14.VideoPlayerController(
          dataSource: dataSource,
          autoPlay: autoPlay,
          autoDispose: autoDispose,
          autoPictureInPicture: autoPictureInPicture,
          allowBackgroundPlayback: allowBackgroundPlayback,
        );
      },
    },
    getters: {
      'dataSource': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .dataSource,
      'autoPlay': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .autoPlay,
      'autoDispose': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .autoDispose,
      'autoPictureInPicture': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .autoPictureInPicture,
      'allowBackgroundPlayback': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .allowBackgroundPlayback,
      'playerId': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .playerId,
      'volume': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .volume,
      'speed': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .speed,
      'looping': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .looping,
      'fit': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .fit,
      'isInitialized': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .isInitialized,
      'hasFirstFrame': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .hasFirstFrame,
      'isPictureInPictureActive': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .isPictureInPictureActive,
      'isNowPlaying': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .isNowPlaying,
      'isExternalPlaybackActive': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .isExternalPlaybackActive,
      'isPlaying': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .isPlaying,
      'durationMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .durationMs,
      'duration': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .duration,
      'positionMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .positionMs,
      'position': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .position,
      'videoWidth': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .videoWidth,
      'videoHeight': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .videoHeight,
      'events': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .events,
      'nativeViewPtr': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .nativeViewPtr,
      'isDisposed': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
            target,
            'VideoPlayerController',
          )
          .isDisposed,
    },
    setters: {
      'playerId': (visitor, target, value) =>
          D4
              .validateTarget<
                $dartnative_video_player_14.VideoPlayerController
              >(target, 'VideoPlayerController')
              .playerId = D4.extractBridgedArgOrNull<int>(
            value,
            'playerId',
          ),
    },
    methods: {
      'enterPictureInPicture': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        return t.enterPictureInPicture();
      },
      'exitPictureInPicture': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        t.exitPictureInPicture();
        return null;
      },
      'setAutoPictureInPicture':
          (visitor, target, positional, named, typeArgs) {
            final t = D4
                .validateTarget<
                  $dartnative_video_player_14.VideoPlayerController
                >(target, 'VideoPlayerController');
            D4.requireMinArgs(positional, 1, 'setAutoPictureInPicture');
            final on = D4.getRequiredArg<bool>(
              positional,
              0,
              'on',
              'setAutoPictureInPicture',
            );
            t.setAutoPictureInPicture(on);
            return null;
          },
      'setNowPlaying': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        D4.requireMinArgs(positional, 1, 'setNowPlaying');
        final info = D4
            .getRequiredArg<$dartnative_video_player_14.NowPlayingInfo>(
              positional,
              0,
              'info',
              'setNowPlaying',
            );
        t.setNowPlaying(info);
        return null;
      },
      'clearNowPlaying': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        t.clearNowPlaying();
        return null;
      },
      'initialize': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        t.initialize();
        return null;
      },
      'play': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        t.play();
        return null;
      },
      'pause': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        t.pause();
        return null;
      },
      'seekTo': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        D4.requireMinArgs(positional, 1, 'seekTo');
        final position = D4.getRequiredArg<Duration>(
          positional,
          0,
          'position',
          'seekTo',
        );
        t.seekTo(position);
        return null;
      },
      'setVolume': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        D4.requireMinArgs(positional, 1, 'setVolume');
        final volume = D4.getRequiredArg<double>(
          positional,
          0,
          'volume',
          'setVolume',
        );
        t.setVolume(volume);
        return null;
      },
      'setSpeed': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
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
      'setLooping': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        D4.requireMinArgs(positional, 1, 'setLooping');
        final looping = D4.getRequiredArg<bool>(
          positional,
          0,
          'looping',
          'setLooping',
        );
        t.setLooping(looping);
        return null;
      },
      'setFit': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        D4.requireMinArgs(positional, 1, 'setFit');
        final fit = D4.getRequiredArg<$dartnative_7.BoxFit>(
          positional,
          0,
          'fit',
          'setFit',
        );
        t.setFit(fit);
        return null;
      },
      'setHintAspectRatio': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        D4.requireMinArgs(positional, 1, 'setHintAspectRatio');
        final ratio = D4.getRequiredArg<double>(
          positional,
          0,
          'ratio',
          'setHintAspectRatio',
        );
        t.setHintAspectRatio(ratio);
        return null;
      },
      'handleNativeEvent': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        D4.requireMinArgs(positional, 4, 'handleNativeEvent');
        final eventType = D4.getRequiredArg<int>(
          positional,
          0,
          'eventType',
          'handleNativeEvent',
        );
        final arg1 = D4.getRequiredArg<int>(
          positional,
          1,
          'arg1',
          'handleNativeEvent',
        );
        final arg2 = D4.getRequiredArg<int>(
          positional,
          2,
          'arg2',
          'handleNativeEvent',
        );
        final arg3 = D4.getRequiredArg<int>(
          positional,
          3,
          'arg3',
          'handleNativeEvent',
        );
        t.handleNativeEvent(eventType, arg1, arg2, arg3);
        return null;
      },
      'updatePosition': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        D4.requireMinArgs(positional, 1, 'updatePosition');
        final positionMs = D4.getRequiredArg<int>(
          positional,
          0,
          'positionMs',
          'updatePosition',
        );
        t.updatePosition(positionMs);
        return null;
      },
      'addListener': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
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
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
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
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_14.VideoPlayerController>(
              target,
              'VideoPlayerController',
            );
        (t as dynamic).dispose();
        return null;
      },
    },
    staticGetters: {
      'isPictureInPictureSupported': (visitor) => $dartnative_video_player_14
          .VideoPlayerController
          .isPictureInPictureSupported,
    },
    staticMethods: {
      'showAirPlayPicker': (visitor, positional, named, typeArgs) {
        return $dartnative_video_player_14
            .VideoPlayerController.showAirPlayPicker();
      },
      'registerCallbacks': (visitor, positional, named, typeArgs) {
        if (!named.containsKey('create') || named['create'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "create"',
          );
        }
        final createRaw = named['create'];
        final create =
            (($dartnative_video_player_14.VideoPlayerController p0) {
                  return D4.callInterpreterCallback(visitor!, createRaw, [p0])
                      as int;
                })
                as int Function(
                  $dartnative_video_player_14.VideoPlayerController,
                );
        if (!named.containsKey('play') || named['play'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "play"',
          );
        }
        final playRaw = named['play'];
        final play = (int p0) {
          D4.callInterpreterCallback(visitor!, playRaw, [p0]);
        };
        if (!named.containsKey('pause') || named['pause'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "pause"',
          );
        }
        final pauseRaw = named['pause'];
        final pause = (int p0) {
          D4.callInterpreterCallback(visitor!, pauseRaw, [p0]);
        };
        if (!named.containsKey('seekTo') || named['seekTo'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "seekTo"',
          );
        }
        final seekToRaw = named['seekTo'];
        final seekTo = (int p0, int p1) {
          D4.callInterpreterCallback(visitor!, seekToRaw, [p0, p1]);
        };
        if (!named.containsKey('setVolume') || named['setVolume'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "setVolume"',
          );
        }
        final setVolumeRaw = named['setVolume'];
        final setVolume = (int p0, double p1) {
          D4.callInterpreterCallback(visitor!, setVolumeRaw, [p0, p1]);
        };
        if (!named.containsKey('setSpeed') || named['setSpeed'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "setSpeed"',
          );
        }
        final setSpeedRaw = named['setSpeed'];
        final setSpeed = (int p0, double p1) {
          D4.callInterpreterCallback(visitor!, setSpeedRaw, [p0, p1]);
        };
        if (!named.containsKey('setLooping') || named['setLooping'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "setLooping"',
          );
        }
        final setLoopingRaw = named['setLooping'];
        final setLooping = (int p0, bool p1) {
          D4.callInterpreterCallback(visitor!, setLoopingRaw, [p0, p1]);
        };
        if (!named.containsKey('setFit') || named['setFit'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "setFit"',
          );
        }
        final setFitRaw = named['setFit'];
        final setFit = (int p0, int p1) {
          D4.callInterpreterCallback(visitor!, setFitRaw, [p0, p1]);
        };
        final setHintAspectRatioRaw = named['setHintAspectRatio'];
        final setHintAspectRatio = setHintAspectRatioRaw == null
            ? null
            : (int p0, double p1) {
                D4.callInterpreterCallback(visitor!, setHintAspectRatioRaw, [
                  p0,
                  p1,
                ]);
              };
        if (!named.containsKey('disposePlayer') ||
            named['disposePlayer'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "disposePlayer"',
          );
        }
        final disposePlayerRaw = named['disposePlayer'];
        final disposePlayer = (int p0) {
          D4.callInterpreterCallback(visitor!, disposePlayerRaw, [p0]);
        };
        if (!named.containsKey('getViewPtr') || named['getViewPtr'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "getViewPtr"',
          );
        }
        final getViewPtrRaw = named['getViewPtr'];
        final getViewPtr =
            ((int p0) {
                  return D4.callInterpreterCallback(visitor!, getViewPtrRaw, [
                        p0,
                      ])
                      as int;
                })
                as int Function(int);
        final pictureInPictureSupportedRaw = named['pictureInPictureSupported'];
        final pictureInPictureSupported = pictureInPictureSupportedRaw == null
            ? null
            : (() {
                    return D4.callInterpreterCallback(
                          visitor!,
                          pictureInPictureSupportedRaw,
                          [],
                        )
                        as int;
                  })
                  as int Function();
        final enterPictureInPictureRaw = named['enterPictureInPicture'];
        final enterPictureInPicture = enterPictureInPictureRaw == null
            ? null
            : ((int p0) {
                    return D4.callInterpreterCallback(
                          visitor!,
                          enterPictureInPictureRaw,
                          [p0],
                        )
                        as int;
                  })
                  as int Function(int);
        final exitPictureInPictureRaw = named['exitPictureInPicture'];
        final exitPictureInPicture = exitPictureInPictureRaw == null
            ? null
            : (int p0) {
                D4.callInterpreterCallback(visitor!, exitPictureInPictureRaw, [
                  p0,
                ]);
              };
        final setAutoPictureInPictureRaw = named['setAutoPictureInPicture'];
        final setAutoPictureInPicture = setAutoPictureInPictureRaw == null
            ? null
            : (int p0, bool p1) {
                D4.callInterpreterCallback(
                  visitor!,
                  setAutoPictureInPictureRaw,
                  [p0, p1],
                );
              };
        final setBackgroundPlaybackRaw = named['setBackgroundPlayback'];
        final setBackgroundPlayback = setBackgroundPlaybackRaw == null
            ? null
            : (int p0, bool p1) {
                D4.callInterpreterCallback(visitor!, setBackgroundPlaybackRaw, [
                  p0,
                  p1,
                ]);
              };
        final setNowPlayingRaw = named['setNowPlaying'];
        final setNowPlaying = setNowPlayingRaw == null
            ? null
            : (int p0, $dartnative_video_player_14.NowPlayingInfo p1) {
                D4.callInterpreterCallback(visitor!, setNowPlayingRaw, [
                  p0,
                  p1,
                ]);
              };
        final clearNowPlayingRaw = named['clearNowPlaying'];
        final clearNowPlaying = clearNowPlayingRaw == null
            ? null
            : (int p0) {
                D4.callInterpreterCallback(visitor!, clearNowPlayingRaw, [p0]);
              };
        final showAirPlayPickerRaw = named['showAirPlayPicker'];
        final showAirPlayPicker = showAirPlayPickerRaw == null
            ? null
            : (() {
                    return D4.callInterpreterCallback(
                          visitor!,
                          showAirPlayPickerRaw,
                          [],
                        )
                        as int;
                  })
                  as int Function();
        return $dartnative_video_player_14
            .VideoPlayerController.registerCallbacks(
          create: create,
          play: play,
          pause: pause,
          seekTo: seekTo,
          setVolume: setVolume,
          setSpeed: setSpeed,
          setLooping: setLooping,
          setFit: setFit,
          setHintAspectRatio: setHintAspectRatio,
          disposePlayer: disposePlayer,
          getViewPtr: getViewPtr,
          pictureInPictureSupported: pictureInPictureSupported,
          enterPictureInPicture: enterPictureInPicture,
          exitPictureInPicture: exitPictureInPicture,
          setAutoPictureInPicture: setAutoPictureInPicture,
          setBackgroundPlayback: setBackgroundPlayback,
          setNowPlaying: setNowPlaying,
          clearNowPlaying: clearNowPlaying,
          showAirPlayPicker: showAirPlayPicker,
        );
      },
    },
    constructorSignatures: {
      '': 'VideoPlayerController({required VideoDataSource dataSource, bool autoPlay = false, bool autoDispose = true, bool autoPictureInPicture = false, bool allowBackgroundPlayback = false})',
    },
    methodSignatures: {
      'enterPictureInPicture': 'bool enterPictureInPicture()',
      'exitPictureInPicture': 'void exitPictureInPicture()',
      'setAutoPictureInPicture': 'void setAutoPictureInPicture(bool on)',
      'setNowPlaying': 'void setNowPlaying(NowPlayingInfo info)',
      'clearNowPlaying': 'void clearNowPlaying()',
      'initialize': 'void initialize()',
      'play': 'void play()',
      'pause': 'void pause()',
      'seekTo': 'void seekTo(Duration position)',
      'setVolume': 'void setVolume(double volume)',
      'setSpeed': 'void setSpeed(double speed)',
      'setLooping': 'void setLooping(bool looping)',
      'setFit': 'void setFit(BoxFit fit)',
      'setHintAspectRatio': 'void setHintAspectRatio(double ratio)',
      'handleNativeEvent':
          'void handleNativeEvent(int eventType, int arg1, int arg2, int arg3)',
      'updatePosition': 'void updatePosition(int positionMs)',
      'addListener': 'void addListener(void Function() listener)',
      'removeListener': 'void removeListener(void Function() listener)',
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'dataSource': 'VideoDataSource get dataSource',
      'autoPlay': 'bool get autoPlay',
      'autoDispose': 'bool get autoDispose',
      'autoPictureInPicture': 'bool get autoPictureInPicture',
      'allowBackgroundPlayback': 'bool get allowBackgroundPlayback',
      'playerId': 'int? get playerId',
      'volume': 'double get volume',
      'speed': 'double get speed',
      'looping': 'bool get looping',
      'fit': 'BoxFit get fit',
      'isInitialized': 'bool get isInitialized',
      'hasFirstFrame': 'bool get hasFirstFrame',
      'isPictureInPictureActive': 'bool get isPictureInPictureActive',
      'isNowPlaying': 'bool get isNowPlaying',
      'isExternalPlaybackActive': 'bool get isExternalPlaybackActive',
      'isPlaying': 'bool get isPlaying',
      'durationMs': 'int get durationMs',
      'duration': 'Duration get duration',
      'positionMs': 'int get positionMs',
      'position': 'Duration get position',
      'videoWidth': 'double get videoWidth',
      'videoHeight': 'double get videoHeight',
      'events': 'Stream<VideoEvent> get events',
      'nativeViewPtr': 'int get nativeViewPtr',
      'isDisposed': 'bool get isDisposed',
    },
    setterSignatures: {
      'playerId': 'set playerId(dynamic value)',
    },
    staticMethodSignatures: {
      'showAirPlayPicker': 'bool showAirPlayPicker()',
      'registerCallbacks':
          'void registerCallbacks({required int Function(VideoPlayerController controller) create, required void Function(int playerId) play, required void Function(int playerId) pause, required void Function(int playerId, int positionMs) seekTo, required void Function(int playerId, double volume) setVolume, required void Function(int playerId, double speed) setSpeed, required void Function(int playerId, bool looping) setLooping, required void Function(int playerId, int fitIndex) setFit, void Function(int playerId, double ratio)? setHintAspectRatio, required void Function(int playerId) disposePlayer, required int Function(int playerId) getViewPtr, int Function()? pictureInPictureSupported, int Function(int playerId)? enterPictureInPicture, void Function(int playerId)? exitPictureInPicture, void Function(int playerId, bool on)? setAutoPictureInPicture, void Function(int playerId, bool on)? setBackgroundPlayback, void Function(int playerId, NowPlayingInfo info)? setNowPlaying, void Function(int playerId)? clearNowPlaying, int Function()? showAirPlayPicker})',
    },
    staticGetterSignatures: {
      'isPictureInPictureSupported': 'bool get isPictureInPictureSupported',
    },
  );
}

// =============================================================================
// VideoDataSource Bridge
// =============================================================================

BridgedClass _createVideoDataSourceBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_10.VideoDataSource,
    name: 'VideoDataSource',
    isAssignable: (v) => v is $dartnative_video_player_10.VideoDataSource,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'VideoDataSource');
        final type = D4
            .getRequiredArg<$dartnative_video_player_10.VideoDataSourceType>(
              positional,
              0,
              'type',
              'VideoDataSource',
            );
        final url = D4.getRequiredArg<String>(
          positional,
          1,
          'url',
          'VideoDataSource',
        );
        final headers = named.containsKey('headers') && named['headers'] != null
            ? D4.coerceMap<String, String>(named['headers'], 'headers')
            : const <String, String>{};
        final cacheConfig = D4
            .getNamedArgWithDefault<
              $dartnative_video_player_9.VideoCacheConfig
            >(
              named,
              'cacheConfig',
              const $dartnative_video_player_9.VideoCacheConfig(),
            );
        final videoExtension = D4.getOptionalNamedArg<String?>(
          named,
          'videoExtension',
        );
        final bufferingConfig = D4
            .getNamedArgWithDefault<
              $dartnative_video_player_7.VideoBufferingConfig
            >(
              named,
              'bufferingConfig',
              const $dartnative_video_player_7.VideoBufferingConfig(),
            );
        return $dartnative_video_player_10.VideoDataSource(
          type,
          url,
          headers: headers,
          cacheConfig: cacheConfig,
          videoExtension: videoExtension,
          bufferingConfig: bufferingConfig,
        );
      },
      'network': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'VideoDataSource');
        final url = D4.getRequiredArg<String>(
          positional,
          0,
          'url',
          'VideoDataSource',
        );
        final headers = named.containsKey('headers') && named['headers'] != null
            ? D4.coerceMap<String, String>(named['headers'], 'headers')
            : const <String, String>{};
        final cacheConfig = D4
            .getNamedArgWithDefault<
              $dartnative_video_player_9.VideoCacheConfig
            >(
              named,
              'cacheConfig',
              const $dartnative_video_player_9.VideoCacheConfig(),
            );
        final videoExtension = D4.getOptionalNamedArg<String?>(
          named,
          'videoExtension',
        );
        final bufferingConfig = D4
            .getNamedArgWithDefault<
              $dartnative_video_player_7.VideoBufferingConfig
            >(
              named,
              'bufferingConfig',
              const $dartnative_video_player_7.VideoBufferingConfig(),
            );
        return $dartnative_video_player_10.VideoDataSource.network(
          url,
          headers: headers,
          cacheConfig: cacheConfig,
          videoExtension: videoExtension,
          bufferingConfig: bufferingConfig,
        );
      },
      'file': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'VideoDataSource');
        final url = D4.getRequiredArg<String>(
          positional,
          0,
          'url',
          'VideoDataSource',
        );
        final cacheConfig = D4
            .getNamedArgWithDefault<
              $dartnative_video_player_9.VideoCacheConfig
            >(
              named,
              'cacheConfig',
              $dartnative_video_player_9.VideoCacheConfig.none,
            );
        final videoExtension = D4.getOptionalNamedArg<String?>(
          named,
          'videoExtension',
        );
        final bufferingConfig = D4
            .getNamedArgWithDefault<
              $dartnative_video_player_7.VideoBufferingConfig
            >(
              named,
              'bufferingConfig',
              const $dartnative_video_player_7.VideoBufferingConfig(),
            );
        return $dartnative_video_player_10.VideoDataSource.file(
          url,
          cacheConfig: cacheConfig,
          videoExtension: videoExtension,
          bufferingConfig: bufferingConfig,
        );
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_10.VideoDataSource>(
            target,
            'VideoDataSource',
          )
          .type,
      'url': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_10.VideoDataSource>(
            target,
            'VideoDataSource',
          )
          .url,
      'headers': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_10.VideoDataSource>(
            target,
            'VideoDataSource',
          )
          .headers,
      'cacheConfig': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_10.VideoDataSource>(
            target,
            'VideoDataSource',
          )
          .cacheConfig,
      'videoExtension': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_10.VideoDataSource>(
            target,
            'VideoDataSource',
          )
          .videoExtension,
      'bufferingConfig': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_10.VideoDataSource>(
            target,
            'VideoDataSource',
          )
          .bufferingConfig,
    },
    constructorSignatures: {
      '': 'const VideoDataSource(VideoDataSourceType type, String url, {Map<String, String> headers = const {}, VideoCacheConfig cacheConfig = const VideoCacheConfig(), String? videoExtension, VideoBufferingConfig bufferingConfig = const VideoBufferingConfig()})',
      'network':
          'const VideoDataSource.network(String url, {Map<String, String> headers = const {}, VideoCacheConfig cacheConfig = const VideoCacheConfig(), String? videoExtension, VideoBufferingConfig bufferingConfig = const VideoBufferingConfig()})',
      'file':
          'const VideoDataSource.file(String url, {VideoCacheConfig cacheConfig = VideoCacheConfig.none, String? videoExtension, VideoBufferingConfig bufferingConfig = const VideoBufferingConfig()})',
    },
    getterSignatures: {
      'type': 'VideoDataSourceType get type',
      'url': 'String get url',
      'headers': 'Map<String, String> get headers',
      'cacheConfig': 'VideoCacheConfig get cacheConfig',
      'videoExtension': 'String? get videoExtension',
      'bufferingConfig': 'VideoBufferingConfig get bufferingConfig',
    },
  );
}

// =============================================================================
// VideoCache Bridge
// =============================================================================

BridgedClass _createVideoCacheBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_8.VideoCache,
    name: 'VideoCache',
    isAssignable: (v) => v is $dartnative_video_player_8.VideoCache,
    constructors: {},
    staticMethods: {
      'registerCallbacks': (visitor, positional, named, typeArgs) {
        if (!named.containsKey('preCache') || named['preCache'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "preCache"',
          );
        }
        final preCacheRaw = named['preCache'];
        final preCache =
            (String p0, String? p1, int p2, Map<String, String> p3) {
              D4.callInterpreterCallback(visitor!, preCacheRaw, [
                p0,
                p1,
                p2,
                p3,
              ]);
            };
        if (!named.containsKey('clearCache') || named['clearCache'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "clearCache"',
          );
        }
        final clearCacheRaw = named['clearCache'];
        final clearCache = (bool p0) {
          D4.callInterpreterCallback(visitor!, clearCacheRaw, [p0]);
        };
        if (!named.containsKey('configure') || named['configure'] == null) {
          throw ArgumentError(
            'registerCallbacks: Missing required named argument "configure"',
          );
        }
        final configureRaw = named['configure'];
        final configure = (int p0) {
          D4.callInterpreterCallback(visitor!, configureRaw, [p0]);
        };
        return $dartnative_video_player_8.VideoCache.registerCallbacks(
          preCache: preCache,
          clearCache: clearCache,
          configure: configure,
        );
      },
      'preCache': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'preCache');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'preCache');
        final cacheKey = D4.getOptionalNamedArg<String?>(named, 'cacheKey');
        final preCacheSize = D4.getNamedArgWithDefault<int>(
          named,
          'preCacheSize',
          500 * 1024,
        );
        final headers = named.containsKey('headers') && named['headers'] != null
            ? D4.coerceMap<String, String>(named['headers'], 'headers')
            : const <String, String>{};
        return $dartnative_video_player_8.VideoCache.preCache(
          url,
          cacheKey: cacheKey,
          preCacheSize: preCacheSize,
          headers: headers,
        );
      },
      'clearCache': (visitor, positional, named, typeArgs) {
        final removeAll = D4.getNamedArgWithDefault<bool>(
          named,
          'removeAll',
          false,
        );
        return $dartnative_video_player_8.VideoCache.clearCache(
          removeAll: removeAll,
        );
      },
      'configure': (visitor, positional, named, typeArgs) {
        final maxCacheSize = D4.getRequiredNamedArg<int>(
          named,
          'maxCacheSize',
          'configure',
        );
        return $dartnative_video_player_8.VideoCache.configure(
          maxCacheSize: maxCacheSize,
        );
      },
    },
    staticMethodSignatures: {
      'registerCallbacks':
          'void registerCallbacks({required void Function(String url, String? cacheKey, int preCacheSize, Map<String, String> headers) preCache, required void Function(bool removeAll) clearCache, required void Function(int maxCacheSize) configure})',
      'preCache':
          'void preCache(String url, {String? cacheKey, int preCacheSize = 500 * 1024, Map<String, String> headers = const {}})',
      'clearCache': 'void clearCache({bool removeAll = false})',
      'configure': 'void configure({required int maxCacheSize})',
    },
  );
}

// =============================================================================
// VideoCacheConfig Bridge
// =============================================================================

BridgedClass _createVideoCacheConfigBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_9.VideoCacheConfig,
    name: 'VideoCacheConfig',
    isAssignable: (v) => v is $dartnative_video_player_9.VideoCacheConfig,
    constructors: {
      '': (visitor, positional, named) {
        final useCache = D4.getNamedArgWithDefault<bool>(
          named,
          'useCache',
          true,
        );
        final preCacheSize = D4.getNamedArgWithDefault<int>(
          named,
          'preCacheSize',
          500 * 1024,
        );
        final maxCacheSize = D4.getNamedArgWithDefault<int>(
          named,
          'maxCacheSize',
          100 * 1024 * 1024,
        );
        final key = D4.getOptionalNamedArg<String?>(named, 'key');
        return $dartnative_video_player_9.VideoCacheConfig(
          useCache: useCache,
          preCacheSize: preCacheSize,
          maxCacheSize: maxCacheSize,
          key: key,
        );
      },
    },
    getters: {
      'useCache': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_9.VideoCacheConfig>(
            target,
            'VideoCacheConfig',
          )
          .useCache,
      'preCacheSize': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_9.VideoCacheConfig>(
            target,
            'VideoCacheConfig',
          )
          .preCacheSize,
      'maxCacheSize': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_9.VideoCacheConfig>(
            target,
            'VideoCacheConfig',
          )
          .maxCacheSize,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_9.VideoCacheConfig>(
            target,
            'VideoCacheConfig',
          )
          .key,
    },
    staticGetters: {
      'none': (visitor) => $dartnative_video_player_9.VideoCacheConfig.none,
    },
    constructorSignatures: {
      '': 'const VideoCacheConfig({bool useCache = true, int preCacheSize = 500 * 1024, int maxCacheSize = 100 * 1024 * 1024, String? key})',
    },
    getterSignatures: {
      'useCache': 'bool get useCache',
      'preCacheSize': 'int get preCacheSize',
      'maxCacheSize': 'int get maxCacheSize',
      'key': 'String? get key',
    },
    staticGetterSignatures: {
      'none': 'VideoCacheConfig get none',
    },
  );
}

// =============================================================================
// VideoBufferingConfig Bridge
// =============================================================================

BridgedClass _createVideoBufferingConfigBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_7.VideoBufferingConfig,
    name: 'VideoBufferingConfig',
    isAssignable: (v) => v is $dartnative_video_player_7.VideoBufferingConfig,
    constructors: {
      '': (visitor, positional, named) {
        final minBufferMs = D4.getNamedArgWithDefault<int>(
          named,
          'minBufferMs',
          50000,
        );
        final maxBufferMs = D4.getNamedArgWithDefault<int>(
          named,
          'maxBufferMs',
          50000,
        );
        final bufferForPlaybackMs = D4.getNamedArgWithDefault<int>(
          named,
          'bufferForPlaybackMs',
          2500,
        );
        final bufferForPlaybackAfterRebufferMs = D4.getNamedArgWithDefault<int>(
          named,
          'bufferForPlaybackAfterRebufferMs',
          5000,
        );
        return $dartnative_video_player_7.VideoBufferingConfig(
          minBufferMs: minBufferMs,
          maxBufferMs: maxBufferMs,
          bufferForPlaybackMs: bufferForPlaybackMs,
          bufferForPlaybackAfterRebufferMs: bufferForPlaybackAfterRebufferMs,
        );
      },
    },
    getters: {
      'minBufferMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_7.VideoBufferingConfig>(
            target,
            'VideoBufferingConfig',
          )
          .minBufferMs,
      'maxBufferMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_7.VideoBufferingConfig>(
            target,
            'VideoBufferingConfig',
          )
          .maxBufferMs,
      'bufferForPlaybackMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_7.VideoBufferingConfig>(
            target,
            'VideoBufferingConfig',
          )
          .bufferForPlaybackMs,
      'bufferForPlaybackAfterRebufferMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_7.VideoBufferingConfig>(
            target,
            'VideoBufferingConfig',
          )
          .bufferForPlaybackAfterRebufferMs,
    },
    staticGetters: {
      'feed': (visitor) => $dartnative_video_player_7.VideoBufferingConfig.feed,
    },
    constructorSignatures: {
      '': 'const VideoBufferingConfig({int minBufferMs = 50000, int maxBufferMs = 50000, int bufferForPlaybackMs = 2500, int bufferForPlaybackAfterRebufferMs = 5000})',
    },
    getterSignatures: {
      'minBufferMs': 'int get minBufferMs',
      'maxBufferMs': 'int get maxBufferMs',
      'bufferForPlaybackMs': 'int get bufferForPlaybackMs',
      'bufferForPlaybackAfterRebufferMs':
          'int get bufferForPlaybackAfterRebufferMs',
    },
    staticGetterSignatures: {
      'feed': 'VideoBufferingConfig get feed',
    },
  );
}

// =============================================================================
// VideoEvent Bridge
// =============================================================================

BridgedClass _createVideoEventBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_11.VideoEvent,
    name: 'VideoEvent',
    isAssignable: (v) => v is $dartnative_video_player_11.VideoEvent,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'VideoEvent');
        final type = D4
            .getRequiredArg<$dartnative_video_player_11.VideoEventType>(
              positional,
              0,
              'type',
              'VideoEvent',
            );
        final durationMs = D4.getOptionalNamedArg<int?>(named, 'durationMs');
        final width = D4.getOptionalNamedArg<double?>(named, 'width');
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final bufferedRanges = D4.coerceListOrNull<(int, int)>(
          named['bufferedRanges'],
          'bufferedRanges',
        );
        final errorMessage = D4.getOptionalNamedArg<String?>(
          named,
          'errorMessage',
        );
        final command = D4
            .getOptionalNamedArg<$dartnative_video_player_11.RemoteCommand?>(
              named,
              'command',
            );
        final positionMs = D4.getOptionalNamedArg<int?>(named, 'positionMs');
        return $dartnative_video_player_11.VideoEvent(
          type,
          durationMs: durationMs,
          width: width,
          height: height,
          bufferedRanges: bufferedRanges,
          errorMessage: errorMessage,
          command: command,
          positionMs: positionMs,
        );
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_11.VideoEvent>(
            target,
            'VideoEvent',
          )
          .type,
      'durationMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_11.VideoEvent>(
            target,
            'VideoEvent',
          )
          .durationMs,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_11.VideoEvent>(
            target,
            'VideoEvent',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_11.VideoEvent>(
            target,
            'VideoEvent',
          )
          .height,
      'bufferedRanges': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_11.VideoEvent>(
            target,
            'VideoEvent',
          )
          .bufferedRanges,
      'errorMessage': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_11.VideoEvent>(
            target,
            'VideoEvent',
          )
          .errorMessage,
      'command': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_11.VideoEvent>(
            target,
            'VideoEvent',
          )
          .command,
      'positionMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_11.VideoEvent>(
            target,
            'VideoEvent',
          )
          .positionMs,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_video_player_11.VideoEvent>(
          target,
          'VideoEvent',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const VideoEvent(VideoEventType type, {int? durationMs, double? width, double? height, List<(int, int)>? bufferedRanges, String? errorMessage, RemoteCommand? command, int? positionMs})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'type': 'VideoEventType get type',
      'durationMs': 'int? get durationMs',
      'width': 'double? get width',
      'height': 'double? get height',
      'bufferedRanges': 'List<(int, int)>? get bufferedRanges',
      'errorMessage': 'String? get errorMessage',
      'command': 'RemoteCommand? get command',
      'positionMs': 'int? get positionMs',
    },
  );
}

// =============================================================================
// VideoFFIBindings Bridge
// =============================================================================

BridgedClass _createVideoFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_12.VideoFFIBindings,
    name: 'VideoFFIBindings',
    isAssignable: (v) => v is $dartnative_video_player_12.VideoFFIBindings,
    constructors: {},
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_video_player_12.VideoFFIBindings.loadSymbols();
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
  );
}

// =============================================================================
// AirPlayButton Bridge
// =============================================================================

BridgedClass _createAirPlayButtonBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_1.AirPlayButton,
    name: 'AirPlayButton',
    isAssignable: (v) => v is $dartnative_video_player_1.AirPlayButton,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final controller = D4
            .getOptionalNamedArg<
              $dartnative_video_player_14.VideoPlayerController?
            >(named, 'controller');
        final size = D4.getNamedArgWithDefault<double>(named, 'size', 24);
        final color = D4.getNamedArgWithDefault<$dartnative_2.Color>(
          named,
          'color',
          const $dartnative_2.Color(0xFFFFFFFF),
        );
        final activeColor = D4.getOptionalNamedArg<$dartnative_2.Color?>(
          named,
          'activeColor',
        );
        final icon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'icon',
        );
        return $dartnative_video_player_1.AirPlayButton(
          key: key,
          controller: controller,
          size: size,
          color: color,
          activeColor: activeColor,
          icon: icon,
        );
      },
    },
    getters: {
      'controller': (visitor, target) =>
          (D4.validateTarget<$dartnative_video_player_1.AirPlayButton>(
                    target,
                    'AirPlayButton',
                  )
                  as dynamic)
              .controller,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_1.AirPlayButton>(
            target,
            'AirPlayButton',
          )
          .size,
      'color': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_1.AirPlayButton>(
            target,
            'AirPlayButton',
          )
          .color,
      'activeColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_1.AirPlayButton>(
            target,
            'AirPlayButton',
          )
          .activeColor,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_1.AirPlayButton>(
            target,
            'AirPlayButton',
          )
          .icon,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_1.AirPlayButton>(
            target,
            'AirPlayButton',
          )
          .key,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_video_player_1.AirPlayButton>(
          target,
          'AirPlayButton',
        );
        return t.createState();
      },
    },
    constructorSignatures: {
      '': 'const AirPlayButton({Key? key, VideoPlayerController? controller, double size = 24, Color color = const Color(0xFFFFFFFF), Color? activeColor, IconData? icon})',
    },
    methodSignatures: {
      'createState': 'State<AirPlayButton> createState()',
    },
    getterSignatures: {
      'controller': 'VideoPlayerController? get controller',
      'size': 'double get size',
      'color': 'Color get color',
      'activeColor': 'Color? get activeColor',
      'icon': 'IconData? get icon',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// VideoControlsTheme Bridge
// =============================================================================

BridgedClass _createVideoControlsThemeBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_3.VideoControlsTheme,
    name: 'VideoControlsTheme',
    isAssignable: (v) => v is $dartnative_video_player_3.VideoControlsTheme,
    constructors: {
      '': (visitor, positional, named) {
        final skipDuration = D4.getNamedArgWithDefault<Duration>(
          named,
          'skipDuration',
          const Duration(seconds: 5),
        );
        final autoHideDuration = D4.getNamedArgWithDefault<Duration>(
          named,
          'autoHideDuration',
          const Duration(seconds: 2),
        );
        final overlayColor = D4.getNamedArgWithDefault<$dartnative_2.Color>(
          named,
          'overlayColor',
          const $dartnative_2.Color(0x40000000),
        );
        final buttonBackgroundColor = D4
            .getNamedArgWithDefault<$dartnative_2.Color>(
              named,
              'buttonBackgroundColor',
              const $dartnative_2.Color(0x66000000),
            );
        final iconColor = D4.getNamedArgWithDefault<$dartnative_2.Color>(
          named,
          'iconColor',
          const $dartnative_2.Color(0xFFFFFFFF),
        );
        final textColor = D4.getNamedArgWithDefault<$dartnative_2.Color>(
          named,
          'textColor',
          const $dartnative_2.Color(0xFFFFFFFF),
        );
        final playPauseSize = D4.getNamedArgWithDefault<double>(
          named,
          'playPauseSize',
          64,
        );
        final playPauseIconSize = D4.getNamedArgWithDefault<double>(
          named,
          'playPauseIconSize',
          34,
        );
        final skipButtonSize = D4.getNamedArgWithDefault<double>(
          named,
          'skipButtonSize',
          48,
        );
        final skipIconSize = D4.getNamedArgWithDefault<double>(
          named,
          'skipIconSize',
          25,
        );
        final timeFontSize = D4.getNamedArgWithDefault<double>(
          named,
          'timeFontSize',
          13,
        );
        final sliderActiveColor = D4
            .getNamedArgWithDefault<$dartnative_2.Color>(
              named,
              'sliderActiveColor',
              const $dartnative_2.Color(0xB3FAFAFA),
            );
        final sliderInactiveColor = D4
            .getNamedArgWithDefault<$dartnative_2.Color>(
              named,
              'sliderInactiveColor',
              const $dartnative_2.Color(0x1A969696),
            );
        final sliderThumbColor = D4.getNamedArgWithDefault<$dartnative_2.Color>(
          named,
          'sliderThumbColor',
          const $dartnative_2.Color(0xFFFAFAFA),
        );
        final playIcon = D4.getNamedArgWithDefault<$dartnative_6.IconData>(
          named,
          'playIcon',
          $aux_dartnative.MaterialSymbolsRounded.play_arrow,
        );
        final pauseIcon = D4.getNamedArgWithDefault<$dartnative_6.IconData>(
          named,
          'pauseIcon',
          $aux_dartnative.MaterialSymbolsRounded.pause,
        );
        final skipBackwardIcon = D4
            .getNamedArgWithDefault<$dartnative_6.IconData>(
              named,
              'skipBackwardIcon',
              $aux_dartnative.MaterialSymbolsRounded.fast_rewind,
            );
        final skipForwardIcon = D4
            .getNamedArgWithDefault<$dartnative_6.IconData>(
              named,
              'skipForwardIcon',
              $aux_dartnative.MaterialSymbolsRounded.fast_forward,
            );
        final fullscreenExitIcon = D4
            .getNamedArgWithDefault<$dartnative_6.IconData>(
              named,
              'fullscreenExitIcon',
              $aux_dartnative.MaterialSymbolsRounded.fullscreen_exit,
            );
        return $dartnative_video_player_3.VideoControlsTheme(
          skipDuration: skipDuration,
          autoHideDuration: autoHideDuration,
          overlayColor: overlayColor,
          buttonBackgroundColor: buttonBackgroundColor,
          iconColor: iconColor,
          textColor: textColor,
          playPauseSize: playPauseSize,
          playPauseIconSize: playPauseIconSize,
          skipButtonSize: skipButtonSize,
          skipIconSize: skipIconSize,
          timeFontSize: timeFontSize,
          sliderActiveColor: sliderActiveColor,
          sliderInactiveColor: sliderInactiveColor,
          sliderThumbColor: sliderThumbColor,
          playIcon: playIcon,
          pauseIcon: pauseIcon,
          skipBackwardIcon: skipBackwardIcon,
          skipForwardIcon: skipForwardIcon,
          fullscreenExitIcon: fullscreenExitIcon,
        );
      },
    },
    getters: {
      'skipDuration': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .skipDuration,
      'autoHideDuration': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .autoHideDuration,
      'overlayColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .overlayColor,
      'buttonBackgroundColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .buttonBackgroundColor,
      'iconColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .iconColor,
      'textColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .textColor,
      'playPauseSize': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .playPauseSize,
      'playPauseIconSize': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .playPauseIconSize,
      'skipButtonSize': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .skipButtonSize,
      'skipIconSize': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .skipIconSize,
      'timeFontSize': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .timeFontSize,
      'sliderActiveColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .sliderActiveColor,
      'sliderInactiveColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .sliderInactiveColor,
      'sliderThumbColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .sliderThumbColor,
      'playIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .playIcon,
      'pauseIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .pauseIcon,
      'skipBackwardIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .skipBackwardIcon,
      'skipForwardIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .skipForwardIcon,
      'fullscreenExitIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_3.VideoControlsTheme>(
            target,
            'VideoControlsTheme',
          )
          .fullscreenExitIcon,
    },
    constructorSignatures: {
      '': 'const VideoControlsTheme({Duration skipDuration = const Duration(seconds: 5), Duration autoHideDuration = const Duration(seconds: 2), Color overlayColor = const Color(0x40000000), Color buttonBackgroundColor = const Color(0x66000000), Color iconColor = const Color(0xFFFFFFFF), Color textColor = const Color(0xFFFFFFFF), double playPauseSize = 64, double playPauseIconSize = 34, double skipButtonSize = 48, double skipIconSize = 25, double timeFontSize = 13, Color sliderActiveColor = const Color(0xB3FAFAFA), Color sliderInactiveColor = const Color(0x1A969696), Color sliderThumbColor = const Color(0xFFFAFAFA), IconData playIcon = MaterialSymbolsRounded.play_arrow, IconData pauseIcon = MaterialSymbolsRounded.pause, IconData skipBackwardIcon = MaterialSymbolsRounded.fast_rewind, IconData skipForwardIcon = MaterialSymbolsRounded.fast_forward, IconData fullscreenExitIcon = MaterialSymbolsRounded.fullscreen_exit})',
    },
    getterSignatures: {
      'skipDuration': 'Duration get skipDuration',
      'autoHideDuration': 'Duration get autoHideDuration',
      'overlayColor': 'Color get overlayColor',
      'buttonBackgroundColor': 'Color get buttonBackgroundColor',
      'iconColor': 'Color get iconColor',
      'textColor': 'Color get textColor',
      'playPauseSize': 'double get playPauseSize',
      'playPauseIconSize': 'double get playPauseIconSize',
      'skipButtonSize': 'double get skipButtonSize',
      'skipIconSize': 'double get skipIconSize',
      'timeFontSize': 'double get timeFontSize',
      'sliderActiveColor': 'Color get sliderActiveColor',
      'sliderInactiveColor': 'Color get sliderInactiveColor',
      'sliderThumbColor': 'Color get sliderThumbColor',
      'playIcon': 'IconData get playIcon',
      'pauseIcon': 'IconData get pauseIcon',
      'skipBackwardIcon': 'IconData get skipBackwardIcon',
      'skipForwardIcon': 'IconData get skipForwardIcon',
      'fullscreenExitIcon': 'IconData get fullscreenExitIcon',
    },
  );
}

// =============================================================================
// VideoOverlayControls Bridge
// =============================================================================

BridgedClass _createVideoOverlayControlsBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_4.VideoOverlayControls,
    name: 'VideoOverlayControls',
    isAssignable: (v) => v is $dartnative_video_player_4.VideoOverlayControls,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final controller = D4
            .getRequiredNamedArg<
              $dartnative_video_player_14.VideoPlayerController
            >(named, 'controller', 'VideoOverlayControls');
        final onExitFullScreenRaw = named['onExitFullScreen'];
        final playIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'playIcon',
        );
        final pauseIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'pauseIcon',
        );
        final forwardIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'forwardIcon',
        );
        final rewindIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'rewindIcon',
        );
        final minimizeIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'minimizeIcon',
        );
        final expandIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'expandIcon',
        );
        final onExpandFullScreenRaw = named['onExpandFullScreen'];
        return $dartnative_video_player_4.VideoOverlayControls(
          key: key,
          controller: controller,
          onExitFullScreen: onExitFullScreenRaw == null
              ? null
              : () {
                  D4.callInterpreterCallback(visitor!, onExitFullScreenRaw, []);
                },
          playIcon: playIcon,
          pauseIcon: pauseIcon,
          forwardIcon: forwardIcon,
          rewindIcon: rewindIcon,
          minimizeIcon: minimizeIcon,
          expandIcon: expandIcon,
          onExpandFullScreen: onExpandFullScreenRaw == null
              ? null
              : () {
                  D4.callInterpreterCallback(
                    visitor!,
                    onExpandFullScreenRaw,
                    [],
                  );
                },
        );
      },
    },
    getters: {
      'controller': (visitor, target) =>
          (D4.validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
                    target,
                    'VideoOverlayControls',
                  )
                  as dynamic)
              .controller,
      'onExitFullScreen': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
            target,
            'VideoOverlayControls',
          )
          .onExitFullScreen,
      'playIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
            target,
            'VideoOverlayControls',
          )
          .playIcon,
      'pauseIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
            target,
            'VideoOverlayControls',
          )
          .pauseIcon,
      'forwardIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
            target,
            'VideoOverlayControls',
          )
          .forwardIcon,
      'rewindIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
            target,
            'VideoOverlayControls',
          )
          .rewindIcon,
      'minimizeIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
            target,
            'VideoOverlayControls',
          )
          .minimizeIcon,
      'expandIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
            target,
            'VideoOverlayControls',
          )
          .expandIcon,
      'onExpandFullScreen': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
            target,
            'VideoOverlayControls',
          )
          .onExpandFullScreen,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
            target,
            'VideoOverlayControls',
          )
          .key,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_4.VideoOverlayControls>(
              target,
              'VideoOverlayControls',
            );
        return t.createState();
      },
    },
    constructorSignatures: {
      '': 'const VideoOverlayControls({Key? key, required VideoPlayerController controller, VoidCallback? onExitFullScreen, IconData? playIcon, IconData? pauseIcon, IconData? forwardIcon, IconData? rewindIcon, IconData? minimizeIcon, IconData? expandIcon, VoidCallback? onExpandFullScreen})',
    },
    methodSignatures: {
      'createState': 'State<VideoOverlayControls> createState()',
    },
    getterSignatures: {
      'controller': 'VideoPlayerController get controller',
      'onExitFullScreen': 'VoidCallback? get onExitFullScreen',
      'playIcon': 'IconData? get playIcon',
      'pauseIcon': 'IconData? get pauseIcon',
      'forwardIcon': 'IconData? get forwardIcon',
      'rewindIcon': 'IconData? get rewindIcon',
      'minimizeIcon': 'IconData? get minimizeIcon',
      'expandIcon': 'IconData? get expandIcon',
      'onExpandFullScreen': 'VoidCallback? get onExpandFullScreen',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// VideoBottomBarControls Bridge
// =============================================================================

BridgedClass _createVideoBottomBarControlsBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_2.VideoBottomBarControls,
    name: 'VideoBottomBarControls',
    isAssignable: (v) => v is $dartnative_video_player_2.VideoBottomBarControls,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final controller = D4
            .getRequiredNamedArg<
              $dartnative_video_player_14.VideoPlayerController
            >(named, 'controller', 'VideoBottomBarControls');
        final playIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'playIcon',
        );
        final pauseIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'pauseIcon',
        );
        final expandIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'expandIcon',
        );
        final onExpandFullScreenRaw = named['onExpandFullScreen'];
        return $dartnative_video_player_2.VideoBottomBarControls(
          key: key,
          controller: controller,
          playIcon: playIcon,
          pauseIcon: pauseIcon,
          expandIcon: expandIcon,
          onExpandFullScreen: onExpandFullScreenRaw == null
              ? null
              : () {
                  D4.callInterpreterCallback(
                    visitor!,
                    onExpandFullScreenRaw,
                    [],
                  );
                },
        );
      },
    },
    getters: {
      'controller': (visitor, target) =>
          (D4.validateTarget<$dartnative_video_player_2.VideoBottomBarControls>(
                    target,
                    'VideoBottomBarControls',
                  )
                  as dynamic)
              .controller,
      'playIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_2.VideoBottomBarControls>(
            target,
            'VideoBottomBarControls',
          )
          .playIcon,
      'pauseIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_2.VideoBottomBarControls>(
            target,
            'VideoBottomBarControls',
          )
          .pauseIcon,
      'expandIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_2.VideoBottomBarControls>(
            target,
            'VideoBottomBarControls',
          )
          .expandIcon,
      'onExpandFullScreen': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_2.VideoBottomBarControls>(
            target,
            'VideoBottomBarControls',
          )
          .onExpandFullScreen,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_2.VideoBottomBarControls>(
            target,
            'VideoBottomBarControls',
          )
          .key,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_2.VideoBottomBarControls>(
              target,
              'VideoBottomBarControls',
            );
        return t.createState();
      },
    },
    constructorSignatures: {
      '': 'const VideoBottomBarControls({Key? key, required VideoPlayerController controller, IconData? playIcon, IconData? pauseIcon, IconData? expandIcon, VoidCallback? onExpandFullScreen})',
    },
    methodSignatures: {
      'createState': 'State<VideoBottomBarControls> createState()',
    },
    getterSignatures: {
      'controller': 'VideoPlayerController get controller',
      'playIcon': 'IconData? get playIcon',
      'pauseIcon': 'IconData? get pauseIcon',
      'expandIcon': 'IconData? get expandIcon',
      'onExpandFullScreen': 'VoidCallback? get onExpandFullScreen',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// VideoProgressColors Bridge
// =============================================================================

BridgedClass _createVideoProgressColorsBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_6.VideoProgressColors,
    name: 'VideoProgressColors',
    isAssignable: (v) => v is $dartnative_video_player_6.VideoProgressColors,
    constructors: {
      '': (visitor, positional, named) {
        final playedColor = D4.getNamedArgWithDefault<$dartnative_2.Color>(
          named,
          'playedColor',
          const $dartnative_2.Color(0xB3FAFAFA),
        );
        final backgroundColor = D4.getNamedArgWithDefault<$dartnative_2.Color>(
          named,
          'backgroundColor',
          const $dartnative_2.Color(0x1A969696),
        );
        final handleColor = D4.getNamedArgWithDefault<$dartnative_2.Color>(
          named,
          'handleColor',
          const $dartnative_2.Color(0xFFFAFAFA),
        );
        return $dartnative_video_player_6.VideoProgressColors(
          playedColor: playedColor,
          backgroundColor: backgroundColor,
          handleColor: handleColor,
        );
      },
    },
    getters: {
      'playedColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressColors>(
            target,
            'VideoProgressColors',
          )
          .playedColor,
      'backgroundColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressColors>(
            target,
            'VideoProgressColors',
          )
          .backgroundColor,
      'handleColor': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressColors>(
            target,
            'VideoProgressColors',
          )
          .handleColor,
    },
    constructorSignatures: {
      '': 'const VideoProgressColors({Color playedColor = const Color(0xB3FAFAFA), Color backgroundColor = const Color(0x1A969696), Color handleColor = const Color(0xFFFAFAFA)})',
    },
    getterSignatures: {
      'playedColor': 'Color get playedColor',
      'backgroundColor': 'Color get backgroundColor',
      'handleColor': 'Color get handleColor',
    },
  );
}

// =============================================================================
// VideoProgressBar Bridge
// =============================================================================

BridgedClass _createVideoProgressBarBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_6.VideoProgressBar,
    name: 'VideoProgressBar',
    isAssignable: (v) => v is $dartnative_video_player_6.VideoProgressBar,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final positionMs = D4.getRequiredNamedArg<int>(
          named,
          'positionMs',
          'VideoProgressBar',
        );
        final durationMs = D4.getRequiredNamedArg<int>(
          named,
          'durationMs',
          'VideoProgressBar',
        );
        final width = D4.getNamedArgWithDefault<double>(named, 'width', 200);
        final height = D4.getNamedArgWithDefault<double>(named, 'height', 52);
        final onSeekRaw = named['onSeek'];
        final onDragStartRaw = named['onDragStart'];
        final onDragEndRaw = named['onDragEnd'];
        final colors = D4
            .getNamedArgWithDefault<
              $dartnative_video_player_6.VideoProgressColors
            >(
              named,
              'colors',
              const $dartnative_video_player_6.VideoProgressColors(),
            );
        final minHitHeight = D4.getNamedArgWithDefault<double>(
          named,
          'minHitHeight',
          44.0,
        );
        return $dartnative_video_player_6.VideoProgressBar(
          key: key,
          positionMs: positionMs,
          durationMs: durationMs,
          width: width,
          height: height,
          onSeek: onSeekRaw == null
              ? null
              : (int p0) {
                  D4.callInterpreterCallback(visitor!, onSeekRaw, [p0]);
                },
          onDragStart: onDragStartRaw == null
              ? null
              : () {
                  D4.callInterpreterCallback(visitor!, onDragStartRaw, []);
                },
          onDragEnd: onDragEndRaw == null
              ? null
              : () {
                  D4.callInterpreterCallback(visitor!, onDragEndRaw, []);
                },
          colors: colors,
          minHitHeight: minHitHeight,
        );
      },
    },
    getters: {
      'positionMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .positionMs,
      'durationMs': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .durationMs,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .height,
      'onSeek': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .onSeek,
      'onDragStart': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .onDragStart,
      'onDragEnd': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .onDragEnd,
      'colors': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .colors,
      'minHitHeight': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .minHitHeight,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
            target,
            'VideoProgressBar',
          )
          .key,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_6.VideoProgressBar>(
              target,
              'VideoProgressBar',
            );
        return t.createState();
      },
    },
    constructorSignatures: {
      '': 'const VideoProgressBar({Key? key, required int positionMs, required int durationMs, double width = 200, double height = 52, ValueChanged<int>? onSeek, VoidCallback? onDragStart, VoidCallback? onDragEnd, VideoProgressColors colors = const VideoProgressColors(), double minHitHeight = 44.0})',
    },
    methodSignatures: {
      'createState': 'State<VideoProgressBar> createState()',
    },
    getterSignatures: {
      'positionMs': 'int get positionMs',
      'durationMs': 'int get durationMs',
      'width': 'double get width',
      'height': 'double get height',
      'onSeek': 'ValueChanged<int>? get onSeek',
      'onDragStart': 'VoidCallback? get onDragStart',
      'onDragEnd': 'VoidCallback? get onDragEnd',
      'colors': 'VideoProgressColors get colors',
      'minHitHeight': 'double get minHitHeight',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// VideoPlayerWithControls Bridge
// =============================================================================

BridgedClass _createVideoPlayerWithControlsBridge() {
  return BridgedClass(
    nativeType: $dartnative_video_player_5.VideoPlayerWithControls,
    name: 'VideoPlayerWithControls',
    isAssignable: (v) =>
        v is $dartnative_video_player_5.VideoPlayerWithControls,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final controller = D4
            .getRequiredNamedArg<
              $dartnative_video_player_14.VideoPlayerController
            >(named, 'controller', 'VideoPlayerWithControls');
        final aspectRatio = D4.getOptionalNamedArg<double?>(
          named,
          'aspectRatio',
        );
        final onExitFullScreenRaw = named['onExitFullScreen'];
        final controlsMode = D4
            .getNamedArgWithDefault<
              $dartnative_video_player_5.VideoControlsMode
            >(
              named,
              'controlsMode',
              $dartnative_video_player_5.VideoControlsMode.overlay,
            );
        final centeringMode = D4
            .getNamedArgWithDefault<
              $dartnative_video_player_5.VideoPlayerCenteringMode
            >(
              named,
              'centeringMode',
              $dartnative_video_player_5.VideoPlayerCenteringMode.absolute,
            );
        final topBarHeight = D4.getNamedArgWithDefault<double>(
          named,
          'topBarHeight',
          0,
        );
        final playIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'playIcon',
        );
        final pauseIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'pauseIcon',
        );
        final forwardIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'forwardIcon',
        );
        final rewindIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'rewindIcon',
        );
        final minimizeIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'minimizeIcon',
        );
        final expandIcon = D4.getOptionalNamedArg<$dartnative_6.IconData?>(
          named,
          'expandIcon',
        );
        final onExpandFullScreenRaw = named['onExpandFullScreen'];
        return $dartnative_video_player_5.VideoPlayerWithControls(
          key: key,
          controller: controller,
          aspectRatio: aspectRatio,
          onExitFullScreen: onExitFullScreenRaw == null
              ? null
              : () {
                  D4.callInterpreterCallback(visitor!, onExitFullScreenRaw, []);
                },
          controlsMode: controlsMode,
          centeringMode: centeringMode,
          topBarHeight: topBarHeight,
          playIcon: playIcon,
          pauseIcon: pauseIcon,
          forwardIcon: forwardIcon,
          rewindIcon: rewindIcon,
          minimizeIcon: minimizeIcon,
          expandIcon: expandIcon,
          onExpandFullScreen: onExpandFullScreenRaw == null
              ? null
              : () {
                  D4.callInterpreterCallback(
                    visitor!,
                    onExpandFullScreenRaw,
                    [],
                  );
                },
        );
      },
    },
    getters: {
      'controller': (visitor, target) =>
          (D4.validateTarget<
                    $dartnative_video_player_5.VideoPlayerWithControls
                  >(target, 'VideoPlayerWithControls')
                  as dynamic)
              .controller,
      'aspectRatio': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .aspectRatio,
      'onExitFullScreen': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .onExitFullScreen,
      'controlsMode': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .controlsMode,
      'centeringMode': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .centeringMode,
      'topBarHeight': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .topBarHeight,
      'playIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .playIcon,
      'pauseIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .pauseIcon,
      'forwardIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .forwardIcon,
      'rewindIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .rewindIcon,
      'minimizeIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .minimizeIcon,
      'expandIcon': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .expandIcon,
      'onExpandFullScreen': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .onExpandFullScreen,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
            target,
            'VideoPlayerWithControls',
          )
          .key,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_video_player_5.VideoPlayerWithControls>(
              target,
              'VideoPlayerWithControls',
            );
        return t.createState();
      },
    },
    constructorSignatures: {
      '': 'const VideoPlayerWithControls({Key? key, required VideoPlayerController controller, double? aspectRatio, VoidCallback? onExitFullScreen, VideoControlsMode controlsMode = VideoControlsMode.overlay, VideoPlayerCenteringMode centeringMode = VideoPlayerCenteringMode.absolute, double topBarHeight = 0, IconData? playIcon, IconData? pauseIcon, IconData? forwardIcon, IconData? rewindIcon, IconData? minimizeIcon, IconData? expandIcon, VoidCallback? onExpandFullScreen})',
    },
    methodSignatures: {
      'createState': 'State<VideoPlayerWithControls> createState()',
    },
    getterSignatures: {
      'controller': 'VideoPlayerController get controller',
      'aspectRatio': 'double? get aspectRatio',
      'onExitFullScreen': 'VoidCallback? get onExitFullScreen',
      'controlsMode': 'VideoControlsMode get controlsMode',
      'centeringMode': 'VideoPlayerCenteringMode get centeringMode',
      'topBarHeight': 'double get topBarHeight',
      'playIcon': 'IconData? get playIcon',
      'pauseIcon': 'IconData? get pauseIcon',
      'forwardIcon': 'IconData? get forwardIcon',
      'rewindIcon': 'IconData? get rewindIcon',
      'minimizeIcon': 'IconData? get minimizeIcon',
      'expandIcon': 'IconData? get expandIcon',
      'onExpandFullScreen': 'VoidCallback? get onExpandFullScreen',
      'key': 'Key? get key',
    },
  );
}

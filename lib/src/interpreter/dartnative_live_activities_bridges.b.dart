// D4rt Bridge - Generated file, do not edit
// Sources: 20 files
// Generated: 2026-11-16T04:48:55.805158 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartnative/src/painting.dart' as $dartnative_1;
import 'package:dartnative_live_activities/src/components/actions.dart'
    as $dartnative_live_activities_1;
import 'package:dartnative_live_activities/src/components/charts.dart'
    as $dartnative_live_activities_2;
import 'package:dartnative_live_activities/src/components/layout_nodes.dart'
    as $dartnative_live_activities_3;
import 'package:dartnative_live_activities/src/components/progress.dart'
    as $dartnative_live_activities_4;
import 'package:dartnative_live_activities/src/components/text.dart'
    as $dartnative_live_activities_5;
import 'package:dartnative_live_activities/src/components/visuals.dart'
    as $dartnative_live_activities_6;
import 'package:dartnative_live_activities/src/core/bind.dart'
    as $dartnative_live_activities_7;
import 'package:dartnative_live_activities/src/core/check.dart'
    as $dartnative_live_activities_8;
import 'package:dartnative_live_activities/src/core/enums.dart'
    as $dartnative_live_activities_9;
import 'package:dartnative_live_activities/src/core/layout.dart'
    as $dartnative_live_activities_10;
import 'package:dartnative_live_activities/src/core/node.dart'
    as $dartnative_live_activities_11;
import 'package:dartnative_live_activities/src/core/route.dart'
    as $dartnative_live_activities_12;
import 'package:dartnative_live_activities/src/core/state.dart'
    as $dartnative_live_activities_13;
import 'package:dartnative_live_activities/src/live_activities.dart'
    as $dartnative_live_activities_14;
import 'package:dartnative_live_activities/src/platform/image_loader.dart'
    as $dartnative_live_activities_15;
import 'package:dartnative_live_activities/src/platform/live_activities_ffi.dart'
    as $dartnative_live_activities_16;
import 'package:dartnative_live_activities/src/platform/live_activities_platform.dart'
    as $dartnative_live_activities_17;
import 'package:dartnative_live_activities/src/presets/designs.dart'
    as $dartnative_live_activities_18;
import 'package:dartnative_live_activities/src/presets/designs_run.dart'
    as $dartnative_live_activities_19;
import 'package:dartnative_live_activities/src/presets/preset.dart'
    as $dartnative_live_activities_20;
import 'package:dartnative_live_activities/src/presets/presets.dart'
    as $dartnative_live_activities_21;

/// Bridge class for dartnative_live_activities module.
class DartnativeLiveActivitiesBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createLiveActionBridge(),
      _createLiveButtonBridge(),
      _createLiveToggleBridge(),
      _createLiveRowBridge(),
      _createLiveColumnBridge(),
      _createLiveStackBridge(),
      _createLiveSpacerBridge(),
      _createLivePaddingBridge(),
      _createLiveBoxBridge(),
      _createLiveIfBridge(),
      _createLiveSparklineBridge(),
      _createLiveGaugeBridge(),
      _createLiveFlightPathBridge(),
      _createLiveSplitPartBridge(),
      _createLiveSplitBarBridge(),
      _createLiveStageIconBridge(),
      _createLiveProgressStyleBridge(),
      _createLiveProgressBridge(),
      _createLiveSegmentsBridge(),
      _createLiveMetricBridge(),
      _createLiveTextBridge(),
      _createLiveVisualBridge(),
      _createLiveTrackerSourceBridge(),
      _createLiveIconBridge(),
      _createLiveImageBridge(),
      _createLiveAvatarBridge(),
      _createLiveTrackerBridge(),
      _createLiveTextSourceBridge(),
      _createLiveBindBridge(),
      _createLiveConditionBridge(),
      _createLiveCheckBridge(),
      _createLiveReportBridge(),
      _createLiveThemeBridge(),
      _createLiveExpandedBridge(),
      _createLiveLockScreenBridge(),
      _createLiveChipBridge(),
      _createLiveAndroidBridge(),
      _createLiveImageMetaBridge(),
      _createLiveLayoutBridge(),
      _createLiveNodeBridge(),
      _createLiveLatLngBridge(),
      _createLiveRouteBridge(),
      _createLiveStateBridge(),
      _createLiveActivityBridge(),
      _createLiveActivitiesBridge(),
      _createRidePickupPresetBridge(),
      _createStorePickupPresetBridge(),
      _createRunPresetBridge(),
      _createMatchPresetBridge(),
      _createStockPresetBridge(),
      _createFlightPathPresetBridge(),
      _createOrbitPresetBridge(),
      _createChargePresetBridge(),
      _createFareSplitPresetBridge(),
      _createRideArrivalPresetBridge(),
      _createRideTripPresetBridge(),
      _createDeliveryOrderPresetBridge(),
      _createRidePinPresetBridge(),
      _createRideStopPresetBridge(),
      _createRideDestinationPresetBridge(),
      _createTrainPresetBridge(),
      _createPresetSampleBridge(),
      _createLivePresetSpecBridge(),
      _createLivePresetBridge(),
      _createTripPresetBridge(),
      _createDeliveryPresetBridge(),
      _createCourierPresetBridge(),
      _createPickupPresetBridge(),
      _createQueuePresetBridge(),
      _createFlightPresetBridge(),
      _createParkingPresetBridge(),
      _createEvChargingPresetBridge(),
      _createWorkoutPresetBridge(),
      _createCookingTimerPresetBridge(),
      _createUploadPresetBridge(),
      _createTechnicianPresetBridge(),
      _createTransitPresetBridge(),
      _createWaitingRoomPresetBridge(),
      _createScorePresetBridge(),
      _createLiveImagePayloadBridge(),
      _createLivePushTokenBridge(),
      _createLivePushEventBridge(),
      _createLivePushTokenEventBridge(),
      _createLivePushStartedEventBridge(),
      _createLiveActivityStateChangeBridge(),
      _createLivePushStateEventBridge(),
      _createLiveAlertBridge(),
      _createLiveDismissBridge(),
      _createLiveActivityInfoBridge(),
      _createLiveActivitiesExceptionBridge(),
      _createLiveActivitiesPlatformBridge(),
      _createLiveActivitiesFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'LiveAction': _createLiveActionBridge,
      'LiveButton': _createLiveButtonBridge,
      'LiveToggle': _createLiveToggleBridge,
      'LiveRow': _createLiveRowBridge,
      'LiveColumn': _createLiveColumnBridge,
      'LiveStack': _createLiveStackBridge,
      'LiveSpacer': _createLiveSpacerBridge,
      'LivePadding': _createLivePaddingBridge,
      'LiveBox': _createLiveBoxBridge,
      'LiveIf': _createLiveIfBridge,
      'LiveSparkline': _createLiveSparklineBridge,
      'LiveGauge': _createLiveGaugeBridge,
      'LiveFlightPath': _createLiveFlightPathBridge,
      'LiveSplitPart': _createLiveSplitPartBridge,
      'LiveSplitBar': _createLiveSplitBarBridge,
      'LiveStageIcon': _createLiveStageIconBridge,
      'LiveProgressStyle': _createLiveProgressStyleBridge,
      'LiveProgress': _createLiveProgressBridge,
      'LiveSegments': _createLiveSegmentsBridge,
      'LiveMetric': _createLiveMetricBridge,
      'LiveText': _createLiveTextBridge,
      'LiveVisual': _createLiveVisualBridge,
      'LiveTrackerSource': _createLiveTrackerSourceBridge,
      'LiveIcon': _createLiveIconBridge,
      'LiveImage': _createLiveImageBridge,
      'LiveAvatar': _createLiveAvatarBridge,
      'LiveTracker': _createLiveTrackerBridge,
      'LiveTextSource': _createLiveTextSourceBridge,
      'LiveBind': _createLiveBindBridge,
      'LiveCondition': _createLiveConditionBridge,
      'LiveCheck': _createLiveCheckBridge,
      'LiveReport': _createLiveReportBridge,
      'LiveTheme': _createLiveThemeBridge,
      'LiveExpanded': _createLiveExpandedBridge,
      'LiveLockScreen': _createLiveLockScreenBridge,
      'LiveChip': _createLiveChipBridge,
      'LiveAndroid': _createLiveAndroidBridge,
      'LiveImageMeta': _createLiveImageMetaBridge,
      'LiveLayout': _createLiveLayoutBridge,
      'LiveNode': _createLiveNodeBridge,
      'LiveLatLng': _createLiveLatLngBridge,
      'LiveRoute': _createLiveRouteBridge,
      'LiveState': _createLiveStateBridge,
      'LiveActivity': _createLiveActivityBridge,
      'LiveActivities': _createLiveActivitiesBridge,
      'RidePickupPreset': _createRidePickupPresetBridge,
      'StorePickupPreset': _createStorePickupPresetBridge,
      'RunPreset': _createRunPresetBridge,
      'MatchPreset': _createMatchPresetBridge,
      'StockPreset': _createStockPresetBridge,
      'FlightPathPreset': _createFlightPathPresetBridge,
      'OrbitPreset': _createOrbitPresetBridge,
      'ChargePreset': _createChargePresetBridge,
      'FareSplitPreset': _createFareSplitPresetBridge,
      'RideArrivalPreset': _createRideArrivalPresetBridge,
      'RideTripPreset': _createRideTripPresetBridge,
      'DeliveryOrderPreset': _createDeliveryOrderPresetBridge,
      'RidePinPreset': _createRidePinPresetBridge,
      'RideStopPreset': _createRideStopPresetBridge,
      'RideDestinationPreset': _createRideDestinationPresetBridge,
      'TrainPreset': _createTrainPresetBridge,
      'PresetSample': _createPresetSampleBridge,
      'LivePresetSpec': _createLivePresetSpecBridge,
      'LivePreset': _createLivePresetBridge,
      'TripPreset': _createTripPresetBridge,
      'DeliveryPreset': _createDeliveryPresetBridge,
      'CourierPreset': _createCourierPresetBridge,
      'PickupPreset': _createPickupPresetBridge,
      'QueuePreset': _createQueuePresetBridge,
      'FlightPreset': _createFlightPresetBridge,
      'ParkingPreset': _createParkingPresetBridge,
      'EvChargingPreset': _createEvChargingPresetBridge,
      'WorkoutPreset': _createWorkoutPresetBridge,
      'CookingTimerPreset': _createCookingTimerPresetBridge,
      'UploadPreset': _createUploadPresetBridge,
      'TechnicianPreset': _createTechnicianPresetBridge,
      'TransitPreset': _createTransitPresetBridge,
      'WaitingRoomPreset': _createWaitingRoomPresetBridge,
      'ScorePreset': _createScorePresetBridge,
      'LiveImagePayload': _createLiveImagePayloadBridge,
      'LivePushToken': _createLivePushTokenBridge,
      'LivePushEvent': _createLivePushEventBridge,
      'LivePushTokenEvent': _createLivePushTokenEventBridge,
      'LivePushStartedEvent': _createLivePushStartedEventBridge,
      'LiveActivityStateChange': _createLiveActivityStateChangeBridge,
      'LivePushStateEvent': _createLivePushStateEventBridge,
      'LiveAlert': _createLiveAlertBridge,
      'LiveDismiss': _createLiveDismissBridge,
      'LiveActivityInfo': _createLiveActivityInfoBridge,
      'LiveActivitiesException': _createLiveActivitiesExceptionBridge,
      'LiveActivitiesPlatform': _createLiveActivitiesPlatformBridge,
      'LiveActivitiesFFIBindings': _createLiveActivitiesFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'LiveAction': $dartnative_live_activities_1.LiveAction,
      'LiveButton': $dartnative_live_activities_1.LiveButton,
      'LiveToggle': $dartnative_live_activities_1.LiveToggle,
      'LiveRow': $dartnative_live_activities_3.LiveRow,
      'LiveColumn': $dartnative_live_activities_3.LiveColumn,
      'LiveStack': $dartnative_live_activities_3.LiveStack,
      'LiveSpacer': $dartnative_live_activities_3.LiveSpacer,
      'LivePadding': $dartnative_live_activities_3.LivePadding,
      'LiveBox': $dartnative_live_activities_3.LiveBox,
      'LiveIf': $dartnative_live_activities_3.LiveIf,
      'LiveSparkline': $dartnative_live_activities_2.LiveSparkline,
      'LiveGauge': $dartnative_live_activities_2.LiveGauge,
      'LiveFlightPath': $dartnative_live_activities_2.LiveFlightPath,
      'LiveSplitPart': $dartnative_live_activities_2.LiveSplitPart,
      'LiveSplitBar': $dartnative_live_activities_2.LiveSplitBar,
      'LiveStageIcon': $dartnative_live_activities_4.LiveStageIcon,
      'LiveProgressStyle': $dartnative_live_activities_4.LiveProgressStyle,
      'LiveProgress': $dartnative_live_activities_4.LiveProgress,
      'LiveSegments': $dartnative_live_activities_4.LiveSegments,
      'LiveMetric': $dartnative_live_activities_4.LiveMetric,
      'LiveText': $dartnative_live_activities_5.LiveText,
      'LiveVisual': $dartnative_live_activities_6.LiveVisual,
      'LiveTrackerSource': $dartnative_live_activities_6.LiveTrackerSource,
      'LiveIcon': $dartnative_live_activities_6.LiveIcon,
      'LiveImage': $dartnative_live_activities_6.LiveImage,
      'LiveAvatar': $dartnative_live_activities_6.LiveAvatar,
      'LiveTracker': $dartnative_live_activities_6.LiveTracker,
      'LiveTextSource': $dartnative_live_activities_7.LiveTextSource,
      'LiveBind': $dartnative_live_activities_7.LiveBind,
      'LiveCondition': $dartnative_live_activities_7.LiveCondition,
      'LiveCheck': $dartnative_live_activities_8.LiveCheck,
      'LiveReport': $dartnative_live_activities_8.LiveReport,
      'LiveTheme': $dartnative_live_activities_10.LiveTheme,
      'LiveExpanded': $dartnative_live_activities_10.LiveExpanded,
      'LiveLockScreen': $dartnative_live_activities_10.LiveLockScreen,
      'LiveChip': $dartnative_live_activities_10.LiveChip,
      'LiveAndroid': $dartnative_live_activities_10.LiveAndroid,
      'LiveImageMeta': $dartnative_live_activities_10.LiveImageMeta,
      'LiveLayout': $dartnative_live_activities_10.LiveLayout,
      'LiveNode': $dartnative_live_activities_11.LiveNode,
      'LiveLatLng': $dartnative_live_activities_12.LiveLatLng,
      'LiveRoute': $dartnative_live_activities_12.LiveRoute,
      'LiveState': $dartnative_live_activities_13.LiveState,
      'LiveActivity': $dartnative_live_activities_14.LiveActivity,
      'LiveActivities': $dartnative_live_activities_14.LiveActivities,
      'RidePickupPreset': $dartnative_live_activities_18.RidePickupPreset,
      'StorePickupPreset': $dartnative_live_activities_18.StorePickupPreset,
      'RunPreset': $dartnative_live_activities_18.RunPreset,
      'MatchPreset': $dartnative_live_activities_18.MatchPreset,
      'StockPreset': $dartnative_live_activities_18.StockPreset,
      'FlightPathPreset': $dartnative_live_activities_18.FlightPathPreset,
      'OrbitPreset': $dartnative_live_activities_18.OrbitPreset,
      'ChargePreset': $dartnative_live_activities_18.ChargePreset,
      'FareSplitPreset': $dartnative_live_activities_18.FareSplitPreset,
      'RideArrivalPreset': $dartnative_live_activities_19.RideArrivalPreset,
      'RideTripPreset': $dartnative_live_activities_19.RideTripPreset,
      'DeliveryOrderPreset': $dartnative_live_activities_19.DeliveryOrderPreset,
      'RidePinPreset': $dartnative_live_activities_19.RidePinPreset,
      'RideStopPreset': $dartnative_live_activities_19.RideStopPreset,
      'RideDestinationPreset':
          $dartnative_live_activities_19.RideDestinationPreset,
      'TrainPreset': $dartnative_live_activities_19.TrainPreset,
      'PresetSample': $dartnative_live_activities_20.PresetSample,
      'LivePresetSpec': $dartnative_live_activities_20.LivePresetSpec,
      'LivePreset': $dartnative_live_activities_20.LivePreset,
      'TripPreset': $dartnative_live_activities_21.TripPreset,
      'DeliveryPreset': $dartnative_live_activities_21.DeliveryPreset,
      'CourierPreset': $dartnative_live_activities_21.CourierPreset,
      'PickupPreset': $dartnative_live_activities_21.PickupPreset,
      'QueuePreset': $dartnative_live_activities_21.QueuePreset,
      'FlightPreset': $dartnative_live_activities_21.FlightPreset,
      'ParkingPreset': $dartnative_live_activities_21.ParkingPreset,
      'EvChargingPreset': $dartnative_live_activities_21.EvChargingPreset,
      'WorkoutPreset': $dartnative_live_activities_21.WorkoutPreset,
      'CookingTimerPreset': $dartnative_live_activities_21.CookingTimerPreset,
      'UploadPreset': $dartnative_live_activities_21.UploadPreset,
      'TechnicianPreset': $dartnative_live_activities_21.TechnicianPreset,
      'TransitPreset': $dartnative_live_activities_21.TransitPreset,
      'WaitingRoomPreset': $dartnative_live_activities_21.WaitingRoomPreset,
      'ScorePreset': $dartnative_live_activities_21.ScorePreset,
      'LiveImagePayload': $dartnative_live_activities_17.LiveImagePayload,
      'LivePushToken': $dartnative_live_activities_17.LivePushToken,
      'LivePushEvent': $dartnative_live_activities_17.LivePushEvent,
      'LivePushTokenEvent': $dartnative_live_activities_17.LivePushTokenEvent,
      'LivePushStartedEvent':
          $dartnative_live_activities_17.LivePushStartedEvent,
      'LiveActivityStateChange':
          $dartnative_live_activities_17.LiveActivityStateChange,
      'LivePushStateEvent': $dartnative_live_activities_17.LivePushStateEvent,
      'LiveAlert': $dartnative_live_activities_17.LiveAlert,
      'LiveDismiss': $dartnative_live_activities_17.LiveDismiss,
      'LiveActivityInfo': $dartnative_live_activities_17.LiveActivityInfo,
      'LiveActivitiesException':
          $dartnative_live_activities_17.LiveActivitiesException,
      'LiveActivitiesPlatform':
          $dartnative_live_activities_17.LiveActivitiesPlatform,
      'LiveActivitiesFFIBindings':
          $dartnative_live_activities_16.LiveActivitiesFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'LiveAction':
          'package:dartnative_live_activities/src/components/actions.dart',
      'LiveButton':
          'package:dartnative_live_activities/src/components/actions.dart',
      'LiveToggle':
          'package:dartnative_live_activities/src/components/actions.dart',
      'LiveRow':
          'package:dartnative_live_activities/src/components/layout_nodes.dart',
      'LiveColumn':
          'package:dartnative_live_activities/src/components/layout_nodes.dart',
      'LiveStack':
          'package:dartnative_live_activities/src/components/layout_nodes.dart',
      'LiveSpacer':
          'package:dartnative_live_activities/src/components/layout_nodes.dart',
      'LivePadding':
          'package:dartnative_live_activities/src/components/layout_nodes.dart',
      'LiveBox':
          'package:dartnative_live_activities/src/components/layout_nodes.dart',
      'LiveIf':
          'package:dartnative_live_activities/src/components/layout_nodes.dart',
      'LiveSparkline':
          'package:dartnative_live_activities/src/components/charts.dart',
      'LiveGauge':
          'package:dartnative_live_activities/src/components/charts.dart',
      'LiveFlightPath':
          'package:dartnative_live_activities/src/components/charts.dart',
      'LiveSplitPart':
          'package:dartnative_live_activities/src/components/charts.dart',
      'LiveSplitBar':
          'package:dartnative_live_activities/src/components/charts.dart',
      'LiveStageIcon':
          'package:dartnative_live_activities/src/components/progress.dart',
      'LiveProgressStyle':
          'package:dartnative_live_activities/src/components/progress.dart',
      'LiveProgress':
          'package:dartnative_live_activities/src/components/progress.dart',
      'LiveSegments':
          'package:dartnative_live_activities/src/components/progress.dart',
      'LiveMetric':
          'package:dartnative_live_activities/src/components/progress.dart',
      'LiveText': 'package:dartnative_live_activities/src/components/text.dart',
      'LiveVisual':
          'package:dartnative_live_activities/src/components/visuals.dart',
      'LiveTrackerSource':
          'package:dartnative_live_activities/src/components/visuals.dart',
      'LiveIcon':
          'package:dartnative_live_activities/src/components/visuals.dart',
      'LiveImage':
          'package:dartnative_live_activities/src/components/visuals.dart',
      'LiveAvatar':
          'package:dartnative_live_activities/src/components/visuals.dart',
      'LiveTracker':
          'package:dartnative_live_activities/src/components/visuals.dart',
      'LiveTextSource': 'package:dartnative_live_activities/src/core/bind.dart',
      'LiveBind': 'package:dartnative_live_activities/src/core/bind.dart',
      'LiveCondition': 'package:dartnative_live_activities/src/core/bind.dart',
      'LiveCheck': 'package:dartnative_live_activities/src/core/check.dart',
      'LiveReport': 'package:dartnative_live_activities/src/core/check.dart',
      'LiveTheme': 'package:dartnative_live_activities/src/core/layout.dart',
      'LiveExpanded': 'package:dartnative_live_activities/src/core/layout.dart',
      'LiveLockScreen':
          'package:dartnative_live_activities/src/core/layout.dart',
      'LiveChip': 'package:dartnative_live_activities/src/core/layout.dart',
      'LiveAndroid': 'package:dartnative_live_activities/src/core/layout.dart',
      'LiveImageMeta':
          'package:dartnative_live_activities/src/core/layout.dart',
      'LiveLayout': 'package:dartnative_live_activities/src/core/layout.dart',
      'LiveNode': 'package:dartnative_live_activities/src/core/node.dart',
      'LiveLatLng': 'package:dartnative_live_activities/src/core/route.dart',
      'LiveRoute': 'package:dartnative_live_activities/src/core/route.dart',
      'LiveState': 'package:dartnative_live_activities/src/core/state.dart',
      'LiveActivity':
          'package:dartnative_live_activities/src/live_activities.dart',
      'LiveActivities':
          'package:dartnative_live_activities/src/live_activities.dart',
      'RidePickupPreset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'StorePickupPreset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'RunPreset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'MatchPreset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'StockPreset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'FlightPathPreset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'OrbitPreset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'ChargePreset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'FareSplitPreset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'RideArrivalPreset':
          'package:dartnative_live_activities/src/presets/designs_run.dart',
      'RideTripPreset':
          'package:dartnative_live_activities/src/presets/designs_run.dart',
      'DeliveryOrderPreset':
          'package:dartnative_live_activities/src/presets/designs_run.dart',
      'RidePinPreset':
          'package:dartnative_live_activities/src/presets/designs_run.dart',
      'RideStopPreset':
          'package:dartnative_live_activities/src/presets/designs_run.dart',
      'RideDestinationPreset':
          'package:dartnative_live_activities/src/presets/designs_run.dart',
      'TrainPreset':
          'package:dartnative_live_activities/src/presets/designs_run.dart',
      'PresetSample':
          'package:dartnative_live_activities/src/presets/preset.dart',
      'LivePresetSpec':
          'package:dartnative_live_activities/src/presets/preset.dart',
      'LivePreset':
          'package:dartnative_live_activities/src/presets/preset.dart',
      'TripPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'DeliveryPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'CourierPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'PickupPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'QueuePreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'FlightPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'ParkingPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'EvChargingPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'WorkoutPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'CookingTimerPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'UploadPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'TechnicianPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'TransitPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'WaitingRoomPreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'ScorePreset':
          'package:dartnative_live_activities/src/presets/presets.dart',
      'LiveImagePayload':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LivePushToken':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LivePushEvent':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LivePushTokenEvent':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LivePushStartedEvent':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LiveActivityStateChange':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LivePushStateEvent':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LiveAlert':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LiveDismiss':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LiveActivityInfo':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LiveActivitiesException':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LiveActivitiesPlatform':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'LiveActivitiesFFIBindings':
          'package:dartnative_live_activities/src/platform/live_activities_ffi.dart',
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
      'LiveButton': ['LiveNode'],
      'LiveToggle': ['LiveNode'],
      'LiveRow': ['LiveNode'],
      'LiveColumn': ['LiveNode'],
      'LiveStack': ['LiveNode'],
      'LiveSpacer': ['LiveNode'],
      'LivePadding': ['LiveNode'],
      'LiveBox': ['LiveNode'],
      'LiveIf': ['LiveNode'],
      'LiveSparkline': ['LiveNode'],
      'LiveGauge': ['LiveNode'],
      'LiveFlightPath': ['LiveNode'],
      'LiveSplitBar': ['LiveNode'],
      'LiveProgress': ['LiveNode'],
      'LiveSegments': ['LiveNode'],
      'LiveMetric': ['LiveNode'],
      'LiveText': ['LiveNode', 'LiveTextSource'],
      'LiveVisual': ['LiveNode'],
      'LiveIcon': ['LiveVisual', 'LiveNode', 'LiveTrackerSource'],
      'LiveImage': ['LiveVisual', 'LiveNode', 'LiveTrackerSource'],
      'LiveAvatar': ['LiveVisual', 'LiveNode'],
      'LiveTracker': ['LiveTrackerSource'],
      'LiveBind': ['LiveTextSource'],
      'RidePickupPreset': ['LivePreset'],
      'StorePickupPreset': ['LivePreset'],
      'RunPreset': ['LivePreset'],
      'MatchPreset': ['LivePreset'],
      'StockPreset': ['LivePreset'],
      'FlightPathPreset': ['LivePreset'],
      'OrbitPreset': ['LivePreset'],
      'ChargePreset': ['LivePreset'],
      'FareSplitPreset': ['LivePreset'],
      'RideArrivalPreset': ['LivePreset'],
      'RideTripPreset': ['LivePreset'],
      'DeliveryOrderPreset': ['LivePreset'],
      'RidePinPreset': ['LivePreset'],
      'RideStopPreset': ['LivePreset'],
      'RideDestinationPreset': ['LivePreset'],
      'TrainPreset': ['LivePreset'],
      'TripPreset': ['LivePreset'],
      'DeliveryPreset': ['LivePreset'],
      'CourierPreset': ['LivePreset'],
      'PickupPreset': ['LivePreset'],
      'QueuePreset': ['LivePreset'],
      'FlightPreset': ['LivePreset'],
      'ParkingPreset': ['LivePreset'],
      'EvChargingPreset': ['LivePreset'],
      'WorkoutPreset': ['LivePreset'],
      'CookingTimerPreset': ['LivePreset'],
      'UploadPreset': ['LivePreset'],
      'TechnicianPreset': ['LivePreset'],
      'TransitPreset': ['LivePreset'],
      'WaitingRoomPreset': ['LivePreset'],
      'ScorePreset': ['LivePreset'],
      'LivePushTokenEvent': ['LivePushEvent'],
      'LivePushStartedEvent': ['LivePushEvent'],
      'LivePushStateEvent': ['LivePushEvent'],
      'LiveActivitiesException': ['Exception'],
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
      'LiveImageReader',
      'LiveAssetReader',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dartnative_live_activities_5.LiveTextKind>(
        name: 'LiveTextKind',
        values: $dartnative_live_activities_5.LiveTextKind.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_6.LiveImageSource>(
        name: 'LiveImageSource',
        values: $dartnative_live_activities_6.LiveImageSource.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_8.LiveSeverity>(
        name: 'LiveSeverity',
        values: $dartnative_live_activities_8.LiveSeverity.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_9.LiveFit>(
        name: 'LiveFit',
        values: $dartnative_live_activities_9.LiveFit.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_9.LiveShape>(
        name: 'LiveShape',
        values: $dartnative_live_activities_9.LiveShape.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_9.LiveBackground>(
        name: 'LiveBackground',
        values: $dartnative_live_activities_9.LiveBackground.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_9.LiveAlign>(
        name: 'LiveAlign',
        values: $dartnative_live_activities_9.LiveAlign.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_9.LiveAndroidStyle>(
        name: 'LiveAndroidStyle',
        values: $dartnative_live_activities_9.LiveAndroidStyle.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_9.LivePointShape>(
        name: 'LivePointShape',
        values: $dartnative_live_activities_9.LivePointShape.values,
      ),
      BridgedEnumDefinition<
        $dartnative_live_activities_9.LiveTrackerBackground
      >(
        name: 'LiveTrackerBackground',
        values: $dartnative_live_activities_9.LiveTrackerBackground.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_18.RideBar>(
        name: 'RideBar',
        values: $dartnative_live_activities_18.RideBar.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_20.PresetProgress>(
        name: 'PresetProgress',
        values: $dartnative_live_activities_20.PresetProgress.values,
      ),
      BridgedEnumDefinition<$dartnative_live_activities_17.LiveActivityState>(
        name: 'LiveActivityState',
        values: $dartnative_live_activities_17.LiveActivityState.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'LiveTextKind':
          'package:dartnative_live_activities/src/components/text.dart',
      'LiveImageSource':
          'package:dartnative_live_activities/src/components/visuals.dart',
      'LiveSeverity': 'package:dartnative_live_activities/src/core/check.dart',
      'LiveFit': 'package:dartnative_live_activities/src/core/enums.dart',
      'LiveShape': 'package:dartnative_live_activities/src/core/enums.dart',
      'LiveBackground':
          'package:dartnative_live_activities/src/core/enums.dart',
      'LiveAlign': 'package:dartnative_live_activities/src/core/enums.dart',
      'LiveAndroidStyle':
          'package:dartnative_live_activities/src/core/enums.dart',
      'LivePointShape':
          'package:dartnative_live_activities/src/core/enums.dart',
      'LiveTrackerBackground':
          'package:dartnative_live_activities/src/core/enums.dart',
      'RideBar': 'package:dartnative_live_activities/src/presets/designs.dart',
      'PresetProgress':
          'package:dartnative_live_activities/src/presets/preset.dart',
      'LiveActivityState':
          'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
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
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target:
            'package:dartnative_live_activities/src/components/actions.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target:
            'package:dartnative_live_activities/src/components/layout_nodes.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/components/charts.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target:
            'package:dartnative_live_activities/src/components/progress.dart',
        show: null,
        hide: {'progressStyleFromJson', 'progressStyleToJson'},
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/components/text.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target:
            'package:dartnative_live_activities/src/components/visuals.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/core/bind.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/core/check.dart',
        show: null,
        hide: {'checkLayout'},
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/core/enums.dart',
        show: null,
        hide: {'enumByName'},
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/core/layout.dart',
        show: null,
        hide: {'firstProgress'},
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/core/node.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/core/route.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/core/state.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/live_activities.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/presets/designs.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target:
            'package:dartnative_live_activities/src/presets/designs_run.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/presets/preset.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target: 'package:dartnative_live_activities/src/presets/presets.dart',
        show: null,
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target:
            'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
        show: {
          'LiveActivityInfo',
          'LiveActivityState',
          'LiveActivityStateChange',
          'LiveAlert',
          'LiveDismiss',
          'LiveImagePayload',
          'LivePushEvent',
          'LivePushStartedEvent',
          'LivePushStateEvent',
          'LivePushToken',
          'LivePushTokenEvent',
          'LiveActivitiesException',
          'LiveActivitiesPlatform',
        },
        hide: null,
      ),
      (
        source:
            'package:dartnative_live_activities/dartnative_live_activities.dart',
        target:
            'package:dartnative_live_activities/src/platform/live_activities_ffi.dart',
        show: {'LiveActivitiesFFIBindings'},
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
        'liveContractVersion',
        $dartnative_live_activities_10.liveContractVersion,
        importPath,
        sourceUri: 'package:dartnative_live_activities/src/core/layout.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "liveContractVersion": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'liveDesignCarTopAsset',
        $dartnative_live_activities_18.liveDesignCarTopAsset,
        importPath,
        sourceUri:
            'package:dartnative_live_activities/src/presets/designs.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "liveDesignCarTopAsset": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'liveDesignCarSideAsset',
        $dartnative_live_activities_18.liveDesignCarSideAsset,
        importPath,
        sourceUri:
            'package:dartnative_live_activities/src/presets/designs.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "liveDesignCarSideAsset": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'liveDesignCarPlateAsset',
        $dartnative_live_activities_18.liveDesignCarPlateAsset,
        importPath,
        sourceUri:
            'package:dartnative_live_activities/src/presets/designs.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "liveDesignCarPlateAsset": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'liveDesignTrainTopAsset',
        $dartnative_live_activities_18.liveDesignTrainTopAsset,
        importPath,
        sourceUri:
            'package:dartnative_live_activities/src/presets/designs.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "liveDesignTrainTopAsset": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'liveDesignCrestAAsset',
        $dartnative_live_activities_18.liveDesignCrestAAsset,
        importPath,
        sourceUri:
            'package:dartnative_live_activities/src/presets/designs.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "liveDesignCrestAAsset": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'liveDesignCrestBAsset',
        $dartnative_live_activities_18.liveDesignCrestBAsset,
        importPath,
        sourceUri:
            'package:dartnative_live_activities/src/presets/designs.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "liveDesignCrestBAsset": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'livePresetCarAsset',
        $dartnative_live_activities_21.livePresetCarAsset,
        importPath,
        sourceUri:
            'package:dartnative_live_activities/src/presets/presets.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "livePresetCarAsset": $e');
    }

    if (errors.isNotEmpty) {
      throw StateError(
        'Bridge registration errors (dartnative_live_activities):\n${errors.join("\n")}',
      );
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {
      'liveSeries': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'liveSeries');
        final values = D4.getRequiredArg<Iterable<num>>(
          positional,
          0,
          'values',
          'liveSeries',
        );
        return $dartnative_live_activities_2.liveSeries(values);
      },
      'parseLiveSeries': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'parseLiveSeries');
        final raw = D4.getRequiredArg<Object?>(
          positional,
          0,
          'raw',
          'parseLiveSeries',
        );
        return $dartnative_live_activities_2.parseLiveSeries(raw);
      },
      'bind': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'bind');
        final field = D4.getRequiredArg<String>(positional, 0, 'field', 'bind');
        return $dartnative_live_activities_7.bind(field);
      },
      'liveText': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'liveText');
        final v = D4.getRequiredArg<Object?>(positional, 0, 'v', 'liveText');
        return $dartnative_live_activities_7.liveText(v);
      },
      'formatTemplate': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'formatTemplate');
        final fmt = D4.getRequiredArg<String>(
          positional,
          0,
          'fmt',
          'formatTemplate',
        );
        final state = D4.getRequiredArg<Map<String, Object?>>(
          positional,
          1,
          'state',
          'formatTemplate',
        );
        return $dartnative_live_activities_7.formatTemplate(fmt, state);
      },
      'liveDesignOrderAsset': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'liveDesignOrderAsset');
        final stage = D4.getRequiredArg<int>(
          positional,
          0,
          'stage',
          'liveDesignOrderAsset',
        );
        final reached = D4.getRequiredNamedArg<bool>(
          named,
          'reached',
          'liveDesignOrderAsset',
        );
        return $dartnative_live_activities_18.liveDesignOrderAsset(
          stage,
          reached: reached,
        );
      },
      'presetIcon': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'presetIcon');
        final sf = D4.getRequiredArg<String>(positional, 0, 'sf', 'presetIcon');
        final file = D4.getRequiredArg<String>(
          positional,
          1,
          'file',
          'presetIcon',
        );
        final accent = D4.getNamedArgWithDefault<bool>(named, 'accent', false);
        return $dartnative_live_activities_20.presetIcon(
          sf,
          file,
          accent: accent,
        );
      },
      'presetButton': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'presetButton');
        final label = D4.getRequiredArg<String>(
          positional,
          0,
          'label',
          'presetButton',
        );
        final icon = D4.getRequiredArg<$dartnative_live_activities_6.LiveIcon?>(
          positional,
          1,
          'icon',
          'presetButton',
        );
        final id = D4.getOptionalNamedArg<String?>(named, 'id');
        return $dartnative_live_activities_20.presetButton(label, icon, id: id);
      },
      'buildPresetLayout': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'buildPresetLayout');
        final spec = D4
            .getRequiredArg<$dartnative_live_activities_20.LivePresetSpec>(
              positional,
              0,
              'spec',
              'buildPresetLayout',
            );
        return $dartnative_live_activities_20.buildPresetLayout(spec);
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'liveSeries':
          'package:dartnative_live_activities/src/components/charts.dart',
      'parseLiveSeries':
          'package:dartnative_live_activities/src/components/charts.dart',
      'bind': 'package:dartnative_live_activities/src/core/bind.dart',
      'liveText': 'package:dartnative_live_activities/src/core/bind.dart',
      'formatTemplate': 'package:dartnative_live_activities/src/core/bind.dart',
      'liveDesignOrderAsset':
          'package:dartnative_live_activities/src/presets/designs.dart',
      'presetIcon':
          'package:dartnative_live_activities/src/presets/preset.dart',
      'presetButton':
          'package:dartnative_live_activities/src/presets/preset.dart',
      'buildPresetLayout':
          'package:dartnative_live_activities/src/presets/preset.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'liveSeries': 'String liveSeries(Iterable<num> values)',
      'parseLiveSeries': 'List<double> parseLiveSeries(Object? raw)',
      'bind': 'LiveBind bind(String field)',
      'liveText': 'String liveText(Object? v)',
      'formatTemplate':
          'String formatTemplate(String fmt, Map<String, Object?> state)',
      'liveDesignOrderAsset':
          'String liveDesignOrderAsset(int stage, {required bool reached})',
      'presetIcon':
          'LiveIcon presetIcon(String sf, String file, {bool accent = false})',
      'presetButton':
          'LiveButton presetButton(String label, LiveIcon? icon, {String? id})',
      'buildPresetLayout': 'LiveLayout buildPresetLayout(LivePresetSpec spec)',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative_live_activities/src/components/actions.dart',
      'package:dartnative_live_activities/src/components/charts.dart',
      'package:dartnative_live_activities/src/components/layout_nodes.dart',
      'package:dartnative_live_activities/src/components/progress.dart',
      'package:dartnative_live_activities/src/components/text.dart',
      'package:dartnative_live_activities/src/components/visuals.dart',
      'package:dartnative_live_activities/src/core/bind.dart',
      'package:dartnative_live_activities/src/core/check.dart',
      'package:dartnative_live_activities/src/core/enums.dart',
      'package:dartnative_live_activities/src/core/layout.dart',
      'package:dartnative_live_activities/src/core/node.dart',
      'package:dartnative_live_activities/src/core/route.dart',
      'package:dartnative_live_activities/src/core/state.dart',
      'package:dartnative_live_activities/src/live_activities.dart',
      'package:dartnative_live_activities/src/platform/live_activities_ffi.dart',
      'package:dartnative_live_activities/src/platform/live_activities_platform.dart',
      'package:dartnative_live_activities/src/presets/designs.dart',
      'package:dartnative_live_activities/src/presets/designs_run.dart',
      'package:dartnative_live_activities/src/presets/preset.dart',
      'package:dartnative_live_activities/src/presets/presets.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_live_activities/dartnative_live_activities.dart';";
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
    'LiveTextKind',
    'LiveImageSource',
    'LiveSeverity',
    'LiveFit',
    'LiveShape',
    'LiveBackground',
    'LiveAlign',
    'LiveAndroidStyle',
    'LivePointShape',
    'LiveTrackerBackground',
    'RideBar',
    'PresetProgress',
    'LiveActivityState',
  ];
}

// =============================================================================
// LiveAction Bridge
// =============================================================================

BridgedClass _createLiveActionBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_1.LiveAction,
    name: 'LiveAction',
    isAssignable: (v) => v is $dartnative_live_activities_1.LiveAction,
    constructors: {
      'deepLink': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveAction');
        final url = D4.getRequiredArg<String>(
          positional,
          0,
          'url',
          'LiveAction',
        );
        return $dartnative_live_activities_1.LiveAction.deepLink(url);
      },
      'call': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveAction');
        final number = D4.getRequiredArg<String>(
          positional,
          0,
          'number',
          'LiveAction',
        );
        return $dartnative_live_activities_1.LiveAction.call(number);
      },
      'custom': (visitor, positional, named) {
        return $dartnative_live_activities_1.LiveAction.custom();
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveAction');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveAction: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_1.LiveAction.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveAction>(
            target,
            'LiveAction',
          )
          .type,
      'url': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveAction>(
            target,
            'LiveAction',
          )
          .url,
      'number': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveAction>(
            target,
            'LiveAction',
          )
          .number,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_1.LiveAction>(
          target,
          'LiveAction',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      'deepLink': 'const LiveAction.deepLink(String url)',
      'call': 'const LiveAction.call(String number)',
      'custom': 'const LiveAction.custom()',
      'fromJson': 'factory LiveAction.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'url': 'String? get url',
      'number': 'String? get number',
    },
  );
}

// =============================================================================
// LiveButton Bridge
// =============================================================================

BridgedClass _createLiveButtonBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_1.LiveButton,
    name: 'LiveButton',
    isAssignable: (v) => v is $dartnative_live_activities_1.LiveButton,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final id = D4.getRequiredNamedArg<String>(named, 'id', 'LiveButton');
        final label = D4.getRequiredNamedArg<String>(
          named,
          'label',
          'LiveButton',
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'icon',
            );
        final action = D4
            .getOptionalNamedArg<$dartnative_live_activities_1.LiveAction?>(
              named,
              'action',
            );
        return $dartnative_live_activities_1.LiveButton(
          id: id,
          label: label,
          icon: icon,
          action: action,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveButton');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveButton: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_1.LiveButton.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveButton>(
            target,
            'LiveButton',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveButton>(
            target,
            'LiveButton',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveButton>(
            target,
            'LiveButton',
          )
          .descendants,
      'id': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveButton>(
            target,
            'LiveButton',
          )
          .id,
      'label': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveButton>(
            target,
            'LiveButton',
          )
          .label,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveButton>(
            target,
            'LiveButton',
          )
          .icon,
      'action': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveButton>(
            target,
            'LiveButton',
          )
          .action,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_1.LiveButton>(
          target,
          'LiveButton',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'LiveButton({required String id, required String label, LiveVisual? icon, LiveAction? action})',
      'fromJson': 'factory LiveButton.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'id': 'String get id',
      'label': 'String get label',
      'icon': 'LiveVisual? get icon',
      'action': 'LiveAction? get action',
    },
  );
}

// =============================================================================
// LiveToggle Bridge
// =============================================================================

BridgedClass _createLiveToggleBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_1.LiveToggle,
    name: 'LiveToggle',
    isAssignable: (v) => v is $dartnative_live_activities_1.LiveToggle,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final id = D4.getRequiredNamedArg<String>(named, 'id', 'LiveToggle');
        final value = D4
            .getRequiredNamedArg<$dartnative_live_activities_7.LiveBind>(
              named,
              'value',
              'LiveToggle',
            );
        final label = D4.getOptionalNamedArg<String?>(named, 'label');
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        return $dartnative_live_activities_1.LiveToggle(
          id: id,
          value: value,
          label: label,
          icon: icon,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveToggle');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveToggle: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_1.LiveToggle.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveToggle>(
            target,
            'LiveToggle',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveToggle>(
            target,
            'LiveToggle',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveToggle>(
            target,
            'LiveToggle',
          )
          .descendants,
      'id': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveToggle>(
            target,
            'LiveToggle',
          )
          .id,
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveToggle>(
            target,
            'LiveToggle',
          )
          .value,
      'label': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveToggle>(
            target,
            'LiveToggle',
          )
          .label,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_1.LiveToggle>(
            target,
            'LiveToggle',
          )
          .icon,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_1.LiveToggle>(
          target,
          'LiveToggle',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'LiveToggle({required String id, required LiveBind value, String? label, LiveIcon? icon})',
      'fromJson': 'factory LiveToggle.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'id': 'String get id',
      'value': 'LiveBind get value',
      'label': 'String? get label',
      'icon': 'LiveIcon? get icon',
    },
  );
}

// =============================================================================
// LiveRow Bridge
// =============================================================================

BridgedClass _createLiveRowBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_3.LiveRow,
    name: 'LiveRow',
    isAssignable: (v) => v is $dartnative_live_activities_3.LiveRow,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveRow');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveRow: Missing required argument "items" at position 0',
          );
        }
        final items = D4.coerceList<$dartnative_live_activities_11.LiveNode>(
          positional[0],
          'items',
        );
        final gap = D4.getOptionalNamedArg<double?>(named, 'gap');
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        return $dartnative_live_activities_3.LiveRow(
          items,
          gap: gap,
          align: align,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveRow');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveRow: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_3.LiveRow.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveRow>(
            target,
            'LiveRow',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveRow>(
            target,
            'LiveRow',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveRow>(
            target,
            'LiveRow',
          )
          .descendants,
      'items': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveRow>(
            target,
            'LiveRow',
          )
          .items,
      'gap': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveRow>(
            target,
            'LiveRow',
          )
          .gap,
      'align': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveRow>(
            target,
            'LiveRow',
          )
          .align,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_3.LiveRow>(
          target,
          'LiveRow',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveRow(List<LiveNode> items, {double? gap, LiveAlign? align})',
      'fromJson': 'factory LiveRow.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'items': 'List<LiveNode> get items',
      'gap': 'double? get gap',
      'align': 'LiveAlign? get align',
    },
  );
}

// =============================================================================
// LiveColumn Bridge
// =============================================================================

BridgedClass _createLiveColumnBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_3.LiveColumn,
    name: 'LiveColumn',
    isAssignable: (v) => v is $dartnative_live_activities_3.LiveColumn,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveColumn');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveColumn: Missing required argument "items" at position 0',
          );
        }
        final items = D4.coerceList<$dartnative_live_activities_11.LiveNode>(
          positional[0],
          'items',
        );
        final gap = D4.getOptionalNamedArg<double?>(named, 'gap');
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        return $dartnative_live_activities_3.LiveColumn(
          items,
          gap: gap,
          align: align,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveColumn');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveColumn: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_3.LiveColumn.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveColumn>(
            target,
            'LiveColumn',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveColumn>(
            target,
            'LiveColumn',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveColumn>(
            target,
            'LiveColumn',
          )
          .descendants,
      'items': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveColumn>(
            target,
            'LiveColumn',
          )
          .items,
      'gap': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveColumn>(
            target,
            'LiveColumn',
          )
          .gap,
      'align': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveColumn>(
            target,
            'LiveColumn',
          )
          .align,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_3.LiveColumn>(
          target,
          'LiveColumn',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveColumn(List<LiveNode> items, {double? gap, LiveAlign? align})',
      'fromJson': 'factory LiveColumn.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'items': 'List<LiveNode> get items',
      'gap': 'double? get gap',
      'align': 'LiveAlign? get align',
    },
  );
}

// =============================================================================
// LiveStack Bridge
// =============================================================================

BridgedClass _createLiveStackBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_3.LiveStack,
    name: 'LiveStack',
    isAssignable: (v) => v is $dartnative_live_activities_3.LiveStack,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveStack');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveStack: Missing required argument "items" at position 0',
          );
        }
        final items = D4.coerceList<$dartnative_live_activities_11.LiveNode>(
          positional[0],
          'items',
        );
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        return $dartnative_live_activities_3.LiveStack(items, align: align);
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveStack');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveStack: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_3.LiveStack.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveStack>(
            target,
            'LiveStack',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveStack>(
            target,
            'LiveStack',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveStack>(
            target,
            'LiveStack',
          )
          .descendants,
      'items': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveStack>(
            target,
            'LiveStack',
          )
          .items,
      'align': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveStack>(
            target,
            'LiveStack',
          )
          .align,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_3.LiveStack>(
          target,
          'LiveStack',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveStack(List<LiveNode> items, {LiveAlign? align})',
      'fromJson': 'factory LiveStack.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'items': 'List<LiveNode> get items',
      'align': 'LiveAlign? get align',
    },
  );
}

// =============================================================================
// LiveSpacer Bridge
// =============================================================================

BridgedClass _createLiveSpacerBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_3.LiveSpacer,
    name: 'LiveSpacer',
    isAssignable: (v) => v is $dartnative_live_activities_3.LiveSpacer,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        return $dartnative_live_activities_3.LiveSpacer(size: size);
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveSpacer');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveSpacer: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_3.LiveSpacer.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveSpacer>(
            target,
            'LiveSpacer',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveSpacer>(
            target,
            'LiveSpacer',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveSpacer>(
            target,
            'LiveSpacer',
          )
          .descendants,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveSpacer>(
            target,
            'LiveSpacer',
          )
          .size,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_3.LiveSpacer>(
          target,
          'LiveSpacer',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveSpacer({double? size})',
      'fromJson': 'factory LiveSpacer.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'size': 'double? get size',
    },
  );
}

// =============================================================================
// LivePadding Bridge
// =============================================================================

BridgedClass _createLivePaddingBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_3.LivePadding,
    name: 'LivePadding',
    isAssignable: (v) => v is $dartnative_live_activities_3.LivePadding,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LivePadding');
        final child = D4
            .getRequiredArg<$dartnative_live_activities_11.LiveNode>(
              positional,
              0,
              'child',
              'LivePadding',
            );
        final all = D4.getOptionalNamedArg<double?>(named, 'all');
        final horizontal = D4.getOptionalNamedArg<double?>(named, 'horizontal');
        final vertical = D4.getOptionalNamedArg<double?>(named, 'vertical');
        final top = D4.getOptionalNamedArg<double?>(named, 'top');
        final bottom = D4.getOptionalNamedArg<double?>(named, 'bottom');
        final left = D4.getOptionalNamedArg<double?>(named, 'left');
        final right = D4.getOptionalNamedArg<double?>(named, 'right');
        return $dartnative_live_activities_3.LivePadding(
          child,
          all: all,
          horizontal: horizontal,
          vertical: vertical,
          top: top,
          bottom: bottom,
          left: left,
          right: right,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LivePadding');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LivePadding: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_3.LivePadding.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .descendants,
      'child': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .child,
      'all': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .all,
      'horizontal': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .horizontal,
      'vertical': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .vertical,
      'top': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .top,
      'bottom': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .bottom,
      'left': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .left,
      'right': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LivePadding>(
            target,
            'LivePadding',
          )
          .right,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_3.LivePadding>(
          target,
          'LivePadding',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LivePadding(LiveNode child, {double? all, double? horizontal, double? vertical, double? top, double? bottom, double? left, double? right})',
      'fromJson': 'factory LivePadding.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'child': 'LiveNode get child',
      'all': 'double? get all',
      'horizontal': 'double? get horizontal',
      'vertical': 'double? get vertical',
      'top': 'double? get top',
      'bottom': 'double? get bottom',
      'left': 'double? get left',
      'right': 'double? get right',
    },
  );
}

// =============================================================================
// LiveBox Bridge
// =============================================================================

BridgedClass _createLiveBoxBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_3.LiveBox,
    name: 'LiveBox',
    isAssignable: (v) => v is $dartnative_live_activities_3.LiveBox,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final child = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'child',
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final radius = D4.getOptionalNamedArg<double?>(named, 'radius');
        final tint = D4.getOptionalNamedArg<double?>(named, 'tint');
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final border = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'border',
        );
        final borderWidth = D4.getOptionalNamedArg<double?>(
          named,
          'borderWidth',
        );
        final glow = D4.getOptionalNamedArg<double?>(named, 'glow');
        return $dartnative_live_activities_3.LiveBox(
          child: child,
          size: size,
          radius: radius,
          tint: tint,
          color: color,
          border: border,
          borderWidth: borderWidth,
          glow: glow,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveBox');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveBox: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_3.LiveBox.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .descendants,
      'child': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .child,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .size,
      'radius': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .radius,
      'tint': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .tint,
      'color': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .color,
      'border': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .border,
      'borderWidth': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .borderWidth,
      'glow': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveBox>(
            target,
            'LiveBox',
          )
          .glow,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_3.LiveBox>(
          target,
          'LiveBox',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveBox({LiveNode? child, double? size, double? radius, double? tint, Color? color, Color? border, double? borderWidth, double? glow})',
      'fromJson': 'factory LiveBox.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'child': 'LiveNode? get child',
      'size': 'double? get size',
      'radius': 'double? get radius',
      'tint': 'double? get tint',
      'color': 'Color? get color',
      'border': 'Color? get border',
      'borderWidth': 'double? get borderWidth',
      'glow': 'double? get glow',
    },
  );
}

// =============================================================================
// LiveIf Bridge
// =============================================================================

BridgedClass _createLiveIfBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_3.LiveIf,
    name: 'LiveIf',
    isAssignable: (v) => v is $dartnative_live_activities_3.LiveIf,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveIf');
        final when = D4
            .getRequiredArg<$dartnative_live_activities_7.LiveCondition>(
              positional,
              0,
              'when',
              'LiveIf',
            );
        final then = D4
            .getRequiredNamedArg<$dartnative_live_activities_11.LiveNode>(
              named,
              'then',
              'LiveIf',
            );
        final otherwise = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'otherwise',
            );
        return $dartnative_live_activities_3.LiveIf(
          when,
          then: then,
          otherwise: otherwise,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveIf');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveIf: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_3.LiveIf.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveIf>(
            target,
            'LiveIf',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveIf>(
            target,
            'LiveIf',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveIf>(
            target,
            'LiveIf',
          )
          .descendants,
      'when': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveIf>(
            target,
            'LiveIf',
          )
          .when,
      'then': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveIf>(
            target,
            'LiveIf',
          )
          .then,
      'otherwise': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_3.LiveIf>(
            target,
            'LiveIf',
          )
          .otherwise,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_3.LiveIf>(
          target,
          'LiveIf',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveIf(LiveCondition when, {required LiveNode then, LiveNode? otherwise})',
      'fromJson': 'factory LiveIf.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'when': 'LiveCondition get when',
      'then': 'LiveNode get then',
      'otherwise': 'LiveNode? get otherwise',
    },
  );
}

// =============================================================================
// LiveSparkline Bridge
// =============================================================================

BridgedClass _createLiveSparklineBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_2.LiveSparkline,
    name: 'LiveSparkline',
    isAssignable: (v) => v is $dartnative_live_activities_2.LiveSparkline,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final series = D4
            .getRequiredNamedArg<$dartnative_live_activities_7.LiveBind>(
              named,
              'series',
              'LiveSparkline',
            );
        final height = D4.getNamedArgWithDefault<double>(named, 'height', 36);
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final fill = D4.getNamedArgWithDefault<bool>(named, 'fill', true);
        final strokeWidth = D4.getNamedArgWithDefault<double>(
          named,
          'strokeWidth',
          2,
        );
        final dot = D4.getNamedArgWithDefault<bool>(named, 'dot', true);
        final min = D4.getOptionalNamedArg<double?>(named, 'min');
        final max = D4.getOptionalNamedArg<double?>(named, 'max');
        return $dartnative_live_activities_2.LiveSparkline(
          series: series,
          height: height,
          color: color,
          fill: fill,
          strokeWidth: strokeWidth,
          dot: dot,
          min: min,
          max: max,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveSparkline');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveSparkline: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_2.LiveSparkline.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .descendants,
      'series': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .series,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .height,
      'color': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .color,
      'fill': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .fill,
      'strokeWidth': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .strokeWidth,
      'dot': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .dot,
      'min': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .min,
      'max': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
            target,
            'LiveSparkline',
          )
          .max,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_2.LiveSparkline>(
              target,
              'LiveSparkline',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveSparkline({required LiveBind series, double height = 36, Color? color, bool fill = true, double strokeWidth = 2, bool dot = true, double? min, double? max})',
      'fromJson': 'factory LiveSparkline.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'series': 'LiveBind get series',
      'height': 'double get height',
      'color': 'Color? get color',
      'fill': 'bool get fill',
      'strokeWidth': 'double get strokeWidth',
      'dot': 'bool get dot',
      'min': 'double? get min',
      'max': 'double? get max',
    },
  );
}

// =============================================================================
// LiveGauge Bridge
// =============================================================================

BridgedClass _createLiveGaugeBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_2.LiveGauge,
    name: 'LiveGauge',
    isAssignable: (v) => v is $dartnative_live_activities_2.LiveGauge,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final value = D4
            .getRequiredNamedArg<$dartnative_live_activities_7.LiveBind>(
              named,
              'value',
              'LiveGauge',
            );
        final size = D4.getNamedArgWithDefault<double>(named, 'size', 96);
        final sweep = D4.getNamedArgWithDefault<double>(named, 'sweep', 180);
        final knob = D4.getNamedArgWithDefault<bool>(named, 'knob', true);
        final style = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'style');
        final child = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'child',
            );
        return $dartnative_live_activities_2.LiveGauge(
          value: value,
          size: size,
          sweep: sweep,
          knob: knob,
          style: style,
          child: child,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveGauge');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveGauge: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_2.LiveGauge.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveGauge>(
            target,
            'LiveGauge',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveGauge>(
            target,
            'LiveGauge',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveGauge>(
            target,
            'LiveGauge',
          )
          .descendants,
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveGauge>(
            target,
            'LiveGauge',
          )
          .value,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveGauge>(
            target,
            'LiveGauge',
          )
          .size,
      'sweep': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveGauge>(
            target,
            'LiveGauge',
          )
          .sweep,
      'knob': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveGauge>(
            target,
            'LiveGauge',
          )
          .knob,
      'style': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveGauge>(
            target,
            'LiveGauge',
          )
          .style,
      'child': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveGauge>(
            target,
            'LiveGauge',
          )
          .child,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_2.LiveGauge>(
          target,
          'LiveGauge',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveGauge({required LiveBind value, double size = 96, double sweep = 180, bool knob = true, LiveProgressStyle? style, LiveNode? child})',
      'fromJson': 'factory LiveGauge.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'value': 'LiveBind get value',
      'size': 'double get size',
      'sweep': 'double get sweep',
      'knob': 'bool get knob',
      'style': 'LiveProgressStyle? get style',
      'child': 'LiveNode? get child',
    },
  );
}

// =============================================================================
// LiveFlightPath Bridge
// =============================================================================

BridgedClass _createLiveFlightPathBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_2.LiveFlightPath,
    name: 'LiveFlightPath',
    isAssignable: (v) => v is $dartnative_live_activities_2.LiveFlightPath,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final value = D4
            .getRequiredNamedArg<$dartnative_live_activities_7.LiveBind>(
              named,
              'value',
              'LiveFlightPath',
            );
        final height = D4.getNamedArgWithDefault<double>(named, 'height', 44);
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final startIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'startIcon',
            );
        final endIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'endIcon',
            );
        final style = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'style');
        if (!named.containsKey('curve')) {
          return $dartnative_live_activities_2.LiveFlightPath(
            value: value,
            height: height,
            tracker: tracker,
            startIcon: startIcon,
            endIcon: endIcon,
            style: style,
          );
        }
        if (named.containsKey('curve')) {
          final curve = D4.getRequiredNamedArg<double>(
            named,
            'curve',
            'LiveFlightPath',
          );
          return $dartnative_live_activities_2.LiveFlightPath(
            value: value,
            height: height,
            tracker: tracker,
            startIcon: startIcon,
            endIcon: endIcon,
            style: style,
            curve: curve,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveFlightPath');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveFlightPath: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_2.LiveFlightPath.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .descendants,
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .value,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .height,
      'curve': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .curve,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .tracker,
      'startIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .startIcon,
      'endIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .endIcon,
      'style': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
            target,
            'LiveFlightPath',
          )
          .style,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_2.LiveFlightPath>(
              target,
              'LiveFlightPath',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'LiveFlightPath({required LiveBind value, double height = 44, double curve = .55, LiveTrackerSource? tracker, LiveVisual? startIcon, LiveVisual? endIcon, LiveProgressStyle? style})',
      'fromJson': 'factory LiveFlightPath.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'value': 'LiveBind get value',
      'height': 'double get height',
      'curve': 'double get curve',
      'tracker': 'LiveTracker? get tracker',
      'startIcon': 'LiveVisual? get startIcon',
      'endIcon': 'LiveVisual? get endIcon',
      'style': 'LiveProgressStyle? get style',
    },
  );
}

// =============================================================================
// LiveSplitPart Bridge
// =============================================================================

BridgedClass _createLiveSplitPartBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_2.LiveSplitPart,
    name: 'LiveSplitPart',
    isAssignable: (v) => v is $dartnative_live_activities_2.LiveSplitPart,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'LiveSplitPart');
        final value = D4.getRequiredArg<$dartnative_live_activities_7.LiveBind>(
          positional,
          0,
          'value',
          'LiveSplitPart',
        );
        final color = D4.getRequiredArg<$dartnative_1.Color>(
          positional,
          1,
          'color',
          'LiveSplitPart',
        );
        return $dartnative_live_activities_2.LiveSplitPart(value, color);
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveSplitPart');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveSplitPart: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_2.LiveSplitPart.fromJson(json);
      },
    },
    getters: {
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSplitPart>(
            target,
            'LiveSplitPart',
          )
          .value,
      'color': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSplitPart>(
            target,
            'LiveSplitPart',
          )
          .color,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_2.LiveSplitPart>(
              target,
              'LiveSplitPart',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveSplitPart(LiveBind value, Color color)',
      'fromJson': 'factory LiveSplitPart.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'value': 'LiveBind get value',
      'color': 'Color get color',
    },
  );
}

// =============================================================================
// LiveSplitBar Bridge
// =============================================================================

BridgedClass _createLiveSplitBarBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_2.LiveSplitBar,
    name: 'LiveSplitBar',
    isAssignable: (v) => v is $dartnative_live_activities_2.LiveSplitBar,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveSplitBar');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveSplitBar: Missing required argument "parts" at position 0',
          );
        }
        final parts = D4
            .coerceList<$dartnative_live_activities_2.LiveSplitPart>(
              positional[0],
              'parts',
            );
        final height = D4.getNamedArgWithDefault<double>(named, 'height', 10);
        final gap = D4.getNamedArgWithDefault<double>(named, 'gap', 3);
        final radius = D4.getOptionalNamedArg<double?>(named, 'radius');
        return $dartnative_live_activities_2.LiveSplitBar(
          parts,
          height: height,
          gap: gap,
          radius: radius,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveSplitBar');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveSplitBar: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_2.LiveSplitBar.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSplitBar>(
            target,
            'LiveSplitBar',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSplitBar>(
            target,
            'LiveSplitBar',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSplitBar>(
            target,
            'LiveSplitBar',
          )
          .descendants,
      'parts': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSplitBar>(
            target,
            'LiveSplitBar',
          )
          .parts,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSplitBar>(
            target,
            'LiveSplitBar',
          )
          .height,
      'gap': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSplitBar>(
            target,
            'LiveSplitBar',
          )
          .gap,
      'radius': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_2.LiveSplitBar>(
            target,
            'LiveSplitBar',
          )
          .radius,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_2.LiveSplitBar>(
          target,
          'LiveSplitBar',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveSplitBar(List<LiveSplitPart> parts, {double height = 10, double gap = 3, double? radius})',
      'fromJson': 'factory LiveSplitBar.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'parts': 'List<LiveSplitPart> get parts',
      'height': 'double get height',
      'gap': 'double get gap',
      'radius': 'double? get radius',
    },
  );
}

// =============================================================================
// LiveStageIcon Bridge
// =============================================================================

BridgedClass _createLiveStageIconBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_4.LiveStageIcon,
    name: 'LiveStageIcon',
    isAssignable: (v) => v is $dartnative_live_activities_4.LiveStageIcon,
    constructors: {
      '': (visitor, positional, named) {
        final pending = D4
            .getRequiredNamedArg<$dartnative_live_activities_6.LiveImage>(
              named,
              'pending',
              'LiveStageIcon',
            );
        final reached = D4
            .getRequiredNamedArg<$dartnative_live_activities_6.LiveImage>(
              named,
              'reached',
              'LiveStageIcon',
            );
        return $dartnative_live_activities_4.LiveStageIcon(
          pending: pending,
          reached: reached,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveStageIcon');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveStageIcon: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_4.LiveStageIcon.fromJson(json);
      },
    },
    getters: {
      'pending': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveStageIcon>(
            target,
            'LiveStageIcon',
          )
          .pending,
      'reached': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveStageIcon>(
            target,
            'LiveStageIcon',
          )
          .reached,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_4.LiveStageIcon>(
              target,
              'LiveStageIcon',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveStageIcon({required LiveImage pending, required LiveImage reached})',
      'fromJson': 'factory LiveStageIcon.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'pending': 'LiveImage get pending',
      'reached': 'LiveImage get reached',
    },
  );
}

// =============================================================================
// LiveProgressStyle Bridge
// =============================================================================

BridgedClass _createLiveProgressStyleBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_4.LiveProgressStyle,
    name: 'LiveProgressStyle',
    isAssignable: (v) => v is $dartnative_live_activities_4.LiveProgressStyle,
    constructors: {
      '': (visitor, positional, named) {
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final trackColor = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'trackColor',
        );
        final gap = D4.getOptionalNamedArg<double?>(named, 'gap');
        final radius = D4.getOptionalNamedArg<double?>(named, 'radius');
        final pointSize = D4.getOptionalNamedArg<double?>(named, 'pointSize');
        final pointColor = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'pointColor',
        );
        final pointShape = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LivePointShape?>(
              named,
              'pointShape',
            );
        final dashed = D4.getOptionalNamedArg<bool?>(named, 'dashed');
        final labelSize = D4.getOptionalNamedArg<double?>(named, 'labelSize');
        final trackerSize = D4.getOptionalNamedArg<double?>(
          named,
          'trackerSize',
        );
        final markers = D4.coerceListOrNull<double>(
          named['markers'],
          'markers',
        );
        final glow = D4.getOptionalNamedArg<double?>(named, 'glow');
        final endMarker = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LivePointShape?>(
              named,
              'endMarker',
            );
        final markerLabels = D4.coerceListOrNull<String>(
          named['markerLabels'],
          'markerLabels',
        );
        return $dartnative_live_activities_4.LiveProgressStyle(
          height: height,
          color: color,
          trackColor: trackColor,
          gap: gap,
          radius: radius,
          pointSize: pointSize,
          pointColor: pointColor,
          pointShape: pointShape,
          dashed: dashed,
          labelSize: labelSize,
          trackerSize: trackerSize,
          markers: markers,
          glow: glow,
          endMarker: endMarker,
          markerLabels: markerLabels,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveProgressStyle');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveProgressStyle: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_4.LiveProgressStyle.fromJson(json);
      },
    },
    getters: {
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .height,
      'color': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .color,
      'trackColor': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .trackColor,
      'gap': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .gap,
      'radius': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .radius,
      'pointSize': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .pointSize,
      'pointColor': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .pointColor,
      'pointShape': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .pointShape,
      'dashed': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .dashed,
      'labelSize': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .labelSize,
      'trackerSize': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .trackerSize,
      'markers': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .markers,
      'glow': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .glow,
      'endMarker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .endMarker,
      'markerLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .markerLabels,
      'isEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .isEmpty,
      'hashCode': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
            target,
            'LiveProgressStyle',
          )
          .hashCode,
    },
    methods: {
      'copyWith': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
              target,
              'LiveProgressStyle',
            );
        final height = D4.getOptionalNamedArg<double?>(named, 'height');
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final trackColor = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'trackColor',
        );
        final gap = D4.getOptionalNamedArg<double?>(named, 'gap');
        final radius = D4.getOptionalNamedArg<double?>(named, 'radius');
        final pointSize = D4.getOptionalNamedArg<double?>(named, 'pointSize');
        final pointColor = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'pointColor',
        );
        final pointShape = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LivePointShape?>(
              named,
              'pointShape',
            );
        final dashed = D4.getOptionalNamedArg<bool?>(named, 'dashed');
        final labelSize = D4.getOptionalNamedArg<double?>(named, 'labelSize');
        final trackerSize = D4.getOptionalNamedArg<double?>(
          named,
          'trackerSize',
        );
        final markers = D4.coerceListOrNull<double>(
          named['markers'],
          'markers',
        );
        final glow = D4.getOptionalNamedArg<double?>(named, 'glow');
        final endMarker = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LivePointShape?>(
              named,
              'endMarker',
            );
        final markerLabels = D4.coerceListOrNull<String>(
          named['markerLabels'],
          'markerLabels',
        );
        return t.copyWith(
          height: height,
          color: color,
          trackColor: trackColor,
          gap: gap,
          radius: radius,
          pointSize: pointSize,
          pointColor: pointColor,
          pointShape: pointShape,
          dashed: dashed,
          labelSize: labelSize,
          trackerSize: trackerSize,
          markers: markers,
          glow: glow,
          endMarker: endMarker,
          markerLabels: markerLabels,
        );
      },
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
              target,
              'LiveProgressStyle',
            );
        return t.toJson();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_4.LiveProgressStyle>(
              target,
              'LiveProgressStyle',
            );
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(
          positional,
          0,
          'other',
          'operator==',
        );
        return t == other;
      },
    },
    constructorSignatures: {
      '': 'const LiveProgressStyle({double? height, Color? color, Color? trackColor, double? gap, double? radius, double? pointSize, Color? pointColor, LivePointShape? pointShape, bool? dashed, double? labelSize, double? trackerSize, List<double>? markers, double? glow, LivePointShape? endMarker, List<String>? markerLabels})',
      'fromJson':
          'factory LiveProgressStyle.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'copyWith':
          'LiveProgressStyle copyWith({double? height, Color? color, Color? trackColor, double? gap, double? radius, double? pointSize, Color? pointColor, LivePointShape? pointShape, bool? dashed, double? labelSize, double? trackerSize, List<double>? markers, double? glow, LivePointShape? endMarker, List<String>? markerLabels})',
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'height': 'double? get height',
      'color': 'Color? get color',
      'trackColor': 'Color? get trackColor',
      'gap': 'double? get gap',
      'radius': 'double? get radius',
      'pointSize': 'double? get pointSize',
      'pointColor': 'Color? get pointColor',
      'pointShape': 'LivePointShape? get pointShape',
      'dashed': 'bool? get dashed',
      'labelSize': 'double? get labelSize',
      'trackerSize': 'double? get trackerSize',
      'markers': 'List<double>? get markers',
      'glow': 'double? get glow',
      'endMarker': 'LivePointShape? get endMarker',
      'markerLabels': 'List<String>? get markerLabels',
      'isEmpty': 'bool get isEmpty',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// LiveProgress Bridge
// =============================================================================

BridgedClass _createLiveProgressBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_4.LiveProgress,
    name: 'LiveProgress',
    isAssignable: (v) => v is $dartnative_live_activities_4.LiveProgress,
    hierarchyDepth: 1,
    constructors: {
      'bar': (visitor, positional, named) {
        final value = D4
            .getRequiredNamedArg<$dartnative_live_activities_7.LiveBind>(
              named,
              'value',
              'LiveProgress',
            );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final startIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'startIcon',
            );
        final endIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'endIcon',
            );
        final style = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'style');
        return $dartnative_live_activities_4.LiveProgress.bar(
          value: value,
          tracker: tracker,
          startIcon: startIcon,
          endIcon: endIcon,
          style: style,
        );
      },
      'ring': (visitor, positional, named) {
        final value = D4
            .getRequiredNamedArg<$dartnative_live_activities_7.LiveBind>(
              named,
              'value',
              'LiveProgress',
            );
        final child = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'child',
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final style = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'style');
        return $dartnative_live_activities_4.LiveProgress.ring(
          value: value,
          child: child,
          size: size,
          style: style,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveProgress');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveProgress: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_4.LiveProgress.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .descendants,
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .value,
      'isRing': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .isRing,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .tracker,
      'startIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .startIcon,
      'endIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .endIcon,
      'child': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .child,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .size,
      'style': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveProgress>(
            target,
            'LiveProgress',
          )
          .style,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_4.LiveProgress>(
          target,
          'LiveProgress',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      'bar':
          'LiveProgress.bar({required LiveBind value, LiveTrackerSource? tracker, LiveVisual? startIcon, LiveVisual? endIcon, LiveProgressStyle? style})',
      'ring':
          'const LiveProgress.ring({required LiveBind value, LiveNode? child, double? size, LiveProgressStyle? style})',
      'fromJson': 'factory LiveProgress.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'value': 'LiveBind get value',
      'isRing': 'bool get isRing',
      'tracker': 'LiveTracker? get tracker',
      'startIcon': 'LiveVisual? get startIcon',
      'endIcon': 'LiveVisual? get endIcon',
      'child': 'LiveNode? get child',
      'size': 'double? get size',
      'style': 'LiveProgressStyle? get style',
    },
  );
}

// =============================================================================
// LiveSegments Bridge
// =============================================================================

BridgedClass _createLiveSegmentsBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_4.LiveSegments,
    name: 'LiveSegments',
    isAssignable: (v) => v is $dartnative_live_activities_4.LiveSegments,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final value = D4
            .getRequiredNamedArg<$dartnative_live_activities_7.LiveBind>(
              named,
              'value',
              'LiveSegments',
            );
        if (!named.containsKey('labels') || named['labels'] == null) {
          throw ArgumentError(
            'LiveSegments: Missing required named argument "labels"',
          );
        }
        final labels = D4.coerceList<String>(named['labels'], 'labels');
        final points = D4.getNamedArgWithDefault<bool>(named, 'points', false);
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final startIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'startIcon',
            );
        final endIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'endIcon',
            );
        final stageIcons = D4
            .coerceListOrNull<$dartnative_live_activities_4.LiveStageIcon>(
              named['stageIcons'],
              'stageIcons',
            );
        final style = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'style');
        return $dartnative_live_activities_4.LiveSegments(
          value: value,
          labels: labels,
          points: points,
          showLabels: showLabels,
          tracker: tracker,
          startIcon: startIcon,
          endIcon: endIcon,
          stageIcons: stageIcons,
          style: style,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveSegments');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveSegments: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_4.LiveSegments.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .descendants,
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .value,
      'stageIcons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .stageIcons,
      'labels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .labels,
      'points': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .points,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .showLabels,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .tracker,
      'startIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .startIcon,
      'endIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .endIcon,
      'style': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveSegments>(
            target,
            'LiveSegments',
          )
          .style,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_4.LiveSegments>(
          target,
          'LiveSegments',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'LiveSegments({required LiveBind value, required List<String> labels, bool points = false, bool showLabels = true, LiveTrackerSource? tracker, LiveVisual? startIcon, LiveVisual? endIcon, List<LiveStageIcon>? stageIcons, LiveProgressStyle? style})',
      'fromJson': 'factory LiveSegments.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'value': 'LiveBind get value',
      'stageIcons': 'List<LiveStageIcon>? get stageIcons',
      'labels': 'List<String> get labels',
      'points': 'bool get points',
      'showLabels': 'bool get showLabels',
      'tracker': 'LiveTracker? get tracker',
      'startIcon': 'LiveVisual? get startIcon',
      'endIcon': 'LiveVisual? get endIcon',
      'style': 'LiveProgressStyle? get style',
    },
  );
}

// =============================================================================
// LiveMetric Bridge
// =============================================================================

BridgedClass _createLiveMetricBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_4.LiveMetric,
    name: 'LiveMetric',
    isAssignable: (v) => v is $dartnative_live_activities_4.LiveMetric,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final value = D4
            .getRequiredNamedArg<$dartnative_live_activities_7.LiveBind>(
              named,
              'value',
              'LiveMetric',
            );
        final unit = D4.getOptionalNamedArg<String?>(named, 'unit');
        final label = D4.getOptionalNamedArg<String?>(named, 'label');
        return $dartnative_live_activities_4.LiveMetric(
          value: value,
          unit: unit,
          label: label,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveMetric');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveMetric: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_4.LiveMetric.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveMetric>(
            target,
            'LiveMetric',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveMetric>(
            target,
            'LiveMetric',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveMetric>(
            target,
            'LiveMetric',
          )
          .descendants,
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveMetric>(
            target,
            'LiveMetric',
          )
          .value,
      'unit': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveMetric>(
            target,
            'LiveMetric',
          )
          .unit,
      'label': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_4.LiveMetric>(
            target,
            'LiveMetric',
          )
          .label,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_4.LiveMetric>(
          target,
          'LiveMetric',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveMetric({required LiveBind value, String? unit, String? label})',
      'fromJson': 'factory LiveMetric.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'value': 'LiveBind get value',
      'unit': 'String? get unit',
      'label': 'String? get label',
    },
  );
}

// =============================================================================
// LiveText Bridge
// =============================================================================

BridgedClass _createLiveTextBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_5.LiveText,
    name: 'LiveText',
    isAssignable: (v) => v is $dartnative_live_activities_5.LiveText,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveText');
        final source = D4
            .getRequiredArg<$dartnative_live_activities_7.LiveBind>(
              positional,
              0,
              'source',
              'LiveText',
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final weight = D4.getOptionalNamedArg<int?>(named, 'weight');
        final italic = D4.getNamedArgWithDefault<bool>(named, 'italic', false);
        final muted = D4.getNamedArgWithDefault<bool>(named, 'muted', false);
        final accent = D4.getNamedArgWithDefault<bool>(named, 'accent', false);
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final lines = D4.getOptionalNamedArg<int?>(named, 'lines');
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        final tabular = D4.getOptionalNamedArg<bool?>(named, 'tabular');
        return $dartnative_live_activities_5.LiveText(
          source,
          size: size,
          weight: weight,
          italic: italic,
          muted: muted,
          accent: accent,
          color: color,
          lines: lines,
          align: align,
          tabular: tabular,
        );
      },
      'literal': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveText');
        final literal = D4.getRequiredArg<String>(
          positional,
          0,
          'literal',
          'LiveText',
        );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final weight = D4.getOptionalNamedArg<int?>(named, 'weight');
        final italic = D4.getNamedArgWithDefault<bool>(named, 'italic', false);
        final muted = D4.getNamedArgWithDefault<bool>(named, 'muted', false);
        final accent = D4.getNamedArgWithDefault<bool>(named, 'accent', false);
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final lines = D4.getOptionalNamedArg<int?>(named, 'lines');
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        final tabular = D4.getOptionalNamedArg<bool?>(named, 'tabular');
        return $dartnative_live_activities_5.LiveText.literal(
          literal,
          size: size,
          weight: weight,
          italic: italic,
          muted: muted,
          accent: accent,
          color: color,
          lines: lines,
          align: align,
          tabular: tabular,
        );
      },
      'format': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveText');
        final template = D4.getRequiredArg<String>(
          positional,
          0,
          'template',
          'LiveText',
        );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final weight = D4.getOptionalNamedArg<int?>(named, 'weight');
        final italic = D4.getNamedArgWithDefault<bool>(named, 'italic', false);
        final muted = D4.getNamedArgWithDefault<bool>(named, 'muted', false);
        final accent = D4.getNamedArgWithDefault<bool>(named, 'accent', false);
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final lines = D4.getOptionalNamedArg<int?>(named, 'lines');
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        final tabular = D4.getOptionalNamedArg<bool?>(named, 'tabular');
        return $dartnative_live_activities_5.LiveText.format(
          template,
          size: size,
          weight: weight,
          italic: italic,
          muted: muted,
          accent: accent,
          color: color,
          lines: lines,
          align: align,
          tabular: tabular,
        );
      },
      'countdown': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveText');
        final until = D4.getRequiredArg<$dartnative_live_activities_7.LiveBind>(
          positional,
          0,
          'until',
          'LiveText',
        );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final weight = D4.getOptionalNamedArg<int?>(named, 'weight');
        final italic = D4.getNamedArgWithDefault<bool>(named, 'italic', false);
        final muted = D4.getNamedArgWithDefault<bool>(named, 'muted', false);
        final accent = D4.getNamedArgWithDefault<bool>(named, 'accent', false);
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final lines = D4.getOptionalNamedArg<int?>(named, 'lines');
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        final tabular = D4.getOptionalNamedArg<bool?>(named, 'tabular');
        return $dartnative_live_activities_5.LiveText.countdown(
          until,
          size: size,
          weight: weight,
          italic: italic,
          muted: muted,
          accent: accent,
          color: color,
          lines: lines,
          align: align,
          tabular: tabular,
        );
      },
      'stopwatch': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveText');
        final since = D4.getRequiredArg<$dartnative_live_activities_7.LiveBind>(
          positional,
          0,
          'since',
          'LiveText',
        );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final weight = D4.getOptionalNamedArg<int?>(named, 'weight');
        final italic = D4.getNamedArgWithDefault<bool>(named, 'italic', false);
        final muted = D4.getNamedArgWithDefault<bool>(named, 'muted', false);
        final accent = D4.getNamedArgWithDefault<bool>(named, 'accent', false);
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final lines = D4.getOptionalNamedArg<int?>(named, 'lines');
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        final tabular = D4.getOptionalNamedArg<bool?>(named, 'tabular');
        return $dartnative_live_activities_5.LiveText.stopwatch(
          since,
          size: size,
          weight: weight,
          italic: italic,
          muted: muted,
          accent: accent,
          color: color,
          lines: lines,
          align: align,
          tabular: tabular,
        );
      },
      'relative': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveText');
        final date = D4.getRequiredArg<$dartnative_live_activities_7.LiveBind>(
          positional,
          0,
          'date',
          'LiveText',
        );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final weight = D4.getOptionalNamedArg<int?>(named, 'weight');
        final italic = D4.getNamedArgWithDefault<bool>(named, 'italic', false);
        final muted = D4.getNamedArgWithDefault<bool>(named, 'muted', false);
        final accent = D4.getNamedArgWithDefault<bool>(named, 'accent', false);
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final lines = D4.getOptionalNamedArg<int?>(named, 'lines');
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        final tabular = D4.getOptionalNamedArg<bool?>(named, 'tabular');
        return $dartnative_live_activities_5.LiveText.relative(
          date,
          size: size,
          weight: weight,
          italic: italic,
          muted: muted,
          accent: accent,
          color: color,
          lines: lines,
          align: align,
          tabular: tabular,
        );
      },
      'from': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveText');
        final other = D4.getRequiredArg<$dartnative_live_activities_5.LiveText>(
          positional,
          0,
          'other',
          'LiveText',
        );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final weight = D4.getOptionalNamedArg<int?>(named, 'weight');
        final italic = D4.getOptionalNamedArg<bool?>(named, 'italic');
        final muted = D4.getOptionalNamedArg<bool?>(named, 'muted');
        final accent = D4.getOptionalNamedArg<bool?>(named, 'accent');
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        final lines = D4.getOptionalNamedArg<int?>(named, 'lines');
        final align = D4
            .getOptionalNamedArg<$dartnative_live_activities_9.LiveAlign?>(
              named,
              'align',
            );
        final tabular = D4.getOptionalNamedArg<bool?>(named, 'tabular');
        return $dartnative_live_activities_5.LiveText.from(
          other,
          size: size,
          weight: weight,
          italic: italic,
          muted: muted,
          accent: accent,
          color: color,
          lines: lines,
          align: align,
          tabular: tabular,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveText');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveText: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_5.LiveText.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .descendants,
      'kind': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .kind,
      'source': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .source,
      'literal': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .literal,
      'template': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .template,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .size,
      'weight': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .weight,
      'italic': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .italic,
      'muted': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .muted,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .accent,
      'color': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .color,
      'lines': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .lines,
      'align': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .align,
      'tabular': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_5.LiveText>(
            target,
            'LiveText',
          )
          .tabular,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_5.LiveText>(
          target,
          'LiveText',
        );
        return t.toJson();
      },
      'toAndroidTextJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_5.LiveText>(
          target,
          'LiveText',
        );
        return t.toAndroidTextJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveText(LiveBind source, {double? size, int? weight, bool italic = false, bool muted = false, bool accent = false, Color? color, int? lines, LiveAlign? align, bool? tabular})',
      'literal':
          'const LiveText.literal(String literal, {double? size, int? weight, bool italic = false, bool muted = false, bool accent = false, Color? color, int? lines, LiveAlign? align, bool? tabular})',
      'format':
          'const LiveText.format(String template, {double? size, int? weight, bool italic = false, bool muted = false, bool accent = false, Color? color, int? lines, LiveAlign? align, bool? tabular})',
      'countdown':
          'const LiveText.countdown(LiveBind until, {double? size, int? weight, bool italic = false, bool muted = false, bool accent = false, Color? color, int? lines, LiveAlign? align, bool? tabular})',
      'stopwatch':
          'const LiveText.stopwatch(LiveBind since, {double? size, int? weight, bool italic = false, bool muted = false, bool accent = false, Color? color, int? lines, LiveAlign? align, bool? tabular})',
      'relative':
          'const LiveText.relative(LiveBind date, {double? size, int? weight, bool italic = false, bool muted = false, bool accent = false, Color? color, int? lines, LiveAlign? align, bool? tabular})',
      'from':
          'LiveText.from(LiveText other, {double? size, int? weight, bool? italic, bool? muted, bool? accent, Color? color, int? lines, LiveAlign? align, bool? tabular})',
      'fromJson': 'factory LiveText.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
      'toAndroidTextJson': 'Map<String, Object?> toAndroidTextJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'kind': 'LiveTextKind get kind',
      'source': 'LiveBind? get source',
      'literal': 'String? get literal',
      'template': 'String? get template',
      'size': 'double? get size',
      'weight': 'int? get weight',
      'italic': 'bool get italic',
      'muted': 'bool get muted',
      'accent': 'bool get accent',
      'color': 'Color? get color',
      'lines': 'int? get lines',
      'align': 'LiveAlign? get align',
      'tabular': 'bool? get tabular',
    },
  );
}

// =============================================================================
// LiveVisual Bridge
// =============================================================================

BridgedClass _createLiveVisualBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_6.LiveVisual,
    name: 'LiveVisual',
    isAssignable: (v) => v is $dartnative_live_activities_6.LiveVisual,
    hierarchyDepth: 1,
    constructors: {
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveVisual');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveVisual: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_6.LiveVisual.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveVisual>(
            target,
            'LiveVisual',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveVisual>(
            target,
            'LiveVisual',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveVisual>(
            target,
            'LiveVisual',
          )
          .descendants,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveVisual>(
          target,
          'LiveVisual',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      'fromJson': 'factory LiveVisual.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
    },
  );
}

// =============================================================================
// LiveTrackerSource Bridge
// =============================================================================

BridgedClass _createLiveTrackerSourceBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_6.LiveTrackerSource,
    name: 'LiveTrackerSource',
    isAssignable: (v) => v is $dartnative_live_activities_6.LiveTrackerSource,
    isAbstract: true,
    constructors: {},
    methods: {
      'asTracker': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_6.LiveTrackerSource>(
              target,
              'LiveTrackerSource',
            );
        return t.asTracker();
      },
    },
    methodSignatures: {
      'asTracker': 'LiveTracker asTracker()',
    },
  );
}

// =============================================================================
// LiveIcon Bridge
// =============================================================================

BridgedClass _createLiveIconBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_6.LiveIcon,
    name: 'LiveIcon',
    isAssignable: (v) => v is $dartnative_live_activities_6.LiveIcon,
    hierarchyDepth: 3,
    constructors: {
      'symbol': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveIcon');
        final sf = D4.getRequiredArg<String>(positional, 0, 'sf', 'LiveIcon');
        final android = D4.getOptionalNamedArg<String?>(named, 'android');
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final accent = D4.getNamedArgWithDefault<bool>(named, 'accent', false);
        final color = D4.getOptionalNamedArg<$dartnative_1.Color?>(
          named,
          'color',
        );
        return $dartnative_live_activities_6.LiveIcon.symbol(
          sf,
          android: android,
          size: size,
          accent: accent,
          color: color,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveIcon');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveIcon: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_6.LiveIcon.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveIcon>(
            target,
            'LiveIcon',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveIcon>(
            target,
            'LiveIcon',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveIcon>(
            target,
            'LiveIcon',
          )
          .descendants,
      'sf': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveIcon>(
            target,
            'LiveIcon',
          )
          .sf,
      'android': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveIcon>(
            target,
            'LiveIcon',
          )
          .android,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveIcon>(
            target,
            'LiveIcon',
          )
          .size,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveIcon>(
            target,
            'LiveIcon',
          )
          .accent,
      'color': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveIcon>(
            target,
            'LiveIcon',
          )
          .color,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveIcon>(
          target,
          'LiveIcon',
        );
        return t.toJson();
      },
      'withAccent': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveIcon>(
          target,
          'LiveIcon',
        );
        final accent = D4.getOptionalArgWithDefault<bool>(
          positional,
          0,
          'accent',
          true,
        );
        return t.withAccent(accent);
      },
      'asTracker': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveIcon>(
          target,
          'LiveIcon',
        );
        return t.asTracker();
      },
    },
    constructorSignatures: {
      'symbol':
          'const LiveIcon.symbol(String sf, {String? android, double? size, bool accent = false, Color? color})',
      'fromJson': 'factory LiveIcon.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
      'withAccent': 'LiveIcon withAccent([bool accent = true])',
      'asTracker': 'LiveTracker asTracker()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'sf': 'String get sf',
      'android': 'String? get android',
      'size': 'double? get size',
      'accent': 'bool get accent',
      'color': 'Color? get color',
    },
  );
}

// =============================================================================
// LiveImage Bridge
// =============================================================================

BridgedClass _createLiveImageBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_6.LiveImage,
    name: 'LiveImage',
    isAssignable: (v) => v is $dartnative_live_activities_6.LiveImage,
    hierarchyDepth: 3,
    constructors: {
      'asset': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveImage');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'LiveImage',
        );
        final fit = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveFit>(
              named,
              'fit',
              $dartnative_live_activities_9.LiveFit.contain,
            );
        final shape = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveShape>(
              named,
              'shape',
              $dartnative_live_activities_9.LiveShape.rounded,
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final fixedHeight = D4.getOptionalNamedArg<double?>(
          named,
          'fixedHeight',
        );
        final byteSize = D4.getOptionalNamedArg<int?>(named, 'byteSize');
        final width = D4.getOptionalNamedArg<int?>(named, 'width');
        final height = D4.getOptionalNamedArg<int?>(named, 'height');
        return $dartnative_live_activities_6.LiveImage.asset(
          path,
          fit: fit,
          shape: shape,
          size: size,
          fixedHeight: fixedHeight,
          byteSize: byteSize,
          width: width,
          height: height,
        );
      },
      'network': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveImage');
        final url = D4.getRequiredArg<String>(
          positional,
          0,
          'url',
          'LiveImage',
        );
        final fit = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveFit>(
              named,
              'fit',
              $dartnative_live_activities_9.LiveFit.contain,
            );
        final shape = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveShape>(
              named,
              'shape',
              $dartnative_live_activities_9.LiveShape.rounded,
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final fixedHeight = D4.getOptionalNamedArg<double?>(
          named,
          'fixedHeight',
        );
        final byteSize = D4.getOptionalNamedArg<int?>(named, 'byteSize');
        final width = D4.getOptionalNamedArg<int?>(named, 'width');
        final height = D4.getOptionalNamedArg<int?>(named, 'height');
        return $dartnative_live_activities_6.LiveImage.network(
          url,
          fit: fit,
          shape: shape,
          size: size,
          fixedHeight: fixedHeight,
          byteSize: byteSize,
          width: width,
          height: height,
        );
      },
      'file': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveImage');
        final file = D4.getRequiredArg<File>(
          positional,
          0,
          'file',
          'LiveImage',
        );
        final fit = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveFit>(
              named,
              'fit',
              $dartnative_live_activities_9.LiveFit.contain,
            );
        final shape = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveShape>(
              named,
              'shape',
              $dartnative_live_activities_9.LiveShape.rounded,
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final fixedHeight = D4.getOptionalNamedArg<double?>(
          named,
          'fixedHeight',
        );
        final byteSize = D4.getOptionalNamedArg<int?>(named, 'byteSize');
        final width = D4.getOptionalNamedArg<int?>(named, 'width');
        final height = D4.getOptionalNamedArg<int?>(named, 'height');
        return $dartnative_live_activities_6.LiveImage.file(
          file,
          fit: fit,
          shape: shape,
          size: size,
          fixedHeight: fixedHeight,
          byteSize: byteSize,
          width: width,
          height: height,
        );
      },
      'memory': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveImage');
        final data = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'data',
          'LiveImage',
        );
        final fit = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveFit>(
              named,
              'fit',
              $dartnative_live_activities_9.LiveFit.contain,
            );
        final shape = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveShape>(
              named,
              'shape',
              $dartnative_live_activities_9.LiveShape.rounded,
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final fixedHeight = D4.getOptionalNamedArg<double?>(
          named,
          'fixedHeight',
        );
        final width = D4.getOptionalNamedArg<int?>(named, 'width');
        final height = D4.getOptionalNamedArg<int?>(named, 'height');
        return $dartnative_live_activities_6.LiveImage.memory(
          data,
          fit: fit,
          shape: shape,
          size: size,
          fixedHeight: fixedHeight,
          width: width,
          height: height,
        );
      },
      'reference': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveImage');
        final id = D4.getRequiredArg<String>(positional, 0, 'id', 'LiveImage');
        final fit = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveFit>(
              named,
              'fit',
              $dartnative_live_activities_9.LiveFit.contain,
            );
        final shape = D4
            .getNamedArgWithDefault<$dartnative_live_activities_9.LiveShape>(
              named,
              'shape',
              $dartnative_live_activities_9.LiveShape.rounded,
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        final fixedHeight = D4.getOptionalNamedArg<double?>(
          named,
          'fixedHeight',
        );
        return $dartnative_live_activities_6.LiveImage.reference(
          id,
          fit: fit,
          shape: shape,
          size: size,
          fixedHeight: fixedHeight,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveImage');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveImage: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_6.LiveImage.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .descendants,
      'source': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .source,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .key,
      'bytes': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .bytes,
      'id': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .id,
      'fit': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .fit,
      'shape': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .shape,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .size,
      'fixedHeight': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .fixedHeight,
      'byteSize': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .byteSize,
      'width': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .width,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveImage>(
            target,
            'LiveImage',
          )
          .height,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveImage>(
          target,
          'LiveImage',
        );
        return t.toJson();
      },
      'withSize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveImage>(
          target,
          'LiveImage',
        );
        D4.requireMinArgs(positional, 1, 'withSize');
        final size = D4.getRequiredArg<double>(
          positional,
          0,
          'size',
          'withSize',
        );
        return t.withSize(size);
      },
      'withHeight': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveImage>(
          target,
          'LiveImage',
        );
        D4.requireMinArgs(positional, 1, 'withHeight');
        final height = D4.getRequiredArg<double>(
          positional,
          0,
          'height',
          'withHeight',
        );
        return t.withHeight(height);
      },
      'asTracker': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveImage>(
          target,
          'LiveImage',
        );
        return t.asTracker();
      },
    },
    constructorSignatures: {
      'asset':
          'LiveImage.asset(String path, {LiveFit fit = LiveFit.contain, LiveShape shape = LiveShape.rounded, double? size, double? fixedHeight, int? byteSize, int? width, int? height})',
      'network':
          'LiveImage.network(String url, {LiveFit fit = LiveFit.contain, LiveShape shape = LiveShape.rounded, double? size, double? fixedHeight, int? byteSize, int? width, int? height})',
      'file':
          'LiveImage.file(File file, {LiveFit fit = LiveFit.contain, LiveShape shape = LiveShape.rounded, double? size, double? fixedHeight, int? byteSize, int? width, int? height})',
      'memory':
          'LiveImage.memory(Uint8List data, {LiveFit fit = LiveFit.contain, LiveShape shape = LiveShape.rounded, double? size, double? fixedHeight, int? width, int? height})',
      'reference':
          'LiveImage.reference(String id, {LiveFit fit = LiveFit.contain, LiveShape shape = LiveShape.rounded, double? size, double? fixedHeight})',
      'fromJson': 'factory LiveImage.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
      'withSize': 'LiveImage withSize(double size)',
      'withHeight': 'LiveImage withHeight(double height)',
      'asTracker': 'LiveTracker asTracker()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'source': 'LiveImageSource get source',
      'key': 'String get key',
      'bytes': 'Uint8List? get bytes',
      'id': 'String get id',
      'fit': 'LiveFit get fit',
      'shape': 'LiveShape get shape',
      'size': 'double? get size',
      'fixedHeight': 'double? get fixedHeight',
      'byteSize': 'int? get byteSize',
      'width': 'int? get width',
      'height': 'int? get height',
    },
  );
}

// =============================================================================
// LiveAvatar Bridge
// =============================================================================

BridgedClass _createLiveAvatarBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_6.LiveAvatar,
    name: 'LiveAvatar',
    isAssignable: (v) => v is $dartnative_live_activities_6.LiveAvatar,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveAvatar');
        final text = D4.getRequiredArg<String?>(
          positional,
          0,
          'text',
          'LiveAvatar',
        );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        return $dartnative_live_activities_6.LiveAvatar(text, size: size);
      },
      'bound': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveAvatar');
        final bindText = D4
            .getRequiredArg<$dartnative_live_activities_7.LiveBind>(
              positional,
              0,
              'bindText',
              'LiveAvatar',
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        return $dartnative_live_activities_6.LiveAvatar.bound(
          bindText,
          size: size,
        );
      },
      'photo': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveAvatar');
        final photo = D4
            .getRequiredArg<$dartnative_live_activities_6.LiveImage>(
              positional,
              0,
              'photo',
              'LiveAvatar',
            );
        final size = D4.getOptionalNamedArg<double?>(named, 'size');
        return $dartnative_live_activities_6.LiveAvatar.photo(
          photo,
          size: size,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveAvatar');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveAvatar: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_6.LiveAvatar.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveAvatar>(
            target,
            'LiveAvatar',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveAvatar>(
            target,
            'LiveAvatar',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveAvatar>(
            target,
            'LiveAvatar',
          )
          .descendants,
      'text': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveAvatar>(
            target,
            'LiveAvatar',
          )
          .text,
      'bindText': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveAvatar>(
            target,
            'LiveAvatar',
          )
          .bindText,
      'photo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveAvatar>(
            target,
            'LiveAvatar',
          )
          .photo,
      'size': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveAvatar>(
            target,
            'LiveAvatar',
          )
          .size,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveAvatar>(
          target,
          'LiveAvatar',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveAvatar(String? text, {double? size})',
      'bound': 'const LiveAvatar.bound(LiveBind bindText, {double? size})',
      'photo': 'const LiveAvatar.photo(LiveImage photo, {double? size})',
      'fromJson': 'factory LiveAvatar.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
      'text': 'String? get text',
      'bindText': 'LiveBind? get bindText',
      'photo': 'LiveImage? get photo',
      'size': 'double? get size',
    },
  );
}

// =============================================================================
// LiveTracker Bridge
// =============================================================================

BridgedClass _createLiveTrackerBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_6.LiveTracker,
    name: 'LiveTracker',
    isAssignable: (v) => v is $dartnative_live_activities_6.LiveTracker,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveTracker');
        final visual = D4
            .getRequiredArg<$dartnative_live_activities_6.LiveVisual>(
              positional,
              0,
              'visual',
              'LiveTracker',
            );
        final height = D4.getNamedArgWithDefault<double>(named, 'height', 24);
        final background = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveTrackerBackground
            >(
              named,
              'background',
              $dartnative_live_activities_9.LiveTrackerBackground.accentCircle,
            );
        return $dartnative_live_activities_6.LiveTracker(
          visual,
          height: height,
          background: background,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveTracker');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveTracker: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_6.LiveTracker.fromJson(json);
      },
    },
    getters: {
      'visual': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveTracker>(
            target,
            'LiveTracker',
          )
          .visual,
      'height': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveTracker>(
            target,
            'LiveTracker',
          )
          .height,
      'background': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_6.LiveTracker>(
            target,
            'LiveTracker',
          )
          .background,
    },
    methods: {
      'asTracker': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveTracker>(
          target,
          'LiveTracker',
        );
        return t.asTracker();
      },
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_6.LiveTracker>(
          target,
          'LiveTracker',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveTracker(LiveVisual visual, {double height = 24, LiveTrackerBackground background = LiveTrackerBackground.accentCircle})',
      'fromJson': 'factory LiveTracker.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'asTracker': 'LiveTracker asTracker()',
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'visual': 'LiveVisual get visual',
      'height': 'double get height',
      'background': 'LiveTrackerBackground get background',
    },
  );
}

// =============================================================================
// LiveTextSource Bridge
// =============================================================================

BridgedClass _createLiveTextSourceBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_7.LiveTextSource,
    name: 'LiveTextSource',
    isAssignable: (v) => v is $dartnative_live_activities_7.LiveTextSource,
    isAbstract: true,
    constructors: {},
    methods: {
      'toAndroidTextJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_7.LiveTextSource>(
              target,
              'LiveTextSource',
            );
        return t.toAndroidTextJson();
      },
    },
    methodSignatures: {
      'toAndroidTextJson': 'Map<String, Object?> toAndroidTextJson()',
    },
  );
}

// =============================================================================
// LiveBind Bridge
// =============================================================================

BridgedClass _createLiveBindBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_7.LiveBind,
    name: 'LiveBind',
    isAssignable: (v) => v is $dartnative_live_activities_7.LiveBind,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveBind');
        final field = D4.getRequiredArg<String>(
          positional,
          0,
          'field',
          'LiveBind',
        );
        return $dartnative_live_activities_7.LiveBind(field);
      },
    },
    getters: {
      'field': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_7.LiveBind>(
            target,
            'LiveBind',
          )
          .field,
      'isTrue': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_7.LiveBind>(
            target,
            'LiveBind',
          )
          .isTrue,
      'hashCode': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_7.LiveBind>(
            target,
            'LiveBind',
          )
          .hashCode,
    },
    methods: {
      'equals': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_7.LiveBind>(
          target,
          'LiveBind',
        );
        D4.requireMinArgs(positional, 1, 'equals');
        final value = D4.getRequiredArg<Object?>(
          positional,
          0,
          'value',
          'equals',
        );
        return t.equals(value);
      },
      'notEquals': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_7.LiveBind>(
          target,
          'LiveBind',
        );
        D4.requireMinArgs(positional, 1, 'notEquals');
        final value = D4.getRequiredArg<Object?>(
          positional,
          0,
          'value',
          'notEquals',
        );
        return t.notEquals(value);
      },
      'greaterThan': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_7.LiveBind>(
          target,
          'LiveBind',
        );
        D4.requireMinArgs(positional, 1, 'greaterThan');
        final value = D4.getRequiredArg<num>(
          positional,
          0,
          'value',
          'greaterThan',
        );
        return t.greaterThan(value);
      },
      'greaterOrEqual': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_7.LiveBind>(
          target,
          'LiveBind',
        );
        D4.requireMinArgs(positional, 1, 'greaterOrEqual');
        final value = D4.getRequiredArg<num>(
          positional,
          0,
          'value',
          'greaterOrEqual',
        );
        return t.greaterOrEqual(value);
      },
      'lessThan': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_7.LiveBind>(
          target,
          'LiveBind',
        );
        D4.requireMinArgs(positional, 1, 'lessThan');
        final value = D4.getRequiredArg<num>(
          positional,
          0,
          'value',
          'lessThan',
        );
        return t.lessThan(value);
      },
      'lessOrEqual': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_7.LiveBind>(
          target,
          'LiveBind',
        );
        D4.requireMinArgs(positional, 1, 'lessOrEqual');
        final value = D4.getRequiredArg<num>(
          positional,
          0,
          'value',
          'lessOrEqual',
        );
        return t.lessOrEqual(value);
      },
      'toAndroidTextJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_7.LiveBind>(
          target,
          'LiveBind',
        );
        return t.toAndroidTextJson();
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_7.LiveBind>(
          target,
          'LiveBind',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_7.LiveBind>(
          target,
          'LiveBind',
        );
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(
          positional,
          0,
          'other',
          'operator==',
        );
        return t == other;
      },
    },
    staticGetters: {
      'stale': (visitor) => $dartnative_live_activities_7.LiveBind.stale,
    },
    constructorSignatures: {
      '': 'const LiveBind(String field)',
    },
    methodSignatures: {
      'equals': 'LiveCondition equals(Object? value)',
      'notEquals': 'LiveCondition notEquals(Object? value)',
      'greaterThan': 'LiveCondition greaterThan(num value)',
      'greaterOrEqual': 'LiveCondition greaterOrEqual(num value)',
      'lessThan': 'LiveCondition lessThan(num value)',
      'lessOrEqual': 'LiveCondition lessOrEqual(num value)',
      'toAndroidTextJson': 'Map<String, Object?> toAndroidTextJson()',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'field': 'String get field',
      'isTrue': 'LiveCondition get isTrue',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'stale': 'LiveBind get stale',
    },
  );
}

// =============================================================================
// LiveCondition Bridge
// =============================================================================

BridgedClass _createLiveConditionBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_7.LiveCondition,
    name: 'LiveCondition',
    isAssignable: (v) => v is $dartnative_live_activities_7.LiveCondition,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 3, 'LiveCondition');
        final field = D4.getRequiredArg<String>(
          positional,
          0,
          'field',
          'LiveCondition',
        );
        final op = D4.getRequiredArg<String>(
          positional,
          1,
          'op',
          'LiveCondition',
        );
        final value = D4.getRequiredArg<Object?>(
          positional,
          2,
          'value',
          'LiveCondition',
        );
        return $dartnative_live_activities_7.LiveCondition(field, op, value);
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveCondition');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveCondition: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_7.LiveCondition.fromJson(json);
      },
    },
    getters: {
      'field': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_7.LiveCondition>(
            target,
            'LiveCondition',
          )
          .field,
      'op': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_7.LiveCondition>(
            target,
            'LiveCondition',
          )
          .op,
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_7.LiveCondition>(
            target,
            'LiveCondition',
          )
          .value,
      'hashCode': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_7.LiveCondition>(
            target,
            'LiveCondition',
          )
          .hashCode,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_7.LiveCondition>(
              target,
              'LiveCondition',
            );
        return t.toJson();
      },
      'evaluate': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_7.LiveCondition>(
              target,
              'LiveCondition',
            );
        D4.requireMinArgs(positional, 1, 'evaluate');
        if (positional.isEmpty) {
          throw ArgumentError(
            'evaluate: Missing required argument "state" at position 0',
          );
        }
        final state = D4.coerceMap<String, Object?>(positional[0], 'state');
        return t.evaluate(state);
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_7.LiveCondition>(
              target,
              'LiveCondition',
            );
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(
          positional,
          0,
          'other',
          'operator==',
        );
        return t == other;
      },
    },
    staticGetters: {
      'operators': (visitor) =>
          $dartnative_live_activities_7.LiveCondition.operators,
    },
    constructorSignatures: {
      '': 'const LiveCondition(String field, String op, Object? value)',
      'fromJson': 'factory LiveCondition.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
      'evaluate': 'bool evaluate(Map<String, Object?> state)',
    },
    getterSignatures: {
      'field': 'String get field',
      'op': 'String get op',
      'value': 'Object? get value',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'operators': 'Set<String> get operators',
    },
  );
}

// =============================================================================
// LiveCheck Bridge
// =============================================================================

BridgedClass _createLiveCheckBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_8.LiveCheck,
    name: 'LiveCheck',
    isAssignable: (v) => v is $dartnative_live_activities_8.LiveCheck,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 3, 'LiveCheck');
        final severity = D4
            .getRequiredArg<$dartnative_live_activities_8.LiveSeverity>(
              positional,
              0,
              'severity',
              'LiveCheck',
            );
        final code = D4.getRequiredArg<String>(
          positional,
          1,
          'code',
          'LiveCheck',
        );
        final message = D4.getRequiredArg<String>(
          positional,
          2,
          'message',
          'LiveCheck',
        );
        return $dartnative_live_activities_8.LiveCheck(severity, code, message);
      },
    },
    getters: {
      'severity': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_8.LiveCheck>(
            target,
            'LiveCheck',
          )
          .severity,
      'code': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_8.LiveCheck>(
            target,
            'LiveCheck',
          )
          .code,
      'message': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_8.LiveCheck>(
            target,
            'LiveCheck',
          )
          .message,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_8.LiveCheck>(
          target,
          'LiveCheck',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const LiveCheck(LiveSeverity severity, String code, String message)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'severity': 'LiveSeverity get severity',
      'code': 'String get code',
      'message': 'String get message',
    },
  );
}

// =============================================================================
// LiveReport Bridge
// =============================================================================

BridgedClass _createLiveReportBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_8.LiveReport,
    name: 'LiveReport',
    isAssignable: (v) => v is $dartnative_live_activities_8.LiveReport,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveReport');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveReport: Missing required argument "items" at position 0',
          );
        }
        final items = D4.coerceList<$dartnative_live_activities_8.LiveCheck>(
          positional[0],
          'items',
        );
        return $dartnative_live_activities_8.LiveReport(items);
      },
    },
    getters: {
      'items': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_8.LiveReport>(
            target,
            'LiveReport',
          )
          .items,
      'hasErrors': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_8.LiveReport>(
            target,
            'LiveReport',
          )
          .hasErrors,
      'hasWarnings': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_8.LiveReport>(
            target,
            'LiveReport',
          )
          .hasWarnings,
    },
    methods: {
      'byCode': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_8.LiveReport>(
          target,
          'LiveReport',
        );
        D4.requireMinArgs(positional, 1, 'byCode');
        final code = D4.getRequiredArg<String>(positional, 0, 'code', 'byCode');
        return t.byCode(code);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_8.LiveReport>(
          target,
          'LiveReport',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const LiveReport(List<LiveCheck> items)',
    },
    methodSignatures: {
      'byCode': 'LiveCheck? byCode(String code)',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'items': 'List<LiveCheck> get items',
      'hasErrors': 'bool get hasErrors',
      'hasWarnings': 'bool get hasWarnings',
    },
  );
}

// =============================================================================
// LiveTheme Bridge
// =============================================================================

BridgedClass _createLiveThemeBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_10.LiveTheme,
    name: 'LiveTheme',
    isAssignable: (v) => v is $dartnative_live_activities_10.LiveTheme,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getRequiredNamedArg<$dartnative_1.Color>(
          named,
          'accent',
          'LiveTheme',
        );
        final background = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'background',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        return $dartnative_live_activities_10.LiveTheme(
          accent: accent,
          background: background,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveTheme');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveTheme: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_10.LiveTheme.fromJson(json);
      },
    },
    getters: {
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveTheme>(
            target,
            'LiveTheme',
          )
          .accent,
      'background': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveTheme>(
            target,
            'LiveTheme',
          )
          .background,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_10.LiveTheme>(
          target,
          'LiveTheme',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveTheme({required Color accent, LiveBackground background = LiveBackground.system})',
      'fromJson': 'factory LiveTheme.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'accent': 'Color get accent',
      'background': 'LiveBackground get background',
    },
  );
}

// =============================================================================
// LiveExpanded Bridge
// =============================================================================

BridgedClass _createLiveExpandedBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_10.LiveExpanded,
    name: 'LiveExpanded',
    isAssignable: (v) => v is $dartnative_live_activities_10.LiveExpanded,
    constructors: {
      '': (visitor, positional, named) {
        final leading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'leading',
            );
        final center = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'center',
            );
        final trailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'trailing',
            );
        final bottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'bottom',
            );
        return $dartnative_live_activities_10.LiveExpanded(
          leading: leading,
          center: center,
          trailing: trailing,
          bottom: bottom,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveExpanded');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveExpanded: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_10.LiveExpanded.fromJson(json);
      },
    },
    getters: {
      'leading': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveExpanded>(
            target,
            'LiveExpanded',
          )
          .leading,
      'center': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveExpanded>(
            target,
            'LiveExpanded',
          )
          .center,
      'trailing': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveExpanded>(
            target,
            'LiveExpanded',
          )
          .trailing,
      'bottom': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveExpanded>(
            target,
            'LiveExpanded',
          )
          .bottom,
      'nodes': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveExpanded>(
            target,
            'LiveExpanded',
          )
          .nodes,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_10.LiveExpanded>(
              target,
              'LiveExpanded',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveExpanded({LiveNode? leading, LiveNode? center, LiveNode? trailing, LiveNode? bottom})',
      'fromJson': 'factory LiveExpanded.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'leading': 'LiveNode? get leading',
      'center': 'LiveNode? get center',
      'trailing': 'LiveNode? get trailing',
      'bottom': 'LiveNode? get bottom',
      'nodes': 'Iterable<LiveNode> get nodes',
    },
  );
}

// =============================================================================
// LiveLockScreen Bridge
// =============================================================================

BridgedClass _createLiveLockScreenBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_10.LiveLockScreen,
    name: 'LiveLockScreen',
    isAssignable: (v) => v is $dartnative_live_activities_10.LiveLockScreen,
    constructors: {
      'sameAsExpanded': (visitor, positional, named) {
        return $dartnative_live_activities_10.LiveLockScreen.sameAsExpanded();
      },
      'custom': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveLockScreen');
        final custom = D4
            .getRequiredArg<$dartnative_live_activities_11.LiveNode>(
              positional,
              0,
              'custom',
              'LiveLockScreen',
            );
        return $dartnative_live_activities_10.LiveLockScreen.custom(custom);
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveLockScreen');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveLockScreen: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_10.LiveLockScreen.fromJson(json);
      },
    },
    getters: {
      'custom': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLockScreen>(
            target,
            'LiveLockScreen',
          )
          .custom,
      'isSameAsExpanded': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLockScreen>(
            target,
            'LiveLockScreen',
          )
          .isSameAsExpanded,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_10.LiveLockScreen>(
              target,
              'LiveLockScreen',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      'sameAsExpanded': 'const LiveLockScreen.sameAsExpanded()',
      'custom': 'const LiveLockScreen.custom(LiveNode custom)',
      'fromJson': 'factory LiveLockScreen.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'custom': 'LiveNode? get custom',
      'isSameAsExpanded': 'bool get isSameAsExpanded',
    },
  );
}

// =============================================================================
// LiveChip Bridge
// =============================================================================

BridgedClass _createLiveChipBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_10.LiveChip,
    name: 'LiveChip',
    isAssignable: (v) => v is $dartnative_live_activities_10.LiveChip,
    constructors: {
      'countdown': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveChip');
        final until = D4.getRequiredArg<$dartnative_live_activities_7.LiveBind>(
          positional,
          0,
          'until',
          'LiveChip',
        );
        return $dartnative_live_activities_10.LiveChip.countdown(until);
      },
      'text': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveChip');
        final text = D4.getRequiredArg<String>(
          positional,
          0,
          'text',
          'LiveChip',
        );
        return $dartnative_live_activities_10.LiveChip.text(text);
      },
      'icon': (visitor, positional, named) {
        return $dartnative_live_activities_10.LiveChip.icon();
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveChip');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveChip: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_10.LiveChip.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveChip>(
            target,
            'LiveChip',
          )
          .type,
      'bind': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveChip>(
            target,
            'LiveChip',
          )
          .bind,
      'text': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveChip>(
            target,
            'LiveChip',
          )
          .text,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_10.LiveChip>(
          target,
          'LiveChip',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      'countdown': 'const LiveChip.countdown(LiveBind until)',
      'text': 'const LiveChip.text(String text)',
      'icon': 'const LiveChip.icon()',
      'fromJson': 'factory LiveChip.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'bind': 'LiveBind? get bind',
      'text': 'String? get text',
    },
  );
}

// =============================================================================
// LiveAndroid Bridge
// =============================================================================

BridgedClass _createLiveAndroidBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_10.LiveAndroid,
    name: 'LiveAndroid',
    isAssignable: (v) => v is $dartnative_live_activities_10.LiveAndroid,
    constructors: {
      '': (visitor, positional, named) {
        final title = D4
            .getOptionalNamedArg<$dartnative_live_activities_7.LiveTextSource?>(
              named,
              'title',
            );
        final text = D4
            .getOptionalNamedArg<$dartnative_live_activities_7.LiveTextSource?>(
              named,
              'text',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final colorized = D4.getNamedArgWithDefault<bool>(
          named,
          'colorized',
          false,
        );
        final progress = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'progress',
            );
        final actions = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['actions'],
              'actions',
            );
        final largeIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'largeIcon',
            );
        final subText = D4
            .getOptionalNamedArg<$dartnative_live_activities_7.LiveTextSource?>(
              named,
              'subText',
            );
        final style = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'style',
              $dartnative_live_activities_9.LiveAndroidStyle.liveUpdate,
            );
        final card = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'card',
            );
        final cardCollapsed = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'cardCollapsed',
            );
        return $dartnative_live_activities_10.LiveAndroid(
          title: title,
          text: text,
          chip: chip,
          colorized: colorized,
          progress: progress,
          actions: actions,
          largeIcon: largeIcon,
          subText: subText,
          style: style,
          card: card,
          cardCollapsed: cardCollapsed,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveAndroid');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveAndroid: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_10.LiveAndroid.fromJson(json);
      },
    },
    getters: {
      'style': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .style,
      'card': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .card,
      'cardCollapsed': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .cardCollapsed,
      'title': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .title,
      'text': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .text,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .chip,
      'colorized': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .colorized,
      'progress': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .progress,
      'actions': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .actions,
      'largeIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .largeIcon,
      'subText': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveAndroid>(
            target,
            'LiveAndroid',
          )
          .subText,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_10.LiveAndroid>(
          target,
          'LiveAndroid',
        );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveAndroid({LiveTextSource? title, LiveTextSource? text, LiveChip? chip, bool colorized = false, LiveNode? progress, List<LiveButton>? actions, LiveVisual? largeIcon, LiveTextSource? subText, LiveAndroidStyle style = LiveAndroidStyle.liveUpdate, LiveNode? card, LiveNode? cardCollapsed})',
      'fromJson': 'factory LiveAndroid.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'style': 'LiveAndroidStyle get style',
      'card': 'LiveNode? get card',
      'cardCollapsed': 'LiveNode? get cardCollapsed',
      'title': 'LiveTextSource? get title',
      'text': 'LiveTextSource? get text',
      'chip': 'LiveChip? get chip',
      'colorized': 'bool get colorized',
      'progress': 'LiveNode? get progress',
      'actions': 'List<LiveButton>? get actions',
      'largeIcon': 'LiveVisual? get largeIcon',
      'subText': 'LiveTextSource? get subText',
    },
  );
}

// =============================================================================
// LiveImageMeta Bridge
// =============================================================================

BridgedClass _createLiveImageMetaBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_10.LiveImageMeta,
    name: 'LiveImageMeta',
    isAssignable: (v) => v is $dartnative_live_activities_10.LiveImageMeta,
    constructors: {
      '': (visitor, positional, named) {
        final file = D4.getRequiredNamedArg<String>(
          named,
          'file',
          'LiveImageMeta',
        );
        final w = D4.getRequiredNamedArg<int>(named, 'w', 'LiveImageMeta');
        final h = D4.getRequiredNamedArg<int>(named, 'h', 'LiveImageMeta');
        return $dartnative_live_activities_10.LiveImageMeta(
          file: file,
          w: w,
          h: h,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveImageMeta');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveImageMeta: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_10.LiveImageMeta.fromJson(json);
      },
    },
    getters: {
      'file': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveImageMeta>(
            target,
            'LiveImageMeta',
          )
          .file,
      'w': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveImageMeta>(
            target,
            'LiveImageMeta',
          )
          .w,
      'h': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveImageMeta>(
            target,
            'LiveImageMeta',
          )
          .h,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_10.LiveImageMeta>(
              target,
              'LiveImageMeta',
            );
        return t.toJson();
      },
    },
    constructorSignatures: {
      '': 'const LiveImageMeta({required String file, required int w, required int h})',
      'fromJson': 'factory LiveImageMeta.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'file': 'String get file',
      'w': 'int get w',
      'h': 'int get h',
    },
  );
}

// =============================================================================
// LiveLayout Bridge
// =============================================================================

BridgedClass _createLiveLayoutBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_10.LiveLayout,
    name: 'LiveLayout',
    isAssignable: (v) => v is $dartnative_live_activities_10.LiveLayout,
    constructors: {
      '': (visitor, positional, named) {
        final theme = D4
            .getRequiredNamedArg<$dartnative_live_activities_10.LiveTheme>(
              named,
              'theme',
              'LiveLayout',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return $dartnative_live_activities_10.LiveLayout(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          lockScreen: lockScreen,
          android: android,
        );
      },
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveLayout');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveLayout: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_10.LiveLayout.fromJson(json);
      },
    },
    getters: {
      'theme': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .theme,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .androidSmallIcon,
      'compactLeading': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .compactLeading,
      'compactTrailing': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .compactTrailing,
      'minimal': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .minimal,
      'expanded': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .expanded,
      'lockScreen': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .lockScreen,
      'android': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .android,
      'allNodes': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .allNodes,
      'images': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_10.LiveLayout>(
            target,
            'LiveLayout',
          )
          .images,
    },
    methods: {
      'copyWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_10.LiveLayout>(
          target,
          'LiveLayout',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.copyWith(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          lockScreen: lockScreen,
          android: android,
        );
      },
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_10.LiveLayout>(
          target,
          'LiveLayout',
        );
        final resolved = D4
            .coerceMapOrNull<
              String,
              $dartnative_live_activities_10.LiveImageMeta
            >(named['resolved'], 'resolved');
        return t.toJson(resolved: resolved);
      },
    },
    constructorSignatures: {
      '': 'const LiveLayout({required LiveTheme theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveLockScreen? lockScreen, LiveAndroid? android})',
      'fromJson': 'factory LiveLayout.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'copyWith':
          'LiveLayout copyWith({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveLockScreen? lockScreen, LiveAndroid? android})',
      'toJson':
          'Map<String, Object?> toJson({Map<String, LiveImageMeta>? resolved})',
    },
    getterSignatures: {
      'theme': 'LiveTheme get theme',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'compactLeading': 'LiveNode? get compactLeading',
      'compactTrailing': 'LiveNode? get compactTrailing',
      'minimal': 'LiveNode? get minimal',
      'expanded': 'LiveExpanded? get expanded',
      'lockScreen': 'LiveLockScreen? get lockScreen',
      'android': 'LiveAndroid? get android',
      'allNodes': 'Iterable<LiveNode> get allNodes',
      'images': 'List<LiveImage> get images',
    },
  );
}

// =============================================================================
// LiveNode Bridge
// =============================================================================

BridgedClass _createLiveNodeBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_11.LiveNode,
    name: 'LiveNode',
    isAssignable: (v) => v is $dartnative_live_activities_11.LiveNode,
    isAbstract: true,
    constructors: {
      'fromJson': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveNode');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveNode: Missing required argument "json" at position 0',
          );
        }
        final json = D4.coerceMap<String, Object?>(positional[0], 'json');
        return $dartnative_live_activities_11.LiveNode.fromJson(json);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_11.LiveNode>(
            target,
            'LiveNode',
          )
          .type,
      'children': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_11.LiveNode>(
            target,
            'LiveNode',
          )
          .children,
      'descendants': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_11.LiveNode>(
            target,
            'LiveNode',
          )
          .descendants,
    },
    methods: {
      'toJson': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_11.LiveNode>(
          target,
          'LiveNode',
        );
        return t.toJson();
      },
    },
    staticMethods: {
      'listFromJson': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'listFromJson');
        final raw = D4.getRequiredArg<Object?>(
          positional,
          0,
          'raw',
          'listFromJson',
        );
        return $dartnative_live_activities_11.LiveNode.listFromJson(raw);
      },
    },
    constructorSignatures: {
      'fromJson': 'factory LiveNode.fromJson(Map<String, Object?> json)',
    },
    methodSignatures: {
      'toJson': 'Map<String, Object?> toJson()',
    },
    getterSignatures: {
      'type': 'String get type',
      'children': 'Iterable<LiveNode> get children',
      'descendants': 'Iterable<LiveNode> get descendants',
    },
    staticMethodSignatures: {
      'listFromJson': 'List<LiveNode> listFromJson(Object? raw)',
    },
  );
}

// =============================================================================
// LiveLatLng Bridge
// =============================================================================

BridgedClass _createLiveLatLngBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_12.LiveLatLng,
    name: 'LiveLatLng',
    isAssignable: (v) => v is $dartnative_live_activities_12.LiveLatLng,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'LiveLatLng');
        final lat = D4.getRequiredArg<double>(
          positional,
          0,
          'lat',
          'LiveLatLng',
        );
        final lng = D4.getRequiredArg<double>(
          positional,
          1,
          'lng',
          'LiveLatLng',
        );
        return $dartnative_live_activities_12.LiveLatLng(lat, lng);
      },
    },
    getters: {
      'lat': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_12.LiveLatLng>(
            target,
            'LiveLatLng',
          )
          .lat,
      'lng': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_12.LiveLatLng>(
            target,
            'LiveLatLng',
          )
          .lng,
      'hashCode': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_12.LiveLatLng>(
            target,
            'LiveLatLng',
          )
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_12.LiveLatLng>(
          target,
          'LiveLatLng',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_12.LiveLatLng>(
          target,
          'LiveLatLng',
        );
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(
          positional,
          0,
          'other',
          'operator==',
        );
        return t == other;
      },
    },
    constructorSignatures: {
      '': 'const LiveLatLng(double lat, double lng)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'lat': 'double get lat',
      'lng': 'double get lng',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// LiveRoute Bridge
// =============================================================================

BridgedClass _createLiveRouteBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_12.LiveRoute,
    name: 'LiveRoute',
    isAssignable: (v) => v is $dartnative_live_activities_12.LiveRoute,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveRoute');
        if (positional.isEmpty) {
          throw ArgumentError(
            'LiveRoute: Missing required argument "path" at position 0',
          );
        }
        final path = D4.coerceList<$dartnative_live_activities_12.LiveLatLng>(
          positional[0],
          'path',
        );
        return $dartnative_live_activities_12.LiveRoute(path);
      },
      'straight': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'LiveRoute');
        final start = D4
            .getRequiredArg<$dartnative_live_activities_12.LiveLatLng>(
              positional,
              0,
              'start',
              'LiveRoute',
            );
        final end = D4
            .getRequiredArg<$dartnative_live_activities_12.LiveLatLng>(
              positional,
              1,
              'end',
              'LiveRoute',
            );
        return $dartnative_live_activities_12.LiveRoute.straight(start, end);
      },
    },
    getters: {
      'path': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_12.LiveRoute>(
            target,
            'LiveRoute',
          )
          .path,
      'totalMeters': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_12.LiveRoute>(
            target,
            'LiveRoute',
          )
          .totalMeters,
    },
    methods: {
      'progressAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_12.LiveRoute>(
          target,
          'LiveRoute',
        );
        D4.requireMinArgs(positional, 1, 'progressAt');
        final position = D4
            .getRequiredArg<$dartnative_live_activities_12.LiveLatLng>(
              positional,
              0,
              'position',
              'progressAt',
            );
        return t.progressAt(position);
      },
      'remainingMeters': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_12.LiveRoute>(
          target,
          'LiveRoute',
        );
        D4.requireMinArgs(positional, 1, 'remainingMeters');
        final position = D4
            .getRequiredArg<$dartnative_live_activities_12.LiveLatLng>(
              positional,
              0,
              'position',
              'remainingMeters',
            );
        return t.remainingMeters(position);
      },
      'metersToEnd': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_12.LiveRoute>(
          target,
          'LiveRoute',
        );
        D4.requireMinArgs(positional, 1, 'metersToEnd');
        final position = D4
            .getRequiredArg<$dartnative_live_activities_12.LiveLatLng>(
              positional,
              0,
              'position',
              'metersToEnd',
            );
        return t.metersToEnd(position);
      },
      'stageAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_12.LiveRoute>(
          target,
          'LiveRoute',
        );
        D4.requireMinArgs(positional, 2, 'stageAt');
        final position = D4
            .getRequiredArg<$dartnative_live_activities_12.LiveLatLng>(
              positional,
              0,
              'position',
              'stageAt',
            );
        final stages = D4.getRequiredArg<int>(
          positional,
          1,
          'stages',
          'stageAt',
        );
        return t.stageAt(position, stages);
      },
      'hasArrived': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_12.LiveRoute>(
          target,
          'LiveRoute',
        );
        D4.requireMinArgs(positional, 1, 'hasArrived');
        final position = D4
            .getRequiredArg<$dartnative_live_activities_12.LiveLatLng>(
              positional,
              0,
              'position',
              'hasArrived',
            );
        final meters = D4.getNamedArgWithDefault<double>(named, 'meters', 50);
        return t.hasArrived(position, meters: meters);
      },
    },
    constructorSignatures: {
      '': 'LiveRoute(List<LiveLatLng> path)',
      'straight': 'LiveRoute.straight(LiveLatLng start, LiveLatLng end)',
    },
    methodSignatures: {
      'progressAt': 'double progressAt(LiveLatLng position)',
      'remainingMeters': 'double remainingMeters(LiveLatLng position)',
      'metersToEnd': 'double metersToEnd(LiveLatLng position)',
      'stageAt': 'int stageAt(LiveLatLng position, int stages)',
      'hasArrived':
          'bool hasArrived(LiveLatLng position, {double meters = 50})',
    },
    getterSignatures: {
      'path': 'List<LiveLatLng> get path',
      'totalMeters': 'double get totalMeters',
    },
  );
}

// =============================================================================
// LiveState Bridge
// =============================================================================

BridgedClass _createLiveStateBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_13.LiveState,
    name: 'LiveState',
    isAssignable: (v) => v is $dartnative_live_activities_13.LiveState,
    isAbstract: true,
    constructors: {},
    staticGetters: {
      'maxBytes': (visitor) =>
          $dartnative_live_activities_13.LiveState.maxBytes,
    },
    staticMethods: {
      'normalize': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'normalize');
        if (positional.isEmpty) {
          throw ArgumentError(
            'normalize: Missing required argument "state" at position 0',
          );
        }
        final state = D4.coerceMap<String, Object?>(positional[0], 'state');
        return $dartnative_live_activities_13.LiveState.normalize(state);
      },
      'byteSize': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'byteSize');
        if (positional.isEmpty) {
          throw ArgumentError(
            'byteSize: Missing required argument "state" at position 0',
          );
        }
        final state = D4.coerceMap<String, Object?>(positional[0], 'state');
        return $dartnative_live_activities_13.LiveState.byteSize(state);
      },
    },
    staticMethodSignatures: {
      'normalize': 'Map<String, Object?> normalize(Map<String, Object?> state)',
      'byteSize': 'int byteSize(Map<String, Object?> state)',
    },
    staticGetterSignatures: {
      'maxBytes': 'int get maxBytes',
    },
  );
}

// =============================================================================
// LiveActivity Bridge
// =============================================================================

BridgedClass _createLiveActivityBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_14.LiveActivity,
    name: 'LiveActivity',
    isAssignable: (v) => v is $dartnative_live_activities_14.LiveActivity,
    constructors: {},
    getters: {
      'id': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_14.LiveActivity>(
            target,
            'LiveActivity',
          )
          .id,
      'customId': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_14.LiveActivity>(
            target,
            'LiveActivity',
          )
          .customId,
      'pushTokens': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_14.LiveActivity>(
            target,
            'LiveActivity',
          )
          .pushTokens,
      'states': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_14.LiveActivity>(
            target,
            'LiveActivity',
          )
          .states,
    },
    methods: {
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_14.LiveActivity>(
              target,
              'LiveActivity',
            );
        D4.requireMinArgs(positional, 1, 'update');
        if (positional.isEmpty) {
          throw ArgumentError(
            'update: Missing required argument "state" at position 0',
          );
        }
        final state = D4.coerceMap<String, Object?>(positional[0], 'state');
        final staleAfter = D4.getOptionalNamedArg<Duration?>(
          named,
          'staleAfter',
        );
        final alert = D4
            .getOptionalNamedArg<$dartnative_live_activities_17.LiveAlert?>(
              named,
              'alert',
            );
        final deepLink = D4.getOptionalNamedArg<String?>(named, 'deepLink');
        return t.update(
          state,
          staleAfter: staleAfter,
          alert: alert,
          deepLink: deepLink,
        );
      },
      'follow': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_14.LiveActivity>(
              target,
              'LiveActivity',
            );
        D4.requireMinArgs(positional, 2, 'follow');
        final source = D4.getRequiredArg<Stream<dynamic>>(
          positional,
          0,
          'source',
          'follow',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'follow: Missing required argument "toState" at position 1',
          );
        }
        final toStateRaw = positional[1];
        final minInterval = D4.getNamedArgWithDefault<Duration>(
          named,
          'minInterval',
          const Duration(seconds: 5),
        );
        return t.follow<Object?>(
          source,
          ((dynamic p0) {
                return D4.extractBridgedArg<Map<String, Object?>>(
                      D4.callInterpreterCallback(visitor!, toStateRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as Map<String, Object?>;
              })
              as Map<String, Object?> Function(dynamic),
          minInterval: minInterval,
        );
      },
      'scheduleEnd': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_14.LiveActivity>(
              target,
              'LiveActivity',
            );
        D4.requireMinArgs(positional, 1, 'scheduleEnd');
        final at = D4.getRequiredArg<DateTime>(
          positional,
          0,
          'at',
          'scheduleEnd',
        );
        final state = D4.coerceMapOrNull<String, Object?>(
          named['state'],
          'state',
        );
        return t.scheduleEnd(at, state: state);
      },
      'end': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_14.LiveActivity>(
              target,
              'LiveActivity',
            );
        final state = D4.coerceMapOrNull<String, Object?>(
          named['state'],
          'state',
        );
        final dismiss = D4
            .getNamedArgWithDefault<$dartnative_live_activities_17.LiveDismiss>(
              named,
              'dismiss',
              $dartnative_live_activities_17.LiveDismiss.byDefault,
            );
        return t.end(state: state, dismiss: dismiss);
      },
    },
    methodSignatures: {
      'update':
          'Future<void> update(Map<String, Object?> state, {Duration? staleAfter, LiveAlert? alert, String? deepLink})',
      'follow':
          'StreamSubscription<T> follow(Stream<T> source, Map<String, Object?> Function(T event) toState, {Duration minInterval = const Duration(seconds: 5)})',
      'scheduleEnd':
          'Future<void> scheduleEnd(DateTime at, {Map<String, Object?>? state})',
      'end':
          'Future<void> end({Map<String, Object?>? state, LiveDismiss dismiss = LiveDismiss.byDefault})',
    },
    getterSignatures: {
      'id': 'String get id',
      'customId': 'String? get customId',
      'pushTokens': 'Stream<String> get pushTokens',
      'states': 'Stream<LiveActivityState> get states',
    },
  );
}

// =============================================================================
// LiveActivities Bridge
// =============================================================================

BridgedClass _createLiveActivitiesBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_14.LiveActivities,
    name: 'LiveActivities',
    isAssignable: (v) => v is $dartnative_live_activities_14.LiveActivities,
    isAbstract: true,
    constructors: {},
    staticGetters: {
      'actions': (visitor) =>
          $dartnative_live_activities_14.LiveActivities.actions,
      'pushTokens': (visitor) =>
          $dartnative_live_activities_14.LiveActivities.pushTokens,
      'stateChanges': (visitor) =>
          $dartnative_live_activities_14.LiveActivities.stateChanges,
      'startedByPush': (visitor) =>
          $dartnative_live_activities_14.LiveActivities.startedByPush,
    },
    staticMethods: {
      'debugOverride': (visitor, positional, named, typeArgs) {
        final platform = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_17.LiveActivitiesPlatform?
            >(named, 'platform');
        final imageReaderRaw = named['imageReader'];
        final imageReader = imageReaderRaw == null
            ? null
            : (($dartnative_live_activities_6.LiveImage p0) {
                    return Future.value(
                      D4.callInterpreterCallback(visitor!, imageReaderRaw, [
                        p0,
                      ]),
                    ).then((v) => v as Uint8List);
                  })
                  as Future<Uint8List> Function(
                    $dartnative_live_activities_6.LiveImage,
                  );
        final assetReaderRaw = named['assetReader'];
        final assetReader = assetReaderRaw == null
            ? null
            : ((String p0) {
                    return Future.value(
                      D4.callInterpreterCallback(visitor!, assetReaderRaw, [
                        p0,
                      ]),
                    ).then((v) => v as Uint8List);
                  })
                  as Future<Uint8List> Function(String);
        return $dartnative_live_activities_14.LiveActivities.debugOverride(
          platform: platform,
          imageReader: imageReader,
          assetReader: assetReader,
        );
      },
      'areEnabled': (visitor, positional, named, typeArgs) {
        return $dartnative_live_activities_14.LiveActivities.areEnabled();
      },
      'requestPermission': (visitor, positional, named, typeArgs) {
        return $dartnative_live_activities_14
            .LiveActivities.requestPermission();
      },
      'openPromotionSettings': (visitor, positional, named, typeArgs) {
        return $dartnative_live_activities_14
            .LiveActivities.openPromotionSettings();
      },
      'activeActivities': (visitor, positional, named, typeArgs) {
        return $dartnative_live_activities_14.LiveActivities.activeActivities();
      },
      'activity': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'activity');
        final customId = D4.getRequiredArg<String>(
          positional,
          0,
          'customId',
          'activity',
        );
        return $dartnative_live_activities_14.LiveActivities.activity(customId);
      },
      'endAll': (visitor, positional, named, typeArgs) {
        final dismiss = D4
            .getNamedArgWithDefault<$dartnative_live_activities_17.LiveDismiss>(
              named,
              'dismiss',
              $dartnative_live_activities_17.LiveDismiss.immediate,
            );
        return $dartnative_live_activities_14.LiveActivities.endAll(
          dismiss: dismiss,
        );
      },
      'onAction': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'onAction');
        if (positional.isEmpty) {
          throw ArgumentError(
            'onAction: Missing required argument "callback" at position 0',
          );
        }
        final callbackRaw = positional[0];
        final callback = (String p0) {
          D4.callInterpreterCallback(visitor!, callbackRaw, [p0]);
        };
        return $dartnative_live_activities_14.LiveActivities.onAction(callback);
      },
      'registerLayout': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'registerLayout');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'registerLayout',
        );
        final layout = D4
            .getRequiredArg<$dartnative_live_activities_10.LiveLayout>(
              positional,
              1,
              'layout',
              'registerLayout',
            );
        return $dartnative_live_activities_14.LiveActivities.registerLayout(
          name,
          layout,
        );
      },
      'handlePush': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'handlePush');
        if (positional.isEmpty) {
          throw ArgumentError(
            'handlePush: Missing required argument "data" at position 0',
          );
        }
        final data = D4.coerceMap<String, Object?>(positional[0], 'data');
        return $dartnative_live_activities_14.LiveActivities.handlePush(data);
      },
      'start': (visitor, positional, named, typeArgs) {
        final layout = D4
            .getRequiredNamedArg<$dartnative_live_activities_10.LiveLayout>(
              named,
              'layout',
              'start',
            );
        if (!named.containsKey('state') || named['state'] == null) {
          throw ArgumentError('start: Missing required named argument "state"');
        }
        final state = D4.coerceMap<String, Object?>(named['state'], 'state');
        final deepLink = D4.getOptionalNamedArg<String?>(named, 'deepLink');
        final staleAfter = D4.getOptionalNamedArg<Duration?>(
          named,
          'staleAfter',
        );
        final relevance = D4.getNamedArgWithDefault<double>(
          named,
          'relevance',
          0,
        );
        final requestPushToken = D4.getNamedArgWithDefault<bool>(
          named,
          'requestPushToken',
          false,
        );
        final customId = D4.getOptionalNamedArg<String?>(named, 'customId');
        return $dartnative_live_activities_14.LiveActivities.start(
          layout: layout,
          state: state,
          deepLink: deepLink,
          staleAfter: staleAfter,
          relevance: relevance,
          requestPushToken: requestPushToken,
          customId: customId,
        );
      },
      'check': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'check');
        final layout = D4
            .getRequiredArg<$dartnative_live_activities_10.LiveLayout>(
              positional,
              0,
              'layout',
              'check',
            );
        if (positional.length <= 1) {
          throw ArgumentError(
            'check: Missing required argument "state" at position 1',
          );
        }
        final state = D4.coerceMap<String, Object?>(positional[1], 'state');
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        final androidPromotable = D4.getNamedArgWithDefault<bool>(
          named,
          'androidPromotable',
          true,
        );
        return $dartnative_live_activities_14.LiveActivities.check(
          layout,
          state,
          now: now,
          androidPromotable: androidPromotable,
        );
      },
    },
    staticMethodSignatures: {
      'debugOverride':
          'void debugOverride({LiveActivitiesPlatform? platform, LiveImageReader? imageReader, LiveAssetReader? assetReader})',
      'areEnabled': 'Future<bool> areEnabled()',
      'requestPermission': 'Future<bool> requestPermission()',
      'openPromotionSettings': 'Future<bool> openPromotionSettings()',
      'activeActivities': 'Future<List<LiveActivity>> activeActivities()',
      'activity': 'Future<LiveActivity?> activity(String customId)',
      'endAll':
          'Future<void> endAll({LiveDismiss dismiss = LiveDismiss.immediate})',
      'onAction':
          'StreamSubscription<String> onAction(void Function(String id) callback)',
      'registerLayout':
          'Future<void> registerLayout(String name, LiveLayout layout)',
      'handlePush': 'Future<String?> handlePush(Map<String, Object?> data)',
      'start':
          'Future<LiveActivity> start({required LiveLayout layout, required Map<String, Object?> state, String? deepLink, Duration? staleAfter, double relevance = 0, bool requestPushToken = false, String? customId})',
      'check':
          'LiveReport check(LiveLayout layout, Map<String, Object?> state, {DateTime? now, bool androidPromotable = true})',
    },
    staticGetterSignatures: {
      'actions': 'Stream<String> get actions',
      'pushTokens': 'Stream<LivePushToken> get pushTokens',
      'stateChanges': 'Stream<LiveActivityStateChange> get stateChanges',
      'startedByPush': 'Stream<LiveActivity> get startedByPush',
    },
  );
}

// =============================================================================
// RidePickupPreset Bridge
// =============================================================================

BridgedClass _createRidePickupPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_18.RidePickupPreset,
    name: 'RidePickupPreset',
    isAssignable: (v) => v is $dartnative_live_activities_18.RidePickupPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final dark = D4.getNamedArgWithDefault<bool>(named, 'dark', false);
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF1F5EFF),
        );
        final brand = D4.getNamedArgWithDefault<String>(named, 'brand', 'Run');
        final driverInitials = D4.getNamedArgWithDefault<String>(
          named,
          'driverInitials',
          'A',
        );
        final driverPhoto = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'driverPhoto',
            );
        final carImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'carImage',
            );
        final brandLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'brandLogo',
            );
        final headerImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'headerImage',
            );
        final trackerImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'trackerImage',
            );
        final compactIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'compactIcon',
            );
        final bar = D4
            .getOptionalNamedArg<$dartnative_live_activities_18.RideBar?>(
              named,
              'bar',
            );
        final showCar = D4.getNamedArgWithDefault<bool>(named, 'showCar', true);
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_18.RidePickupPreset(
          androidStyle: androidStyle,
          dark: dark,
          accent: accent,
          brand: brand,
          driverInitials: driverInitials,
          driverPhoto: driverPhoto,
          carImage: carImage,
          brandLogo: brandLogo,
          headerImage: headerImage,
          trackerImage: trackerImage,
          compactIcon: compactIcon,
          bar: bar,
          showCar: showCar,
          buttons: buttons,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .androidPromotable,
      'dark': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .dark,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .accent,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .brand,
      'driverInitials': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .driverInitials,
      'driverPhoto': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .driverPhoto,
      'carImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .carImage,
      'brandLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .brandLogo,
      'headerImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .headerImage,
      'trackerImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .trackerImage,
      'compactIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .compactIcon,
      'bar': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .bar,
      'showCar': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .showCar,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
            target,
            'RidePickupPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
              target,
              'RidePickupPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
              target,
              'RidePickupPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.RidePickupPreset>(
              target,
              'RidePickupPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const RidePickupPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, bool dark = false, Color accent = const Color(0xFF1F5EFF), String brand = \'Run\', String driverInitials = \'A\', LiveImage? driverPhoto, LiveImage? carImage, LiveImage? brandLogo, LiveImage? headerImage, LiveImage? trackerImage, LiveVisual? compactIcon, RideBar? bar, bool showCar = true, List<LiveButton>? buttons, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'dark': 'bool get dark',
      'accent': 'Color get accent',
      'brand': 'String get brand',
      'driverInitials': 'String get driverInitials',
      'driverPhoto': 'LiveImage? get driverPhoto',
      'carImage': 'LiveImage? get carImage',
      'brandLogo': 'LiveImage? get brandLogo',
      'headerImage': 'LiveImage? get headerImage',
      'trackerImage': 'LiveImage? get trackerImage',
      'compactIcon': 'LiveVisual? get compactIcon',
      'bar': 'RideBar? get bar',
      'showCar': 'bool get showCar',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// StorePickupPreset Bridge
// =============================================================================

BridgedClass _createStorePickupPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_18.StorePickupPreset,
    name: 'StorePickupPreset',
    isAssignable: (v) => v is $dartnative_live_activities_18.StorePickupPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF1E3932),
        );
        final stepColor = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'stepColor',
          const $dartnative_1.Color(0xFF00A862),
        );
        final store = D4.getNamedArgWithDefault<String>(
          named,
          'store',
          'Store pickup',
        );
        final brandLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'brandLogo',
            );
        final people = D4.coerceListOrNull<String>(named['people'], 'people');
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_18.StorePickupPreset(
          androidStyle: androidStyle,
          accent: accent,
          stepColor: stepColor,
          store: store,
          brandLogo: brandLogo,
          people: people,
          buttons: buttons,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .accent,
      'stepColor': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .stepColor,
      'store': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .store,
      'brandLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .brandLogo,
      'people': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .people,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
            target,
            'StorePickupPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
              target,
              'StorePickupPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
              target,
              'StorePickupPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.StorePickupPreset>(
              target,
              'StorePickupPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const StorePickupPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFF1E3932), Color stepColor = const Color(0xFF00A862), String store = \'Store pickup\', LiveImage? brandLogo, List<String>? people, List<LiveButton>? buttons, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'stepColor': 'Color get stepColor',
      'store': 'String get store',
      'brandLogo': 'LiveImage? get brandLogo',
      'people': 'List<String>? get people',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// RunPreset Bridge
// =============================================================================

BridgedClass _createRunPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_18.RunPreset,
    name: 'RunPreset',
    isAssignable: (v) => v is $dartnative_live_activities_18.RunPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF45C8FF),
        );
        final unit = D4.getNamedArgWithDefault<String>(
          named,
          'unit',
          'Kilometers',
        );
        final timeLabel = D4.getNamedArgWithDefault<String>(
          named,
          'timeLabel',
          'Time',
        );
        final brand = D4.getNamedArgWithDefault<String>(
          named,
          'brand',
          'Sprint',
        );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_18.RunPreset(
          androidStyle: androidStyle,
          accent: accent,
          unit: unit,
          timeLabel: timeLabel,
          brand: brand,
          buttons: buttons,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .accent,
      'unit': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .unit,
      'timeLabel': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .timeLabel,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .brand,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.RunPreset>(
            target,
            'RunPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.RunPreset>(
          target,
          'RunPreset',
        );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.RunPreset>(
          target,
          'RunPreset',
        );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.RunPreset>(
          target,
          'RunPreset',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const RunPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFF45C8FF), String unit = \'Kilometers\', String timeLabel = \'Time\', String brand = \'Sprint\', List<LiveButton>? buttons, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'unit': 'String get unit',
      'timeLabel': 'String get timeLabel',
      'brand': 'String get brand',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// MatchPreset Bridge
// =============================================================================

BridgedClass _createMatchPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_18.MatchPreset,
    name: 'MatchPreset',
    isAssignable: (v) => v is $dartnative_live_activities_18.MatchPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF1B5E20),
        );
        final homeCrest = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'homeCrest',
            );
        final awayCrest = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'awayCrest',
            );
        final homeLabel = D4.getNamedArgWithDefault<String>(
          named,
          'homeLabel',
          'Home',
        );
        final awayLabel = D4.getNamedArgWithDefault<String>(
          named,
          'awayLabel',
          'Away',
        );
        final link = D4.getNamedArgWithDefault<String>(
          named,
          'link',
          'View stats',
        );
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_18.MatchPreset(
          accent: accent,
          homeCrest: homeCrest,
          awayCrest: awayCrest,
          homeLabel: homeLabel,
          awayLabel: awayLabel,
          link: link,
          androidStyle: androidStyle,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .accent,
      'homeCrest': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .homeCrest,
      'awayCrest': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .awayCrest,
      'homeLabel': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .homeLabel,
      'awayLabel': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .awayLabel,
      'link': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .link,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .androidStyle,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.MatchPreset>(
            target,
            'MatchPreset',
          )
          .chip,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.MatchPreset>(
          target,
          'MatchPreset',
        );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.MatchPreset>(
          target,
          'MatchPreset',
        );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.MatchPreset>(
          target,
          'MatchPreset',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const MatchPreset({Color accent = const Color(0xFF1B5E20), LiveImage? homeCrest, LiveImage? awayCrest, String homeLabel = \'Home\', String awayLabel = \'Away\', String link = \'View stats\', LiveAndroidStyle androidStyle = LiveAndroidStyle.card, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'homeCrest': 'LiveImage? get homeCrest',
      'awayCrest': 'LiveImage? get awayCrest',
      'homeLabel': 'String get homeLabel',
      'awayLabel': 'String get awayLabel',
      'link': 'String get link',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
      'chip': 'LiveChip? get chip',
    },
  );
}

// =============================================================================
// StockPreset Bridge
// =============================================================================

BridgedClass _createStockPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_18.StockPreset,
    name: 'StockPreset',
    isAssignable: (v) => v is $dartnative_live_activities_18.StockPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final brandLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'brandLogo',
            );
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        if (!named.containsKey('accent')) {
          return $dartnative_live_activities_18.StockPreset(
            brandLogo: brandLogo,
            androidStyle: androidStyle,
            chip: chip,
          );
        }
        if (named.containsKey('accent')) {
          final accent = D4.getRequiredNamedArg<$dartnative_1.Color>(
            named,
            'accent',
            'StockPreset',
          );
          return $dartnative_live_activities_18.StockPreset(
            brandLogo: brandLogo,
            androidStyle: androidStyle,
            chip: chip,
            accent: accent,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StockPreset>(
            target,
            'StockPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StockPreset>(
            target,
            'StockPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StockPreset>(
            target,
            'StockPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StockPreset>(
            target,
            'StockPreset',
          )
          .accent,
      'brandLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StockPreset>(
            target,
            'StockPreset',
          )
          .brandLogo,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StockPreset>(
            target,
            'StockPreset',
          )
          .androidStyle,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.StockPreset>(
            target,
            'StockPreset',
          )
          .chip,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.StockPreset>(
          target,
          'StockPreset',
        );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.StockPreset>(
          target,
          'StockPreset',
        );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.StockPreset>(
          target,
          'StockPreset',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const StockPreset({Color accent = _up, LiveImage? brandLogo, LiveAndroidStyle androidStyle = LiveAndroidStyle.card, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'brandLogo': 'LiveImage? get brandLogo',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
      'chip': 'LiveChip? get chip',
    },
  );
}

// =============================================================================
// FlightPathPreset Bridge
// =============================================================================

BridgedClass _createFlightPathPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_18.FlightPathPreset,
    name: 'FlightPathPreset',
    isAssignable: (v) => v is $dartnative_live_activities_18.FlightPathPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF30D158),
        );
        final carrier = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'carrier',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_18.FlightPathPreset(
          androidStyle: androidStyle,
          accent: accent,
          carrier: carrier,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
            target,
            'FlightPathPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
            target,
            'FlightPathPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
            target,
            'FlightPathPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
            target,
            'FlightPathPreset',
          )
          .accent,
      'carrier': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
            target,
            'FlightPathPreset',
          )
          .carrier,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
            target,
            'FlightPathPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
            target,
            'FlightPathPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
              target,
              'FlightPathPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
              target,
              'FlightPathPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.FlightPathPreset>(
              target,
              'FlightPathPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const FlightPathPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFF30D158), LiveImage? carrier, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'carrier': 'LiveImage? get carrier',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// OrbitPreset Bridge
// =============================================================================

BridgedClass _createOrbitPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_18.OrbitPreset,
    name: 'OrbitPreset',
    isAssignable: (v) => v is $dartnative_live_activities_18.OrbitPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF64D2FF),
        );
        final sweep = D4.getNamedArgWithDefault<double>(named, 'sweep', 180);
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_18.OrbitPreset(
          androidStyle: androidStyle,
          accent: accent,
          sweep: sweep,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.OrbitPreset>(
            target,
            'OrbitPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.OrbitPreset>(
            target,
            'OrbitPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.OrbitPreset>(
            target,
            'OrbitPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.OrbitPreset>(
            target,
            'OrbitPreset',
          )
          .accent,
      'sweep': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.OrbitPreset>(
            target,
            'OrbitPreset',
          )
          .sweep,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.OrbitPreset>(
            target,
            'OrbitPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.OrbitPreset>(
            target,
            'OrbitPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.OrbitPreset>(
          target,
          'OrbitPreset',
        );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.OrbitPreset>(
          target,
          'OrbitPreset',
        );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_18.OrbitPreset>(
          target,
          'OrbitPreset',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const OrbitPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFF64D2FF), double sweep = 180, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'sweep': 'double get sweep',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// ChargePreset Bridge
// =============================================================================

BridgedClass _createChargePresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_18.ChargePreset,
    name: 'ChargePreset',
    isAssignable: (v) => v is $dartnative_live_activities_18.ChargePreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF30D158),
        );
        final glow = D4.getNamedArgWithDefault<double>(named, 'glow', 10);
        final compactIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'compactIcon',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_18.ChargePreset(
          androidStyle: androidStyle,
          accent: accent,
          glow: glow,
          compactIcon: compactIcon,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.ChargePreset>(
            target,
            'ChargePreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.ChargePreset>(
            target,
            'ChargePreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.ChargePreset>(
            target,
            'ChargePreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.ChargePreset>(
            target,
            'ChargePreset',
          )
          .accent,
      'glow': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.ChargePreset>(
            target,
            'ChargePreset',
          )
          .glow,
      'compactIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.ChargePreset>(
            target,
            'ChargePreset',
          )
          .compactIcon,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.ChargePreset>(
            target,
            'ChargePreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.ChargePreset>(
            target,
            'ChargePreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.ChargePreset>(
              target,
              'ChargePreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.ChargePreset>(
              target,
              'ChargePreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.ChargePreset>(
              target,
              'ChargePreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const ChargePreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFF30D158), double glow = 10, LiveVisual? compactIcon, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'glow': 'double get glow',
      'compactIcon': 'LiveVisual? get compactIcon',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// FareSplitPreset Bridge
// =============================================================================

BridgedClass _createFareSplitPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_18.FareSplitPreset,
    name: 'FareSplitPreset',
    isAssignable: (v) => v is $dartnative_live_activities_18.FareSplitPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF30D158),
        );
        final brand = D4.getNamedArgWithDefault<String>(named, 'brand', 'Run');
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_18.FareSplitPreset(
          accent: accent,
          brand: brand,
          androidStyle: androidStyle,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
            target,
            'FareSplitPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
            target,
            'FareSplitPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
            target,
            'FareSplitPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
            target,
            'FareSplitPreset',
          )
          .accent,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
            target,
            'FareSplitPreset',
          )
          .brand,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
            target,
            'FareSplitPreset',
          )
          .androidStyle,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
            target,
            'FareSplitPreset',
          )
          .chip,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
              target,
              'FareSplitPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
              target,
              'FareSplitPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_18.FareSplitPreset>(
              target,
              'FareSplitPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const FareSplitPreset({Color accent = const Color(0xFF30D158), String brand = \'Run\', LiveAndroidStyle androidStyle = LiveAndroidStyle.card, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'brand': 'String get brand',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
      'chip': 'LiveChip? get chip',
    },
  );
}

// =============================================================================
// RideArrivalPreset Bridge
// =============================================================================

BridgedClass _createRideArrivalPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_19.RideArrivalPreset,
    name: 'RideArrivalPreset',
    isAssignable: (v) => v is $dartnative_live_activities_19.RideArrivalPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF6FA8FF),
        );
        final background = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'background',
          const $dartnative_1.Color(0xFF000000),
        );
        final brand = D4.getNamedArgWithDefault<String>(named, 'brand', 'Run');
        final carImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'carImage',
            );
        final compactIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'compactIcon',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_19.RideArrivalPreset(
          androidStyle: androidStyle,
          accent: accent,
          background: background,
          brand: brand,
          carImage: carImage,
          compactIcon: compactIcon,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .accent,
      'background': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .background,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .brand,
      'carImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .carImage,
      'compactIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .compactIcon,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
            target,
            'RideArrivalPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
              target,
              'RideArrivalPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
              target,
              'RideArrivalPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RideArrivalPreset>(
              target,
              'RideArrivalPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const RideArrivalPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFF6FA8FF), Color background = const Color(0xFF000000), String brand = \'Run\', LiveImage? carImage, LiveVisual? compactIcon, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'background': 'Color get background',
      'brand': 'String get brand',
      'carImage': 'LiveImage? get carImage',
      'compactIcon': 'LiveVisual? get compactIcon',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// RideTripPreset Bridge
// =============================================================================

BridgedClass _createRideTripPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_19.RideTripPreset,
    name: 'RideTripPreset',
    isAssignable: (v) => v is $dartnative_live_activities_19.RideTripPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFFB794FF),
        );
        final background = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'background',
          const $dartnative_1.Color(0xFF000000),
        );
        final brand = D4.getNamedArgWithDefault<String>(named, 'brand', 'Run');
        final driverInitials = D4.getNamedArgWithDefault<String>(
          named,
          'driverInitials',
          'A',
        );
        final driverPhoto = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'driverPhoto',
            );
        final trackerImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'trackerImage',
            );
        final compactIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'compactIcon',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_19.RideTripPreset(
          androidStyle: androidStyle,
          accent: accent,
          background: background,
          brand: brand,
          driverInitials: driverInitials,
          driverPhoto: driverPhoto,
          trackerImage: trackerImage,
          compactIcon: compactIcon,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .accent,
      'background': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .background,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .brand,
      'driverInitials': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .driverInitials,
      'driverPhoto': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .driverPhoto,
      'trackerImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .trackerImage,
      'compactIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .compactIcon,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
            target,
            'RideTripPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
              target,
              'RideTripPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
              target,
              'RideTripPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RideTripPreset>(
              target,
              'RideTripPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const RideTripPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFFB794FF), Color background = const Color(0xFF000000), String brand = \'Run\', String driverInitials = \'A\', LiveImage? driverPhoto, LiveImage? trackerImage, LiveVisual? compactIcon, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'background': 'Color get background',
      'brand': 'String get brand',
      'driverInitials': 'String get driverInitials',
      'driverPhoto': 'LiveImage? get driverPhoto',
      'trackerImage': 'LiveImage? get trackerImage',
      'compactIcon': 'LiveVisual? get compactIcon',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// DeliveryOrderPreset Bridge
// =============================================================================

BridgedClass _createDeliveryOrderPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_19.DeliveryOrderPreset,
    name: 'DeliveryOrderPreset',
    isAssignable: (v) =>
        v is $dartnative_live_activities_19.DeliveryOrderPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFFFF8A1F),
        );
        final brand = D4.getNamedArgWithDefault<String>(named, 'brand', 'Run');
        final compactIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'compactIcon',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_19.DeliveryOrderPreset(
          androidStyle: androidStyle,
          accent: accent,
          brand: brand,
          compactIcon: compactIcon,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
            target,
            'DeliveryOrderPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
            target,
            'DeliveryOrderPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
            target,
            'DeliveryOrderPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
            target,
            'DeliveryOrderPreset',
          )
          .accent,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
            target,
            'DeliveryOrderPreset',
          )
          .brand,
      'compactIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
            target,
            'DeliveryOrderPreset',
          )
          .compactIcon,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
            target,
            'DeliveryOrderPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
            target,
            'DeliveryOrderPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
              target,
              'DeliveryOrderPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
              target,
              'DeliveryOrderPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.DeliveryOrderPreset>(
              target,
              'DeliveryOrderPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const DeliveryOrderPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFFFF8A1F), String brand = \'Run\', LiveVisual? compactIcon, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'brand': 'String get brand',
      'compactIcon': 'LiveVisual? get compactIcon',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// RidePinPreset Bridge
// =============================================================================

BridgedClass _createRidePinPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_19.RidePinPreset,
    name: 'RidePinPreset',
    isAssignable: (v) => v is $dartnative_live_activities_19.RidePinPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF3B6CFF),
        );
        final brand = D4.getNamedArgWithDefault<String>(named, 'brand', 'Run');
        final driverInitials = D4.getNamedArgWithDefault<String>(
          named,
          'driverInitials',
          'M',
        );
        final driverPhoto = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'driverPhoto',
            );
        final trackerImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'trackerImage',
            );
        final compactIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'compactIcon',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_19.RidePinPreset(
          androidStyle: androidStyle,
          accent: accent,
          brand: brand,
          driverInitials: driverInitials,
          driverPhoto: driverPhoto,
          trackerImage: trackerImage,
          compactIcon: compactIcon,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .accent,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .brand,
      'driverInitials': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .driverInitials,
      'driverPhoto': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .driverPhoto,
      'trackerImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .trackerImage,
      'compactIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .compactIcon,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
            target,
            'RidePinPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
              target,
              'RidePinPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
              target,
              'RidePinPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RidePinPreset>(
              target,
              'RidePinPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const RidePinPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFF3B6CFF), String brand = \'Run\', String driverInitials = \'M\', LiveImage? driverPhoto, LiveImage? trackerImage, LiveVisual? compactIcon, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'brand': 'String get brand',
      'driverInitials': 'String get driverInitials',
      'driverPhoto': 'LiveImage? get driverPhoto',
      'trackerImage': 'LiveImage? get trackerImage',
      'compactIcon': 'LiveVisual? get compactIcon',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// RideStopPreset Bridge
// =============================================================================

BridgedClass _createRideStopPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_19.RideStopPreset,
    name: 'RideStopPreset',
    isAssignable: (v) => v is $dartnative_live_activities_19.RideStopPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFFE6E6EA),
        );
        final brand = D4.getNamedArgWithDefault<String>(named, 'brand', 'Run');
        final carImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'carImage',
            );
        final trackerImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'trackerImage',
            );
        final compactIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'compactIcon',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        if (!named.containsKey('stopAt')) {
          return $dartnative_live_activities_19.RideStopPreset(
            androidStyle: androidStyle,
            accent: accent,
            brand: brand,
            carImage: carImage,
            trackerImage: trackerImage,
            compactIcon: compactIcon,
            chip: chip,
          );
        }
        if (named.containsKey('stopAt')) {
          final stopAt = D4.getRequiredNamedArg<double>(
            named,
            'stopAt',
            'RideStopPreset',
          );
          return $dartnative_live_activities_19.RideStopPreset(
            androidStyle: androidStyle,
            accent: accent,
            brand: brand,
            carImage: carImage,
            trackerImage: trackerImage,
            compactIcon: compactIcon,
            chip: chip,
            stopAt: stopAt,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .accent,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .brand,
      'stopAt': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .stopAt,
      'carImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .carImage,
      'trackerImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .trackerImage,
      'compactIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .compactIcon,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
            target,
            'RideStopPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
              target,
              'RideStopPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
              target,
              'RideStopPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_19.RideStopPreset>(
              target,
              'RideStopPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const RideStopPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFFE6E6EA), String brand = \'Run\', double stopAt = .82, LiveImage? carImage, LiveImage? trackerImage, LiveVisual? compactIcon, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'brand': 'String get brand',
      'stopAt': 'double get stopAt',
      'carImage': 'LiveImage? get carImage',
      'trackerImage': 'LiveImage? get trackerImage',
      'compactIcon': 'LiveVisual? get compactIcon',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// RideDestinationPreset Bridge
// =============================================================================

BridgedClass _createRideDestinationPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_19.RideDestinationPreset,
    name: 'RideDestinationPreset',
    isAssignable: (v) =>
        v is $dartnative_live_activities_19.RideDestinationPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFFFFFFFF),
        );
        final brand = D4.getNamedArgWithDefault<String>(named, 'brand', 'Run');
        final trackerImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'trackerImage',
            );
        final compactIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'compactIcon',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_19.RideDestinationPreset(
          androidStyle: androidStyle,
          accent: accent,
          brand: brand,
          trackerImage: trackerImage,
          compactIcon: compactIcon,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideDestinationPreset>(
            target,
            'RideDestinationPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideDestinationPreset>(
            target,
            'RideDestinationPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideDestinationPreset>(
            target,
            'RideDestinationPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideDestinationPreset>(
            target,
            'RideDestinationPreset',
          )
          .accent,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideDestinationPreset>(
            target,
            'RideDestinationPreset',
          )
          .brand,
      'trackerImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideDestinationPreset>(
            target,
            'RideDestinationPreset',
          )
          .trackerImage,
      'compactIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideDestinationPreset>(
            target,
            'RideDestinationPreset',
          )
          .compactIcon,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideDestinationPreset>(
            target,
            'RideDestinationPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.RideDestinationPreset>(
            target,
            'RideDestinationPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_19.RideDestinationPreset
            >(target, 'RideDestinationPreset');
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_19.RideDestinationPreset
            >(target, 'RideDestinationPreset');
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_19.RideDestinationPreset
            >(target, 'RideDestinationPreset');
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const RideDestinationPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFFFFFFFF), String brand = \'Run\', LiveImage? trackerImage, LiveVisual? compactIcon, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'brand': 'String get brand',
      'trackerImage': 'LiveImage? get trackerImage',
      'compactIcon': 'LiveVisual? get compactIcon',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// TrainPreset Bridge
// =============================================================================

BridgedClass _createTrainPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_19.TrainPreset,
    name: 'TrainPreset',
    isAssignable: (v) => v is $dartnative_live_activities_19.TrainPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final androidStyle = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveAndroidStyle
            >(
              named,
              'androidStyle',
              $dartnative_live_activities_9.LiveAndroidStyle.card,
            );
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFFA7F060),
        );
        final brand = D4.getNamedArgWithDefault<String>(
          named,
          'brand',
          'Lima Transit',
        );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const ['El Ángel', 'Miguel Grau', 'Gamarra'];
        final trainImage = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'trainImage',
            );
        final compactIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'compactIcon',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_19.TrainPreset(
          androidStyle: androidStyle,
          accent: accent,
          brand: brand,
          stages: stages,
          trainImage: trainImage,
          compactIcon: compactIcon,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .accent,
      'brand': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .brand,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .stages,
      'trainImage': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .trainImage,
      'compactIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .compactIcon,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .chip,
      'androidStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_19.TrainPreset>(
            target,
            'TrainPreset',
          )
          .androidStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_19.TrainPreset>(
          target,
          'TrainPreset',
        );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_19.TrainPreset>(
          target,
          'TrainPreset',
        );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_19.TrainPreset>(
          target,
          'TrainPreset',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const TrainPreset({LiveAndroidStyle androidStyle = LiveAndroidStyle.card, Color accent = const Color(0xFFA7F060), String brand = \'Lima Transit\', List<String> stages = const [\'El Ángel\', \'Miguel Grau\', \'Gamarra\'], LiveImage? trainImage, LiveVisual? compactIcon, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'brand': 'String get brand',
      'stages': 'List<String> get stages',
      'trainImage': 'LiveImage? get trainImage',
      'compactIcon': 'LiveVisual? get compactIcon',
      'chip': 'LiveChip? get chip',
      'androidStyle': 'LiveAndroidStyle get androidStyle',
    },
  );
}

// =============================================================================
// PresetSample Bridge
// =============================================================================

BridgedClass _createPresetSampleBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_20.PresetSample,
    name: 'PresetSample',
    isAssignable: (v) => v is $dartnative_live_activities_20.PresetSample,
    constructors: {
      '': (visitor, positional, named) {
        final title = D4.getRequiredNamedArg<String>(
          named,
          'title',
          'PresetSample',
        );
        final subtitle = D4.getRequiredNamedArg<String>(
          named,
          'subtitle',
          'PresetSample',
        );
        final name = D4.getRequiredNamedArg<String>(
          named,
          'name',
          'PresetSample',
        );
        final highlight = D4.getNamedArgWithDefault<String>(
          named,
          'highlight',
          '',
        );
        final minutes = D4.getNamedArgWithDefault<double>(named, 'minutes', 5);
        final progress = D4.getNamedArgWithDefault<double>(
          named,
          'progress',
          0.4,
        );
        return $dartnative_live_activities_20.PresetSample(
          title: title,
          subtitle: subtitle,
          name: name,
          highlight: highlight,
          minutes: minutes,
          progress: progress,
        );
      },
    },
    getters: {
      'title': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.PresetSample>(
            target,
            'PresetSample',
          )
          .title,
      'subtitle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.PresetSample>(
            target,
            'PresetSample',
          )
          .subtitle,
      'name': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.PresetSample>(
            target,
            'PresetSample',
          )
          .name,
      'highlight': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.PresetSample>(
            target,
            'PresetSample',
          )
          .highlight,
      'minutes': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.PresetSample>(
            target,
            'PresetSample',
          )
          .minutes,
      'progress': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.PresetSample>(
            target,
            'PresetSample',
          )
          .progress,
    },
    constructorSignatures: {
      '': 'const PresetSample({required String title, required String subtitle, required String name, String highlight = \'\', double minutes = 5, double progress = 0.4})',
    },
    getterSignatures: {
      'title': 'String get title',
      'subtitle': 'String get subtitle',
      'name': 'String get name',
      'highlight': 'String get highlight',
      'minutes': 'double get minutes',
      'progress': 'double get progress',
    },
  );
}

// =============================================================================
// LivePresetSpec Bridge
// =============================================================================

BridgedClass _createLivePresetSpecBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_20.LivePresetSpec,
    name: 'LivePresetSpec',
    isAssignable: (v) => v is $dartnative_live_activities_20.LivePresetSpec,
    constructors: {
      '': (visitor, positional, named) {
        final id = D4.getRequiredNamedArg<String>(
          named,
          'id',
          'LivePresetSpec',
        );
        final appName = D4.getRequiredNamedArg<String>(
          named,
          'appName',
          'LivePresetSpec',
        );
        final accent = D4.getRequiredNamedArg<$dartnative_1.Color>(
          named,
          'accent',
          'LivePresetSpec',
        );
        final icon = D4
            .getRequiredNamedArg<$dartnative_live_activities_6.LiveIcon>(
              named,
              'icon',
              'LivePresetSpec',
            );
        final sample = D4
            .getRequiredNamedArg<$dartnative_live_activities_20.PresetSample>(
              named,
              'sample',
              'LivePresetSpec',
            );
        final chip = D4
            .getRequiredNamedArg<$dartnative_live_activities_10.LiveChip>(
              named,
              'chip',
              'LivePresetSpec',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final avatarText = D4.getOptionalNamedArg<String?>(named, 'avatarText');
        final avatarPhoto = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'avatarPhoto',
            );
        final countdown = D4.getNamedArgWithDefault<bool>(
          named,
          'countdown',
          false,
        );
        final progress = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_20.PresetProgress
            >(
              named,
              'progress',
              $dartnative_live_activities_20.PresetProgress.none,
            );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const <String>[];
        final showPoints = D4.getNamedArgWithDefault<bool>(
          named,
          'showPoints',
          false,
        );
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final startIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'startIcon',
            );
        final endIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'endIcon',
            );
        final buttons = named.containsKey('buttons') && named['buttons'] != null
            ? D4.coerceList<$dartnative_live_activities_1.LiveButton>(
                named['buttons'],
                'buttons',
              )
            : const <$dartnative_live_activities_1.LiveButton>[];
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final androidPromotable = D4.getNamedArgWithDefault<bool>(
          named,
          'androidPromotable',
          true,
        );
        return $dartnative_live_activities_20.LivePresetSpec(
          id: id,
          appName: appName,
          accent: accent,
          icon: icon,
          sample: sample,
          chip: chip,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          avatarText: avatarText,
          avatarPhoto: avatarPhoto,
          countdown: countdown,
          progress: progress,
          stages: stages,
          showPoints: showPoints,
          showLabels: showLabels,
          progressStyle: progressStyle,
          tracker: tracker,
          startIcon: startIcon,
          endIcon: endIcon,
          buttons: buttons,
          lockBackground: lockBackground,
          androidPromotable: androidPromotable,
        );
      },
    },
    getters: {
      'id': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .id,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .appName,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .icon,
      'sample': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .sample,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .chip,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .androidSmallIcon,
      'avatarText': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .avatarText,
      'avatarPhoto': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .avatarPhoto,
      'countdown': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .countdown,
      'progress': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .progress,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .stages,
      'showPoints': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .showPoints,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .showLabels,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .progressStyle,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .tracker,
      'startIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .startIcon,
      'endIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .endIcon,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .buttons,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .lockBackground,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePresetSpec>(
            target,
            'LivePresetSpec',
          )
          .androidPromotable,
    },
    constructorSignatures: {
      '': 'LivePresetSpec({required String id, required String appName, required Color accent, required LiveIcon icon, required PresetSample sample, required LiveChip chip, LiveVisual? appLogo, LiveVisual? androidSmallIcon, String? avatarText, LiveImage? avatarPhoto, bool countdown = false, PresetProgress progress = PresetProgress.none, List<String> stages = const [], bool showPoints = false, bool showLabels = true, LiveProgressStyle? progressStyle, LiveTrackerSource? tracker, LiveVisual? startIcon, LiveVisual? endIcon, List<LiveButton> buttons = const [], LiveBackground lockBackground = LiveBackground.system, bool androidPromotable = true})',
    },
    getterSignatures: {
      'id': 'String get id',
      'appName': 'String get appName',
      'accent': 'Color get accent',
      'icon': 'LiveIcon get icon',
      'sample': 'PresetSample get sample',
      'chip': 'LiveChip get chip',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'avatarText': 'String? get avatarText',
      'avatarPhoto': 'LiveImage? get avatarPhoto',
      'countdown': 'bool get countdown',
      'progress': 'PresetProgress get progress',
      'stages': 'List<String> get stages',
      'showPoints': 'bool get showPoints',
      'showLabels': 'bool get showLabels',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
      'tracker': 'LiveTrackerSource? get tracker',
      'startIcon': 'LiveVisual? get startIcon',
      'endIcon': 'LiveVisual? get endIcon',
      'buttons': 'List<LiveButton> get buttons',
      'lockBackground': 'LiveBackground get lockBackground',
      'androidPromotable': 'bool get androidPromotable',
    },
  );
}

// =============================================================================
// LivePreset Bridge
// =============================================================================

BridgedClass _createLivePresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_20.LivePreset,
    name: 'LivePreset',
    isAssignable: (v) => v is $dartnative_live_activities_20.LivePreset,
    isAbstract: true,
    constructors: {},
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePreset>(
            target,
            'LivePreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePreset>(
            target,
            'LivePreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_20.LivePreset>(
            target,
            'LivePreset',
          )
          .androidPromotable,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_20.LivePreset>(
          target,
          'LivePreset',
        );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_20.LivePreset>(
          target,
          'LivePreset',
        );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_20.LivePreset>(
          target,
          'LivePreset',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
    },
  );
}

// =============================================================================
// TripPreset Bridge
// =============================================================================

BridgedClass _createTripPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.TripPreset,
    name: 'TripPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.TripPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF1F6FEB),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const ['Assigned', 'On the way', 'Arrived'];
        final showPoints = D4.getNamedArgWithDefault<bool>(
          named,
          'showPoints',
          true,
        );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final endIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'endIcon',
            );
        final avatarText = D4.getNamedArgWithDefault<String>(
          named,
          'avatarText',
          'CM',
        );
        final avatarPhoto = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'avatarPhoto',
            );
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final showTracker = D4.getNamedArgWithDefault<bool>(
          named,
          'showTracker',
          true,
        );
        final showEndIcon = D4.getNamedArgWithDefault<bool>(
          named,
          'showEndIcon',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.TripPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          stages: stages,
          showPoints: showPoints,
          tracker: tracker,
          endIcon: endIcon,
          avatarText: avatarText,
          avatarPhoto: avatarPhoto,
          showLabels: showLabels,
          showTracker: showTracker,
          showEndIcon: showEndIcon,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .chip,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .stages,
      'showPoints': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .showPoints,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .tracker,
      'endIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .endIcon,
      'avatarText': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .avatarText,
      'avatarPhoto': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .avatarPhoto,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .showLabels,
      'showTracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .showTracker,
      'showEndIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .showEndIcon,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TripPreset>(
            target,
            'TripPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_21.TripPreset>(
          target,
          'TripPreset',
        );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_21.TripPreset>(
          target,
          'TripPreset',
        );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_21.TripPreset>(
          target,
          'TripPreset',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const TripPreset({Color accent = const Color(0xFF1F6FEB), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, List<String> stages = const [\'Assigned\', \'On the way\', \'Arrived\'], bool showPoints = true, LiveTrackerSource? tracker, LiveVisual? endIcon, String avatarText = \'CM\', LiveImage? avatarPhoto, bool showLabels = true, bool showTracker = true, bool showEndIcon = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'stages': 'List<String> get stages',
      'showPoints': 'bool get showPoints',
      'tracker': 'LiveTrackerSource? get tracker',
      'endIcon': 'LiveVisual? get endIcon',
      'avatarText': 'String get avatarText',
      'avatarPhoto': 'LiveImage? get avatarPhoto',
      'showLabels': 'bool get showLabels',
      'showTracker': 'bool get showTracker',
      'showEndIcon': 'bool get showEndIcon',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// DeliveryPreset Bridge
// =============================================================================

BridgedClass _createDeliveryPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.DeliveryPreset,
    name: 'DeliveryPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.DeliveryPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFFE4572E),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const ['Confirmed', 'Preparing', 'On the way', 'Delivered'];
        final showPoints = D4.getNamedArgWithDefault<bool>(
          named,
          'showPoints',
          true,
        );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final endIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'endIcon',
            );
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final showTracker = D4.getNamedArgWithDefault<bool>(
          named,
          'showTracker',
          true,
        );
        final showEndIcon = D4.getNamedArgWithDefault<bool>(
          named,
          'showEndIcon',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.DeliveryPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          stages: stages,
          showPoints: showPoints,
          tracker: tracker,
          endIcon: endIcon,
          showLabels: showLabels,
          showTracker: showTracker,
          showEndIcon: showEndIcon,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .chip,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .stages,
      'showPoints': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .showPoints,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .tracker,
      'endIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .endIcon,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .showLabels,
      'showTracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .showTracker,
      'showEndIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .showEndIcon,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
            target,
            'DeliveryPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
              target,
              'DeliveryPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
              target,
              'DeliveryPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.DeliveryPreset>(
              target,
              'DeliveryPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const DeliveryPreset({Color accent = const Color(0xFFE4572E), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, List<String> stages = const [\'Confirmed\', \'Preparing\', \'On the way\', \'Delivered\'], bool showPoints = true, LiveTrackerSource? tracker, LiveVisual? endIcon, bool showLabels = true, bool showTracker = true, bool showEndIcon = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'stages': 'List<String> get stages',
      'showPoints': 'bool get showPoints',
      'tracker': 'LiveTrackerSource? get tracker',
      'endIcon': 'LiveVisual? get endIcon',
      'showLabels': 'bool get showLabels',
      'showTracker': 'bool get showTracker',
      'showEndIcon': 'bool get showEndIcon',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// CourierPreset Bridge
// =============================================================================

BridgedClass _createCourierPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.CourierPreset,
    name: 'CourierPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.CourierPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF6D4C41),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const ['Warehouse', 'In transit', 'Nearby', 'Delivered'];
        final showPoints = D4.getNamedArgWithDefault<bool>(
          named,
          'showPoints',
          true,
        );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final endIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'endIcon',
            );
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final showTracker = D4.getNamedArgWithDefault<bool>(
          named,
          'showTracker',
          true,
        );
        final showEndIcon = D4.getNamedArgWithDefault<bool>(
          named,
          'showEndIcon',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.CourierPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          stages: stages,
          showPoints: showPoints,
          tracker: tracker,
          endIcon: endIcon,
          showLabels: showLabels,
          showTracker: showTracker,
          showEndIcon: showEndIcon,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .chip,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .stages,
      'showPoints': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .showPoints,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .tracker,
      'endIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .endIcon,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .showLabels,
      'showTracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .showTracker,
      'showEndIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .showEndIcon,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CourierPreset>(
            target,
            'CourierPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.CourierPreset>(
              target,
              'CourierPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.CourierPreset>(
              target,
              'CourierPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.CourierPreset>(
              target,
              'CourierPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const CourierPreset({Color accent = const Color(0xFF6D4C41), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, List<String> stages = const [\'Warehouse\', \'In transit\', \'Nearby\', \'Delivered\'], bool showPoints = true, LiveTrackerSource? tracker, LiveVisual? endIcon, bool showLabels = true, bool showTracker = true, bool showEndIcon = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'stages': 'List<String> get stages',
      'showPoints': 'bool get showPoints',
      'tracker': 'LiveTrackerSource? get tracker',
      'endIcon': 'LiveVisual? get endIcon',
      'showLabels': 'bool get showLabels',
      'showTracker': 'bool get showTracker',
      'showEndIcon': 'bool get showEndIcon',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// PickupPreset Bridge
// =============================================================================

BridgedClass _createPickupPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.PickupPreset,
    name: 'PickupPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.PickupPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF8D5B3A),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const ['Received', 'Preparing', 'Ready'];
        final showPoints = D4.getNamedArgWithDefault<bool>(
          named,
          'showPoints',
          true,
        );
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.PickupPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          stages: stages,
          showPoints: showPoints,
          showLabels: showLabels,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .chip,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .stages,
      'showPoints': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .showPoints,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .showLabels,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.PickupPreset>(
            target,
            'PickupPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.PickupPreset>(
              target,
              'PickupPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.PickupPreset>(
              target,
              'PickupPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.PickupPreset>(
              target,
              'PickupPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const PickupPreset({Color accent = const Color(0xFF8D5B3A), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, List<String> stages = const [\'Received\', \'Preparing\', \'Ready\'], bool showPoints = true, bool showLabels = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'stages': 'List<String> get stages',
      'showPoints': 'bool get showPoints',
      'showLabels': 'bool get showLabels',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// QueuePreset Bridge
// =============================================================================

BridgedClass _createQueuePresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.QueuePreset,
    name: 'QueuePreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.QueuePreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF00897B),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final showTracker = D4.getNamedArgWithDefault<bool>(
          named,
          'showTracker',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.QueuePreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          tracker: tracker,
          showTracker: showTracker,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .chip,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .tracker,
      'showTracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .showTracker,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.QueuePreset>(
            target,
            'QueuePreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_21.QueuePreset>(
          target,
          'QueuePreset',
        );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_21.QueuePreset>(
          target,
          'QueuePreset',
        );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_21.QueuePreset>(
          target,
          'QueuePreset',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const QueuePreset({Color accent = const Color(0xFF00897B), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, LiveTrackerSource? tracker, bool showTracker = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'tracker': 'LiveTrackerSource? get tracker',
      'showTracker': 'bool get showTracker',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// FlightPreset Bridge
// =============================================================================

BridgedClass _createFlightPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.FlightPreset,
    name: 'FlightPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.FlightPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF2D5BD7),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const ['Check-in', 'Boarding', 'Takeoff'];
        final showPoints = D4.getNamedArgWithDefault<bool>(
          named,
          'showPoints',
          true,
        );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final showTracker = D4.getNamedArgWithDefault<bool>(
          named,
          'showTracker',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.FlightPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          stages: stages,
          showPoints: showPoints,
          tracker: tracker,
          showLabels: showLabels,
          showTracker: showTracker,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .chip,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .stages,
      'showPoints': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .showPoints,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .tracker,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .showLabels,
      'showTracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .showTracker,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.FlightPreset>(
            target,
            'FlightPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.FlightPreset>(
              target,
              'FlightPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.FlightPreset>(
              target,
              'FlightPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.FlightPreset>(
              target,
              'FlightPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const FlightPreset({Color accent = const Color(0xFF2D5BD7), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, List<String> stages = const [\'Check-in\', \'Boarding\', \'Takeoff\'], bool showPoints = true, LiveTrackerSource? tracker, bool showLabels = true, bool showTracker = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'stages': 'List<String> get stages',
      'showPoints': 'bool get showPoints',
      'tracker': 'LiveTrackerSource? get tracker',
      'showLabels': 'bool get showLabels',
      'showTracker': 'bool get showTracker',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// ParkingPreset Bridge
// =============================================================================

BridgedClass _createParkingPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.ParkingPreset,
    name: 'ParkingPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.ParkingPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF0277BD),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.ParkingPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .chip,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
            target,
            'ParkingPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
              target,
              'ParkingPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
              target,
              'ParkingPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.ParkingPreset>(
              target,
              'ParkingPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const ParkingPreset({Color accent = const Color(0xFF0277BD), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// EvChargingPreset Bridge
// =============================================================================

BridgedClass _createEvChargingPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.EvChargingPreset,
    name: 'EvChargingPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.EvChargingPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF2E7D32),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final showTracker = D4.getNamedArgWithDefault<bool>(
          named,
          'showTracker',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.EvChargingPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          tracker: tracker,
          showTracker: showTracker,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .chip,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .tracker,
      'showTracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .showTracker,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
            target,
            'EvChargingPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
              target,
              'EvChargingPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
              target,
              'EvChargingPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.EvChargingPreset>(
              target,
              'EvChargingPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const EvChargingPreset({Color accent = const Color(0xFF2E7D32), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, LiveTrackerSource? tracker, bool showTracker = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'tracker': 'LiveTrackerSource? get tracker',
      'showTracker': 'bool get showTracker',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// WorkoutPreset Bridge
// =============================================================================

BridgedClass _createWorkoutPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.WorkoutPreset,
    name: 'WorkoutPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.WorkoutPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFFD81B60),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const ['1', '2', '3', '4'];
        final showPoints = D4.getNamedArgWithDefault<bool>(
          named,
          'showPoints',
          false,
        );
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.WorkoutPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          stages: stages,
          showPoints: showPoints,
          showLabels: showLabels,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .chip,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .stages,
      'showPoints': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .showPoints,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .showLabels,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
            target,
            'WorkoutPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
              target,
              'WorkoutPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
              target,
              'WorkoutPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.WorkoutPreset>(
              target,
              'WorkoutPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const WorkoutPreset({Color accent = const Color(0xFFD81B60), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, List<String> stages = const [\'1\', \'2\', \'3\', \'4\'], bool showPoints = false, bool showLabels = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'stages': 'List<String> get stages',
      'showPoints': 'bool get showPoints',
      'showLabels': 'bool get showLabels',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// CookingTimerPreset Bridge
// =============================================================================

BridgedClass _createCookingTimerPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.CookingTimerPreset,
    name: 'CookingTimerPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.CookingTimerPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFFF57C00),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.CookingTimerPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .chip,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
            target,
            'CookingTimerPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
              target,
              'CookingTimerPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
              target,
              'CookingTimerPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.CookingTimerPreset>(
              target,
              'CookingTimerPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const CookingTimerPreset({Color accent = const Color(0xFFF57C00), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// UploadPreset Bridge
// =============================================================================

BridgedClass _createUploadPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.UploadPreset,
    name: 'UploadPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.UploadPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF5E35B1),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.UploadPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .chip,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.UploadPreset>(
            target,
            'UploadPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.UploadPreset>(
              target,
              'UploadPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.UploadPreset>(
              target,
              'UploadPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.UploadPreset>(
              target,
              'UploadPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const UploadPreset({Color accent = const Color(0xFF5E35B1), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// TechnicianPreset Bridge
// =============================================================================

BridgedClass _createTechnicianPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.TechnicianPreset,
    name: 'TechnicianPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.TechnicianPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF00838F),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const ['Assigned', 'On the way', 'Working', 'Ready'];
        final showPoints = D4.getNamedArgWithDefault<bool>(
          named,
          'showPoints',
          true,
        );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final avatarText = D4.getNamedArgWithDefault<String>(
          named,
          'avatarText',
          'JR',
        );
        final avatarPhoto = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveImage?>(
              named,
              'avatarPhoto',
            );
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final showTracker = D4.getNamedArgWithDefault<bool>(
          named,
          'showTracker',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.TechnicianPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          stages: stages,
          showPoints: showPoints,
          tracker: tracker,
          avatarText: avatarText,
          avatarPhoto: avatarPhoto,
          showLabels: showLabels,
          showTracker: showTracker,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .chip,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .stages,
      'showPoints': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .showPoints,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .tracker,
      'avatarText': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .avatarText,
      'avatarPhoto': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .avatarPhoto,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .showLabels,
      'showTracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .showTracker,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
            target,
            'TechnicianPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
              target,
              'TechnicianPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
              target,
              'TechnicianPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.TechnicianPreset>(
              target,
              'TechnicianPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const TechnicianPreset({Color accent = const Color(0xFF00838F), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, List<String> stages = const [\'Assigned\', \'On the way\', \'Working\', \'Ready\'], bool showPoints = true, LiveTrackerSource? tracker, String avatarText = \'JR\', LiveImage? avatarPhoto, bool showLabels = true, bool showTracker = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'stages': 'List<String> get stages',
      'showPoints': 'bool get showPoints',
      'tracker': 'LiveTrackerSource? get tracker',
      'avatarText': 'String get avatarText',
      'avatarPhoto': 'LiveImage? get avatarPhoto',
      'showLabels': 'bool get showLabels',
      'showTracker': 'bool get showTracker',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// TransitPreset Bridge
// =============================================================================

BridgedClass _createTransitPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.TransitPreset,
    name: 'TransitPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.TransitPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFFC62828),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final stages = named.containsKey('stages') && named['stages'] != null
            ? D4.coerceList<String>(named['stages'], 'stages')
            : const ['Boarded', '2', '3', '4', 'Exit'];
        final showPoints = D4.getNamedArgWithDefault<bool>(
          named,
          'showPoints',
          true,
        );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final endIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'endIcon',
            );
        final showLabels = D4.getNamedArgWithDefault<bool>(
          named,
          'showLabels',
          true,
        );
        final showTracker = D4.getNamedArgWithDefault<bool>(
          named,
          'showTracker',
          true,
        );
        final showEndIcon = D4.getNamedArgWithDefault<bool>(
          named,
          'showEndIcon',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.TransitPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          stages: stages,
          showPoints: showPoints,
          tracker: tracker,
          endIcon: endIcon,
          showLabels: showLabels,
          showTracker: showTracker,
          showEndIcon: showEndIcon,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .chip,
      'stages': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .stages,
      'showPoints': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .showPoints,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .tracker,
      'endIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .endIcon,
      'showLabels': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .showLabels,
      'showTracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .showTracker,
      'showEndIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .showEndIcon,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.TransitPreset>(
            target,
            'TransitPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.TransitPreset>(
              target,
              'TransitPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.TransitPreset>(
              target,
              'TransitPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.TransitPreset>(
              target,
              'TransitPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const TransitPreset({Color accent = const Color(0xFFC62828), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, List<String> stages = const [\'Boarded\', \'2\', \'3\', \'4\', \'Exit\'], bool showPoints = true, LiveTrackerSource? tracker, LiveVisual? endIcon, bool showLabels = true, bool showTracker = true, bool showEndIcon = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'stages': 'List<String> get stages',
      'showPoints': 'bool get showPoints',
      'tracker': 'LiveTrackerSource? get tracker',
      'endIcon': 'LiveVisual? get endIcon',
      'showLabels': 'bool get showLabels',
      'showTracker': 'bool get showTracker',
      'showEndIcon': 'bool get showEndIcon',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// WaitingRoomPreset Bridge
// =============================================================================

BridgedClass _createWaitingRoomPresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.WaitingRoomPreset,
    name: 'WaitingRoomPreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.WaitingRoomPreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF00796B),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        final tracker = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_6.LiveTrackerSource?
            >(named, 'tracker');
        final showTracker = D4.getNamedArgWithDefault<bool>(
          named,
          'showTracker',
          true,
        );
        final progressStyle = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_4.LiveProgressStyle?
            >(named, 'progressStyle');
        return $dartnative_live_activities_21.WaitingRoomPreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
          tracker: tracker,
          showTracker: showTracker,
          progressStyle: progressStyle,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .chip,
      'tracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .tracker,
      'showTracker': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .showTracker,
      'progressStyle': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
            target,
            'WaitingRoomPreset',
          )
          .progressStyle,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
              target,
              'WaitingRoomPreset',
            );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
              target,
              'WaitingRoomPreset',
            );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_21.WaitingRoomPreset>(
              target,
              'WaitingRoomPreset',
            );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const WaitingRoomPreset({Color accent = const Color(0xFF00796B), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip, LiveTrackerSource? tracker, bool showTracker = true, LiveProgressStyle? progressStyle})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
      'tracker': 'LiveTrackerSource? get tracker',
      'showTracker': 'bool get showTracker',
      'progressStyle': 'LiveProgressStyle? get progressStyle',
    },
  );
}

// =============================================================================
// ScorePreset Bridge
// =============================================================================

BridgedClass _createScorePresetBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_21.ScorePreset,
    name: 'ScorePreset',
    isAssignable: (v) => v is $dartnative_live_activities_21.ScorePreset,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final accent = D4.getNamedArgWithDefault<$dartnative_1.Color>(
          named,
          'accent',
          const $dartnative_1.Color(0xFF1B5E20),
        );
        final icon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveIcon?>(
              named,
              'icon',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final lockBackground = D4
            .getNamedArgWithDefault<
              $dartnative_live_activities_9.LiveBackground
            >(
              named,
              'lockBackground',
              $dartnative_live_activities_9.LiveBackground.system,
            );
        final buttons = D4
            .coerceListOrNull<$dartnative_live_activities_1.LiveButton>(
              named['buttons'],
              'buttons',
            );
        final chip = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveChip?>(
              named,
              'chip',
            );
        return $dartnative_live_activities_21.ScorePreset(
          accent: accent,
          icon: icon,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          lockBackground: lockBackground,
          buttons: buttons,
          chip: chip,
        );
      },
    },
    getters: {
      'spec': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .spec,
      'appName': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .appName,
      'androidPromotable': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .androidPromotable,
      'accent': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .accent,
      'icon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .icon,
      'appLogo': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .appLogo,
      'androidSmallIcon': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .androidSmallIcon,
      'lockBackground': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .lockBackground,
      'buttons': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .buttons,
      'chip': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_21.ScorePreset>(
            target,
            'ScorePreset',
          )
          .chip,
    },
    methods: {
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_21.ScorePreset>(
          target,
          'ScorePreset',
        );
        return (t as dynamic).build();
      },
      'sampleState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_21.ScorePreset>(
          target,
          'ScorePreset',
        );
        final now = D4.getOptionalNamedArg<DateTime?>(named, 'now');
        return t.sampleState(now: now);
      },
      'override': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_21.ScorePreset>(
          target,
          'ScorePreset',
        );
        final theme = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveTheme?>(
              named,
              'theme',
            );
        final appLogo = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'appLogo',
            );
        final androidSmallIcon = D4
            .getOptionalNamedArg<$dartnative_live_activities_6.LiveVisual?>(
              named,
              'androidSmallIcon',
            );
        final compactLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactLeading',
            );
        final compactTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'compactTrailing',
            );
        final minimal = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'minimal',
            );
        final expanded = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveExpanded?>(
              named,
              'expanded',
            );
        final expandedLeading = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedLeading',
            );
        final expandedCenter = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedCenter',
            );
        final expandedTrailing = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedTrailing',
            );
        final expandedBottom = D4
            .getOptionalNamedArg<$dartnative_live_activities_11.LiveNode?>(
              named,
              'expandedBottom',
            );
        final lockScreen = D4
            .getOptionalNamedArg<
              $dartnative_live_activities_10.LiveLockScreen?
            >(named, 'lockScreen');
        final android = D4
            .getOptionalNamedArg<$dartnative_live_activities_10.LiveAndroid?>(
              named,
              'android',
            );
        return t.override(
          theme: theme,
          appLogo: appLogo,
          androidSmallIcon: androidSmallIcon,
          compactLeading: compactLeading,
          compactTrailing: compactTrailing,
          minimal: minimal,
          expanded: expanded,
          expandedLeading: expandedLeading,
          expandedCenter: expandedCenter,
          expandedTrailing: expandedTrailing,
          expandedBottom: expandedBottom,
          lockScreen: lockScreen,
          android: android,
        );
      },
    },
    constructorSignatures: {
      '': 'const ScorePreset({Color accent = const Color(0xFF1B5E20), LiveIcon? icon, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveBackground lockBackground = LiveBackground.system, List<LiveButton>? buttons, LiveChip? chip})',
    },
    methodSignatures: {
      'build': 'LiveLayout build()',
      'sampleState': 'Map<String, Object?> sampleState({DateTime? now})',
      'override':
          'LiveLayout override({LiveTheme? theme, LiveVisual? appLogo, LiveVisual? androidSmallIcon, LiveNode? compactLeading, LiveNode? compactTrailing, LiveNode? minimal, LiveExpanded? expanded, LiveNode? expandedLeading, LiveNode? expandedCenter, LiveNode? expandedTrailing, LiveNode? expandedBottom, LiveLockScreen? lockScreen, LiveAndroid? android})',
    },
    getterSignatures: {
      'spec': 'LivePresetSpec get spec',
      'appName': 'String get appName',
      'androidPromotable': 'bool get androidPromotable',
      'accent': 'Color get accent',
      'icon': 'LiveIcon? get icon',
      'appLogo': 'LiveVisual? get appLogo',
      'androidSmallIcon': 'LiveVisual? get androidSmallIcon',
      'lockBackground': 'LiveBackground get lockBackground',
      'buttons': 'List<LiveButton>? get buttons',
      'chip': 'LiveChip? get chip',
    },
  );
}

// =============================================================================
// LiveImagePayload Bridge
// =============================================================================

BridgedClass _createLiveImagePayloadBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LiveImagePayload,
    name: 'LiveImagePayload',
    isAssignable: (v) => v is $dartnative_live_activities_17.LiveImagePayload,
    constructors: {
      '': (visitor, positional, named) {
        final id = D4.getRequiredNamedArg<String>(
          named,
          'id',
          'LiveImagePayload',
        );
        final bytes = D4.getRequiredNamedArg<Uint8List>(
          named,
          'bytes',
          'LiveImagePayload',
        );
        final maxWidth = D4.getRequiredNamedArg<int>(
          named,
          'maxWidth',
          'LiveImagePayload',
        );
        final maxHeight = D4.getRequiredNamedArg<int>(
          named,
          'maxHeight',
          'LiveImagePayload',
        );
        return $dartnative_live_activities_17.LiveImagePayload(
          id: id,
          bytes: bytes,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
      },
    },
    getters: {
      'id': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveImagePayload>(
            target,
            'LiveImagePayload',
          )
          .id,
      'bytes': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveImagePayload>(
            target,
            'LiveImagePayload',
          )
          .bytes,
      'maxWidth': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveImagePayload>(
            target,
            'LiveImagePayload',
          )
          .maxWidth,
      'maxHeight': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveImagePayload>(
            target,
            'LiveImagePayload',
          )
          .maxHeight,
    },
    methods: {
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_17.LiveImagePayload>(
              target,
              'LiveImagePayload',
            );
        return t.toMap();
      },
    },
    constructorSignatures: {
      '': 'const LiveImagePayload({required String id, required Uint8List bytes, required int maxWidth, required int maxHeight})',
    },
    methodSignatures: {
      'toMap': 'Map<String, Object?> toMap()',
    },
    getterSignatures: {
      'id': 'String get id',
      'bytes': 'Uint8List get bytes',
      'maxWidth': 'int get maxWidth',
      'maxHeight': 'int get maxHeight',
    },
  );
}

// =============================================================================
// LivePushToken Bridge
// =============================================================================

BridgedClass _createLivePushTokenBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LivePushToken,
    name: 'LivePushToken',
    isAssignable: (v) => v is $dartnative_live_activities_17.LivePushToken,
    constructors: {
      '': (visitor, positional, named) {
        final token = D4.getRequiredNamedArg<String>(
          named,
          'token',
          'LivePushToken',
        );
        final activityId = D4.getOptionalNamedArg<String?>(named, 'activityId');
        return $dartnative_live_activities_17.LivePushToken(
          token: token,
          activityId: activityId,
        );
      },
    },
    getters: {
      'token': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LivePushToken>(
            target,
            'LivePushToken',
          )
          .token,
      'activityId': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LivePushToken>(
            target,
            'LivePushToken',
          )
          .activityId,
      'isPushToStart': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LivePushToken>(
            target,
            'LivePushToken',
          )
          .isPushToStart,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_17.LivePushToken>(
              target,
              'LivePushToken',
            );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const LivePushToken({required String token, String? activityId})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'token': 'String get token',
      'activityId': 'String? get activityId',
      'isPushToStart': 'bool get isPushToStart',
    },
  );
}

// =============================================================================
// LivePushEvent Bridge
// =============================================================================

BridgedClass _createLivePushEventBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LivePushEvent,
    name: 'LivePushEvent',
    isAssignable: (v) => v is $dartnative_live_activities_17.LivePushEvent,
    constructors: {},
  );
}

// =============================================================================
// LivePushTokenEvent Bridge
// =============================================================================

BridgedClass _createLivePushTokenEventBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LivePushTokenEvent,
    name: 'LivePushTokenEvent',
    isAssignable: (v) => v is $dartnative_live_activities_17.LivePushTokenEvent,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LivePushTokenEvent');
        final token = D4
            .getRequiredArg<$dartnative_live_activities_17.LivePushToken>(
              positional,
              0,
              'token',
              'LivePushTokenEvent',
            );
        return $dartnative_live_activities_17.LivePushTokenEvent(token);
      },
    },
    getters: {
      'token': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LivePushTokenEvent>(
            target,
            'LivePushTokenEvent',
          )
          .token,
    },
    constructorSignatures: {
      '': 'const LivePushTokenEvent(LivePushToken token)',
    },
    getterSignatures: {
      'token': 'LivePushToken get token',
    },
  );
}

// =============================================================================
// LivePushStartedEvent Bridge
// =============================================================================

BridgedClass _createLivePushStartedEventBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LivePushStartedEvent,
    name: 'LivePushStartedEvent',
    isAssignable: (v) =>
        v is $dartnative_live_activities_17.LivePushStartedEvent,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LivePushStartedEvent');
        final activityId = D4.getRequiredArg<String>(
          positional,
          0,
          'activityId',
          'LivePushStartedEvent',
        );
        return $dartnative_live_activities_17.LivePushStartedEvent(activityId);
      },
    },
    getters: {
      'activityId': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LivePushStartedEvent>(
            target,
            'LivePushStartedEvent',
          )
          .activityId,
    },
    constructorSignatures: {
      '': 'const LivePushStartedEvent(String activityId)',
    },
    getterSignatures: {
      'activityId': 'String get activityId',
    },
  );
}

// =============================================================================
// LiveActivityStateChange Bridge
// =============================================================================

BridgedClass _createLiveActivityStateChangeBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LiveActivityStateChange,
    name: 'LiveActivityStateChange',
    isAssignable: (v) =>
        v is $dartnative_live_activities_17.LiveActivityStateChange,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'LiveActivityStateChange');
        final id = D4.getRequiredArg<String>(
          positional,
          0,
          'id',
          'LiveActivityStateChange',
        );
        final state = D4
            .getRequiredArg<$dartnative_live_activities_17.LiveActivityState>(
              positional,
              1,
              'state',
              'LiveActivityStateChange',
            );
        final customId = D4.getOptionalNamedArg<String?>(named, 'customId');
        return $dartnative_live_activities_17.LiveActivityStateChange(
          id,
          state,
          customId: customId,
        );
      },
    },
    getters: {
      'id': (visitor, target) => D4
          .validateTarget<
            $dartnative_live_activities_17.LiveActivityStateChange
          >(target, 'LiveActivityStateChange')
          .id,
      'customId': (visitor, target) => D4
          .validateTarget<
            $dartnative_live_activities_17.LiveActivityStateChange
          >(target, 'LiveActivityStateChange')
          .customId,
      'state': (visitor, target) => D4
          .validateTarget<
            $dartnative_live_activities_17.LiveActivityStateChange
          >(target, 'LiveActivityStateChange')
          .state,
      'hashCode': (visitor, target) => D4
          .validateTarget<
            $dartnative_live_activities_17.LiveActivityStateChange
          >(target, 'LiveActivityStateChange')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivityStateChange
            >(target, 'LiveActivityStateChange');
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivityStateChange
            >(target, 'LiveActivityStateChange');
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(
          positional,
          0,
          'other',
          'operator==',
        );
        return t == other;
      },
    },
    constructorSignatures: {
      '': 'const LiveActivityStateChange(String id, LiveActivityState state, {String? customId})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'id': 'String get id',
      'customId': 'String? get customId',
      'state': 'LiveActivityState get state',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// LivePushStateEvent Bridge
// =============================================================================

BridgedClass _createLivePushStateEventBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LivePushStateEvent,
    name: 'LivePushStateEvent',
    isAssignable: (v) => v is $dartnative_live_activities_17.LivePushStateEvent,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LivePushStateEvent');
        final change = D4
            .getRequiredArg<
              $dartnative_live_activities_17.LiveActivityStateChange
            >(positional, 0, 'change', 'LivePushStateEvent');
        return $dartnative_live_activities_17.LivePushStateEvent(change);
      },
    },
    getters: {
      'change': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LivePushStateEvent>(
            target,
            'LivePushStateEvent',
          )
          .change,
    },
    constructorSignatures: {
      '': 'const LivePushStateEvent(LiveActivityStateChange change)',
    },
    getterSignatures: {
      'change': 'LiveActivityStateChange get change',
    },
  );
}

// =============================================================================
// LiveAlert Bridge
// =============================================================================

BridgedClass _createLiveAlertBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LiveAlert,
    name: 'LiveAlert',
    isAssignable: (v) => v is $dartnative_live_activities_17.LiveAlert,
    constructors: {
      '': (visitor, positional, named) {
        final title = D4.getRequiredNamedArg<String>(
          named,
          'title',
          'LiveAlert',
        );
        final body = D4.getRequiredNamedArg<String>(named, 'body', 'LiveAlert');
        final sound = D4.getOptionalNamedArg<String?>(named, 'sound');
        return $dartnative_live_activities_17.LiveAlert(
          title: title,
          body: body,
          sound: sound,
        );
      },
    },
    getters: {
      'title': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveAlert>(
            target,
            'LiveAlert',
          )
          .title,
      'body': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveAlert>(
            target,
            'LiveAlert',
          )
          .body,
      'sound': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveAlert>(
            target,
            'LiveAlert',
          )
          .sound,
      'hashCode': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveAlert>(
            target,
            'LiveAlert',
          )
          .hashCode,
    },
    methods: {
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_17.LiveAlert>(
          target,
          'LiveAlert',
        );
        return t.toMap();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_17.LiveAlert>(
          target,
          'LiveAlert',
        );
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(
          positional,
          0,
          'other',
          'operator==',
        );
        return t == other;
      },
    },
    constructorSignatures: {
      '': 'const LiveAlert({required String title, required String body, String? sound})',
    },
    methodSignatures: {
      'toMap': 'Map<String, Object?> toMap()',
    },
    getterSignatures: {
      'title': 'String get title',
      'body': 'String get body',
      'sound': 'String? get sound',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// LiveDismiss Bridge
// =============================================================================

BridgedClass _createLiveDismissBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LiveDismiss,
    name: 'LiveDismiss',
    isAssignable: (v) => v is $dartnative_live_activities_17.LiveDismiss,
    constructors: {
      'after': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveDismiss');
        final delay = D4.getRequiredArg<Duration>(
          positional,
          0,
          'delay',
          'LiveDismiss',
        );
        return $dartnative_live_activities_17.LiveDismiss.after(delay);
      },
      'at': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveDismiss');
        final when = D4.getRequiredArg<DateTime>(
          positional,
          0,
          'when',
          'LiveDismiss',
        );
        return $dartnative_live_activities_17.LiveDismiss.at(when);
      },
    },
    getters: {
      'type': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveDismiss>(
            target,
            'LiveDismiss',
          )
          .type,
      'after': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveDismiss>(
            target,
            'LiveDismiss',
          )
          .after,
      'at': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveDismiss>(
            target,
            'LiveDismiss',
          )
          .at,
    },
    methods: {
      'afterFromNow': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_live_activities_17.LiveDismiss>(
          target,
          'LiveDismiss',
        );
        final now = D4.getOptionalArg<DateTime?>(positional, 0, 'now');
        return t.afterFromNow(now);
      },
    },
    staticGetters: {
      'immediate': (visitor) =>
          $dartnative_live_activities_17.LiveDismiss.immediate,
      'byDefault': (visitor) =>
          $dartnative_live_activities_17.LiveDismiss.byDefault,
    },
    constructorSignatures: {
      'after': 'const LiveDismiss.after(Duration delay)',
      'at': 'const LiveDismiss.at(DateTime when)',
    },
    methodSignatures: {
      'afterFromNow': 'Duration afterFromNow([DateTime? now])',
    },
    getterSignatures: {
      'type': 'String get type',
      'after': 'Duration get after',
      'at': 'DateTime? get at',
    },
    staticGetterSignatures: {
      'immediate': 'LiveDismiss get immediate',
      'byDefault': 'LiveDismiss get byDefault',
    },
  );
}

// =============================================================================
// LiveActivityInfo Bridge
// =============================================================================

BridgedClass _createLiveActivityInfoBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LiveActivityInfo,
    name: 'LiveActivityInfo',
    isAssignable: (v) => v is $dartnative_live_activities_17.LiveActivityInfo,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'LiveActivityInfo');
        final id = D4.getRequiredArg<String>(
          positional,
          0,
          'id',
          'LiveActivityInfo',
        );
        final customId = D4.getOptionalNamedArg<String?>(named, 'customId');
        return $dartnative_live_activities_17.LiveActivityInfo(
          id,
          customId: customId,
        );
      },
    },
    getters: {
      'id': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveActivityInfo>(
            target,
            'LiveActivityInfo',
          )
          .id,
      'customId': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveActivityInfo>(
            target,
            'LiveActivityInfo',
          )
          .customId,
      'hashCode': (visitor, target) => D4
          .validateTarget<$dartnative_live_activities_17.LiveActivityInfo>(
            target,
            'LiveActivityInfo',
          )
          .hashCode,
    },
    methods: {
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<$dartnative_live_activities_17.LiveActivityInfo>(
              target,
              'LiveActivityInfo',
            );
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(
          positional,
          0,
          'other',
          'operator==',
        );
        return t == other;
      },
    },
    constructorSignatures: {
      '': 'const LiveActivityInfo(String id, {String? customId})',
    },
    getterSignatures: {
      'id': 'String get id',
      'customId': 'String? get customId',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// LiveActivitiesException Bridge
// =============================================================================

BridgedClass _createLiveActivitiesExceptionBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LiveActivitiesException,
    name: 'LiveActivitiesException',
    isAssignable: (v) =>
        v is $dartnative_live_activities_17.LiveActivitiesException,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'LiveActivitiesException');
        final code = D4.getRequiredArg<String>(
          positional,
          0,
          'code',
          'LiveActivitiesException',
        );
        final message = D4.getRequiredArg<String>(
          positional,
          1,
          'message',
          'LiveActivitiesException',
        );
        return $dartnative_live_activities_17.LiveActivitiesException(
          code,
          message,
        );
      },
    },
    getters: {
      'code': (visitor, target) => D4
          .validateTarget<
            $dartnative_live_activities_17.LiveActivitiesException
          >(target, 'LiveActivitiesException')
          .code,
      'message': (visitor, target) => D4
          .validateTarget<
            $dartnative_live_activities_17.LiveActivitiesException
          >(target, 'LiveActivitiesException')
          .message,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesException
            >(target, 'LiveActivitiesException');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const LiveActivitiesException(String code, String message)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'code': 'String get code',
      'message': 'String get message',
    },
  );
}

// =============================================================================
// LiveActivitiesPlatform Bridge
// =============================================================================

BridgedClass _createLiveActivitiesPlatformBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_17.LiveActivitiesPlatform,
    name: 'LiveActivitiesPlatform',
    isAssignable: (v) =>
        v is $dartnative_live_activities_17.LiveActivitiesPlatform,
    isAbstract: true,
    constructors: {},
    getters: {
      'needsAndroidIcons': (visitor, target) => D4
          .validateTarget<
            $dartnative_live_activities_17.LiveActivitiesPlatform
          >(target, 'LiveActivitiesPlatform')
          .needsAndroidIcons,
      'actions': (visitor, target) => D4
          .validateTarget<
            $dartnative_live_activities_17.LiveActivitiesPlatform
          >(target, 'LiveActivitiesPlatform')
          .actions,
      'pushEvents': (visitor, target) => D4
          .validateTarget<
            $dartnative_live_activities_17.LiveActivitiesPlatform
          >(target, 'LiveActivitiesPlatform')
          .pushEvents,
    },
    methods: {
      'areEnabled': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        return t.areEnabled();
      },
      'activeActivities': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        return t.activeActivities();
      },
      'endAll': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        final dismiss = D4
            .getNamedArgWithDefault<$dartnative_live_activities_17.LiveDismiss>(
              named,
              'dismiss',
              $dartnative_live_activities_17.LiveDismiss.immediate,
            );
        return t.endAll(dismiss: dismiss);
      },
      'registerLayout': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        final name = D4.getRequiredNamedArg<String>(
          named,
          'name',
          'registerLayout',
        );
        final layoutJson = D4.getRequiredNamedArg<String>(
          named,
          'layoutJson',
          'registerLayout',
        );
        if (!named.containsKey('images') || named['images'] == null) {
          throw ArgumentError(
            'registerLayout: Missing required named argument "images"',
          );
        }
        final images = D4
            .coerceList<$dartnative_live_activities_17.LiveImagePayload>(
              named['images'],
              'images',
            );
        return t.registerLayout(
          name: name,
          layoutJson: layoutJson,
          images: images,
        );
      },
      'handlePush': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        D4.requireMinArgs(positional, 1, 'handlePush');
        if (positional.isEmpty) {
          throw ArgumentError(
            'handlePush: Missing required argument "data" at position 0',
          );
        }
        final data = D4.coerceMap<String, Object?>(positional[0], 'data');
        return t.handlePush(data);
      },
      'requestPermission': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        return t.requestPermission();
      },
      'openPromotionSettings': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        return t.openPromotionSettings();
      },
      'start': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        final layoutJson = D4.getRequiredNamedArg<String>(
          named,
          'layoutJson',
          'start',
        );
        final stateJson = D4.getRequiredNamedArg<String>(
          named,
          'stateJson',
          'start',
        );
        if (!named.containsKey('images') || named['images'] == null) {
          throw ArgumentError(
            'start: Missing required named argument "images"',
          );
        }
        final images = D4
            .coerceList<$dartnative_live_activities_17.LiveImagePayload>(
              named['images'],
              'images',
            );
        final deepLink = D4.getOptionalNamedArg<String?>(named, 'deepLink');
        final staleAfter = D4.getOptionalNamedArg<Duration?>(
          named,
          'staleAfter',
        );
        final relevance = D4.getNamedArgWithDefault<double>(
          named,
          'relevance',
          0,
        );
        final requestPushToken = D4.getNamedArgWithDefault<bool>(
          named,
          'requestPushToken',
          false,
        );
        final customId = D4.getOptionalNamedArg<String?>(named, 'customId');
        return t.start(
          layoutJson: layoutJson,
          stateJson: stateJson,
          images: images,
          deepLink: deepLink,
          staleAfter: staleAfter,
          relevance: relevance,
          requestPushToken: requestPushToken,
          customId: customId,
        );
      },
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        D4.requireMinArgs(positional, 2, 'update');
        final id = D4.getRequiredArg<String>(positional, 0, 'id', 'update');
        final stateJson = D4.getRequiredArg<String>(
          positional,
          1,
          'stateJson',
          'update',
        );
        final staleAfter = D4.getOptionalNamedArg<Duration?>(
          named,
          'staleAfter',
        );
        final alert = D4
            .getOptionalNamedArg<$dartnative_live_activities_17.LiveAlert?>(
              named,
              'alert',
            );
        return t.update(id, stateJson, staleAfter: staleAfter, alert: alert);
      },
      'end': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        D4.requireMinArgs(positional, 1, 'end');
        final id = D4.getRequiredArg<String>(positional, 0, 'id', 'end');
        final stateJson = D4.getOptionalNamedArg<String?>(named, 'stateJson');
        final dismiss = D4
            .getNamedArgWithDefault<$dartnative_live_activities_17.LiveDismiss>(
              named,
              'dismiss',
              $dartnative_live_activities_17.LiveDismiss.byDefault,
            );
        return t.end(id, stateJson: stateJson, dismiss: dismiss);
      },
      'scheduleEnd': (visitor, target, positional, named, typeArgs) {
        final t = D4
            .validateTarget<
              $dartnative_live_activities_17.LiveActivitiesPlatform
            >(target, 'LiveActivitiesPlatform');
        D4.requireMinArgs(positional, 1, 'scheduleEnd');
        final id = D4.getRequiredArg<String>(
          positional,
          0,
          'id',
          'scheduleEnd',
        );
        final secondsFromNow = D4.getRequiredNamedArg<double>(
          named,
          'secondsFromNow',
          'scheduleEnd',
        );
        final stateJson = D4.getOptionalNamedArg<String?>(named, 'stateJson');
        return t.scheduleEnd(
          id,
          secondsFromNow: secondsFromNow,
          stateJson: stateJson,
        );
      },
    },
    methodSignatures: {
      'areEnabled': 'Future<bool> areEnabled()',
      'activeActivities': 'Future<List<LiveActivityInfo>> activeActivities()',
      'endAll':
          'Future<void> endAll({LiveDismiss dismiss = LiveDismiss.immediate})',
      'registerLayout':
          'Future<void> registerLayout({required String name, required String layoutJson, required List<LiveImagePayload> images})',
      'handlePush': 'Future<String?> handlePush(Map<String, Object?> data)',
      'requestPermission': 'Future<bool> requestPermission()',
      'openPromotionSettings': 'Future<bool> openPromotionSettings()',
      'start':
          'Future<String> start({required String layoutJson, required String stateJson, required List<LiveImagePayload> images, String? deepLink, Duration? staleAfter, double relevance = 0, bool requestPushToken = false, String? customId})',
      'update':
          'Future<void> update(String id, String stateJson, {Duration? staleAfter, LiveAlert? alert})',
      'end':
          'Future<void> end(String id, {String? stateJson, LiveDismiss dismiss = LiveDismiss.byDefault})',
      'scheduleEnd':
          'Future<void> scheduleEnd(String id, {required double secondsFromNow, String? stateJson})',
    },
    getterSignatures: {
      'needsAndroidIcons': 'bool get needsAndroidIcons',
      'actions': 'Stream<String> get actions',
      'pushEvents': 'Stream<LivePushEvent> get pushEvents',
    },
  );
}

// =============================================================================
// LiveActivitiesFFIBindings Bridge
// =============================================================================

BridgedClass _createLiveActivitiesFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_live_activities_16.LiveActivitiesFFIBindings,
    name: 'LiveActivitiesFFIBindings',
    isAssignable: (v) =>
        v is $dartnative_live_activities_16.LiveActivitiesFFIBindings,
    isAbstract: true,
    constructors: {},
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_live_activities_16
            .LiveActivitiesFFIBindings.loadSymbols();
      },
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
  );
}

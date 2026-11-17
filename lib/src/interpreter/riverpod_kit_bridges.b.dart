// D4rt Bridge - Generated file, do not edit
// Sources: 19 files
// Generated: 2026-11-16T04:48:23.843888 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'package:dartnative/dartnative.dart' as $flutter_widgets;
import 'widget_proxies.dart';

import 'package:riverpod/src/builder.dart' as $riverpod_1;
import 'package:riverpod/src/common/stack_trace.dart' as $riverpod_2;
import 'package:riverpod/src/common/string.dart' as $riverpod_3;
import 'package:riverpod/src/common/tenable.dart' as $riverpod_4;
import 'package:riverpod/src/core/persist.dart' as $riverpod_5;
import 'package:riverpod/src/framework.dart' as $riverpod_6;
import 'package:riverpod/src/providers/async_notifier.dart' as $riverpod_7;
import 'package:riverpod/src/providers/future_provider.dart' as $riverpod_8;
import 'package:riverpod/src/providers/legacy/state_controller.dart'
    as $riverpod_9;
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart'
    as $riverpod_10;
import 'package:riverpod/src/providers/legacy/state_provider.dart'
    as $riverpod_11;
import 'package:riverpod/src/providers/notifier.dart' as $riverpod_12;
import 'package:riverpod/src/providers/provider.dart' as $riverpod_13;
import 'package:riverpod/src/providers/stream_notifier.dart' as $riverpod_14;
import 'package:riverpod/src/providers/stream_provider.dart' as $riverpod_15;
import 'package:riverpod_kit/src/consumer.dart' as $riverpod_kit_1;
import 'package:riverpod_kit/src/provider_scope.dart' as $riverpod_kit_2;
import 'package:riverpod_kit/src/widget_ref.dart' as $riverpod_kit_3;
import 'package:state_notifier/state_notifier.dart' as $state_notifier_1;

/// Bridge class for riverpod_kit module.
Object? _unwrapInterpretedProxy(Object? val) {
  if (val is InterpretedNotifierProxy) {
    return val.instance;
  }
  if (val is InterpretedAsyncNotifierProxy) {
    return val.instance;
  }
  if (val is InterpretedStreamNotifierProxy) {
    return val.instance;
  }
  return val;
}

class RiverpodKitBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createProviderExceptionBridge(),
      _createStorageOptionsBridge(),
      _createPersistedDataBridge(),
      _createStorageBridge(),
      _createStorageCacheTimeBridge(),
      _createRefreshableBridge(),
      _createFamilyBridge(),
      _createProviderListenableOrFamilyBridge(),
      _createProviderOrFamilyBridge(),
      _createProviderListenableBridge(),
      _createAsyncProviderListenableBridge(),
      _createOverrideBridge(),
      _create$ProviderOverrideBridge(),
      _createAnyNotifierBridge(),
      _createPersistResultBridge(),
      _createProviderBaseBridge(),
      _createProviderTransformerContextBridge(),
      _createProviderTransformerBridge(),
      _createProviderReferenceBridge(),
      _createProviderContainerBridge(),
      _createProviderObserverContextBridge(),
      _createProviderObserverBridge(),
      _createProviderSubscriptionBridge(),
      _createMutationTransactionBridge(),
      _createMutationTargetBridge(),
      _createMutationBridge(),
      _createMutationStateBridge(),
      _createMutationIdleBridge(),
      _createMutationPendingBridge(),
      _createMutationErrorBridge(),
      _createMutationSuccessBridge(),
      _createRefBridge(),
      _createKeepAliveLinkBridge(),
      _createAsyncValueIsLoadingExceptionBridge(),
      _createAsyncValueBridge(),
      _createAsyncResultBridge(),
      _createAsyncDataBridge(),
      _createAsyncLoadingBridge(),
      _createAsyncErrorBridge(),
      _createDevtoolObserverBridge(),
      _createSyncProviderTransformerMixinBridge(),
      _create$AsyncNotifierBridge(),
      _create$AsyncNotifierProviderBridge(),
      _createAsyncNotifierBridge(),
      _createAsyncNotifierProviderBridge(),
      _createAsyncNotifierProviderFamilyBridge(),
      _createFutureProviderBridge(),
      _createFutureProviderFamilyBridge(),
      _createStateControllerBridge(),
      _createStateNotifierProviderBridge(),
      _createStateNotifierProviderFamilyBridge(),
      _createStateProviderBridge(),
      _createStateProviderFamilyBridge(),
      _create$NotifierBridge(),
      _create$NotifierProviderBridge(),
      _createNotifierBridge(),
      _createNotifierProviderBridge(),
      _createNotifierProviderFamilyBridge(),
      _createProviderBridge(),
      _createProviderFamilyBridge(),
      _create$StreamNotifierBridge(),
      _create$StreamNotifierProviderBridge(),
      _createStreamNotifierProviderFamilyBridge(),
      _createStreamNotifierBridge(),
      _createStreamNotifierProviderBridge(),
      _createStreamProviderBridge(),
      _createStreamProviderFamilyBridge(),
      _createConsumerStatefulWidgetBridge(),
      _createConsumerStateBridge(),
      _createConsumerWidgetBridge(),
      _createConsumerBridge(),
      _createProviderScopeBridge(),
      _createRootRegistrationBridge(),
      _createUncontrolledProviderScopeBridge(),
      _createWidgetRefBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'ProviderException': _createProviderExceptionBridge,
      'StorageOptions': _createStorageOptionsBridge,
      'PersistedData': _createPersistedDataBridge,
      'Storage': _createStorageBridge,
      'StorageCacheTime': _createStorageCacheTimeBridge,
      'Refreshable': _createRefreshableBridge,
      'Family': _createFamilyBridge,
      'ProviderListenableOrFamily': _createProviderListenableOrFamilyBridge,
      'ProviderOrFamily': _createProviderOrFamilyBridge,
      'ProviderListenable': _createProviderListenableBridge,
      'AsyncProviderListenable': _createAsyncProviderListenableBridge,
      'Override': _createOverrideBridge,
      '\$ProviderOverride': _create$ProviderOverrideBridge,
      'AnyNotifier': _createAnyNotifierBridge,
      'PersistResult': _createPersistResultBridge,
      'ProviderBase': _createProviderBaseBridge,
      'ProviderTransformerContext': _createProviderTransformerContextBridge,
      'ProviderTransformer': _createProviderTransformerBridge,
      'ProviderReference': _createProviderReferenceBridge,
      'ProviderContainer': _createProviderContainerBridge,
      'ProviderObserverContext': _createProviderObserverContextBridge,
      'ProviderObserver': _createProviderObserverBridge,
      'ProviderSubscription': _createProviderSubscriptionBridge,
      'MutationTransaction': _createMutationTransactionBridge,
      'MutationTarget': _createMutationTargetBridge,
      'Mutation': _createMutationBridge,
      'MutationState': _createMutationStateBridge,
      'MutationIdle': _createMutationIdleBridge,
      'MutationPending': _createMutationPendingBridge,
      'MutationError': _createMutationErrorBridge,
      'MutationSuccess': _createMutationSuccessBridge,
      'Ref': _createRefBridge,
      'KeepAliveLink': _createKeepAliveLinkBridge,
      'AsyncValueIsLoadingException': _createAsyncValueIsLoadingExceptionBridge,
      'AsyncValue': _createAsyncValueBridge,
      'AsyncResult': _createAsyncResultBridge,
      'AsyncData': _createAsyncDataBridge,
      'AsyncLoading': _createAsyncLoadingBridge,
      'AsyncError': _createAsyncErrorBridge,
      'DevtoolObserver': _createDevtoolObserverBridge,
      'SyncProviderTransformerMixin': _createSyncProviderTransformerMixinBridge,
      '\$AsyncNotifier': _create$AsyncNotifierBridge,
      '\$AsyncNotifierProvider': _create$AsyncNotifierProviderBridge,
      'AsyncNotifier': _createAsyncNotifierBridge,
      'AsyncNotifierProvider': _createAsyncNotifierProviderBridge,
      'AsyncNotifierProviderFamily': _createAsyncNotifierProviderFamilyBridge,
      'FutureProvider': _createFutureProviderBridge,
      'FutureProviderFamily': _createFutureProviderFamilyBridge,
      'StateController': _createStateControllerBridge,
      'StateNotifierProvider': _createStateNotifierProviderBridge,
      'StateNotifierProviderFamily': _createStateNotifierProviderFamilyBridge,
      'StateProvider': _createStateProviderBridge,
      'StateProviderFamily': _createStateProviderFamilyBridge,
      '\$Notifier': _create$NotifierBridge,
      '\$NotifierProvider': _create$NotifierProviderBridge,
      'Notifier': _createNotifierBridge,
      'NotifierProvider': _createNotifierProviderBridge,
      'NotifierProviderFamily': _createNotifierProviderFamilyBridge,
      'Provider': _createProviderBridge,
      'ProviderFamily': _createProviderFamilyBridge,
      '\$StreamNotifier': _create$StreamNotifierBridge,
      '\$StreamNotifierProvider': _create$StreamNotifierProviderBridge,
      'StreamNotifierProviderFamily': _createStreamNotifierProviderFamilyBridge,
      'StreamNotifier': _createStreamNotifierBridge,
      'StreamNotifierProvider': _createStreamNotifierProviderBridge,
      'StreamProvider': _createStreamProviderBridge,
      'StreamProviderFamily': _createStreamProviderFamilyBridge,
      'ConsumerStatefulWidget': _createConsumerStatefulWidgetBridge,
      'ConsumerState': _createConsumerStateBridge,
      'ConsumerWidget': _createConsumerWidgetBridge,
      'Consumer': _createConsumerBridge,
      'ProviderScope': _createProviderScopeBridge,
      'RootRegistration': _createRootRegistrationBridge,
      'UncontrolledProviderScope': _createUncontrolledProviderScopeBridge,
      'WidgetRef': _createWidgetRefBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'ProviderException': $riverpod_2.ProviderException,
      'StorageOptions': $riverpod_5.StorageOptions,
      'PersistedData': $riverpod_5.PersistedData,
      'Storage': $riverpod_5.Storage,
      'StorageCacheTime': $riverpod_5.StorageCacheTime,
      'Refreshable': $riverpod_6.Refreshable,
      'Family': $riverpod_6.Family,
      'ProviderListenableOrFamily': $riverpod_6.ProviderListenableOrFamily,
      'ProviderOrFamily': $riverpod_6.ProviderOrFamily,
      'ProviderListenable': $riverpod_6.ProviderListenable,
      'AsyncProviderListenable': $riverpod_6.AsyncProviderListenable,
      'Override': $riverpod_6.Override,
      '\$ProviderOverride': $riverpod_6.$ProviderOverride,
      'AnyNotifier': $riverpod_6.AnyNotifier,
      'PersistResult': $riverpod_6.PersistResult,
      'ProviderBase': $riverpod_6.ProviderBase,
      'ProviderTransformerContext': $riverpod_6.ProviderTransformerContext,
      'ProviderTransformer': $riverpod_6.ProviderTransformer,
      'ProviderReference': $riverpod_6.ProviderReference,
      'ProviderContainer': $riverpod_6.ProviderContainer,
      'ProviderObserverContext': $riverpod_6.ProviderObserverContext,
      'ProviderObserver': $riverpod_6.ProviderObserver,
      'ProviderSubscription': $riverpod_6.ProviderSubscription,
      'MutationTransaction': $riverpod_6.MutationTransaction,
      'MutationTarget': $riverpod_6.MutationTarget,
      'Mutation': $riverpod_6.Mutation,
      'MutationState': $riverpod_6.MutationState,
      'MutationIdle': $riverpod_6.MutationIdle,
      'MutationPending': $riverpod_6.MutationPending,
      'MutationError': $riverpod_6.MutationError,
      'MutationSuccess': $riverpod_6.MutationSuccess,
      'Ref': $riverpod_6.Ref,
      'KeepAliveLink': $riverpod_6.KeepAliveLink,
      'AsyncValueIsLoadingException': $riverpod_6.AsyncValueIsLoadingException,
      'AsyncValue': $riverpod_6.AsyncValue,
      'AsyncResult': $riverpod_6.AsyncResult,
      'AsyncData': $riverpod_6.AsyncData,
      'AsyncLoading': $riverpod_6.AsyncLoading,
      'AsyncError': $riverpod_6.AsyncError,
      'DevtoolObserver': $riverpod_6.DevtoolObserver,
      'SyncProviderTransformerMixin': $riverpod_6.SyncProviderTransformerMixin,
      '\$AsyncNotifier': $riverpod_7.$AsyncNotifier,
      '\$AsyncNotifierProvider': $riverpod_7.$AsyncNotifierProvider,
      'AsyncNotifier': $riverpod_7.AsyncNotifier,
      'AsyncNotifierProvider': $riverpod_7.AsyncNotifierProvider,
      'AsyncNotifierProviderFamily': $riverpod_7.AsyncNotifierProviderFamily,
      'FutureProvider': $riverpod_8.FutureProvider,
      'FutureProviderFamily': $riverpod_8.FutureProviderFamily,
      'StateController': $riverpod_9.StateController,
      'StateNotifierProvider': $riverpod_10.StateNotifierProvider,
      'StateNotifierProviderFamily': $riverpod_10.StateNotifierProviderFamily,
      'StateProvider': $riverpod_11.StateProvider,
      'StateProviderFamily': $riverpod_11.StateProviderFamily,
      '\$Notifier': $riverpod_12.$Notifier,
      '\$NotifierProvider': $riverpod_12.$NotifierProvider,
      'Notifier': $riverpod_12.Notifier,
      'NotifierProvider': $riverpod_12.NotifierProvider,
      'NotifierProviderFamily': $riverpod_12.NotifierProviderFamily,
      'Provider': $riverpod_13.Provider,
      'ProviderFamily': $riverpod_13.ProviderFamily,
      '\$StreamNotifier': $riverpod_14.$StreamNotifier,
      '\$StreamNotifierProvider': $riverpod_14.$StreamNotifierProvider,
      'StreamNotifierProviderFamily': $riverpod_14.StreamNotifierProviderFamily,
      'StreamNotifier': $riverpod_14.StreamNotifier,
      'StreamNotifierProvider': $riverpod_14.StreamNotifierProvider,
      'StreamProvider': $riverpod_15.StreamProvider,
      'StreamProviderFamily': $riverpod_15.StreamProviderFamily,
      'ConsumerStatefulWidget': $riverpod_kit_1.ConsumerStatefulWidget,
      'ConsumerState': $riverpod_kit_1.ConsumerState,
      'ConsumerWidget': $riverpod_kit_1.ConsumerWidget,
      'Consumer': $riverpod_kit_1.Consumer,
      'ProviderScope': $riverpod_kit_2.ProviderScope,
      'RootRegistration': $riverpod_kit_2.RootRegistration,
      'UncontrolledProviderScope': $riverpod_kit_2.UncontrolledProviderScope,
      'WidgetRef': $riverpod_kit_3.WidgetRef,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'ProviderException': 'package:riverpod/src/common/stack_trace.dart',
      'StorageOptions': 'package:riverpod/src/core/persist.dart',
      'PersistedData': 'package:riverpod/src/core/persist.dart',
      'Storage': 'package:riverpod/src/core/persist.dart',
      'StorageCacheTime': 'package:riverpod/src/core/persist.dart',
      'Refreshable': 'package:riverpod/src/framework.dart',
      'Family': 'package:riverpod/src/framework.dart',
      'ProviderListenableOrFamily': 'package:riverpod/src/framework.dart',
      'ProviderOrFamily': 'package:riverpod/src/framework.dart',
      'ProviderListenable': 'package:riverpod/src/framework.dart',
      'AsyncProviderListenable': 'package:riverpod/src/framework.dart',
      'Override': 'package:riverpod/src/framework.dart',
      '\$ProviderOverride': 'package:riverpod/src/framework.dart',
      'AnyNotifier': 'package:riverpod/src/framework.dart',
      'PersistResult': 'package:riverpod/src/framework.dart',
      'ProviderBase': 'package:riverpod/src/framework.dart',
      'ProviderTransformerContext': 'package:riverpod/src/framework.dart',
      'ProviderTransformer': 'package:riverpod/src/framework.dart',
      'ProviderReference': 'package:riverpod/src/framework.dart',
      'ProviderContainer': 'package:riverpod/src/framework.dart',
      'ProviderObserverContext': 'package:riverpod/src/framework.dart',
      'ProviderObserver': 'package:riverpod/src/framework.dart',
      'ProviderSubscription': 'package:riverpod/src/framework.dart',
      'MutationTransaction': 'package:riverpod/src/framework.dart',
      'MutationTarget': 'package:riverpod/src/framework.dart',
      'Mutation': 'package:riverpod/src/framework.dart',
      'MutationState': 'package:riverpod/src/framework.dart',
      'MutationIdle': 'package:riverpod/src/framework.dart',
      'MutationPending': 'package:riverpod/src/framework.dart',
      'MutationError': 'package:riverpod/src/framework.dart',
      'MutationSuccess': 'package:riverpod/src/framework.dart',
      'Ref': 'package:riverpod/src/framework.dart',
      'KeepAliveLink': 'package:riverpod/src/framework.dart',
      'AsyncValueIsLoadingException': 'package:riverpod/src/framework.dart',
      'AsyncValue': 'package:riverpod/src/framework.dart',
      'AsyncResult': 'package:riverpod/src/framework.dart',
      'AsyncData': 'package:riverpod/src/framework.dart',
      'AsyncLoading': 'package:riverpod/src/framework.dart',
      'AsyncError': 'package:riverpod/src/framework.dart',
      'DevtoolObserver': 'package:riverpod/src/framework.dart',
      'SyncProviderTransformerMixin': 'package:riverpod/src/framework.dart',
      '\$AsyncNotifier': 'package:riverpod/src/providers/async_notifier.dart',
      '\$AsyncNotifierProvider':
          'package:riverpod/src/providers/async_notifier.dart',
      'AsyncNotifier': 'package:riverpod/src/providers/async_notifier.dart',
      'AsyncNotifierProvider':
          'package:riverpod/src/providers/async_notifier.dart',
      'AsyncNotifierProviderFamily':
          'package:riverpod/src/providers/async_notifier.dart',
      'FutureProvider': 'package:riverpod/src/providers/future_provider.dart',
      'FutureProviderFamily':
          'package:riverpod/src/providers/future_provider.dart',
      'StateController':
          'package:riverpod/src/providers/legacy/state_controller.dart',
      'StateNotifierProvider':
          'package:riverpod/src/providers/legacy/state_notifier_provider.dart',
      'StateNotifierProviderFamily':
          'package:riverpod/src/providers/legacy/state_notifier_provider.dart',
      'StateProvider':
          'package:riverpod/src/providers/legacy/state_provider.dart',
      'StateProviderFamily':
          'package:riverpod/src/providers/legacy/state_provider.dart',
      '\$Notifier': 'package:riverpod/src/providers/notifier.dart',
      '\$NotifierProvider': 'package:riverpod/src/providers/notifier.dart',
      'Notifier': 'package:riverpod/src/providers/notifier.dart',
      'NotifierProvider': 'package:riverpod/src/providers/notifier.dart',
      'NotifierProviderFamily': 'package:riverpod/src/providers/notifier.dart',
      'Provider': 'package:riverpod/src/providers/provider.dart',
      'ProviderFamily': 'package:riverpod/src/providers/provider.dart',
      '\$StreamNotifier': 'package:riverpod/src/providers/stream_notifier.dart',
      '\$StreamNotifierProvider':
          'package:riverpod/src/providers/stream_notifier.dart',
      'StreamNotifierProviderFamily':
          'package:riverpod/src/providers/stream_notifier.dart',
      'StreamNotifier': 'package:riverpod/src/providers/stream_notifier.dart',
      'StreamNotifierProvider':
          'package:riverpod/src/providers/stream_notifier.dart',
      'StreamProvider': 'package:riverpod/src/providers/stream_provider.dart',
      'StreamProviderFamily':
          'package:riverpod/src/providers/stream_provider.dart',
      'ConsumerStatefulWidget': 'package:riverpod_kit/src/consumer.dart',
      'ConsumerState': 'package:riverpod_kit/src/consumer.dart',
      'ConsumerWidget': 'package:riverpod_kit/src/consumer.dart',
      'Consumer': 'package:riverpod_kit/src/consumer.dart',
      'ProviderScope': 'package:riverpod_kit/src/provider_scope.dart',
      'RootRegistration': 'package:riverpod_kit/src/provider_scope.dart',
      'UncontrolledProviderScope':
          'package:riverpod_kit/src/provider_scope.dart',
      'WidgetRef': 'package:riverpod_kit/src/widget_ref.dart',
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
      'ProviderException': ['Exception'],
      'Refreshable': ['ProviderListenable', 'ProviderListenableOrFamily'],
      'Family': [
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        '_FamilyOverride',
        'Override',
      ],
      'ProviderOrFamily': ['ProviderListenableOrFamily'],
      'ProviderListenable': ['ProviderListenableOrFamily'],
      'AsyncProviderListenable': [
        'ProviderListenable',
        'ProviderListenableOrFamily',
      ],
      '\$ProviderOverride': ['_ProviderOverride', 'Override'],
      'ProviderBase': [
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
      ],
      'ProviderContainer': ['MutationTarget'],
      'Mutation': ['ProviderListenable', 'ProviderListenableOrFamily'],
      'MutationIdle': ['MutationState'],
      'MutationPending': ['MutationState'],
      'MutationError': ['MutationState'],
      'MutationSuccess': ['MutationState'],
      'Ref': ['BaseRef', 'MutationTarget'],
      'AsyncValueIsLoadingException': ['Exception'],
      'AsyncResult': ['AsyncValue'],
      'AsyncData': ['AsyncResult', 'AsyncValue'],
      'AsyncLoading': ['AsyncValue'],
      'AsyncError': ['AsyncResult', 'AsyncValue'],
      'DevtoolObserver': ['ProviderObserver'],
      'SyncProviderTransformerMixin': [
        '_ProviderTransformerMixin',
        'ProviderListenable',
        'ProviderListenableOrFamily',
      ],
      '\$AsyncNotifier': [
        '\$AsyncNotifierBase',
        'AnyNotifier',
        '\$AsyncClassModifier',
      ],
      '\$AsyncNotifierProvider': [
        '\$ClassProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        '\$FutureModifier',
        'AsyncProviderListenable',
      ],
      'AsyncNotifier': [
        '\$AsyncNotifier',
        '\$AsyncNotifierBase',
        'AnyNotifier',
        '\$AsyncClassModifier',
      ],
      'AsyncNotifierProvider': [
        '\$AsyncNotifierProvider',
        '\$ClassProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        '\$FutureModifier',
        'AsyncProviderListenable',
        'LegacyProviderMixin',
      ],
      'AsyncNotifierProviderFamily': [
        'ClassFamily',
        'Family',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        '_FamilyOverride',
        'Override',
        '\$ClassFamilyOverride',
      ],
      'FutureProvider': [
        '\$FunctionalProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        '\$FutureModifier',
        'AsyncProviderListenable',
        '\$FutureProvider',
        'LegacyProviderMixin',
      ],
      'FutureProviderFamily': [
        'FunctionalFamily',
        'Family',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        '_FamilyOverride',
        'Override',
        '\$FunctionalFamilyOverride',
      ],
      'StateController': ['StateNotifier'],
      'StateNotifierProvider': [
        '\$FunctionalProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        'LegacyProviderMixin',
      ],
      'StateNotifierProviderFamily': [
        'FunctionalFamily',
        'Family',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        '_FamilyOverride',
        'Override',
        '\$FunctionalFamilyOverride',
      ],
      'StateProvider': [
        '\$FunctionalProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        'LegacyProviderMixin',
      ],
      'StateProviderFamily': [
        'FunctionalFamily',
        'Family',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        '_FamilyOverride',
        'Override',
        '\$FunctionalFamilyOverride',
      ],
      '\$Notifier': ['\$SyncNotifierBase', 'AnyNotifier'],
      '\$NotifierProvider': [
        '\$ClassProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
      ],
      'Notifier': ['\$Notifier', '\$SyncNotifierBase', 'AnyNotifier'],
      'NotifierProvider': [
        '\$NotifierProvider',
        '\$ClassProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        'LegacyProviderMixin',
      ],
      'NotifierProviderFamily': [
        'ClassFamily',
        'Family',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        '_FamilyOverride',
        'Override',
        '\$ClassFamilyOverride',
      ],
      'Provider': [
        '\$FunctionalProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        '\$Provider',
        'LegacyProviderMixin',
      ],
      'ProviderFamily': [
        'FunctionalFamily',
        'Family',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        '_FamilyOverride',
        'Override',
        '\$FunctionalFamilyOverride',
      ],
      '\$StreamNotifier': [
        '\$AsyncNotifierBase',
        'AnyNotifier',
        '\$AsyncClassModifier',
      ],
      '\$StreamNotifierProvider': [
        '\$ClassProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        '\$FutureModifier',
        'AsyncProviderListenable',
      ],
      'StreamNotifierProviderFamily': [
        'ClassFamily',
        'Family',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        '_FamilyOverride',
        'Override',
        '\$ClassFamilyOverride',
      ],
      'StreamNotifier': [
        '\$StreamNotifier',
        '\$AsyncNotifierBase',
        'AnyNotifier',
        '\$AsyncClassModifier',
      ],
      'StreamNotifierProvider': [
        '\$StreamNotifierProvider',
        '\$ClassProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        '\$FutureModifier',
        'AsyncProviderListenable',
        'LegacyProviderMixin',
      ],
      'StreamProvider': [
        '\$FunctionalProvider',
        '\$ProviderBaseImpl',
        'ProviderBase',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        'ProviderListenable',
        'Refreshable',
        '_ProviderOverride',
        'Override',
        '\$FutureModifier',
        'AsyncProviderListenable',
        '\$StreamProvider',
        'LegacyProviderMixin',
      ],
      'StreamProviderFamily': [
        'FunctionalFamily',
        'Family',
        'ProviderOrFamily',
        'ProviderListenableOrFamily',
        '_FamilyOverride',
        'Override',
        '\$FunctionalFamilyOverride',
      ],
      'ConsumerWidget': ['ConsumerStatefulWidget'],
      'Consumer': ['ConsumerWidget', 'ConsumerStatefulWidget'],
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
      'Listener',
      'RemoveListener',
      'ErrorListener',
      'Locator',
      'Retry',
      'WhenComplete',
      'RunNotifierBuild',
      'Create',
    ];
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
    return [
      BridgedExtensionDefinition(
        name: 'ProviderExceptionX',
        onTypeName: 'ProviderException',
        methods: {
          'unwrap': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_2.ProviderException;
            return Function.apply(
              t.unwrap,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'ProviderListenableSelect',
        onTypeName: 'ProviderListenable',
        methods: {
          'select': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.ProviderListenable;
            return Function.apply(
              t.select,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'NotifierPersistX',
        onTypeName: 'AnyNotifier',
        methods: {
          'persist': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AnyNotifier;
            return Function.apply(
              t.persist,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'InternalProviderContainer',
        onTypeName: 'ProviderContainer',
        getters: {
          'scheduler': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).scheduler,
          'depth': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).depth,
          'debugChildren': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).debugChildren,
        },
        methods: {
          'defaultOnError': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.ProviderContainer;
            return Function.apply(
              t.defaultOnError,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'getAllProviderElements':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $riverpod_6.ProviderContainer;
                return Function.apply(
                  t.getAllProviderElements,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
          'getAllProviderElementsInOrder':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $riverpod_6.ProviderContainer;
                return Function.apply(
                  t.getAllProviderElementsInOrder,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
          'runGuarded': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.ProviderContainer;
            return Function.apply(
              t.runGuarded,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'runUnaryGuarded': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.ProviderContainer;
            return Function.apply(
              t.runUnaryGuarded,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'runBinaryGuarded': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.ProviderContainer;
            return Function.apply(
              t.runBinaryGuarded,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'runTernaryGuarded': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.ProviderContainer;
            return Function.apply(
              t.runTernaryGuarded,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'runQuaternaryGuarded':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $riverpod_6.ProviderContainer;
                return Function.apply(
                  t.runQuaternaryGuarded,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
        },
      ),
      BridgedExtensionDefinition(
        name: 'ContainerReadElement',
        onTypeName: 'ProviderContainer',
        methods: {
          'readProviderElement':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $riverpod_6.ProviderContainer;
                return Function.apply(
                  t.readProviderElement,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
        },
      ),
      BridgedExtensionDefinition(
        name: 'ProviderContainerTest',
        onTypeName: 'ProviderContainer',
        getters: {
          'disposed': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).disposed,
          'root': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).root,
          'parent': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).parent,
          'children': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).children,
          'pointerManager': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).pointerManager,
        },
      ),
      BridgedExtensionDefinition(
        name: 'ProviderSubImpl',
        onTypeName: 'ProviderSubscription',
        getters: {
          'impl': (visitor, target) =>
              (target as $riverpod_6.ProviderSubscription).impl,
          'providerSub': (visitor, target) =>
              (target as $riverpod_6.ProviderSubscription).providerSub,
        },
      ),
      BridgedExtensionDefinition(
        name: 'ProviderSubX',
        onTypeName: 'ProviderSubscription',
        methods: {
          'readSafe': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.ProviderSubscription;
            return Function.apply(
              t.readSafe,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'AsyncTransition',
        onTypeName: 'AsyncValue',
        methods: {
          'cast': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AsyncValue;
            return Function.apply(
              t.cast,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'AsyncValueInternals',
        onTypeName: 'AsyncValue',
        getters: {
          'valueFilled': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).valueFilled,
        },
      ),
      BridgedExtensionDefinition(
        name: 'AsyncValueExtensions',
        onTypeName: 'AsyncValue',
        getters: {
          'retrying': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).retrying,
          'isFromCache': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).isFromCache,
          'isLoading': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).isLoading,
          'isRefreshing': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).isRefreshing,
          'isReloading': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).isReloading,
          'progress': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).progress,
          'hasValue': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).hasValue,
          'hasError': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).hasError,
          'asData': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).asData,
          'asError': (visitor, target) =>
              (target as $riverpod_6.AsyncValue).asError,
        },
        methods: {
          'map': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AsyncValue;
            return Function.apply(
              t.map,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'whenData': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AsyncValue;
            return Function.apply(
              t.whenData,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'maybeWhen': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AsyncValue;
            return Function.apply(
              t.maybeWhen,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'when': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AsyncValue;
            return Function.apply(
              t.when,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'whenOrNull': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AsyncValue;
            return Function.apply(
              t.whenOrNull,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'maybeMap': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AsyncValue;
            return Function.apply(
              t.maybeMap,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'mapOrNull': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AsyncValue;
            return Function.apply(
              t.mapOrNull,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'unwrapPrevious': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_6.AsyncValue;
            return Function.apply(
              t.unwrapPrevious,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'ProviderContainerParents',
        onTypeName: 'ProviderContainer',
        getters: {
          'parents': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).parents,
          'id': (visitor, target) =>
              (target as $riverpod_6.ProviderContainer).id,
        },
      ),
      BridgedExtensionDefinition(
        name: 'OrX',
        onTypeName: 'FutureOr',
        methods: {
          'then': (visitor, target, positional, named, typeArgs) {
            final t = target as FutureOr;
            return Function.apply(
              t.then,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'StringX',
        onTypeName: 'String',
        methods: {
          'indent': (visitor, target, positional, named, typeArgs) {
            final t = target as String;
            return Function.apply(
              t.indent,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'indentAfterFirstLine':
              (visitor, target, positional, named, typeArgs) {
                final t = target as String;
                return Function.apply(
                  t.indentAfterFirstLine,
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
      'ProviderExceptionX@ProviderException':
          'package:riverpod/src/common/stack_trace.dart',
      'ProviderListenableSelect@ProviderListenable':
          'package:riverpod/src/framework.dart',
      'NotifierPersistX@AnyNotifier': 'package:riverpod/src/framework.dart',
      'InternalProviderContainer@ProviderContainer':
          'package:riverpod/src/framework.dart',
      'ContainerReadElement@ProviderContainer':
          'package:riverpod/src/framework.dart',
      'ProviderContainerTest@ProviderContainer':
          'package:riverpod/src/framework.dart',
      'ProviderSubImpl@ProviderSubscription':
          'package:riverpod/src/framework.dart',
      'ProviderSubX@ProviderSubscription':
          'package:riverpod/src/framework.dart',
      'AsyncTransition@AsyncValue': 'package:riverpod/src/framework.dart',
      'AsyncValueInternals@AsyncValue': 'package:riverpod/src/framework.dart',
      'AsyncValueExtensions@AsyncValue': 'package:riverpod/src/framework.dart',
      'ProviderContainerParents@ProviderContainer':
          'package:riverpod/src/framework.dart',
      'OrX@FutureOr': 'package:riverpod/src/common/tenable.dart',
      'StringX@String': 'package:riverpod/src/common/string.dart',
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
        source: 'package:riverpod_kit/riverpod_kit.dart',
        target: 'package:riverpod_kit/src/consumer.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod_kit/riverpod_kit.dart',
        target: 'package:riverpod_kit/src/provider_scope.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod_kit/riverpod_kit.dart',
        target: 'package:riverpod_kit/src/widget_ref.dart',
        show: {'WidgetRef'},
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:state_notifier/state_notifier.dart',
        show: {'StateNotifier'},
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/builder.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/common/internal_lints.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/common/listenable.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/common/result.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/common/stack_trace.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/core/persist.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/framework.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/providers/async_notifier.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/providers/future_provider.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/providers/legacy/state_controller.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target:
            'package:riverpod/src/providers/legacy/state_notifier_provider.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/providers/legacy/state_provider.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/providers/notifier.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/providers/provider.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/providers/stream_notifier.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/_internals.dart',
        target: 'package:riverpod/src/providers/stream_provider.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/src/internals.dart',
        target: 'package:riverpod/src/_internals.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:riverpod/riverpod.dart',
        target: 'package:riverpod/src/internals.dart',
        show: {
          'AsyncValue',
          'AsyncData',
          'AsyncLoading',
          'AsyncError',
          'ProviderContainer',
          'ProviderReference',
          'ProviderObserverContext',
          'ProviderObserver',
          'ProviderSubscription',
          'Ref',
          'AnyNotifier',
          'AsyncNotifier',
          'AsyncNotifierProvider',
          'FutureProvider',
          'Notifier',
          'NotifierProvider',
          'Provider',
          'StreamNotifier',
          'StreamNotifierProvider',
          'StreamProvider',
          'ProviderListenableSelect',
          'AsyncResult',
          'AsyncValueExtensions',
          'AsyncValueIsLoadingException',
        },
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

    // Register global variables
    registerGlobalVariables(interpreter, importPath);

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
        'debugTrackProviderCreation',
        $riverpod_6.debugTrackProviderCreation,
        importPath,
        sourceUri: 'package:riverpod/src/framework.dart',
      );
    } catch (e) {
      errors.add(
        'Failed to register variable "debugTrackProviderCreation": $e',
      );
    }

    if (errors.isNotEmpty) {
      throw StateError(
        'Bridge registration errors (riverpod_kit):\n${errors.join("\n")}',
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
      'package:riverpod/src/common/stack_trace.dart',
      'package:riverpod/src/core/persist.dart',
      'package:riverpod/src/framework.dart',
      'package:riverpod/src/providers/async_notifier.dart',
      'package:riverpod/src/providers/future_provider.dart',
      'package:riverpod/src/providers/legacy/state_controller.dart',
      'package:riverpod/src/providers/legacy/state_notifier_provider.dart',
      'package:riverpod/src/providers/legacy/state_provider.dart',
      'package:riverpod/src/providers/notifier.dart',
      'package:riverpod/src/providers/provider.dart',
      'package:riverpod/src/providers/stream_notifier.dart',
      'package:riverpod/src/providers/stream_provider.dart',
      'package:riverpod_kit/src/consumer.dart',
      'package:riverpod_kit/src/provider_scope.dart',
      'package:riverpod_kit/src/widget_ref.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    final imports = StringBuffer();
    imports.writeln("import 'package:riverpod_kit/riverpod_kit.dart';");
    imports.writeln("import 'package:riverpod/riverpod.dart';");
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
      'package:riverpod/riverpod.dart',
    ];
  }
}

// =============================================================================
// ProviderException Bridge
// =============================================================================

BridgedClass _createProviderExceptionBridge() {
  return BridgedClass(
    nativeType: $riverpod_2.ProviderException,
    name: 'ProviderException',
    isAssignable: (v) => v is $riverpod_2.ProviderException,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'exception': (visitor, target) => D4
          .validateTarget<$riverpod_2.ProviderException>(
            target,
            'ProviderException',
          )
          .exception,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_2.ProviderException>(
            target,
            'ProviderException',
          )
          .stackTrace,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_2.ProviderException>(
          target,
          'ProviderException',
        );
        return t.toString();
      },
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'exception': 'Object get exception',
      'stackTrace': 'StackTrace get stackTrace',
    },
  );
}

// =============================================================================
// StorageOptions Bridge
// =============================================================================

BridgedClass _createStorageOptionsBridge() {
  return BridgedClass(
    nativeType: $riverpod_5.StorageOptions,
    name: 'StorageOptions',
    isAssignable: (v) => v is $riverpod_5.StorageOptions,
    constructors: {
      '': (visitor, positional, named) {
        final destroyKey = D4.getOptionalNamedArg<String?>(named, 'destroyKey');
        final cacheTime = D4
            .getNamedArgWithDefault<$riverpod_5.StorageCacheTime>(
              named,
              'cacheTime',
              const $riverpod_5.StorageCacheTime(Duration(days: 2)),
            );
        return $riverpod_5.StorageOptions(
          destroyKey: destroyKey,
          cacheTime: cacheTime,
        );
      },
    },
    getters: {
      'destroyKey': (visitor, target) => D4
          .validateTarget<$riverpod_5.StorageOptions>(target, 'StorageOptions')
          .destroyKey,
      'cacheTime': (visitor, target) => D4
          .validateTarget<$riverpod_5.StorageOptions>(target, 'StorageOptions')
          .cacheTime,
    },
    constructorSignatures: {
      '': 'const StorageOptions({String? destroyKey, StorageCacheTime cacheTime = const StorageCacheTime(Duration(days: 2))})',
    },
    getterSignatures: {
      'destroyKey': 'String? get destroyKey',
      'cacheTime': 'StorageCacheTime get cacheTime',
    },
  );
}

// =============================================================================
// PersistedData Bridge
// =============================================================================

BridgedClass _createPersistedDataBridge() {
  return BridgedClass(
    nativeType: $riverpod_5.PersistedData,
    name: 'PersistedData',
    isAssignable: (v) => v is $riverpod_5.PersistedData,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'PersistedData');
        final data = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'data',
          'PersistedData',
        );
        final destroyKey = D4.getOptionalNamedArg<String?>(named, 'destroyKey');
        final expireAt = D4.getOptionalNamedArg<DateTime?>(named, 'expireAt');
        // GEN-075: Preserve generic type parameter from runtime value
        switch (data) {
          case double _:
            return $riverpod_5.PersistedData<double>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case int _:
            return $riverpod_5.PersistedData<int>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case String _:
            return $riverpod_5.PersistedData<String>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case bool _:
            return $riverpod_5.PersistedData<bool>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_7.AsyncNotifierProvider _:
            return $riverpod_5.PersistedData<$riverpod_7.AsyncNotifierProvider>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_8.FutureProvider _:
            return $riverpod_5.PersistedData<$riverpod_8.FutureProvider>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_14.StreamNotifierProvider _:
            return $riverpod_5.PersistedData<
              $riverpod_14.StreamNotifierProvider
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_15.StreamProvider _:
            return $riverpod_5.PersistedData<$riverpod_15.StreamProvider>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_7.$AsyncNotifierProvider _:
            return $riverpod_5.PersistedData<
              $riverpod_7.$AsyncNotifierProvider
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_14.$StreamNotifierProvider _:
            return $riverpod_5.PersistedData<
              $riverpod_14.$StreamNotifierProvider
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_12.NotifierProvider _:
            return $riverpod_5.PersistedData<$riverpod_12.NotifierProvider>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_13.Provider _:
            return $riverpod_5.PersistedData<$riverpod_13.Provider>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_10.StateNotifierProvider _:
            return $riverpod_5.PersistedData<
              $riverpod_10.StateNotifierProvider
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_11.StateProvider _:
            return $riverpod_5.PersistedData<$riverpod_11.StateProvider>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_12.$NotifierProvider _:
            return $riverpod_5.PersistedData<$riverpod_12.$NotifierProvider>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_7.AsyncNotifierProviderFamily _:
            return $riverpod_5.PersistedData<
              $riverpod_7.AsyncNotifierProviderFamily
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_8.FutureProviderFamily _:
            return $riverpod_5.PersistedData<$riverpod_8.FutureProviderFamily>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_12.NotifierProviderFamily _:
            return $riverpod_5.PersistedData<
              $riverpod_12.NotifierProviderFamily
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_13.ProviderFamily _:
            return $riverpod_5.PersistedData<$riverpod_13.ProviderFamily>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_10.StateNotifierProviderFamily _:
            return $riverpod_5.PersistedData<
              $riverpod_10.StateNotifierProviderFamily
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_11.StateProviderFamily _:
            return $riverpod_5.PersistedData<$riverpod_11.StateProviderFamily>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_14.StreamNotifierProviderFamily _:
            return $riverpod_5.PersistedData<
              $riverpod_14.StreamNotifierProviderFamily
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_15.StreamProviderFamily _:
            return $riverpod_5.PersistedData<$riverpod_15.StreamProviderFamily>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.ProviderBase _:
            return $riverpod_5.PersistedData<$riverpod_6.ProviderBase>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_7.AsyncNotifier _:
            return $riverpod_5.PersistedData<$riverpod_7.AsyncNotifier>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.Family _:
            return $riverpod_5.PersistedData<$riverpod_6.Family>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_14.StreamNotifier _:
            return $riverpod_5.PersistedData<$riverpod_14.StreamNotifier>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_7.$AsyncNotifier _:
            return $riverpod_5.PersistedData<$riverpod_7.$AsyncNotifier>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_14.$StreamNotifier _:
            return $riverpod_5.PersistedData<$riverpod_14.$StreamNotifier>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_12.Notifier _:
            return $riverpod_5.PersistedData<$riverpod_12.Notifier>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.SyncProviderTransformerMixin _:
            return $riverpod_5.PersistedData<
              $riverpod_6.SyncProviderTransformerMixin
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_12.$Notifier _:
            return $riverpod_5.PersistedData<$riverpod_12.$Notifier>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.$ProviderOverride _:
            return $riverpod_5.PersistedData<$riverpod_6.$ProviderOverride>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.AsyncData _:
            return $riverpod_5.PersistedData<$riverpod_6.AsyncData>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.AsyncError _:
            return $riverpod_5.PersistedData<$riverpod_6.AsyncError>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.AsyncProviderListenable _:
            return $riverpod_5.PersistedData<
              $riverpod_6.AsyncProviderListenable
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_kit_1.Consumer _:
            return $riverpod_5.PersistedData<$riverpod_kit_1.Consumer>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.Mutation _:
            return $riverpod_5.PersistedData<$riverpod_6.Mutation>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.Ref _:
            return $riverpod_5.PersistedData<$riverpod_6.Ref>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.Refreshable _:
            return $riverpod_5.PersistedData<$riverpod_6.Refreshable>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.AsyncLoading _:
            return $riverpod_5.PersistedData<$riverpod_6.AsyncLoading>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.AsyncValueIsLoadingException _:
            return $riverpod_5.PersistedData<
              $riverpod_6.AsyncValueIsLoadingException
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_kit_1.ConsumerWidget _:
            return $riverpod_5.PersistedData<$riverpod_kit_1.ConsumerWidget>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.DevtoolObserver _:
            return $riverpod_5.PersistedData<$riverpod_6.DevtoolObserver>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.MutationError _:
            return $riverpod_5.PersistedData<$riverpod_6.MutationError>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.MutationIdle _:
            return $riverpod_5.PersistedData<$riverpod_6.MutationIdle>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.MutationPending _:
            return $riverpod_5.PersistedData<$riverpod_6.MutationPending>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.MutationSuccess _:
            return $riverpod_5.PersistedData<$riverpod_6.MutationSuccess>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.ProviderContainer _:
            return $riverpod_5.PersistedData<$riverpod_6.ProviderContainer>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_2.ProviderException _:
            return $riverpod_5.PersistedData<$riverpod_2.ProviderException>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.ProviderListenable _:
            return $riverpod_5.PersistedData<$riverpod_6.ProviderListenable>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_9.StateController _:
            return $riverpod_5.PersistedData<$riverpod_9.StateController>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.AnyNotifier _:
            return $riverpod_5.PersistedData<$riverpod_6.AnyNotifier>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_kit_1.ConsumerState _:
            return $riverpod_5.PersistedData<$riverpod_kit_1.ConsumerState>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_kit_1.ConsumerStatefulWidget _:
            return $riverpod_5.PersistedData<
              $riverpod_kit_1.ConsumerStatefulWidget
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_6.KeepAliveLink _:
            return $riverpod_5.PersistedData<$riverpod_6.KeepAliveLink>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.MutationTarget _:
            return $riverpod_5.PersistedData<$riverpod_6.MutationTarget>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.MutationTransaction _:
            return $riverpod_5.PersistedData<$riverpod_6.MutationTransaction>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.Override _:
            return $riverpod_5.PersistedData<$riverpod_6.Override>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.PersistResult _:
            return $riverpod_5.PersistedData<$riverpod_6.PersistResult>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.ProviderListenableOrFamily _:
            return $riverpod_5.PersistedData<
              $riverpod_6.ProviderListenableOrFamily
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_6.ProviderObserver _:
            return $riverpod_5.PersistedData<$riverpod_6.ProviderObserver>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.ProviderObserverContext _:
            return $riverpod_5.PersistedData<
              $riverpod_6.ProviderObserverContext
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_6.ProviderReference _:
            return $riverpod_5.PersistedData<$riverpod_6.ProviderReference>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_kit_2.ProviderScope _:
            return $riverpod_5.PersistedData<$riverpod_kit_2.ProviderScope>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.ProviderSubscription _:
            return $riverpod_5.PersistedData<$riverpod_6.ProviderSubscription>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.ProviderTransformer _:
            return $riverpod_5.PersistedData<$riverpod_6.ProviderTransformer>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_6.ProviderTransformerContext _:
            return $riverpod_5.PersistedData<
              $riverpod_6.ProviderTransformerContext
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_kit_2.RootRegistration _:
            return $riverpod_5.PersistedData<$riverpod_kit_2.RootRegistration>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_5.Storage _:
            return $riverpod_5.PersistedData<$riverpod_5.Storage>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_5.StorageCacheTime _:
            return $riverpod_5.PersistedData<$riverpod_5.StorageCacheTime>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_5.StorageOptions _:
            return $riverpod_5.PersistedData<$riverpod_5.StorageOptions>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          case $riverpod_kit_2.UncontrolledProviderScope _:
            return $riverpod_5.PersistedData<
              $riverpod_kit_2.UncontrolledProviderScope
            >(data, destroyKey: destroyKey, expireAt: expireAt);
          case $riverpod_kit_3.WidgetRef _:
            return $riverpod_5.PersistedData<$riverpod_kit_3.WidgetRef>(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
          default:
            return $riverpod_5.PersistedData(
              data,
              destroyKey: destroyKey,
              expireAt: expireAt,
            );
        }
      },
    },
    getters: {
      'data': (visitor, target) => D4
          .validateTarget<$riverpod_5.PersistedData>(target, 'PersistedData')
          .data,
      'destroyKey': (visitor, target) => D4
          .validateTarget<$riverpod_5.PersistedData>(target, 'PersistedData')
          .destroyKey,
      'expireAt': (visitor, target) => D4
          .validateTarget<$riverpod_5.PersistedData>(target, 'PersistedData')
          .expireAt,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_5.PersistedData>(target, 'PersistedData')
          .hashCode,
    },
    methods: {
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.PersistedData>(
          target,
          'PersistedData',
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
      '': 'const PersistedData(DataT data, {String? destroyKey, DateTime? expireAt})',
    },
    getterSignatures: {
      'data': 'DataT get data',
      'destroyKey': 'String? get destroyKey',
      'expireAt': 'DateTime? get expireAt',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// Storage Bridge
// =============================================================================

BridgedClass _createStorageBridge() {
  return BridgedClass(
    nativeType: $riverpod_5.Storage,
    name: 'Storage',
    isAssignable: (v) => v is $riverpod_5.Storage,
    isAbstract: true,
    constructors: {
      'inMemory': (visitor, positional, named) {
        return $riverpod_5.Storage.inMemory();
      },
    },
    methods: {
      'deleteOutOfDate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Storage>(target, 'Storage');
        t.deleteOutOfDate();
        return null;
      },
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Storage>(target, 'Storage');
        D4.requireMinArgs(positional, 1, 'read');
        final key = D4.getRequiredArg<Object?>(positional, 0, 'key', 'read');
        return t.read(key);
      },
      'write': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Storage>(target, 'Storage');
        D4.requireMinArgs(positional, 3, 'write');
        final key = D4.getRequiredArg<Object?>(positional, 0, 'key', 'write');
        final value = D4.getRequiredArg<Object?>(
          positional,
          1,
          'value',
          'write',
        );
        final options = D4.getRequiredArg<$riverpod_5.StorageOptions>(
          positional,
          2,
          'options',
          'write',
        );
        return t.write(key, value, options);
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Storage>(target, 'Storage');
        D4.requireMinArgs(positional, 1, 'delete');
        final key = D4.getRequiredArg<Object?>(positional, 0, 'key', 'delete');
        return t.delete(key);
      },
    },
    constructorSignatures: {
      'inMemory': 'factory Storage.inMemory()',
    },
    methodSignatures: {
      'deleteOutOfDate': 'void deleteOutOfDate()',
      'read': 'FutureOr<PersistedData<EncodedT>?> read(KeyT key)',
      'write':
          'FutureOr<void> write(KeyT key, EncodedT value, StorageOptions options)',
      'delete': 'FutureOr<void> delete(KeyT key)',
    },
  );
}

// =============================================================================
// StorageCacheTime Bridge
// =============================================================================

BridgedClass _createStorageCacheTimeBridge() {
  return BridgedClass(
    nativeType: $riverpod_5.StorageCacheTime,
    name: 'StorageCacheTime',
    isAssignable: (v) => v is $riverpod_5.StorageCacheTime,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'StorageCacheTime');
        final duration = D4.getRequiredArg<Duration>(
          positional,
          0,
          'duration',
          'StorageCacheTime',
        );
        return $riverpod_5.StorageCacheTime(duration);
      },
    },
    getters: {
      'duration': (visitor, target) => D4
          .validateTarget<$riverpod_5.StorageCacheTime>(
            target,
            'StorageCacheTime',
          )
          .duration,
    },
    staticGetters: {
      'unsafe_forever': (visitor) =>
          $riverpod_5.StorageCacheTime.unsafe_forever,
    },
    constructorSignatures: {
      '': 'const StorageCacheTime(Duration duration)',
    },
    getterSignatures: {
      'duration': 'Duration? get duration',
    },
    staticGetterSignatures: {
      'unsafe_forever': 'StorageCacheTime get unsafe_forever',
    },
  );
}

// =============================================================================
// Refreshable Bridge
// =============================================================================

BridgedClass _createRefreshableBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.Refreshable,
    name: 'Refreshable',
    isAssignable: (v) => v is $riverpod_6.Refreshable,
    hierarchyDepth: 2,
    constructors: {},
  );
}

// =============================================================================
// Family Bridge
// =============================================================================

BridgedClass _createFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.Family,
    name: 'Family',
    isAssignable: (v) => v is $riverpod_6.Family,
    hierarchyDepth: 4,
    constructors: {},
    getters: {
      'name': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Family>(target, 'Family').name,
      'retry': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Family>(target, 'Family').retry,
      'dependencies': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Family>(target, 'Family').dependencies,
      'isAutoDispose': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Family>(target, 'Family').isAutoDispose,
      'from': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Family>(target, 'Family').from,
      'origin': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Family>(target, 'Family').origin,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_6.Family>(target, 'Family')
          .$allTransitiveDependencies,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Family>(target, 'Family');
        return t.toString();
      },
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'from': 'Family get from',
      'origin': 'Family get origin',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
    },
  );
}

// =============================================================================
// ProviderListenableOrFamily Bridge
// =============================================================================

BridgedClass _createProviderListenableOrFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderListenableOrFamily,
    name: 'ProviderListenableOrFamily',
    isAssignable: (v) => v is $riverpod_6.ProviderListenableOrFamily,
    constructors: {
      '': (visitor, positional, named) {
        return $riverpod_6.ProviderListenableOrFamily();
      },
    },
    constructorSignatures: {
      '': 'ProviderListenableOrFamily()',
    },
  );
}

// =============================================================================
// ProviderOrFamily Bridge
// =============================================================================

BridgedClass _createProviderOrFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderOrFamily,
    name: 'ProviderOrFamily',
    isAssignable: (v) => v is $riverpod_6.ProviderOrFamily,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderOrFamily>(
            target,
            'ProviderOrFamily',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderOrFamily>(
            target,
            'ProviderOrFamily',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderOrFamily>(
            target,
            'ProviderOrFamily',
          )
          .dependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderOrFamily>(
            target,
            'ProviderOrFamily',
          )
          .isAutoDispose,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderOrFamily>(
            target,
            'ProviderOrFamily',
          )
          .from,
    },
    getterSignatures: {
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'from': 'Family? get from',
    },
  );
}

// =============================================================================
// ProviderListenable Bridge
// =============================================================================

BridgedClass _createProviderListenableBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderListenable,
    name: 'ProviderListenable',
    isAssignable: (v) => v is $riverpod_6.ProviderListenable,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
  );
}

// =============================================================================
// AsyncProviderListenable Bridge
// =============================================================================

BridgedClass _createAsyncProviderListenableBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.AsyncProviderListenable,
    name: 'AsyncProviderListenable',
    isAssignable: (v) => v is $riverpod_6.AsyncProviderListenable,
    hierarchyDepth: 2,
    isAbstract: true,
    constructors: {},
    getters: {
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncProviderListenable>(
            target,
            'AsyncProviderListenable',
          )
          .future,
    },
    getterSignatures: {
      'future': 'Refreshable<Future<ValueT>> get future',
    },
  );
}

// =============================================================================
// Override Bridge
// =============================================================================

BridgedClass _createOverrideBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.Override,
    name: 'Override',
    isAssignable: (v) => v is $riverpod_6.Override,
    constructors: {},
    getters: {
      'origin': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Override>(target, 'Override').origin,
    },
    getterSignatures: {
      'origin': 'Override get origin',
    },
  );
}

// =============================================================================
// $ProviderOverride Bridge
// =============================================================================

BridgedClass _create$ProviderOverrideBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.$ProviderOverride,
    name: '\$ProviderOverride',
    isAssignable: (v) => v is $riverpod_6.$ProviderOverride,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final origin = D4
            .getRequiredNamedArg<$riverpod_6.ProviderBase<Object?>>(
              named,
              'origin',
              '\$ProviderOverride',
            );
        final providerOverride = D4
            .getRequiredNamedArg<$riverpod_6.ProviderBase<Object?>>(
              named,
              'providerOverride',
              '\$ProviderOverride',
            );
        return $riverpod_6.$ProviderOverride(
          origin: origin,
          providerOverride: providerOverride,
        );
      },
    },
    getters: {
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_6.$ProviderOverride>(
            target,
            '\$ProviderOverride',
          )
          .origin,
      'providerOverride': (visitor, target) => D4
          .validateTarget<$riverpod_6.$ProviderOverride>(
            target,
            '\$ProviderOverride',
          )
          .providerOverride,
    },
    constructorSignatures: {
      '': '\$ProviderOverride({required ProviderBase<Object?> origin, required ProviderBase<Object?> providerOverride})',
    },
    getterSignatures: {
      'origin': 'ProviderBase<Object?> get origin',
      'providerOverride': 'ProviderBase<Object?> get providerOverride',
    },
  );
}

// =============================================================================
// AnyNotifier Bridge
// =============================================================================

BridgedClass _createAnyNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.AnyNotifier,
    name: 'AnyNotifier',
    isAssignable: (v) => v is $riverpod_6.AnyNotifier,
    isAbstract: true,
    constructors: {},
    getters: {
      'ref': (visitor, target) =>
          D4.validateTarget<$riverpod_6.AnyNotifier>(target, 'AnyNotifier').ref,
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_6.AnyNotifier>(target, 'AnyNotifier')
          .state,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
                  .validateTarget<$riverpod_6.AnyNotifier>(
                    target,
                    'AnyNotifier',
                  )
                  .state =
              value as dynamic,
    },
    methods: {
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AnyNotifier>(
          target,
          'AnyNotifier',
        );
        D4.requireMinArgs(positional, 1, 'listenSelf');
        if (positional.isEmpty) {
          throw ArgumentError(
            'listenSelf: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).listenSelf(
          (dynamic p0, dynamic p1) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
        );
      },
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AnyNotifier>(
          target,
          'AnyNotifier',
        );
        return t.runBuild();
      },
    },
    methodSignatures: {
      'listenSelf':
          'RemoveListener listenSelf(void Function(StateT? previous, StateT next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
      'runBuild': 'WhenComplete? runBuild()',
    },
    getterSignatures: {
      'ref': 'Ref get ref',
      'state': 'StateT get state',
    },
    setterSignatures: {
      'state': 'set state(StateT value)',
    },
  );
}

// =============================================================================
// PersistResult Bridge
// =============================================================================

BridgedClass _createPersistResultBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.PersistResult,
    name: 'PersistResult',
    isAssignable: (v) => v is $riverpod_6.PersistResult,
    constructors: {},
    getters: {
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_6.PersistResult>(target, 'PersistResult')
          .future,
    },
    getterSignatures: {
      'future': 'Future<void>? get future',
    },
  );
}

// =============================================================================
// ProviderBase Bridge
// =============================================================================

BridgedClass _createProviderBaseBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderBase,
    name: 'ProviderBase',
    isAssignable: (v) => v is $riverpod_6.ProviderBase,
    hierarchyDepth: 6,
    constructors: {},
    getters: {
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderBase>(target, 'ProviderBase')
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderBase>(target, 'ProviderBase')
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderBase>(target, 'ProviderBase')
          .dependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderBase>(target, 'ProviderBase')
          .isAutoDispose,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderBase>(target, 'ProviderBase')
          .from,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderBase>(target, 'ProviderBase')
          .argument,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderBase>(target, 'ProviderBase')
          .origin,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderBase>(target, 'ProviderBase')
          .$allTransitiveDependencies,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderBase>(
          target,
          'ProviderBase',
        );
        return t.toString();
      },
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'from': 'Family? get from',
      'argument': 'Object? get argument',
      'origin': 'ProviderBase<StateT> get origin',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
    },
  );
}

// =============================================================================
// ProviderTransformerContext Bridge
// =============================================================================

BridgedClass _createProviderTransformerContextBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderTransformerContext,
    name: 'ProviderTransformerContext',
    isAssignable: (v) => v is $riverpod_6.ProviderTransformerContext,
    constructors: {},
    getters: {
      'sourceState': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderTransformerContext>(
            target,
            'ProviderTransformerContext',
          )
          .sourceState,
    },
    getterSignatures: {
      'sourceState': 'AsyncResult<InT> get sourceState',
    },
  );
}

// =============================================================================
// ProviderTransformer Bridge
// =============================================================================

BridgedClass _createProviderTransformerBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderTransformer,
    name: 'ProviderTransformer',
    isAssignable: (v) => v is $riverpod_6.ProviderTransformer,
    constructors: {
      '': (visitor, positional, named) {
        if (!named.containsKey('listener') || named['listener'] == null) {
          throw ArgumentError(
            'ProviderTransformer: Missing required named argument "listener"',
          );
        }
        final listenerRaw = named['listener'];
        if (!named.containsKey('initState') || named['initState'] == null) {
          throw ArgumentError(
            'ProviderTransformer: Missing required named argument "initState"',
          );
        }
        final initStateRaw = named['initState'];
        final onCloseRaw = named['onClose'];
        return $riverpod_6.ProviderTransformer(
          listener:
              (
                $riverpod_6.ProviderTransformer<dynamic, dynamic> p0,
                $riverpod_6.AsyncResult<dynamic> p1,
                $riverpod_6.AsyncResult<dynamic> p2,
              ) {
                D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1, p2]);
              },
          initState: ($riverpod_6.ProviderTransformer<dynamic, dynamic> p0) {
            return D4.castCallbackResult<dynamic>(
              D4.callInterpreterCallback(visitor!, initStateRaw, [p0]),
            );
          },
          onClose: onCloseRaw == null
              ? null
              : () {
                  D4.callInterpreterCallback(visitor!, onCloseRaw, []);
                },
        );
      },
    },
    getters: {
      'onClose': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderTransformer>(
            target,
            'ProviderTransformer',
          )
          .onClose,
      'listener': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderTransformer>(
            target,
            'ProviderTransformer',
          )
          .listener,
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderTransformer>(
            target,
            'ProviderTransformer',
          )
          .state,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
              .validateTarget<$riverpod_6.ProviderTransformer>(
                target,
                'ProviderTransformer',
              )
              .state = D4.extractBridgedArg<$riverpod_6.AsyncResult<dynamic>>(
            value,
            'state',
          ),
    },
    constructorSignatures: {
      '': 'ProviderTransformer({required void Function(ProviderTransformer<InT, ValueT> self, AsyncResult<InT> prev, AsyncResult<InT> next) listener, required ValueT Function(ProviderTransformer<InT, ValueT> self) initState, void Function()? onClose})',
    },
    getterSignatures: {
      'onClose': 'void Function()? get onClose',
      'listener':
          'void Function(ProviderTransformer<InT, ValueT> self, AsyncResult<InT> prev, AsyncResult<InT> next) get listener',
      'state': 'AsyncResult<ValueT> get state',
    },
    setterSignatures: {
      'state': 'set state(AsyncResult<ValueT> value)',
    },
  );
}

// =============================================================================
// ProviderReference Bridge
// =============================================================================

BridgedClass _createProviderReferenceBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderReference,
    name: 'ProviderReference',
    isAssignable: (v) => v is $riverpod_6.ProviderReference,
    constructors: {},
    getters: {
      'provider': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderReference>(
            target,
            'ProviderReference',
          )
          .provider,
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderReference>(
            target,
            'ProviderReference',
          )
          .container,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderReference>(
          target,
          'ProviderReference',
        );
        return t.toString();
      },
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'provider': 'ProviderBase<Object?> get provider',
      'container': 'ProviderContainer get container',
    },
  );
}

// =============================================================================
// ProviderContainer Bridge
// =============================================================================

BridgedClass _createProviderContainerBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderContainer,
    name: 'ProviderContainer',
    isAssignable: (v) => v is $riverpod_6.ProviderContainer,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final parent = D4.getOptionalNamedArg<$riverpod_6.ProviderContainer?>(
          named,
          'parent',
        );
        final overrides =
            named.containsKey('overrides') && named['overrides'] != null
            ? D4.coerceList<$riverpod_6.Override>(
                named['overrides'],
                'overrides',
              )
            : const <$riverpod_6.Override>[];
        final observers = D4.coerceListOrNull<$riverpod_6.ProviderObserver>(
          named['observers'],
          'observers',
        );
        final onErrorRaw = named['onError'];
        final retryRaw = named['retry'];
        return $riverpod_6.ProviderContainer(
          parent: parent,
          overrides: overrides,
          observers: observers,
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
      'test': (visitor, positional, named) {
        final parent = D4.getOptionalNamedArg<$riverpod_6.ProviderContainer?>(
          named,
          'parent',
        );
        final overrides =
            named.containsKey('overrides') && named['overrides'] != null
            ? D4.coerceList<$riverpod_6.Override>(
                named['overrides'],
                'overrides',
              )
            : const <$riverpod_6.Override>[];
        final observers = D4.coerceListOrNull<$riverpod_6.ProviderObserver>(
          named['observers'],
          'observers',
        );
        final retryRaw = named['retry'];
        return $riverpod_6.ProviderContainer.test(
          parent: parent,
          overrides: overrides,
          observers: observers,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderContainer>(
            target,
            'ProviderContainer',
          )
          .retry,
      'observers': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderContainer>(
            target,
            'ProviderContainer',
          )
          .observers,
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderContainer>(
            target,
            'ProviderContainer',
          )
          .container,
    },
    methods: {
      'pump': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        return t.pump();
      },
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'read');
        final provider = D4
            .getRequiredArg<$riverpod_6.ProviderListenable<dynamic>>(
              positional,
              0,
              'provider',
              'read',
            );
        return _unwrapInterpretedProxy(t.read(provider));
      },
      'exists': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'exists');
        final provider = D4.getRequiredArg<$riverpod_6.ProviderBase<Object?>>(
          positional,
          0,
          'provider',
          'exists',
        );
        return t.exists(provider);
      },
      'allProviders': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        final family = D4.getOptionalNamedArg<$riverpod_6.Family?>(
          named,
          'family',
        );
        return t.allProviders(family: family);
      },
      'debugReassemble': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        t.debugReassemble();
        return null;
      },
      'listen': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 2, 'listen');
        final provider = D4
            .getRequiredArg<$riverpod_6.ProviderListenable<dynamic>>(
              positional,
              0,
              'provider',
              'listen',
            );
        if (positional.length <= 1) {
          throw ArgumentError(
            'listen: Missing required argument "listener" at position 1',
          );
        }
        final listenerRaw = positional[1];
        final fireImmediately = D4.getNamedArgWithDefault<bool>(
          named,
          'fireImmediately',
          false,
        );
        final weak = D4.getNamedArgWithDefault<bool>(named, 'weak', false);
        final onErrorRaw = named['onError'];
        return t.listen<Object?>(
          provider,
          (dynamic p0, dynamic p1) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          fireImmediately: fireImmediately,
          weak: weak,
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
        );
      },
      'invalidate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'invalidate');
        final provider = D4.getRequiredArg<$riverpod_6.ProviderOrFamily>(
          positional,
          0,
          'provider',
          'invalidate',
        );
        final asReload = D4.getNamedArgWithDefault<bool>(
          named,
          'asReload',
          false,
        );
        t.invalidate(provider, asReload: asReload);
        return null;
      },
      'refresh': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'refresh');
        final refreshable = D4.getRequiredArg<$riverpod_6.Refreshable<dynamic>>(
          positional,
          0,
          'refreshable',
          'refresh',
        );
        return t.refresh(refreshable);
      },
      'updateOverrides': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'updateOverrides');
        if (positional.isEmpty) {
          throw ArgumentError(
            'updateOverrides: Missing required argument "overrides" at position 0',
          );
        }
        final overrides = D4.coerceList<$riverpod_6.Override>(
          positional[0],
          'overrides',
        );
        t.updateOverrides(overrides);
        return null;
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        (t as dynamic).dispose();
        return null;
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        return t.toString();
      },
    },
    staticMethods: {
      'defaultRetry': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'defaultRetry');
        final retryCount = D4.getRequiredArg<int>(
          positional,
          0,
          'retryCount',
          'defaultRetry',
        );
        final error = D4.getRequiredArg<Object>(
          positional,
          1,
          'error',
          'defaultRetry',
        );
        final maxRetries = D4.getNamedArgWithDefault<int>(
          named,
          'maxRetries',
          10,
        );
        final maxDelay = D4.getNamedArgWithDefault<Duration>(
          named,
          'maxDelay',
          const Duration(milliseconds: 6400),
        );
        final minDelay = D4.getNamedArgWithDefault<Duration>(
          named,
          'minDelay',
          const Duration(milliseconds: 200),
        );
        return $riverpod_6.ProviderContainer.defaultRetry(
          retryCount,
          error,
          maxRetries: maxRetries,
          maxDelay: maxDelay,
          minDelay: minDelay,
        );
      },
    },
    constructorSignatures: {
      '': 'ProviderContainer({ProviderContainer? parent, List<Override> overrides = const [], List<ProviderObserver>? observers, void Function(Object error, StackTrace stackTrace)? onError, Retry? retry})',
      'test':
          'factory ProviderContainer.test({ProviderContainer? parent, List<Override> overrides = const [], List<ProviderObserver>? observers, Retry? retry})',
    },
    methodSignatures: {
      'pump': 'Future<void> pump()',
      'read': 'StateT read(ProviderListenable<StateT> provider)',
      'exists': 'bool exists(ProviderBase<Object?> provider)',
      'allProviders':
          'Iterable<ProviderReference> allProviders({Family? family})',
      'debugReassemble': 'void debugReassemble()',
      'listen':
          'ProviderSubscription<StateT> listen(ProviderListenable<StateT> provider, void Function(StateT? previous, StateT next) listener, {bool fireImmediately = false, bool weak = false, void Function(Object error, StackTrace stackTrace)? onError})',
      'invalidate':
          'void invalidate(ProviderOrFamily provider, {bool asReload = false})',
      'refresh': 'StateT refresh(Refreshable<StateT> refreshable)',
      'updateOverrides': 'void updateOverrides(List<Override> overrides)',
      'dispose': 'void dispose()',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'retry': 'Retry? get retry',
      'observers': 'List<ProviderObserver> get observers',
      'container': 'ProviderContainer get container',
    },
    staticMethodSignatures: {
      'defaultRetry':
          'Duration? defaultRetry(int retryCount, Object error, {int maxRetries = 10, Duration maxDelay = const Duration(milliseconds: 6400), Duration minDelay = const Duration(milliseconds: 200)})',
    },
  );
}

// =============================================================================
// ProviderObserverContext Bridge
// =============================================================================

BridgedClass _createProviderObserverContextBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderObserverContext,
    name: 'ProviderObserverContext',
    isAssignable: (v) => v is $riverpod_6.ProviderObserverContext,
    constructors: {},
    getters: {
      'provider': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderObserverContext>(
            target,
            'ProviderObserverContext',
          )
          .provider,
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderObserverContext>(
            target,
            'ProviderObserverContext',
          )
          .container,
      'mutation': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderObserverContext>(
            target,
            'ProviderObserverContext',
          )
          .mutation,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserverContext>(
          target,
          'ProviderObserverContext',
        );
        return t.toString();
      },
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'provider': 'ProviderBase<Object?> get provider',
      'container': 'ProviderContainer get container',
      'mutation': 'Mutation<Object?>? get mutation',
    },
  );
}

// =============================================================================
// ProviderObserver Bridge
// =============================================================================

BridgedClass _createProviderObserverBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderObserver,
    name: 'ProviderObserver',
    isAssignable: (v) => v is $riverpod_6.ProviderObserver,
    isAbstract: true,
    constructors: {},
    methods: {
      'didCreateProviderContainer':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
              target,
              'ProviderObserver',
            );
            D4.requireMinArgs(positional, 1, 'didCreateProviderContainer');
            final container = D4.getRequiredArg<$riverpod_6.ProviderContainer>(
              positional,
              0,
              'container',
              'didCreateProviderContainer',
            );
            t.didCreateProviderContainer(container);
            return null;
          },
      'didDisposeProviderContainer':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
              target,
              'ProviderObserver',
            );
            D4.requireMinArgs(positional, 1, 'didDisposeProviderContainer');
            final container = D4.getRequiredArg<$riverpod_6.ProviderContainer>(
              positional,
              0,
              'container',
              'didDisposeProviderContainer',
            );
            t.didDisposeProviderContainer(container);
            return null;
          },
      'didAddProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 2, 'didAddProvider');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didAddProvider',
        );
        final value = D4.getRequiredArg<Object?>(
          positional,
          1,
          'value',
          'didAddProvider',
        );
        t.didAddProvider(context, value);
        return null;
      },
      'providerDidFail': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 3, 'providerDidFail');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'providerDidFail',
        );
        final error = D4.getRequiredArg<Object>(
          positional,
          1,
          'error',
          'providerDidFail',
        );
        final stackTrace = D4.getRequiredArg<StackTrace>(
          positional,
          2,
          'stackTrace',
          'providerDidFail',
        );
        t.providerDidFail(context, error, stackTrace);
        return null;
      },
      'didUnmountProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 1, 'didUnmountProvider');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didUnmountProvider',
        );
        t.didUnmountProvider(context);
        return null;
      },
      'didUpdateProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 3, 'didUpdateProvider');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didUpdateProvider',
        );
        final previousValue = D4.getRequiredArg<Object?>(
          positional,
          1,
          'previousValue',
          'didUpdateProvider',
        );
        final newValue = D4.getRequiredArg<Object?>(
          positional,
          2,
          'newValue',
          'didUpdateProvider',
        );
        t.didUpdateProvider(context, previousValue, newValue);
        return null;
      },
      'didDisposeProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 1, 'didDisposeProvider');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didDisposeProvider',
        );
        t.didDisposeProvider(context);
        return null;
      },
      'mutationReset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 2, 'mutationReset');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationReset',
        );
        final mutation = D4.getRequiredArg<$riverpod_6.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationReset',
        );
        t.mutationReset(context, mutation);
        return null;
      },
      'mutationStart': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 2, 'mutationStart');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationStart',
        );
        final mutation = D4.getRequiredArg<$riverpod_6.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationStart',
        );
        t.mutationStart(context, mutation);
        return null;
      },
      'mutationError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 4, 'mutationError');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationError',
        );
        final mutation = D4.getRequiredArg<$riverpod_6.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationError',
        );
        final error = D4.getRequiredArg<Object>(
          positional,
          2,
          'error',
          'mutationError',
        );
        final stackTrace = D4.getRequiredArg<StackTrace>(
          positional,
          3,
          'stackTrace',
          'mutationError',
        );
        t.mutationError(context, mutation, error, stackTrace);
        return null;
      },
      'mutationSuccess': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 3, 'mutationSuccess');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationSuccess',
        );
        final mutation = D4.getRequiredArg<$riverpod_6.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationSuccess',
        );
        final result = D4.getRequiredArg<Object?>(
          positional,
          2,
          'result',
          'mutationSuccess',
        );
        t.mutationSuccess(context, mutation, result);
        return null;
      },
    },
    methodSignatures: {
      'didCreateProviderContainer':
          'void didCreateProviderContainer(ProviderContainer container)',
      'didDisposeProviderContainer':
          'void didDisposeProviderContainer(ProviderContainer container)',
      'didAddProvider':
          'void didAddProvider(ProviderObserverContext context, Object? value)',
      'providerDidFail':
          'void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace)',
      'didUnmountProvider':
          'void didUnmountProvider(ProviderObserverContext context)',
      'didUpdateProvider':
          'void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue)',
      'didDisposeProvider':
          'void didDisposeProvider(ProviderObserverContext context)',
      'mutationReset':
          'void mutationReset(ProviderObserverContext context, Mutation<Object?> mutation)',
      'mutationStart':
          'void mutationStart(ProviderObserverContext context, Mutation<Object?> mutation)',
      'mutationError':
          'void mutationError(ProviderObserverContext context, Mutation<Object?> mutation, Object error, StackTrace stackTrace)',
      'mutationSuccess':
          'void mutationSuccess(ProviderObserverContext context, Mutation<Object?> mutation, Object? result)',
    },
  );
}

// =============================================================================
// ProviderSubscription Bridge
// =============================================================================

BridgedClass _createProviderSubscriptionBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.ProviderSubscription,
    name: 'ProviderSubscription',
    isAssignable: (v) => v is $riverpod_6.ProviderSubscription,
    constructors: {},
    getters: {
      'closed': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderSubscription>(
            target,
            'ProviderSubscription',
          )
          .closed,
      'weak': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderSubscription>(
            target,
            'ProviderSubscription',
          )
          .weak,
      'isPaused': (visitor, target) => D4
          .validateTarget<$riverpod_6.ProviderSubscription>(
            target,
            'ProviderSubscription',
          )
          .isPaused,
    },
    methods: {
      'pause': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderSubscription>(
          target,
          'ProviderSubscription',
        );
        t.pause();
        return null;
      },
      'resume': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderSubscription>(
          target,
          'ProviderSubscription',
        );
        t.resume();
        return null;
      },
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderSubscription>(
          target,
          'ProviderSubscription',
        );
        return t.read();
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.ProviderSubscription>(
          target,
          'ProviderSubscription',
        );
        t.close();
        return null;
      },
    },
    methodSignatures: {
      'pause': 'void pause()',
      'resume': 'void resume()',
      'read': 'OutT read()',
      'close': 'void close()',
    },
    getterSignatures: {
      'closed': 'bool get closed',
      'weak': 'bool get weak',
      'isPaused': 'bool get isPaused',
    },
  );
}

// =============================================================================
// MutationTransaction Bridge
// =============================================================================

BridgedClass _createMutationTransactionBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.MutationTransaction,
    name: 'MutationTransaction',
    isAssignable: (v) => v is $riverpod_6.MutationTransaction,
    constructors: {},
    methods: {
      'get': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.MutationTransaction>(
          target,
          'MutationTransaction',
        );
        D4.requireMinArgs(positional, 1, 'get');
        final listenable = D4
            .getRequiredArg<$riverpod_6.ProviderListenable<dynamic>>(
              positional,
              0,
              'listenable',
              'get',
            );
        return t.get(listenable);
      },
    },
    methodSignatures: {
      'get': 'StateT get(ProviderListenable<StateT> listenable)',
    },
  );
}

// =============================================================================
// MutationTarget Bridge
// =============================================================================

BridgedClass _createMutationTargetBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.MutationTarget,
    name: 'MutationTarget',
    isAssignable: (v) => v is $riverpod_6.MutationTarget,
    isAbstract: true,
    constructors: {},
    getters: {
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationTarget>(target, 'MutationTarget')
          .container,
    },
    getterSignatures: {
      'container': 'ProviderContainer get container',
    },
  );
}

// =============================================================================
// Mutation Bridge
// =============================================================================

BridgedClass _createMutationBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.Mutation,
    name: 'Mutation',
    isAssignable: (v) => v is $riverpod_6.Mutation,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final label = D4.getOptionalNamedArg<Object?>(named, 'label');
        return $riverpod_6.Mutation(label: label);
      },
    },
    getters: {
      'label': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Mutation>(target, 'Mutation').label,
      'key': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Mutation>(target, 'Mutation').key,
    },
    methods: {
      'call': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Mutation>(target, 'Mutation');
        D4.requireMinArgs(positional, 1, 'call');
        final key = D4.getRequiredArg<Object?>(positional, 0, 'key', 'call');
        return t.call(key);
      },
      'run': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Mutation>(target, 'Mutation');
        D4.requireMinArgs(positional, 2, 'run');
        final target_ = D4.getRequiredArg<$riverpod_6.MutationTarget>(
          positional,
          0,
          'target',
          'run',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'run: Missing required argument "cb" at position 1',
          );
        }
        final cbRaw = positional[1];
        return (t as dynamic).run(
          target_,
          (($riverpod_6.MutationTransaction p0) {
                return Future.value(
                  D4.callInterpreterCallback(visitor!, cbRaw, [p0]),
                ).then((v) => v as dynamic);
              })
              as Future<dynamic> Function($riverpod_6.MutationTransaction),
        );
      },
      'reset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Mutation>(target, 'Mutation');
        D4.requireMinArgs(positional, 1, 'reset');
        final container = D4.getRequiredArg<$riverpod_6.MutationTarget>(
          positional,
          0,
          'container',
          'reset',
        );
        t.reset(container);
        return null;
      },
    },
    constructorSignatures: {
      '': 'factory Mutation({Object? label})',
    },
    methodSignatures: {
      'call': 'Mutation<ChangedT> call(Object? key)',
      'run':
          'Future<ResultT> run(MutationTarget target, Future<ResultT> Function(MutationTransaction tsx) cb)',
      'reset': 'void reset(MutationTarget container)',
    },
    getterSignatures: {
      'label': 'Object? get label',
      'key': 'Object? get key',
    },
  );
}

// =============================================================================
// MutationState Bridge
// =============================================================================

BridgedClass _createMutationStateBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.MutationState,
    name: 'MutationState',
    isAssignable: (v) => v is $riverpod_6.MutationState,
    constructors: {},
    getters: {
      'isIdle': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationState>(target, 'MutationState')
          .isIdle,
      'isPending': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationState>(target, 'MutationState')
          .isPending,
      'hasError': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationState>(target, 'MutationState')
          .hasError,
      'isSuccess': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationState>(target, 'MutationState')
          .isSuccess,
    },
    getterSignatures: {
      'isIdle': 'bool get isIdle',
      'isPending': 'bool get isPending',
      'hasError': 'bool get hasError',
      'isSuccess': 'bool get isSuccess',
    },
  );
}

// =============================================================================
// MutationIdle Bridge
// =============================================================================

BridgedClass _createMutationIdleBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.MutationIdle,
    name: 'MutationIdle',
    isAssignable: (v) => v is $riverpod_6.MutationIdle,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'isIdle': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationIdle>(target, 'MutationIdle')
          .isIdle,
      'isPending': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationIdle>(target, 'MutationIdle')
          .isPending,
      'hasError': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationIdle>(target, 'MutationIdle')
          .hasError,
      'isSuccess': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationIdle>(target, 'MutationIdle')
          .isSuccess,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationIdle>(target, 'MutationIdle')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.MutationIdle>(
          target,
          'MutationIdle',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.MutationIdle>(
          target,
          'MutationIdle',
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
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'isIdle': 'bool get isIdle',
      'isPending': 'bool get isPending',
      'hasError': 'bool get hasError',
      'isSuccess': 'bool get isSuccess',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// MutationPending Bridge
// =============================================================================

BridgedClass _createMutationPendingBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.MutationPending,
    name: 'MutationPending',
    isAssignable: (v) => v is $riverpod_6.MutationPending,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'isIdle': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationPending>(
            target,
            'MutationPending',
          )
          .isIdle,
      'isPending': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationPending>(
            target,
            'MutationPending',
          )
          .isPending,
      'hasError': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationPending>(
            target,
            'MutationPending',
          )
          .hasError,
      'isSuccess': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationPending>(
            target,
            'MutationPending',
          )
          .isSuccess,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationPending>(
            target,
            'MutationPending',
          )
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.MutationPending>(
          target,
          'MutationPending',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.MutationPending>(
          target,
          'MutationPending',
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
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'isIdle': 'bool get isIdle',
      'isPending': 'bool get isPending',
      'hasError': 'bool get hasError',
      'isSuccess': 'bool get isSuccess',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// MutationError Bridge
// =============================================================================

BridgedClass _createMutationErrorBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.MutationError,
    name: 'MutationError',
    isAssignable: (v) => v is $riverpod_6.MutationError,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'isIdle': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationError>(target, 'MutationError')
          .isIdle,
      'isPending': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationError>(target, 'MutationError')
          .isPending,
      'hasError': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationError>(target, 'MutationError')
          .hasError,
      'isSuccess': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationError>(target, 'MutationError')
          .isSuccess,
      'error': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationError>(target, 'MutationError')
          .error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationError>(target, 'MutationError')
          .stackTrace,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationError>(target, 'MutationError')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.MutationError>(
          target,
          'MutationError',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.MutationError>(
          target,
          'MutationError',
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
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'isIdle': 'bool get isIdle',
      'isPending': 'bool get isPending',
      'hasError': 'bool get hasError',
      'isSuccess': 'bool get isSuccess',
      'error': 'Object get error',
      'stackTrace': 'StackTrace get stackTrace',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// MutationSuccess Bridge
// =============================================================================

BridgedClass _createMutationSuccessBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.MutationSuccess,
    name: 'MutationSuccess',
    isAssignable: (v) => v is $riverpod_6.MutationSuccess,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'isIdle': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationSuccess>(
            target,
            'MutationSuccess',
          )
          .isIdle,
      'isPending': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationSuccess>(
            target,
            'MutationSuccess',
          )
          .isPending,
      'hasError': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationSuccess>(
            target,
            'MutationSuccess',
          )
          .hasError,
      'isSuccess': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationSuccess>(
            target,
            'MutationSuccess',
          )
          .isSuccess,
      'value': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationSuccess>(
            target,
            'MutationSuccess',
          )
          .value,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.MutationSuccess>(
            target,
            'MutationSuccess',
          )
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.MutationSuccess>(
          target,
          'MutationSuccess',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.MutationSuccess>(
          target,
          'MutationSuccess',
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
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'isIdle': 'bool get isIdle',
      'isPending': 'bool get isPending',
      'hasError': 'bool get hasError',
      'isSuccess': 'bool get isSuccess',
      'value': 'ResultT get value',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// Ref Bridge
// =============================================================================

BridgedClass _createRefBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.Ref,
    name: 'Ref',
    isAssignable: (v) => v is $riverpod_6.Ref,
    hierarchyDepth: 2,
    constructors: {},
    getters: {
      'isFirstBuild': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Ref>(target, 'Ref').isFirstBuild,
      'isReload': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Ref>(target, 'Ref').isReload,
      'isRefresh': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Ref>(target, 'Ref').isRefresh,
      'mounted': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Ref>(target, 'Ref').mounted,
      'isPaused': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Ref>(target, 'Ref').isPaused,
      'container': (visitor, target) =>
          D4.validateTarget<$riverpod_6.Ref>(target, 'Ref').container,
    },
    methods: {
      'keepAlive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        return t.keepAlive();
      },
      'refresh': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'refresh');
        final refreshable = D4.getRequiredArg<$riverpod_6.Refreshable<dynamic>>(
          positional,
          0,
          'refreshable',
          'refresh',
        );
        return t.refresh(refreshable);
      },
      'invalidate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'invalidate');
        final providerOrFamily = D4
            .getRequiredArg<$riverpod_6.ProviderOrFamily>(
              positional,
              0,
              'providerOrFamily',
              'invalidate',
            );
        final asReload = D4.getNamedArgWithDefault<bool>(
          named,
          'asReload',
          false,
        );
        t.invalidate(providerOrFamily, asReload: asReload);
        return null;
      },
      'invalidateSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        final asReload = D4.getNamedArgWithDefault<bool>(
          named,
          'asReload',
          false,
        );
        t.invalidateSelf(asReload: asReload);
        return null;
      },
      'onManualInvalidation': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'onManualInvalidation');
        if (positional.isEmpty) {
          throw ArgumentError(
            'onManualInvalidation: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        return t.onManualInvalidation(() {
          D4.callInterpreterCallback(visitor!, cbRaw, []);
        });
      },
      'notifyListeners': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        t.notifyListeners();
        return null;
      },
      'onAddListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'onAddListener');
        if (positional.isEmpty) {
          throw ArgumentError(
            'onAddListener: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        return t.onAddListener(() {
          D4.callInterpreterCallback(visitor!, cbRaw, []);
        });
      },
      'onRemoveListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'onRemoveListener');
        if (positional.isEmpty) {
          throw ArgumentError(
            'onRemoveListener: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        return t.onRemoveListener(() {
          D4.callInterpreterCallback(visitor!, cbRaw, []);
        });
      },
      'onCancel': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'onCancel');
        if (positional.isEmpty) {
          throw ArgumentError(
            'onCancel: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        return t.onCancel(() {
          D4.callInterpreterCallback(visitor!, cbRaw, []);
        });
      },
      'onResume': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'onResume');
        if (positional.isEmpty) {
          throw ArgumentError(
            'onResume: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        return t.onResume(() {
          D4.callInterpreterCallback(visitor!, cbRaw, []);
        });
      },
      'onDispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'onDispose');
        if (positional.isEmpty) {
          throw ArgumentError(
            'onDispose: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        return t.onDispose(() {
          D4.callInterpreterCallback(visitor!, listenerRaw, []);
        });
      },
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'read');
        final listenable = D4
            .getRequiredArg<$riverpod_6.ProviderListenable<dynamic>>(
              positional,
              0,
              'listenable',
              'read',
            );
        return _unwrapInterpretedProxy(t.read(listenable));
      },
      'exists': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'exists');
        final provider = D4.getRequiredArg<$riverpod_6.ProviderBase<Object?>>(
          positional,
          0,
          'provider',
          'exists',
        );
        return t.exists(provider);
      },
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'watch');
        final listenable = D4
            .getRequiredArg<$riverpod_6.ProviderListenable<dynamic>>(
              positional,
              0,
              'listenable',
              'watch',
            );
        return _unwrapInterpretedProxy(t.watch(listenable));
      },
      'listen': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 2, 'listen');
        final provider = D4
            .getRequiredArg<$riverpod_6.ProviderListenable<dynamic>>(
              positional,
              0,
              'provider',
              'listen',
            );
        if (positional.length <= 1) {
          throw ArgumentError(
            'listen: Missing required argument "listener" at position 1',
          );
        }
        final listenerRaw = positional[1];
        final onErrorRaw = named['onError'];
        final weak = D4.getNamedArgWithDefault<bool>(named, 'weak', false);
        final fireImmediately = D4.getNamedArgWithDefault<bool>(
          named,
          'fireImmediately',
          false,
        );
        return t.listen<Object?>(
          provider,
          (dynamic p0, dynamic p1) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
          weak: weak,
          fireImmediately: fireImmediately,
        );
      },
    },
    methodSignatures: {
      'keepAlive': 'KeepAliveLink keepAlive()',
      'refresh': 'StateT refresh(Refreshable<StateT> refreshable)',
      'invalidate':
          'void invalidate(ProviderOrFamily providerOrFamily, {bool asReload = false})',
      'invalidateSelf': 'void invalidateSelf({bool asReload = false})',
      'onManualInvalidation':
          'RemoveListener onManualInvalidation(void Function() cb)',
      'notifyListeners': 'void notifyListeners()',
      'onAddListener': 'RemoveListener onAddListener(void Function() cb)',
      'onRemoveListener': 'RemoveListener onRemoveListener(void Function() cb)',
      'onCancel': 'RemoveListener onCancel(void Function() cb)',
      'onResume': 'RemoveListener onResume(void Function() cb)',
      'onDispose': 'RemoveListener onDispose(void Function() listener)',
      'read': 'StateT read(ProviderListenable<StateT> listenable)',
      'exists': 'bool exists(ProviderBase<Object?> provider)',
      'watch': 'StateT watch(ProviderListenable<StateT> listenable)',
      'listen':
          'ProviderSubscription<StateT> listen(ProviderListenable<StateT> provider, void Function(StateT? previous, StateT next) listener, {void Function(Object error, StackTrace stackTrace)? onError, bool weak = false, bool fireImmediately = false})',
    },
    getterSignatures: {
      'isFirstBuild': 'bool get isFirstBuild',
      'isReload': 'bool get isReload',
      'isRefresh': 'bool get isRefresh',
      'mounted': 'bool get mounted',
      'isPaused': 'bool get isPaused',
      'container': 'ProviderContainer get container',
    },
  );
}

// =============================================================================
// KeepAliveLink Bridge
// =============================================================================

BridgedClass _createKeepAliveLinkBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.KeepAliveLink,
    name: 'KeepAliveLink',
    isAssignable: (v) => v is $riverpod_6.KeepAliveLink,
    constructors: {},
    methods: {
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.KeepAliveLink>(
          target,
          'KeepAliveLink',
        );
        t.close();
        return null;
      },
    },
    methodSignatures: {
      'close': 'void close()',
    },
  );
}

// =============================================================================
// AsyncValueIsLoadingException Bridge
// =============================================================================

BridgedClass _createAsyncValueIsLoadingExceptionBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.AsyncValueIsLoadingException,
    name: 'AsyncValueIsLoadingException',
    isAssignable: (v) => v is $riverpod_6.AsyncValueIsLoadingException,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'value': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncValueIsLoadingException>(
            target,
            'AsyncValueIsLoadingException',
          )
          .value,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncValueIsLoadingException>(
          target,
          'AsyncValueIsLoadingException',
        );
        return t.toString();
      },
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'value': 'AsyncValue<Object?> get value',
    },
  );
}

// =============================================================================
// AsyncValue Bridge
// =============================================================================

BridgedClass _createAsyncValueBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.AsyncValue,
    name: 'AsyncValue',
    isAssignable: (v) => v is $riverpod_6.AsyncValue,
    constructors: {
      'data': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AsyncValue');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'value',
          'AsyncValue',
        );
        // GEN-075: Preserve generic type parameter from runtime value
        switch (value) {
          case double _:
            return $riverpod_6.AsyncValue<double>.data(value);
          case int _:
            return $riverpod_6.AsyncValue<int>.data(value);
          case String _:
            return $riverpod_6.AsyncValue<String>.data(value);
          case bool _:
            return $riverpod_6.AsyncValue<bool>.data(value);
          case $riverpod_7.AsyncNotifierProvider _:
            return $riverpod_6.AsyncValue<
              $riverpod_7.AsyncNotifierProvider
            >.data(value);
          case $riverpod_8.FutureProvider _:
            return $riverpod_6.AsyncValue<$riverpod_8.FutureProvider>.data(
              value,
            );
          case $riverpod_14.StreamNotifierProvider _:
            return $riverpod_6.AsyncValue<
              $riverpod_14.StreamNotifierProvider
            >.data(value);
          case $riverpod_15.StreamProvider _:
            return $riverpod_6.AsyncValue<$riverpod_15.StreamProvider>.data(
              value,
            );
          case $riverpod_7.$AsyncNotifierProvider _:
            return $riverpod_6.AsyncValue<
              $riverpod_7.$AsyncNotifierProvider
            >.data(value);
          case $riverpod_14.$StreamNotifierProvider _:
            return $riverpod_6.AsyncValue<
              $riverpod_14.$StreamNotifierProvider
            >.data(value);
          case $riverpod_12.NotifierProvider _:
            return $riverpod_6.AsyncValue<$riverpod_12.NotifierProvider>.data(
              value,
            );
          case $riverpod_13.Provider _:
            return $riverpod_6.AsyncValue<$riverpod_13.Provider>.data(value);
          case $riverpod_10.StateNotifierProvider _:
            return $riverpod_6.AsyncValue<
              $riverpod_10.StateNotifierProvider
            >.data(value);
          case $riverpod_11.StateProvider _:
            return $riverpod_6.AsyncValue<$riverpod_11.StateProvider>.data(
              value,
            );
          case $riverpod_12.$NotifierProvider _:
            return $riverpod_6.AsyncValue<$riverpod_12.$NotifierProvider>.data(
              value,
            );
          case $riverpod_7.AsyncNotifierProviderFamily _:
            return $riverpod_6.AsyncValue<
              $riverpod_7.AsyncNotifierProviderFamily
            >.data(value);
          case $riverpod_8.FutureProviderFamily _:
            return $riverpod_6.AsyncValue<
              $riverpod_8.FutureProviderFamily
            >.data(value);
          case $riverpod_12.NotifierProviderFamily _:
            return $riverpod_6.AsyncValue<
              $riverpod_12.NotifierProviderFamily
            >.data(value);
          case $riverpod_13.ProviderFamily _:
            return $riverpod_6.AsyncValue<$riverpod_13.ProviderFamily>.data(
              value,
            );
          case $riverpod_10.StateNotifierProviderFamily _:
            return $riverpod_6.AsyncValue<
              $riverpod_10.StateNotifierProviderFamily
            >.data(value);
          case $riverpod_11.StateProviderFamily _:
            return $riverpod_6.AsyncValue<
              $riverpod_11.StateProviderFamily
            >.data(value);
          case $riverpod_14.StreamNotifierProviderFamily _:
            return $riverpod_6.AsyncValue<
              $riverpod_14.StreamNotifierProviderFamily
            >.data(value);
          case $riverpod_15.StreamProviderFamily _:
            return $riverpod_6.AsyncValue<
              $riverpod_15.StreamProviderFamily
            >.data(value);
          case $riverpod_6.ProviderBase _:
            return $riverpod_6.AsyncValue<$riverpod_6.ProviderBase>.data(value);
          case $riverpod_7.AsyncNotifier _:
            return $riverpod_6.AsyncValue<$riverpod_7.AsyncNotifier>.data(
              value,
            );
          case $riverpod_6.Family _:
            return $riverpod_6.AsyncValue<$riverpod_6.Family>.data(value);
          case $riverpod_14.StreamNotifier _:
            return $riverpod_6.AsyncValue<$riverpod_14.StreamNotifier>.data(
              value,
            );
          case $riverpod_7.$AsyncNotifier _:
            return $riverpod_6.AsyncValue<$riverpod_7.$AsyncNotifier>.data(
              value,
            );
          case $riverpod_14.$StreamNotifier _:
            return $riverpod_6.AsyncValue<$riverpod_14.$StreamNotifier>.data(
              value,
            );
          case $riverpod_12.Notifier _:
            return $riverpod_6.AsyncValue<$riverpod_12.Notifier>.data(value);
          case $riverpod_6.SyncProviderTransformerMixin _:
            return $riverpod_6.AsyncValue<
              $riverpod_6.SyncProviderTransformerMixin
            >.data(value);
          case $riverpod_12.$Notifier _:
            return $riverpod_6.AsyncValue<$riverpod_12.$Notifier>.data(value);
          case $riverpod_6.$ProviderOverride _:
            return $riverpod_6.AsyncValue<$riverpod_6.$ProviderOverride>.data(
              value,
            );
          case $riverpod_6.AsyncData _:
            return $riverpod_6.AsyncValue<$riverpod_6.AsyncData>.data(value);
          case $riverpod_6.AsyncError _:
            return $riverpod_6.AsyncValue<$riverpod_6.AsyncError>.data(value);
          case $riverpod_6.AsyncProviderListenable _:
            return $riverpod_6.AsyncValue<
              $riverpod_6.AsyncProviderListenable
            >.data(value);
          case $riverpod_kit_1.Consumer _:
            return $riverpod_6.AsyncValue<$riverpod_kit_1.Consumer>.data(value);
          case $riverpod_6.Mutation _:
            return $riverpod_6.AsyncValue<$riverpod_6.Mutation>.data(value);
          case $riverpod_6.Ref _:
            return $riverpod_6.AsyncValue<$riverpod_6.Ref>.data(value);
          case $riverpod_6.Refreshable _:
            return $riverpod_6.AsyncValue<$riverpod_6.Refreshable>.data(value);
          case $riverpod_6.AsyncLoading _:
            return $riverpod_6.AsyncValue<$riverpod_6.AsyncLoading>.data(value);
          case $riverpod_6.AsyncValueIsLoadingException _:
            return $riverpod_6.AsyncValue<
              $riverpod_6.AsyncValueIsLoadingException
            >.data(value);
          case $riverpod_kit_1.ConsumerWidget _:
            return $riverpod_6.AsyncValue<$riverpod_kit_1.ConsumerWidget>.data(
              value,
            );
          case $riverpod_6.DevtoolObserver _:
            return $riverpod_6.AsyncValue<$riverpod_6.DevtoolObserver>.data(
              value,
            );
          case $riverpod_6.MutationError _:
            return $riverpod_6.AsyncValue<$riverpod_6.MutationError>.data(
              value,
            );
          case $riverpod_6.MutationIdle _:
            return $riverpod_6.AsyncValue<$riverpod_6.MutationIdle>.data(value);
          case $riverpod_6.MutationPending _:
            return $riverpod_6.AsyncValue<$riverpod_6.MutationPending>.data(
              value,
            );
          case $riverpod_6.MutationSuccess _:
            return $riverpod_6.AsyncValue<$riverpod_6.MutationSuccess>.data(
              value,
            );
          case $riverpod_6.ProviderContainer _:
            return $riverpod_6.AsyncValue<$riverpod_6.ProviderContainer>.data(
              value,
            );
          case $riverpod_2.ProviderException _:
            return $riverpod_6.AsyncValue<$riverpod_2.ProviderException>.data(
              value,
            );
          case $riverpod_6.ProviderListenable _:
            return $riverpod_6.AsyncValue<$riverpod_6.ProviderListenable>.data(
              value,
            );
          case $riverpod_9.StateController _:
            return $riverpod_6.AsyncValue<$riverpod_9.StateController>.data(
              value,
            );
          case $riverpod_6.AnyNotifier _:
            return $riverpod_6.AsyncValue<$riverpod_6.AnyNotifier>.data(value);
          case $riverpod_kit_1.ConsumerState _:
            return $riverpod_6.AsyncValue<$riverpod_kit_1.ConsumerState>.data(
              value,
            );
          case $riverpod_kit_1.ConsumerStatefulWidget _:
            return $riverpod_6.AsyncValue<
              $riverpod_kit_1.ConsumerStatefulWidget
            >.data(value);
          case $riverpod_6.KeepAliveLink _:
            return $riverpod_6.AsyncValue<$riverpod_6.KeepAliveLink>.data(
              value,
            );
          case $riverpod_6.MutationTarget _:
            return $riverpod_6.AsyncValue<$riverpod_6.MutationTarget>.data(
              value,
            );
          case $riverpod_6.MutationTransaction _:
            return $riverpod_6.AsyncValue<$riverpod_6.MutationTransaction>.data(
              value,
            );
          case $riverpod_6.Override _:
            return $riverpod_6.AsyncValue<$riverpod_6.Override>.data(value);
          case $riverpod_6.PersistResult _:
            return $riverpod_6.AsyncValue<$riverpod_6.PersistResult>.data(
              value,
            );
          case $riverpod_5.PersistedData _:
            return $riverpod_6.AsyncValue<$riverpod_5.PersistedData>.data(
              value,
            );
          case $riverpod_6.ProviderListenableOrFamily _:
            return $riverpod_6.AsyncValue<
              $riverpod_6.ProviderListenableOrFamily
            >.data(value);
          case $riverpod_6.ProviderObserver _:
            return $riverpod_6.AsyncValue<$riverpod_6.ProviderObserver>.data(
              value,
            );
          case $riverpod_6.ProviderObserverContext _:
            return $riverpod_6.AsyncValue<
              $riverpod_6.ProviderObserverContext
            >.data(value);
          case $riverpod_6.ProviderReference _:
            return $riverpod_6.AsyncValue<$riverpod_6.ProviderReference>.data(
              value,
            );
          case $riverpod_kit_2.ProviderScope _:
            return $riverpod_6.AsyncValue<$riverpod_kit_2.ProviderScope>.data(
              value,
            );
          case $riverpod_6.ProviderSubscription _:
            return $riverpod_6.AsyncValue<
              $riverpod_6.ProviderSubscription
            >.data(value);
          case $riverpod_6.ProviderTransformer _:
            return $riverpod_6.AsyncValue<$riverpod_6.ProviderTransformer>.data(
              value,
            );
          case $riverpod_6.ProviderTransformerContext _:
            return $riverpod_6.AsyncValue<
              $riverpod_6.ProviderTransformerContext
            >.data(value);
          case $riverpod_kit_2.RootRegistration _:
            return $riverpod_6.AsyncValue<
              $riverpod_kit_2.RootRegistration
            >.data(value);
          case $riverpod_5.Storage _:
            return $riverpod_6.AsyncValue<$riverpod_5.Storage>.data(value);
          case $riverpod_5.StorageCacheTime _:
            return $riverpod_6.AsyncValue<$riverpod_5.StorageCacheTime>.data(
              value,
            );
          case $riverpod_5.StorageOptions _:
            return $riverpod_6.AsyncValue<$riverpod_5.StorageOptions>.data(
              value,
            );
          case $riverpod_kit_2.UncontrolledProviderScope _:
            return $riverpod_6.AsyncValue<
              $riverpod_kit_2.UncontrolledProviderScope
            >.data(value);
          case $riverpod_kit_3.WidgetRef _:
            return $riverpod_6.AsyncValue<$riverpod_kit_3.WidgetRef>.data(
              value,
            );
          default:
            return $riverpod_6.AsyncValue.data(value);
        }
      },
      'loading': (visitor, positional, named) {
        if (!named.containsKey('progress')) {
          return $riverpod_6.AsyncValue.loading();
        }
        if (named.containsKey('progress')) {
          final progress = D4.getRequiredNamedArg<num>(
            named,
            'progress',
            'AsyncValue',
          );
          return $riverpod_6.AsyncValue.loading(progress: progress);
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'error': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'AsyncValue');
        final error = D4.getRequiredArg<Object>(
          positional,
          0,
          'error',
          'AsyncValue',
        );
        final stackTrace = D4.getRequiredArg<StackTrace>(
          positional,
          1,
          'stackTrace',
          'AsyncValue',
        );
        return $riverpod_6.AsyncValue.error(error, stackTrace);
      },
    },
    getters: {
      'value': (visitor, target) =>
          D4.validateTarget<$riverpod_6.AsyncValue>(target, 'AsyncValue').value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncValue>(target, 'AsyncValue')
          .requireValue,
      'error': (visitor, target) =>
          D4.validateTarget<$riverpod_6.AsyncValue>(target, 'AsyncValue').error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncValue>(target, 'AsyncValue')
          .stackTrace,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncValue>(target, 'AsyncValue')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncValue>(
          target,
          'AsyncValue',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncValue>(
          target,
          'AsyncValue',
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
    staticMethods: {
      'guard': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'guard');
        if (positional.isEmpty) {
          throw ArgumentError(
            'guard: Missing required argument "future" at position 0',
          );
        }
        final futureRaw = positional[0];
        final future =
            (() {
                  return Future.value(
                    D4.callInterpreterCallback(visitor!, futureRaw, []),
                  ).then((v) => v as dynamic);
                })
                as Future<dynamic> Function();
        final testRaw = positional.length > 1 ? positional[1] : null;
        final test = testRaw == null
            ? null
            : ((Object p0) {
                    return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                        as bool;
                  })
                  as bool Function(Object);
        return $riverpod_6.AsyncValue.guard(future, test);
      },
    },
    constructorSignatures: {
      'data': 'const factory AsyncValue.data(ValueT value)',
      'loading': 'const factory AsyncValue.loading({num progress})',
      'error':
          'const factory AsyncValue.error(Object error, StackTrace stackTrace)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'value': 'ValueT? get value',
      'requireValue': 'ValueT get requireValue',
      'error': 'Object? get error',
      'stackTrace': 'StackTrace? get stackTrace',
      'hashCode': 'int get hashCode',
    },
    staticMethodSignatures: {
      'guard':
          'Future<AsyncValue<ValueT>> guard(Future<ValueT> Function() future, [bool Function(Object)? test])',
    },
  );
}

// =============================================================================
// AsyncResult Bridge
// =============================================================================

BridgedClass _createAsyncResultBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.AsyncResult,
    name: 'AsyncResult',
    isAssignable: (v) => v is $riverpod_6.AsyncResult,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'value': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncResult>(target, 'AsyncResult')
          .value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncResult>(target, 'AsyncResult')
          .requireValue,
      'error': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncResult>(target, 'AsyncResult')
          .error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncResult>(target, 'AsyncResult')
          .stackTrace,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncResult>(target, 'AsyncResult')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncResult>(
          target,
          'AsyncResult',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncResult>(
          target,
          'AsyncResult',
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
    staticMethods: {
      'guard': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'guard');
        if (positional.isEmpty) {
          throw ArgumentError(
            'guard: Missing required argument "fn" at position 0',
          );
        }
        final fnRaw = positional[0];
        final fn = () {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, fnRaw, []),
          );
        };
        return $riverpod_6.AsyncResult.guard(fn);
      },
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'value': 'ValueT get value',
      'requireValue': 'ValueT get requireValue',
      'error': 'Object? get error',
      'stackTrace': 'StackTrace? get stackTrace',
      'hashCode': 'int get hashCode',
    },
    staticMethodSignatures: {
      'guard': 'AsyncResult<ValueT> guard(ValueT Function() fn)',
    },
  );
}

// =============================================================================
// AsyncData Bridge
// =============================================================================

BridgedClass _createAsyncDataBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.AsyncData,
    name: 'AsyncData',
    isAssignable: (v) => v is $riverpod_6.AsyncData,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AsyncData');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'value',
          'AsyncData',
        );
        final kind = D4.getOptionalNamedArg<$riverpod_6.DataKind?>(
          named,
          'kind',
        );
        // GEN-075: Preserve generic type parameter from runtime value
        switch (value) {
          case double _:
            return $riverpod_6.AsyncData<double>(value, kind: kind);
          case int _:
            return $riverpod_6.AsyncData<int>(value, kind: kind);
          case String _:
            return $riverpod_6.AsyncData<String>(value, kind: kind);
          case bool _:
            return $riverpod_6.AsyncData<bool>(value, kind: kind);
          case $riverpod_7.AsyncNotifierProvider _:
            return $riverpod_6.AsyncData<$riverpod_7.AsyncNotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_8.FutureProvider _:
            return $riverpod_6.AsyncData<$riverpod_8.FutureProvider>(
              value,
              kind: kind,
            );
          case $riverpod_14.StreamNotifierProvider _:
            return $riverpod_6.AsyncData<$riverpod_14.StreamNotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_15.StreamProvider _:
            return $riverpod_6.AsyncData<$riverpod_15.StreamProvider>(
              value,
              kind: kind,
            );
          case $riverpod_7.$AsyncNotifierProvider _:
            return $riverpod_6.AsyncData<$riverpod_7.$AsyncNotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_14.$StreamNotifierProvider _:
            return $riverpod_6.AsyncData<$riverpod_14.$StreamNotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_12.NotifierProvider _:
            return $riverpod_6.AsyncData<$riverpod_12.NotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_13.Provider _:
            return $riverpod_6.AsyncData<$riverpod_13.Provider>(
              value,
              kind: kind,
            );
          case $riverpod_10.StateNotifierProvider _:
            return $riverpod_6.AsyncData<$riverpod_10.StateNotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_11.StateProvider _:
            return $riverpod_6.AsyncData<$riverpod_11.StateProvider>(
              value,
              kind: kind,
            );
          case $riverpod_12.$NotifierProvider _:
            return $riverpod_6.AsyncData<$riverpod_12.$NotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_7.AsyncNotifierProviderFamily _:
            return $riverpod_6.AsyncData<
              $riverpod_7.AsyncNotifierProviderFamily
            >(value, kind: kind);
          case $riverpod_8.FutureProviderFamily _:
            return $riverpod_6.AsyncData<$riverpod_8.FutureProviderFamily>(
              value,
              kind: kind,
            );
          case $riverpod_12.NotifierProviderFamily _:
            return $riverpod_6.AsyncData<$riverpod_12.NotifierProviderFamily>(
              value,
              kind: kind,
            );
          case $riverpod_13.ProviderFamily _:
            return $riverpod_6.AsyncData<$riverpod_13.ProviderFamily>(
              value,
              kind: kind,
            );
          case $riverpod_10.StateNotifierProviderFamily _:
            return $riverpod_6.AsyncData<
              $riverpod_10.StateNotifierProviderFamily
            >(value, kind: kind);
          case $riverpod_11.StateProviderFamily _:
            return $riverpod_6.AsyncData<$riverpod_11.StateProviderFamily>(
              value,
              kind: kind,
            );
          case $riverpod_14.StreamNotifierProviderFamily _:
            return $riverpod_6.AsyncData<
              $riverpod_14.StreamNotifierProviderFamily
            >(value, kind: kind);
          case $riverpod_15.StreamProviderFamily _:
            return $riverpod_6.AsyncData<$riverpod_15.StreamProviderFamily>(
              value,
              kind: kind,
            );
          case $riverpod_6.ProviderBase _:
            return $riverpod_6.AsyncData<$riverpod_6.ProviderBase>(
              value,
              kind: kind,
            );
          case $riverpod_7.AsyncNotifier _:
            return $riverpod_6.AsyncData<$riverpod_7.AsyncNotifier>(
              value,
              kind: kind,
            );
          case $riverpod_6.Family _:
            return $riverpod_6.AsyncData<$riverpod_6.Family>(value, kind: kind);
          case $riverpod_14.StreamNotifier _:
            return $riverpod_6.AsyncData<$riverpod_14.StreamNotifier>(
              value,
              kind: kind,
            );
          case $riverpod_7.$AsyncNotifier _:
            return $riverpod_6.AsyncData<$riverpod_7.$AsyncNotifier>(
              value,
              kind: kind,
            );
          case $riverpod_14.$StreamNotifier _:
            return $riverpod_6.AsyncData<$riverpod_14.$StreamNotifier>(
              value,
              kind: kind,
            );
          case $riverpod_12.Notifier _:
            return $riverpod_6.AsyncData<$riverpod_12.Notifier>(
              value,
              kind: kind,
            );
          case $riverpod_6.SyncProviderTransformerMixin _:
            return $riverpod_6.AsyncData<
              $riverpod_6.SyncProviderTransformerMixin
            >(value, kind: kind);
          case $riverpod_12.$Notifier _:
            return $riverpod_6.AsyncData<$riverpod_12.$Notifier>(
              value,
              kind: kind,
            );
          case $riverpod_6.$ProviderOverride _:
            return $riverpod_6.AsyncData<$riverpod_6.$ProviderOverride>(
              value,
              kind: kind,
            );
          case $riverpod_6.AsyncError _:
            return $riverpod_6.AsyncData<$riverpod_6.AsyncError>(
              value,
              kind: kind,
            );
          case $riverpod_6.AsyncProviderListenable _:
            return $riverpod_6.AsyncData<$riverpod_6.AsyncProviderListenable>(
              value,
              kind: kind,
            );
          case $riverpod_kit_1.Consumer _:
            return $riverpod_6.AsyncData<$riverpod_kit_1.Consumer>(
              value,
              kind: kind,
            );
          case $riverpod_6.Mutation _:
            return $riverpod_6.AsyncData<$riverpod_6.Mutation>(
              value,
              kind: kind,
            );
          case $riverpod_6.Ref _:
            return $riverpod_6.AsyncData<$riverpod_6.Ref>(value, kind: kind);
          case $riverpod_6.Refreshable _:
            return $riverpod_6.AsyncData<$riverpod_6.Refreshable>(
              value,
              kind: kind,
            );
          case $riverpod_6.AsyncLoading _:
            return $riverpod_6.AsyncData<$riverpod_6.AsyncLoading>(
              value,
              kind: kind,
            );
          case $riverpod_6.AsyncResult _:
            return $riverpod_6.AsyncData<$riverpod_6.AsyncResult>(
              value,
              kind: kind,
            );
          case $riverpod_6.AsyncValueIsLoadingException _:
            return $riverpod_6.AsyncData<
              $riverpod_6.AsyncValueIsLoadingException
            >(value, kind: kind);
          case $riverpod_kit_1.ConsumerWidget _:
            return $riverpod_6.AsyncData<$riverpod_kit_1.ConsumerWidget>(
              value,
              kind: kind,
            );
          case $riverpod_6.DevtoolObserver _:
            return $riverpod_6.AsyncData<$riverpod_6.DevtoolObserver>(
              value,
              kind: kind,
            );
          case $riverpod_6.MutationError _:
            return $riverpod_6.AsyncData<$riverpod_6.MutationError>(
              value,
              kind: kind,
            );
          case $riverpod_6.MutationIdle _:
            return $riverpod_6.AsyncData<$riverpod_6.MutationIdle>(
              value,
              kind: kind,
            );
          case $riverpod_6.MutationPending _:
            return $riverpod_6.AsyncData<$riverpod_6.MutationPending>(
              value,
              kind: kind,
            );
          case $riverpod_6.MutationSuccess _:
            return $riverpod_6.AsyncData<$riverpod_6.MutationSuccess>(
              value,
              kind: kind,
            );
          case $riverpod_6.ProviderContainer _:
            return $riverpod_6.AsyncData<$riverpod_6.ProviderContainer>(
              value,
              kind: kind,
            );
          case $riverpod_2.ProviderException _:
            return $riverpod_6.AsyncData<$riverpod_2.ProviderException>(
              value,
              kind: kind,
            );
          case $riverpod_6.ProviderListenable _:
            return $riverpod_6.AsyncData<$riverpod_6.ProviderListenable>(
              value,
              kind: kind,
            );
          case $riverpod_9.StateController _:
            return $riverpod_6.AsyncData<$riverpod_9.StateController>(
              value,
              kind: kind,
            );
          case $riverpod_6.AnyNotifier _:
            return $riverpod_6.AsyncData<$riverpod_6.AnyNotifier>(
              value,
              kind: kind,
            );
          case $riverpod_kit_1.ConsumerState _:
            return $riverpod_6.AsyncData<$riverpod_kit_1.ConsumerState>(
              value,
              kind: kind,
            );
          case $riverpod_kit_1.ConsumerStatefulWidget _:
            return $riverpod_6.AsyncData<
              $riverpod_kit_1.ConsumerStatefulWidget
            >(value, kind: kind);
          case $riverpod_6.KeepAliveLink _:
            return $riverpod_6.AsyncData<$riverpod_6.KeepAliveLink>(
              value,
              kind: kind,
            );
          case $riverpod_6.MutationTarget _:
            return $riverpod_6.AsyncData<$riverpod_6.MutationTarget>(
              value,
              kind: kind,
            );
          case $riverpod_6.MutationTransaction _:
            return $riverpod_6.AsyncData<$riverpod_6.MutationTransaction>(
              value,
              kind: kind,
            );
          case $riverpod_6.Override _:
            return $riverpod_6.AsyncData<$riverpod_6.Override>(
              value,
              kind: kind,
            );
          case $riverpod_6.PersistResult _:
            return $riverpod_6.AsyncData<$riverpod_6.PersistResult>(
              value,
              kind: kind,
            );
          case $riverpod_5.PersistedData _:
            return $riverpod_6.AsyncData<$riverpod_5.PersistedData>(
              value,
              kind: kind,
            );
          case $riverpod_6.ProviderListenableOrFamily _:
            return $riverpod_6.AsyncData<
              $riverpod_6.ProviderListenableOrFamily
            >(value, kind: kind);
          case $riverpod_6.ProviderObserver _:
            return $riverpod_6.AsyncData<$riverpod_6.ProviderObserver>(
              value,
              kind: kind,
            );
          case $riverpod_6.ProviderObserverContext _:
            return $riverpod_6.AsyncData<$riverpod_6.ProviderObserverContext>(
              value,
              kind: kind,
            );
          case $riverpod_6.ProviderReference _:
            return $riverpod_6.AsyncData<$riverpod_6.ProviderReference>(
              value,
              kind: kind,
            );
          case $riverpod_kit_2.ProviderScope _:
            return $riverpod_6.AsyncData<$riverpod_kit_2.ProviderScope>(
              value,
              kind: kind,
            );
          case $riverpod_6.ProviderSubscription _:
            return $riverpod_6.AsyncData<$riverpod_6.ProviderSubscription>(
              value,
              kind: kind,
            );
          case $riverpod_6.ProviderTransformer _:
            return $riverpod_6.AsyncData<$riverpod_6.ProviderTransformer>(
              value,
              kind: kind,
            );
          case $riverpod_6.ProviderTransformerContext _:
            return $riverpod_6.AsyncData<
              $riverpod_6.ProviderTransformerContext
            >(value, kind: kind);
          case $riverpod_kit_2.RootRegistration _:
            return $riverpod_6.AsyncData<$riverpod_kit_2.RootRegistration>(
              value,
              kind: kind,
            );
          case $riverpod_5.Storage _:
            return $riverpod_6.AsyncData<$riverpod_5.Storage>(
              value,
              kind: kind,
            );
          case $riverpod_5.StorageCacheTime _:
            return $riverpod_6.AsyncData<$riverpod_5.StorageCacheTime>(
              value,
              kind: kind,
            );
          case $riverpod_5.StorageOptions _:
            return $riverpod_6.AsyncData<$riverpod_5.StorageOptions>(
              value,
              kind: kind,
            );
          case $riverpod_kit_2.UncontrolledProviderScope _:
            return $riverpod_6.AsyncData<
              $riverpod_kit_2.UncontrolledProviderScope
            >(value, kind: kind);
          case $riverpod_kit_3.WidgetRef _:
            return $riverpod_6.AsyncData<$riverpod_kit_3.WidgetRef>(
              value,
              kind: kind,
            );
          default:
            return $riverpod_6.AsyncData(value, kind: kind);
        }
      },
    },
    getters: {
      'value': (visitor, target) =>
          D4.validateTarget<$riverpod_6.AsyncData>(target, 'AsyncData').value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncData>(target, 'AsyncData')
          .requireValue,
      'error': (visitor, target) =>
          D4.validateTarget<$riverpod_6.AsyncData>(target, 'AsyncData').error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncData>(target, 'AsyncData')
          .stackTrace,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncData>(target, 'AsyncData')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncData>(target, 'AsyncData');
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncData>(target, 'AsyncData');
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
      '': 'const AsyncData(ValueT value, {DataKind? kind})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'value': 'ValueT get value',
      'requireValue': 'ValueT get requireValue',
      'error': 'Object? get error',
      'stackTrace': 'StackTrace? get stackTrace',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// AsyncLoading Bridge
// =============================================================================

BridgedClass _createAsyncLoadingBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.AsyncLoading,
    name: 'AsyncLoading',
    isAssignable: (v) => v is $riverpod_6.AsyncLoading,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final progress = D4.getOptionalNamedArg<num?>(named, 'progress');
        return $riverpod_6.AsyncLoading(progress: progress);
      },
    },
    getters: {
      'value': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncLoading>(target, 'AsyncLoading')
          .value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncLoading>(target, 'AsyncLoading')
          .requireValue,
      'error': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncLoading>(target, 'AsyncLoading')
          .error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncLoading>(target, 'AsyncLoading')
          .stackTrace,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncLoading>(target, 'AsyncLoading')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncLoading>(
          target,
          'AsyncLoading',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncLoading>(
          target,
          'AsyncLoading',
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
      '': 'const AsyncLoading({num? progress})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'value': 'ValueT get value',
      'requireValue': 'ValueT get requireValue',
      'error': 'Object? get error',
      'stackTrace': 'StackTrace? get stackTrace',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// AsyncError Bridge
// =============================================================================

BridgedClass _createAsyncErrorBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.AsyncError,
    name: 'AsyncError',
    isAssignable: (v) => v is $riverpod_6.AsyncError,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'AsyncError');
        final error = D4.getRequiredArg<Object>(
          positional,
          0,
          'error',
          'AsyncError',
        );
        final stackTrace = D4.getRequiredArg<StackTrace>(
          positional,
          1,
          'stackTrace',
          'AsyncError',
        );
        final retrying = D4.getOptionalNamedArg<bool?>(named, 'retrying');
        return $riverpod_6.AsyncError(error, stackTrace, retrying: retrying);
      },
    },
    getters: {
      'value': (visitor, target) =>
          D4.validateTarget<$riverpod_6.AsyncError>(target, 'AsyncError').value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncError>(target, 'AsyncError')
          .requireValue,
      'error': (visitor, target) =>
          D4.validateTarget<$riverpod_6.AsyncError>(target, 'AsyncError').error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncError>(target, 'AsyncError')
          .stackTrace,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncError>(target, 'AsyncError')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncError>(
          target,
          'AsyncError',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncError>(
          target,
          'AsyncError',
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
      '': 'const AsyncError(Object error, StackTrace stackTrace, {bool? retrying})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'value': 'ValueT get value',
      'requireValue': 'ValueT get requireValue',
      'error': 'Object get error',
      'stackTrace': 'StackTrace get stackTrace',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// DevtoolObserver Bridge
// =============================================================================

BridgedClass _createDevtoolObserverBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.DevtoolObserver,
    name: 'DevtoolObserver',
    isAssignable: (v) => v is $riverpod_6.DevtoolObserver,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        return $riverpod_6.DevtoolObserver();
      },
    },
    methods: {
      'didCreateProviderContainer':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
              target,
              'DevtoolObserver',
            );
            D4.requireMinArgs(positional, 1, 'didCreateProviderContainer');
            final container = D4.getRequiredArg<$riverpod_6.ProviderContainer>(
              positional,
              0,
              'container',
              'didCreateProviderContainer',
            );
            t.didCreateProviderContainer(container);
            return null;
          },
      'didDisposeProviderContainer':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
              target,
              'DevtoolObserver',
            );
            D4.requireMinArgs(positional, 1, 'didDisposeProviderContainer');
            final container = D4.getRequiredArg<$riverpod_6.ProviderContainer>(
              positional,
              0,
              'container',
              'didDisposeProviderContainer',
            );
            t.didDisposeProviderContainer(container);
            return null;
          },
      'didAddProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
          target,
          'DevtoolObserver',
        );
        D4.requireMinArgs(positional, 2, 'didAddProvider');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didAddProvider',
        );
        final value = D4.getRequiredArg<Object?>(
          positional,
          1,
          'value',
          'didAddProvider',
        );
        t.didAddProvider(context, value);
        return null;
      },
      'providerDidFail': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
          target,
          'DevtoolObserver',
        );
        D4.requireMinArgs(positional, 3, 'providerDidFail');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'providerDidFail',
        );
        final error = D4.getRequiredArg<Object>(
          positional,
          1,
          'error',
          'providerDidFail',
        );
        final stackTrace = D4.getRequiredArg<StackTrace>(
          positional,
          2,
          'stackTrace',
          'providerDidFail',
        );
        t.providerDidFail(context, error, stackTrace);
        return null;
      },
      'didUnmountProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
          target,
          'DevtoolObserver',
        );
        D4.requireMinArgs(positional, 1, 'didUnmountProvider');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didUnmountProvider',
        );
        t.didUnmountProvider(context);
        return null;
      },
      'didUpdateProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
          target,
          'DevtoolObserver',
        );
        D4.requireMinArgs(positional, 3, 'didUpdateProvider');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didUpdateProvider',
        );
        final previousValue = D4.getRequiredArg<Object?>(
          positional,
          1,
          'previousValue',
          'didUpdateProvider',
        );
        final newValue = D4.getRequiredArg<Object?>(
          positional,
          2,
          'newValue',
          'didUpdateProvider',
        );
        t.didUpdateProvider(context, previousValue, newValue);
        return null;
      },
      'didDisposeProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
          target,
          'DevtoolObserver',
        );
        D4.requireMinArgs(positional, 1, 'didDisposeProvider');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didDisposeProvider',
        );
        t.didDisposeProvider(context);
        return null;
      },
      'mutationReset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
          target,
          'DevtoolObserver',
        );
        D4.requireMinArgs(positional, 2, 'mutationReset');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationReset',
        );
        final mutation = D4.getRequiredArg<$riverpod_6.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationReset',
        );
        t.mutationReset(context, mutation);
        return null;
      },
      'mutationStart': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
          target,
          'DevtoolObserver',
        );
        D4.requireMinArgs(positional, 2, 'mutationStart');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationStart',
        );
        final mutation = D4.getRequiredArg<$riverpod_6.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationStart',
        );
        t.mutationStart(context, mutation);
        return null;
      },
      'mutationError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
          target,
          'DevtoolObserver',
        );
        D4.requireMinArgs(positional, 4, 'mutationError');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationError',
        );
        final mutation = D4.getRequiredArg<$riverpod_6.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationError',
        );
        final error = D4.getRequiredArg<Object>(
          positional,
          2,
          'error',
          'mutationError',
        );
        final stackTrace = D4.getRequiredArg<StackTrace>(
          positional,
          3,
          'stackTrace',
          'mutationError',
        );
        t.mutationError(context, mutation, error, stackTrace);
        return null;
      },
      'mutationSuccess': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.DevtoolObserver>(
          target,
          'DevtoolObserver',
        );
        D4.requireMinArgs(positional, 3, 'mutationSuccess');
        final context = D4.getRequiredArg<$riverpod_6.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationSuccess',
        );
        final mutation = D4.getRequiredArg<$riverpod_6.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationSuccess',
        );
        final result = D4.getRequiredArg<Object?>(
          positional,
          2,
          'result',
          'mutationSuccess',
        );
        t.mutationSuccess(context, mutation, result);
        return null;
      },
    },
    constructorSignatures: {
      '': 'const DevtoolObserver()',
    },
    methodSignatures: {
      'didCreateProviderContainer':
          'void didCreateProviderContainer(ProviderContainer container)',
      'didDisposeProviderContainer':
          'void didDisposeProviderContainer(ProviderContainer container)',
      'didAddProvider':
          'void didAddProvider(ProviderObserverContext context, Object? value)',
      'providerDidFail':
          'void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace)',
      'didUnmountProvider':
          'void didUnmountProvider(ProviderObserverContext context)',
      'didUpdateProvider':
          'void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue)',
      'didDisposeProvider':
          'void didDisposeProvider(ProviderObserverContext context)',
      'mutationReset':
          'void mutationReset(ProviderObserverContext context, Mutation<Object?> mutation)',
      'mutationStart':
          'void mutationStart(ProviderObserverContext context, Mutation<Object?> mutation)',
      'mutationError':
          'void mutationError(ProviderObserverContext context, Mutation<Object?> mutation, Object error, StackTrace stackTrace)',
      'mutationSuccess':
          'void mutationSuccess(ProviderObserverContext context, Mutation<Object?> mutation, Object? result)',
    },
  );
}

// =============================================================================
// SyncProviderTransformerMixin Bridge
// =============================================================================

BridgedClass _createSyncProviderTransformerMixinBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.SyncProviderTransformerMixin,
    name: 'SyncProviderTransformerMixin',
    isAssignable: (v) => v is $riverpod_6.SyncProviderTransformerMixin,
    hierarchyDepth: 3,
    canBeUsedAsMixin: true,
    isAbstract: true,
    constructors: {},
    methods: {
      'transform': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.SyncProviderTransformerMixin>(
          target,
          'SyncProviderTransformerMixin',
        );
        D4.requireMinArgs(positional, 1, 'transform');
        final context = D4
            .getRequiredArg<
              $riverpod_6.ProviderTransformerContext<dynamic, dynamic>
            >(positional, 0, 'context', 'transform');
        return t.transform(context);
      },
    },
    methodSignatures: {
      'transform':
          'ProviderTransformer<InT, ValueT> transform(ProviderTransformerContext<InT, ValueT> context)',
    },
  );
}

// =============================================================================
// $AsyncNotifier Bridge
// =============================================================================

BridgedClass _create$AsyncNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_7.$AsyncNotifier,
    name: '\$AsyncNotifier',
    isAssignable: (v) => v is $riverpod_7.$AsyncNotifier,
    hierarchyDepth: 3,
    isAbstract: true,
    constructors: {},
    getters: {
      'ref': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifier>(target, '\$AsyncNotifier')
          .ref,
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifier>(target, '\$AsyncNotifier')
          .state,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifier>(target, '\$AsyncNotifier')
          .future,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
              .validateTarget<$riverpod_7.$AsyncNotifier>(
                target,
                '\$AsyncNotifier',
              )
              .state = D4.extractBridgedArg<$riverpod_6.AsyncValue<dynamic>>(
            value,
            'state',
          ),
    },
    methods: {
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.$AsyncNotifier>(
          target,
          '\$AsyncNotifier',
        );
        D4.requireMinArgs(positional, 1, 'listenSelf');
        if (positional.isEmpty) {
          throw ArgumentError(
            'listenSelf: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).listenSelf(
          (
            $riverpod_6.AsyncValue<dynamic>? p0,
            $riverpod_6.AsyncValue<dynamic> p1,
          ) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
        );
      },
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.$AsyncNotifier>(
          target,
          '\$AsyncNotifier',
        );
        return t.runBuild();
      },
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.$AsyncNotifier>(
          target,
          '\$AsyncNotifier',
        );
        D4.requireMinArgs(positional, 1, 'update');
        if (positional.isEmpty) {
          throw ArgumentError(
            'update: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).update(
          ((dynamic p0) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, cbRaw, [p0]),
                );
              })
              as FutureOr<Object?> Function(dynamic),
          onError: onErrorRaw == null
              ? null
              : ((Object p0, StackTrace p1) {
                      return D4.castCallbackResult<FutureOr<Object?>>(
                        D4.callInterpreterCallback(visitor!, onErrorRaw, [
                          p0,
                          p1,
                        ]),
                      );
                    })
                    as FutureOr<Object?> Function(Object, StackTrace),
        );
      },
    },
    methodSignatures: {
      'listenSelf':
          'RemoveListener listenSelf(void Function(AsyncValue<ValueT>? previous, AsyncValue<ValueT> next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
      'runBuild': 'WhenComplete? runBuild()',
      'update':
          'Future<ValueT> update(FutureOr<ValueT> Function(ValueT previousState) cb, {FutureOr<ValueT> Function(Object err, StackTrace stackTrace)? onError})',
    },
    getterSignatures: {
      'ref': 'Ref get ref',
      'state': 'AsyncValue<ValueT> get state',
      'future': 'Future<ValueT> get future',
    },
    setterSignatures: {
      'state': 'set state(AsyncValue<ValueT> value)',
    },
  );
}

// =============================================================================
// $AsyncNotifierProvider Bridge
// =============================================================================

BridgedClass _create$AsyncNotifierProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_7.$AsyncNotifierProvider,
    name: '\$AsyncNotifierProvider',
    isAssignable: (v) => v is $riverpod_7.$AsyncNotifierProvider,
    hierarchyDepth: 11,
    isAbstract: true,
    constructors: {},
    getters: {
      'notifier': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_7.$AsyncNotifierProvider>(
            target,
            '\$AsyncNotifierProvider',
          )
          .future,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.$AsyncNotifierProvider>(
          target,
          '\$AsyncNotifierProvider',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.$AsyncNotifierProvider>(
          target,
          '\$AsyncNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (() {
                return D4
                        .extractBridgedArg<$riverpod_7.$AsyncNotifier<dynamic>>(
                          D4.callInterpreterCallback(visitor!, createRaw, []),
                          'callback',
                          visitor,
                        )
                    as $riverpod_7.$AsyncNotifier<dynamic>;
              })
              as $riverpod_7.$AsyncNotifier<dynamic> Function(),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.$AsyncNotifierProvider>(
          target,
          '\$AsyncNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithBuild');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWithBuild: Missing required argument "build" at position 0',
          );
        }
        final buildRaw = positional[0];
        return (t as dynamic).overrideWithBuild(
          (($riverpod_6.Ref p0, $riverpod_7.$AsyncNotifier<dynamic> p1) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
                );
              })
              as FutureOr<Object?> Function(
                $riverpod_6.Ref,
                $riverpod_7.$AsyncNotifier<dynamic>,
              ),
        );
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.$AsyncNotifierProvider>(
          target,
          '\$AsyncNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'selectAsync');
        if (positional.isEmpty) {
          throw ArgumentError(
            'selectAsync: Missing required argument "selector" at position 0',
          );
        }
        final selectorRaw = positional[0];
        return (t as dynamic).selectAsync((dynamic p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, selectorRaw, [p0]),
          );
        });
      },
    },
    methodSignatures: {
      'toString': 'String toString()',
      'overrideWith': 'Override overrideWith(NotifierT Function() create)',
      'overrideWithBuild':
          'Override overrideWithBuild(RunNotifierBuild<NotifierT, FutureOr<ValueT>> build)',
      'selectAsync':
          'ProviderListenable<Future<OutT>> selectAsync(OutT Function(ValueT data) selector)',
    },
    getterSignatures: {
      'notifier': 'Refreshable<NotifierT> get notifier',
      'from': 'Family? get from',
      'origin': 'ProviderBase<AsyncValue<ValueT>> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'future': 'Refreshable<Future<ValueT>> get future',
    },
  );
}

// =============================================================================
// AsyncNotifier Bridge
// =============================================================================

BridgedClass _createAsyncNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_7.AsyncNotifier,
    name: 'AsyncNotifier',
    isAssignable: (v) => v is $riverpod_7.AsyncNotifier,
    hierarchyDepth: 4,
    isAbstract: true,
    constructors: {},
    getters: {
      'ref': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifier>(target, 'AsyncNotifier')
          .ref,
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifier>(target, 'AsyncNotifier')
          .state,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifier>(target, 'AsyncNotifier')
          .future,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
              .validateTarget<$riverpod_7.AsyncNotifier>(
                target,
                'AsyncNotifier',
              )
              .state = D4.extractBridgedArg<$riverpod_6.AsyncValue<dynamic>>(
            value,
            'state',
          ),
    },
    methods: {
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifier>(
          target,
          'AsyncNotifier',
        );
        D4.requireMinArgs(positional, 1, 'listenSelf');
        if (positional.isEmpty) {
          throw ArgumentError(
            'listenSelf: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).listenSelf(
          (
            $riverpod_6.AsyncValue<dynamic>? p0,
            $riverpod_6.AsyncValue<dynamic> p1,
          ) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
        );
      },
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifier>(
          target,
          'AsyncNotifier',
        );
        return t.runBuild();
      },
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifier>(
          target,
          'AsyncNotifier',
        );
        D4.requireMinArgs(positional, 1, 'update');
        if (positional.isEmpty) {
          throw ArgumentError(
            'update: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).update(
          ((dynamic p0) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, cbRaw, [p0]),
                );
              })
              as FutureOr<Object?> Function(dynamic),
          onError: onErrorRaw == null
              ? null
              : ((Object p0, StackTrace p1) {
                      return D4.castCallbackResult<FutureOr<Object?>>(
                        D4.callInterpreterCallback(visitor!, onErrorRaw, [
                          p0,
                          p1,
                        ]),
                      );
                    })
                    as FutureOr<Object?> Function(Object, StackTrace),
        );
      },
    },
    methodSignatures: {
      'listenSelf':
          'RemoveListener listenSelf(void Function(AsyncValue<StateT>? previous, AsyncValue<StateT> next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
      'runBuild': 'WhenComplete? runBuild()',
      'update':
          'Future<StateT> update(FutureOr<StateT> Function(StateT previousState) cb, {FutureOr<StateT> Function(Object err, StackTrace stackTrace)? onError})',
    },
    getterSignatures: {
      'ref': 'Ref get ref',
      'state': 'AsyncValue<StateT> get state',
      'future': 'Future<StateT> get future',
    },
    setterSignatures: {
      'state': 'set state(AsyncValue<StateT> value)',
    },
  );
}

// =============================================================================
// AsyncNotifierProvider Bridge
// =============================================================================

BridgedClass _createAsyncNotifierProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_7.AsyncNotifierProvider,
    name: 'AsyncNotifierProvider',
    isAssignable: (v) => v is $riverpod_7.AsyncNotifierProvider,
    hierarchyDepth: 13,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'AsyncNotifierProvider');
        if (positional.isEmpty) {
          throw ArgumentError(
            'AsyncNotifierProvider: Missing required argument "_createNotifier" at position 0',
          );
        }
        final createNotifierRaw = positional[0];
        final name = D4.getOptionalNamedArg<String?>(named, 'name');
        final dependencies = D4.coerceListOrNull<$riverpod_6.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_7.AsyncNotifierProvider(
          (() {
                return D4.extractBridgedArg<$riverpod_7.AsyncNotifier<dynamic>>(
                      D4.callInterpreterCallback(
                        visitor!,
                        createNotifierRaw,
                        [],
                      ),
                      'callback',
                      visitor,
                    )
                    as $riverpod_7.AsyncNotifier<dynamic>;
              })
              as $riverpod_7.AsyncNotifier<dynamic> Function(),
          name: name,
          dependencies: dependencies,
          isAutoDispose: isAutoDispose,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'notifier': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .future,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProvider>(
          target,
          'AsyncNotifierProvider',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProvider>(
          target,
          'AsyncNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (() {
                return D4.extractBridgedArg<$riverpod_7.AsyncNotifier<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_7.AsyncNotifier<dynamic>;
              })
              as $riverpod_7.AsyncNotifier<dynamic> Function(),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProvider>(
          target,
          'AsyncNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithBuild');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWithBuild: Missing required argument "build" at position 0',
          );
        }
        final buildRaw = positional[0];
        return (t as dynamic).overrideWithBuild(
          (($riverpod_6.Ref p0, $riverpod_7.AsyncNotifier<dynamic> p1) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
                );
              })
              as FutureOr<Object?> Function(
                $riverpod_6.Ref,
                $riverpod_7.AsyncNotifier<dynamic>,
              ),
        );
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProvider>(
          target,
          'AsyncNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'selectAsync');
        if (positional.isEmpty) {
          throw ArgumentError(
            'selectAsync: Missing required argument "selector" at position 0',
          );
        }
        final selectorRaw = positional[0];
        return (t as dynamic).selectAsync((dynamic p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, selectorRaw, [p0]),
          );
        });
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProvider>(
          target,
          'AsyncNotifierProvider',
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
      'autoDispose': (visitor) => $riverpod_7.AsyncNotifierProvider.autoDispose,
      'family': (visitor) => $riverpod_7.AsyncNotifierProvider.family,
    },
    constructorSignatures: {
      '': 'AsyncNotifierProvider(NotifierT Function() _createNotifier, {String? name, Iterable<ProviderOrFamily>? dependencies, bool isAutoDispose = false, Retry? retry})',
    },
    methodSignatures: {
      'toString': 'String toString()',
      'overrideWith': 'Override overrideWith(NotifierT Function() create)',
      'overrideWithBuild':
          'Override overrideWithBuild(RunNotifierBuild<NotifierT, FutureOr<ValueT>> build)',
      'selectAsync':
          'ProviderListenable<Future<OutT>> selectAsync(OutT Function(ValueT data) selector)',
    },
    getterSignatures: {
      'notifier': 'Refreshable<NotifierT> get notifier',
      'from': 'Family? get from',
      'origin': 'ProviderBase<AsyncValue<ValueT>> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'future': 'Refreshable<Future<ValueT>> get future',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'autoDispose': 'AutoDisposeAsyncNotifierProviderBuilder get autoDispose',
      'family': 'AsyncNotifierProviderFamilyBuilder get family',
    },
  );
}

// =============================================================================
// AsyncNotifierProviderFamily Bridge
// =============================================================================

BridgedClass _createAsyncNotifierProviderFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_7.AsyncNotifierProviderFamily,
    name: 'AsyncNotifierProviderFamily',
    isAssignable: (v) => v is $riverpod_7.AsyncNotifierProviderFamily,
    hierarchyDepth: 7,
    constructors: {},
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
            target,
            'AsyncNotifierProviderFamily',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
            target,
            'AsyncNotifierProviderFamily',
          )
          .origin,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
            target,
            'AsyncNotifierProviderFamily',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
            target,
            'AsyncNotifierProviderFamily',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
            target,
            'AsyncNotifierProviderFamily',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
            target,
            'AsyncNotifierProviderFamily',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
            target,
            'AsyncNotifierProviderFamily',
          )
          .isAutoDispose,
    },
    methods: {
      'call': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
          target,
          'AsyncNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'call');
        final argument = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'argument',
          'call',
        );
        return t.call(argument);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
          target,
          'AsyncNotifierProviderFamily',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
          target,
          'AsyncNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (() {
                return D4.extractBridgedArg<$riverpod_7.AsyncNotifier<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_7.AsyncNotifier<dynamic>;
              })
              as $riverpod_7.AsyncNotifier<dynamic> Function(),
        );
      },
      'overrideWith2': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
          target,
          'AsyncNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith2');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith2: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith2(
          ((dynamic p0) {
                return D4.extractBridgedArg<$riverpod_7.AsyncNotifier<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as $riverpod_7.AsyncNotifier<dynamic>;
              })
              as $riverpod_7.AsyncNotifier<dynamic> Function(dynamic),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.AsyncNotifierProviderFamily>(
          target,
          'AsyncNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithBuild');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWithBuild: Missing required argument "build" at position 0',
          );
        }
        final buildRaw = positional[0];
        return (t as dynamic).overrideWithBuild(
          (($riverpod_6.Ref p0, $riverpod_7.AsyncNotifier<dynamic> p1) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
                );
              })
              as FutureOr<Object?> Function(
                $riverpod_6.Ref,
                $riverpod_7.AsyncNotifier<dynamic>,
              ),
        );
      },
    },
    methodSignatures: {
      'call': 'AsyncNotifierProvider<NotifierT, ValueT> call(ArgT argument)',
      'toString': 'String toString()',
      'overrideWith': 'Override overrideWith(NotifierT Function() create)',
      'overrideWith2':
          'Override overrideWith2(NotifierT Function(ArgT arg) create)',
      'overrideWithBuild':
          'Override overrideWithBuild(RunNotifierBuild<NotifierT, FutureOr<ValueT>> build)',
    },
    getterSignatures: {
      'from': 'Family get from',
      'origin': 'Family get origin',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
    },
  );
}

// =============================================================================
// FutureProvider Bridge
// =============================================================================

BridgedClass _createFutureProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_8.FutureProvider,
    name: 'FutureProvider',
    isAssignable: (v) => v is $riverpod_8.FutureProvider,
    hierarchyDepth: 13,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'FutureProvider');
        if (positional.isEmpty) {
          throw ArgumentError(
            'FutureProvider: Missing required argument "_create" at position 0',
          );
        }
        final createRaw = positional[0];
        final name = D4.getOptionalNamedArg<String?>(named, 'name');
        final dependencies = D4.coerceListOrNull<$riverpod_6.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_8.FutureProvider(
          (($riverpod_6.Ref p0) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                );
              })
              as FutureOr<Object?> Function($riverpod_6.Ref),
          name: name,
          dependencies: dependencies,
          isAutoDispose: isAutoDispose,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .future,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProvider>(target, 'FutureProvider')
          .hashCode,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.FutureProvider>(
          target,
          'FutureProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (($riverpod_6.Ref p0) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                );
              })
              as FutureOr<Object?> Function($riverpod_6.Ref),
        );
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.FutureProvider>(
          target,
          'FutureProvider',
        );
        return t.toString();
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.FutureProvider>(
          target,
          'FutureProvider',
        );
        D4.requireMinArgs(positional, 1, 'selectAsync');
        if (positional.isEmpty) {
          throw ArgumentError(
            'selectAsync: Missing required argument "selector" at position 0',
          );
        }
        final selectorRaw = positional[0];
        return (t as dynamic).selectAsync((dynamic p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, selectorRaw, [p0]),
          );
        });
      },
      'overrideWithValue': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.FutureProvider>(
          target,
          'FutureProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithValue');
        final value = D4.getRequiredArg<$riverpod_6.AsyncValue<dynamic>>(
          positional,
          0,
          'value',
          'overrideWithValue',
        );
        return t.overrideWithValue(value);
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.FutureProvider>(
          target,
          'FutureProvider',
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
      'autoDispose': (visitor) => $riverpod_8.FutureProvider.autoDispose,
      'family': (visitor) => $riverpod_8.FutureProvider.family,
    },
    constructorSignatures: {
      '': 'FutureProvider(Create<FutureOr<ValueT>> _create, {String? name, Iterable<ProviderOrFamily>? dependencies, bool isAutoDispose = false, Retry? retry})',
    },
    methodSignatures: {
      'overrideWith': 'Override overrideWith(Create<FutureOr<ValueT>> create)',
      'toString': 'String toString()',
      'selectAsync':
          'ProviderListenable<Future<OutT>> selectAsync(OutT Function(ValueT data) selector)',
      'overrideWithValue':
          'Override overrideWithValue(AsyncValue<ValueT> value)',
    },
    getterSignatures: {
      'from': 'Family? get from',
      'origin': 'ProviderBase<AsyncValue<ValueT>> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'future': 'Refreshable<Future<ValueT>> get future',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'autoDispose': 'AutoDisposeFutureProviderBuilder get autoDispose',
      'family': 'FutureProviderFamilyBuilder get family',
    },
  );
}

// =============================================================================
// FutureProviderFamily Bridge
// =============================================================================

BridgedClass _createFutureProviderFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_8.FutureProviderFamily,
    name: 'FutureProviderFamily',
    isAssignable: (v) => v is $riverpod_8.FutureProviderFamily,
    hierarchyDepth: 7,
    constructors: {},
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProviderFamily>(
            target,
            'FutureProviderFamily',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProviderFamily>(
            target,
            'FutureProviderFamily',
          )
          .origin,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProviderFamily>(
            target,
            'FutureProviderFamily',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProviderFamily>(
            target,
            'FutureProviderFamily',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProviderFamily>(
            target,
            'FutureProviderFamily',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProviderFamily>(
            target,
            'FutureProviderFamily',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_8.FutureProviderFamily>(
            target,
            'FutureProviderFamily',
          )
          .isAutoDispose,
    },
    methods: {
      'call': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.FutureProviderFamily>(
          target,
          'FutureProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'call');
        final argument = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'argument',
          'call',
        );
        return t.call(argument);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.FutureProviderFamily>(
          target,
          'FutureProviderFamily',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.FutureProviderFamily>(
          target,
          'FutureProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (($riverpod_6.Ref p0, dynamic p1) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, createRaw, [p0, p1]),
                );
              })
              as FutureOr<Object?> Function($riverpod_6.Ref, dynamic),
        );
      },
    },
    methodSignatures: {
      'call': 'FutureProvider<ValueT> call(ArgT argument)',
      'toString': 'String toString()',
      'overrideWith':
          'Override overrideWith(FutureOr<ValueT> Function(Ref ref, ArgT arg) create)',
    },
    getterSignatures: {
      'from': 'Family get from',
      'origin': 'Family get origin',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
    },
  );
}

// =============================================================================
// StateController Bridge
// =============================================================================

BridgedClass _createStateControllerBridge() {
  return BridgedClass(
    nativeType: $riverpod_9.StateController,
    name: 'StateController',
    isAssignable: (v) => v is $riverpod_9.StateController,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'StateController');
        final state = D4.getRequiredArg<dynamic>(
          positional,
          0,
          '_state',
          'StateController',
        );
        // GEN-075: Preserve generic type parameter from runtime value
        switch (state) {
          case double _:
            return $riverpod_9.StateController<double>(state);
          case int _:
            return $riverpod_9.StateController<int>(state);
          case String _:
            return $riverpod_9.StateController<String>(state);
          case bool _:
            return $riverpod_9.StateController<bool>(state);
          case $riverpod_7.AsyncNotifierProvider _:
            return $riverpod_9.StateController<
              $riverpod_7.AsyncNotifierProvider
            >(state);
          case $riverpod_8.FutureProvider _:
            return $riverpod_9.StateController<$riverpod_8.FutureProvider>(
              state,
            );
          case $riverpod_14.StreamNotifierProvider _:
            return $riverpod_9.StateController<
              $riverpod_14.StreamNotifierProvider
            >(state);
          case $riverpod_15.StreamProvider _:
            return $riverpod_9.StateController<$riverpod_15.StreamProvider>(
              state,
            );
          case $riverpod_7.$AsyncNotifierProvider _:
            return $riverpod_9.StateController<
              $riverpod_7.$AsyncNotifierProvider
            >(state);
          case $riverpod_14.$StreamNotifierProvider _:
            return $riverpod_9.StateController<
              $riverpod_14.$StreamNotifierProvider
            >(state);
          case $riverpod_12.NotifierProvider _:
            return $riverpod_9.StateController<$riverpod_12.NotifierProvider>(
              state,
            );
          case $riverpod_13.Provider _:
            return $riverpod_9.StateController<$riverpod_13.Provider>(state);
          case $riverpod_10.StateNotifierProvider _:
            return $riverpod_9.StateController<
              $riverpod_10.StateNotifierProvider
            >(state);
          case $riverpod_11.StateProvider _:
            return $riverpod_9.StateController<$riverpod_11.StateProvider>(
              state,
            );
          case $riverpod_12.$NotifierProvider _:
            return $riverpod_9.StateController<$riverpod_12.$NotifierProvider>(
              state,
            );
          case $riverpod_7.AsyncNotifierProviderFamily _:
            return $riverpod_9.StateController<
              $riverpod_7.AsyncNotifierProviderFamily
            >(state);
          case $riverpod_8.FutureProviderFamily _:
            return $riverpod_9.StateController<
              $riverpod_8.FutureProviderFamily
            >(state);
          case $riverpod_12.NotifierProviderFamily _:
            return $riverpod_9.StateController<
              $riverpod_12.NotifierProviderFamily
            >(state);
          case $riverpod_13.ProviderFamily _:
            return $riverpod_9.StateController<$riverpod_13.ProviderFamily>(
              state,
            );
          case $riverpod_10.StateNotifierProviderFamily _:
            return $riverpod_9.StateController<
              $riverpod_10.StateNotifierProviderFamily
            >(state);
          case $riverpod_11.StateProviderFamily _:
            return $riverpod_9.StateController<
              $riverpod_11.StateProviderFamily
            >(state);
          case $riverpod_14.StreamNotifierProviderFamily _:
            return $riverpod_9.StateController<
              $riverpod_14.StreamNotifierProviderFamily
            >(state);
          case $riverpod_15.StreamProviderFamily _:
            return $riverpod_9.StateController<
              $riverpod_15.StreamProviderFamily
            >(state);
          case $riverpod_6.ProviderBase _:
            return $riverpod_9.StateController<$riverpod_6.ProviderBase>(state);
          case $riverpod_7.AsyncNotifier _:
            return $riverpod_9.StateController<$riverpod_7.AsyncNotifier>(
              state,
            );
          case $riverpod_6.Family _:
            return $riverpod_9.StateController<$riverpod_6.Family>(state);
          case $riverpod_14.StreamNotifier _:
            return $riverpod_9.StateController<$riverpod_14.StreamNotifier>(
              state,
            );
          case $riverpod_7.$AsyncNotifier _:
            return $riverpod_9.StateController<$riverpod_7.$AsyncNotifier>(
              state,
            );
          case $riverpod_14.$StreamNotifier _:
            return $riverpod_9.StateController<$riverpod_14.$StreamNotifier>(
              state,
            );
          case $riverpod_12.Notifier _:
            return $riverpod_9.StateController<$riverpod_12.Notifier>(state);
          case $riverpod_6.SyncProviderTransformerMixin _:
            return $riverpod_9.StateController<
              $riverpod_6.SyncProviderTransformerMixin
            >(state);
          case $riverpod_12.$Notifier _:
            return $riverpod_9.StateController<$riverpod_12.$Notifier>(state);
          case $riverpod_6.$ProviderOverride _:
            return $riverpod_9.StateController<$riverpod_6.$ProviderOverride>(
              state,
            );
          case $riverpod_6.AsyncData _:
            return $riverpod_9.StateController<$riverpod_6.AsyncData>(state);
          case $riverpod_6.AsyncError _:
            return $riverpod_9.StateController<$riverpod_6.AsyncError>(state);
          case $riverpod_6.AsyncProviderListenable _:
            return $riverpod_9.StateController<
              $riverpod_6.AsyncProviderListenable
            >(state);
          case $riverpod_kit_1.Consumer _:
            return $riverpod_9.StateController<$riverpod_kit_1.Consumer>(state);
          case $riverpod_6.Mutation _:
            return $riverpod_9.StateController<$riverpod_6.Mutation>(state);
          case $riverpod_6.Ref _:
            return $riverpod_9.StateController<$riverpod_6.Ref>(state);
          case $riverpod_6.Refreshable _:
            return $riverpod_9.StateController<$riverpod_6.Refreshable>(state);
          case $riverpod_6.AsyncLoading _:
            return $riverpod_9.StateController<$riverpod_6.AsyncLoading>(state);
          case $riverpod_6.AsyncValueIsLoadingException _:
            return $riverpod_9.StateController<
              $riverpod_6.AsyncValueIsLoadingException
            >(state);
          case $riverpod_kit_1.ConsumerWidget _:
            return $riverpod_9.StateController<$riverpod_kit_1.ConsumerWidget>(
              state,
            );
          case $riverpod_6.DevtoolObserver _:
            return $riverpod_9.StateController<$riverpod_6.DevtoolObserver>(
              state,
            );
          case $riverpod_6.MutationError _:
            return $riverpod_9.StateController<$riverpod_6.MutationError>(
              state,
            );
          case $riverpod_6.MutationIdle _:
            return $riverpod_9.StateController<$riverpod_6.MutationIdle>(state);
          case $riverpod_6.MutationPending _:
            return $riverpod_9.StateController<$riverpod_6.MutationPending>(
              state,
            );
          case $riverpod_6.MutationSuccess _:
            return $riverpod_9.StateController<$riverpod_6.MutationSuccess>(
              state,
            );
          case $riverpod_6.ProviderContainer _:
            return $riverpod_9.StateController<$riverpod_6.ProviderContainer>(
              state,
            );
          case $riverpod_2.ProviderException _:
            return $riverpod_9.StateController<$riverpod_2.ProviderException>(
              state,
            );
          case $riverpod_6.ProviderListenable _:
            return $riverpod_9.StateController<$riverpod_6.ProviderListenable>(
              state,
            );
          case $riverpod_6.AnyNotifier _:
            return $riverpod_9.StateController<$riverpod_6.AnyNotifier>(state);
          case $riverpod_kit_1.ConsumerState _:
            return $riverpod_9.StateController<$riverpod_kit_1.ConsumerState>(
              state,
            );
          case $riverpod_kit_1.ConsumerStatefulWidget _:
            return $riverpod_9.StateController<
              $riverpod_kit_1.ConsumerStatefulWidget
            >(state);
          case $riverpod_6.KeepAliveLink _:
            return $riverpod_9.StateController<$riverpod_6.KeepAliveLink>(
              state,
            );
          case $riverpod_6.MutationTarget _:
            return $riverpod_9.StateController<$riverpod_6.MutationTarget>(
              state,
            );
          case $riverpod_6.MutationTransaction _:
            return $riverpod_9.StateController<$riverpod_6.MutationTransaction>(
              state,
            );
          case $riverpod_6.Override _:
            return $riverpod_9.StateController<$riverpod_6.Override>(state);
          case $riverpod_6.PersistResult _:
            return $riverpod_9.StateController<$riverpod_6.PersistResult>(
              state,
            );
          case $riverpod_5.PersistedData _:
            return $riverpod_9.StateController<$riverpod_5.PersistedData>(
              state,
            );
          case $riverpod_6.ProviderListenableOrFamily _:
            return $riverpod_9.StateController<
              $riverpod_6.ProviderListenableOrFamily
            >(state);
          case $riverpod_6.ProviderObserver _:
            return $riverpod_9.StateController<$riverpod_6.ProviderObserver>(
              state,
            );
          case $riverpod_6.ProviderObserverContext _:
            return $riverpod_9.StateController<
              $riverpod_6.ProviderObserverContext
            >(state);
          case $riverpod_6.ProviderReference _:
            return $riverpod_9.StateController<$riverpod_6.ProviderReference>(
              state,
            );
          case $riverpod_kit_2.ProviderScope _:
            return $riverpod_9.StateController<$riverpod_kit_2.ProviderScope>(
              state,
            );
          case $riverpod_6.ProviderSubscription _:
            return $riverpod_9.StateController<
              $riverpod_6.ProviderSubscription
            >(state);
          case $riverpod_6.ProviderTransformer _:
            return $riverpod_9.StateController<$riverpod_6.ProviderTransformer>(
              state,
            );
          case $riverpod_6.ProviderTransformerContext _:
            return $riverpod_9.StateController<
              $riverpod_6.ProviderTransformerContext
            >(state);
          case $riverpod_kit_2.RootRegistration _:
            return $riverpod_9.StateController<
              $riverpod_kit_2.RootRegistration
            >(state);
          case $riverpod_5.Storage _:
            return $riverpod_9.StateController<$riverpod_5.Storage>(state);
          case $riverpod_5.StorageCacheTime _:
            return $riverpod_9.StateController<$riverpod_5.StorageCacheTime>(
              state,
            );
          case $riverpod_5.StorageOptions _:
            return $riverpod_9.StateController<$riverpod_5.StorageOptions>(
              state,
            );
          case $riverpod_kit_2.UncontrolledProviderScope _:
            return $riverpod_9.StateController<
              $riverpod_kit_2.UncontrolledProviderScope
            >(state);
          case $riverpod_kit_3.WidgetRef _:
            return $riverpod_9.StateController<$riverpod_kit_3.WidgetRef>(
              state,
            );
          default:
            return $riverpod_9.StateController(state);
        }
      },
    },
    getters: {
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_9.StateController>(
            target,
            'StateController',
          )
          .state,
      'onError': (visitor, target) => D4
          .validateTarget<$riverpod_9.StateController>(
            target,
            'StateController',
          )
          .onError,
      'mounted': (visitor, target) => D4
          .validateTarget<$riverpod_9.StateController>(
            target,
            'StateController',
          )
          .mounted,
      'stream': (visitor, target) => D4
          .validateTarget<$riverpod_9.StateController>(
            target,
            'StateController',
          )
          .stream,
      'debugState': (visitor, target) => D4
          .validateTarget<$riverpod_9.StateController>(
            target,
            'StateController',
          )
          .debugState,
      'hasListeners': (visitor, target) => D4
          .validateTarget<$riverpod_9.StateController>(
            target,
            'StateController',
          )
          .hasListeners,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
                  .validateTarget<$riverpod_9.StateController>(
                    target,
                    'StateController',
                  )
                  .state =
              value as dynamic,
      'onError': (visitor, target, value) {
        final onErrorRaw = D4.extractBridgedArgOrNull<dynamic>(
          value,
          'onError',
        );
        D4
            .validateTarget<$riverpod_9.StateController>(
              target,
              'StateController',
            )
            .onError = (Object p0, StackTrace? p1) {
          D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
        };
      },
    },
    methods: {
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_9.StateController>(
          target,
          'StateController',
        );
        D4.requireMinArgs(positional, 1, 'update');
        if (positional.isEmpty) {
          throw ArgumentError(
            'update: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        return (t as dynamic).update((dynamic p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, cbRaw, [p0]),
          );
        });
      },
      'updateShouldNotify': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_9.StateController>(
          target,
          'StateController',
        );
        D4.requireMinArgs(positional, 2, 'updateShouldNotify');
        final old = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'old',
          'updateShouldNotify',
        );
        final current = D4.getRequiredArg<dynamic>(
          positional,
          1,
          'current',
          'updateShouldNotify',
        );
        return t.updateShouldNotify(old, current);
      },
      'addListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_9.StateController>(
          target,
          'StateController',
        );
        D4.requireMinArgs(positional, 1, 'addListener');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addListener: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        final fireImmediately = D4.getNamedArgWithDefault<bool>(
          named,
          'fireImmediately',
          true,
        );
        return (t as dynamic).addListener((dynamic p0) {
          D4.callInterpreterCallback(visitor!, listenerRaw, [p0]);
        }, fireImmediately: fireImmediately);
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_9.StateController>(
          target,
          'StateController',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    constructorSignatures: {
      '': 'StateController(StateT _state)',
    },
    methodSignatures: {
      'update': 'StateT update(StateT Function(StateT state) cb)',
      'updateShouldNotify':
          'bool updateShouldNotify(StateT old, StateT current)',
      'addListener':
          'RemoveListener addListener(Listener<StateT> listener, {bool fireImmediately = true})',
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'state': 'StateT get state',
      'onError':
          'void Function(Object error, StackTrace? stackTrace) get onError',
      'mounted': 'bool get mounted',
      'stream': 'Stream<StateT> get stream',
      'debugState': 'StateT get debugState',
      'hasListeners': 'bool get hasListeners',
    },
    setterSignatures: {
      'state': 'set state(StateT value)',
      'onError':
          'set onError(void Function(Object error, StackTrace? stackTrace) value)',
    },
  );
}

// =============================================================================
// StateNotifierProvider Bridge
// =============================================================================

BridgedClass _createStateNotifierProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_10.StateNotifierProvider,
    name: 'StateNotifierProvider',
    isAssignable: (v) => v is $riverpod_10.StateNotifierProvider,
    hierarchyDepth: 10,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'StateNotifierProvider');
        if (positional.isEmpty) {
          throw ArgumentError(
            'StateNotifierProvider: Missing required argument "_create" at position 0',
          );
        }
        final createRaw = positional[0];
        final name = D4.getOptionalNamedArg<String?>(named, 'name');
        final dependencies = D4.coerceListOrNull<$riverpod_6.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_10.StateNotifierProvider(
          (($riverpod_6.Ref p0) {
                return D4.extractBridgedArg<
                      $state_notifier_1.StateNotifier<dynamic>
                    >(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as $state_notifier_1.StateNotifier<dynamic>;
              })
              as $state_notifier_1.StateNotifier<dynamic> Function(
                $riverpod_6.Ref,
              ),
          name: name,
          dependencies: dependencies,
          isAutoDispose: isAutoDispose,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'notifier': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .isAutoDispose,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProvider>(
            target,
            'StateNotifierProvider',
          )
          .hashCode,
    },
    methods: {
      'create': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StateNotifierProvider>(
          target,
          'StateNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'create');
        final ref = D4.getRequiredArg<$riverpod_6.Ref>(
          positional,
          0,
          'ref',
          'create',
        );
        return t.create(ref);
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StateNotifierProvider>(
          target,
          'StateNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (($riverpod_6.Ref p0) {
                return D4.extractBridgedArg<
                      $state_notifier_1.StateNotifier<dynamic>
                    >(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as $state_notifier_1.StateNotifier<dynamic>;
              })
              as $state_notifier_1.StateNotifier<dynamic> Function(
                $riverpod_6.Ref,
              ),
        );
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StateNotifierProvider>(
          target,
          'StateNotifierProvider',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StateNotifierProvider>(
          target,
          'StateNotifierProvider',
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
      'autoDispose': (visitor) =>
          $riverpod_10.StateNotifierProvider.autoDispose,
      'family': (visitor) => $riverpod_10.StateNotifierProvider.family,
    },
    constructorSignatures: {
      '': 'StateNotifierProvider(NotifierT Function(Ref ref) _create, {String? name, Iterable<ProviderOrFamily>? dependencies, bool isAutoDispose = false, Retry? retry})',
    },
    methodSignatures: {
      'create': 'NotifierT create(Ref ref)',
      'overrideWith': 'Override overrideWith(Create<NotifierT> create)',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'notifier': 'Refreshable<NotifierT> get notifier',
      'from': 'Family? get from',
      'origin': 'ProviderBase<ValueT> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'autoDispose': 'AutoDisposeStateNotifierProviderBuilder get autoDispose',
      'family': 'StateNotifierProviderFamilyBuilder get family',
    },
  );
}

// =============================================================================
// StateNotifierProviderFamily Bridge
// =============================================================================

BridgedClass _createStateNotifierProviderFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_10.StateNotifierProviderFamily,
    name: 'StateNotifierProviderFamily',
    isAssignable: (v) => v is $riverpod_10.StateNotifierProviderFamily,
    hierarchyDepth: 7,
    constructors: {},
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProviderFamily>(
            target,
            'StateNotifierProviderFamily',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProviderFamily>(
            target,
            'StateNotifierProviderFamily',
          )
          .origin,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProviderFamily>(
            target,
            'StateNotifierProviderFamily',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProviderFamily>(
            target,
            'StateNotifierProviderFamily',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProviderFamily>(
            target,
            'StateNotifierProviderFamily',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProviderFamily>(
            target,
            'StateNotifierProviderFamily',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_10.StateNotifierProviderFamily>(
            target,
            'StateNotifierProviderFamily',
          )
          .isAutoDispose,
    },
    methods: {
      'call': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StateNotifierProviderFamily>(
          target,
          'StateNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'call');
        final argument = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'argument',
          'call',
        );
        return t.call(argument);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StateNotifierProviderFamily>(
          target,
          'StateNotifierProviderFamily',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StateNotifierProviderFamily>(
          target,
          'StateNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (($riverpod_6.Ref p0, dynamic p1) {
                return D4.extractBridgedArg<
                      $state_notifier_1.StateNotifier<dynamic>
                    >(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0, p1]),
                      'callback',
                      visitor,
                    )
                    as $state_notifier_1.StateNotifier<dynamic>;
              })
              as $state_notifier_1.StateNotifier<dynamic> Function(
                $riverpod_6.Ref,
                dynamic,
              ),
        );
      },
    },
    methodSignatures: {
      'call': 'StateNotifierProvider<NotifierT, ValueT> call(ArgT argument)',
      'toString': 'String toString()',
      'overrideWith':
          'Override overrideWith(NotifierT Function(Ref ref, ArgT arg) create)',
    },
    getterSignatures: {
      'from': 'Family get from',
      'origin': 'Family get origin',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
    },
  );
}

// =============================================================================
// StateProvider Bridge
// =============================================================================

BridgedClass _createStateProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_11.StateProvider,
    name: 'StateProvider',
    isAssignable: (v) => v is $riverpod_11.StateProvider,
    hierarchyDepth: 10,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'StateProvider');
        if (positional.isEmpty) {
          throw ArgumentError(
            'StateProvider: Missing required argument "_createFn" at position 0',
          );
        }
        final createFnRaw = positional[0];
        final name = D4.getOptionalNamedArg<String?>(named, 'name');
        final dependencies = D4.coerceListOrNull<$riverpod_6.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_11.StateProvider(
          ($riverpod_6.Ref p0) {
            return D4.castCallbackResult<dynamic>(
              D4.callInterpreterCallback(visitor!, createFnRaw, [p0]),
            );
          },
          name: name,
          dependencies: dependencies,
          isAutoDispose: isAutoDispose,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'notifier': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .isAutoDispose,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProvider>(target, 'StateProvider')
          .hashCode,
    },
    methods: {
      'create': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StateProvider>(
          target,
          'StateProvider',
        );
        D4.requireMinArgs(positional, 1, 'create');
        final ref = D4.getRequiredArg<$riverpod_6.Ref>(
          positional,
          0,
          'ref',
          'create',
        );
        return t.create(ref);
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StateProvider>(
          target,
          'StateProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(($riverpod_6.Ref p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, createRaw, [p0]),
          );
        });
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StateProvider>(
          target,
          'StateProvider',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StateProvider>(
          target,
          'StateProvider',
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
      'autoDispose': (visitor) => $riverpod_11.StateProvider.autoDispose,
      'family': (visitor) => $riverpod_11.StateProvider.family,
    },
    constructorSignatures: {
      '': 'StateProvider(ValueT Function(Ref ref) _createFn, {String? name, Iterable<ProviderOrFamily>? dependencies, bool isAutoDispose = false, Retry? retry})',
    },
    methodSignatures: {
      'create': 'ValueT create(Ref ref)',
      'overrideWith': 'Override overrideWith(Create<ValueT> create)',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'notifier': 'Refreshable<StateController<ValueT>> get notifier',
      'from': 'Family? get from',
      'origin': 'ProviderBase<ValueT> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'autoDispose': 'AutoDisposeStateProviderBuilder get autoDispose',
      'family': 'StateProviderFamilyBuilder get family',
    },
  );
}

// =============================================================================
// StateProviderFamily Bridge
// =============================================================================

BridgedClass _createStateProviderFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_11.StateProviderFamily,
    name: 'StateProviderFamily',
    isAssignable: (v) => v is $riverpod_11.StateProviderFamily,
    hierarchyDepth: 7,
    constructors: {},
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProviderFamily>(
            target,
            'StateProviderFamily',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProviderFamily>(
            target,
            'StateProviderFamily',
          )
          .origin,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProviderFamily>(
            target,
            'StateProviderFamily',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProviderFamily>(
            target,
            'StateProviderFamily',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProviderFamily>(
            target,
            'StateProviderFamily',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProviderFamily>(
            target,
            'StateProviderFamily',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_11.StateProviderFamily>(
            target,
            'StateProviderFamily',
          )
          .isAutoDispose,
    },
    methods: {
      'call': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StateProviderFamily>(
          target,
          'StateProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'call');
        final argument = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'argument',
          'call',
        );
        return t.call(argument);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StateProviderFamily>(
          target,
          'StateProviderFamily',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StateProviderFamily>(
          target,
          'StateProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(($riverpod_6.Ref p0, dynamic p1) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, createRaw, [p0, p1]),
          );
        });
      },
    },
    methodSignatures: {
      'call': 'StateProvider<ValueT> call(ArgT argument)',
      'toString': 'String toString()',
      'overrideWith':
          'Override overrideWith(ValueT Function(Ref ref, ArgT arg) create)',
    },
    getterSignatures: {
      'from': 'Family get from',
      'origin': 'Family get origin',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
    },
  );
}

// =============================================================================
// $Notifier Bridge
// =============================================================================

BridgedClass _create$NotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_12.$Notifier,
    name: '\$Notifier',
    isAssignable: (v) => v is $riverpod_12.$Notifier,
    hierarchyDepth: 2,
    isAbstract: true,
    constructors: {},
    getters: {
      'stateOrNull': (visitor, target) => D4
          .validateTarget<$riverpod_12.$Notifier>(target, '\$Notifier')
          .stateOrNull,
      'ref': (visitor, target) =>
          D4.validateTarget<$riverpod_12.$Notifier>(target, '\$Notifier').ref,
      'state': (visitor, target) =>
          D4.validateTarget<$riverpod_12.$Notifier>(target, '\$Notifier').state,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
                  .validateTarget<$riverpod_12.$Notifier>(target, '\$Notifier')
                  .state =
              value as dynamic,
    },
    methods: {
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.$Notifier>(
          target,
          '\$Notifier',
        );
        D4.requireMinArgs(positional, 1, 'listenSelf');
        if (positional.isEmpty) {
          throw ArgumentError(
            'listenSelf: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).listenSelf(
          (dynamic p0, dynamic p1) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
        );
      },
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.$Notifier>(
          target,
          '\$Notifier',
        );
        return t.runBuild();
      },
    },
    methodSignatures: {
      'listenSelf':
          'RemoveListener listenSelf(void Function(StateT? previous, StateT next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
      'runBuild': 'WhenComplete? runBuild()',
    },
    getterSignatures: {
      'stateOrNull': 'StateT? get stateOrNull',
      'ref': 'Ref get ref',
      'state': 'StateT get state',
    },
    setterSignatures: {
      'state': 'set state(StateT value)',
    },
  );
}

// =============================================================================
// $NotifierProvider Bridge
// =============================================================================

BridgedClass _create$NotifierProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_12.$NotifierProvider,
    name: '\$NotifierProvider',
    isAssignable: (v) => v is $riverpod_12.$NotifierProvider,
    hierarchyDepth: 9,
    isAbstract: true,
    constructors: {},
    getters: {
      'notifier': (visitor, target) => D4
          .validateTarget<$riverpod_12.$NotifierProvider>(
            target,
            '\$NotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_12.$NotifierProvider>(
            target,
            '\$NotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_12.$NotifierProvider>(
            target,
            '\$NotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_12.$NotifierProvider>(
            target,
            '\$NotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_12.$NotifierProvider>(
            target,
            '\$NotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_12.$NotifierProvider>(
            target,
            '\$NotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_12.$NotifierProvider>(
            target,
            '\$NotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_12.$NotifierProvider>(
            target,
            '\$NotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_12.$NotifierProvider>(
            target,
            '\$NotifierProvider',
          )
          .isAutoDispose,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.$NotifierProvider>(
          target,
          '\$NotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (() {
                return D4.extractBridgedArg<$riverpod_12.$Notifier<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_12.$Notifier<dynamic>;
              })
              as $riverpod_12.$Notifier<dynamic> Function(),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.$NotifierProvider>(
          target,
          '\$NotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithBuild');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWithBuild: Missing required argument "build" at position 0',
          );
        }
        final buildRaw = positional[0];
        return (t as dynamic).overrideWithBuild((
          $riverpod_6.Ref p0,
          $riverpod_12.$Notifier<dynamic> p1,
        ) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
          );
        });
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.$NotifierProvider>(
          target,
          '\$NotifierProvider',
        );
        return t.toString();
      },
    },
    methodSignatures: {
      'overrideWith': 'Override overrideWith(NotifierT Function() create)',
      'overrideWithBuild':
          'Override overrideWithBuild(RunNotifierBuild<NotifierT, StateT> build)',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'notifier': 'Refreshable<NotifierT> get notifier',
      'from': 'Family? get from',
      'origin': 'ProviderBase<StateT> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
    },
  );
}

// =============================================================================
// Notifier Bridge
// =============================================================================

BridgedClass _createNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_12.Notifier,
    name: 'Notifier',
    isAssignable: (v) => v is $riverpod_12.Notifier,
    hierarchyDepth: 3,
    isAbstract: true,
    constructors: {},
    getters: {
      'stateOrNull': (visitor, target) => D4
          .validateTarget<$riverpod_12.Notifier>(target, 'Notifier')
          .stateOrNull,
      'ref': (visitor, target) =>
          D4.validateTarget<$riverpod_12.Notifier>(target, 'Notifier').ref,
      'state': (visitor, target) =>
          D4.validateTarget<$riverpod_12.Notifier>(target, 'Notifier').state,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4.validateTarget<$riverpod_12.Notifier>(target, 'Notifier').state =
              value as dynamic,
    },
    methods: {
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.Notifier>(target, 'Notifier');
        D4.requireMinArgs(positional, 1, 'listenSelf');
        if (positional.isEmpty) {
          throw ArgumentError(
            'listenSelf: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).listenSelf(
          (dynamic p0, dynamic p1) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
        );
      },
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.Notifier>(target, 'Notifier');
        return t.runBuild();
      },
    },
    methodSignatures: {
      'listenSelf':
          'RemoveListener listenSelf(void Function(ValueT? previous, ValueT next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
      'runBuild': 'WhenComplete? runBuild()',
    },
    getterSignatures: {
      'stateOrNull': 'ValueT get stateOrNull',
      'ref': 'Ref get ref',
      'state': 'ValueT get state',
    },
    setterSignatures: {
      'state': 'set state(ValueT value)',
    },
  );
}

// =============================================================================
// NotifierProvider Bridge
// =============================================================================

BridgedClass _createNotifierProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_12.NotifierProvider,
    name: 'NotifierProvider',
    isAssignable: (v) => v is $riverpod_12.NotifierProvider,
    hierarchyDepth: 11,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'NotifierProvider');
        if (positional.isEmpty) {
          throw ArgumentError(
            'NotifierProvider: Missing required argument "_createNotifier" at position 0',
          );
        }
        final createNotifierRaw = positional[0];
        final name = D4.getOptionalNamedArg<String?>(named, 'name');
        final dependencies = D4.coerceListOrNull<$riverpod_6.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_12.NotifierProvider(
          (() {
                return D4.extractBridgedArg<$riverpod_12.Notifier<dynamic>>(
                      D4.callInterpreterCallback(
                        visitor!,
                        createNotifierRaw,
                        [],
                      ),
                      'callback',
                      visitor,
                    )
                    as $riverpod_12.Notifier<dynamic>;
              })
              as $riverpod_12.Notifier<dynamic> Function(),
          name: name,
          dependencies: dependencies,
          isAutoDispose: isAutoDispose,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'notifier': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .isAutoDispose,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .hashCode,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.NotifierProvider>(
          target,
          'NotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (() {
                return D4.extractBridgedArg<$riverpod_12.Notifier<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_12.Notifier<dynamic>;
              })
              as $riverpod_12.Notifier<dynamic> Function(),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.NotifierProvider>(
          target,
          'NotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithBuild');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWithBuild: Missing required argument "build" at position 0',
          );
        }
        final buildRaw = positional[0];
        return (t as dynamic).overrideWithBuild((
          $riverpod_6.Ref p0,
          $riverpod_12.Notifier<dynamic> p1,
        ) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
          );
        });
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.NotifierProvider>(
          target,
          'NotifierProvider',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.NotifierProvider>(
          target,
          'NotifierProvider',
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
      'autoDispose': (visitor) => $riverpod_12.NotifierProvider.autoDispose,
      'family': (visitor) => $riverpod_12.NotifierProvider.family,
    },
    constructorSignatures: {
      '': 'NotifierProvider(NotifierT Function() _createNotifier, {String? name, Iterable<ProviderOrFamily>? dependencies, bool isAutoDispose = false, Retry? retry})',
    },
    methodSignatures: {
      'overrideWith': 'Override overrideWith(NotifierT Function() create)',
      'overrideWithBuild':
          'Override overrideWithBuild(RunNotifierBuild<NotifierT, ValueT> build)',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'notifier': 'Refreshable<NotifierT> get notifier',
      'from': 'Family? get from',
      'origin': 'ProviderBase<ValueT> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'autoDispose': 'AutoDisposeNotifierProviderBuilder get autoDispose',
      'family': 'NotifierProviderFamilyBuilder get family',
    },
  );
}

// =============================================================================
// NotifierProviderFamily Bridge
// =============================================================================

BridgedClass _createNotifierProviderFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_12.NotifierProviderFamily,
    name: 'NotifierProviderFamily',
    isAssignable: (v) => v is $riverpod_12.NotifierProviderFamily,
    hierarchyDepth: 7,
    constructors: {},
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProviderFamily>(
            target,
            'NotifierProviderFamily',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProviderFamily>(
            target,
            'NotifierProviderFamily',
          )
          .origin,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProviderFamily>(
            target,
            'NotifierProviderFamily',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProviderFamily>(
            target,
            'NotifierProviderFamily',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProviderFamily>(
            target,
            'NotifierProviderFamily',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProviderFamily>(
            target,
            'NotifierProviderFamily',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_12.NotifierProviderFamily>(
            target,
            'NotifierProviderFamily',
          )
          .isAutoDispose,
    },
    methods: {
      'call': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.NotifierProviderFamily>(
          target,
          'NotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'call');
        final argument = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'argument',
          'call',
        );
        return t.call(argument);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.NotifierProviderFamily>(
          target,
          'NotifierProviderFamily',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.NotifierProviderFamily>(
          target,
          'NotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (() {
                return D4.extractBridgedArg<$riverpod_12.Notifier<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_12.Notifier<dynamic>;
              })
              as $riverpod_12.Notifier<dynamic> Function(),
        );
      },
      'overrideWith2': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.NotifierProviderFamily>(
          target,
          'NotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith2');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith2: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith2(
          ((dynamic p0) {
                return D4.extractBridgedArg<$riverpod_12.Notifier<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as $riverpod_12.Notifier<dynamic>;
              })
              as $riverpod_12.Notifier<dynamic> Function(dynamic),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_12.NotifierProviderFamily>(
          target,
          'NotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithBuild');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWithBuild: Missing required argument "build" at position 0',
          );
        }
        final buildRaw = positional[0];
        return (t as dynamic).overrideWithBuild((
          $riverpod_6.Ref p0,
          $riverpod_12.Notifier<dynamic> p1,
        ) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
          );
        });
      },
    },
    methodSignatures: {
      'call': 'NotifierProvider<NotifierT, StateT> call(ArgT argument)',
      'toString': 'String toString()',
      'overrideWith': 'Override overrideWith(NotifierT Function() create)',
      'overrideWith2':
          'Override overrideWith2(NotifierT Function(ArgT arg) create)',
      'overrideWithBuild':
          'Override overrideWithBuild(RunNotifierBuild<NotifierT, StateT> build)',
    },
    getterSignatures: {
      'from': 'Family get from',
      'origin': 'Family get origin',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
    },
  );
}

// =============================================================================
// Provider Bridge
// =============================================================================

BridgedClass _createProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_13.Provider,
    name: 'Provider',
    isAssignable: (v) => v is $riverpod_13.Provider,
    hierarchyDepth: 11,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Provider');
        if (positional.isEmpty) {
          throw ArgumentError(
            'Provider: Missing required argument "_create" at position 0',
          );
        }
        final createRaw = positional[0];
        final name = D4.getOptionalNamedArg<String?>(named, 'name');
        final dependencies = D4.coerceListOrNull<$riverpod_6.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_13.Provider(
          ($riverpod_6.Ref p0) {
            return D4.castCallbackResult<dynamic>(
              D4.callInterpreterCallback(visitor!, createRaw, [p0]),
            );
          },
          name: name,
          dependencies: dependencies,
          isAutoDispose: isAutoDispose,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'from': (visitor, target) =>
          D4.validateTarget<$riverpod_13.Provider>(target, 'Provider').from,
      'origin': (visitor, target) =>
          D4.validateTarget<$riverpod_13.Provider>(target, 'Provider').origin,
      'argument': (visitor, target) =>
          D4.validateTarget<$riverpod_13.Provider>(target, 'Provider').argument,
      'name': (visitor, target) =>
          D4.validateTarget<$riverpod_13.Provider>(target, 'Provider').name,
      'retry': (visitor, target) =>
          D4.validateTarget<$riverpod_13.Provider>(target, 'Provider').retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_13.Provider>(target, 'Provider')
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_13.Provider>(target, 'Provider')
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_13.Provider>(target, 'Provider')
          .isAutoDispose,
      'hashCode': (visitor, target) =>
          D4.validateTarget<$riverpod_13.Provider>(target, 'Provider').hashCode,
    },
    methods: {
      'overrideWithValue': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_13.Provider>(target, 'Provider');
        D4.requireMinArgs(positional, 1, 'overrideWithValue');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'value',
          'overrideWithValue',
        );
        return t.overrideWithValue(value);
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_13.Provider>(target, 'Provider');
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(($riverpod_6.Ref p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, createRaw, [p0]),
          );
        });
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_13.Provider>(target, 'Provider');
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_13.Provider>(target, 'Provider');
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
      'autoDispose': (visitor) => $riverpod_13.Provider.autoDispose,
      'family': (visitor) => $riverpod_13.Provider.family,
    },
    constructorSignatures: {
      '': 'Provider(Create<ValueT> _create, {String? name, Iterable<ProviderOrFamily>? dependencies, bool isAutoDispose = false, Retry? retry})',
    },
    methodSignatures: {
      'overrideWithValue': 'Override overrideWithValue(ValueT value)',
      'overrideWith': 'Override overrideWith(Create<ValueT> create)',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'from': 'Family? get from',
      'origin': 'ProviderBase<ValueT> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'autoDispose': 'AutoDisposeProviderBuilder get autoDispose',
      'family': 'ProviderFamilyBuilder get family',
    },
  );
}

// =============================================================================
// ProviderFamily Bridge
// =============================================================================

BridgedClass _createProviderFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_13.ProviderFamily,
    name: 'ProviderFamily',
    isAssignable: (v) => v is $riverpod_13.ProviderFamily,
    hierarchyDepth: 7,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'ProviderFamily');
        if (positional.isEmpty) {
          throw ArgumentError(
            'ProviderFamily: Missing required argument "_createFn" at position 0',
          );
        }
        final createFnRaw = positional[0];
        final name = D4.getOptionalNamedArg<String?>(named, 'name');
        final dependencies = D4.coerceListOrNull<$riverpod_6.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_13.ProviderFamily(
          ($riverpod_6.Ref p0, dynamic p1) {
            return D4.castCallbackResult<dynamic>(
              D4.callInterpreterCallback(visitor!, createFnRaw, [p0, p1]),
            );
          },
          name: name,
          dependencies: dependencies,
          isAutoDispose: isAutoDispose,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_13.ProviderFamily>(target, 'ProviderFamily')
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_13.ProviderFamily>(target, 'ProviderFamily')
          .origin,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_13.ProviderFamily>(target, 'ProviderFamily')
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_13.ProviderFamily>(target, 'ProviderFamily')
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_13.ProviderFamily>(target, 'ProviderFamily')
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_13.ProviderFamily>(target, 'ProviderFamily')
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_13.ProviderFamily>(target, 'ProviderFamily')
          .isAutoDispose,
    },
    methods: {
      'call': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_13.ProviderFamily>(
          target,
          'ProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'call');
        final argument = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'argument',
          'call',
        );
        return t.call(argument);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_13.ProviderFamily>(
          target,
          'ProviderFamily',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_13.ProviderFamily>(
          target,
          'ProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(($riverpod_6.Ref p0, dynamic p1) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, createRaw, [p0, p1]),
          );
        });
      },
    },
    constructorSignatures: {
      '': 'ProviderFamily(StateT Function(Ref ref, ArgT arg) _createFn, {String? name, Iterable<ProviderOrFamily>? dependencies, bool isAutoDispose = false, Retry? retry})',
    },
    methodSignatures: {
      'call': 'Provider<StateT> call(ArgT argument)',
      'toString': 'String toString()',
      'overrideWith':
          'Override overrideWith(StateT Function(Ref ref, ArgT arg) create)',
    },
    getterSignatures: {
      'from': 'Family get from',
      'origin': 'Family get origin',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
    },
  );
}

// =============================================================================
// $StreamNotifier Bridge
// =============================================================================

BridgedClass _create$StreamNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_14.$StreamNotifier,
    name: '\$StreamNotifier',
    isAssignable: (v) => v is $riverpod_14.$StreamNotifier,
    hierarchyDepth: 3,
    isAbstract: true,
    constructors: {},
    getters: {
      'ref': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifier>(
            target,
            '\$StreamNotifier',
          )
          .ref,
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifier>(
            target,
            '\$StreamNotifier',
          )
          .state,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifier>(
            target,
            '\$StreamNotifier',
          )
          .future,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
              .validateTarget<$riverpod_14.$StreamNotifier>(
                target,
                '\$StreamNotifier',
              )
              .state = D4.extractBridgedArg<$riverpod_6.AsyncValue<dynamic>>(
            value,
            'state',
          ),
    },
    methods: {
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.$StreamNotifier>(
          target,
          '\$StreamNotifier',
        );
        D4.requireMinArgs(positional, 1, 'listenSelf');
        if (positional.isEmpty) {
          throw ArgumentError(
            'listenSelf: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).listenSelf(
          (
            $riverpod_6.AsyncValue<dynamic>? p0,
            $riverpod_6.AsyncValue<dynamic> p1,
          ) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
        );
      },
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.$StreamNotifier>(
          target,
          '\$StreamNotifier',
        );
        return t.runBuild();
      },
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.$StreamNotifier>(
          target,
          '\$StreamNotifier',
        );
        D4.requireMinArgs(positional, 1, 'update');
        if (positional.isEmpty) {
          throw ArgumentError(
            'update: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).update(
          ((dynamic p0) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, cbRaw, [p0]),
                );
              })
              as FutureOr<Object?> Function(dynamic),
          onError: onErrorRaw == null
              ? null
              : ((Object p0, StackTrace p1) {
                      return D4.castCallbackResult<FutureOr<Object?>>(
                        D4.callInterpreterCallback(visitor!, onErrorRaw, [
                          p0,
                          p1,
                        ]),
                      );
                    })
                    as FutureOr<Object?> Function(Object, StackTrace),
        );
      },
    },
    methodSignatures: {
      'listenSelf':
          'RemoveListener listenSelf(void Function(AsyncValue<ValueT>? previous, AsyncValue<ValueT> next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
      'runBuild': 'WhenComplete? runBuild()',
      'update':
          'Future<ValueT> update(FutureOr<ValueT> Function(ValueT previousState) cb, {FutureOr<ValueT> Function(Object err, StackTrace stackTrace)? onError})',
    },
    getterSignatures: {
      'ref': 'Ref get ref',
      'state': 'AsyncValue<ValueT> get state',
      'future': 'Future<ValueT> get future',
    },
    setterSignatures: {
      'state': 'set state(AsyncValue<ValueT> value)',
    },
  );
}

// =============================================================================
// $StreamNotifierProvider Bridge
// =============================================================================

BridgedClass _create$StreamNotifierProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_14.$StreamNotifierProvider,
    name: '\$StreamNotifierProvider',
    isAssignable: (v) => v is $riverpod_14.$StreamNotifierProvider,
    hierarchyDepth: 11,
    isAbstract: true,
    constructors: {},
    getters: {
      'notifier': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_14.$StreamNotifierProvider>(
            target,
            '\$StreamNotifierProvider',
          )
          .future,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.$StreamNotifierProvider>(
          target,
          '\$StreamNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (() {
                return D4.extractBridgedArg<
                      $riverpod_14.$StreamNotifier<dynamic>
                    >(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_14.$StreamNotifier<dynamic>;
              })
              as $riverpod_14.$StreamNotifier<dynamic> Function(),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.$StreamNotifierProvider>(
          target,
          '\$StreamNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithBuild');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWithBuild: Missing required argument "build" at position 0',
          );
        }
        final buildRaw = positional[0];
        return (t as dynamic).overrideWithBuild(
          (($riverpod_6.Ref p0, $riverpod_14.$StreamNotifier<dynamic> p1) {
                return D4.extractBridgedArg<Stream<dynamic>>(
                      D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
                      'callback',
                      visitor,
                    )
                    as Stream<dynamic>;
              })
              as Stream<dynamic> Function(
                $riverpod_6.Ref,
                $riverpod_14.$StreamNotifier<dynamic>,
              ),
        );
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.$StreamNotifierProvider>(
          target,
          '\$StreamNotifierProvider',
        );
        return t.toString();
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.$StreamNotifierProvider>(
          target,
          '\$StreamNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'selectAsync');
        if (positional.isEmpty) {
          throw ArgumentError(
            'selectAsync: Missing required argument "selector" at position 0',
          );
        }
        final selectorRaw = positional[0];
        return (t as dynamic).selectAsync((dynamic p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, selectorRaw, [p0]),
          );
        });
      },
    },
    methodSignatures: {
      'overrideWith': 'Override overrideWith(NotifierT Function() create)',
      'overrideWithBuild':
          'Override overrideWithBuild(RunNotifierBuild<NotifierT, Stream<ValueT>> build)',
      'toString': 'String toString()',
      'selectAsync':
          'ProviderListenable<Future<OutT>> selectAsync(OutT Function(ValueT data) selector)',
    },
    getterSignatures: {
      'notifier': 'Refreshable<NotifierT> get notifier',
      'from': 'Family? get from',
      'origin': 'ProviderBase<AsyncValue<ValueT>> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'future': 'Refreshable<Future<ValueT>> get future',
    },
  );
}

// =============================================================================
// StreamNotifierProviderFamily Bridge
// =============================================================================

BridgedClass _createStreamNotifierProviderFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_14.StreamNotifierProviderFamily,
    name: 'StreamNotifierProviderFamily',
    isAssignable: (v) => v is $riverpod_14.StreamNotifierProviderFamily,
    hierarchyDepth: 7,
    constructors: {},
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
            target,
            'StreamNotifierProviderFamily',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
            target,
            'StreamNotifierProviderFamily',
          )
          .origin,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
            target,
            'StreamNotifierProviderFamily',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
            target,
            'StreamNotifierProviderFamily',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
            target,
            'StreamNotifierProviderFamily',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
            target,
            'StreamNotifierProviderFamily',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
            target,
            'StreamNotifierProviderFamily',
          )
          .isAutoDispose,
    },
    methods: {
      'call': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
          target,
          'StreamNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'call');
        final argument = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'argument',
          'call',
        );
        return t.call(argument);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
          target,
          'StreamNotifierProviderFamily',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
          target,
          'StreamNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (() {
                return D4.extractBridgedArg<
                      $riverpod_14.StreamNotifier<dynamic>
                    >(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_14.StreamNotifier<dynamic>;
              })
              as $riverpod_14.StreamNotifier<dynamic> Function(),
        );
      },
      'overrideWith2': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
          target,
          'StreamNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith2');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith2: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith2(
          ((dynamic p0) {
                return D4.extractBridgedArg<
                      $riverpod_14.StreamNotifier<dynamic>
                    >(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as $riverpod_14.StreamNotifier<dynamic>;
              })
              as $riverpod_14.StreamNotifier<dynamic> Function(dynamic),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProviderFamily>(
          target,
          'StreamNotifierProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithBuild');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWithBuild: Missing required argument "build" at position 0',
          );
        }
        final buildRaw = positional[0];
        return (t as dynamic).overrideWithBuild(
          (($riverpod_6.Ref p0, $riverpod_14.StreamNotifier<dynamic> p1) {
                return D4.extractBridgedArg<Stream<dynamic>>(
                      D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
                      'callback',
                      visitor,
                    )
                    as Stream<dynamic>;
              })
              as Stream<dynamic> Function(
                $riverpod_6.Ref,
                $riverpod_14.StreamNotifier<dynamic>,
              ),
        );
      },
    },
    methodSignatures: {
      'call': 'StreamNotifierProvider<NotifierT, ValueT> call(ArgT argument)',
      'toString': 'String toString()',
      'overrideWith': 'Override overrideWith(NotifierT Function() create)',
      'overrideWith2':
          'Override overrideWith2(NotifierT Function(ArgT arg) create)',
      'overrideWithBuild':
          'Override overrideWithBuild(RunNotifierBuild<NotifierT, Stream<ValueT>> build)',
    },
    getterSignatures: {
      'from': 'Family get from',
      'origin': 'Family get origin',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
    },
  );
}

// =============================================================================
// StreamNotifier Bridge
// =============================================================================

BridgedClass _createStreamNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_14.StreamNotifier,
    name: 'StreamNotifier',
    isAssignable: (v) => v is $riverpod_14.StreamNotifier,
    hierarchyDepth: 4,
    isAbstract: true,
    constructors: {},
    getters: {
      'ref': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifier>(target, 'StreamNotifier')
          .ref,
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifier>(target, 'StreamNotifier')
          .state,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifier>(target, 'StreamNotifier')
          .future,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
              .validateTarget<$riverpod_14.StreamNotifier>(
                target,
                'StreamNotifier',
              )
              .state = D4.extractBridgedArg<$riverpod_6.AsyncValue<dynamic>>(
            value,
            'state',
          ),
    },
    methods: {
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifier>(
          target,
          'StreamNotifier',
        );
        D4.requireMinArgs(positional, 1, 'listenSelf');
        if (positional.isEmpty) {
          throw ArgumentError(
            'listenSelf: Missing required argument "listener" at position 0',
          );
        }
        final listenerRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).listenSelf(
          (
            $riverpod_6.AsyncValue<dynamic>? p0,
            $riverpod_6.AsyncValue<dynamic> p1,
          ) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
        );
      },
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifier>(
          target,
          'StreamNotifier',
        );
        return t.runBuild();
      },
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifier>(
          target,
          'StreamNotifier',
        );
        D4.requireMinArgs(positional, 1, 'update');
        if (positional.isEmpty) {
          throw ArgumentError(
            'update: Missing required argument "cb" at position 0',
          );
        }
        final cbRaw = positional[0];
        final onErrorRaw = named['onError'];
        return (t as dynamic).update(
          ((dynamic p0) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, cbRaw, [p0]),
                );
              })
              as FutureOr<Object?> Function(dynamic),
          onError: onErrorRaw == null
              ? null
              : ((Object p0, StackTrace p1) {
                      return D4.castCallbackResult<FutureOr<Object?>>(
                        D4.callInterpreterCallback(visitor!, onErrorRaw, [
                          p0,
                          p1,
                        ]),
                      );
                    })
                    as FutureOr<Object?> Function(Object, StackTrace),
        );
      },
    },
    methodSignatures: {
      'listenSelf':
          'RemoveListener listenSelf(void Function(AsyncValue<ValueT>? previous, AsyncValue<ValueT> next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
      'runBuild': 'WhenComplete? runBuild()',
      'update':
          'Future<ValueT> update(FutureOr<ValueT> Function(ValueT previousState) cb, {FutureOr<ValueT> Function(Object err, StackTrace stackTrace)? onError})',
    },
    getterSignatures: {
      'ref': 'Ref get ref',
      'state': 'AsyncValue<ValueT> get state',
      'future': 'Future<ValueT> get future',
    },
    setterSignatures: {
      'state': 'set state(AsyncValue<ValueT> value)',
    },
  );
}

// =============================================================================
// StreamNotifierProvider Bridge
// =============================================================================

BridgedClass _createStreamNotifierProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_14.StreamNotifierProvider,
    name: 'StreamNotifierProvider',
    isAssignable: (v) => v is $riverpod_14.StreamNotifierProvider,
    hierarchyDepth: 13,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'StreamNotifierProvider');
        if (positional.isEmpty) {
          throw ArgumentError(
            'StreamNotifierProvider: Missing required argument "_createNotifier" at position 0',
          );
        }
        final createNotifierRaw = positional[0];
        final name = D4.getOptionalNamedArg<String?>(named, 'name');
        final dependencies = D4.coerceListOrNull<$riverpod_6.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_14.StreamNotifierProvider(
          (() {
                return D4.extractBridgedArg<
                      $riverpod_14.StreamNotifier<dynamic>
                    >(
                      D4.callInterpreterCallback(
                        visitor!,
                        createNotifierRaw,
                        [],
                      ),
                      'callback',
                      visitor,
                    )
                    as $riverpod_14.StreamNotifier<dynamic>;
              })
              as $riverpod_14.StreamNotifier<dynamic> Function(),
          name: name,
          dependencies: dependencies,
          isAutoDispose: isAutoDispose,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'notifier': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .future,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_14.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .hashCode,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProvider>(
          target,
          'StreamNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (() {
                return D4.extractBridgedArg<
                      $riverpod_14.StreamNotifier<dynamic>
                    >(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_14.StreamNotifier<dynamic>;
              })
              as $riverpod_14.StreamNotifier<dynamic> Function(),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProvider>(
          target,
          'StreamNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithBuild');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWithBuild: Missing required argument "build" at position 0',
          );
        }
        final buildRaw = positional[0];
        return (t as dynamic).overrideWithBuild(
          (($riverpod_6.Ref p0, $riverpod_14.StreamNotifier<dynamic> p1) {
                return D4.extractBridgedArg<Stream<dynamic>>(
                      D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
                      'callback',
                      visitor,
                    )
                    as Stream<dynamic>;
              })
              as Stream<dynamic> Function(
                $riverpod_6.Ref,
                $riverpod_14.StreamNotifier<dynamic>,
              ),
        );
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProvider>(
          target,
          'StreamNotifierProvider',
        );
        return t.toString();
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProvider>(
          target,
          'StreamNotifierProvider',
        );
        D4.requireMinArgs(positional, 1, 'selectAsync');
        if (positional.isEmpty) {
          throw ArgumentError(
            'selectAsync: Missing required argument "selector" at position 0',
          );
        }
        final selectorRaw = positional[0];
        return (t as dynamic).selectAsync((dynamic p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, selectorRaw, [p0]),
          );
        });
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_14.StreamNotifierProvider>(
          target,
          'StreamNotifierProvider',
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
      'autoDispose': (visitor) =>
          $riverpod_14.StreamNotifierProvider.autoDispose,
      'family': (visitor) => $riverpod_14.StreamNotifierProvider.family,
    },
    constructorSignatures: {
      '': 'StreamNotifierProvider(NotifierT Function() _createNotifier, {String? name, Iterable<ProviderOrFamily>? dependencies, bool isAutoDispose = false, Retry? retry})',
    },
    methodSignatures: {
      'overrideWith': 'Override overrideWith(NotifierT Function() create)',
      'overrideWithBuild':
          'Override overrideWithBuild(RunNotifierBuild<NotifierT, Stream<ValueT>> build)',
      'toString': 'String toString()',
      'selectAsync':
          'ProviderListenable<Future<OutT>> selectAsync(OutT Function(ValueT data) selector)',
    },
    getterSignatures: {
      'notifier': 'Refreshable<NotifierT> get notifier',
      'from': 'Family? get from',
      'origin': 'ProviderBase<AsyncValue<ValueT>> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'future': 'Refreshable<Future<ValueT>> get future',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'autoDispose': 'AutoDisposeStreamNotifierProviderBuilder get autoDispose',
      'family': 'StreamNotifierProviderFamilyBuilder get family',
    },
  );
}

// =============================================================================
// StreamProvider Bridge
// =============================================================================

BridgedClass _createStreamProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_15.StreamProvider,
    name: 'StreamProvider',
    isAssignable: (v) => v is $riverpod_15.StreamProvider,
    hierarchyDepth: 13,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'StreamProvider');
        if (positional.isEmpty) {
          throw ArgumentError(
            'StreamProvider: Missing required argument "_create" at position 0',
          );
        }
        final createRaw = positional[0];
        final name = D4.getOptionalNamedArg<String?>(named, 'name');
        final dependencies = D4.coerceListOrNull<$riverpod_6.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_15.StreamProvider(
          (($riverpod_6.Ref p0) {
                return D4.extractBridgedArg<Stream<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as Stream<dynamic>;
              })
              as Stream<dynamic> Function($riverpod_6.Ref),
          name: name,
          dependencies: dependencies,
          isAutoDispose: isAutoDispose,
          retry: retryRaw == null
              ? null
              : ((int p0, Object p1) {
                      return D4.extractBridgedArg<Duration?>(
                            D4.callInterpreterCallback(visitor!, retryRaw, [
                              p0,
                              p1,
                            ]),
                            'callback',
                            visitor,
                          )
                          as Duration?;
                    })
                    as Duration? Function(int, Object),
        );
      },
    },
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .future,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProvider>(target, 'StreamProvider')
          .hashCode,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_15.StreamProvider>(
          target,
          'StreamProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (($riverpod_6.Ref p0) {
                return D4.extractBridgedArg<Stream<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as Stream<dynamic>;
              })
              as Stream<dynamic> Function($riverpod_6.Ref),
        );
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_15.StreamProvider>(
          target,
          'StreamProvider',
        );
        return t.toString();
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_15.StreamProvider>(
          target,
          'StreamProvider',
        );
        D4.requireMinArgs(positional, 1, 'selectAsync');
        if (positional.isEmpty) {
          throw ArgumentError(
            'selectAsync: Missing required argument "selector" at position 0',
          );
        }
        final selectorRaw = positional[0];
        return (t as dynamic).selectAsync((dynamic p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, selectorRaw, [p0]),
          );
        });
      },
      'overrideWithValue': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_15.StreamProvider>(
          target,
          'StreamProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithValue');
        final value = D4.getRequiredArg<$riverpod_6.AsyncValue<dynamic>>(
          positional,
          0,
          'value',
          'overrideWithValue',
        );
        return t.overrideWithValue(value);
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_15.StreamProvider>(
          target,
          'StreamProvider',
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
      'autoDispose': (visitor) => $riverpod_15.StreamProvider.autoDispose,
      'family': (visitor) => $riverpod_15.StreamProvider.family,
    },
    constructorSignatures: {
      '': 'StreamProvider(Create<Stream<ValueT>> _create, {String? name, Iterable<ProviderOrFamily>? dependencies, bool isAutoDispose = false, Retry? retry})',
    },
    methodSignatures: {
      'overrideWith': 'Override overrideWith(Create<Stream<ValueT>> create)',
      'toString': 'String toString()',
      'selectAsync':
          'ProviderListenable<Future<OutT>> selectAsync(OutT Function(ValueT data) selector)',
      'overrideWithValue':
          'Override overrideWithValue(AsyncValue<ValueT> value)',
    },
    getterSignatures: {
      'from': 'Family? get from',
      'origin': 'ProviderBase<AsyncValue<ValueT>> get origin',
      'argument': 'Object? get argument',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
      'future': 'Refreshable<Future<ValueT>> get future',
      'hashCode': 'int get hashCode',
    },
    staticGetterSignatures: {
      'autoDispose': 'AutoDisposeStreamProviderBuilder get autoDispose',
      'family': 'StreamProviderFamilyBuilder get family',
    },
  );
}

// =============================================================================
// StreamProviderFamily Bridge
// =============================================================================

BridgedClass _createStreamProviderFamilyBridge() {
  return BridgedClass(
    nativeType: $riverpod_15.StreamProviderFamily,
    name: 'StreamProviderFamily',
    isAssignable: (v) => v is $riverpod_15.StreamProviderFamily,
    hierarchyDepth: 7,
    constructors: {},
    getters: {
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProviderFamily>(
            target,
            'StreamProviderFamily',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProviderFamily>(
            target,
            'StreamProviderFamily',
          )
          .origin,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProviderFamily>(
            target,
            'StreamProviderFamily',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProviderFamily>(
            target,
            'StreamProviderFamily',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProviderFamily>(
            target,
            'StreamProviderFamily',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProviderFamily>(
            target,
            'StreamProviderFamily',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_15.StreamProviderFamily>(
            target,
            'StreamProviderFamily',
          )
          .isAutoDispose,
    },
    methods: {
      'call': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_15.StreamProviderFamily>(
          target,
          'StreamProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'call');
        final argument = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'argument',
          'call',
        );
        return t.call(argument);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_15.StreamProviderFamily>(
          target,
          'StreamProviderFamily',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_15.StreamProviderFamily>(
          target,
          'StreamProviderFamily',
        );
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(
          (($riverpod_6.Ref p0, dynamic p1) {
                return D4.extractBridgedArg<Stream<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0, p1]),
                      'callback',
                      visitor,
                    )
                    as Stream<dynamic>;
              })
              as Stream<dynamic> Function($riverpod_6.Ref, dynamic),
        );
      },
    },
    methodSignatures: {
      'call': 'StreamProvider<ValueT> call(ArgT argument)',
      'toString': 'String toString()',
      'overrideWith':
          'Override overrideWith(Stream<ValueT> Function(Ref ref, ArgT arg) create)',
    },
    getterSignatures: {
      'from': 'Family get from',
      'origin': 'Family get origin',
      'name': 'String? get name',
      'retry': 'Retry? get retry',
      'dependencies': 'Iterable<ProviderOrFamily>? get dependencies',
      '\$allTransitiveDependencies':
          'Iterable<ProviderOrFamily>? get \$allTransitiveDependencies',
      'isAutoDispose': 'bool get isAutoDispose',
    },
  );
}

// =============================================================================
// ConsumerStatefulWidget Bridge
// =============================================================================

BridgedClass _createConsumerStatefulWidgetBridge() {
  return BridgedClass(
    nativeType: $riverpod_kit_1.ConsumerStatefulWidget,
    name: 'ConsumerStatefulWidget',
    isAssignable: (v) => v is $riverpod_kit_1.ConsumerStatefulWidget,
    isAbstract: true,
    constructors: {},
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_1.ConsumerStatefulWidget>(
          target,
          'ConsumerStatefulWidget',
        );
        return t.createState();
      },
    },
    methodSignatures: {
      'createState': 'ConsumerState<ConsumerStatefulWidget> createState()',
    },
  );
}

// =============================================================================
// ConsumerState Bridge
// =============================================================================

BridgedClass _createConsumerStateBridge() {
  return BridgedClass(
    nativeType: $riverpod_kit_1.ConsumerState,
    name: 'ConsumerState',
    isAssignable: (v) => v is $riverpod_kit_1.ConsumerState,
    isAbstract: true,
    constructors: {},
    getters: {
      'ref': (visitor, target) => D4
          .validateTarget<$riverpod_kit_1.ConsumerState>(
            target,
            'ConsumerState',
          )
          .ref,
    },
    methods: {
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_1.ConsumerState>(
          target,
          'ConsumerState',
        );
        (t as dynamic).dispose();
        return null;
      },
    },
    methodSignatures: {
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'ref': 'WidgetRef get ref',
    },
  );
}

// =============================================================================
// ConsumerWidget Bridge
// =============================================================================

BridgedClass _createConsumerWidgetBridge() {
  return BridgedClass(
    nativeType: $riverpod_kit_1.ConsumerWidget,
    name: 'ConsumerWidget',
    isAssignable: (v) => v is $riverpod_kit_1.ConsumerWidget,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_1.ConsumerWidget>(
          target,
          'ConsumerWidget',
        );
        return t.createState();
      },
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_1.ConsumerWidget>(
          target,
          'ConsumerWidget',
        );
        D4.requireMinArgs(positional, 2, 'build');
        final context = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'context',
          'build',
        );
        final ref = D4.getRequiredArg<$riverpod_kit_3.WidgetRef>(
          positional,
          1,
          'ref',
          'build',
        );
        return (t as dynamic).build(context, ref);
      },
    },
    methodSignatures: {
      'createState': 'ConsumerState<ConsumerWidget> createState()',
      'build': 'InvalidType build(InvalidType context, WidgetRef ref)',
    },
  );
}

// =============================================================================
// Consumer Bridge
// =============================================================================

BridgedClass _createConsumerBridge() {
  return BridgedClass(
    nativeType: $riverpod_kit_1.Consumer,
    name: 'Consumer',
    isAssignable: (v) => v is $riverpod_kit_1.Consumer,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        if (!named.containsKey('builder') || named['builder'] == null) {
          throw ArgumentError(
            'Consumer: Missing required named argument "builder"',
          );
        }
        final builderRaw = named['builder'];
        if (!named.containsKey('key') && !named.containsKey('child')) {
          return $riverpod_kit_1.Consumer(
            builder: (dynamic p0, $riverpod_kit_3.WidgetRef p1, dynamic p2) {
              return D4.castCallbackResult<dynamic>(
                D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1, p2]),
              );
            },
          );
        }
        if (named.containsKey('key') && !named.containsKey('child')) {
          final key = D4.getRequiredNamedArg<dynamic>(named, 'key', 'Consumer');
          return $riverpod_kit_1.Consumer(
            builder: (dynamic p0, $riverpod_kit_3.WidgetRef p1, dynamic p2) {
              return D4.castCallbackResult<dynamic>(
                D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1, p2]),
              );
            },
            key: key,
          );
        }
        if (!named.containsKey('key') && named.containsKey('child')) {
          final child = D4.extractBridgedArgOrNull<$flutter_widgets.Widget>(
            D4.getRequiredNamedArg<dynamic>(named, 'child', 'Consumer'),
            'child',
            visitor,
          );
          return $riverpod_kit_1.Consumer(
            builder: (dynamic p0, $riverpod_kit_3.WidgetRef p1, dynamic p2) {
              return D4.castCallbackResult<dynamic>(
                D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1, p2]),
              );
            },
            child: child,
          );
        }
        if (named.containsKey('key') && named.containsKey('child')) {
          final key = D4.getRequiredNamedArg<dynamic>(named, 'key', 'Consumer');
          final child = D4.extractBridgedArgOrNull<$flutter_widgets.Widget>(
            D4.getRequiredNamedArg<dynamic>(named, 'child', 'Consumer'),
            'child',
            visitor,
          );
          return $riverpod_kit_1.Consumer(
            builder: (dynamic p0, $riverpod_kit_3.WidgetRef p1, dynamic p2) {
              return D4.castCallbackResult<dynamic>(
                D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1, p2]),
              );
            },
            key: key,
            child: child,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
    },
    getters: {
      'builder': (visitor, target) => D4
          .validateTarget<$riverpod_kit_1.Consumer>(target, 'Consumer')
          .builder,
      'child': (visitor, target) =>
          D4.validateTarget<$riverpod_kit_1.Consumer>(target, 'Consumer').child,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_1.Consumer>(
          target,
          'Consumer',
        );
        return t.createState();
      },
      'build': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_1.Consumer>(
          target,
          'Consumer',
        );
        D4.requireMinArgs(positional, 2, 'build');
        final context = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'context',
          'build',
        );
        final ref = D4.getRequiredArg<$riverpod_kit_3.WidgetRef>(
          positional,
          1,
          'ref',
          'build',
        );
        return (t as dynamic).build(context, ref);
      },
    },
    constructorSignatures: {
      '': 'const Consumer({dynamic key, required InvalidType Function(InvalidType context, WidgetRef ref, InvalidType child) builder, InvalidType child})',
    },
    methodSignatures: {
      'createState': 'ConsumerState<ConsumerWidget> createState()',
      'build': 'InvalidType build(InvalidType context, WidgetRef ref)',
    },
    getterSignatures: {
      'builder':
          'InvalidType Function(InvalidType context, WidgetRef ref, InvalidType child) get builder',
      'child': 'InvalidType get child',
    },
  );
}

// =============================================================================
// ProviderScope Bridge
// =============================================================================

BridgedClass _createProviderScopeBridge() {
  return BridgedClass(
    nativeType: $riverpod_kit_2.ProviderScope,
    name: 'ProviderScope',
    isAssignable: (v) => v is $riverpod_kit_2.ProviderScope,
    constructors: {
      '': (visitor, positional, named) {
        final overrides =
            named.containsKey('overrides') && named['overrides'] != null
            ? D4.coerceList<$riverpod_6.Override>(
                named['overrides'],
                'overrides',
              )
            : const <$riverpod_6.Override>[];
        final observers = D4.coerceListOrNull<$riverpod_6.ProviderObserver>(
          named['observers'],
          'observers',
        );
        final retryRaw = named['retry'];
        final child = D4.extractBridgedArg<$flutter_widgets.Widget>(
          D4.getRequiredNamedArg<dynamic>(named, 'child', 'ProviderScope'),
          'child',
          visitor,
        );
        if (!named.containsKey('key')) {
          return $riverpod_kit_2.ProviderScope(
            overrides: overrides,
            observers: observers,
            retry: retryRaw == null
                ? null
                : ((int p0, Object p1) {
                        return D4.extractBridgedArg<Duration?>(
                              D4.callInterpreterCallback(visitor!, retryRaw, [
                                p0,
                                p1,
                              ]),
                              'callback',
                              visitor,
                            )
                            as Duration?;
                      })
                      as Duration? Function(int, Object),
            child: child,
          );
        }
        if (named.containsKey('key')) {
          final key = D4.getRequiredNamedArg<dynamic>(
            named,
            'key',
            'ProviderScope',
          );
          return $riverpod_kit_2.ProviderScope(
            overrides: overrides,
            observers: observers,
            retry: retryRaw == null
                ? null
                : ((int p0, Object p1) {
                        return D4.extractBridgedArg<Duration?>(
                              D4.callInterpreterCallback(visitor!, retryRaw, [
                                p0,
                                p1,
                              ]),
                              'callback',
                              visitor,
                            )
                            as Duration?;
                      })
                      as Duration? Function(int, Object),
            child: child,
            key: key,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
    },
    getters: {
      'overrides': (visitor, target) => D4
          .validateTarget<$riverpod_kit_2.ProviderScope>(
            target,
            'ProviderScope',
          )
          .overrides,
      'observers': (visitor, target) => D4
          .validateTarget<$riverpod_kit_2.ProviderScope>(
            target,
            'ProviderScope',
          )
          .observers,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_kit_2.ProviderScope>(
            target,
            'ProviderScope',
          )
          .retry,
      'child': (visitor, target) => D4
          .validateTarget<$riverpod_kit_2.ProviderScope>(
            target,
            'ProviderScope',
          )
          .child,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_2.ProviderScope>(
          target,
          'ProviderScope',
        );
        return t.createState();
      },
    },
    staticGetters: {
      'rootContainer': (visitor) => $riverpod_kit_2.ProviderScope.rootContainer,
    },
    staticMethods: {
      'containerOf': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'containerOf');
        final context = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'context',
          'containerOf',
        );
        return $riverpod_kit_2.ProviderScope.containerOf(context);
      },
      'maybeContainerOf': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'maybeContainerOf');
        final context = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'context',
          'maybeContainerOf',
        );
        return $riverpod_kit_2.ProviderScope.maybeContainerOf(context);
      },
      'registerRoot': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'registerRoot');
        final container = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'container',
          'registerRoot',
        );
        return $riverpod_kit_2.ProviderScope.registerRoot(container);
      },
    },
    constructorSignatures: {
      '': 'const ProviderScope({dynamic key, List<InvalidType> overrides = const [], List<InvalidType>? observers, Duration? Function(int retryCount, Object error)? retry, required InvalidType child})',
    },
    methodSignatures: {
      'createState': 'InvalidType createState()',
    },
    getterSignatures: {
      'overrides': 'List<InvalidType> get overrides',
      'observers': 'List<InvalidType>? get observers',
      'retry': 'Duration? Function(int retryCount, Object error)? get retry',
      'child': 'InvalidType get child',
    },
    staticMethodSignatures: {
      'containerOf': 'InvalidType containerOf(InvalidType context)',
      'maybeContainerOf': 'InvalidType maybeContainerOf(InvalidType context)',
      'registerRoot': 'RootRegistration registerRoot(InvalidType container)',
    },
    staticGetterSignatures: {
      'rootContainer': 'InvalidType get rootContainer',
    },
  );
}

// =============================================================================
// RootRegistration Bridge
// =============================================================================

BridgedClass _createRootRegistrationBridge() {
  return BridgedClass(
    nativeType: $riverpod_kit_2.RootRegistration,
    name: 'RootRegistration',
    isAssignable: (v) => v is $riverpod_kit_2.RootRegistration,
    constructors: {},
    getters: {
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_kit_2.RootRegistration>(
            target,
            'RootRegistration',
          )
          .container,
    },
    methods: {
      'release': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_2.RootRegistration>(
          target,
          'RootRegistration',
        );
        t.release();
        return null;
      },
    },
    methodSignatures: {
      'release': 'void release()',
    },
    getterSignatures: {
      'container': 'InvalidType get container',
    },
  );
}

// =============================================================================
// UncontrolledProviderScope Bridge
// =============================================================================

BridgedClass _createUncontrolledProviderScopeBridge() {
  return BridgedClass(
    nativeType: $riverpod_kit_2.UncontrolledProviderScope,
    name: 'UncontrolledProviderScope',
    isAssignable: (v) => v is $riverpod_kit_2.UncontrolledProviderScope,
    constructors: {
      '': (visitor, positional, named) {
        final container = D4.getRequiredNamedArg<dynamic>(
          named,
          'container',
          'UncontrolledProviderScope',
        );
        final child = D4.extractBridgedArg<$flutter_widgets.Widget>(
          D4.getRequiredNamedArg<dynamic>(
            named,
            'child',
            'UncontrolledProviderScope',
          ),
          'child',
          visitor,
        );
        if (!named.containsKey('key')) {
          return $riverpod_kit_2.UncontrolledProviderScope(
            container: container,
            child: child,
          );
        }
        if (named.containsKey('key')) {
          final key = D4.getRequiredNamedArg<dynamic>(
            named,
            'key',
            'UncontrolledProviderScope',
          );
          return $riverpod_kit_2.UncontrolledProviderScope(
            container: container,
            child: child,
            key: key,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
    },
    getters: {
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_kit_2.UncontrolledProviderScope>(
            target,
            'UncontrolledProviderScope',
          )
          .container,
      'child': (visitor, target) => D4
          .validateTarget<$riverpod_kit_2.UncontrolledProviderScope>(
            target,
            'UncontrolledProviderScope',
          )
          .child,
    },
    methods: {
      'createState': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_2.UncontrolledProviderScope>(
          target,
          'UncontrolledProviderScope',
        );
        return t.createState();
      },
    },
    constructorSignatures: {
      '': 'const UncontrolledProviderScope({dynamic key, required InvalidType container, required InvalidType child})',
    },
    methodSignatures: {
      'createState': 'InvalidType createState()',
    },
    getterSignatures: {
      'container': 'InvalidType get container',
      'child': 'InvalidType get child',
    },
  );
}

// =============================================================================
// WidgetRef Bridge
// =============================================================================

BridgedClass _createWidgetRefBridge() {
  return BridgedClass(
    nativeType: $riverpod_kit_3.WidgetRef,
    name: 'WidgetRef',
    isAssignable: (v) => v is $riverpod_kit_3.WidgetRef,
    isAbstract: true,
    constructors: {},
    getters: {
      'context': (visitor, target) => D4
          .validateTarget<$riverpod_kit_3.WidgetRef>(target, 'WidgetRef')
          .context,
    },
    methods: {
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_3.WidgetRef>(
          target,
          'WidgetRef',
        );
        D4.requireMinArgs(positional, 1, 'watch');
        final provider = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'provider',
          'watch',
        );
        return _unwrapInterpretedProxy(t.watch(provider));
      },
      'exists': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_3.WidgetRef>(
          target,
          'WidgetRef',
        );
        D4.requireMinArgs(positional, 1, 'exists');
        final provider = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'provider',
          'exists',
        );
        return t.exists(provider);
      },
      'listen': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_3.WidgetRef>(
          target,
          'WidgetRef',
        );
        D4.requireMinArgs(positional, 2, 'listen');
        final provider = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'provider',
          'listen',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'listen: Missing required argument "listener" at position 1',
          );
        }
        final listenerRaw = positional[1];
        final onErrorRaw = named['onError'];
        t.listen<Object?>(
          provider,
          (dynamic p0, dynamic p1) {
            D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
          },
          onError: onErrorRaw == null
              ? null
              : (Object p0, StackTrace p1) {
                  D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                },
        );
        return null;
      },
      'listenManual': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_3.WidgetRef>(
          target,
          'WidgetRef',
        );
        D4.requireMinArgs(positional, 2, 'listenManual');
        final provider = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'provider',
          'listenManual',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'listenManual: Missing required argument "listener" at position 1',
          );
        }
        final listenerRaw = positional[1];
        final onErrorRaw = named['onError'];
        if (!named.containsKey('fireImmediately')) {
          return t.listenManual<Object?>(
            provider,
            (dynamic p0, dynamic p1) {
              D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
            },
            onError: onErrorRaw == null
                ? null
                : (Object p0, StackTrace p1) {
                    D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                  },
          );
        }
        if (named.containsKey('fireImmediately')) {
          final fireImmediately = D4.getRequiredNamedArg<bool>(
            named,
            'fireImmediately',
            'listenManual',
          );
          return t.listenManual<Object?>(
            provider,
            (dynamic p0, dynamic p1) {
              D4.callInterpreterCallback(visitor!, listenerRaw, [p0, p1]);
            },
            onError: onErrorRaw == null
                ? null
                : (Object p0, StackTrace p1) {
                    D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]);
                  },
            fireImmediately: fireImmediately,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_3.WidgetRef>(
          target,
          'WidgetRef',
        );
        D4.requireMinArgs(positional, 1, 'read');
        final provider = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'provider',
          'read',
        );
        return _unwrapInterpretedProxy(t.read(provider));
      },
      'refresh': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_3.WidgetRef>(
          target,
          'WidgetRef',
        );
        D4.requireMinArgs(positional, 1, 'refresh');
        final provider = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'provider',
          'refresh',
        );
        return _unwrapInterpretedProxy(t.refresh(provider));
      },
      'invalidate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_3.WidgetRef>(
          target,
          'WidgetRef',
        );
        D4.requireMinArgs(positional, 1, 'invalidate');
        final provider = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'provider',
          'invalidate',
        );
        final asReload = D4.getNamedArgWithDefault<bool>(
          named,
          'asReload',
          false,
        );
        t.invalidate(provider, asReload: asReload);
        return null;
      },
    },
    methodSignatures: {
      'watch': 'StateT watch(InvalidType provider)',
      'exists': 'bool exists(InvalidType provider)',
      'listen':
          'void listen(InvalidType provider, void Function(StateT? previous, StateT next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
      'listenManual':
          'InvalidType listenManual(InvalidType provider, void Function(StateT? previous, StateT next) listener, {void Function(Object error, StackTrace stackTrace)? onError, bool fireImmediately})',
      'read': 'StateT read(InvalidType provider)',
      'refresh': 'StateT refresh(InvalidType provider)',
      'invalidate':
          'void invalidate(InvalidType provider, {bool asReload = false})',
    },
    getterSignatures: {
      'context': 'InvalidType get context',
    },
  );
}

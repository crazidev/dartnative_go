// D4rt Bridge - Generated file, do not edit
// Sources: 14 files
// Generated: 2026-09-20T04:31:46.025809 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, experimental_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';
import 'package:dartnative/dartnative.dart' as $flutter_widgets;
import 'ast_widget_proxies.dart';

import 'package:riverpod/src/builder.dart' as $riverpod_1;
import 'package:riverpod/src/common/stack_trace.dart' as $riverpod_2;
import 'package:riverpod/src/common/string.dart' as $riverpod_3;
import 'package:riverpod/src/common/tenable.dart' as $riverpod_4;
import 'package:riverpod/src/framework.dart' as $riverpod_5;
import 'package:riverpod/src/providers/async_notifier.dart' as $riverpod_6;
import 'package:riverpod/src/providers/future_provider.dart' as $riverpod_7;
import 'package:riverpod/src/providers/notifier.dart' as $riverpod_8;
import 'package:riverpod/src/providers/provider.dart' as $riverpod_9;
import 'package:riverpod/src/providers/stream_notifier.dart' as $riverpod_10;
import 'package:riverpod/src/providers/stream_provider.dart' as $riverpod_11;
import 'package:riverpod_kit/src/consumer.dart' as $riverpod_kit_1;
import 'package:riverpod_kit/src/provider_scope.dart' as $riverpod_kit_2;
import 'package:riverpod_kit/src/widget_ref.dart' as $riverpod_kit_3;
import 'package:state_notifier/state_notifier.dart' as $state_notifier_1;

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

/// Bridge class for riverpod_kit module.
class RiverpodKitBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createAnyNotifierBridge(),
      _createProviderReferenceBridge(),
      _createProviderContainerBridge(),
      _createProviderObserverContextBridge(),
      _createProviderObserverBridge(),
      _createProviderSubscriptionBridge(),
      _createRefBridge(),
      _createAsyncValueIsLoadingExceptionBridge(),
      _createAsyncValueBridge(),
      _createAsyncResultBridge(),
      _createAsyncDataBridge(),
      _createAsyncLoadingBridge(),
      _createAsyncErrorBridge(),
      _createAsyncNotifierBridge(),
      _createAsyncNotifierProviderBridge(),
      _createFutureProviderBridge(),
      _createNotifierBridge(),
      _createNotifierProviderBridge(),
      _createProviderBridge(),
      _createStreamNotifierBridge(),
      _createStreamNotifierProviderBridge(),
      _createStreamProviderBridge(),
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
      'AnyNotifier': _createAnyNotifierBridge,
      'ProviderReference': _createProviderReferenceBridge,
      'ProviderContainer': _createProviderContainerBridge,
      'ProviderObserverContext': _createProviderObserverContextBridge,
      'ProviderObserver': _createProviderObserverBridge,
      'ProviderSubscription': _createProviderSubscriptionBridge,
      'Ref': _createRefBridge,
      'AsyncValueIsLoadingException': _createAsyncValueIsLoadingExceptionBridge,
      'AsyncValue': _createAsyncValueBridge,
      'AsyncResult': _createAsyncResultBridge,
      'AsyncData': _createAsyncDataBridge,
      'AsyncLoading': _createAsyncLoadingBridge,
      'AsyncError': _createAsyncErrorBridge,
      'AsyncNotifier': _createAsyncNotifierBridge,
      'AsyncNotifierProvider': _createAsyncNotifierProviderBridge,
      'FutureProvider': _createFutureProviderBridge,
      'Notifier': _createNotifierBridge,
      'NotifierProvider': _createNotifierProviderBridge,
      'Provider': _createProviderBridge,
      'StreamNotifier': _createStreamNotifierBridge,
      'StreamNotifierProvider': _createStreamNotifierProviderBridge,
      'StreamProvider': _createStreamProviderBridge,
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
      'AnyNotifier': $riverpod_5.AnyNotifier,
      'ProviderReference': $riverpod_5.ProviderReference,
      'ProviderContainer': $riverpod_5.ProviderContainer,
      'ProviderObserverContext': $riverpod_5.ProviderObserverContext,
      'ProviderObserver': $riverpod_5.ProviderObserver,
      'ProviderSubscription': $riverpod_5.ProviderSubscription,
      'Ref': $riverpod_5.Ref,
      'AsyncValueIsLoadingException': $riverpod_5.AsyncValueIsLoadingException,
      'AsyncValue': $riverpod_5.AsyncValue,
      'AsyncResult': $riverpod_5.AsyncResult,
      'AsyncData': $riverpod_5.AsyncData,
      'AsyncLoading': $riverpod_5.AsyncLoading,
      'AsyncError': $riverpod_5.AsyncError,
      'AsyncNotifier': $riverpod_6.AsyncNotifier,
      'AsyncNotifierProvider': $riverpod_6.AsyncNotifierProvider,
      'FutureProvider': $riverpod_7.FutureProvider,
      'Notifier': $riverpod_8.Notifier,
      'NotifierProvider': $riverpod_8.NotifierProvider,
      'Provider': $riverpod_9.Provider,
      'StreamNotifier': $riverpod_10.StreamNotifier,
      'StreamNotifierProvider': $riverpod_10.StreamNotifierProvider,
      'StreamProvider': $riverpod_11.StreamProvider,
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
      'AnyNotifier': 'package:riverpod/src/framework.dart',
      'ProviderReference': 'package:riverpod/src/framework.dart',
      'ProviderContainer': 'package:riverpod/src/framework.dart',
      'ProviderObserverContext': 'package:riverpod/src/framework.dart',
      'ProviderObserver': 'package:riverpod/src/framework.dart',
      'ProviderSubscription': 'package:riverpod/src/framework.dart',
      'Ref': 'package:riverpod/src/framework.dart',
      'AsyncValueIsLoadingException': 'package:riverpod/src/framework.dart',
      'AsyncValue': 'package:riverpod/src/framework.dart',
      'AsyncResult': 'package:riverpod/src/framework.dart',
      'AsyncData': 'package:riverpod/src/framework.dart',
      'AsyncLoading': 'package:riverpod/src/framework.dart',
      'AsyncError': 'package:riverpod/src/framework.dart',
      'AsyncNotifier': 'package:riverpod/src/providers/async_notifier.dart',
      'AsyncNotifierProvider':
          'package:riverpod/src/providers/async_notifier.dart',
      'FutureProvider': 'package:riverpod/src/providers/future_provider.dart',
      'Notifier': 'package:riverpod/src/providers/notifier.dart',
      'NotifierProvider': 'package:riverpod/src/providers/notifier.dart',
      'Provider': 'package:riverpod/src/providers/provider.dart',
      'StreamNotifier': 'package:riverpod/src/providers/stream_notifier.dart',
      'StreamNotifierProvider':
          'package:riverpod/src/providers/stream_notifier.dart',
      'StreamProvider': 'package:riverpod/src/providers/stream_provider.dart',
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
      'ProviderContainer': ['MutationTarget'],
      'Ref': ['BaseRef', 'MutationTarget'],
      'AsyncValueIsLoadingException': ['Exception'],
      'AsyncResult': ['AsyncValue'],
      'AsyncData': ['AsyncResult', 'AsyncValue'],
      'AsyncLoading': ['AsyncValue'],
      'AsyncError': ['AsyncResult', 'AsyncValue'],
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
      'ConsumerWidget': ['ConsumerStatefulWidget'],
      'Consumer': ['ConsumerWidget', 'ConsumerStatefulWidget'],
      'WidgetRef': ['MutationTarget'],
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
        name: 'ProviderListenableSelect',
        onTypeName: 'ProviderListenable',
        methods: {
          'select': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.ProviderListenable;
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
            final t = target as $riverpod_5.AnyNotifier;
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
              (target as $riverpod_5.ProviderContainer).scheduler,
          'depth': (visitor, target) =>
              (target as $riverpod_5.ProviderContainer).depth,
          'debugChildren': (visitor, target) =>
              (target as $riverpod_5.ProviderContainer).debugChildren,
        },
        methods: {
          'defaultOnError': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.ProviderContainer;
            return Function.apply(
              t.defaultOnError,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'getAllProviderElements':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $riverpod_5.ProviderContainer;
                return Function.apply(
                  t.getAllProviderElements,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
          'getAllProviderElementsInOrder':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $riverpod_5.ProviderContainer;
                return Function.apply(
                  t.getAllProviderElementsInOrder,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
          'runGuarded': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.ProviderContainer;
            return Function.apply(
              t.runGuarded,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'runUnaryGuarded': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.ProviderContainer;
            return Function.apply(
              t.runUnaryGuarded,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'runBinaryGuarded': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.ProviderContainer;
            return Function.apply(
              t.runBinaryGuarded,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'runTernaryGuarded': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.ProviderContainer;
            return Function.apply(
              t.runTernaryGuarded,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'runQuaternaryGuarded':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $riverpod_5.ProviderContainer;
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
                final t = target as $riverpod_5.ProviderContainer;
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
              (target as $riverpod_5.ProviderContainer).disposed,
          'root': (visitor, target) =>
              (target as $riverpod_5.ProviderContainer).root,
          'parent': (visitor, target) =>
              (target as $riverpod_5.ProviderContainer).parent,
          'children': (visitor, target) =>
              (target as $riverpod_5.ProviderContainer).children,
          'pointerManager': (visitor, target) =>
              (target as $riverpod_5.ProviderContainer).pointerManager,
        },
      ),
      BridgedExtensionDefinition(
        name: 'ProviderSubImpl',
        onTypeName: 'ProviderSubscription',
        getters: {
          'impl': (visitor, target) =>
              (target as $riverpod_5.ProviderSubscription).impl,
          'providerSub': (visitor, target) =>
              (target as $riverpod_5.ProviderSubscription).providerSub,
        },
      ),
      BridgedExtensionDefinition(
        name: 'ProviderSubX',
        onTypeName: 'ProviderSubscription',
        methods: {
          'readSafe': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.ProviderSubscription;
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
            final t = target as $riverpod_5.AsyncValue;
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
              (target as $riverpod_5.AsyncValue).valueFilled,
        },
      ),
      BridgedExtensionDefinition(
        name: 'AsyncValueExtensions',
        onTypeName: 'AsyncValue',
        getters: {
          'retrying': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).retrying,
          'isFromCache': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).isFromCache,
          'isLoading': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).isLoading,
          'isRefreshing': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).isRefreshing,
          'isReloading': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).isReloading,
          'progress': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).progress,
          'hasValue': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).hasValue,
          'hasError': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).hasError,
          'asData': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).asData,
          'asError': (visitor, target) =>
              (target as $riverpod_5.AsyncValue).asError,
        },
        methods: {
          'map': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.AsyncValue;
            return Function.apply(
              t.map,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'whenData': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.AsyncValue;
            return Function.apply(
              t.whenData,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'maybeWhen': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.AsyncValue;
            return Function.apply(
              t.maybeWhen,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'when': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.AsyncValue;
            return Function.apply(
              t.when,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'whenOrNull': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.AsyncValue;
            return Function.apply(
              t.whenOrNull,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'maybeMap': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.AsyncValue;
            return Function.apply(
              t.maybeMap,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'mapOrNull': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.AsyncValue;
            return Function.apply(
              t.mapOrNull,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'unwrapPrevious': (visitor, target, positional, named, typeArgs) {
            final t = target as $riverpod_5.AsyncValue;
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
              (target as $riverpod_5.ProviderContainer).parents,
          'id': (visitor, target) =>
              (target as $riverpod_5.ProviderContainer).id,
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
        target: 'package:riverpod/riverpod.dart',
        show: null,
        hide: null,
      ),
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
      'package:riverpod/src/framework.dart',
      'package:riverpod/src/providers/async_notifier.dart',
      'package:riverpod/src/providers/future_provider.dart',
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
// AnyNotifier Bridge
// =============================================================================

BridgedClass _createAnyNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_5.AnyNotifier,
    name: 'AnyNotifier',
    isAssignable: (v) => v is $riverpod_5.AnyNotifier,
    isAbstract: true,
    constructors: {},
    getters: {
      'ref': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AnyNotifier>(target, 'AnyNotifier').ref,
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_5.AnyNotifier>(target, 'AnyNotifier')
          .state,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
                  .validateTarget<$riverpod_5.AnyNotifier>(
                    target,
                    'AnyNotifier',
                  )
                  .state =
              value as dynamic,
    },
    methods: {
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AnyNotifier>(
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
        final t = D4.validateTarget<$riverpod_5.AnyNotifier>(
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
// ProviderReference Bridge
// =============================================================================

BridgedClass _createProviderReferenceBridge() {
  return BridgedClass(
    nativeType: $riverpod_5.ProviderReference,
    name: 'ProviderReference',
    isAssignable: (v) => v is $riverpod_5.ProviderReference,
    constructors: {},
    getters: {
      'provider': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderReference>(
            target,
            'ProviderReference',
          )
          .provider,
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderReference>(
            target,
            'ProviderReference',
          )
          .container,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderReference>(
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
    nativeType: $riverpod_5.ProviderContainer,
    name: 'ProviderContainer',
    isAssignable: (v) => v is $riverpod_5.ProviderContainer,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final parent = D4.getOptionalNamedArg<$riverpod_5.ProviderContainer?>(
          named,
          'parent',
        );
        final overrides =
            named.containsKey('overrides') && named['overrides'] != null
            ? D4.coerceList<$riverpod_5.Override>(
                named['overrides'],
                'overrides',
              )
            : const <$riverpod_5.Override>[];
        final observers = D4.coerceListOrNull<$riverpod_5.ProviderObserver>(
          named['observers'],
          'observers',
        );
        final onErrorRaw = named['onError'];
        final retryRaw = named['retry'];
        return $riverpod_5.ProviderContainer(
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
        final parent = D4.getOptionalNamedArg<$riverpod_5.ProviderContainer?>(
          named,
          'parent',
        );
        final overrides =
            named.containsKey('overrides') && named['overrides'] != null
            ? D4.coerceList<$riverpod_5.Override>(
                named['overrides'],
                'overrides',
              )
            : const <$riverpod_5.Override>[];
        final observers = D4.coerceListOrNull<$riverpod_5.ProviderObserver>(
          named['observers'],
          'observers',
        );
        final retryRaw = named['retry'];
        return $riverpod_5.ProviderContainer.test(
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
          .validateTarget<$riverpod_5.ProviderContainer>(
            target,
            'ProviderContainer',
          )
          .retry,
      'observers': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderContainer>(
            target,
            'ProviderContainer',
          )
          .observers,
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderContainer>(
            target,
            'ProviderContainer',
          )
          .container,
    },
    methods: {
      'pump': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        return t.pump();
      },
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'read');
        final provider = D4
            .getRequiredArg<$riverpod_5.ProviderListenable<dynamic>>(
              positional,
              0,
              'provider',
              'read',
            );
        return _unwrapInterpretedProxy(t.read(provider));
      },
      'exists': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'exists');
        final provider = D4.getRequiredArg<$riverpod_5.ProviderBase<Object?>>(
          positional,
          0,
          'provider',
          'exists',
        );
        return t.exists(provider);
      },
      'allProviders': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        final family = D4.getOptionalNamedArg<$riverpod_5.Family?>(
          named,
          'family',
        );
        return t.allProviders(family: family);
      },
      'debugReassemble': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        t.debugReassemble();
        return null;
      },
      'listen': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 2, 'listen');
        final provider = D4
            .getRequiredArg<$riverpod_5.ProviderListenable<dynamic>>(
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
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'invalidate');
        final provider = D4.getRequiredArg<$riverpod_5.ProviderOrFamily>(
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
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'refresh');
        final refreshable = D4.getRequiredArg<$riverpod_5.Refreshable<dynamic>>(
          positional,
          0,
          'refreshable',
          'refresh',
        );
        return t.refresh(refreshable);
      },
      'updateOverrides': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        D4.requireMinArgs(positional, 1, 'updateOverrides');
        if (positional.isEmpty) {
          throw ArgumentError(
            'updateOverrides: Missing required argument "overrides" at position 0',
          );
        }
        final overrides = D4.coerceList<$riverpod_5.Override>(
          positional[0],
          'overrides',
        );
        t.updateOverrides(overrides);
        return null;
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
          target,
          'ProviderContainer',
        );
        (t as dynamic).dispose();
        return null;
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderContainer>(
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
        return $riverpod_5.ProviderContainer.defaultRetry(
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
    nativeType: $riverpod_5.ProviderObserverContext,
    name: 'ProviderObserverContext',
    isAssignable: (v) => v is $riverpod_5.ProviderObserverContext,
    constructors: {},
    getters: {
      'provider': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderObserverContext>(
            target,
            'ProviderObserverContext',
          )
          .provider,
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderObserverContext>(
            target,
            'ProviderObserverContext',
          )
          .container,
      'mutation': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderObserverContext>(
            target,
            'ProviderObserverContext',
          )
          .mutation,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderObserverContext>(
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
    nativeType: $riverpod_5.ProviderObserver,
    name: 'ProviderObserver',
    isAssignable: (v) => v is $riverpod_5.ProviderObserver,
    isAbstract: true,
    constructors: {},
    methods: {
      'didCreateProviderContainer':
          (visitor, target, positional, named, typeArgs) {
            final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
              target,
              'ProviderObserver',
            );
            D4.requireMinArgs(positional, 1, 'didCreateProviderContainer');
            final container = D4.getRequiredArg<$riverpod_5.ProviderContainer>(
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
            final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
              target,
              'ProviderObserver',
            );
            D4.requireMinArgs(positional, 1, 'didDisposeProviderContainer');
            final container = D4.getRequiredArg<$riverpod_5.ProviderContainer>(
              positional,
              0,
              'container',
              'didDisposeProviderContainer',
            );
            t.didDisposeProviderContainer(container);
            return null;
          },
      'didAddProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 2, 'didAddProvider');
        final context = D4.getRequiredArg<$riverpod_5.ProviderObserverContext>(
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
        final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 3, 'providerDidFail');
        final context = D4.getRequiredArg<$riverpod_5.ProviderObserverContext>(
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
        final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 1, 'didUnmountProvider');
        final context = D4.getRequiredArg<$riverpod_5.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didUnmountProvider',
        );
        t.didUnmountProvider(context);
        return null;
      },
      'didUpdateProvider': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 3, 'didUpdateProvider');
        final context = D4.getRequiredArg<$riverpod_5.ProviderObserverContext>(
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
        final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 1, 'didDisposeProvider');
        final context = D4.getRequiredArg<$riverpod_5.ProviderObserverContext>(
          positional,
          0,
          'context',
          'didDisposeProvider',
        );
        t.didDisposeProvider(context);
        return null;
      },
      'mutationReset': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 2, 'mutationReset');
        final context = D4.getRequiredArg<$riverpod_5.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationReset',
        );
        final mutation = D4.getRequiredArg<$riverpod_5.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationReset',
        );
        t.mutationReset(context, mutation);
        return null;
      },
      'mutationStart': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 2, 'mutationStart');
        final context = D4.getRequiredArg<$riverpod_5.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationStart',
        );
        final mutation = D4.getRequiredArg<$riverpod_5.Mutation<Object?>>(
          positional,
          1,
          'mutation',
          'mutationStart',
        );
        t.mutationStart(context, mutation);
        return null;
      },
      'mutationError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 4, 'mutationError');
        final context = D4.getRequiredArg<$riverpod_5.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationError',
        );
        final mutation = D4.getRequiredArg<$riverpod_5.Mutation<Object?>>(
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
        final t = D4.validateTarget<$riverpod_5.ProviderObserver>(
          target,
          'ProviderObserver',
        );
        D4.requireMinArgs(positional, 3, 'mutationSuccess');
        final context = D4.getRequiredArg<$riverpod_5.ProviderObserverContext>(
          positional,
          0,
          'context',
          'mutationSuccess',
        );
        final mutation = D4.getRequiredArg<$riverpod_5.Mutation<Object?>>(
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
    nativeType: $riverpod_5.ProviderSubscription,
    name: 'ProviderSubscription',
    isAssignable: (v) => v is $riverpod_5.ProviderSubscription,
    constructors: {},
    getters: {
      'closed': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderSubscription>(
            target,
            'ProviderSubscription',
          )
          .closed,
      'weak': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderSubscription>(
            target,
            'ProviderSubscription',
          )
          .weak,
      'isPaused': (visitor, target) => D4
          .validateTarget<$riverpod_5.ProviderSubscription>(
            target,
            'ProviderSubscription',
          )
          .isPaused,
    },
    methods: {
      'pause': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderSubscription>(
          target,
          'ProviderSubscription',
        );
        t.pause();
        return null;
      },
      'resume': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderSubscription>(
          target,
          'ProviderSubscription',
        );
        t.resume();
        return null;
      },
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderSubscription>(
          target,
          'ProviderSubscription',
        );
        return t.read();
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.ProviderSubscription>(
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
// Ref Bridge
// =============================================================================

BridgedClass _createRefBridge() {
  return BridgedClass(
    nativeType: $riverpod_5.Ref,
    name: 'Ref',
    isAssignable: (v) => v is $riverpod_5.Ref,
    hierarchyDepth: 2,
    constructors: {},
    getters: {
      'isFirstBuild': (visitor, target) =>
          D4.validateTarget<$riverpod_5.Ref>(target, 'Ref').isFirstBuild,
      'isReload': (visitor, target) =>
          D4.validateTarget<$riverpod_5.Ref>(target, 'Ref').isReload,
      'isRefresh': (visitor, target) =>
          D4.validateTarget<$riverpod_5.Ref>(target, 'Ref').isRefresh,
      'mounted': (visitor, target) =>
          D4.validateTarget<$riverpod_5.Ref>(target, 'Ref').mounted,
      'isPaused': (visitor, target) =>
          D4.validateTarget<$riverpod_5.Ref>(target, 'Ref').isPaused,
      'container': (visitor, target) =>
          D4.validateTarget<$riverpod_5.Ref>(target, 'Ref').container,
    },
    methods: {
      'keepAlive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
        return t.keepAlive();
      },
      'refresh': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'refresh');
        final refreshable = D4.getRequiredArg<$riverpod_5.Refreshable<dynamic>>(
          positional,
          0,
          'refreshable',
          'refresh',
        );
        return t.refresh(refreshable);
      },
      'invalidate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'invalidate');
        final providerOrFamily = D4
            .getRequiredArg<$riverpod_5.ProviderOrFamily>(
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
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
        final asReload = D4.getNamedArgWithDefault<bool>(
          named,
          'asReload',
          false,
        );
        t.invalidateSelf(asReload: asReload);
        return null;
      },
      'onManualInvalidation': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
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
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
        t.notifyListeners();
        return null;
      },
      'onAddListener': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
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
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
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
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
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
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
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
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
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
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'read');
        final listenable = D4
            .getRequiredArg<$riverpod_5.ProviderListenable<dynamic>>(
              positional,
              0,
              'listenable',
              'read',
            );
        return _unwrapInterpretedProxy(t.read(listenable));
      },
      'exists': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'exists');
        final provider = D4.getRequiredArg<$riverpod_5.ProviderBase<Object?>>(
          positional,
          0,
          'provider',
          'exists',
        );
        return t.exists(provider);
      },
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 1, 'watch');
        final listenable = D4
            .getRequiredArg<$riverpod_5.ProviderListenable<dynamic>>(
              positional,
              0,
              'listenable',
              'watch',
            );
        return _unwrapInterpretedProxy(t.watch(listenable));
      },
      'listen': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.Ref>(target, 'Ref');
        D4.requireMinArgs(positional, 2, 'listen');
        final provider = D4
            .getRequiredArg<$riverpod_5.ProviderListenable<dynamic>>(
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
// AsyncValueIsLoadingException Bridge
// =============================================================================

BridgedClass _createAsyncValueIsLoadingExceptionBridge() {
  return BridgedClass(
    nativeType: $riverpod_5.AsyncValueIsLoadingException,
    name: 'AsyncValueIsLoadingException',
    isAssignable: (v) => v is $riverpod_5.AsyncValueIsLoadingException,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'value': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncValueIsLoadingException>(
            target,
            'AsyncValueIsLoadingException',
          )
          .value,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncValueIsLoadingException>(
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
    nativeType: $riverpod_5.AsyncValue,
    name: 'AsyncValue',
    isAssignable: (v) => v is $riverpod_5.AsyncValue,
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
            return $riverpod_5.AsyncValue<double>.data(value);
          case int _:
            return $riverpod_5.AsyncValue<int>.data(value);
          case String _:
            return $riverpod_5.AsyncValue<String>.data(value);
          case bool _:
            return $riverpod_5.AsyncValue<bool>.data(value);
          case $riverpod_6.AsyncNotifierProvider _:
            return $riverpod_5.AsyncValue<
              $riverpod_6.AsyncNotifierProvider
            >.data(value);
          case $riverpod_7.FutureProvider _:
            return $riverpod_5.AsyncValue<$riverpod_7.FutureProvider>.data(
              value,
            );
          case $riverpod_10.StreamNotifierProvider _:
            return $riverpod_5.AsyncValue<
              $riverpod_10.StreamNotifierProvider
            >.data(value);
          case $riverpod_11.StreamProvider _:
            return $riverpod_5.AsyncValue<$riverpod_11.StreamProvider>.data(
              value,
            );
          case $riverpod_8.NotifierProvider _:
            return $riverpod_5.AsyncValue<$riverpod_8.NotifierProvider>.data(
              value,
            );
          case $riverpod_9.Provider _:
            return $riverpod_5.AsyncValue<$riverpod_9.Provider>.data(value);
          case $riverpod_6.AsyncNotifier _:
            return $riverpod_5.AsyncValue<$riverpod_6.AsyncNotifier>.data(
              value,
            );
          case $riverpod_10.StreamNotifier _:
            return $riverpod_5.AsyncValue<$riverpod_10.StreamNotifier>.data(
              value,
            );
          case $riverpod_8.Notifier _:
            return $riverpod_5.AsyncValue<$riverpod_8.Notifier>.data(value);
          case $riverpod_5.AsyncData _:
            return $riverpod_5.AsyncValue<$riverpod_5.AsyncData>.data(value);
          case $riverpod_5.AsyncError _:
            return $riverpod_5.AsyncValue<$riverpod_5.AsyncError>.data(value);
          case $riverpod_kit_1.Consumer _:
            return $riverpod_5.AsyncValue<$riverpod_kit_1.Consumer>.data(value);
          case $riverpod_5.Ref _:
            return $riverpod_5.AsyncValue<$riverpod_5.Ref>.data(value);
          case $riverpod_5.AsyncLoading _:
            return $riverpod_5.AsyncValue<$riverpod_5.AsyncLoading>.data(value);
          case $riverpod_5.AsyncValueIsLoadingException _:
            return $riverpod_5.AsyncValue<
              $riverpod_5.AsyncValueIsLoadingException
            >.data(value);
          case $riverpod_kit_1.ConsumerWidget _:
            return $riverpod_5.AsyncValue<$riverpod_kit_1.ConsumerWidget>.data(
              value,
            );
          case $riverpod_5.ProviderContainer _:
            return $riverpod_5.AsyncValue<$riverpod_5.ProviderContainer>.data(
              value,
            );
          case $riverpod_kit_3.WidgetRef _:
            return $riverpod_5.AsyncValue<$riverpod_kit_3.WidgetRef>.data(
              value,
            );
          case $riverpod_5.AnyNotifier _:
            return $riverpod_5.AsyncValue<$riverpod_5.AnyNotifier>.data(value);
          case $riverpod_kit_1.ConsumerState _:
            return $riverpod_5.AsyncValue<$riverpod_kit_1.ConsumerState>.data(
              value,
            );
          case $riverpod_kit_1.ConsumerStatefulWidget _:
            return $riverpod_5.AsyncValue<
              $riverpod_kit_1.ConsumerStatefulWidget
            >.data(value);
          case $riverpod_5.ProviderObserver _:
            return $riverpod_5.AsyncValue<$riverpod_5.ProviderObserver>.data(
              value,
            );
          case $riverpod_5.ProviderObserverContext _:
            return $riverpod_5.AsyncValue<
              $riverpod_5.ProviderObserverContext
            >.data(value);
          case $riverpod_5.ProviderReference _:
            return $riverpod_5.AsyncValue<$riverpod_5.ProviderReference>.data(
              value,
            );
          case $riverpod_kit_2.ProviderScope _:
            return $riverpod_5.AsyncValue<$riverpod_kit_2.ProviderScope>.data(
              value,
            );
          case $riverpod_5.ProviderSubscription _:
            return $riverpod_5.AsyncValue<
              $riverpod_5.ProviderSubscription
            >.data(value);
          case $riverpod_kit_2.RootRegistration _:
            return $riverpod_5.AsyncValue<
              $riverpod_kit_2.RootRegistration
            >.data(value);
          case $riverpod_kit_2.UncontrolledProviderScope _:
            return $riverpod_5.AsyncValue<
              $riverpod_kit_2.UncontrolledProviderScope
            >.data(value);
          default:
            return $riverpod_5.AsyncValue.data(value);
        }
      },
      'loading': (visitor, positional, named) {
        if (!named.containsKey('progress')) {
          return $riverpod_5.AsyncValue.loading();
        }
        if (named.containsKey('progress')) {
          final progress = D4.getRequiredNamedArg<num>(
            named,
            'progress',
            'AsyncValue',
          );
          return $riverpod_5.AsyncValue.loading(progress: progress);
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
        return $riverpod_5.AsyncValue.error(error, stackTrace);
      },
    },
    getters: {
      'value': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue').value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue')
          .requireValue,
      'error': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue').error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue')
          .stackTrace,
      'valueOrNull': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue').value,
      'isLoading': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue').isLoading,
      'isRefreshing': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue').isRefreshing,
      'isReloading': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue').isReloading,
      'hasValue': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue').hasValue,
      'hasError': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue').hasError,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncValue>(target, 'AsyncValue')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncValue>(
          target,
          'AsyncValue',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncValue>(
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
        return $riverpod_5.AsyncValue.guard(future, test);
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
    nativeType: $riverpod_5.AsyncResult,
    name: 'AsyncResult',
    isAssignable: (v) => v is $riverpod_5.AsyncResult,
    hierarchyDepth: 1,
    constructors: {},
    getters: {
      'value': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncResult>(target, 'AsyncResult')
          .value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncResult>(target, 'AsyncResult')
          .requireValue,
      'error': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncResult>(target, 'AsyncResult')
          .error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncResult>(target, 'AsyncResult')
          .stackTrace,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncResult>(target, 'AsyncResult')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncResult>(
          target,
          'AsyncResult',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncResult>(
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
        return $riverpod_5.AsyncResult.guard(fn);
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
    nativeType: $riverpod_5.AsyncData,
    name: 'AsyncData',
    isAssignable: (v) => v is $riverpod_5.AsyncData,
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
        final kind = D4.getOptionalNamedArg<$riverpod_5.DataKind?>(
          named,
          'kind',
        );
        // GEN-075: Preserve generic type parameter from runtime value
        switch (value) {
          case double _:
            return $riverpod_5.AsyncData<double>(value, kind: kind);
          case int _:
            return $riverpod_5.AsyncData<int>(value, kind: kind);
          case String _:
            return $riverpod_5.AsyncData<String>(value, kind: kind);
          case bool _:
            return $riverpod_5.AsyncData<bool>(value, kind: kind);
          case $riverpod_6.AsyncNotifierProvider _:
            return $riverpod_5.AsyncData<$riverpod_6.AsyncNotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_7.FutureProvider _:
            return $riverpod_5.AsyncData<$riverpod_7.FutureProvider>(
              value,
              kind: kind,
            );
          case $riverpod_10.StreamNotifierProvider _:
            return $riverpod_5.AsyncData<$riverpod_10.StreamNotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_11.StreamProvider _:
            return $riverpod_5.AsyncData<$riverpod_11.StreamProvider>(
              value,
              kind: kind,
            );
          case $riverpod_8.NotifierProvider _:
            return $riverpod_5.AsyncData<$riverpod_8.NotifierProvider>(
              value,
              kind: kind,
            );
          case $riverpod_9.Provider _:
            return $riverpod_5.AsyncData<$riverpod_9.Provider>(
              value,
              kind: kind,
            );
          case $riverpod_6.AsyncNotifier _:
            return $riverpod_5.AsyncData<$riverpod_6.AsyncNotifier>(
              value,
              kind: kind,
            );
          case $riverpod_10.StreamNotifier _:
            return $riverpod_5.AsyncData<$riverpod_10.StreamNotifier>(
              value,
              kind: kind,
            );
          case $riverpod_8.Notifier _:
            return $riverpod_5.AsyncData<$riverpod_8.Notifier>(
              value,
              kind: kind,
            );
          case $riverpod_5.AsyncError _:
            return $riverpod_5.AsyncData<$riverpod_5.AsyncError>(
              value,
              kind: kind,
            );
          case $riverpod_kit_1.Consumer _:
            return $riverpod_5.AsyncData<$riverpod_kit_1.Consumer>(
              value,
              kind: kind,
            );
          case $riverpod_5.Ref _:
            return $riverpod_5.AsyncData<$riverpod_5.Ref>(value, kind: kind);
          case $riverpod_5.AsyncLoading _:
            return $riverpod_5.AsyncData<$riverpod_5.AsyncLoading>(
              value,
              kind: kind,
            );
          case $riverpod_5.AsyncResult _:
            return $riverpod_5.AsyncData<$riverpod_5.AsyncResult>(
              value,
              kind: kind,
            );
          case $riverpod_5.AsyncValueIsLoadingException _:
            return $riverpod_5.AsyncData<
              $riverpod_5.AsyncValueIsLoadingException
            >(value, kind: kind);
          case $riverpod_kit_1.ConsumerWidget _:
            return $riverpod_5.AsyncData<$riverpod_kit_1.ConsumerWidget>(
              value,
              kind: kind,
            );
          case $riverpod_5.ProviderContainer _:
            return $riverpod_5.AsyncData<$riverpod_5.ProviderContainer>(
              value,
              kind: kind,
            );
          case $riverpod_kit_3.WidgetRef _:
            return $riverpod_5.AsyncData<$riverpod_kit_3.WidgetRef>(
              value,
              kind: kind,
            );
          case $riverpod_5.AnyNotifier _:
            return $riverpod_5.AsyncData<$riverpod_5.AnyNotifier>(
              value,
              kind: kind,
            );
          case $riverpod_kit_1.ConsumerState _:
            return $riverpod_5.AsyncData<$riverpod_kit_1.ConsumerState>(
              value,
              kind: kind,
            );
          case $riverpod_kit_1.ConsumerStatefulWidget _:
            return $riverpod_5.AsyncData<
              $riverpod_kit_1.ConsumerStatefulWidget
            >(value, kind: kind);
          case $riverpod_5.ProviderObserver _:
            return $riverpod_5.AsyncData<$riverpod_5.ProviderObserver>(
              value,
              kind: kind,
            );
          case $riverpod_5.ProviderObserverContext _:
            return $riverpod_5.AsyncData<$riverpod_5.ProviderObserverContext>(
              value,
              kind: kind,
            );
          case $riverpod_5.ProviderReference _:
            return $riverpod_5.AsyncData<$riverpod_5.ProviderReference>(
              value,
              kind: kind,
            );
          case $riverpod_kit_2.ProviderScope _:
            return $riverpod_5.AsyncData<$riverpod_kit_2.ProviderScope>(
              value,
              kind: kind,
            );
          case $riverpod_5.ProviderSubscription _:
            return $riverpod_5.AsyncData<$riverpod_5.ProviderSubscription>(
              value,
              kind: kind,
            );
          case $riverpod_kit_2.RootRegistration _:
            return $riverpod_5.AsyncData<$riverpod_kit_2.RootRegistration>(
              value,
              kind: kind,
            );
          case $riverpod_kit_2.UncontrolledProviderScope _:
            return $riverpod_5.AsyncData<
              $riverpod_kit_2.UncontrolledProviderScope
            >(value, kind: kind);
          default:
            return $riverpod_5.AsyncData(value, kind: kind);
        }
      },
    },
    getters: {
      'value': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData').value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData')
          .requireValue,
      'error': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData').error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData')
          .stackTrace,
      'valueOrNull': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData').value,
      'isLoading': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData').isLoading,
      'isRefreshing': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData').isRefreshing,
      'isReloading': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData').isReloading,
      'hasValue': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData').hasValue,
      'hasError': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData').hasError,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData');
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncData>(target, 'AsyncData');
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
    nativeType: $riverpod_5.AsyncLoading,
    name: 'AsyncLoading',
    isAssignable: (v) => v is $riverpod_5.AsyncLoading,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final progress = D4.getOptionalNamedArg<num?>(named, 'progress');
        return $riverpod_5.AsyncLoading(progress: progress);
      },
    },
    getters: {
      'value': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading')
          .value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading')
          .requireValue,
      'error': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading')
          .error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading')
          .stackTrace,
      'valueOrNull': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading').value,
      'isLoading': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading').isLoading,
      'isRefreshing': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading').isRefreshing,
      'isReloading': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading').isReloading,
      'hasValue': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading').hasValue,
      'hasError': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading').hasError,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncLoading>(target, 'AsyncLoading')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncLoading>(
          target,
          'AsyncLoading',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncLoading>(
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
    nativeType: $riverpod_5.AsyncError,
    name: 'AsyncError',
    isAssignable: (v) => v is $riverpod_5.AsyncError,
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
        return $riverpod_5.AsyncError(error, stackTrace, retrying: retrying);
      },
    },
    getters: {
      'value': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError').value,
      'requireValue': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError')
          .requireValue,
      'error': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError').error,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError')
          .stackTrace,
      'valueOrNull': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError').value,
      'isLoading': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError').isLoading,
      'isRefreshing': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError').isRefreshing,
      'isReloading': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError').isReloading,
      'hasValue': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError').hasValue,
      'hasError': (visitor, target) =>
          D4.validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError').hasError,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_5.AsyncError>(target, 'AsyncError')
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncError>(
          target,
          'AsyncError',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_5.AsyncError>(
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
// AsyncNotifier Bridge
// =============================================================================

BridgedClass _createAsyncNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_6.AsyncNotifier,
    name: 'AsyncNotifier',
    isAssignable: (v) => v is $riverpod_6.AsyncNotifier,
    hierarchyDepth: 4,
    isAbstract: true,
    constructors: {},
    getters: {
      'ref': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifier>(target, 'AsyncNotifier')
          .ref,
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifier>(target, 'AsyncNotifier')
          .state,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifier>(target, 'AsyncNotifier')
          .future,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
              .validateTarget<$riverpod_6.AsyncNotifier>(
                target,
                'AsyncNotifier',
              )
              .state = D4.extractBridgedArg<$riverpod_5.AsyncValue<dynamic>>(
            value,
            'state',
          ),
    },
    methods: {
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncNotifier>(
          target,
          'AsyncNotifier',
        );
        return t.runBuild();
      },
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncNotifier>(
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
            $riverpod_5.AsyncValue<dynamic>? p0,
            $riverpod_5.AsyncValue<dynamic> p1,
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
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncNotifier>(
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
      'runBuild': 'WhenComplete? runBuild()',
      'listenSelf':
          'RemoveListener listenSelf(void Function(AsyncValue<StateT>? previous, AsyncValue<StateT> next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
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
    nativeType: $riverpod_6.AsyncNotifierProvider,
    name: 'AsyncNotifierProvider',
    isAssignable: (v) => v is $riverpod_6.AsyncNotifierProvider,
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
        final dependencies = D4.coerceListOrNull<$riverpod_5.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_6.AsyncNotifierProvider(
          (() {
                final rawNotifier = D4.callInterpreterCallback(
                  visitor!,
                  createNotifierRaw,
                  [],
                );
                if (rawNotifier is InterpretedInstance) {
                  return InterpretedAsyncNotifierProxy(visitor!, rawNotifier);
                }
                return D4.extractBridgedArg<$riverpod_6.AsyncNotifier<dynamic>>(
                      rawNotifier,
                      'callback',
                      visitor,
                    )
                    as $riverpod_6.AsyncNotifier<dynamic>;
              })
              as $riverpod_6.AsyncNotifier<dynamic> Function(),
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
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .future,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_6.AsyncNotifierProvider>(
            target,
            'AsyncNotifierProvider',
          )
          .hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncNotifierProvider>(
          target,
          'AsyncNotifierProvider',
        );
        return t.toString();
      },
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncNotifierProvider>(
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
                return D4.extractBridgedArg<$riverpod_6.AsyncNotifier<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_6.AsyncNotifier<dynamic>;
              })
              as $riverpod_6.AsyncNotifier<dynamic> Function(),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncNotifierProvider>(
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
          (($riverpod_5.Ref p0, $riverpod_6.AsyncNotifier<dynamic> p1) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
                );
              })
              as FutureOr<Object?> Function(
                $riverpod_5.Ref,
                $riverpod_6.AsyncNotifier<dynamic>,
              ),
        );
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_6.AsyncNotifierProvider>(
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
        final t = D4.validateTarget<$riverpod_6.AsyncNotifierProvider>(
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
      'autoDispose': (visitor) => $riverpod_6.AsyncNotifierProvider.autoDispose,
      'family': (visitor) => $riverpod_6.AsyncNotifierProvider.family,
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
// FutureProvider Bridge
// =============================================================================

BridgedClass _createFutureProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_7.FutureProvider,
    name: 'FutureProvider',
    isAssignable: (v) => v is $riverpod_7.FutureProvider,
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
        final dependencies = D4.coerceListOrNull<$riverpod_5.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_7.FutureProvider(
          (($riverpod_5.Ref p0) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                );
              })
              as FutureOr<Object?> Function($riverpod_5.Ref),
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
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .future,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_7.FutureProvider>(target, 'FutureProvider')
          .hashCode,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.FutureProvider>(
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
          (($riverpod_5.Ref p0) {
                return D4.castCallbackResult<FutureOr<Object?>>(
                  D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                );
              })
              as FutureOr<Object?> Function($riverpod_5.Ref),
        );
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.FutureProvider>(
          target,
          'FutureProvider',
        );
        return t.toString();
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.FutureProvider>(
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
        final t = D4.validateTarget<$riverpod_7.FutureProvider>(
          target,
          'FutureProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithValue');
        final value = D4.getRequiredArg<$riverpod_5.AsyncValue<dynamic>>(
          positional,
          0,
          'value',
          'overrideWithValue',
        );
        return t.overrideWithValue(value);
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_7.FutureProvider>(
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
      'autoDispose': (visitor) => $riverpod_7.FutureProvider.autoDispose,
      'family': (visitor) => $riverpod_7.FutureProvider.family,
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
// Notifier Bridge
// =============================================================================

BridgedClass _createNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_8.Notifier,
    name: 'Notifier',
    isAssignable: (v) => v is $riverpod_8.Notifier,
    hierarchyDepth: 3,
    isAbstract: true,
    constructors: {},
    getters: {
      'stateOrNull': (visitor, target) => D4
          .validateTarget<$riverpod_8.Notifier>(target, 'Notifier')
          .stateOrNull,
      'ref': (visitor, target) =>
          D4.validateTarget<$riverpod_8.Notifier>(target, 'Notifier').ref,
      'state': (visitor, target) =>
          D4.validateTarget<$riverpod_8.Notifier>(target, 'Notifier').state,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4.validateTarget<$riverpod_8.Notifier>(target, 'Notifier').state =
              value as dynamic,
    },
    methods: {
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.Notifier>(target, 'Notifier');
        return t.runBuild();
      },
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.Notifier>(target, 'Notifier');
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
    },
    methodSignatures: {
      'runBuild': 'WhenComplete? runBuild()',
      'listenSelf':
          'RemoveListener listenSelf(void Function(ValueT? previous, ValueT next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
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
    nativeType: $riverpod_8.NotifierProvider,
    name: 'NotifierProvider',
    isAssignable: (v) => v is $riverpod_8.NotifierProvider,
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
        final dependencies = D4.coerceListOrNull<$riverpod_5.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_8.NotifierProvider(
          (() {
                final rawNotifier = D4.callInterpreterCallback(
                  visitor!,
                  createNotifierRaw,
                  [],
                );
                // DN-PATCH: InterpretedInstance → native Notifier proxy.
                // Riverpod requires _createNotifier() to return a real
                // Notifier<T> subclass. When interpreted code provides
                // `AppStateNotifier.new`, the interpreter produces an
                // InterpretedInstance which cannot satisfy Notifier<dynamic>
                // via reified-generics. Wrap it directly here.
                if (rawNotifier is InterpretedInstance) {
                  return InterpretedNotifierProxy(visitor!, rawNotifier);
                }
                return D4.extractBridgedArg<$riverpod_8.Notifier<dynamic>>(
                      rawNotifier,
                      'callback',
                      visitor,
                    )
                    as $riverpod_8.Notifier<dynamic>;
              })
              as $riverpod_8.Notifier<dynamic> Function(),
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
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .isAutoDispose,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_8.NotifierProvider>(
            target,
            'NotifierProvider',
          )
          .hashCode,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.NotifierProvider>(
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
                return D4.extractBridgedArg<$riverpod_8.Notifier<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_8.Notifier<dynamic>;
              })
              as $riverpod_8.Notifier<dynamic> Function(),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.NotifierProvider>(
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
          $riverpod_5.Ref p0,
          $riverpod_8.Notifier<dynamic> p1,
        ) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
          );
        });
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.NotifierProvider>(
          target,
          'NotifierProvider',
        );
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_8.NotifierProvider>(
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
      'autoDispose': (visitor) => $riverpod_8.NotifierProvider.autoDispose,
      'family': (visitor) => $riverpod_8.NotifierProvider.family,
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
// Provider Bridge
// =============================================================================

BridgedClass _createProviderBridge() {
  return BridgedClass(
    nativeType: $riverpod_9.Provider,
    name: 'Provider',
    isAssignable: (v) => v is $riverpod_9.Provider,
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
        final dependencies = D4.coerceListOrNull<$riverpod_5.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_9.Provider(
          ($riverpod_5.Ref p0) {
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
          D4.validateTarget<$riverpod_9.Provider>(target, 'Provider').from,
      'origin': (visitor, target) =>
          D4.validateTarget<$riverpod_9.Provider>(target, 'Provider').origin,
      'argument': (visitor, target) =>
          D4.validateTarget<$riverpod_9.Provider>(target, 'Provider').argument,
      'name': (visitor, target) =>
          D4.validateTarget<$riverpod_9.Provider>(target, 'Provider').name,
      'retry': (visitor, target) =>
          D4.validateTarget<$riverpod_9.Provider>(target, 'Provider').retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_9.Provider>(target, 'Provider')
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_9.Provider>(target, 'Provider')
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_9.Provider>(target, 'Provider')
          .isAutoDispose,
      'hashCode': (visitor, target) =>
          D4.validateTarget<$riverpod_9.Provider>(target, 'Provider').hashCode,
    },
    methods: {
      'overrideWithValue': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_9.Provider>(target, 'Provider');
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
        final t = D4.validateTarget<$riverpod_9.Provider>(target, 'Provider');
        D4.requireMinArgs(positional, 1, 'overrideWith');
        if (positional.isEmpty) {
          throw ArgumentError(
            'overrideWith: Missing required argument "create" at position 0',
          );
        }
        final createRaw = positional[0];
        return (t as dynamic).overrideWith(($riverpod_5.Ref p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, createRaw, [p0]),
          );
        });
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_9.Provider>(target, 'Provider');
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_9.Provider>(target, 'Provider');
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
      'autoDispose': (visitor) => $riverpod_9.Provider.autoDispose,
      'family': (visitor) => $riverpod_9.Provider.family,
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
// StreamNotifier Bridge
// =============================================================================

BridgedClass _createStreamNotifierBridge() {
  return BridgedClass(
    nativeType: $riverpod_10.StreamNotifier,
    name: 'StreamNotifier',
    isAssignable: (v) => v is $riverpod_10.StreamNotifier,
    hierarchyDepth: 4,
    isAbstract: true,
    constructors: {},
    getters: {
      'ref': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifier>(target, 'StreamNotifier')
          .ref,
      'state': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifier>(target, 'StreamNotifier')
          .state,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifier>(target, 'StreamNotifier')
          .future,
    },
    setters: {
      'state': (visitor, target, value) =>
          D4
              .validateTarget<$riverpod_10.StreamNotifier>(
                target,
                'StreamNotifier',
              )
              .state = D4.extractBridgedArg<$riverpod_5.AsyncValue<dynamic>>(
            value,
            'state',
          ),
    },
    methods: {
      'runBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StreamNotifier>(
          target,
          'StreamNotifier',
        );
        return t.runBuild();
      },
      'listenSelf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StreamNotifier>(
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
            $riverpod_5.AsyncValue<dynamic>? p0,
            $riverpod_5.AsyncValue<dynamic> p1,
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
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StreamNotifier>(
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
      'runBuild': 'WhenComplete? runBuild()',
      'listenSelf':
          'RemoveListener listenSelf(void Function(AsyncValue<ValueT>? previous, AsyncValue<ValueT> next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
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
    nativeType: $riverpod_10.StreamNotifierProvider,
    name: 'StreamNotifierProvider',
    isAssignable: (v) => v is $riverpod_10.StreamNotifierProvider,
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
        final dependencies = D4.coerceListOrNull<$riverpod_5.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_10.StreamNotifierProvider(
          (() {
                final rawNotifier = D4.callInterpreterCallback(
                  visitor!,
                  createNotifierRaw,
                  [],
                );
                if (rawNotifier is InterpretedInstance) {
                  return InterpretedStreamNotifierProxy(visitor!, rawNotifier);
                }
                return D4.extractBridgedArg<
                      $riverpod_10.StreamNotifier<dynamic>
                    >(
                      rawNotifier,
                      'callback',
                      visitor,
                    )
                    as $riverpod_10.StreamNotifier<dynamic>;
              })
              as $riverpod_10.StreamNotifier<dynamic> Function(),
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
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .notifier,
      'from': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .future,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_10.StreamNotifierProvider>(
            target,
            'StreamNotifierProvider',
          )
          .hashCode,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StreamNotifierProvider>(
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
                      $riverpod_10.StreamNotifier<dynamic>
                    >(
                      D4.callInterpreterCallback(visitor!, createRaw, []),
                      'callback',
                      visitor,
                    )
                    as $riverpod_10.StreamNotifier<dynamic>;
              })
              as $riverpod_10.StreamNotifier<dynamic> Function(),
        );
      },
      'overrideWithBuild': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StreamNotifierProvider>(
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
          (($riverpod_5.Ref p0, $riverpod_10.StreamNotifier<dynamic> p1) {
                return D4.extractBridgedArg<Stream<dynamic>>(
                      D4.callInterpreterCallback(visitor!, buildRaw, [p0, p1]),
                      'callback',
                      visitor,
                    )
                    as Stream<dynamic>;
              })
              as Stream<dynamic> Function(
                $riverpod_5.Ref,
                $riverpod_10.StreamNotifier<dynamic>,
              ),
        );
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StreamNotifierProvider>(
          target,
          'StreamNotifierProvider',
        );
        return t.toString();
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_10.StreamNotifierProvider>(
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
        final t = D4.validateTarget<$riverpod_10.StreamNotifierProvider>(
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
          $riverpod_10.StreamNotifierProvider.autoDispose,
      'family': (visitor) => $riverpod_10.StreamNotifierProvider.family,
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
    nativeType: $riverpod_11.StreamProvider,
    name: 'StreamProvider',
    isAssignable: (v) => v is $riverpod_11.StreamProvider,
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
        final dependencies = D4.coerceListOrNull<$riverpod_5.ProviderOrFamily>(
          named['dependencies'],
          'dependencies',
        );
        final isAutoDispose = D4.getNamedArgWithDefault<bool>(
          named,
          'isAutoDispose',
          false,
        );
        final retryRaw = named['retry'];
        return $riverpod_11.StreamProvider(
          (($riverpod_5.Ref p0) {
                return D4.extractBridgedArg<Stream<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as Stream<dynamic>;
              })
              as Stream<dynamic> Function($riverpod_5.Ref),
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
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .from,
      'origin': (visitor, target) => D4
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .origin,
      'argument': (visitor, target) => D4
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .argument,
      'name': (visitor, target) => D4
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .name,
      'retry': (visitor, target) => D4
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .retry,
      'dependencies': (visitor, target) => D4
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .dependencies,
      '\$allTransitiveDependencies': (visitor, target) => D4
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .$allTransitiveDependencies,
      'isAutoDispose': (visitor, target) => D4
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .isAutoDispose,
      'future': (visitor, target) => D4
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .future,
      'hashCode': (visitor, target) => D4
          .validateTarget<$riverpod_11.StreamProvider>(target, 'StreamProvider')
          .hashCode,
    },
    methods: {
      'overrideWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StreamProvider>(
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
          (($riverpod_5.Ref p0) {
                return D4.extractBridgedArg<Stream<dynamic>>(
                      D4.callInterpreterCallback(visitor!, createRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as Stream<dynamic>;
              })
              as Stream<dynamic> Function($riverpod_5.Ref),
        );
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StreamProvider>(
          target,
          'StreamProvider',
        );
        return t.toString();
      },
      'selectAsync': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StreamProvider>(
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
        final t = D4.validateTarget<$riverpod_11.StreamProvider>(
          target,
          'StreamProvider',
        );
        D4.requireMinArgs(positional, 1, 'overrideWithValue');
        final value = D4.getRequiredArg<$riverpod_5.AsyncValue<dynamic>>(
          positional,
          0,
          'value',
          'overrideWithValue',
        );
        return t.overrideWithValue(value);
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_11.StreamProvider>(
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
      'autoDispose': (visitor) => $riverpod_11.StreamProvider.autoDispose,
      'family': (visitor) => $riverpod_11.StreamProvider.family,
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
          final child = D4.getRequiredNamedArg<dynamic>(
            named,
            'child',
            'Consumer',
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
          final child = D4.getRequiredNamedArg<dynamic>(
            named,
            'child',
            'Consumer',
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
            ? D4.coerceList<$riverpod_5.Override>(
                named['overrides'],
                'overrides',
              )
            : const <$riverpod_5.Override>[];
        final observers = D4.coerceListOrNull<$riverpod_5.ProviderObserver>(
          named['observers'],
          'observers',
        );
        final retryRaw = named['retry'];
        final child = D4.extractBridgedArg<$flutter_widgets.Widget>(
          D4.getRequiredNamedArg<dynamic>(
            named,
            'child',
            'ProviderScope',
          ),
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
        final container = D4.getRequiredArg<$riverpod_5.ProviderContainer>(
          positional,
          0,
          'container',
          'registerRoot',
        );
        return $riverpod_kit_2.ProviderScope.registerRoot(container);
      },
    },
    constructorSignatures: {
      '': 'const ProviderScope({dynamic key, List<Override> overrides = const [], List<ProviderObserver>? observers, Duration? Function(int retryCount, Object error)? retry, required InvalidType child})',
    },
    methodSignatures: {
      'createState': 'InvalidType createState()',
    },
    getterSignatures: {
      'overrides': 'List<Override> get overrides',
      'observers': 'List<ProviderObserver>? get observers',
      'retry': 'Duration? Function(int retryCount, Object error)? get retry',
      'child': 'InvalidType get child',
    },
    staticMethodSignatures: {
      'containerOf': 'ProviderContainer containerOf(InvalidType context)',
      'maybeContainerOf':
          'ProviderContainer? maybeContainerOf(InvalidType context)',
      'registerRoot':
          'RootRegistration registerRoot(ProviderContainer container)',
    },
    staticGetterSignatures: {
      'rootContainer': 'ProviderContainer? get rootContainer',
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
      'container': 'ProviderContainer get container',
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
        final container = D4.getRequiredNamedArg<$riverpod_5.ProviderContainer>(
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
      '': 'const UncontrolledProviderScope({dynamic key, required ProviderContainer container, required InvalidType child})',
    },
    methodSignatures: {
      'createState': 'InvalidType createState()',
    },
    getterSignatures: {
      'container': 'ProviderContainer get container',
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
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    getters: {
      'context': (visitor, target) => D4
          .validateTarget<$riverpod_kit_3.WidgetRef>(target, 'WidgetRef')
          .context,
      'container': (visitor, target) => D4
          .validateTarget<$riverpod_kit_3.WidgetRef>(target, 'WidgetRef')
          .container,
    },
    methods: {
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$riverpod_kit_3.WidgetRef>(
          target,
          'WidgetRef',
        );
        D4.requireMinArgs(positional, 1, 'watch');
        final provider = D4
            .getRequiredArg<$riverpod_5.ProviderListenable<dynamic>>(
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
        final provider = D4.getRequiredArg<$riverpod_5.ProviderBase<Object?>>(
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
        final provider = D4
            .getRequiredArg<$riverpod_5.ProviderListenable<dynamic>>(
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
        final provider = D4
            .getRequiredArg<$riverpod_5.ProviderListenable<dynamic>>(
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
        final provider = D4
            .getRequiredArg<$riverpod_5.ProviderListenable<dynamic>>(
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
        final provider = D4.getRequiredArg<$riverpod_5.Refreshable<dynamic>>(
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
        final provider = D4.getRequiredArg<$riverpod_5.ProviderOrFamily>(
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
      'watch': 'StateT watch(ProviderListenable<StateT> provider)',
      'exists': 'bool exists(ProviderBase<Object?> provider)',
      'listen':
          'void listen(ProviderListenable<StateT> provider, void Function(StateT? previous, StateT next) listener, {void Function(Object error, StackTrace stackTrace)? onError})',
      'listenManual':
          'ProviderSubscription<StateT> listenManual(ProviderListenable<StateT> provider, void Function(StateT? previous, StateT next) listener, {void Function(Object error, StackTrace stackTrace)? onError, bool fireImmediately})',
      'read': 'StateT read(ProviderListenable<StateT> provider)',
      'refresh': 'StateT refresh(Refreshable<StateT> provider)',
      'invalidate':
          'void invalidate(ProviderOrFamily provider, {bool asReload = false})',
    },
    getterSignatures: {
      'context': 'InvalidType get context',
      'container': 'ProviderContainer get container',
    },
  );
}

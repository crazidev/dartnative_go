// D4rt Bridge - Generated file, do not edit
// Sources: 25 files
// Generated: 2026-11-24T16:25:19.259855 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as $dart_math;
import 'dart:math';
import 'dart:typed_data';

import 'package:dartnative_hive/src/hive/hive.dart' as $dartnative_hive_1;
import 'package:dartnative_hive/src/hive/src/annotations/generate_adapters.dart'
    as $dartnative_hive_2;
import 'package:dartnative_hive/src/hive/src/annotations/hive_field.dart'
    as $dartnative_hive_3;
import 'package:dartnative_hive/src/hive/src/annotations/hive_type.dart'
    as $dartnative_hive_4;
import 'package:dartnative_hive/src/hive/src/binary/binary_reader.dart'
    as $dartnative_hive_5;
import 'package:dartnative_hive/src/hive/src/binary/binary_writer.dart'
    as $dartnative_hive_6;
import 'package:dartnative_hive/src/hive/src/box/box.dart'
    as $dartnative_hive_7;
import 'package:dartnative_hive/src/hive/src/box/box_base.dart'
    as $dartnative_hive_8;
import 'package:dartnative_hive/src/hive/src/box/lazy_box.dart'
    as $dartnative_hive_9;
import 'package:dartnative_hive/src/hive/src/crypto/hive_aes_cipher.dart'
    as $dartnative_hive_10;
import 'package:dartnative_hive/src/hive/src/crypto/hive_cipher.dart'
    as $dartnative_hive_11;
import 'package:dartnative_hive/src/hive/src/hive.dart' as $dartnative_hive_12;
import 'package:dartnative_hive/src/hive/src/hive_error.dart'
    as $dartnative_hive_13;
import 'package:dartnative_hive/src/hive/src/isolate/isolate_name_server.dart'
    as $dartnative_hive_14;
import 'package:dartnative_hive/src/hive/src/isolate/isolated_box.dart'
    as $dartnative_hive_15;
import 'package:dartnative_hive/src/hive/src/isolate/isolated_compaction_strategy.dart'
    as $dartnative_hive_16;
import 'package:dartnative_hive/src/hive/src/isolate/isolated_hive.dart'
    as $dartnative_hive_17;
import 'package:dartnative_hive/src/hive/src/object/hive_collection.dart'
    as $dartnative_hive_18;
import 'package:dartnative_hive/src/hive/src/object/hive_list.dart'
    as $dartnative_hive_19;
import 'package:dartnative_hive/src/hive/src/object/hive_object.dart'
    as $dartnative_hive_20;
import 'package:dartnative_hive/src/hive/src/object/hive_storage_backend_preference.dart'
    as $dartnative_hive_21;
import 'package:dartnative_hive/src/hive/src/registry/type_adapter.dart'
    as $dartnative_hive_22;
import 'package:dartnative_hive/src/hive/src/registry/type_registry.dart'
    as $dartnative_hive_23;
import 'package:dartnative_hive/src/hive/src/util/extensions.dart'
    as $dartnative_hive_24;
import 'package:dartnative_hive/src/hive_init.dart' as $dartnative_hive_25;

/// Bridge class for dartnative_hive module.
class DartnativeHiveBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createHiveObjectBridge(),
      _createHiveObjectMixinBridge(),
      _createGenerateAdaptersBridge(),
      _createAdapterSpecBridge(),
      _createHiveFieldBridge(),
      _createHiveTypeBridge(),
      _createBinaryReaderBridge(),
      _createBinaryWriterBridge(),
      _createBoxBridge(),
      _createBoxEventBridge(),
      _createBoxBaseBridge(),
      _createLazyBoxBridge(),
      _createHiveAesCipherBridge(),
      _createHiveCipherBridge(),
      _createHiveInterfaceBridge(),
      _createHiveErrorBridge(),
      _createHiveCollectionBridge(),
      _createHiveListBridge(),
      _createTypeAdapterBridge(),
      _createTypeRegistryBridge(),
      _createIsolateNameServerBridge(),
      _createIsolatedCompactionStrategyBridge(),
      _createIsolatedHiveInterfaceBridge(),
      _createIsolatedBoxBaseBridge(),
      _createIsolatedBoxBridge(),
      _createIsolatedLazyBoxBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'HiveObject': _createHiveObjectBridge,
      'HiveObjectMixin': _createHiveObjectMixinBridge,
      'GenerateAdapters': _createGenerateAdaptersBridge,
      'AdapterSpec': _createAdapterSpecBridge,
      'HiveField': _createHiveFieldBridge,
      'HiveType': _createHiveTypeBridge,
      'BinaryReader': _createBinaryReaderBridge,
      'BinaryWriter': _createBinaryWriterBridge,
      'Box': _createBoxBridge,
      'BoxEvent': _createBoxEventBridge,
      'BoxBase': _createBoxBaseBridge,
      'LazyBox': _createLazyBoxBridge,
      'HiveAesCipher': _createHiveAesCipherBridge,
      'HiveCipher': _createHiveCipherBridge,
      'HiveInterface': _createHiveInterfaceBridge,
      'HiveError': _createHiveErrorBridge,
      'HiveCollection': _createHiveCollectionBridge,
      'HiveList': _createHiveListBridge,
      'TypeAdapter': _createTypeAdapterBridge,
      'TypeRegistry': _createTypeRegistryBridge,
      'IsolateNameServer': _createIsolateNameServerBridge,
      'IsolatedCompactionStrategy': _createIsolatedCompactionStrategyBridge,
      'IsolatedHiveInterface': _createIsolatedHiveInterfaceBridge,
      'IsolatedBoxBase': _createIsolatedBoxBaseBridge,
      'IsolatedBox': _createIsolatedBoxBridge,
      'IsolatedLazyBox': _createIsolatedLazyBoxBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'HiveObject': $dartnative_hive_20.HiveObject,
      'HiveObjectMixin': $dartnative_hive_20.HiveObjectMixin,
      'GenerateAdapters': $dartnative_hive_2.GenerateAdapters,
      'AdapterSpec': $dartnative_hive_2.AdapterSpec,
      'HiveField': $dartnative_hive_3.HiveField,
      'HiveType': $dartnative_hive_4.HiveType,
      'BinaryReader': $dartnative_hive_5.BinaryReader,
      'BinaryWriter': $dartnative_hive_6.BinaryWriter,
      'Box': $dartnative_hive_7.Box,
      'BoxEvent': $dartnative_hive_8.BoxEvent,
      'BoxBase': $dartnative_hive_8.BoxBase,
      'LazyBox': $dartnative_hive_9.LazyBox,
      'HiveAesCipher': $dartnative_hive_10.HiveAesCipher,
      'HiveCipher': $dartnative_hive_11.HiveCipher,
      'HiveInterface': $dartnative_hive_12.HiveInterface,
      'HiveError': $dartnative_hive_13.HiveError,
      'HiveCollection': $dartnative_hive_18.HiveCollection,
      'HiveList': $dartnative_hive_19.HiveList,
      'TypeAdapter': $dartnative_hive_22.TypeAdapter,
      'TypeRegistry': $dartnative_hive_23.TypeRegistry,
      'IsolateNameServer': $dartnative_hive_14.IsolateNameServer,
      'IsolatedCompactionStrategy':
          $dartnative_hive_16.IsolatedCompactionStrategy,
      'IsolatedHiveInterface': $dartnative_hive_17.IsolatedHiveInterface,
      'IsolatedBoxBase': $dartnative_hive_15.IsolatedBoxBase,
      'IsolatedBox': $dartnative_hive_15.IsolatedBox,
      'IsolatedLazyBox': $dartnative_hive_15.IsolatedLazyBox,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'HiveObject':
          'package:dartnative_hive/src/hive/src/object/hive_object.dart',
      'HiveObjectMixin':
          'package:dartnative_hive/src/hive/src/object/hive_object.dart',
      'GenerateAdapters':
          'package:dartnative_hive/src/hive/src/annotations/generate_adapters.dart',
      'AdapterSpec':
          'package:dartnative_hive/src/hive/src/annotations/generate_adapters.dart',
      'HiveField':
          'package:dartnative_hive/src/hive/src/annotations/hive_field.dart',
      'HiveType':
          'package:dartnative_hive/src/hive/src/annotations/hive_type.dart',
      'BinaryReader':
          'package:dartnative_hive/src/hive/src/binary/binary_reader.dart',
      'BinaryWriter':
          'package:dartnative_hive/src/hive/src/binary/binary_writer.dart',
      'Box': 'package:dartnative_hive/src/hive/src/box/box.dart',
      'BoxEvent': 'package:dartnative_hive/src/hive/src/box/box_base.dart',
      'BoxBase': 'package:dartnative_hive/src/hive/src/box/box_base.dart',
      'LazyBox': 'package:dartnative_hive/src/hive/src/box/lazy_box.dart',
      'HiveAesCipher':
          'package:dartnative_hive/src/hive/src/crypto/hive_aes_cipher.dart',
      'HiveCipher':
          'package:dartnative_hive/src/hive/src/crypto/hive_cipher.dart',
      'HiveInterface': 'package:dartnative_hive/src/hive/src/hive.dart',
      'HiveError': 'package:dartnative_hive/src/hive/src/hive_error.dart',
      'HiveCollection':
          'package:dartnative_hive/src/hive/src/object/hive_collection.dart',
      'HiveList': 'package:dartnative_hive/src/hive/src/object/hive_list.dart',
      'TypeAdapter':
          'package:dartnative_hive/src/hive/src/registry/type_adapter.dart',
      'TypeRegistry':
          'package:dartnative_hive/src/hive/src/registry/type_registry.dart',
      'IsolateNameServer':
          'package:dartnative_hive/src/hive/src/isolate/isolate_name_server.dart',
      'IsolatedCompactionStrategy':
          'package:dartnative_hive/src/hive/src/isolate/isolated_compaction_strategy.dart',
      'IsolatedHiveInterface':
          'package:dartnative_hive/src/hive/src/isolate/isolated_hive.dart',
      'IsolatedBoxBase':
          'package:dartnative_hive/src/hive/src/isolate/isolated_box.dart',
      'IsolatedBox':
          'package:dartnative_hive/src/hive/src/isolate/isolated_box.dart',
      'IsolatedLazyBox':
          'package:dartnative_hive/src/hive/src/isolate/isolated_box.dart',
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
      'HiveObject': ['HiveObjectMixin'],
      'Box': ['BoxBase'],
      'LazyBox': ['BoxBase'],
      'HiveAesCipher': ['HiveCipher'],
      'HiveInterface': ['TypeRegistry'],
      'HiveError': ['Error'],
      'HiveCollection': [
        'List',
        'Iterable',
        '_ListIterable',
        'EfficientLengthIterable',
        'HideEfficientLengthIterable',
      ],
      'HiveList': [
        'HiveCollection',
        'List',
        'Iterable',
        '_ListIterable',
        'EfficientLengthIterable',
        'HideEfficientLengthIterable',
      ],
      'IsolatedHiveInterface': ['TypeRegistry'],
      'IsolatedBox': ['IsolatedBoxBase'],
      'IsolatedLazyBox': ['IsolatedBoxBase'],
    };
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {
      'HiveLogger': 'Logger',
      'HiveLoggerLevel': 'LoggerLevel',
    };
  }

  /// Returns the list of function typedef names declared in this library.
  ///
  /// Function typedefs like `typedef VoidCallback = void Function()` are
  /// registered so that they can be used as type arguments in D4rt scripts.
  static List<String> functionTypedefs() {
    return [
      'KeyComparator',
      'CompactionStrategy',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dartnative_hive_21.HiveStorageBackendPreference>(
        name: 'HiveStorageBackendPreference',
        values: $dartnative_hive_21.HiveStorageBackendPreference.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'HiveStorageBackendPreference':
          'package:dartnative_hive/src/hive/src/object/hive_storage_backend_preference.dart',
    };
  }

  /// Returns all bridged extension definitions.
  static List<BridgedExtensionDefinition> bridgedExtensions() {
    return [
      BridgedExtensionDefinition(
        name: 'HiveObjectInternal',
        onTypeName: 'HiveObjectMixin',
        getters: {
          'debugHiveLists': (visitor, target) =>
              (target as $dartnative_hive_20.HiveObjectMixin).debugHiveLists,
        },
        methods: {
          'init': (visitor, target, positional, named, typeArgs) {
            final t = target as $dartnative_hive_20.HiveObjectMixin;
            return Function.apply(
              t.init,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'dispose': (visitor, target, positional, named, typeArgs) {
            final t = target as $dartnative_hive_20.HiveObjectMixin;
            return Function.apply(
              t.dispose,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'linkHiveList': (visitor, target, positional, named, typeArgs) {
            final t = target as $dartnative_hive_20.HiveObjectMixin;
            return Function.apply(
              t.linkHiveList,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'unlinkHiveList': (visitor, target, positional, named, typeArgs) {
            final t = target as $dartnative_hive_20.HiveObjectMixin;
            return Function.apply(
              t.unlinkHiveList,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'isInHiveList': (visitor, target, positional, named, typeArgs) {
            final t = target as $dartnative_hive_20.HiveObjectMixin;
            return Function.apply(
              t.isInHiveList,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'StringX',
        onTypeName: 'String',
        getters: {
          'isAscii': (visitor, target) => (target as String).isAscii,
        },
      ),
      BridgedExtensionDefinition(
        name: 'ListIntX',
        onTypeName: 'List',
        methods: {
          'readUint32': (visitor, target, positional, named, typeArgs) {
            final t = target as List<int>;
            return Function.apply(
              t.readUint32,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'writeUint32': (visitor, target, positional, named, typeArgs) {
            final t = target as List<int>;
            return Function.apply(
              t.writeUint32,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'Uint8ListX',
        onTypeName: 'Uint8List',
        methods: {
          'view': (visitor, target, positional, named, typeArgs) {
            final t = target as Uint8List;
            return Function.apply(
              t.view,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'RandomX',
        onTypeName: 'Random',
        methods: {
          'nextBytes': (visitor, target, positional, named, typeArgs) {
            final t = target as $dart_math.Random;
            return Function.apply(
              t.nextBytes,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'DartNativeHiveX',
        onTypeName: 'HiveInterface',
        methods: {
          'initDartNative': (visitor, target, positional, named, typeArgs) {
            final t = target as $dartnative_hive_12.HiveInterface;
            return Function.apply(
              t.initDartNative,
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
      'HiveObjectInternal@HiveObjectMixin':
          'package:dartnative_hive/src/hive/src/object/hive_object.dart',
      'StringX@String':
          'package:dartnative_hive/src/hive/src/util/extensions.dart',
      'ListIntX@List':
          'package:dartnative_hive/src/hive/src/util/extensions.dart',
      'Uint8ListX@Uint8List':
          'package:dartnative_hive/src/hive/src/util/extensions.dart',
      'RandomX@Random':
          'package:dartnative_hive/src/hive/src/util/extensions.dart',
      'DartNativeHiveX@HiveInterface':
          'package:dartnative_hive/src/hive_init.dart',
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
        source: 'package:dartnative_hive/dartnative_hive.dart',
        target: 'package:dartnative_hive/src/hive/hive.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/dartnative_hive.dart',
        target: 'package:dartnative_hive/src/hive_init.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/box_collection/box_collection_stub.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target: 'package:dartnative_hive/src/hive/src/object/hive_object.dart',
        show: {'HiveObject', 'HiveObjectMixin'},
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/annotations/generate_adapters.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/annotations/hive_field.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/annotations/hive_type.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/binary/binary_reader.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/binary/binary_writer.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target: 'package:dartnative_hive/src/hive/src/box/box.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target: 'package:dartnative_hive/src/hive/src/box/box_base.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target: 'package:dartnative_hive/src/hive/src/box/lazy_box.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/crypto/hive_aes_cipher.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target: 'package:dartnative_hive/src/hive/src/crypto/hive_cipher.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target: 'package:dartnative_hive/src/hive/src/hive.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target: 'package:dartnative_hive/src/hive/src/hive_error.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/object/hive_collection.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target: 'package:dartnative_hive/src/hive/src/object/hive_list.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/object/hive_storage_backend_preference.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/registry/type_adapter.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/registry/type_registry.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/isolate/isolate_name_server.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/isolate/isolated_compaction_strategy.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/isolate/isolated_hive.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_hive/src/hive/hive.dart',
        target:
            'package:dartnative_hive/src/hive/src/isolate/isolated_box.dart',
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

  /// Registers all global variables with the interpreter.
  ///
  /// [importPath] is the package import path for library-scoped registration.
  /// Collects all registration errors and throws a single exception
  /// with all error details if any registrations fail.
  static void registerGlobalVariables(D4rt interpreter, String importPath) {
    final errors = <String>[];

    try {
      interpreter.registerGlobalVariable(
        'Hive',
        $dartnative_hive_1.Hive,
        importPath,
        sourceUri: 'package:dartnative_hive/src/hive/hive.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "Hive": $e');
    }
    try {
      interpreter.registerGlobalVariable(
        'IsolatedHive',
        $dartnative_hive_1.IsolatedHive,
        importPath,
        sourceUri: 'package:dartnative_hive/src/hive/hive.dart',
      );
    } catch (e) {
      errors.add('Failed to register variable "IsolatedHive": $e');
    }

    if (errors.isNotEmpty) {
      throw StateError(
        'Bridge registration errors (dartnative_hive):\n${errors.join("\n")}',
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
      'package:dartnative_hive/src/hive/hive.dart',
      'package:dartnative_hive/src/hive/src/annotations/generate_adapters.dart',
      'package:dartnative_hive/src/hive/src/annotations/hive_field.dart',
      'package:dartnative_hive/src/hive/src/annotations/hive_type.dart',
      'package:dartnative_hive/src/hive/src/binary/binary_reader.dart',
      'package:dartnative_hive/src/hive/src/binary/binary_writer.dart',
      'package:dartnative_hive/src/hive/src/box/box.dart',
      'package:dartnative_hive/src/hive/src/box/box_base.dart',
      'package:dartnative_hive/src/hive/src/box/lazy_box.dart',
      'package:dartnative_hive/src/hive/src/crypto/hive_aes_cipher.dart',
      'package:dartnative_hive/src/hive/src/crypto/hive_cipher.dart',
      'package:dartnative_hive/src/hive/src/hive.dart',
      'package:dartnative_hive/src/hive/src/hive_error.dart',
      'package:dartnative_hive/src/hive/src/isolate/isolate_name_server.dart',
      'package:dartnative_hive/src/hive/src/isolate/isolated_box.dart',
      'package:dartnative_hive/src/hive/src/isolate/isolated_compaction_strategy.dart',
      'package:dartnative_hive/src/hive/src/isolate/isolated_hive.dart',
      'package:dartnative_hive/src/hive/src/object/hive_collection.dart',
      'package:dartnative_hive/src/hive/src/object/hive_list.dart',
      'package:dartnative_hive/src/hive/src/object/hive_object.dart',
      'package:dartnative_hive/src/hive/src/object/hive_storage_backend_preference.dart',
      'package:dartnative_hive/src/hive/src/registry/type_adapter.dart',
      'package:dartnative_hive/src/hive/src/registry/type_registry.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_hive/dartnative_hive.dart';";
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
    'HiveStorageBackendPreference',
  ];
}

// =============================================================================
// HiveObject Bridge
// =============================================================================

BridgedClass _createHiveObjectBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_20.HiveObject,
    name: 'HiveObject',
    isAssignable: (v) => v is $dartnative_hive_20.HiveObject,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    getters: {
      'box': (visitor, target) => D4
          .validateTarget<$dartnative_hive_20.HiveObject>(target, 'HiveObject')
          .box,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_hive_20.HiveObject>(target, 'HiveObject')
          .key,
      'isInBox': (visitor, target) => D4
          .validateTarget<$dartnative_hive_20.HiveObject>(target, 'HiveObject')
          .isInBox,
    },
    methods: {
      'save': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_20.HiveObject>(
          target,
          'HiveObject',
        );
        return t.save();
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_20.HiveObject>(
          target,
          'HiveObject',
        );
        return t.delete();
      },
    },
    methodSignatures: {
      'save': 'Future<void> save()',
      'delete': 'Future<void> delete()',
    },
    getterSignatures: {
      'box': 'BoxBase? get box',
      'key': 'dynamic get key',
      'isInBox': 'bool get isInBox',
    },
  );
}

// =============================================================================
// HiveObjectMixin Bridge
// =============================================================================

BridgedClass _createHiveObjectMixinBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_20.HiveObjectMixin,
    name: 'HiveObjectMixin',
    isAssignable: (v) => v is $dartnative_hive_20.HiveObjectMixin,
    canBeUsedAsMixin: true,
    isAbstract: true,
    constructors: {},
    getters: {
      'box': (visitor, target) => D4
          .validateTarget<$dartnative_hive_20.HiveObjectMixin>(
            target,
            'HiveObjectMixin',
          )
          .box,
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_hive_20.HiveObjectMixin>(
            target,
            'HiveObjectMixin',
          )
          .key,
      'isInBox': (visitor, target) => D4
          .validateTarget<$dartnative_hive_20.HiveObjectMixin>(
            target,
            'HiveObjectMixin',
          )
          .isInBox,
    },
    methods: {
      'save': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_20.HiveObjectMixin>(
          target,
          'HiveObjectMixin',
        );
        return t.save();
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_20.HiveObjectMixin>(
          target,
          'HiveObjectMixin',
        );
        return t.delete();
      },
    },
    methodSignatures: {
      'save': 'Future<void> save()',
      'delete': 'Future<void> delete()',
    },
    getterSignatures: {
      'box': 'BoxBase? get box',
      'key': 'dynamic get key',
      'isInBox': 'bool get isInBox',
    },
  );
}

// =============================================================================
// GenerateAdapters Bridge
// =============================================================================

BridgedClass _createGenerateAdaptersBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_2.GenerateAdapters,
    name: 'GenerateAdapters',
    isAssignable: (v) => v is $dartnative_hive_2.GenerateAdapters,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'GenerateAdapters');
        if (positional.isEmpty) {
          throw ArgumentError(
            'GenerateAdapters: Missing required argument "specs" at position 0',
          );
        }
        final specs = D4.coerceList<$dartnative_hive_2.AdapterSpec>(
          positional[0],
          'specs',
        );
        final firstTypeId = D4.getNamedArgWithDefault<int>(
          named,
          'firstTypeId',
          0,
        );
        final reservedTypeIds =
            named.containsKey('reservedTypeIds') &&
                named['reservedTypeIds'] != null
            ? D4.coerceSet<int>(named['reservedTypeIds'], 'reservedTypeIds')
            : const <int>{};
        return $dartnative_hive_2.GenerateAdapters(
          specs,
          firstTypeId: firstTypeId,
          reservedTypeIds: reservedTypeIds,
        );
      },
    },
    getters: {
      'specs': (visitor, target) => D4
          .validateTarget<$dartnative_hive_2.GenerateAdapters>(
            target,
            'GenerateAdapters',
          )
          .specs,
      'firstTypeId': (visitor, target) => D4
          .validateTarget<$dartnative_hive_2.GenerateAdapters>(
            target,
            'GenerateAdapters',
          )
          .firstTypeId,
      'reservedTypeIds': (visitor, target) => D4
          .validateTarget<$dartnative_hive_2.GenerateAdapters>(
            target,
            'GenerateAdapters',
          )
          .reservedTypeIds,
    },
    constructorSignatures: {
      '': 'const GenerateAdapters(List<AdapterSpec> specs, {int firstTypeId = 0, Set<int> reservedTypeIds = const {}})',
    },
    getterSignatures: {
      'specs': 'List<AdapterSpec> get specs',
      'firstTypeId': 'int get firstTypeId',
      'reservedTypeIds': 'Set<int> get reservedTypeIds',
    },
  );
}

// =============================================================================
// AdapterSpec Bridge
// =============================================================================

BridgedClass _createAdapterSpecBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_2.AdapterSpec,
    name: 'AdapterSpec',
    isAssignable: (v) => v is $dartnative_hive_2.AdapterSpec,
    constructors: {
      '': (visitor, positional, named) {
        final ignoredFields =
            named.containsKey('ignoredFields') && named['ignoredFields'] != null
            ? D4.coerceSet<String>(named['ignoredFields'], 'ignoredFields')
            : const <String>{};
        return $dartnative_hive_2.AdapterSpec(ignoredFields: ignoredFields);
      },
    },
    getters: {
      'ignoredFields': (visitor, target) => D4
          .validateTarget<$dartnative_hive_2.AdapterSpec>(target, 'AdapterSpec')
          .ignoredFields,
    },
    constructorSignatures: {
      '': 'const AdapterSpec({Set<String> ignoredFields = const {}})',
    },
    getterSignatures: {
      'ignoredFields': 'Set<String> get ignoredFields',
    },
  );
}

// =============================================================================
// HiveField Bridge
// =============================================================================

BridgedClass _createHiveFieldBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_3.HiveField,
    name: 'HiveField',
    isAssignable: (v) => v is $dartnative_hive_3.HiveField,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'HiveField');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'HiveField',
        );
        if (!named.containsKey('defaultValue')) {
          return $dartnative_hive_3.HiveField(index);
        }
        if (named.containsKey('defaultValue')) {
          final defaultValue = D4.getRequiredNamedArg<dynamic>(
            named,
            'defaultValue',
            'HiveField',
          );
          return $dartnative_hive_3.HiveField(
            index,
            defaultValue: defaultValue,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
    },
    getters: {
      'index': (visitor, target) => D4
          .validateTarget<$dartnative_hive_3.HiveField>(target, 'HiveField')
          .index,
      'defaultValue': (visitor, target) => D4
          .validateTarget<$dartnative_hive_3.HiveField>(target, 'HiveField')
          .defaultValue,
    },
    constructorSignatures: {
      '': 'const HiveField(int index, {dynamic defaultValue})',
    },
    getterSignatures: {
      'index': 'int get index',
      'defaultValue': 'dynamic get defaultValue',
    },
  );
}

// =============================================================================
// HiveType Bridge
// =============================================================================

BridgedClass _createHiveTypeBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_4.HiveType,
    name: 'HiveType',
    isAssignable: (v) => v is $dartnative_hive_4.HiveType,
    constructors: {
      '': (visitor, positional, named) {
        final typeId = D4.getRequiredNamedArg<int>(named, 'typeId', 'HiveType');
        final adapterName = D4.getOptionalNamedArg<String?>(
          named,
          'adapterName',
        );
        return $dartnative_hive_4.HiveType(
          typeId: typeId,
          adapterName: adapterName,
        );
      },
    },
    getters: {
      'typeId': (visitor, target) => D4
          .validateTarget<$dartnative_hive_4.HiveType>(target, 'HiveType')
          .typeId,
      'adapterName': (visitor, target) => D4
          .validateTarget<$dartnative_hive_4.HiveType>(target, 'HiveType')
          .adapterName,
    },
    constructorSignatures: {
      '': 'const HiveType({required int typeId, String? adapterName})',
    },
    getterSignatures: {
      'typeId': 'int get typeId',
      'adapterName': 'String? get adapterName',
    },
  );
}

// =============================================================================
// BinaryReader Bridge
// =============================================================================

BridgedClass _createBinaryReaderBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_5.BinaryReader,
    name: 'BinaryReader',
    isAssignable: (v) => v is $dartnative_hive_5.BinaryReader,
    isAbstract: true,
    constructors: {},
    getters: {
      'availableBytes': (visitor, target) => D4
          .validateTarget<$dartnative_hive_5.BinaryReader>(
            target,
            'BinaryReader',
          )
          .availableBytes,
      'usedBytes': (visitor, target) => D4
          .validateTarget<$dartnative_hive_5.BinaryReader>(
            target,
            'BinaryReader',
          )
          .usedBytes,
    },
    methods: {
      'skip': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        D4.requireMinArgs(positional, 1, 'skip');
        final bytes = D4.getRequiredArg<int>(positional, 0, 'bytes', 'skip');
        t.skip(bytes);
        return null;
      },
      'readByte': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        return t.readByte();
      },
      'viewBytes': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        D4.requireMinArgs(positional, 1, 'viewBytes');
        final bytes = D4.getRequiredArg<int>(
          positional,
          0,
          'bytes',
          'viewBytes',
        );
        return t.viewBytes(bytes);
      },
      'peekBytes': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        D4.requireMinArgs(positional, 1, 'peekBytes');
        final bytes = D4.getRequiredArg<int>(
          positional,
          0,
          'bytes',
          'peekBytes',
        );
        return t.peekBytes(bytes);
      },
      'readWord': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        return t.readWord();
      },
      'readInt32': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        return t.readInt32();
      },
      'readUint32': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        return t.readUint32();
      },
      'readInt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        return t.readInt();
      },
      'readDouble': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        return t.readDouble();
      },
      'readBool': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        return t.readBool();
      },
      'readString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final byteCount = D4.getOptionalArg<int?>(positional, 0, 'byteCount');
        // TODO: Non-wrappable default: utf8Decoder
        final decoder = D4
            .getRequiredArgTodoDefault<Converter<List<int>, String>>(
              positional,
              1,
              'decoder',
              'readString',
              'utf8Decoder',
            );
        return t.readString(byteCount, decoder);
      },
      'readByteList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final length = D4.getOptionalArg<int?>(positional, 0, 'length');
        return t.readByteList(length);
      },
      'readIntList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final length = D4.getOptionalArg<int?>(positional, 0, 'length');
        return t.readIntList(length);
      },
      'readDoubleList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final length = D4.getOptionalArg<int?>(positional, 0, 'length');
        return t.readDoubleList(length);
      },
      'readBoolList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final length = D4.getOptionalArg<int?>(positional, 0, 'length');
        return t.readBoolList(length);
      },
      'readStringList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final length = D4.getOptionalArg<int?>(positional, 0, 'length');
        // TODO: Non-wrappable default: utf8Decoder
        final decoder = D4
            .getRequiredArgTodoDefault<Converter<List<int>, String>>(
              positional,
              1,
              'decoder',
              'readStringList',
              'utf8Decoder',
            );
        return t.readStringList(length, decoder);
      },
      'readList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final length = D4.getOptionalArg<int?>(positional, 0, 'length');
        return t.readList(length);
      },
      'readMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final length = D4.getOptionalArg<int?>(positional, 0, 'length');
        return t.readMap(length);
      },
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final typeId = D4.getOptionalArg<int?>(positional, 0, 'typeId');
        return t.read(typeId);
      },
      'readHiveList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_5.BinaryReader>(
          target,
          'BinaryReader',
        );
        final length = D4.getOptionalArg<int?>(positional, 0, 'length');
        return t.readHiveList(length);
      },
    },
    staticGetters: {
      'utf8Decoder': (visitor) => $dartnative_hive_5.BinaryReader.utf8Decoder,
    },
    methodSignatures: {
      'skip': 'void skip(int bytes)',
      'readByte': 'int readByte()',
      'viewBytes': 'Uint8List viewBytes(int bytes)',
      'peekBytes': 'Uint8List peekBytes(int bytes)',
      'readWord': 'int readWord()',
      'readInt32': 'int readInt32()',
      'readUint32': 'int readUint32()',
      'readInt': 'int readInt()',
      'readDouble': 'double readDouble()',
      'readBool': 'bool readBool()',
      'readString':
          'String readString([int? byteCount, Converter<List<int>, String> decoder = utf8Decoder])',
      'readByteList': 'Uint8List readByteList([int? length])',
      'readIntList': 'List<int> readIntList([int? length])',
      'readDoubleList': 'List<double> readDoubleList([int? length])',
      'readBoolList': 'List<bool> readBoolList([int? length])',
      'readStringList':
          'List<String> readStringList([int? length, Converter<List<int>, String> decoder = utf8Decoder])',
      'readList': 'List readList([int? length])',
      'readMap': 'Map readMap([int? length])',
      'read': 'dynamic read([int? typeId])',
      'readHiveList': 'HiveList<HiveObjectMixin> readHiveList([int? length])',
    },
    getterSignatures: {
      'availableBytes': 'int get availableBytes',
      'usedBytes': 'int get usedBytes',
    },
    staticGetterSignatures: {
      'utf8Decoder': 'Utf8Decoder get utf8Decoder',
    },
  );
}

// =============================================================================
// BinaryWriter Bridge
// =============================================================================

BridgedClass _createBinaryWriterBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_6.BinaryWriter,
    name: 'BinaryWriter',
    isAssignable: (v) => v is $dartnative_hive_6.BinaryWriter,
    isAbstract: true,
    constructors: {},
    methods: {
      'writeByte': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeByte');
        final byte = D4.getRequiredArg<int>(positional, 0, 'byte', 'writeByte');
        t.writeByte(byte);
        return null;
      },
      'writeWord': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeWord');
        final value = D4.getRequiredArg<int>(
          positional,
          0,
          'value',
          'writeWord',
        );
        t.writeWord(value);
        return null;
      },
      'writeInt32': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeInt32');
        final value = D4.getRequiredArg<int>(
          positional,
          0,
          'value',
          'writeInt32',
        );
        t.writeInt32(value);
        return null;
      },
      'writeUint32': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeUint32');
        final value = D4.getRequiredArg<int>(
          positional,
          0,
          'value',
          'writeUint32',
        );
        t.writeUint32(value);
        return null;
      },
      'writeInt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeInt');
        final value = D4.getRequiredArg<int>(
          positional,
          0,
          'value',
          'writeInt',
        );
        t.writeInt(value);
        return null;
      },
      'writeDouble': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeDouble');
        final value = D4.getRequiredArg<double>(
          positional,
          0,
          'value',
          'writeDouble',
        );
        t.writeDouble(value);
        return null;
      },
      'writeBool': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeBool');
        final value = D4.getRequiredArg<bool>(
          positional,
          0,
          'value',
          'writeBool',
        );
        t.writeBool(value);
        return null;
      },
      'writeString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeString');
        final value = D4.getRequiredArg<String>(
          positional,
          0,
          'value',
          'writeString',
        );
        final writeByteCount = D4.getNamedArgWithDefault<bool>(
          named,
          'writeByteCount',
          true,
        );
        if (!named.containsKey('encoder')) {
          t.writeString(value, writeByteCount: writeByteCount);
          return null;
        }
        if (named.containsKey('encoder')) {
          final encoder = D4.getRequiredNamedArg<Converter<String, List<int>>>(
            named,
            'encoder',
            'writeString',
          );
          t.writeString(
            value,
            writeByteCount: writeByteCount,
            encoder: encoder,
          );
          return null;
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'writeByteList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeByteList');
        if (positional.isEmpty) {
          throw ArgumentError(
            'writeByteList: Missing required argument "bytes" at position 0',
          );
        }
        final bytes = D4.coerceList<int>(positional[0], 'bytes');
        final writeLength = D4.getNamedArgWithDefault<bool>(
          named,
          'writeLength',
          true,
        );
        t.writeByteList(bytes, writeLength: writeLength);
        return null;
      },
      'writeIntList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeIntList');
        if (positional.isEmpty) {
          throw ArgumentError(
            'writeIntList: Missing required argument "list" at position 0',
          );
        }
        final list = D4.coerceList<int>(positional[0], 'list');
        final writeLength = D4.getNamedArgWithDefault<bool>(
          named,
          'writeLength',
          true,
        );
        t.writeIntList(list, writeLength: writeLength);
        return null;
      },
      'writeDoubleList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeDoubleList');
        if (positional.isEmpty) {
          throw ArgumentError(
            'writeDoubleList: Missing required argument "list" at position 0',
          );
        }
        final list = D4.coerceList<double>(positional[0], 'list');
        final writeLength = D4.getNamedArgWithDefault<bool>(
          named,
          'writeLength',
          true,
        );
        t.writeDoubleList(list, writeLength: writeLength);
        return null;
      },
      'writeBoolList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeBoolList');
        if (positional.isEmpty) {
          throw ArgumentError(
            'writeBoolList: Missing required argument "list" at position 0',
          );
        }
        final list = D4.coerceList<bool>(positional[0], 'list');
        final writeLength = D4.getNamedArgWithDefault<bool>(
          named,
          'writeLength',
          true,
        );
        t.writeBoolList(list, writeLength: writeLength);
        return null;
      },
      'writeStringList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeStringList');
        if (positional.isEmpty) {
          throw ArgumentError(
            'writeStringList: Missing required argument "list" at position 0',
          );
        }
        final list = D4.coerceList<String>(positional[0], 'list');
        final writeLength = D4.getNamedArgWithDefault<bool>(
          named,
          'writeLength',
          true,
        );
        if (!named.containsKey('encoder')) {
          t.writeStringList(list, writeLength: writeLength);
          return null;
        }
        if (named.containsKey('encoder')) {
          final encoder = D4.getRequiredNamedArg<Converter<String, List<int>>>(
            named,
            'encoder',
            'writeStringList',
          );
          t.writeStringList(list, writeLength: writeLength, encoder: encoder);
          return null;
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'writeList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeList');
        final list = D4.getRequiredArg<List>(
          positional,
          0,
          'list',
          'writeList',
        );
        final writeLength = D4.getNamedArgWithDefault<bool>(
          named,
          'writeLength',
          true,
        );
        t.writeList(list, writeLength: writeLength);
        return null;
      },
      'writeMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeMap');
        final map = D4.getRequiredArg<Map>(positional, 0, 'map', 'writeMap');
        final writeLength = D4.getNamedArgWithDefault<bool>(
          named,
          'writeLength',
          true,
        );
        t.writeMap(map, writeLength: writeLength);
        return null;
      },
      'writeHiveList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'writeHiveList');
        final list = D4
            .getRequiredArg<
              $dartnative_hive_19.HiveList<$dartnative_hive_20.HiveObjectMixin>
            >(positional, 0, 'list', 'writeHiveList');
        final writeLength = D4.getNamedArgWithDefault<bool>(
          named,
          'writeLength',
          true,
        );
        t.writeHiveList(list, writeLength: writeLength);
        return null;
      },
      'write': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_6.BinaryWriter>(
          target,
          'BinaryWriter',
        );
        D4.requireMinArgs(positional, 1, 'write');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'value',
          'write',
        );
        final withTypeId = D4.getNamedArgWithDefault<bool>(
          named,
          'withTypeId',
          true,
        );
        t.write(value, withTypeId: withTypeId);
        return null;
      },
    },
    staticGetters: {
      'utf8Encoder': (visitor) => $dartnative_hive_6.BinaryWriter.utf8Encoder,
    },
    methodSignatures: {
      'writeByte': 'void writeByte(int byte)',
      'writeWord': 'void writeWord(int value)',
      'writeInt32': 'void writeInt32(int value)',
      'writeUint32': 'void writeUint32(int value)',
      'writeInt': 'void writeInt(int value)',
      'writeDouble': 'void writeDouble(double value)',
      'writeBool': 'void writeBool(bool value)',
      'writeString':
          'void writeString(String value, {bool writeByteCount = true, Converter<String, List<int>> encoder = utf8Encoder})',
      'writeByteList':
          'void writeByteList(List<int> bytes, {bool writeLength = true})',
      'writeIntList':
          'void writeIntList(List<int> list, {bool writeLength = true})',
      'writeDoubleList':
          'void writeDoubleList(List<double> list, {bool writeLength = true})',
      'writeBoolList':
          'void writeBoolList(List<bool> list, {bool writeLength = true})',
      'writeStringList':
          'void writeStringList(List<String> list, {bool writeLength = true, Converter<String, List<int>> encoder = utf8Encoder})',
      'writeList': 'void writeList(List list, {bool writeLength = true})',
      'writeMap': 'void writeMap(Map map, {bool writeLength = true})',
      'writeHiveList':
          'void writeHiveList(HiveList<HiveObjectMixin> list, {bool writeLength = true})',
      'write': 'void write(T value, {bool withTypeId = true})',
    },
    staticGetterSignatures: {
      'utf8Encoder': 'Utf8Encoder get utf8Encoder',
    },
  );
}

// =============================================================================
// Box Bridge
// =============================================================================

BridgedClass _createBoxBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_7.Box,
    name: 'Box',
    isAssignable: (v) => v is $dartnative_hive_7.Box,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    getters: {
      'values': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box').values,
      'name': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box').name,
      'isOpen': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box').isOpen,
      'path': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box').path,
      'lazy': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box').lazy,
      'keys': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box').keys,
      'length': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box').length,
      'isEmpty': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box').isEmpty,
      'isNotEmpty': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box').isNotEmpty,
    },
    methods: {
      'valuesBetween': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        if (!named.containsKey('startKey') && !named.containsKey('endKey')) {
          return t.valuesBetween();
        }
        if (named.containsKey('startKey') && !named.containsKey('endKey')) {
          final startKey = D4.getRequiredNamedArg<dynamic>(
            named,
            'startKey',
            'valuesBetween',
          );
          return t.valuesBetween(startKey: startKey);
        }
        if (!named.containsKey('startKey') && named.containsKey('endKey')) {
          final endKey = D4.getRequiredNamedArg<dynamic>(
            named,
            'endKey',
            'valuesBetween',
          );
          return t.valuesBetween(endKey: endKey);
        }
        if (named.containsKey('startKey') && named.containsKey('endKey')) {
          final startKey = D4.getRequiredNamedArg<dynamic>(
            named,
            'startKey',
            'valuesBetween',
          );
          final endKey = D4.getRequiredNamedArg<dynamic>(
            named,
            'endKey',
            'valuesBetween',
          );
          return t.valuesBetween(startKey: startKey, endKey: endKey);
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'get': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'get');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'get');
        final defaultValue = D4.getOptionalNamedArg<dynamic>(
          named,
          'defaultValue',
        );
        return t.get(key, defaultValue: defaultValue);
      },
      'getAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'getAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'getAt');
        return t.getAt(index);
      },
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        return t.toMap();
      },
      'keyAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'keyAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'keyAt');
        return t.keyAt(index);
      },
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        if (!named.containsKey('key')) {
          return t.watch();
        }
        if (named.containsKey('key')) {
          final key = D4.getRequiredNamedArg<dynamic>(named, 'key', 'watch');
          return t.watch(key: key);
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'containsKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'containsKey');
        final key = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'key',
          'containsKey',
        );
        return t.containsKey(key);
      },
      'put': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 2, 'put');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'put');
        final value = D4.getRequiredArg<dynamic>(positional, 1, 'value', 'put');
        return t.put(key, value);
      },
      'putAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 2, 'putAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'putAt');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          1,
          'value',
          'putAt',
        );
        return t.putAt(index, value);
      },
      'putAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'putAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'putAll: Missing required argument "entries" at position 0',
          );
        }
        final entries = D4.coerceMap<dynamic, dynamic>(
          positional[0],
          'entries',
        );
        return t.putAll(entries);
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'add');
        final value = D4.getRequiredArg<dynamic>(positional, 0, 'value', 'add');
        return t.add(value);
      },
      'addAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'addAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addAll: Missing required argument "values" at position 0',
          );
        }
        final values = D4.coerceList<dynamic>(positional[0], 'values');
        return t.addAll(values);
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'delete');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'delete');
        return t.delete(key);
      },
      'deleteAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'deleteAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'deleteAt',
        );
        return t.deleteAt(index);
      },
      'deleteAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        D4.requireMinArgs(positional, 1, 'deleteAll');
        final keys = D4.getRequiredArg<Iterable>(
          positional,
          0,
          'keys',
          'deleteAll',
        );
        return t.deleteAll(keys);
      },
      'compact': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        return t.compact();
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        return t.clear();
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        return t.close();
      },
      'deleteFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        return t.deleteFromDisk();
      },
      'flush': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_7.Box>(target, 'Box');
        return t.flush();
      },
    },
    methodSignatures: {
      'valuesBetween':
          'Iterable<E> valuesBetween({dynamic startKey, dynamic endKey})',
      'get': 'E? get(dynamic key, {E? defaultValue})',
      'getAt': 'E? getAt(int index)',
      'toMap': 'Map<dynamic, E> toMap()',
      'keyAt': 'dynamic keyAt(int index)',
      'watch': 'Stream<BoxEvent> watch({dynamic key})',
      'containsKey': 'bool containsKey(dynamic key)',
      'put': 'Future<void> put(dynamic key, E value)',
      'putAt': 'Future<void> putAt(int index, E value)',
      'putAll': 'Future<void> putAll(Map<dynamic, E> entries)',
      'add': 'Future<int> add(E value)',
      'addAll': 'Future<Iterable<int>> addAll(Iterable<E> values)',
      'delete': 'Future<void> delete(dynamic key)',
      'deleteAt': 'Future<void> deleteAt(int index)',
      'deleteAll': 'Future<void> deleteAll(Iterable keys)',
      'compact': 'Future<void> compact()',
      'clear': 'Future<int> clear()',
      'close': 'Future<void> close()',
      'deleteFromDisk': 'Future<void> deleteFromDisk()',
      'flush': 'Future<void> flush()',
    },
    getterSignatures: {
      'values': 'Iterable<E> get values',
      'name': 'String get name',
      'isOpen': 'bool get isOpen',
      'path': 'String? get path',
      'lazy': 'bool get lazy',
      'keys': 'Iterable<dynamic> get keys',
      'length': 'int get length',
      'isEmpty': 'bool get isEmpty',
      'isNotEmpty': 'bool get isNotEmpty',
    },
  );
}

// =============================================================================
// BoxEvent Bridge
// =============================================================================

BridgedClass _createBoxEventBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_8.BoxEvent,
    name: 'BoxEvent',
    isAssignable: (v) => v is $dartnative_hive_8.BoxEvent,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 3, 'BoxEvent');
        final key = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'key',
          'BoxEvent',
        );
        final value = D4.getRequiredArg<dynamic>(
          positional,
          1,
          'value',
          'BoxEvent',
        );
        final deleted = D4.getRequiredArg<bool>(
          positional,
          2,
          'deleted',
          'BoxEvent',
        );
        return $dartnative_hive_8.BoxEvent(key, value, deleted);
      },
    },
    getters: {
      'key': (visitor, target) => D4
          .validateTarget<$dartnative_hive_8.BoxEvent>(target, 'BoxEvent')
          .key,
      'value': (visitor, target) => D4
          .validateTarget<$dartnative_hive_8.BoxEvent>(target, 'BoxEvent')
          .value,
      'deleted': (visitor, target) => D4
          .validateTarget<$dartnative_hive_8.BoxEvent>(target, 'BoxEvent')
          .deleted,
      'hashCode': (visitor, target) => D4
          .validateTarget<$dartnative_hive_8.BoxEvent>(target, 'BoxEvent')
          .hashCode,
    },
    methods: {
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxEvent>(
          target,
          'BoxEvent',
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
      '': 'const BoxEvent(dynamic key, dynamic value, bool deleted)',
    },
    getterSignatures: {
      'key': 'dynamic get key',
      'value': 'dynamic get value',
      'deleted': 'bool get deleted',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// BoxBase Bridge
// =============================================================================

BridgedClass _createBoxBaseBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_8.BoxBase,
    name: 'BoxBase',
    isAssignable: (v) => v is $dartnative_hive_8.BoxBase,
    isAbstract: true,
    constructors: {},
    getters: {
      'name': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_8.BoxBase>(target, 'BoxBase').name,
      'isOpen': (visitor, target) => D4
          .validateTarget<$dartnative_hive_8.BoxBase>(target, 'BoxBase')
          .isOpen,
      'path': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_8.BoxBase>(target, 'BoxBase').path,
      'lazy': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_8.BoxBase>(target, 'BoxBase').lazy,
      'keys': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_8.BoxBase>(target, 'BoxBase').keys,
      'length': (visitor, target) => D4
          .validateTarget<$dartnative_hive_8.BoxBase>(target, 'BoxBase')
          .length,
      'isEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_8.BoxBase>(target, 'BoxBase')
          .isEmpty,
      'isNotEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_8.BoxBase>(target, 'BoxBase')
          .isNotEmpty,
    },
    methods: {
      'keyAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 1, 'keyAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'keyAt');
        return t.keyAt(index);
      },
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        if (!named.containsKey('key')) {
          return t.watch();
        }
        if (named.containsKey('key')) {
          final key = D4.getRequiredNamedArg<dynamic>(named, 'key', 'watch');
          return t.watch(key: key);
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'containsKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 1, 'containsKey');
        final key = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'key',
          'containsKey',
        );
        return t.containsKey(key);
      },
      'put': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 2, 'put');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'put');
        final value = D4.getRequiredArg<dynamic>(positional, 1, 'value', 'put');
        return t.put(key, value);
      },
      'putAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 2, 'putAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'putAt');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          1,
          'value',
          'putAt',
        );
        return t.putAt(index, value);
      },
      'putAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 1, 'putAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'putAll: Missing required argument "entries" at position 0',
          );
        }
        final entries = D4.coerceMap<dynamic, dynamic>(
          positional[0],
          'entries',
        );
        return t.putAll(entries);
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 1, 'add');
        final value = D4.getRequiredArg<dynamic>(positional, 0, 'value', 'add');
        return t.add(value);
      },
      'addAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 1, 'addAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addAll: Missing required argument "values" at position 0',
          );
        }
        final values = D4.coerceList<dynamic>(positional[0], 'values');
        return t.addAll(values);
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 1, 'delete');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'delete');
        return t.delete(key);
      },
      'deleteAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 1, 'deleteAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'deleteAt',
        );
        return t.deleteAt(index);
      },
      'deleteAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        D4.requireMinArgs(positional, 1, 'deleteAll');
        final keys = D4.getRequiredArg<Iterable>(
          positional,
          0,
          'keys',
          'deleteAll',
        );
        return t.deleteAll(keys);
      },
      'compact': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        return t.compact();
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        return t.clear();
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        return t.close();
      },
      'deleteFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        return t.deleteFromDisk();
      },
      'flush': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_8.BoxBase>(
          target,
          'BoxBase',
        );
        return t.flush();
      },
    },
    methodSignatures: {
      'keyAt': 'dynamic keyAt(int index)',
      'watch': 'Stream<BoxEvent> watch({dynamic key})',
      'containsKey': 'bool containsKey(dynamic key)',
      'put': 'Future<void> put(dynamic key, E value)',
      'putAt': 'Future<void> putAt(int index, E value)',
      'putAll': 'Future<void> putAll(Map<dynamic, E> entries)',
      'add': 'Future<int> add(E value)',
      'addAll': 'Future<Iterable<int>> addAll(Iterable<E> values)',
      'delete': 'Future<void> delete(dynamic key)',
      'deleteAt': 'Future<void> deleteAt(int index)',
      'deleteAll': 'Future<void> deleteAll(Iterable keys)',
      'compact': 'Future<void> compact()',
      'clear': 'Future<int> clear()',
      'close': 'Future<void> close()',
      'deleteFromDisk': 'Future<void> deleteFromDisk()',
      'flush': 'Future<void> flush()',
    },
    getterSignatures: {
      'name': 'String get name',
      'isOpen': 'bool get isOpen',
      'path': 'String? get path',
      'lazy': 'bool get lazy',
      'keys': 'Iterable get keys',
      'length': 'int get length',
      'isEmpty': 'bool get isEmpty',
      'isNotEmpty': 'bool get isNotEmpty',
    },
  );
}

// =============================================================================
// LazyBox Bridge
// =============================================================================

BridgedClass _createLazyBoxBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_9.LazyBox,
    name: 'LazyBox',
    isAssignable: (v) => v is $dartnative_hive_9.LazyBox,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    getters: {
      'name': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_9.LazyBox>(target, 'LazyBox').name,
      'isOpen': (visitor, target) => D4
          .validateTarget<$dartnative_hive_9.LazyBox>(target, 'LazyBox')
          .isOpen,
      'path': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_9.LazyBox>(target, 'LazyBox').path,
      'lazy': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_9.LazyBox>(target, 'LazyBox').lazy,
      'keys': (visitor, target) =>
          D4.validateTarget<$dartnative_hive_9.LazyBox>(target, 'LazyBox').keys,
      'length': (visitor, target) => D4
          .validateTarget<$dartnative_hive_9.LazyBox>(target, 'LazyBox')
          .length,
      'isEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_9.LazyBox>(target, 'LazyBox')
          .isEmpty,
      'isNotEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_9.LazyBox>(target, 'LazyBox')
          .isNotEmpty,
    },
    methods: {
      'keyAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'keyAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'keyAt');
        return t.keyAt(index);
      },
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        if (!named.containsKey('key')) {
          return t.watch();
        }
        if (named.containsKey('key')) {
          final key = D4.getRequiredNamedArg<dynamic>(named, 'key', 'watch');
          return t.watch(key: key);
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'containsKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'containsKey');
        final key = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'key',
          'containsKey',
        );
        return t.containsKey(key);
      },
      'put': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 2, 'put');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'put');
        final value = D4.getRequiredArg<dynamic>(positional, 1, 'value', 'put');
        return t.put(key, value);
      },
      'putAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 2, 'putAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'putAt');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          1,
          'value',
          'putAt',
        );
        return t.putAt(index, value);
      },
      'putAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'putAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'putAll: Missing required argument "entries" at position 0',
          );
        }
        final entries = D4.coerceMap<dynamic, dynamic>(
          positional[0],
          'entries',
        );
        return t.putAll(entries);
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'add');
        final value = D4.getRequiredArg<dynamic>(positional, 0, 'value', 'add');
        return t.add(value);
      },
      'addAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'addAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addAll: Missing required argument "values" at position 0',
          );
        }
        final values = D4.coerceList<dynamic>(positional[0], 'values');
        return t.addAll(values);
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'delete');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'delete');
        return t.delete(key);
      },
      'deleteAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'deleteAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'deleteAt',
        );
        return t.deleteAt(index);
      },
      'deleteAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'deleteAll');
        final keys = D4.getRequiredArg<Iterable>(
          positional,
          0,
          'keys',
          'deleteAll',
        );
        return t.deleteAll(keys);
      },
      'compact': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        return t.compact();
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        return t.clear();
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        return t.close();
      },
      'deleteFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        return t.deleteFromDisk();
      },
      'flush': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        return t.flush();
      },
      'get': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'get');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'get');
        final defaultValue = D4.getOptionalNamedArg<dynamic>(
          named,
          'defaultValue',
        );
        return t.get(key, defaultValue: defaultValue);
      },
      'getAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_9.LazyBox>(
          target,
          'LazyBox',
        );
        D4.requireMinArgs(positional, 1, 'getAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'getAt');
        return t.getAt(index);
      },
    },
    methodSignatures: {
      'keyAt': 'dynamic keyAt(int index)',
      'watch': 'Stream<BoxEvent> watch({dynamic key})',
      'containsKey': 'bool containsKey(dynamic key)',
      'put': 'Future<void> put(dynamic key, E value)',
      'putAt': 'Future<void> putAt(int index, E value)',
      'putAll': 'Future<void> putAll(Map<dynamic, E> entries)',
      'add': 'Future<int> add(E value)',
      'addAll': 'Future<Iterable<int>> addAll(Iterable<E> values)',
      'delete': 'Future<void> delete(dynamic key)',
      'deleteAt': 'Future<void> deleteAt(int index)',
      'deleteAll': 'Future<void> deleteAll(Iterable keys)',
      'compact': 'Future<void> compact()',
      'clear': 'Future<int> clear()',
      'close': 'Future<void> close()',
      'deleteFromDisk': 'Future<void> deleteFromDisk()',
      'flush': 'Future<void> flush()',
      'get': 'Future<E?> get(dynamic key, {E? defaultValue})',
      'getAt': 'Future<E?> getAt(int index)',
    },
    getterSignatures: {
      'name': 'String get name',
      'isOpen': 'bool get isOpen',
      'path': 'String? get path',
      'lazy': 'bool get lazy',
      'keys': 'Iterable<dynamic> get keys',
      'length': 'int get length',
      'isEmpty': 'bool get isEmpty',
      'isNotEmpty': 'bool get isNotEmpty',
    },
  );
}

// =============================================================================
// HiveAesCipher Bridge
// =============================================================================

BridgedClass _createHiveAesCipherBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_10.HiveAesCipher,
    name: 'HiveAesCipher',
    isAssignable: (v) => v is $dartnative_hive_10.HiveAesCipher,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'HiveAesCipher');
        if (positional.isEmpty) {
          throw ArgumentError(
            'HiveAesCipher: Missing required argument "key" at position 0',
          );
        }
        final key = D4.coerceList<int>(positional[0], 'key');
        return $dartnative_hive_10.HiveAesCipher(key);
      },
    },
    methods: {
      'calculateKeyCrc': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_10.HiveAesCipher>(
          target,
          'HiveAesCipher',
        );
        return t.calculateKeyCrc();
      },
      'decrypt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_10.HiveAesCipher>(
          target,
          'HiveAesCipher',
        );
        D4.requireMinArgs(positional, 5, 'decrypt');
        final inp = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'inp',
          'decrypt',
        );
        final inpOff = D4.getRequiredArg<int>(
          positional,
          1,
          'inpOff',
          'decrypt',
        );
        final inpLength = D4.getRequiredArg<int>(
          positional,
          2,
          'inpLength',
          'decrypt',
        );
        final out = D4.getRequiredArg<Uint8List>(
          positional,
          3,
          'out',
          'decrypt',
        );
        final outOff = D4.getRequiredArg<int>(
          positional,
          4,
          'outOff',
          'decrypt',
        );
        return t.decrypt(inp, inpOff, inpLength, out, outOff);
      },
      'generateIv': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_10.HiveAesCipher>(
          target,
          'HiveAesCipher',
        );
        return t.generateIv();
      },
      'encrypt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_10.HiveAesCipher>(
          target,
          'HiveAesCipher',
        );
        D4.requireMinArgs(positional, 5, 'encrypt');
        final inp = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'inp',
          'encrypt',
        );
        final inpOff = D4.getRequiredArg<int>(
          positional,
          1,
          'inpOff',
          'encrypt',
        );
        final inpLength = D4.getRequiredArg<int>(
          positional,
          2,
          'inpLength',
          'encrypt',
        );
        final out = D4.getRequiredArg<Uint8List>(
          positional,
          3,
          'out',
          'encrypt',
        );
        final outOff = D4.getRequiredArg<int>(
          positional,
          4,
          'outOff',
          'encrypt',
        );
        return t.encrypt(inp, inpOff, inpLength, out, outOff);
      },
      'maxEncryptedSize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_10.HiveAesCipher>(
          target,
          'HiveAesCipher',
        );
        D4.requireMinArgs(positional, 1, 'maxEncryptedSize');
        final inp = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'inp',
          'maxEncryptedSize',
        );
        return t.maxEncryptedSize(inp);
      },
    },
    constructorSignatures: {
      '': 'HiveAesCipher(List<int> key)',
    },
    methodSignatures: {
      'calculateKeyCrc': 'int calculateKeyCrc()',
      'decrypt':
          'int decrypt(Uint8List inp, int inpOff, int inpLength, Uint8List out, int outOff)',
      'generateIv': 'Uint8List generateIv()',
      'encrypt':
          'int encrypt(Uint8List inp, int inpOff, int inpLength, Uint8List out, int outOff)',
      'maxEncryptedSize': 'int maxEncryptedSize(Uint8List inp)',
    },
  );
}

// =============================================================================
// HiveCipher Bridge
// =============================================================================

BridgedClass _createHiveCipherBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_11.HiveCipher,
    name: 'HiveCipher',
    isAssignable: (v) => v is $dartnative_hive_11.HiveCipher,
    isAbstract: true,
    constructors: {},
    methods: {
      'calculateKeyCrc': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_11.HiveCipher>(
          target,
          'HiveCipher',
        );
        return t.calculateKeyCrc();
      },
      'maxEncryptedSize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_11.HiveCipher>(
          target,
          'HiveCipher',
        );
        D4.requireMinArgs(positional, 1, 'maxEncryptedSize');
        final inp = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'inp',
          'maxEncryptedSize',
        );
        return t.maxEncryptedSize(inp);
      },
      'encrypt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_11.HiveCipher>(
          target,
          'HiveCipher',
        );
        D4.requireMinArgs(positional, 5, 'encrypt');
        final inp = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'inp',
          'encrypt',
        );
        final inpOff = D4.getRequiredArg<int>(
          positional,
          1,
          'inpOff',
          'encrypt',
        );
        final inpLength = D4.getRequiredArg<int>(
          positional,
          2,
          'inpLength',
          'encrypt',
        );
        final out = D4.getRequiredArg<Uint8List>(
          positional,
          3,
          'out',
          'encrypt',
        );
        final outOff = D4.getRequiredArg<int>(
          positional,
          4,
          'outOff',
          'encrypt',
        );
        return t.encrypt(inp, inpOff, inpLength, out, outOff);
      },
      'decrypt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_11.HiveCipher>(
          target,
          'HiveCipher',
        );
        D4.requireMinArgs(positional, 5, 'decrypt');
        final inp = D4.getRequiredArg<Uint8List>(
          positional,
          0,
          'inp',
          'decrypt',
        );
        final inpOff = D4.getRequiredArg<int>(
          positional,
          1,
          'inpOff',
          'decrypt',
        );
        final inpLength = D4.getRequiredArg<int>(
          positional,
          2,
          'inpLength',
          'decrypt',
        );
        final out = D4.getRequiredArg<Uint8List>(
          positional,
          3,
          'out',
          'decrypt',
        );
        final outOff = D4.getRequiredArg<int>(
          positional,
          4,
          'outOff',
          'decrypt',
        );
        return t.decrypt(inp, inpOff, inpLength, out, outOff);
      },
    },
    methodSignatures: {
      'calculateKeyCrc': 'int calculateKeyCrc()',
      'maxEncryptedSize': 'int maxEncryptedSize(Uint8List inp)',
      'encrypt':
          'int encrypt(Uint8List inp, int inpOff, int inpLength, Uint8List out, int outOff)',
      'decrypt':
          'int decrypt(Uint8List inp, int inpOff, int inpLength, Uint8List out, int outOff)',
    },
  );
}

// =============================================================================
// HiveInterface Bridge
// =============================================================================

BridgedClass _createHiveInterfaceBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_12.HiveInterface,
    name: 'HiveInterface',
    isAssignable: (v) => v is $dartnative_hive_12.HiveInterface,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    methods: {
      'init': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'init');
        final path = D4.getRequiredArg<String?>(positional, 0, 'path', 'init');
        final backendPreference = D4
            .getNamedArgWithDefault<
              $dartnative_hive_21.HiveStorageBackendPreference
            >(
              named,
              'backendPreference',
              $dartnative_hive_21.HiveStorageBackendPreference.native,
            );
        t.init(path, backendPreference: backendPreference);
        return null;
      },
      'openBox': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'openBox');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'openBox',
        );
        final encryptionCipher = D4
            .getOptionalNamedArg<$dartnative_hive_11.HiveCipher?>(
              named,
              'encryptionCipher',
            );
        final crashRecovery = D4.getNamedArgWithDefault<bool>(
          named,
          'crashRecovery',
          true,
        );
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        final bytes = D4.getOptionalNamedArg<Uint8List?>(named, 'bytes');
        final collection = D4.getOptionalNamedArg<String?>(named, 'collection');
        final encryptionKey = D4.coerceListOrNull<int>(
          named['encryptionKey'],
          'encryptionKey',
        );
        if (!named.containsKey('keyComparator') &&
            !named.containsKey('compactionStrategy')) {
          return t.openBox(
            name,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery,
            path: path,
            bytes: bytes,
            collection: collection,
            encryptionKey: encryptionKey,
          );
        }
        if (named.containsKey('keyComparator') &&
            !named.containsKey('compactionStrategy')) {
          final keyComparatorRaw = named['keyComparator'];
          final keyComparator =
              ((dynamic p0, dynamic p1) {
                    return D4.callInterpreterCallback(
                          visitor!,
                          keyComparatorRaw,
                          [p0, p1],
                        )
                        as int;
                  })
                  as int Function(dynamic, dynamic);
          return t.openBox(
            name,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery,
            path: path,
            bytes: bytes,
            collection: collection,
            encryptionKey: encryptionKey,
            keyComparator: keyComparator,
          );
        }
        if (!named.containsKey('keyComparator') &&
            named.containsKey('compactionStrategy')) {
          final compactionStrategyRaw = named['compactionStrategy'];
          final compactionStrategy =
              ((int p0, int p1) {
                    return D4.callInterpreterCallback(
                          visitor!,
                          compactionStrategyRaw,
                          [p0, p1],
                        )
                        as bool;
                  })
                  as bool Function(int, int);
          return t.openBox(
            name,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery,
            path: path,
            bytes: bytes,
            collection: collection,
            encryptionKey: encryptionKey,
            compactionStrategy: compactionStrategy,
          );
        }
        if (named.containsKey('keyComparator') &&
            named.containsKey('compactionStrategy')) {
          final keyComparatorRaw = named['keyComparator'];
          final keyComparator =
              ((dynamic p0, dynamic p1) {
                    return D4.callInterpreterCallback(
                          visitor!,
                          keyComparatorRaw,
                          [p0, p1],
                        )
                        as int;
                  })
                  as int Function(dynamic, dynamic);
          final compactionStrategyRaw = named['compactionStrategy'];
          final compactionStrategy =
              ((int p0, int p1) {
                    return D4.callInterpreterCallback(
                          visitor!,
                          compactionStrategyRaw,
                          [p0, p1],
                        )
                        as bool;
                  })
                  as bool Function(int, int);
          return t.openBox(
            name,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery,
            path: path,
            bytes: bytes,
            collection: collection,
            encryptionKey: encryptionKey,
            keyComparator: keyComparator,
            compactionStrategy: compactionStrategy,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'openLazyBox': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'openLazyBox');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'openLazyBox',
        );
        final encryptionCipher = D4
            .getOptionalNamedArg<$dartnative_hive_11.HiveCipher?>(
              named,
              'encryptionCipher',
            );
        final crashRecovery = D4.getNamedArgWithDefault<bool>(
          named,
          'crashRecovery',
          true,
        );
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        final collection = D4.getOptionalNamedArg<String?>(named, 'collection');
        final encryptionKey = D4.coerceListOrNull<int>(
          named['encryptionKey'],
          'encryptionKey',
        );
        if (!named.containsKey('keyComparator') &&
            !named.containsKey('compactionStrategy')) {
          return t.openLazyBox(
            name,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery,
            path: path,
            collection: collection,
            encryptionKey: encryptionKey,
          );
        }
        if (named.containsKey('keyComparator') &&
            !named.containsKey('compactionStrategy')) {
          final keyComparatorRaw = named['keyComparator'];
          final keyComparator =
              ((dynamic p0, dynamic p1) {
                    return D4.callInterpreterCallback(
                          visitor!,
                          keyComparatorRaw,
                          [p0, p1],
                        )
                        as int;
                  })
                  as int Function(dynamic, dynamic);
          return t.openLazyBox(
            name,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery,
            path: path,
            collection: collection,
            encryptionKey: encryptionKey,
            keyComparator: keyComparator,
          );
        }
        if (!named.containsKey('keyComparator') &&
            named.containsKey('compactionStrategy')) {
          final compactionStrategyRaw = named['compactionStrategy'];
          final compactionStrategy =
              ((int p0, int p1) {
                    return D4.callInterpreterCallback(
                          visitor!,
                          compactionStrategyRaw,
                          [p0, p1],
                        )
                        as bool;
                  })
                  as bool Function(int, int);
          return t.openLazyBox(
            name,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery,
            path: path,
            collection: collection,
            encryptionKey: encryptionKey,
            compactionStrategy: compactionStrategy,
          );
        }
        if (named.containsKey('keyComparator') &&
            named.containsKey('compactionStrategy')) {
          final keyComparatorRaw = named['keyComparator'];
          final keyComparator =
              ((dynamic p0, dynamic p1) {
                    return D4.callInterpreterCallback(
                          visitor!,
                          keyComparatorRaw,
                          [p0, p1],
                        )
                        as int;
                  })
                  as int Function(dynamic, dynamic);
          final compactionStrategyRaw = named['compactionStrategy'];
          final compactionStrategy =
              ((int p0, int p1) {
                    return D4.callInterpreterCallback(
                          visitor!,
                          compactionStrategyRaw,
                          [p0, p1],
                        )
                        as bool;
                  })
                  as bool Function(int, int);
          return t.openLazyBox(
            name,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery,
            path: path,
            collection: collection,
            encryptionKey: encryptionKey,
            keyComparator: keyComparator,
            compactionStrategy: compactionStrategy,
          );
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'box': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'box');
        final name = D4.getRequiredArg<String>(positional, 0, 'name', 'box');
        return t.box(name);
      },
      'lazyBox': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'lazyBox');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'lazyBox',
        );
        return t.lazyBox(name);
      },
      'isBoxOpen': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'isBoxOpen');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'isBoxOpen',
        );
        return t.isBoxOpen(name);
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        return t.close();
      },
      'deleteBoxFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'deleteBoxFromDisk');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'deleteBoxFromDisk',
        );
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        return t.deleteBoxFromDisk(name, path: path);
      },
      'deleteFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        return t.deleteFromDisk();
      },
      'generateSecureKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        return t.generateSecureKey();
      },
      'boxExists': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'boxExists');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'boxExists',
        );
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        return t.boxExists(name, path: path);
      },
      'resetAdapters': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        t.resetAdapters();
        return null;
      },
      'registerAdapter': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'registerAdapter');
        final adapter = D4
            .getRequiredArg<$dartnative_hive_22.TypeAdapter<dynamic>>(
              positional,
              0,
              'adapter',
              'registerAdapter',
            );
        final internal = D4.getNamedArgWithDefault<bool>(
          named,
          'internal',
          false,
        );
        final override = D4.getNamedArgWithDefault<bool>(
          named,
          'override',
          false,
        );
        t.registerAdapter(adapter, internal: internal, override: override);
        return null;
      },
      'isAdapterRegistered': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'isAdapterRegistered');
        final typeId = D4.getRequiredArg<int>(
          positional,
          0,
          'typeId',
          'isAdapterRegistered',
        );
        return t.isAdapterRegistered(typeId);
      },
      'ignoreTypeId': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_12.HiveInterface>(
          target,
          'HiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'ignoreTypeId');
        final typeId = D4.getRequiredArg<int>(
          positional,
          0,
          'typeId',
          'ignoreTypeId',
        );
        t.ignoreTypeId(typeId);
        return null;
      },
    },
    methodSignatures: {
      'init':
          'void init(String? path, {HiveStorageBackendPreference backendPreference = HiveStorageBackendPreference.native})',
      'openBox':
          'Future<Box<E>> openBox(String name, {HiveCipher? encryptionCipher, KeyComparator keyComparator = defaultKeyComparator, CompactionStrategy compactionStrategy = defaultCompactionStrategy, bool crashRecovery = true, String? path, Uint8List? bytes, String? collection, List<int>? encryptionKey})',
      'openLazyBox':
          'Future<LazyBox<E>> openLazyBox(String name, {HiveCipher? encryptionCipher, KeyComparator keyComparator = defaultKeyComparator, CompactionStrategy compactionStrategy = defaultCompactionStrategy, bool crashRecovery = true, String? path, String? collection, List<int>? encryptionKey})',
      'box': 'Box<E> box(String name)',
      'lazyBox': 'LazyBox<E> lazyBox(String name)',
      'isBoxOpen': 'bool isBoxOpen(String name)',
      'close': 'Future<void> close()',
      'deleteBoxFromDisk':
          'Future<void> deleteBoxFromDisk(String name, {String? path})',
      'deleteFromDisk': 'Future<void> deleteFromDisk()',
      'generateSecureKey': 'List<int> generateSecureKey()',
      'boxExists': 'Future<bool> boxExists(String name, {String? path})',
      'resetAdapters': 'void resetAdapters()',
      'registerAdapter':
          'void registerAdapter(TypeAdapter<T> adapter, {bool internal = false, bool override = false})',
      'isAdapterRegistered': 'bool isAdapterRegistered(int typeId)',
      'ignoreTypeId': 'void ignoreTypeId(int typeId)',
    },
  );
}

// =============================================================================
// HiveError Bridge
// =============================================================================

BridgedClass _createHiveErrorBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_13.HiveError,
    name: 'HiveError',
    isAssignable: (v) => v is $dartnative_hive_13.HiveError,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'HiveError');
        final message = D4.getRequiredArg<String>(
          positional,
          0,
          'message',
          'HiveError',
        );
        return $dartnative_hive_13.HiveError(message);
      },
    },
    getters: {
      'message': (visitor, target) => D4
          .validateTarget<$dartnative_hive_13.HiveError>(target, 'HiveError')
          .message,
      'stackTrace': (visitor, target) => D4
          .validateTarget<$dartnative_hive_13.HiveError>(target, 'HiveError')
          .stackTrace,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_13.HiveError>(
          target,
          'HiveError',
        );
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'HiveError(String message)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'message': 'String get message',
      'stackTrace': 'StackTrace? get stackTrace',
    },
  );
}

// =============================================================================
// HiveCollection Bridge
// =============================================================================

BridgedClass _createHiveCollectionBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_18.HiveCollection,
    name: 'HiveCollection',
    isAssignable: (v) => v is $dartnative_hive_18.HiveCollection,
    hierarchyDepth: 5,
    isAbstract: true,
    constructors: {},
    getters: {
      'box': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .box,
      'keys': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .keys,
      'length': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .length,
      'reversed': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .reversed,
      'iterator': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .iterator,
      'isEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .isEmpty,
      'isNotEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .isNotEmpty,
      'first': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .first,
      'last': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .last,
      'single': (visitor, target) => D4
          .validateTarget<$dartnative_hive_18.HiveCollection>(
            target,
            'HiveCollection',
          )
          .single,
    },
    setters: {
      'first': (visitor, target, value) =>
          D4
              .validateTarget<$dartnative_hive_18.HiveCollection>(
                target,
                'HiveCollection',
              )
              .first = D4.extractBridgedArg<$dartnative_hive_1.HiveObjectMixin>(
            value,
            'first',
          ),
      'last': (visitor, target, value) =>
          D4
              .validateTarget<$dartnative_hive_18.HiveCollection>(
                target,
                'HiveCollection',
              )
              .last = D4.extractBridgedArg<$dartnative_hive_1.HiveObjectMixin>(
            value,
            'last',
          ),
      'length': (visitor, target, value) =>
          D4
              .validateTarget<$dartnative_hive_18.HiveCollection>(
                target,
                'HiveCollection',
              )
              .length = D4.extractBridgedArg<int>(
            value,
            'length',
          ),
    },
    methods: {
      'deleteAllFromHive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.deleteAllFromHive();
      },
      'deleteFirstFromHive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.deleteFirstFromHive();
      },
      'deleteLastFromHive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.deleteLastFromHive();
      },
      'deleteFromHive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'deleteFromHive');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'deleteFromHive',
        );
        return t.deleteFromHive(index);
      },
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.toMap();
      },
      'cast': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.cast();
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'add');
        final value = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          0,
          'value',
          'add',
        );
        t.add(value);
        return null;
      },
      'addAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'addAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addAll: Missing required argument "iterable" at position 0',
          );
        }
        final iterable = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[0],
          'iterable',
        );
        t.addAll(iterable);
        return null;
      },
      'sort': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        final compareRaw = positional.isNotEmpty ? positional[0] : null;
        (t as dynamic).sort(
          compareRaw == null
              ? null
              : ((
                      $dartnative_hive_1.HiveObjectMixin p0,
                      $dartnative_hive_1.HiveObjectMixin p1,
                    ) {
                      return D4.callInterpreterCallback(visitor!, compareRaw, [
                            p0,
                            p1,
                          ])
                          as int;
                    })
                    as int Function(
                      $dartnative_hive_1.HiveObjectMixin,
                      $dartnative_hive_1.HiveObjectMixin,
                    ),
        );
        return null;
      },
      'shuffle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        final random = D4.getOptionalArg<$dart_math.Random?>(
          positional,
          0,
          'random',
        );
        t.shuffle(random);
        return null;
      },
      'indexOf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'indexOf');
        final element = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          0,
          'element',
          'indexOf',
        );
        final start = D4.getOptionalArgWithDefault<int>(
          positional,
          1,
          'start',
          0,
        );
        return t.indexOf(element, start);
      },
      'indexWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'indexWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'indexWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final start = D4.getOptionalArgWithDefault<int>(
          positional,
          1,
          'start',
          0,
        );
        return (t as dynamic).indexWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          start,
        );
      },
      'lastIndexWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'lastIndexWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'lastIndexWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final start = D4.getOptionalArg<int?>(positional, 1, 'start');
        return (t as dynamic).lastIndexWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          start,
        );
      },
      'lastIndexOf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'lastIndexOf');
        final element = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          0,
          'element',
          'lastIndexOf',
        );
        final start = D4.getOptionalArg<int?>(positional, 1, 'start');
        return t.lastIndexOf(element, start);
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        t.clear();
        return null;
      },
      'insert': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 2, 'insert');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'insert');
        final element = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          1,
          'element',
          'insert',
        );
        t.insert(index, element);
        return null;
      },
      'insertAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 2, 'insertAll');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'insertAll',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'insertAll: Missing required argument "iterable" at position 1',
          );
        }
        final iterable = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[1],
          'iterable',
        );
        t.insertAll(index, iterable);
        return null;
      },
      'setAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 2, 'setAll');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'setAll');
        if (positional.length <= 1) {
          throw ArgumentError(
            'setAll: Missing required argument "iterable" at position 1',
          );
        }
        final iterable = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[1],
          'iterable',
        );
        t.setAll(index, iterable);
        return null;
      },
      'remove': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'remove');
        final value = D4.getRequiredArg<Object?>(
          positional,
          0,
          'value',
          'remove',
        );
        return t.remove(value);
      },
      'removeAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'removeAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'removeAt',
        );
        return t.removeAt(index);
      },
      'removeLast': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.removeLast();
      },
      'removeWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'removeWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'removeWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        (t as dynamic).removeWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
        return null;
      },
      'retainWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'retainWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'retainWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        (t as dynamic).retainWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
        return null;
      },
      'sublist': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'sublist');
        final start = D4.getRequiredArg<int>(positional, 0, 'start', 'sublist');
        final end = D4.getOptionalArg<int?>(positional, 1, 'end');
        return t.sublist(start, end);
      },
      'getRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 2, 'getRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'getRange',
        );
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'getRange');
        return t.getRange(start, end);
      },
      'setRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 3, 'setRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'setRange',
        );
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'setRange');
        if (positional.length <= 2) {
          throw ArgumentError(
            'setRange: Missing required argument "iterable" at position 2',
          );
        }
        final iterable = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[2],
          'iterable',
        );
        final skipCount = D4.getOptionalArgWithDefault<int>(
          positional,
          3,
          'skipCount',
          0,
        );
        t.setRange(start, end, iterable, skipCount);
        return null;
      },
      'removeRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 2, 'removeRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'removeRange',
        );
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'removeRange');
        t.removeRange(start, end);
        return null;
      },
      'fillRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 2, 'fillRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'fillRange',
        );
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'fillRange');
        final fillValue = D4
            .getOptionalArg<$dartnative_hive_1.HiveObjectMixin?>(
              positional,
              2,
              'fillValue',
            );
        t.fillRange(start, end, fillValue);
        return null;
      },
      'replaceRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 3, 'replaceRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'replaceRange',
        );
        final end = D4.getRequiredArg<int>(
          positional,
          1,
          'end',
          'replaceRange',
        );
        if (positional.length <= 2) {
          throw ArgumentError(
            'replaceRange: Missing required argument "replacements" at position 2',
          );
        }
        final replacements = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[2],
          'replacements',
        );
        t.replaceRange(start, end, replacements);
        return null;
      },
      'asMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.asMap();
      },
      'followedBy': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'followedBy');
        if (positional.isEmpty) {
          throw ArgumentError(
            'followedBy: Missing required argument "other" at position 0',
          );
        }
        final other = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[0],
          'other',
        );
        return t.followedBy(other);
      },
      'map': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'map');
        if (positional.isEmpty) {
          throw ArgumentError(
            'map: Missing required argument "toElement" at position 0',
          );
        }
        final toElementRaw = positional[0];
        return (t as dynamic).map(($dartnative_hive_1.HiveObjectMixin p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, toElementRaw, [p0]),
          );
        });
      },
      'where': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'where');
        if (positional.isEmpty) {
          throw ArgumentError(
            'where: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).where(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'whereType': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.whereType();
      },
      'expand': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'expand');
        if (positional.isEmpty) {
          throw ArgumentError(
            'expand: Missing required argument "toElements" at position 0',
          );
        }
        final toElementsRaw = positional[0];
        return (t as dynamic).expand(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.extractBridgedArg<Iterable<dynamic>>(
                      D4.callInterpreterCallback(visitor!, toElementsRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as Iterable<dynamic>;
              })
              as Iterable<dynamic> Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'contains': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'contains');
        final element = D4.getRequiredArg<Object?>(
          positional,
          0,
          'element',
          'contains',
        );
        return t.contains(element);
      },
      'forEach': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'forEach');
        if (positional.isEmpty) {
          throw ArgumentError(
            'forEach: Missing required argument "action" at position 0',
          );
        }
        final actionRaw = positional[0];
        (t as dynamic).forEach(($dartnative_hive_1.HiveObjectMixin p0) {
          D4.callInterpreterCallback(visitor!, actionRaw, [p0]);
        });
        return null;
      },
      'reduce': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'reduce');
        if (positional.isEmpty) {
          throw ArgumentError(
            'reduce: Missing required argument "combine" at position 0',
          );
        }
        final combineRaw = positional[0];
        return (t as dynamic).reduce(
          ((
                $dartnative_hive_1.HiveObjectMixin p0,
                $dartnative_hive_1.HiveObjectMixin p1,
              ) {
                return D4.extractBridgedArg<$dartnative_hive_1.HiveObjectMixin>(
                      D4.callInterpreterCallback(visitor!, combineRaw, [
                        p0,
                        p1,
                      ]),
                      'callback',
                      visitor,
                    )
                    as $dartnative_hive_1.HiveObjectMixin;
              })
              as $dartnative_hive_1.HiveObjectMixin Function(
                $dartnative_hive_1.HiveObjectMixin,
                $dartnative_hive_1.HiveObjectMixin,
              ),
        );
      },
      'fold': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 2, 'fold');
        final initialValue = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'initialValue',
          'fold',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'fold: Missing required argument "combine" at position 1',
          );
        }
        final combineRaw = positional[1];
        return (t as dynamic).fold(initialValue, (
          dynamic p0,
          $dartnative_hive_1.HiveObjectMixin p1,
        ) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, combineRaw, [p0, p1]),
          );
        });
      },
      'every': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'every');
        if (positional.isEmpty) {
          throw ArgumentError(
            'every: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).every(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'join': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        final separator = D4.getOptionalArgWithDefault<String>(
          positional,
          0,
          'separator',
          "",
        );
        return t.join(separator);
      },
      'any': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'any');
        if (positional.isEmpty) {
          throw ArgumentError(
            'any: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).any(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'toList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        final growable = D4.getNamedArgWithDefault<bool>(
          named,
          'growable',
          true,
        );
        return t.toList(growable: growable);
      },
      'toSet': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.toSet();
      },
      'take': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'take');
        final count = D4.getRequiredArg<int>(positional, 0, 'count', 'take');
        return t.take(count);
      },
      'takeWhile': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'takeWhile');
        if (positional.isEmpty) {
          throw ArgumentError(
            'takeWhile: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).takeWhile(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'skip': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'skip');
        final count = D4.getRequiredArg<int>(positional, 0, 'count', 'skip');
        return t.skip(count);
      },
      'skipWhile': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'skipWhile');
        if (positional.isEmpty) {
          throw ArgumentError(
            'skipWhile: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).skipWhile(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'firstWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'firstWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'firstWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final orElseRaw = named['orElse'];
        return (t as dynamic).firstWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          orElse: orElseRaw == null
              ? null
              : (() {
                      return D4.extractBridgedArg<
                            $dartnative_hive_1.HiveObjectMixin
                          >(
                            D4.callInterpreterCallback(visitor!, orElseRaw, []),
                            'callback',
                            visitor,
                          )
                          as $dartnative_hive_1.HiveObjectMixin;
                    })
                    as $dartnative_hive_1.HiveObjectMixin Function(),
        );
      },
      'lastWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'lastWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'lastWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final orElseRaw = named['orElse'];
        return (t as dynamic).lastWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          orElse: orElseRaw == null
              ? null
              : (() {
                      return D4.extractBridgedArg<
                            $dartnative_hive_1.HiveObjectMixin
                          >(
                            D4.callInterpreterCallback(visitor!, orElseRaw, []),
                            'callback',
                            visitor,
                          )
                          as $dartnative_hive_1.HiveObjectMixin;
                    })
                    as $dartnative_hive_1.HiveObjectMixin Function(),
        );
      },
      'singleWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'singleWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'singleWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final orElseRaw = named['orElse'];
        return (t as dynamic).singleWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          orElse: orElseRaw == null
              ? null
              : (() {
                      return D4.extractBridgedArg<
                            $dartnative_hive_1.HiveObjectMixin
                          >(
                            D4.callInterpreterCallback(visitor!, orElseRaw, []),
                            'callback',
                            visitor,
                          )
                          as $dartnative_hive_1.HiveObjectMixin;
                    })
                    as $dartnative_hive_1.HiveObjectMixin Function(),
        );
      },
      'elementAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        D4.requireMinArgs(positional, 1, 'elementAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'elementAt',
        );
        return t.elementAt(index);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        return t.toString();
      },
      '[]': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'operator[]',
        );
        return t[index];
      },
      '[]=': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'operator[]=',
        );
        final value = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          1,
          'value',
          'operator[]=',
        );
        t[index] = value;
        return null;
      },
      '+': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
        );
        final other = D4
            .getRequiredArg<List<$dartnative_hive_1.HiveObjectMixin>>(
              positional,
              0,
              'other',
              'operator+',
            );
        return t + other;
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_18.HiveCollection>(
          target,
          'HiveCollection',
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
      'deleteAllFromHive': 'Future<void> deleteAllFromHive()',
      'deleteFirstFromHive': 'Future<void> deleteFirstFromHive()',
      'deleteLastFromHive': 'Future<void> deleteLastFromHive()',
      'deleteFromHive': 'Future<void> deleteFromHive(int index)',
      'toMap': 'Map<dynamic, E> toMap()',
      'cast': 'List<R> cast()',
      'add': 'void add(E value)',
      'addAll': 'void addAll(Iterable<E> iterable)',
      'sort': 'void sort([int Function(E a, E b)? compare])',
      'shuffle': 'void shuffle([Random? random])',
      'indexOf': 'int indexOf(E element, [int start = 0])',
      'indexWhere':
          'int indexWhere(bool Function(E element) test, [int start = 0])',
      'lastIndexWhere':
          'int lastIndexWhere(bool Function(E element) test, [int? start])',
      'lastIndexOf': 'int lastIndexOf(E element, [int? start])',
      'clear': 'void clear()',
      'insert': 'void insert(int index, E element)',
      'insertAll': 'void insertAll(int index, Iterable<E> iterable)',
      'setAll': 'void setAll(int index, Iterable<E> iterable)',
      'remove': 'bool remove(Object? value)',
      'removeAt': 'E removeAt(int index)',
      'removeLast': 'E removeLast()',
      'removeWhere': 'void removeWhere(bool Function(E element) test)',
      'retainWhere': 'void retainWhere(bool Function(E element) test)',
      'sublist': 'List<E> sublist(int start, [int? end])',
      'getRange': 'Iterable<E> getRange(int start, int end)',
      'setRange':
          'void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0])',
      'removeRange': 'void removeRange(int start, int end)',
      'fillRange': 'void fillRange(int start, int end, [E? fillValue])',
      'replaceRange':
          'void replaceRange(int start, int end, Iterable<E> replacements)',
      'asMap': 'Map<int, E> asMap()',
      'followedBy': 'Iterable<E> followedBy(Iterable<E> other)',
      'map': 'Iterable<T> map(T Function(E e) toElement)',
      'where': 'Iterable<E> where(bool Function(E element) test)',
      'whereType': 'Iterable<T> whereType()',
      'expand':
          'Iterable<T> expand(Iterable<T> Function(E element) toElements)',
      'contains': 'bool contains(Object? element)',
      'forEach': 'void forEach(void Function(E element) action)',
      'reduce': 'E reduce(E Function(E value, E element) combine)',
      'fold':
          'T fold(T initialValue, T Function(T previousValue, E element) combine)',
      'every': 'bool every(bool Function(E element) test)',
      'join': 'String join([String separator = ""])',
      'any': 'bool any(bool Function(E element) test)',
      'toList': 'List<E> toList({bool growable = true})',
      'toSet': 'Set<E> toSet()',
      'take': 'Iterable<E> take(int count)',
      'takeWhile': 'Iterable<E> takeWhile(bool Function(E value) test)',
      'skip': 'Iterable<E> skip(int count)',
      'skipWhile': 'Iterable<E> skipWhile(bool Function(E value) test)',
      'firstWhere':
          'E firstWhere(bool Function(E element) test, {E Function()? orElse})',
      'lastWhere':
          'E lastWhere(bool Function(E element) test, {E Function()? orElse})',
      'singleWhere':
          'E singleWhere(bool Function(E element) test, {E Function()? orElse})',
      'elementAt': 'E elementAt(int index)',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'box': 'BoxBase get box',
      'keys': 'Iterable get keys',
      'length': 'int get length',
      'reversed': 'Iterable<E> get reversed',
      'iterator': 'Iterator<E> get iterator',
      'isEmpty': 'bool get isEmpty',
      'isNotEmpty': 'bool get isNotEmpty',
      'first': 'E get first',
      'last': 'E get last',
      'single': 'E get single',
    },
    setterSignatures: {
      'first': 'set first(E value)',
      'last': 'set last(E value)',
      'length': 'set length(int value)',
    },
  );
}

// =============================================================================
// HiveList Bridge
// =============================================================================

BridgedClass _createHiveListBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_19.HiveList,
    name: 'HiveList',
    isAssignable: (v) => v is $dartnative_hive_19.HiveList,
    hierarchyDepth: 6,
    isAbstract: true,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'HiveList');
        final box = D4.getRequiredArg<$dartnative_hive_7.Box>(
          positional,
          0,
          'box',
          'HiveList',
        );
        final objects = D4.coerceListOrNull<$dartnative_hive_1.HiveObjectMixin>(
          named['objects'],
          'objects',
        );
        return $dartnative_hive_19.HiveList(box, objects: objects);
      },
    },
    getters: {
      'box': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .box,
      'keys': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .keys,
      'length': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .length,
      'reversed': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .reversed,
      'iterator': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .iterator,
      'isEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .isEmpty,
      'isNotEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .isNotEmpty,
      'first': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .first,
      'last': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .last,
      'single': (visitor, target) => D4
          .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
          .single,
    },
    setters: {
      'first': (visitor, target, value) =>
          D4
              .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
              .first = D4.extractBridgedArg<$dartnative_hive_1.HiveObjectMixin>(
            value,
            'first',
          ),
      'last': (visitor, target, value) =>
          D4
              .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
              .last = D4.extractBridgedArg<$dartnative_hive_1.HiveObjectMixin>(
            value,
            'last',
          ),
      'length': (visitor, target, value) =>
          D4
              .validateTarget<$dartnative_hive_19.HiveList>(target, 'HiveList')
              .length = D4.extractBridgedArg<int>(
            value,
            'length',
          ),
    },
    methods: {
      'deleteAllFromHive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.deleteAllFromHive();
      },
      'deleteFirstFromHive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.deleteFirstFromHive();
      },
      'deleteLastFromHive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.deleteLastFromHive();
      },
      'deleteFromHive': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'deleteFromHive');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'deleteFromHive',
        );
        return t.deleteFromHive(index);
      },
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.toMap();
      },
      'cast': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.cast();
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'add');
        final value = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          0,
          'value',
          'add',
        );
        t.add(value);
        return null;
      },
      'addAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'addAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addAll: Missing required argument "iterable" at position 0',
          );
        }
        final iterable = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[0],
          'iterable',
        );
        t.addAll(iterable);
        return null;
      },
      'sort': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        final compareRaw = positional.isNotEmpty ? positional[0] : null;
        (t as dynamic).sort(
          compareRaw == null
              ? null
              : ((
                      $dartnative_hive_1.HiveObjectMixin p0,
                      $dartnative_hive_1.HiveObjectMixin p1,
                    ) {
                      return D4.callInterpreterCallback(visitor!, compareRaw, [
                            p0,
                            p1,
                          ])
                          as int;
                    })
                    as int Function(
                      $dartnative_hive_1.HiveObjectMixin,
                      $dartnative_hive_1.HiveObjectMixin,
                    ),
        );
        return null;
      },
      'shuffle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        final random = D4.getOptionalArg<$dart_math.Random?>(
          positional,
          0,
          'random',
        );
        t.shuffle(random);
        return null;
      },
      'indexOf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'indexOf');
        final element = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          0,
          'element',
          'indexOf',
        );
        final start = D4.getOptionalArgWithDefault<int>(
          positional,
          1,
          'start',
          0,
        );
        return t.indexOf(element, start);
      },
      'indexWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'indexWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'indexWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final start = D4.getOptionalArgWithDefault<int>(
          positional,
          1,
          'start',
          0,
        );
        return (t as dynamic).indexWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          start,
        );
      },
      'lastIndexWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'lastIndexWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'lastIndexWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final start = D4.getOptionalArg<int?>(positional, 1, 'start');
        return (t as dynamic).lastIndexWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          start,
        );
      },
      'lastIndexOf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'lastIndexOf');
        final element = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          0,
          'element',
          'lastIndexOf',
        );
        final start = D4.getOptionalArg<int?>(positional, 1, 'start');
        return t.lastIndexOf(element, start);
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        t.clear();
        return null;
      },
      'insert': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 2, 'insert');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'insert');
        final element = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          1,
          'element',
          'insert',
        );
        t.insert(index, element);
        return null;
      },
      'insertAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 2, 'insertAll');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'insertAll',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'insertAll: Missing required argument "iterable" at position 1',
          );
        }
        final iterable = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[1],
          'iterable',
        );
        t.insertAll(index, iterable);
        return null;
      },
      'setAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 2, 'setAll');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'setAll');
        if (positional.length <= 1) {
          throw ArgumentError(
            'setAll: Missing required argument "iterable" at position 1',
          );
        }
        final iterable = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[1],
          'iterable',
        );
        t.setAll(index, iterable);
        return null;
      },
      'remove': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'remove');
        final value = D4.getRequiredArg<Object?>(
          positional,
          0,
          'value',
          'remove',
        );
        return t.remove(value);
      },
      'removeAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'removeAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'removeAt',
        );
        return t.removeAt(index);
      },
      'removeLast': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.removeLast();
      },
      'removeWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'removeWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'removeWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        (t as dynamic).removeWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
        return null;
      },
      'retainWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'retainWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'retainWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        (t as dynamic).retainWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
        return null;
      },
      'sublist': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'sublist');
        final start = D4.getRequiredArg<int>(positional, 0, 'start', 'sublist');
        final end = D4.getOptionalArg<int?>(positional, 1, 'end');
        return t.sublist(start, end);
      },
      'getRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 2, 'getRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'getRange',
        );
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'getRange');
        return t.getRange(start, end);
      },
      'setRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 3, 'setRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'setRange',
        );
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'setRange');
        if (positional.length <= 2) {
          throw ArgumentError(
            'setRange: Missing required argument "iterable" at position 2',
          );
        }
        final iterable = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[2],
          'iterable',
        );
        final skipCount = D4.getOptionalArgWithDefault<int>(
          positional,
          3,
          'skipCount',
          0,
        );
        t.setRange(start, end, iterable, skipCount);
        return null;
      },
      'removeRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 2, 'removeRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'removeRange',
        );
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'removeRange');
        t.removeRange(start, end);
        return null;
      },
      'fillRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 2, 'fillRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'fillRange',
        );
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'fillRange');
        final fillValue = D4
            .getOptionalArg<$dartnative_hive_1.HiveObjectMixin?>(
              positional,
              2,
              'fillValue',
            );
        t.fillRange(start, end, fillValue);
        return null;
      },
      'replaceRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 3, 'replaceRange');
        final start = D4.getRequiredArg<int>(
          positional,
          0,
          'start',
          'replaceRange',
        );
        final end = D4.getRequiredArg<int>(
          positional,
          1,
          'end',
          'replaceRange',
        );
        if (positional.length <= 2) {
          throw ArgumentError(
            'replaceRange: Missing required argument "replacements" at position 2',
          );
        }
        final replacements = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[2],
          'replacements',
        );
        t.replaceRange(start, end, replacements);
        return null;
      },
      'asMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.asMap();
      },
      'followedBy': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'followedBy');
        if (positional.isEmpty) {
          throw ArgumentError(
            'followedBy: Missing required argument "other" at position 0',
          );
        }
        final other = D4.coerceList<$dartnative_hive_1.HiveObjectMixin>(
          positional[0],
          'other',
        );
        return t.followedBy(other);
      },
      'map': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'map');
        if (positional.isEmpty) {
          throw ArgumentError(
            'map: Missing required argument "toElement" at position 0',
          );
        }
        final toElementRaw = positional[0];
        return (t as dynamic).map(($dartnative_hive_1.HiveObjectMixin p0) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, toElementRaw, [p0]),
          );
        });
      },
      'where': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'where');
        if (positional.isEmpty) {
          throw ArgumentError(
            'where: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).where(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'whereType': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.whereType();
      },
      'expand': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'expand');
        if (positional.isEmpty) {
          throw ArgumentError(
            'expand: Missing required argument "toElements" at position 0',
          );
        }
        final toElementsRaw = positional[0];
        return (t as dynamic).expand(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.extractBridgedArg<Iterable<dynamic>>(
                      D4.callInterpreterCallback(visitor!, toElementsRaw, [p0]),
                      'callback',
                      visitor,
                    )
                    as Iterable<dynamic>;
              })
              as Iterable<dynamic> Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'contains': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'contains');
        final element = D4.getRequiredArg<Object?>(
          positional,
          0,
          'element',
          'contains',
        );
        return t.contains(element);
      },
      'forEach': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'forEach');
        if (positional.isEmpty) {
          throw ArgumentError(
            'forEach: Missing required argument "action" at position 0',
          );
        }
        final actionRaw = positional[0];
        (t as dynamic).forEach(($dartnative_hive_1.HiveObjectMixin p0) {
          D4.callInterpreterCallback(visitor!, actionRaw, [p0]);
        });
        return null;
      },
      'reduce': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'reduce');
        if (positional.isEmpty) {
          throw ArgumentError(
            'reduce: Missing required argument "combine" at position 0',
          );
        }
        final combineRaw = positional[0];
        return (t as dynamic).reduce(
          ((
                $dartnative_hive_1.HiveObjectMixin p0,
                $dartnative_hive_1.HiveObjectMixin p1,
              ) {
                return D4.extractBridgedArg<$dartnative_hive_1.HiveObjectMixin>(
                      D4.callInterpreterCallback(visitor!, combineRaw, [
                        p0,
                        p1,
                      ]),
                      'callback',
                      visitor,
                    )
                    as $dartnative_hive_1.HiveObjectMixin;
              })
              as $dartnative_hive_1.HiveObjectMixin Function(
                $dartnative_hive_1.HiveObjectMixin,
                $dartnative_hive_1.HiveObjectMixin,
              ),
        );
      },
      'fold': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 2, 'fold');
        final initialValue = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'initialValue',
          'fold',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'fold: Missing required argument "combine" at position 1',
          );
        }
        final combineRaw = positional[1];
        return (t as dynamic).fold(initialValue, (
          dynamic p0,
          $dartnative_hive_1.HiveObjectMixin p1,
        ) {
          return D4.castCallbackResult<dynamic>(
            D4.callInterpreterCallback(visitor!, combineRaw, [p0, p1]),
          );
        });
      },
      'every': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'every');
        if (positional.isEmpty) {
          throw ArgumentError(
            'every: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).every(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'join': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        final separator = D4.getOptionalArgWithDefault<String>(
          positional,
          0,
          'separator',
          "",
        );
        return t.join(separator);
      },
      'any': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'any');
        if (positional.isEmpty) {
          throw ArgumentError(
            'any: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).any(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'toList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        final growable = D4.getNamedArgWithDefault<bool>(
          named,
          'growable',
          true,
        );
        return t.toList(growable: growable);
      },
      'toSet': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.toSet();
      },
      'take': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'take');
        final count = D4.getRequiredArg<int>(positional, 0, 'count', 'take');
        return t.take(count);
      },
      'takeWhile': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'takeWhile');
        if (positional.isEmpty) {
          throw ArgumentError(
            'takeWhile: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).takeWhile(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'skip': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'skip');
        final count = D4.getRequiredArg<int>(positional, 0, 'count', 'skip');
        return t.skip(count);
      },
      'skipWhile': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'skipWhile');
        if (positional.isEmpty) {
          throw ArgumentError(
            'skipWhile: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        return (t as dynamic).skipWhile(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
        );
      },
      'firstWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'firstWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'firstWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final orElseRaw = named['orElse'];
        return (t as dynamic).firstWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          orElse: orElseRaw == null
              ? null
              : (() {
                      return D4.extractBridgedArg<
                            $dartnative_hive_1.HiveObjectMixin
                          >(
                            D4.callInterpreterCallback(visitor!, orElseRaw, []),
                            'callback',
                            visitor,
                          )
                          as $dartnative_hive_1.HiveObjectMixin;
                    })
                    as $dartnative_hive_1.HiveObjectMixin Function(),
        );
      },
      'lastWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'lastWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'lastWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final orElseRaw = named['orElse'];
        return (t as dynamic).lastWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          orElse: orElseRaw == null
              ? null
              : (() {
                      return D4.extractBridgedArg<
                            $dartnative_hive_1.HiveObjectMixin
                          >(
                            D4.callInterpreterCallback(visitor!, orElseRaw, []),
                            'callback',
                            visitor,
                          )
                          as $dartnative_hive_1.HiveObjectMixin;
                    })
                    as $dartnative_hive_1.HiveObjectMixin Function(),
        );
      },
      'singleWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'singleWhere');
        if (positional.isEmpty) {
          throw ArgumentError(
            'singleWhere: Missing required argument "test" at position 0',
          );
        }
        final testRaw = positional[0];
        final orElseRaw = named['orElse'];
        return (t as dynamic).singleWhere(
          (($dartnative_hive_1.HiveObjectMixin p0) {
                return D4.callInterpreterCallback(visitor!, testRaw, [p0])
                    as bool;
              })
              as bool Function($dartnative_hive_1.HiveObjectMixin),
          orElse: orElseRaw == null
              ? null
              : (() {
                      return D4.extractBridgedArg<
                            $dartnative_hive_1.HiveObjectMixin
                          >(
                            D4.callInterpreterCallback(visitor!, orElseRaw, []),
                            'callback',
                            visitor,
                          )
                          as $dartnative_hive_1.HiveObjectMixin;
                    })
                    as $dartnative_hive_1.HiveObjectMixin Function(),
        );
      },
      'elementAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        D4.requireMinArgs(positional, 1, 'elementAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'elementAt',
        );
        return t.elementAt(index);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.toString();
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        (t as dynamic).dispose();
        return null;
      },
      'castHiveList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        return t.castHiveList();
      },
      '[]': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'operator[]',
        );
        return t[index];
      },
      '[]=': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'operator[]=',
        );
        final value = D4.getRequiredArg<$dartnative_hive_1.HiveObjectMixin>(
          positional,
          1,
          'value',
          'operator[]=',
        );
        t[index] = value;
        return null;
      },
      '+': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
        );
        final other = D4
            .getRequiredArg<List<$dartnative_hive_1.HiveObjectMixin>>(
              positional,
              0,
              'other',
              'operator+',
            );
        return t + other;
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_19.HiveList>(
          target,
          'HiveList',
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
      '': 'factory HiveList(Box box, {List<E>? objects})',
    },
    methodSignatures: {
      'deleteAllFromHive': 'Future<void> deleteAllFromHive()',
      'deleteFirstFromHive': 'Future<void> deleteFirstFromHive()',
      'deleteLastFromHive': 'Future<void> deleteLastFromHive()',
      'deleteFromHive': 'Future<void> deleteFromHive(int index)',
      'toMap': 'Map<dynamic, E> toMap()',
      'cast': 'List<R> cast()',
      'add': 'void add(E value)',
      'addAll': 'void addAll(Iterable<E> iterable)',
      'sort': 'void sort([int Function(E a, E b)? compare])',
      'shuffle': 'void shuffle([Random? random])',
      'indexOf': 'int indexOf(E element, [int start = 0])',
      'indexWhere':
          'int indexWhere(bool Function(E element) test, [int start = 0])',
      'lastIndexWhere':
          'int lastIndexWhere(bool Function(E element) test, [int? start])',
      'lastIndexOf': 'int lastIndexOf(E element, [int? start])',
      'clear': 'void clear()',
      'insert': 'void insert(int index, E element)',
      'insertAll': 'void insertAll(int index, Iterable<E> iterable)',
      'setAll': 'void setAll(int index, Iterable<E> iterable)',
      'remove': 'bool remove(Object? value)',
      'removeAt': 'E removeAt(int index)',
      'removeLast': 'E removeLast()',
      'removeWhere': 'void removeWhere(bool Function(E element) test)',
      'retainWhere': 'void retainWhere(bool Function(E element) test)',
      'sublist': 'List<E> sublist(int start, [int? end])',
      'getRange': 'Iterable<E> getRange(int start, int end)',
      'setRange':
          'void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0])',
      'removeRange': 'void removeRange(int start, int end)',
      'fillRange': 'void fillRange(int start, int end, [E? fillValue])',
      'replaceRange':
          'void replaceRange(int start, int end, Iterable<E> replacements)',
      'asMap': 'Map<int, E> asMap()',
      'followedBy': 'Iterable<E> followedBy(Iterable<E> other)',
      'map': 'Iterable<T> map(T Function(E e) toElement)',
      'where': 'Iterable<E> where(bool Function(E element) test)',
      'whereType': 'Iterable<T> whereType()',
      'expand':
          'Iterable<T> expand(Iterable<T> Function(E element) toElements)',
      'contains': 'bool contains(Object? element)',
      'forEach': 'void forEach(void Function(E element) action)',
      'reduce': 'E reduce(E Function(E value, E element) combine)',
      'fold':
          'T fold(T initialValue, T Function(T previousValue, E element) combine)',
      'every': 'bool every(bool Function(E element) test)',
      'join': 'String join([String separator = ""])',
      'any': 'bool any(bool Function(E element) test)',
      'toList': 'List<E> toList({bool growable = true})',
      'toSet': 'Set<E> toSet()',
      'take': 'Iterable<E> take(int count)',
      'takeWhile': 'Iterable<E> takeWhile(bool Function(E value) test)',
      'skip': 'Iterable<E> skip(int count)',
      'skipWhile': 'Iterable<E> skipWhile(bool Function(E value) test)',
      'firstWhere':
          'E firstWhere(bool Function(E element) test, {E Function()? orElse})',
      'lastWhere':
          'E lastWhere(bool Function(E element) test, {E Function()? orElse})',
      'singleWhere':
          'E singleWhere(bool Function(E element) test, {E Function()? orElse})',
      'elementAt': 'E elementAt(int index)',
      'toString': 'String toString()',
      'dispose': 'void dispose()',
      'castHiveList': 'HiveList<T> castHiveList()',
    },
    getterSignatures: {
      'box': 'BoxBase<dynamic> get box',
      'keys': 'Iterable<dynamic> get keys',
      'length': 'int get length',
      'reversed': 'Iterable<E> get reversed',
      'iterator': 'Iterator<E> get iterator',
      'isEmpty': 'bool get isEmpty',
      'isNotEmpty': 'bool get isNotEmpty',
      'first': 'E get first',
      'last': 'E get last',
      'single': 'E get single',
    },
    setterSignatures: {
      'first': 'set first(E value)',
      'last': 'set last(E value)',
      'length': 'set length(int value)',
    },
  );
}

// =============================================================================
// TypeAdapter Bridge
// =============================================================================

BridgedClass _createTypeAdapterBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_22.TypeAdapter,
    name: 'TypeAdapter',
    isAssignable: (v) => v is $dartnative_hive_22.TypeAdapter,
    isAbstract: true,
    constructors: {},
    getters: {
      'typeId': (visitor, target) => D4
          .validateTarget<$dartnative_hive_22.TypeAdapter>(
            target,
            'TypeAdapter',
          )
          .typeId,
    },
    methods: {
      'read': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_22.TypeAdapter>(
          target,
          'TypeAdapter',
        );
        D4.requireMinArgs(positional, 1, 'read');
        final reader = D4.getRequiredArg<$dartnative_hive_5.BinaryReader>(
          positional,
          0,
          'reader',
          'read',
        );
        return t.read(reader);
      },
      'write': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_22.TypeAdapter>(
          target,
          'TypeAdapter',
        );
        D4.requireMinArgs(positional, 2, 'write');
        final writer = D4.getRequiredArg<$dartnative_hive_6.BinaryWriter>(
          positional,
          0,
          'writer',
          'write',
        );
        final obj = D4.getRequiredArg<dynamic>(positional, 1, 'obj', 'write');
        t.write(writer, obj);
        return null;
      },
    },
    methodSignatures: {
      'read': 'T read(BinaryReader reader)',
      'write': 'void write(BinaryWriter writer, T obj)',
    },
    getterSignatures: {
      'typeId': 'int get typeId',
    },
  );
}

// =============================================================================
// TypeRegistry Bridge
// =============================================================================

BridgedClass _createTypeRegistryBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_23.TypeRegistry,
    name: 'TypeRegistry',
    isAssignable: (v) => v is $dartnative_hive_23.TypeRegistry,
    isAbstract: true,
    constructors: {},
    methods: {
      'registerAdapter': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_23.TypeRegistry>(
          target,
          'TypeRegistry',
        );
        D4.requireMinArgs(positional, 1, 'registerAdapter');
        final adapter = D4
            .getRequiredArg<$dartnative_hive_22.TypeAdapter<dynamic>>(
              positional,
              0,
              'adapter',
              'registerAdapter',
            );
        final internal = D4.getNamedArgWithDefault<bool>(
          named,
          'internal',
          false,
        );
        final override = D4.getNamedArgWithDefault<bool>(
          named,
          'override',
          false,
        );
        t.registerAdapter(adapter, internal: internal, override: override);
        return null;
      },
      'isAdapterRegistered': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_23.TypeRegistry>(
          target,
          'TypeRegistry',
        );
        D4.requireMinArgs(positional, 1, 'isAdapterRegistered');
        final typeId = D4.getRequiredArg<int>(
          positional,
          0,
          'typeId',
          'isAdapterRegistered',
        );
        return t.isAdapterRegistered(typeId);
      },
      'ignoreTypeId': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_23.TypeRegistry>(
          target,
          'TypeRegistry',
        );
        D4.requireMinArgs(positional, 1, 'ignoreTypeId');
        final typeId = D4.getRequiredArg<int>(
          positional,
          0,
          'typeId',
          'ignoreTypeId',
        );
        t.ignoreTypeId(typeId);
        return null;
      },
    },
    methodSignatures: {
      'registerAdapter':
          'void registerAdapter(TypeAdapter<T> adapter, {bool internal = false, bool override = false})',
      'isAdapterRegistered': 'bool isAdapterRegistered(int typeId)',
      'ignoreTypeId': 'void ignoreTypeId(int typeId)',
    },
  );
}

// =============================================================================
// IsolateNameServer Bridge
// =============================================================================

BridgedClass _createIsolateNameServerBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_14.IsolateNameServer,
    name: 'IsolateNameServer',
    isAssignable: (v) => v is $dartnative_hive_14.IsolateNameServer,
    isAbstract: true,
    constructors: {},
    methods: {
      'lookupPortByName': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_14.IsolateNameServer>(
          target,
          'IsolateNameServer',
        );
        D4.requireMinArgs(positional, 1, 'lookupPortByName');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'lookupPortByName',
        );
        return t.lookupPortByName(name);
      },
      'registerPortWithName': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_14.IsolateNameServer>(
          target,
          'IsolateNameServer',
        );
        D4.requireMinArgs(positional, 2, 'registerPortWithName');
        final port = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'port',
          'registerPortWithName',
        );
        final name = D4.getRequiredArg<String>(
          positional,
          1,
          'name',
          'registerPortWithName',
        );
        return t.registerPortWithName(port, name);
      },
      'removePortNameMapping': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_14.IsolateNameServer>(
          target,
          'IsolateNameServer',
        );
        D4.requireMinArgs(positional, 1, 'removePortNameMapping');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'removePortNameMapping',
        );
        return t.removePortNameMapping(name);
      },
    },
    methodSignatures: {
      'lookupPortByName': 'dynamic lookupPortByName(String name)',
      'registerPortWithName':
          'bool registerPortWithName(dynamic port, String name)',
      'removePortNameMapping': 'bool removePortNameMapping(String name)',
    },
  );
}

// =============================================================================
// IsolatedCompactionStrategy Bridge
// =============================================================================

BridgedClass _createIsolatedCompactionStrategyBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_16.IsolatedCompactionStrategy,
    name: 'IsolatedCompactionStrategy',
    isAssignable: (v) => v is $dartnative_hive_16.IsolatedCompactionStrategy,
    constructors: {
      'threshold': (visitor, positional, named) {
        final deletedThreshold = D4.getRequiredNamedArg<int>(
          named,
          'deletedThreshold',
          'IsolatedCompactionStrategy',
        );
        final deletedRatio = D4.getRequiredNamedArg<double>(
          named,
          'deletedRatio',
          'IsolatedCompactionStrategy',
        );
        return $dartnative_hive_16.IsolatedCompactionStrategy.threshold(
          deletedThreshold: deletedThreshold,
          deletedRatio: deletedRatio,
        );
      },
      'never': (visitor, positional, named) {
        return $dartnative_hive_16.IsolatedCompactionStrategy.never();
      },
      'always': (visitor, positional, named) {
        return $dartnative_hive_16.IsolatedCompactionStrategy.always();
      },
    },
    constructorSignatures: {
      'threshold':
          'const factory IsolatedCompactionStrategy.threshold({required int deletedThreshold, required double deletedRatio})',
      'never': 'const factory IsolatedCompactionStrategy.never()',
      'always': 'const factory IsolatedCompactionStrategy.always()',
    },
  );
}

// =============================================================================
// IsolatedHiveInterface Bridge
// =============================================================================

BridgedClass _createIsolatedHiveInterfaceBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_17.IsolatedHiveInterface,
    name: 'IsolatedHiveInterface',
    isAssignable: (v) => v is $dartnative_hive_17.IsolatedHiveInterface,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    methods: {
      'init': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'init');
        final path = D4.getRequiredArg<String?>(positional, 0, 'path', 'init');
        final isolateNameServer = D4
            .getOptionalNamedArg<$dartnative_hive_14.IsolateNameServer?>(
              named,
              'isolateNameServer',
            );
        return t.init(path, isolateNameServer: isolateNameServer);
      },
      'openBox': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'openBox');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'openBox',
        );
        final encryptionCipher = D4
            .getOptionalNamedArg<$dartnative_hive_11.HiveCipher?>(
              named,
              'encryptionCipher',
            );
        final keyComparatorRaw = named['keyComparator'];
        final compactionStrategy = D4
            .getOptionalNamedArg<
              $dartnative_hive_16.IsolatedCompactionStrategy?
            >(named, 'compactionStrategy');
        final crashRecovery = D4.getNamedArgWithDefault<bool>(
          named,
          'crashRecovery',
          true,
        );
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        final bytes = D4.getOptionalNamedArg<Uint8List?>(named, 'bytes');
        final collection = D4.getOptionalNamedArg<String?>(named, 'collection');
        return t.openBox(
          name,
          encryptionCipher: encryptionCipher,
          keyComparator: keyComparatorRaw == null
              ? null
              : ((dynamic p0, dynamic p1) {
                      return D4.callInterpreterCallback(
                            visitor!,
                            keyComparatorRaw,
                            [p0, p1],
                          )
                          as int;
                    })
                    as int Function(dynamic, dynamic),
          compactionStrategy: compactionStrategy,
          crashRecovery: crashRecovery,
          path: path,
          bytes: bytes,
          collection: collection,
        );
      },
      'openLazyBox': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'openLazyBox');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'openLazyBox',
        );
        final encryptionCipher = D4
            .getOptionalNamedArg<$dartnative_hive_11.HiveCipher?>(
              named,
              'encryptionCipher',
            );
        final keyComparatorRaw = named['keyComparator'];
        final compactionStrategy = D4
            .getOptionalNamedArg<
              $dartnative_hive_16.IsolatedCompactionStrategy?
            >(named, 'compactionStrategy');
        final crashRecovery = D4.getNamedArgWithDefault<bool>(
          named,
          'crashRecovery',
          true,
        );
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        final collection = D4.getOptionalNamedArg<String?>(named, 'collection');
        return t.openLazyBox(
          name,
          encryptionCipher: encryptionCipher,
          keyComparator: keyComparatorRaw == null
              ? null
              : ((dynamic p0, dynamic p1) {
                      return D4.callInterpreterCallback(
                            visitor!,
                            keyComparatorRaw,
                            [p0, p1],
                          )
                          as int;
                    })
                    as int Function(dynamic, dynamic),
          compactionStrategy: compactionStrategy,
          crashRecovery: crashRecovery,
          path: path,
          collection: collection,
        );
      },
      'box': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'box');
        final name = D4.getRequiredArg<String>(positional, 0, 'name', 'box');
        return t.box(name);
      },
      'lazyBox': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'lazyBox');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'lazyBox',
        );
        return t.lazyBox(name);
      },
      'isBoxOpen': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'isBoxOpen');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'isBoxOpen',
        );
        return t.isBoxOpen(name);
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        return t.close();
      },
      'deleteBoxFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'deleteBoxFromDisk');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'deleteBoxFromDisk',
        );
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        return t.deleteBoxFromDisk(name, path: path);
      },
      'deleteFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        return t.deleteFromDisk();
      },
      'boxExists': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'boxExists');
        final name = D4.getRequiredArg<String>(
          positional,
          0,
          'name',
          'boxExists',
        );
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        return t.boxExists(name, path: path);
      },
      'resetAdapters': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        t.resetAdapters();
        return null;
      },
      'registerAdapter': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'registerAdapter');
        final adapter = D4
            .getRequiredArg<$dartnative_hive_22.TypeAdapter<dynamic>>(
              positional,
              0,
              'adapter',
              'registerAdapter',
            );
        final internal = D4.getNamedArgWithDefault<bool>(
          named,
          'internal',
          false,
        );
        final override = D4.getNamedArgWithDefault<bool>(
          named,
          'override',
          false,
        );
        t.registerAdapter(adapter, internal: internal, override: override);
        return null;
      },
      'isAdapterRegistered': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'isAdapterRegistered');
        final typeId = D4.getRequiredArg<int>(
          positional,
          0,
          'typeId',
          'isAdapterRegistered',
        );
        return t.isAdapterRegistered(typeId);
      },
      'ignoreTypeId': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_17.IsolatedHiveInterface>(
          target,
          'IsolatedHiveInterface',
        );
        D4.requireMinArgs(positional, 1, 'ignoreTypeId');
        final typeId = D4.getRequiredArg<int>(
          positional,
          0,
          'typeId',
          'ignoreTypeId',
        );
        t.ignoreTypeId(typeId);
        return null;
      },
    },
    methodSignatures: {
      'init':
          'Future<void> init(String? path, {IsolateNameServer? isolateNameServer})',
      'openBox':
          'Future<IsolatedBox<E>> openBox(String name, {HiveCipher? encryptionCipher, KeyComparator? keyComparator, IsolatedCompactionStrategy? compactionStrategy, bool crashRecovery = true, String? path, Uint8List? bytes, String? collection})',
      'openLazyBox':
          'Future<IsolatedLazyBox<E>> openLazyBox(String name, {HiveCipher? encryptionCipher, KeyComparator? keyComparator, IsolatedCompactionStrategy? compactionStrategy, bool crashRecovery = true, String? path, String? collection})',
      'box': 'IsolatedBox<E> box(String name)',
      'lazyBox': 'IsolatedLazyBox<E> lazyBox(String name)',
      'isBoxOpen': 'bool isBoxOpen(String name)',
      'close': 'Future<void> close()',
      'deleteBoxFromDisk':
          'Future<void> deleteBoxFromDisk(String name, {String? path})',
      'deleteFromDisk': 'Future<void> deleteFromDisk()',
      'boxExists': 'Future<bool> boxExists(String name, {String? path})',
      'resetAdapters': 'void resetAdapters()',
      'registerAdapter':
          'void registerAdapter(TypeAdapter<T> adapter, {bool internal = false, bool override = false})',
      'isAdapterRegistered': 'bool isAdapterRegistered(int typeId)',
      'ignoreTypeId': 'void ignoreTypeId(int typeId)',
    },
  );
}

// =============================================================================
// IsolatedBoxBase Bridge
// =============================================================================

BridgedClass _createIsolatedBoxBaseBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_15.IsolatedBoxBase,
    name: 'IsolatedBoxBase',
    isAssignable: (v) => v is $dartnative_hive_15.IsolatedBoxBase,
    isAbstract: true,
    constructors: {},
    getters: {
      'name': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
            target,
            'IsolatedBoxBase',
          )
          .name,
      'lazy': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
            target,
            'IsolatedBoxBase',
          )
          .lazy,
      'isOpen': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
            target,
            'IsolatedBoxBase',
          )
          .isOpen,
      'path': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
            target,
            'IsolatedBoxBase',
          )
          .path,
      'keys': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
            target,
            'IsolatedBoxBase',
          )
          .keys,
      'length': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
            target,
            'IsolatedBoxBase',
          )
          .length,
      'isEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
            target,
            'IsolatedBoxBase',
          )
          .isEmpty,
      'isNotEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
            target,
            'IsolatedBoxBase',
          )
          .isNotEmpty,
    },
    methods: {
      'keyAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'keyAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'keyAt');
        return t.keyAt(index);
      },
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        if (!named.containsKey('key')) {
          return t.watch();
        }
        if (named.containsKey('key')) {
          final key = D4.getRequiredNamedArg<dynamic>(named, 'key', 'watch');
          return t.watch(key: key);
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'containsKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'containsKey');
        final key = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'key',
          'containsKey',
        );
        return t.containsKey(key);
      },
      'put': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 2, 'put');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'put');
        final value = D4.getRequiredArg<dynamic>(positional, 1, 'value', 'put');
        return t.put(key, value);
      },
      'putAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 2, 'putAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'putAt');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          1,
          'value',
          'putAt',
        );
        return t.putAt(index, value);
      },
      'putAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'putAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'putAll: Missing required argument "entries" at position 0',
          );
        }
        final entries = D4.coerceMap<dynamic, dynamic>(
          positional[0],
          'entries',
        );
        return t.putAll(entries);
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'add');
        final value = D4.getRequiredArg<dynamic>(positional, 0, 'value', 'add');
        return t.add(value);
      },
      'addAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'addAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addAll: Missing required argument "values" at position 0',
          );
        }
        final values = D4.coerceList<dynamic>(positional[0], 'values');
        return t.addAll(values);
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'delete');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'delete');
        return t.delete(key);
      },
      'deleteAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'deleteAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'deleteAt',
        );
        return t.deleteAt(index);
      },
      'deleteAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'deleteAll');
        final keys = D4.getRequiredArg<Iterable>(
          positional,
          0,
          'keys',
          'deleteAll',
        );
        return t.deleteAll(keys);
      },
      'compact': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        return t.compact();
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        return t.clear();
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        return t.close();
      },
      'deleteFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        return t.deleteFromDisk();
      },
      'flush': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        return t.flush();
      },
      'get': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'get');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'get');
        final defaultValue = D4.getOptionalNamedArg<dynamic>(
          named,
          'defaultValue',
        );
        return t.get(key, defaultValue: defaultValue);
      },
      'getAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBoxBase>(
          target,
          'IsolatedBoxBase',
        );
        D4.requireMinArgs(positional, 1, 'getAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'getAt');
        return t.getAt(index);
      },
    },
    methodSignatures: {
      'keyAt': 'Future keyAt(int index)',
      'watch': 'Stream<BoxEvent> watch({dynamic key})',
      'containsKey': 'Future<bool> containsKey(dynamic key)',
      'put': 'Future<void> put(dynamic key, E value)',
      'putAt': 'Future<void> putAt(int index, E value)',
      'putAll': 'Future<void> putAll(Map<dynamic, E> entries)',
      'add': 'Future<int> add(E value)',
      'addAll': 'Future<List<int>> addAll(Iterable<E> values)',
      'delete': 'Future<void> delete(dynamic key)',
      'deleteAt': 'Future<void> deleteAt(int index)',
      'deleteAll': 'Future<void> deleteAll(Iterable keys)',
      'compact': 'Future<void> compact()',
      'clear': 'Future<int> clear()',
      'close': 'Future<void> close()',
      'deleteFromDisk': 'Future<void> deleteFromDisk()',
      'flush': 'Future<void> flush()',
      'get': 'Future<E?> get(dynamic key, {E? defaultValue})',
      'getAt': 'Future<E?> getAt(int index)',
    },
    getterSignatures: {
      'name': 'String get name',
      'lazy': 'bool get lazy',
      'isOpen': 'bool get isOpen',
      'path': 'Future<String?> get path',
      'keys': 'Future<List> get keys',
      'length': 'Future<int> get length',
      'isEmpty': 'Future<bool> get isEmpty',
      'isNotEmpty': 'Future<bool> get isNotEmpty',
    },
  );
}

// =============================================================================
// IsolatedBox Bridge
// =============================================================================

BridgedClass _createIsolatedBoxBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_15.IsolatedBox,
    name: 'IsolatedBox',
    isAssignable: (v) => v is $dartnative_hive_15.IsolatedBox,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    getters: {
      'name': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBox>(
            target,
            'IsolatedBox',
          )
          .name,
      'lazy': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBox>(
            target,
            'IsolatedBox',
          )
          .lazy,
      'isOpen': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBox>(
            target,
            'IsolatedBox',
          )
          .isOpen,
      'path': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBox>(
            target,
            'IsolatedBox',
          )
          .path,
      'keys': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBox>(
            target,
            'IsolatedBox',
          )
          .keys,
      'length': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBox>(
            target,
            'IsolatedBox',
          )
          .length,
      'isEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBox>(
            target,
            'IsolatedBox',
          )
          .isEmpty,
      'isNotEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBox>(
            target,
            'IsolatedBox',
          )
          .isNotEmpty,
      'values': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedBox>(
            target,
            'IsolatedBox',
          )
          .values,
    },
    methods: {
      'keyAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'keyAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'keyAt');
        return t.keyAt(index);
      },
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        if (!named.containsKey('key')) {
          return t.watch();
        }
        if (named.containsKey('key')) {
          final key = D4.getRequiredNamedArg<dynamic>(named, 'key', 'watch');
          return t.watch(key: key);
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'containsKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'containsKey');
        final key = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'key',
          'containsKey',
        );
        return t.containsKey(key);
      },
      'put': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 2, 'put');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'put');
        final value = D4.getRequiredArg<dynamic>(positional, 1, 'value', 'put');
        return t.put(key, value);
      },
      'putAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 2, 'putAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'putAt');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          1,
          'value',
          'putAt',
        );
        return t.putAt(index, value);
      },
      'putAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'putAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'putAll: Missing required argument "entries" at position 0',
          );
        }
        final entries = D4.coerceMap<dynamic, dynamic>(
          positional[0],
          'entries',
        );
        return t.putAll(entries);
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'add');
        final value = D4.getRequiredArg<dynamic>(positional, 0, 'value', 'add');
        return t.add(value);
      },
      'addAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'addAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addAll: Missing required argument "values" at position 0',
          );
        }
        final values = D4.coerceList<dynamic>(positional[0], 'values');
        return t.addAll(values);
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'delete');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'delete');
        return t.delete(key);
      },
      'deleteAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'deleteAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'deleteAt',
        );
        return t.deleteAt(index);
      },
      'deleteAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'deleteAll');
        final keys = D4.getRequiredArg<Iterable>(
          positional,
          0,
          'keys',
          'deleteAll',
        );
        return t.deleteAll(keys);
      },
      'compact': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        return t.compact();
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        return t.clear();
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        return t.close();
      },
      'deleteFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        return t.deleteFromDisk();
      },
      'flush': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        return t.flush();
      },
      'get': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'get');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'get');
        final defaultValue = D4.getOptionalNamedArg<dynamic>(
          named,
          'defaultValue',
        );
        return t.get(key, defaultValue: defaultValue);
      },
      'getAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        D4.requireMinArgs(positional, 1, 'getAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'getAt');
        return t.getAt(index);
      },
      'valuesBetween': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        if (!named.containsKey('startKey') && !named.containsKey('endKey')) {
          return t.valuesBetween();
        }
        if (named.containsKey('startKey') && !named.containsKey('endKey')) {
          final startKey = D4.getRequiredNamedArg<dynamic>(
            named,
            'startKey',
            'valuesBetween',
          );
          return t.valuesBetween(startKey: startKey);
        }
        if (!named.containsKey('startKey') && named.containsKey('endKey')) {
          final endKey = D4.getRequiredNamedArg<dynamic>(
            named,
            'endKey',
            'valuesBetween',
          );
          return t.valuesBetween(endKey: endKey);
        }
        if (named.containsKey('startKey') && named.containsKey('endKey')) {
          final startKey = D4.getRequiredNamedArg<dynamic>(
            named,
            'startKey',
            'valuesBetween',
          );
          final endKey = D4.getRequiredNamedArg<dynamic>(
            named,
            'endKey',
            'valuesBetween',
          );
          return t.valuesBetween(startKey: startKey, endKey: endKey);
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'toMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedBox>(
          target,
          'IsolatedBox',
        );
        return t.toMap();
      },
    },
    methodSignatures: {
      'keyAt': 'Future keyAt(int index)',
      'watch': 'Stream<BoxEvent> watch({dynamic key})',
      'containsKey': 'Future<bool> containsKey(dynamic key)',
      'put': 'Future<void> put(dynamic key, E value)',
      'putAt': 'Future<void> putAt(int index, E value)',
      'putAll': 'Future<void> putAll(Map<dynamic, E> entries)',
      'add': 'Future<int> add(E value)',
      'addAll': 'Future<List<int>> addAll(Iterable<E> values)',
      'delete': 'Future<void> delete(dynamic key)',
      'deleteAt': 'Future<void> deleteAt(int index)',
      'deleteAll': 'Future<void> deleteAll(Iterable keys)',
      'compact': 'Future<void> compact()',
      'clear': 'Future<int> clear()',
      'close': 'Future<void> close()',
      'deleteFromDisk': 'Future<void> deleteFromDisk()',
      'flush': 'Future<void> flush()',
      'get': 'Future<E?> get(dynamic key, {E? defaultValue})',
      'getAt': 'Future<E?> getAt(int index)',
      'valuesBetween':
          'Future<Iterable<E>> valuesBetween({dynamic startKey, dynamic endKey})',
      'toMap': 'Future<Map<dynamic, E>> toMap()',
    },
    getterSignatures: {
      'name': 'String get name',
      'lazy': 'bool get lazy',
      'isOpen': 'bool get isOpen',
      'path': 'Future<String?> get path',
      'keys': 'Future<List<dynamic>> get keys',
      'length': 'Future<int> get length',
      'isEmpty': 'Future<bool> get isEmpty',
      'isNotEmpty': 'Future<bool> get isNotEmpty',
      'values': 'Future<Iterable<E>> get values',
    },
  );
}

// =============================================================================
// IsolatedLazyBox Bridge
// =============================================================================

BridgedClass _createIsolatedLazyBoxBridge() {
  return BridgedClass(
    nativeType: $dartnative_hive_15.IsolatedLazyBox,
    name: 'IsolatedLazyBox',
    isAssignable: (v) => v is $dartnative_hive_15.IsolatedLazyBox,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {},
    getters: {
      'name': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
            target,
            'IsolatedLazyBox',
          )
          .name,
      'lazy': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
            target,
            'IsolatedLazyBox',
          )
          .lazy,
      'isOpen': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
            target,
            'IsolatedLazyBox',
          )
          .isOpen,
      'path': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
            target,
            'IsolatedLazyBox',
          )
          .path,
      'keys': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
            target,
            'IsolatedLazyBox',
          )
          .keys,
      'length': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
            target,
            'IsolatedLazyBox',
          )
          .length,
      'isEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
            target,
            'IsolatedLazyBox',
          )
          .isEmpty,
      'isNotEmpty': (visitor, target) => D4
          .validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
            target,
            'IsolatedLazyBox',
          )
          .isNotEmpty,
    },
    methods: {
      'keyAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'keyAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'keyAt');
        return t.keyAt(index);
      },
      'watch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        if (!named.containsKey('key')) {
          return t.watch();
        }
        if (named.containsKey('key')) {
          final key = D4.getRequiredNamedArg<dynamic>(named, 'key', 'watch');
          return t.watch(key: key);
        }
        throw StateError(
          'Unreachable: all named parameter combinations should be covered',
        );
      },
      'containsKey': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'containsKey');
        final key = D4.getRequiredArg<dynamic>(
          positional,
          0,
          'key',
          'containsKey',
        );
        return t.containsKey(key);
      },
      'put': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 2, 'put');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'put');
        final value = D4.getRequiredArg<dynamic>(positional, 1, 'value', 'put');
        return t.put(key, value);
      },
      'putAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 2, 'putAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'putAt');
        final value = D4.getRequiredArg<dynamic>(
          positional,
          1,
          'value',
          'putAt',
        );
        return t.putAt(index, value);
      },
      'putAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'putAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'putAll: Missing required argument "entries" at position 0',
          );
        }
        final entries = D4.coerceMap<dynamic, dynamic>(
          positional[0],
          'entries',
        );
        return t.putAll(entries);
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'add');
        final value = D4.getRequiredArg<dynamic>(positional, 0, 'value', 'add');
        return t.add(value);
      },
      'addAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'addAll');
        if (positional.isEmpty) {
          throw ArgumentError(
            'addAll: Missing required argument "values" at position 0',
          );
        }
        final values = D4.coerceList<dynamic>(positional[0], 'values');
        return t.addAll(values);
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'delete');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'delete');
        return t.delete(key);
      },
      'deleteAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'deleteAt');
        final index = D4.getRequiredArg<int>(
          positional,
          0,
          'index',
          'deleteAt',
        );
        return t.deleteAt(index);
      },
      'deleteAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'deleteAll');
        final keys = D4.getRequiredArg<Iterable>(
          positional,
          0,
          'keys',
          'deleteAll',
        );
        return t.deleteAll(keys);
      },
      'compact': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        return t.compact();
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        return t.clear();
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        return t.close();
      },
      'deleteFromDisk': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        return t.deleteFromDisk();
      },
      'flush': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        return t.flush();
      },
      'get': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'get');
        final key = D4.getRequiredArg<dynamic>(positional, 0, 'key', 'get');
        final defaultValue = D4.getOptionalNamedArg<dynamic>(
          named,
          'defaultValue',
        );
        return t.get(key, defaultValue: defaultValue);
      },
      'getAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_hive_15.IsolatedLazyBox>(
          target,
          'IsolatedLazyBox',
        );
        D4.requireMinArgs(positional, 1, 'getAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'getAt');
        return t.getAt(index);
      },
    },
    methodSignatures: {
      'keyAt': 'Future keyAt(int index)',
      'watch': 'Stream<BoxEvent> watch({dynamic key})',
      'containsKey': 'Future<bool> containsKey(dynamic key)',
      'put': 'Future<void> put(dynamic key, E value)',
      'putAt': 'Future<void> putAt(int index, E value)',
      'putAll': 'Future<void> putAll(Map<dynamic, E> entries)',
      'add': 'Future<int> add(E value)',
      'addAll': 'Future<List<int>> addAll(Iterable<E> values)',
      'delete': 'Future<void> delete(dynamic key)',
      'deleteAt': 'Future<void> deleteAt(int index)',
      'deleteAll': 'Future<void> deleteAll(Iterable keys)',
      'compact': 'Future<void> compact()',
      'clear': 'Future<int> clear()',
      'close': 'Future<void> close()',
      'deleteFromDisk': 'Future<void> deleteFromDisk()',
      'flush': 'Future<void> flush()',
      'get': 'Future<E?> get(dynamic key, {E? defaultValue})',
      'getAt': 'Future<E?> getAt(int index)',
    },
    getterSignatures: {
      'name': 'String get name',
      'lazy': 'bool get lazy',
      'isOpen': 'bool get isOpen',
      'path': 'Future<String?> get path',
      'keys': 'Future<List<dynamic>> get keys',
      'length': 'Future<int> get length',
      'isEmpty': 'Future<bool> get isEmpty',
      'isNotEmpty': 'Future<bool> get isNotEmpty',
    },
  );
}

// D4rt Bridge - Generated file, do not edit
// Sources: 17 files
// Generated: 2026-11-01T03:47:39.003880 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';
import 'dart:async';
import 'dart:math' as $dart_math;
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/src/adapter.dart' as $dio_1;
import 'package:dio/src/cancel_token.dart' as $dio_2;
import 'package:dio/src/dio.dart' as $dio_3;
import 'package:dio/src/dio_exception.dart' as $dio_4;
import 'package:dio/src/dio_mixin.dart' as $dio_5;
import 'package:dio/src/form_data.dart' as $dio_6;
import 'package:dio/src/headers.dart' as $dio_7;
import 'package:dio/src/interceptors/log.dart' as $dio_8;
import 'package:dio/src/multipart_file.dart' as $dio_9;
import 'package:dio/src/options.dart' as $dio_10;
import 'package:dio/src/parameter.dart' as $dio_11;
import 'package:dio/src/redirect_record.dart' as $dio_12;
import 'package:dio/src/response.dart' as $dio_13;
import 'package:dio/src/transformer.dart' as $dio_14;
import 'package:dio/src/transformers/background_transformer.dart' as $dio_15;
import 'package:dio/src/transformers/fused_transformer.dart' as $dio_16;
import 'package:dio/src/transformers/sync_transformer.dart' as $dio_17;
import 'package:http_parser/src/media_type.dart' as $http_parser_1;

/// Bridge class for dio module.
class DioBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createHttpClientAdapterBridge(),
      _createResponseBodyBridge(),
      _createCancelTokenBridge(),
      _createDioBridge(),
      _createDioExceptionBridge(),
      _createDioMixinBridge(),
      _createNotNullableErrorBridge(),
      _createRequestInterceptorHandlerBridge(),
      _createResponseInterceptorHandlerBridge(),
      _createErrorInterceptorHandlerBridge(),
      _createInterceptorBridge(),
      _createInterceptorsWrapperBridge(),
      _createInterceptorsBridge(),
      _createQueuedInterceptorBridge(),
      _createQueuedInterceptorsWrapperBridge(),
      _createFormDataBridge(),
      _createHeadersBridge(),
      _createLogInterceptorBridge(),
      _createMultipartFileBridge(),
      _createBaseOptionsBridge(),
      _createOptionsBridge(),
      _createRequestOptionsBridge(),
      _createOptionsMixinBridge(),
      _createListParamBridge(),
      _createRedirectRecordBridge(),
      _createResponseBridge(),
      _createBackgroundTransformerBridge(),
      _createFusedTransformerBridge(),
      _createSyncTransformerBridge(),
      _createTransformerBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'HttpClientAdapter': _createHttpClientAdapterBridge,
      'ResponseBody': _createResponseBodyBridge,
      'CancelToken': _createCancelTokenBridge,
      'Dio': _createDioBridge,
      'DioException': _createDioExceptionBridge,
      'DioMixin': _createDioMixinBridge,
      'NotNullableError': _createNotNullableErrorBridge,
      'RequestInterceptorHandler': _createRequestInterceptorHandlerBridge,
      'ResponseInterceptorHandler': _createResponseInterceptorHandlerBridge,
      'ErrorInterceptorHandler': _createErrorInterceptorHandlerBridge,
      'Interceptor': _createInterceptorBridge,
      'InterceptorsWrapper': _createInterceptorsWrapperBridge,
      'Interceptors': _createInterceptorsBridge,
      'QueuedInterceptor': _createQueuedInterceptorBridge,
      'QueuedInterceptorsWrapper': _createQueuedInterceptorsWrapperBridge,
      'FormData': _createFormDataBridge,
      'Headers': _createHeadersBridge,
      'LogInterceptor': _createLogInterceptorBridge,
      'MultipartFile': _createMultipartFileBridge,
      'BaseOptions': _createBaseOptionsBridge,
      'Options': _createOptionsBridge,
      'RequestOptions': _createRequestOptionsBridge,
      'OptionsMixin': _createOptionsMixinBridge,
      'ListParam': _createListParamBridge,
      'RedirectRecord': _createRedirectRecordBridge,
      'Response': _createResponseBridge,
      'BackgroundTransformer': _createBackgroundTransformerBridge,
      'FusedTransformer': _createFusedTransformerBridge,
      'SyncTransformer': _createSyncTransformerBridge,
      'Transformer': _createTransformerBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'HttpClientAdapter': $dio_1.HttpClientAdapter,
      'ResponseBody': $dio_1.ResponseBody,
      'CancelToken': $dio_2.CancelToken,
      'Dio': $dio_3.Dio,
      'DioException': $dio_4.DioException,
      'DioMixin': $dio_5.DioMixin,
      'NotNullableError': $dio_5.NotNullableError,
      'RequestInterceptorHandler': $dio_5.RequestInterceptorHandler,
      'ResponseInterceptorHandler': $dio_5.ResponseInterceptorHandler,
      'ErrorInterceptorHandler': $dio_5.ErrorInterceptorHandler,
      'Interceptor': $dio_5.Interceptor,
      'InterceptorsWrapper': $dio_5.InterceptorsWrapper,
      'Interceptors': $dio_5.Interceptors,
      'QueuedInterceptor': $dio_5.QueuedInterceptor,
      'QueuedInterceptorsWrapper': $dio_5.QueuedInterceptorsWrapper,
      'FormData': $dio_6.FormData,
      'Headers': $dio_7.Headers,
      'LogInterceptor': $dio_8.LogInterceptor,
      'MultipartFile': $dio_9.MultipartFile,
      'BaseOptions': $dio_10.BaseOptions,
      'Options': $dio_10.Options,
      'RequestOptions': $dio_10.RequestOptions,
      'OptionsMixin': $dio_10.OptionsMixin,
      'ListParam': $dio_11.ListParam,
      'RedirectRecord': $dio_12.RedirectRecord,
      'Response': $dio_13.Response,
      'BackgroundTransformer': $dio_15.BackgroundTransformer,
      'FusedTransformer': $dio_16.FusedTransformer,
      'SyncTransformer': $dio_17.SyncTransformer,
      'Transformer': $dio_14.Transformer,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'HttpClientAdapter': 'package:dio/src/adapter.dart',
      'ResponseBody': 'package:dio/src/adapter.dart',
      'CancelToken': 'package:dio/src/cancel_token.dart',
      'Dio': 'package:dio/src/dio.dart',
      'DioException': 'package:dio/src/dio_exception.dart',
      'DioMixin': 'package:dio/src/dio_mixin.dart',
      'NotNullableError': 'package:dio/src/dio_mixin.dart',
      'RequestInterceptorHandler': 'package:dio/src/dio_mixin.dart',
      'ResponseInterceptorHandler': 'package:dio/src/dio_mixin.dart',
      'ErrorInterceptorHandler': 'package:dio/src/dio_mixin.dart',
      'Interceptor': 'package:dio/src/dio_mixin.dart',
      'InterceptorsWrapper': 'package:dio/src/dio_mixin.dart',
      'Interceptors': 'package:dio/src/dio_mixin.dart',
      'QueuedInterceptor': 'package:dio/src/dio_mixin.dart',
      'QueuedInterceptorsWrapper': 'package:dio/src/dio_mixin.dart',
      'FormData': 'package:dio/src/form_data.dart',
      'Headers': 'package:dio/src/headers.dart',
      'LogInterceptor': 'package:dio/src/interceptors/log.dart',
      'MultipartFile': 'package:dio/src/multipart_file.dart',
      'BaseOptions': 'package:dio/src/options.dart',
      'Options': 'package:dio/src/options.dart',
      'RequestOptions': 'package:dio/src/options.dart',
      'OptionsMixin': 'package:dio/src/options.dart',
      'ListParam': 'package:dio/src/parameter.dart',
      'RedirectRecord': 'package:dio/src/redirect_record.dart',
      'Response': 'package:dio/src/response.dart',
      'BackgroundTransformer': 'package:dio/src/transformers/background_transformer.dart',
      'FusedTransformer': 'package:dio/src/transformers/fused_transformer.dart',
      'SyncTransformer': 'package:dio/src/transformers/sync_transformer.dart',
      'Transformer': 'package:dio/src/transformer.dart',
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
      'DioException': ['Exception'],
      'DioMixin': ['Dio'],
      'NotNullableError': ['Error', 'TypeError'],
      'RequestInterceptorHandler': ['_BaseHandler'],
      'ResponseInterceptorHandler': ['_BaseHandler'],
      'ErrorInterceptorHandler': ['_BaseHandler'],
      'InterceptorsWrapper': ['Interceptor', '_InterceptorWrapperMixin'],
      'Interceptors': ['ListBase', 'List', 'Iterable', '_ListIterable', 'EfficientLengthIterable', 'HideEfficientLengthIterable'],
      'QueuedInterceptor': ['Interceptor'],
      'QueuedInterceptorsWrapper': ['QueuedInterceptor', 'Interceptor', '_InterceptorWrapperMixin'],
      'LogInterceptor': ['Interceptor'],
      'BaseOptions': ['_RequestConfig', 'OptionsMixin'],
      'RequestOptions': ['_RequestConfig', 'OptionsMixin'],
      'BackgroundTransformer': ['SyncTransformer', 'Transformer'],
      'FusedTransformer': ['Transformer'],
      'SyncTransformer': ['Transformer'],
    };
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {
      'DioErrorType': 'DioExceptionType',
      'DioError': 'DioException',
      'DioMediaType': 'MediaType',
      'DefaultTransformer': 'SyncTransformer',
    };
  }

  /// Returns the list of function typedef names declared in this library.
  ///
  /// Function typedefs like `typedef VoidCallback = void Function()` are
  /// registered so that they can be used as type arguments in D4rt scripts.
  static List<String> functionTypedefs() {
    return [
      'ProgressCallback',
      'DioExceptionReadableStringBuilder',
      'InterceptorSendCallback',
      'InterceptorSuccessCallback',
      'InterceptorErrorCallback',
      'HeaderForEachCallback',
      'ValidateStatus',
      'ResponseDecoder',
      'RequestEncoder',
      'JsonDecodeCallback',
      'JsonEncodeCallback',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dio_4.DioExceptionType>(
        name: 'DioExceptionType',
        values: $dio_4.DioExceptionType.values,
      ),
      BridgedEnumDefinition<$dio_10.ResponseType>(
        name: 'ResponseType',
        values: $dio_10.ResponseType.values,
      ),
      BridgedEnumDefinition<$dio_10.ListFormat>(
        name: 'ListFormat',
        values: $dio_10.ListFormat.values,
      ),
      BridgedEnumDefinition<$dio_10.FileAccessMode>(
        name: 'FileAccessMode',
        values: $dio_10.FileAccessMode.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'DioExceptionType': 'package:dio/src/dio_exception.dart',
      'ResponseType': 'package:dio/src/options.dart',
      'ListFormat': 'package:dio/src/options.dart',
      'FileAccessMode': 'package:dio/src/options.dart',
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
      (source: 'package:dio/dio.dart', target: 'package:dio/src/adapter.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/cancel_token.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/dio.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/dio_exception.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/dio_mixin.dart', show: null, hide: {'InterceptorState', 'InterceptorResultType'}),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/form_data.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/headers.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/interceptors/log.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/multipart_file.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/options.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/parameter.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/redirect_record.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/response.dart', show: null, hide: null),
      (source: 'package:dio/dio.dart', target: 'package:dio/src/transformer.dart', show: null, hide: null),
      (source: 'package:dio/src/transformer.dart', target: 'package:dio/src/transformers/background_transformer.dart', show: null, hide: null),
      (source: 'package:dio/src/transformer.dart', target: 'package:dio/src/transformers/fused_transformer.dart', show: null, hide: null),
      (source: 'package:dio/src/transformer.dart', target: 'package:dio/src/transformers/sync_transformer.dart', show: null, hide: null),
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
      interpreter.registerLibraryReExport(r.source, r.target, show: r.show, hide: r.hide);
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {
      'defaultDioExceptionReadableStringBuilder': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'defaultDioExceptionReadableStringBuilder');
        final e = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'e', 'defaultDioExceptionReadableStringBuilder');
        return $dio_4.defaultDioExceptionReadableStringBuilder(e);
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'defaultDioExceptionReadableStringBuilder': 'package:dio/src/dio_exception.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'defaultDioExceptionReadableStringBuilder': 'String defaultDioExceptionReadableStringBuilder(DioException e)',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dio/src/adapter.dart',
      'package:dio/src/cancel_token.dart',
      'package:dio/src/dio.dart',
      'package:dio/src/dio_exception.dart',
      'package:dio/src/dio_mixin.dart',
      'package:dio/src/form_data.dart',
      'package:dio/src/headers.dart',
      'package:dio/src/interceptors/log.dart',
      'package:dio/src/multipart_file.dart',
      'package:dio/src/options.dart',
      'package:dio/src/parameter.dart',
      'package:dio/src/redirect_record.dart',
      'package:dio/src/response.dart',
      'package:dio/src/transformer.dart',
      'package:dio/src/transformers/background_transformer.dart',
      'package:dio/src/transformers/fused_transformer.dart',
      'package:dio/src/transformers/sync_transformer.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dio/dio.dart';";
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
    'DioExceptionType',
    'ResponseType',
    'ListFormat',
    'FileAccessMode',
  ];

}

// =============================================================================
// HttpClientAdapter Bridge
// =============================================================================

BridgedClass _createHttpClientAdapterBridge() {
  return BridgedClass(
    nativeType: $dio_1.HttpClientAdapter,
    name: 'HttpClientAdapter',
    isAssignable: (v) => v is $dio_1.HttpClientAdapter,
    isAbstract: true,
    constructors: {
      '': (visitor, positional, named) {
        return $dio_1.HttpClientAdapter();
      },
    },
    methods: {
      'fetch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_1.HttpClientAdapter>(target, 'HttpClientAdapter');
        D4.requireMinArgs(positional, 3, 'fetch');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'fetch');
        final requestStream = D4.getRequiredArg<Stream<Uint8List>?>(positional, 1, 'requestStream', 'fetch');
        final cancelFuture = D4.getRequiredArg<Future<void>?>(positional, 2, 'cancelFuture', 'fetch');
        return t.fetch(options, requestStream, cancelFuture);
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_1.HttpClientAdapter>(target, 'HttpClientAdapter');
        final force = D4.getNamedArgWithDefault<bool>(named, 'force', false);
        t.close(force: force);
        return null;
      },
    },
    staticGetters: {
      'extraKeyHttpVersion': (visitor) => $dio_1.HttpClientAdapter.extraKeyHttpVersion,
    },
    constructorSignatures: {
      '': 'factory HttpClientAdapter()',
    },
    methodSignatures: {
      'fetch': 'Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture)',
      'close': 'void close({bool force = false})',
    },
    staticGetterSignatures: {
      'extraKeyHttpVersion': 'String get extraKeyHttpVersion',
    },
  );
}

// =============================================================================
// ResponseBody Bridge
// =============================================================================

BridgedClass _createResponseBodyBridge() {
  return BridgedClass(
    nativeType: $dio_1.ResponseBody,
    name: 'ResponseBody',
    isAssignable: (v) => v is $dio_1.ResponseBody,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'ResponseBody');
        final stream = D4.getRequiredArg<Stream<Uint8List>>(positional, 0, 'stream', 'ResponseBody');
        final statusCode = D4.getRequiredArg<int>(positional, 1, 'statusCode', 'ResponseBody');
        final statusMessage = D4.getOptionalNamedArg<String?>(named, 'statusMessage');
        final isRedirect = D4.getNamedArgWithDefault<bool>(named, 'isRedirect', false);
        final redirects = D4.coerceListOrNull<$dio_12.RedirectRecord>(named['redirects'], 'redirects');
        final onCloseRaw = named['onClose'];
        final headers = D4.coerceMapOrNull<String, List<String>>(named['headers'], 'headers');
        return $dio_1.ResponseBody(stream, statusCode, statusMessage: statusMessage, isRedirect: isRedirect, redirects: redirects, onClose: onCloseRaw == null ? null : () { D4.callInterpreterCallback(visitor!, onCloseRaw, []); }, headers: headers);
      },
      'fromString': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'ResponseBody');
        final text = D4.getRequiredArg<String>(positional, 0, 'text', 'ResponseBody');
        final statusCode = D4.getRequiredArg<int>(positional, 1, 'statusCode', 'ResponseBody');
        final statusMessage = D4.getOptionalNamedArg<String?>(named, 'statusMessage');
        final isRedirect = D4.getNamedArgWithDefault<bool>(named, 'isRedirect', false);
        final onCloseRaw = named['onClose'];
        final headers = D4.coerceMapOrNull<String, List<String>>(named['headers'], 'headers');
        return $dio_1.ResponseBody.fromString(text, statusCode, statusMessage: statusMessage, isRedirect: isRedirect, onClose: onCloseRaw == null ? null : () { D4.callInterpreterCallback(visitor!, onCloseRaw, []); }, headers: headers);
      },
      'fromBytes': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'ResponseBody');
        if (positional.isEmpty) {
          throw ArgumentError('ResponseBody: Missing required argument "bytes" at position 0');
        }
        final bytes = D4.coerceList<int>(positional[0], 'bytes');
        final statusCode = D4.getRequiredArg<int>(positional, 1, 'statusCode', 'ResponseBody');
        final statusMessage = D4.getOptionalNamedArg<String?>(named, 'statusMessage');
        final isRedirect = D4.getNamedArgWithDefault<bool>(named, 'isRedirect', false);
        final onCloseRaw = named['onClose'];
        final headers = D4.coerceMapOrNull<String, List<String>>(named['headers'], 'headers');
        return $dio_1.ResponseBody.fromBytes(bytes, statusCode, statusMessage: statusMessage, isRedirect: isRedirect, onClose: onCloseRaw == null ? null : () { D4.callInterpreterCallback(visitor!, onCloseRaw, []); }, headers: headers);
      },
    },
    getters: {
      'isRedirect': (visitor, target) => D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').isRedirect,
      'stream': (visitor, target) => D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').stream,
      'statusCode': (visitor, target) => D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').statusCode,
      'statusMessage': (visitor, target) => D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').statusMessage,
      'redirects': (visitor, target) => D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').redirects,
      'headers': (visitor, target) => D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').headers,
      'extra': (visitor, target) => D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').extra,
      'contentLength': (visitor, target) => D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').contentLength,
    },
    setters: {
      'stream': (visitor, target, value) => 
        D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').stream = D4.extractBridgedArg<Stream<Uint8List>>(value, 'stream'),
      'statusCode': (visitor, target, value) => 
        D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').statusCode = D4.extractBridgedArg<int>(value, 'statusCode'),
      'statusMessage': (visitor, target, value) => 
        D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').statusMessage = D4.extractBridgedArgOrNull<String>(value, 'statusMessage'),
      'redirects': (visitor, target, value) => 
        D4.validateTarget<$dio_1.ResponseBody>(target, 'ResponseBody').redirects = value == null ? null : D4.coerceList<$dio_12.RedirectRecord>(value, 'redirects'),
    },
    constructorSignatures: {
      '': 'ResponseBody(Stream<Uint8List> stream, int statusCode, {String? statusMessage, bool isRedirect = false, List<RedirectRecord>? redirects, void Function()? onClose, Map<String, List<String>>? headers})',
      'fromString': 'ResponseBody.fromString(String text, int statusCode, {String? statusMessage, bool isRedirect = false, void Function()? onClose, Map<String, List<String>>? headers})',
      'fromBytes': 'ResponseBody.fromBytes(List<int> bytes, int statusCode, {String? statusMessage, bool isRedirect = false, void Function()? onClose, Map<String, List<String>>? headers})',
    },
    getterSignatures: {
      'isRedirect': 'bool get isRedirect',
      'stream': 'Stream<Uint8List> get stream',
      'statusCode': 'int get statusCode',
      'statusMessage': 'String? get statusMessage',
      'redirects': 'List<RedirectRecord>? get redirects',
      'headers': 'Map<String, List<String>> get headers',
      'extra': 'Map<String, dynamic> get extra',
      'contentLength': 'int get contentLength',
    },
    setterSignatures: {
      'stream': 'set stream(dynamic value)',
      'statusCode': 'set statusCode(dynamic value)',
      'statusMessage': 'set statusMessage(dynamic value)',
      'redirects': 'set redirects(dynamic value)',
      'headers': 'set headers(dynamic value)',
      'extra': 'set extra(dynamic value)',
    },
  );
}

// =============================================================================
// CancelToken Bridge
// =============================================================================

BridgedClass _createCancelTokenBridge() {
  return BridgedClass(
    nativeType: $dio_2.CancelToken,
    name: 'CancelToken',
    isAssignable: (v) => v is $dio_2.CancelToken,
    constructors: {
      '': (visitor, positional, named) {
        return $dio_2.CancelToken();
      },
    },
    getters: {
      'requestOptions': (visitor, target) => D4.validateTarget<$dio_2.CancelToken>(target, 'CancelToken').requestOptions,
      'cancelError': (visitor, target) => D4.validateTarget<$dio_2.CancelToken>(target, 'CancelToken').cancelError,
      'isCancelled': (visitor, target) => D4.validateTarget<$dio_2.CancelToken>(target, 'CancelToken').isCancelled,
      'whenCancel': (visitor, target) => D4.validateTarget<$dio_2.CancelToken>(target, 'CancelToken').whenCancel,
    },
    setters: {
      'requestOptions': (visitor, target, value) => 
        D4.validateTarget<$dio_2.CancelToken>(target, 'CancelToken').requestOptions = D4.extractBridgedArgOrNull<$dio_10.RequestOptions>(value, 'requestOptions'),
    },
    methods: {
      'cancel': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_2.CancelToken>(target, 'CancelToken');
        final reason = D4.getOptionalArg<Object?>(positional, 0, 'reason');
        t.cancel(reason);
        return null;
      },
    },
    staticMethods: {
      'isCancel': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'isCancel');
        final error = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'error', 'isCancel');
        return $dio_2.CancelToken.isCancel(error);
      },
    },
    constructorSignatures: {
      '': 'CancelToken()',
    },
    methodSignatures: {
      'cancel': 'void cancel([Object? reason])',
    },
    getterSignatures: {
      'requestOptions': 'RequestOptions? get requestOptions',
      'cancelError': 'DioException? get cancelError',
      'isCancelled': 'bool get isCancelled',
      'whenCancel': 'Future<DioException> get whenCancel',
    },
    setterSignatures: {
      'requestOptions': 'set requestOptions(dynamic value)',
    },
    staticMethodSignatures: {
      'isCancel': 'bool isCancel(DioException error)',
    },
  );
}

// =============================================================================
// Dio Bridge
// =============================================================================

BridgedClass _createDioBridge() {
  return BridgedClass(
    nativeType: $dio_3.Dio,
    name: 'Dio',
    isAssignable: (v) => v is $dio_3.Dio,
    isAbstract: true,
    constructors: {
      '': (visitor, positional, named) {
        final options = D4.getOptionalArg<$dio_10.BaseOptions?>(positional, 0, 'options');
        return $dio_3.Dio(options);
      },
    },
    getters: {
      'options': (visitor, target) => D4.validateTarget<$dio_3.Dio>(target, 'Dio').options,
      'httpClientAdapter': (visitor, target) => D4.validateTarget<$dio_3.Dio>(target, 'Dio').httpClientAdapter,
      'transformer': (visitor, target) => D4.validateTarget<$dio_3.Dio>(target, 'Dio').transformer,
      'interceptors': (visitor, target) => D4.validateTarget<$dio_3.Dio>(target, 'Dio').interceptors,
    },
    setters: {
      'options': (visitor, target, value) => 
        D4.validateTarget<$dio_3.Dio>(target, 'Dio').options = D4.extractBridgedArg<$dio_10.BaseOptions>(value, 'options'),
      'httpClientAdapter': (visitor, target, value) => 
        D4.validateTarget<$dio_3.Dio>(target, 'Dio').httpClientAdapter = D4.extractBridgedArg<$dio_1.HttpClientAdapter>(value, 'httpClientAdapter'),
      'transformer': (visitor, target, value) => 
        D4.validateTarget<$dio_3.Dio>(target, 'Dio').transformer = D4.extractBridgedArg<$dio_14.Transformer>(value, 'transformer'),
    },
    methods: {
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        final force = D4.getNamedArgWithDefault<bool>(named, 'force', false);
        t.close(force: force);
        return null;
      },
      'head': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'head');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'head');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        return t.head(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      },
      'headUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'headUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'headUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        return t.headUri(uri, data: data, options: options, cancelToken: cancelToken);
      },
      'get': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'get');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'get');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.get(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'getUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'getUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'getUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.getUri(uri, data: data, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'post': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'post');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'post');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.post(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'postUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'postUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'postUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.postUri(uri, data: data, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'put': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'put');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'put');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.put(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'putUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'putUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'putUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.putUri(uri, data: data, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'patch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'patch');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'patch');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.patch(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'patchUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'patchUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'patchUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.patchUri(uri, data: data, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'delete');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'delete');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        return t.delete(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      },
      'deleteUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'deleteUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'deleteUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        return t.deleteUri(uri, data: data, options: options, cancelToken: cancelToken);
      },
      'query': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'query');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'query');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.query(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'queryUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'queryUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'queryUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.queryUri(uri, data: data, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'download': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 2, 'download');
        final urlPath = D4.getRequiredArg<String>(positional, 0, 'urlPath', 'download');
        final savePath = D4.getRequiredArg<dynamic>(positional, 1, 'savePath', 'download');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final deleteOnError = D4.getNamedArgWithDefault<bool>(named, 'deleteOnError', true);
        final fileAccessMode = D4.getNamedArgWithDefault<$dio_10.FileAccessMode>(named, 'fileAccessMode', $dio_10.FileAccessMode.write);
        final lengthHeader = D4.getNamedArgWithDefault<String>(named, 'lengthHeader', $dio_7.Headers.contentLengthHeader);
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        return t.download(urlPath, savePath, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); }, queryParameters: queryParameters, cancelToken: cancelToken, deleteOnError: deleteOnError, fileAccessMode: fileAccessMode, lengthHeader: lengthHeader, data: data, options: options);
      },
      'downloadUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 2, 'downloadUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'downloadUri');
        final savePath = D4.getRequiredArg<dynamic>(positional, 1, 'savePath', 'downloadUri');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final deleteOnError = D4.getNamedArgWithDefault<bool>(named, 'deleteOnError', true);
        final fileAccessMode = D4.getNamedArgWithDefault<$dio_10.FileAccessMode>(named, 'fileAccessMode', $dio_10.FileAccessMode.write);
        final lengthHeader = D4.getNamedArgWithDefault<String>(named, 'lengthHeader', $dio_7.Headers.contentLengthHeader);
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        return t.downloadUri(uri, savePath, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); }, cancelToken: cancelToken, deleteOnError: deleteOnError, fileAccessMode: fileAccessMode, lengthHeader: lengthHeader, data: data, options: options);
      },
      'request': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'request');
        final url = D4.getRequiredArg<String>(positional, 0, 'url', 'request');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.request(url, data: data, queryParameters: queryParameters, cancelToken: cancelToken, options: options, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'requestUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'requestUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'requestUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.requestUri(uri, data: data, cancelToken: cancelToken, options: options, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'fetch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        D4.requireMinArgs(positional, 1, 'fetch');
        final requestOptions = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'requestOptions', 'fetch');
        return t.fetch(requestOptions);
      },
      'clone': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_3.Dio>(target, 'Dio');
        final options = D4.getOptionalNamedArg<$dio_10.BaseOptions?>(named, 'options');
        final interceptors = D4.getOptionalNamedArg<$dio_5.Interceptors?>(named, 'interceptors');
        final httpClientAdapter = D4.getOptionalNamedArg<$dio_1.HttpClientAdapter?>(named, 'httpClientAdapter');
        final transformer = D4.getOptionalNamedArg<$dio_14.Transformer?>(named, 'transformer');
        return t.clone(options: options, interceptors: interceptors, httpClientAdapter: httpClientAdapter, transformer: transformer);
      },
    },
    constructorSignatures: {
      '': 'factory Dio([BaseOptions? options])',
    },
    methodSignatures: {
      'close': 'void close({bool force = false})',
      'head': 'Future<Response<T>> head(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken})',
      'headUri': 'Future<Response<T>> headUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken})',
      'get': 'Future<Response<T>> get(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onReceiveProgress})',
      'getUri': 'Future<Response<T>> getUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onReceiveProgress})',
      'post': 'Future<Response<T>> post(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'postUri': 'Future<Response<T>> postUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'put': 'Future<Response<T>> put(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'putUri': 'Future<Response<T>> putUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'patch': 'Future<Response<T>> patch(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'patchUri': 'Future<Response<T>> patchUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'delete': 'Future<Response<T>> delete(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken})',
      'deleteUri': 'Future<Response<T>> deleteUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken})',
      'query': 'Future<Response<T>> query(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'queryUri': 'Future<Response<T>> queryUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'download': 'Future<Response> download(String urlPath, dynamic savePath, {ProgressCallback? onReceiveProgress, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, bool deleteOnError = true, FileAccessMode fileAccessMode = FileAccessMode.write, String lengthHeader = Headers.contentLengthHeader, Object? data, Options? options})',
      'downloadUri': 'Future<Response> downloadUri(Uri uri, dynamic savePath, {ProgressCallback? onReceiveProgress, CancelToken? cancelToken, bool deleteOnError = true, FileAccessMode fileAccessMode = FileAccessMode.write, String lengthHeader = Headers.contentLengthHeader, Object? data, Options? options})',
      'request': 'Future<Response<T>> request(String url, {Object? data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'requestUri': 'Future<Response<T>> requestUri(Uri uri, {Object? data, CancelToken? cancelToken, Options? options, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'fetch': 'Future<Response<T>> fetch(RequestOptions requestOptions)',
      'clone': 'Dio clone({BaseOptions? options, Interceptors? interceptors, HttpClientAdapter? httpClientAdapter, Transformer? transformer})',
    },
    getterSignatures: {
      'options': 'BaseOptions get options',
      'httpClientAdapter': 'HttpClientAdapter get httpClientAdapter',
      'transformer': 'Transformer get transformer',
      'interceptors': 'Interceptors get interceptors',
    },
    setterSignatures: {
      'options': 'set options(dynamic value)',
      'httpClientAdapter': 'set httpClientAdapter(dynamic value)',
      'transformer': 'set transformer(dynamic value)',
    },
  );
}

// =============================================================================
// DioException Bridge
// =============================================================================

BridgedClass _createDioExceptionBridge() {
  return BridgedClass(
    nativeType: $dio_4.DioException,
    name: 'DioException',
    isAssignable: (v) => v is $dio_4.DioException,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'DioException');
        final response = D4.getOptionalNamedArg<$dio_13.Response?>(named, 'response');
        final type = D4.getNamedArgWithDefault<$dio_4.DioExceptionType>(named, 'type', $dio_4.DioExceptionType.unknown);
        final error = D4.getOptionalNamedArg<Object?>(named, 'error');
        final stackTrace = D4.getOptionalNamedArg<StackTrace?>(named, 'stackTrace');
        final message = D4.getOptionalNamedArg<String?>(named, 'message');
        return $dio_4.DioException(requestOptions: requestOptions, response: response, type: type, error: error, stackTrace: stackTrace, message: message);
      },
      'badResponse': (visitor, positional, named) {
        final statusCode = D4.getRequiredNamedArg<int>(named, 'statusCode', 'DioException');
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'DioException');
        final response = D4.getRequiredNamedArg<$dio_13.Response>(named, 'response', 'DioException');
        return $dio_4.DioException.badResponse(statusCode: statusCode, requestOptions: requestOptions, response: response);
      },
      'connectionTimeout': (visitor, positional, named) {
        final timeout = D4.getRequiredNamedArg<Duration>(named, 'timeout', 'DioException');
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'DioException');
        final error = D4.getOptionalNamedArg<Object?>(named, 'error');
        return $dio_4.DioException.connectionTimeout(timeout: timeout, requestOptions: requestOptions, error: error);
      },
      'sendTimeout': (visitor, positional, named) {
        final timeout = D4.getRequiredNamedArg<Duration>(named, 'timeout', 'DioException');
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'DioException');
        return $dio_4.DioException.sendTimeout(timeout: timeout, requestOptions: requestOptions);
      },
      'receiveTimeout': (visitor, positional, named) {
        final timeout = D4.getRequiredNamedArg<Duration>(named, 'timeout', 'DioException');
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'DioException');
        final error = D4.getOptionalNamedArg<Object?>(named, 'error');
        return $dio_4.DioException.receiveTimeout(timeout: timeout, requestOptions: requestOptions, error: error);
      },
      'transformTimeout': (visitor, positional, named) {
        final timeout = D4.getRequiredNamedArg<Duration>(named, 'timeout', 'DioException');
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'DioException');
        final error = D4.getOptionalNamedArg<Object?>(named, 'error');
        return $dio_4.DioException.transformTimeout(timeout: timeout, requestOptions: requestOptions, error: error);
      },
      'badCertificate': (visitor, positional, named) {
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'DioException');
        final error = D4.getOptionalNamedArg<Object?>(named, 'error');
        return $dio_4.DioException.badCertificate(requestOptions: requestOptions, error: error);
      },
      'requestCancelled': (visitor, positional, named) {
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'DioException');
        final reason = D4.getRequiredNamedArg<Object?>(named, 'reason', 'DioException');
        final stackTrace = D4.getOptionalNamedArg<StackTrace?>(named, 'stackTrace');
        return $dio_4.DioException.requestCancelled(requestOptions: requestOptions, reason: reason, stackTrace: stackTrace);
      },
      'connectionError': (visitor, positional, named) {
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'DioException');
        final reason = D4.getRequiredNamedArg<String>(named, 'reason', 'DioException');
        final error = D4.getOptionalNamedArg<Object?>(named, 'error');
        final stackTrace = D4.getOptionalNamedArg<StackTrace?>(named, 'stackTrace');
        return $dio_4.DioException.connectionError(requestOptions: requestOptions, reason: reason, error: error, stackTrace: stackTrace);
      },
    },
    getters: {
      'requestOptions': (visitor, target) => D4.validateTarget<$dio_4.DioException>(target, 'DioException').requestOptions,
      'response': (visitor, target) => D4.validateTarget<$dio_4.DioException>(target, 'DioException').response,
      'type': (visitor, target) => D4.validateTarget<$dio_4.DioException>(target, 'DioException').type,
      'error': (visitor, target) => D4.validateTarget<$dio_4.DioException>(target, 'DioException').error,
      'stackTrace': (visitor, target) => D4.validateTarget<$dio_4.DioException>(target, 'DioException').stackTrace,
      'message': (visitor, target) => D4.validateTarget<$dio_4.DioException>(target, 'DioException').message,
      'stringBuilder': (visitor, target) => D4.validateTarget<$dio_4.DioException>(target, 'DioException').stringBuilder,
    },
    setters: {
      'stringBuilder': (visitor, target, value) {
        final stringBuilderRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'stringBuilder');
        D4.validateTarget<$dio_4.DioException>(target, 'DioException').stringBuilder = stringBuilderRaw == null ? null : (($dio_4.DioException p0) { return D4.callInterpreterCallback(visitor!, stringBuilderRaw, [p0]) as String; }) as String Function($dio_4.DioException);
      },
    },
    methods: {
      'copyWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_4.DioException>(target, 'DioException');
        final requestOptions = D4.getOptionalNamedArg<$dio_10.RequestOptions?>(named, 'requestOptions');
        final response = D4.getOptionalNamedArg<$dio_13.Response?>(named, 'response');
        final type = D4.getOptionalNamedArg<$dio_4.DioExceptionType?>(named, 'type');
        final error = D4.getOptionalNamedArg<Object?>(named, 'error');
        final stackTrace = D4.getOptionalNamedArg<StackTrace?>(named, 'stackTrace');
        final message = D4.getOptionalNamedArg<String?>(named, 'message');
        return t.copyWith(requestOptions: requestOptions, response: response, type: type, error: error, stackTrace: stackTrace, message: message);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_4.DioException>(target, 'DioException');
        return t.toString();
      },
    },
    staticGetters: {
      'readableStringBuilder': (visitor) => $dio_4.DioException.readableStringBuilder,
    },
    staticSetters: {
      'readableStringBuilder': (visitor, value) {
        final readableStringBuilderRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'readableStringBuilder');
        $dio_4.DioException.readableStringBuilder = (($dio_4.DioException p0) { return D4.callInterpreterCallback(visitor!, readableStringBuilderRaw, [p0]) as String; }) as String Function($dio_4.DioException);
      },
    },
    constructorSignatures: {
      '': 'DioException({required RequestOptions requestOptions, Response? response, DioExceptionType type = DioExceptionType.unknown, Object? error, StackTrace? stackTrace, String? message})',
      'badResponse': 'factory DioException.badResponse({required int statusCode, required RequestOptions requestOptions, required Response response})',
      'connectionTimeout': 'factory DioException.connectionTimeout({required Duration timeout, required RequestOptions requestOptions, Object? error})',
      'sendTimeout': 'factory DioException.sendTimeout({required Duration timeout, required RequestOptions requestOptions})',
      'receiveTimeout': 'factory DioException.receiveTimeout({required Duration timeout, required RequestOptions requestOptions, Object? error})',
      'transformTimeout': 'factory DioException.transformTimeout({required Duration timeout, required RequestOptions requestOptions, Object? error})',
      'badCertificate': 'factory DioException.badCertificate({required RequestOptions requestOptions, Object? error})',
      'requestCancelled': 'factory DioException.requestCancelled({required RequestOptions requestOptions, required Object? reason, StackTrace? stackTrace})',
      'connectionError': 'factory DioException.connectionError({required RequestOptions requestOptions, required String reason, Object? error, StackTrace? stackTrace})',
    },
    methodSignatures: {
      'copyWith': 'DioException copyWith({RequestOptions? requestOptions, Response? response, DioExceptionType? type, Object? error, StackTrace? stackTrace, String? message})',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'requestOptions': 'RequestOptions get requestOptions',
      'response': 'Response? get response',
      'type': 'DioExceptionType get type',
      'error': 'Object? get error',
      'stackTrace': 'StackTrace get stackTrace',
      'message': 'String? get message',
      'stringBuilder': 'DioExceptionReadableStringBuilder? get stringBuilder',
    },
    setterSignatures: {
      'stringBuilder': 'set stringBuilder(dynamic value)',
    },
    staticGetterSignatures: {
      'readableStringBuilder': 'DioExceptionReadableStringBuilder get readableStringBuilder',
    },
    staticSetterSignatures: {
      'readableStringBuilder': 'set readableStringBuilder(dynamic value)',
    },
  );
}

// =============================================================================
// DioMixin Bridge
// =============================================================================

BridgedClass _createDioMixinBridge() {
  return BridgedClass(
    nativeType: $dio_5.DioMixin,
    name: 'DioMixin',
    isAssignable: (v) => v is $dio_5.DioMixin,
    hierarchyDepth: 1,
    isAbstract: true,
    constructors: {
    },
    getters: {
      'options': (visitor, target) => D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin').options,
      'httpClientAdapter': (visitor, target) => D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin').httpClientAdapter,
      'transformer': (visitor, target) => D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin').transformer,
      'interceptors': (visitor, target) => D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin').interceptors,
    },
    setters: {
      'options': (visitor, target, value) => 
        D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin').options = D4.extractBridgedArg<$dio_10.BaseOptions>(value, 'options'),
      'httpClientAdapter': (visitor, target, value) => 
        D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin').httpClientAdapter = D4.extractBridgedArg<$dio_1.HttpClientAdapter>(value, 'httpClientAdapter'),
      'transformer': (visitor, target, value) => 
        D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin').transformer = D4.extractBridgedArg<$dio_14.Transformer>(value, 'transformer'),
    },
    methods: {
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        final force = D4.getNamedArgWithDefault<bool>(named, 'force', false);
        t.close(force: force);
        return null;
      },
      'get': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'get');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'get');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.get(path, queryParameters: queryParameters, data: data, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'getUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'getUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'getUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.getUri(uri, data: data, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'post': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'post');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'post');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.post(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'postUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'postUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'postUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.postUri(uri, data: data, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'put': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'put');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'put');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.put(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'putUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'putUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'putUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.putUri(uri, data: data, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'head': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'head');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'head');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        return t.head(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      },
      'headUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'headUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'headUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        return t.headUri(uri, data: data, options: options, cancelToken: cancelToken);
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'delete');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'delete');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        return t.delete(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      },
      'deleteUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'deleteUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'deleteUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        return t.deleteUri(uri, data: data, options: options, cancelToken: cancelToken);
      },
      'patch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'patch');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'patch');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.patch(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'patchUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'patchUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'patchUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.patchUri(uri, data: data, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'query': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'query');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'query');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.query(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'queryUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'queryUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'queryUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.queryUri(uri, data: data, options: options, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'downloadUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 2, 'downloadUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'downloadUri');
        final savePath = D4.getRequiredArg<dynamic>(positional, 1, 'savePath', 'downloadUri');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final deleteOnError = D4.getNamedArgWithDefault<bool>(named, 'deleteOnError', true);
        final fileAccessMode = D4.getNamedArgWithDefault<$dio_10.FileAccessMode>(named, 'fileAccessMode', $dio_10.FileAccessMode.write);
        final lengthHeader = D4.getNamedArgWithDefault<String>(named, 'lengthHeader', $dio_7.Headers.contentLengthHeader);
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        return t.downloadUri(uri, savePath, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); }, cancelToken: cancelToken, deleteOnError: deleteOnError, fileAccessMode: fileAccessMode, lengthHeader: lengthHeader, data: data, options: options);
      },
      'download': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 2, 'download');
        final urlPath = D4.getRequiredArg<String>(positional, 0, 'urlPath', 'download');
        final savePath = D4.getRequiredArg<dynamic>(positional, 1, 'savePath', 'download');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final deleteOnError = D4.getNamedArgWithDefault<bool>(named, 'deleteOnError', true);
        final fileAccessMode = D4.getNamedArgWithDefault<$dio_10.FileAccessMode>(named, 'fileAccessMode', $dio_10.FileAccessMode.write);
        final lengthHeader = D4.getNamedArgWithDefault<String>(named, 'lengthHeader', $dio_7.Headers.contentLengthHeader);
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        return t.download(urlPath, savePath, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); }, queryParameters: queryParameters, cancelToken: cancelToken, deleteOnError: deleteOnError, fileAccessMode: fileAccessMode, lengthHeader: lengthHeader, data: data, options: options);
      },
      'requestUri': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'requestUri');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'requestUri');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.requestUri(uri, data: data, cancelToken: cancelToken, options: options, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'request': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'request');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'request');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final options = D4.getOptionalNamedArg<$dio_10.Options?>(named, 'options');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        return t.request(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken, options: options, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); });
      },
      'fetch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        D4.requireMinArgs(positional, 1, 'fetch');
        final requestOptions = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'requestOptions', 'fetch');
        return t.fetch(requestOptions);
      },
      'clone': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.DioMixin>(target, 'DioMixin');
        final options = D4.getOptionalNamedArg<$dio_10.BaseOptions?>(named, 'options');
        final interceptors = D4.getOptionalNamedArg<$dio_5.Interceptors?>(named, 'interceptors');
        final httpClientAdapter = D4.getOptionalNamedArg<$dio_1.HttpClientAdapter?>(named, 'httpClientAdapter');
        final transformer = D4.getOptionalNamedArg<$dio_14.Transformer?>(named, 'transformer');
        return t.clone(options: options, interceptors: interceptors, httpClientAdapter: httpClientAdapter, transformer: transformer);
      },
    },
    methodSignatures: {
      'close': 'void close({bool force = false})',
      'get': 'Future<Response<T>> get(String path, {Map<String, dynamic>? queryParameters, Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onReceiveProgress})',
      'getUri': 'Future<Response<T>> getUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onReceiveProgress})',
      'post': 'Future<Response<T>> post(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'postUri': 'Future<Response<T>> postUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'put': 'Future<Response<T>> put(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'putUri': 'Future<Response<T>> putUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'head': 'Future<Response<T>> head(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken})',
      'headUri': 'Future<Response<T>> headUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken})',
      'delete': 'Future<Response<T>> delete(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken})',
      'deleteUri': 'Future<Response<T>> deleteUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken})',
      'patch': 'Future<Response<T>> patch(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'patchUri': 'Future<Response<T>> patchUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'query': 'Future<Response<T>> query(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'queryUri': 'Future<Response<T>> queryUri(Uri uri, {Object? data, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'downloadUri': 'Future<Response> downloadUri(Uri uri, dynamic savePath, {ProgressCallback? onReceiveProgress, CancelToken? cancelToken, bool deleteOnError = true, FileAccessMode fileAccessMode = FileAccessMode.write, String lengthHeader = Headers.contentLengthHeader, Object? data, Options? options})',
      'download': 'Future<Response> download(String urlPath, dynamic savePath, {ProgressCallback? onReceiveProgress, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, bool deleteOnError = true, FileAccessMode fileAccessMode = FileAccessMode.write, String lengthHeader = Headers.contentLengthHeader, Object? data, Options? options})',
      'requestUri': 'Future<Response<T>> requestUri(Uri uri, {Object? data, CancelToken? cancelToken, Options? options, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'request': 'Future<Response<T>> request(String path, {Object? data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress})',
      'fetch': 'Future<Response<T>> fetch(RequestOptions requestOptions)',
      'clone': 'Dio clone({BaseOptions? options, Interceptors? interceptors, HttpClientAdapter? httpClientAdapter, Transformer? transformer})',
    },
    getterSignatures: {
      'options': 'BaseOptions get options',
      'httpClientAdapter': 'HttpClientAdapter get httpClientAdapter',
      'transformer': 'Transformer get transformer',
      'interceptors': 'Interceptors get interceptors',
    },
    setterSignatures: {
      'options': 'set options(dynamic value)',
      'httpClientAdapter': 'set httpClientAdapter(dynamic value)',
      'transformer': 'set transformer(dynamic value)',
    },
  );
}

// =============================================================================
// NotNullableError Bridge
// =============================================================================

BridgedClass _createNotNullableErrorBridge() {
  return BridgedClass(
    nativeType: $dio_5.NotNullableError,
    name: 'NotNullableError',
    isAssignable: (v) => v is $dio_5.NotNullableError,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'NotNullableError');
        final name = D4.getRequiredArg<String>(positional, 0, '_name', 'NotNullableError');
        return $dio_5.NotNullableError(name);
      },
    },
    getters: {
      'stackTrace': (visitor, target) => D4.validateTarget<$dio_5.NotNullableError>(target, 'NotNullableError').stackTrace,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.NotNullableError>(target, 'NotNullableError');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'NotNullableError(String _name)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'stackTrace': 'StackTrace? get stackTrace',
    },
  );
}

// =============================================================================
// RequestInterceptorHandler Bridge
// =============================================================================

BridgedClass _createRequestInterceptorHandlerBridge() {
  return BridgedClass(
    nativeType: $dio_5.RequestInterceptorHandler,
    name: 'RequestInterceptorHandler',
    isAssignable: (v) => v is $dio_5.RequestInterceptorHandler,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        return $dio_5.RequestInterceptorHandler();
      },
    },
    getters: {
      'future': (visitor, target) => D4.validateTarget<$dio_5.RequestInterceptorHandler>(target, 'RequestInterceptorHandler').future,
      'isCompleted': (visitor, target) => D4.validateTarget<$dio_5.RequestInterceptorHandler>(target, 'RequestInterceptorHandler').isCompleted,
    },
    methods: {
      'next': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.RequestInterceptorHandler>(target, 'RequestInterceptorHandler');
        D4.requireMinArgs(positional, 1, 'next');
        final requestOptions = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'requestOptions', 'next');
        t.next(requestOptions);
        return null;
      },
      'resolve': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.RequestInterceptorHandler>(target, 'RequestInterceptorHandler');
        D4.requireMinArgs(positional, 1, 'resolve');
        final response = D4.getRequiredArg<$dio_13.Response>(positional, 0, 'response', 'resolve');
        final callFollowingResponseInterceptor = D4.getOptionalArgWithDefault<bool>(positional, 1, 'callFollowingResponseInterceptor', false);
        t.resolve(response, callFollowingResponseInterceptor);
        return null;
      },
      'reject': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.RequestInterceptorHandler>(target, 'RequestInterceptorHandler');
        D4.requireMinArgs(positional, 1, 'reject');
        final error = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'error', 'reject');
        final callFollowingErrorInterceptor = D4.getOptionalArgWithDefault<bool>(positional, 1, 'callFollowingErrorInterceptor', false);
        t.reject(error, callFollowingErrorInterceptor);
        return null;
      },
    },
    constructorSignatures: {
      '': 'RequestInterceptorHandler()',
    },
    methodSignatures: {
      'next': 'void next(RequestOptions requestOptions)',
      'resolve': 'void resolve(Response response, [bool callFollowingResponseInterceptor = false])',
      'reject': 'void reject(DioException error, [bool callFollowingErrorInterceptor = false])',
    },
    getterSignatures: {
      'future': 'Future<InterceptorState> get future',
      'isCompleted': 'bool get isCompleted',
    },
  );
}

// =============================================================================
// ResponseInterceptorHandler Bridge
// =============================================================================

BridgedClass _createResponseInterceptorHandlerBridge() {
  return BridgedClass(
    nativeType: $dio_5.ResponseInterceptorHandler,
    name: 'ResponseInterceptorHandler',
    isAssignable: (v) => v is $dio_5.ResponseInterceptorHandler,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        return $dio_5.ResponseInterceptorHandler();
      },
    },
    getters: {
      'future': (visitor, target) => D4.validateTarget<$dio_5.ResponseInterceptorHandler>(target, 'ResponseInterceptorHandler').future,
      'isCompleted': (visitor, target) => D4.validateTarget<$dio_5.ResponseInterceptorHandler>(target, 'ResponseInterceptorHandler').isCompleted,
    },
    methods: {
      'next': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.ResponseInterceptorHandler>(target, 'ResponseInterceptorHandler');
        D4.requireMinArgs(positional, 1, 'next');
        final response = D4.getRequiredArg<$dio_13.Response>(positional, 0, 'response', 'next');
        t.next(response);
        return null;
      },
      'resolve': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.ResponseInterceptorHandler>(target, 'ResponseInterceptorHandler');
        D4.requireMinArgs(positional, 1, 'resolve');
        final response = D4.getRequiredArg<$dio_13.Response>(positional, 0, 'response', 'resolve');
        t.resolve(response);
        return null;
      },
      'reject': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.ResponseInterceptorHandler>(target, 'ResponseInterceptorHandler');
        D4.requireMinArgs(positional, 1, 'reject');
        final error = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'error', 'reject');
        final callFollowingErrorInterceptor = D4.getOptionalArgWithDefault<bool>(positional, 1, 'callFollowingErrorInterceptor', false);
        t.reject(error, callFollowingErrorInterceptor);
        return null;
      },
    },
    constructorSignatures: {
      '': 'ResponseInterceptorHandler()',
    },
    methodSignatures: {
      'next': 'void next(Response response)',
      'resolve': 'void resolve(Response response)',
      'reject': 'void reject(DioException error, [bool callFollowingErrorInterceptor = false])',
    },
    getterSignatures: {
      'future': 'Future<InterceptorState> get future',
      'isCompleted': 'bool get isCompleted',
    },
  );
}

// =============================================================================
// ErrorInterceptorHandler Bridge
// =============================================================================

BridgedClass _createErrorInterceptorHandlerBridge() {
  return BridgedClass(
    nativeType: $dio_5.ErrorInterceptorHandler,
    name: 'ErrorInterceptorHandler',
    isAssignable: (v) => v is $dio_5.ErrorInterceptorHandler,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        return $dio_5.ErrorInterceptorHandler();
      },
    },
    getters: {
      'future': (visitor, target) => D4.validateTarget<$dio_5.ErrorInterceptorHandler>(target, 'ErrorInterceptorHandler').future,
      'isCompleted': (visitor, target) => D4.validateTarget<$dio_5.ErrorInterceptorHandler>(target, 'ErrorInterceptorHandler').isCompleted,
    },
    methods: {
      'next': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.ErrorInterceptorHandler>(target, 'ErrorInterceptorHandler');
        D4.requireMinArgs(positional, 1, 'next');
        final error = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'error', 'next');
        t.next(error);
        return null;
      },
      'resolve': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.ErrorInterceptorHandler>(target, 'ErrorInterceptorHandler');
        D4.requireMinArgs(positional, 1, 'resolve');
        final response = D4.getRequiredArg<$dio_13.Response>(positional, 0, 'response', 'resolve');
        t.resolve(response);
        return null;
      },
      'reject': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.ErrorInterceptorHandler>(target, 'ErrorInterceptorHandler');
        D4.requireMinArgs(positional, 1, 'reject');
        final error = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'error', 'reject');
        final callFollowingErrorInterceptor = D4.getOptionalArgWithDefault<bool>(positional, 1, 'callFollowingErrorInterceptor', false);
        t.reject(error, callFollowingErrorInterceptor);
        return null;
      },
    },
    constructorSignatures: {
      '': 'ErrorInterceptorHandler()',
    },
    methodSignatures: {
      'next': 'void next(DioException error)',
      'resolve': 'void resolve(Response response)',
      'reject': 'void reject(DioException error, [bool callFollowingErrorInterceptor = false])',
    },
    getterSignatures: {
      'future': 'Future<InterceptorState> get future',
      'isCompleted': 'bool get isCompleted',
    },
  );
}

// =============================================================================
// Interceptor Bridge
// =============================================================================

BridgedClass _createInterceptorBridge() {
  return BridgedClass(
    nativeType: $dio_5.Interceptor,
    name: 'Interceptor',
    isAssignable: (v) => v is $dio_5.Interceptor,
    constructors: {
      '': (visitor, positional, named) {
        return $dio_5.Interceptor();
      },
    },
    methods: {
      'onRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptor>(target, 'Interceptor');
        D4.requireMinArgs(positional, 2, 'onRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'onRequest');
        final handler = D4.getRequiredArg<$dio_5.RequestInterceptorHandler>(positional, 1, 'handler', 'onRequest');
        t.onRequest(options, handler);
        return null;
      },
      'onResponse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptor>(target, 'Interceptor');
        D4.requireMinArgs(positional, 2, 'onResponse');
        final response = D4.getRequiredArg<$dio_13.Response>(positional, 0, 'response', 'onResponse');
        final handler = D4.getRequiredArg<$dio_5.ResponseInterceptorHandler>(positional, 1, 'handler', 'onResponse');
        t.onResponse(response, handler);
        return null;
      },
      'onError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptor>(target, 'Interceptor');
        D4.requireMinArgs(positional, 2, 'onError');
        final err = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'err', 'onError');
        final handler = D4.getRequiredArg<$dio_5.ErrorInterceptorHandler>(positional, 1, 'handler', 'onError');
        t.onError(err, handler);
        return null;
      },
    },
    constructorSignatures: {
      '': 'const Interceptor()',
    },
    methodSignatures: {
      'onRequest': 'void onRequest(RequestOptions options, RequestInterceptorHandler handler)',
      'onResponse': 'void onResponse(Response response, ResponseInterceptorHandler handler)',
      'onError': 'void onError(DioException err, ErrorInterceptorHandler handler)',
    },
  );
}

// =============================================================================
// InterceptorsWrapper Bridge
// =============================================================================

BridgedClass _createInterceptorsWrapperBridge() {
  return BridgedClass(
    nativeType: $dio_5.InterceptorsWrapper,
    name: 'InterceptorsWrapper',
    isAssignable: (v) => v is $dio_5.InterceptorsWrapper,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final onRequestRaw = named['onRequest'];
        final onResponseRaw = named['onResponse'];
        final onErrorRaw = named['onError'];
        return $dio_5.InterceptorsWrapper(onRequest: onRequestRaw == null ? null : ($dio_10.RequestOptions p0, $dio_5.RequestInterceptorHandler p1) { D4.callInterpreterCallback(visitor!, onRequestRaw, [p0, p1]); }, onResponse: onResponseRaw == null ? null : ($dio_13.Response<dynamic> p0, $dio_5.ResponseInterceptorHandler p1) { D4.callInterpreterCallback(visitor!, onResponseRaw, [p0, p1]); }, onError: onErrorRaw == null ? null : ($dio_4.DioException p0, $dio_5.ErrorInterceptorHandler p1) { D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]); });
      },
    },
    methods: {
      'onRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.InterceptorsWrapper>(target, 'InterceptorsWrapper');
        D4.requireMinArgs(positional, 2, 'onRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'onRequest');
        final handler = D4.getRequiredArg<$dio_5.RequestInterceptorHandler>(positional, 1, 'handler', 'onRequest');
        t.onRequest(options, handler);
        return null;
      },
      'onResponse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.InterceptorsWrapper>(target, 'InterceptorsWrapper');
        D4.requireMinArgs(positional, 2, 'onResponse');
        final response = D4.getRequiredArg<$dio_13.Response>(positional, 0, 'response', 'onResponse');
        final handler = D4.getRequiredArg<$dio_5.ResponseInterceptorHandler>(positional, 1, 'handler', 'onResponse');
        t.onResponse(response, handler);
        return null;
      },
      'onError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.InterceptorsWrapper>(target, 'InterceptorsWrapper');
        D4.requireMinArgs(positional, 2, 'onError');
        final err = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'err', 'onError');
        final handler = D4.getRequiredArg<$dio_5.ErrorInterceptorHandler>(positional, 1, 'handler', 'onError');
        t.onError(err, handler);
        return null;
      },
    },
    constructorSignatures: {
      '': 'InterceptorsWrapper({InterceptorSendCallback? onRequest, InterceptorSuccessCallback? onResponse, InterceptorErrorCallback? onError})',
    },
    methodSignatures: {
      'onRequest': 'void onRequest(RequestOptions options, RequestInterceptorHandler handler)',
      'onResponse': 'void onResponse(Response response, ResponseInterceptorHandler handler)',
      'onError': 'void onError(DioException err, ErrorInterceptorHandler handler)',
    },
  );
}

// =============================================================================
// Interceptors Bridge
// =============================================================================

BridgedClass _createInterceptorsBridge() {
  return BridgedClass(
    nativeType: $dio_5.Interceptors,
    name: 'Interceptors',
    isAssignable: (v) => v is $dio_5.Interceptors,
    hierarchyDepth: 6,
    constructors: {
      '': (visitor, positional, named) {
        final initialInterceptors = named.containsKey('initialInterceptors') && named['initialInterceptors'] != null
            ? D4.coerceList<$dio_5.Interceptor>(named['initialInterceptors'], 'initialInterceptors')
            : const <$dio_5.Interceptor>[];
        return $dio_5.Interceptors(initialInterceptors: initialInterceptors);
      },
    },
    getters: {
      'length': (visitor, target) => D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').length,
      'iterator': (visitor, target) => D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').iterator,
      'isEmpty': (visitor, target) => D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').isEmpty,
      'isNotEmpty': (visitor, target) => D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').isNotEmpty,
      'first': (visitor, target) => D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').first,
      'last': (visitor, target) => D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').last,
      'single': (visitor, target) => D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').single,
      'reversed': (visitor, target) => D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').reversed,
    },
    setters: {
      'length': (visitor, target, value) => 
        D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').length = D4.extractBridgedArg<int>(value, 'length'),
      'first': (visitor, target, value) => 
        D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').first = D4.extractBridgedArg<$dio_5.Interceptor>(value, 'first'),
      'last': (visitor, target, value) => 
        D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors').last = D4.extractBridgedArg<$dio_5.Interceptor>(value, 'last'),
    },
    methods: {
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        final keepImplyContentTypeInterceptor = D4.getNamedArgWithDefault<bool>(named, 'keepImplyContentTypeInterceptor', true);
        t.clear(keepImplyContentTypeInterceptor: keepImplyContentTypeInterceptor);
        return null;
      },
      'removeImplyContentTypeInterceptor': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        t.removeImplyContentTypeInterceptor();
        return null;
      },
      'elementAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'elementAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'elementAt');
        return t.elementAt(index);
      },
      'followedBy': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'followedBy');
        if (positional.isEmpty) {
          throw ArgumentError('followedBy: Missing required argument "other" at position 0');
        }
        final other = D4.coerceList<$dio_5.Interceptor>(positional[0], 'other');
        return t.followedBy(other);
      },
      'forEach': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'forEach');
        if (positional.isEmpty) {
          throw ArgumentError('forEach: Missing required argument "action" at position 0');
        }
        final actionRaw = positional[0];
        t.forEach(($dio_5.Interceptor p0) { D4.callInterpreterCallback(visitor!, actionRaw, [p0]); });
        return null;
      },
      'contains': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'contains');
        final element = D4.getRequiredArg<Object?>(positional, 0, 'element', 'contains');
        return t.contains(element);
      },
      'every': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'every');
        if (positional.isEmpty) {
          throw ArgumentError('every: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        return t.every((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor));
      },
      'any': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'any');
        if (positional.isEmpty) {
          throw ArgumentError('any: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        return t.any((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor));
      },
      'firstWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'firstWhere');
        if (positional.isEmpty) {
          throw ArgumentError('firstWhere: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        final orElseRaw = named['orElse'];
        return t.firstWhere((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor), orElse: orElseRaw == null ? null : (() { return D4.extractBridgedArg<$dio_5.Interceptor>(D4.callInterpreterCallback(visitor!, orElseRaw, []), 'callback', visitor) as $dio_5.Interceptor; }) as $dio_5.Interceptor Function());
      },
      'lastWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'lastWhere');
        if (positional.isEmpty) {
          throw ArgumentError('lastWhere: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        final orElseRaw = named['orElse'];
        return t.lastWhere((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor), orElse: orElseRaw == null ? null : (() { return D4.extractBridgedArg<$dio_5.Interceptor>(D4.callInterpreterCallback(visitor!, orElseRaw, []), 'callback', visitor) as $dio_5.Interceptor; }) as $dio_5.Interceptor Function());
      },
      'singleWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'singleWhere');
        if (positional.isEmpty) {
          throw ArgumentError('singleWhere: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        final orElseRaw = named['orElse'];
        return t.singleWhere((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor), orElse: orElseRaw == null ? null : (() { return D4.extractBridgedArg<$dio_5.Interceptor>(D4.callInterpreterCallback(visitor!, orElseRaw, []), 'callback', visitor) as $dio_5.Interceptor; }) as $dio_5.Interceptor Function());
      },
      'join': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        final separator = D4.getOptionalArgWithDefault<String>(positional, 0, 'separator', "");
        return t.join(separator);
      },
      'where': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'where');
        if (positional.isEmpty) {
          throw ArgumentError('where: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        return t.where((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor));
      },
      'whereType': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        return t.whereType();
      },
      'map': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'map');
        if (positional.isEmpty) {
          throw ArgumentError('map: Missing required argument "f" at position 0');
        }
        final fRaw = positional[0];
        return t.map<Object?>(($dio_5.Interceptor p0) { return D4.castCallbackResult<dynamic>(D4.callInterpreterCallback(visitor!, fRaw, [p0])); });
      },
      'expand': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'expand');
        if (positional.isEmpty) {
          throw ArgumentError('expand: Missing required argument "f" at position 0');
        }
        final fRaw = positional[0];
        return t.expand<Object?>((($dio_5.Interceptor p0) { return D4.extractBridgedArg<Iterable<dynamic>>(D4.callInterpreterCallback(visitor!, fRaw, [p0]), 'callback', visitor) as Iterable<dynamic>; }) as Iterable<dynamic> Function($dio_5.Interceptor));
      },
      'reduce': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'reduce');
        if (positional.isEmpty) {
          throw ArgumentError('reduce: Missing required argument "combine" at position 0');
        }
        final combineRaw = positional[0];
        return t.reduce((($dio_5.Interceptor p0, $dio_5.Interceptor p1) { return D4.extractBridgedArg<$dio_5.Interceptor>(D4.callInterpreterCallback(visitor!, combineRaw, [p0, p1]), 'callback', visitor) as $dio_5.Interceptor; }) as $dio_5.Interceptor Function($dio_5.Interceptor, $dio_5.Interceptor));
      },
      'fold': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 2, 'fold');
        final initialValue = D4.getRequiredArg<dynamic>(positional, 0, 'initialValue', 'fold');
        if (positional.length <= 1) {
          throw ArgumentError('fold: Missing required argument "combine" at position 1');
        }
        final combineRaw = positional[1];
        return t.fold<Object?>(initialValue, (dynamic p0, $dio_5.Interceptor p1) { return D4.castCallbackResult<dynamic>(D4.callInterpreterCallback(visitor!, combineRaw, [p0, p1])); });
      },
      'skip': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'skip');
        final count = D4.getRequiredArg<int>(positional, 0, 'count', 'skip');
        return t.skip(count);
      },
      'skipWhile': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'skipWhile');
        if (positional.isEmpty) {
          throw ArgumentError('skipWhile: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        return t.skipWhile((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor));
      },
      'take': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'take');
        final count = D4.getRequiredArg<int>(positional, 0, 'count', 'take');
        return t.take(count);
      },
      'takeWhile': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'takeWhile');
        if (positional.isEmpty) {
          throw ArgumentError('takeWhile: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        return t.takeWhile((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor));
      },
      'toList': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        final growable = D4.getNamedArgWithDefault<bool>(named, 'growable', true);
        return t.toList(growable: growable);
      },
      'toSet': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        return t.toSet();
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'add');
        final element = D4.getRequiredArg<$dio_5.Interceptor>(positional, 0, 'element', 'add');
        t.add(element);
        return null;
      },
      'addAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'addAll');
        if (positional.isEmpty) {
          throw ArgumentError('addAll: Missing required argument "iterable" at position 0');
        }
        final iterable = D4.coerceList<$dio_5.Interceptor>(positional[0], 'iterable');
        t.addAll(iterable);
        return null;
      },
      'remove': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'remove');
        final element = D4.getRequiredArg<Object?>(positional, 0, 'element', 'remove');
        return t.remove(element);
      },
      'removeWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'removeWhere');
        if (positional.isEmpty) {
          throw ArgumentError('removeWhere: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        t.removeWhere((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor));
        return null;
      },
      'retainWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'retainWhere');
        if (positional.isEmpty) {
          throw ArgumentError('retainWhere: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        t.retainWhere((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor));
        return null;
      },
      'cast': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        return t.cast();
      },
      'removeLast': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        return t.removeLast();
      },
      'sort': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        final compareRaw = positional.isNotEmpty ? positional[0] : null;
        t.sort(compareRaw == null ? null : (($dio_5.Interceptor p0, $dio_5.Interceptor p1) { return D4.callInterpreterCallback(visitor!, compareRaw, [p0, p1]) as int; }) as int Function($dio_5.Interceptor, $dio_5.Interceptor));
        return null;
      },
      'shuffle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        final random = D4.getOptionalArg<$dart_math.Random?>(positional, 0, 'random');
        t.shuffle(random);
        return null;
      },
      'asMap': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        return t.asMap();
      },
      'sublist': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'sublist');
        final start = D4.getRequiredArg<int>(positional, 0, 'start', 'sublist');
        final end = D4.getOptionalArg<int?>(positional, 1, 'end');
        return t.sublist(start, end);
      },
      'getRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 2, 'getRange');
        final start = D4.getRequiredArg<int>(positional, 0, 'start', 'getRange');
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'getRange');
        return t.getRange(start, end);
      },
      'removeRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 2, 'removeRange');
        final start = D4.getRequiredArg<int>(positional, 0, 'start', 'removeRange');
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'removeRange');
        t.removeRange(start, end);
        return null;
      },
      'fillRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 2, 'fillRange');
        final start = D4.getRequiredArg<int>(positional, 0, 'start', 'fillRange');
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'fillRange');
        final fill = D4.getOptionalArg<$dio_5.Interceptor?>(positional, 2, 'fill');
        t.fillRange(start, end, fill);
        return null;
      },
      'setRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 3, 'setRange');
        final start = D4.getRequiredArg<int>(positional, 0, 'start', 'setRange');
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'setRange');
        if (positional.length <= 2) {
          throw ArgumentError('setRange: Missing required argument "iterable" at position 2');
        }
        final iterable = D4.coerceList<$dio_5.Interceptor>(positional[2], 'iterable');
        final skipCount = D4.getOptionalArgWithDefault<int>(positional, 3, 'skipCount', 0);
        t.setRange(start, end, iterable, skipCount);
        return null;
      },
      'replaceRange': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 3, 'replaceRange');
        final start = D4.getRequiredArg<int>(positional, 0, 'start', 'replaceRange');
        final end = D4.getRequiredArg<int>(positional, 1, 'end', 'replaceRange');
        if (positional.length <= 2) {
          throw ArgumentError('replaceRange: Missing required argument "newContents" at position 2');
        }
        final newContents = D4.coerceList<$dio_5.Interceptor>(positional[2], 'newContents');
        t.replaceRange(start, end, newContents);
        return null;
      },
      'indexOf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'indexOf');
        final element = D4.getRequiredArg<Object?>(positional, 0, 'element', 'indexOf');
        final start = D4.getOptionalArgWithDefault<int>(positional, 1, 'start', 0);
        return t.indexOf(element, start);
      },
      'indexWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'indexWhere');
        if (positional.isEmpty) {
          throw ArgumentError('indexWhere: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        final start = D4.getOptionalArgWithDefault<int>(positional, 1, 'start', 0);
        return t.indexWhere((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor), start);
      },
      'lastIndexOf': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'lastIndexOf');
        final element = D4.getRequiredArg<Object?>(positional, 0, 'element', 'lastIndexOf');
        final start = D4.getOptionalArg<int?>(positional, 1, 'start');
        return t.lastIndexOf(element, start);
      },
      'lastIndexWhere': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'lastIndexWhere');
        if (positional.isEmpty) {
          throw ArgumentError('lastIndexWhere: Missing required argument "test" at position 0');
        }
        final testRaw = positional[0];
        final start = D4.getOptionalArg<int?>(positional, 1, 'start');
        return t.lastIndexWhere((($dio_5.Interceptor p0) { return D4.callInterpreterCallback(visitor!, testRaw, [p0]) as bool; }) as bool Function($dio_5.Interceptor), start);
      },
      'insert': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 2, 'insert');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'insert');
        final element = D4.getRequiredArg<$dio_5.Interceptor>(positional, 1, 'element', 'insert');
        t.insert(index, element);
        return null;
      },
      'removeAt': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 1, 'removeAt');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'removeAt');
        return t.removeAt(index);
      },
      'insertAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 2, 'insertAll');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'insertAll');
        if (positional.length <= 1) {
          throw ArgumentError('insertAll: Missing required argument "iterable" at position 1');
        }
        final iterable = D4.coerceList<$dio_5.Interceptor>(positional[1], 'iterable');
        t.insertAll(index, iterable);
        return null;
      },
      'setAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        D4.requireMinArgs(positional, 2, 'setAll');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'setAll');
        if (positional.length <= 1) {
          throw ArgumentError('setAll: Missing required argument "iterable" at position 1');
        }
        final iterable = D4.coerceList<$dio_5.Interceptor>(positional[1], 'iterable');
        t.setAll(index, iterable);
        return null;
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        return t.toString();
      },
      '[]': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'operator[]');
        return t[index];
      },
      '[]=': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        final index = D4.getRequiredArg<int>(positional, 0, 'index', 'operator[]=');
        final value = D4.getRequiredArg<$dio_5.Interceptor>(positional, 1, 'value', 'operator[]=');
        t[index] = value;
        return null;
      },
      '+': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        final other = D4.getRequiredArg<List<$dio_5.Interceptor>>(positional, 0, 'other', 'operator+');
        return t + other;
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.Interceptors>(target, 'Interceptors');
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(positional, 0, 'other', 'operator==');
        return t == other;
      },
    },
    constructorSignatures: {
      '': 'Interceptors({List<Interceptor> initialInterceptors = const <Interceptor>[]})',
    },
    methodSignatures: {
      'clear': 'void clear({bool keepImplyContentTypeInterceptor = true})',
      'removeImplyContentTypeInterceptor': 'void removeImplyContentTypeInterceptor()',
      'elementAt': 'Interceptor elementAt(int index)',
      'followedBy': 'Iterable<Interceptor> followedBy(Iterable<Interceptor> other)',
      'forEach': 'void forEach(void Function(Interceptor element) action)',
      'contains': 'bool contains(Object? element)',
      'every': 'bool every(bool Function(Interceptor element) test)',
      'any': 'bool any(bool Function(Interceptor element) test)',
      'firstWhere': 'Interceptor firstWhere(bool Function(Interceptor element) test, {Interceptor Function()? orElse})',
      'lastWhere': 'Interceptor lastWhere(bool Function(Interceptor element) test, {Interceptor Function()? orElse})',
      'singleWhere': 'Interceptor singleWhere(bool Function(Interceptor element) test, {Interceptor Function()? orElse})',
      'join': 'String join([String separator = ""])',
      'where': 'Iterable<Interceptor> where(bool Function(Interceptor element) test)',
      'whereType': 'Iterable<T> whereType()',
      'map': 'Iterable<T> map(T Function(Interceptor element) f)',
      'expand': 'Iterable<T> expand(Iterable<T> Function(Interceptor element) f)',
      'reduce': 'Interceptor reduce(Interceptor Function(Interceptor previousValue, Interceptor element) combine)',
      'fold': 'T fold(T initialValue, T Function(T previousValue, Interceptor element) combine)',
      'skip': 'Iterable<Interceptor> skip(int count)',
      'skipWhile': 'Iterable<Interceptor> skipWhile(bool Function(Interceptor element) test)',
      'take': 'Iterable<Interceptor> take(int count)',
      'takeWhile': 'Iterable<Interceptor> takeWhile(bool Function(Interceptor element) test)',
      'toList': 'List<Interceptor> toList({bool growable = true})',
      'toSet': 'Set<Interceptor> toSet()',
      'add': 'void add(Interceptor element)',
      'addAll': 'void addAll(Iterable<Interceptor> iterable)',
      'remove': 'bool remove(Object? element)',
      'removeWhere': 'void removeWhere(bool Function(Interceptor element) test)',
      'retainWhere': 'void retainWhere(bool Function(Interceptor element) test)',
      'cast': 'List<R> cast()',
      'removeLast': 'Interceptor removeLast()',
      'sort': 'void sort([int Function(Interceptor a, Interceptor b)? compare])',
      'shuffle': 'void shuffle([Random? random])',
      'asMap': 'Map<int, Interceptor> asMap()',
      'sublist': 'List<Interceptor> sublist(int start, [int? end])',
      'getRange': 'Iterable<Interceptor> getRange(int start, int end)',
      'removeRange': 'void removeRange(int start, int end)',
      'fillRange': 'void fillRange(int start, int end, [Interceptor? fill])',
      'setRange': 'void setRange(int start, int end, Iterable<Interceptor> iterable, [int skipCount = 0])',
      'replaceRange': 'void replaceRange(int start, int end, Iterable<Interceptor> newContents)',
      'indexOf': 'int indexOf(Object? element, [int start = 0])',
      'indexWhere': 'int indexWhere(bool Function(Interceptor element) test, [int start = 0])',
      'lastIndexOf': 'int lastIndexOf(Object? element, [int? start])',
      'lastIndexWhere': 'int lastIndexWhere(bool Function(Interceptor element) test, [int? start])',
      'insert': 'void insert(int index, Interceptor element)',
      'removeAt': 'Interceptor removeAt(int index)',
      'insertAll': 'void insertAll(int index, Iterable<Interceptor> iterable)',
      'setAll': 'void setAll(int index, Iterable<Interceptor> iterable)',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'length': 'int get length',
      'iterator': 'Iterator<Interceptor> get iterator',
      'isEmpty': 'bool get isEmpty',
      'isNotEmpty': 'bool get isNotEmpty',
      'first': 'Interceptor get first',
      'last': 'Interceptor get last',
      'single': 'Interceptor get single',
      'reversed': 'Iterable<Interceptor> get reversed',
    },
    setterSignatures: {
      'length': 'set length(int value)',
      'first': 'set first(Interceptor value)',
      'last': 'set last(Interceptor value)',
    },
  );
}

// =============================================================================
// QueuedInterceptor Bridge
// =============================================================================

BridgedClass _createQueuedInterceptorBridge() {
  return BridgedClass(
    nativeType: $dio_5.QueuedInterceptor,
    name: 'QueuedInterceptor',
    isAssignable: (v) => v is $dio_5.QueuedInterceptor,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        return $dio_5.QueuedInterceptor();
      },
    },
    methods: {
      'onRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.QueuedInterceptor>(target, 'QueuedInterceptor');
        D4.requireMinArgs(positional, 2, 'onRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'onRequest');
        final handler = D4.getRequiredArg<$dio_5.RequestInterceptorHandler>(positional, 1, 'handler', 'onRequest');
        t.onRequest(options, handler);
        return null;
      },
      'onResponse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.QueuedInterceptor>(target, 'QueuedInterceptor');
        D4.requireMinArgs(positional, 2, 'onResponse');
        final response = D4.getRequiredArg<$dio_13.Response>(positional, 0, 'response', 'onResponse');
        final handler = D4.getRequiredArg<$dio_5.ResponseInterceptorHandler>(positional, 1, 'handler', 'onResponse');
        t.onResponse(response, handler);
        return null;
      },
      'onError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.QueuedInterceptor>(target, 'QueuedInterceptor');
        D4.requireMinArgs(positional, 2, 'onError');
        final err = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'err', 'onError');
        final handler = D4.getRequiredArg<$dio_5.ErrorInterceptorHandler>(positional, 1, 'handler', 'onError');
        t.onError(err, handler);
        return null;
      },
    },
    constructorSignatures: {
      '': 'QueuedInterceptor()',
    },
    methodSignatures: {
      'onRequest': 'void onRequest(RequestOptions options, RequestInterceptorHandler handler)',
      'onResponse': 'void onResponse(Response response, ResponseInterceptorHandler handler)',
      'onError': 'void onError(DioException err, ErrorInterceptorHandler handler)',
    },
  );
}

// =============================================================================
// QueuedInterceptorsWrapper Bridge
// =============================================================================

BridgedClass _createQueuedInterceptorsWrapperBridge() {
  return BridgedClass(
    nativeType: $dio_5.QueuedInterceptorsWrapper,
    name: 'QueuedInterceptorsWrapper',
    isAssignable: (v) => v is $dio_5.QueuedInterceptorsWrapper,
    hierarchyDepth: 3,
    constructors: {
      '': (visitor, positional, named) {
        final onRequestRaw = named['onRequest'];
        final onResponseRaw = named['onResponse'];
        final onErrorRaw = named['onError'];
        return $dio_5.QueuedInterceptorsWrapper(onRequest: onRequestRaw == null ? null : ($dio_10.RequestOptions p0, $dio_5.RequestInterceptorHandler p1) { D4.callInterpreterCallback(visitor!, onRequestRaw, [p0, p1]); }, onResponse: onResponseRaw == null ? null : ($dio_13.Response<dynamic> p0, $dio_5.ResponseInterceptorHandler p1) { D4.callInterpreterCallback(visitor!, onResponseRaw, [p0, p1]); }, onError: onErrorRaw == null ? null : ($dio_4.DioException p0, $dio_5.ErrorInterceptorHandler p1) { D4.callInterpreterCallback(visitor!, onErrorRaw, [p0, p1]); });
      },
    },
    methods: {
      'onRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.QueuedInterceptorsWrapper>(target, 'QueuedInterceptorsWrapper');
        D4.requireMinArgs(positional, 2, 'onRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'onRequest');
        final handler = D4.getRequiredArg<$dio_5.RequestInterceptorHandler>(positional, 1, 'handler', 'onRequest');
        t.onRequest(options, handler);
        return null;
      },
      'onResponse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.QueuedInterceptorsWrapper>(target, 'QueuedInterceptorsWrapper');
        D4.requireMinArgs(positional, 2, 'onResponse');
        final response = D4.getRequiredArg<$dio_13.Response>(positional, 0, 'response', 'onResponse');
        final handler = D4.getRequiredArg<$dio_5.ResponseInterceptorHandler>(positional, 1, 'handler', 'onResponse');
        t.onResponse(response, handler);
        return null;
      },
      'onError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_5.QueuedInterceptorsWrapper>(target, 'QueuedInterceptorsWrapper');
        D4.requireMinArgs(positional, 2, 'onError');
        final err = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'err', 'onError');
        final handler = D4.getRequiredArg<$dio_5.ErrorInterceptorHandler>(positional, 1, 'handler', 'onError');
        t.onError(err, handler);
        return null;
      },
    },
    constructorSignatures: {
      '': 'QueuedInterceptorsWrapper({InterceptorSendCallback? onRequest, InterceptorSuccessCallback? onResponse, InterceptorErrorCallback? onError})',
    },
    methodSignatures: {
      'onRequest': 'void onRequest(RequestOptions options, RequestInterceptorHandler handler)',
      'onResponse': 'void onResponse(Response response, ResponseInterceptorHandler handler)',
      'onError': 'void onError(DioException err, ErrorInterceptorHandler handler)',
    },
  );
}

// =============================================================================
// FormData Bridge
// =============================================================================

BridgedClass _createFormDataBridge() {
  return BridgedClass(
    nativeType: $dio_6.FormData,
    name: 'FormData',
    isAssignable: (v) => v is $dio_6.FormData,
    constructors: {
      '': (visitor, positional, named) {
        final camelCaseContentDisposition = D4.getNamedArgWithDefault<bool>(named, 'camelCaseContentDisposition', false);
        if (!named.containsKey('boundaryName')) {
          return $dio_6.FormData(camelCaseContentDisposition: camelCaseContentDisposition);
        }
        if (named.containsKey('boundaryName')) {
          final boundaryName = D4.getRequiredNamedArg<String>(named, 'boundaryName', 'FormData');
          return $dio_6.FormData(camelCaseContentDisposition: camelCaseContentDisposition, boundaryName: boundaryName);
        }
        throw StateError('Unreachable: all named parameter combinations should be covered');
      },
      'fromMap': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'FormData');
        if (positional.isEmpty) {
          throw ArgumentError('FormData: Missing required argument "map" at position 0');
        }
        final map = D4.coerceMap<String, dynamic>(positional[0], 'map');
        final listFormat = D4.getOptionalArgWithDefault<$dio_10.ListFormat>(positional, 1, 'listFormat', $dio_10.ListFormat.multi);
        final camelCaseContentDisposition = D4.getOptionalArgWithDefault<bool>(positional, 2, 'camelCaseContentDisposition', false);
        // TODO: Non-wrappable default: _boundaryName
        final boundaryName = D4.getRequiredArgTodoDefault<String>(positional, 3, 'boundaryName', 'FormData', '_boundaryName');
        return $dio_6.FormData.fromMap(map, listFormat, camelCaseContentDisposition, boundaryName);
      },
    },
    getters: {
      'boundaryName': (visitor, target) => D4.validateTarget<$dio_6.FormData>(target, 'FormData').boundaryName,
      'camelCaseContentDisposition': (visitor, target) => D4.validateTarget<$dio_6.FormData>(target, 'FormData').camelCaseContentDisposition,
      'fields': (visitor, target) => D4.validateTarget<$dio_6.FormData>(target, 'FormData').fields,
      'files': (visitor, target) => D4.validateTarget<$dio_6.FormData>(target, 'FormData').files,
      'boundary': (visitor, target) => D4.validateTarget<$dio_6.FormData>(target, 'FormData').boundary,
      'isFinalized': (visitor, target) => D4.validateTarget<$dio_6.FormData>(target, 'FormData').isFinalized,
      'length': (visitor, target) => D4.validateTarget<$dio_6.FormData>(target, 'FormData').length,
    },
    methods: {
      'finalize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_6.FormData>(target, 'FormData');
        return t.finalize();
      },
      'readAsBytes': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_6.FormData>(target, 'FormData');
        return t.readAsBytes();
      },
      'clone': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_6.FormData>(target, 'FormData');
        return t.clone();
      },
    },
    constructorSignatures: {
      '': 'FormData({String boundaryName = _boundaryName, bool camelCaseContentDisposition = false})',
      'fromMap': 'FormData.fromMap(Map<String, dynamic> map, [ListFormat listFormat = ListFormat.multi, bool camelCaseContentDisposition = false, String boundaryName = _boundaryName])',
    },
    methodSignatures: {
      'finalize': 'Stream<Uint8List> finalize()',
      'readAsBytes': 'Future<Uint8List> readAsBytes()',
      'clone': 'FormData clone()',
    },
    getterSignatures: {
      'boundaryName': 'String get boundaryName',
      'camelCaseContentDisposition': 'bool get camelCaseContentDisposition',
      'fields': 'List<MapEntry<String, String>> get fields',
      'files': 'List<MapEntry<String, MultipartFile>> get files',
      'boundary': 'String get boundary',
      'isFinalized': 'bool get isFinalized',
      'length': 'int get length',
    },
  );
}

// =============================================================================
// Headers Bridge
// =============================================================================

BridgedClass _createHeadersBridge() {
  return BridgedClass(
    nativeType: $dio_7.Headers,
    name: 'Headers',
    isAssignable: (v) => v is $dio_7.Headers,
    constructors: {
      '': (visitor, positional, named) {
        final preserveHeaderCase = D4.getNamedArgWithDefault<bool>(named, 'preserveHeaderCase', false);
        return $dio_7.Headers(preserveHeaderCase: preserveHeaderCase);
      },
      'fromMap': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Headers');
        if (positional.isEmpty) {
          throw ArgumentError('Headers: Missing required argument "map" at position 0');
        }
        final map = D4.coerceMap<String, List<String>>(positional[0], 'map');
        final preserveHeaderCase = D4.getNamedArgWithDefault<bool>(named, 'preserveHeaderCase', false);
        return $dio_7.Headers.fromMap(map, preserveHeaderCase: preserveHeaderCase);
      },
    },
    getters: {
      'preserveHeaderCase': (visitor, target) => D4.validateTarget<$dio_7.Headers>(target, 'Headers').preserveHeaderCase,
      'map': (visitor, target) => D4.validateTarget<$dio_7.Headers>(target, 'Headers').map,
      'isEmpty': (visitor, target) => D4.validateTarget<$dio_7.Headers>(target, 'Headers').isEmpty,
    },
    methods: {
      'value': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_7.Headers>(target, 'Headers');
        D4.requireMinArgs(positional, 1, 'value');
        final name = D4.getRequiredArg<String>(positional, 0, 'name', 'value');
        return t.value(name);
      },
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_7.Headers>(target, 'Headers');
        D4.requireMinArgs(positional, 2, 'add');
        final name = D4.getRequiredArg<String>(positional, 0, 'name', 'add');
        final value = D4.getRequiredArg<String>(positional, 1, 'value', 'add');
        t.add(name, value);
        return null;
      },
      'set': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_7.Headers>(target, 'Headers');
        D4.requireMinArgs(positional, 2, 'set');
        final name = D4.getRequiredArg<String>(positional, 0, 'name', 'set');
        final value = D4.getRequiredArg<dynamic>(positional, 1, 'value', 'set');
        t.set(name, value);
        return null;
      },
      'remove': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_7.Headers>(target, 'Headers');
        D4.requireMinArgs(positional, 2, 'remove');
        final name = D4.getRequiredArg<String>(positional, 0, 'name', 'remove');
        final value = D4.getRequiredArg<String>(positional, 1, 'value', 'remove');
        t.remove(name, value);
        return null;
      },
      'removeAll': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_7.Headers>(target, 'Headers');
        D4.requireMinArgs(positional, 1, 'removeAll');
        final name = D4.getRequiredArg<String>(positional, 0, 'name', 'removeAll');
        t.removeAll(name);
        return null;
      },
      'clear': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_7.Headers>(target, 'Headers');
        t.clear();
        return null;
      },
      'forEach': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_7.Headers>(target, 'Headers');
        D4.requireMinArgs(positional, 1, 'forEach');
        if (positional.isEmpty) {
          throw ArgumentError('forEach: Missing required argument "f" at position 0');
        }
        final fRaw = positional[0];
        t.forEach((String p0, List<String> p1) { D4.callInterpreterCallback(visitor!, fRaw, [p0, p1]); });
        return null;
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_7.Headers>(target, 'Headers');
        return t.toString();
      },
      '[]': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_7.Headers>(target, 'Headers');
        final index = D4.getRequiredArg<String>(positional, 0, 'index', 'operator[]');
        return t[index];
      },
    },
    staticGetters: {
      'acceptHeader': (visitor) => $dio_7.Headers.acceptHeader,
      'contentEncodingHeader': (visitor) => $dio_7.Headers.contentEncodingHeader,
      'contentLengthHeader': (visitor) => $dio_7.Headers.contentLengthHeader,
      'contentTypeHeader': (visitor) => $dio_7.Headers.contentTypeHeader,
      'wwwAuthenticateHeader': (visitor) => $dio_7.Headers.wwwAuthenticateHeader,
      'jsonContentType': (visitor) => $dio_7.Headers.jsonContentType,
      'formUrlEncodedContentType': (visitor) => $dio_7.Headers.formUrlEncodedContentType,
      'textPlainContentType': (visitor) => $dio_7.Headers.textPlainContentType,
      'multipartFormDataContentType': (visitor) => $dio_7.Headers.multipartFormDataContentType,
      'jsonMimeType': (visitor) => $dio_7.Headers.jsonMimeType,
    },
    constructorSignatures: {
      '': 'Headers({bool preserveHeaderCase = false})',
      'fromMap': 'Headers.fromMap(Map<String, List<String>> map, {bool preserveHeaderCase = false})',
    },
    methodSignatures: {
      'value': 'String? value(String name)',
      'add': 'void add(String name, String value)',
      'set': 'void set(String name, dynamic value)',
      'remove': 'void remove(String name, String value)',
      'removeAll': 'void removeAll(String name)',
      'clear': 'void clear()',
      'forEach': 'void forEach(HeaderForEachCallback f)',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'preserveHeaderCase': 'bool get preserveHeaderCase',
      'map': 'Map<String, List<String>> get map',
      'isEmpty': 'bool get isEmpty',
    },
    staticGetterSignatures: {
      'acceptHeader': 'String get acceptHeader',
      'contentEncodingHeader': 'String get contentEncodingHeader',
      'contentLengthHeader': 'String get contentLengthHeader',
      'contentTypeHeader': 'String get contentTypeHeader',
      'wwwAuthenticateHeader': 'String get wwwAuthenticateHeader',
      'jsonContentType': 'String get jsonContentType',
      'formUrlEncodedContentType': 'String get formUrlEncodedContentType',
      'textPlainContentType': 'String get textPlainContentType',
      'multipartFormDataContentType': 'String get multipartFormDataContentType',
      'jsonMimeType': 'MediaType get jsonMimeType',
    },
  );
}

// =============================================================================
// LogInterceptor Bridge
// =============================================================================

BridgedClass _createLogInterceptorBridge() {
  return BridgedClass(
    nativeType: $dio_8.LogInterceptor,
    name: 'LogInterceptor',
    isAssignable: (v) => v is $dio_8.LogInterceptor,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final request = D4.getNamedArgWithDefault<bool>(named, 'request', true);
        final requestUrl = D4.getNamedArgWithDefault<bool>(named, 'requestUrl', true);
        final requestHeader = D4.getNamedArgWithDefault<bool>(named, 'requestHeader', true);
        final requestBody = D4.getNamedArgWithDefault<bool>(named, 'requestBody', false);
        final responseUrl = D4.getNamedArgWithDefault<bool>(named, 'responseUrl', true);
        final responseHeader = D4.getNamedArgWithDefault<bool>(named, 'responseHeader', true);
        final responseBody = D4.getNamedArgWithDefault<bool>(named, 'responseBody', false);
        final error = D4.getNamedArgWithDefault<bool>(named, 'error', true);
        if (!named.containsKey('logPrint')) {
          return $dio_8.LogInterceptor(request: request, requestUrl: requestUrl, requestHeader: requestHeader, requestBody: requestBody, responseUrl: responseUrl, responseHeader: responseHeader, responseBody: responseBody, error: error);
        }
        if (named.containsKey('logPrint')) {
          final logPrintRaw = named['logPrint'];
          final logPrint = (Object p0) { D4.callInterpreterCallback(visitor!, logPrintRaw, [p0]); };
          return $dio_8.LogInterceptor(request: request, requestUrl: requestUrl, requestHeader: requestHeader, requestBody: requestBody, responseUrl: responseUrl, responseHeader: responseHeader, responseBody: responseBody, error: error, logPrint: logPrint);
        }
        throw StateError('Unreachable: all named parameter combinations should be covered');
      },
    },
    getters: {
      'request': (visitor, target) => D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').request,
      'requestUrl': (visitor, target) => D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').requestUrl,
      'requestHeader': (visitor, target) => D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').requestHeader,
      'requestBody': (visitor, target) => D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').requestBody,
      'responseUrl': (visitor, target) => D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').responseUrl,
      'responseHeader': (visitor, target) => D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').responseHeader,
      'responseBody': (visitor, target) => D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').responseBody,
      'error': (visitor, target) => D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').error,
      'logPrint': (visitor, target) => D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').logPrint,
    },
    setters: {
      'request': (visitor, target, value) => 
        D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').request = D4.extractBridgedArg<bool>(value, 'request'),
      'requestUrl': (visitor, target, value) => 
        D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').requestUrl = D4.extractBridgedArg<bool>(value, 'requestUrl'),
      'requestHeader': (visitor, target, value) => 
        D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').requestHeader = D4.extractBridgedArg<bool>(value, 'requestHeader'),
      'requestBody': (visitor, target, value) => 
        D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').requestBody = D4.extractBridgedArg<bool>(value, 'requestBody'),
      'responseUrl': (visitor, target, value) => 
        D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').responseUrl = D4.extractBridgedArg<bool>(value, 'responseUrl'),
      'responseHeader': (visitor, target, value) => 
        D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').responseHeader = D4.extractBridgedArg<bool>(value, 'responseHeader'),
      'responseBody': (visitor, target, value) => 
        D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').responseBody = D4.extractBridgedArg<bool>(value, 'responseBody'),
      'error': (visitor, target, value) => 
        D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').error = D4.extractBridgedArg<bool>(value, 'error'),
      'logPrint': (visitor, target, value) {
        final logPrintRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'logPrint');
        D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor').logPrint = (Object p0) { D4.callInterpreterCallback(visitor!, logPrintRaw, [p0]); };
      },
    },
    methods: {
      'onRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor');
        D4.requireMinArgs(positional, 2, 'onRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'onRequest');
        final handler = D4.getRequiredArg<$dio_5.RequestInterceptorHandler>(positional, 1, 'handler', 'onRequest');
        t.onRequest(options, handler);
        return null;
      },
      'onResponse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor');
        D4.requireMinArgs(positional, 2, 'onResponse');
        final response = D4.getRequiredArg<$dio_13.Response>(positional, 0, 'response', 'onResponse');
        final handler = D4.getRequiredArg<$dio_5.ResponseInterceptorHandler>(positional, 1, 'handler', 'onResponse');
        t.onResponse(response, handler);
        return null;
      },
      'onError': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_8.LogInterceptor>(target, 'LogInterceptor');
        D4.requireMinArgs(positional, 2, 'onError');
        final err = D4.getRequiredArg<$dio_4.DioException>(positional, 0, 'err', 'onError');
        final handler = D4.getRequiredArg<$dio_5.ErrorInterceptorHandler>(positional, 1, 'handler', 'onError');
        t.onError(err, handler);
        return null;
      },
    },
    constructorSignatures: {
      '': 'LogInterceptor({bool request = true, bool requestUrl = true, bool requestHeader = true, bool requestBody = false, bool responseUrl = true, bool responseHeader = true, bool responseBody = false, bool error = true, void Function(Object object) logPrint = _debugPrint})',
    },
    methodSignatures: {
      'onRequest': 'void onRequest(RequestOptions options, RequestInterceptorHandler handler)',
      'onResponse': 'void onResponse(Response response, ResponseInterceptorHandler handler)',
      'onError': 'void onError(DioException err, ErrorInterceptorHandler handler)',
    },
    getterSignatures: {
      'request': 'bool get request',
      'requestUrl': 'bool get requestUrl',
      'requestHeader': 'bool get requestHeader',
      'requestBody': 'bool get requestBody',
      'responseUrl': 'bool get responseUrl',
      'responseHeader': 'bool get responseHeader',
      'responseBody': 'bool get responseBody',
      'error': 'bool get error',
      'logPrint': 'void Function(Object object) get logPrint',
    },
    setterSignatures: {
      'request': 'set request(dynamic value)',
      'requestUrl': 'set requestUrl(dynamic value)',
      'requestHeader': 'set requestHeader(dynamic value)',
      'requestBody': 'set requestBody(dynamic value)',
      'responseUrl': 'set responseUrl(dynamic value)',
      'responseHeader': 'set responseHeader(dynamic value)',
      'responseBody': 'set responseBody(dynamic value)',
      'error': 'set error(dynamic value)',
      'logPrint': 'set logPrint(dynamic value)',
    },
  );
}

// =============================================================================
// MultipartFile Bridge
// =============================================================================

BridgedClass _createMultipartFileBridge() {
  return BridgedClass(
    nativeType: $dio_9.MultipartFile,
    name: 'MultipartFile',
    isAssignable: (v) => v is $dio_9.MultipartFile,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'MultipartFile');
        final stream = D4.getRequiredArg<Stream<List<int>>>(positional, 0, 'stream', 'MultipartFile');
        final length = D4.getRequiredArg<int>(positional, 1, 'length', 'MultipartFile');
        final filename = D4.getOptionalNamedArg<String?>(named, 'filename');
        final contentType = D4.getOptionalNamedArg<$http_parser_1.MediaType?>(named, 'contentType');
        final headers = D4.coerceMapOrNull<String, List<String>>(named['headers'], 'headers');
        return $dio_9.MultipartFile(stream, length, filename: filename, contentType: contentType, headers: headers);
      },
      'fromStream': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'MultipartFile');
        if (positional.isEmpty) {
          throw ArgumentError('MultipartFile: Missing required argument "data" at position 0');
        }
        final dataRaw = positional[0];
        final length = D4.getRequiredArg<int>(positional, 1, 'length', 'MultipartFile');
        final filename = D4.getOptionalNamedArg<String?>(named, 'filename');
        final contentType = D4.getOptionalNamedArg<$http_parser_1.MediaType?>(named, 'contentType');
        final headers = D4.coerceMapOrNull<String, List<String>>(named['headers'], 'headers');
        return $dio_9.MultipartFile.fromStream((() { return D4.extractBridgedArg<Stream<List<int>>>(D4.callInterpreterCallback(visitor!, dataRaw, []), 'callback', visitor) as Stream<List<int>>; }) as Stream<List<int>> Function(), length, filename: filename, contentType: contentType, headers: headers);
      },
      'fromBytes': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'MultipartFile');
        if (positional.isEmpty) {
          throw ArgumentError('MultipartFile: Missing required argument "value" at position 0');
        }
        final value = D4.coerceList<int>(positional[0], 'value');
        final filename = D4.getOptionalNamedArg<String?>(named, 'filename');
        final contentType = D4.getOptionalNamedArg<$http_parser_1.MediaType?>(named, 'contentType');
        final headers = D4.coerceMapOrNull<String, List<String>>(named['headers'], 'headers');
        return $dio_9.MultipartFile.fromBytes(value, filename: filename, contentType: contentType, headers: headers);
      },
      'fromString': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'MultipartFile');
        final value = D4.getRequiredArg<String>(positional, 0, 'value', 'MultipartFile');
        final filename = D4.getOptionalNamedArg<String?>(named, 'filename');
        final contentType = D4.getOptionalNamedArg<$http_parser_1.MediaType?>(named, 'contentType');
        final headers = D4.coerceMapOrNull<String, List<String>>(named['headers'], 'headers');
        return $dio_9.MultipartFile.fromString(value, filename: filename, contentType: contentType, headers: headers);
      },
    },
    getters: {
      'length': (visitor, target) => D4.validateTarget<$dio_9.MultipartFile>(target, 'MultipartFile').length,
      'filename': (visitor, target) => D4.validateTarget<$dio_9.MultipartFile>(target, 'MultipartFile').filename,
      'headers': (visitor, target) => D4.validateTarget<$dio_9.MultipartFile>(target, 'MultipartFile').headers,
      'contentType': (visitor, target) => D4.validateTarget<$dio_9.MultipartFile>(target, 'MultipartFile').contentType,
      'isFinalized': (visitor, target) => D4.validateTarget<$dio_9.MultipartFile>(target, 'MultipartFile').isFinalized,
    },
    methods: {
      'finalize': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_9.MultipartFile>(target, 'MultipartFile');
        return t.finalize();
      },
      'clone': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_9.MultipartFile>(target, 'MultipartFile');
        return t.clone();
      },
    },
    staticMethods: {
      'fromFile': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'fromFile');
        final filePath = D4.getRequiredArg<String>(positional, 0, 'filePath', 'fromFile');
        final filename = D4.getOptionalNamedArg<String?>(named, 'filename');
        final contentType = D4.getOptionalNamedArg<$http_parser_1.MediaType?>(named, 'contentType');
        final headers = D4.coerceMapOrNull<String, List<String>>(named['headers'], 'headers');
        return $dio_9.MultipartFile.fromFile(filePath, filename: filename, contentType: contentType, headers: headers);
      },
      'fromFileSync': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'fromFileSync');
        final filePath = D4.getRequiredArg<String>(positional, 0, 'filePath', 'fromFileSync');
        final filename = D4.getOptionalNamedArg<String?>(named, 'filename');
        final contentType = D4.getOptionalNamedArg<$http_parser_1.MediaType?>(named, 'contentType');
        final headers = D4.coerceMapOrNull<String, List<String>>(named['headers'], 'headers');
        return $dio_9.MultipartFile.fromFileSync(filePath, filename: filename, contentType: contentType, headers: headers);
      },
      'lookupMediaType': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'lookupMediaType');
        final filenameOrPath = D4.getRequiredArg<String?>(positional, 0, 'filenameOrPath', 'lookupMediaType');
        return $dio_9.MultipartFile.lookupMediaType(filenameOrPath);
      },
    },
    constructorSignatures: {
      '': 'MultipartFile(Stream<List<int>> stream, int length, {String? filename, MediaType? contentType, Map<String, List<String>>? headers})',
      'fromStream': 'MultipartFile.fromStream(Stream<List<int>> Function() data, int length, {String? filename, MediaType? contentType, Map<String, List<String>>? headers})',
      'fromBytes': 'factory MultipartFile.fromBytes(List<int> value, {String? filename, MediaType? contentType, Map<String, List<String>>? headers})',
      'fromString': 'factory MultipartFile.fromString(String value, {String? filename, MediaType? contentType, Map<String, List<String>>? headers})',
    },
    methodSignatures: {
      'finalize': 'Stream<Uint8List> finalize()',
      'clone': 'MultipartFile clone()',
    },
    getterSignatures: {
      'length': 'int get length',
      'filename': 'String? get filename',
      'headers': 'Map<String, List<String>>? get headers',
      'contentType': 'MediaType? get contentType',
      'isFinalized': 'bool get isFinalized',
    },
    staticMethodSignatures: {
      'fromFile': 'Future<MultipartFile> fromFile(String filePath, {String? filename, MediaType? contentType, Map<String, List<String>>? headers})',
      'fromFileSync': 'MultipartFile fromFileSync(String filePath, {String? filename, MediaType? contentType, Map<String, List<String>>? headers})',
      'lookupMediaType': 'MediaType? lookupMediaType(String? filenameOrPath)',
    },
  );
}

// =============================================================================
// BaseOptions Bridge
// =============================================================================

BridgedClass _createBaseOptionsBridge() {
  return BridgedClass(
    nativeType: $dio_10.BaseOptions,
    name: 'BaseOptions',
    isAssignable: (v) => v is $dio_10.BaseOptions,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final method = D4.getOptionalNamedArg<String?>(named, 'method');
        final connectTimeout = D4.getOptionalNamedArg<Duration?>(named, 'connectTimeout');
        final receiveTimeout = D4.getOptionalNamedArg<Duration?>(named, 'receiveTimeout');
        final sendTimeout = D4.getOptionalNamedArg<Duration?>(named, 'sendTimeout');
        final transformTimeout = D4.getOptionalNamedArg<Duration?>(named, 'transformTimeout');
        final baseUrl = D4.getNamedArgWithDefault<String>(named, 'baseUrl', '');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final extra = D4.coerceMapOrNull<String, dynamic>(named['extra'], 'extra');
        final headers = D4.coerceMapOrNull<String, dynamic>(named['headers'], 'headers');
        final preserveHeaderCase = D4.getNamedArgWithDefault<bool?>(named, 'preserveHeaderCase', false);
        final responseType = D4.getNamedArgWithDefault<$dio_10.ResponseType?>(named, 'responseType', $dio_10.ResponseType.json);
        final contentType = D4.getOptionalNamedArg<String?>(named, 'contentType');
        final validateStatusRaw = named['validateStatus'];
        final receiveDataWhenStatusError = D4.getOptionalNamedArg<bool?>(named, 'receiveDataWhenStatusError');
        final followRedirects = D4.getOptionalNamedArg<bool?>(named, 'followRedirects');
        final maxRedirects = D4.getOptionalNamedArg<int?>(named, 'maxRedirects');
        final persistentConnection = D4.getOptionalNamedArg<bool?>(named, 'persistentConnection');
        final requestEncoderRaw = named['requestEncoder'];
        final responseDecoderRaw = named['responseDecoder'];
        final listFormat = D4.getOptionalNamedArg<$dio_10.ListFormat?>(named, 'listFormat');
        return $dio_10.BaseOptions(method: method, connectTimeout: connectTimeout, receiveTimeout: receiveTimeout, sendTimeout: sendTimeout, transformTimeout: transformTimeout, baseUrl: baseUrl, queryParameters: queryParameters, extra: extra, headers: headers, preserveHeaderCase: preserveHeaderCase, responseType: responseType, contentType: contentType, validateStatus: validateStatusRaw == null ? null : ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?), receiveDataWhenStatusError: receiveDataWhenStatusError, followRedirects: followRedirects, maxRedirects: maxRedirects, persistentConnection: persistentConnection, requestEncoder: requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions), responseDecoder: responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody), listFormat: listFormat);
      },
    },
    getters: {
      'method': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').method,
      'headers': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').headers,
      'preserveHeaderCase': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').preserveHeaderCase,
      'sendTimeout': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').sendTimeout,
      'receiveTimeout': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').receiveTimeout,
      'transformTimeout': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').transformTimeout,
      'contentType': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').contentType,
      'responseType': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').responseType,
      'validateStatus': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').validateStatus,
      'receiveDataWhenStatusError': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').receiveDataWhenStatusError,
      'extra': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').extra,
      'followRedirects': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').followRedirects,
      'maxRedirects': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').maxRedirects,
      'persistentConnection': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').persistentConnection,
      'requestEncoder': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').requestEncoder,
      'responseDecoder': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').responseDecoder,
      'listFormat': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').listFormat,
      'baseUrl': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').baseUrl,
      'queryParameters': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').queryParameters,
      'connectTimeout': (visitor, target) => D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').connectTimeout,
    },
    setters: {
      'method': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').method = D4.extractBridgedArg<String>(value, 'method'),
      'preserveHeaderCase': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').preserveHeaderCase = D4.extractBridgedArg<bool>(value, 'preserveHeaderCase'),
      'sendTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').sendTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'sendTimeout'),
      'receiveTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').receiveTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'receiveTimeout'),
      'transformTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').transformTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'transformTimeout'),
      'contentType': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').contentType = D4.extractBridgedArgOrNull<String>(value, 'contentType'),
      'responseType': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').responseType = D4.extractBridgedArg<$dio_10.ResponseType>(value, 'responseType'),
      'validateStatus': (visitor, target, value) {
        final validateStatusRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'validateStatus');
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').validateStatus = ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?);
      },
      'receiveDataWhenStatusError': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').receiveDataWhenStatusError = D4.extractBridgedArg<bool>(value, 'receiveDataWhenStatusError'),
      'followRedirects': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').followRedirects = D4.extractBridgedArg<bool>(value, 'followRedirects'),
      'maxRedirects': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').maxRedirects = D4.extractBridgedArg<int>(value, 'maxRedirects'),
      'persistentConnection': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').persistentConnection = D4.extractBridgedArg<bool>(value, 'persistentConnection'),
      'requestEncoder': (visitor, target, value) {
        final requestEncoderRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'requestEncoder');
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').requestEncoder = requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions);
      },
      'responseDecoder': (visitor, target, value) {
        final responseDecoderRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'responseDecoder');
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').responseDecoder = responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody);
      },
      'listFormat': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').listFormat = D4.extractBridgedArg<$dio_10.ListFormat>(value, 'listFormat'),
      'baseUrl': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').baseUrl = D4.extractBridgedArg<String>(value, 'baseUrl'),
      'connectTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions').connectTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'connectTimeout'),
    },
    methods: {
      'copyWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_10.BaseOptions>(target, 'BaseOptions');
        final method = D4.getOptionalNamedArg<String?>(named, 'method');
        final baseUrl = D4.getOptionalNamedArg<String?>(named, 'baseUrl');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        final connectTimeout = D4.getOptionalNamedArg<Duration?>(named, 'connectTimeout');
        final receiveTimeout = D4.getOptionalNamedArg<Duration?>(named, 'receiveTimeout');
        final sendTimeout = D4.getOptionalNamedArg<Duration?>(named, 'sendTimeout');
        final transformTimeout = D4.getOptionalNamedArg<Duration?>(named, 'transformTimeout');
        final extra = D4.coerceMapOrNull<String, Object?>(named['extra'], 'extra');
        final headers = D4.coerceMapOrNull<String, Object?>(named['headers'], 'headers');
        final preserveHeaderCase = D4.getOptionalNamedArg<bool?>(named, 'preserveHeaderCase');
        final responseType = D4.getOptionalNamedArg<$dio_10.ResponseType?>(named, 'responseType');
        final contentType = D4.getOptionalNamedArg<String?>(named, 'contentType');
        final validateStatusRaw = named['validateStatus'];
        final receiveDataWhenStatusError = D4.getOptionalNamedArg<bool?>(named, 'receiveDataWhenStatusError');
        final followRedirects = D4.getOptionalNamedArg<bool?>(named, 'followRedirects');
        final maxRedirects = D4.getOptionalNamedArg<int?>(named, 'maxRedirects');
        final persistentConnection = D4.getOptionalNamedArg<bool?>(named, 'persistentConnection');
        final requestEncoderRaw = named['requestEncoder'];
        final responseDecoderRaw = named['responseDecoder'];
        final listFormat = D4.getOptionalNamedArg<$dio_10.ListFormat?>(named, 'listFormat');
        return t.copyWith(method: method, baseUrl: baseUrl, queryParameters: queryParameters, path: path, connectTimeout: connectTimeout, receiveTimeout: receiveTimeout, sendTimeout: sendTimeout, transformTimeout: transformTimeout, extra: extra, headers: headers, preserveHeaderCase: preserveHeaderCase, responseType: responseType, contentType: contentType, validateStatus: validateStatusRaw == null ? null : ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?), receiveDataWhenStatusError: receiveDataWhenStatusError, followRedirects: followRedirects, maxRedirects: maxRedirects, persistentConnection: persistentConnection, requestEncoder: requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions), responseDecoder: responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody), listFormat: listFormat);
      },
    },
    constructorSignatures: {
      '': 'BaseOptions({String? method, Duration? connectTimeout, Duration? receiveTimeout, Duration? sendTimeout, Duration? transformTimeout, String baseUrl = \'\', Map<String, dynamic>? queryParameters, Map<String, dynamic>? extra, Map<String, dynamic>? headers, bool? preserveHeaderCase = false, ResponseType? responseType = ResponseType.json, String? contentType, ValidateStatus? validateStatus, bool? receiveDataWhenStatusError, bool? followRedirects, int? maxRedirects, bool? persistentConnection, RequestEncoder? requestEncoder, ResponseDecoder? responseDecoder, ListFormat? listFormat})',
    },
    methodSignatures: {
      'copyWith': 'BaseOptions copyWith({String? method, String? baseUrl, Map<String, dynamic>? queryParameters, String? path, Duration? connectTimeout, Duration? receiveTimeout, Duration? sendTimeout, Duration? transformTimeout, Map<String, Object?>? extra, Map<String, Object?>? headers, bool? preserveHeaderCase, ResponseType? responseType, String? contentType, ValidateStatus? validateStatus, bool? receiveDataWhenStatusError, bool? followRedirects, int? maxRedirects, bool? persistentConnection, RequestEncoder? requestEncoder, ResponseDecoder? responseDecoder, ListFormat? listFormat})',
    },
    getterSignatures: {
      'method': 'String get method',
      'headers': 'Map<String, dynamic> get headers',
      'preserveHeaderCase': 'bool get preserveHeaderCase',
      'sendTimeout': 'Duration? get sendTimeout',
      'receiveTimeout': 'Duration? get receiveTimeout',
      'transformTimeout': 'Duration? get transformTimeout',
      'contentType': 'String? get contentType',
      'responseType': 'ResponseType get responseType',
      'validateStatus': 'ValidateStatus get validateStatus',
      'receiveDataWhenStatusError': 'bool get receiveDataWhenStatusError',
      'extra': 'Map<String, dynamic> get extra',
      'followRedirects': 'bool get followRedirects',
      'maxRedirects': 'int get maxRedirects',
      'persistentConnection': 'bool get persistentConnection',
      'requestEncoder': 'RequestEncoder? get requestEncoder',
      'responseDecoder': 'ResponseDecoder? get responseDecoder',
      'listFormat': 'ListFormat get listFormat',
      'baseUrl': 'String get baseUrl',
      'queryParameters': 'Map<String, dynamic> get queryParameters',
      'connectTimeout': 'Duration? get connectTimeout',
    },
    setterSignatures: {
      'method': 'set method(String value)',
      'headers': 'set headers(Map<String, dynamic>? value)',
      'preserveHeaderCase': 'set preserveHeaderCase(bool value)',
      'sendTimeout': 'set sendTimeout(Duration? value)',
      'receiveTimeout': 'set receiveTimeout(Duration? value)',
      'transformTimeout': 'set transformTimeout(Duration? value)',
      'contentType': 'set contentType(String? value)',
      'responseType': 'set responseType(ResponseType value)',
      'validateStatus': 'set validateStatus(ValidateStatus value)',
      'receiveDataWhenStatusError': 'set receiveDataWhenStatusError(bool value)',
      'extra': 'set extra(Map<String, dynamic> value)',
      'followRedirects': 'set followRedirects(bool value)',
      'maxRedirects': 'set maxRedirects(int value)',
      'persistentConnection': 'set persistentConnection(bool value)',
      'requestEncoder': 'set requestEncoder(RequestEncoder? value)',
      'responseDecoder': 'set responseDecoder(ResponseDecoder? value)',
      'listFormat': 'set listFormat(ListFormat value)',
      'baseUrl': 'set baseUrl(String value)',
      'queryParameters': 'set queryParameters(Map<String, dynamic> value)',
      'connectTimeout': 'set connectTimeout(Duration? value)',
    },
  );
}

// =============================================================================
// Options Bridge
// =============================================================================

BridgedClass _createOptionsBridge() {
  return BridgedClass(
    nativeType: $dio_10.Options,
    name: 'Options',
    isAssignable: (v) => v is $dio_10.Options,
    constructors: {
      '': (visitor, positional, named) {
        final method = D4.getOptionalNamedArg<String?>(named, 'method');
        final sendTimeout = D4.getOptionalNamedArg<Duration?>(named, 'sendTimeout');
        final receiveTimeout = D4.getOptionalNamedArg<Duration?>(named, 'receiveTimeout');
        final transformTimeout = D4.getOptionalNamedArg<Duration?>(named, 'transformTimeout');
        final connectTimeout = D4.getOptionalNamedArg<Duration?>(named, 'connectTimeout');
        final extra = D4.coerceMapOrNull<String, dynamic>(named['extra'], 'extra');
        final headers = D4.coerceMapOrNull<String, dynamic>(named['headers'], 'headers');
        final preserveHeaderCase = D4.getOptionalNamedArg<bool?>(named, 'preserveHeaderCase');
        final responseType = D4.getOptionalNamedArg<$dio_10.ResponseType?>(named, 'responseType');
        final contentType = D4.getOptionalNamedArg<String?>(named, 'contentType');
        final validateStatusRaw = named['validateStatus'];
        final receiveDataWhenStatusError = D4.getOptionalNamedArg<bool?>(named, 'receiveDataWhenStatusError');
        final followRedirects = D4.getOptionalNamedArg<bool?>(named, 'followRedirects');
        final maxRedirects = D4.getOptionalNamedArg<int?>(named, 'maxRedirects');
        final persistentConnection = D4.getOptionalNamedArg<bool?>(named, 'persistentConnection');
        final requestEncoderRaw = named['requestEncoder'];
        final responseDecoderRaw = named['responseDecoder'];
        final listFormat = D4.getOptionalNamedArg<$dio_10.ListFormat?>(named, 'listFormat');
        return $dio_10.Options(method: method, sendTimeout: sendTimeout, receiveTimeout: receiveTimeout, transformTimeout: transformTimeout, connectTimeout: connectTimeout, extra: extra, headers: headers, preserveHeaderCase: preserveHeaderCase, responseType: responseType, contentType: contentType, validateStatus: validateStatusRaw == null ? null : ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?), receiveDataWhenStatusError: receiveDataWhenStatusError, followRedirects: followRedirects, maxRedirects: maxRedirects, persistentConnection: persistentConnection, requestEncoder: requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions), responseDecoder: responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody), listFormat: listFormat);
      },
    },
    getters: {
      'method': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').method,
      'headers': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').headers,
      'preserveHeaderCase': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').preserveHeaderCase,
      'contentType': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').contentType,
      'responseType': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').responseType,
      'validateStatus': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').validateStatus,
      'receiveDataWhenStatusError': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').receiveDataWhenStatusError,
      'extra': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').extra,
      'followRedirects': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').followRedirects,
      'maxRedirects': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').maxRedirects,
      'persistentConnection': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').persistentConnection,
      'requestEncoder': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').requestEncoder,
      'responseDecoder': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').responseDecoder,
      'listFormat': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').listFormat,
      'sendTimeout': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').sendTimeout,
      'receiveTimeout': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').receiveTimeout,
      'transformTimeout': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').transformTimeout,
      'connectTimeout': (visitor, target) => D4.validateTarget<$dio_10.Options>(target, 'Options').connectTimeout,
    },
    setters: {
      'method': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').method = D4.extractBridgedArgOrNull<String>(value, 'method'),
      'preserveHeaderCase': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').preserveHeaderCase = D4.extractBridgedArgOrNull<bool>(value, 'preserveHeaderCase'),
      'contentType': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').contentType = D4.extractBridgedArgOrNull<String>(value, 'contentType'),
      'responseType': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').responseType = D4.extractBridgedArgOrNull<$dio_10.ResponseType>(value, 'responseType'),
      'validateStatus': (visitor, target, value) {
        final validateStatusRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'validateStatus');
        D4.validateTarget<$dio_10.Options>(target, 'Options').validateStatus = validateStatusRaw == null ? null : ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?);
      },
      'receiveDataWhenStatusError': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').receiveDataWhenStatusError = D4.extractBridgedArgOrNull<bool>(value, 'receiveDataWhenStatusError'),
      'followRedirects': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').followRedirects = D4.extractBridgedArgOrNull<bool>(value, 'followRedirects'),
      'maxRedirects': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').maxRedirects = D4.extractBridgedArgOrNull<int>(value, 'maxRedirects'),
      'persistentConnection': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').persistentConnection = D4.extractBridgedArgOrNull<bool>(value, 'persistentConnection'),
      'requestEncoder': (visitor, target, value) {
        final requestEncoderRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'requestEncoder');
        D4.validateTarget<$dio_10.Options>(target, 'Options').requestEncoder = requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions);
      },
      'responseDecoder': (visitor, target, value) {
        final responseDecoderRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'responseDecoder');
        D4.validateTarget<$dio_10.Options>(target, 'Options').responseDecoder = responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody);
      },
      'listFormat': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').listFormat = D4.extractBridgedArgOrNull<$dio_10.ListFormat>(value, 'listFormat'),
      'sendTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').sendTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'sendTimeout'),
      'receiveTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').receiveTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'receiveTimeout'),
      'transformTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').transformTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'transformTimeout'),
      'connectTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.Options>(target, 'Options').connectTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'connectTimeout'),
    },
    methods: {
      'copyWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_10.Options>(target, 'Options');
        final method = D4.getOptionalNamedArg<String?>(named, 'method');
        final sendTimeout = D4.getOptionalNamedArg<Duration?>(named, 'sendTimeout');
        final receiveTimeout = D4.getOptionalNamedArg<Duration?>(named, 'receiveTimeout');
        final transformTimeout = D4.getOptionalNamedArg<Duration?>(named, 'transformTimeout');
        final connectTimeout = D4.getOptionalNamedArg<Duration?>(named, 'connectTimeout');
        final extra = D4.coerceMapOrNull<String, Object?>(named['extra'], 'extra');
        final headers = D4.coerceMapOrNull<String, Object?>(named['headers'], 'headers');
        final preserveHeaderCase = D4.getOptionalNamedArg<bool?>(named, 'preserveHeaderCase');
        final responseType = D4.getOptionalNamedArg<$dio_10.ResponseType?>(named, 'responseType');
        final contentType = D4.getOptionalNamedArg<String?>(named, 'contentType');
        final validateStatusRaw = named['validateStatus'];
        final receiveDataWhenStatusError = D4.getOptionalNamedArg<bool?>(named, 'receiveDataWhenStatusError');
        final followRedirects = D4.getOptionalNamedArg<bool?>(named, 'followRedirects');
        final maxRedirects = D4.getOptionalNamedArg<int?>(named, 'maxRedirects');
        final persistentConnection = D4.getOptionalNamedArg<bool?>(named, 'persistentConnection');
        final requestEncoderRaw = named['requestEncoder'];
        final responseDecoderRaw = named['responseDecoder'];
        final listFormat = D4.getOptionalNamedArg<$dio_10.ListFormat?>(named, 'listFormat');
        return t.copyWith(method: method, sendTimeout: sendTimeout, receiveTimeout: receiveTimeout, transformTimeout: transformTimeout, connectTimeout: connectTimeout, extra: extra, headers: headers, preserveHeaderCase: preserveHeaderCase, responseType: responseType, contentType: contentType, validateStatus: validateStatusRaw == null ? null : ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?), receiveDataWhenStatusError: receiveDataWhenStatusError, followRedirects: followRedirects, maxRedirects: maxRedirects, persistentConnection: persistentConnection, requestEncoder: requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions), responseDecoder: responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody), listFormat: listFormat);
      },
      'compose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_10.Options>(target, 'Options');
        D4.requireMinArgs(positional, 2, 'compose');
        final baseOpt = D4.getRequiredArg<$dio_10.BaseOptions>(positional, 0, 'baseOpt', 'compose');
        final path = D4.getRequiredArg<String>(positional, 1, 'path', 'compose');
        final data = D4.getOptionalNamedArg<Object?>(named, 'data');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final onSendProgressRaw = named['onSendProgress'];
        final onReceiveProgressRaw = named['onReceiveProgress'];
        final sourceStackTrace = D4.getOptionalNamedArg<StackTrace?>(named, 'sourceStackTrace');
        return t.compose(baseOpt, path, data: data, queryParameters: queryParameters, cancelToken: cancelToken, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); }, sourceStackTrace: sourceStackTrace);
      },
    },
    constructorSignatures: {
      '': 'Options({String? method, Duration? sendTimeout, Duration? receiveTimeout, Duration? transformTimeout, Duration? connectTimeout, Map<String, dynamic>? extra, Map<String, dynamic>? headers, bool? preserveHeaderCase, ResponseType? responseType, String? contentType, ValidateStatus? validateStatus, bool? receiveDataWhenStatusError, bool? followRedirects, int? maxRedirects, bool? persistentConnection, RequestEncoder? requestEncoder, ResponseDecoder? responseDecoder, ListFormat? listFormat})',
    },
    methodSignatures: {
      'copyWith': 'Options copyWith({String? method, Duration? sendTimeout, Duration? receiveTimeout, Duration? transformTimeout, Duration? connectTimeout, Map<String, Object?>? extra, Map<String, Object?>? headers, bool? preserveHeaderCase, ResponseType? responseType, String? contentType, ValidateStatus? validateStatus, bool? receiveDataWhenStatusError, bool? followRedirects, int? maxRedirects, bool? persistentConnection, RequestEncoder? requestEncoder, ResponseDecoder? responseDecoder, ListFormat? listFormat})',
      'compose': 'RequestOptions compose(BaseOptions baseOpt, String path, {Object? data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress, StackTrace? sourceStackTrace})',
    },
    getterSignatures: {
      'method': 'String? get method',
      'headers': 'Map<String, dynamic>? get headers',
      'preserveHeaderCase': 'bool? get preserveHeaderCase',
      'contentType': 'String? get contentType',
      'responseType': 'ResponseType? get responseType',
      'validateStatus': 'ValidateStatus? get validateStatus',
      'receiveDataWhenStatusError': 'bool? get receiveDataWhenStatusError',
      'extra': 'Map<String, dynamic>? get extra',
      'followRedirects': 'bool? get followRedirects',
      'maxRedirects': 'int? get maxRedirects',
      'persistentConnection': 'bool? get persistentConnection',
      'requestEncoder': 'RequestEncoder? get requestEncoder',
      'responseDecoder': 'ResponseDecoder? get responseDecoder',
      'listFormat': 'ListFormat? get listFormat',
      'sendTimeout': 'Duration? get sendTimeout',
      'receiveTimeout': 'Duration? get receiveTimeout',
      'transformTimeout': 'Duration? get transformTimeout',
      'connectTimeout': 'Duration? get connectTimeout',
    },
    setterSignatures: {
      'method': 'set method(dynamic value)',
      'headers': 'set headers(dynamic value)',
      'preserveHeaderCase': 'set preserveHeaderCase(dynamic value)',
      'contentType': 'set contentType(dynamic value)',
      'responseType': 'set responseType(dynamic value)',
      'validateStatus': 'set validateStatus(dynamic value)',
      'receiveDataWhenStatusError': 'set receiveDataWhenStatusError(dynamic value)',
      'extra': 'set extra(dynamic value)',
      'followRedirects': 'set followRedirects(dynamic value)',
      'maxRedirects': 'set maxRedirects(dynamic value)',
      'persistentConnection': 'set persistentConnection(dynamic value)',
      'requestEncoder': 'set requestEncoder(dynamic value)',
      'responseDecoder': 'set responseDecoder(dynamic value)',
      'listFormat': 'set listFormat(dynamic value)',
      'sendTimeout': 'set sendTimeout(Duration? value)',
      'receiveTimeout': 'set receiveTimeout(Duration? value)',
      'transformTimeout': 'set transformTimeout(Duration? value)',
      'connectTimeout': 'set connectTimeout(Duration? value)',
    },
  );
}

// =============================================================================
// RequestOptions Bridge
// =============================================================================

BridgedClass _createRequestOptionsBridge() {
  return BridgedClass(
    nativeType: $dio_10.RequestOptions,
    name: 'RequestOptions',
    isAssignable: (v) => v is $dio_10.RequestOptions,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        final path = D4.getNamedArgWithDefault<String>(named, 'path', '');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        final onSendProgressRaw = named['onSendProgress'];
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final method = D4.getOptionalNamedArg<String?>(named, 'method');
        final sendTimeout = D4.getOptionalNamedArg<Duration?>(named, 'sendTimeout');
        final receiveTimeout = D4.getOptionalNamedArg<Duration?>(named, 'receiveTimeout');
        final transformTimeout = D4.getOptionalNamedArg<Duration?>(named, 'transformTimeout');
        final connectTimeout = D4.getOptionalNamedArg<Duration?>(named, 'connectTimeout');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final baseUrl = D4.getOptionalNamedArg<String?>(named, 'baseUrl');
        final extra = D4.coerceMapOrNull<String, dynamic>(named['extra'], 'extra');
        final headers = D4.coerceMapOrNull<String, dynamic>(named['headers'], 'headers');
        final preserveHeaderCase = D4.getOptionalNamedArg<bool?>(named, 'preserveHeaderCase');
        final responseType = D4.getOptionalNamedArg<$dio_10.ResponseType?>(named, 'responseType');
        final contentType = D4.getOptionalNamedArg<String?>(named, 'contentType');
        final validateStatusRaw = named['validateStatus'];
        final receiveDataWhenStatusError = D4.getOptionalNamedArg<bool?>(named, 'receiveDataWhenStatusError');
        final followRedirects = D4.getOptionalNamedArg<bool?>(named, 'followRedirects');
        final maxRedirects = D4.getOptionalNamedArg<int?>(named, 'maxRedirects');
        final persistentConnection = D4.getOptionalNamedArg<bool?>(named, 'persistentConnection');
        final requestEncoderRaw = named['requestEncoder'];
        final responseDecoderRaw = named['responseDecoder'];
        final listFormat = D4.getOptionalNamedArg<$dio_10.ListFormat?>(named, 'listFormat');
        final setRequestContentTypeWhenNoPayload = D4.getOptionalNamedArg<bool?>(named, 'setRequestContentTypeWhenNoPayload');
        final sourceStackTrace = D4.getOptionalNamedArg<StackTrace?>(named, 'sourceStackTrace');
        if (!named.containsKey('data')) {
          return $dio_10.RequestOptions(path: path, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); }, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, cancelToken: cancelToken, method: method, sendTimeout: sendTimeout, receiveTimeout: receiveTimeout, transformTimeout: transformTimeout, connectTimeout: connectTimeout, queryParameters: queryParameters, baseUrl: baseUrl, extra: extra, headers: headers, preserveHeaderCase: preserveHeaderCase, responseType: responseType, contentType: contentType, validateStatus: validateStatusRaw == null ? null : ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?), receiveDataWhenStatusError: receiveDataWhenStatusError, followRedirects: followRedirects, maxRedirects: maxRedirects, persistentConnection: persistentConnection, requestEncoder: requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions), responseDecoder: responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody), listFormat: listFormat, setRequestContentTypeWhenNoPayload: setRequestContentTypeWhenNoPayload, sourceStackTrace: sourceStackTrace);
        }
        if (named.containsKey('data')) {
          final data = D4.getRequiredNamedArg<dynamic>(named, 'data', 'RequestOptions');
          return $dio_10.RequestOptions(path: path, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); }, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, cancelToken: cancelToken, method: method, sendTimeout: sendTimeout, receiveTimeout: receiveTimeout, transformTimeout: transformTimeout, connectTimeout: connectTimeout, queryParameters: queryParameters, baseUrl: baseUrl, extra: extra, headers: headers, preserveHeaderCase: preserveHeaderCase, responseType: responseType, contentType: contentType, validateStatus: validateStatusRaw == null ? null : ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?), receiveDataWhenStatusError: receiveDataWhenStatusError, followRedirects: followRedirects, maxRedirects: maxRedirects, persistentConnection: persistentConnection, requestEncoder: requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions), responseDecoder: responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody), listFormat: listFormat, setRequestContentTypeWhenNoPayload: setRequestContentTypeWhenNoPayload, sourceStackTrace: sourceStackTrace, data: data);
        }
        throw StateError('Unreachable: all named parameter combinations should be covered');
      },
    },
    getters: {
      'data': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').data,
      'path': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').path,
      'cancelToken': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').cancelToken,
      'onReceiveProgress': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').onReceiveProgress,
      'onSendProgress': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').onSendProgress,
      'uri': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').uri,
      'method': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').method,
      'headers': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').headers,
      'preserveHeaderCase': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').preserveHeaderCase,
      'sendTimeout': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').sendTimeout,
      'receiveTimeout': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').receiveTimeout,
      'transformTimeout': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').transformTimeout,
      'contentType': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').contentType,
      'responseType': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').responseType,
      'validateStatus': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').validateStatus,
      'receiveDataWhenStatusError': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').receiveDataWhenStatusError,
      'extra': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').extra,
      'followRedirects': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').followRedirects,
      'maxRedirects': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').maxRedirects,
      'persistentConnection': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').persistentConnection,
      'requestEncoder': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').requestEncoder,
      'responseDecoder': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').responseDecoder,
      'listFormat': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').listFormat,
      'baseUrl': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').baseUrl,
      'queryParameters': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').queryParameters,
      'connectTimeout': (visitor, target) => D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').connectTimeout,
    },
    setters: {
      'data': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').data = value as dynamic,
      'path': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').path = D4.extractBridgedArg<String>(value, 'path'),
      'cancelToken': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').cancelToken = D4.extractBridgedArgOrNull<$dio_2.CancelToken>(value, 'cancelToken'),
      'onReceiveProgress': (visitor, target, value) {
        final onReceiveProgressRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'onReceiveProgress');
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').onReceiveProgress = onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); };
      },
      'onSendProgress': (visitor, target, value) {
        final onSendProgressRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'onSendProgress');
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').onSendProgress = onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); };
      },
      'method': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').method = D4.extractBridgedArg<String>(value, 'method'),
      'preserveHeaderCase': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').preserveHeaderCase = D4.extractBridgedArg<bool>(value, 'preserveHeaderCase'),
      'sendTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').sendTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'sendTimeout'),
      'receiveTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').receiveTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'receiveTimeout'),
      'transformTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').transformTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'transformTimeout'),
      'contentType': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').contentType = D4.extractBridgedArgOrNull<String>(value, 'contentType'),
      'responseType': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').responseType = D4.extractBridgedArg<$dio_10.ResponseType>(value, 'responseType'),
      'validateStatus': (visitor, target, value) {
        final validateStatusRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'validateStatus');
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').validateStatus = ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?);
      },
      'receiveDataWhenStatusError': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').receiveDataWhenStatusError = D4.extractBridgedArg<bool>(value, 'receiveDataWhenStatusError'),
      'followRedirects': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').followRedirects = D4.extractBridgedArg<bool>(value, 'followRedirects'),
      'maxRedirects': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').maxRedirects = D4.extractBridgedArg<int>(value, 'maxRedirects'),
      'persistentConnection': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').persistentConnection = D4.extractBridgedArg<bool>(value, 'persistentConnection'),
      'requestEncoder': (visitor, target, value) {
        final requestEncoderRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'requestEncoder');
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').requestEncoder = requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions);
      },
      'responseDecoder': (visitor, target, value) {
        final responseDecoderRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'responseDecoder');
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').responseDecoder = responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody);
      },
      'listFormat': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').listFormat = D4.extractBridgedArg<$dio_10.ListFormat>(value, 'listFormat'),
      'baseUrl': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').baseUrl = D4.extractBridgedArg<String>(value, 'baseUrl'),
      'connectTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions').connectTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'connectTimeout'),
    },
    methods: {
      'copyWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_10.RequestOptions>(target, 'RequestOptions');
        final method = D4.getOptionalNamedArg<String?>(named, 'method');
        final sendTimeout = D4.getOptionalNamedArg<Duration?>(named, 'sendTimeout');
        final receiveTimeout = D4.getOptionalNamedArg<Duration?>(named, 'receiveTimeout');
        final transformTimeout = D4.getOptionalNamedArg<Duration?>(named, 'transformTimeout');
        final connectTimeout = D4.getOptionalNamedArg<Duration?>(named, 'connectTimeout');
        final path = D4.getOptionalNamedArg<String?>(named, 'path');
        final queryParameters = D4.coerceMapOrNull<String, dynamic>(named['queryParameters'], 'queryParameters');
        final baseUrl = D4.getOptionalNamedArg<String?>(named, 'baseUrl');
        final onReceiveProgressRaw = named['onReceiveProgress'];
        final onSendProgressRaw = named['onSendProgress'];
        final cancelToken = D4.getOptionalNamedArg<$dio_2.CancelToken?>(named, 'cancelToken');
        final extra = D4.coerceMapOrNull<String, dynamic>(named['extra'], 'extra');
        final headers = D4.coerceMapOrNull<String, dynamic>(named['headers'], 'headers');
        final preserveHeaderCase = D4.getOptionalNamedArg<bool?>(named, 'preserveHeaderCase');
        final responseType = D4.getOptionalNamedArg<$dio_10.ResponseType?>(named, 'responseType');
        final contentType = D4.getOptionalNamedArg<String?>(named, 'contentType');
        final validateStatusRaw = named['validateStatus'];
        final receiveDataWhenStatusError = D4.getOptionalNamedArg<bool?>(named, 'receiveDataWhenStatusError');
        final followRedirects = D4.getOptionalNamedArg<bool?>(named, 'followRedirects');
        final maxRedirects = D4.getOptionalNamedArg<int?>(named, 'maxRedirects');
        final persistentConnection = D4.getOptionalNamedArg<bool?>(named, 'persistentConnection');
        final requestEncoderRaw = named['requestEncoder'];
        final responseDecoderRaw = named['responseDecoder'];
        final listFormat = D4.getOptionalNamedArg<$dio_10.ListFormat?>(named, 'listFormat');
        final setRequestContentTypeWhenNoPayload = D4.getOptionalNamedArg<bool?>(named, 'setRequestContentTypeWhenNoPayload');
        if (!named.containsKey('data')) {
          return t.copyWith(method: method, sendTimeout: sendTimeout, receiveTimeout: receiveTimeout, transformTimeout: transformTimeout, connectTimeout: connectTimeout, path: path, queryParameters: queryParameters, baseUrl: baseUrl, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); }, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, cancelToken: cancelToken, extra: extra, headers: headers, preserveHeaderCase: preserveHeaderCase, responseType: responseType, contentType: contentType, validateStatus: validateStatusRaw == null ? null : ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?), receiveDataWhenStatusError: receiveDataWhenStatusError, followRedirects: followRedirects, maxRedirects: maxRedirects, persistentConnection: persistentConnection, requestEncoder: requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions), responseDecoder: responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody), listFormat: listFormat, setRequestContentTypeWhenNoPayload: setRequestContentTypeWhenNoPayload);
        }
        if (named.containsKey('data')) {
          final data = D4.getRequiredNamedArg<dynamic>(named, 'data', 'copyWith');
          return t.copyWith(method: method, sendTimeout: sendTimeout, receiveTimeout: receiveTimeout, transformTimeout: transformTimeout, connectTimeout: connectTimeout, path: path, queryParameters: queryParameters, baseUrl: baseUrl, onReceiveProgress: onReceiveProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onReceiveProgressRaw, [p0, p1]); }, onSendProgress: onSendProgressRaw == null ? null : (int p0, int p1) { D4.callInterpreterCallback(visitor!, onSendProgressRaw, [p0, p1]); }, cancelToken: cancelToken, extra: extra, headers: headers, preserveHeaderCase: preserveHeaderCase, responseType: responseType, contentType: contentType, validateStatus: validateStatusRaw == null ? null : ((int? p0) { return D4.callInterpreterCallback(visitor!, validateStatusRaw, [p0]) as bool; }) as bool Function(int?), receiveDataWhenStatusError: receiveDataWhenStatusError, followRedirects: followRedirects, maxRedirects: maxRedirects, persistentConnection: persistentConnection, requestEncoder: requestEncoderRaw == null ? null : ((String p0, $dio_10.RequestOptions p1) { return D4.extractBridgedArg<FutureOr<List<int>>>(D4.callInterpreterCallback(visitor!, requestEncoderRaw, [p0, p1]), 'callback', visitor) as FutureOr<List<int>>; }) as FutureOr<List<int>> Function(String, $dio_10.RequestOptions), responseDecoder: responseDecoderRaw == null ? null : ((List<int> p0, $dio_10.RequestOptions p1, $dio_1.ResponseBody p2) { return D4.extractBridgedArg<FutureOr<String?>>(D4.callInterpreterCallback(visitor!, responseDecoderRaw, [p0, p1, p2]), 'callback', visitor) as FutureOr<String?>; }) as FutureOr<String?> Function(List<int>, $dio_10.RequestOptions, $dio_1.ResponseBody), listFormat: listFormat, setRequestContentTypeWhenNoPayload: setRequestContentTypeWhenNoPayload, data: data);
        }
        throw StateError('Unreachable: all named parameter combinations should be covered');
      },
    },
    constructorSignatures: {
      '': 'RequestOptions({String path = \'\', dynamic data, ProgressCallback? onReceiveProgress, ProgressCallback? onSendProgress, CancelToken? cancelToken, String? method, Duration? sendTimeout, Duration? receiveTimeout, Duration? transformTimeout, Duration? connectTimeout, Map<String, dynamic>? queryParameters, String? baseUrl, Map<String, dynamic>? extra, Map<String, dynamic>? headers, bool? preserveHeaderCase, ResponseType? responseType, String? contentType, ValidateStatus? validateStatus, bool? receiveDataWhenStatusError, bool? followRedirects, int? maxRedirects, bool? persistentConnection, RequestEncoder? requestEncoder, ResponseDecoder? responseDecoder, ListFormat? listFormat, bool? setRequestContentTypeWhenNoPayload, StackTrace? sourceStackTrace})',
    },
    methodSignatures: {
      'copyWith': 'RequestOptions copyWith({String? method, Duration? sendTimeout, Duration? receiveTimeout, Duration? transformTimeout, Duration? connectTimeout, dynamic data, String? path, Map<String, dynamic>? queryParameters, String? baseUrl, ProgressCallback? onReceiveProgress, ProgressCallback? onSendProgress, CancelToken? cancelToken, Map<String, dynamic>? extra, Map<String, dynamic>? headers, bool? preserveHeaderCase, ResponseType? responseType, String? contentType, ValidateStatus? validateStatus, bool? receiveDataWhenStatusError, bool? followRedirects, int? maxRedirects, bool? persistentConnection, RequestEncoder? requestEncoder, ResponseDecoder? responseDecoder, ListFormat? listFormat, bool? setRequestContentTypeWhenNoPayload})',
    },
    getterSignatures: {
      'data': 'dynamic get data',
      'path': 'String get path',
      'cancelToken': 'CancelToken? get cancelToken',
      'onReceiveProgress': 'ProgressCallback? get onReceiveProgress',
      'onSendProgress': 'ProgressCallback? get onSendProgress',
      'uri': 'Uri get uri',
      'method': 'String get method',
      'headers': 'Map<String, dynamic> get headers',
      'preserveHeaderCase': 'bool get preserveHeaderCase',
      'sendTimeout': 'Duration? get sendTimeout',
      'receiveTimeout': 'Duration? get receiveTimeout',
      'transformTimeout': 'Duration? get transformTimeout',
      'contentType': 'String? get contentType',
      'responseType': 'ResponseType get responseType',
      'validateStatus': 'ValidateStatus get validateStatus',
      'receiveDataWhenStatusError': 'bool get receiveDataWhenStatusError',
      'extra': 'Map<String, dynamic> get extra',
      'followRedirects': 'bool get followRedirects',
      'maxRedirects': 'int get maxRedirects',
      'persistentConnection': 'bool get persistentConnection',
      'requestEncoder': 'RequestEncoder? get requestEncoder',
      'responseDecoder': 'ResponseDecoder? get responseDecoder',
      'listFormat': 'ListFormat get listFormat',
      'baseUrl': 'String get baseUrl',
      'queryParameters': 'Map<String, dynamic> get queryParameters',
      'connectTimeout': 'Duration? get connectTimeout',
    },
    setterSignatures: {
      'data': 'set data(dynamic value)',
      'path': 'set path(dynamic value)',
      'cancelToken': 'set cancelToken(dynamic value)',
      'onReceiveProgress': 'set onReceiveProgress(dynamic value)',
      'onSendProgress': 'set onSendProgress(dynamic value)',
      'method': 'set method(String value)',
      'headers': 'set headers(Map<String, dynamic>? value)',
      'preserveHeaderCase': 'set preserveHeaderCase(bool value)',
      'sendTimeout': 'set sendTimeout(Duration? value)',
      'receiveTimeout': 'set receiveTimeout(Duration? value)',
      'transformTimeout': 'set transformTimeout(Duration? value)',
      'contentType': 'set contentType(String? value)',
      'responseType': 'set responseType(ResponseType value)',
      'validateStatus': 'set validateStatus(ValidateStatus value)',
      'receiveDataWhenStatusError': 'set receiveDataWhenStatusError(bool value)',
      'extra': 'set extra(Map<String, dynamic> value)',
      'followRedirects': 'set followRedirects(bool value)',
      'maxRedirects': 'set maxRedirects(int value)',
      'persistentConnection': 'set persistentConnection(bool value)',
      'requestEncoder': 'set requestEncoder(RequestEncoder? value)',
      'responseDecoder': 'set responseDecoder(ResponseDecoder? value)',
      'listFormat': 'set listFormat(ListFormat value)',
      'baseUrl': 'set baseUrl(String value)',
      'queryParameters': 'set queryParameters(Map<String, dynamic> value)',
      'connectTimeout': 'set connectTimeout(Duration? value)',
    },
  );
}

// =============================================================================
// OptionsMixin Bridge
// =============================================================================

BridgedClass _createOptionsMixinBridge() {
  return BridgedClass(
    nativeType: $dio_10.OptionsMixin,
    name: 'OptionsMixin',
    isAssignable: (v) => v is $dio_10.OptionsMixin,
    canBeUsedAsMixin: true,
    isAbstract: true,
    constructors: {
    },
    getters: {
      'queryParameters': (visitor, target) => D4.validateTarget<$dio_10.OptionsMixin>(target, 'OptionsMixin').queryParameters,
      'baseUrl': (visitor, target) => D4.validateTarget<$dio_10.OptionsMixin>(target, 'OptionsMixin').baseUrl,
      'connectTimeout': (visitor, target) => D4.validateTarget<$dio_10.OptionsMixin>(target, 'OptionsMixin').connectTimeout,
    },
    setters: {
      'baseUrl': (visitor, target, value) => 
        D4.validateTarget<$dio_10.OptionsMixin>(target, 'OptionsMixin').baseUrl = D4.extractBridgedArg<String>(value, 'baseUrl'),
      'connectTimeout': (visitor, target, value) => 
        D4.validateTarget<$dio_10.OptionsMixin>(target, 'OptionsMixin').connectTimeout = D4.extractBridgedArgOrNull<Duration>(value, 'connectTimeout'),
    },
    getterSignatures: {
      'queryParameters': 'Map<String, dynamic> get queryParameters',
      'baseUrl': 'String get baseUrl',
      'connectTimeout': 'Duration? get connectTimeout',
    },
    setterSignatures: {
      'queryParameters': 'set queryParameters(dynamic value)',
      'baseUrl': 'set baseUrl(String value)',
      'connectTimeout': 'set connectTimeout(Duration? value)',
    },
  );
}

// =============================================================================
// ListParam Bridge
// =============================================================================

BridgedClass _createListParamBridge() {
  return BridgedClass(
    nativeType: $dio_11.ListParam,
    name: 'ListParam',
    isAssignable: (v) => v is $dio_11.ListParam,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'ListParam');
        if (positional.isEmpty) {
          throw ArgumentError('ListParam: Missing required argument "value" at position 0');
        }
        final value = D4.coerceList<dynamic>(positional[0], 'value');
        final format = D4.getRequiredArg<$dio_10.ListFormat>(positional, 1, 'format', 'ListParam');
        return $dio_11.ListParam(value, format);
      },
    },
    getters: {
      'value': (visitor, target) => D4.validateTarget<$dio_11.ListParam>(target, 'ListParam').value,
      'format': (visitor, target) => D4.validateTarget<$dio_11.ListParam>(target, 'ListParam').format,
      'hashCode': (visitor, target) => D4.validateTarget<$dio_11.ListParam>(target, 'ListParam').hashCode,
    },
    methods: {
      'copyWith': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_11.ListParam>(target, 'ListParam');
        final value = D4.coerceListOrNull<dynamic>(named['value'], 'value');
        final format = D4.getOptionalNamedArg<$dio_10.ListFormat?>(named, 'format');
        return t.copyWith(value: value, format: format);
      },
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_11.ListParam>(target, 'ListParam');
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_11.ListParam>(target, 'ListParam');
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(positional, 0, 'other', 'operator==');
        return t == other;
      },
    },
    constructorSignatures: {
      '': 'const ListParam(List<T> value, ListFormat format)',
    },
    methodSignatures: {
      'copyWith': 'ListParam<T> copyWith({List<T>? value, ListFormat? format})',
      'toString': 'String toString()',
    },
    getterSignatures: {
      'value': 'List<T> get value',
      'format': 'ListFormat get format',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// RedirectRecord Bridge
// =============================================================================

BridgedClass _createRedirectRecordBridge() {
  return BridgedClass(
    nativeType: $dio_12.RedirectRecord,
    name: 'RedirectRecord',
    isAssignable: (v) => v is $dio_12.RedirectRecord,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 3, 'RedirectRecord');
        final statusCode = D4.getRequiredArg<int>(positional, 0, 'statusCode', 'RedirectRecord');
        final method = D4.getRequiredArg<String>(positional, 1, 'method', 'RedirectRecord');
        final location = D4.getRequiredArg<Uri>(positional, 2, 'location', 'RedirectRecord');
        return $dio_12.RedirectRecord(statusCode, method, location);
      },
    },
    getters: {
      'statusCode': (visitor, target) => D4.validateTarget<$dio_12.RedirectRecord>(target, 'RedirectRecord').statusCode,
      'method': (visitor, target) => D4.validateTarget<$dio_12.RedirectRecord>(target, 'RedirectRecord').method,
      'location': (visitor, target) => D4.validateTarget<$dio_12.RedirectRecord>(target, 'RedirectRecord').location,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_12.RedirectRecord>(target, 'RedirectRecord');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'const RedirectRecord(int statusCode, String method, Uri location)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'statusCode': 'int get statusCode',
      'method': 'String get method',
      'location': 'Uri get location',
    },
  );
}

// =============================================================================
// Response Bridge
// =============================================================================

BridgedClass _createResponseBridge() {
  return BridgedClass(
    nativeType: $dio_13.Response,
    name: 'Response',
    isAssignable: (v) => v is $dio_13.Response,
    constructors: {
      '': (visitor, positional, named) {
        final data = D4.getOptionalNamedArg<dynamic>(named, 'data');
        final requestOptions = D4.getRequiredNamedArg<$dio_10.RequestOptions>(named, 'requestOptions', 'Response');
        final statusCode = D4.getOptionalNamedArg<int?>(named, 'statusCode');
        final statusMessage = D4.getOptionalNamedArg<String?>(named, 'statusMessage');
        final isRedirect = D4.getNamedArgWithDefault<bool>(named, 'isRedirect', false);
        final redirects = named.containsKey('redirects') && named['redirects'] != null
            ? D4.coerceList<$dio_12.RedirectRecord>(named['redirects'], 'redirects')
            : const <$dio_12.RedirectRecord>[];
        final extra = D4.coerceMapOrNull<String, dynamic>(named['extra'], 'extra');
        final headers = D4.getOptionalNamedArg<$dio_7.Headers?>(named, 'headers');
        return $dio_13.Response(data: data, requestOptions: requestOptions, statusCode: statusCode, statusMessage: statusMessage, isRedirect: isRedirect, redirects: redirects, extra: extra, headers: headers);
      },
    },
    getters: {
      'data': (visitor, target) => D4.validateTarget<$dio_13.Response>(target, 'Response').data,
      'requestOptions': (visitor, target) => D4.validateTarget<$dio_13.Response>(target, 'Response').requestOptions,
      'statusCode': (visitor, target) => D4.validateTarget<$dio_13.Response>(target, 'Response').statusCode,
      'statusMessage': (visitor, target) => D4.validateTarget<$dio_13.Response>(target, 'Response').statusMessage,
      'headers': (visitor, target) => D4.validateTarget<$dio_13.Response>(target, 'Response').headers,
      'isRedirect': (visitor, target) => D4.validateTarget<$dio_13.Response>(target, 'Response').isRedirect,
      'redirects': (visitor, target) => D4.validateTarget<$dio_13.Response>(target, 'Response').redirects,
      'extra': (visitor, target) => D4.validateTarget<$dio_13.Response>(target, 'Response').extra,
      'realUri': (visitor, target) => D4.validateTarget<$dio_13.Response>(target, 'Response').realUri,
    },
    setters: {
      'data': (visitor, target, value) => 
        D4.validateTarget<$dio_13.Response>(target, 'Response').data = D4.extractBridgedArgOrNull<dynamic>(value, 'data'),
      'requestOptions': (visitor, target, value) => 
        D4.validateTarget<$dio_13.Response>(target, 'Response').requestOptions = D4.extractBridgedArg<$dio_10.RequestOptions>(value, 'requestOptions'),
      'statusCode': (visitor, target, value) => 
        D4.validateTarget<$dio_13.Response>(target, 'Response').statusCode = D4.extractBridgedArgOrNull<int>(value, 'statusCode'),
      'statusMessage': (visitor, target, value) => 
        D4.validateTarget<$dio_13.Response>(target, 'Response').statusMessage = D4.extractBridgedArgOrNull<String>(value, 'statusMessage'),
      'headers': (visitor, target, value) => 
        D4.validateTarget<$dio_13.Response>(target, 'Response').headers = D4.extractBridgedArg<$dio_7.Headers>(value, 'headers'),
      'isRedirect': (visitor, target, value) => 
        D4.validateTarget<$dio_13.Response>(target, 'Response').isRedirect = D4.extractBridgedArg<bool>(value, 'isRedirect'),
      'redirects': (visitor, target, value) => 
        D4.validateTarget<$dio_13.Response>(target, 'Response').redirects = D4.coerceList<$dio_12.RedirectRecord>(value, 'redirects'),
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_13.Response>(target, 'Response');
        return t.toString();
      },
    },
    constructorSignatures: {
      '': 'Response({T? data, required RequestOptions requestOptions, int? statusCode, String? statusMessage, bool isRedirect = false, List<RedirectRecord> redirects = const [], Map<String, dynamic>? extra, Headers? headers})',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'data': 'T? get data',
      'requestOptions': 'RequestOptions get requestOptions',
      'statusCode': 'int? get statusCode',
      'statusMessage': 'String? get statusMessage',
      'headers': 'Headers get headers',
      'isRedirect': 'bool get isRedirect',
      'redirects': 'List<RedirectRecord> get redirects',
      'extra': 'Map<String, dynamic> get extra',
      'realUri': 'Uri get realUri',
    },
    setterSignatures: {
      'data': 'set data(dynamic value)',
      'requestOptions': 'set requestOptions(dynamic value)',
      'statusCode': 'set statusCode(dynamic value)',
      'statusMessage': 'set statusMessage(dynamic value)',
      'headers': 'set headers(dynamic value)',
      'isRedirect': 'set isRedirect(dynamic value)',
      'redirects': 'set redirects(dynamic value)',
      'extra': 'set extra(dynamic value)',
    },
  );
}

// =============================================================================
// BackgroundTransformer Bridge
// =============================================================================

BridgedClass _createBackgroundTransformerBridge() {
  return BridgedClass(
    nativeType: $dio_15.BackgroundTransformer,
    name: 'BackgroundTransformer',
    isAssignable: (v) => v is $dio_15.BackgroundTransformer,
    hierarchyDepth: 2,
    constructors: {
      '': (visitor, positional, named) {
        return $dio_15.BackgroundTransformer();
      },
    },
    getters: {
      'jsonDecodeCallback': (visitor, target) => D4.validateTarget<$dio_15.BackgroundTransformer>(target, 'BackgroundTransformer').jsonDecodeCallback,
      'jsonEncodeCallback': (visitor, target) => D4.validateTarget<$dio_15.BackgroundTransformer>(target, 'BackgroundTransformer').jsonEncodeCallback,
    },
    setters: {
      'jsonDecodeCallback': (visitor, target, value) {
        final jsonDecodeCallbackRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'jsonDecodeCallback');
        D4.validateTarget<$dio_15.BackgroundTransformer>(target, 'BackgroundTransformer').jsonDecodeCallback = ((String p0) { return D4.castCallbackResult<FutureOr<Object?>>(D4.callInterpreterCallback(visitor!, jsonDecodeCallbackRaw, [p0])); }) as FutureOr<Object?> Function(String);
      },
      'jsonEncodeCallback': (visitor, target, value) {
        final jsonEncodeCallbackRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'jsonEncodeCallback');
        D4.validateTarget<$dio_15.BackgroundTransformer>(target, 'BackgroundTransformer').jsonEncodeCallback = ((Object p0) { return D4.extractBridgedArg<FutureOr<String>>(D4.callInterpreterCallback(visitor!, jsonEncodeCallbackRaw, [p0]), 'callback', visitor) as FutureOr<String>; }) as FutureOr<String> Function(Object);
      },
    },
    methods: {
      'transformRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_15.BackgroundTransformer>(target, 'BackgroundTransformer');
        D4.requireMinArgs(positional, 1, 'transformRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'transformRequest');
        return t.transformRequest(options);
      },
      'transformResponse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_15.BackgroundTransformer>(target, 'BackgroundTransformer');
        D4.requireMinArgs(positional, 2, 'transformResponse');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'transformResponse');
        final responseBody = D4.getRequiredArg<$dio_1.ResponseBody>(positional, 1, 'responseBody', 'transformResponse');
        return t.transformResponse(options, responseBody);
      },
    },
    constructorSignatures: {
      '': 'BackgroundTransformer()',
    },
    methodSignatures: {
      'transformRequest': 'Future<String> transformRequest(RequestOptions options)',
      'transformResponse': 'Future transformResponse(RequestOptions options, ResponseBody responseBody)',
    },
    getterSignatures: {
      'jsonDecodeCallback': 'JsonDecodeCallback get jsonDecodeCallback',
      'jsonEncodeCallback': 'JsonEncodeCallback get jsonEncodeCallback',
    },
    setterSignatures: {
      'jsonDecodeCallback': 'set jsonDecodeCallback(JsonDecodeCallback value)',
      'jsonEncodeCallback': 'set jsonEncodeCallback(JsonEncodeCallback value)',
    },
  );
}

// =============================================================================
// FusedTransformer Bridge
// =============================================================================

BridgedClass _createFusedTransformerBridge() {
  return BridgedClass(
    nativeType: $dio_16.FusedTransformer,
    name: 'FusedTransformer',
    isAssignable: (v) => v is $dio_16.FusedTransformer,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final contentLengthIsolateThreshold = D4.getNamedArgWithDefault<int>(named, 'contentLengthIsolateThreshold', -1);
        return $dio_16.FusedTransformer(contentLengthIsolateThreshold: contentLengthIsolateThreshold);
      },
      'sync': (visitor, positional, named) {
        return $dio_16.FusedTransformer.sync();
      },
    },
    getters: {
      'contentLengthIsolateThreshold': (visitor, target) => D4.validateTarget<$dio_16.FusedTransformer>(target, 'FusedTransformer').contentLengthIsolateThreshold,
    },
    methods: {
      'transformRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_16.FusedTransformer>(target, 'FusedTransformer');
        D4.requireMinArgs(positional, 1, 'transformRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'transformRequest');
        return t.transformRequest(options);
      },
      'transformResponse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_16.FusedTransformer>(target, 'FusedTransformer');
        D4.requireMinArgs(positional, 2, 'transformResponse');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'transformResponse');
        final responseBody = D4.getRequiredArg<$dio_1.ResponseBody>(positional, 1, 'responseBody', 'transformResponse');
        return t.transformResponse(options, responseBody);
      },
    },
    constructorSignatures: {
      '': 'FusedTransformer({int contentLengthIsolateThreshold = -1})',
      'sync': 'factory FusedTransformer.sync()',
    },
    methodSignatures: {
      'transformRequest': 'Future<String> transformRequest(RequestOptions options)',
      'transformResponse': 'Future transformResponse(RequestOptions options, ResponseBody responseBody)',
    },
    getterSignatures: {
      'contentLengthIsolateThreshold': 'int get contentLengthIsolateThreshold',
    },
  );
}

// =============================================================================
// SyncTransformer Bridge
// =============================================================================

BridgedClass _createSyncTransformerBridge() {
  return BridgedClass(
    nativeType: $dio_17.SyncTransformer,
    name: 'SyncTransformer',
    isAssignable: (v) => v is $dio_17.SyncTransformer,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        if (!named.containsKey('jsonDecodeCallback') && !named.containsKey('jsonEncodeCallback')) {
          return $dio_17.SyncTransformer();
        }
        if (named.containsKey('jsonDecodeCallback') && !named.containsKey('jsonEncodeCallback')) {
          final jsonDecodeCallbackRaw = named['jsonDecodeCallback'];
          final jsonDecodeCallback = ((String p0) { return D4.castCallbackResult<FutureOr<Object?>>(D4.callInterpreterCallback(visitor!, jsonDecodeCallbackRaw, [p0])); }) as FutureOr<Object?> Function(String);
          return $dio_17.SyncTransformer(jsonDecodeCallback: jsonDecodeCallback);
        }
        if (!named.containsKey('jsonDecodeCallback') && named.containsKey('jsonEncodeCallback')) {
          final jsonEncodeCallbackRaw = named['jsonEncodeCallback'];
          final jsonEncodeCallback = ((Object p0) { return D4.extractBridgedArg<FutureOr<String>>(D4.callInterpreterCallback(visitor!, jsonEncodeCallbackRaw, [p0]), 'callback', visitor) as FutureOr<String>; }) as FutureOr<String> Function(Object);
          return $dio_17.SyncTransformer(jsonEncodeCallback: jsonEncodeCallback);
        }
        if (named.containsKey('jsonDecodeCallback') && named.containsKey('jsonEncodeCallback')) {
          final jsonDecodeCallbackRaw = named['jsonDecodeCallback'];
          final jsonDecodeCallback = ((String p0) { return D4.castCallbackResult<FutureOr<Object?>>(D4.callInterpreterCallback(visitor!, jsonDecodeCallbackRaw, [p0])); }) as FutureOr<Object?> Function(String);
          final jsonEncodeCallbackRaw = named['jsonEncodeCallback'];
          final jsonEncodeCallback = ((Object p0) { return D4.extractBridgedArg<FutureOr<String>>(D4.callInterpreterCallback(visitor!, jsonEncodeCallbackRaw, [p0]), 'callback', visitor) as FutureOr<String>; }) as FutureOr<String> Function(Object);
          return $dio_17.SyncTransformer(jsonDecodeCallback: jsonDecodeCallback, jsonEncodeCallback: jsonEncodeCallback);
        }
        throw StateError('Unreachable: all named parameter combinations should be covered');
      },
    },
    getters: {
      'jsonDecodeCallback': (visitor, target) => D4.validateTarget<$dio_17.SyncTransformer>(target, 'SyncTransformer').jsonDecodeCallback,
      'jsonEncodeCallback': (visitor, target) => D4.validateTarget<$dio_17.SyncTransformer>(target, 'SyncTransformer').jsonEncodeCallback,
    },
    setters: {
      'jsonDecodeCallback': (visitor, target, value) {
        final jsonDecodeCallbackRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'jsonDecodeCallback');
        D4.validateTarget<$dio_17.SyncTransformer>(target, 'SyncTransformer').jsonDecodeCallback = ((String p0) { return D4.castCallbackResult<FutureOr<Object?>>(D4.callInterpreterCallback(visitor!, jsonDecodeCallbackRaw, [p0])); }) as FutureOr<Object?> Function(String);
      },
      'jsonEncodeCallback': (visitor, target, value) {
        final jsonEncodeCallbackRaw = D4.extractBridgedArgOrNull<dynamic>(value, 'jsonEncodeCallback');
        D4.validateTarget<$dio_17.SyncTransformer>(target, 'SyncTransformer').jsonEncodeCallback = ((Object p0) { return D4.extractBridgedArg<FutureOr<String>>(D4.callInterpreterCallback(visitor!, jsonEncodeCallbackRaw, [p0]), 'callback', visitor) as FutureOr<String>; }) as FutureOr<String> Function(Object);
      },
    },
    methods: {
      'transformRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_17.SyncTransformer>(target, 'SyncTransformer');
        D4.requireMinArgs(positional, 1, 'transformRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'transformRequest');
        return t.transformRequest(options);
      },
      'transformResponse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_17.SyncTransformer>(target, 'SyncTransformer');
        D4.requireMinArgs(positional, 2, 'transformResponse');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'transformResponse');
        final responseBody = D4.getRequiredArg<$dio_1.ResponseBody>(positional, 1, 'responseBody', 'transformResponse');
        return t.transformResponse(options, responseBody);
      },
    },
    constructorSignatures: {
      '': 'SyncTransformer({JsonDecodeCallback jsonDecodeCallback = jsonDecode, JsonEncodeCallback jsonEncodeCallback = jsonEncode})',
    },
    methodSignatures: {
      'transformRequest': 'Future<String> transformRequest(RequestOptions options)',
      'transformResponse': 'Future transformResponse(RequestOptions options, ResponseBody responseBody)',
    },
    getterSignatures: {
      'jsonDecodeCallback': 'JsonDecodeCallback get jsonDecodeCallback',
      'jsonEncodeCallback': 'JsonEncodeCallback get jsonEncodeCallback',
    },
    setterSignatures: {
      'jsonDecodeCallback': 'set jsonDecodeCallback(dynamic value)',
      'jsonEncodeCallback': 'set jsonEncodeCallback(dynamic value)',
    },
  );
}

// =============================================================================
// Transformer Bridge
// =============================================================================

BridgedClass _createTransformerBridge() {
  return BridgedClass(
    nativeType: $dio_14.Transformer,
    name: 'Transformer',
    isAssignable: (v) => v is $dio_14.Transformer,
    isAbstract: true,
    constructors: {
    },
    methods: {
      'transformRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_14.Transformer>(target, 'Transformer');
        D4.requireMinArgs(positional, 1, 'transformRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'transformRequest');
        return t.transformRequest(options);
      },
      'transformResponse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dio_14.Transformer>(target, 'Transformer');
        D4.requireMinArgs(positional, 2, 'transformResponse');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'transformResponse');
        final responseBody = D4.getRequiredArg<$dio_1.ResponseBody>(positional, 1, 'responseBody', 'transformResponse');
        return t.transformResponse(options, responseBody);
      },
    },
    staticMethods: {
      'urlEncodeMap': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'urlEncodeMap');
        if (positional.isEmpty) {
          throw ArgumentError('urlEncodeMap: Missing required argument "map" at position 0');
        }
        final map = D4.coerceMap<String, dynamic>(positional[0], 'map');
        final listFormat = D4.getOptionalArgWithDefault<$dio_10.ListFormat>(positional, 1, 'listFormat', $dio_10.ListFormat.multi);
        return $dio_14.Transformer.urlEncodeMap(map, listFormat);
      },
      'urlEncodeQueryMap': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'urlEncodeQueryMap');
        if (positional.isEmpty) {
          throw ArgumentError('urlEncodeQueryMap: Missing required argument "map" at position 0');
        }
        final map = D4.coerceMap<String, dynamic>(positional[0], 'map');
        final listFormat = D4.getOptionalArgWithDefault<$dio_10.ListFormat>(positional, 1, 'listFormat', $dio_10.ListFormat.multi);
        return $dio_14.Transformer.urlEncodeQueryMap(map, listFormat);
      },
      'isJsonMimeType': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'isJsonMimeType');
        final contentType = D4.getRequiredArg<String?>(positional, 0, 'contentType', 'isJsonMimeType');
        return $dio_14.Transformer.isJsonMimeType(contentType);
      },
      'defaultTransformRequest': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 2, 'defaultTransformRequest');
        final options = D4.getRequiredArg<$dio_10.RequestOptions>(positional, 0, 'options', 'defaultTransformRequest');
        if (positional.length <= 1) {
          throw ArgumentError('defaultTransformRequest: Missing required argument "jsonEncodeCallback" at position 1');
        }
        final jsonEncodeCallbackRaw = positional[1];
        final jsonEncodeCallback = ((Object p0) { return D4.extractBridgedArg<FutureOr<String>>(D4.callInterpreterCallback(visitor!, jsonEncodeCallbackRaw, [p0]), 'callback', visitor) as FutureOr<String>; }) as FutureOr<String> Function(Object);
        return $dio_14.Transformer.defaultTransformRequest(options, jsonEncodeCallback);
      },
    },
    methodSignatures: {
      'transformRequest': 'Future<String> transformRequest(RequestOptions options)',
      'transformResponse': 'Future transformResponse(RequestOptions options, ResponseBody responseBody)',
    },
    staticMethodSignatures: {
      'urlEncodeMap': 'String urlEncodeMap(Map<String, dynamic> map, [ListFormat listFormat = ListFormat.multi])',
      'urlEncodeQueryMap': 'String urlEncodeQueryMap(Map<String, dynamic> map, [ListFormat listFormat = ListFormat.multi])',
      'isJsonMimeType': 'bool isJsonMimeType(String? contentType)',
      'defaultTransformRequest': 'FutureOr<String> defaultTransformRequest(RequestOptions options, JsonEncodeCallback jsonEncodeCallback)',
    },
  );
}


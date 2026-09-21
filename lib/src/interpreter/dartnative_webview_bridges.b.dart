// D4rt Bridge - Generated file, do not edit
// Sources: 5 files
// Generated: 2026-09-20T04:30:47.549950 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';

import 'package:dartnative/src/core.dart' as $dartnative_1;
import 'package:dartnative/src/painting.dart' as $dartnative_2;
import 'package:dartnative_webview/src/javascript_mode.dart' as $dartnative_webview_1;
import 'package:dartnative_webview/src/navigation_delegate.dart' as $dartnative_webview_2;
import 'package:dartnative_webview/src/webview_controller.dart' as $dartnative_webview_3;
import 'package:dartnative_webview/src/webview_ffi_bindings.dart' as $dartnative_webview_4;
import 'package:dartnative_webview/src/webview_widget.dart' as $dartnative_webview_5;

/// Bridge class for dartnative_webview module.
class DartnativeWebviewBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createNavigationRequestBridge(),
      _createNavigationDelegateBridge(),
      _createWebViewControllerBridge(),
      _createWebKitWebViewControllerCreationParamsBridge(),
      _createWebViewWidgetBridge(),
      _createWebViewFFIBindingsBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'NavigationRequest': _createNavigationRequestBridge,
      'NavigationDelegate': _createNavigationDelegateBridge,
      'WebViewController': _createWebViewControllerBridge,
      'WebKitWebViewControllerCreationParams': _createWebKitWebViewControllerCreationParamsBridge,
      'WebViewWidget': _createWebViewWidgetBridge,
      'WebViewFFIBindings': _createWebViewFFIBindingsBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'NavigationRequest': $dartnative_webview_2.NavigationRequest,
      'NavigationDelegate': $dartnative_webview_2.NavigationDelegate,
      'WebViewController': $dartnative_webview_3.WebViewController,
      'WebKitWebViewControllerCreationParams': $dartnative_webview_3.WebKitWebViewControllerCreationParams,
      'WebViewWidget': $dartnative_webview_5.WebViewWidget,
      'WebViewFFIBindings': $dartnative_webview_4.WebViewFFIBindings,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'NavigationRequest': 'package:dartnative_webview/src/navigation_delegate.dart',
      'NavigationDelegate': 'package:dartnative_webview/src/navigation_delegate.dart',
      'WebViewController': 'package:dartnative_webview/src/webview_controller.dart',
      'WebKitWebViewControllerCreationParams': 'package:dartnative_webview/src/webview_controller.dart',
      'WebViewWidget': 'package:dartnative_webview/src/webview_widget.dart',
      'WebViewFFIBindings': 'package:dartnative_webview/src/webview_ffi_bindings.dart',
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
      'WebViewWidget': ['Widget'],
    };
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {
      'CChar': 'Char',
    };
  }

  /// Returns the list of function typedef names declared in this library.
  ///
  /// Function typedefs like `typedef VoidCallback = void Function()` are
  /// registered so that they can be used as type arguments in D4rt scripts.
  static List<String> functionTypedefs() {
    return [
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$dartnative_webview_1.JavaScriptMode>(
        name: 'JavaScriptMode',
        values: $dartnative_webview_1.JavaScriptMode.values,
      ),
      BridgedEnumDefinition<$dartnative_webview_2.NavigationDecision>(
        name: 'NavigationDecision',
        values: $dartnative_webview_2.NavigationDecision.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'JavaScriptMode': 'package:dartnative_webview/src/javascript_mode.dart',
      'NavigationDecision': 'package:dartnative_webview/src/navigation_delegate.dart',
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
      (source: 'package:dartnative_webview/dartnative_webview.dart', target: 'package:dartnative_webview/src/javascript_mode.dart', show: null, hide: null),
      (source: 'package:dartnative_webview/dartnative_webview.dart', target: 'package:dartnative_webview/src/navigation_delegate.dart', show: null, hide: null),
      (source: 'package:dartnative_webview/dartnative_webview.dart', target: 'package:dartnative_webview/src/webview_controller.dart', show: null, hide: null),
      (source: 'package:dartnative_webview/dartnative_webview.dart', target: 'package:dartnative_webview/src/webview_widget.dart', show: null, hide: null),
      (source: 'package:dartnative_webview/dartnative_webview.dart', target: 'package:dartnative_webview/src/webview_ffi_bindings.dart', show: {'WebViewFFIBindings'}, hide: null),
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

    // GEN-107: Register library re-exports
    for (final r in bridgeReExports()) {
      interpreter.registerLibraryReExport(r.source, r.target, show: r.show, hide: r.hide);
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {
      'registerWebViewElementFactory': (visitor, positional, named, typeArgs) {
        return $dartnative_webview_5.registerWebViewElementFactory();
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'registerWebViewElementFactory': 'package:dartnative_webview/src/webview_widget.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'registerWebViewElementFactory': 'void registerWebViewElementFactory()',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative_webview/src/javascript_mode.dart',
      'package:dartnative_webview/src/navigation_delegate.dart',
      'package:dartnative_webview/src/webview_controller.dart',
      'package:dartnative_webview/src/webview_ffi_bindings.dart',
      'package:dartnative_webview/src/webview_widget.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:dartnative_webview/dartnative_webview.dart';";
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
    'JavaScriptMode',
    'NavigationDecision',
  ];

}

// =============================================================================
// NavigationRequest Bridge
// =============================================================================

BridgedClass _createNavigationRequestBridge() {
  return BridgedClass(
    nativeType: $dartnative_webview_2.NavigationRequest,
    name: 'NavigationRequest',
    isAssignable: (v) => v is $dartnative_webview_2.NavigationRequest,
    constructors: {
      '': (visitor, positional, named) {
        final url = D4.getRequiredNamedArg<String>(named, 'url', 'NavigationRequest');
        return $dartnative_webview_2.NavigationRequest(url: url);
      },
    },
    getters: {
      'url': (visitor, target) => D4.validateTarget<$dartnative_webview_2.NavigationRequest>(target, 'NavigationRequest').url,
    },
    constructorSignatures: {
      '': 'const NavigationRequest({required String url})',
    },
    getterSignatures: {
      'url': 'String get url',
    },
  );
}

// =============================================================================
// NavigationDelegate Bridge
// =============================================================================

BridgedClass _createNavigationDelegateBridge() {
  return BridgedClass(
    nativeType: $dartnative_webview_2.NavigationDelegate,
    name: 'NavigationDelegate',
    isAssignable: (v) => v is $dartnative_webview_2.NavigationDelegate,
    constructors: {
      '': (visitor, positional, named) {
        final onNavigationRequestRaw = named['onNavigationRequest'];
        final onProgressRaw = named['onProgress'];
        final onPageStartedRaw = named['onPageStarted'];
        final onPageFinishedRaw = named['onPageFinished'];
        return $dartnative_webview_2.NavigationDelegate(onNavigationRequest: onNavigationRequestRaw == null ? null : (($dartnative_webview_2.NavigationRequest p0) { return D4.extractBridgedArg<FutureOr<$dartnative_webview_2.NavigationDecision>>(D4.callInterpreterCallback(visitor!, onNavigationRequestRaw, [p0]), 'callback', visitor) as FutureOr<$dartnative_webview_2.NavigationDecision>; }) as FutureOr<$dartnative_webview_2.NavigationDecision> Function($dartnative_webview_2.NavigationRequest), onProgress: onProgressRaw == null ? null : (int p0) { D4.callInterpreterCallback(visitor!, onProgressRaw, [p0]); }, onPageStarted: onPageStartedRaw == null ? null : (String p0) { D4.callInterpreterCallback(visitor!, onPageStartedRaw, [p0]); }, onPageFinished: onPageFinishedRaw == null ? null : (String p0) { D4.callInterpreterCallback(visitor!, onPageFinishedRaw, [p0]); });
      },
    },
    getters: {
      'onNavigationRequest': (visitor, target) => D4.validateTarget<$dartnative_webview_2.NavigationDelegate>(target, 'NavigationDelegate').onNavigationRequest,
      'onProgress': (visitor, target) => D4.validateTarget<$dartnative_webview_2.NavigationDelegate>(target, 'NavigationDelegate').onProgress,
      'onPageStarted': (visitor, target) => D4.validateTarget<$dartnative_webview_2.NavigationDelegate>(target, 'NavigationDelegate').onPageStarted,
      'onPageFinished': (visitor, target) => D4.validateTarget<$dartnative_webview_2.NavigationDelegate>(target, 'NavigationDelegate').onPageFinished,
    },
    constructorSignatures: {
      '': 'const NavigationDelegate({FutureOr<NavigationDecision> Function(NavigationRequest)? onNavigationRequest, void Function(int progress)? onProgress, void Function(String url)? onPageStarted, void Function(String url)? onPageFinished})',
    },
    getterSignatures: {
      'onNavigationRequest': 'FutureOr<NavigationDecision> Function(NavigationRequest)? get onNavigationRequest',
      'onProgress': 'void Function(int progress)? get onProgress',
      'onPageStarted': 'void Function(String url)? get onPageStarted',
      'onPageFinished': 'void Function(String url)? get onPageFinished',
    },
  );
}

// =============================================================================
// WebViewController Bridge
// =============================================================================

BridgedClass _createWebViewControllerBridge() {
  return BridgedClass(
    nativeType: $dartnative_webview_3.WebViewController,
    name: 'WebViewController',
    isAssignable: (v) => v is $dartnative_webview_3.WebViewController,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_webview_3.WebViewController();
      },
      'fromPlatformCreationParams': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'WebViewController');
        final params = D4.getRequiredArg<dynamic>(positional, 0, 'params', 'WebViewController');
        return $dartnative_webview_3.WebViewController.fromPlatformCreationParams(params);
      },
    },
    getters: {
      'webViewId': (visitor, target) => D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController').webViewId,
    },
    methods: {
      'prepareNativeAttach': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        t.prepareNativeAttach();
        return null;
      },
      'setJavaScriptMode': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        D4.requireMinArgs(positional, 1, 'setJavaScriptMode');
        final mode = D4.getRequiredArg<$dartnative_webview_1.JavaScriptMode>(positional, 0, 'mode', 'setJavaScriptMode');
        return t.setJavaScriptMode(mode);
      },
      'setBackgroundColor': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        D4.requireMinArgs(positional, 1, 'setBackgroundColor');
        final color = D4.getRequiredArg<$dartnative_2.Color>(positional, 0, 'color', 'setBackgroundColor');
        return t.setBackgroundColor(color);
      },
      'setNavigationDelegate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        D4.requireMinArgs(positional, 1, 'setNavigationDelegate');
        final delegate = D4.getRequiredArg<$dartnative_webview_2.NavigationDelegate>(positional, 0, 'delegate', 'setNavigationDelegate');
        return t.setNavigationDelegate(delegate);
      },
      'loadRequest': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        D4.requireMinArgs(positional, 1, 'loadRequest');
        final uri = D4.getRequiredArg<Uri>(positional, 0, 'uri', 'loadRequest');
        return t.loadRequest(uri);
      },
      'goBack': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        return t.goBack();
      },
      'goForward': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        return t.goForward();
      },
      'reload': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        return t.reload();
      },
      'canGoBack': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        return t.canGoBack();
      },
      'canGoForward': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        return t.canGoForward();
      },
      'getTitle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        return t.getTitle();
      },
      'dispose': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_3.WebViewController>(target, 'WebViewController');
        (t as dynamic).dispose();
        return null;
      },
    },
    constructorSignatures: {
      '': 'WebViewController()',
      'fromPlatformCreationParams': 'WebViewController.fromPlatformCreationParams(dynamic params)',
    },
    methodSignatures: {
      'prepareNativeAttach': 'void prepareNativeAttach()',
      'setJavaScriptMode': 'Future<void> setJavaScriptMode(JavaScriptMode mode)',
      'setBackgroundColor': 'Future<void> setBackgroundColor(Color color)',
      'setNavigationDelegate': 'Future<void> setNavigationDelegate(NavigationDelegate delegate)',
      'loadRequest': 'Future<void> loadRequest(Uri uri)',
      'goBack': 'Future<void> goBack()',
      'goForward': 'Future<void> goForward()',
      'reload': 'Future<void> reload()',
      'canGoBack': 'Future<bool> canGoBack()',
      'canGoForward': 'Future<bool> canGoForward()',
      'getTitle': 'Future<String?> getTitle()',
      'dispose': 'void dispose()',
    },
    getterSignatures: {
      'webViewId': 'int? get webViewId',
    },
  );
}

// =============================================================================
// WebKitWebViewControllerCreationParams Bridge
// =============================================================================

BridgedClass _createWebKitWebViewControllerCreationParamsBridge() {
  return BridgedClass(
    nativeType: $dartnative_webview_3.WebKitWebViewControllerCreationParams,
    name: 'WebKitWebViewControllerCreationParams',
    isAssignable: (v) => v is $dartnative_webview_3.WebKitWebViewControllerCreationParams,
    constructors: {
      '': (visitor, positional, named) {
        final allowsInlineMediaPlayback = D4.getNamedArgWithDefault<bool>(named, 'allowsInlineMediaPlayback', true);
        final mediaTypesRequiringUserAction = named.containsKey('mediaTypesRequiringUserAction') && named['mediaTypesRequiringUserAction'] != null
            ? D4.coerceSet<Object>(named['mediaTypesRequiringUserAction'], 'mediaTypesRequiringUserAction')
            : const <Object>{};
        return $dartnative_webview_3.WebKitWebViewControllerCreationParams(allowsInlineMediaPlayback: allowsInlineMediaPlayback, mediaTypesRequiringUserAction: mediaTypesRequiringUserAction);
      },
    },
    getters: {
      'allowsInlineMediaPlayback': (visitor, target) => D4.validateTarget<$dartnative_webview_3.WebKitWebViewControllerCreationParams>(target, 'WebKitWebViewControllerCreationParams').allowsInlineMediaPlayback,
      'mediaTypesRequiringUserAction': (visitor, target) => D4.validateTarget<$dartnative_webview_3.WebKitWebViewControllerCreationParams>(target, 'WebKitWebViewControllerCreationParams').mediaTypesRequiringUserAction,
    },
    constructorSignatures: {
      '': 'const WebKitWebViewControllerCreationParams({bool allowsInlineMediaPlayback = true, Set<Object> mediaTypesRequiringUserAction = const {}})',
    },
    getterSignatures: {
      'allowsInlineMediaPlayback': 'bool get allowsInlineMediaPlayback',
      'mediaTypesRequiringUserAction': 'Set<Object> get mediaTypesRequiringUserAction',
    },
  );
}

// =============================================================================
// WebViewWidget Bridge
// =============================================================================

BridgedClass _createWebViewWidgetBridge() {
  return BridgedClass(
    nativeType: $dartnative_webview_5.WebViewWidget,
    name: 'WebViewWidget',
    isAssignable: (v) => v is $dartnative_webview_5.WebViewWidget,
    hierarchyDepth: 1,
    constructors: {
      '': (visitor, positional, named) {
        final key = D4.getOptionalNamedArg<$dartnative_1.Key?>(named, 'key');
        final controller = D4.getRequiredNamedArg<$dartnative_webview_3.WebViewController>(named, 'controller', 'WebViewWidget');
        return $dartnative_webview_5.WebViewWidget(key: key, controller: controller);
      },
    },
    getters: {
      'controller': (visitor, target) => (D4.validateTarget<$dartnative_webview_5.WebViewWidget>(target, 'WebViewWidget') as dynamic).controller,
      'key': (visitor, target) => D4.validateTarget<$dartnative_webview_5.WebViewWidget>(target, 'WebViewWidget').key,
    },
    constructorSignatures: {
      '': 'const WebViewWidget({Key? key, required WebViewController controller})',
    },
    getterSignatures: {
      'controller': 'WebViewController get controller',
      'key': 'Key? get key',
    },
  );
}

// =============================================================================
// WebViewFFIBindings Bridge
// =============================================================================

BridgedClass _createWebViewFFIBindingsBridge() {
  return BridgedClass(
    nativeType: $dartnative_webview_4.WebViewFFIBindings,
    name: 'WebViewFFIBindings',
    isAssignable: (v) => v is $dartnative_webview_4.WebViewFFIBindings,
    constructors: {
    },
    methods: {
      'create': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        return t.create();
      },
      'setPendingWebViewId': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 1, 'setPendingWebViewId');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'setPendingWebViewId');
        t.setPendingWebViewId(id);
        return null;
      },
      'disposeView': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 1, 'disposeView');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'disposeView');
        t.disposeView(id);
        return null;
      },
      'loadURL': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 2, 'loadURL');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'loadURL');
        final url = D4.getRequiredArg<String>(positional, 1, 'url', 'loadURL');
        t.loadURL(id, url);
        return null;
      },
      'goBack': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 1, 'goBack');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'goBack');
        t.goBack(id);
        return null;
      },
      'goForward': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 1, 'goForward');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'goForward');
        t.goForward(id);
        return null;
      },
      'reload': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 1, 'reload');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'reload');
        t.reload(id);
        return null;
      },
      'canGoBack': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 1, 'canGoBack');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'canGoBack');
        return t.canGoBack(id);
      },
      'canGoForward': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 1, 'canGoForward');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'canGoForward');
        return t.canGoForward(id);
      },
      'getTitle': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 1, 'getTitle');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'getTitle');
        return t.getTitle(id);
      },
      'setJavaScriptEnabled': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 2, 'setJavaScriptEnabled');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'setJavaScriptEnabled');
        final enabled = D4.getRequiredArg<int>(positional, 1, 'enabled', 'setJavaScriptEnabled');
        t.setJavaScriptEnabled(id, enabled);
        return null;
      },
      'setBackgroundTransparent': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 2, 'setBackgroundTransparent');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'setBackgroundTransparent');
        final transparent = D4.getRequiredArg<int>(positional, 1, 'transparent', 'setBackgroundTransparent');
        t.setBackgroundTransparent(id, transparent);
        return null;
      },
      'registerProgressCallback': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 2, 'registerProgressCallback');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'registerProgressCallback');
        if (positional.length <= 1) {
          throw ArgumentError('registerProgressCallback: Missing required argument "onProgress" at position 1');
        }
        final onProgressRaw = positional[1];
        t.registerProgressCallback(id, (int p0) { D4.callInterpreterCallback(visitor!, onProgressRaw, [p0]); });
        return null;
      },
      'registerPageChangedCallback': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 2, 'registerPageChangedCallback');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'registerPageChangedCallback');
        if (positional.length <= 1) {
          throw ArgumentError('registerPageChangedCallback: Missing required argument "onPageChanged" at position 1');
        }
        final onPageChangedRaw = positional[1];
        t.registerPageChangedCallback(id, (int p0, String p1) { D4.callInterpreterCallback(visitor!, onPageChangedRaw, [p0, p1]); });
        return null;
      },
      'disconnect': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_webview_4.WebViewFFIBindings>(target, 'WebViewFFIBindings');
        D4.requireMinArgs(positional, 1, 'disconnect');
        final id = D4.getRequiredArg<int>(positional, 0, 'id', 'disconnect');
        t.disconnect(id);
        return null;
      },
    },
    staticGetters: {
      'instance': (visitor) => $dartnative_webview_4.WebViewFFIBindings.instance,
    },
    staticMethods: {
      'loadSymbols': (visitor, positional, named, typeArgs) {
        return $dartnative_webview_4.WebViewFFIBindings.loadSymbols();
      },
    },
    methodSignatures: {
      'create': 'int create()',
      'setPendingWebViewId': 'void setPendingWebViewId(int id)',
      'disposeView': 'void disposeView(int id)',
      'loadURL': 'void loadURL(int id, String url)',
      'goBack': 'void goBack(int id)',
      'goForward': 'void goForward(int id)',
      'reload': 'void reload(int id)',
      'canGoBack': 'int canGoBack(int id)',
      'canGoForward': 'int canGoForward(int id)',
      'getTitle': 'String? getTitle(int id)',
      'setJavaScriptEnabled': 'void setJavaScriptEnabled(int id, int enabled)',
      'setBackgroundTransparent': 'void setBackgroundTransparent(int id, int transparent)',
      'registerProgressCallback': 'void registerProgressCallback(int id, void Function(int progress) onProgress)',
      'registerPageChangedCallback': 'void registerPageChangedCallback(int id, void Function(int type, String url) onPageChanged)',
      'disconnect': 'void disconnect(int id)',
    },
    staticMethodSignatures: {
      'loadSymbols': 'void loadSymbols()',
    },
    staticGetterSignatures: {
      'instance': 'WebViewFFIBindings get instance',
    },
  );
}


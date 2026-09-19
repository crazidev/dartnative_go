// D4rt Bridge - Generated file, do not edit
// Sources: 7 files
// Generated: 2026-09-19T02:10:30.244877 by tom_d4rt_generator 1.26.2

// ignore_for_file: unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';
import 'dart:convert';

import 'package:crypto/src/digest.dart' as $crypto_1;
import 'package:crypto/src/hash.dart' as $crypto_2;
import 'package:crypto/src/hmac.dart' as $crypto_3;
import 'package:crypto/src/md5.dart' as $crypto_4;
import 'package:crypto/src/sha1.dart' as $crypto_5;
import 'package:crypto/src/sha256.dart' as $crypto_6;
import 'package:crypto/src/sha512.dart' as $crypto_7;

/// Bridge class for crypto module.
class CryptoBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createDigestBridge(),
      _createHashBridge(),
      _createHmacBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'Digest': _createDigestBridge,
      'Hash': _createHashBridge,
      'Hmac': _createHmacBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'Digest': $crypto_1.Digest,
      'Hash': $crypto_2.Hash,
      'Hmac': $crypto_3.Hmac,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'Digest': 'package:crypto/src/digest.dart',
      'Hash': 'package:crypto/src/hash.dart',
      'Hmac': 'package:crypto/src/hmac.dart',
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
      'Hash': ['Converter', 'StreamTransformerBase', 'StreamTransformer'],
      'Hmac': ['Converter', 'StreamTransformerBase', 'StreamTransformer'],
    };
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {
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
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
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
      (source: 'package:crypto/crypto.dart', target: 'package:crypto/src/digest.dart', show: null, hide: null),
      (source: 'package:crypto/crypto.dart', target: 'package:crypto/src/hash.dart', show: null, hide: null),
      (source: 'package:crypto/crypto.dart', target: 'package:crypto/src/hmac.dart', show: null, hide: null),
      (source: 'package:crypto/crypto.dart', target: 'package:crypto/src/md5.dart', show: null, hide: null),
      (source: 'package:crypto/crypto.dart', target: 'package:crypto/src/sha1.dart', show: null, hide: null),
      (source: 'package:crypto/crypto.dart', target: 'package:crypto/src/sha256.dart', show: null, hide: null),
      (source: 'package:crypto/crypto.dart', target: 'package:crypto/src/sha512.dart', show: null, hide: null),
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

    // GEN-107: Register library re-exports
    for (final r in bridgeReExports()) {
      interpreter.registerLibraryReExport(r.source, r.target, show: r.show, hide: r.hide);
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
      interpreter.registerGlobalVariable('md5', $crypto_4.md5, importPath, sourceUri: 'package:crypto/src/md5.dart');
    } catch (e) {
      errors.add('Failed to register variable "md5": $e');
    }
    try {
      interpreter.registerGlobalVariable('sha1', $crypto_5.sha1, importPath, sourceUri: 'package:crypto/src/sha1.dart');
    } catch (e) {
      errors.add('Failed to register variable "sha1": $e');
    }
    try {
      interpreter.registerGlobalVariable('sha256', $crypto_6.sha256, importPath, sourceUri: 'package:crypto/src/sha256.dart');
    } catch (e) {
      errors.add('Failed to register variable "sha256": $e');
    }
    try {
      interpreter.registerGlobalVariable('sha224', $crypto_6.sha224, importPath, sourceUri: 'package:crypto/src/sha256.dart');
    } catch (e) {
      errors.add('Failed to register variable "sha224": $e');
    }
    try {
      interpreter.registerGlobalVariable('sha384', $crypto_7.sha384, importPath, sourceUri: 'package:crypto/src/sha512.dart');
    } catch (e) {
      errors.add('Failed to register variable "sha384": $e');
    }
    try {
      interpreter.registerGlobalVariable('sha512', $crypto_7.sha512, importPath, sourceUri: 'package:crypto/src/sha512.dart');
    } catch (e) {
      errors.add('Failed to register variable "sha512": $e');
    }
    try {
      interpreter.registerGlobalVariable('sha512224', $crypto_7.sha512224, importPath, sourceUri: 'package:crypto/src/sha512.dart');
    } catch (e) {
      errors.add('Failed to register variable "sha512224": $e');
    }
    try {
      interpreter.registerGlobalVariable('sha512256', $crypto_7.sha512256, importPath, sourceUri: 'package:crypto/src/sha512.dart');
    } catch (e) {
      errors.add('Failed to register variable "sha512256": $e');
    }

    if (errors.isNotEmpty) {
      throw StateError('Bridge registration errors (crypto):\n${errors.join("\n")}');
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
      'package:crypto/src/digest.dart',
      'package:crypto/src/hash.dart',
      'package:crypto/src/hmac.dart',
      'package:crypto/src/md5.dart',
      'package:crypto/src/sha1.dart',
      'package:crypto/src/sha256.dart',
      'package:crypto/src/sha512.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    return "import 'package:crypto/crypto.dart';";
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

}

// =============================================================================
// Digest Bridge
// =============================================================================

BridgedClass _createDigestBridge() {
  return BridgedClass(
    nativeType: $crypto_1.Digest,
    name: 'Digest',
    isAssignable: (v) => v is $crypto_1.Digest,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'Digest');
        if (positional.isEmpty) {
          throw ArgumentError('Digest: Missing required argument "bytes" at position 0');
        }
        final bytes = D4.coerceList<int>(positional[0], 'bytes');
        return $crypto_1.Digest(bytes);
      },
    },
    getters: {
      'bytes': (visitor, target) => D4.validateTarget<$crypto_1.Digest>(target, 'Digest').bytes,
      'hashCode': (visitor, target) => D4.validateTarget<$crypto_1.Digest>(target, 'Digest').hashCode,
    },
    methods: {
      'toString': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_1.Digest>(target, 'Digest');
        return t.toString();
      },
      '==': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_1.Digest>(target, 'Digest');
        // GEN-103: Dart spec — non-null == null is always false.
        if (positional.isEmpty || positional[0] == null) return false;
        final other = D4.getRequiredArg<Object>(positional, 0, 'other', 'operator==');
        return t == other;
      },
    },
    constructorSignatures: {
      '': 'Digest(List<int> bytes)',
    },
    methodSignatures: {
      'toString': 'String toString()',
    },
    getterSignatures: {
      'bytes': 'List<int> get bytes',
      'hashCode': 'int get hashCode',
    },
  );
}

// =============================================================================
// Hash Bridge
// =============================================================================

BridgedClass _createHashBridge() {
  return BridgedClass(
    nativeType: $crypto_2.Hash,
    name: 'Hash',
    isAssignable: (v) => v is $crypto_2.Hash,
    hierarchyDepth: 3,
    isAbstract: true,
    constructors: {
    },
    getters: {
      'blockSize': (visitor, target) => D4.validateTarget<$crypto_2.Hash>(target, 'Hash').blockSize,
    },
    methods: {
      'convert': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_2.Hash>(target, 'Hash');
        D4.requireMinArgs(positional, 1, 'convert');
        if (positional.isEmpty) {
          throw ArgumentError('convert: Missing required argument "input" at position 0');
        }
        final input = D4.coerceList<int>(positional[0], 'input');
        return t.convert(input);
      },
      'startChunkedConversion': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_2.Hash>(target, 'Hash');
        D4.requireMinArgs(positional, 1, 'startChunkedConversion');
        final sink = D4.getRequiredArg<Sink<$crypto_1.Digest>>(positional, 0, 'sink', 'startChunkedConversion');
        return t.startChunkedConversion(sink);
      },
      'fuse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_2.Hash>(target, 'Hash');
        D4.requireMinArgs(positional, 1, 'fuse');
        final other = D4.getRequiredArg<Converter<$crypto_1.Digest, dynamic>>(positional, 0, 'other', 'fuse');
        return t.fuse(other);
      },
      'bind': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_2.Hash>(target, 'Hash');
        D4.requireMinArgs(positional, 1, 'bind');
        final stream = D4.getRequiredArg<Stream<List<int>>>(positional, 0, 'stream', 'bind');
        return t.bind(stream);
      },
      'cast': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_2.Hash>(target, 'Hash');
        return t.cast();
      },
    },
    methodSignatures: {
      'convert': 'Digest convert(List<int> input)',
      'startChunkedConversion': 'ByteConversionSink startChunkedConversion(Sink<Digest> sink)',
      'fuse': 'Converter<List<int>, TT> fuse(Converter<Digest, TT> other)',
      'bind': 'Stream<Digest> bind(Stream<List<int>> stream)',
      'cast': 'Converter<RS, RT> cast()',
    },
    getterSignatures: {
      'blockSize': 'int get blockSize',
    },
  );
}

// =============================================================================
// Hmac Bridge
// =============================================================================

BridgedClass _createHmacBridge() {
  return BridgedClass(
    nativeType: $crypto_3.Hmac,
    name: 'Hmac',
    isAssignable: (v) => v is $crypto_3.Hmac,
    hierarchyDepth: 3,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 2, 'Hmac');
        final hash = D4.getRequiredArg<$crypto_2.Hash>(positional, 0, 'hash', 'Hmac');
        if (positional.length <= 1) {
          throw ArgumentError('Hmac: Missing required argument "key" at position 1');
        }
        final key = D4.coerceList<int>(positional[1], 'key');
        return $crypto_3.Hmac(hash, key);
      },
    },
    methods: {
      'convert': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_3.Hmac>(target, 'Hmac');
        D4.requireMinArgs(positional, 1, 'convert');
        if (positional.isEmpty) {
          throw ArgumentError('convert: Missing required argument "input" at position 0');
        }
        final input = D4.coerceList<int>(positional[0], 'input');
        return t.convert(input);
      },
      'startChunkedConversion': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_3.Hmac>(target, 'Hmac');
        D4.requireMinArgs(positional, 1, 'startChunkedConversion');
        final sink = D4.getRequiredArg<Sink<$crypto_1.Digest>>(positional, 0, 'sink', 'startChunkedConversion');
        return t.startChunkedConversion(sink);
      },
      'fuse': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_3.Hmac>(target, 'Hmac');
        D4.requireMinArgs(positional, 1, 'fuse');
        final other = D4.getRequiredArg<Converter<$crypto_1.Digest, dynamic>>(positional, 0, 'other', 'fuse');
        return t.fuse(other);
      },
      'bind': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_3.Hmac>(target, 'Hmac');
        D4.requireMinArgs(positional, 1, 'bind');
        final stream = D4.getRequiredArg<Stream<List<int>>>(positional, 0, 'stream', 'bind');
        return t.bind(stream);
      },
      'cast': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$crypto_3.Hmac>(target, 'Hmac');
        return t.cast();
      },
    },
    constructorSignatures: {
      '': 'Hmac(Hash hash, List<int> key)',
    },
    methodSignatures: {
      'convert': 'Digest convert(List<int> input)',
      'startChunkedConversion': 'ByteConversionSink startChunkedConversion(Sink<Digest> sink)',
      'fuse': 'Converter<List<int>, TT> fuse(Converter<Digest, TT> other)',
      'bind': 'Stream<Digest> bind(Stream<List<int>> stream)',
      'cast': 'Converter<RS, RT> cast()',
    },
  );
}


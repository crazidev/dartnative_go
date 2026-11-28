import 'dart:ffi' as ffi;

import 'package:tom_d4rt_ast/runtime.dart';

/// Stdlib bridge for `dart:ffi`.
///
/// The interpreter cannot express a *native* function type, so `dart:ffi` has
/// always been rejected at module load — which makes any guest that imports it
/// unloadable, even when the FFI call sits inside a `try`/`catch` (the
/// upstream `dn-silly-benchmark` reads `clock()` that way to compute CPU%, and
/// its own code already degrades to `n/a` when the lookup fails).
///
/// Two pieces make that pattern work:
///
///  * [DynamicLibrary] is bridged for real — `process()`, `open()` and
///    `executable()` return the host library, so nothing is faked.
///  * `lookupFunction` maps the *guest's* function type onto a real
///    `lookupFunction<NativeT, DartT>` call for a fixed signature table. The
///    guest's type argument arrives as a [FunctionRuntimeType] with resolved
///    return/parameter names, so `ffi.Long Function()` becomes
///    `ffi.Long Function()` on this side. Anything outside the table throws
///    [UnsupportedError] — a *call-time* failure, so a guest that guards its
///    FFI use keeps working and one that does not gets a clear message.
///
/// The table covers the shapes a benchmark or a small probe needs: zero- and
/// one-argument integer/double/pointer returns. It is deliberately not a
/// general FFI bridge; adding a signature is one line in [_lookup0] /
/// [_lookup1].
class FfiStdlib {
  static void register(Environment environment) {
    environment.defineBridge(DynamicLibraryFfi.definition);
    for (final bridge in _typeBridges) {
      environment.defineBridge(bridge);
    }
  }

  /// The `dart:ffi` type names a guest can write in a signature. Registered so
  /// type annotations and `lookupFunction<…>` type arguments resolve.
  static final List<BridgedClass> _typeBridges = [
    _type('NativeType', ffi.NativeType),
    _type('NativeFunction', ffi.NativeFunction),
    _type('Pointer', ffi.Pointer),
    _type('Struct', ffi.Struct),
    _type('Union', ffi.Union),
    _type('AbiSpecificInteger', ffi.AbiSpecificInteger),
    _type('Void', ffi.Void),
    _type('Char', ffi.Char),
    _type('SignedChar', ffi.SignedChar),
    _type('UnsignedChar', ffi.UnsignedChar),
    _type('Short', ffi.Short),
    _type('UnsignedShort', ffi.UnsignedShort),
    _type('Int', ffi.Int),
    _type('UnsignedInt', ffi.UnsignedInt),
    _type('Long', ffi.Long),
    _type('UnsignedLong', ffi.UnsignedLong),
    _type('LongLong', ffi.LongLong),
    _type('UnsignedLongLong', ffi.UnsignedLongLong),
    _type('IntPtr', ffi.IntPtr),
    _type('UintPtr', ffi.UintPtr),
    _type('Size', ffi.Size),
    _type('Int8', ffi.Int8),
    _type('Int16', ffi.Int16),
    _type('Int32', ffi.Int32),
    _type('Int64', ffi.Int64),
    _type('Uint8', ffi.Uint8),
    _type('Uint16', ffi.Uint16),
    _type('Uint32', ffi.Uint32),
    _type('Uint64', ffi.Uint64),
    _type('Float', ffi.Float),
    _type('Double', ffi.Double),
    _type('Bool', ffi.Bool),
    _type('WChar', ffi.WChar),
  ];

  static BridgedClass _type(String name, Type native) => BridgedClass(
    nativeType: native,
    name: name,
    isAssignable: (v) => false,
    constructors: const {},
  );

  /// Looks [name] up in [library] using the guest's `T extends Function`.
  static Object? lookupFunction(
    ffi.DynamicLibrary library,
    List<Object?> positional,
    List<RuntimeType>? typeArgs,
  ) {
    if (positional.isEmpty || positional[0] is! String) {
      throw RuntimeD4rtException(
        'DynamicLibrary.lookupFunction expects a String symbol name.',
      );
    }
    final symbol = positional[0] as String;
    final type = typeArgs != null && typeArgs.isNotEmpty ? typeArgs[0] : null;
    if (type is! FunctionRuntimeType) {
      throw RuntimeD4rtException(
        'DynamicLibrary.lookupFunction: could not resolve the native '
        'signature of "$symbol".',
      );
    }
    final found = _lookup0(library, symbol, type) ??
        _lookup1(library, symbol, type);
    if (found != null) return found;
    throw RuntimeD4rtException(
      'dart:ffi lookupFunction("$symbol") with signature '
      '"${type.name}" is not supported under the interpreter. '
      'Supported: zero/one-argument functions returning int, double, bool '
      'or void.',
    );
  }

  /// Zero-argument signatures.
  static Object? _lookup0(
    ffi.DynamicLibrary lib,
    String name,
    FunctionRuntimeType type,
  ) {
    if (type.positionalParameterTypes.isNotEmpty ||
        type.optionalPositionalParameterTypes.isNotEmpty ||
        type.namedParameterTypes.isNotEmpty) {
      return null;
    }
    switch (type.returnType.name) {
      case 'Long':
        return lib.lookupFunction<ffi.Long Function(), int Function()>(name);
      case 'Int64':
        return lib.lookupFunction<ffi.Int64 Function(), int Function()>(name);
      case 'Int32':
        return lib.lookupFunction<ffi.Int32 Function(), int Function()>(name);
      case 'Int':
        return lib.lookupFunction<ffi.Int Function(), int Function()>(name);
      case 'IntPtr':
        return lib.lookupFunction<ffi.IntPtr Function(), int Function()>(name);
      case 'Uint64':
        return lib.lookupFunction<ffi.Uint64 Function(), int Function()>(name);
      case 'Uint32':
        return lib.lookupFunction<ffi.Uint32 Function(), int Function()>(name);
      case 'Uint8':
        return lib.lookupFunction<ffi.Uint8 Function(), int Function()>(name);
      case 'Double':
        return lib.lookupFunction<ffi.Double Function(), double Function()>(
          name,
        );
      case 'Float':
        return lib.lookupFunction<ffi.Float Function(), double Function()>(
          name,
        );
      case 'Bool':
        return lib.lookupFunction<ffi.Bool Function(), bool Function()>(name);
      case 'Void':
        return lib.lookupFunction<ffi.Void Function(), void Function()>(name);
    }
    return null;
  }

  /// One-argument signatures (an int argument, which covers the common
  /// handle/fd/pid probes).
  static Object? _lookup1(
    ffi.DynamicLibrary lib,
    String name,
    FunctionRuntimeType type,
  ) {
    if (type.optionalPositionalParameterTypes.isNotEmpty ||
        type.namedParameterTypes.isNotEmpty ||
        type.positionalParameterTypes.length != 1) {
      return null;
    }
    const intArgs = {'Long', 'Int64', 'Int32', 'Int', 'IntPtr', 'Uint64', 'Uint32'};
    if (!intArgs.contains(type.positionalParameterTypes[0].name)) return null;
    switch (type.returnType.name) {
      case 'Long':
        return lib.lookupFunction<ffi.Long Function(ffi.Int64), int Function(int)>(
          name,
        );
      case 'Int64':
        return lib.lookupFunction<ffi.Int64 Function(ffi.Int64), int Function(int)>(
          name,
        );
      case 'Int32':
        return lib.lookupFunction<ffi.Int32 Function(ffi.Int32), int Function(int)>(
          name,
        );
      case 'Int':
        return lib.lookupFunction<ffi.Int Function(ffi.Int), int Function(int)>(
          name,
        );
      case 'Void':
        return lib.lookupFunction<ffi.Void Function(ffi.Int64), void Function(int)>(
          name,
        );
      case 'Double':
        return lib.lookupFunction<
          ffi.Double Function(ffi.Int64),
          double Function(int)
        >(name);
    }
    return null;
  }
}

/// Bridged `dart:ffi` `DynamicLibrary`.
class DynamicLibraryFfi {
  static BridgedClass get definition => BridgedClass(
    nativeType: ffi.DynamicLibrary,
    name: 'DynamicLibrary',
    isAssignable: (v) => v is ffi.DynamicLibrary,
    constructors: const {},
    staticMethods: {
      'process': (visitor, positional, named, typeArgs) =>
          ffi.DynamicLibrary.process(),
      'executable': (visitor, positional, named, typeArgs) =>
          ffi.DynamicLibrary.executable(),
      'open': (visitor, positional, named, typeArgs) {
        if (positional.isEmpty || positional[0] is! String) {
          throw RuntimeD4rtException(
            'DynamicLibrary.open expects a String path.',
          );
        }
        return ffi.DynamicLibrary.open(positional[0] as String);
      },
    },
    methods: {
      'lookupFunction': (visitor, target, positional, named, typeArgs) =>
          FfiStdlib.lookupFunction(
            target as ffi.DynamicLibrary,
            positional,
            typeArgs,
          ),
      'lookup': (visitor, target, positional, named, typeArgs) {
        throw RuntimeD4rtException(
          'DynamicLibrary.lookup returns a raw Pointer, which the interpreter '
          'cannot type. Use lookupFunction<T>() instead.',
        );
      },
      'close': (visitor, target, positional, named, typeArgs) {
        // No-op: a library the guest never explicitly closes is fine to keep
        // open for the process lifetime, and closing one it does close is
        // already handled by the host's own finalizer.
        return null;
      },
    },
    staticMethodSignatures: const {
      'process': 'DynamicLibrary process()',
      'executable': 'DynamicLibrary executable()',
      'open': 'DynamicLibrary open(String path)',
    },
    methodSignatures: const {
      'lookupFunction': 'T lookupFunction<T extends Function>(String name)',
      'lookup': 'Pointer<T> lookup<T extends NativeType>(String name)',
      'close': 'void close()',
    },
  );
}

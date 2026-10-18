import 'dart:collection';
import 'dart:math' show Random;

import 'package:tom_d4rt_ast/runtime.dart';

/// Native implementations of the SDK collection-mixin algorithms, executed
/// against interpreted instances.
///
/// An interpreted `class Q extends ListMixin<E>` (or `with ListMixin`)
/// inherits concrete helpers (`addAll`, `sort`, …) that the VM runs natively.
/// The stub bridges modeling those mixins declare no members — deliberately,
/// so they never steal dispatch — which leaves two holes: the
/// interface-contract check (closed by `providesContract`) and *dispatch*
/// (closed here). Each entry below mirrors the SDK algorithm, expressed only
/// through the primitives the subclass must define (`length`, `[]`, `[]=`,
/// `length=`), calling siblings by name so overrides keep working, exactly as
/// dynamic dispatch does on the VM.
///
/// Currently covers the `List` contract (the overwhelmingly common mixin).
/// `Set`/`Map`/`Iterable` contracts resolve for checking via
/// `providesContract`; their dispatch arrives on demand with the same shape.
///
/// Intentional deviations from the SDK, all documented at the member:
///
/// * `getRange` materializes instead of staying lazy.
/// * `asMap` returns a snapshot instead of a live view.
/// * Iterators are snapshots: no `ConcurrentModificationError`.
typedef _MixinImpl =
    Object? Function(
      InterpreterVisitor visitor,
      InterpretedInstance instance,
      List<Object?> positional,
      Map<String, Object?> named,
    );

/// A [Callable] binding one SDK-mixin helper to an interpreted instance.
class SdkMixinMethodCallable implements Callable {
  final InterpretedInstance instance;
  final String memberName;
  final String contractName;
  final _MixinImpl _impl;

  SdkMixinMethodCallable(
    this.instance,
    this.memberName,
    this.contractName,
    this._impl,
  );

  @override
  int get arity => 0;

  @override
  Object? call(
    InterpreterVisitor visitor,
    List<Object?> positionalArguments, [
    Map<String, Object?> namedArguments = const {},
    List<RuntimeType>? typeArguments,
  ]) {
    return _impl(visitor, instance, positionalArguments, namedArguments);
  }

  @override
  String toString() => '<mixin helper $contractName.$memberName>';
}

class SdkMixinHelpers {
  const SdkMixinHelpers._();

  /// Pulls every element of [source], which may be a native [Iterable], a
  /// [BridgedInstance] wrapping one, or an interpreted iterable driven
  /// through its `iterator` member. Shared by the mixin algorithms and by
  /// bridges that must snapshot interpreted collections.
  static Iterable<Object?> eachSource(
    Object? source,
    InterpreterVisitor visitor,
    String member,
  ) {
    return _eachSource(source, visitor, member);
  }

  /// Reads `instance[index]` through the class's `[]` operator.
  static Object? readIndex(
    InterpretedInstance instance,
    InterpreterVisitor visitor,
    Object? index,
  ) {
    return _readIndex(instance, visitor, index);
  }

  /// Returns a callable for [memberName] when an inherited bridged mixin of
  /// [klass] supplies it natively, or null when no helper covers it.
  ///
  /// Getter entries are invoked immediately (a bare `obj.iterator` reads the
  /// getter, exactly as declared getters behave in member lookup); method
  /// entries return the bound callable for the invocation machinery.
  static Object? resolve(
    InterpretedInstance instance,
    InterpretedClass klass,
    String memberName,
    InterpreterVisitor? visitor,
  ) {
    for (final mixin in klass.inheritedBridgedMixins) {
      final resolved = _resolveFromContract(
        instance,
        mixin,
        memberName,
        visitor,
      );
      if (resolved != null) return resolved;
    }
    // An interpreted class may also *extend* a bridged contract base rather
    // than mix one in — `class Interceptors extends ListMixin<Interceptor>`
    // (dio), `class ListSlice extends ListBase` (package:collection). The
    // stub bridge declares no members, so without walking the bridged
    // superclass chain the inherited List helpers (`add`, `addAll`, `clear`,
    // `iterator`, …) are unreachable and the class is only loadable, not
    // callable. Dart puts the whole class in scope, superclass included, so
    // the base contract's helpers belong here too.
    InterpretedClass? current = klass;
    while (current != null) {
      final bridgedSuper = current.bridgedSuperclass;
      if (bridgedSuper != null) {
        final resolved = _resolveFromContract(
          instance,
          bridgedSuper,
          memberName,
          visitor,
        );
        if (resolved != null) return resolved;
      }
      current = current.superclass;
    }
    return null;
  }

  /// Resolves [memberName] against a single bridged [contract-provider]:
  /// returns the bound method callable or the evaluated getter, or null when
  /// that provider has no helper of this name (or no contract at all).
  static Object? _resolveFromContract(
    InterpretedInstance instance,
    BridgedClass provider,
    String memberName,
    InterpreterVisitor? visitor,
  ) {
    final contract = provider.providesContract;
    if (contract == null) return null;
    final table = _tables[contract];
    final method = table?.methods[memberName];
    if (method != null) {
      return SdkMixinMethodCallable(
        instance,
        memberName,
        provider.name,
        method,
      );
    }
    final getter = table?.getters[memberName];
    if (getter != null) {
      if (visitor == null) {
        return SdkMixinMethodCallable(
          instance,
          memberName,
          provider.name,
          getter,
        );
      }
      return getter(visitor, instance, const [], const {});
    }
    // Everything else the contract exposes — the whole `Iterable` surface
    // (`first`, `last`, `where`, `map`, `join`, `fold`, …), plus any `List`
    // member the hand-written tables don't enumerate — is run through the real
    // bridge for the contract, driven by a guest-backed facade. That reuses
    // the SDK algorithms the bridge already implements instead of restating
    // them here, and works for any interpreted class that extends/mixes in a
    // contract base (`ListMixin`, `ListBase`, `IterableBase`, …).
    if (visitor != null) {
      return _resolveViaContractBridge(
        instance,
        contract,
        memberName,
        visitor,
      );
    }
    return null;
  }

  /// Resolves [memberName] on the bridge for [contract] (and every contract it
  /// transitively implements), invoking through a facade that forwards the
  /// contract primitives back to [instance]. Returns null when the contract has
  /// no facade (currently only the List/Iterable contract) or the bridge has no
  /// member of that name.
  static Object? _resolveViaContractBridge(
    InterpretedInstance instance,
    String contract,
    String memberName,
    InterpreterVisitor visitor,
  ) {
    final environment = visitor.environment;
    final contractBridge = environment.findBridgedClassByName(contract);
    if (contractBridge == null) return null;
    final facade = _facadeFor(contract, instance, visitor);
    if (facade == null) return null;
    final bridges = <BridgedClass>[contractBridge];
    for (final name in BridgedClass.transitiveSupertypeNames(contract)) {
      final superBridge = environment.findBridgedClassByName(name);
      if (superBridge != null) bridges.add(superBridge);
    }
    for (final bridge in bridges) {
      final getter = bridge.findInstanceGetterAdapter(memberName);
      if (getter != null) return getter(visitor, facade);
      final method = bridge.findInstanceMethodAdapter(memberName);
      if (method != null) {
        return BridgedMethodCallable(
          BridgedInstance(bridge, facade),
          method,
          memberName,
        );
      }
    }
    return null;
  }

  /// Builds a native facade implementing [contract], backed by [instance]'s
  /// own `length`/`[]`/`[]=` primitives. Returns null for contracts without a
  /// facade yet (Set/Map).
  static Object? _facadeFor(
    String contract,
    InterpretedInstance instance,
    InterpreterVisitor visitor,
  ) {
    switch (contract) {
      case 'List':
      case 'Iterable':
        return _GuestList(instance, visitor);
    }
    return null;
  }

  static final Map<String, _ContractTable> _tables = {
    'List': (methods: _listMethods, getters: _listGetters),
  };

  // -- primitives (must be defined by the subclass; never helper-resolved) --

  static int _length(InterpretedInstance instance, InterpreterVisitor v) {
    final value = instance.get('length', visitor: v);
    if (value is! int) {
      throw RuntimeD4rtException(
        "The getter 'length' of '${instance.klass.name}' must return an int.",
      );
    }
    return value;
  }

  static Object? _readIndex(
    InterpretedInstance instance,
    InterpreterVisitor v,
    Object? index,
  ) {
    final op = instance.klass.findOperator('[]');
    if (op == null) {
      throw RuntimeD4rtException(
        "Class '${instance.klass.name}' does not define operator '[]'.",
      );
    }
    return op.bind(instance).call(v, [index], {});
  }

  static void _writeIndex(
    InterpretedInstance instance,
    InterpreterVisitor v,
    int index,
    Object? value,
  ) {
    final op = instance.klass.findOperator('[]=');
    if (op == null) {
      throw RuntimeD4rtException(
        "Class '${instance.klass.name}' does not define operator '[]='.",
      );
    }
    op.bind(instance).call(v, [index, value], {});
  }

  static Object? _callMember(
    InterpretedInstance instance,
    InterpreterVisitor v,
    String name,
    List<Object?> positional, [
    Map<String, Object?> named = const {},
  ]) {
    final member = instance.get(name, visitor: v);
    if (member is! Callable) {
      throw RuntimeD4rtException(
        "Member '$name' of '${instance.klass.name}' is not callable.",
      );
    }
    return member.call(v, positional, named);
  }

  static Object? _callFunction(
    Object? fn,
    InterpreterVisitor v,
    List<Object?> positional,
    String member,
  ) {
    if (fn is Callable) return fn.call(v, positional, {});
    if (fn is Function) return Function.apply(fn, positional);
    throw RuntimeD4rtException(
      'Argument to $member must be a function.',
    );
  }

  static bool _callPredicate(
    Object? fn,
    InterpreterVisitor v,
    List<Object?> positional,
    String member,
  ) {
    final result = _callFunction(fn, v, positional, member);
    if (result is! bool) {
      throw RuntimeD4rtException(
        'The test callback of $member must return a bool.',
      );
    }
    return result;
  }

  static Iterable<Object?> _eachSource(
    Object? source,
    InterpreterVisitor v,
    String member,
  ) sync* {
    final native = source is BridgedInstance ? source.nativeObject : source;
    if (native is Iterable) {
      yield* native;
      return;
    }
    if (source is InterpretedInstance) {
      final iterator = _callMember(source, v, 'iterator', []);
      if (iterator is Iterator) {
        // E.g. the List-contract snapshot iterator below.
        while (iterator.moveNext()) {
          yield iterator.current;
        }
        return;
      }
      if (iterator is InterpretedInstance) {
        while (_iteratorMoveNext(iterator, v, member)) {
          yield _iteratorCurrent(iterator, v, member);
        }
        return;
      }
      throw RuntimeD4rtException(
        'The iterator of the $member argument must define moveNext/current.',
      );
    }
    throw RuntimeD4rtException(
      'Argument to $member must be an Iterable.',
    );
  }

  static bool _iteratorMoveNext(
    InterpretedInstance iterable,
    InterpreterVisitor v,
    String member,
  ) {
    final result = _callMember(iterable, v, 'moveNext', []);
    if (result is! bool) {
      throw RuntimeD4rtException(
        'The moveNext of the $member iterator must return a bool.',
      );
    }
    return result;
  }

  static Object? _iteratorCurrent(
    InterpretedInstance iterable,
    InterpreterVisitor v,
    String member,
  ) {
    return iterable.get('current', visitor: v);
  }

  // -- List contract (mirrors SDK ListBase/ListMixin algorithms) --

  static final Map<String, _MixinImpl> _listMethods = {
    // (method table; see getters below for `iterator`)
    'add': (v, instance, pos, named) {
      if (pos.length != 1) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.add: expected one value.',
        );
      }
      final length = _length(instance, v);
      instance.set('length', length + 1, v);
      _writeIndex(instance, v, length, pos[0]);
      return null;
    },
    'addAll': (v, instance, pos, named) {
      if (pos.length != 1) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.addAll: expected one Iterable.',
        );
      }
      for (final element in _eachSource(pos[0], v, 'List.addAll')) {
        _callMember(instance, v, 'add', [element]);
      }
      return null;
    },
    'clear': (v, instance, pos, named) {
      instance.set('length', 0, v);
      return null;
    },
    'contains': (v, instance, pos, named) {
      if (pos.length != 1) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.contains: expected one value.',
        );
      }
      return _callMember(instance, v, 'indexOf', [pos[0]]) != -1;
    },
    'indexOf': (v, instance, pos, named) {
      if (pos.isEmpty || pos.length > 2) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.indexOf: expected (value, [start]).',
        );
      }
      final start = pos.length == 2 ? pos[1] as int : 0;
      final length = _length(instance, v);
      for (var i = start < 0 ? 0 : start; i < length; i++) {
        if (_readIndex(instance, v, i) == pos[0]) return i;
      }
      return -1;
    },
    'indexWhere': (v, instance, pos, named) {
      if (pos.isEmpty || pos.length > 2) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.indexWhere: expected (test, [start]).',
        );
      }
      final start = pos.length == 2 ? pos[1] as int : 0;
      final length = _length(instance, v);
      for (var i = start < 0 ? 0 : start; i < length; i++) {
        if (_callPredicate(pos[0], v, [
          _readIndex(instance, v, i),
        ], 'List.indexWhere')) {
          return i;
        }
      }
      return -1;
    },
    'lastIndexOf': (v, instance, pos, named) {
      if (pos.isEmpty || pos.length > 2) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.lastIndexOf: expected (value, [start]).',
        );
      }
      final length = _length(instance, v);
      var start = pos.length == 2 ? pos[1] as int : length - 1;
      if (start >= length) start = length - 1;
      for (var i = start; i >= 0; i--) {
        if (_readIndex(instance, v, i) == pos[0]) return i;
      }
      return -1;
    },
    'lastIndexWhere': (v, instance, pos, named) {
      if (pos.isEmpty || pos.length > 2) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.lastIndexWhere: expected (test, [start]).',
        );
      }
      final length = _length(instance, v);
      var start = pos.length == 2 ? pos[1] as int : length - 1;
      if (start >= length) start = length - 1;
      for (var i = start; i >= 0; i--) {
        if (_callPredicate(
          pos[0],
          v,
          [_readIndex(instance, v, i)],
          'List.lastIndexWhere',
        )) {
          return i;
        }
      }
      return -1;
    },
    'insert': (v, instance, pos, named) {
      if (pos.length != 2 || pos[0] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.insert: expected (int index, value).',
        );
      }
      final index = pos[0] as int;
      final length = _length(instance, v);
      RangeError.checkValidRange(index, index, length + 1);
      instance.set('length', length + 1, v);
      for (var i = length - 1; i >= index; i--) {
        _writeIndex(instance, v, i + 1, _readIndex(instance, v, i));
      }
      _writeIndex(instance, v, index, pos[1]);
      return null;
    },
    'insertAll': (v, instance, pos, named) {
      if (pos.length != 2 || pos[0] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.insertAll: expected (int index, Iterable).',
        );
      }
      final newcomers = _eachSource(pos[1], v, 'List.insertAll').toList();
      final index = pos[0] as int;
      final length = _length(instance, v);
      RangeError.checkValidRange(index, index, length + 1);
      instance.set('length', length + newcomers.length, v);
      for (var i = length - 1; i >= index; i--) {
        _writeIndex(
          instance,
          v,
          i + newcomers.length,
          _readIndex(instance, v, i),
        );
      }
      for (var i = 0; i < newcomers.length; i++) {
        _writeIndex(instance, v, index + i, newcomers[i]);
      }
      return null;
    },
    'remove': (v, instance, pos, named) {
      if (pos.length != 1) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.remove: expected one value.',
        );
      }
      final index = _callMember(instance, v, 'indexOf', [pos[0]]) as int;
      if (index == -1) return false;
      _callMember(instance, v, 'removeAt', [index]);
      return true;
    },
    'removeAt': (v, instance, pos, named) {
      if (pos.length != 1 || pos[0] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.removeAt: expected (int index).',
        );
      }
      final index = pos[0] as int;
      final length = _length(instance, v);
      RangeError.checkValidRange(index, index + 1, length);
      final removed = _readIndex(instance, v, index);
      for (var i = index; i < length - 1; i++) {
        _writeIndex(instance, v, i, _readIndex(instance, v, i + 1));
      }
      instance.set('length', length - 1, v);
      return removed;
    },
    'removeLast': (v, instance, pos, named) {
      final length = _length(instance, v);
      if (length == 0) throw StateError('No element');
      return _callMember(instance, v, 'removeAt', [length - 1]);
    },
    'removeRange': (v, instance, pos, named) {
      if (pos.length != 2 || pos[0] is! int || pos[1] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.removeRange: expected (int start, int end).',
        );
      }
      final start = pos[0] as int;
      final end = pos[1] as int;
      final length = _length(instance, v);
      RangeError.checkValidRange(start, end, length);
      final count = end - start;
      for (var i = end; i < length; i++) {
        _writeIndex(instance, v, i - count, _readIndex(instance, v, i));
      }
      instance.set('length', length - count, v);
      return null;
    },
    'removeWhere': (v, instance, pos, named) {
      if (pos.length != 1) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.removeWhere: expected one test function.',
        );
      }
      final length = _length(instance, v);
      final condemned = <int>[];
      for (var i = 0; i < length; i++) {
        if (_callPredicate(
          pos[0],
          v,
          [_readIndex(instance, v, i)],
          'List.removeWhere',
        )) {
          condemned.add(i);
        }
      }
      for (var i = condemned.length - 1; i >= 0; i--) {
        _callMember(instance, v, 'removeAt', [condemned[i]]);
      }
      return null;
    },
    'retainWhere': (v, instance, pos, named) {
      if (pos.length != 1) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.retainWhere: expected one test function.',
        );
      }
      final length = _length(instance, v);
      final condemned = <int>[];
      for (var i = 0; i < length; i++) {
        if (!_callPredicate(
          pos[0],
          v,
          [_readIndex(instance, v, i)],
          'List.retainWhere',
        )) {
          condemned.add(i);
        }
      }
      for (var i = condemned.length - 1; i >= 0; i--) {
        _callMember(instance, v, 'removeAt', [condemned[i]]);
      }
      return null;
    },
    'setAll': (v, instance, pos, named) {
      if (pos.length != 2 || pos[0] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.setAll: expected (int index, Iterable).',
        );
      }
      final newcomers = _eachSource(pos[1], v, 'List.setAll').toList();
      final index = pos[0] as int;
      final length = _length(instance, v);
      RangeError.checkValidRange(index, index + newcomers.length, length);
      for (var i = 0; i < newcomers.length; i++) {
        _writeIndex(instance, v, index + i, newcomers[i]);
      }
      return null;
    },
    'setRange': (v, instance, pos, named) {
      if (pos.length < 3 ||
          pos.length > 4 ||
          pos[0] is! int ||
          pos[1] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.setRange: expected '
          '(int start, int end, Iterable, [int skipCount]).',
        );
      }
      final start = pos[0] as int;
      final end = pos[1] as int;
      final skipCount = pos.length == 4 ? pos[3] as int : 0;
      final length = _length(instance, v);
      RangeError.checkValidRange(start, end, length);
      RangeError.checkNotNegative(skipCount, 'skipCount');
      final it = _eachSource(
        pos[2],
        v,
        'List.setRange',
      ).skip(skipCount).iterator;
      var i = start;
      while (i < end) {
        if (!it.moveNext()) {
          throw StateError('Too few elements in source iterable.');
        }
        _writeIndex(instance, v, i, it.current);
        i++;
      }
      return null;
    },
    'fillRange': (v, instance, pos, named) {
      if (pos.length < 2 ||
          pos.length > 3 ||
          pos[0] is! int ||
          pos[1] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.fillRange: expected '
          '(int start, int end, [fillValue]).',
        );
      }
      final start = pos[0] as int;
      final end = pos[1] as int;
      final fill = pos.length == 3 ? pos[2] : null;
      final length = _length(instance, v);
      RangeError.checkValidRange(start, end, length);
      for (var i = start; i < end; i++) {
        _writeIndex(instance, v, i, fill);
      }
      return null;
    },
    'replaceRange': (v, instance, pos, named) {
      if (pos.length != 3 || pos[0] is! int || pos[1] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.replaceRange: expected '
          '(int start, int end, Iterable).',
        );
      }
      _callMember(instance, v, 'removeRange', [pos[0], pos[1]]);
      _callMember(instance, v, 'insertAll', [pos[0], pos[2]]);
      return null;
    },
    'sort': (v, instance, pos, named) {
      final length = _length(instance, v);
      final items = List<Object?>.generate(
        length,
        (i) => _readIndex(instance, v, i),
      );
      final compare = pos.isNotEmpty ? pos[0] : null;
      if (compare == null) {
        items.sort((a, b) => (a as Comparable).compareTo(b));
      } else {
        items.sort((a, b) {
          final result = _callFunction(compare, v, [a, b], 'List.sort');
          if (result is! int) {
            throw RuntimeD4rtException(
              'The compare callback of List.sort must return an int.',
            );
          }
          return result;
        });
      }
      for (var i = 0; i < length; i++) {
        _writeIndex(instance, v, i, items[i]);
      }
      return null;
    },
    'shuffle': (v, instance, pos, named) {
      final length = _length(instance, v);
      final items = List<Object?>.generate(
        length,
        (i) => _readIndex(instance, v, i),
      );
      final random = pos.isNotEmpty ? pos[0] : null;
      final rng = random is Random
          ? random
          : (random is BridgedInstance && random.nativeObject is Random
                ? random.nativeObject as Random
                : Random());
      for (var i = length - 1; i > 0; i--) {
        final j = rng.nextInt(i + 1);
        final tmp = items[i];
        items[i] = items[j];
        items[j] = tmp;
      }
      for (var i = 0; i < length; i++) {
        _writeIndex(instance, v, i, items[i]);
      }
      return null;
    },
    'sublist': (v, instance, pos, named) {
      if (pos.isEmpty || pos.length > 2 || pos[0] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.sublist: expected (int start, [int end]).',
        );
      }
      final start = pos[0] as int;
      final length = _length(instance, v);
      final end = pos.length == 2 ? pos[1] as int : length;
      RangeError.checkValidRange(start, end, length);
      return List<Object?>.generate(
        end - start,
        (i) => _readIndex(instance, v, start + i),
      );
    },
    'getRange': (v, instance, pos, named) {
      // Deviation: the SDK returns a lazy view; this materializes a snapshot.
      if (pos.isEmpty || pos.length > 2 || pos[0] is! int) {
        throw RuntimeD4rtException(
          'Invalid arguments for List.getRange: expected (int start, [int end]).',
        );
      }
      final start = pos[0] as int;
      final length = _length(instance, v);
      final end = pos.length == 2 ? pos[1] as int : length;
      RangeError.checkValidRange(start, end, length);
      return List<Object?>.generate(
        end - start,
        (i) => _readIndex(instance, v, start + i),
      );
    },
    'asMap': (v, instance, pos, named) {
      // Deviation: the SDK returns a live view; this returns a snapshot.
      final length = _length(instance, v);
      return <int, Object?>{
        for (var i = 0; i < length; i++) i: _readIndex(instance, v, i),
      };
    },
  };

  static final Map<String, _MixinImpl> _listGetters = {
    'iterator': (v, instance, pos, named) {
      // Deviation: a snapshot iterator (no ConcurrentModificationError).
      final length = _length(instance, v);
      final snapshot = List<Object?>.generate(
        length,
        (i) => _readIndex(instance, v, i),
      );
      return snapshot.iterator;
    },
  };
}

/// One SDK-mixin contract: method helpers stay callable, getter helpers run
/// on read (mirroring how member lookup treats declared getters).
typedef _ContractTable = ({
  Map<String, _MixinImpl> methods,
  Map<String, _MixinImpl> getters,
});

/// A native [List] view over an interpreted instance that supplies the
/// contract's primitives (`length`, `[]`, `[]=`).
///
/// It is handed to the real `List`/`Iterable` bridge adapters, so every
/// inherited algorithm the SDK implements — `add`, `sort`, `first`, `where`,
/// `fold`, `join`, the iterator, … — runs natively against the guest's own
/// storage. `_GuestList` itself is a [ListBase], which is how those algorithms
/// are wired in the SDK, so a bridged `add` really does `this[length++] = …`
/// and therefore lands on the instance's `[]=`.
///
/// Primitives are read straight off the interpreted class (never through
/// `Instance.get`), so a missing primitive cannot re-enter the contract
/// resolution that built this facade.
class _GuestList extends ListBase<Object?> {
  final InterpretedInstance instance;
  final InterpreterVisitor visitor;

  _GuestList(this.instance, this.visitor);

  Object? _getter(String name) {
    final getter = instance.klass.findInstanceGetter(name);
    if (getter == null) {
      throw RuntimeD4rtException(
        "Class '${instance.klass.name}' does not define '$name'.",
      );
    }
    return getter.bind(instance).call(visitor, const [], const {});
  }

  @override
  int get length {
    final value = _getter('length');
    return value is int ? value : 0;
  }

  @override
  set length(int newLength) {
    final setter = instance.klass.findInstanceSetter('length');
    if (setter == null) {
      throw RuntimeD4rtException(
        "Class '${instance.klass.name}' does not define 'length='.",
      );
    }
    setter.bind(instance).call(visitor, [newLength], const {});
  }

  @override
  Object? operator [](int index) {
    final op = instance.klass.findOperator('[]');
    if (op == null) {
      throw RuntimeD4rtException(
        "Class '${instance.klass.name}' does not define operator '[]'.",
      );
    }
    return op.bind(instance).call(visitor, [index], const {});
  }

  @override
  void operator []=(int index, Object? value) {
    final op = instance.klass.findOperator('[]=');
    if (op == null) {
      throw RuntimeD4rtException(
        "Class '${instance.klass.name}' does not define operator '[]='.",
      );
    }
    op.bind(instance).call(visitor, [index, value], const {});
  }
}

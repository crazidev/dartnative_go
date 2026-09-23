import 'bytecode_models.dart';

/// Global function table enabling O(1) invocation and atomic hot-swapping.
class FunctionTable {
  final Map<int, BytecodeFunction> _table = {};
  final Map<String, int> _qualifiedNameToId = {};
  final Map<String, List<int>> _classToMethodIds = {};

  int get count => _table.length;

  /// Registers a function into the table.
  void register(BytecodeFunction function) {
    _table[function.id] = function;
    _qualifiedNameToId[function.qualifiedName] = function.id;
    if (function.enclosingClass != null) {
      _classToMethodIds
          .putIfAbsent(function.enclosingClass!, () => [])
          .add(function.id);
    }
  }

  /// Registers all functions from a bundle.
  void registerAll(Iterable<BytecodeFunction> functions) {
    for (final fn in functions) {
      register(fn);
    }
  }

  /// Retrieves a function by its integer ID.
  BytecodeFunction? get(int funcId) => _table[funcId];

  /// Retrieves a function by its qualified name (`Class.method` or `functionName`).
  BytecodeFunction? getByName(String qualifiedName) {
    final id = _qualifiedNameToId[qualifiedName];
    return id != null ? _table[id] : null;
  }

  /// Applies a [BytecodeDelta] by hot-swapping changed function bodies in-place.
  /// Returns the set of dirty widget/class names affected by the swap.
  Set<String> applyDelta(BytecodeDelta delta) {
    final dirtyClasses = Set<String>.from(delta.dirtyClassNames);
    for (final updatedFn in delta.updatedFunctions) {
      _table[updatedFn.id] = updatedFn;
      _qualifiedNameToId[updatedFn.qualifiedName] = updatedFn.id;
      if (updatedFn.enclosingClass != null) {
        dirtyClasses.add(updatedFn.enclosingClass!);
      }
    }
    return dirtyClasses;
  }

  /// Clears the function table.
  void clear() {
    _table.clear();
    _qualifiedNameToId.clear();
    _classToMethodIds.clear();
  }
}

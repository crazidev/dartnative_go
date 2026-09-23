import 'package:tom_d4rt_ast/runtime.dart'
    show Callable, InterpreterVisitor, RuntimeType;
import 'bytecode_models.dart';
import 'vm.dart';

/// Call frame representing an active execution frame on the VM call stack.
class CallFrame {
  final BytecodeFunction function;
  int pc = 0;
  final List<Object?> slots;
  final List<Object?>? capturedEnv;
  int? catchPc;

  CallFrame({
    required this.function,
    required int slotCount,
    this.capturedEnv,
  }) : slots = List<Object?>.filled(slotCount, null, growable: false);

  Object? getLocal(int slot) =>
      (slot >= 0 && slot < slots.length) ? slots[slot] : null;

  void setLocal(int slot, Object? value) {
    if (slot >= 0 && slot < slots.length) {
      slots[slot] = value;
    }
  }
}

/// Represents an interpreted closure capturing its lexical environment.
class BytecodeClosure implements Callable {
  final int funcId;
  final List<Object?> capturedSlots;
  final BytecodeVM? vm;
  final BytecodeInstance? thisTarget;

  const BytecodeClosure({
    required this.funcId,
    required this.capturedSlots,
    this.vm,
    this.thisTarget,
  });

  @override
  int get arity => 0;

  @override
  Object? call(
    InterpreterVisitor visitor,
    List<Object?> positionalArguments, [
    Map<String, Object?>? namedArguments,
    List<RuntimeType>? typeArguments,
  ]) {
    final activeVm = vm ?? BytecodeVM.current;
    if (activeVm == null) {
      throw StateError('Cannot invoke BytecodeClosure without active BytecodeVM');
    }
    return activeVm.executeFunction(
      funcId: funcId,
      positionalArgs: positionalArguments,
      namedArgs: namedArguments ?? const {},
      capturedEnv: capturedSlots,
      thisTarget: thisTarget,
    );
  }
}

/// Represents an instantiated interpreted class instance.
class BytecodeInstance {
  BytecodeClass bytecodeClass;
  final Map<String, Object?> fields = {};
  final Map<String, String> _appliedInitHashes = {};
  Object? nativeProxy;

  BytecodeInstance(this.bytecodeClass) {
    for (final f in bytecodeClass.fieldNames) {
      fields[f] = null;
    }
  }

  void recordInitHash(String fieldName, String hash) {
    _appliedInitHashes[fieldName] = hash;
  }

  /// Synchronizes this instance to a newer [BytecodeClass] definition (e.g. after hot reload).
  void syncClass(BytecodeClass newClass, [BytecodeVM? vm]) {
    bytecodeClass = newClass;
    for (final f in newClass.fieldNames) {
      final isNewField = !fields.containsKey(f);
      final newInitId = newClass.fieldInitializerFuncIds[f];
      final newHash = newInitId != null
          ? vm?.functionTable.get(newInitId)?.contentHash
          : null;
      final initChanged = newHash != null &&
          _appliedInitHashes.containsKey(f) &&
          _appliedInitHashes[f] != newHash;

      if (isNewField || fields[f] == null || initChanged) {
        if (newInitId != null && vm != null) {
          try {
            fields[f] = vm.executeFunction(
              funcId: newInitId,
              thisTarget: this,
            );
            if (newHash != null) {
              _appliedInitHashes[f] = newHash;
            }
          } catch (_) {
            fields.putIfAbsent(f, () => null);
          }
        } else {
          fields.putIfAbsent(f, () => null);
        }
      }
    }
  }

  Object? getField(String name) {
    if (nativeProxy != null) {
      if (name == 'widget') {
        try {
          return (nativeProxy as dynamic).widgetInstance ?? (nativeProxy as dynamic).widget;
        } catch (_) {}
      }
      if (name == 'ref') {
        try {
          return (nativeProxy as dynamic).ref;
        } catch (_) {}
      }
      if (name == 'context') {
        try {
          return (nativeProxy as dynamic).context;
        } catch (_) {}
      }
      if (name == 'mounted') {
        try {
          return (nativeProxy as dynamic).mounted;
        } catch (_) {}
      }
      if (name == 'state') {
        try {
          return (nativeProxy as dynamic).state;
        } catch (_) {}
      }
    }
    if (fields.containsKey(name)) {
      return fields[name];
    }
    return null;
  }

  void setField(String name, Object? value) {
    fields[name] = value;
    if (name == 'state' && nativeProxy != null) {
      try {
        (nativeProxy as dynamic).state = value;
      } catch (_) {}
    }
  }
}

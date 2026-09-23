import 'bytecode_models.dart';

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
class BytecodeClosure {
  final int funcId;
  final List<Object?> capturedSlots;

  const BytecodeClosure({
    required this.funcId,
    required this.capturedSlots,
  });
}

/// Represents an instantiated interpreted class instance.
class BytecodeInstance {
  final BytecodeClass bytecodeClass;
  final Map<String, Object?> fields = {};
  Object? nativeProxy;

  BytecodeInstance(this.bytecodeClass) {
    for (final f in bytecodeClass.fieldNames) {
      fields[f] = null;
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

import 'dart:typed_data';
import 'package:dartnative_go/src/runner/bytecode/bytecode_models.dart';
import 'package:dartnative_go/src/runner/bytecode/opcodes.dart';
import 'package:dartnative_go/src/runner/bytecode/vm.dart';
import 'package:test/test.dart';

void main() {
  group('BytecodeVM Execution & Hot-Patching', () {
    late BytecodeVM vm;

    setUp(() {
      vm = BytecodeVM();
    });

    test('Executes basic arithmetic and local variable operations', () {
      // Bytecode for:
      // var a = 10;
      // var b = 20;
      // return a + b;
      final code = Uint8List.fromList([
        OpCode.pushInt, 0, 0, 0, 10,       // push 10
        OpCode.storeLocal, 0, 0,           // slot 0 = 10
        OpCode.pushInt, 0, 0, 0, 20,       // push 20
        OpCode.storeLocal, 0, 1,           // slot 1 = 20
        OpCode.loadLocal, 0, 0,            // push slot 0
        OpCode.loadLocal, 0, 1,            // push slot 1
        OpCode.binaryOp, BinaryOpId.add,   // add
        OpCode.retValue,                   // return 30
      ]);

      final fn = BytecodeFunction(
        id: 1,
        name: 'addTest',
        uri: 'package:test/main.dart',
        contentHash: 'hash1',
        localSlotsCount: 2,
        code: code,
      );

      final bundle = BytecodeBundle(
        entryPointUri: 'package:test/main.dart',
        entryPointFuncId: 1,
        constantPool: const ConstantPool([]),
        functions: [fn],
        classes: const [],
      );

      final result = vm.loadBundle(bundle);
      expect(result, equals(30));
    });

    test('Executes conditional branching (if/else)', () {
      // Bytecode for:
      // if (x > 5) return 100; else return 200;
      // with x = 10
      final code = Uint8List.fromList([
        OpCode.pushInt, 0, 0, 0, 10,       // x = 10
        OpCode.pushInt, 0, 0, 0, 5,        // 5
        OpCode.binaryOp, BinaryOpId.gt,    // 10 > 5 => true
        OpCode.jumpIfFalse, 0, 0, 0, 12,   // jump to else (+12 bytes)
        OpCode.pushInt, 0, 0, 0, 100,      // return 100
        OpCode.retValue,
        OpCode.pushInt, 0, 0, 0, 200,      // else: return 200
        OpCode.retValue,
      ]);

      final fn = BytecodeFunction(
        id: 1,
        name: 'branchTest',
        uri: 'package:test/main.dart',
        contentHash: 'hash2',
        localSlotsCount: 0,
        code: code,
      );

      final bundle = BytecodeBundle(
        entryPointUri: 'package:test/main.dart',
        entryPointFuncId: 1,
        constantPool: const ConstantPool([]),
        functions: [fn],
        classes: const [],
      );

      final result = vm.loadBundle(bundle);
      expect(result, equals(100));
    });

    test('Hot-patches function logic in-place preserving object instance state', () {
      // Class Counter with state `count` and method `increment()`
      // Version 1 increment(): count = count + 1
      // Version 2 increment(): count = count + 10 (hot-patched)

      final pool = ConstantPool(['count', 'increment']);

      // ctor func (id: 2): this.count = 0
      final ctorCode = Uint8List.fromList([
        OpCode.pushInt, 0, 0, 0, 0,  // push 0 (val)
        OpCode.loadLocal, 0, 0,      // load this (target)
        OpCode.storeField, 0, 0,     // this.count = 0
        OpCode.ret,
      ]);

      // method func v1 (id: 3): this.count = this.count + 1
      final v1MethodCode = Uint8List.fromList([
        OpCode.loadLocal, 0, 0,           // load this
        OpCode.loadField, 0, 0,           // get this.count
        OpCode.pushInt, 0, 0, 0, 1,       // push 1
        OpCode.binaryOp, BinaryOpId.add,  // this.count + 1 (val)
        OpCode.loadLocal, 0, 0,           // load this (target)
        OpCode.storeField, 0, 0,          // this.count = val
        OpCode.loadLocal, 0, 0,           // load this
        OpCode.loadField, 0, 0,           // return this.count
        OpCode.retValue,
      ]);

      final ctorFn = BytecodeFunction(
        id: 2,
        name: 'new',
        uri: 'package:test/counter.dart',
        enclosingClass: 'Counter',
        contentHash: 'ctor_hash',
        localSlotsCount: 1,
        code: ctorCode,
      );

      final v1MethodFn = BytecodeFunction(
        id: 3,
        name: 'increment',
        uri: 'package:test/counter.dart',
        enclosingClass: 'Counter',
        contentHash: 'v1_hash',
        localSlotsCount: 1,
        code: v1MethodCode,
      );

      final cls = BytecodeClass(
        name: 'Counter',
        uri: 'package:test/counter.dart',
        fieldNames: ['count'],
        methodFuncIds: {'increment': 3},
        constructorFuncIds: {'new': 2},
      );

      final bundle = BytecodeBundle(
        entryPointUri: 'package:test/counter.dart',
        entryPointFuncId: 2,
        constantPool: pool,
        functions: [ctorFn, v1MethodFn],
        classes: [cls],
      );

      vm.loadBundle(bundle);

      // Instantiate Counter
      final instance = vm.instantiateClass('Counter', 'new', [], {});
      expect(instance.fields['count'], equals(0));

      // Invoke increment() v1 -> count = 1
      final res1 = vm.invokeMethod(instance, 'increment', [], {});
      expect(res1, equals(1));
      expect(instance.fields['count'], equals(1));

      // Again increment() v1 -> count = 2
      final res2 = vm.invokeMethod(instance, 'increment', [], {});
      expect(res2, equals(2));
      expect(instance.fields['count'], equals(2));

      // Now prepare HOT PATCH (Delta): replace increment() with +10
      final v2MethodCode = Uint8List.fromList([
        OpCode.loadLocal, 0, 0,           // load this
        OpCode.loadField, 0, 0,           // get this.count
        OpCode.pushInt, 0, 0, 0, 10,      // push 10
        OpCode.binaryOp, BinaryOpId.add,  // this.count + 10 (val)
        OpCode.loadLocal, 0, 0,           // load this (target)
        OpCode.storeField, 0, 0,          // this.count = val
        OpCode.loadLocal, 0, 0,           // load this
        OpCode.loadField, 0, 0,           // return this.count
        OpCode.retValue,
      ]);

      final v2MethodFn = BytecodeFunction(
        id: 3,
        name: 'increment',
        uri: 'package:test/counter.dart',
        enclosingClass: 'Counter',
        contentHash: 'v2_hash',
        localSlotsCount: 1,
        code: v2MethodCode,
      );

      final delta = BytecodeDelta(
        version: 1,
        changedConstants: const {},
        updatedFunctions: [v2MethodFn],
        dirtyClassNames: {'Counter'},
      );

      // Apply hot patch in-place
      final dirty = vm.applyDelta(delta);
      expect(dirty, contains('Counter'));

      // The existing instance retained its heap state (count == 2)
      expect(instance.fields['count'], equals(2));

      // Next call to increment() on the SAME instance executes new v2 bytecode (+10) -> count = 12
      final res3 = vm.invokeMethod(instance, 'increment', [], {});
      expect(res3, equals(12));
      expect(instance.fields['count'], equals(12));
    });
  });
}

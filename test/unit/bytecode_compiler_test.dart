import 'dart:typed_data';
import 'package:dartnative_go/src/cli/bytecode_emitter.dart';
import 'package:dartnative_go/src/runner/bytecode/bundle_codec.dart';
import 'package:dartnative_go/src/runner/bytecode/bytecode_models.dart';
import 'package:dartnative_go/src/runner/bytecode/opcodes.dart';
import 'package:test/test.dart';

void main() {
  group('BytecodeEmitter & ConstantPool Tests', () {
    test('ConstantPool deduplicates constants', () {
      final pool = ConstantPoolBuilder();
      final idx1 = pool.add('hello');
      final idx2 = pool.add('world');
      final idx3 = pool.add('hello');
      final idx4 = pool.add(42);
      final idx5 = pool.add(42);

      expect(idx1, equals(idx3));
      expect(idx4, equals(idx5));
      expect(idx1, isNot(equals(idx2)));

      final built = pool.build();
      expect(built[idx1], equals('hello'));
      expect(built[idx2], equals('world'));
      expect(built[idx4], equals(42));
    });

    test('BytecodeBundleCodec round-trips bundles and deltas', () {
      final pool = ConstantPool(['title', 'Counter', 100]);
      final fn = BytecodeFunction(
        id: 1,
        name: 'main',
        uri: 'package:app/main.dart',
        contentHash: 'abc1234',
        positionalParamCount: 0,
        localSlotsCount: 2,
        code: Uint8List.fromList([OpCode.pushInt, 0, 0, 0, 42, OpCode.retValue]),
      );

      final bundle = BytecodeBundle(
        entryPointUri: 'package:app/main.dart',
        entryPointFuncId: 1,
        constantPool: pool,
        functions: [fn],
        classes: const [],
      );

      final encoded = BytecodeBundleCodec.encodeBundle(bundle);
      expect(encoded.isNotEmpty, isTrue);

      final decoded = BytecodeBundleCodec.decodeBundle(encoded);
      expect(decoded.entryPointUri, equals('package:app/main.dart'));
      expect(decoded.functions.length, equals(1));
      expect(decoded.functions.first.name, equals('main'));
      expect(decoded.functions.first.code, equals(fn.code));
    });

    test('BytecodeEmitter.computeDelta identifies changed functions', () {
      final pool = ConstantPool(['hello']);
      final fn1 = BytecodeFunction(
        id: 1,
        name: 'build',
        uri: 'package:app/home.dart',
        enclosingClass: 'HomeScreen',
        contentHash: 'hash_v1',
        positionalParamCount: 1,
        localSlotsCount: 2,
        code: Uint8List.fromList([OpCode.pushInt, 0, 0, 0, 1, OpCode.retValue]),
      );

      final oldBundle = BytecodeBundle(
        entryPointUri: 'package:app/main.dart',
        entryPointFuncId: 1,
        constantPool: pool,
        functions: [fn1],
        classes: [
          const BytecodeClass(
            name: 'HomeScreen',
            uri: 'package:app/home.dart',
            fieldNames: ['count'],
            methodFuncIds: {'build': 1},
          )
        ],
      );

      final fn1Updated = BytecodeFunction(
        id: 1,
        name: 'build',
        uri: 'package:app/home.dart',
        enclosingClass: 'HomeScreen',
        contentHash: 'hash_v2', // changed hash
        positionalParamCount: 1,
        localSlotsCount: 2,
        code: Uint8List.fromList([OpCode.pushInt, 0, 0, 0, 2, OpCode.retValue]),
      );

      final newBundle = BytecodeBundle(
        entryPointUri: 'package:app/main.dart',
        entryPointFuncId: 1,
        constantPool: pool,
        functions: [fn1Updated],
        classes: [
          const BytecodeClass(
            name: 'HomeScreen',
            uri: 'package:app/home.dart',
            fieldNames: ['count'],
            methodFuncIds: {'build': 1},
          )
        ],
      );

      final delta = BytecodeEmitter.computeDelta(
        oldBundle: oldBundle,
        newBundle: newBundle,
      );

      expect(delta.hasStructuralChange, isFalse);
      expect(delta.updatedFunctions.length, equals(1));
      expect(delta.updatedFunctions.first.id, equals(1));
      expect(delta.dirtyClassNames, contains('HomeScreen'));
    });
  });
}

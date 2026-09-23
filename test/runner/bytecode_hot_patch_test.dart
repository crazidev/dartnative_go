import 'dart:io';
import 'dart:typed_data';
import 'package:dartnative_go/src/runner/bytecode/bundle_codec.dart';
import 'package:dartnative_go/src/runner/bytecode/bytecode_models.dart';
import 'package:dartnative_go/src/runner/bytecode/opcodes.dart';
import 'package:dartnative_go/src/runner/bytecode_interpreter_runner.dart';
import 'package:test/test.dart';

void main() {
  group('BytecodeInterpreterRunner True Hot-Patching End-to-End', () {
    late BytecodeInterpreterRunner runner;

    setUp(() {
      runner = BytecodeInterpreterRunner();
    });

    tearDown(() {
      runner.dispose();
    });

    test('Loads compiled bytecode bundle and hot-patches widget build method', () async {
      // Create a Widget class `MyWidget` extends StatelessWidget
      // ctor id: 1
      // build(context) id: 2: returns Text("Hello v1")
      // main() id: 3: calls runApp(MyWidget()) or returns MyWidget()

      final pool = ConstantPool([
        'MyWidget',
        'StatelessWidget',
        'Text',
        'Hello v1',
        'new',
        'build',
        'runApp',
      ]);

      // MyWidget ctor (id: 1)
      final ctorFn = BytecodeFunction(
        id: 1,
        name: 'new',
        uri: 'package:app/main.dart',
        enclosingClass: 'MyWidget',
        contentHash: 'ctor_hash',
        localSlotsCount: 1,
        code: Uint8List.fromList([
          OpCode.ret,
        ]),
      );

      // MyWidget.build(context) (id: 2) -> returns Text("Hello v1")
      // callConstructor: class: Text (idx 2), ctor: new (idx 4), pos: 1, named: 0
      final buildV1Fn = BytecodeFunction(
        id: 2,
        name: 'build',
        uri: 'package:app/main.dart',
        enclosingClass: 'MyWidget',
        contentHash: 'build_v1',
        positionalParamCount: 1, // context
        localSlotsCount: 2,      // this, context
        code: Uint8List.fromList([
          OpCode.pushConst, 0, 3, // "Hello v1"
          OpCode.callConstructor, 0, 2, 0, 4, 1, 0,
          OpCode.retValue,
        ]),
      );

      // main() (id: 3) -> calls runApp(MyWidget())
      final mainFn = BytecodeFunction(
        id: 3,
        name: 'main',
        uri: 'package:app/main.dart',
        contentHash: 'main_hash',
        localSlotsCount: 1,
        code: Uint8List.fromList([
          OpCode.pushNull,                          // target for top-level call
          OpCode.callConstructor, 0, 0, 0, 4, 0, 0, // new MyWidget()
          OpCode.callMethod, 0, 6, 1, 0,            // runApp(MyWidget())
          OpCode.ret,
        ]),
      );

      final cls = BytecodeClass(
        name: 'MyWidget',
        uri: 'package:app/main.dart',
        superclass: 'StatelessWidget',
        methodFuncIds: {'build': 2},
        constructorFuncIds: {'new': 1},
      );

      final bundle = BytecodeBundle(
        entryPointUri: 'package:app/main.dart',
        entryPointFuncId: 3,
        constantPool: pool,
        functions: [ctorFn, buildV1Fn, mainFn],
        classes: [cls],
      );

      final bundleBytes = BytecodeBundleCodec.encodeBundle(bundle);

      // Evaluate bundle
      final widget = await runner.evaluateBytecodeBundle(bundleBytes);
      expect(widget, isNotNull);

      // Now create Hot-Patch Delta: update build() to return Text("Hello v2 (Hot Patched!)")
      // pool extension: idx 7: "Hello v2 (Hot Patched!)"
      final buildV2Fn = BytecodeFunction(
        id: 2,
        name: 'build',
        uri: 'package:app/main.dart',
        enclosingClass: 'MyWidget',
        contentHash: 'build_v2',
        positionalParamCount: 1,
        localSlotsCount: 2,
        code: Uint8List.fromList([
          OpCode.pushConst, 0, 7, // "Hello v2 (Hot Patched!)"
          OpCode.callConstructor, 0, 2, 0, 4, 1, 0,
          OpCode.retValue,
        ]),
      );

      final delta = BytecodeDelta(
        version: 1,
        changedConstants: {
          7: 'Hello v2 (Hot Patched!)',
        },
        updatedFunctions: [buildV2Fn],
        dirtyClassNames: {'MyWidget'},
      );

      final dirtyClasses = runner.applyBytecodeDelta(delta);
      expect(dirtyClasses, contains('MyWidget'));

      // Function table now resolves build (id: 2) to v2
      final updatedFunc = runner.vm.functionTable.get(2);
      expect(updatedFunc?.contentHash, equals('build_v2'));
    });

    test('Evaluates pre-compiled example guest.bc containing ProviderScope & TodoScreen', () async {
      final bcFile = File('example/assets/bundles/guest.bc');
      if (!bcFile.existsSync()) return;

      final bytes = await bcFile.readAsBytes();
      final widget = await runner.evaluateBytecodeBundle(bytes);
      expect(widget, isNotNull);
    });
  });
}

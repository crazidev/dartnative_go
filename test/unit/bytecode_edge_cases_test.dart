import 'dart:io';
import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/cli/bytecode_emitter.dart';
import 'package:dartnative_go/src/runner/ast_bundle_codec.dart';
import 'package:dartnative_go/src/runner/bytecode/bundle_codec.dart';
import 'package:dartnative_go/src/runner/bytecode/bytecode_widget_proxies.dart';
import 'package:dartnative_go/src/runner/bytecode/call_frame.dart';
import 'package:dartnative_go/src/runner/bytecode/vm.dart';
import 'package:dartnative_go/src/runner/native_bottomsheet_manager.dart';
import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart';

Future<BytecodeVM> compileAndRun(String source) async {
  final bundler = AstBundler(
    bridgedLibraries: kAstBridgedLibraries,
    packageName: 'scratch_app',
    converter: SafeAstConverter(),
  );
  final astBundle = await bundler.createFromSource(
    source,
    sourcePath: 'main.dart',
  );
  final bcBundle = BytecodeEmitter().compileBundle(astBundle);
  final vm = BytecodeVM();
  vm.loadBundle(bcBundle);
  return vm;
}

void main() {
  group('scratch repro', () {
    test('const EdgeInsets padding applied to Container', () async {
      const src = '''
import 'package:dartnative/dartnative.dart';
void main() {
  runApp(Container(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
  ));
}
''';
      final vm = await compileAndRun(src);
      final app = vm.bridgeAdapter.capturedApp;
      expect(app, isA<Container>());
      final container = app as Container;
      expect(container.padding, isA<EdgeInsets>());
      final p = container.padding as EdgeInsets;
      expect(p.left, equals(16));
      expect(p.top, equals(14));
      expect(p.right, equals(16));
      expect(p.bottom, equals(16));
    });

    test('compile guest.ast to bytecode and check EdgeInsets.fromLTRB', () async {
      final file = File('example/assets/bundles/guest.ast');
      final bytes = await file.readAsBytes();
      final astBundle = decodeAstBundleBytes(bytes);
      final bcBundle = BytecodeEmitter().compileBundle(astBundle);
      expect(bcBundle.constantPool.constants, contains('EdgeInsets'));
      expect(bcBundle.constantPool.constants, contains('fromLTRB'));
      final encodedBytes = BytecodeBundleCodec.encodeBundle(bcBundle);
      await File('example/assets/bundles/guest.bc').writeAsBytes(encodedBytes, flush: true);

      final vm = BytecodeVM();
      vm.loadBundle(bcBundle);
      print('DEBUG globals NoteColors.blue: ${(vm.globals['NoteColors.blue'] as Color?)?.value}');
      print('DEBUG globals NoteColors.yellow: ${(vm.globals['NoteColors.yellow'] as Color?)?.value}');
      final createPanelCls = vm.classes['CreateNotePanel']!;
      final panelInstance = vm.executeFunction(funcId: createPanelCls.constructorFuncIds['new'] ?? createPanelCls.constructorFuncIds['']!) as BytecodeInstance?;
      final stateRes = vm.executeFunction(
        funcId: createPanelCls.methodFuncIds['createState']!,
        thisTarget: panelInstance,
      );
      if (stateRes is BytecodeInstance) {
        print('DEBUG stateRes selectedColor: ${(stateRes.fields['selectedColor'] as Color?)?.value}');
        expect(stateRes.fields['selectedColor'], isNotNull);
      }
    });

    test('non-const EdgeInsets padding applied to Container', () async {
      const src = '''
import 'package:dartnative/dartnative.dart';
void main() {
  runApp(Container(
    padding: EdgeInsets.fromLTRB(16, 14, 16, 16),
  ));
}
''';
      final vm = await compileAndRun(src);
      final app = vm.bridgeAdapter.capturedApp;
      expect(app, isA<Container>());
      final container = app as Container;
      expect(container.padding, isA<EdgeInsets>());
      final p = container.padding as EdgeInsets;
      expect(p.left, equals(16));
      expect(p.top, equals(14));
      expect(p.right, equals(16));
      expect(p.bottom, equals(16));
    });

    test('static const siblings in list', () async {
      const src = '''
import 'package:dartnative/dartnative.dart';
class NoteColors {
  static const yellow = Color(0xFFFFF3A3);
  static const pink = Color(0xFFFFC9D6);
  static const all = [yellow, pink];
}
void main() { runApp(Container(color: NoteColors.yellow)); }
''';
      final vm = await compileAndRun(src);
      final yellow = vm.globals['NoteColors.yellow'];
      expect(yellow, isA<Color>());
      expect((yellow as Color).value, equals(0xFFFFF3A3));

      final all = vm.globals['NoteColors.all'] as List?;
      expect(all, isNotNull);
      expect(all!.length, equals(2));
      expect((all[0] as Color).value, equals(0xFFFFF3A3));
      expect((all[1] as Color).value, equals(0xFFFFC9D6));

      final app = vm.bridgeAdapter.capturedApp;
      expect(app, isA<Container>());
      final container = app as Container;
      expect(container.color, isA<Color>());
      expect(container.color!.value, equals(0xFFFFF3A3));
    });

    test('top-level variable preserves mutated runtime value on hot reload', () async {
      const src1 = '''
var example = "Hello world";
void main() {}
''';
      final bundler = AstBundler(
        bridgedLibraries: kAstBridgedLibraries,
        packageName: 'scratch_app',
        converter: SafeAstConverter(),
      );
      final astBundle1 = await bundler.createFromSource(src1, sourcePath: 'main.dart');
      final bcBundle1 = BytecodeEmitter().compileBundle(astBundle1);

      final vm = BytecodeVM();
      vm.loadBundle(bcBundle1);
      expect(vm.globals['example'], equals('Hello world'));

      // Mutate global at runtime
      vm.globals['example'] = 'Hello world1!!!!';
      expect(vm.globals['example'], equals('Hello world1!!!!'));

      // Simulate hot reload with a modified bundle (or same bundle recompiled)
      const src2 = '''
var example = "Hello world";
var newVar = "I am new";
void main() {}
''';
      final astBundle2 = await bundler.createFromSource(src2, sourcePath: 'main.dart');
      final bcBundle2 = BytecodeEmitter().compileBundle(astBundle2);

      vm.loadBundle(bcBundle2, isHotReload: true);

      // The mutated value MUST be preserved
      expect(vm.globals['example'], equals('Hello world1!!!!'));
      // The new variable MUST be initialized
      expect(vm.globals['newVar'], equals('I am new'));
    });

    test('closure in class method reads and writes instance field', () async {
      const src = '''
import 'package:dartnative/dartnative.dart';

class NoteColors {
  static const yellow = Color(0xFFFFF3A3);
  static const blue = Color(0xFFBFE3FF);
  static const all = [yellow, blue];
}

class MyPanel {
  Color selectedColor = NoteColors.blue;

  void selectYellow() {
    final fn = () {
      selectedColor = NoteColors.yellow;
    };
    fn();
  }

  bool isSelected(Color c) {
    final fn = (Color color) {
      return color == selectedColor;
    };
    return fn(c);
  }
}

void main() {}
''';
      final vm = await compileAndRun(src);
      final myPanelCls = vm.classes['MyPanel']!;
      final inst = vm.instantiateClass('MyPanel', '');

      expect(inst.fields['selectedColor'], isNotNull);
      expect((inst.fields['selectedColor'] as Color).value, equals(0xFFBFE3FF));

      // Test isSelected inside closure
      final isBlue = vm.executeFunction(
        funcId: myPanelCls.methodFuncIds['isSelected']!,
        positionalArgs: [vm.globals['NoteColors.blue']],
        thisTarget: inst,
      );
      expect(isBlue, isTrue);

      // Mutate via closure inside selectYellow
      vm.executeFunction(
        funcId: myPanelCls.methodFuncIds['selectYellow']!,
        thisTarget: inst,
      );
      expect((inst.fields['selectedColor'] as Color).value, equals(0xFFFFF3A3));

      final isYellow = vm.executeFunction(
        funcId: myPanelCls.methodFuncIds['isSelected']!,
        positionalArgs: [vm.globals['NoteColors.yellow']],
        thisTarget: inst,
      );
      expect(isYellow, isTrue);
    });

    test('findUserClassInVisitor locates class in AST mode and Bytecode mode', () async {
      const src = '''
class MySpecialWidget {
  int x = 42;
}
void main() {}
''';
      final bundler = AstBundler(
        bridgedLibraries: kAstBridgedLibraries,
        packageName: 'scratch_app',
        converter: SafeAstConverter(),
      );
      final astBundle = await bundler.createFromSource(
        src,
        sourcePath: 'main.dart',
      );

      // Bytecode mode check
      final bcBundle = BytecodeEmitter().compileBundle(astBundle);
      final vm = BytecodeVM();
      vm.loadBundle(bcBundle);
      final bcClass = findUserClassInVisitor(vm, 'MySpecialWidget');
      expect(bcClass, isNotNull);
      expect(bcClass.name, equals('MySpecialWidget'));

      // AST mode check
      final runner = D4rtRunner();
      runner.executeBundle(astBundle);
      final visitor = runner.visitor!;
      final astClass = findUserClassInVisitor(visitor, 'MySpecialWidget');
      expect(astClass, isNotNull);
    });

    test('tapping color GestureDetector in State widget invokes onTap and setState without crashing', () async {
      const src = '''
import 'package:dartnative/dartnative.dart';

class NoteColors {
  static const yellow = Color(0xFFFFF3A3);
  static const blue = Color(0xFFBFE3FF);
  static const all = [yellow, blue];
}

class MyWidget extends StatefulWidget {
  @override
  State createState() => _MyWidgetState();
}

class _MyWidgetState extends State {
  Color selectedColor = NoteColors.blue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...NoteColors.all.map((color) {
          return GestureDetector(
            onTap: () {
              selectedColor = color;
              setState(() {});
            },
            child: Container(
              child: selectedColor == color ? const Text('selected') : const SizedBox.shrink(),
            ),
          );
        }),
      ],
    );
  }
}

void main() {
  runApp(MyWidget());
}
''';
      final vm = await compileAndRun(src);
      final app = vm.bridgeAdapter.capturedApp;
      expect(app, isNotNull);
      expect(app, isA<BytecodeStatefulWidget>());
      final sw = app as BytecodeStatefulWidget;
      final state = sw.createState() as BytecodeStateProxy;
      // Build first time
      final col = state.build(FakeBuildContext()) as Column;
      expect(col.children.length, equals(2));
      final gd0 = col.children[0] as GestureDetector;
      final gd1 = col.children[1] as GestureDetector;
      expect(gd0.onTap, isNotNull);
      expect(gd1.onTap, isNotNull);

      // Tap yellow color (gd0)
      gd0.onTap!();
      expect(state.stateInstance.fields['selectedColor'], isNotNull);
      expect((state.stateInstance.fields['selectedColor'] as Color).value, equals(0xFFFFF3A3));

      // Rebuild
      final col2 = state.build(FakeBuildContext()) as Column;
      expect(col2, isNotNull);
    });

    test('scratch repro hot reload rebinds BytecodeConsumerStateProxy without function ID not found error', () async {
      const src1 = '''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

class MyConsumerScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyConsumerScreen> createState() => _MyConsumerScreenState();
}

class _MyConsumerScreenState extends ConsumerState<MyConsumerScreen> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Text('Count: \$count');
  }
}

void main() {
  runApp(MyConsumerScreen());
}
''';

      const src2 = '''
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

class MyConsumerScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyConsumerScreen> createState() => _MyConsumerScreenState();
}

class _MyConsumerScreenState extends ConsumerState<MyConsumerScreen> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Text('Count v2: \$count');
  }
}

void main() {
  runApp(MyConsumerScreen());
}
''';

      // 1. Initial compile
      final vm1 = await compileAndRun(src1);
      final widget1 = vm1.bridgeAdapter.capturedApp as BytecodeConsumerStatefulWidget;
      final proxy = widget1.createState() as BytecodeConsumerStateProxy;

      // Initial build
      final text1 = proxy.build(FakeBuildContext()) as Text;
      expect(text1.data, equals('Count: 0'));

      // 2. Emulate reload / restart where a new VM is created and bundle reloaded
      final vm2 = await compileAndRun(src2);
      final widget2 = vm2.bridgeAdapter.capturedApp as BytecodeConsumerStatefulWidget;

      // 3. Emulate Flutter/DartNative didUpdateWidget
      proxy.didUpdateWidget(widget2);

      // Also emulate rebindForHotReload
      final newClass = vm2.classes['_MyConsumerScreenState'];
      expect(newClass, isNotNull);
      proxy.rebindForHotReload(vm2, newClass);

      // 4. Rebuild proxy using new VM - MUST NOT throw Function ID not found
      final text2 = proxy.build(FakeBuildContext()) as Text;
      expect(text2.data, equals('Count v2: 0'));
    });

    test('scratch repro NativeBottomSheetManager.notifyHotReload rebinds BytecodeStateProxy in sheet', () async {
      const src1 = '''
import 'package:dartnative/dartnative.dart';

class SheetPanel extends StatefulWidget {
  @override
  State<SheetPanel> createState() => _SheetPanelState();
}

class _SheetPanelState extends State<SheetPanel> {
  String label = 'initial';

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}

void main() {
  runApp(SheetPanel());
}
''';

      const src2 = '''
import 'package:dartnative/dartnative.dart';

class SheetPanel extends StatefulWidget {
  @override
  State<SheetPanel> createState() => _SheetPanelState();
}

class _SheetPanelState extends State<SheetPanel> {
  String label = 'initial';

  @override
  Widget build(BuildContext context) {
    return Text('reloaded');
  }
}

void main() {
  runApp(SheetPanel());
}
''';

      final vm1 = await compileAndRun(src1);
      final widget1 = vm1.bridgeAdapter.capturedApp as BytecodeStatefulWidget;
      final proxy = widget1.createState() as BytecodeStateProxy;

      // Simulate proxy registering inside bottom sheet
      final sheetState = NativeBottomSheetScopeState();
      sheetState.registerProxy(proxy);
      expect(sheetState.proxies.contains(proxy), isTrue);

      // Recompile
      final vm2 = await compileAndRun(src2);

      // Rebind via sheetState.rebindAndRebuild
      sheetState.rebindAndRebuild(vm2);

      // Verify proxy's VM was updated to vm2 and build succeeds
      expect(proxy.vm, equals(vm2));
      final text = proxy.build(FakeBuildContext()) as Text;
      expect(text.data, equals('reloaded'));
    });
  });
}

class FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}


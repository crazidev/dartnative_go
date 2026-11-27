import 'package:dartnative/dartnative.dart';
import 'package:dartnative/src/bindings/uikit_bindings.dart';
import 'package:dartnative/src/reconciler/reconciler.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/interpreter/ast/ast_widget_proxies.dart';
import 'package:dartnative_go/src/interpreter/widget_generation_tracker.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';

class _NoopBindings implements NativeBindings {
  @override
  double getSafeAreaInset(int edge) => 0.0;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  tearDown(WidgetGenerationTracker.resetAll);

  test(
    'const interpreted widgets, bridged widgets, and const lists are canonical and skip reconciler rebuilds',
    () async {
      final runner = AstInterpreterRunner();
      runner.initRunner();

      final bundle = await AstBundler(
        bridgedLibraries: kAstBridgedLibraries,
      ).createFromSource('''
import 'package:dartnative/dartnative.dart';

int constChildBuilds = 0;
int dynamicChildBuilds = 0;
late void Function() triggerBump;

class _ConstHeader extends StatelessWidget {
  const _ConstHeader(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    constChildBuilds++;
    return const SizedBox(height: 12);
  }
}

class _DynamicCounter extends StatelessWidget {
  const _DynamicCounter(this.count);
  final int count;
  @override
  Widget build(BuildContext context) {
    dynamicChildBuilds++;
    return Text('count=\$count');
  }
}

class _Host extends StatefulWidget {
  const _Host();
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    triggerBump = () => setState(() => _tick++);
  }

  @override
  Widget build(BuildContext context) {
    const localSpacer = SizedBox(height: 8);
    return Column(
      children: [
        const _ConstHeader('Static Title'),
        localSpacer,
        _DynamicCounter(_tick),
      ],
    );
  }
}

Widget makeConstInterpreted() => const _ConstHeader('same');
Widget makeConstBridged() => const SizedBox(height: 12);
List<Widget> makeConstList() => const [SizedBox(height: 12), _ConstHeader('a')];
Widget makeLocalConst() {
  const w = SizedBox(height: 6);
  return w;
}

String checkIdentity() {
  final a1 = makeConstInterpreted();
  final a2 = makeConstInterpreted();
  final b1 = makeConstBridged();
  final b2 = makeConstBridged();
  final l1 = makeConstList();
  final l2 = makeConstList();
  final c1 = makeLocalConst();
  final c2 = makeLocalConst();
  return 'interp=\${identical(a1, a2)} '
      'bridged=\${identical(b1, b2)} '
      'list=\${identical(l1, l2)} '
      'local=\${identical(c1, c2)}';
}

Widget buildRoot() => const _Host();
void bump() => triggerBump();
String counts() => 'const=\$constChildBuilds dyn=\$dynamicChildBuilds';
''', sourcePath: 'const_caching.dart');

      final idResult = await runner.runner!.executeBundle(
        bundle,
        name: 'checkIdentity',
      );
      expect(idResult, equals('interp=true bridged=true list=true local=true'));

      final rawRoot = await runner.runner!.executeBundle(
        bundle,
        name: 'buildRoot',
      );
      final root = wrapAstInterpretedWidget(
        rawRoot,
        visitor: runner.runner!.visitor,
      )!;
      final rec = DartNativeReconciler(_NoopBindings());
      rec.attachRoot(root);

      expect(
        await runner.runner!.executeBundle(bundle, name: 'counts'),
        equals('const=1 dyn=1'),
      );

      await runner.runner!.executeBundle(bundle, name: 'bump');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(
        await runner.runner!.executeBundle(bundle, name: 'counts'),
        equals('const=1 dyn=2'),
      );

      await runner.runner!.executeBundle(bundle, name: 'bump');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(
        await runner.runner!.executeBundle(bundle, name: 'counts'),
        equals('const=1 dyn=3'),
      );

      rec.detachRoot();
    },
  );

  test(
    'const widgets rebuild with updated code after hot reload',
    () async {
      final runner = AstInterpreterRunner();
      runner.initRunner();

      Future<List<int>> compile(String versionLabel) async {
        final bundle = await AstBundler(
          bridgedLibraries: kAstBridgedLibraries,
        ).createFromSource('''
import 'package:dartnative/dartnative.dart';

String lastRendered = '';
int constChildBuilds = 0;
late void Function() triggerBump;

class _ConstBanner extends StatelessWidget {
  const _ConstBanner();
  @override
  Widget build(BuildContext context) {
    constChildBuilds++;
    lastRendered = '$versionLabel';
    return Text('$versionLabel');
  }
}

class _Host extends StatefulWidget {
  const _Host();
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    triggerBump = () => setState(() => _tick++);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ConstBanner(),
        Text('tick=\$_tick'),
      ],
    );
  }
}

void main() => runApp(const _Host());
void bump() => triggerBump();
String snapshot() => '\$lastRendered|builds=\$constChildBuilds';
''', sourcePath: 'const_reload.dart');
        return bundle.toZip();
      }

      final bytesV1 = await compile('v1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(bytesV1);
      final rec = DartNativeReconciler(_NoopBindings());
      rec.attachRoot(rootV1);

      expect(
        runner.runner!.visitor!.environment.get('lastRendered'),
        equals('v1'),
      );
      expect(
        runner.runner!.visitor!.environment.get('constChildBuilds'),
        equals(1),
      );

      // Normal setState within v1: const widget must NOT rebuild.
      final bumpV1 = runner.runner!.visitor!.environment.get('bump') as dynamic;
      bumpV1.call(runner.runner!.visitor!, const <Object?>[], const <String, Object?>{});
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(
        runner.runner!.visitor!.environment.get('constChildBuilds'),
        equals(1),
      );

      // Hot reload to v2: const cache is scoped to the new visitor, so the
      // edited const widget MUST rebuild and render 'v2'.
      WidgetGenerationTracker.registerClassFiles(runner.classFileMap);
      WidgetGenerationTracker.notifyFilesChanged(const {'const_reload.dart'});
      final bytesV2 = await compile('v2');
      await runner.evaluateAstBundleAs<Widget>(bytesV2, isHotReload: true);
      WidgetGenerationTracker.notifyMountedWidgets(runner.visitor);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(
        runner.runner!.visitor!.environment.get('lastRendered'),
        equals('v2'),
      );
      expect(
        runner.runner!.visitor!.environment.get('constChildBuilds'),
        equals(2),
      );

      // Subsequent setState within v2: const widget is cached again and skips rebuild.
      final bumpV2 = runner.runner!.visitor!.environment.get('bump') as dynamic;
      bumpV2.call(runner.runner!.visitor!, const <Object?>[], const <String, Object?>{});
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(
        runner.runner!.visitor!.environment.get('constChildBuilds'),
        equals(2),
      );

      rec.detachRoot();
    },
  );

  test(
    'Listenable.removeListener actually detaches guest callbacks on ValueNotifier and ChangeNotifier',
    () async {
      final runner = AstInterpreterRunner();
      runner.initRunner();

      final bundle = await AstBundler(
        bridgedLibraries: kAstBridgedLibraries,
      ).createFromSource('''
import 'package:dartnative/dartnative.dart';

class _SubNotifier extends ChangeNotifier {
  void fire() => notifyListeners();
}

String main() {
  var vnCalls = 0;
  final vn = ValueNotifier<int>(0);
  void onVn() => vnCalls++;
  vn.addListener(onVn);
  vn.value = 1;
  vn.removeListener(onVn);
  vn.value = 2;
  vn.value = 3;

  var cnCalls = 0;
  final cn = _SubNotifier();
  void onCn() => cnCalls++;
  cn.addListener(onCn);
  cn.fire();
  cn.removeListener(onCn);
  cn.fire();
  cn.fire();

  return 'vn=\$vnCalls cn=\$cnCalls';
}
''', sourcePath: 'listener_remove.dart');

      final res = await runner.runner!.executeBundle(bundle, name: 'main');
      expect(res, equals('vn=1 cn=1'));
    },
  );
}

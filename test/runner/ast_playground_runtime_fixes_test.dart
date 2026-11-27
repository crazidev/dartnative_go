import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';

void main() {
  late AstInterpreterRunner runner;

  setUpAll(() {
    runner = AstInterpreterRunner();
    runner.initRunner();
  });

  Future<Object?> runSnippet(String source) async {
    final bundle = await AstBundler(
      bridgedLibraries: kAstBridgedLibraries,
    ).createFromSource(source, sourcePath: 'snippet.dart');
    return runner.runner!.executeBundle(bundle, name: 'main');
  }

  test('ui.Gradient.linear resolves inside CustomPainter.paint', () async {
    final result = await runSnippet('''
import 'package:dartnative/dartnative.dart';
import 'package:dartnative/canvas.dart' as ui;

class _TestPainter extends CustomPainter {
  const _TestPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final shader = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(size.width, size.height),
      const [Color(0xFF000000), Color(0xFFFFFFFF)],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant _TestPainter oldDelegate) => false;
}

bool main() {
  final cp = CustomPaint(painter: const _TestPainter());
  final rec = BinaryCanvasRecorder();
  cp.painter!.paint(rec, const Size(88, 88));
  return true;
}
''');
    expect(result, isTrue);
  });

  test(
    'GlobalKey<SliderMenuContainerState> constructs reified key for SliderMenuContainer',
    () async {
      final result = await runSnippet('''
import 'package:dartnative/dartnative.dart';

Object main() {
  final key = GlobalKey<SliderMenuContainerState>();
  final widget = SliderMenuContainer(
    sliderKey: key,
    sliderMain: const SizedBox(),
    sliderMenu: const SizedBox(),
  );
  return widget.runtimeType.toString();
}
''');
      expect(result, isA<String>());
    },
  );

  test('Iterable.indexed native Record matches Dart record pattern', () async {
    final result = await runSnippet('''
String main() {
  final items = [('a', 1), ('b', 2)];
  final out = <String>[];
  for (final (i, item) in items.indexed) {
    final (label, n) = item;
    out.add('\$i:\$label:\$n');
  }
  return out.join(',');
}
''');
    expect(result, equals('0:a:1,1:b:2'));
  });

  test(
    'Listenable.watch works on interpreted ChangeNotifier subclass',
    () async {
      final result = await runSnippet('''
import 'package:dartnative/dartnative.dart';

class _ClickHistory extends ChangeNotifier {
  int count = 42;
}

int main() {
  final hist = _ClickHistory();
  final watched = hist.watch<_ClickHistory>(null as dynamic);
  return watched.count;
}
''');
      expect(result, equals(42));
    },
  );

  test('await on null and non-Future values succeeds', () async {
    final result = await runSnippet('''
Future<String> main() async {
  Future<void>? maybeNull;
  final a = await maybeNull;
  final b = await 7;
  return '\$a:\$b';
}
''');
    expect(result, equals('null:7'));
  });

  test(
    'prefix and postfix ++/-- work on bridged Signal.value and class statics',
    () async {
      final result = await runSnippet('''
import 'package:dartnative/dartnative.dart';

class _Box {
  static int s = 10;
  final Signal<int> counter = signal<int>(0);
}

String main() {
  final sig = signal<int>(5);
  final a = sig.value++;
  final b = ++sig.value;
  final c = sig.value--;
  final d = --sig.value;
  final box = _Box();
  final e = box.counter.value++;
  final f = ++box.counter.value;
  final g = _Box.s++;
  final h = ++_Box.s;
  return '\$a,\$b,\$c,\$d,\${sig.value}|\$e,\$f,\${box.counter.value}|\$g,\$h,\${_Box.s}';
}
''');
      expect(result, equals('5,7,7,5,5|0,2,2|10,12,12'));
    },
  );

  test(
    'native Dart Function values support ?.call() and Function.apply',
    () async {
      final result = await runSnippet('''
import 'package:dartnative/dartnative.dart';

int main() {
  final counter = signal<int>(0);
  var hits = 0;
  VoidCallback? stop;
  stop?.call();
  stop = effect(() {
    counter.value;
    hits++;
  });
  counter.value++;
  stop?.call();
  counter.value++;
  final stop2 = effect(() {
    counter.value;
    hits++;
  });
  Function.apply(stop2, const []);
  counter.value++;
  return hits;
}
''');
      // 1st effect: initial run (1) + 1st increment (2) -> stopped before 2nd.
      // 2nd effect: initial run (3) -> stopped via Function.apply before 3rd.
      expect(result, equals(3));
    },
  );
}

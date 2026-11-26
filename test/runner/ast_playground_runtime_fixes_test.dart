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

  test('GlobalKey<SliderMenuContainerState> constructs reified key for SliderMenuContainer', () async {
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
  });

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

  test('Listenable.watch works on interpreted ChangeNotifier subclass', () async {
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
  });

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
}

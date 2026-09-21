/// Widget-tree probe: find text/buttons, tap, dump — no engine needed.
///
/// Interpreted guest apps resolve to real native `Widget` objects on the
/// host VM (see `test/riverpod_comprehensive_test.dart`). This helper walks
/// the tree synchronously: `Scaffold.body → Center → Column.children`, etc.
library;

import 'package:dartnative/dartnative.dart';

/// Flattens [root] into a depth-first list of widgets.
List<Widget> flattenTree(Widget root) {
  final out = <Widget>[];
  void visit(Widget w) {
    out.add(w);
    for (final child in directChildren(w)) {
      visit(child);
    }
  }

  visit(root);
  return out;
}

/// Direct children for the common layout widgets used by guest apps.
List<Widget> directChildren(Widget w) {
  if (w is Scaffold) {
    final body = w.body;
    return body == null ? const [] : [body];
  }
  if (w is Center) return [w.child];
  if (w is Column) return List<Widget>.of(w.children);
  if (w is Row) return List<Widget>.of(w.children);
  if (w is Container) {
    final child = w.child;
    return child == null ? const [] : [child];
  }
  if (w is Padding) return [w.child];
  if (w is SingleChildScrollView) return [w.child];
  // ProviderScope wraps the guest root (riverpod apps).
  final typeName = w.runtimeType.toString();
  if (typeName.contains('ProviderScope')) {
    try {
      final child = (w as dynamic).child as Widget?;
      if (child != null) return [child];
    } catch (_) {}
  }
  return const [];
}

/// All [Text] nodes under [root].
List<Text> findTexts(Widget root) =>
    flattenTree(root).whereType<Text>().toList();

/// All [Button] nodes under [root].
List<Button> findButtons(Widget root) =>
    flattenTree(root).whereType<Button>().toList();

/// First [Text] whose [Text.data] equals [data], or null.
Text? findText(Widget root, String data) {
  for (final t in findTexts(root)) {
    if (t.data == data) return t;
  }
  return null;
}

/// First [Button] whose [Button.title] equals [title], or null.
Button? findButton(Widget root, String title) {
  for (final b in findButtons(root)) {
    if (b.title == title) return b;
  }
  return null;
}

/// Taps the button titled [title] (invokes `onPressed`) and returns it.
/// Throws [StateError] when the button or its callback is missing.
Button tapButton(Widget root, String title) {
  final button = findButton(root, title);
  if (button == null) {
    throw StateError(
      'tapButton: no Button titled "$title" '
      '(have: ${findButtons(root).map((b) => b.title).toList()})',
    );
  }
  final cb = button.onPressed;
  if (cb == null) {
    throw StateError('tapButton: Button "$title" has null onPressed');
  }
  cb();
  return button;
}

/// Human-readable tree dump for logs and failure messages.
String dumpTree(Widget root, {int maxDepth = 8}) {
  final buffer = StringBuffer();
  void visit(Widget w, int depth) {
    if (depth > maxDepth) return;
    final indent = '  ' * depth;
    final extra = switch (w) {
      Text(data: final d) => ' data="$d"',
      Button(title: final t) => ' title="$t"',
      _ => '',
    };
    buffer.writeln('$indent${w.runtimeType}$extra');
    for (final child in directChildren(w)) {
      visit(child, depth + 1);
    }
  }

  visit(root, 0);
  return buffer.toString();
}

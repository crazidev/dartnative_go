/// UI probe: serializes the guest UI to JSON and taps buttons by title —
/// shared by the on-device automation handler (`lib/main.dart`) and host
/// tests (`test/test_lab/ui_automator.dart`).
///
/// Two levels, same JSON shape:
/// - **Level 1 — widget walk** (`serializeTree`): universal, runs on host and
///   device. Sees the pre-reconciliation tree.
/// - **Level 2 — DNTree walk** (`serializeElementTree`): the reconciler's
///   post-inflation `Element` tree. Nodes carry the native `viewId` and
///   `viewType` (label=1, button=16, … — see `ViewType`), i.e. what is
///   actually on screen, including lazily materialized list items a widget
///   walk can never see. The entry point is any mounted `Element`; the app
///   exposes its guest root via a `GlobalKey` (`_guestProbeKey` in
///   `lib/main.dart`) because the reconciler instance itself has no public
///   accessor. On the host (SDK stubs) element access throws and the probe
///   falls back to Level 1 — see [probeGuest].
///
/// Event model (from the SDK surface): Dart → native flows through
/// `UIKitReconciler.enqueueMutation(ViewMutation)`; native → Dart re-enters
/// through callback ids (`registerGestureCallback`, `registerTapUpCallback`,
/// `registerScrollCallback`, …). The callback registry has no public
/// accessor, so taps dispatch semantically — invoking the widget's
/// `onPressed` found via the DNTree — which exercises everything except the
/// native touch recognizer itself. True touch injection stays the domain of
/// XCUITest/Espresso; a future SDK seam (`DartNativeReconciler.active` or a
/// mutation-listener hook) would additionally allow asserting which
/// `ViewMutation`s a tap emits.
///
/// Wire protocol (relayed by `DartGoServer`, see `lib/src/cli/server.dart`):
/// - test script → all clients: `{'type': 'ui_probe_request', 'requestId': ...}`
/// - device → all clients: `{'type': 'ui_tree', 'requestId': ..., 'tree': {...}}`
/// - test script → all clients: `{'type': 'ui_tap', 'requestId': ..., 'title': ...}`
/// - device → all clients: `{'type': 'ui_tap_result', 'requestId': ...,
///   'ok': bool, 'error': String?}`
library;

import 'package:dartnative/dartnative.dart';
import 'package:dartnative/src/reconciler/element.dart';

/// Serializes a widget subtree into a JSON-safe map (Level 1).
///
/// Node shape: `{'type': 'Text', 'text': '...', 'key': '...', 'children': [...]}`.
/// `Button` nodes carry `'title'`; tappable nodes carry `'tappable': true`.
/// [elementIndex] optionally enriches nodes with reconciler data (see
/// [indexElementsByWidget]).
Map<String, dynamic> serializeTree(
  Widget root, [
  Map<Widget, Element>? elementIndex,
]) =>
    _serializeWidget(root, elementIndex);

Map<String, dynamic> _serializeWidget(
  Widget w,
  Map<Widget, Element>? elementIndex,
) {
  final node = <String, dynamic>{'type': w.runtimeType.toString()};
  try {
    final key = w.key;
    if (key != null) node['key'] = key.toString();
  } catch (_) {}
  if (w is Text) {
    node['text'] = w.data;
  } else if (w is Button) {
    node['title'] = w.title;
    node['tappable'] = w.onPressed != null;
  }
  final element = elementIndex?[w];
  if (element != null) _attachElementData(node, element);
  final children = directChildrenOf(w)
      .map((c) => _serializeWidget(c, elementIndex))
      .toList(growable: false);
  if (children.isNotEmpty) node['children'] = children;
  return node;
}

/// Serializes a reconciler `Element` subtree into a JSON-safe map (Level 2).
///
/// Same node shape as [serializeTree], plus `'viewId'` on every element that
/// has one and `'viewType'` on native elements. Element access is guarded:
/// nodes whose accessors throw (host SDK stubs) serialize as leaves.
Map<String, dynamic> serializeElementTree(Element root) =>
    _serializeElement(root);

Map<String, dynamic> _serializeElement(Element element) {
  Widget? widget;
  try {
    widget = element.widget;
  } catch (_) {}
  final node = <String, dynamic>{
    'type': widget?.runtimeType.toString() ?? element.runtimeType.toString(),
  };
  if (widget != null) {
    try {
      final key = widget.key;
      if (key != null) node['key'] = key.toString();
    } catch (_) {}
    if (widget is Text) {
      node['text'] = widget.data;
    } else if (widget is Button) {
      node['title'] = widget.title;
      node['tappable'] = widget.onPressed != null;
    }
  }
  _attachElementData(node, element);
  for (final child in _safeChildren(element)) {
    (node['children'] ??= <Map<String, dynamic>>[]).add(
      _serializeElement(child),
    );
  }
  return node;
}

/// Attaches `viewId` / `viewType` to [node]; never throws.
void _attachElementData(Map<String, dynamic> node, Element element) {
  try {
    final id = element.viewId;
    if (id != null) node['viewId'] = id;
  } catch (_) {}
  try {
    if (element is NativeElement) node['viewType'] = element.viewType;
  } catch (_) {}
}

/// Element children, tolerating host stubs and partially-mounted trees.
List<Element> _safeChildren(Element element) {
  try {
    return List<Element>.of(element.children);
  } catch (_) {
    return const [];
  }
}

/// Indexes an `Element` subtree by widget identity (Level 1 + 2 join key).
///
/// `element.widget` is the exact widget instance the element was inflated
/// from, so a widget-walk node can look up its reconciler element (and
/// hence its native `viewId`) with `index[widgetInstance]`.
Map<Widget, Element> indexElementsByWidget(Element root) {
  final index = Map<Widget, Element>.identity();
  void visit(Element element) {
    try {
      index[element.widget] = element;
    } catch (_) {}
    for (final child in _safeChildren(element)) {
      visit(child);
    }
  }

  visit(root);
  return index;
}

/// Best-available guest-tree snapshot.
///
/// Prefers the DNTree ([elementRoot]) so nodes carry native `viewId`s;
/// falls back to the widget walk ([widgetRoot]). Returns the tree plus
/// whether it came from reconciled elements.
({Map<String, dynamic> tree, bool fromElements}) probeGuest({
  Element? elementRoot,
  Widget? widgetRoot,
}) {
  if (elementRoot != null) {
    try {
      // Touch the tree once to detect host stubs before committing.
      elementRoot.widget;
      return (
        tree: serializeElementTree(elementRoot),
        fromElements: true,
      );
    } catch (_) {}
  }
  final widget = widgetRoot;
  if (widget == null) {
    return (
      tree: const {'type': 'Error', 'error': 'no app mounted'},
      fromElements: false,
    );
  }
  return (tree: serializeTree(widget), fromElements: false);
}

/// Resolves the guest-root `Element` from a `GlobalKey` mounted above it.
/// Returns null when unmounted or on the host (SDK stubs throw).
Element? probeRootElement(GlobalKey key) {
  try {
    final context = key.currentContext;
    if (context is Element) return context;
  } catch (_) {}
  return null;
}

/// Direct children for the layout widgets guest apps commonly use.
List<Widget> directChildrenOf(Widget w) {
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
  final typeName = w.runtimeType.toString();
  if (typeName.contains('ProviderScope')) {
    try {
      final child = (w as dynamic).child as Widget?;
      if (child != null) return [child];
    } catch (_) {}
  }
  return const [];
}

/// Finds all `Text` nodes with [data] in a serialized tree.
List<Map<String, dynamic>> findTextNodes(
  Map<String, dynamic> tree,
  String data,
) {
  final out = <Map<String, dynamic>>[];
  void visit(Map<String, dynamic> node) {
    if (node['type'] == 'Text' && node['text'] == data) out.add(node);
    final children = node['children'];
    if (children is List) {
      for (final child in children) {
        if (child is Map<String, dynamic>) visit(child);
      }
    }
  }

  visit(tree);
  return out;
}

/// Finds all `Button` nodes with [title] in a serialized tree.
List<Map<String, dynamic>> findButtonNodes(
  Map<String, dynamic> tree,
  String title,
) {
  final out = <Map<String, dynamic>>[];
  void visit(Map<String, dynamic> node) {
    if ((node['type'] == 'Button' ||
            node['type'].toString().contains('Button')) &&
        node['title'] == title) {
      out.add(node);
    }
    final children = node['children'];
    if (children is List) {
      for (final child in children) {
        if (child is Map<String, dynamic>) visit(child);
      }
    }
  }

  visit(tree);
  return out;
}

/// Taps the first `Button` titled [title] under the widget [root].
///
/// Returns `null` on success, or an error description. The device handler
/// sends this back as `ui_tap_result`. Prefer [tapButtonInElementTree] on
/// device so the tap resolves through the reconciled DNTree.
String? tapButtonByTitle(Widget root, String title) {
  final button = _findButton(root, title);
  if (button == null) {
    return 'no Button titled "$title" '
        '(have: ${_allButtons(root).map((b) => b.title).toList()})';
  }
  return _invokeButton(button, title);
}

/// Taps the first `Button` titled [title] under the element-tree [root].
///
/// Walks reconciled elements and dispatches through `element.widget`, so the
/// tapped node is guaranteed to be the mounted instance. Returns `null` on
/// success, or an error description.
String? tapButtonInElementTree(Element root, String title) {
  Button? found;
  String? foundTitle;
  void visit(Element element) {
    if (found != null) return;
    Widget? widget;
    try {
      widget = element.widget;
    } catch (_) {}
    if (widget is Button && widget.title == title) {
      found = widget;
      return;
    }
    if (widget is Button) foundTitle ??= widget.title;
    for (final child in _safeChildren(element)) {
      visit(child);
    }
  }

  visit(root);
  final button = found;
  if (button == null) {
    return 'no Button titled "$title" in the reconciled tree'
        '${foundTitle == null ? '' : ' (e.g. "$foundTitle")'}';
  }
  return _invokeButton(button, title);
}

String? _invokeButton(Button button, String title) {
  final cb = button.onPressed;
  if (cb == null) return 'Button "$title" has null onPressed';
  try {
    cb();
  } catch (e) {
    return 'Button "$title" onPressed threw: $e';
  }
  return null;
}

Button? _findButton(Widget root, String title) {
  for (final b in _allButtons(root)) {
    if (b.title == title) return b;
  }
  return null;
}

List<Button> _allButtons(Widget root) {
  final out = <Button>[];
  void visit(Widget w) {
    if (w is Button) out.add(w);
    for (final child in directChildrenOf(w)) {
      visit(child);
    }
  }

  visit(root);
  return out;
}

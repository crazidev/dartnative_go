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
// The reconciler (Element, NativeElement, view ids) is only reachable
// through package:dartnative/src/ — the public barrel does not export it,
// and the probe must walk the mounted DNTree on-device.
// ignore: implementation_imports
import 'package:dartnative/src/reconciler/element.dart';

export 'ui_tree_json.dart'
    show findButtonNodes, findIconNodes, findKeyNodes, findTextNodes;

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
  _attachKey(node, w.key);
  if (w is Text) {
    node['text'] = w.data;
  } else if (w is Button) {
    node['title'] = w.title;
    node['tappable'] = w.onPressed != null;
  } else if (w is Icon) {
    _attachIcon(node, w);
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
    _attachKey(node, widget.key);
    if (widget is Text) {
      node['text'] = widget.data;
    } else if (widget is Button) {
      node['title'] = widget.title;
      node['tappable'] = widget.onPressed != null;
    } else if (widget is Icon) {
      _attachIcon(node, widget);
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

/// Attaches `key` / `key_value` to [node]; never throws.
///
/// `key_value` is the raw `ValueKey` payload (e.g. `guest_root`), which is
/// what `key:` step args and `findKeyNodes` match on. Non-value keys
/// (GlobalKey, UniqueKey) only carry the opaque `key` string.
void _attachKey(Map<String, dynamic> node, Key? key) {
  try {
    if (key == null) return;
    node['key'] = key.toString();
    try {
      node['key_value'] = '${(key as dynamic).value}';
    } catch (_) {}
  } catch (_) {}
}

/// Attaches `icon: {code_point, font_family?}` to [node]; never throws.
void _attachIcon(Map<String, dynamic> node, Icon icon) {
  try {
    node['icon'] = {
      'code_point': icon.icon.codePoint,
      if (icon.icon.fontFamily != null)
        'font_family': icon.icon.fontFamily,
    };
  } catch (_) {}
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

class TargetSpec {
  /// `Button.title`.
  final String? title;

  /// `Text.data`.
  final String? text;

  /// Raw `ValueKey` payload (`key_value`) or full serialized `key` string.
  /// Matches ANY widget type — the only selector that reaches inputs,
  /// icons, and layout widgets.
  final String? key;

  /// `Icon` code point and/or font family.
  final int? iconCodePoint;
  final String? iconFontFamily;

  const TargetSpec({
    this.title,
    this.text,
    this.key,
    this.iconCodePoint,
    this.iconFontFamily,
  });

  bool get isEmpty =>
      title == null &&
      text == null &&
      key == null &&
      iconCodePoint == null &&
      iconFontFamily == null;

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (text != null) 'text': text,
        if (key != null) 'key': key,
        if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
        if (iconFontFamily != null) 'icon_font_family': iconFontFamily,
      };

  static TargetSpec fromJson(Map<String, dynamic> json) => TargetSpec(
        title: json['title']?.toString(),
        text: json['text']?.toString(),
        key: json['key']?.toString(),
        iconCodePoint: json['icon_code_point'] is int
            ? json['icon_code_point'] as int
            : int.tryParse('${json['icon_code_point']}'),
        iconFontFamily: json['icon_font_family']?.toString(),
      );

  @override
  String toString() => toJson().toString();
}

/// A resolved target: the widget plus its element when resolved through the
/// reconciled DNTree (carries the native `viewId`).
class ResolvedTarget {
  final Widget widget;
  final Element? element;

  ResolvedTarget(this.widget, [this.element]);

  int? get viewId {
    try {
      return element?.viewId;
    } catch (_) {
      return null;
    }
  }
}

bool _matchesWidget(Widget w, TargetSpec spec) {
  if (spec.key != null) {
    String? full;
    String? raw;
    try {
      final k = w.key;
      full = k?.toString();
      try {
        raw = k == null ? null : '${(k as dynamic).value}';
      } catch (_) {}
    } catch (_) {}
    if (raw != spec.key && full != spec.key) return false;
  }
  if (spec.title != null) {
    if (w is! Button || w.title != spec.title) return false;
  }
  if (spec.text != null) {
    if (w is! Text || w.data != spec.text) return false;
  }
  if (spec.iconCodePoint != null || spec.iconFontFamily != null) {
    if (w is! Icon) return false;
    int? cp;
    String? ff;
    try {
      cp = w.icon.codePoint;
      ff = w.icon.fontFamily;
    } catch (_) {
      return false;
    }
    if (spec.iconCodePoint != null && cp != spec.iconCodePoint) return false;
    if (spec.iconFontFamily != null && ff != spec.iconFontFamily) {
      return false;
    }
  }
  return true;
}

/// Resolves [spec] against the element tree when available (preferred —
/// guarantees the mounted instance), else the widget tree.
///
/// Returns the target or an error description (never throws).
({ResolvedTarget? target, String? error}) resolveTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  required TargetSpec spec,
}) {
  if (spec.isEmpty) {
    return (target: null, error: 'empty target: set title/text/key/icon');
  }
  if (elementRoot != null) {
    ResolvedTarget? found;
    void visit(Element element) {
      if (found != null) return;
      Widget? widget;
      try {
        widget = element.widget;
      } catch (_) {}
      if (widget != null && _matchesWidget(widget, spec)) {
        found = ResolvedTarget(widget, element);
        return;
      }
      for (final child in _safeChildren(element)) {
        visit(child);
      }
    }

    try {
      visit(elementRoot);
    } catch (_) {}
    if (found != null) return (target: found, error: null);
  }
  final root = widgetRoot;
  if (root != null) {
    ResolvedTarget? found;
    void visit(Widget w) {
      if (found != null) return;
      if (_matchesWidget(w, spec)) {
        found = ResolvedTarget(w);
        return;
      }
      for (final child in directChildrenOf(w)) {
        visit(child);
      }
    }

    visit(root);
    if (found != null) return (target: found, error: null);
  }
  return (target: null, error: 'no element matching $spec');
}

/// Outcome of a trigger action.
class TriggerOutcome {
  final bool ok;
  final String? error;
  final int? viewId;

  const TriggerOutcome._(this.ok, this.error, this.viewId);

  factory TriggerOutcome.ok([int? viewId]) =>
      TriggerOutcome._(true, null, viewId);

  factory TriggerOutcome.fail(String error) =>
      TriggerOutcome._(false, error, null);

  Map<String, dynamic> toJson(String requestId, String type) => {
        'type': type,
        'requestId': requestId,
        'ok': ok,
        if (error != null) 'error': error,
        if (viewId != null) 'viewId': viewId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
}

/// Hover: resolve the target and report its native `viewId`.
///
/// The SDK exposes no hover callbacks on Button/TextField (mobile-first
/// framework), so hover is pointer placement + reachability proof: it fails
/// when the target is absent and reports where a native gesture injector
/// (XCUITest/Espresso) would aim.
TriggerOutcome hoverTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  required TargetSpec spec,
}) {
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: spec,
  );
  if (resolved.target == null) {
    return TriggerOutcome.fail(resolved.error ?? 'target not found');
  }
  return TriggerOutcome.ok(resolved.target!.viewId);
}

/// Focus: `TextField.focusNode.requestFocus()` (real keyboard path via the
/// reconciler). Fails cleanly without a `FocusNode` or on widgets without
/// focus support (e.g. Button).
TriggerOutcome focusTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  required TargetSpec spec,
}) {
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: spec,
  );
  final target = resolved.target;
  if (target == null) {
    return TriggerOutcome.fail(resolved.error ?? 'target not found');
  }
  final widget = target.widget;
  if (widget is! TextField) {
    return TriggerOutcome.fail(
      'focus needs a TextField with a FocusNode, got ${widget.runtimeType}',
    );
  }
  final node = widget.focusNode;
  if (node == null) {
    return TriggerOutcome.fail('TextField has no focusNode');
  }
  try {
    node.requestFocus();
  } catch (e) {
    return TriggerOutcome.fail('requestFocus threw: $e');
  }
  return TriggerOutcome.ok(target.viewId);
}

/// Blur: `TextField.focusNode.unfocus()`.
TriggerOutcome blurTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  required TargetSpec spec,
}) {
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: spec,
  );
  final target = resolved.target;
  if (target == null) {
    return TriggerOutcome.fail(resolved.error ?? 'target not found');
  }
  final widget = target.widget;
  if (widget is! TextField) {
    return TriggerOutcome.fail(
      'blur needs a TextField with a FocusNode, got ${widget.runtimeType}',
    );
  }
  final node = widget.focusNode;
  if (node == null) {
    return TriggerOutcome.fail('TextField has no focusNode');
  }
  try {
    node.unfocus();
  } catch (e) {
    return TriggerOutcome.fail('unfocus threw: $e');
  }
  return TriggerOutcome.ok(target.viewId);
}

/// Type into a `TextField`: set `controller.text`, then fire `onChanged`.
///
/// Needs a `TextEditingController`; fails cleanly without one (host SDK
/// stubs also throw here — same graceful path).
TriggerOutcome typeIntoTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  required TargetSpec spec,
  required String text,
}) {
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: spec,
  );
  final target = resolved.target;
  if (target == null) {
    return TriggerOutcome.fail(resolved.error ?? 'target not found');
  }
  final widget = target.widget;
  if (widget is! TextField) {
    return TriggerOutcome.fail(
      'type needs a TextField, got ${widget.runtimeType}',
    );
  }
  final controller = widget.controller;
  if (controller == null) {
    return TriggerOutcome.fail('TextField has no controller');
  }
  try {
    controller.text = text;
  } catch (e) {
    return TriggerOutcome.fail('setting controller text threw: $e');
  }
  try {
    widget.onChanged?.call(text);
  } catch (e) {
    return TriggerOutcome.fail('onChanged threw: $e');
  }
  return TriggerOutcome.ok(target.viewId);
}

/// Submit: `TextField.onSubmitted` with [text], the controller text, or `''`.
///
/// Buttons have no submit surface — use `tap` for those (this fails with a
/// message saying so instead of silently pressing).
TriggerOutcome submitTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  required TargetSpec spec,
  String? text,
}) {
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: spec,
  );
  final target = resolved.target;
  if (target == null) {
    return TriggerOutcome.fail(resolved.error ?? 'target not found');
  }
  final widget = target.widget;
  if (widget is Button) {
    return TriggerOutcome.fail(
      'Button "${widget.title}" has no submit action — use tap',
    );
  }
  if (widget is! TextField) {
    return TriggerOutcome.fail(
      'submit needs a TextField, got ${widget.runtimeType}',
    );
  }
  final submit = widget.onSubmitted;
  if (submit == null) {
    return TriggerOutcome.fail('TextField has no onSubmitted');
  }
  String value = text ?? '';
  if (text == null) {
    try {
      value = widget.controller?.text ?? '';
    } catch (_) {}
  }
  try {
    submit(value);
  } catch (e) {
    return TriggerOutcome.fail('onSubmitted threw: $e');
  }
  return TriggerOutcome.ok(target.viewId);
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

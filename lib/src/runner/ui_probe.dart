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
/// Wire protocol (relayed by `DartGoServer`, see
/// `lib/src/cli/server/server.dart`):
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

export 'icon_registry.dart' show resolveIcon, ResolvedIcon;
export 'ui_tree_json.dart'
    show findButtonNodes, findIconNodes, findKeyNodes, findTextNodes;

import 'icon_registry.dart';
import 'native_bottomsheet_manager.dart';

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
  } else if (w is IconButton) {
    node['tappable'] = w.onPressed != null;
    if (w.icon is Icon) {
      _attachIcon(node, w.icon as Icon);
    }
  } else if (w is Icon) {
    _attachIcon(node, w);
  } else if (w is TextField) {
    try {
      if (w.controller != null) node['text'] = w.controller!.text;
      final hint = w.decoration?.hintText;
      if (hint != null) {
        node['hint'] = hint;
        node['placeholder'] = hint;
      }
    } catch (_) {}
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
    } else if (widget is IconButton) {
      node['tappable'] = widget.onPressed != null;
      if (widget.icon is Icon) {
        _attachIcon(node, widget.icon as Icon);
      }
    } else if (widget is Icon) {
      _attachIcon(node, widget);
    } else if (widget is TextField) {
      try {
        if (widget.controller != null) node['text'] = widget.controller!.text;
        final hint = widget.decoration?.hintText;
        if (hint != null) {
          node['hint'] = hint;
          node['placeholder'] = hint;
        }
      } catch (_) {}
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
  if (key == null) return;
  try {
    if (key is ValueKey) {
      node['key_value'] = '${key.value}';
      node['key'] = "[<'${key.value}'>]";
    } else {
      try {
        node['key_value'] = '${(key as dynamic).value}';
      } catch (_) {}
      try {
        node['key'] = key.toString();
      } catch (_) {}
    }
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
/// falls back to the widget walk ([widgetRoot]). Also discovers and attaches
/// any active native bottom sheets ([NativeBottomSheetManager.activeSheets])
/// so modal sheet content is visible to probes and automations.
/// Returns the tree plus whether it came from reconciled elements.
({Map<String, dynamic> tree, bool fromElements}) probeGuest({
  Element? elementRoot,
  Widget? widgetRoot,
  List<NativeBottomSheetScopeState>? activeSheets,
}) {
  Map<String, dynamic> mainTree;
  bool fromElements = false;
  if (elementRoot != null) {
    try {
      // Touch the tree once to detect host stubs before committing.
      elementRoot.widget;
      mainTree = serializeElementTree(elementRoot);
      fromElements = true;
    } catch (_) {
      final widget = widgetRoot;
      if (widget == null) {
        return (
          tree: const {'type': 'Error', 'error': 'no app mounted'},
          fromElements: false,
        );
      }
      mainTree = serializeTree(widget);
    }
  } else {
    final widget = widgetRoot;
    if (widget == null) {
      return (
        tree: const {'type': 'Error', 'error': 'no app mounted'},
        fromElements: false,
      );
    }
    mainTree = serializeTree(widget);
  }

  final sheets = activeSheets ?? NativeBottomSheetManager.activeSheets;
  final validSheets = sheets.where((s) => s.isScopeActive).toList();
  if (validSheets.isEmpty) {
    return (tree: mainTree, fromElements: fromElements);
  }

  final sheetNodes = <Map<String, dynamic>>[];
  for (final s in validSheets) {
    final el = s.elementRoot;
    Map<String, dynamic>? sheetTree;
    if (el != null) {
      try {
        el.widget;
        sheetTree = serializeElementTree(el);
      } catch (_) {}
    }
    final scope = s.scopeWidget;
    sheetTree ??= serializeTree(scope.child);
    sheetNodes.add({
      'type': 'NativeBottomSheet',
      'sheetId': scope.controller.sheetId,
      'children': [sheetTree],
    });
  }

  if (mainTree['children'] is List) {
    final children = List<dynamic>.from(mainTree['children'] as List);
    children.addAll(sheetNodes);
    mainTree['children'] = children;
    return (tree: mainTree, fromElements: fromElements);
  } else {
    return (
      tree: {
        'type': 'AppRoot',
        'children': [mainTree, ...sheetNodes],
      },
      fromElements: fromElements,
    );
  }
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
    return [
      if (w.appBar != null) w.appBar!,
      if (w.body != null) w.body!,
    ];
  }
  if (w is AppBar) {
    return [
      if (w.leading != null) w.leading!,
      if (w.title != null) w.title!,
      if (w.actions != null) ...w.actions!,
    ];
  }
  if (w is Center) return [w.child];
  if (w is Column) return List<Widget>.of(w.children);
  if (w is Row) return List<Widget>.of(w.children);
  if (w is Stack) return List<Widget>.of(w.children);
  if (w is Container) {
    final child = w.child;
    return child == null ? const [] : [child];
  }
  if (w is Padding) return [w.child];
  if (w is SingleChildScrollView) return [w.child];
  if (w is ListView && w.children != null) {
    return List<Widget>.of(w.children!);
  }
  if (w is GestureDetector) {
    final child = w.child;
    return child == null ? const [] : [child];
  }
  if (w is IconButton) return [w.icon];
  if (w is NativeBottomSheetScope) return [w.child];
  if (w is Expanded) return [w.child];
  if (w is Positioned) return [w.child];
  if (w is SizedBox) {
    final child = w.child;
    return child == null ? const [] : [child];
  }
  final typeName = w.runtimeType.toString();
  if (typeName.contains('ProviderScope')) {
    try {
      final child = (w as dynamic).child as Widget?;
      if (child != null) return [child];
    } catch (_) {}
  }
  try {
    final dynamic dyn = w;
    final child = dyn.child as Widget?;
    if (child != null) return [child];
  } catch (_) {}
  try {
    final dynamic dyn = w;
    final children = dyn.children as List<Widget>?;
    if (children != null) return List<Widget>.of(children);
  } catch (_) {}
  return const [];
}

/// Taps the first `Button` titled [title] under the widget [root].
///
/// Returns `null` on success, or an error description. Preserved for backward
/// compatibility; prefer [tapTarget] on modern test suites.
String? tapButtonByTitle(Widget root, String title) {
  final outcome = tapTarget(
    widgetRoot: root,
    spec: TargetSpec(title: title),
  );
  if (outcome.ok) return null;
  return outcome.error;
}

/// Taps the first `Button` titled [title] under the element-tree [root].
///
/// Walks reconciled elements and dispatches through mounted instances.
/// Preserved for backward compatibility; prefer [tapTarget] on modern test suites.
String? tapButtonInElementTree(Element root, String title) {
  final outcome = tapTarget(
    elementRoot: root,
    spec: TargetSpec(title: title),
  );
  if (outcome.ok) return null;
  return outcome.error;
}

class TargetSpec {
  /// `Button.title` or `BarButtonItem.title`.
  final String? title;

  /// `Text.data`.
  final String? text;

  /// Raw `ValueKey` payload (`key_value`) or full serialized `key` string.
  /// Matches ANY widget type — the only selector that reaches inputs,
  /// icons, and layout widgets.
  final String? key;

  /// `TextField.decoration.hintText` or placeholder text.
  final String? placeholder;

  /// Matches any `TextField` (or the currently focused/autofocused one).
  final bool anyTextField;

  /// `Icon` code point and/or font family.
  final int? iconCodePoint;
  final String? iconFontFamily;

  const TargetSpec({
    this.title,
    this.text,
    this.key,
    this.placeholder,
    this.anyTextField = false,
    this.iconCodePoint,
    this.iconFontFamily,
  });

  bool get isEmpty =>
      title == null &&
      text == null &&
      key == null &&
      placeholder == null &&
      !anyTextField &&
      iconCodePoint == null &&
      iconFontFamily == null;

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (text != null) 'text': text,
        if (key != null) 'key': key,
        if (placeholder != null) 'placeholder': placeholder,
        if (anyTextField) 'any_text_field': true,
        if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
        if (iconFontFamily != null) 'icon_font_family': iconFontFamily,
      };

  static TargetSpec fromJson(Map<String, dynamic> json) {
    int? cp;
    String? ff;

    final resolved = resolveIcon(json);
    if (resolved != null) {
      cp = resolved.codePoint;
      ff = resolved.fontFamily;
    } else {
      if (json['icon_code_point'] != null) {
        cp = json['icon_code_point'] is int
            ? json['icon_code_point'] as int
            : int.tryParse('${json['icon_code_point']}');
      } else if (json['code_point'] != null) {
        cp = json['code_point'] is int
            ? json['code_point'] as int
            : int.tryParse('${json['code_point']}');
      } else if (json['icon'] != null) {
        if (json['icon'] is int) {
          cp = json['icon'] as int;
        } else if (json['icon'] is Map) {
          final iconMap = json['icon'] as Map;
          cp = iconMap['code_point'] is int
              ? iconMap['code_point'] as int
              : int.tryParse('${iconMap['code_point']}');
        } else {
          cp = int.tryParse('${json['icon']}');
        }
      }

      ff = json['icon_font_family']?.toString() ??
          json['font_family']?.toString();
      if (ff == null && json['icon'] is Map) {
        ff = (json['icon'] as Map)['font_family']?.toString();
      }
    }

    final placeholder = json['placeholder']?.toString() ??
        json['hint']?.toString() ??
        (json['into'] is String ? json['into'] as String : null);
    final anyTextField = json['any_text_field'] == true ||
        json['type'] == 'TextField';

    return TargetSpec(
      title: json['title']?.toString(),
      text: json['text']?.toString(),
      key: json['key']?.toString(),
      placeholder: placeholder,
      anyTextField: anyTextField,
      iconCodePoint: cp,
      iconFontFamily: ff,
    );
  }

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
  if (spec.anyTextField && w is! TextField) return false;
  if (spec.key != null) {
    String? full;
    String? raw;
    try {
      final k = w.key;
      if (k is ValueKey) {
        raw = '${k.value}';
        full = "[<'${k.value}'>]";
      } else if (k != null) {
        try {
          raw = '${(k as dynamic).value}';
        } catch (_) {}
        try {
          full = k.toString();
        } catch (_) {}
      }
    } catch (_) {}
    if (raw != spec.key && full != spec.key) return false;
  }
  if (spec.placeholder != null) {
    if (w is! TextField) return false;
    final hint = w.decoration?.hintText;
    if (hint == null ||
        (hint != spec.placeholder &&
            (spec.placeholder!.isEmpty || !hint.contains(spec.placeholder!)))) {
      return false;
    }
  }
  if (spec.title != null) {
    String? title;
    if (w is Button) {
      title = w.title;
    } else if (w is BarButtonItem) {
      title = w.title;
    } else if (w is TextField) {
      title = w.decoration?.hintText;
    } else {
      try {
        title = (w as dynamic).title?.toString();
      } catch (_) {}
    }
    if (title != spec.title &&
        (title == null ||
            spec.title!.isEmpty ||
            !title.contains(spec.title!))) {
      return false;
    }
  }
  if (spec.text != null) {
    if (w is Text) {
      final t = w.data;
      if (t != spec.text && (spec.text!.isEmpty || !t.contains(spec.text!))) {
        return false;
      }
    } else if (w is TextField) {
      final hint = w.decoration?.hintText;
      final current = w.controller?.text;
      final matchesHint = hint != null &&
          (hint == spec.text ||
              (spec.text!.isNotEmpty && hint.contains(spec.text!)));
      final matchesCurrent = current != null &&
          (current == spec.text ||
              (spec.text!.isNotEmpty && current.contains(spec.text!)));
      if (!matchesHint && !matchesCurrent) return false;
    } else {
      return false;
    }
  }
  if (spec.iconCodePoint != null || spec.iconFontFamily != null) {
    int? cp;
    String? ff;
    if (w is Icon) {
      try {
        cp = w.icon.codePoint;
        ff = w.icon.fontFamily;
      } catch (_) {}
    } else if (w is BarButtonItem) {
      try {
        cp = w.fontIcon?.codePoint;
        ff = w.fontIcon?.fontFamily;
      } catch (_) {}
    } else if (w is IconButton) {
      try {
        final iconWidget = w.icon;
        if (iconWidget is Icon) {
          cp = iconWidget.icon.codePoint;
          ff = iconWidget.icon.fontFamily;
        }
      } catch (_) {}
    }
    if (cp == null && ff == null) return false;
    if (spec.iconCodePoint != null && cp != spec.iconCodePoint) return false;
    if (spec.iconFontFamily != null && ff != spec.iconFontFamily) {
      return false;
    }
  }
  return true;
}

VoidCallback? _resolveTapCallback(Widget w) {
  if (w is Button) return w.onPressed;
  if (w is BarButtonItem) return w.onPressed;
  if (w is IconButton) return w.onPressed;
  if (w is GestureDetector) {
    if (w.onTap != null) return w.onTap;
    if (w.onTapUp != null) {
      return () => w.onTapUp!(const TapUpDetails());
    }
  }
  try {
    final dynamic dyn = w;
    final cb = dyn.onPressed;
    if (cb is VoidCallback) return cb;
  } catch (_) {}
  try {
    final dynamic dyn = w;
    final cb = dyn.onTap;
    if (cb is VoidCallback) return cb;
  } catch (_) {}
  return null;
}

/// Resolves [spec] against the element tree when available (preferred —
/// guarantees the mounted instance), else the widget tree.
///
/// Searches active bottom sheets first (newest sheet on top), then falls back
/// to the main app tree. Returns the target or an error description (never throws).
({ResolvedTarget? target, String? error}) resolveTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  required TargetSpec spec,
  List<NativeBottomSheetScopeState>? activeSheets,
}) {
  if (spec.isEmpty) {
    return (target: null, error: 'empty target: set title/text/key/icon');
  }

  // 1. Search active bottom sheets first (modal content overlays the main app)
  final sheets = activeSheets ?? NativeBottomSheetManager.activeSheets;
  final validSheets = sheets.where((s) => s.isScopeActive).toList();
  for (final sheet in validSheets.reversed) {
    final sheetElement = sheet.elementRoot;
    if (sheetElement != null) {
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
        visit(sheetElement);
      } catch (_) {}
      if (found != null) return (target: found, error: null);
    }

    ResolvedTarget? found;
    void visitWidget(Widget w) {
      if (found != null) return;
      if (_matchesWidget(w, spec)) {
        found = ResolvedTarget(w);
        return;
      }
      for (final child in directChildrenOf(w)) {
        visitWidget(child);
      }
    }

    visitWidget(sheet.scopeWidget.child);
    if (found != null) return (target: found, error: null);
  }

  // 2. Search main app elementRoot and widgetRoot
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

/// Taps the target matching [spec] (by title, text, key, icon code point/font).
///
/// Resolves through active bottom sheets first, then the element tree (Level 2)
/// or widget tree (Level 1).
///
/// Once the target node is located, searches the node itself and its ancestor
/// chain for a tap callback:
/// - `Button.onPressed`
/// - `GestureDetector.onTap` (or `onTapUp`)
/// - `BarButtonItem.onPressed`
/// - `IconButton.onPressed`
/// - Any widget with `onTap` or `onPressed`
///
/// Returns [TriggerOutcome.ok] on success, or [TriggerOutcome.fail] with details.
TriggerOutcome tapTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  required TargetSpec spec,
  List<NativeBottomSheetScopeState>? activeSheets,
}) {
  if (spec.isEmpty) {
    return TriggerOutcome.fail('empty target: set title/text/key/icon');
  }

  // 1. Search active bottom sheets first (modal content on top of screen)
  final sheets = activeSheets ?? NativeBottomSheetManager.activeSheets;
  final validSheets = sheets.where((s) => s.isScopeActive).toList();
  for (final sheet in validSheets.reversed) {
    final sheetElement = sheet.elementRoot;
    if (sheetElement != null) {
      ResolvedTarget? foundTarget;
      VoidCallback? foundCallback;
      String? callbackWidgetType;

      void visit(Element element, List<Element> ancestors) {
        if (foundTarget != null) return;
        Widget? widget;
        try {
          widget = element.widget;
        } catch (_) {}
        if (widget != null && _matchesWidget(widget, spec)) {
          foundTarget = ResolvedTarget(widget, element);
          var cb = _resolveTapCallback(widget);
          if (cb != null) {
            foundCallback = cb;
            callbackWidgetType = widget.runtimeType.toString();
            return;
          }
          for (final a in ancestors.reversed) {
            Widget? aw;
            try {
              aw = a.widget;
            } catch (_) {}
            if (aw != null) {
              cb = _resolveTapCallback(aw);
              if (cb != null) {
                foundCallback = cb;
                callbackWidgetType = aw.runtimeType.toString();
                return;
              }
            }
          }
          for (final child in _safeChildren(element)) {
            Widget? cw;
            try {
              cw = child.widget;
            } catch (_) {}
            if (cw != null) {
              cb = _resolveTapCallback(cw);
              if (cb != null) {
                foundCallback = cb;
                callbackWidgetType = cw.runtimeType.toString();
                return;
              }
            }
          }
          return;
        }
        final nextAncestors = [...ancestors, element];
        for (final child in _safeChildren(element)) {
          visit(child, nextAncestors);
        }
      }

      try {
        visit(sheetElement, const []);
      } catch (_) {}

      if (foundTarget != null) {
        if (foundCallback != null) {
          try {
            foundCallback!();
            return TriggerOutcome.ok(foundTarget!.viewId);
          } catch (e) {
            return TriggerOutcome.fail('$callbackWidgetType tap callback threw: $e');
          }
        }
        return TriggerOutcome.fail(
          'target matching $spec (${foundTarget!.widget.runtimeType}) has no tappable ancestor (checked Button, GestureDetector, BarButtonItem, IconButton)',
        );
      }
    }

    // Fallback to widget walk for sheet
    ResolvedTarget? foundTarget;
    VoidCallback? foundCallback;
    String? callbackWidgetType;

    void visit(Widget w, List<Widget> ancestors) {
      if (foundTarget != null) return;
      if (_matchesWidget(w, spec)) {
        foundTarget = ResolvedTarget(w);
        var cb = _resolveTapCallback(w);
        if (cb != null) {
          foundCallback = cb;
          callbackWidgetType = w.runtimeType.toString();
          return;
        }
        for (final a in ancestors.reversed) {
          cb = _resolveTapCallback(a);
          if (cb != null) {
            foundCallback = cb;
            callbackWidgetType = a.runtimeType.toString();
            return;
          }
        }
        for (final child in directChildrenOf(w)) {
          cb = _resolveTapCallback(child);
          if (cb != null) {
            foundCallback = cb;
            callbackWidgetType = child.runtimeType.toString();
            return;
          }
        }
        return;
      }
      final nextAncestors = [...ancestors, w];
      for (final child in directChildrenOf(w)) {
        visit(child, nextAncestors);
      }
    }

    visit(sheet.scopeWidget.child, const []);
    if (foundTarget != null) {
      if (foundCallback != null) {
        try {
          foundCallback!();
          return TriggerOutcome.ok(foundTarget!.viewId);
        } catch (e) {
          return TriggerOutcome.fail('$callbackWidgetType tap callback threw: $e');
        }
      }
      return TriggerOutcome.fail(
        'target matching $spec (${foundTarget!.widget.runtimeType}) has no tappable ancestor (checked Button, GestureDetector, BarButtonItem, IconButton)',
      );
    }
  }

  // 2. Search main app elementRoot and widgetRoot
  if (elementRoot != null) {
    ResolvedTarget? foundTarget;
    VoidCallback? foundCallback;
    String? callbackWidgetType;

    void visit(Element element, List<Element> ancestors) {
      if (foundTarget != null) return;
      Widget? widget;
      try {
        widget = element.widget;
      } catch (_) {}
      if (widget != null && _matchesWidget(widget, spec)) {
        foundTarget = ResolvedTarget(widget, element);
        var cb = _resolveTapCallback(widget);
        if (cb != null) {
          foundCallback = cb;
          callbackWidgetType = widget.runtimeType.toString();
          return;
        }
        for (final a in ancestors.reversed) {
          Widget? aw;
          try {
            aw = a.widget;
          } catch (_) {}
          if (aw != null) {
            cb = _resolveTapCallback(aw);
            if (cb != null) {
              foundCallback = cb;
              callbackWidgetType = aw.runtimeType.toString();
              return;
            }
          }
        }
        for (final child in _safeChildren(element)) {
          Widget? cw;
          try {
            cw = child.widget;
          } catch (_) {}
          if (cw != null) {
            cb = _resolveTapCallback(cw);
            if (cb != null) {
              foundCallback = cb;
              callbackWidgetType = cw.runtimeType.toString();
              return;
            }
          }
        }
        return;
      }
      final nextAncestors = [...ancestors, element];
      for (final child in _safeChildren(element)) {
        visit(child, nextAncestors);
      }
    }

    try {
      visit(elementRoot, const []);
    } catch (_) {}

    if (foundTarget != null) {
      if (foundCallback != null) {
        try {
          foundCallback!();
          return TriggerOutcome.ok(foundTarget!.viewId);
        } catch (e) {
          return TriggerOutcome.fail('$callbackWidgetType tap callback threw: $e');
        }
      }
      return TriggerOutcome.fail(
        'target matching $spec (${foundTarget!.widget.runtimeType}) has no tappable ancestor (checked Button, GestureDetector, BarButtonItem, IconButton)',
      );
    }
  }

  final root = widgetRoot;
  if (root != null) {
    ResolvedTarget? foundTarget;
    VoidCallback? foundCallback;
    String? callbackWidgetType;

    void visit(Widget w, List<Widget> ancestors) {
      if (foundTarget != null) return;
      if (_matchesWidget(w, spec)) {
        foundTarget = ResolvedTarget(w);
        var cb = _resolveTapCallback(w);
        if (cb != null) {
          foundCallback = cb;
          callbackWidgetType = w.runtimeType.toString();
          return;
        }
        for (final a in ancestors.reversed) {
          cb = _resolveTapCallback(a);
          if (cb != null) {
            foundCallback = cb;
            callbackWidgetType = a.runtimeType.toString();
            return;
          }
        }
        for (final child in directChildrenOf(w)) {
          cb = _resolveTapCallback(child);
          if (cb != null) {
            foundCallback = cb;
            callbackWidgetType = child.runtimeType.toString();
            return;
          }
        }
        return;
      }
      final nextAncestors = [...ancestors, w];
      for (final child in directChildrenOf(w)) {
        visit(child, nextAncestors);
      }
    }

    visit(root, const []);
    if (foundTarget != null) {
      if (foundCallback != null) {
        try {
          foundCallback!();
          return TriggerOutcome.ok(foundTarget!.viewId);
        } catch (e) {
          return TriggerOutcome.fail('$callbackWidgetType tap callback threw: $e');
        }
      }
      return TriggerOutcome.fail(
        'target matching $spec (${foundTarget!.widget.runtimeType}) has no tappable ancestor (checked Button, GestureDetector, BarButtonItem, IconButton)',
      );
    }
  }

  if (spec.title != null) {
    return TriggerOutcome.fail(
      'no Button titled "${spec.title}" in the reconciled tree',
    );
  }
  return TriggerOutcome.fail('no element matching $spec');
}

/// Scroll trigger: scroll a [SingleChildScrollView] / [ListView] or target.
TriggerOutcome scrollTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  TargetSpec? spec,
  double deltaX = 0,
  double deltaY = 100,
  List<NativeBottomSheetScopeState>? activeSheets,
}) {
  Widget? scrollWidget;
  Element? scrollElement;

  if (spec != null && !spec.isEmpty) {
    final res = resolveTarget(
      widgetRoot: widgetRoot,
      elementRoot: elementRoot,
      spec: spec,
      activeSheets: activeSheets,
    );
    if (res.target != null) {
      scrollWidget = res.target!.widget;
      scrollElement = res.target!.element;
    }
  }

  if (scrollWidget == null) {
    final sheets = activeSheets ?? NativeBottomSheetManager.activeSheets;
    for (final sheet in sheets.where((s) => s.isScopeActive).toList().reversed) {
      final sheetEl = sheet.elementRoot;
      if (sheetEl != null) {
        void findScrollElement(Element element) {
          if (scrollWidget != null) return;
          Widget? w;
          try {
            w = element.widget;
          } catch (_) {}
          if (w is SingleChildScrollView || w is ListView) {
            scrollWidget = w;
            scrollElement = element;
            return;
          }
          for (final child in _safeChildren(element)) {
            findScrollElement(child);
          }
        }
        try {
          findScrollElement(sheetEl);
        } catch (_) {}
      }
      if (scrollWidget != null) break;

      void findScrollWidget(Widget w) {
        if (scrollWidget != null) return;
        if (w is SingleChildScrollView || w is ListView) {
          scrollWidget = w;
          return;
        }
        for (final child in directChildrenOf(w)) {
          findScrollWidget(child);
        }
      }
      findScrollWidget(sheet.scopeWidget.child);
      if (scrollWidget != null) break;
    }
  }

  if (scrollWidget == null) {
    if (elementRoot != null) {
      void findScrollElement(Element element) {
        if (scrollWidget != null) return;
        Widget? w;
        try {
          w = element.widget;
        } catch (_) {}
        if (w is SingleChildScrollView || w is ListView) {
          scrollWidget = w;
          scrollElement = element;
          return;
        }
        for (final child in _safeChildren(element)) {
          findScrollElement(child);
        }
      }
      try {
        findScrollElement(elementRoot);
      } catch (_) {}
    } else if (widgetRoot != null) {
      void findScrollWidget(Widget w) {
        if (scrollWidget != null) return;
        if (w is SingleChildScrollView || w is ListView) {
          scrollWidget = w;
          return;
        }
        for (final child in directChildrenOf(w)) {
          findScrollWidget(child);
        }
      }
      findScrollWidget(widgetRoot);
    }
  }

  if (scrollWidget == null) {
    return TriggerOutcome.fail('no scrollable widget (SingleChildScrollView / ListView) found');
  }

  try {
    final dynamic w = scrollWidget;
    final dynamic controller = w.controller;
    if (controller != null) {
      try {
        final currentOffset = (controller.offset as num).toDouble();
        controller.jumpTo(currentOffset + deltaY);
      } catch (_) {
        try {
          controller.jumpTo(deltaY);
        } catch (_) {}
      }
    }
  } catch (_) {}

  int? viewId;
  try {
    viewId = scrollElement?.viewId;
  } catch (_) {}

  return TriggerOutcome.ok(viewId);
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
  List<NativeBottomSheetScopeState>? activeSheets,
}) {
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: spec,
    activeSheets: activeSheets,
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
  List<NativeBottomSheetScopeState>? activeSheets,
}) {
  final targetSpec = spec.isEmpty ? const TargetSpec(anyTextField: true) : spec;
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: targetSpec,
    activeSheets: activeSheets,
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
  List<NativeBottomSheetScopeState>? activeSheets,
}) {
  final targetSpec = spec.isEmpty ? const TargetSpec(anyTextField: true) : spec;
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: targetSpec,
    activeSheets: activeSheets,
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

/// Type into a `TextField`: updates `controller.text`, `controller.value`,
/// notifies `controller` listeners, invokes `onChanged`, and updates the
/// mounted native element (e.g. `TextFieldNativeElement`).
TriggerOutcome typeIntoTarget({
  Widget? widgetRoot,
  Element? elementRoot,
  required TargetSpec spec,
  required String text,
  List<NativeBottomSheetScopeState>? activeSheets,
}) {
  final targetSpec = spec.isEmpty ? const TargetSpec(anyTextField: true) : spec;
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: targetSpec,
    activeSheets: activeSheets,
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
  TextEditingController? controller = widget.controller;
  if (controller == null && target.element != null) {
    try {
      final dynamic el = target.element;
      final dynamic tf = el.widget ?? el._tf;
      if (tf is TextField && tf.controller != null) {
        controller = tf.controller;
      }
    } catch (_) {}
    if (controller == null) {
      try {
        final state = (target.element as dynamic).state;
        if (state != null) {
          controller =
              (state as dynamic).controller ?? (state as dynamic)._controller;
        }
      } catch (_) {}
    }
  }

  ValueChanged<String>? onChanged = widget.onChanged;
  if (onChanged == null && target.element != null) {
    try {
      final dynamic el = target.element;
      final dynamic tf = el.widget ?? el._tf;
      if (tf != null && tf.onChanged != null) {
        onChanged = tf.onChanged as ValueChanged<String>?;
      }
    } catch (_) {}
  }

  if (controller == null && onChanged == null) {
    return TriggerOutcome.fail('TextField has no controller or onChanged');
  }

  if (controller != null) {
    try {
      controller.text = text;
    } catch (_) {}
    try {
      controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } catch (_) {}
    try {
      (controller as dynamic).notifyListeners();
    } catch (_) {}
  }

  if (onChanged != null) {
    try {
      onChanged(text);
    } catch (e) {
      return TriggerOutcome.fail('onChanged threw: $e');
    }
  }

  final el = target.element;
  if (el != null) {
    try {
      (el as dynamic)._onControllerChanged();
    } catch (_) {}
    try {
      el.markDirty();
    } catch (_) {}
  }

  final sheets = activeSheets ?? NativeBottomSheetManager.activeSheets;
  for (final sheet in sheets) {
    if (sheet.isScopeActive) {
      try {
        sheet.triggerRebuild();
      } catch (_) {}
    }
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
  List<NativeBottomSheetScopeState>? activeSheets,
}) {
  final targetSpec = spec.isEmpty ? const TargetSpec(anyTextField: true) : spec;
  final resolved = resolveTarget(
    widgetRoot: widgetRoot,
    elementRoot: elementRoot,
    spec: targetSpec,
    activeSheets: activeSheets,
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
  void Function(String)? submit = widget.onSubmitted;
  if (submit == null && target.element != null) {
    try {
      final dynamic el = target.element;
      final dynamic tf = el.widget ?? el._tf;
      if (tf != null && tf.onSubmitted != null) {
        submit = tf.onSubmitted as void Function(String)?;
      }
    } catch (_) {}
  }
  if (submit == null) {
    return TriggerOutcome.fail('TextField has no onSubmitted');
  }
  String value = text ?? '';
  if (text == null) {
    try {
      value = widget.controller?.text ?? '';
    } catch (_) {}
    if (value.isEmpty && target.element != null) {
      try {
        final dynamic el = target.element;
        final dynamic tf = el.widget ?? el._tf;
        if (tf is TextField && tf.controller != null) {
          value = tf.controller!.text;
        }
      } catch (_) {}
    }
  }
  try {
    submit(value);
  } catch (e) {
    return TriggerOutcome.fail('onSubmitted threw: $e');
  }
  return TriggerOutcome.ok(target.viewId);
}

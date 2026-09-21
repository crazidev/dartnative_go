/// Pure-Dart JSON helpers for serialized widget trees.
///
/// No `dart:ui`, no Flutter — importable from `tool/` scripts run with plain
/// `dart run` as well as from tests. Node shape (see
/// `lib/src/runner/ui_probe.dart`): `{'type': 'Text', 'text': …}`,
/// `{'type': 'Button', 'title': …, 'tappable': …}`, optional `'viewId'` /
/// `'viewType'` on reconciled nodes, nested `'children'` lists.
library;

/// Finds all `Text` nodes with [data] in a serialized [tree].
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

/// Finds all `Button` nodes with [title] in a serialized [tree].
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

/// Finds all nodes carrying key [key] in a serialized [tree].
///
/// Matches the raw `key_value` (e.g. `guest_root` from `ValueKey`) or the
/// full serialized `key` string.
List<Map<String, dynamic>> findKeyNodes(
  Map<String, dynamic> tree,
  String key,
) {
  final out = <Map<String, dynamic>>[];
  void visit(Map<String, dynamic> node) {
    if (node['key_value'] == key || node['key'] == key) out.add(node);
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

/// Finds all `Icon` nodes in a serialized [tree], optionally filtered by
/// [codePoint] and/or [fontFamily].
List<Map<String, dynamic>> findIconNodes(
  Map<String, dynamic> tree, {
  int? codePoint,
  String? fontFamily,
}) {
  final out = <Map<String, dynamic>>[];
  void visit(Map<String, dynamic> node) {
    if (node['type'] == 'Icon') {
      final icon = node['icon'];
      final cp = icon is Map ? icon['code_point'] : null;
      final ff = icon is Map ? icon['font_family'] : null;
      if ((codePoint == null || cp == codePoint) &&
          (fontFamily == null || ff == fontFamily)) {
        out.add(node);
      }
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

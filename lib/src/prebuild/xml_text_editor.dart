import 'package:xml/xml.dart';

/// A minimal, format-preserving XML text editor.
///
/// The `xml` package can parse and mutate a document, but serialising the
/// result rewrites indentation, collapses multi-line attributes and drops the
/// trailing newline. That makes a prebuild diff noisy even when only one
/// element changed.
///
/// This editor keeps the original source string and applies targeted
/// insertions, removals and attribute edits to it, so untouched regions stay
/// byte-for-byte identical.
class XmlTextEditor {
  String _text;
  final String _original;

  XmlTextEditor(this._text) : _original = _text;

  String get text => _text;

  bool get changed => _text != _original;

  /// Indentation unit used by the document (tabs or spaces).
  String get indentUnit {
    for (final line in _text.split('\n')) {
      if (line.trim().isEmpty) continue;
      final indent = line.substring(0, line.length - line.trimLeft().length);
      if (indent.isEmpty) continue;
      if (indent.contains('\t')) return '\t';
      return indent.length >= 4
          ? '    '
          : indent.length == 2
          ? '  '
          : '    ';
    }
    return '    ';
  }

  /// Renders [element] using this document's indentation unit.
  String render(XmlElement element) =>
      element.toXmlString(pretty: true, indent: indentUnit);

  /// Reads an attribute from [element]'s opening tag.
  String? attribute(XmlTextElement element, String attribute) {
    final open = _text.substring(element.start, element.openEnd);
    final match = RegExp(
      r'''\s''' + RegExp.escape(attribute) + r'''\s*=\s*(["'])(.*?)\1''',
      dotAll: true,
    ).firstMatch(open);
    return match?.group(2);
  }

  /// Finds the first element called [name], optionally restricted to a
  /// predicate. Returns null when the document has no match.
  XmlTextElement? find(
    String name, {
    bool Function(XmlTextElement element)? where,
  }) {
    for (final element in _scan()) {
      if (element.name == name && (where == null || where(element))) {
        return element;
      }
    }
    return null;
  }

  /// Finds every descendant of [within] (or the whole document) called
  /// [name]. The returned offsets belong to the current [text].
  List<XmlTextElement> findAll(String name, {XmlTextElement? within}) {
    final from = within?.openEnd ?? 0;
    final to = within?.closeStart ?? _text.length;
    return [
      for (final element in _scan(from, to))
        if (element.name == name) element,
    ];
  }

  bool has(String name, {bool Function(XmlTextElement element)? where}) =>
      find(name, where: where) != null;

  /// Whether [parent] contains at least one element child.
  bool hasChildElements(XmlTextElement parent) =>
      _scan(parent.openEnd, parent.closeStart).isNotEmpty;

  /// Replaces the value of [attribute] on the first matching element. Inserts
  /// the attribute when it does not exist yet. No-op when the value is
  /// already the same.
  bool setAttribute(
    String name,
    String attribute,
    String value, {
    bool Function(XmlTextElement element)? where,
  }) {
    final element = find(name, where: where);
    if (element == null) return false;
    final open = _text.substring(element.start, element.openEnd);
    final existing = RegExp(
      r'(^|\s)' + RegExp.escape(attribute) + r'''\s*=\s*(["'])(.*?)\2''',
      dotAll: true,
    ).firstMatch(open);
    if (existing != null && existing.group(3) == value) return true;

    final escaped = _escapeAttribute(value);
    if (existing != null) {
      _text = _text.replaceRange(
        element.start + existing.start,
        element.start + existing.end,
        '${existing.group(1)}$attribute="$escaped"',
      );
      return true;
    }

    final closeLength = open.trimRight().endsWith('/>') ? 2 : 1;
    final insertAt = element.start + open.length - closeLength;
    _text = _text.replaceRange(insertAt, insertAt, ' $attribute="$escaped"');
    return true;
  }

  /// Removes the first matching element, including its line when the element
  /// is alone on that line.
  bool remove(
    String name, {
    bool Function(XmlTextElement element)? where,
  }) {
    final element = find(name, where: where);
    if (element == null) return false;
    _text = _withoutElement(element);
    return true;
  }

  /// Inserts [markup] as the first child of the first matching [parent].
  bool prependChild(
    String parent,
    String markup, {
    bool Function(XmlTextElement element)? where,
  }) {
    final element = find(parent, where: where);
    if (element == null) return false;
    _insertFirstChild(element, markup);
    return true;
  }

  /// Inserts [markup] as the last child of the first matching [parent].
  bool appendChild(
    String parent,
    String markup, {
    bool Function(XmlTextElement element)? where,
  }) {
    final element = find(parent, where: where);
    if (element == null) return false;
    _insertLastChild(element, markup);
    return true;
  }

  void _insertFirstChild(XmlTextElement parent, String markup) {
    final newline = RegExp(
      r'^\r?\n',
    ).firstMatch(_text.substring(parent.openEnd));
    final parentIndent = _lineIndentAt(parent.start);
    final childIndent = '$parentIndent$indentUnit';
    final block = _indentLines(markup, childIndent);
    if (newline != null) {
      final insertAt = parent.openEnd + newline.group(0)!.length;
      _text = _text.replaceRange(insertAt, insertAt, '$block\n');
    } else {
      _text = _text.replaceRange(
        parent.openEnd,
        parent.openEnd,
        '\n$block\n$parentIndent',
      );
    }
  }

  void _insertLastChild(XmlTextElement parent, String markup) {
    final parentIndent = _lineIndentAt(parent.start);
    final childIndent = '$parentIndent$indentUnit';
    final block = _indentLines(markup, childIndent);
    if (parent.selfClosing) {
      final open = _text.substring(parent.start, parent.openEnd);
      final expandedOpen = open.replaceFirst(RegExp(r'/\s*>$'), '>');
      _text = _text.replaceRange(
        parent.start,
        parent.end,
        '$expandedOpen\n$block\n$parentIndent</${parent.name}>',
      );
      return;
    }

    final lineStart = _text.lastIndexOf('\n', parent.closeStart) + 1;
    final beforeClose = _text.substring(lineStart, parent.closeStart);
    if (beforeClose.trim().isEmpty) {
      _text = _text.replaceRange(lineStart, lineStart, '$block\n');
    } else {
      _text = _text.replaceRange(
        parent.closeStart,
        parent.closeStart,
        '\n$block\n$parentIndent',
      );
    }
  }

  String _withoutElement(XmlTextElement element) {
    final lineStart = _text.lastIndexOf('\n', element.start) + 1;
    final newline = _text.indexOf('\n', element.end);
    final lineEnd = newline < 0 ? _text.length : newline;
    final prefix = _text.substring(lineStart, element.start);
    final suffix = _text.substring(element.end, lineEnd);
    if (prefix.trim().isEmpty && suffix.trim().isEmpty) {
      return _text.replaceRange(
        lineStart,
        newline < 0 ? lineEnd : lineEnd + 1,
        '',
      );
    }
    return _text.replaceRange(element.start, element.end, '');
  }

  String _lineIndentAt(int position) {
    final lineStart = _text.lastIndexOf('\n', position) + 1;
    var end = lineStart;
    while (end < _text.length && (_text[end] == ' ' || _text[end] == '\t')) {
      end++;
    }
    return _text.substring(lineStart, end);
  }

  String _indentLines(String markup, String indent) => markup
      .split('\n')
      .map((line) => line.isEmpty ? line : '$indent$line')
      .join('\n');

  String _escapeAttribute(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

  /// Returns every element in `[from, to)`, including descendants.
  List<XmlTextElement> _scan([int from = 0, int? to]) {
    final limit = to ?? _text.length;
    final elements = <XmlTextElement>[];
    var i = from;
    while (i < limit) {
      i = _skipTrivia(i, limit);
      if (i >= limit || !_text.startsWith('<', i)) {
        if (i >= limit) break;
        i++;
        continue;
      }
      if (_text.startsWith('</', i)) {
        final end = _tagEnd(i);
        if (end < 0) break;
        i = end + 1;
        continue;
      }
      final end = _tagEnd(i);
      if (end < 0) break;
      final open = _text.substring(i, end + 1);
      final name = RegExp(r'^<\s*([^\s/>]+)').firstMatch(open)?.group(1);
      if (name == null) {
        i = end + 1;
        continue;
      }
      final selfClosing = open.trimRight().endsWith('/>');
      if (selfClosing) {
        elements.add(XmlTextElement(name, i, end + 1, end + 1, true));
        i = end + 1;
        continue;
      }
      final closeStart = _findClose(name, end + 1, limit);
      if (closeStart < 0) {
        elements.add(XmlTextElement(name, i, end + 1, limit, false, limit));
        i = limit;
        continue;
      }
      final closeEnd = _tagEnd(closeStart) + 1;
      elements.add(
        XmlTextElement(name, i, end + 1, closeEnd, false, closeStart),
      );
      elements.addAll(_scan(end + 1, closeStart));
      i = closeEnd;
    }
    return elements;
  }

  int _skipTrivia(int index, int limit) {
    var i = index;
    while (i < limit) {
      if (_text.startsWith('<!--', i)) {
        final end = _text.indexOf('-->', i + 4);
        i = end < 0 ? limit : end + 3;
      } else if (_text.startsWith('<![CDATA[', i)) {
        final end = _text.indexOf(']]>', i + 9);
        i = end < 0 ? limit : end + 3;
      } else if (_text.startsWith('<?', i)) {
        final end = _text.indexOf('?>', i + 2);
        i = end < 0 ? limit : end + 2;
      } else if (_text.startsWith('<!', i)) {
        final end = _text.indexOf('>', i + 2);
        i = end < 0 ? limit : end + 1;
      } else {
        break;
      }
    }
    return i;
  }

  int _tagEnd(int start) {
    String? quote;
    for (var i = start; i < _text.length; i++) {
      final char = _text[i];
      if (quote != null) {
        if (char == quote) quote = null;
        continue;
      }
      if (char == '"' || char == "'") {
        quote = char;
      } else if (char == '>') {
        return i;
      }
    }
    return -1;
  }

  /// Index of the `<` that starts `</name>`, or -1.
  int _findClose(String name, int from, int limit) {
    var depth = 1;
    var i = from;
    while (i < limit) {
      final next = _text.indexOf('<', i);
      if (next < 0 || next >= limit) return -1;
      // Comments, CDATA and processing instructions can contain quotes and
      // `>` characters that are not tag delimiters.
      if (_isMarkupTrivia(next)) {
        i = _skipTrivia(next, limit);
        if (i == next) i = next + 1;
        continue;
      }
      if (_text.startsWith('</', next)) {
        final end = _tagEnd(next);
        if (end < 0) return -1;
        final closing = RegExp(
          r'^</\s*([^\s>]+)',
        ).firstMatch(_text.substring(next, end + 1))?.group(1);
        if (closing == name) {
          depth--;
          if (depth == 0) return next;
        }
        i = end + 1;
      } else {
        final end = _tagEnd(next);
        if (end < 0) return -1;
        final tag = _text.substring(next, end + 1);
        final opening = RegExp(
          r'^<\s*([^\s/>]+)',
        ).firstMatch(tag)?.group(1);
        if (opening == name && !tag.trimRight().endsWith('/>')) {
          depth++;
        }
        i = end + 1;
      }
    }
    return -1;
  }

  bool _isMarkupTrivia(int index) =>
      _text.startsWith('<!--', index) ||
      _text.startsWith('<![CDATA[', index) ||
      _text.startsWith('<?', index) ||
      _text.startsWith('<!', index);
}

/// An element found in the current [XmlTextEditor.text].
class XmlTextElement {
  final String name;
  final int start;

  /// Offset just after the opening tag's `>`.
  final int openEnd;

  /// Offset just after the closing `>` (equal to [openEnd] when self-closing).
  final int end;

  final bool selfClosing;

  /// Offset of the `<` in `</name>` (equal to [end] when self-closing).
  final int closeStart;

  const XmlTextElement(
    this.name,
    this.start,
    this.openEnd,
    this.end,
    this.selfClosing, [
    int? closeStart,
  ]) : closeStart = closeStart ?? end;
}

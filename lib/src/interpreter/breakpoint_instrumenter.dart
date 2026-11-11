/// Breakpoint instrumentation for the analyzer-based Source runtime.
///
/// Kept separate so the AST product runtime remains analyzer-free.
library;

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// Injects `__debugBreakpoint` calls and ensures enclosing functions are async.
String instrumentBreakpoints(
  String source,
  String fileName,
  Set<int> targetLines,
) {
  if (targetLines.isEmpty) return source;

  final cleanFile = fileName.replaceAll(r'\', '/');
  final baseFile = cleanFile.contains('/')
      ? cleanFile.split('/').last
      : cleanFile;

  // 1. Ensure enclosing function bodies for target lines are marked async.
  var code = source;
  try {
    final parseResult = parseString(content: code, throwIfDiagnostics: false);
    final lineInfo = parseResult.lineInfo;
    final asyncInsertOffsets = <int>{};

    for (final targetLine in targetLines) {
      final finder = _EnclosingBodyFinder(targetLine, lineInfo);
      parseResult.unit.accept(finder);
      final body = finder.innermostBody;
      if (body != null && !body.isAsynchronous) {
        asyncInsertOffsets.add(body.block.leftBracket.offset);
      }
    }

    if (asyncInsertOffsets.isNotEmpty) {
      final sorted = asyncInsertOffsets.toList()
        ..sort((a, b) => b.compareTo(a));
      for (final offset in sorted) {
        code = '${code.substring(0, offset)}async ${code.substring(offset)}';
      }
    }
  } catch (_) {}

  // 2. Prepend debug breakpoint call to each target line.
  final lines = code.split('\n');
  for (final targetLine in targetLines) {
    final index = targetLine - 1;
    if (index >= 0 && index < lines.length) {
      final line = lines[index];
      final trimmed = line.trim();

      // Skip blank lines, comments, imports, exports, solitary braces
      if (trimmed.isEmpty ||
          trimmed.startsWith('//') ||
          trimmed.startsWith('/*') ||
          trimmed.startsWith('*') ||
          trimmed.startsWith('import ') ||
          trimmed.startsWith('export ') ||
          trimmed.startsWith('part ') ||
          trimmed == '{' ||
          trimmed == '}') {
        continue;
      }

      final leadingSpaces = line.substring(0, line.indexOf(trimmed));
      lines[index] =
          '$leadingSpaces'
          'await __debugBreakpoint(\'$baseFile\', $targetLine); $trimmed';
    }
  }
  return lines.join('\n');
}

/// AST visitor to identify the innermost BlockFunctionBody enclosing a target
/// line number.
class _EnclosingBodyFinder extends RecursiveAstVisitor<void> {
  final int targetLine;
  final dynamic lineInfo;
  BlockFunctionBody? innermostBody;

  _EnclosingBodyFinder(this.targetLine, this.lineInfo);

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    final start = lineInfo.getLocation(node.offset).lineNumber;
    final end = lineInfo.getLocation(node.end).lineNumber;
    if (targetLine >= start && targetLine <= end) {
      innermostBody = node;
    }
    super.visitBlockFunctionBody(node);
  }
}

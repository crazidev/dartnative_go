/// Shared analyzer → serializable-AST converter with shims for
/// newer/unmapped analyzer node types.
///
/// Extracted from `ast_builder.dart` so both the client bundler and the
/// server-component delta bundler use the identical conversion behavior
/// without a duplicate class definition (which causes ambiguous imports).
library;

import 'package:analyzer/dart/ast/ast.dart' as analyzer;
import 'package:tom_ast_generator/tom_ast_generator.dart';

/// Extended [AstConverter] that handles newer/unmapped analyzer nodes
/// such as [analyzer.LibraryIdentifier] in `library foo;` directives.
class SafeAstConverter extends AstConverter {
  @override
  SAstNode? convert(analyzer.AstNode? node) {
    if (node == null) return null;
    // The analyzer still models a `library foo.bar;` name as a
    // LibraryIdentifier; the serializable model spells it SDottedName.
    if (node is analyzer.DottedName) {
      // A dotted name's tokens alternate identifier, '.', identifier, …
      final name = node.tokens
          .where((t) => t.lexeme != '.')
          .map((t) => t.lexeme)
          .join('.');
      return SSimpleIdentifier(
        offset: node.offset,
        length: node.length,
        name: name,
        inDeclarationContext: false,
      );
    }
    final nodeType = node.runtimeType.toString();
    if (nodeType.contains('DotShorthandPropertyAccess')) {
      final propName =
          (node as dynamic).propertyName?.name?.toString() ??
          (node as dynamic).identifier?.name?.toString() ??
          node.toString().replaceAll(RegExp(r'^\.'), '');
      return SSimpleIdentifier(
        offset: node.offset,
        length: node.length,
        name: propName,
        inDeclarationContext: false,
      );
    }
    if (nodeType.contains('DotShorthandInvocation')) {
      final methodName =
          (node as dynamic).methodName?.name?.toString() ??
          (node as dynamic).identifier?.name?.toString() ??
          '';
      final args = (node as dynamic).argumentList as analyzer.AstNode?;
      return SMethodInvocation(
        offset: node.offset,
        length: node.length,
        methodName: SSimpleIdentifier(
          offset: node.offset,
          length: methodName.length,
          name: methodName,
          inDeclarationContext: false,
        ),
        argumentList: convert(args) as SArgumentList?,
      );
    }
    final res = super.convert(node);
    if (res != null && res.runtimeType.toString().contains('Unknown')) {
      print('[AST] Unhandled node: ${node.runtimeType} -> "$node"');
    }
    return res;
  }
}

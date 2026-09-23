import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:tom_ast_model/tom_ast_model.dart';
import 'package:tom_d4rt_ast/runtime.dart' show AstBundle;

import '../runner/bytecode/bytecode_models.dart';
import '../runner/bytecode/opcodes.dart';

/// Helper to build and deduplicate Constant Pool entries.
class ConstantPoolBuilder {
  final List<Object?> _constants = [];
  final Map<String, int> _lookup = {};

  int add(Object? value) {
    if (value == null) {
      final key = 'null';
      if (_lookup.containsKey(key)) return _lookup[key]!;
      final idx = _constants.length;
      _constants.add(null);
      _lookup[key] = idx;
      return idx;
    }
    final key = '${value.runtimeType}:$value';
    if (_lookup.containsKey(key)) {
      return _lookup[key]!;
    }
    final index = _constants.length;
    _constants.add(value);
    _lookup[key] = index;
    return index;
  }

  ConstantPool build() => ConstantPool(List.unmodifiable(_constants));
}

/// Scope tracker for local variables and slots within a function.
class _LocalScope {
  final _LocalScope? parent;
  final Map<String, int> _variables = {};
  int _nextSlot;

  _LocalScope({this.parent, int initialSlot = 0})
    : _nextSlot = parent != null ? parent._nextSlot : initialSlot;

  int define(String name) {
    final slot = _nextSlot++;
    _variables[name] = slot;
    return slot;
  }

  int? lookup(String name) {
    if (_variables.containsKey(name)) {
      return _variables[name];
    }
    return parent?.lookup(name);
  }

  int get maxSlots => _nextSlot;
}

/// Dynamic Bytecode Buffer with label patching support.
class _BytecodeBuffer {
  final List<int> _bytes = [];
  final List<SourceMapEntry> _sourceMap = [];

  int get length => _bytes.length;

  void emit(int byte) => _bytes.add(byte & 0xFF);

  void emitOp(int opCode, [int? line, int? col]) {
    if (line != null && col != null) {
      _sourceMap.add(
        SourceMapEntry(
          pcOffset: _bytes.length,
          line: line,
          column: col,
        ),
      );
    }
    emit(opCode);
  }

  void emitU8(int value) => emit(value & 0xFF);

  void emitU16(int value) {
    emit((value >> 8) & 0xFF);
    emit(value & 0xFF);
  }

  void emitU32(int value) {
    emit((value >> 24) & 0xFF);
    emit((value >> 16) & 0xFF);
    emit((value >> 8) & 0xFF);
    emit(value & 0xFF);
  }

  void emitI32(int value) => emitU32(value);

  int emitJumpPlaceholder(int jumpOpCode) {
    emit(jumpOpCode);
    final offsetPos = _bytes.length;
    emitI32(0); // placeholder
    return offsetPos;
  }

  void patchJump(int placeholderPos, [int? targetPos]) {
    final target = targetPos ?? _bytes.length;
    final relOffset = target - (placeholderPos + 4);
    _bytes[placeholderPos] = (relOffset >> 24) & 0xFF;
    _bytes[placeholderPos + 1] = (relOffset >> 16) & 0xFF;
    _bytes[placeholderPos + 2] = (relOffset >> 8) & 0xFF;
    _bytes[placeholderPos + 3] = relOffset & 0xFF;
  }

  Uint8List toBytes() => Uint8List.fromList(_bytes);
  List<SourceMapEntry> toSourceMap() => List.unmodifiable(_sourceMap);
}

/// Compiles `SAstNode` trees into a complete [BytecodeBundle] and computes [BytecodeDelta] diffs.
class BytecodeEmitter {
  final ConstantPoolBuilder _pool = ConstantPoolBuilder();
  final List<BytecodeFunction> _functions = [];
  final List<BytecodeClass> _classes = [];
  final Map<String, int> _globalFuncIdMap = {};
  final Set<String> _knownClassNames = {};
  int _nextFuncId = 1;
  int _nextClosureIndex = 1;

  bool _isPascalCase(String name) {
    if (name.isEmpty) return false;
    final first = name.codeUnitAt(0);
    return first >= 65 && first <= 90;
  }

  int _allocateFuncId(String qualifiedName) {
    if (_globalFuncIdMap.containsKey(qualifiedName)) {
      return _globalFuncIdMap[qualifiedName]!;
    }
    final id = _nextFuncId++;
    _globalFuncIdMap[qualifiedName] = id;
    return id;
  }

  /// Compiles a whole [AstBundle] into a [BytecodeBundle].
  BytecodeBundle compileBundle(AstBundle astBundle) {
    _functions.clear();
    _classes.clear();
    _globalFuncIdMap.clear();
    _knownClassNames.clear();
    _nextFuncId = 1;
    _nextClosureIndex = 1;

    // First pass: register all classes and function signatures to assign stable IDs
    for (final entry in astBundle.modules.entries) {
      final uri = entry.key;
      final unit = entry.value;
      _preIndexUnit(uri, unit);
    }

    // Second pass: compile function and method bodies
    int? entryFuncId;
    for (final entry in astBundle.modules.entries) {
      final uri = entry.key;
      final unit = entry.value;
      final mainId = _compileUnit(uri, unit);
      if (uri == astBundle.entryPointUri || entryFuncId == null) {
        if (mainId != null) entryFuncId = mainId;
      }
    }

    entryFuncId ??= _globalFuncIdMap['main'] ?? 1;

    return BytecodeBundle(
      entryPointUri: astBundle.entryPointUri,
      entryPointFuncId: entryFuncId,
      constantPool: _pool.build(),
      functions: List.unmodifiable(_functions),
      classes: List.unmodifiable(_classes),
      metadata: {
        'modules': astBundle.modules.length,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  void _preIndexUnit(String uri, SCompilationUnit unit) {
    for (final decl in unit.declarations) {
      if (decl is SFunctionDeclaration) {
        final name = decl.name?.name;
        if (name != null) {
          _allocateFuncId('$uri#$name');
          if (name == 'main') _allocateFuncId('main');
        }
      } else if (decl is SClassDeclaration) {
        final className = decl.name?.name;
        if (className != null) {
          _knownClassNames.add(className);
          for (final member in decl.members) {
            if (member is SMethodDeclaration) {
              final methodName = member.name?.name;
              if (methodName != null) {
                _allocateFuncId('$uri#$className.$methodName');
              }
            } else if (member is SConstructorDeclaration) {
              final ctorName = member.name?.name ?? 'new';
              _allocateFuncId('$uri#$className.$ctorName');
            }
          }
        }
      }
    }
  }

  int? _compileUnit(String uri, SCompilationUnit unit) {
    int? mainId;

    for (final decl in unit.declarations) {
      if (decl is SFunctionDeclaration) {
        final name = decl.name?.name;
        if (name == null) continue;
        final funcId = _allocateFuncId('$uri#$name');
        if (name == 'main') {
          mainId = funcId;
          _globalFuncIdMap['main'] = funcId;
        }
        final fn = _compileFunction(
          id: funcId,
          name: name,
          uri: uri,
          enclosingClass: null,
          params: decl.functionExpression?.parameters,
          body: decl.functionExpression?.body,
        );
        _functions.add(fn);
      } else if (decl is SClassDeclaration) {
        _compileClass(uri, decl);
      }
    }

    return mainId;
  }

  void _compileClass(String uri, SClassDeclaration decl) {
    final className = decl.name?.name ?? 'Anonymous';
    String? superclassName;
    final superType = decl.extendsClause?.superclass;
    if (superType is SNamedType) {
      superclassName = superType.name?.name;
    }
    final fieldNames = <String>[];
    final fieldInitializers = <SVariableDeclaration>[];
    final methodFuncIds = <String, int>{};
    final constructorFuncIds = <String, int>{};

    for (final member in decl.members) {
      if (member is SFieldDeclaration) {
        final vars = member.fields?.variables ?? const [];
        for (final v in vars) {
          final vName = v.name?.name;
          if (vName != null) {
            fieldNames.add(vName);
            if (v.initializer != null) {
              fieldInitializers.add(v);
            }
          }
        }
      } else if (member is SMethodDeclaration) {
        final methodName = member.name?.name;
        if (methodName == null) continue;
        final funcId = _allocateFuncId('$uri#$className.$methodName');
        methodFuncIds[methodName] = funcId;
        final fn = _compileFunction(
          id: funcId,
          name: methodName,
          uri: uri,
          enclosingClass: className,
          fieldNames: fieldNames,
          params: member.parameters,
          body: member.body,
          isMethod: true,
        );
        _functions.add(fn);
      } else if (member is SConstructorDeclaration) {
        final ctorName = member.name?.name ?? 'new';
        final funcId = _allocateFuncId('$uri#$className.$ctorName');
        constructorFuncIds[ctorName] = funcId;
        final fn = _compileFunction(
          id: funcId,
          name: ctorName,
          uri: uri,
          enclosingClass: className,
          fieldNames: fieldNames,
          fieldInitializers: fieldInitializers,
          ctorInitializers: member.initializers,
          params: member.parameters,
          body: member.body,
          isConstructor: true,
        );
        _functions.add(fn);
      }
    }

    if (constructorFuncIds.isEmpty) {
      final defaultCtorId = _allocateFuncId('$uri#$className.new');
      constructorFuncIds['new'] = defaultCtorId;
      final fn = _compileFunction(
        id: defaultCtorId,
        name: 'new',
        uri: uri,
        enclosingClass: className,
        fieldNames: fieldNames,
        fieldInitializers: fieldInitializers,
        params: null,
        body: null,
        isConstructor: true,
      );
      _functions.add(fn);
    }

    _classes.add(
      BytecodeClass(
        name: className,
        uri: uri,
        superclass: superclassName,
        fieldNames: fieldNames,
        methodFuncIds: methodFuncIds,
        constructorFuncIds: constructorFuncIds,
      ),
    );
  }

  BytecodeFunction _compileFunction({
    required int id,
    required String name,
    required String uri,
    required String? enclosingClass,
    required SFormalParameterList? params,
    required SFunctionBody? body,
    List<String>? fieldNames,
    List<SVariableDeclaration>? fieldInitializers,
    List<SConstructorInitializer>? ctorInitializers,
    bool isMethod = false,
    bool isConstructor = false,
  }) {
    final buffer = _BytecodeBuffer();
    final scope = _LocalScope();
    final namedParamList = <BytecodeParam>[];
    int positionalCount = 0;

    // Slot 0 is reserved for `this` in methods/constructors
    if (isMethod || isConstructor) {
      scope.define('this');
    }

    // Allocate parameter slots
    if (params != null) {
      for (final p in params.parameters) {
        final pName = _extractParamName(p);
        final isNamed = p.isNamed;
        final isReq = p.isRequired;
        int? defaultConstIdx;
        if (p is SDefaultFormalParameter && p.defaultValue != null) {
          final defVal = _extractLiteralValue(p.defaultValue!);
          if (defVal != null) {
            defaultConstIdx = _pool.add(defVal);
          }
        }
        if (pName != null) {
          scope.define(pName);
          if (isNamed) {
            namedParamList.add(
              BytecodeParam(
                name: pName,
                isRequired: isReq,
                isNamed: true,
                defaultValueConstIndex: defaultConstIdx,
              ),
            );
          } else {
            positionalCount++;
          }
        }
      }
    }

    // Constructor initialization logic
    if (isConstructor) {
      // 1. Field initializers at declaration level
      if (fieldInitializers != null) {
        for (final f in fieldInitializers) {
          if (f.initializer != null) {
            final fName = f.name?.name;
            if (fName != null) {
              _compileExpression(f.initializer!, buffer, scope);
              buffer.emitOp(OpCode.loadLocal);
              buffer.emitU16(0); // this
              final nameIdx = _pool.add(fName);
              buffer.emitOp(OpCode.storeField);
              buffer.emitU16(nameIdx);
            }
          }
        }
      }

      // 2. Initializing formals (this.param) and matching constructor parameters
      if (params != null) {
        for (final p in params.parameters) {
          final pName = _extractParamName(p);
          if (pName != null && fieldNames != null && fieldNames.contains(pName)) {
            final paramSlot = scope.lookup(pName);
            if (paramSlot != null) {
              buffer.emitOp(OpCode.loadLocal);
              buffer.emitU16(paramSlot);
              buffer.emitOp(OpCode.loadLocal);
              buffer.emitU16(0); // this
              final nameIdx = _pool.add(pName);
              buffer.emitOp(OpCode.storeField);
              buffer.emitU16(nameIdx);
            }
          }
        }
      }

      // 3. Constructor field initializers
      if (ctorInitializers != null) {
        for (final init in ctorInitializers) {
          if (init is SConstructorFieldInitializer &&
              init.fieldName?.name != null &&
              init.expression != null) {
            _compileExpression(init.expression!, buffer, scope);
            buffer.emitOp(OpCode.loadLocal);
            buffer.emitU16(0); // this
            final nameIdx = _pool.add(init.fieldName!.name);
            buffer.emitOp(OpCode.storeField);
            buffer.emitU16(nameIdx);
          }
        }
      }
    }

    // Compile body statements/expressions
    if (body is SBlockFunctionBody) {
      if (body.block != null) {
        _compileBlock(body.block!, buffer, scope);
      }
      buffer.emitOp(OpCode.ret);
    } else if (body is SExpressionFunctionBody) {
      if (body.expression != null) {
        _compileExpression(body.expression!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      buffer.emitOp(OpCode.retValue);
    } else {
      buffer.emitOp(OpCode.ret);
    }

    final codeBytes = buffer.toBytes();
    final hashStr = sha256.convert(codeBytes).toString().substring(0, 16);

    return BytecodeFunction(
      id: id,
      name: name,
      uri: uri,
      enclosingClass: enclosingClass,
      contentHash: hashStr,
      positionalParamCount: positionalCount,
      namedParams: namedParamList,
      localSlotsCount: scope.maxSlots,
      code: codeBytes,
      sourceMap: buffer.toSourceMap(),
    );
  }

  Object? _extractLiteralValue(SExpression expr) {
    if (expr is SBooleanLiteral) return expr.value;
    if (expr is SIntegerLiteral) return expr.value;
    if (expr is SDoubleLiteral) return expr.value;
    if (expr is SSimpleStringLiteral) return expr.value;
    if (expr is SNullLiteral) return null;
    return null;
  }

  String? _extractParamName(SFormalParameter p) {
    if (p is SSimpleFormalParameter) return p.name?.name;
    if (p is SDefaultFormalParameter) {
      final inner = p.parameter;
      return inner != null ? _extractParamName(inner) : null;
    }
    if (p is SFieldFormalParameter) return p.name?.name;
    return null;
  }

  void _compileBlock(
    SBlock block,
    _BytecodeBuffer buffer,
    _LocalScope scope,
  ) {
    for (final stmt in block.statements) {
      _compileStatement(stmt, buffer, scope);
    }
  }

  void _compileStatement(
    SStatement stmt,
    _BytecodeBuffer buffer,
    _LocalScope scope,
  ) {
    if (stmt is SVariableDeclarationStatement) {
      final vars = stmt.variables?.variables ?? const [];
      for (final v in vars) {
        final name = v.name?.name;
        if (name == null) continue;
        final slot = scope.define(name);
        if (v.initializer != null) {
          _compileExpression(v.initializer!, buffer, scope);
        } else {
          buffer.emitOp(OpCode.pushNull);
        }
        buffer.emitOp(OpCode.storeLocal);
        buffer.emitU16(slot);
      }
    } else if (stmt is SReturnStatement) {
      if (stmt.expression != null) {
        _compileExpression(stmt.expression!, buffer, scope);
        buffer.emitOp(OpCode.retValue);
      } else {
        buffer.emitOp(OpCode.ret);
      }
    } else if (stmt is SExpressionStatement) {
      if (stmt.expression != null) {
        _compileExpression(stmt.expression!, buffer, scope);
        buffer.emitOp(OpCode.pop);
      }
    } else if (stmt is SIfStatement) {
      if (stmt.condition != null) {
        _compileExpression(stmt.condition!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushTrue);
      }
      final jumpFalsePos = buffer.emitJumpPlaceholder(OpCode.jumpIfFalse);
      if (stmt.thenStatement != null) {
        _compileStatement(stmt.thenStatement!, buffer, scope);
      }
      if (stmt.elseStatement != null) {
        final jumpOverElsePos = buffer.emitJumpPlaceholder(OpCode.jump);
        buffer.patchJump(jumpFalsePos);
        _compileStatement(stmt.elseStatement!, buffer, scope);
        buffer.patchJump(jumpOverElsePos);
      } else {
        buffer.patchJump(jumpFalsePos);
      }
    } else if (stmt is SBlock) {
      _compileBlock(stmt, buffer, scope);
    } else if (stmt is SWhileStatement) {
      final loopStart = buffer.length;
      if (stmt.condition != null) {
        _compileExpression(stmt.condition!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushTrue);
      }
      final exitJump = buffer.emitJumpPlaceholder(OpCode.jumpIfFalse);
      if (stmt.body != null) {
        _compileStatement(stmt.body!, buffer, scope);
      }
      final loopJump = buffer.emitJumpPlaceholder(OpCode.jump);
      buffer.patchJump(loopJump, loopStart);
      buffer.patchJump(exitJump);
    } else if (stmt is SForStatement) {
      final loopParts = stmt.forLoopParts;
      if (loopParts is SForEachPartsWithDeclaration || loopParts is SForEachPartsWithIdentifier) {
        final iterableExpr = loopParts is SForEachPartsWithDeclaration
            ? loopParts.iterable
            : (loopParts as SForEachPartsWithIdentifier).iterable;
        final varName = loopParts is SForEachPartsWithDeclaration
            ? loopParts.loopVariable?.identifier?.name
            : (loopParts as SForEachPartsWithIdentifier).identifier?.name;

        if (iterableExpr != null && varName != null && stmt.body != null) {
          final iterSlot = scope.define('\$iter_${scope.maxSlots}');
          final idxSlot = scope.define('\$idx_${scope.maxSlots}');
          final elemSlot = scope.define(varName);

          _compileExpression(iterableExpr, buffer, scope);
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(iterSlot);

          buffer.emitOp(OpCode.pushInt);
          buffer.emitI32(0);
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(idxSlot);

          final loopStart = buffer.length;

          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(idxSlot);

          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(iterSlot);
          final lenIdx = _pool.add('length');
          buffer.emitOp(OpCode.loadField);
          buffer.emitU16(lenIdx);

          buffer.emitOp(OpCode.binaryOp);
          buffer.emitU8(BinaryOpId.lt);

          final exitJump = buffer.emitJumpPlaceholder(OpCode.jumpIfFalse);

          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(iterSlot);
          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(idxSlot);
          buffer.emitOp(OpCode.loadIndex);
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(elemSlot);

          _compileStatement(stmt.body!, buffer, scope);

          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(idxSlot);
          buffer.emitOp(OpCode.pushInt);
          buffer.emitI32(1);
          buffer.emitOp(OpCode.binaryOp);
          buffer.emitU8(BinaryOpId.add);
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(idxSlot);

          final loopJump = buffer.emitJumpPlaceholder(OpCode.jump);
          buffer.patchJump(loopJump, loopStart);
          buffer.patchJump(exitJump);
        }
      }
    } else if (stmt is STryStatement) {
      final tryBeginPos = buffer.emitJumpPlaceholder(OpCode.tryCatchBegin);
      if (stmt.body != null) {
        _compileBlock(stmt.body!, buffer, scope);
      }
      buffer.emitOp(OpCode.tryCatchEnd);
      final jumpOverCatchPos = buffer.emitJumpPlaceholder(OpCode.jump);
      buffer.patchJump(tryBeginPos);
      if (stmt.catchClauses.isNotEmpty) {
        final clause = stmt.catchClauses.first;
        if (clause.exceptionParameter?.name != null) {
          final slot = scope.define(clause.exceptionParameter!.name);
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(slot);
        }
        if (clause.body != null) {
          _compileBlock(clause.body!, buffer, scope);
        }
      }
      buffer.patchJump(jumpOverCatchPos);
    }
  }

  void _compileExpression(
    SExpression expr,
    _BytecodeBuffer buffer,
    _LocalScope scope,
  ) {
    if (expr is SIntegerLiteral) {
      final val = expr.value;
      if (val >= -2147483648 && val <= 2147483647) {
        buffer.emitOp(OpCode.pushInt);
        buffer.emitI32(val);
      } else {
        final idx = _pool.add(val);
        buffer.emitOp(OpCode.pushConst);
        buffer.emitU16(idx);
      }
    } else if (expr is SDoubleLiteral) {
      final idx = _pool.add(expr.value);
      buffer.emitOp(OpCode.pushConst);
      buffer.emitU16(idx);
    } else if (expr is SBooleanLiteral) {
      buffer.emitOp(expr.value ? OpCode.pushTrue : OpCode.pushFalse);
    } else if (expr is SNullLiteral) {
      buffer.emitOp(OpCode.pushNull);
    } else if (expr is SSimpleStringLiteral) {
      final idx = _pool.add(expr.value);
      buffer.emitOp(OpCode.pushConst);
      buffer.emitU16(idx);
    } else if (expr is SStringInterpolation) {
      // String interpolation: evaluate elements and concat via binaryOp +
      var isFirst = true;
      for (final el in expr.elements) {
        if (el is SInterpolationString) {
          final idx = _pool.add(el.value);
          buffer.emitOp(OpCode.pushConst);
          buffer.emitU16(idx);
        } else if (el is SInterpolationExpression) {
          if (el.expression != null) {
            _compileExpression(el.expression!, buffer, scope);
          } else {
            buffer.emitOp(OpCode.pushNull);
          }
        }
        if (!isFirst) {
          buffer.emitOp(OpCode.binaryOp);
          buffer.emitU8(BinaryOpId.add);
        }
        isFirst = false;
      }
    } else if (expr is SSimpleIdentifier) {
      final name = expr.name;
      final localSlot = scope.lookup(name);
      if (localSlot != null) {
        buffer.emitOp(OpCode.loadLocal);
        buffer.emitU16(localSlot);
      } else if (scope.lookup('this') != null) {
        // Class field fallback
        final thisSlot = scope.lookup('this')!;
        buffer.emitOp(OpCode.loadLocal);
        buffer.emitU16(thisSlot);
        final nameIdx = _pool.add(name);
        buffer.emitOp(OpCode.loadField);
        buffer.emitU16(nameIdx);
      } else {
        // Global / top-level identifier
        final nameIdx = _pool.add(name);
        buffer.emitOp(OpCode.loadGlobal);
        buffer.emitU16(nameIdx);
      }
    } else if (expr is SBinaryExpression) {
      final op = expr.operator;
      final left = expr.leftOperand;
      final right = expr.rightOperand;

      if (op == '&&') {
        if (left != null) _compileExpression(left, buffer, scope);
        buffer.emitOp(OpCode.dup);
        final jumpPos = buffer.emitJumpPlaceholder(OpCode.jumpIfFalse);
        buffer.emitOp(OpCode.pop);
        if (right != null) _compileExpression(right, buffer, scope);
        buffer.patchJump(jumpPos);
      } else if (op == '||') {
        if (left != null) _compileExpression(left, buffer, scope);
        buffer.emitOp(OpCode.dup);
        final jumpPos = buffer.emitJumpPlaceholder(OpCode.jumpIfTrue);
        buffer.emitOp(OpCode.pop);
        if (right != null) _compileExpression(right, buffer, scope);
        buffer.patchJump(jumpPos);
      } else if (op == '??') {
        if (left != null) _compileExpression(left, buffer, scope);
        buffer.emitOp(OpCode.dup);
        final jumpPos = buffer.emitJumpPlaceholder(OpCode.jumpIfNotNull);
        buffer.emitOp(OpCode.pop);
        if (right != null) _compileExpression(right, buffer, scope);
        buffer.patchJump(jumpPos);
      } else {
        if (left != null) {
          _compileExpression(left, buffer, scope);
        } else {
          buffer.emitOp(OpCode.pushNull);
        }
        if (right != null) {
          _compileExpression(right, buffer, scope);
        } else {
          buffer.emitOp(OpCode.pushNull);
        }
        final binOpId = _resolveBinaryOpId(op);
        buffer.emitOp(OpCode.binaryOp);
        buffer.emitU8(binOpId);
      }
    } else if (expr is SPrefixExpression) {
      final op = expr.operator;
      if (expr.operand != null) {
        _compileExpression(expr.operand!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      if (op == '!') {
        buffer.emitOp(OpCode.unaryOp);
        buffer.emitU8(UnaryOpId.not);
      } else if (op == '-') {
        buffer.emitOp(OpCode.unaryOp);
        buffer.emitU8(UnaryOpId.neg);
      } else if (op == '~') {
        buffer.emitOp(OpCode.unaryOp);
        buffer.emitU8(UnaryOpId.bitNot);
      }
    } else if (expr is SAssignmentExpression) {
      final lhs = expr.leftHandSide;
      if (expr.rightHandSide != null) {
        _compileExpression(expr.rightHandSide!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      buffer.emitOp(OpCode.dup); // value remains on stack for expression result
      if (lhs is SSimpleIdentifier) {
        final slot = scope.lookup(lhs.name);
        if (slot != null) {
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(slot);
        } else if (scope.lookup('this') != null) {
          final thisSlot = scope.lookup('this')!;
          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(thisSlot);
          final nameIdx = _pool.add(lhs.name);
          buffer.emitOp(OpCode.storeField);
          buffer.emitU16(nameIdx);
        } else {
          final nameIdx = _pool.add(lhs.name);
          buffer.emitOp(OpCode.storeGlobal);
          buffer.emitU16(nameIdx);
        }
      } else if (lhs is SPrefixedIdentifier) {
        final prefixName = lhs.prefix?.name ?? '';
        final identifierName = lhs.identifier?.name ?? '';
        final localSlot = scope.lookup(prefixName);
        if (localSlot != null) {
          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(localSlot);
          final nameIdx = _pool.add(identifierName);
          buffer.emitOp(OpCode.storeField);
          buffer.emitU16(nameIdx);
        } else if (prefixName == 'this' && scope.lookup('this') != null) {
          final thisSlot = scope.lookup('this')!;
          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(thisSlot);
          final nameIdx = _pool.add(identifierName);
          buffer.emitOp(OpCode.storeField);
          buffer.emitU16(nameIdx);
        } else if (scope.lookup('this') != null &&
            !_knownClassNames.contains(prefixName) &&
            !_isPascalCase(prefixName)) {
          final thisSlot = scope.lookup('this')!;
          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(thisSlot);
          final prefixIdx = _pool.add(prefixName);
          buffer.emitOp(OpCode.loadField);
          buffer.emitU16(prefixIdx);
          final nameIdx = _pool.add(identifierName);
          buffer.emitOp(OpCode.storeField);
          buffer.emitU16(nameIdx);
        } else {
          final fullName = '$prefixName.$identifierName';
          final nameIdx = _pool.add(fullName);
          buffer.emitOp(OpCode.storeGlobal);
          buffer.emitU16(nameIdx);
        }
      } else if (lhs is SPropertyAccess) {
        if (lhs.target != null) {
          _compileExpression(lhs.target!, buffer, scope);
          final pName = lhs.propertyName?.name ?? '';
          final nameIdx = _pool.add(pName);
          buffer.emitOp(OpCode.storeField);
          buffer.emitU16(nameIdx);
        }
      }
    } else if (expr is SMethodInvocation) {
      final methodName = expr.methodName?.name ?? '';
      final argList = expr.argumentList?.arguments ?? const [];
      final (posArgs, namedArgs) = _splitArgs(argList);

      // 1. Direct constructor call without `new`/`const`: `NewWidget(...)`, `Container(...)`, `Text(...)`
      if (expr.target == null &&
          (_knownClassNames.contains(methodName) || _isPascalCase(methodName))) {
        for (final a in posArgs) {
          _compileExpression(a, buffer, scope);
        }
        for (final na in namedArgs) {
          final naName = na.name?.label?.name ?? '';
          final nameIdx = _pool.add(naName);
          buffer.emitOp(OpCode.pushConst);
          buffer.emitU16(nameIdx);
          if (na.expression != null) {
            _compileExpression(na.expression!, buffer, scope);
          } else {
            buffer.emitOp(OpCode.pushNull);
          }
        }
        final classConstIdx = _pool.add(methodName);
        final ctorConstIdx = _pool.add('new');
        buffer.emitOp(OpCode.callConstructor);
        buffer.emitU16(classConstIdx);
        buffer.emitU16(ctorConstIdx);
        buffer.emitU8(posArgs.length);
        buffer.emitU8(namedArgs.length);
      } else if (expr.target is SSimpleIdentifier &&
          scope.lookup((expr.target as SSimpleIdentifier).name) == null &&
          (_knownClassNames.contains((expr.target as SSimpleIdentifier).name) ||
              _isPascalCase((expr.target as SSimpleIdentifier).name))) {
        // 2. Named constructor or static constructor call: `EdgeInsets.all(...)`, `BorderRadius.circular(...)`
        final targetName = (expr.target as SSimpleIdentifier).name;
        for (final a in posArgs) {
          _compileExpression(a, buffer, scope);
        }
        for (final na in namedArgs) {
          final naName = na.name?.label?.name ?? '';
          final nameIdx = _pool.add(naName);
          buffer.emitOp(OpCode.pushConst);
          buffer.emitU16(nameIdx);
          if (na.expression != null) {
            _compileExpression(na.expression!, buffer, scope);
          } else {
            buffer.emitOp(OpCode.pushNull);
          }
        }
        final classConstIdx = _pool.add(targetName);
        final ctorConstIdx = _pool.add(methodName);
        buffer.emitOp(OpCode.callConstructor);
        buffer.emitU16(classConstIdx);
        buffer.emitU16(ctorConstIdx);
        buffer.emitU8(posArgs.length);
        buffer.emitU8(namedArgs.length);
      } else {
        if (expr.target == null) {
          // Check if target is a known local / this
          final thisSlot = scope.lookup('this');
          if (thisSlot != null) {
            buffer.emitOp(OpCode.loadLocal);
            buffer.emitU16(thisSlot);
          } else {
            buffer.emitOp(OpCode.pushNull);
          }
        } else {
          _compileExpression(expr.target!, buffer, scope);
        }

        // Compile positional arguments
        for (final a in posArgs) {
          _compileExpression(a, buffer, scope);
        }

        // Compile named arguments (push name string then value)
        for (final na in namedArgs) {
          final naName = na.name?.label?.name ?? '';
          final nameIdx = _pool.add(naName);
          buffer.emitOp(OpCode.pushConst);
          buffer.emitU16(nameIdx);
          if (na.expression != null) {
            _compileExpression(na.expression!, buffer, scope);
          } else {
            buffer.emitOp(OpCode.pushNull);
          }
        }

        final methodConstIdx = _pool.add(methodName);
        buffer.emitOp(OpCode.callMethod);
        buffer.emitU16(methodConstIdx);
        buffer.emitU8(posArgs.length);
        buffer.emitU8(namedArgs.length);
      }
    } else if (expr is SInstanceCreationExpression) {
      final className = expr.constructorName?.type?.name?.name ?? 'Object';
      final ctorSuffix = expr.constructorName?.name?.name ?? 'new';
      final argList = expr.argumentList?.arguments ?? const [];
      final (posArgs, namedArgs) = _splitArgs(argList);

      for (final a in posArgs) {
        _compileExpression(a, buffer, scope);
      }
      for (final na in namedArgs) {
        final naName = na.name?.label?.name ?? '';
        final nameIdx = _pool.add(naName);
        buffer.emitOp(OpCode.pushConst);
        buffer.emitU16(nameIdx);
        if (na.expression != null) {
          _compileExpression(na.expression!, buffer, scope);
        } else {
          buffer.emitOp(OpCode.pushNull);
        }
      }

      final classConstIdx = _pool.add(className);
      final ctorConstIdx = _pool.add(ctorSuffix);
      buffer.emitOp(OpCode.callConstructor);
      buffer.emitU16(classConstIdx);
      buffer.emitU16(ctorConstIdx);
      buffer.emitU8(posArgs.length);
      buffer.emitU8(namedArgs.length);
    } else if (expr is SListLiteral) {
      buffer.emitOp(OpCode.makeEmptyList);
      for (final el in expr.elements) {
        _compileCollectionElement(el, buffer, scope, isMap: false);
      }
    } else if (expr is SSetOrMapLiteral) {
      buffer.emitOp(OpCode.makeEmptyMap);
      for (final el in expr.elements) {
        _compileCollectionElement(el, buffer, scope, isMap: true);
      }
    } else if (expr is SConditionalExpression) {
      if (expr.condition != null) {
        _compileExpression(expr.condition!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushTrue);
      }
      final jumpFalsePos = buffer.emitJumpPlaceholder(OpCode.jumpIfFalse);
      if (expr.thenExpression != null) {
        _compileExpression(expr.thenExpression!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      final jumpOverElsePos = buffer.emitJumpPlaceholder(OpCode.jump);
      buffer.patchJump(jumpFalsePos);
      if (expr.elseExpression != null) {
        _compileExpression(expr.elseExpression!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      buffer.patchJump(jumpOverElsePos);
    } else if (expr is SParenthesizedExpression) {
      if (expr.expression != null) {
        _compileExpression(expr.expression!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
    } else if (expr is SPrefixedIdentifier) {
      final prefixName = expr.prefix?.name ?? '';
      final identifierName = expr.identifier?.name ?? '';
      final localSlot = scope.lookup(prefixName);
      if (localSlot != null) {
        buffer.emitOp(OpCode.loadLocal);
        buffer.emitU16(localSlot);
        final nameIdx = _pool.add(identifierName);
        buffer.emitOp(OpCode.loadField);
        buffer.emitU16(nameIdx);
      } else if (prefixName == 'this' && scope.lookup('this') != null) {
        final thisSlot = scope.lookup('this')!;
        buffer.emitOp(OpCode.loadLocal);
        buffer.emitU16(thisSlot);
        final nameIdx = _pool.add(identifierName);
        buffer.emitOp(OpCode.loadField);
        buffer.emitU16(nameIdx);
      } else if (scope.lookup('this') != null &&
          !_knownClassNames.contains(prefixName) &&
          !_isPascalCase(prefixName)) {
        final thisSlot = scope.lookup('this')!;
        buffer.emitOp(OpCode.loadLocal);
        buffer.emitU16(thisSlot);
        final prefixIdx = _pool.add(prefixName);
        buffer.emitOp(OpCode.loadField);
        buffer.emitU16(prefixIdx);
        final nameIdx = _pool.add(identifierName);
        buffer.emitOp(OpCode.loadField);
        buffer.emitU16(nameIdx);
      } else {
        final fullName = '$prefixName.$identifierName';
        final nameIdx = _pool.add(fullName);
        buffer.emitOp(OpCode.loadGlobal);
        buffer.emitU16(nameIdx);
      }
    } else if (expr is SPropertyAccess) {
      if (expr.target != null) {
        _compileExpression(expr.target!, buffer, scope);
        final pName = expr.propertyName?.name ?? '';
        final nameIdx = _pool.add(pName);
        buffer.emitOp(OpCode.loadField);
        buffer.emitU16(nameIdx);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
    } else if (expr is SIndexExpression) {
      if (expr.target != null) {
        _compileExpression(expr.target!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      if (expr.index != null) {
        _compileExpression(expr.index!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      buffer.emitOp(OpCode.loadIndex);
    } else if (expr is SFunctionExpression) {
      final closureId = _allocateFuncId('closure_${_nextClosureIndex++}');
      final hasThis = scope.lookup('this') != null;
      final fn = _compileFunction(
        id: closureId,
        name: 'closure',
        uri: '',
        enclosingClass: null,
        params: expr.parameters,
        body: expr.body,
        isMethod: hasThis,
      );
      _functions.add(fn);
      if (hasThis) {
        final thisSlot = scope.lookup('this')!;
        buffer.emitOp(OpCode.loadLocal);
        buffer.emitU16(thisSlot);
        buffer.emitOp(OpCode.makeClosure);
        buffer.emitU32(closureId);
        buffer.emitU16(1);
      } else {
        buffer.emitOp(OpCode.makeClosure);
        buffer.emitU32(closureId);
        buffer.emitU16(0);
      }
    } else if (expr is SAsExpression) {
      if (expr.expression != null) {
        _compileExpression(expr.expression!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
    } else if (expr is SIsExpression) {
      if (expr.expression != null) {
        _compileExpression(expr.expression!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      buffer.emitOp(expr.isNot ? OpCode.pushFalse : OpCode.pushTrue);
    } else {
      buffer.emitOp(OpCode.pushNull);
    }
  }

  void _compileCollectionElement(
    SCollectionElement element,
    _BytecodeBuffer buffer,
    _LocalScope scope, {
    required bool isMap,
  }) {
    if (element is SExpression) {
      _compileExpression(element, buffer, scope);
      buffer.emitOp(OpCode.listAdd);
    } else if (element is SMapLiteralEntry) {
      if (element.key != null) {
        _compileExpression(element.key!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      if (element.value != null) {
        _compileExpression(element.value!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushNull);
      }
      buffer.emitOp(OpCode.mapPut);
    } else if (element is SSpreadElement) {
      if (element.expression != null) {
        _compileExpression(element.expression!, buffer, scope);
        buffer.emitOp(isMap ? OpCode.mapPutAll : OpCode.listAddAll);
      }
    } else if (element is SIfElement) {
      if (element.condition != null) {
        _compileExpression(element.condition!, buffer, scope);
      } else {
        buffer.emitOp(OpCode.pushTrue);
      }
      final jumpFalsePos = buffer.emitJumpPlaceholder(OpCode.jumpIfFalse);
      if (element.thenElement != null) {
        _compileCollectionElement(element.thenElement!, buffer, scope, isMap: isMap);
      }
      if (element.elseElement != null) {
        final jumpOverElsePos = buffer.emitJumpPlaceholder(OpCode.jump);
        buffer.patchJump(jumpFalsePos);
        _compileCollectionElement(element.elseElement!, buffer, scope, isMap: isMap);
        buffer.patchJump(jumpOverElsePos);
      } else {
        buffer.patchJump(jumpFalsePos);
      }
    } else if (element is SForElement) {
      final loopParts = element.forLoopParts;
      if (loopParts is SForEachPartsWithDeclaration || loopParts is SForEachPartsWithIdentifier) {
        final iterableExpr = loopParts is SForEachPartsWithDeclaration
            ? loopParts.iterable
            : (loopParts as SForEachPartsWithIdentifier).iterable;
        final varName = loopParts is SForEachPartsWithDeclaration
            ? loopParts.loopVariable?.identifier?.name
            : (loopParts as SForEachPartsWithIdentifier).identifier?.name;

        if (iterableExpr != null && varName != null && element.body != null) {
          final iterSlot = scope.define('\$iter_${scope.maxSlots}');
          final idxSlot = scope.define('\$idx_${scope.maxSlots}');
          final elemSlot = scope.define(varName);

          _compileExpression(iterableExpr, buffer, scope);
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(iterSlot);

          buffer.emitOp(OpCode.pushInt);
          buffer.emitI32(0);
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(idxSlot);

          final loopStart = buffer.length;

          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(idxSlot);

          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(iterSlot);
          final lenIdx = _pool.add('length');
          buffer.emitOp(OpCode.loadField);
          buffer.emitU16(lenIdx);

          buffer.emitOp(OpCode.binaryOp);
          buffer.emitU8(BinaryOpId.lt);

          final exitJump = buffer.emitJumpPlaceholder(OpCode.jumpIfFalse);

          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(iterSlot);
          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(idxSlot);
          buffer.emitOp(OpCode.loadIndex);
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(elemSlot);

          _compileCollectionElement(element.body!, buffer, scope, isMap: isMap);

          buffer.emitOp(OpCode.loadLocal);
          buffer.emitU16(idxSlot);
          buffer.emitOp(OpCode.pushInt);
          buffer.emitI32(1);
          buffer.emitOp(OpCode.binaryOp);
          buffer.emitU8(BinaryOpId.add);
          buffer.emitOp(OpCode.storeLocal);
          buffer.emitU16(idxSlot);

          final loopJump = buffer.emitJumpPlaceholder(OpCode.jump);
          buffer.patchJump(loopJump, loopStart);
          buffer.patchJump(exitJump);
        }
      }
    }
  }

  (List<SExpression>, List<SNamedExpression>) _splitArgs(
    List<SCollectionElement> rawArgs,
  ) {
    final pos = <SExpression>[];
    final named = <SNamedExpression>[];
    for (final a in rawArgs) {
      if (a is SNamedExpression) {
        named.add(a);
      } else if (a is SExpression) {
        pos.add(a);
      }
    }
    return (pos, named);
  }

  int _resolveBinaryOpId(String op) => switch (op) {
    '+' => BinaryOpId.add,
    '-' => BinaryOpId.sub,
    '*' => BinaryOpId.mul,
    '/' => BinaryOpId.div,
    '~/' => BinaryOpId.truncDiv,
    '%' => BinaryOpId.mod,
    '==' => BinaryOpId.eq,
    '!=' => BinaryOpId.neq,
    '<' => BinaryOpId.lt,
    '<=' => BinaryOpId.lte,
    '>' => BinaryOpId.gt,
    '>=' => BinaryOpId.gte,
    '&' => BinaryOpId.bitAnd,
    '|' => BinaryOpId.bitOr,
    '^' => BinaryOpId.bitXor,
    '<<' => BinaryOpId.shl,
    '>>' => BinaryOpId.shr,
    _ => BinaryOpId.eq,
  };

  /// Computes a [BytecodeDelta] diff between [oldBundle] and [newBundle].
  static BytecodeDelta computeDelta({
    required BytecodeBundle oldBundle,
    required BytecodeBundle newBundle,
  }) {
    // 1. Check for structural changes (class added/removed or fields changed)
    final oldClasses = {for (final c in oldBundle.classes) c.name: c};
    final newClasses = {for (final c in newBundle.classes) c.name: c};

    bool hasStructuralChange = false;
    if (oldClasses.length != newClasses.length) {
      hasStructuralChange = true;
    } else {
      for (final entry in newClasses.entries) {
        final oldCls = oldClasses[entry.key];
        if (oldCls == null ||
            oldCls.fieldNames.length != entry.value.fieldNames.length ||
            !_listsEqual(oldCls.fieldNames, entry.value.fieldNames)) {
          hasStructuralChange = true;
          break;
        }
      }
    }

    // 2. Identify changed and new function bodies
    final oldFuncs = {for (final f in oldBundle.functions) f.id: f};
    final updatedFuncs = <BytecodeFunction>[];
    final dirtyClasses = <String>{};

    for (final newFn in newBundle.functions) {
      final oldFn = oldFuncs[newFn.id];
      if (oldFn == null || oldFn.contentHash != newFn.contentHash) {
        updatedFuncs.add(newFn);
        if (newFn.enclosingClass != null) {
          dirtyClasses.add(newFn.enclosingClass!);
        }
      }
    }

    // 3. Extract new constants
    final changedConstants = <int, Object?>{};
    for (
      var i = oldBundle.constantPool.length;
      i < newBundle.constantPool.length;
      i++
    ) {
      changedConstants[i] = newBundle.constantPool[i];
    }

    return BytecodeDelta(
      version: newBundle.version,
      changedConstants: changedConstants,
      updatedFunctions: updatedFuncs,
      dirtyClassNames: dirtyClasses,
      hasStructuralChange: hasStructuralChange,
    );
  }

  static bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

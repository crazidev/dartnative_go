import 'dart:typed_data';

/// Represents a parameter in a bytecode function definition.
class BytecodeParam {
  final String name;
  final int? defaultValueConstIndex;
  final bool isRequired;
  final bool isNamed;

  const BytecodeParam({
    required this.name,
    this.defaultValueConstIndex,
    this.isRequired = false,
    this.isNamed = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'default': defaultValueConstIndex,
        'required': isRequired,
        'named': isNamed,
      };

  factory BytecodeParam.fromJson(Map<String, dynamic> json) => BytecodeParam(
        name: json['name'] as String,
        defaultValueConstIndex: json['default'] as int?,
        isRequired: json['required'] as bool? ?? false,
        isNamed: json['named'] as bool? ?? false,
      );
}

/// Source mapping for stack traces and debug inspection.
class SourceMapEntry {
  final int pcOffset;
  final int line;
  final int column;

  const SourceMapEntry({
    required this.pcOffset,
    required this.line,
    required this.column,
  });

  Map<String, dynamic> toJson() => {
        'pc': pcOffset,
        'line': line,
        'col': column,
      };

  factory SourceMapEntry.fromJson(Map<String, dynamic> json) => SourceMapEntry(
        pcOffset: json['pc'] as int,
        line: json['line'] as int,
        column: json['col'] as int,
      );
}

/// Compiled bytecode function or method.
class BytecodeFunction {
  final int id;
  final String name;
  final String uri;
  final String? enclosingClass;
  final String contentHash;
  final int positionalParamCount;
  final List<BytecodeParam> namedParams;
  final int localSlotsCount;
  final Uint8List code;
  final List<SourceMapEntry> sourceMap;

  const BytecodeFunction({
    required this.id,
    required this.name,
    required this.uri,
    this.enclosingClass,
    this.contentHash = '',
    this.positionalParamCount = 0,
    this.namedParams = const [],
    this.localSlotsCount = 0,
    required this.code,
    this.sourceMap = const [],
  });

  String get qualifiedName =>
      enclosingClass != null ? '$enclosingClass.$name' : name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'uri': uri,
        if (enclosingClass != null) 'class': enclosingClass,
        'hash': contentHash,
        'posParams': positionalParamCount,
        'namedParams': namedParams.map((p) => p.toJson()).toList(),
        'slots': localSlotsCount,
        'code': code.toList(),
        'sourcemap': sourceMap.map((s) => s.toJson()).toList(),
      };

  factory BytecodeFunction.fromJson(Map<String, dynamic> json) =>
      BytecodeFunction(
        id: json['id'] as int,
        name: json['name'] as String,
        uri: json['uri'] as String,
        enclosingClass: json['class'] as String?,
        contentHash: json['hash'] as String,
        positionalParamCount: json['posParams'] as int? ?? 0,
        namedParams: (json['namedParams'] as List<dynamic>?)
                ?.map((p) => BytecodeParam.fromJson(p as Map<String, dynamic>))
                .toList() ??
            const [],
        localSlotsCount: json['slots'] as int? ?? 0,
        code: Uint8List.fromList((json['code'] as List<dynamic>).cast<int>()),
        sourceMap: (json['sourcemap'] as List<dynamic>?)
                ?.map(
                    (s) => SourceMapEntry.fromJson(s as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

/// Structural representation of an interpreted class.
class BytecodeClass {
  final String name;
  final String uri;
  final String? superclass;
  final List<String> fieldNames;
  final Map<String, int> methodFuncIds; // methodName -> funcId
  final Map<String, int> constructorFuncIds; // ctorName -> funcId

  const BytecodeClass({
    required this.name,
    required this.uri,
    this.superclass,
    this.fieldNames = const [],
    this.methodFuncIds = const {},
    this.constructorFuncIds = const {},
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'uri': uri,
        if (superclass != null) 'super': superclass,
        'fields': fieldNames,
        'methods': methodFuncIds,
        'constructors': constructorFuncIds,
      };

  factory BytecodeClass.fromJson(Map<String, dynamic> json) => BytecodeClass(
        name: json['name'] as String,
        uri: json['uri'] as String,
        superclass: json['super'] as String?,
        fieldNames: (json['fields'] as List<dynamic>?)?.cast<String>() ?? const [],
        methodFuncIds: (json['methods'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v as int),
            ) ??
            const {},
        constructorFuncIds:
            (json['constructors'] as Map<String, dynamic>?)?.map(
                  (k, v) => MapEntry(k, v as int),
                ) ??
                const {},
      );
}

/// Constant pool supporting literal values and identifiers.
class ConstantPool {
  final List<Object?> constants;

  const ConstantPool([this.constants = const []]);

  int get length => constants.length;

  Object? operator [](int index) =>
      (index >= 0 && index < constants.length) ? constants[index] : null;

  List<dynamic> toJson() => constants;

  factory ConstantPool.fromJson(List<dynamic> json) => ConstantPool(json);
}

/// Complete compiled application bytecode bundle.
class BytecodeBundle {
  static const int kCurrentVersion = 1;

  final int version;
  final String entryPointUri;
  final int entryPointFuncId;
  final int? initGlobalsFuncId;
  final ConstantPool constantPool;
  final List<BytecodeFunction> functions;
  final List<BytecodeClass> classes;
  final Map<String, dynamic> metadata;

  const BytecodeBundle({
    this.version = kCurrentVersion,
    required this.entryPointUri,
    required this.entryPointFuncId,
    this.initGlobalsFuncId,
    required this.constantPool,
    required this.functions,
    required this.classes,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'entryUri': entryPointUri,
        'entryFunc': entryPointFuncId,
        if (initGlobalsFuncId != null) 'initGlobals': initGlobalsFuncId,
        'constants': constantPool.toJson(),
        'functions': functions.map((f) => f.toJson()).toList(),
        'classes': classes.map((c) => c.toJson()).toList(),
        'metadata': metadata,
      };

  factory BytecodeBundle.fromJson(Map<String, dynamic> json) => BytecodeBundle(
        version: json['version'] as int? ?? kCurrentVersion,
        entryPointUri: json['entryUri'] as String,
        entryPointFuncId: json['entryFunc'] as int,
        initGlobalsFuncId: json['initGlobals'] as int?,
        constantPool: ConstantPool.fromJson(json['constants'] as List<dynamic>),
        functions: (json['functions'] as List<dynamic>)
            .map((f) => BytecodeFunction.fromJson(f as Map<String, dynamic>))
            .toList(),
        classes: (json['classes'] as List<dynamic>)
            .map((c) => BytecodeClass.fromJson(c as Map<String, dynamic>))
            .toList(),
        metadata:
            (json['metadata'] as Map<String, dynamic>?) ?? const <String, dynamic>{},
      );
}

/// Delta patch for Hot-Swapping function bodies.
class BytecodeDelta {
  final int version;
  final Map<int, Object?> changedConstants; // index -> constVal
  final List<BytecodeFunction> updatedFunctions;
  final Set<String> dirtyClassNames;
  final bool hasStructuralChange; // if true, trigger fallback full reload

  const BytecodeDelta({
    this.version = BytecodeBundle.kCurrentVersion,
    this.changedConstants = const {},
    required this.updatedFunctions,
    this.dirtyClassNames = const {},
    this.hasStructuralChange = false,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'constants':
            changedConstants.map((k, v) => MapEntry(k.toString(), v)),
        'functions': updatedFunctions.map((f) => f.toJson()).toList(),
        'dirtyClasses': dirtyClassNames.toList(),
        'structural': hasStructuralChange,
      };

  factory BytecodeDelta.fromJson(Map<String, dynamic> json) => BytecodeDelta(
        version: json['version'] as int? ?? BytecodeBundle.kCurrentVersion,
        changedConstants: (json['constants'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(int.parse(k), v),
            ) ??
            const {},
        updatedFunctions: (json['functions'] as List<dynamic>?)
                ?.map((f) =>
                    BytecodeFunction.fromJson(f as Map<String, dynamic>))
                .toList() ??
            const [],
        dirtyClassNames:
            (json['dirtyClasses'] as List<dynamic>?)?.cast<String>().toSet() ??
                const {},
        hasStructuralChange: json['structural'] as bool? ?? false,
      );
}

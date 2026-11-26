import 'package:tom_d4rt_ast/runtime.dart';

import 'declaration_registry.dart';
import 'frozen_name_map.dart';

/// Visitor for the first pass: Declares class and mixin placeholders.
///
/// This visitor traverses top-level declarations and creates empty
/// `InterpretedClass` instances (placeholders) in the global environment for
/// each class and mixin found. It does not resolve relationships (extends,
/// implements, with) nor does it process members.
class DeclarationVisitor extends GeneralizingSAstVisitor<void> {
  final Environment environment;

  /// Hot-reload declaration registry (Phase 4 registers class cells here so
  /// instances follow the reloaded class version). Null disables the mechanism.
  final DeclarationRegistry? declarationRegistry;

  /// Module URI the declarations being visited belong to; part of a class's
  /// cross-generation identity.
  final String moduleUri;

  DeclarationVisitor(
    this.environment, {
    this.declarationRegistry,
    this.moduleUri = '',
  });

  /// Binds a top-level class alias (`typedef <alias> = <Target>;`) in this
  /// module's environment, so a bare reference to `<alias>` — above all a
  /// constructor call `<alias>(...)` — resolves to `<Target>`.
  ///
  /// A typedef has no runtime representation, so the declaration pass is the
  /// only place it can be observed; without this, dio's `MultipartFile`
  /// constructors fail on `DioMediaType('application', 'octet-stream')`
  /// (`DioMediaType` is a top-level alias for `http_parser`'s `MediaType`).
  @override
  void visitTypedefDeclaration(STypedefDeclaration node) {
    final aliasName = node.name?.name;
    if (aliasName == null || aliasName.isEmpty) return;
    final type = node.type;
    if (type is! SNamedType) return; // Function/record typedef, not a rename.
    if (type.importPrefix != null) return;
    final args = type.typeArguments;
    if (args != null && args.arguments.isNotEmpty) return; // Generic alias.
    final targetName = type.name?.name;
    if (targetName == null || targetName.isEmpty) return;

    // Never shadow an existing binding, and never shadow a real declaration
    // that shares the alias name.
    if (!identical(environment.readBinding(aliasName), Environment.kNotFound)) {
      return;
    }
    environment.define(
      aliasName,
      GlobalGetter(() => environment.lookup(targetName)),
    );
  }

  @override
  void visitClassDeclaration(SClassDeclaration node) {
    final className = node.namePart.typeName.name;
    if (environment.isDefinedLocally(className) &&
        !environment.holdsImportedTypeDeclaration(className)) {
      return;
    }

    // Extract type parameter information
    final typeParameters = node.namePart.typeParameters;
    Environment? tempEnvironment;

    if (typeParameters != null) {
      Logger.debug(
        "[DeclarationVisitor.visitClassDeclaration] Class '$className' has ${typeParameters.typeParameters.length} type parameters",
      );

      // Create a temporary environment for type resolution
      tempEnvironment = Environment(enclosing: environment);

      // Create temporary type parameter placeholders
      for (final typeParam in typeParameters.typeParameters) {
        final paramName = typeParam.name?.name ?? '';
        final typeParamPlaceholder = TypeParameter(paramName);
        tempEnvironment.define(paramName, typeParamPlaceholder);

        Logger.debug(
          "[DeclarationVisitor.visitClassDeclaration]   Defined type parameter '$paramName' in temp environment",
        );
      }
    }

    // Use the temp environment (if any) for type resolution
    final resolveEnvironment = tempEnvironment ?? environment;

    // Extract type parameter names and bounds
    final typeParameterNames = InterpretedClass.extractTypeParameterNames(
      typeParameters,
    );
    final typeParameterBounds = InterpretedClass.extractTypeParameterBounds(
      typeParameters,
      resolveEnvironment,
      // SCE130: the placeholder pass runs before imports and type aliases, so
      // `class Box<T extends N>` through `typedef N = num` could not resolve
      // its bound here and threw. Pass 2 repairs the miss via
      // `resolveDeferredTypeParameterBounds`, and reports a bound that is
      // genuinely undefined.
      lenient: true,
    );

    // Create a placeholder for the class with the required positional arguments
    final placeholder = InterpretedClass(
      className, // name
      null, // superclass (initialized to null)
      environment, // classDefinitionEnvironment
      <SFieldDeclaration>[], // fieldDeclarations (initially empty)
      // Member tables use FrozenNameMap (perf T6): mutable while wiring, then
      // frozen via klass.freezeMemberTables() at the end of the Pass-2 loop.
      FrozenNameMap<InterpretedFunction>(), // methods
      FrozenNameMap<InterpretedFunction>(), // getters
      FrozenNameMap<InterpretedFunction>(), // setters
      FrozenNameMap<InterpretedFunction>(), // staticMethods
      FrozenNameMap<InterpretedFunction>(), // staticGetters
      FrozenNameMap<InterpretedFunction>(), // staticSetters
      <String, Object?>{}, // staticFields (deferred init — left mutable)
      FrozenNameMap<InterpretedFunction>(), // constructors
      FrozenNameMap<InterpretedFunction>(), // operators
      // Named parameters
      isAbstract: node.isAbstract,
      isMixin: node.isMixin, // 'mixin class' declaration
      interfaces: [], // Initially empty
      onClauseTypes: [], // Initially empty
      mixins: [], // Initially empty
      // Read modifiers from AST node
      isFinal: node.isFinal,
      isInterface: node.isInterface,
      isBase: node.isBase,
      isSealed: node.isSealed,
      // Add type parameter information
      typeParameterNames: typeParameterNames,
      typeParameterBounds: typeParameterBounds,
    );
    // Phase 4: attach the declaration's stable cell. The new class object is
    // published into it at the end of the Pass-2 wiring (see
    // InterpreterVisitor.visitClassDeclaration); until then instances keep
    // dispatching through the previous version.
    //
    // The shape check runs FIRST so a breaking edit (signature change or
    // removed member) retires the cell before it is looked up — instances built
    // before the edit then keep the previous class version and its call shapes,
    // while additive and body-only edits share the cell.
    placeholder.moduleUri = moduleUri;
    final registry = declarationRegistry;
    if (registry != null) {
      registry.reconcileClassShape(
        moduleUri,
        className,
        classMemberShapeKeys(node.body.members),
      );
      placeholder.classCell = registry.classCellFor(
        DeclarationKey(moduleUri, className, 'class'),
        placeholder,
      );
    }
    environment.define(className, placeholder);
    Logger.debug(
      "[DeclarationVisitor] Defined placeholder for class '$className' in env: [38;5;244m${environment.hashCode}[0m",
    );
  }

  @override
  void visitMixinDeclaration(SMixinDeclaration node) {
    final mixinName = node.name?.name ?? '';
    if (environment.isDefinedLocally(mixinName) &&
        !environment.holdsImportedTypeDeclaration(mixinName)) {
      return;
    }
    // Create a placeholder for the mixin with the required positional arguments
    final placeholder = InterpretedClass(
      mixinName, // name
      null, // superclass (null for pure mixins)
      environment, // classDefinitionEnvironment
      <SFieldDeclaration>[], // fieldDeclarations (initially empty)
      // Member tables use FrozenNameMap (perf T6): mutable while wiring, then
      // frozen via klass.freezeMemberTables() at the end of the Pass-2 loop.
      FrozenNameMap<InterpretedFunction>(), // methods
      FrozenNameMap<InterpretedFunction>(), // getters
      FrozenNameMap<InterpretedFunction>(), // setters
      FrozenNameMap<InterpretedFunction>(), // staticMethods
      FrozenNameMap<InterpretedFunction>(), // staticGetters
      FrozenNameMap<InterpretedFunction>(), // staticSetters
      <String, Object?>{}, // staticFields (deferred init — left mutable)
      FrozenNameMap<InterpretedFunction>(), // constructors (empty for mixins)
      FrozenNameMap<InterpretedFunction>(), // operators
      // Named parameters
      isAbstract: false, // Mixins are not abstract
      isMixin: true,
      interfaces: [], // Initially empty
      onClauseTypes: [], // Will be filled in pass 2
      mixins: [], // Initially empty (mixins cannot use 'with')
    );
    placeholder.moduleUri = moduleUri;
    final registry = declarationRegistry;
    if (registry != null) {
      registry.reconcileClassShape(
        moduleUri,
        mixinName,
        classMemberShapeKeys(node.body.members),
      );
      placeholder.classCell = registry.classCellFor(
        DeclarationKey(moduleUri, mixinName, 'class'),
        placeholder,
      );
    }
    environment.define(mixinName, placeholder);
    Logger.debug(
      "[DeclarationVisitor] Defined placeholder for mixin '$mixinName' in env: [38;5;244m${environment.hashCode}[0m",
    );
  }

  @override
  void visitEnumDeclaration(SEnumDeclaration node) {
    final enumName = node.namePart.typeName.name;
    if (environment.isDefinedLocally(enumName) &&
        !environment.holdsImportedTypeDeclaration(enumName)) {
      return;
    }

    // Extract constant names - needed for ordering later
    final valueNames = node.body.constants
        .map((c) => c.name?.name ?? '')
        .toList();

    // Constant names are part of the enum's shape: removing or reordering a
    // constant retires the preserved enum values (Phase 3c).
    final registry = declarationRegistry;
    if (registry != null) {
      registry.reconcileClassShape(moduleUri, enumName, {
        ...classMemberShapeKeys(node.body.members),
        for (final constant in node.body.constants)
          'const:${constant.name?.name ?? ''}',
      });
    }

    // Create the placeholder enum runtime object, storing only names for now
    final enumPlaceholder = InterpretedEnum.placeholder(
      enumName,
      environment,
      valueNames,
      // Part of the enum's cross-generation identity: without it a value
      // captured before a reload is not the same type as the reloaded enum.
      moduleUri: moduleUri.isEmpty ? null : moduleUri,
    );

    // Define the enum type placeholder in the current environment
    environment.define(enumName, enumPlaceholder);
    Logger.debug(
      "[DeclarationVisitor] Defined placeholder for enum '$enumName' with value order [${valueNames.join(', ')}] in env: [38;5;244m${environment.hashCode}[0m",
    );

    // Do NOT process members or constants here. That happens in Pass 2 (InterpreterVisitor).
  }

  // Ignore other declaration types in this pass
  @override
  void visitFunctionDeclaration(SFunctionDeclaration node) {
    final functionName = node.name?.name ?? '';
    Logger.debug(
      "[DeclarationVisitor.visitFunctionDeclaration] Processing function: $functionName",
    );

    if (environment.isDefinedLocally(functionName)) {
      return;
    }

    // Handle type parameters for generic functions
    Environment? tempEnvironment;
    final typeParameters = node.functionExpression?.typeParameters;

    if (typeParameters != null) {
      Logger.debug(
        "[DeclarationVisitor.visitFunctionDeclaration] Function '$functionName' has ${typeParameters.typeParameters.length} type parameters",
      );

      // Create a temporary environment for type resolution
      tempEnvironment = Environment(enclosing: environment);

      // Create temporary type parameter placeholders
      for (final typeParam in typeParameters.typeParameters) {
        final paramName = typeParam.name?.name ?? '';

        // Create a simple TypeParameter placeholder in the temp environment
        final typeParamPlaceholder = TypeParameter(paramName);
        tempEnvironment.define(paramName, typeParamPlaceholder);

        Logger.debug(
          "[DeclarationVisitor.visitFunctionDeclaration]   Defined type parameter '$paramName' in temp environment",
        );
      }
    }

    // Use the temp environment (if any) for type resolution, otherwise use the normal environment
    final resolveEnvironment = tempEnvironment ?? environment;

    // Now resolve the return type (which might reference type parameters)
    final returnTypeNode = node.returnType;
    RuntimeType declaredReturnType;

    if (returnTypeNode is SNamedType) {
      final typeName = returnTypeNode.name?.name ?? '';
      Logger.debug(
        "[DeclarationVisitor.visitFunctionDeclaration]   Return type node name: $typeName",
      );

      try {
        final resolvedType = resolveEnvironment.get(typeName);
        Logger.debug(
          "[DeclarationVisitor.visitFunctionDeclaration]     environment.get('$typeName') resolved to: ${resolvedType?.runtimeType} with name: ${(resolvedType is RuntimeType ? resolvedType.name : 'N/A')}",
        );

        if (resolvedType is RuntimeType) {
          declaredReturnType = resolvedType;
        } else {
          Logger.warn(
            "[DeclarationVisitor.visitFunctionDeclaration]     Type '$typeName' resolved to non-RuntimeType: $resolvedType. Using placeholder.",
          );
          declaredReturnType = BridgedClass(nativeType: Object, name: typeName);
        }
      } on RuntimeD4rtException catch (e) {
        Logger.warn(
          "[DeclarationVisitor.visitFunctionDeclaration]     Type '$typeName' not found in environment (RuntimeError: ${e.message}). Using placeholder.",
        );
        declaredReturnType = BridgedClass(nativeType: Object, name: typeName);
      }
    } else if (returnTypeNode == null) {
      declaredReturnType = BridgedClass(nativeType: Object, name: 'dynamic');
    } else {
      // For other TypeAnnotation types, use a generic placeholder
      declaredReturnType = BridgedClass(
        nativeType: Object,
        name: 'unknown_type_placeholder',
      );
    }

    bool isNullable =
        (returnTypeNode is SNamedType) && returnTypeNode.isNullable;

    // For async functions with Future<T?> return type, extract isNullable from inner type T
    final body0 = node.functionExpression?.body;
    bool isAsync = (body0 is SBlockFunctionBody)
        ? body0.isAsync
        : (body0 is SExpressionFunctionBody)
        ? body0.isAsync
        : false;
    if (isAsync &&
        !isNullable &&
        returnTypeNode is SNamedType &&
        returnTypeNode.name?.name == 'Future') {
      final typeArgs = returnTypeNode.typeArguments;
      if (typeArgs != null && typeArgs.arguments.isNotEmpty) {
        final innerType = typeArgs.arguments.first;
        if (innerType is SNamedType) {
          isNullable = innerType.isNullable;
        }
      }
    }

    final function = InterpretedFunction.declaration(
      node,
      environment, // The function captures the environment it's declared in
      declaredReturnType,
      isNullable,
      // SCE130: this is the PLACEHOLDER pass. The block above already
      // substitutes a placeholder for a return type the environment cannot
      // resolve yet, and says so in a log line; a type-parameter BOUND is the
      // same kind of forward reference and used to be the one thing here that
      // threw. It threw on `typedef N = num; T pick<T extends N>(T v)`,
      // because type aliases are registered in pass 2 — they must be, since an
      // alias may name a class whose placeholder this pass is still creating.
      // Pass 2 rebuilds this function from the same declaration once aliases
      // exist, and that build is strict, so the bound is still resolved and
      // still enforced, and a genuinely undefined bound still throws.
      lenientBounds: true,
    );
    Logger.debug(
      "[DeclarationVisitor.visitFunctionDeclaration]   Defining function '$functionName' with declaredReturnType: ${declaredReturnType.name} (Hash: ${declaredReturnType.hashCode})",
    );
    // SCF25: a setter is bound under its setter name, `v=`, so a getter and a
    // setter of one name no longer replace each other.
    environment.define(
      node.isSetter ? Environment.setterKey(functionName) : functionName,
      function,
    );
  }

  @override
  void visitTopLevelVariableDeclaration(STopLevelVariableDeclaration node) {
    // Does nothing for global variables in this pass (handled by InterpreterVisitor)
    for (final variable in node.variables?.variables ?? []) {
      final varName = variable.name?.name ?? '';
      if (varName == '_') {
        // Ignore wildcard variables
        continue;
      }
      // For now, just define the variable name with null.
      // The actual initialization will happen in InterpreterVisitor.
      if (!environment.isDefinedLocally(varName)) {
        environment.define(varName, null);
        Logger.debug(
          "[DeclarationVisitor] Defined top-level variable placeholder '$varName' in env: ${environment.hashCode}",
        );
      }
    }
  }

  // Add other visit... if needed to ignore other declaration types
}

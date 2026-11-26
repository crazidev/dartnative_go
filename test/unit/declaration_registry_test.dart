/// Unit coverage for the hot-reload declaration registry (Phase 2).
///
/// Pure data-model + cell tests: no `dart:ui`, no bundle execution. They pin
/// the registry decisions the AST runtime relies on:
///   1. same declaration key + same call shape  → same shell, swapped payload
///   2. same declaration key + different shape   → fresh shell (retirement)
///   3. structural class member edit             → every cell of that class dies
library;

import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart';

SMethodDeclaration _method(
  String name, {
  List<SFormalParameter> parameters = const [],
  bool isStatic = false,
}) {
  return SMethodDeclaration(
    offset: 0,
    length: 0,
    name: SSimpleIdentifier(offset: 0, length: 0, name: name),
    isStatic: isStatic,
    parameters: SFormalParameterList(
      offset: 0,
      length: 0,
      parameters: parameters,
    ),
    body: SBlockFunctionBody(offset: 0, length: 0),
  );
}

SFormalParameter _requiredPositional(String name) => SRegularFormalParameter(
  offset: 0,
  length: 0,
  name: SSimpleIdentifier(offset: 0, length: 0, name: name),
  isNamed: false,
  isRequired: true,
);

InterpretedFunction _function(Environment env, SMethodDeclaration method) =>
    InterpretedFunction.method(method, env, null);

void main() {
  group('FunctionCell', () {
    test('publish swaps payload, bumps version and re-points home', () {
      final envA = Environment();
      final envB = Environment();
      const key = DeclarationKey('pkg:a.dart', 'Counter#bump', 'method');
      final fnA = _function(envA, _method('bump'));
      final cell = FunctionCell(key, fnA.currentCode, home: envA)..attach(fnA);
      fnA.adoptCell(cell);
      cell.publish(fnA.currentCode, home: envA, generation: 1);

      expect(cell.current, same(fnA.currentCode));
      expect(cell.home, same(envA));
      expect(cell.version, 0);

      final fnB = _function(envB, _method('bump'));
      cell.publish(fnB.currentCode, home: envB, generation: 2);

      expect(cell.current, same(fnB.currentCode));
      expect(cell.current.generation, 2);
      expect(cell.home, same(envB));
      expect(cell.version, 1);
    });

    test('publish without a home keeps the previous environment', () {
      final envA = Environment();
      final fnA = _function(envA, _method('bump'));
      final cell = FunctionCell(
        const DeclarationKey('pkg:a.dart', 'f', 'function'),
        fnA.currentCode,
        home: envA,
      )..attach(fnA);
      fnA.adoptCell(cell);

      cell.publish(
        _function(Environment(), _method('bump')).currentCode,
        generation: 2,
      );

      expect(cell.home, same(envA));
      expect(cell.version, 1);
    });

    test('homeOrNull is null until a home is published', () {
      final fnA = _function(Environment(), _method('bump'));
      final cell = FunctionCell(
        const DeclarationKey('pkg:a.dart', 'f', 'function'),
        fnA.currentCode,
      )..attach(fnA);
      expect(cell.homeOrNull, isNull);
      expect(() => cell.home, throwsStateError);
    });
  });

  group('parameterShapeKey', () {
    test('encodes names, positions and arity', () {
      expect(parameterShapeKey(null), '()');
      expect(
        parameterShapeKey(
          SFormalParameterList(offset: 0, length: 0),
        ),
        '()',
      );
      final one = parameterShapeKey(
        SFormalParameterList(
          offset: 0,
          length: 0,
          parameters: [_requiredPositional('a')],
        ),
      );
      final sameOne = parameterShapeKey(
        SFormalParameterList(
          offset: 0,
          length: 0,
          parameters: [_requiredPositional('a')],
        ),
      );
      final renamed = parameterShapeKey(
        SFormalParameterList(
          offset: 0,
          length: 0,
          parameters: [_requiredPositional('b')],
        ),
      );
      expect(one, sameOne);
      expect(one, isNot(renamed));
      expect(one, isNot('()'));
    });
  });

  group('DeclarationRegistry.stabilizeFunction', () {
    test('first sighting registers the cell and returns that shell', () {
      final registry = DeclarationRegistry();
      const key = DeclarationKey('pkg:a.dart', 'Counter#bump', 'method');
      final env = Environment();
      final fn = _function(env, _method('bump'));

      final stable = registry.stabilizeFunction(key, fn, home: env);

      expect(stable, same(fn));
      expect(stable.codeCell, isNotNull);
      expect(registry.cellFor(key), same(stable.codeCell));
      expect(registry.stats['misses'], 1);
      expect(registry.stats['hits'], 0);
    });

    test('same shape returns the SAME shell and swaps the payload', () {
      final registry = DeclarationRegistry();
      const key = DeclarationKey('pkg:a.dart', 'Counter#bump', 'method');
      final envA = Environment();
      final envB = Environment();

      final first = registry.stabilizeFunction(
        key,
        _function(envA, _method('bump')),
        home: envA,
      );
      final freshSecond = _function(envB, _method('bump'));
      final second = registry.stabilizeFunction(key, freshSecond, home: envB);

      expect(
        second,
        same(first),
        reason: 'body-only edit keeps shell identity',
      );
      expect(second.currentCode, same(freshSecond.currentCode));
      expect(
        second.closure,
        same(envB),
        reason: 'new code resolves in the new env',
      );
      expect(second.codeCell!.version, 1);
      expect(registry.stats['hits'], 1);
      expect(registry.stats['swaps'], 1);
    });

    test('changed shape retires the cell and yields a fresh shell', () {
      final registry = DeclarationRegistry();
      const key = DeclarationKey('pkg:a.dart', 'Counter#bump', 'method');
      final envA = Environment();
      final envB = Environment();

      final first = registry.stabilizeFunction(
        key,
        _function(
          envA,
          _method('bump', parameters: [_requiredPositional('a')]),
        ),
        home: envA,
      );
      final second = registry.stabilizeFunction(
        key,
        _function(
          envB,
          _method(
            'bump',
            parameters: [_requiredPositional('a'), _requiredPositional('b')],
          ),
        ),
        home: envB,
      );

      expect(second, isNot(same(first)));
      expect(first.codeCell!.version, 0, reason: 'retired cell is frozen');
      expect(registry.stats['retirements'], 1);
    });

    test('retireClass drops only that class in that module', () {
      final registry = DeclarationRegistry();
      const counter = DeclarationKey('pkg:a.dart', 'Counter#bump', 'method');
      const other = DeclarationKey('pkg:a.dart', 'Other#bump', 'method');
      const sameNameOtherModule = DeclarationKey(
        'pkg:b.dart',
        'Counter#bump',
        'method',
      );
      final env = Environment();

      registry.stabilizeFunction(
        counter,
        _function(env, _method('bump')),
        home: env,
      );
      registry.stabilizeFunction(
        other,
        _function(env, _method('bump')),
        home: env,
      );
      registry.stabilizeFunction(
        sameNameOtherModule,
        _function(env, _method('bump')),
        home: env,
      );
      expect(registry.cellCount, 3);

      registry.retireClass('pkg:a.dart', 'Counter');

      expect(registry.cellCount, 2);
      expect(registry.cellFor(counter), isNull);
      expect(registry.cellFor(other), isNotNull);
      expect(registry.cellFor(sameNameOtherModule), isNotNull);
    });

    test('reconcileClassShape retires only on a breaking edit', () {
      final registry = DeclarationRegistry();
      const bump = DeclarationKey('pkg:a.dart', 'Counter#bump', 'method');
      final env = Environment();
      final shape = classMemberShapeKeys([_method('bump')]);
      final widerShape = classMemberShapeKeys([
        _method('bump'),
        _method('reset'),
      ]);

      registry.reconcileClassShape('pkg:a.dart', 'Counter', shape);
      registry.stabilizeFunction(
        bump,
        _function(env, _method('bump')),
        home: env,
      );
      expect(registry.cellCount, 1);

      // Same declared shape → cells survive (pure body edit).
      registry.reconcileClassShape('pkg:a.dart', 'Counter', shape);
      expect(registry.cellFor(bump), isNotNull);
      expect(registry.stats['retirements'], 0);

      // Added member → additive edit → the class survives (new members become
      // visible to existing instances).
      registry.reconcileClassShape('pkg:a.dart', 'Counter', widerShape);
      expect(registry.cellFor(bump), isNotNull);
      expect(registry.stats['retirements'], 0);

      // Re-typed member → breaking edit → every cell of the class dies.
      final retyped = classMemberShapeKeys([
        _method('bump', parameters: [_requiredPositional('a')]),
        _method('reset'),
      ]);
      registry.reconcileClassShape('pkg:a.dart', 'Counter', retyped);
      expect(registry.cellFor(bump), isNull);
      expect(registry.stats['retirements'], greaterThan(0));
    });

    test('member shape ignores bodies but not member sets', () {
      final v1 = classMemberShapeKeys([
        _method('bump', parameters: [_requiredPositional('a')]),
      ]);
      final v1Again = classMemberShapeKeys([
        _method('bump', parameters: [_requiredPositional('a')]),
      ]);
      final v2Retyped = classMemberShapeKeys([
        _method(
          'bump',
          parameters: [_requiredPositional('a'), _requiredPositional('b')],
        ),
      ]);
      final v2Renamed = classMemberShapeKeys([_method('nope')]);
      expect(v1, v1Again);
      expect(v1, isNot(v2Retyped));
      expect(v1, isNot(v2Renamed));
      expect(v2Renamed, isNot(v1));
    });

    test('clear drops cells and shape records', () {
      final registry = DeclarationRegistry();
      const key = DeclarationKey('pkg:a.dart', 'Counter#bump', 'method');
      final env = Environment();
      final shape = classMemberShapeKeys([_method('bump')]);
      registry.reconcileClassShape('pkg:a.dart', 'Counter', shape);
      registry.stabilizeFunction(
        key,
        _function(env, _method('bump')),
        home: env,
      );
      registry.beginGeneration();
      registry.beginGeneration();

      registry.clear();

      expect(registry.cellCount, 0);
      expect(registry.stats['generation'], 2);
      // Shape records are gone too: the next reconcile is a first sighting.
      registry.reconcileClassShape(
        'pkg:a.dart',
        'Counter',
        classMemberShapeKeys([_method('bump')]),
      );
      expect(registry.stats['retirements'], 0);
    });

    test('beginGeneration increments the generation counter', () {
      final registry = DeclarationRegistry();
      expect(registry.stats['generation'], 0);
      registry.beginGeneration();
      registry.beginGeneration();
      registry.beginGeneration();
      expect(registry.stats['generation'], 3);
    });
  });
}

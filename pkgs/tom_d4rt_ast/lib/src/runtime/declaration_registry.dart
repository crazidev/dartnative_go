import 'package:tom_d4rt_ast/runtime.dart';

/// Stable identity of a swappable declaration.
///
/// [moduleUri] scopes the name (so `a/foo.dart#Bar#baz` and
/// `b/foo.dart#Bar#baz` never collide), [qualifiedName] is either a top-level
/// name (`foo`) or a class-scoped member (`Bar#baz`, `Bar#new`,
/// `Bar#get value`), and [kind] separates the member tables that share a name
/// space (`method` / `getter` / `setter` / `constructor` / `operator`).
class DeclarationKey {
  final String moduleUri;
  final String qualifiedName;
  final String kind;

  const DeclarationKey(this.moduleUri, this.qualifiedName, this.kind);

  /// Key for declarations that are never registered (closures, bound copies):
  /// they are per-generation by nature, so their identity is irrelevant.
  static const DeclarationKey detached = DeclarationKey('', '', 'detached');

  /// The owning class name when this key addresses a class member.
  String? get ownerClassName {
    final hash = qualifiedName.indexOf('#');
    if (hash <= 0) return null;
    return qualifiedName.substring(0, hash);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeclarationKey &&
          other.moduleUri == moduleUri &&
          other.qualifiedName == qualifiedName &&
          other.kind == kind);

  @override
  int get hashCode => Object.hash(moduleUri, qualifiedName, kind);

  @override
  String toString() => 'DeclarationKey($moduleUri, $qualifiedName, $kind)';
}

/// Encodes the *call shape* of a parameter list: kinds, positions, optionality,
/// defaults and names. Two declarations with the same shape can share a
/// [FunctionCell] across generations; a different shape must not (callers,
/// native adapters and arity checks baked their view of the signature in).
String parameterShapeKey(SFormalParameterList? parameters) {
  final params = parameters?.parameters;
  if (params == null || params.isEmpty) return '()';
  final buffer = StringBuffer('(');
  for (final param in params) {
    buffer.write(_singleParameterShapeKey(param));
    buffer.write(',');
  }
  buffer.write(')');
  return buffer.toString();
}

String _singleParameterShapeKey(SAstNode param) {
  if (param is SDefaultFormalParameter) {
    final inner = param.parameter ?? param;
    return '${_simpleParameterShapeKey(inner)}'
        '${param.isNamed ? 'n' : 'p'}'
        '${param.isRequired ? 'r' : 'o'}'
        '${param.defaultValue != null ? 'd' : ''}';
  }
  return _simpleParameterShapeKey(param);
}

String _simpleParameterShapeKey(SAstNode param) {
  if (param is SSimpleFormalParameter) {
    return 's${param.isNamed ? 'n' : 'p'}'
        '${param.isRequired ? 'r' : 'o'}:${param.name?.name ?? ''}';
  }
  if (param is SFieldFormalParameter) {
    return 'f:${param.name?.name ?? ''}';
  }
  if (param is SSuperFormalParameter) {
    return 'u:${param.name?.name ?? ''}';
  }
  if (param is SFunctionTypedFormalParameter) {
    return 't:${param.name?.name ?? ''}';
  }
  return 'x';
}

/// Immutable payload for one generation of a function body.
///
/// Everything an [InterpretedFunction] needs in order to *execute* lives here;
/// the function object itself is a thin, stable shell that reads the current
/// payload from its [FunctionCell] on every access. Publishing a new
/// [FunctionCode] into a cell is therefore a body swap that every existing
/// reference (tear-offs, timers, stream listeners, class member tables) sees
/// immediately.
class FunctionCode {
  final SFormalParameterList? parameters;
  final SAstNode body;
  final String? name;
  final List<SAstNode>? constructorInitializers;
  final bool isInitializer;
  final bool isGetter;
  final bool isSetter;
  final bool isAbstract;
  final bool isAsync;
  final bool isGenerator;
  final bool isAsyncGenerator;
  final bool isFactory;
  final bool isNullable;
  final SConstructorName? redirectedFactoryTarget;
  final RuntimeType? ownerType;
  final RuntimeType? declaredReturnType;
  final AppliedRuntimeType? declaredReturnTypeApplied;
  final List<String> typeParameterNames;
  final Map<String, RuntimeType?> typeParameterBounds;

  /// Generation counter of the registry that published this payload. Purely
  /// diagnostic — it lets tests and the profiler tell which reload a body came
  /// from. Stamped by [FunctionCell.publish].
  int generation = 0;

  /// Structural function type cache. Stored per payload (not per shell) so a
  /// body swap can never leave a stale `T Function(...)` type behind.
  FunctionRuntimeType? cachedCallableRuntimeType;

  FunctionCode({
    required this.parameters,
    required this.body,
    required this.name,
    required this.constructorInitializers,
    required this.isInitializer,
    required this.isGetter,
    required this.isSetter,
    required this.isAbstract,
    required this.isAsync,
    required this.isGenerator,
    required this.isAsyncGenerator,
    required this.isFactory,
    required this.isNullable,
    required this.redirectedFactoryTarget,
    required this.ownerType,
    required this.declaredReturnType,
    required this.declaredReturnTypeApplied,
    required this.typeParameterNames,
    required this.typeParameterBounds,
  });

  /// Identity of the *callable shape*. Equal shapes may share a cell across
  /// generations; unequal shapes must get a fresh one.
  String? _cachedSignatureKey;
  String get signatureKey => _cachedSignatureKey ??= parameterShapeKey(parameters);
}

/// Stable, swappable holder for one function declaration.
///
/// The cell owns the current [FunctionCode] and the *current generation's*
/// home [Environment] for the declaration. Shells (the unbound function object
/// installed in class member tables / the module environment, plus every bound
/// copy produced by `bind()`) read both through the cell, so a publish is
/// visible to all of them at once.
class FunctionCell {
  final DeclarationKey key;
  FunctionCode _current;
  Environment? _home;

  /// The canonical unbound shell for this cell. Bound copies are transient and
  /// are not registered here.
  late InterpretedFunction shell;

  /// Number of successful publishes (body swaps) on this cell.
  int version = 0;

  FunctionCell(this.key, FunctionCode initial, {Environment? home})
    : _current = initial,
      _home = home;

  void attach(InterpretedFunction function) {
    shell = function;
  }

  FunctionCode get current => _current;

  /// The environment newly published code must resolve names in.
  ///
  /// Throws only for a cell that was never given a home — the registry always
  /// supplies one, and [homeOrNull] is the defensive accessor used on read
  /// paths.
  Environment get home {
    final env = _home;
    if (env == null) {
      throw StateError('FunctionCell $key has no home environment');
    }
    return env;
  }

  Environment? get homeOrNull => _home;

  String get signatureKey => _current.signatureKey;

  /// Swaps in [next] as the executable payload, re-points the home environment
  /// at the generation that produced it, and stamps the payload with
  /// [generation] for diagnostics.
  /// Restores a previously captured state (rollback of a failed generation).
  void restore(
    FunctionCode code, {
    Environment? home,
    required int version,
    int? generation,
  }) {
    _current = code;
    if (generation != null) code.generation = generation;
    _home = home;
    this.version = version;
  }

  void publish(FunctionCode next, {Environment? home, int? generation}) {
    if (generation != null) next.generation = generation;
    if (!identical(next, _current)) {
      _current = next;
      version++;
    }
    if (home != null) _home = home;
  }
}

/// Stable storage slot for one variable declaration (Phase 3).
///
/// A cell replaces the raw map entry a top-level variable, static field or enum
/// constant would otherwise occupy, which buys three things:
///
/// * **Reload keeps the value.** A new generation re-uses the cell and only
///   re-runs the initializer when the initializer expression actually changed —
///   the Dart VM hot-reload rule. Unchanged initializers keep whatever the
///   running program had put there.
/// * **Cross-generation aliasing.** Every environment that imports the
///   declaration (module env, exported env, prefixed import) shares the same
///   cell, so a reload cannot leave one frame looking at a stale copy.
/// * **Declaration flags.** `late` (lazy first read, `LateInitializationError`
///   when read too early), `final` (second write throws) and `const` are
///   enforced for top-levels, which the raw-value path ignored entirely.
class VariableCell {
  final String name;

  /// Storage. For a `late` declaration this holds the value only after the
  /// first read/write; [_initializer] is evaluated on demand.
  Object? _value;

  bool _initialized;

  /// Evaluates the current generation's initializer the first time the cell is
  /// read. Replaced (not re-run) when a reload changes the initializer.
  Object? Function()? _initializer;

  /// Initializer AST of the generation that produced this cell. Compared
  /// structurally across generations to decide keep-vs-reinitialize.
  SAstNode? _initializerNode;

  /// Offset-free canonical form of [_initializerNode], used for the
  /// keep-vs-reinitialize comparison. `SAstNode.equals` includes `offset` /
  /// `length`, so an edit anywhere earlier in the file would make every later
  /// initializer compare unequal and needlessly reset live state.
  String? _initializerKey;

  final bool isFinal;
  final bool isConst;
  final bool isLate;

  /// Generation that last wrote [_value]. Diagnostics only.
  int generation = 0;

  VariableCell(
    this.name, {
    Object? initialValue,
    bool initialized = true,
    Object? Function()? initializer,
    SAstNode? initializerNode,
    this.isFinal = false,
    this.isConst = false,
    this.isLate = false,
  }) : _value = initialValue,
       _initialized = initialized || initialValue != null,
       _initializer = initializer,
       _initializerNode = initializerNode,
       _initializerKey = canonicalInitializerKey(initializerNode);

  bool get isInitialized => _initialized;

  Object? get rawValue => _value;

  /// Initializer AST of the generation that produced this cell.
  SAstNode? get initializerNode => _initializerNode;

  /// Offset-free canonical key of the current initializer (null when the
  /// declaration has no initializer). Diagnostics / tests only.
  String? get initializerKey => _initializerKey;

  /// The lazy initializer currently installed (null when the declaration is
  /// eager or has no initializer).
  Object? Function()? get initializer => _initializer;

  /// Restores a previously captured state (rollback of a failed generation).
  void restore({
    Object? value,
    required bool initialized,
    Object? Function()? initializer,
    SAstNode? initializerNode,
    String? initializerKey,
  }) {
    _value = value;
    _initialized = initialized;
    if (initializer != null) _initializer = initializer;
    _initializerNode = initializerNode ?? _initializerNode;
    if (initializerKey != null) _initializerKey = initializerKey;
  }

  bool get hasInitializer => _initializer != null || _initializerNode != null;

  /// Reads the value, lazily initializing a `late` declaration.
  Object? read() {
    if (!_initialized) {
      final initializer = _initializer;
      if (initializer != null) {
        _value = initializer();
        _initialized = true;
        return _value;
      }
      if (isLate) {
        throw LateInitializationError(
          "LateInitializationError: Late variable '$name' without initializer "
          "is accessed before being assigned.",
        );
      }
    }
    return _value;
  }

  /// Writes [next]. Throws on a second write to a `final` cell, matching Dart.
  void write(Object? next) {
    if (isFinal && _initialized) {
      throw RuntimeD4rtException(
        "The final variable '$name' has already been assigned.",
      );
    }
    _value = next;
    _initialized = true;
  }

  /// Unconditional write used by the declaration pass (initializer evaluation
  /// and the keep-or-reinitialize decision) — bypasses the `final` guard,
  /// because running the declaration's own initializer is not an assignment.
  void setFromInitializer(Object? next) {
    _value = next;
    _initialized = true;
  }

  /// Adopts the initializer of a new generation without running it.
  ///
  /// Returns true when the stored value was kept — i.e. the declaration has no
  /// initializer in either generation, or its canonical (offset-free) form is
  /// unchanged. Returns false when the cell was reset, in which case the caller
  /// must evaluate the new initializer.
  bool adoptInitializer(
    Object? Function() initializer,
    SAstNode? initializerNode,
  ) {
    final previousKey = _initializerKey;
    final nextKey = canonicalInitializerKey(initializerNode);
    final same = previousKey != null && nextKey != null
        ? previousKey == nextKey
        : previousKey == null && nextKey == null;
    _initializer = initializer;
    _initializerNode = initializerNode;
    _initializerKey = nextKey;
    if (same) return true;
    _initialized = false;
    _value = null;
    return false;
  }

  /// Evaluates the adopted initializer now and stores the result.
  void runInitializer() {
    final initializer = _initializer;
    if (initializer == null) {
      _initialized = true;
      return;
    }
    _value = initializer();
    _initialized = true;
  }

  /// Drops the stored value so the next read re-runs the initializer.
  void invalidate() {
    _initialized = false;
    _value = null;
  }

  @override
  String toString() =>
      'VariableCell($name, initialized: $_initialized, value: $_value)';
}

/// Offset-free canonical form of an initializer expression, used to decide
/// whether a reload changed it.
///
/// Fast structural hasher: walks the node's JSON map directly without allocating
/// intermediate stripped Maps/Lists or running `jsonEncode`. Returns an FNV-1a
/// 64-bit hex string.
String? canonicalInitializerKey(SAstNode? node) {
  if (node == null) return null;
  try {
    return _computeNodeStructuralHash(node.toJson()).toRadixString(16);
  } catch (_) {
    return null;
  }
}

int _computeNodeStructuralHash(Object? value) {
  var hash = 0xcbf29ce484222325;
  const prime = 0x100000001b3;

  void addByte(int b) {
    hash ^= b;
    hash = (hash * prime) & 0xFFFFFFFFFFFFFFFF;
  }

  void addString(String s) {
    for (final c in s.codeUnits) {
      addByte(c & 0xFF);
      addByte((c >> 8) & 0xFF);
    }
  }

  void walk(Object? v) {
    if (v == null) {
      addByte(0);
      return;
    }
    if (v is Map) {
      addByte(1);
      final keys = v.keys.map((k) => k.toString()).toList()..sort();
      for (final key in keys) {
        if (key == 'offset' || key == 'length') continue;
        addString(key);
        walk(v[key]);
      }
    } else if (v is List) {
      addByte(2);
      addByte(v.length & 0xFF);
      for (final item in v) {
        walk(item);
      }
    } else if (v is String) {
      addByte(3);
      addString(v);
    } else if (v is int) {
      addByte(4);
      addByte(v & 0xFF);
      addByte((v >> 8) & 0xFF);
      addByte((v >> 16) & 0xFF);
      addByte((v >> 24) & 0xFF);
    } else if (v is double) {
      addByte(5);
      addString(v.toString());
    } else if (v is bool) {
      addByte(6);
      addByte(v ? 1 : 0);
    } else {
      addByte(7);
      addString(v.toString());
    }
  }

  walk(value);
  return hash;
}

/// Stable holder for one class declaration across hot-reload generations
/// (Phase 4).
///
/// Every generation builds a fresh [InterpretedClass] (member tables are frozen
/// after wiring, so a class object cannot be re-wired in place) and publishes it
/// here once it is fully wired. Instances created in ANY generation read their
/// class through this cell, so an object built before a reload dispatches to
/// the reloaded class: new methods appear, edited bodies run, and `is` / `as`
/// against the reloaded type succeed.
class ClassCell {
  final DeclarationKey key;

  InterpretedClass? _current;

  /// Incremented on every publish. Diagnostics only.
  int version = 0;

  ClassCell(this.key, InterpretedClass initial) : _current = initial;

  InterpretedClass get current {
    final klass = _current;
    if (klass == null) {
      throw StateError('ClassCell $key has no published class');
    }
    return klass;
  }

  bool get hasCurrent => _current != null;

  /// Restores a previously captured state (rollback of a failed generation).
  void restore(InterpretedClass previous, int previousVersion) {
    _current = previous;
    version = previousVersion;
  }

  /// Drops the published class (rollback of a registration).
  void clear() {
    _current = null;
  }

  /// Publishes [next] as the current version of the declaration.
  void publish(InterpretedClass next) {
    if (identical(next, _current)) return;
    _current = next;
    version++;
  }

  @override
  String toString() =>
      'ClassCell($key, version: $version, current: ${_current?.name})';
}

/// One cached module plus the content fingerprint it was built from.
class _CachedModule {
  final String fingerprint;
  final Object module;

  _CachedModule(this.fingerprint, this.module);
}

/// Declaration registry for state-preserving hot reload.
///
/// Owned by the embedder (one per app session, cleared on restart / unmount)
/// and handed to the runtime so both declaration passes can resolve a
/// declaration to the *same* function object across bundle generations:
///
/// * **cell hit, same signature** → publish the new body into the existing
///   cell and reuse the existing shell. Every live reference (instances,
///   tear-offs, native callbacks) now executes the new code.
/// * **cell miss** → register the fresh function as the canonical shell.
/// * **cell hit, different signature** → retire the cell (the new declaration
///   gets a fresh shell) so in-flight callers keep calling the old shape.
/// * **structural class edit** (member added/removed/renamed/retyped) → retire
///   every cell of that class, because live instances of the previous class
///   version cannot satisfy a changed shape.
class DeclarationRegistry {
  final Map<DeclarationKey, FunctionCell> _cells = {};
  final Map<String, Set<String>> _classMemberShapes = {};
  final Map<String, Set<DeclarationKey>> _classFunctionKeys = {};
  final Map<String, Set<DeclarationKey>> _classVariableKeys = {};

  /// Incremented once per evaluated generation; stamped onto published code.
  int generation = 0;

  /// Undo actions for the in-flight generation, in application order.
  ///
  /// A generation publishes function bodies, variable storage and class
  /// versions while it wires declarations. If evaluation then throws, the
  /// runner replays this journal in reverse so the previous generation's
  /// semantics are restored exactly — a half-applied reload would otherwise
  /// leave live objects (the still-mounted previous widget tree) calling into
  /// a mixture of old and new code.
  final List<void Function()> _journal = [];

  /// True while a generation is in flight (between [beginGeneration] and
  /// [commitGeneration] / [rollbackGeneration]).
  bool get hasOpenGeneration => _journalOpen;
  bool _journalOpen = false;

  /// Records [undo] to run if the in-flight generation is rolled back.
  void journalUndo(void Function() undo) {
    if (_journalOpen) _journal.add(undo);
  }

  /// Starts a new generation and opens the rollback journal.
  void beginGeneration() {
    generation++;
    _journal.clear();
    _journalOpen = true;
  }

  /// Accepts the in-flight generation: its publications become the new
  /// baseline and the journal is dropped.
  void commitGeneration() {
    _journal.clear();
    _journalOpen = false;
  }

  /// Restores the previous generation by replaying the journal in reverse.
  ///
  /// Undo actions are isolated: one failing action must not prevent the rest of
  /// the rollback, or the runtime would be left in a mixed state.
  void rollbackGeneration() {
    for (final undo in _journal.reversed) {
      try {
        undo();
      } catch (e) {
        Logger.warn('[DeclarationRegistry] rollback action failed: $e');
      }
    }
    _journal.clear();
    _journalOpen = false;
  }

  int hits = 0;
  int misses = 0;
  int swaps = 0;
  int retirements = 0;

  /// Records the declared member shape of a class and retires its cells when
  /// the edit was **breaking** since the previous generation.
  ///
  /// [memberKeys] describes every declared member (name, kind, static /
  /// abstract flags and call shape) but NOT their bodies. The class survives —
  /// keeping its cell, so existing instances dispatch through the reloaded
  /// class — when the new declarations are a superset of the previous ones:
  ///
  /// * body edit → superset → cells kept, bodies swapped (Phase 2)
  /// * member added → superset → cells kept, new members become visible to
  ///   instances that already exist
  /// * signature changed / member removed → not a superset → the class cell and
  ///   the class's function cells are retired, so instances created before the
  ///   edit keep the previous class version and its call shapes
  void reconcileClassShape(
    String moduleUri,
    String className,
    Set<String> memberKeys,
  ) {
    final classKey = '$moduleUri#$className';
    final previous = _classMemberShapes[classKey];
    if (previous != null && !previous.every(memberKeys.contains)) {
      retireClass(moduleUri, className);
    }
    _classMemberShapes[classKey] = memberKeys;
  }

  /// Drops every function cell owned by [className] in [moduleUri].
  ///
  /// Only function cells: variable storage is retired per declaration (see
  /// [retireMissingVariables]) because adding a static field must NOT reset the
  /// state of the statics that survived the edit.
  void retireClass(String moduleUri, String className) {
    _classCells.remove(
      DeclarationKey(moduleUri, className, 'class'),
    );
    final classKey = '$moduleUri#$className';
    final memberKeys = _classFunctionKeys.remove(classKey);
    if (memberKeys != null && memberKeys.isNotEmpty) {
      for (final key in memberKeys) {
        _cells.remove(key);
      }
      retirements += memberKeys.length;
    } else {
      final prefix = '$className#';
      final stale = _cells.keys
          .where(
            (k) => k.moduleUri == moduleUri && k.qualifiedName.startsWith(prefix),
          )
          .toList();
      for (final key in stale) {
        _cells.remove(key);
      }
      if (stale.isNotEmpty) retirements += stale.length;
    }
  }

  /// Drops the variable cells of [className] in [moduleUri] whose member name
  /// is no longer declared, or whose declaration flags changed.
  ///
  /// [declaredNames] maps member name → `isFinal|isConst|isLate` fingerprint.
  void retireMissingVariables(
    String moduleUri,
    String className,
    String kind,
    Map<String, String> declaredNames,
  ) {
    final classKey = '$moduleUri#$className';
    final memberKeys = _classVariableKeys[classKey];
    final prefix = '$className#';
    final stale = <DeclarationKey>[];
    final candidates = memberKeys != null ? List<DeclarationKey>.of(memberKeys) : _variableCells.keys.toList();
    for (final key in candidates) {
      if (key.moduleUri != moduleUri ||
          key.kind != kind ||
          !key.qualifiedName.startsWith(prefix)) {
        continue;
      }
      final cell = _variableCells[key];
      if (cell == null) continue;
      final member = key.qualifiedName.substring(prefix.length);
      final fingerprint = declaredNames[member];
      final current = '${cell.isFinal}|${cell.isConst}|${cell.isLate}';
      if (fingerprint == null || fingerprint != current) {
        stale.add(key);
      }
    }
    for (final key in stale) {
      _variableCells.remove(key);
      memberKeys?.remove(key);
    }
    if (stale.isNotEmpty) retirements += stale.length;
  }

  /// Resolves [fresh] to the shell that should be installed for [key].
  ///
  /// [fresh] is the function object the current generation just built; [home]
  /// is the environment its code must resolve names in (the current module or
  /// class-definition environment).
  InterpretedFunction stabilizeFunction(
    DeclarationKey key,
    InterpretedFunction fresh, {
    Environment? home,
  }) {
    final existing = _cells[key];
    final owner = key.ownerClassName;
    if (existing == null) {
      final cell = FunctionCell(key, fresh.currentCode);
      fresh.adoptCell(cell);
      cell.publish(fresh.currentCode, home: home, generation: generation);
      _cells[key] = cell;
      if (owner != null) {
        _classFunctionKeys.putIfAbsent('${key.moduleUri}#$owner', () => {}).add(key);
      }
      misses++;
      return fresh;
    }
    if (existing.signatureKey != fresh.signatureKey) {
      // Different call shape: the new declaration gets its own shell so
      // in-flight callers of the old shape keep a coherent signature.
      final cell = FunctionCell(key, fresh.currentCode);
      fresh.adoptCell(cell);
      cell.publish(fresh.currentCode, home: home, generation: generation);
      _cells[key] = cell;
      if (owner != null) {
        _classFunctionKeys.putIfAbsent('${key.moduleUri}#$owner', () => {}).add(key);
      }
      retirements++;
      return fresh;
    }
    final previousCode = existing.current;
    final previousHome = existing.homeOrNull;
    final previousVersion = existing.version;
    final previousGeneration = previousCode.generation;
    journalUndo(() {
      existing.restore(
        previousCode,
        home: previousHome,
        version: previousVersion,
        generation: previousGeneration,
      );
    });
    existing.publish(
      fresh.currentCode,
      home: home,
      generation: generation,
    );
    hits++;
    swaps++;
    return existing.shell;
  }

  /// Live cell for [key], or null. Diagnostics / tests only.
  FunctionCell? cellFor(DeclarationKey key) => _cells[key];

  final Map<DeclarationKey, VariableCell> _variableCells = {};
  final Map<DeclarationKey, ClassCell> _classCells = {};

  /// Loaded bundle modules, keyed by module URI (Phase 5).
  ///
  /// A module whose content fingerprint is unchanged **since the previous
  /// generation** is not re-declared: its [LoadedModule] (with its environment,
  /// classes and functions) is reused as-is. That is safe because every mutable
  /// piece of a module's state lives in a registry cell, which the new
  /// generation shares.
  ///
  /// The stored fingerprint is the one from the *last* generation that loaded
  /// the module, never any historical value: a module whose content is edited
  /// and then reverted to a previously seen fingerprint MUST be re-declared,
  /// because the cells currently hold the newer generation's code. Matching
  /// against any historical fingerprint would silently resurrect the stale
  /// module while the cells stayed ahead of it.
  final Map<String, _CachedModule> _moduleCache = {};

  /// Records a loaded module for potential reuse in the next generation.
  void cacheModule(String uri, String? fingerprint, Object module) {
    if (fingerprint == null || fingerprint.isEmpty) return;
    final previous = _moduleCache[uri];
    journalUndo(() {
      if (previous == null) {
        _moduleCache.remove(uri);
      } else {
        _moduleCache[uri] = previous;
      }
    });
    _moduleCache[uri] = _CachedModule(fingerprint, module);
  }

  /// The module loaded for [uri] in the previous generation, when the content
  /// fingerprint still matches.
  Object? cachedModule(String uri, String? fingerprint) {
    if (fingerprint == null || fingerprint.isEmpty) return null;
    final entry = _moduleCache[uri];
    if (entry == null || entry.fingerprint != fingerprint) return null;
    return entry.module;
  }

  /// Number of cached modules. Diagnostics / tests only.
  int get moduleCacheCount => _moduleCache.length;

  /// Live cell for a top-level / static variable [key], or null.
  VariableCell? variableCellFor(DeclarationKey key) => _variableCells[key];

  /// Number of registered variable cells. Diagnostics / tests only.
  int get variableCellCount => _variableCells.length;

  /// Number of registered class cells. Diagnostics / tests only.
  int get classCellCount => _classCells.length;

  /// Returns the stable class cell for [key], creating it with [initial] the
  /// first time the declaration is seen.
  ClassCell classCellFor(
    DeclarationKey key,
    InterpretedClass initial,
  ) {
    final existing = _classCells[key];
    if (existing != null) return existing;
    final cell = ClassCell(key, initial);
    _classCells[key] = cell;
    journalUndo(() => _classCells.remove(key));
    misses++;
    return cell;
  }

  /// Registers [cell] as the stable storage for [key] (first generation).
  void registerVariable(DeclarationKey key, VariableCell cell) {
    _variableCells[key] = cell;
    final owner = key.ownerClassName;
    if (owner != null) {
      _classVariableKeys.putIfAbsent('${key.moduleUri}#$owner', () => {}).add(key);
    }
    journalUndo(() {
      _variableCells.remove(key);
      if (owner != null) {
        _classVariableKeys['${key.moduleUri}#$owner']?.remove(key);
      }
    });
    misses++;
  }

  /// Runs [initializer] and stores the result in [key]'s cell as the
  /// generation's initializer value. Journals the previous state so a failed
  /// generation restores it.
  void setVariableFromInitializer(DeclarationKey key, Object? value) {
    final cell = _variableCells[key];
    if (cell == null) return;
    final previousValue = cell.rawValue;
    final previousInitialized = cell.isInitialized;
    journalUndo(() {
      cell.restore(
        value: previousValue,
        initialized: previousInitialized,
      );
    });
    cell.setFromInitializer(value);
  }

  /// Adopts a new `late` initializer into [key]'s cell, journalling the
  /// previous one.
  void adoptLateInitializer(
    DeclarationKey key,
    Object? Function() initializer,
    SAstNode? initializerNode,
  ) {
    final cell = _variableCells[key];
    if (cell == null) return;
    final previousInitializer = cell.initializerNode;
    final previousKey = cell.initializerKey;
    final previousValue = cell.rawValue;
    final previousInitialized = cell.isInitialized;
    journalUndo(() {
      cell.restore(
        value: previousValue,
        initialized: previousInitialized,
        initializerNode: previousInitializer,
        initializerKey: previousKey,
      );
    });
    cell.adoptInitializer(initializer, initializerNode);
  }

  /// Publishes [klass] as the current version of its class declaration.
  void publishClass(InterpretedClass klass) {
    final cell = klass.classCell;
    if (cell == null) return;
    if (!cell.hasCurrent) {
      journalUndo(() => cell.clear());
      cell.publish(klass);
      return;
    }
    final previous = cell.current;
    final previousVersion = cell.version;
    journalUndo(() {
      cell.restore(previous, previousVersion);
    });
    cell.publish(klass);
  }

  /// Adopts [initializer] / [initializerNode] from a new generation into
  /// [key]'s cell and reports whether the stored value survived.
  ///
  /// Returns true when the cell kept its value (initializer unchanged), false
  /// when it was invalidated and must be re-evaluated.
  bool adoptVariableInitializer(
    DeclarationKey key,
    Object? Function() initializer,
    SAstNode? initializerNode,
  ) {
    final cell = _variableCells[key];
    if (cell == null) return false;
    final kept = cell.adoptInitializer(initializer, initializerNode);
    if (!kept) swaps++;
    return kept;
  }

  /// Drops the variable cell registered for [key].
  void retireVariable(DeclarationKey key) {
    _variableCells.remove(key);
    final owner = key.ownerClassName;
    if (owner != null) {
      _classVariableKeys['${key.moduleUri}#$owner']?.remove(key);
    }
  }

  /// Drops every variable cell whose key is owned by [className] in [moduleUri].
  void retireClassVariables(String moduleUri, String className) {
    final classKey = '$moduleUri#$className';
    final memberKeys = _classVariableKeys.remove(classKey);
    if (memberKeys != null && memberKeys.isNotEmpty) {
      for (final key in memberKeys) {
        _variableCells.remove(key);
      }
      retirements += memberKeys.length;
    } else {
      final prefix = '$className#';
      final stale = _variableCells.keys
          .where(
            (k) => k.moduleUri == moduleUri && k.qualifiedName.startsWith(prefix),
          )
          .toList();
      for (final key in stale) {
        _variableCells.remove(key);
      }
      if (stale.isNotEmpty) retirements += stale.length;
    }
  }

  /// Registered keys. Diagnostics / tests only.
  Iterable<DeclarationKey> get keys => _cells.keys;

  /// Number of registered cells. Diagnostics / tests only.
  int get cellCount => _cells.length;

  /// Drops every declaration. Call on hot restart, runtime-mode switch and
  /// unmount — never on hot reload.
  void clear() {
    _cells.clear();
    _variableCells.clear();
    _classCells.clear();
    _moduleCache.clear();
    _classMemberShapes.clear();
    _classFunctionKeys.clear();
    _classVariableKeys.clear();
  }

  /// Counters for host-visible diagnostics.
  Map<String, int> get stats => {
    'generation': generation,
    'cells': _cells.length,
    'var_cells': _variableCells.length,
    'class_cells': _classCells.length,
    'modules': _moduleCache.length,
    'hits': hits,
    'misses': misses,
    'swaps': swaps,
    'retirements': retirements,
  };
}

/// Per-member shape entries of a class (bodies excluded), used to tell an
/// additive edit from a breaking one between generations. See
/// [DeclarationRegistry.reconcileClassShape].
Set<String> classMemberShapeKeys(Iterable<SAstNode> members) {
  final parts = <String>{};
  for (final member in members) {
    if (member is SMethodDeclaration) {
      final name = member.name?.name ?? '';
      final kind = member.isGetter
          ? 'get'
          : member.isSetter
          ? 'set'
          : member.isOperator
          ? 'op'
          : 'method';
      parts.add(
        '$kind:$name:${member.isStatic ? 's' : 'i'}'
        '${member.isAbstract ? 'a' : 'c'}'
        '${parameterShapeKey(member.parameters)}',
      );
    } else if (member is SConstructorDeclaration) {
      final name = member.name?.name ?? '';
      parts.add(
        'ctor:$name:${member.isFactory ? 'f' : 'g'}'
        '${parameterShapeKey(member.parameters)}',
      );
    } else if (member is SFieldDeclaration) {
      for (final variable
          in member.fields?.variables ?? const <SVariableDeclaration>[]) {
        parts.add(
          'field:${variable.name?.name ?? ''}:'
          '${member.isStatic ? 's' : 'i'}'
          '${variable.initializer != null ? 'h' : 'n'}',
        );
      }
    }
  }
  return parts;
}

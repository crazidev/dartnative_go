/// Manages DAP variables and assigns unique `variablesReference` identifiers
/// so VS Code can lazily browse and expand complex objects, lists, and maps.
class DapVariableStore {
  int _nextId = 1000;
  final Map<int, Object?> _storedObjects = {};

  /// Clears all stored variable references (typically done on resume or reload).
  void clear() {
    _nextId = 1000;
    _storedObjects.clear();
  }

  /// Registers an object and returns its unique `variablesReference` ID.
  int register(Object? object) {
    if (object == null) return 0;
    if (object is num || object is bool || object is String) {
      return 0; // Primitives are leaf nodes, reference is 0
    }
    final id = _nextId++;
    _storedObjects[id] = object;
    return id;
  }

  /// Retrieves the object associated with a given `variablesReference`.
  Object? get(int variablesReference) => _storedObjects[variablesReference];

  /// Converts a value into a DAP Variable structure.
  Map<String, dynamic> createVariable(String name, Object? value) {
    if (value == null) {
      return {
        'name': name,
        'value': 'null',
        'type': 'Null',
        'variablesReference': 0,
      };
    }

    if (value is bool || value is num) {
      return {
        'name': name,
        'value': value.toString(),
        'type': value.runtimeType.toString(),
        'variablesReference': 0,
      };
    }

    if (value is String) {
      return {
        'name': name,
        'value': '"$value"',
        'type': 'String',
        'variablesReference': 0,
      };
    }

    if (value is List) {
      final ref = register(value);
      return {
        'name': name,
        'value': 'List (${value.length} items)',
        'type': 'List',
        'variablesReference': ref,
        'indexedVariables': value.length,
      };
    }

    if (value is Set) {
      final ref = register(value.toList());
      return {
        'name': name,
        'value': 'Set (${value.length} items)',
        'type': 'Set',
        'variablesReference': ref,
      };
    }

    if (value is Map) {
      final ref = register(value);
      return {
        'name': name,
        'value': 'Map (${value.length} entries)',
        'type': 'Map',
        'variablesReference': ref,
        'namedVariables': value.length,
      };
    }

    // Generic Object or Interpreted instance
    final typeName = value.runtimeType.toString();
    final ref = register(value);
    return {
      'name': name,
      'value': value.toString(),
      'type': typeName,
      'variablesReference': ref,
    };
  }

  /// Returns the child variables for an expandable object by `variablesReference`.
  List<Map<String, dynamic>> getChildVariables(int variablesReference) {
    final obj = _storedObjects[variablesReference];
    if (obj == null) return const [];

    final result = <Map<String, dynamic>>[];

    if (obj is List) {
      for (var i = 0; i < obj.length; i++) {
        result.add(createVariable('[$i]', obj[i]));
      }
      return result;
    }

    if (obj is Map) {
      obj.forEach((key, val) {
        result.add(createVariable(key.toString(), val));
      });
      return result;
    }

    // Fallback representation for custom object properties
    result.add({
      'name': 'toString()',
      'value': '"${obj.toString()}"',
      'type': 'String',
      'variablesReference': 0,
    });

    return result;
  }
}

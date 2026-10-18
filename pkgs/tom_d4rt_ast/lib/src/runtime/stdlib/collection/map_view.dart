import 'dart:collection';

import 'package:tom_d4rt_ast/runtime.dart';

/// Narrows [target] to the native view, or reports which member was reached
/// with the wrong receiver.
MapView _view(Object? target, String member) {
  if (target is MapView) return target;
  throw RuntimeD4rtException("Target is not a MapView for '$member'");
}

/// Bridge for `dart:collection`'s [MapView].
///
/// Required by `package:path` (`PathMap extends MapView`), and therefore by
/// anything that bundles it (e.g. `dio` via `package:mime`/`package:path`).
/// The constructor takes the backing map so explicit `super(map)` calls from
/// interpreted subclasses wire a real native view; reads delegate to it.
class MapViewCollection {
  static BridgedClass get definition => BridgedClass(
    nativeType: MapView,
    name: 'MapView',
    isAssignable: (v) => v is MapView,
    typeParameterCount: 2,
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        if (positionalArgs.length != 1) {
          throw RuntimeD4rtException(
            'Constructor MapView(Map map) expects one positional argument.',
          );
        }
        final source = positionalArgs[0];
        if (source is Map) {
          return MapView<dynamic, dynamic>(source);
        }
        throw RuntimeD4rtException(
          'Argument to MapView() must be a Map.',
        );
      },
    },
    methods: {
      '[]': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 1) {
          throw RuntimeD4rtException("Invalid arguments for MapView[]");
        }
        return _view(target, '[]')[positionalArgs[0]];
      },
      '[]=': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 2) {
          throw RuntimeD4rtException("Invalid arguments for MapView[]=");
        }
        _view(target, '[]=')[positionalArgs[0]] = positionalArgs[1];
        return positionalArgs[1];
      },
      'addAll': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 1 || positionalArgs[0] is! Map) {
          throw RuntimeD4rtException(
            'Argument to MapView.addAll must be a Map.',
          );
        }
        _view(target, 'addAll').addAll(positionalArgs[0] as Map);
        return null;
      },
      'clear': (visitor, target, positionalArgs, namedArgs, _) {
        _view(target, 'clear').clear();
        return null;
      },
      'containsKey': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 1) {
          throw RuntimeD4rtException(
            'Invalid arguments for MapView.containsKey',
          );
        }
        return _view(target, 'containsKey').containsKey(positionalArgs[0]);
      },
      'containsValue': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 1) {
          throw RuntimeD4rtException(
            'Invalid arguments for MapView.containsValue',
          );
        }
        return _view(target, 'containsValue').containsValue(positionalArgs[0]);
      },
      'forEach': (visitor, target, positionalArgs, namedArgs, _) {
        final action = positionalArgs[0];
        if (action is! Callable) {
          throw RuntimeD4rtException(
            'Argument to MapView.forEach must be a function.',
          );
        }
        _view(target, 'forEach').forEach((key, value) {
          action.call(visitor, [key, value]);
        });
        return null;
      },
      'putIfAbsent': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 2) {
          throw RuntimeD4rtException(
            'Invalid arguments for MapView.putIfAbsent',
          );
        }
        final ifAbsent = positionalArgs[1];
        if (ifAbsent is! Callable) {
          throw RuntimeD4rtException(
            'Argument to MapView.putIfAbsent must be a function.',
          );
        }
        return _view(
          target,
          'putIfAbsent',
        ).putIfAbsent(positionalArgs[0], () => ifAbsent.call(visitor, []));
      },
      'remove': (visitor, target, positionalArgs, namedArgs, _) {
        if (positionalArgs.length != 1) {
          throw RuntimeD4rtException("Invalid arguments for MapView.remove");
        }
        return _view(target, 'remove').remove(positionalArgs[0]);
      },
      'cast': (visitor, target, positionalArgs, namedArgs, _) {
        return _view(target, 'cast').cast<dynamic, dynamic>();
      },
      'toString': (visitor, target, positionalArgs, namedArgs, _) {
        return _view(target, 'toString').toString();
      },
    },
    getters: {
      'length': (visitor, target) => _view(target, 'length').length,
      'isEmpty': (visitor, target) => _view(target, 'isEmpty').isEmpty,
      'isNotEmpty': (visitor, target) => _view(target, 'isNotEmpty').isNotEmpty,
      'keys': (visitor, target) => _view(target, 'keys').keys,
      'values': (visitor, target) => _view(target, 'values').values,
      'entries': (visitor, target) => _view(target, 'entries').entries,
      'hashCode': (visitor, target) => _view(target, 'hashCode').hashCode,
      'runtimeType': (visitor, target) =>
          _view(target, 'runtimeType').runtimeType,
    },
  );
}

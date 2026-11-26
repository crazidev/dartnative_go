import 'dart:async';
import 'dart:developer';
import 'package:tom_d4rt/d4rt.dart';
import 'developer/timeline.dart';
import 'developer/user_tag.dart';
import 'developer/service.dart';
import 'developer/flow.dart';

export 'developer/timeline.dart';
export 'developer/user_tag.dart';
export 'developer/service.dart';
export 'developer/flow.dart';

/// Stdlib bridge for `dart:developer`.
///
/// Ported from upstream `d4rt` (`lib/src/stdlib/developer.dart`):
/// `Timeline`, `TimelineTask`, `UserTag`, `Service`,
/// `ServiceExtensionResponse`, `ServiceProtocolInfo`, `Flow`, plus the
/// top-level `log` / `debugger` / `inspect` / `postEvent` /
/// `registerExtension` functions. Calls forward to the host
/// `dart:developer` so guest observability (e.g. `get_it` DevTools
/// extensions) behaves like host code. In AOT product mode the host
/// calls are no-ops by SDK design, except `NativeRuntime.buildId`.
class DeveloperStdlib {
  /// Guest service-extension handlers, keyed by method name.
  ///
  /// Held at class scope (rather than captured per call) so a hot reload can
  /// *replace* a handler without re-registering it with the host. The host
  /// `dart:developer.registerExtension` throws
  /// `ArgumentError('Extension already registered: $method')` on a duplicate
  /// and exposes no unregister, yet a reload re-runs the guest top level, so
  /// packages that register an extension (e.g. get_it's
  /// `ext.get_it.getRegistrations`) would otherwise fail on every reload with
  /// `Interpreter Error: Invalid argument(s): Extension already registered`.
  /// Rebinding here also keeps dispatch pointing at the freshly-interpreted
  /// handler instead of the stale pre-reload one.
  static final Map<String, ({Object? handler, InterpreterVisitor visitor})>
  _extensionHandlers =
      <String, ({Object? handler, InterpreterVisitor visitor})>{};

  /// Method names already handed to the host, so a reload rebinds the stored
  /// handler instead of calling [registerExtension] again (which would throw).
  static final Set<String> _hostRegisteredExtensions = <String>{};

  static void register(Environment environment) {
    environment.defineBridge(TimelineDeveloper.definition);
    environment.defineBridge(TimelineTaskDeveloper.definition);
    environment.defineBridge(UserTagDeveloper.definition);
    environment.defineBridge(ServiceDeveloper.definition);
    environment.defineBridge(ServiceExtensionResponseDeveloper.definition);
    environment.defineBridge(ServiceProtocolInfoDeveloper.definition);
    environment.defineBridge(FlowDeveloper.definition);

    environment.define(
      'log',
      NativeFunction(
        (visitor, arguments, namedArguments, typeArguments) {
          if (arguments.isEmpty || arguments[0] is! String) {
            throw RuntimeD4rtException(
              'log requires at least one String message argument.',
            );
          }
          final message = arguments[0] as String;
          final time = namedArguments['time'] as DateTime?;
          final sequenceNumber = namedArguments['sequenceNumber'] as int?;
          final level = namedArguments['level'] as int? ?? 0;
          final name = namedArguments['name'] as String? ?? '';
          final zone = namedArguments['zone'] as Zone?;
          final error = namedArguments['error'];
          final stackTrace = namedArguments['stackTrace'] as StackTrace?;

          log(
            message,
            time: time,
            sequenceNumber: sequenceNumber,
            level: level,
            name: name,
            zone: zone,
            error: error,
            stackTrace: stackTrace,
          );
          return null;
        },
        arity: 1,
        name: 'log',
      ),
    );

    environment.define(
      'debugger',
      NativeFunction(
        (visitor, arguments, namedArguments, typeArguments) {
          final when = namedArguments['when'] as bool? ?? true;
          final message = namedArguments['message'] as String?;
          return debugger(when: when, message: message);
        },
        arity: 0,
        name: 'debugger',
      ),
    );

    environment.define(
      'inspect',
      NativeFunction(
        (visitor, arguments, namedArguments, typeArguments) {
          if (arguments.isEmpty) {
            throw RuntimeD4rtException('inspect requires one object argument.');
          }
          return inspect(arguments[0]);
        },
        arity: 1,
        name: 'inspect',
      ),
    );

    environment.define(
      'postEvent',
      NativeFunction(
        (visitor, arguments, namedArguments, typeArguments) {
          if (arguments.length < 2 ||
              arguments[0] is! String ||
              arguments[1] is! Map) {
            throw RuntimeD4rtException(
              'postEvent requires a String eventKind and a Map eventData.',
            );
          }
          final eventKind = arguments[0] as String;
          final eventData = (arguments[1] as Map).cast<String, dynamic>();
          postEvent(eventKind, eventData);
          return null;
        },
        arity: 2,
        name: 'postEvent',
      ),
    );

    environment.define(
      'registerExtension',
      NativeFunction(
        (visitor, arguments, namedArguments, typeArguments) {
          if (arguments.length < 2 || arguments[0] is! String) {
            throw RuntimeD4rtException(
              'registerExtension requires a String method and a function handler.',
            );
          }
          final method = arguments[0] as String;
          final handler = arguments[1];

          // Store (or overwrite) the handler for this method. Overwriting is the
          // reload-safe path: the newest registration wins and dispatch reads the
          // current entry at call time.
          _extensionHandlers[method] = (handler: handler, visitor: visitor);

          // Register with the host exactly once per method. Repeat registrations
          // (a hot reload, or a second `main()`) only rebind the stored handler.
          if (_hostRegisteredExtensions.add(method)) {
            registerExtension(method, (methodName, parameters) async {
              final entry = _extensionHandlers[method];
              if (entry == null) {
                throw RuntimeD4rtException(
                  'Service extension $method has no registered handler.',
                );
              }
              final currentHandler = entry.handler;
              final currentVisitor = entry.visitor;
              Object? result;
              if (currentHandler is InterpretedFunction) {
                result = currentHandler.call(currentVisitor, [
                  methodName,
                  parameters,
                ]);
              } else if (currentHandler is Callable) {
                result = currentHandler.call(currentVisitor, [
                  methodName,
                  parameters,
                ], {});
              } else if (currentHandler is Function) {
                result = (currentHandler as dynamic)(methodName, parameters);
              }
              final resolvedResult = result is Future ? await result : result;
              if (resolvedResult is ServiceExtensionResponse) {
                return resolvedResult;
              }
              throw RuntimeD4rtException(
                'Service extension handler must return a ServiceExtensionResponse.',
              );
            });
          }
          return null;
        },
        arity: 2,
        name: 'registerExtension',
      ),
    );
  }
}

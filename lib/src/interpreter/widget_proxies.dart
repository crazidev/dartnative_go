import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';

/// Native proxy for interpreted classes that extend [StatelessWidget].
class InterpretedStatelessWidget extends StatelessWidget {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedStatelessWidget(this.visitor, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  @override
  Widget build(BuildContext context) {
    final method = instance.get('build', visitor: visitor);
    if (method is Callable) {
      final rawResult = method.call(visitor, [context], {});
      final widget = D4.extractBridgedArg<Widget>(rawResult, 'buildResult', visitor);
      return widget;
    }
    throw StateError('Interpreted StatelessWidget has no callable build(context) method');
  }
}

/// Native proxy for interpreted classes that extend [StatefulWidget].
class InterpretedStatefulWidget extends StatefulWidget {
  final InterpreterVisitor visitor;
  final InterpretedInstance instance;

  InterpretedStatefulWidget(this.visitor, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  @override
  State<StatefulWidget> createState() {
    final method = instance.get('createState', visitor: visitor);
    if (method is Callable) {
      final stateResult = method.call(visitor, [], {});
      if (stateResult is InterpretedInstance) {
        return InterpretedStateProxy(visitor, stateResult, this);
      } else if (stateResult is State<StatefulWidget>) {
        return stateResult;
      }
    }
    throw StateError('Interpreted StatefulWidget failed to create state');
  }
}

/// Native proxy for interpreted classes that extend [State].
class InterpretedStateProxy extends State<StatefulWidget> {
  final InterpreterVisitor visitor;
  final InterpretedInstance stateInstance;
  final InterpretedStatefulWidget ownerWidget;

  InterpretedStateProxy(this.visitor, this.stateInstance, this.ownerWidget) {
    stateInstance.nativeProxy = this;
    stateInstance.bridgedSuperObject = this;
    stateInstance.nativeStateProxy = this;
    stateInstance.interpretedStatefulWidget = ownerWidget.instance;
  }

  @override
  void initState() {
    super.initState();
    final method = stateInstance.klass.findInstanceMethod('initState');
    if (method != null) {
      final callable = stateInstance.bindMethodCached(method);
      callable.call(visitor, [], {});
    }
  }

  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    stateInstance.interpretedStatefulWidget = ownerWidget.instance;
    final method = stateInstance.klass.findInstanceMethod('didUpdateWidget');
    if (method != null) {
      final callable = stateInstance.bindMethodCached(method);
      callable.call(visitor, [oldWidget], {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final method = stateInstance.get('build', visitor: visitor);
    if (method is Callable) {
      final rawResult = method.call(visitor, [context], {});
      final widget = D4.extractBridgedArg<Widget>(rawResult, 'buildResult', visitor);
      return widget;
    }
    throw StateError('Interpreted State has no callable build(context) method');
  }

  @override
  void dispose() {
    final method = stateInstance.klass.findInstanceMethod('dispose');
    if (method != null) {
      final callable = stateInstance.bindMethodCached(method);
      callable.call(visitor, [], {});
    }
    super.dispose();
  }
}

/// Registers interface proxies for [StatelessWidget] and [StatefulWidget]
/// into the [tom_d4rt] interpreter runtime.
void registerWidgetInterfaceProxies(D4rt interpreter) {
  D4.registerInterfaceProxy('StatelessWidget', (visitor, instance) {
    return InterpretedStatelessWidget(visitor, instance);
  });

  D4.registerInterfaceProxy('StatefulWidget', (visitor, instance) {
    return InterpretedStatefulWidget(visitor, instance);
  });
}

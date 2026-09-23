import 'dart:async';
import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'call_frame.dart';
import 'vm.dart';

/// Native proxy for Bytecode interpreted classes extending [StatelessWidget].
class BytecodeStatelessWidget extends StatelessWidget {
  final BytecodeVM vm;
  final BytecodeInstance instance;

  BytecodeStatelessWidget(this.vm, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  @override
  Widget build(BuildContext context) {
    final latestClass = vm.classes[instance.bytecodeClass.name];
    if (latestClass != null) {
      instance.syncClass(latestClass, vm);
    }
    final buildFuncId = instance.bytecodeClass.methodFuncIds['build'];
    if (buildFuncId != null) {
      final res = vm.executeFunction(
        funcId: buildFuncId,
        positionalArgs: [context],
        thisTarget: instance,
      );
      final widget = vm.unwrapWidget(res);
      if (widget != null) return widget;
    }
    return const SizedBox.shrink();
  }
}

/// Native proxy for Bytecode interpreted classes extending [StatefulWidget].
class BytecodeStatefulWidget extends StatefulWidget {
  final BytecodeVM vm;
  final BytecodeInstance instance;

  BytecodeStatefulWidget(this.vm, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  @override
  State<StatefulWidget> createState() {
    final latestClass = vm.classes[instance.bytecodeClass.name];
    if (latestClass != null) {
      instance.syncClass(latestClass, vm);
    }
    final createStateFuncId = instance.bytecodeClass.methodFuncIds['createState'];
    if (createStateFuncId != null) {
      final stateRes = vm.executeFunction(
        funcId: createStateFuncId,
        thisTarget: instance,
      );
      if (stateRes is BytecodeInstance) {
        return BytecodeStateProxy(vm, stateRes, this);
      } else if (stateRes is State<StatefulWidget>) {
        return stateRes;
      }
    }
    throw StateError(
      'Bytecode StatefulWidget ${instance.bytecodeClass.name} failed to create state',
    );
  }
}

/// Native proxy for Bytecode interpreted classes extending [State].
class BytecodeStateProxy extends State<StatefulWidget> {
  final BytecodeVM vm;
  BytecodeInstance stateInstance;
  BytecodeStatefulWidget ownerWidget;

  BytecodeStateProxy(this.vm, this.stateInstance, this.ownerWidget) {
    stateInstance.nativeProxy = this;
  }

  BytecodeInstance get widgetInstance => ownerWidget.instance;

  @override
  void initState() {
    super.initState();
    final initFuncId = stateInstance.bytecodeClass.methodFuncIds['initState'];
    if (initFuncId != null) {
      vm.executeFunction(
        funcId: initFuncId,
        thisTarget: stateInstance,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final depFuncId = stateInstance.bytecodeClass.methodFuncIds['didChangeDependencies'];
    if (depFuncId != null) {
      vm.executeFunction(
        funcId: depFuncId,
        thisTarget: stateInstance,
      );
    }
  }

  bool _mounted = true;

  @override
  bool get mounted {
    try {
      return super.mounted;
    } catch (_) {
      return _mounted;
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    try {
      super.setState(fn);
    } catch (_) {
      fn();
      scheduleMicrotask(() {
        if (mounted) {
          try {
            super.setState(() {});
          } catch (_) {}
        }
      });
    }
  }


  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget is BytecodeStatefulWidget) {
      ownerWidget = widget as BytecodeStatefulWidget;
    }
    final latestClass = vm.classes[stateInstance.bytecodeClass.name];
    if (latestClass != null) {
      stateInstance.syncClass(latestClass, vm);
    }
    final updateFuncId = stateInstance.bytecodeClass.methodFuncIds['didUpdateWidget'];
    if (updateFuncId != null) {
      vm.executeFunction(
        funcId: updateFuncId,
        positionalArgs: [oldWidget],
        thisTarget: stateInstance,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    stateInstance.nativeProxy = this;
    final latestClass = vm.classes[stateInstance.bytecodeClass.name];
    if (latestClass != null) {
      stateInstance.syncClass(latestClass, vm);
    }
    final buildFuncId = stateInstance.bytecodeClass.methodFuncIds['build'];
    if (buildFuncId != null) {
      final res = vm.executeFunction(
        funcId: buildFuncId,
        positionalArgs: [context],
        thisTarget: stateInstance,
      );
      final widget = vm.unwrapWidget(res);
      if (widget != null) return widget;
    }
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _mounted = false;
    final disposeFuncId = stateInstance.bytecodeClass.methodFuncIds['dispose'];
    if (disposeFuncId != null) {
      try {
        vm.executeFunction(
          funcId: disposeFuncId,
          thisTarget: stateInstance,
        );
      } catch (_) {}
    }
    super.dispose();
  }
}

/// Native proxy for Bytecode interpreted classes extending [ConsumerWidget].
class BytecodeConsumerWidget extends ConsumerWidget {
  final BytecodeVM vm;
  final BytecodeInstance instance;

  BytecodeConsumerWidget(this.vm, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestClass = vm.classes[instance.bytecodeClass.name];
    if (latestClass != null) {
      instance.syncClass(latestClass, vm);
    }
    final buildFuncId = instance.bytecodeClass.methodFuncIds['build'];
    if (buildFuncId != null) {
      final res = vm.executeFunction(
        funcId: buildFuncId,
        positionalArgs: [context, ref],
        thisTarget: instance,
      );
      final widget = vm.unwrapWidget(res);
      if (widget != null) return widget;
    }
    return const SizedBox.shrink();
  }
}

/// Native proxy for Bytecode interpreted classes extending [ConsumerStatefulWidget].
class BytecodeConsumerStatefulWidget extends ConsumerStatefulWidget {
  final BytecodeVM vm;
  final BytecodeInstance instance;

  BytecodeConsumerStatefulWidget(this.vm, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    final latestClass = vm.classes[instance.bytecodeClass.name];
    if (latestClass != null) {
      instance.syncClass(latestClass, vm);
    }
    final createStateFuncId = instance.bytecodeClass.methodFuncIds['createState'];
    if (createStateFuncId != null) {
      final stateRes = vm.executeFunction(
        funcId: createStateFuncId,
        thisTarget: instance,
      );
      if (stateRes is BytecodeInstance) {
        return BytecodeConsumerStateProxy(vm, stateRes, this);
      } else if (stateRes is ConsumerState<ConsumerStatefulWidget>) {
        return stateRes;
      }
    }
    throw StateError(
      'Bytecode ConsumerStatefulWidget ${instance.bytecodeClass.name} failed to create state',
    );
  }
}

/// Native proxy for Bytecode interpreted classes extending [ConsumerState].
class BytecodeConsumerStateProxy extends ConsumerState<ConsumerStatefulWidget> {
  final BytecodeVM vm;
  BytecodeInstance stateInstance;
  BytecodeConsumerStatefulWidget ownerWidget;

  BytecodeConsumerStateProxy(this.vm, this.stateInstance, this.ownerWidget) {
    stateInstance.nativeProxy = this;
  }

  BytecodeInstance get widgetInstance => ownerWidget.instance;

  @override
  void initState() {
    super.initState();
    final initFuncId = stateInstance.bytecodeClass.methodFuncIds['initState'];
    if (initFuncId != null) {
      vm.executeFunction(
        funcId: initFuncId,
        thisTarget: stateInstance,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final depFuncId = stateInstance.bytecodeClass.methodFuncIds['didChangeDependencies'];
    if (depFuncId != null) {
      vm.executeFunction(
        funcId: depFuncId,
        thisTarget: stateInstance,
      );
    }
  }

  bool _mounted = true;

  @override
  bool get mounted {
    try {
      return super.mounted;
    } catch (_) {
      return _mounted;
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    try {
      super.setState(fn);
    } catch (_) {
      fn();
      scheduleMicrotask(() {
        if (mounted) {
          try {
            super.setState(() {});
          } catch (_) {}
        }
      });
    }
  }


  @override
  void didUpdateWidget(covariant ConsumerStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget is BytecodeConsumerStatefulWidget) {
      ownerWidget = widget as BytecodeConsumerStatefulWidget;
    }
    final latestClass = vm.classes[stateInstance.bytecodeClass.name];
    if (latestClass != null) {
      stateInstance.syncClass(latestClass, vm);
    }
    final updateFuncId = stateInstance.bytecodeClass.methodFuncIds['didUpdateWidget'];
    if (updateFuncId != null) {
      vm.executeFunction(
        funcId: updateFuncId,
        positionalArgs: [oldWidget],
        thisTarget: stateInstance,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    stateInstance.nativeProxy = this;
    final latestClass = vm.classes[stateInstance.bytecodeClass.name];
    if (latestClass != null) {
      stateInstance.syncClass(latestClass, vm);
    }
    final buildFuncId = stateInstance.bytecodeClass.methodFuncIds['build'];
    if (buildFuncId != null) {
      final res = vm.executeFunction(
        funcId: buildFuncId,
        positionalArgs: [context],
        thisTarget: stateInstance,
      );
      final widget = vm.unwrapWidget(res);
      if (widget != null) return widget;
    }
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _mounted = false;
    final disposeFuncId = stateInstance.bytecodeClass.methodFuncIds['dispose'];
    if (disposeFuncId != null) {
      try {
        vm.executeFunction(
          funcId: disposeFuncId,
          thisTarget: stateInstance,
        );
      } catch (_) {}
    }
    super.dispose();
  }
}

/// Native proxy for Bytecode interpreted classes extending [Notifier].
class BytecodeNotifierProxy extends Notifier<dynamic> {
  final BytecodeVM vm;
  final BytecodeInstance instance;

  BytecodeNotifierProxy(this.vm, this.instance) {
    instance.nativeProxy = this;
  }

  @override
  dynamic build() {
    final latestClass = vm.classes[instance.bytecodeClass.name];
    if (latestClass != null) {
      instance.syncClass(latestClass, vm);
    }
    final buildFuncId = instance.bytecodeClass.methodFuncIds['build'];
    if (buildFuncId != null) {
      final res = vm.executeFunction(
        funcId: buildFuncId,
        thisTarget: instance,
      );
      return res;
    }
    return null;
  }
}

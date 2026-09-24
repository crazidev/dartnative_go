import 'dart:async';
import 'package:dartnative/dartnative.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import '../native_bottomsheet_manager.dart';
import 'bytecode_models.dart';
import 'call_frame.dart';
import 'vm.dart';

/// Native proxy for Bytecode interpreted classes extending [StatelessWidget].
class BytecodeStatelessWidget extends StatelessWidget {
  BytecodeVM vm;
  BytecodeInstance instance;

  BytecodeStatelessWidget(this.vm, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    if (newVisitor is BytecodeVM) {
      vm = newVisitor;
    }
    if (newClass is BytecodeClass) {
      instance.syncClass(newClass, vm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final latestClass = vm.classes[instance.bytecodeClass.name];
    if (latestClass != null) {
      instance.syncClass(latestClass, vm);
    }
    final buildFuncId = instance.bytecodeClass.methodFuncIds['build'];
    var fn = buildFuncId != null ? vm.functionTable.get(buildFuncId) : null;
    fn ??= vm.functionTable.getByName('${instance.bytecodeClass.name}.build');
    if (fn != null) {
      final res = vm.executeFunction(
        funcId: fn.id,
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
  BytecodeVM vm;
  BytecodeInstance instance;

  BytecodeStatefulWidget(this.vm, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    if (newVisitor is BytecodeVM) {
      vm = newVisitor;
    }
    if (newClass is BytecodeClass) {
      instance.syncClass(newClass, vm);
    }
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
  BytecodeVM vm;
  BytecodeInstance stateInstance;
  BytecodeStatefulWidget ownerWidget;

  BytecodeStateProxy(this.vm, this.stateInstance, this.ownerWidget) {
    stateInstance.nativeProxy = this;
  }

  BytecodeInstance get widgetInstance => ownerWidget.instance;

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    if (newVisitor is BytecodeVM) {
      vm = newVisitor;
    }
    if (newClass is BytecodeClass) {
      stateInstance.syncClass(newClass, vm);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      NativeBottomSheetScope.of(context)?.registerProxy(this);
    } catch (_) {}
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
    try {
      NativeBottomSheetScope.of(context)?.registerProxy(this);
    } catch (_) {}
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
    try {
      super.didUpdateWidget(oldWidget);
    } catch (_) {}
    try {
      if (widget is BytecodeStatefulWidget) {
        ownerWidget = widget as BytecodeStatefulWidget;
        vm = ownerWidget.vm;
      }
    } catch (_) {}
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
    try {
      if (widget is BytecodeStatefulWidget) {
        ownerWidget = widget as BytecodeStatefulWidget;
        vm = ownerWidget.vm;
      }
    } catch (_) {}
    stateInstance.nativeProxy = this;
    final latestClass = vm.classes[stateInstance.bytecodeClass.name];
    if (latestClass != null) {
      stateInstance.syncClass(latestClass, vm);
    }
    final buildFuncId = stateInstance.bytecodeClass.methodFuncIds['build'];
    var fn = buildFuncId != null ? vm.functionTable.get(buildFuncId) : null;
    fn ??= vm.functionTable.getByName('${stateInstance.bytecodeClass.name}.build');
    if (fn != null) {
      final res = vm.executeFunction(
        funcId: fn.id,
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
    try {
      NativeBottomSheetScope.of(context)?.unregisterProxy(this);
    } catch (_) {}
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
  BytecodeVM vm;
  BytecodeInstance instance;

  BytecodeConsumerWidget(this.vm, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    if (newVisitor is BytecodeVM) {
      vm = newVisitor;
    }
    if (newClass is BytecodeClass) {
      instance.syncClass(newClass, vm);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestClass = vm.classes[instance.bytecodeClass.name];
    if (latestClass != null) {
      instance.syncClass(latestClass, vm);
    }
    final buildFuncId = instance.bytecodeClass.methodFuncIds['build'];
    var fn = buildFuncId != null ? vm.functionTable.get(buildFuncId) : null;
    fn ??= vm.functionTable.getByName('${instance.bytecodeClass.name}.build');
    if (fn != null) {
      final res = vm.executeFunction(
        funcId: fn.id,
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
  BytecodeVM vm;
  BytecodeInstance instance;

  BytecodeConsumerStatefulWidget(this.vm, this.instance, {super.key}) {
    instance.nativeProxy = this;
  }

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    if (newVisitor is BytecodeVM) {
      vm = newVisitor;
    }
    if (newClass is BytecodeClass) {
      instance.syncClass(newClass, vm);
    }
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
  BytecodeVM vm;
  BytecodeInstance stateInstance;
  BytecodeConsumerStatefulWidget ownerWidget;

  BytecodeConsumerStateProxy(this.vm, this.stateInstance, this.ownerWidget) {
    stateInstance.nativeProxy = this;
  }

  BytecodeInstance get widgetInstance => ownerWidget.instance;

  void rebindForHotReload(dynamic newVisitor, dynamic newClass) {
    if (newVisitor is BytecodeVM) {
      vm = newVisitor;
    }
    if (newClass is BytecodeClass) {
      stateInstance.syncClass(newClass, vm);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      NativeBottomSheetScope.of(context)?.registerProxy(this);
    } catch (_) {}
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
    try {
      NativeBottomSheetScope.of(context)?.registerProxy(this);
    } catch (_) {}
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
    try {
      super.didUpdateWidget(oldWidget);
    } catch (_) {}
    try {
      if (widget is BytecodeConsumerStatefulWidget) {
        ownerWidget = widget as BytecodeConsumerStatefulWidget;
        vm = ownerWidget.vm;
      }
    } catch (_) {}
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
    try {
      if (widget is BytecodeConsumerStatefulWidget) {
        ownerWidget = widget as BytecodeConsumerStatefulWidget;
        vm = ownerWidget.vm;
      }
    } catch (_) {}
    stateInstance.nativeProxy = this;
    final latestClass = vm.classes[stateInstance.bytecodeClass.name];
    if (latestClass != null) {
      stateInstance.syncClass(latestClass, vm);
    }
    final buildFuncId = stateInstance.bytecodeClass.methodFuncIds['build'];
    var fn = buildFuncId != null ? vm.functionTable.get(buildFuncId) : null;
    fn ??= vm.functionTable.getByName('${stateInstance.bytecodeClass.name}.build');
    if (fn != null) {
      final res = vm.executeFunction(
        funcId: fn.id,
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
    try {
      NativeBottomSheetScope.of(context)?.unregisterProxy(this);
    } catch (_) {}
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

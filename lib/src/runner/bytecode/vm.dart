import 'dart:typed_data';
import 'package:dartnative/dartnative.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import '../logger.dart';
import 'bridge_adapter.dart';
import 'bytecode_models.dart';
import 'bytecode_widget_proxies.dart';
import 'call_frame.dart';
import 'function_table.dart';
import 'opcodes.dart';

/// Lightweight, high-performance Stack Virtual Machine for DartNative Go.
class BytecodeVM {
  static BytecodeVM? current;

  final FunctionTable functionTable = FunctionTable();
  ConstantPool constantPool = ConstantPool(const []);
  final Map<String, BytecodeClass> classes = {};
  final Map<String, Object?> globals = {};
  late final BytecodeBridgeAdapter bridgeAdapter;

  final List<CallFrame> _callStack = [];
  final List<Object?> _operandStack = [];

  BytecodeVM({
    void Function(String)? onLog,
    String? Function()? serverUrlProvider,
  }) {
    bridgeAdapter = BytecodeBridgeAdapter(
      onLog: onLog,
      serverUrlProvider: serverUrlProvider,
      widgetUnwrapper: (o) => unwrapWidget(o),
      vm: this,
    );
  }

  BytecodeInstance _createInstance(BytecodeClass bytecodeClass) {
    final instance = BytecodeInstance(bytecodeClass);
    final sc = bytecodeClass.superclass ?? '';
    if (sc == 'Notifier' || sc.startsWith('Notifier<')) {
      BytecodeNotifierProxy(this, instance);
    }
    return instance;
  }

  /// Loads and initializes a [BytecodeBundle].
  Object? loadBundle(BytecodeBundle bundle) {
    functionTable.clear();
    functionTable.registerAll(bundle.functions);
    constantPool = bundle.constantPool;
    classes.clear();
    for (final c in bundle.classes) {
      classes[c.name] = c;
    }
    globals.clear();

    if (bundle.initGlobalsFuncId != null) {
      executeFunction(funcId: bundle.initGlobalsFuncId!);
    }

    return executeFunction(funcId: bundle.entryPointFuncId);
  }

  /// Hot-swaps modified functions and updates constant pool from [delta].
  Set<String> applyDelta(BytecodeDelta delta) {
    for (final entry in delta.changedConstants.entries) {
      final idx = entry.key;
      if (idx < constantPool.constants.length) {
        constantPool.constants[idx] = entry.value;
      } else {
        while (constantPool.constants.length < idx) {
          constantPool.constants.add(null);
        }
        constantPool.constants.add(entry.value);
      }
    }
    return functionTable.applyDelta(delta);
  }

  /// Helper to instantiate an interpreted class by name.
  BytecodeInstance instantiateClass(
    String className,
    String ctorName, [
    List<Object?> posArgs = const [],
    Map<String, Object?> namedArgs = const {},
  ]) {
    final bytecodeClass = classes[className];
    if (bytecodeClass == null) {
      throw StateError('Class $className not found in VM');
    }
    final instance = _createInstance(bytecodeClass);
    final ctorFuncId = bytecodeClass.constructorFuncIds[ctorName] ??
        bytecodeClass.constructorFuncIds['new'] ??
        bytecodeClass.constructorFuncIds[''];
    if (ctorFuncId != null) {
      executeFunction(
        funcId: ctorFuncId,
        positionalArgs: posArgs,
        namedArgs: namedArgs,
        thisTarget: instance,
      );
    }
    return instance;
  }

  /// Helper to invoke a method on a [BytecodeInstance].
  Object? invokeMethod(
    BytecodeInstance instance,
    String methodName, [
    List<Object?> posArgs = const [],
    Map<String, Object?> namedArgs = const {},
  ]) {
    final methodFuncId = instance.bytecodeClass.methodFuncIds[methodName];
    if (methodFuncId != null) {
      return executeFunction(
        funcId: methodFuncId,
        positionalArgs: posArgs,
        namedArgs: namedArgs,
        thisTarget: instance,
      );
    }
    return null;
  }

  /// Executes a function by its integer [funcId].
  Object? executeFunction({
    required int funcId,
    List<Object?> positionalArgs = const [],
    Map<String, Object?> namedArgs = const {},
    BytecodeInstance? thisTarget,
    List<Object?>? capturedEnv,
  }) {
    final fn = functionTable.get(funcId);
    if (fn == null) {
      throw StateError('Function ID $funcId not found in FunctionTable');
    }

    final frame = CallFrame(
      function: fn,
      slotCount: fn.localSlotsCount,
      capturedEnv: capturedEnv,
    );

    var slot = 0;
    if (thisTarget != null) {
      frame.setLocal(slot++, thisTarget);
    } else if (capturedEnv != null && capturedEnv.isNotEmpty) {
      if (capturedEnv[0] is BytecodeInstance) {
        frame.setLocal(slot++, capturedEnv[0]);
      }
    }
    for (var i = 0; i < positionalArgs.length && slot < frame.slots.length; i++) {
      frame.setLocal(slot++, positionalArgs[i]);
    }
    for (final param in fn.namedParams) {
      if (namedArgs.containsKey(param.name)) {
        frame.setLocal(slot++, namedArgs[param.name]);
      } else if (param.defaultValueConstIndex != null) {
        frame.setLocal(
          slot++,
          constantPool[param.defaultValueConstIndex!],
        );
      } else {
        frame.setLocal(slot++, null);
      }
    }

    _callStack.add(frame);
    final prevCurrent = current;
    current = this;
    try {
      return _run(frame);
    } finally {
      current = prevCurrent;
      if (_callStack.isNotEmpty) _callStack.removeLast();
    }
  }

  Object? _run(CallFrame frame) {
    final code = frame.function.code;
    final data = ByteData.sublistView(code);

    while (frame.pc < code.length) {
      final op = code[frame.pc++];

      switch (op) {
        case OpCode.nop:
          break;

        case OpCode.pushConst:
          final idx = data.getUint16(frame.pc);
          frame.pc += 2;
          _operandStack.add(constantPool[idx]);
          break;

        case OpCode.pushNull:
          _operandStack.add(null);
          break;

        case OpCode.pushTrue:
          _operandStack.add(true);
          break;

        case OpCode.pushFalse:
          _operandStack.add(false);
          break;

        case OpCode.pushInt:
          final val = data.getInt32(frame.pc);
          frame.pc += 4;
          _operandStack.add(val);
          break;

        case OpCode.pop:
          if (_operandStack.isNotEmpty) _operandStack.removeLast();
          break;

        case OpCode.dup:
          if (_operandStack.isNotEmpty) {
            _operandStack.add(_operandStack.last);
          }
          break;

        case OpCode.loadLocal:
          final slot = data.getUint16(frame.pc);
          frame.pc += 2;
          _operandStack.add(frame.getLocal(slot));
          break;

        case OpCode.storeLocal:
          final slot = data.getUint16(frame.pc);
          frame.pc += 2;
          final val = _operandStack.removeLast();
          frame.setLocal(slot, val);
          break;

        case OpCode.loadGlobal:
          final nameIdx = data.getUint16(frame.pc);
          frame.pc += 2;
          final name = constantPool[nameIdx]?.toString() ?? '';
          var val = globals[name];
          if (val == null && frame.function.enclosingClass != null) {
            val = globals['${frame.function.enclosingClass}.$name'];
          }
          val ??= bridgeAdapter.resolveGlobalOrStatic(name);
          _operandStack.add(val);
          break;

        case OpCode.storeGlobal:
          final nameIdx = data.getUint16(frame.pc);
          frame.pc += 2;
          final name = constantPool[nameIdx]?.toString() ?? '';
          final val = _operandStack.removeLast();
          globals[name] = val;
          bridgeAdapter.storeGlobal(name, val);
          break;

        case OpCode.loadField:
          final nameIdx = data.getUint16(frame.pc);
          frame.pc += 2;
          final name = constantPool[nameIdx]?.toString() ?? '';
          final target = _operandStack.removeLast();
          if (target is BytecodeInstance) {
            if (target.bytecodeClass.methodFuncIds.containsKey(name)) {
              final funcId = target.bytecodeClass.methodFuncIds[name]!;
              _operandStack.add(_createTearOff(target, funcId));
            } else {
              _operandStack.add(target.getField(name));
            }
          } else if (target is BytecodeNotifierProxy) {
            if (name == 'state') {
              _operandStack.add((target as dynamic).state);
            } else if (target.instance.bytecodeClass.methodFuncIds.containsKey(name)) {
              final funcId = target.instance.bytecodeClass.methodFuncIds[name]!;
              _operandStack.add(_createTearOff(target.instance, funcId));
            } else {
              _operandStack.add(target.instance.getField(name));
            }
          } else if (target != null) {
            _operandStack.add(bridgeAdapter.resolveMember(target, name));
          } else {
            _operandStack.add(null);
          }
          break;

        case OpCode.storeField:
          final nameIdx = data.getUint16(frame.pc);
          frame.pc += 2;
          final name = constantPool[nameIdx]?.toString() ?? '';
          final target = _operandStack.removeLast();
          final val = _operandStack.removeLast();
          if (target is BytecodeInstance) {
            target.setField(name, val);
          }
          break;

        case OpCode.loadIndex:
          final index = _operandStack.removeLast();
          final target = _operandStack.removeLast();
          if (target is List && index is int && index >= 0 && index < target.length) {
            _operandStack.add(target[index]);
          } else if (target is String && index is int && index >= 0 && index < target.length) {
            _operandStack.add(target[index]);
          } else if (target is Map) {
            _operandStack.add(target[index]);
          } else {
            _operandStack.add(null);
          }
          break;

        case OpCode.storeIndex:
          final val = _operandStack.removeLast();
          final index = _operandStack.removeLast();
          final target = _operandStack.removeLast();
          if (target is List && index is int && index >= 0 && index < target.length) {
            target[index] = val;
          } else if (target is Map) {
            target[index] = val;
          }
          break;

        case OpCode.makeList:
          final count = data.getUint16(frame.pc);
          frame.pc += 2;
          final list = List<Object?>.filled(count, null);
          for (var i = count - 1; i >= 0; i--) {
            list[i] = _operandStack.removeLast();
          }
          _operandStack.add(list);
          break;

        case OpCode.makeEmptyList:
          _operandStack.add(<Object?>[]);
          break;

        case OpCode.listAdd:
          final item = _operandStack.removeLast();
          final list = _operandStack.last;
          if (list is List) {
            list.add(item);
          }
          break;

        case OpCode.listAddAll:
          final items = _operandStack.removeLast();
          final list = _operandStack.last;
          if (list is List && items is Iterable) {
            list.addAll(items);
          }
          break;

        case OpCode.makeMap:
          final entryCount = data.getUint16(frame.pc);
          frame.pc += 2;
          final map = <Object?, Object?>{};
          for (var i = 0; i < entryCount; i++) {
            final val = _operandStack.removeLast();
            final key = _operandStack.removeLast();
            map[key] = val;
          }
          _operandStack.add(map);
          break;

        case OpCode.makeEmptyMap:
          _operandStack.add(<Object?, Object?>{});
          break;

        case OpCode.mapPut:
          final val = _operandStack.removeLast();
          final key = _operandStack.removeLast();
          final map = _operandStack.last;
          if (map is Map) {
            map[key] = val;
          }
          break;

        case OpCode.mapPutAll:
          final mapToAdd = _operandStack.removeLast();
          final map = _operandStack.last;
          if (map is Map && mapToAdd is Map) {
            map.addAll(mapToAdd);
          }
          break;

        case OpCode.makeClosure:
          final funcId = data.getUint32(frame.pc);
          frame.pc += 4;
          final captureCount = data.getUint16(frame.pc);
          frame.pc += 2;
          final captured = <Object?>[];
          for (var i = 0; i < captureCount; i++) {
            captured.add(_operandStack.removeLast());
          }
          _operandStack.add(BytecodeClosure(
            funcId: funcId,
            capturedSlots: captured,
            vm: this,
            thisTarget: captured.isNotEmpty && captured[0] is BytecodeInstance
                ? captured[0] as BytecodeInstance
                : (frame.slots.isNotEmpty && frame.slots[0] is BytecodeInstance
                    ? frame.slots[0] as BytecodeInstance
                    : null),
          ));
          break;

        case OpCode.callInterpreted:
          final funcId = data.getUint32(frame.pc);
          frame.pc += 4;
          final posCount = code[frame.pc++];
          final namedCount = code[frame.pc++];

          final namedArgs = <String, Object?>{};
          for (var i = 0; i < namedCount; i++) {
            final val = _operandStack.removeLast();
            final name = _operandStack.removeLast()?.toString() ?? '';
            namedArgs[name] = val;
          }
          final posArgs = <Object?>[];
          for (var i = 0; i < posCount; i++) {
            posArgs.insert(0, _operandStack.removeLast());
          }

          final res = executeFunction(
            funcId: funcId,
            positionalArgs: posArgs,
            namedArgs: namedArgs,
          );
          _operandStack.add(res);
          break;

        case OpCode.callMethod:
          final nameIdx = data.getUint16(frame.pc);
          frame.pc += 2;
          final methodName = constantPool[nameIdx]?.toString() ?? '';
          final posCount = code[frame.pc++];
          final namedCount = code[frame.pc++];

          final namedArgs = <String, Object?>{};
          for (var i = 0; i < namedCount; i++) {
            final val = _operandStack.removeLast();
            final name = _operandStack.removeLast()?.toString() ?? '';
            namedArgs[name] = val;
          }
          final posArgs = <Object?>[];
          for (var i = 0; i < posCount; i++) {
            posArgs.insert(0, _operandStack.removeLast());
          }
          final target = _operandStack.removeLast();

          if (target is BytecodeInstance) {
            final methodFuncId = target.bytecodeClass.methodFuncIds[methodName];
            if (methodFuncId != null) {
              final res = executeFunction(
                funcId: methodFuncId,
                positionalArgs: posArgs,
                namedArgs: namedArgs,
                thisTarget: target,
              );
              _operandStack.add(res);
            } else if (target.nativeProxy != null) {
              final res = _invokeNativeMethod(
                target.nativeProxy,
                methodName,
                posArgs,
                namedArgs,
              );
              _operandStack.add(res);
            } else if (classes.containsKey(methodName)) {
              final bytecodeClass = classes[methodName]!;
              final instance = _createInstance(bytecodeClass);
              final ctorFuncId = bytecodeClass.constructorFuncIds['new'] ??
                  bytecodeClass.constructorFuncIds[''] ??
                  bytecodeClass.constructorFuncIds[methodName];
              if (ctorFuncId != null) {
                executeFunction(
                  funcId: ctorFuncId,
                  positionalArgs: posArgs,
                  namedArgs: namedArgs,
                  thisTarget: instance,
                );
              }
              _operandStack.add(instance);
            } else {
              final bridged = bridgeAdapter.invokeConstructor(
                methodName,
                'new',
                posArgs,
                namedArgs,
              );
              if (bridged != null) {
                _operandStack.add(bridged);
              } else {
                final res = bridgeAdapter.invokeTopLevel(
                  methodName,
                  posArgs,
                  namedArgs,
                );
                _operandStack.add(res);
              }
            }
          } else if (target is BytecodeNotifierProxy) {
            final methodFuncId = target.instance.bytecodeClass.methodFuncIds[methodName];
            if (methodFuncId != null) {
              final res = executeFunction(
                funcId: methodFuncId,
                positionalArgs: posArgs,
                namedArgs: namedArgs,
                thisTarget: target.instance,
              );
              _operandStack.add(res);
            } else {
              final res = _invokeNativeMethod(
                target,
                methodName,
                posArgs,
                namedArgs,
              );
              _operandStack.add(res);
            }
          } else if (target is BytecodeClosure) {
            final res = executeFunction(
              funcId: target.funcId,
              positionalArgs: posArgs,
              namedArgs: namedArgs,
              capturedEnv: target.capturedSlots,
            );
            _operandStack.add(res);
          } else if (target is Function) {
            try {
              final res = Function.apply(
                target,
                posArgs,
                namedArgs.map((k, v) => MapEntry(Symbol(k), v)),
              );
              _operandStack.add(res);
            } catch (e) {
              _operandStack.add(null);
            }
          } else if (target != null) {
            final res = _invokeNativeMethod(
              target,
              methodName,
              posArgs,
              namedArgs,
            );
            _operandStack.add(res);
          } else {
            // Target is null
            if (classes.containsKey(methodName)) {
              final bytecodeClass = classes[methodName]!;
              final instance = _createInstance(bytecodeClass);
              final ctorFuncId = bytecodeClass.constructorFuncIds['new'] ??
                  bytecodeClass.constructorFuncIds[''] ??
                  bytecodeClass.constructorFuncIds[methodName];
              if (ctorFuncId != null) {
                executeFunction(
                  funcId: ctorFuncId,
                  positionalArgs: posArgs,
                  namedArgs: namedArgs,
                  thisTarget: instance,
                );
              }
              _operandStack.add(instance);
            } else {
              final bridged = bridgeAdapter.invokeConstructor(
                methodName,
                'new',
                posArgs,
                namedArgs,
              );
              if (bridged != null) {
                _operandStack.add(bridged);
              } else {
                final res = bridgeAdapter.invokeTopLevel(
                  methodName,
                  posArgs,
                  namedArgs,
                );
                _operandStack.add(res);
              }
            }
          }
          break;

        case OpCode.callConstructor:
          final classConstIdx = data.getUint16(frame.pc);
          frame.pc += 2;
          final ctorConstIdx = data.getUint16(frame.pc);
          frame.pc += 2;
          final className = constantPool[classConstIdx]?.toString() ?? '';
          final ctorName = constantPool[ctorConstIdx]?.toString() ?? 'new';
          final posCount = code[frame.pc++];
          final namedCount = code[frame.pc++];

          final namedArgs = <String, Object?>{};
          for (var i = 0; i < namedCount; i++) {
            final val = _operandStack.removeLast();
            final name = _operandStack.removeLast()?.toString() ?? '';
            namedArgs[name] = val;
          }
          final posArgs = <Object?>[];
          for (var i = 0; i < posCount; i++) {
            posArgs.insert(0, _operandStack.removeLast());
          }

          if (classes.containsKey(className)) {
            final bytecodeClass = classes[className]!;
            final instance = _createInstance(bytecodeClass);
            final ctorFuncId = bytecodeClass.constructorFuncIds[ctorName] ??
                bytecodeClass.constructorFuncIds['new'] ??
                bytecodeClass.constructorFuncIds[''];
            if (ctorFuncId != null) {
              executeFunction(
                funcId: ctorFuncId,
                positionalArgs: posArgs,
                namedArgs: namedArgs,
                thisTarget: instance,
              );
            }
            _operandStack.add(instance);
          } else {
            // Native host bridged constructor
            final bridged = bridgeAdapter.invokeConstructor(
              className,
              ctorName,
              posArgs,
              namedArgs,
            );
            _operandStack.add(bridged);
          }
          break;

        case OpCode.jump:
          final offset = data.getInt32(frame.pc);
          frame.pc += 4;
          frame.pc += offset;
          break;

        case OpCode.jumpIfFalse:
          final offset = data.getInt32(frame.pc);
          frame.pc += 4;
          final cond = _operandStack.removeLast();
          if (cond == false || cond == null) {
            frame.pc += offset;
          }
          break;

        case OpCode.jumpIfTrue:
          final offset = data.getInt32(frame.pc);
          frame.pc += 4;
          final cond = _operandStack.removeLast();
          if (cond == true) {
            frame.pc += offset;
          }
          break;

        case OpCode.jumpIfNull:
          final offset = data.getInt32(frame.pc);
          frame.pc += 4;
          if (_operandStack.last == null) {
            _operandStack.removeLast();
            frame.pc += offset;
          }
          break;

        case OpCode.jumpIfNotNull:
          final offset = data.getInt32(frame.pc);
          frame.pc += 4;
          if (_operandStack.last != null) {
            frame.pc += offset;
          }
          break;

        case OpCode.ret:
          return null;

        case OpCode.retValue:
          return _operandStack.isNotEmpty ? _operandStack.removeLast() : null;

        case OpCode.unaryOp:
          final opId = code[frame.pc++];
          final val = _operandStack.removeLast();
          if (opId == UnaryOpId.not) {
            _operandStack.add(val != true);
          } else if (opId == UnaryOpId.neg) {
            _operandStack.add(val is num ? -val : 0);
          } else if (opId == UnaryOpId.bitNot) {
            _operandStack.add(val is int ? ~val : 0);
          }
          break;

        case OpCode.binaryOp:
          final binOp = code[frame.pc++];
          final right = _operandStack.removeLast();
          final left = _operandStack.removeLast();
          _operandStack.add(_evalBinary(binOp, left, right));
          break;

        default:
          throw UnsupportedError('Unknown OpCode: 0x${op.toRadixString(16)}');
      }
    }

    return null;
  }

  static const _sentinel = Object();

  Object? _createTearOff(BytecodeInstance instance, int funcId) {
    return ([
      Object? a0 = _sentinel,
      Object? a1 = _sentinel,
      Object? a2 = _sentinel,
      Object? a3 = _sentinel,
      Object? a4 = _sentinel,
    ]) {
      final pos = <Object?>[];
      if (!identical(a0, _sentinel)) pos.add(a0);
      if (!identical(a1, _sentinel)) pos.add(a1);
      if (!identical(a2, _sentinel)) pos.add(a2);
      if (!identical(a3, _sentinel)) pos.add(a3);
      if (!identical(a4, _sentinel)) pos.add(a4);
      return executeFunction(
        funcId: funcId,
        positionalArgs: pos,
        thisTarget: instance,
      );
    };
  }

  Object? _invokeNativeMethod(
    Object? target,
    String methodName,
    List<Object?> posArgs,
    Map<String, Object?> namedArgs,
  ) {
    if (target == null) return null;

    // 1. WidgetRef (Riverpod)
    if (target is WidgetRef) {
      final dynamicRef = target as dynamic;
      final provider = posArgs.isNotEmpty ? posArgs[0] : null;
      if (methodName == 'watch') {
        return dynamicRef.watch(provider as dynamic);
      } else if (methodName == 'read') {
        return dynamicRef.read(provider as dynamic);
      } else if (methodName == 'refresh') {
        return dynamicRef.refresh(provider as dynamic);
      } else if (methodName == 'invalidate') {
        dynamicRef.invalidate(provider as dynamic);
        return null;
      }
    }

    // 2. State / ConsumerState setState
    if (methodName == 'setState') {
      final callback = posArgs.isNotEmpty ? posArgs[0] : null;
      void runCallback() {
        if (callback is BytecodeClosure) {
          executeFunction(
            funcId: callback.funcId,
            capturedEnv: callback.capturedSlots,
            thisTarget: callback.capturedSlots.isNotEmpty &&
                    callback.capturedSlots[0] is BytecodeInstance
                ? callback.capturedSlots[0] as BytecodeInstance
                : (target is BytecodeStateProxy
                    ? target.stateInstance
                    : (target is BytecodeConsumerStateProxy
                        ? target.stateInstance
                        : null)),
          );
        } else if (callback is Function) {
          callback();
        }
      }

      if (target is State) {
        target.setState(runCallback);
        return null;
      } else if (target is ConsumerState) {
        target.setState(runCallback);
        return null;
      }
    }

    // 3. BytecodeNotifierProxy
    if (target is BytecodeNotifierProxy) {
      final methodFuncId = target.instance.bytecodeClass.methodFuncIds[methodName];
      if (methodFuncId != null) {
        return executeFunction(
          funcId: methodFuncId,
          positionalArgs: posArgs,
          namedArgs: namedArgs,
          thisTarget: target.instance,
        );
      }
      if (methodName == 'build') {
        return target.build();
      }
    }

    // 4. List / Iterable
    if (target is List) {
      if (methodName == 'where') {
        final predicate = posArgs.isNotEmpty ? posArgs[0] : null;
        final res = <Object?>[];
        for (final item in target) {
          bool match = false;
          if (predicate is BytecodeClosure) {
            match = executeFunction(
              funcId: predicate.funcId,
              positionalArgs: [item],
              capturedEnv: predicate.capturedSlots,
            ) == true;
          } else if (predicate is Function) {
            match = predicate(item) == true;
          }
          if (match) res.add(item);
        }
        return res;
      } else if (methodName == 'map') {
        final transform = posArgs.isNotEmpty ? posArgs[0] : null;
        final res = <Object?>[];
        for (final item in target) {
          if (transform is BytecodeClosure) {
            res.add(executeFunction(
              funcId: transform.funcId,
              positionalArgs: [item],
              capturedEnv: transform.capturedSlots,
            ));
          } else if (transform is Function) {
            res.add(transform(item));
          } else {
            res.add(null);
          }
        }
        return res;
      } else if (methodName == 'forEach') {
        final action = posArgs.isNotEmpty ? posArgs[0] : null;
        for (final item in target) {
          if (action is BytecodeClosure) {
            executeFunction(
              funcId: action.funcId,
              positionalArgs: [item],
              capturedEnv: action.capturedSlots,
            );
          } else if (action is Function) {
            action(item);
          }
        }
        return null;
      } else if (methodName == 'add') {
        target.add(posArgs.isNotEmpty ? posArgs[0] : null);
        return null;
      } else if (methodName == 'addAll') {
        final items = posArgs.isNotEmpty && posArgs[0] is Iterable
            ? posArgs[0] as Iterable
            : const [];
        target.addAll(items);
        return null;
      } else if (methodName == 'remove') {
        return target.remove(posArgs.isNotEmpty ? posArgs[0] : null);
      } else if (methodName == 'removeAt') {
        final idx = posArgs.isNotEmpty ? posArgs[0] as int : 0;
        if (idx >= 0 && idx < target.length) {
          return target.removeAt(idx);
        }
        return null;
      } else if (methodName == 'contains') {
        return target.contains(posArgs.isNotEmpty ? posArgs[0] : null);
      } else if (methodName == 'indexOf') {
        return target.indexOf(posArgs.isNotEmpty ? posArgs[0] : null);
      } else if (methodName == 'sublist') {
        final start = posArgs.isNotEmpty ? posArgs[0] as int : 0;
        final end = posArgs.length > 1 ? posArgs[1] as int? : null;
        return target.sublist(start, end);
      } else if (methodName == 'toList') {
        return List<Object?>.from(target);
      } else if (methodName == 'toSet') {
        return Set<Object?>.from(target);
      } else if (methodName == 'join') {
        final sep = posArgs.isNotEmpty ? posArgs[0]?.toString() ?? '' : '';
        return target.join(sep);
      } else if (methodName == 'clear') {
        target.clear();
        return null;
      }
    }

    // 5. String
    if (target is String) {
      if (methodName == 'trim') return target.trim();
      if (methodName == 'trimLeft') return target.trimLeft();
      if (methodName == 'trimRight') return target.trimRight();
      if (methodName == 'toLowerCase') return target.toLowerCase();
      if (methodName == 'toUpperCase') return target.toUpperCase();
      if (methodName == 'startsWith') {
        return target.startsWith(posArgs.isNotEmpty ? posArgs[0]?.toString() ?? '' : '');
      }
      if (methodName == 'endsWith') {
        return target.endsWith(posArgs.isNotEmpty ? posArgs[0]?.toString() ?? '' : '');
      }
      if (methodName == 'contains') {
        return target.contains(posArgs.isNotEmpty ? posArgs[0]?.toString() ?? '' : '');
      }
      if (methodName == 'replaceAll') {
        final from = posArgs.isNotEmpty ? posArgs[0]?.toString() ?? '' : '';
        final to = posArgs.length > 1 ? posArgs[1]?.toString() ?? '' : '';
        return target.replaceAll(from, to);
      }
      if (methodName == 'replaceFirst') {
        final from = posArgs.isNotEmpty ? posArgs[0]?.toString() ?? '' : '';
        final to = posArgs.length > 1 ? posArgs[1]?.toString() ?? '' : '';
        return target.replaceFirst(from, to);
      }
      if (methodName == 'substring') {
        final start = posArgs.isNotEmpty ? posArgs[0] as int : 0;
        final end = posArgs.length > 1 ? posArgs[1] as int? : null;
        return target.substring(start, end);
      }
      if (methodName == 'split') {
        final pattern = posArgs.isNotEmpty ? posArgs[0]?.toString() ?? '' : '';
        return target.split(pattern);
      }
      if (methodName == 'toString') return target.toString();
    }

    // 6. Map
    if (target is Map) {
      if (methodName == 'containsKey') {
        return target.containsKey(posArgs.isNotEmpty ? posArgs[0] : null);
      }
      if (methodName == 'containsValue') {
        return target.containsValue(posArgs.isNotEmpty ? posArgs[0] : null);
      }
      if (methodName == 'remove') {
        return target.remove(posArgs.isNotEmpty ? posArgs[0] : null);
      }
      if (methodName == 'clear') {
        target.clear();
        return null;
      }
    }

    // 7. num / int / double
    if (target is num) {
      if (methodName == 'toDouble') return target.toDouble();
      if (methodName == 'toInt') return target.toInt();
      if (methodName == 'toStringAsFixed') {
        final fractionDigits = posArgs.isNotEmpty ? posArgs[0] as int : 0;
        return target.toStringAsFixed(fractionDigits);
      }
      if (methodName == 'abs') return target.abs();
      if (methodName == 'round') return target.round();
      if (methodName == 'floor') return target.floor();
      if (methodName == 'ceil') return target.ceil();
      if (methodName == 'toString') return target.toString();
    }

    // 8. DNSheetController
    if (target is DNSheetController) {
      if (methodName == 'dismiss') {
        target.dismiss();
        return null;
      }
      if (methodName == 'snapTo') {
        if (posArgs.isNotEmpty && posArgs[0] is DNSheetDetent) {
          target.snapTo(posArgs[0] as DNSheetDetent);
        }
        return null;
      }
    }

    // 9. TextEditingController
    if (target is TextEditingController) {
      if (methodName == 'clear') {
        target.clear();
        return null;
      }
      if (methodName == 'dispose') {
        target.dispose();
        return null;
      }
    }

    // 10. DateTime
    if (target is DateTime) {
      if (methodName == 'isBefore' && posArgs.isNotEmpty && posArgs[0] is DateTime) {
        return target.isBefore(posArgs[0] as DateTime);
      }
      if (methodName == 'isAfter' && posArgs.isNotEmpty && posArgs[0] is DateTime) {
        return target.isAfter(posArgs[0] as DateTime);
      }
      if (methodName == 'toIso8601String') {
        return target.toIso8601String();
      }
      if (methodName == 'toString') {
        return target.toString();
      }
    }

    // 11. Function
    if (target is Function) {
      try {
        return Function.apply(
          target,
          posArgs,
          namedArgs.map((k, v) => MapEntry(Symbol(k), v)),
        );
      } catch (e) {
        DartGoLogger.debug('Error invoking Dart function: $e', tag: 'BytecodeVM');
      }
    }

    // 12. Delegate to bridged instance method from AST bridges
    final bridgedResult = bridgeAdapter.invokeInstanceMethod(
      target,
      methodName,
      posArgs,
      namedArgs,
    );
    if (bridgedResult != null) return bridgedResult;

    // 13. Fallback to bridged top-level function
    return bridgeAdapter.invokeTopLevel(methodName, posArgs, namedArgs);
  }

  Object? _evalBinary(int opId, Object? l, Object? r) {
    if (opId == BinaryOpId.add) {
      if (l is num && r is num) return l + r;
      return '$l$r';
    }
    if (l is num && r is num) {
      switch (opId) {
        case BinaryOpId.sub:
          return l - r;
        case BinaryOpId.mul:
          return l * r;
        case BinaryOpId.div:
          return l / r;
        case BinaryOpId.truncDiv:
          return l ~/ r;
        case BinaryOpId.mod:
          return l % r;
        case BinaryOpId.lt:
          return l < r;
        case BinaryOpId.lte:
          return l <= r;
        case BinaryOpId.gt:
          return l > r;
        case BinaryOpId.gte:
          return l >= r;
      }
    }
    if (opId == BinaryOpId.eq) return l == r;
    if (opId == BinaryOpId.neq) return l != r;
    if (opId == BinaryOpId.lt ||
        opId == BinaryOpId.lte ||
        opId == BinaryOpId.gt ||
        opId == BinaryOpId.gte) {
      return false;
    }
    return null;
  }

  /// Wraps an interpreted object or widget into a Flutter [Widget].
  Widget? unwrapWidget(Object? obj) {
    if (obj == null) return null;
    if (obj is Widget) return obj;
    if (obj is BytecodeInstance) {
      if (obj.nativeProxy is Widget) return obj.nativeProxy as Widget;
      final superclassName = obj.bytecodeClass.superclass;

      if (superclassName == 'StatelessWidget') {
        return BytecodeStatelessWidget(this, obj);
      } else if (superclassName == 'StatefulWidget') {
        return BytecodeStatefulWidget(this, obj);
      } else if (superclassName == 'ConsumerWidget') {
        return BytecodeConsumerWidget(this, obj);
      } else if (superclassName == 'ConsumerStatefulWidget') {
        return BytecodeConsumerStatefulWidget(this, obj);
      }

      if (obj.bytecodeClass.methodFuncIds.containsKey('build')) {
        return BytecodeStatelessWidget(this, obj);
      }
      if (obj.bytecodeClass.methodFuncIds.containsKey('createState')) {
        return BytecodeStatefulWidget(this, obj);
      }
    }
    return null;
  }
}

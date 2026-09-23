import 'package:dartnative/dartnative.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:tom_d4rt_ast/d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart';

import '../../interpreter/ast/dartscript.b.dart' as ast_bridges;
import '../logger.dart';
import 'bytecode_widget_proxies.dart';
import 'call_frame.dart';
import 'vm.dart';

/// Adapter providing reflection-free dispatch to native DartNative host widgets and plugins.
class BytecodeBridgeAdapter {
  static final Map<String, LibraryClass> _classByName = {};
  static final Map<Type, LibraryClass> _classByType = {};
  static final Map<String, LibraryEnum> _enumByName = {};
  static final Map<String, LibraryFunction> _topLevelFuncByName = {};
  static final Map<String, LibraryVariable> _topLevelVarByName = {};
  static final Map<String, LibraryGetter> _topLevelGetterByName = {};
  static bool _bridgesInitialized = false;
  static late final InterpreterVisitor _sharedVisitor;

  static void ensureInitialized() {
    if (_bridgesInitialized) return;
    _bridgesInitialized = true;

    D4.customUnwrapper = (value) {
      if (value is BytecodeInstance && value.nativeProxy != null) {
        return value.nativeProxy;
      }
      return null;
    };

    final runner = D4rtRunner();
    ast_bridges.DartnativeGoAstBridges.register(runner);

    for (final libMap in runner.bridgedClasses.values) {
      for (final entry in libMap.entries) {
        _classByName[entry.key] = entry.value;
        _classByType[entry.value.nativeType] = entry.value;
      }
    }

    for (final alias in runner.classAliases) {
      final target = _classByName[alias.targetName];
      if (target != null) {
        _classByName[alias.aliasName] = target;
      }
    }

    for (final enumMap in runner.bridgedEnumDefinitions.values) {
      for (final entry in enumMap.entries) {
        _enumByName[entry.key] = entry.value;
      }
    }

    for (final funcMap in runner.libraryFunctions.values) {
      for (final entry in funcMap.entries) {
        _topLevelFuncByName[entry.key] = entry.value;
      }
    }

    for (final varMap in runner.libraryVariables.values) {
      for (final entry in varMap.entries) {
        _topLevelVarByName[entry.key] = entry.value;
      }
    }

    for (final getterMap in runner.libraryGetters.values) {
      for (final entry in getterMap.entries) {
        _topLevelGetterByName[entry.key] = entry.value;
      }
    }

    final env = Environment();
    final moduleContext = NoOpModuleContext(globalEnvironment: env);
    _sharedVisitor = InterpreterVisitor(
      globalEnvironment: env,
      moduleContext: moduleContext,
    );
  }

  static Object? unwrapArgument(Object? arg) {
    if (arg == null) return null;
    if (arg is BytecodeInstance) {
      if (arg.nativeProxy != null) return arg.nativeProxy;
      return arg;
    }
    if (arg is List) {
      return arg.map((item) => unwrapArgument(item)).toList();
    }
    if (arg is Set) {
      return arg.map((item) => unwrapArgument(item)).toSet();
    }
    if (arg is Map) {
      return arg.map((k, v) => MapEntry(k, unwrapArgument(v)));
    }
    return arg;
  }

  Widget? capturedApp;
  void Function(String)? onLog;
  String? Function()? serverUrlProvider;
  Widget? Function(Object?)? widgetUnwrapper;
  BytecodeVM? vm;

  BytecodeBridgeAdapter({
    this.onLog,
    this.serverUrlProvider,
    this.widgetUnwrapper,
    this.vm,
  }) {
    ensureInitialized();
  }

  /// Resolves an instantiated class, constructor, or bridged function call.
  Object? invokeConstructor(
    String className,
    String ctorName,
    List<Object?> positional,
    Map<String, Object?> named,
  ) {
    ensureInitialized();

    final libClass = _classByName[className];
    if (libClass != null) {
      final bridgedClass = libClass.bridgedClass;
      final ctorKey = (ctorName == 'new' || ctorName.isEmpty) ? '' : ctorName;
      final ctor = bridgedClass.constructors[ctorKey] ?? bridgedClass.constructors[ctorName];
      if (ctor != null) {
        final posUnwrapped = positional.map(unwrapArgument).toList();
        final namedUnwrapped = named.map((k, v) => MapEntry(k, unwrapArgument(v)));
        try {
          return ctor(_sharedVisitor, posUnwrapped, namedUnwrapped);
        } catch (e) {
          DartGoLogger.debug(
            'Generated bridge ctor $className.$ctorName failed: $e, falling back to manual adapter',
            tag: 'BytecodeBridge',
          );
        }
      }
    }

    switch (className) {
      // Core UI Widgets
      case 'Text':
        final text = positional.isNotEmpty
            ? positional[0]?.toString() ?? ''
            : '';
        return Text(
          text,
          style: named['style'] as TextStyle?,
          textAlign: named['textAlign'] as TextAlign?,
          maxLines: named['maxLines'] as int?,
          overflow: named['overflow'] as TextOverflow?,
        );

      case 'Center':
        return Center(
          child:
              _unwrapWidget(
                named['child'] ??
                    (positional.isNotEmpty ? positional[0] : null),
              ) ??
              const SizedBox.shrink(),
        );

      case 'Scaffold':
        return Scaffold(
          appBar: _unwrapWidget(named['appBar']) as PreferredSizeWidget?,
          body: _unwrapWidget(named['body']),
          backgroundColor: named['backgroundColor'] as Color?,
          floatingActionButton: _unwrapWidget(named['floatingActionButton']),
          resizeToAvoidBottomInset:
              named['resizeToAvoidBottomInset'] as bool? ?? true,
          extendBodyBehindAppBar:
              named['extendBodyBehindAppBar'] as bool? ?? false,
        );

      case 'AppBar':
        return AppBar(
          title: _unwrapWidget(
            named['title'] ?? (positional.isNotEmpty ? positional[0] : null),
          ),
          centerTitle: named['centerTitle'] as bool?,
          backgroundColor: named['backgroundColor'] as Color?,
          titleGlassBackground: named['titleGlassBackground'] as bool? ?? false,
          actions: (named['actions'] as List<dynamic>?)
              ?.map((a) => a is BarButtonItem ? a : _unwrapWidget(a))
              .whereType<Widget>()
              .toList(),
        );

      case 'BarButtonItem':
        return BarButtonItem(
          fontIcon: named['fontIcon'] as IconData?,
          title: (named['title'] ?? named['label']) as String?,
          titleStyle: named['titleStyle'] as TextStyle?,
          onPressed: _coerceVoidCallback(named['onPressed'] ?? named['onTap']),
        );

      case 'Column':
        final rawChildren = named['children'] as List<dynamic>? ?? const [];
        return Column(
          mainAxisAlignment:
              named['mainAxisAlignment'] as MainAxisAlignment? ??
              MainAxisAlignment.start,
          crossAxisAlignment:
              named['crossAxisAlignment'] as CrossAxisAlignment? ??
              CrossAxisAlignment.center,
          mainAxisSize: named['mainAxisSize'] as MainAxisSize? ?? MainAxisSize.max,
          children: rawChildren
              .map((c) => _unwrapWidget(c) ?? const SizedBox.shrink())
              .toList(),
        );

      case 'Row':
        final rawChildren = named['children'] as List<dynamic>? ?? const [];
        return Row(
          mainAxisAlignment:
              named['mainAxisAlignment'] as MainAxisAlignment? ??
              MainAxisAlignment.start,
          crossAxisAlignment:
              named['crossAxisAlignment'] as CrossAxisAlignment? ??
              CrossAxisAlignment.center,
          mainAxisSize: named['mainAxisSize'] as MainAxisSize? ?? MainAxisSize.max,
          children: rawChildren
              .map((c) => _unwrapWidget(c) ?? const SizedBox.shrink())
              .toList(),
        );

      case 'Container':
        return Container(
          width: (named['width'] as num?)?.toDouble(),
          height: (named['height'] as num?)?.toDouble(),
          padding: named['padding'] as EdgeInsetsGeometry?,
          margin: named['margin'] as EdgeInsetsGeometry?,
          color: named['color'] as Color?,
          decoration: named['decoration'] as Decoration?,
          alignment: named['alignment'] as AlignmentGeometry?,
          child: _unwrapWidget(named['child']),
        );

      case 'SizedBox':
        return SizedBox(
          width: (named['width'] as num?)?.toDouble(),
          height: (named['height'] as num?)?.toDouble() ??
              (positional.isNotEmpty ? (positional[0] as num?)?.toDouble() : null),
          child: _unwrapWidget(named['child']),
        );

      case 'Expanded':
        return Expanded(
          flex: named['flex'] as int? ?? 1,
          child:
              _unwrapWidget(
                named['child'] ??
                    (positional.isNotEmpty ? positional[0] : null),
              ) ??
              const SizedBox.shrink(),
        );

      case 'DefaultTextStyle':
        return DefaultTextStyle(
          style: named['style'] as TextStyle? ?? const TextStyle(),
          child:
              _unwrapWidget(
                named['child'] ??
                    (positional.isNotEmpty ? positional[0] : null),
              ) ??
              const SizedBox.shrink(),
        );

      case 'Image':
        if (ctorName == 'asset') {
          final name = positional.isNotEmpty
              ? positional[0]?.toString() ?? ''
              : (named['name']?.toString() ?? '');
          return Image.asset(
            name,
            width: (named['width'] as num?)?.toDouble(),
            height: (named['height'] as num?)?.toDouble(),
            fit: named['fit'] as BoxFit?,
          );
        } else if (ctorName == 'network') {
          final src = positional.isNotEmpty
              ? positional[0]?.toString() ?? ''
              : (named['src']?.toString() ?? '');
          return Image.network(
            src,
            width: (named['width'] as num?)?.toDouble(),
            height: (named['height'] as num?)?.toDouble(),
            fit: named['fit'] as BoxFit?,
          );
        }
        return const SizedBox.shrink();

      case 'Padding':
        return Padding(
          padding: named['padding'] as EdgeInsetsGeometry? ?? EdgeInsets.zero,
          child: _unwrapWidget(named['child']) ?? const SizedBox.shrink(),
        );

      case 'Button':
        return Button(
          onPressed: _coerceVoidCallback(named['onPressed'] ?? named['onTap']),
          title: named['title'] as String?,
          child: _unwrapWidget(named['child']),
          color: named['color'] as Color?,
          foregroundColor: named['foregroundColor'] as Color?,
          padding: named['padding'] as EdgeInsetsGeometry?,
          variant: named['variant'] as ButtonVariant? ?? ButtonVariant.filled,
        );

      case 'IconButton':
        return IconButton(
          onPressed: _coerceVoidCallback(named['onPressed'] ?? named['onTap']),
          icon: _unwrapWidget(named['icon'] ?? (positional.isNotEmpty ? positional[0] : null)) ?? const SizedBox.shrink(),
        );

      case 'Icon':
        final iconData = positional.isNotEmpty
            ? positional[0] as IconData?
            : (named['icon'] as IconData?);
        return Icon(
          iconData ?? const IconData(0),
          size: (named['size'] as num?)?.toDouble(),
          color: named['color'] as Color?,
        );

      case 'SingleChildScrollView':
        return SingleChildScrollView(
          scrollDirection: named['scrollDirection'] as Axis? ?? Axis.vertical,
          padding: named['padding'] as EdgeInsetsGeometry?,
          child: _unwrapWidget(
                named['child'] ??
                    (positional.isNotEmpty ? positional[0] : null),
              ) ??
              const SizedBox.shrink(),
        );

      case 'ListView':
        if (ctorName == 'builder') {
          final itemCount = named['itemCount'] as int? ?? 0;
          final padding = named['padding'] as EdgeInsetsGeometry?;
          final itemBuilder = named['itemBuilder'];
          return ListView.builder(
            padding: padding,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (itemBuilder is BytecodeClosure && vm != null) {
                final res = vm!.executeFunction(
                  funcId: itemBuilder.funcId,
                  positionalArgs: [context, index],
                  capturedEnv: itemBuilder.capturedSlots,
                );
                return _unwrapWidget(res) ?? const SizedBox.shrink();
              } else if (itemBuilder is Function) {
                final res = itemBuilder(context, index);
                return _unwrapWidget(res) ?? const SizedBox.shrink();
              }
              return const SizedBox.shrink();
            },
          );
        }
        final rawChildren = named['children'] as List<dynamic>? ?? const [];
        return ListView(
          scrollDirection: named['scrollDirection'] as Axis? ?? Axis.vertical,
          padding: named['padding'] as EdgeInsetsGeometry?,
          children: rawChildren
              .map((c) => _unwrapWidget(c) ?? const SizedBox.shrink())
              .toList(),
        );

      case 'GridView':
        if (ctorName == 'builder') {
          final itemCount = named['itemCount'] as int? ?? 0;
          final gridDelegate = named['gridDelegate'] as SliverGridDelegateWithFixedCrossAxisCount? ??
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);
          final padding = named['padding'] as EdgeInsetsGeometry?;
          final itemBuilder = named['itemBuilder'];
          return GridView.builder(
            padding: padding,
            gridDelegate: gridDelegate,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (itemBuilder is BytecodeClosure && vm != null) {
                final res = vm!.executeFunction(
                  funcId: itemBuilder.funcId,
                  positionalArgs: [context, index],
                  capturedEnv: itemBuilder.capturedSlots,
                );
                return _unwrapWidget(res) ?? const SizedBox.shrink();
              } else if (itemBuilder is Function) {
                final res = itemBuilder(context, index);
                return _unwrapWidget(res) ?? const SizedBox.shrink();
              }
              return const SizedBox.shrink();
            },
          );
        }
        final rawChildren = named['children'] as List<dynamic>? ?? const [];
        return GridView(
          gridDelegate: named['gridDelegate'] as SliverGridDelegateWithFixedCrossAxisCount? ??
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          padding: named['padding'] as EdgeInsetsGeometry?,
          children: rawChildren
              .map((c) => _unwrapWidget(c) ?? const SizedBox.shrink())
              .toList(),
        );

      case 'SliverGridDelegateWithFixedCrossAxisCount':
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: named['crossAxisCount'] as int? ??
              (positional.isNotEmpty ? positional[0] as int : 2),
          mainAxisSpacing:
              (named['mainAxisSpacing'] as num?)?.toDouble() ?? 0.0,
          crossAxisSpacing:
              (named['crossAxisSpacing'] as num?)?.toDouble() ?? 0.0,
          childAspectRatio:
              (named['childAspectRatio'] as num?)?.toDouble() ?? 1.0,
        );

      case 'SafeArea':
        return SafeArea(
          top: named['top'] as bool? ?? true,
          bottom: named['bottom'] as bool? ?? true,
          left: named['left'] as bool? ?? true,
          right: named['right'] as bool? ?? true,
          child:
              _unwrapWidget(
                named['child'] ??
                    (positional.isNotEmpty ? positional[0] : null),
              ) ??
              const SizedBox.shrink(),
        );

      case 'GestureDetector':
        return GestureDetector(
          onTap: _coerceVoidCallback(named['onTap'] ?? named['onPressed']),
          onLongPress: _coerceVoidCallback(named['onLongPress']),
          child: _unwrapWidget(
            named['child'] ?? (positional.isNotEmpty ? positional[0] : null),
          ),
        );

      case 'InkWell':
        return InkWell(
          onTap: _coerceVoidCallback(named['onTap'] ?? named['onPressed']),
          onLongPress: _coerceVoidCallback(named['onLongPress']),
          child: _unwrapWidget(
            named['child'] ?? (positional.isNotEmpty ? positional[0] : null),
          ),
        );

      case 'Stack':
        final rawChildren = named['children'] as List<dynamic>? ?? const [];
        return Stack(
          alignment:
              named['alignment'] as AlignmentGeometry? ??
              AlignmentDirectional.topStart,
          children: rawChildren
              .map((c) => _unwrapWidget(c) ?? const SizedBox.shrink())
              .toList(),
        );

      case 'Positioned':
        if (ctorName == 'fill') {
          return Positioned.fill(
            child:
                _unwrapWidget(
                  named['child'] ??
                      (positional.isNotEmpty ? positional[0] : null),
                ) ??
                const SizedBox.shrink(),
          );
        }
        return Positioned(
          left: (named['left'] as num?)?.toDouble(),
          top: (named['top'] as num?)?.toDouble(),
          right: (named['right'] as num?)?.toDouble(),
          bottom: (named['bottom'] as num?)?.toDouble(),
          width: (named['width'] as num?)?.toDouble(),
          height: (named['height'] as num?)?.toDouble(),
          child:
              _unwrapWidget(
                named['child'] ??
                    (positional.isNotEmpty ? positional[0] : null),
              ) ??
              const SizedBox.shrink(),
        );

      case 'Spacer':
        return Spacer(flex: named['flex'] as int? ?? 1);

      case 'TextField':
        return TextField(
          controller: named['controller'] as TextEditingController?,
          decoration: named['decoration'] as InputDecoration?,
          onChanged: _coerceValueChanged<String>(named['onChanged']),
          autofocus: named['autofocus'] as bool? ?? false,
          maxLines: named['maxLines'] as int? ?? 1,
          style: named['style'] as TextStyle?,
          key: named['key'] as Key?,
          textInputAction: named['textInputAction'] as TextInputAction?,
        );

      case 'TextEditingController':
        return TextEditingController(text: named['text'] as String?);

      case 'InputDecoration':
        return InputDecoration(
          hintText: named['hintText'] as String?,
          hintStyle: named['hintStyle'] as TextStyle?,
          filled: named['filled'] as bool? ?? false,
          fillColor: named['fillColor'] as Color?,
          border: named['border'] as InputBorder?,
          contentPadding: named['contentPadding'] as EdgeInsetsGeometry?,
        );

      case 'OutlineInputBorder':
        return OutlineInputBorder(
          borderRadius: named['borderRadius'] as BorderRadius? ??
              const BorderRadius.all(Radius.circular(4.0)),
          borderSide: named['borderSide'] as BorderSide? ?? const BorderSide(),
        );

      case 'BorderSide':
        return BorderSide(
          color: named['color'] as Color? ?? const Color(0xFF000000),
          width: (named['width'] as num?)?.toDouble() ?? 1.0,
        );

      case 'Border':
        if (ctorName == 'all') {
          return Border.all(
            color: named['color'] as Color? ?? const Color(0xFF000000),
            width: (named['width'] as num?)?.toDouble() ?? 1.0,
          );
        }
        return const Border();

      case 'BoxShadow':
        return BoxShadow(
          color: named['color'] as Color? ?? const Color(0xFF000000),
          offset: named['offset'] as Offset? ?? Offset.zero,
          blurRadius: (named['blurRadius'] as num?)?.toDouble() ?? 0.0,
          spreadRadius: (named['spreadRadius'] as num?)?.toDouble() ?? 0.0,
        );

      case 'Offset':
        final dx = (positional.isNotEmpty ? positional[0] as num? : null)
                ?.toDouble() ??
            (named['dx'] as num?)?.toDouble() ??
            0.0;
        final dy = (positional.length > 1 ? positional[1] as num? : null)
                ?.toDouble() ??
            (named['dy'] as num?)?.toDouble() ??
            0.0;
        return Offset(dx, dy);

      case 'Key':
        final val = positional.isNotEmpty
            ? positional[0]?.toString() ?? ''
            : (named['value']?.toString() ?? '');
        return Key(val);

      case 'Transform':
        if (ctorName == 'rotate') {
          final angle = (named['angle'] as num?)?.toDouble() ??
              (positional.isNotEmpty
                  ? (positional[0] as num?)?.toDouble() ?? 0.0
                  : 0.0);
          return Transform.rotate(
            angle: angle,
            child: _unwrapWidget(named['child']),
          );
        } else if (ctorName == 'scale') {
          final scale = (named['scale'] as num?)?.toDouble() ??
              (positional.isNotEmpty
                  ? (positional[0] as num?)?.toDouble() ?? 1.0
                  : 1.0);
          return Transform.scale(
            scale: scale,
            child: _unwrapWidget(named['child']),
          );
        }
        return Transform.translate(
          offset: Offset.zero,
          child: _unwrapWidget(named['child']),
        );

      case 'Alignment':
        final x = (positional.isNotEmpty ? positional[0] as num? : null)
                ?.toDouble() ??
            0.0;
        final y = (positional.length > 1 ? positional[1] as num? : null)
                ?.toDouble() ??
            0.0;
        return Alignment(x, y);

      // Riverpod Kit
      case 'ProviderScope':
        return ProviderScope(
          child:
              _unwrapWidget(
                named['child'] ??
                    (positional.isNotEmpty ? positional[0] : null),
              ) ??
              const SizedBox.shrink(),
        );

      case 'NotifierProvider':
        final createFn = positional.isNotEmpty ? positional[0] : null;
        return NotifierProvider<Notifier<dynamic>, dynamic>(() {
          Object? rawNotifier;
          if (createFn is BytecodeClosure && vm != null) {
            rawNotifier = vm!.executeFunction(
              funcId: createFn.funcId,
              capturedEnv: createFn.capturedSlots,
            );
          } else if (createFn is Function) {
            rawNotifier = createFn();
          }
          if (rawNotifier is BytecodeInstance && vm != null) {
            return BytecodeNotifierProxy(vm!, rawNotifier);
          } else if (rawNotifier is Notifier<dynamic>) {
            return rawNotifier;
          }
          throw StateError('NotifierProvider factory must return a Notifier');
        });

      // Platform & System UI
      case 'SystemUiOverlayStyle':
        return SystemUiOverlayStyle(
          statusBarColor: named['statusBarColor'] as Color?,
          statusBarBrightness: named['statusBarBrightness'] as Brightness?,
          statusBarIconBrightness:
              named['statusBarIconBrightness'] as Brightness?,
          systemNavigationBarColor: named['systemNavigationBarColor'] as Color?,
          systemNavigationBarIconBrightness:
              named['systemNavigationBarIconBrightness'] as Brightness?,
          systemNavigationBarDividerColor:
              named['systemNavigationBarDividerColor'] as Color?,
        );

      // Styling and Values
      case 'TextStyle':
        return TextStyle(
          fontSize: (named['fontSize'] as num?)?.toDouble(),
          color: named['color'] as Color?,
          fontWeight: named['fontWeight'] as FontWeight?,
          fontStyle: named['fontStyle'] as FontStyle?,
          height: (named['height'] as num?)?.toDouble(),
          decoration: named['decoration'] as TextDecoration?,
        );

      case 'BoxDecoration':
        return BoxDecoration(
          color: named['color'] as Color?,
          borderRadius: named['borderRadius'] as BorderRadius?,
          border: named['border'] as BoxBorder?,
          boxShadow: (named['boxShadow'] as List<dynamic>?)?.cast<BoxShadow>(),
          shape: named['shape'] as BoxShape? ?? BoxShape.rectangle,
        );

      case 'EdgeInsets':
        if (ctorName == 'all') {
          final val =
              (positional.isNotEmpty ? positional[0] as num? : null)
                  ?.toDouble() ??
              0.0;
          return EdgeInsets.all(val);
        } else if (ctorName == 'symmetric') {
          final h = (named['horizontal'] as num?)?.toDouble() ?? 0.0;
          final v = (named['vertical'] as num?)?.toDouble() ?? 0.0;
          return EdgeInsets.symmetric(horizontal: h, vertical: v);
        } else if (ctorName == 'only') {
          return EdgeInsets.only(
            left: (named['left'] as num?)?.toDouble() ?? 0.0,
            top: (named['top'] as num?)?.toDouble() ?? 0.0,
            right: (named['right'] as num?)?.toDouble() ?? 0.0,
            bottom: (named['bottom'] as num?)?.toDouble() ?? 0.0,
          );
        } else if (ctorName == 'fromLTRB') {
          final l = (positional.isNotEmpty ? positional[0] as num? : null)
                  ?.toDouble() ??
              (named['left'] as num?)?.toDouble() ??
              0.0;
          final t = (positional.length > 1 ? positional[1] as num? : null)
                  ?.toDouble() ??
              (named['top'] as num?)?.toDouble() ??
              0.0;
          final r = (positional.length > 2 ? positional[2] as num? : null)
                  ?.toDouble() ??
              (named['right'] as num?)?.toDouble() ??
              0.0;
          final b = (positional.length > 3 ? positional[3] as num? : null)
                  ?.toDouble() ??
              (named['bottom'] as num?)?.toDouble() ??
              0.0;
          return EdgeInsets.fromLTRB(l, t, r, b);
        }
        return EdgeInsets.zero;

      case 'BorderRadius':
        if (ctorName == 'circular') {
          final val =
              (positional.isNotEmpty ? positional[0] as num? : null)
                  ?.toDouble() ??
              0.0;
          return BorderRadius.circular(val);
        }
        return BorderRadius.zero;

      case 'Color':
        final val = positional.isNotEmpty ? positional[0] as int? ?? 0 : 0;
        return Color(val);

      case 'DateTime':
        if (ctorName == 'now') return DateTime.now();
        if (ctorName == 'fromMicrosecondsSinceEpoch') {
          return DateTime.fromMicrosecondsSinceEpoch(positional[0] as int);
        }
        if (ctorName == 'fromMillisecondsSinceEpoch') {
          return DateTime.fromMillisecondsSinceEpoch(positional[0] as int);
        }
        return DateTime.now();

      case 'ThemeData':
        if (ctorName == 'dark') return ThemeData.dark();
        if (ctorName == 'light') return ThemeData.light();
        return ThemeData(
          colorScheme:
              named['colorScheme'] as ColorScheme? ?? ColorScheme.dark(),
          textTheme: named['textTheme'] as TextTheme? ?? const TextTheme(),
          brightness: named['brightness'] as Brightness? ?? Brightness.dark,
          scaffoldBackgroundColor: named['scaffoldBackgroundColor'] as Color?,
          dividerColor: named['dividerColor'] as Color?,
          primaryColor: named['primaryColor'] as Color?,
        );

      case 'ColorScheme':
        if (ctorName == 'dark') {
          return ColorScheme.dark();
        } else if (ctorName == 'light') {
          return ColorScheme.light();
        }
        return ColorScheme.dark();

      case 'SystemChrome':
        if (ctorName == 'setSystemUIOverlayStyle') {
          final style = positional.isNotEmpty ? positional[0] as SystemUiOverlayStyle? : null;
          if (style != null) {
            SystemChrome.setSystemUIOverlayStyle(style);
          }
          return null;
        }
        return null;

      default:
        final fallback = invokeTopLevel('$className.$ctorName', positional, named) ??
            invokeTopLevel(ctorName, positional, named);
        if (fallback != null) return fallback;
        DartGoLogger.debug(
          'Unrecognized bridged constructor: $className.$ctorName',
          tag: 'BytecodeBridge',
        );
        return null;
    }
  }

  /// Resolves static identifiers, constants, and enums.
  Object? resolveGlobalOrStatic(String name) {
    ensureInitialized();

    final dot = name.indexOf('.');
    if (dot != -1) {
      final prefix = name.substring(0, dot);
      final member = name.substring(dot + 1);

      // 1. Check Enum
      final libEnum = _enumByName[prefix];
      if (libEnum != null) {
        final enumDef = libEnum.enumDefinition;
        for (final val in enumDef.values) {
          if (val.name == member) return val;
        }
        final staticGetter = enumDef.staticGetters[member];
        if (staticGetter != null) {
          try {
            return staticGetter();
          } catch (_) {}
        }
      }

      // 2. Check BridgedClass static getters / fields
      final libClass = _classByName[prefix];
      if (libClass != null) {
        final bridgedClass = libClass.bridgedClass;
        final staticGetter = bridgedClass.staticGetters[member];
        if (staticGetter != null) {
          try {
            return staticGetter(_sharedVisitor);
          } catch (_) {}
        }
      }
    }

    final topVar = _topLevelVarByName[name];
    if (topVar != null) {
      return topVar.value;
    }
    final topGetter = _topLevelGetterByName[name];
    if (topGetter != null) {
      try {
        return topGetter.getter();
      } catch (_) {}
    }

    switch (name) {
      // Colors
      case 'Colors.transparent':
        return Colors.transparent;
      case 'Colors.white':
        return Colors.white;
      case 'Colors.black':
        return Colors.black;
      case 'Colors.grey':
        return Colors.grey;
      case 'Colors.red':
        return Colors.red;
      case 'Colors.blue':
        return Colors.blue;
      case 'Colors.green':
        return Colors.green;
      case 'Colors.blue.shade50':
        return Colors.blue.shade50;
      case 'Colors.blue.shade100':
        return Colors.blue.shade100;
      case 'Colors.blue.shade200':
        return Colors.blue.shade200;
      case 'Colors.blue.shade300':
        return Colors.blue.shade300;
      case 'Colors.blue.shade400':
        return Colors.blue.shade400;
      case 'Colors.blue.shade500':
        return Colors.blue.shade500;
      case 'Colors.blue.shade600':
        return Colors.blue.shade600;
      case 'Colors.blue.shade700':
        return Colors.blue.shade700;
      case 'Colors.blue.shade800':
        return Colors.blue.shade800;
      case 'Colors.blue.shade900':
        return Colors.blue.shade900;

      // Note Colors
      case 'NoteColors.yellow':
        return const Color(0xFFFFF3A3);
      case 'NoteColors.pink':
        return const Color(0xFFFFC9D6);
      case 'NoteColors.blue':
        return const Color(0xFFBFE3FF);
      case 'NoteColors.green':
        return const Color(0xFFC8F7C5);
      case 'NoteColors.purple':
        return const Color(0xFFE0C7FF);
      case 'NoteColors.orange':
        return const Color(0xFFFFD6A5);
      case 'NoteColors.all':
        return const [
          Color(0xFFFFF3A3),
          Color(0xFFFFC9D6),
          Color(0xFFBFE3FF),
          Color(0xFFC8F7C5),
          Color(0xFFE0C7FF),
          Color(0xFFFFD6A5),
        ];

      // Brightness
      case 'Brightness.light':
        return Brightness.light;
      case 'Brightness.dark':
        return Brightness.dark;

      // FontWeight
      case 'FontWeight.w100':
        return FontWeight.w100;
      case 'FontWeight.w200':
        return FontWeight.w200;
      case 'FontWeight.w300':
        return FontWeight.w300;
      case 'FontWeight.w400':
      case 'FontWeight.normal':
        return FontWeight.normal;
      case 'FontWeight.w500':
        return FontWeight.w500;
      case 'FontWeight.w600':
        return FontWeight.w600;
      case 'FontWeight.w700':
      case 'FontWeight.bold':
        return FontWeight.bold;
      case 'FontWeight.w800':
        return FontWeight.w800;
      case 'FontWeight.w900':
        return FontWeight.w900;

      // MainAxisAlignment
      case 'MainAxisAlignment.start':
        return MainAxisAlignment.start;
      case 'MainAxisAlignment.center':
        return MainAxisAlignment.center;
      case 'MainAxisAlignment.end':
        return MainAxisAlignment.end;
      case 'MainAxisAlignment.spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'MainAxisAlignment.spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'MainAxisAlignment.spaceEvenly':
        return MainAxisAlignment.spaceEvenly;

      // CrossAxisAlignment
      case 'CrossAxisAlignment.start':
        return CrossAxisAlignment.start;
      case 'CrossAxisAlignment.center':
        return CrossAxisAlignment.center;
      case 'CrossAxisAlignment.end':
        return CrossAxisAlignment.end;
      case 'CrossAxisAlignment.stretch':
        return CrossAxisAlignment.stretch;
      case 'CrossAxisAlignment.baseline':
        return CrossAxisAlignment.baseline;

      // MainAxisSize
      case 'MainAxisSize.min':
        return MainAxisSize.min;
      case 'MainAxisSize.max':
        return MainAxisSize.max;

      // TextAlign
      case 'TextAlign.start':
        return TextAlign.start;
      case 'TextAlign.end':
        return TextAlign.end;
      case 'TextAlign.center':
        return TextAlign.center;
      case 'TextAlign.left':
        return TextAlign.left;
      case 'TextAlign.right':
        return TextAlign.right;
      case 'TextAlign.justify':
        return TextAlign.justify;

      // Axis
      case 'Axis.horizontal':
        return Axis.horizontal;
      case 'Axis.vertical':
        return Axis.vertical;

      // BoxFit
      case 'BoxFit.fill':
        return BoxFit.fill;
      case 'BoxFit.contain':
        return BoxFit.contain;
      case 'BoxFit.cover':
        return BoxFit.cover;
      case 'BoxFit.fitWidth':
        return BoxFit.fitWidth;
      case 'BoxFit.fitHeight':
        return BoxFit.fitHeight;
      case 'BoxFit.none':
        return BoxFit.none;
      case 'BoxFit.scaleDown':
        return BoxFit.scaleDown;

      // BoxShape
      case 'BoxShape.circle':
        return BoxShape.circle;
      case 'BoxShape.rectangle':
        return BoxShape.rectangle;

      // Enums & Values
      case 'ButtonVariant.plain':
        return ButtonVariant.plain;
      case 'ButtonVariant.filled':
        return ButtonVariant.filled;
      case 'ButtonVariant.tinted':
        return ButtonVariant.tinted;
      case 'TextOverflow.ellipsis':
        return TextOverflow.ellipsis;
      case 'TextDecoration.lineThrough':
        return TextDecoration.lineThrough;
      case 'TextDecoration.none':
        return TextDecoration.none;
      case 'BorderSide.none':
        return BorderSide.none;
      case 'TextInputAction.next':
        return TextInputAction.next;
      case 'TextInputAction.done':
        return TextInputAction.done;

      // Native BottomSheet Detents
      case 'DNSheetDetent.medium':
        return DNSheetDetent.medium;
      case 'DNSheetDetent.large':
        return DNSheetDetent.large;

      // CupertinoIcons
      case 'CupertinoIcons.person':
        return CupertinoIcons.person;
      case 'CupertinoIcons.person_fill':
        return CupertinoIcons.person_fill;
      case 'CupertinoIcons.plus':
        return CupertinoIcons.plus;
      case 'CupertinoIcons.checkmark':
        return CupertinoIcons.checkmark;
      case 'CupertinoIcons.trash':
        return CupertinoIcons.trash;
      case 'CupertinoIcons.pencil':
        return CupertinoIcons.pencil;
      case 'CupertinoIcons.pin':
        return CupertinoIcons.pin;
      case 'CupertinoIcons.pin_fill':
        return CupertinoIcons.pin_fill;
      case 'CupertinoIcons.pin_slash':
        return CupertinoIcons.pin_slash;
      case 'CupertinoIcons.xmark':
        return CupertinoIcons.xmark;
      case 'CupertinoIcons.square_stack_3d_up':
        return CupertinoIcons.square_stack_3d_up;
      case 'CupertinoIcons.search':
        return CupertinoIcons.search;
      case 'CupertinoIcons.heart':
        return CupertinoIcons.heart;
      case 'CupertinoIcons.heart_fill':
        return CupertinoIcons.heart_fill;
      case 'CupertinoIcons.star':
        return CupertinoIcons.star;
      case 'CupertinoIcons.star_fill':
        return CupertinoIcons.star_fill;
      case 'CupertinoIcons.bell':
        return CupertinoIcons.bell;
      case 'CupertinoIcons.bell_fill':
        return CupertinoIcons.bell_fill;
      case 'CupertinoIcons.info':
        return CupertinoIcons.info;
      case 'CupertinoIcons.gear':
        return CupertinoIcons.gear;
      case 'CupertinoIcons.chevron_back':
        return CupertinoIcons.chevron_back;
      case 'CupertinoIcons.chevron_forward':
        return CupertinoIcons.chevron_forward;
      case 'CupertinoIcons.chevron_up':
        return CupertinoIcons.chevron_up;
      case 'CupertinoIcons.chevron_down':
        return CupertinoIcons.chevron_down;

      // SystemChrome
      case 'SystemChrome.defaultStyle':
        return SystemChrome.defaultStyle;

      default:
        return null;
    }
  }

  /// Sets global or static bridge targets.
  void storeGlobal(String name, Object? value) {
    if (name == 'SystemChrome.defaultStyle' && value is SystemUiOverlayStyle) {
      SystemChrome.defaultStyle = value;
    }
  }

  /// Resolves member properties on native Dart objects (strings, lists, maps, colors).
  Object? resolveMember(Object target, String name) {
    ensureInitialized();

    var libClass = _classByType[target.runtimeType];
    if (libClass == null) {
      for (final lc in _classByName.values) {
        final bc = lc.bridgedClass;
        if (bc.isAssignable != null && bc.isAssignable!(target)) {
          libClass = lc;
          _classByType[target.runtimeType] = lc;
          break;
        }
      }
    }
    if (libClass != null) {
      final getter = libClass.bridgedClass.getters[name];
      if (getter != null) {
        try {
          return getter(_sharedVisitor, target);
        } catch (_) {}
      }
    }

    if (target is Enum) {
      if (name == 'name') return target.name;
      if (name == 'index') return target.index;
      final libEnum = _enumByName[target.runtimeType.toString()];
      if (libEnum != null) {
        final getter = libEnum.enumDefinition.getters[name];
        if (getter != null) {
          try {
            return getter(_sharedVisitor, target);
          } catch (_) {}
        }
      }
    }
    if (target is NotifierProvider) {
      if (name == 'notifier') return target.notifier;
    }
    if (target is DNSheetDetent) {
      if (name == 'label') return target.label;
    }
    if (target is DateTime) {
      if (name == 'microsecondsSinceEpoch') return target.microsecondsSinceEpoch;
      if (name == 'millisecondsSinceEpoch') return target.millisecondsSinceEpoch;
      if (name == 'year') return target.year;
      if (name == 'month') return target.month;
      if (name == 'day') return target.day;
      if (name == 'hour') return target.hour;
      if (name == 'minute') return target.minute;
      if (name == 'second') return target.second;
    }
    if (target is TextEditingController) {
      if (name == 'text') return target.text;
    }
    if (target is MaterialColor) {
      if (name == 'shade50') return target.shade50;
      if (name == 'shade100') return target.shade100;
      if (name == 'shade200') return target.shade200;
      if (name == 'shade300') return target.shade300;
      if (name == 'shade400') return target.shade400;
      if (name == 'shade500') return target.shade500;
      if (name == 'shade600') return target.shade600;
      if (name == 'shade700') return target.shade700;
      if (name == 'shade800') return target.shade800;
      if (name == 'shade900') return target.shade900;
    }
    if (target is String) {
      if (name == 'length') return target.length;
      if (name == 'isEmpty') return target.isEmpty;
      if (name == 'isNotEmpty') return target.isNotEmpty;
      if (name == 'codeUnits') return target.codeUnits;
    } else if (target is List) {
      if (name == 'length') return target.length;
      if (name == 'isEmpty') return target.isEmpty;
      if (name == 'isNotEmpty') return target.isNotEmpty;
      if (name == 'first') return target.isNotEmpty ? target.first : null;
      if (name == 'last') return target.isNotEmpty ? target.last : null;
      if (name == 'reversed') return target.reversed.toList();
    } else if (target is Map) {
      if (name == 'length') return target.length;
      if (name == 'isEmpty') return target.isEmpty;
      if (name == 'isNotEmpty') return target.isNotEmpty;
      if (name == 'keys') return target.keys.toList();
      if (name == 'values') return target.values.toList();
      if (name == 'entries') return target.entries.toList();
    } else if (target is Set) {
      if (name == 'length') return target.length;
      if (name == 'isEmpty') return target.isEmpty;
      if (name == 'isNotEmpty') return target.isNotEmpty;
      if (name == 'first') return target.isNotEmpty ? target.first : null;
      if (name == 'last') return target.isNotEmpty ? target.last : null;
    } else if (target is Color) {
      if (name == 'value') return target.value;
      if (name == 'alpha') return target.alpha;
      if (name == 'red') return target.red;
      if (name == 'green') return target.green;
      if (name == 'blue') return target.blue;
      if (name == 'opacity') return target.opacity;
    } else if (target is Offset) {
      if (name == 'dx') return target.dx;
      if (name == 'dy') return target.dy;
    } else if (target is Size) {
      if (name == 'width') return target.width;
      if (name == 'height') return target.height;
    }
    return null;
  }

  /// Invokes top-level bridged functions (e.g. `runApp`, `print`, `showBottomSheet`).
  Object? invokeTopLevel(
    String functionName,
    List<Object?> positional,
    Map<String, Object?> named,
  ) {
    if (functionName == 'runApp') {
      if (positional.isNotEmpty) {
        capturedApp = _unwrapWidget(positional[0]);
      }
      return null;
    } else if (functionName == 'print') {
      final msg = positional.isNotEmpty ? positional[0]?.toString() ?? '' : '';
      if (onLog != null) {
        onLog!(msg);
      } else {
        print('[GuestApp] $msg');
      }
      return null;
    } else if (functionName == 'showBottomSheet') {
      final ctx = positional.isNotEmpty ? positional[0] as BuildContext? : null;
      if (ctx != null) {
        final builderFn = named['builder'];
        final detents = (named['detents'] as List<dynamic>?)?.cast<DNSheetDetent>() ??
            const [DNSheetDetent.medium, DNSheetDetent.large];
        final initialDetent =
            named['initialDetent'] as DNSheetDetent? ?? DNSheetDetent.medium;
        final showGrabber = named['showGrabber'] as bool? ?? true;

        return showBottomSheet(
          ctx,
          detents: detents,
          initialDetent: initialDetent,
          showGrabber: showGrabber,
          builder: (bCtx, controller) {
            if (builderFn is BytecodeClosure && vm != null) {
              final res = vm!.executeFunction(
                funcId: builderFn.funcId,
                positionalArgs: [bCtx, controller],
                capturedEnv: builderFn.capturedSlots,
              );
              return _unwrapWidget(res) ?? const SizedBox.shrink();
            } else if (builderFn is Function) {
              final res = builderFn(bCtx, controller);
              return _unwrapWidget(res) ?? const SizedBox.shrink();
            }
            return const SizedBox.shrink();
          },
        );
      }
      return null;
    } else if (functionName == 'SystemChrome.setSystemUIOverlayStyle' ||
        functionName == 'setSystemUIOverlayStyle') {
      final style = positional.isNotEmpty ? positional[0] as SystemUiOverlayStyle? : null;
      if (style != null) {
        SystemChrome.setSystemUIOverlayStyle(style);
      }
      return null;
    } else if (functionName == 'DartNativePluginRegistrant.registerAll' ||
        functionName == 'registerAll') {
      return null;
    }

    ensureInitialized();
    final libFunc = _topLevelFuncByName[functionName];
    if (libFunc != null) {
      final posUnwrapped = positional.map(unwrapArgument).toList();
      final namedUnwrapped = named.map((k, v) => MapEntry(k, unwrapArgument(v)));
      try {
        return libFunc.function.call(_sharedVisitor, posUnwrapped, namedUnwrapped, null);
      } catch (e) {
        DartGoLogger.debug(
          'Bridged top-level function $functionName failed: $e',
          tag: 'BytecodeBridge',
        );
      }
    }
    return null;
  }

  /// Invokes an instance method on a native host object using AST bridges.
  Object? invokeInstanceMethod(
    Object target,
    String methodName,
    List<Object?> posArgs,
    Map<String, Object?> namedArgs,
  ) {
    ensureInitialized();

    var libClass = _classByType[target.runtimeType];
    if (libClass == null) {
      for (final lc in _classByName.values) {
        final bc = lc.bridgedClass;
        if (bc.isAssignable != null && bc.isAssignable!(target)) {
          libClass = lc;
          _classByType[target.runtimeType] = lc;
          break;
        }
      }
    }
    if (libClass != null) {
      final method = libClass.bridgedClass.methods[methodName];
      if (method != null) {
        final posUnwrapped = posArgs.map(unwrapArgument).toList();
        final namedUnwrapped = namedArgs.map((k, v) => MapEntry(k, unwrapArgument(v)));
        try {
          return method(_sharedVisitor, target, posUnwrapped, namedUnwrapped, null);
        } catch (e) {
          DartGoLogger.debug(
            'Bridged method $methodName failed on ${target.runtimeType}: $e',
            tag: 'BytecodeBridge',
          );
        }
      }
    }
    return null;
  }

  Widget? _unwrapWidget(Object? obj) {
    if (obj == null) return null;
    if (widgetUnwrapper != null) return widgetUnwrapper!(obj);
    if (obj is Widget) return obj;
    if (obj is BytecodeInstance && obj.nativeProxy is Widget) {
      return obj.nativeProxy as Widget;
    }
    return null;
  }

  VoidCallback? _coerceVoidCallback(Object? cb) {
    if (cb == null) return null;
    if (cb is VoidCallback) return cb;
    if (cb is BytecodeClosure) {
      return () {
        if (vm != null) {
          vm!.executeFunction(
            funcId: cb.funcId,
            capturedEnv: cb.capturedSlots,
            thisTarget: cb.capturedSlots.isNotEmpty &&
                    cb.capturedSlots[0] is BytecodeInstance
                ? cb.capturedSlots[0] as BytecodeInstance
                : null,
          );
        }
      };
    }
    if (cb is Function) {
      return () {
        try {
          Function.apply(cb, const []);
        } catch (e) {
          DartGoLogger.debug('Error invoking callback: $e', tag: 'BytecodeBridge');
        }
      };
    }
    return null;
  }

  ValueChanged<T>? _coerceValueChanged<T>(Object? cb) {
    if (cb == null) return null;
    if (cb is ValueChanged<T>) return cb;
    if (cb is BytecodeClosure) {
      return (T value) {
        if (vm != null) {
          vm!.executeFunction(
            funcId: cb.funcId,
            positionalArgs: [value],
            capturedEnv: cb.capturedSlots,
            thisTarget: cb.capturedSlots.isNotEmpty &&
                    cb.capturedSlots[0] is BytecodeInstance
                ? cb.capturedSlots[0] as BytecodeInstance
                : null,
          );
        }
      };
    }
    if (cb is Function) {
      return (T value) {
        try {
          Function.apply(cb, [value]);
        } catch (e) {
          DartGoLogger.debug('Error invoking value callback: $e', tag: 'BytecodeBridge');
        }
      };
    }
    return null;
  }
}

import 'package:dartnative/dartnative.dart';
import 'bytecode/bundle_codec.dart';
import 'bytecode/bytecode_models.dart';
import 'bytecode/vm.dart';
import 'logger.dart';

/// Runner that manages Bytecode Virtual Machine execution and true hot-patching.
class BytecodeInterpreterRunner {
  late BytecodeVM _vm;
  String? currentServerUrl;
  void Function(String message)? onLog;
  VoidCallback? onExit;

  BytecodeInterpreterRunner({
    this.onLog,
    this.onExit,
    this.currentServerUrl,
  }) {
    initRunner();
  }

  BytecodeVM get vm => _vm;

  void initRunner() {
    _vm = BytecodeVM(
      onLog: onLog,
      serverUrlProvider: () => currentServerUrl,
    );
  }

  /// Evaluates pre-compiled bytecode bytes and resolves the root widget.
  Future<Widget> evaluateBytecodeBundle(
    List<int> bytecodeBytes, {
    bool isHotReload = false,
  }) async {
    final sw = Stopwatch()..start();
    if (!isHotReload) {
      initRunner();
    }

    _vm.bridgeAdapter.capturedApp = null;
    final bundle = BytecodeBundleCodec.decodeBundle(bytecodeBytes);
    final rawResult = _vm.loadBundle(bundle, isHotReload: isHotReload);

    final resolvedWidget = _vm.bridgeAdapter.capturedApp ??
        _vm.unwrapWidget(rawResult);

    if (resolvedWidget == null) {
      throw StateError(
        'Bytecode evaluation succeeded, but could not resolve a Widget from entrypoint.\n'
        'Ensure main() calls runApp(Widget) or returns a Widget.',
      );
    }

    DartGoLogger.bench(
      'BytecodeVM',
      'Bytecode evaluate (${isHotReload ? "reload" : "initial"})',
      sw.elapsedMilliseconds,
      {
        'funcs': bundle.functions.length,
        'classes': bundle.classes.length,
      },
    );

    return resolvedWidget;
  }

  /// Hot-swaps modified functions in-place using a [BytecodeDelta].
  /// Returns the set of affected class names whose widgets should rebuild.
  Set<String> applyBytecodeDelta(BytecodeDelta delta) {
    final sw = Stopwatch()..start();
    final dirtyClasses = _vm.applyDelta(delta);
    DartGoLogger.bench(
      'BytecodeVM',
      'True Hot Patch applied (in-place swap)',
      sw.elapsedMilliseconds,
      {
        'swapped': delta.updatedFunctions.length,
        'dirtyClasses': dirtyClasses.length,
      },
    );
    return dirtyClasses;
  }

  void dispose() {
    _vm.functionTable.clear();
  }
}

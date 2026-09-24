import 'package:dartnative_go/src/client/runtime_mode_storage.dart';
import 'package:dartnative_go/src/runner/runtime_mode.dart';
import 'package:test/test.dart';

void main() {
  group('RuntimeModeStorage', () {
    setUp(() {
      RuntimeModeStorage.resetForTesting();
    });

    tearDown(() {
      RuntimeModeStorage.resetForTesting();
    });

    test('defaults to AST mode when unconfigured', () async {
      final mode = await RuntimeModeStorage.loadMode();
      expect(mode, equals(RuntimeMode.ast));
      expect(RuntimeModeStorage.currentMode, equals(RuntimeMode.ast));
    });

    test('persists mode change in memory and survives load', () async {
      // A Bytecode preference is only honoured while the engine is enabled;
      // otherwise loading falls back to the default engine.
      await RuntimeModeStorage.saveMode(RuntimeMode.bytecode);
      expect(
        RuntimeModeStorage.currentMode,
        equals(kBytecodeEnabled ? RuntimeMode.bytecode : RuntimeMode.ast),
      );
      expect(
        await RuntimeModeStorage.loadMode(),
        equals(
          kBytecodeEnabled ? RuntimeMode.bytecode : RuntimeMode.ast,
        ),
      );

      await RuntimeModeStorage.saveMode(RuntimeMode.source);
      expect(RuntimeModeStorage.currentMode, equals(RuntimeMode.source));
      expect(await RuntimeModeStorage.loadMode(), equals(RuntimeMode.source));

      await RuntimeModeStorage.saveMode(RuntimeMode.ast);
      expect(RuntimeModeStorage.currentMode, equals(RuntimeMode.ast));
      expect(await RuntimeModeStorage.loadMode(), equals(RuntimeMode.ast));
    });

    test('resetForTesting can seed initial mode', () async {
      RuntimeModeStorage.resetForTesting(RuntimeMode.bytecode);
      expect(
        RuntimeModeStorage.currentMode,
        equals(kBytecodeEnabled ? RuntimeMode.bytecode : RuntimeMode.ast),
      );
      expect(
        await RuntimeModeStorage.loadMode(),
        equals(
          kBytecodeEnabled ? RuntimeMode.bytecode : RuntimeMode.ast,
        ),
      );
    });
  });
}

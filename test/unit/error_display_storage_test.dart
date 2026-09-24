import 'package:dartnative_go/src/client/error_display_storage.dart';
import 'package:test/test.dart';

void main() {
  group('ErrorDisplayStorage', () {
    setUp(() {
      ErrorDisplayStorage.resetForTesting();
    });

    tearDown(() {
      ErrorDisplayStorage.resetForTesting();
    });

    test('defaults to overlay when unconfigured', () async {
      expect(
        await ErrorDisplayStorage.loadMode(),
        equals(ErrorDisplayMode.overlay),
      );
      expect(
        ErrorDisplayStorage.currentMode,
        equals(ErrorDisplayMode.overlay),
      );
    });

    test('persists mode change in memory and survives load', () async {
      await ErrorDisplayStorage.saveMode(ErrorDisplayMode.fullscreen);
      expect(
        ErrorDisplayStorage.currentMode,
        equals(ErrorDisplayMode.fullscreen),
      );
      expect(
        await ErrorDisplayStorage.loadMode(),
        equals(ErrorDisplayMode.fullscreen),
      );

      await ErrorDisplayStorage.saveMode(ErrorDisplayMode.overlay);
      expect(
        ErrorDisplayStorage.currentMode,
        equals(ErrorDisplayMode.overlay),
      );
      expect(
        await ErrorDisplayStorage.loadMode(),
        equals(ErrorDisplayMode.overlay),
      );
    });

    test('resetForTesting can seed initial mode', () async {
      ErrorDisplayStorage.resetForTesting(ErrorDisplayMode.fullscreen);
      expect(
        ErrorDisplayStorage.currentMode,
        equals(ErrorDisplayMode.fullscreen),
      );
      expect(
        await ErrorDisplayStorage.loadMode(),
        equals(ErrorDisplayMode.fullscreen),
      );
    });
  });
}

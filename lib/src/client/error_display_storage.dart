import 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart';

/// How a guest failure surfaces on the device.
///
/// [overlay] keeps the working app mounted and shows the error on top of it.
/// [fullscreen] replaces the app with the error screen (the historical
/// behavior).
enum ErrorDisplayMode { overlay, fullscreen }

/// Persists the selected [ErrorDisplayMode].
///
/// Mirrors [RuntimeModeStorage]: survives restarts and relaunches, falls back
/// to [overlay] when storage is unavailable (e.g. headless host tests).
class ErrorDisplayStorage {
  static const String kStorageKey = 'dartnative_go_error_display_mode';

  static SharedPreferences? _prefs;
  static ErrorDisplayMode? _memoryMode;

  /// Loads the persisted mode, defaulting to [ErrorDisplayMode.overlay].
  static Future<ErrorDisplayMode> loadMode() async {
    final cached = _memoryMode;
    if (cached != null) return cached;
    try {
      final prefs = _prefs ??= await SharedPreferences.getInstance();
      final saved = prefs.getString(kStorageKey);
      final mode = ErrorDisplayMode.values.asNameMap()[saved] ??
          ErrorDisplayMode.overlay;
      _memoryMode = mode;
      return mode;
    } catch (_) {
      return _memoryMode ?? ErrorDisplayMode.overlay;
    }
  }

  /// Synchronous getter for the currently known mode, or overlay.
  static ErrorDisplayMode get currentMode =>
      _memoryMode ?? ErrorDisplayMode.overlay;

  /// Persists [mode] and updates the in-memory cache immediately.
  static Future<void> saveMode(ErrorDisplayMode mode) async {
    _memoryMode = mode;
    try {
      final prefs = _prefs ??= await SharedPreferences.getInstance();
      await prefs.setString(kStorageKey, mode.name);
    } catch (_) {}
  }

  /// Reset in-memory cache and prefs (for test isolation).
  static void resetForTesting([ErrorDisplayMode? initialMode]) {
    _memoryMode = initialMode;
    _prefs = null;
  }
}

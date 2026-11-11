import 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart';

/// Which appearance the host app uses.
///
/// [system] follows the device (native appearance unpinned).
enum ThemePreference { system, light, dark }

/// Persists the selected [ThemePreference].
///
/// Mirrors [ErrorDisplayStorage]: survives restarts and relaunches, falls
/// back to [system] when storage is unavailable (e.g. headless host tests).
class ThemeStorage {
  static const String kStorageKey = 'dartnative_go_theme_preference';

  static SharedPreferences? _prefs;
  static ThemePreference? _memoryPreference;

  /// Loads the persisted preference, defaulting to [ThemePreference.system].
  static Future<ThemePreference> loadPreference() async {
    final cached = _memoryPreference;
    if (cached != null) return cached;
    try {
      final prefs = _prefs ??= await SharedPreferences.getInstance();
      final saved = prefs.getString(kStorageKey);
      final preference =
          ThemePreference.values.asNameMap()[saved] ?? ThemePreference.system;
      _memoryPreference = preference;
      return preference;
    } catch (_) {
      return _memoryPreference ?? ThemePreference.system;
    }
  }

  /// Synchronous getter for the currently known preference, or system.
  static ThemePreference get currentPreference =>
      _memoryPreference ?? ThemePreference.system;

  /// Whether [loadPreference] has resolved into the in-memory cache.
  static bool get isLoaded => _memoryPreference != null;

  /// Persists [preference] and updates the in-memory cache immediately.
  static Future<void> savePreference(ThemePreference preference) async {
    _memoryPreference = preference;
    try {
      final prefs = _prefs ??= await SharedPreferences.getInstance();
      await prefs.setString(kStorageKey, preference.name);
    } catch (_) {}
  }

  /// Reset in-memory cache and prefs (for test isolation).
  static void resetForTesting([ThemePreference? initialPreference]) {
    _memoryPreference = initialPreference;
    _prefs = null;
  }
}

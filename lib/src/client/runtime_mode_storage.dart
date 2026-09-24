import 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart';

import '../runner/runtime_mode.dart';

/// Manages persistence of the selected [RuntimeMode] (AST, Bytecode, Source).
///
/// Ensures the mode selection survives Hot Restarts, project re-mounts,
/// and app re-launches.
class RuntimeModeStorage {
  static const String kStorageKey = 'dartnative_go_runtime_mode';

  static SharedPreferences? _prefs;
  static RuntimeMode? _memoryMode;

  /// Loads the persisted [RuntimeMode].
  ///
  /// Falls back to in-memory mode or [kDefaultRuntimeMode] (AST)
  /// if storage is unavailable (e.g. headless host tests). A persisted
  /// Bytecode choice is ignored while the engine is disabled
  /// ([kBytecodeEnabled]) so a stale preference cannot lock the app into a mode
  /// it cannot run.
  static Future<RuntimeMode> loadMode() async {
    final cached = _memoryMode;
    if (cached != null) return cached.isSelectable ? cached : kDefaultRuntimeMode;
    try {
      final prefs = _prefs ??= await SharedPreferences.getInstance();
      final saved = prefs.getString(kStorageKey);
      final mode = runtimeModeFromName(saved);
      _memoryMode = mode;
      return mode;
    } catch (_) {
      final memory = _memoryMode;
      return memory != null && memory.isSelectable ? memory : kDefaultRuntimeMode;
    }
  }

  /// Synchronous getter for the currently known mode, or [kDefaultRuntimeMode].
  static RuntimeMode get currentMode {
    final mode = _memoryMode;
    if (mode == null) return kDefaultRuntimeMode;
    return mode.isSelectable ? mode : kDefaultRuntimeMode;
  }

  /// Persists [mode] and updates in-memory cache immediately.
  static Future<void> saveMode(RuntimeMode mode) async {
    _memoryMode = mode;
    try {
      final prefs = _prefs ??= await SharedPreferences.getInstance();
      await prefs.setString(kStorageKey, mode.name);
    } catch (_) {}
  }

  /// Reset in-memory cache and prefs (for test isolation).
  static void resetForTesting([RuntimeMode? initialMode]) {
    _memoryMode = initialMode;
    _prefs = null;
  }
}

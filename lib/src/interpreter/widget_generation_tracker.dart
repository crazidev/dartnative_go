/// Tracks granular remount generations per widget class and source file.
/// Instead of remounting the entire application tree on every edit, only the
/// changed widget and its subtree down receives a new generational key.
class WidgetGenerationTracker {
  static final Map<String, int> _classGenerations = {};
  static final Map<String, String> _classToFile = {};

  /// Retrieves the current generation counter for a given widget class name.
  static int getGeneration(String className) => _classGenerations[className] ?? 0;

  /// Registers and maps class definitions from multi-file sources.
  static void registerSources(Map<String, String> sources) {
    final classRegex = RegExp(r'\bclass\s+([A-Za-z0-9_]+)');
    sources.forEach((path, content) {
      final normPath = _normalizePath(path);
      for (final match in classRegex.allMatches(content)) {
        final className = match.group(1);
        if (className != null) {
          _classToFile[className] = normPath;
        }
      }
    });
  }

  /// Increments the generation for classes defined in the changed files.
  /// Returns the set of widget class names whose generations were bumped.
  static Set<String> notifyFilesChanged(Set<String> changedFiles) {
    final normalizedChanged = changedFiles.map(_normalizePath).toSet();
    final bumpedClasses = <String>{};

    if (normalizedChanged.isEmpty) {
      // General reload: bump all known classes
      for (final className in _classToFile.keys) {
        _classGenerations[className] = (_classGenerations[className] ?? 0) + 1;
        bumpedClasses.add(className);
      }
      return bumpedClasses;
    }

    _classToFile.forEach((className, filePath) {
      final isMatch = normalizedChanged.contains(filePath) ||
          normalizedChanged.any((cp) =>
              cp.endsWith('/$filePath') ||
              filePath.endsWith('/$cp') ||
              cp == filePath);
      if (isMatch) {
        _classGenerations[className] = (_classGenerations[className] ?? 0) + 1;
        bumpedClasses.add(className);
      }
    });

    return bumpedClasses;
  }

  static String _normalizePath(String path) {
    var p = path.replaceAll(r'\', '/');
    if (p.startsWith('package:')) {
      final slash = p.indexOf('/');
      if (slash != -1) {
        p = p.substring(slash + 1);
      }
    } else if (p.startsWith('file:///')) {
      p = p.substring(8);
      final slash = p.indexOf('/');
      if (slash != -1) {
        p = p.substring(slash + 1);
      }
    } else if (p.startsWith('guest_app/')) {
      p = p.replaceFirst('guest_app/', '');
    }
    return p;
  }

  /// Resets all generations (e.g. on full hot restart or unmount).
  static void resetAll() {
    _classGenerations.clear();
    _classToFile.clear();
  }
}

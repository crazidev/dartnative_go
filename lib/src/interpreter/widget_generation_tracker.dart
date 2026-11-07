/// Tracks granular remount generations per widget class and source file.
/// Instead of remounting the entire application tree on every edit, only the
/// changed widget and its subtree down receives a new generational key.
class WidgetGenerationTracker {
  static final Map<String, int> _classGenerations = {};
  static final Map<String, String> _classToFile = {};
  static final Set<MountedWidgetReloadListener> _mountedWidgetReloadListeners =
      {};

  static void registerMountedWidget(MountedWidgetReloadListener listener) {
    _mountedWidgetReloadListeners.add(listener);
  }

  static void unregisterMountedWidget(MountedWidgetReloadListener listener) {
    _mountedWidgetReloadListeners.remove(listener);
  }

  /// Rebinds mounted guest State proxies and schedules their build methods.
  ///
  /// Pushed Navigator routes are not rebuilt when only the root app widget is
  /// replaced, so they need an explicit reload notification.
  static void notifyMountedWidgets(Object? visitor) {
    for (final listener in List.of(_mountedWidgetReloadListeners)) {
      listener(visitor);
    }
  }

  /// Retrieves the current generation counter for a given widget class name.
  static int getGeneration(String className) =>
      _classGenerations[className] ?? 0;

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

  /// Registers class names against the files that declare them.
  ///
  /// The AST engine has no source text to scrape, so the map is derived from
  /// the decoded bundle's compilation units instead (see
  /// `AstInterpreterRunner.classFileMap`).
  static void registerClassFiles(Map<String, String> classFiles) {
    classFiles.forEach((className, path) {
      final normPath = _normalizePath(path);
      if (normPath.isNotEmpty) _classToFile[className] = normPath;
    });
  }

  /// Increments the generation for classes defined in the changed files.
  /// Returns the set of widget class names whose generations were bumped.
  static Set<String> notifyFilesChanged(
    Set<String> changedFiles, {
    bool bumpAllIfEmpty = false,
  }) {
    if (changedFiles.isEmpty && !bumpAllIfEmpty) {
      return const {};
    }
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
      final isMatch =
          normalizedChanged.contains(filePath) ||
          normalizedChanged.any(
            (cp) =>
                cp.endsWith('/$filePath') ||
                filePath.endsWith('/$cp') ||
                cp == filePath,
          );
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

typedef MountedWidgetReloadListener = void Function(Object? visitor);

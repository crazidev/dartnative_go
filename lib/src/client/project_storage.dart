import 'dart:convert';
import 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart';

import 'project_model.dart';
import 'storage_interface.dart';

export 'storage_interface.dart';

/// Manages persistence of recent DartNative Go projects using SharedPreferences.
class ProjectStorage implements IProjectStorage {
  static const String _kStorageKey = 'dart_go_recent_projects';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<List<DartGoProject>> loadProjects() async {
    try {
      final prefs = await _getPrefs();
      final list = prefs.getStringList(_kStorageKey);
      if (list == null || list.isEmpty) return [];

      final projects = <DartGoProject>[];
      for (final rawJson in list) {
        try {
          final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
          projects.add(DartGoProject.fromJson(decoded));
        } catch (_) {}
      }
      return projects;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveProjects(List<DartGoProject> projects) async {
    try {
      final prefs = await _getPrefs();
      final stringList = projects.map((p) => jsonEncode(p.toJson())).toList();
      await prefs.setStringList(_kStorageKey, stringList);
    } catch (_) {}
  }

  @override
  Future<void> upsertProject(DartGoProject project) async {
    final current = await loadProjects();
    final index = current.indexWhere((p) => p.url == project.url);

    if (index != -1) {
      current[index] = project.copyWith(
        appName: project.appName,
        lastSeen: project.lastSeen,
        isActive: project.isActive,
        manifestUrl: project.manifestUrl ?? current[index].manifestUrl,
        bundleUrl: project.bundleUrl ?? current[index].bundleUrl,
        wsUrl: project.wsUrl ?? current[index].wsUrl,
        iconUrl: project.iconUrl ?? current[index].iconUrl,
      );
    } else {
      current.insert(0, project);
    }

    if (current.length > 25) {
      current.removeRange(25, current.length);
    }

    await saveProjects(current);
  }

  @override
  Future<void> removeProject(String url) async {
    final current = await loadProjects();
    current.removeWhere((p) => p.url == url);
    await saveProjects(current);
  }

  @override
  Future<void> clear() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_kStorageKey);
    } catch (_) {}
  }
}

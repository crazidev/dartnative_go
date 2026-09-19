import 'project_model.dart';

/// Interface for project persistence.
abstract interface class IProjectStorage {
  Future<List<DartGoProject>> loadProjects();
  Future<void> saveProjects(List<DartGoProject> projects);
  Future<void> upsertProject(DartGoProject project);
  Future<void> removeProject(String url);
  Future<void> clear();
}

/// Pure in-memory project storage without external dependencies.
class InMemoryProjectStorage implements IProjectStorage {
  final List<DartGoProject> _projects = [];

  @override
  Future<List<DartGoProject>> loadProjects() async => List.from(_projects);

  @override
  Future<void> saveProjects(List<DartGoProject> projects) async {
    _projects.clear();
    _projects.addAll(projects);
  }

  @override
  Future<void> upsertProject(DartGoProject project) async {
    final idx = _projects.indexWhere((p) => p.url == project.url);
    if (idx != -1) {
      _projects[idx] = project;
    } else {
      _projects.insert(0, project);
    }
  }

  @override
  Future<void> removeProject(String url) async {
    _projects.removeWhere((p) => p.url == url);
  }

  @override
  Future<void> clear() async {
    _projects.clear();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../services/storage.dart';

final projectProvider = StateNotifierProvider<ProjectNotifier, List<Project>>((ref) {
  return ProjectNotifier();
});

class ProjectNotifier extends StateNotifier<List<Project>> {
  final StorageService _storage = StorageService();

  ProjectNotifier() : super([]) {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    state = _storage.getAllProjects();
  }

  Future<void> addProject(Project project) async {
    await _storage.saveProject(project);
    state = [...state, project];
  }

  Future<void> updateProject(Project project) async {
    await _storage.saveProject(project);
    state = [
      for (final p in state)
        if (p.id == project.id) project else p
    ];
  }

  Future<void> deleteProject(String projectId) async {
    await _storage.deleteProject(projectId);
    state = state.where((p) => p.id != projectId).toList();
  }

  Project? getProject(String projectId) {
    return state.firstWhere((p) => p.id == projectId);
  }

  List<Project> getProjectsByStatus(ProjectStatus status) {
    return state.where((p) => p.status == status).toList();
  }

  List<Project> searchProjects(String query) {
    final lowerQuery = query.toLowerCase();
    return state.where((p) =>
        p.name.toLowerCase().contains(lowerQuery) ||
        (p.description?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }
}

// Filter providers
final projectStatusFilterProvider = StateProvider<ProjectStatus?>((ref) => null);

final filteredProjectsProvider = Provider<List<Project>>((ref) {
  final projects = ref.watch(projectProvider);
  final statusFilter = ref.watch(projectStatusFilterProvider);

  if (statusFilter == null) {
    return projects;
  }

  return projects.where((p) => p.status == statusFilter).toList();
});

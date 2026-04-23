import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/storage.dart';
import 'project_provider.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final StorageService _storage = StorageService();

  TaskNotifier() : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    state = _storage.getAllTasks();
  }

  Future<void> addTask(Task task) async {
    await _storage.saveTask(task);
    state = [...state, task];
  }

  Future<void> updateTask(Task task) async {
    await _storage.saveTask(task);
    state = [
      for (final t in state)
        if (t.id == task.id) task else t
    ];
  }

  Future<void> deleteTask(String taskId) async {
    await _storage.deleteTask(taskId);
    state = state.where((t) => t.id != taskId).toList();
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    final task = state.firstWhere((t) => t.id == taskId);
    task.status = status;
    await _storage.saveTask(task);
    state = [
      for (final t in state)
        if (t.id == taskId) task else t
    ];
  }

  Future<void> reorderTasks(List<Task> reorderedTasks) async {
    for (int i = 0; i < reorderedTasks.length; i++) {
      reorderedTasks[i].order = i;
      await _storage.saveTask(reorderedTasks[i]);
    }
    state = [...reorderedTasks];
  }

  List<Task> getTasksByProject(String projectId) {
    return state.where((t) => t.projectId == projectId).toList();
  }

  List<Task> getTasksByAssignee(String assigneeId) {
    return state.where((t) => t.assigneeId == assigneeId).toList();
  }

  List<Task> getParentTasks(String projectId) {
    return state.where((t) => t.projectId == projectId && t.parentTaskId == null).toList();
  }

  List<Task> getSubtasks(String parentTaskId) {
    return state.where((t) => t.parentTaskId == parentTaskId).toList();
  }

  List<Task> getOverdueTasks() {
    return state.where((t) => t.isOverdue && t.status != TaskStatus.completed).toList();
  }

  double getProjectProgress(String projectId) {
    final projectTasks = getTasksByProject(projectId);
    if (projectTasks.isEmpty) return 0.0;
    final completedTasks = projectTasks.where((t) => t.status == TaskStatus.completed).length;
    return (completedTasks / projectTasks.length) * 100;
  }
}

// Task filter provider
final taskFilterProvider = StateProvider<TaskStatus?>((ref) => null);

final projectTasksProvider = Provider.family<List<Task>, String>((ref, projectId) {
  final tasks = ref.watch(taskProvider);
  final statusFilter = ref.watch(taskFilterProvider);

  var filtered = tasks.where((t) => t.projectId == projectId);

  if (statusFilter != null) {
    filtered = filtered.where((t) => t.status == statusFilter);
  }

  return filtered.toList();
});

// Dashboard stats provider
final dashboardStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final tasks = ref.watch(taskProvider);
  final projects = ref.watch(projectProvider);

  final totalTasks = tasks.length;
  final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).length;
  final overdueTasks = tasks.where((t) => t.isOverdue && t.status != TaskStatus.completed).length;
  final inProgressTasks = tasks.where((t) => t.status == TaskStatus.inProgress).length;

  // Priority counts
  final highPriority = tasks.where((t) => t.priority == TaskPriority.high).length;
  final mediumPriority = tasks.where((t) => t.priority == TaskPriority.medium).length;
  final lowPriority = tasks.where((t) => t.priority == TaskPriority.low).length;

  return {
    'totalTasks': totalTasks,
    'completedTasks': completedTasks,
    'overdueTasks': overdueTasks,
    'inProgressTasks': inProgressTasks,
    'completionRate': totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0,
    'highPriority': highPriority,
    'mediumPriority': mediumPriority,
    'lowPriority': lowPriority,
    'totalProjects': projects.length,
  };
});

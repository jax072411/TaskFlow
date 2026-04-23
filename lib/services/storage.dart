import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/member.dart';
import '../models/comment.dart';
import '../models/app_notification.dart';

class StorageService {
  static const String projectsBox = 'projects';
  static const String tasksBox = 'tasks';
  static const String membersBox = 'members';
  static const String commentsBox = 'comments';
  static const String notificationsBox = 'notifications';
  static const String settingsBox = 'settings';

  static Future<void> init() async {
    // Initialize Hive
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDir.path);

    // Register adapters
    Hive.registerAdapter(ProjectAdapter());
    Hive.registerAdapter(ProjectStatusAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskPriorityAdapter());
    Hive.registerAdapter(TaskStatusAdapter());
    Hive.registerAdapter(MemberAdapter());
    Hive.registerAdapter(CommentAdapter());
    Hive.registerAdapter(NotificationTypeAdapter());
    Hive.registerAdapter(AppNotificationAdapter());

    // Open boxes
    await Hive.openBox<Project>(projectsBox);
    await Hive.openBox<Task>(tasksBox);
    await Hive.openBox<Member>(membersBox);
    await Hive.openBox<Comment>(commentsBox);
    await Hive.openBox<AppNotification>(notificationsBox);
    await Hive.openBox<dynamic>(settingsBox);
  }

  // Project operations
  Box<Project> get projects => Hive.box<Project>(projectsBox);

  Future<void> saveProject(Project project) async {
    project.updatedAt = DateTime.now();
    await projects.put(project.id, project);
  }

  Future<void> deleteProject(String projectId) async {
    await projects.delete(projectId);
  }

  Project? getProject(String projectId) {
    return projects.get(projectId);
  }

  List<Project> getAllProjects() {
    return projects.values.toList();
  }

  // Task operations
  Box<Task> get tasks => Hive.box<Task>(tasksBox);

  Future<void> saveTask(Task task) async {
    task.updatedAt = DateTime.now();
    await tasks.put(task.id, task);
  }

  Future<void> deleteTask(String taskId) async {
    await tasks.delete(taskId);
  }

  Task? getTask(String taskId) {
    return tasks.get(taskId);
  }

  List<Task> getTasksByProject(String projectId) {
    return tasks.values.where((task) => task.projectId == projectId).toList();
  }

  List<Task> getTasksByAssignee(String assigneeId) {
    return tasks.values.where((task) => task.assigneeId == assigneeId).toList();
  }

  List<Task> getAllTasks() {
    return tasks.values.toList();
  }

  // Member operations
  Box<Member> get members => Hive.box<Member>(membersBox);

  Future<void> saveMember(Member member) async {
    await members.put(member.id, member);
  }

  Member? getMember(String memberId) {
    return members.get(memberId);
  }

  List<Member> getAllMembers() {
    return members.values.toList();
  }

  // Comment operations
  Box<Comment> get comments => Hive.box<Comment>(commentsBox);

  Future<void> saveComment(Comment comment) async {
    await comments.put(comment.id, comment);
  }

  List<Comment> getCommentsByTask(String taskId) {
    return comments.values.where((comment) => comment.taskId == taskId).toList();
  }

  List<Comment> getAllComments() {
    return comments.values.toList();
  }

  Future<void> deleteComment(String commentId) async {
    await comments.delete(commentId);
  }

  // Notification operations
  Box<AppNotification> get notifications => Hive.box<AppNotification>(notificationsBox);

  Future<void> saveNotification(AppNotification notification) async {
    await notifications.put(notification.id, notification);
  }

  List<AppNotification> getUnreadNotifications() {
    return notifications.values.where((n) => !n.isRead).toList();
  }

  Future<void> markAllNotificationsRead() async {
    for (var notification in notifications.values) {
      notification.isRead = true;
      await notification.save();
    }
  }

  // Settings operations
  Future<void> setSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  Future<dynamic> getSetting(String key, {dynamic defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    if (defaultValue is bool) {
      return prefs.getBool(key) ?? defaultValue;
    } else if (defaultValue is String) {
      return prefs.getString(key) ?? defaultValue;
    } else if (defaultValue is int) {
      return prefs.getInt(key) ?? defaultValue;
    }
    return defaultValue;
  }

  // Backup & Restore
  Future<Map<String, dynamic>> exportData() async {
    return {
      'projects': projects.values.map((p) => p.toJson()).toList(),
      'tasks': tasks.values.map((t) => t.toJson()).toList(),
      'members': members.values.map((m) => m.toJson()).toList(),
      'comments': comments.values.map((c) => c.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  Future<void> importData(Map<String, dynamic> data) async {
    // Import projects
    if (data['projects'] != null) {
      for (var projectData in data['projects']) {
        final project = Project.fromJson(projectData);
        await saveProject(project);
      }
    }

    // Import tasks
    if (data['tasks'] != null) {
      for (var taskData in data['tasks']) {
        final task = Task.fromJson(taskData);
        await saveTask(task);
      }
    }

    // Import members
    if (data['members'] != null) {
      for (var memberData in data['members']) {
        final member = Member.fromJson(memberData);
        await saveMember(member);
      }
    }

    // Import comments
    if (data['comments'] != null) {
      for (var commentData in data['comments']) {
        final comment = Comment.fromJson(commentData);
        await saveComment(comment);
      }
    }
  }

  Future<void> clearAllData() async {
    await projects.clear();
    await tasks.clear();
    await members.clear();
    await comments.clear();
    await notifications.clear();
  }
}

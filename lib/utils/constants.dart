import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'TaskFlow';
  static const String appVersion = '1.0.0';

  // App Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.blueAccent;

  // Priority Colors
  static const Map<String, Color> priorityColors = {
    'high': Colors.red,
    'medium': Colors.orange,
    'low': Colors.green,
  };

  // Status Colors
  static const Map<String, Color> statusColors = {
    'pending': Colors.grey,
    'inProgress': Colors.blue,
    'completed': Colors.green,
    'delayed': Colors.red,
  };

  // Project Status Colors
  static const Map<String, Color> projectStatusColors = {
    'notStarted': Colors.grey,
    'inProgress': Colors.blue,
    'completed': Colors.green,
    'archived': Colors.blueGrey,
  };

  // Task Status Labels
  static const Map<String, String> taskStatusLabels = {
    'pending': '待处理',
    'inProgress': '进行中',
    'completed': '已完成',
    'delayed': '已延期',
  };

  // Task Priority Labels
  static const Map<String, String> taskPriorityLabels = {
    'low': '低',
    'medium': '中',
    'high': '高',
  };

  // Project Status Labels
  static const Map<String, String> projectStatusLabels = {
    'notStarted': '未开始',
    'inProgress': '进行中',
    'completed': '已完成',
    'archived': '已归档',
  };

  // View Types
  static const List<String> viewTypes = ['kanban', 'list', 'calendar'];

  // Settings Keys
  static const String keyThemeMode = 'themeMode';
  static const String keyPrimaryColor = 'primaryColor';
  static const String keyNotificationEnabled = 'notificationEnabled';
  static const String keyDailySummary = 'dailySummary';
}

class AppIcons {
  static const IconData project = Icons.folder;
  static const IconData task = Icons.task;
  static const IconData calendar = Icons.calendar_today;
  static const IconData chart = Icons.bar_chart;
  static const IconData settings = Icons.settings;
  static const IconData search = Icons.search;
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData archive = Icons.archive;
  static const IconData comment = Icons.comment;
  static const IconData attachFile = Icons.attach_file;
  static const IconData priorityHigh = Icons.priority_high;
  static const IconData assignee = Icons.person;
  static const IconData dueDate = Icons.calendar_today;
  static const IconData checkCircle = Icons.check_circle;
  static const IconData pending = Icons.pending;
  static const IconData notification = Icons.notifications;
  static const IconData menu = Icons.menu;
  static const IconData share = Icons.share;
  static const IconData download = Icons.download;
  static const IconData upload = Icons.upload;
}

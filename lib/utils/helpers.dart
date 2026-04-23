import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Helpers {
  static final Uuid _uuid = Uuid();

  static String generateId() {
    return _uuid.v4();
  }

  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}天后';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时后';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟后';
    } else if (difference.inSeconds > 0) {
      return '刚刚';
    } else {
      return '已过期';
    }
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
  }

  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return const Color(0xFFF44336);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.grey;
      case 'inProgress':
        return const Color(0xFF2196F3);
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'delayed':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  static String getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String getFileName(String path) {
    return path.split('/').last;
  }

  static bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static String escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#039;');
  }

  static List<String> extractMentions(String text) {
    final RegExp mentionRegex = RegExp(r'@(\w+)');
    return mentionRegex.allMatches(text).map((match) => match.group(1)!).toList();
  }

  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static double calculateProgress(List<dynamic> items, bool Function(dynamic) isCompleted) {
    if (items.isEmpty) return 0.0;
    final completed = items.where(isCompleted).length;
    return (completed / items.length) * 100;
  }
}

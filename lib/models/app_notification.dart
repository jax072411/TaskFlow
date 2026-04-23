import 'package:hive/hive.dart';

part 'app_notification.g.dart';

@HiveType(typeId: 7)
enum NotificationType {
  @HiveField(0)
  taskAssigned,

  @HiveField(1)
  taskStatusChanged,

  @HiveField(2)
  taskDeadline,

  @HiveField(3)
  commentMention,

  @HiveField(4)
  projectUpdate,
}

@HiveType(typeId: 8)
class AppNotification extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  NotificationType type;

  @HiveField(2)
  String title;

  @HiveField(3)
  String message;

  @HiveField(4)
  String? relatedId; // taskId, projectId, etc.

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  DateTime createdAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.relatedId,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'title': title,
      'message': message,
      'relatedId': relatedId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      type: NotificationType.values[json['type'] ?? 0],
      title: json['title'],
      message: json['message'],
      relatedId: json['relatedId'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

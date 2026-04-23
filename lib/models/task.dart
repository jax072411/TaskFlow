import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 2)
enum TaskPriority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,
}

@HiveType(typeId: 3)
enum TaskStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  completed,

  @HiveField(3)
  delayed,
}

@HiveType(typeId: 4)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String projectId;

  @HiveField(2)
  String? parentTaskId;

  @HiveField(3)
  String name;

  @HiveField(4)
  String? description;

  @HiveField(5)
  String? assigneeId;

  @HiveField(6)
  List<String> participantIds;

  @HiveField(7)
  DateTime? startDate;

  @HiveField(8)
  DateTime? endDate;

  @HiveField(9)
  TaskPriority priority;

  @HiveField(10)
  TaskStatus status;

  @HiveField(11)
  List<String> attachmentIds;

  @HiveField(12)
  int? order;

  @HiveField(13)
  DateTime createdAt;

  @HiveField(14)
  DateTime? updatedAt;

  Task({
    required this.id,
    required this.projectId,
    this.parentTaskId,
    required this.name,
    this.description,
    this.assigneeId,
    List<String>? participantIds,
    this.startDate,
    this.endDate,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    List<String>? attachmentIds,
    this.order,
    DateTime? createdAt,
  })  : participantIds = participantIds ?? [],
        attachmentIds = attachmentIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  bool get isOverdue {
    if (endDate == null || status == TaskStatus.completed) return false;
    return endDate!.isBefore(DateTime.now());
  }

  bool get isNearDeadline {
    if (endDate == null || status == TaskStatus.completed) return false;
    final daysLeft = endDate!.difference(DateTime.now()).inDays;
    return daysLeft <= 3 && daysLeft >= 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'parentTaskId': parentTaskId,
      'name': name,
      'description': description,
      'assigneeId': assigneeId,
      'participantIds': participantIds,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'priority': priority.index,
      'status': status.index,
      'attachmentIds': attachmentIds,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      projectId: json['projectId'],
      parentTaskId: json['parentTaskId'],
      name: json['name'],
      description: json['description'],
      assigneeId: json['assigneeId'],
      participantIds: List<String>.from(json['participantIds'] ?? []),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      priority: TaskPriority.values[json['priority'] ?? 1],
      status: TaskStatus.values[json['status'] ?? 0],
      attachmentIds: List<String>.from(json['attachmentIds'] ?? []),
      order: json['order'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
enum ProjectStatus {
  @HiveField(0)
  notStarted,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  completed,

  @HiveField(3)
  archived,
}

@HiveType(typeId: 1)
class Project extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime? startDate;

  @HiveField(4)
  DateTime? endDate;

  @HiveField(5)
  ProjectStatus status;

  @HiveField(6)
  String? coverImage;

  @HiveField(7)
  String? ownerId;

  @HiveField(8)
  List<String> memberIds;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime? updatedAt;

  Project({
    required this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.status = ProjectStatus.notStarted,
    this.coverImage,
    this.ownerId,
    List<String>? memberIds,
    DateTime? createdAt,
  })  : memberIds = memberIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  double get progress {
    // Calculate based on completed tasks (this would come from task provider)
    return 0.0;
  }

  bool get isOverdue {
    if (endDate == null || status == ProjectStatus.completed) return false;
    return endDate!.isBefore(DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status.index,
      'coverImage': coverImage,
      'ownerId': ownerId,
      'memberIds': memberIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: ProjectStatus.values[json['status'] ?? 0],
      coverImage: json['coverImage'],
      ownerId: json['ownerId'],
      memberIds: List<String>.from(json['memberIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

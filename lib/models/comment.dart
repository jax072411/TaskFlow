import 'package:hive/hive.dart';

part 'comment.g.dart';

@HiveType(typeId: 6)
class Comment extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String taskId;

  @HiveField(2)
  String authorId;

  @HiveField(3)
  List<String> mentions;

  @HiveField(4)
  String content;

  @HiveField(5)
  String? parentCommentId;

  @HiveField(6)
  DateTime createdAt;

  Comment({
    required this.id,
    required this.taskId,
    required this.authorId,
    List<String>? mentions,
    required this.content,
    this.parentCommentId,
    DateTime? createdAt,
  })  : mentions = mentions ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'authorId': authorId,
      'mentions': mentions,
      'content': content,
      'parentCommentId': parentCommentId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      taskId: json['taskId'],
      authorId: json['authorId'],
      mentions: List<String>.from(json['mentions'] ?? []),
      content: json['content'],
      parentCommentId: json['parentCommentId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

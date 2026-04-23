import 'package:hive/hive.dart';

part 'member.g.dart';

@HiveType(typeId: 5)
class Member extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String? avatarUrl;

  @HiveField(4)
  DateTime joinedAt;

  Member({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}

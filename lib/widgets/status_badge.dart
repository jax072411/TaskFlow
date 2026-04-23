import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/project.dart';
import '../utils/constants.dart';

class StatusBadge extends StatelessWidget {
  final dynamic status;
  final bool small;

  const StatusBadge({
    super.key,
    required this.status,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    String label = '';

    if (status is TaskStatus) {
      switch (status) {
        case TaskStatus.pending:
          color = Colors.grey;
          label = '待处理';
          break;
        case TaskStatus.inProgress:
          color = Colors.blue;
          label = '进行中';
          break;
        case TaskStatus.completed:
          color = Colors.green;
          label = '已完成';
          break;
        case TaskStatus.delayed:
          color = Colors.red;
          label = '已延期';
          break;
      }
    } else if (status is ProjectStatus) {
      switch (status) {
        case ProjectStatus.notStarted:
          color = Colors.grey;
          label = '未开始';
          break;
        case ProjectStatus.inProgress:
          color = Colors.blue;
          label = '进行中';
          break;
        case ProjectStatus.completed:
          color = Colors.green;
          label = '已完成';
          break;
        case ProjectStatus.archived:
          color = Colors.blueGrey;
          label = '已归档';
          break;
      }
    } else {
      color = Colors.grey;
      label = status.toString();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

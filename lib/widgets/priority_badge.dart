import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool small;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        label = '高';
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        label = '中';
        break;
      case TaskPriority.low:
        color = Colors.green;
        label = '低';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
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

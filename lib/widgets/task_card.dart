import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'priority_badge.dart';
import 'status_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onStatusChange;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onDelete,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.isOverdue && task.status != TaskStatus.completed;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onStatusChange?.call(),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.check_circle,
            label: '完成',
          ),
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isOverdue ? Colors.red.withOpacity(0.3) : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Status checkbox
                    GestureDetector(
                      onTap: () {
                        // Toggle task status
                        if (task.status != TaskStatus.completed) {
                          task.status = TaskStatus.completed;
                        } else {
                          task.status = TaskStatus.pending;
                        }
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: task.status == TaskStatus.completed
                              ? Colors.green
                              : Colors.transparent,
                          border: Border.all(
                            color: task.status == TaskStatus.completed
                                ? Colors.green
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: task.status == TaskStatus.completed
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title
                    Expanded(
                      child: Text(
                        task.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: task.status == TaskStatus.completed
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.status == TaskStatus.completed
                              ? Colors.grey
                              : null,
                        ),
                      ),
                    ),
                    // Priority badge
                    PriorityBadge(priority: task.priority, small: true),
                    const SizedBox(width: 8),
                    // Menu button
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('编辑'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'status',
                          child: Row(
                            children: [
                              Icon(Icons.change_circle, size: 16),
                              SizedBox(width: 8),
                              Text('更改状态'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('删除', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') onTap();
                        if (value == 'status') onStatusChange?.call();
                        if (value == 'deadline') {
                          // Show date picker
                        }
                        if (value == 'delete') onDelete?.call();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                if (task.description != null && task.description!.isNotEmpty)
                  Text(
                    task.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                // Footer row
                Row(
                  children: [
                    // Assignee
                    if (task.assigneeId != null)
                      Row(
                        children: [
                          const Icon(Icons.person, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '负责人',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(width: 12),
                    // Due date
                    if (task.endDate != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: isOverdue ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Helpers.formatDate(task.endDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: isOverdue ? Colors.red : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    // Status badge
                    StatusBadge(status: task.status, small: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

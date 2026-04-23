import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'task_card.dart';

class KanbanBoard extends ConsumerStatefulWidget {
  final List<Task> tasks;
  final Project project;

  const KanbanBoard({
    super.key,
    required this.tasks,
    required this.project,
  });

  @override
  ConsumerState<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends ConsumerState<KanbanBoard> {
  @override
  Widget build(BuildContext context) {
    final pendingTasks = widget.tasks.where((t) => t.status == TaskStatus.pending).toList();
    final inProgressTasks = widget.tasks.where((t) => t.status == TaskStatus.inProgress).toList();
    final completedTasks = widget.tasks.where((t) => t.status == TaskStatus.completed).toList();
    final delayedTasks = widget.tasks.where((t) => t.status == TaskStatus.delayed).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumn(TaskStatus.pending, pendingTasks),
          _buildColumn(TaskStatus.inProgress, inProgressTasks),
          _buildColumn(TaskStatus.completed, completedTasks),
          if (delayedTasks.isNotEmpty)
            _buildColumn(TaskStatus.delayed, delayedTasks),
        ],
      ),
    );
  }

  Widget _buildColumn(TaskStatus status, List<Task> tasks) {
    final statusColor = Helpers.getStatusColor(status.name);
    final statusLabel = AppConstants.taskStatusLabels[status.name] ?? '';

    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(color: statusColor.withOpacity(0.3)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      tasks.length.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Task list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildTaskItem(task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: task.isOverdue ? Colors.red.withOpacity(0.3) : Colors.transparent,
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          title: Text(
            task.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: task.status == TaskStatus.completed
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Helpers.getPriorityColor(task.priority.name).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppConstants.taskPriorityLabels[task.priority.name] ?? '',
                  style: TextStyle(
                    fontSize: 10,
                    color: Helpers.getPriorityColor(task.priority.name),
                  ),
                ),
              ),
              if (task.endDate != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.calendar_today,
                  size: 12,
                  color: task.isOverdue ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  Helpers.formatDate(task.endDate),
                  style: TextStyle(
                    fontSize: 11,
                    color: task.isOverdue ? Colors.red : Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
          trailing: PopupMenuButton<String>(
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
              if (value == 'edit') {
                _showEditTaskDialog(task);
              } else if (value == 'delete') {
                _deleteTask(task);
              }
            },
          ),
        ),
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑任务'),
        content: TextFormField(
          initialValue: task.name,
          decoration: const InputDecoration(
            labelText: '任务名称',
            border: OutlineInputBorder(),
          ),
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              task.name = value;
              ref.read(taskProvider.notifier).updateTask(task);
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _changeTaskStatus(task);
            },
            child: const Text('更改状态'),
          ),
        ],
      ),
    );
  }

  void _changeTaskStatus(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('更改状态'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskStatus.values.map((status) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Helpers.getStatusColor(status.name).withOpacity(0.2),
                child: Icon(
                  Icons.circle,
                  size: 12,
                  color: Helpers.getStatusColor(status.name),
                ),
              ),
              title: Text(AppConstants.taskStatusLabels[status.name] ?? ''),
              onTap: () {
                ref.read(taskProvider.notifier).updateTaskStatus(task.id, status);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('状态已更新为 ${AppConstants.taskStatusLabels[status.name]}')),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除任务'),
        content: Text('确定要删除任务 "${task.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('任务已删除')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

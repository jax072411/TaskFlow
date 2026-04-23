import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'status_badge.dart';

class ProjectCard extends ConsumerWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider).where((t) => t.projectId == project.id).toList();
    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).length;
    final progress = tasks.isNotEmpty ? (completedTasks / tasks.length) * 100 : 0.0;
    final isOverdue = project.isOverdue;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Cover/Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      image: project.coverImage != null
                          ? DecorationImage(
                              image: FileImage(File(project.coverImage!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: project.coverImage == null
                        ? const Icon(
                            AppIcons.project,
                            color: Colors.blue,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Title and Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        StatusBadge(status: project.status, small: true),
                      ],
                    ),
                  ),
                  // Overdue indicator
                  if (isOverdue)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  const SizedBox(width: 8),
                  // Menu button
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
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
                        value: 'archive',
                        child: Row(
                          children: [
                            Icon(Icons.archive, size: 16),
                            SizedBox(width: 8),
                            Text('归档'),
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
                      if (value == 'edit') onEdit?.call();
                      if (value == 'archive') {
                        project.status = ProjectStatus.archived;
                      }
                      if (value == 'delete') onDelete?.call();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Description
              if (project.description != null && project.description!.isNotEmpty)
                Text(
                  project.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              // Progress bar
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 100 ? Colors.green : Colors.blue,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${progress.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Footer info
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.task, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '$completedTasks/${tasks.length} 任务',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (project.endDate != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          Helpers.formatDate(project.endDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? Colors.red : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

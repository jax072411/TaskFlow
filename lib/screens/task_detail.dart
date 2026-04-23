import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../models/comment.dart';
import '../models/project.dart';
import '../providers/task_provider.dart';
import '../providers/comment_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/priority_badge.dart';
import '../widgets/status_badge.dart';
import '../widgets/add_edit_task_dialog.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final Task task;
  final Project project;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.project,
  });

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentProvider).where((c) => c.taskId == widget.task.id).toList();
    final currentUser = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('任务详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditTaskDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Info
                  Row(
                    children: [
                      Icon(Icons.folder, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.project.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Task Title
                  Text(
                    widget.task.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Status and Priority
                  Row(
                    children: [
                      StatusBadge(status: widget.task.status),
                      const SizedBox(width: 8),
                      PriorityBadge(priority: widget.task.priority),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  if (widget.task.description != null && widget.task.description!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '描述',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(widget.task.description!),
                      ],
                    ),
                  const SizedBox(height: 24),
                  // Dates
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          '开始日期',
                          Helpers.formatDate(widget.task.createdAt),
                          Icons.play_circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          '截止日期',
                          widget.task.endDate != null
                              ? Helpers.formatDate(widget.task.endDate)
                              : '未设置',
                          Icons.calendar_today,
                          isOverdue: widget.task.isOverdue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Comments Section
                  const Text(
                    '评论',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCommentList(comments, currentUser),
                ],
              ),
            ),
          ),
          // Comment Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: '添加评论...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () => _addComment(currentUser),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, {bool isOverdue = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isOverdue ? Colors.red : Colors.grey),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isOverdue ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentList(List<Comment> comments, currentUser) {
    if (comments.isEmpty) {
      return const Text(
        '暂无评论',
        style: TextStyle(color: Colors.grey),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final comment = comments[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      child: Text(
                        Helpers.getInitials(comment.authorId),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.authorId, // In a real app, lookup user name
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      Helpers.formatDate(comment.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(comment.content),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditTaskDialog(
        projectId: widget.task.projectId,
        project: widget.project,
        task: widget.task,
      ),
    );
  }

  void _addComment(currentUser) {
    if (_commentController.text.trim().isEmpty) return;

    final comment = Comment(
      id: Helpers.generateId(),
      taskId: widget.task.id,
      authorId: currentUser?.name ?? 'Unknown',
      content: _commentController.text.trim(),
    );

    ref.read(commentProvider.notifier).addComment(comment);
    _commentController.clear();
  }
}


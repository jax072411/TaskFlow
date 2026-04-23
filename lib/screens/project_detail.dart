import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/project_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/kanban_board.dart';
import '../widgets/add_edit_task_dialog.dart';
import '../widgets/add_edit_project_dialog.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'task_detail.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _viewIndex = 0; // 0: Kanban, 1: List, 2: Calendar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(projectTasksProvider(widget.project.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _viewIndex = index;
            });
          },
          tabs: const [
            Tab(icon: Icon(Icons.view_kanban), text: '看板'),
            Tab(icon: Icon(Icons.list), text: '列表'),
            Tab(icon: Icon(Icons.calendar_today), text: '日历'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('编辑项目')),
              const PopupMenuItem(value: 'archive', child: Text('归档项目')),
              const PopupMenuItem(value: 'delete', child: Text('删除项目', style: TextStyle(color: Colors.red))),
            ],
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditProjectDialog();
                  break;
                case 'delete':
                  _deleteProject();
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Project info bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.project.description != null && widget.project.description!.isNotEmpty)
                        Text(
                          widget.project.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${Helpers.formatDate(widget.project.startDate)} - ${Helpers.formatDate(widget.project.endDate)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Progress
                Container(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: _calculateProgress(tasks),
                    strokeWidth: 6,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _calculateProgress(tasks) >= 1.0 ? Colors.green : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // View content
          Expanded(
            child: _buildViewContent(tasks),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildViewContent(List<Task> tasks) {
    switch (_viewIndex) {
      case 0:
        return KanbanBoard(tasks: tasks, project: widget.project);
      case 1:
        return _buildListView(tasks);
      case 2:
        return _buildCalendarView(tasks);
      default:
        return const SizedBox();
    }
  }

  Widget _buildListView(List<Task> tasks) {
    if (tasks.isEmpty) {
      return _buildEmptyState('暂无任务');
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onTap: () => _openTaskDetail(task),
          onDelete: () => _deleteTask(task),
          onStatusChange: () => _cycleTaskStatus(task),
        );
      },
    );
  }

  Widget _buildCalendarView(List<Task> tasks) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('日历视图开发中...'),
          const SizedBox(height: 8),
          Text('${tasks.length} 个任务'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateProgress(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    return completed / tasks.length;
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditTaskDialog(
        projectId: widget.project.id,
        project: widget.project,
      ),
    );
  }

  void _openTaskDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          project: widget.project,
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

  void _cycleTaskStatus(Task task) {
    final newStatus = TaskStatus.values[(task.status.index + 1) % TaskStatus.values.length];
    ref.read(taskProvider.notifier).updateTaskStatus(task.id, newStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('状态已更新为 ${AppConstants.taskStatusLabels[newStatus.name]}')),
    );
  }

  void _showEditProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditProjectDialog(project: widget.project),
    );
  }

  void _deleteProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除项目'),
        content: Text('确定要删除项目 "${widget.project.name}" 吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              ref.read(projectProvider.notifier).deleteProject(widget.project.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('项目已删除')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}


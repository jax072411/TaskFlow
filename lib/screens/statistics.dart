import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/task.dart';
import '../models/project.dart';
import '../providers/task_provider.dart';
import '../providers/project_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final tasks = ref.watch(taskProvider);
    final projects = ref.watch(projectProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('统计报表'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('导出 Excel'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'export') {
                _exportToExcel(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            _buildSummaryCards(stats),
            const SizedBox(height: 24),
            // Task Priority Chart
            _buildPriorityChart(stats),
            const SizedBox(height: 24),
            // Project Progress
            _buildProjectProgress(projects, tasks),
            const SizedBox(height: 24),
            // Member Task Stats
            _buildMemberStats(tasks),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          '总任务数',
          stats['totalTasks'].toString(),
          Icons.task,
          Colors.blue,
        ),
        _buildStatCard(
          '已完成',
          stats['completedTasks'].toString(),
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          '进行中',
          stats['inProgressTasks'].toString(),
          Icons.play_circle,
          Colors.orange,
        ),
        _buildStatCard(
          '已延期',
          stats['overdueTasks'].toString(),
          Icons.warning,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChart(Map<String, dynamic> stats) {
    final high = stats['highPriority'] as int;
    final medium = stats['mediumPriority'] as int;
    final low = stats['lowPriority'] as int;
    final total = high + medium + low;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '任务优先级分布',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (high + medium + low).toDouble() + 2,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('高');
                            case 1:
                              return const Text('中');
                            case 2:
                              return const Text('低');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: high.toDouble(),
                          color: Colors.red,
                          width: 30,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: medium.toDouble(),
                          color: Colors.orange,
                          width: 30,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: low.toDouble(),
                          color: Colors.green,
                          width: 30,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPriorityLegend('高', high, Colors.red),
                _buildPriorityLegend('中', medium, Colors.orange),
                _buildPriorityLegend('低', low, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityLegend(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text('$label: $count'),
      ],
    );
  }

  Widget _buildProjectProgress(List<Project> projects, List<Task> tasks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '项目进度',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (projects.isEmpty)
              const Text('暂无项目')
            else
              ...projects.take(5).map((project) {
                final projectTasks = tasks.where((t) => t.projectId == project.id).toList();
                final completed = projectTasks.where((t) => t.status == TaskStatus.completed).length;
                final progress = projectTasks.isNotEmpty ? completed / projectTasks.length : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              project.name,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1.0 ? Colors.green : Colors.blue,
                        ),
                        minHeight: 6,
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberStats(List<Task> tasks) {
    // Group tasks by assignee (simulated with task counts)
    final assigneeCounts = <String, int>{};
    for (var task in tasks) {
      if (task.assigneeId != null) {
        assigneeCounts.update(
          task.assigneeId!,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '成员任务统计',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (assigneeCounts.isEmpty)
              const Text('暂无分配的任务')
            else
              ...assigneeCounts.entries.take(5).map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        child: Text(
                          Helpers.getInitials(entry.key),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${entry.value} 个任务',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  void _exportToExcel(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('导出功能开发中...')),
    );
  }
}

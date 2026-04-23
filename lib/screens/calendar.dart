import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final selectedTasks = _getTasksForDay(_selectedDay ?? _focusedDay, tasks);

    return Scaffold(
      appBar: AppBar(
        title: const Text('日历'),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              eventLoader: (day) {
                return tasks.where((task) =>
                    task.endDate != null && isSameDay(task.endDate!, day)
                ).toList();
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  _selectedDay != null
                      ? '${_selectedDay!.year}年${_selectedDay!.month}月${_selectedDay!.day}日'
                      : '${_focusedDay.year}年${_focusedDay.month}月',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${selectedTasks.length} 个任务',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: selectedTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '当天无任务',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: selectedTasks.length,
                    itemBuilder: (context, index) {
                      final task = selectedTasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Helpers.getPriorityColor(task.priority.name),
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(task.name),
                          subtitle: Text(
                            task.description ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            AppConstants.taskStatusLabels[task.status.name] ?? '',
                            style: TextStyle(
                              color: Helpers.getStatusColor(task.status.name),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Task> _getTasksForDay(DateTime day, List<Task> tasks) {
    return tasks.where((task) =>
        task.endDate != null && isSameDay(task.endDate!, day)
    ).toList();
  }
}

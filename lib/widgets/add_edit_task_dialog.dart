import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../models/project.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class AddEditTaskDialog extends ConsumerStatefulWidget {
  final String projectId;
  final Project project;
  final Task? task;

  const AddEditTaskDialog({
    super.key,
    required this.projectId,
    required this.project,
    this.task,
  });

  @override
  ConsumerState<AddEditTaskDialog> createState() => _AddEditTaskDialogState();
}

class _AddEditTaskDialogState extends ConsumerState<AddEditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _nameController.text = widget.task!.name;
      _descriptionController.text = widget.task!.description ?? '';
      _priority = widget.task!.priority;
      _endDate = widget.task!.endDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? '创建任务' : '编辑任务'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '任务名称',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return '请输入任务名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '任务描述',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskPriority>(
                      value: _priority,
                      decoration: const InputDecoration(
                        labelText: '优先级',
                        border: OutlineInputBorder(),
                      ),
                      items: TaskPriority.values.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Helpers.getPriorityColor(priority.name),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(AppConstants.taskPriorityLabels[priority.name] ?? priority.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _priority = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() {
                            _endDate = date;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: '截止日期',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _endDate != null ? Helpers.formatDate(_endDate) : '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: const Text('保存'),
        ),
      ],
    );
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: widget.task?.id ?? Helpers.generateId(),
      projectId: widget.projectId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      endDate: _endDate,
      status: TaskStatus.pending,
      createdAt: widget.task?.createdAt,
    );

    if (widget.task == null) {
      ref.read(taskProvider.notifier).addTask(task);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('任务创建成功')),
      );
    } else {
      ref.read(taskProvider.notifier).updateTask(task);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('任务更新成功')),
      );
    }

    Navigator.pop(context);
  }
}

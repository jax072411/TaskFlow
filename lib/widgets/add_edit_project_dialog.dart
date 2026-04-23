import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../providers/auth_provider.dart';
import '../providers/project_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class AddEditProjectDialog extends ConsumerStatefulWidget {
  final Project? project;

  const AddEditProjectDialog({super.key, this.project});

  @override
  ConsumerState<AddEditProjectDialog> createState() => _AddEditProjectDialogState();
}

class _AddEditProjectDialogState extends ConsumerState<AddEditProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  ProjectStatus _status = ProjectStatus.notStarted;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _nameController.text = widget.project!.name;
      _descriptionController.text = widget.project!.description ?? '';
      _startDate = widget.project!.startDate;
      _endDate = widget.project!.endDate;
      _status = widget.project!.status;
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
      title: Text(widget.project == null ? '创建项目' : '编辑项目'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '项目名称',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return '请输入项目名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '项目描述',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: '开始日期',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _startDate != null ? Helpers.formatDate(_startDate) : '',
                      ),
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
                        labelText: '结束日期',
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
              const SizedBox(height: 16),
              DropdownButtonFormField<ProjectStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: '状态',
                  border: OutlineInputBorder(),
                ),
                items: ProjectStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(AppConstants.projectStatusLabels[status.name] ?? status.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
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
          onPressed: _saveProject,
          child: const Text('保存'),
        ),
      ],
    );
  }

  void _saveProject() {
    if (!_formKey.currentState!.validate()) return;

    final project = Project(
      id: widget.project?.id ?? Helpers.generateId(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      status: _status,
      ownerId: ref.read(authProvider)?.id,
    );

    if (widget.project == null) {
      ref.read(projectProvider.notifier).addProject(project);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('项目创建成功')),
      );
    } else {
      ref.read(projectProvider.notifier).updateProject(project);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('项目更新成功')),
      );
    }

    Navigator.pop(context);
  }
}

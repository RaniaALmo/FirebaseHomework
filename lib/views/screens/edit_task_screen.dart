import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/task.dart';
import '../../viewmodels/tasks/task_states.dart';
import '../../viewmodels/tasks/task_vm.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final String projectId;
  const EditTaskScreen({super.key, required this.task , required this.projectId});

  @override
  State<EditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _startAtController;
  late TextEditingController _endAtController;
  late TextEditingController _statusController;
  late TextEditingController _progressController;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? startDate;
  DateTime? deadline;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          deadline = picked;
        }
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _startAtController = TextEditingController(
        text: widget.task.startAt != null ? _dateFormat.format(widget.task.startAt!) : '');
    _endAtController = TextEditingController(
        text: widget.task.endAt != null ? _dateFormat.format(widget.task.endAt!) : '');
    _statusController = TextEditingController(text: widget.task.status);
    _progressController = TextEditingController(text: widget.task.progress?.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startAtController.dispose();
    _endAtController.dispose();
    _statusController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),
      body:
      BlocListener<TaskVm, TaskStates>(
        listener: (context, state) {
          if (state is TaskUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(' Task updated successfully!')),
            );
            Navigator.pop(context);
          }
          else if (state is ErrorTasks) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(' Error: ${state.message}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                CustomTextField(
                  label: "Title",
                  controller: _titleController,
                ),
                const SizedBox(height: 12),

                // Description
                CustomTextField(
                  label: "Description",
                  controller: _descriptionController,
                ),
                const SizedBox(height: 12),

                // Dates Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: widget.task.startAt ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _startAtController.text = _dateFormat.format(picked);
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today_outlined, size: 18),
                        label: Text(_startAtController.text.isEmpty
                            ? "Start Date"
                            : _startAtController.text),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: widget.task.endAt ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _endAtController.text = _dateFormat.format(picked);
                            });
                          }
                        },
                        icon: const Icon(Icons.flag_outlined, size: 18),
                        label: Text(_endAtController.text.isEmpty
                            ? "Deadline"
                            : _endAtController.text),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Status
                CustomTextField(
                  label: "Status",
                  controller: _statusController,
                ),
                const SizedBox(height: 12),

                // Progress
                CustomTextField(
                  label: "Progress (%)",
                  controller: _progressController,
                ),
                const SizedBox(height: 24),

                // Save Button
                CustomButton(
                  text: "Update Task",
                  onPressed: () {
                    //DateTime? startDate = DateTime.tryParse(_startAtController.text);
                    //DateTime? endDate = DateTime.tryParse(_endAtController.text);
                    DateTime? startDate;
                    if (_startAtController.text.trim().isNotEmpty) {
                      startDate = _dateFormat.parse(_startAtController.text.trim());
                    }

                    DateTime? endDate;
                    if (_endAtController.text.trim().isNotEmpty) {
                      endDate = _dateFormat.parse(_endAtController.text.trim());
                    }


                    Task updatedTask = Task(
                      taskId: widget.task.taskId,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      startAt: startDate,
                      endAt: endDate,
                      status: _statusController.text,
                      progress: double.tryParse(_progressController.text) ?? 0,
                    );

                    context.read<TaskVm>().updateTask(widget.projectId, updatedTask,);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

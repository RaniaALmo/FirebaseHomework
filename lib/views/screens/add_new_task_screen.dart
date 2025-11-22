import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../viewmodels/tasks/task_vm.dart';
import '../../viewmodels/tasks/task_states.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';

class AddNewTaskScreen extends StatefulWidget {
  final String projectId;
  const AddNewTaskScreen({super.key, required this.projectId});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startAtController = TextEditingController();
  final TextEditingController _endAtController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _progressController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = _dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskVm, TaskStates>(
      listener: (context, state) {
        if (state is TaskCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(' Task created successfully!')),
          );
          Navigator.pop(context);
        } else if (state is ErrorTasks) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(' Error: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add New Task')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(label: 'Title', controller: _titleController),
                const SizedBox(height: 12),
                CustomTextField(label: 'Description', controller: _descriptionController),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectDate(context, _startAtController),
                        icon: const Icon(Icons.calendar_today_outlined, size: 18),
                        label: Text(
                          _startAtController.text.isEmpty
                              ? "Start Date"
                              : _startAtController.text,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectDate(context, _endAtController),
                        icon: const Icon(Icons.flag_outlined, size: 18),
                        label: Text(
                          _endAtController.text.isEmpty
                              ? "Deadline"
                              : _endAtController.text,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                CustomTextField(label: 'Status', controller: _statusController),
                const SizedBox(height: 12),
                CustomTextField(label: 'Progress (%)', controller: _progressController),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Save Task',
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      DateTime? startDate = DateTime.tryParse(_startAtController.text);
                      DateTime? endDate = DateTime.tryParse(_endAtController.text);

                      if (_titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Task title is required"))
                        );
                        return;
                      }

                      if (startDate == null || endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter valid dates"))
                        );
                        return;
                      }

                      Task task = Task(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        startAt: startDate,
                        endAt: endDate,
                        status: _statusController.text,
                        progress: double.tryParse(_progressController.text),
                      );

                      context.read<TaskVm>().saveTask(widget.projectId, task);
                    }
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
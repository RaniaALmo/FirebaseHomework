import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/app_user.dart';
import '../../models/project.dart';
import '../../viewmodels/projects/project_states.dart';
import '../../viewmodels/projects/projects_vm.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../components/users_multi_select.dart';

class EditProjectScreen extends StatefulWidget {
  final Project project;

   EditProjectScreen({super.key, required this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _startAtController;
  late TextEditingController _endAtController;
  late TextEditingController _statusController;
  late TextEditingController _progressController;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  List<AppUser> _selectedUsers = [];
  bool _editingUsers = false;
  List<String> _currentUsers = [];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.project.title);
    _descriptionController = TextEditingController(text: widget.project.description);
    _currentUsers = widget.project.users ?? [];

    _startAtController = TextEditingController(
        text: widget.project.startAt != null ? _dateFormat.format(widget.project.startAt!) : "");

    _endAtController = TextEditingController(
        text: widget.project.endAt != null ? _dateFormat.format(widget.project.endAt!) : "");

    _statusController = TextEditingController(text: widget.project.status);
    _progressController = TextEditingController(
        text: widget.project.progress != null ? widget.project.progress!.toString() : "");
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
      appBar: AppBar(title: const Text("Edit Project")),
      body: BlocListener<ProjectVm, ProjectStates>(
        listener: (context, state) {
          if (state is ProjectUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(" Project updated successfully!")),
            );
            Navigator.pushReplacementNamed(
              context,
              '/home',
            );
          } else if (state is ErrorProjects) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(" Error: ${state.message}")),
            );
          }
        },

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                label: "Title",
                controller: _titleController,
              ),
              const SizedBox(height: 12),

              CustomTextField(
                label: "Description",
                controller: _descriptionController,
              ),
              const SizedBox(height: 12),
          // Users
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Users:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _editingUsers = !_editingUsers;
                      });
                    },
                    child: Text(_editingUsers ? "Cancel" : "Edit Users"),
                  ),
                ],
              ),

              if (!_editingUsers)
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _currentUsers.map((userName) {
                    return Chip(
                      avatar: const Icon(Icons.person, size: 18),
                      label: Text(userName),
                    );
                  }).toList(),
                ),

              if (_editingUsers)
                UsersMultiSelect(
                  selectedUsers: _selectedUsers,
                  onChanged: (values) {
                    setState(() => _selectedUsers = values);
                  },
                ),
            ],
          ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: widget.project.startAt ?? DateTime.now(),
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
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: widget.project.endAt ?? DateTime.now(),
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

              CustomTextField(
                label: "Status",
                controller: _statusController,
              ),
              const SizedBox(height: 12),

              CustomTextField(
                label: "Progress (%)",
                controller: _progressController,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: "Update Project",
                onPressed: () {
                  DateTime? startDate;
                  if (_startAtController.text.trim().isNotEmpty) {
                    startDate = _dateFormat.parse(_startAtController.text.trim());
                  }

                  DateTime? endDate;
                  if (_endAtController.text.trim().isNotEmpty) {
                    endDate = _dateFormat.parse(_endAtController.text.trim());
                  }

                  List<String> usersList = _editingUsers
                      ? _selectedUsers.map((u) => u.name ?? "").toList()
                      : _currentUsers;

                  Project updatedProject = Project(
                    projectId: widget.project.projectId,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    users: usersList,
                    startAt: startDate,
                    endAt: endDate,
                    status: _statusController.text,
                    progress: double.tryParse(_progressController.text) ?? 0,
                  );

                  context.read<ProjectVm>().updateProject(
                    widget.project.projectId!,
                    updatedProject,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

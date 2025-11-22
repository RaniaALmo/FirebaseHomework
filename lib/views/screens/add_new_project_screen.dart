import 'package:firebase_homework/models/app_user.dart';
import 'package:firebase_homework/viewmodels/users/users_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/project.dart';
import '../../viewmodels/projects/project_states.dart';
import '../../viewmodels/projects/projects_vm.dart';
import '../../viewmodels/users/users_states.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../components/users_multi_select.dart';

class AddNewProjectScreen extends StatefulWidget {
  const AddNewProjectScreen({super.key});

  @override
  State<AddNewProjectScreen> createState() => _AddNewProjectScreenState();
}

class _AddNewProjectScreenState extends State<AddNewProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startAtController = TextEditingController();
  final TextEditingController _endAtController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _progressController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  UserVM _uservm = UserVM();
  List<AppUser> _selectedUsers = [];

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) controller.text = _dateFormat.format(picked);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Project')),
      body:
      BlocListener<ProjectVm, ProjectStates>(
        listener: (context, state) {
          if (state is ProjectCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(' Project created successfully!')),
            );
            Navigator.pushReplacementNamed(
              context,
              '/home',
            );
          } else if (state is ErrorProjects) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(' Error: ${state.message}')),
            );
          }
        },
        child:
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(label: 'Title', controller: _titleController),
                CustomTextField(label: 'Description', controller: _descriptionController),
                const SizedBox(height: 8),
                Text('Assign Users',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                UsersMultiSelect(
                  selectedUsers: _selectedUsers,
                  onChanged: (values) {
                    setState(() => _selectedUsers = values);
                  },
                ),
                const SizedBox(height: 12),
                // --- Date Pickers ---
                GestureDetector(
                  onTap: () => _selectDate(context, _startAtController),
                  child: AbsorbPointer(
                    child:
                    CustomTextField(label: 'Start Date', controller: _startAtController),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context, _endAtController),
                  child: AbsorbPointer(
                    child:
                    CustomTextField(label: 'End Date', controller: _endAtController),
                  ),
                ),
                CustomTextField(label: 'Status', controller: _statusController),
                CustomTextField(label: 'Progress (%)', controller: _progressController),
                const SizedBox(height: 24),
                CustomButton(
                   text: 'Save Project',
                    onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          List<String> usersList = _selectedUsers.map((u) => u.name ?? "").toList();
                          DateTime? startDate = DateTime.tryParse(_startAtController.text);
                          DateTime? endDate = DateTime.tryParse(_endAtController.text);
                          Project project = Project(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            users: usersList,
                            startAt: startDate,
                            endAt: endDate,
                            status: _statusController.text,
                            progress: double.tryParse(_progressController.text),
                          );

                          context.read<ProjectVm>().saveProjectToFirebase(project);
                        }
                      },
                ),
              ],
            ),
          ),
        ),
      )
    );

  }
}
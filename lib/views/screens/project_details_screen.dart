import 'package:firebase_homework/views/screens/add_new_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/app_user.dart';
import '../../models/project.dart';
import '../../models/task.dart';
import '../../viewmodels/tasks/task_states.dart';
import '../../viewmodels/tasks/task_vm.dart';
import '../components/project_info.dart';
import '../components/task_list.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late TaskVm _taskVm;

  @override
  Widget build(BuildContext context) {
    context.read<TaskVm>().loadTasks(widget.project.projectId!);
    final project = widget.project;
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: Text('Project Details')),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddNewTaskScreen(
                projectId: project.projectId!,
              ),
            ),
          ).then((_) {
            _taskVm.loadTasks(project.projectId!);
          });
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
      ),

      body:
      SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Info
            ProjectInfo(project: project),
            const SizedBox(height: 30),
            // Tasks
            Text(
              "Tasks",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            BlocListener<TaskVm, TaskStates>(
              //bloc: _taskVm,
              listener: (context, state) {
                if (state is TaskDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Task deleted successfully")),
                  );
                  context.read<TaskVm>().loadTasks(widget.project.projectId!);
                }
                else if (state is ErrorTasks) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: BlocBuilder<TaskVm, TaskStates>(
                //bloc: _taskVm,
                builder: (context, state) {
                  if (state is EmptyTasks) {
                    return const Text("No tasks added yet.");
                  }
                  if (state is LoadingTasks) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is LoadedTasks) {
                    return TaskList(
                      tasks: state.tasks,
                      projectId: widget.project.projectId!,
                    );
                  }
                  return const SizedBox();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
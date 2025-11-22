import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/task.dart';
import '../../viewmodels/tasks/task_states.dart';
import '../../viewmodels/tasks/task_vm.dart';
import '../screens/task_details_screen.dart';
import 'task_card.dart';

class TaskList extends StatelessWidget {
  final List <Task> tasks;
  final String projectId;
  const TaskList({super.key, required this.tasks,required this.projectId});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return
          TaskCard(
            task: tasks[index],
            projectId: projectId,
            onTapEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailsScreen(
                    task: tasks[index],
                    projectId: projectId,
                  ),
                ),
              );
            },
          );
      },
    );
  }
}

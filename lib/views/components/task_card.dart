import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/task.dart';
import '../../viewmodels/tasks/task_vm.dart';
import '../screens/edit_task_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final String projectId;
  final VoidCallback? onTapEdit;
  final VoidCallback? onDelete;

  const TaskCard({super.key, required this.task,required this.projectId, this.onTapEdit,this.onDelete});

  Color _statusColor(String? status) {
    switch (status) {
      case "completed":
        return Colors.green;
      case "in_progress":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM');

    return GestureDetector(
      onTap: onTapEdit,
      child:
      Card(
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- Title & Action Icons --------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title ?? "No Title",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditTaskScreen(task: task, projectId: projectId, ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () {
                          context.read<TaskVm>().deleteTask(projectId, task.taskId!);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // -------- Description --------
              Text(
                task.description ?? "No Description",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 12),

              // -------- Dates & Status --------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dates
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16, color: Colors.indigo[400]),
                      const SizedBox(width: 4),
                      Text(
                        "${task.startAt != null ? dateFormat.format(task.startAt!) : '-'} → ${task.endAt != null ? dateFormat.format(task.endAt!) : '-'}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _statusColor(task.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.status ?? "pending",
                      style: TextStyle(
                        fontSize: 12,
                        color: _statusColor(task.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

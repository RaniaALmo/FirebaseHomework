import 'package:firebase_homework/viewmodels/projects/projects_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/project.dart';
import '../screens/edit_project_screen.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;
  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM');

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0.8,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:
                    // Title
                    Text(
                      project.title ?? "No Title",
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
                            builder: (_) => EditProjectScreen(project: project),
                          ),
                        );
                      },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () {
                          context.read<ProjectVm>().deleteProject(project.projectId!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Description
              Text(
                project.description ?? "No Description",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Team count
                  Row(
                    children: [
                      const Icon(Icons.group_outlined,
                          color: Colors.indigo, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "${project.users?.length ?? 0} Members",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  // Dates
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          color: Colors.indigo[400], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${dateFormat.format(project.startAt!)} → ${dateFormat.format(project.endAt!)}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
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

import 'package:firebase_homework/models/project.dart';
import 'package:firebase_homework/views/components/project_card.dart';
import 'package:flutter/material.dart';

class ProjectsList extends StatelessWidget {
   ProjectsList ({super.key, required this.projects});
  List <Project> projects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            Project project = projects[index];
            return
              ProjectCard(project: project,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/project_details',
                  arguments: project,
                );
              },
            );
            },
        ),
    );
  }
}

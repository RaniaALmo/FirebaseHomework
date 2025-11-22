import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_homework/views/components/projects_list.dart';
import 'package:firebase_homework/views/screens/project_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/auth_vm.dart';
import '../../viewmodels/projects/project_states.dart';
import '../components/project_card.dart';
import '../../viewmodels/projects/projects_vm.dart';
import '../../models/project.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    AuthVm _authVm = AuthVm();
    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox();
    }

    return BlocProvider(
      create: (_) => ProjectVm()..loadProjects(),
      child: Scaffold(
        appBar: AppBar(
           title: Padding(
            padding: const EdgeInsets.only(top: 20,right: 40),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Projects",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 0,top: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Welcome, ${user.displayName}",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.only(right: 12,top: 18),
              child:
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await _authVm.signOut();
                  //Navigator.pushReplacementNamed(context, '/login');
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                        (route) => false,
                  );
                },
              ),
            )
          ],
        ),

        body:
        BlocListener<ProjectVm, ProjectStates>(
          listener: (context, state) {
            if (state is ProjectDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Project deleted successfully")),
              );
              context.read<ProjectVm>().loadProjects();
            }

            else if (state is ErrorProjects) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<ProjectVm, ProjectStates>(
            //bloc: _taskVm,
            builder: (context, state) {
              if (state is EmptyProjects) {
                return const Text("No tasks added yet.");
              }
              if (state is LoadingProjects) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is LoadedProjects) {
                return ProjectsList(projects: state.projects);
              }
              return const SizedBox();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/addProject'),
          label: const Text("Add Project"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}

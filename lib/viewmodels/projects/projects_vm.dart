import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import '../../models/project.dart';
import 'project_states.dart';

class ProjectVm extends Cubit<ProjectStates> {
  ProjectVm() : super(EmptyProjects());
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveProjectToFirebase(Project project, {List<AppUser>? users}) async {
    try {
      emit(LoadingProjects());

      final docRef = _db.collection("projects").doc();
      project.projectId = docRef.id;

      // استبدال IDs بأسماء المستخدمين
      if (users != null && users.isNotEmpty) {
        project.users = users.map((u) => u.name ?? "Unknown").toList();
      }

      await docRef.set(project.toJson());

      emit(ProjectCreated());
    } catch (e) {
      emit(ErrorProjects(e.toString()));
    }
  }


  Future<void> loadProjects() async {
    try {
      emit(LoadingProjects());
      QuerySnapshot snapshot = await _db.collection("projects").get();
      List<Project> projects =
      snapshot.docs.map((e) => Project.fromJson(e.data() as Map<String, dynamic>)).toList();
      emit(LoadedProjects(projects));
    } catch (e) {
      emit(ErrorProjects(e.toString()));
    }
  }

  Future<void> updateProject(String projectId,Project project) async {
    try {
      emit(LoadingProjects());

      await _db
          .collection("projects")
          .doc(projectId)
          .update(project.toJson());

      emit(ProjectUpdated());
    } catch (e) {
      emit(ErrorProjects(e.toString()));
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      emit(LoadingProjects());
      await _db
          .collection("projects")
          .doc(projectId)
          .delete();

      emit(ProjectDeleted());
    } catch (e) {
      emit(ErrorProjects(e.toString()));
    }
  }

}




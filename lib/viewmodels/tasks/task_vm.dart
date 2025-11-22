import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task.dart';
import 'task_states.dart';

class TaskVm extends Cubit<TaskStates> {
  TaskVm() : super(EmptyTasks());
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTask(String projectId, Task task) async {
    try {
      emit(LoadingTasks());

      final docRef = _db
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .doc();

      task.taskId = docRef.id;

      await docRef.set(task.toJson());

      emit(TaskCreated());
    } catch (e) {
      emit(ErrorTasks(e.toString()));
    }
  }


  Future<void> loadTasks(String projectId) async {
    try {
      emit(LoadingTasks());

      QuerySnapshot snapshot = await _db
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .get();

      List<Task> tasks = snapshot.docs.map((e) {
        return Task.fromJson(e.data() as Map<String, dynamic>);
      }).toList();

      emit(LoadedTasks(tasks));
    } catch (e) {
      emit(ErrorTasks(e.toString()));
    }
  }

  Future<void> updateTask(String projectId, Task task) async {
    try {
      emit(LoadingTasks());

      final data = task.toJson();
      data.removeWhere((key, value) => value == null || value == "");

      await _db
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .doc(task.taskId)
          .update(data);

      emit(TaskUpdated());
    } catch (e) {
      emit(ErrorTasks(e.toString()));
    }
  }

  Future<void> deleteTask(String projectId, String taskId) async {
    try {
      emit(LoadingTasks());
      await _db
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .doc(taskId)
          .delete();

      emit(TaskDeleted());
    } catch (e) {
      emit(ErrorTasks(e.toString()));
    }
  }
}

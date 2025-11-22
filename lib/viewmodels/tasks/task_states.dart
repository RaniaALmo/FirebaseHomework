import '../../models/task.dart';

abstract class TaskStates {}

class EmptyTasks extends TaskStates {}

class LoadingTasks extends TaskStates {}

class TaskCreated extends TaskStates {
//   final Task task;
//   TaskCreated(this.task);
}

class TaskUpdated extends TaskStates {}

class TaskDeleted extends TaskStates {}

class LoadedTasks extends TaskStates {
  final List<Task> tasks;
  LoadedTasks(this.tasks);
}

class ErrorTasks extends TaskStates {
  final String message;
  ErrorTasks(this.message);
}



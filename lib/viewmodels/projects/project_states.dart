import '../../models/project.dart';

abstract class ProjectStates {}

class EmptyProjects extends ProjectStates {}

class LoadingProjects extends ProjectStates {}

class ProjectCreated extends ProjectStates {
}

class ProjectUpdated extends ProjectStates {}

class ProjectDeleted extends ProjectStates {}

class LoadedProjects extends ProjectStates {
  final List<Project> projects;
  LoadedProjects(this.projects);
}

class ErrorProjects extends ProjectStates {
  final String message;
  ErrorProjects(this.message);
}







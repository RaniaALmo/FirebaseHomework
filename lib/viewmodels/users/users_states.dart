import 'package:firebase_homework/viewmodels/users/users_vm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/app_user.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<AppUser> users;
  UsersLoaded(this.users);
}

class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}

class UsersCubit extends Cubit<UsersState> {
  final UserVM userVM;
  UsersCubit(this.userVM) : super(UsersInitial());

  Future<void> loadUsers() async {
    emit(UsersLoading());
    try {
      final users = await userVM.loadUserFromFirebase();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}

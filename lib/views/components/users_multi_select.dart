import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../models/app_user.dart';
import '../../viewmodels/users/users_vm.dart';
import '../../viewmodels/users/users_states.dart';

class UsersMultiSelect extends StatelessWidget {
  final List<AppUser> selectedUsers;
  final Function(List<AppUser>) onChanged;

  const UsersMultiSelect({
    super.key,
    required this.selectedUsers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UsersCubit(UserVM())..loadUsers(),
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UsersError) {
            return Center(
              child: Text(
                "Error loading users: ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is UsersLoaded) {
            return MultiSelectDialogField<AppUser>(
              items: state.users
                  .map((user) => MultiSelectItem(user, user.name ?? ""))
                  .toList(),
              title: const Text("Select Users"),
              buttonText: const Text("Assign Users"),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.white,
              ),
              searchable: true,
              initialValue: selectedUsers,
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) => onChanged(values),
              chipDisplay: MultiSelectChipDisplay(
                onTap: (value) {
                  List<AppUser> updated = List.from(selectedUsers);
                  updated.remove(value);
                  onChanged(updated);
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

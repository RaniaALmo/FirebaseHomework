import 'package:flutter/material.dart';

import '../../viewmodels/auth_vm.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    AuthVm _authVm = AuthVm();
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {
          _authVm.createaccountbygoogle();
        },
        icon: Image.asset('assets/images/google.jpeg', height: 20),
        label: const Text("Continue with Google"),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

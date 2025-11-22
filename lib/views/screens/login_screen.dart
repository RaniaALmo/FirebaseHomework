import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../viewmodels/auth_vm.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../components/google_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthVm _authVm = AuthVm();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text("Welcome Back 👋", style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text("Login to continue managing your projects"),
              const SizedBox(height: 40),
              CustomTextField(label: "Email", controller: emailController),
              CustomTextField(label: "Password", controller: passwordController, obscureText: true),
              const SizedBox(height: 20),
              CustomButton(
                text: "Login",
                onPressed: () async {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Enter email & password")));
                    return;
                  }
                  dynamic result = await _authVm.login(email: email, password: password);

                  if (result is String) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login successful")),
                    );

                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  }
                },
              ),

              const SizedBox(height: 10),
              const GoogleButton(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text("Register", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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

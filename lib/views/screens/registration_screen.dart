import 'package:firebase_homework/models/app_user.dart';
import 'package:firebase_homework/viewmodels/auth_vm.dart';
import 'package:flutter/material.dart';

import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../components/google_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthVm _authVm = AuthVm();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text("Create Account 👋", style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text("Register now and start managing your projects easily"),
              const SizedBox(height: 40),
              CustomTextField(label: "Full Name", controller: nameController),
              CustomTextField(label: "Email", controller: emailController),
              CustomTextField(label: "Phone", controller: phoneController),
              CustomTextField(
                label: "Password",
                controller: passwordController,
                obscureText: true,
              ),
              CustomTextField(
                label: "Confirm Password",
                controller: confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(text: "Register", onPressed: () async{
                AppUser newuser = AppUser(name: nameController.text,email: emailController.text,phone: phoneController.text,password: passwordController.text);
                dynamic result = await _authVm.createAccountbyemailandpassword(user : newuser);
                if(result is String)
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content : Text(result)));
                else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Account created successfully")));

                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushReplacementNamed(context, '/login');
                  });
                }
              }),
              const SizedBox(height: 10),
              const GoogleButton(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

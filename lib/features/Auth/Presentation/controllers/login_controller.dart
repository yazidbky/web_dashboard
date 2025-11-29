import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/Helpers/regex.dart';
import 'package:web_dashboard/features/Auth/Logic/login_cubit.dart';
import 'package:web_dashboard/features/Auth/Data/Models/login_request_model.dart';

class LoginController {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginController({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  void handleLogin(BuildContext context) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Use regex for email validation
    if (!AppRegex.isEmailValid(email)) {
      return;
    }

    // Create login request model and call cubit
    final loginRequest = LoginRequestModel(
      username: email,
      password: password,
    );

    context.read<LoginCubit>().login(loginRequest);
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}


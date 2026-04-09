import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up.',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            CustomTextField(hintText: 'Name', controller: _nameController),
            SizedBox(height: 15),
            CustomTextField(hintText: 'Email', controller: _emailController),
            SizedBox(height: 15),
            CustomTextField(
              hintText: 'Password',
              controller: _passwordController,
              isObscureText: true,
            ),
            AuthGradientButton(
              buttonText: 'Sign up',
              onPressed: () {
                // Handle sign up logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/my_button.dart';
import '../widgets/my_textfield.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: [
            Color.fromARGB(255, 26, 3, 78),
            Color.fromARGB(255, 9, 1, 20),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                // Logo
                const Icon(
                  Icons.account_circle,
                  size: 175,
                  color: Colors.white,
                ),
                const SizedBox(height: 50),
                // Username Textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                // Password Textfield
                //MyTextField(),
                const SizedBox(height: 20),
                // Login Button
                MyButton(
                  onPressed: () {},
                  text: 'Sign up',
                ),
                const SizedBox(height: 10),
                // Forgot Password Button
              ],
            ),
          ),
        ),
      ),
    );
  }
}

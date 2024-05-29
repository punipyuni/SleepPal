import 'package:flutter/material.dart';

import '../widgets/my_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center( 
            child: Column(
              children: [
                SizedBox(height: 50),

                // Logo
                Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.white,
                ),

                SizedBox(height: 50),

                // Username Textfield
                MyTextField(
                  hintText: 'Username',
                ),

                SizedBox(height: 20),

                // Password Textfield
                MyTextField(
                  hintText: 'Password',
                ),

                SizedBox(height: 20),

                // Login Button

                SizedBox(height: 10),

                // Forgot Password Button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
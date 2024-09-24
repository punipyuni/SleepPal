import 'package:flutter/material.dart';

import '../widgets/my_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                const Icon(
                  Icons.account_circle,
                  size: 175,
                  color: Colors.white,
                ),
                const SizedBox(height: 50),
                //Log In Button
                MyButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  text: 'Log in',
                ),
                const SizedBox(height: 25),
                //Sign Up Button
                MyButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  text: 'Sign up',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

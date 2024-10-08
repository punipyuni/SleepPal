import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/app_color.utils.dart';
import 'login.auth.dart'; // Ensure this import is valid

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Logo
                Image.asset(
                  'assets/images/SleepPal.png',
                  width: 200,
                  height: 200,
                ).p4(),
                const SizedBox(height: 20),

                /// Username Textfield
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white), // Input text color
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1), // Form background color
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: Colors.white), // Hint text color
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ).p4().px24(),
                const SizedBox(height: 20),

                /// Email Textfield
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white), // Input text color
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1), // Form background color
                    errorStyle: const TextStyle(color: Colors.white),
                    errorText:
                        _isNotValidate ? 'Please enter a valid email' : null,
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white), // Hint text color
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ).p4().px24(),
                const SizedBox(height: 20),

                /// Password Textfield
                TextField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white), // Input text color
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1), // Form background color
                    errorStyle: const TextStyle(color: Colors.white),
                    errorText:
                        _isNotValidate ? 'Please enter a valid password' : null,
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white), // Hint text color
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ).p4().px24(),
                const SizedBox(height: 20),

                /// Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    // Placeholder for registration logic
                    // You can add validation or other actions here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:
                      const Text('Sign Up', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 10),

                /// Sign In Link
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child:
                      HStack([
                        "Already have an account? ".text.white.make(),
                        "Sign In".text.blue600.make(),
                      ]).centered(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import 'login.auth.dart';

import '../utils/app_color.utils.dart';
import '../config.dart';

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

  void registerUser() async {
    if (usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var regBody = {
        "username": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(signUpUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = await jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        print('Something went wrong');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
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

                  /// TODO: Transparent Background for Logo
                  /*Image.asset(
                    'assets/images/sleeppal.svg',
                    width: 200,
                    height: 200,
                  ).p4(),*/

                  const SizedBox(height: 20),

                  /// Username Textfield
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      hintText: 'Username',
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ).p4().px24(),

                  const SizedBox(height: 20),

                  /// Email Textfield
                  /// TODO: Add an email validation (Maybe)
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: const TextStyle(color: Colors.white),
                      errorText:
                          _isNotValidate ? 'Please enter a valid email' : null,
                      hintText: 'Email',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ).p4().px24(),

                  const SizedBox(height: 20),

                  /// Password Textfield
                  /// TODO: Add a password validation (Maybe)
                  /// TODO: Add a re-enter password field (Maybe)
                  /// TODO: Add a password visibility toggle functionality (Maybe)
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: const TextStyle(color: Colors.white),
                      errorText: _isNotValidate
                          ? 'Please enter a valid password'
                          : null,
                      hintText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ).p4().px24(),

                  const SizedBox(height: 20),

                  /// Sign Up
                  /// TODO: Make Button to TextField Size
                  ElevatedButton(
                    onPressed: () => {
                      registerUser(),
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColor.primaryButtonColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                    child: const Text('Sign Up',
                        style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 10),

                  /// Sign In Link
                  GestureDetector(
                    onTap: () {
                      print("Sign In");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: HStack([
                      "Already have an account? ".text.white.make(),
                      "Sign In".text.blue600.make(),
                    ]).centered(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

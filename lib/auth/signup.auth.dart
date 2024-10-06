import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:velocity_x/velocity_x.dart';

import 'package:sleeppal_update/config.dart';
import 'package:sleeppal_update/auth/login.auth.dart';

import '../utils/app_color.utils.dart';

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

      // TODO: Create config.dart and add the signup URL
      var response = await http.post(Uri.parse(signUpUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = await jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        // Navigate to the login page
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        // Show an error message
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
                /// TODO: Transparent Background for Logo
                Image.asset(
                  'assets/images/SleepPal.png',
                  width: 200,
                  height: 200,
                ).p4(),
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
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Username',
                    border: OutlineInputBorder(
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
                    errorText:
                        _isNotValidate ? 'Please enter a valid password' : null,
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
                    backgroundColor: AppColor.primaryButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
    );
  }

//       BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment(0.8, 1),
//           colors: [
//             Color.fromARGB(255, 26, 3, 78),
//             Color.fromARGB(255, 9, 1, 20),
//           ]
//         ),
}

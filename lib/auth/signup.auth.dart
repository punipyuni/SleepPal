import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import 'package:sleeppal_update/const.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import 'package:sleeppal_update/auth/login.auth.dart';

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

  void registerTest() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
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
                  'assets/images/sleeppal.png',
                  width: 200,
                  height: 200,
                ).p4(),
                const SizedBox(height: 20),

                /// Username Textfield
                /// TODO: add username to Profile Model Database
                /*TextField(
                  controller: usernameController,
                  style:
                      const TextStyle(color: Colors.white), // Input text color
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        Colors.white.withOpacity(0.1), // Form background color
                    hintText: 'Username',
                    hintStyle:
                        const TextStyle(color: Colors.white), // Hint text color
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ).p4().px24(),*/
                //const SizedBox(height: 20),

                /// Email Textfield
                TextField(
                  controller: emailController,
                  style:
                      const TextStyle(color: Colors.white), // Input text color
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        Colors.white.withOpacity(0.1), // Form background color
                    errorStyle: const TextStyle(color: Colors.white),
                    errorText:
                        _isNotValidate ? 'Please enter a valid email' : null,
                    hintText: 'Email',
                    hintStyle:
                        const TextStyle(color: Colors.white), // Hint text color
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ).p4().px24(),
                const SizedBox(height: 20),

                /// Password Textfield
                TextField(
                  controller: passwordController,
                  style:
                      const TextStyle(color: Colors.white), // Input text color
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        Colors.white.withOpacity(0.1), // Form background color
                    errorStyle: const TextStyle(color: Colors.white),
                    errorText:
                        _isNotValidate ? 'Please enter a valid password' : null,
                    hintText: 'Password',
                    hintStyle:
                        const TextStyle(color: Colors.white), // Hint text color
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ).p4().px24(),
                const SizedBox(height: 20),

                /// Sign Up Button
                ElevatedButton(
                  onPressed: () => {
                    //registerUser(),
                    registerTest(),
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
}

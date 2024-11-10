import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../utils/app_color.utils.dart';
import '../auth/login.auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isNotValidate = false;

  /*void registerTest() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }*/

  void registerUser() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Passwords do not match'),
              backgroundColor: Colors.red),
        );
        return;
      }

      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      try {
        var response = await http
            .post(
              Uri.parse("$url/auth/signup"
                  //"http://$wifiIP:3000/signup"
                  ),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(regBody),
            )
            .timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status']) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something went wrong')),
            );
          }
        } else {
          throw Exception("Server error: ${response.statusCode}");
        }
      } on TimeoutException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Connection timed out. Please try again.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "This email has already registered. Please try using other email"),
              backgroundColor: Colors.red),
        );
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// Logo
                  Image.asset(
                    'assets/images/sleeppal.png',
                    width: 200,
                    height: 200,
                  ).p4(),
                  const SizedBox(height: 10),

                  /// Email Textfield
                  TextField(
                    controller: emailController,
                    style: const TextStyle(
                        color: Colors.white), // Input text color
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white
                          .withOpacity(0.1), // Form background color
                      errorStyle: const TextStyle(color: Colors.white),
                      errorText:
                          _isNotValidate ? 'Please enter a valid email' : null,
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                          color: Colors.white70), // Hint text color
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ).p4().px24(),
                  const SizedBox(height: 20),

                  /// Password Textfield
                  TextField(
                    controller: passwordController,
                    style: const TextStyle(
                        color: Colors.white), // Input text color
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white
                          .withOpacity(0.1), // Form background color
                      errorStyle: const TextStyle(color: Colors.white),
                      errorText: _isNotValidate
                          ? 'Please enter a valid password'
                          : null,
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                          color: Colors.white70), // Hint text color
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ).p4().px24(),
                  const SizedBox(height: 20),

                  TextField(
                    controller: confirmPasswordController,
                    style: const TextStyle(
                        color: Colors.white), // Input text color
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white
                          .withOpacity(0.1), // Form background color
                      errorStyle: const TextStyle(color: Colors.white),
                      errorText: _isNotValidate
                          ? 'Please enter a valid password'
                          : null,
                      hintText: 'Confirm Password',
                      hintStyle: const TextStyle(
                          color: Colors.white70), // Hint text color
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ).p4().px24(),
                  const SizedBox(height: 20),

                  /// Sign Up Button
                  ElevatedButton(
                    onPressed: () => {
                      registerUser(),
                      //registerTest(),
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColor.primaryButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Sign Up',
                        style: TextStyle(color: Colors.white)),
                  ).p4().px24(),
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
      ),
    );
  }
}

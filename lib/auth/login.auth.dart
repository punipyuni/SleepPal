import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleeppal_update/auth/signup.auth.dart';
import 'package:sleeppal_update/views/profile.view.dart';
import 'package:velocity_x/velocity_x.dart';

import '../views/home.view.dart';

import '../utils/app_color.utils.dart';
import '../config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  final String logoUrl = 'assets/images/sleeppal.svg';

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      var response = await http.post(Uri.parse(loginUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = await jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(token: myToken)));
      } else {
        print('Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Logo
                  SvgPicture.asset(
                    logoUrl,
                    width: 200,
                    height: 200,
                  ),

                  const SizedBox(height: 20),

                  /// Email Textfield
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      errorText: _isNotValidate ? 'Enter valid email' : null,
                    ),
                  ).p4().px24(),
                  const SizedBox(height: 20),

                  /// Password Textfield
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      errorText: _isNotValidate ? 'Enter valid password' : null,
                    ),
                  ).p4().px24(),

                  const SizedBox(height: 20),

                  /// Login
                  ElevatedButton(
                    onPressed: () => {
                      loginUser(),
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColor.primaryButtonColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                    child: const Text('Login',
                        style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 10),

                  /// Sign Up Link
                  GestureDetector(
                    onTap: () {
                      print("Sign Up");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                    child: HStack([
                      "Haven't Create an Account? ".text.white.make(),
                      "Sign Up Here".text.blue600.make(),
                    ]).centered(),
                  ),

                  const SizedBox(height: 10),

                  /// Forgot Password Link
                  GestureDetector(
                    onTap: () {
                      print("Forgot Password");
                      Navigator.push(
                          context,
                          // TODO: Forgot Password Page
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: HStack([
                      "Forgot ".text.blue600.make(),
                      "Your Password?".text.white.make(),
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

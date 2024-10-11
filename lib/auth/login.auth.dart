import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sleeppal_update/pages/MainScreen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sleeppal_update/auth/signup.auth.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import 'package:sleeppal_update/const.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  late SharedPreferences prefs;

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
            context, MaterialPageRoute(builder: (context) => MainScreen()));
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Logo
                  Image.asset(
                    'assets/images/sleeppal.png',
                    width: 200,
                    height: 200,
                  ).p4(),
                  const SizedBox(height: 20),

                  /// Email TextField
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      errorText: _isNotValidate ? 'Enter valid email' : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Password TextField
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      errorText: _isNotValidate ? 'Enter valid password' : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Login Button
                  ElevatedButton(
                    onPressed: () => {
                      loginUser(),
                    },
                    child: Text('Log in'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColor.primaryButtonColor,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
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
                      "Sign Up".text.blue600.make(),
                    ]).centered(),
                  ),

                  //const SizedBox(height: 10),

                  /// Forgot Password Link
                  /*GestureDetector(
                    onTap: () {
                      print("Forgot Password");
                      Navigator.push(
                          context,
                          // TODO: Forgot Password Page
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: HStack([
                      "Forgot Your Password?".text.blue600.make(),
                    ]).centered(),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

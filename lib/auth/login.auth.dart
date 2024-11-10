import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../pages/Getting_Start.dart';
import '../pages/MainScreen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/signup.auth.dart';
import '../utils/app_color.utils.dart';
import '../const.dart';

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

  /*void loginTesting() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainScreen()));
  }*/

  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      try {
        var response = await http
            .post(
              Uri.parse("$url/auth/login"),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(reqBody),
            )
            .timeout(const Duration(seconds: 10));

        var jsonResponse = jsonDecode(response.body);

        if (response.statusCode == 200 && jsonResponse['status']) {
          var myToken = jsonResponse['token'];

          // Get the list of previously logged in emails
          Set<String> previousEmails =
              prefs.getStringList('previous_emails')?.toSet() ?? {};

          if (!previousEmails.contains(emailController.text)) {
            // This is a new login for this email
            previousEmails.add(emailController.text);
            await prefs.setStringList(
                'previous_emails', previousEmails.toList());
            await prefs.setString('token', myToken);
            await prefs.setString('current_email', emailController.text);

            // Navigate to Getting Started
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GettingStartedPage(token: myToken),
              ),
            );
          } else {
            // This email has logged in before
            await prefs.setString('token', myToken);
            await prefs.setString('current_email', emailController.text);

            // Navigate to Main Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(token: myToken),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Login failed. Please check your email and password."),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } on TimeoutException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Connection timed out. Please try again."),
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        print("Error during login: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Email or password maybe incorrect. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields."),
          duration: Duration(seconds: 3),
        ),
      );
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
                  const SizedBox(height: 10),

                  /// Email TextField
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
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

                  /// Password TextField
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

                  /// Login Button
                  ElevatedButton(
                    onPressed: () => {
                      loginUser(),
                      //loginTesting(),
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColor.primaryButtonColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Log in'),
                  ).p4().px24(),
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

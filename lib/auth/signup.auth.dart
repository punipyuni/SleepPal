import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:sleeppal_update/auth/login.auth.dart';

import '../utils/app_color.utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Call the API to register the user
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      // TODO: Create config.dart and add the signup URL
      var response = await http.post(Uri.parse('http://localhost:3000/signup'),
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
              children: [],
            ),
          ),
        ),
      ),
    );
  }

//  @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment(0.8, 1),
//           colors: [
//             Color.fromARGB(255, 26, 3, 78),
//             Color.fromARGB(255, 9, 1, 20),
//           ]
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SafeArea(
//           child: Center(
//             child: Column(
//               children: [
//                 // Logo
//                 const Icon(
//                   Icons.account_circle,
//                   size: 175,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(height: 50),
//                 // Username Textfield
//                 MyTextField(
//                   controller: usernameController,
//                   hintText: 'Username',
//                   obscureText: false,
//                 ),
//                 const SizedBox(height: 20),
//                 // Password Textfield
//                 //MyTextField(),
//                 const SizedBox(height: 20),
//                 // Login Button
//                 MyButton(
//                   onPressed: () {},
//                   text: 'Sign up',
//                 ),
//                 const SizedBox(height: 10),
//                 // Forgot Password Button
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
}

import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleeppal_update/views/home.view.dart';

import '../auth/signup.auth.dart';
import '../views/profile.view.dart';
//import '../views/splash.view.dart';

import '../utils/app_theme.utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(SleepPal(token: prefs.getString('token')));
}

class SleepPal extends StatelessWidget {
  final token;
  const SleepPal({@required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.sleepPalTheme,
      home: (token != null && JwtDecoder.isExpired(token) == false)
          ? ProfilePage(token: token)
          : const SignUpPage(),
    );
  }
}

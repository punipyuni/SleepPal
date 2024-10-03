import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sleeppal_update/auth/signup.auth.dart';
import 'package:sleeppal_update/utils/app_theme.utils.dart';
import 'package:sleeppal_update/views/splash.view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(SleepPal(token: prefs.getString('token')));
  //runApp(const SleepPal());
}

class SleepPal extends StatefulWidget {
  final token;
  const SleepPal({@required this.token, Key? key}) : super(key: key);
  //const SleepPal({super.key});

  @override
  _SleepPalState createState() => _SleepPalState();
}

class _SleepPalState extends State<SleepPal> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.sleepPalTheme,
      home: const SignUpPage(),

      //const SplashPage(),

      /*(token != null && JwtDecoder.isExpired(token) == false)
          ? Statistic(token: token)
          : const SignUpPage(),*/
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:sleeppal_update/pages/sleep.dart';
import 'package:sleeppal_update/widgets/Stats/sleep_stat_provider.dart';

import 'package:sleeppal_update/auth/signup.auth.dart';
import 'package:sleeppal_update/pages/MainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({@required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          SleepStatisticsProvider(), // Provide your SleepStatisticsProvider
      child: MaterialApp(
        home: (token != null && JwtDecoder.isExpired(token) == false)
            ? MainScreen()
            : const SignUpPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleeppal_update/auth/signup.auth.dart';
import 'package:sleeppal_update/notifi_service.dart';
import 'package:sleeppal_update/pages/MainScreen.dart';
import 'package:sleeppal_update/pages/sleep.dart';
import 'package:sleeppal_update/widgets/Stats/sleep_stat_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SleepStatisticsProvider(), // Provide your SleepStatisticsProvider
      child: MaterialApp(
        home: const MainScreen(),
      ),
    );
  }
}
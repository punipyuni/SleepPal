import 'package:flutter/material.dart';
import '../widgets/sleep_header.dart';
import '../widgets/bedtime_reminder_toggle.dart';
import '../widgets/sleep_time_toggle.dart';
import '../widgets/timer_display.dart';
import '../widgets/relaxing_sound_option.dart';
import '../widgets/bottom_nav_bar.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  int _selectedIndex = 2;

  // Handle bottom navigation tap, directly update the index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-1.0, -0.8),
            radius: 1.3,
            colors: [
              Color(0xFF6C51A6), // Light purple
              Color(0xFF1A102E), // Darker shade
              Color(0xFF131417), // Almost black
            ],
            stops: [0.17, 0.56, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SleepHeader(),
                SizedBox(height: 20),
                BedtimeReminderToggle(),
                SizedBox(height: 18),
                SleepTimeToggle(),
                SizedBox(height: 40),
                TimerDisplay(),
                SizedBox(height: 200),
                RelaxingSoundOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sleeppal_update/views/profile/profile.dart';
import 'sleepbot/sleepbot.dart';
import '../widgets/bottom_nav_bar.dart';
import 'sleep/sleep_timer.dart';
import 'sleep_statistic/statistic_dashboard.dart';
import 'behavior/behavior_form.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    Chatgpt(),
    Behavior(),
    SleepScreen(),
    SleepStatisticsDashboard(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

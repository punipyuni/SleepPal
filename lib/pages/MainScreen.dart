import 'package:flutter/material.dart';
import '../pages/chatGPT.dart';
import 'package:sleeppal_update/pages/chatGPT.dart';
import '../widgets/forum_post.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/sleep.dart';
import '../pages/Forum.dart';
import '../pages/Statistics.dart';
import '../pages/Behavior.dart';
import '../pages/sleepGPT.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // Default index for the ForumPage

  // Define the different pages to switch between
  final List<Widget> _pages = [
    Chatgpt(),  // Replace with your actual SleepGPT page widget
    Behavior(),  // Replace with your actual Behavior page widget
    SleepScreen(),   // Replace with your actual Sleep page widget
    SleepStatisticsDashboard(),// Replace with your actual Statistics page widget
    ForumPage(),     // ForumPage (your current page)
  ];

  // Handle bottom navigation taps
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
        children: _pages,  // Show the selected page
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,  // Handle page switch
      ),
    );
  }
}
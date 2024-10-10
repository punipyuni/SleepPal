import 'package:flutter/material.dart';
import 'package:sleeppal_update/pages/Profile.dart';
import '../pages/chatGPT.dart';
import 'package:sleeppal_update/pages/chatGPT.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/sleep.dart';
import '../pages/Statistics.dart';
import '../pages/Behavior.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // Default index for the ForumPage

  // Define the different pages to switch between
  final List<Widget> _pages = [
    Chatgpt(),  
    Behavior(),
    SleepScreen(),   
    SleepStatisticsDashboard(),
    ProfilePage(),     
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
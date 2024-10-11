import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleeppal_update/auth/signup.auth.dart';
import 'package:sleeppal_update/pages/Profile.dart';
import '../pages/chatGPT.dart';
import 'package:sleeppal_update/pages/chatGPT.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/sleep.dart';
import '../pages/Statistics.dart';
import '../pages/Behavior.dart';

class MainScreen extends StatefulWidget {
  final token;
  const MainScreen({super.key, @required this.token});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late SharedPreferences prefs;
  late String? nowToken = prefs.getString('token');

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  int _selectedIndex = 2;

  // Define the different pages to switch between
  final List<Widget> _pages = [
    Chatgpt(),
    Behavior(),
    SleepScreen(),
    SleepStatisticsDashboard(),
    ProfilePage(),
  ];

  void changePage() async {
    if (prefs.getString('token') == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SignUpPage()));
    }
  }

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
        children: _pages, // Show the selected page
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // Handle page switch
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/signup.auth.dart';
import '../pages/Notipage.dart';
import '../pages/Profile.dart';
import '../pages/chatGPT.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/sleep.dart';
import '../pages/Statistics.dart';
import '../pages/Behavior.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final token;
  final TimeOfDay? bedtimeReminder;

  const MainScreen({
    super.key,
    required this.token,
    this.initialIndex = 2,
    this.bedtimeReminder,
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SharedPreferences? prefs;
  String? token;
  int _selectedIndex = 2;
  List<Widget>? _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    initializeData();
  }

  Future<void> initializeData() async {
    // Initialize SharedPreferences
    prefs = await SharedPreferences.getInstance();
    token = widget.token.isNotEmpty ? widget.token : prefs?.getString('token');

    // Initialize pages after getting the token
    setState(() {
      _pages = [
        Chatgpt(),
        BehaviorWidget(token: token),
        widget.bedtimeReminder != null
            ? SleepScreen(bedtimeReminder: widget.bedtimeReminder)
            : SleepScreen(),
        SleepStatisticsDashboard(
          token: token,
        ),
        ProfilePage(token: token),
      ];
    });

    if (token == null) {
      // Navigate to SignUp if no token is found
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      });
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
    // Show loading indicator while pages are being initialized
    if (_pages == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages!,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

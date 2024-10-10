import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleeppal_update/auth/login.auth.dart';

import 'behavior_analysis.view.dart';
import 'profile.view.dart';
import 'sleep_tracking.view.dart';
import 'sleepbot.view.dart';
import 'statistic.view.dart';

import '../utils/widgets/bottom_nav_bar.widgets.dart';

class HomeScreen extends StatefulWidget {
  final token;
  const HomeScreen({@required this.token, super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userId;
  late SharedPreferences prefs;

  @override
  Future<void> initState() async {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  int _selectedIndex = 2;

  final List<Widget> _pages = [
    // Index 0
    const SleepBot(),
    // Index 1
    const BehaviorAnalysisPage(),
    // Index 2
    const SleepTrackingPage(),
    // Index 3
    const StatisticPage(),
    // Index 4
    const ProfilePage(token: null),
    // Index 5
    // ForumPage(),
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

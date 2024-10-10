import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'behavior_analysis.view.dart';
import 'profile.view.dart';
import 'sleep_tracking.view.dart';
import 'sleepgpt.view.dart';
import 'statistic.view.dart';

import '../utils/widgets/bottom_nav_bar.widgets.dart';

class HomeScreen extends StatefulWidget {
  final token;
  const HomeScreen({@required this.token, super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    // Index 0
    const SleepGPTPage(),
    // Index 1
    const BehaviorAnalysisPage(),
    // Index 2
    const SleepTrackingPage(),
    // Index 3
    const StatisticPage(),
    // Index 4
    const ProfilePage(),
    // Index 5
    // ForumPage(),
  ];

  late String userId;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
  }

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

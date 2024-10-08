import 'package:flutter/material.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemTapped,
      backgroundColor: AppColor.navBarColor,
      selectedItemColor: AppColor.selectedItemColor,
      unselectedItemColor: AppColor.unselectedItemColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'SleepGPT',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.psychology),
          label: 'Behavior',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.nightlight_round),
          label: 'Sleep',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Statistic',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

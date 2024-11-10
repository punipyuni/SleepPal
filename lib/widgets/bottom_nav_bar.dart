import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemTapped,
      backgroundColor: const Color(0xFF121317), // Set the background color to #121317
      selectedItemColor: Colors.blueAccent, // Change selected item color if needed
      unselectedItemColor: Colors.grey, // Change unselected item color
      showSelectedLabels: true, // Always show selected labels
      showUnselectedLabels: true, // Ensure unselected labels are also visible
      type: BottomNavigationBarType.fixed, // Use fixed type to show labels for all items
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'SleepBot',
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
          label: 'Statistics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
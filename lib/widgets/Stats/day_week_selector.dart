import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sleep_stat_provider.dart'; // Make sure to import your provider

class DayWeekSelector extends StatelessWidget {
  final bool isDaySelected;
  final Function(bool) onToggle;

  const DayWeekSelector({
    Key? key,
    required this.isDaySelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the SleepStatisticsProvider
    final provider = Provider.of<SleepStatisticsProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton('Day', isDaySelected, () {
            onToggle(true);
            provider.toggleView(true); // Reset when switching to Day view
          }),
          _buildToggleButton('Week', !isDaySelected, () {
            onToggle(false);
            provider.toggleView(false); // Switch to Week view
          }),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

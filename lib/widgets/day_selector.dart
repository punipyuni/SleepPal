import 'package:flutter/material.dart';
import '../widgets/day_button.dart';
class DaySelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelected;

  const DaySelector({
    Key? key,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Container(
      height: 80, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: DayButton(
              day: days[index],
              date: (index + 17).toString(), // Simplified date logic
              isSelected: index == selectedIndex,
              onTap: () => onSelected(index),
            ),
          );
        },
      ),
    );
  }
}

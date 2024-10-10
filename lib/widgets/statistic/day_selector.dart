import 'package:flutter/material.dart';
import 'day_button.dart';
import 'sleep_stat_provider.dart';
import 'package:provider/provider.dart';

class DaySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

        return Container(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = provider.getDateForIndex(index);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: DayButton(
                  day: days[index],
                  date: date.day.toString(),
                  isSelected: index == provider.selectedDayIndex,
                  onTap: () => provider.selectDayInDayView(index),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
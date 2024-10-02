import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/day_selector.dart';
import '../widgets/sleep_phase_chart.dart';
import '../widgets/sleep_pie_chart.dart';
import '../widgets/statistic_item.dart';
import '../widgets/day_week_selector.dart';
import '../widgets/stats_header.dart';
import '../widgets/sleep_stat_provider.dart';
import 'package:provider/provider.dart';
import 'week_stat_view.dart';


class DayStatisticsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DaySelector(
              selectedIndex: provider.selectedDayIndex,
              onSelected: provider.selectDayInDayView,
            ),
            SizedBox(height: 24),
            Text(
              '9 hr 30 min', // This should be fetched from the provider based on the selected day
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticItem(title: 'Sleep Duration (AVG)', value: '6 hr 30 min'),
                StatisticItem(title: 'Time Asleep', value: '0 hr 37 min'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticItem(title: 'Sleeping Time', value: '23:00 p.m.'),
                StatisticItem(title: 'Wake Up Time', value: '08:30 a.m.'),
              ],
            ),
            SizedBox(height: 24),
            SleepPhaseChart(),
            SizedBox(height: 24),
            SleepTypesPieChart()
          ],
        );
      },
    );
  }
}
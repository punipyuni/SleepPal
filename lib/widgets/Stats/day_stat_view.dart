import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'day_selector.dart';
import 'sleep_phase_chart.dart';
import 'sleep_pie_chart.dart';
import 'statistic_item.dart';
import 'sleep_stat_provider.dart';
import 'package:provider/provider.dart';

class DayStatisticsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DaySelector(),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticItem(title: 'Sleep Duration', value: provider.selectedDaySleepDuration),
                StatisticItem(title: 'Time Asleep', value: provider.selectedDayTimeAsleep),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticItem(title: 'Sleeping Time', value: provider.selectedDaySleepingTime),
                StatisticItem(title: 'Wake Up Time', value: provider.selectedDayWakeUpTime),
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
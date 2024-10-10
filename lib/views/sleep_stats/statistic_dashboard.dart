import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import '../../widgets/statistic/day_selector.dart';
import '../../widgets/statistic/sleep_phase_chart.dart';
import '../../widgets/statistic/sleep_pie_chart.dart';
import '../../widgets/statistic/statistic_item.dart';
import '../../widgets/statistic/day_week_selector.dart';
import '../../widgets/statistic/stats_header.dart';
import '../../widgets/statistic/day_stat_view.dart';
import 'package:provider/provider.dart';
import '../../widgets/statistic/sleep_stat_provider.dart';
import '../../widgets/statistic/week_stat_view.dart';

class SleepStatisticsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Consumer<SleepStatisticsProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Statistics',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  DayWeekSelector(
                    isDaySelected: provider.isDayView,
                    onToggle: provider.toggleView,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: provider.isDayView ? DayStatisticsView() : WeekStatisticsView(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/Stats/day_selector.dart';
import '../widgets/Stats/sleep_phase_chart.dart';
import '../widgets/Stats/sleep_pie_chart.dart';
import '../widgets/Stats/statistic_item.dart';
import '../widgets/Stats/day_week_selector.dart';
import '../widgets/Stats/stats_header.dart';
import '../widgets/Stats/day_stat_view.dart';
import 'package:provider/provider.dart';
import '../widgets/Stats/sleep_stat_provider.dart';
import '../widgets/Stats/week_stat_view.dart';

class SleepStatisticsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-1.0, -0.8),
            radius: 1.3,
            colors: [
              Color(0xFF6C51A6),
              Color(0xFF1A102E),
              Color(0xFF131417),
            ],
            stops: [0.17, 0.56, 1.0],
          ),
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
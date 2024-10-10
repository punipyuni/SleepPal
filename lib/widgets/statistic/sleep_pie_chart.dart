import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:sleeppal_update/widgets/statistic/sleep_stat_provider.dart';


class SleepTypesPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        // Get selected day's data
        final selectedDayData = provider.selectedDayData;

        // Extract durations for REM, Light, and Deep sleep
        final remDuration = selectedDayData['rem'] as Duration;
        final lightDuration = selectedDayData['light'] as Duration;
        final deepDuration = selectedDayData['deep'] as Duration;

        // Calculate total duration
        final totalDuration = remDuration + lightDuration + deepDuration;

        // Calculate percentage values
        final remPercentage = (remDuration.inMinutes / totalDuration.inMinutes) * 100;
        final lightPercentage = (lightDuration.inMinutes / totalDuration.inMinutes) * 100;
        final deepPercentage = (deepDuration.inMinutes / totalDuration.inMinutes) * 100;

        return Container(
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        color: Color(0xFFFF9999), // Orangish for REM
                        value: remPercentage,
                        title: '${remPercentage.toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Color(0xFFAA77FF), // Purple for Deep
                        value: deepPercentage,
                        title: '${deepPercentage.toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Color(0xFFFF77FF), // Pink for Light
                        value: lightPercentage,
                        title: '${lightPercentage.toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Light Sleep', _formatDuration(lightDuration), Color(0xFFFF77FF)),
                    SizedBox(height: 8),
                    _buildLabel('Deep Sleep', _formatDuration(deepDuration), Color(0xFFAA77FF)),
                    SizedBox(height: 8),
                    _buildLabel('REM Sleep', _formatDuration(remDuration), Color(0xFFFF9999)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }

  Widget _buildLabel(String title, String duration, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              duration,
              style:
                  TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
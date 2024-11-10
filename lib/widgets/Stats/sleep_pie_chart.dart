import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:health/health.dart'; // Import the health package
import '../../widgets/Stats/sleep_stat_provider.dart';

class SleepTypesPieChart extends StatelessWidget {
  const SleepTypesPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        // Retrieve selected day's data or use an empty map if it's null
        final selectedDayData = provider.selectedDayData ?? {};

           void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Sleep Stage Information', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🌙 Light Sleep: Typically around 50–55%. Provides a stable sleep foundation.', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('😊 Good REM Sleep: 20–25%, vital for memory and mood.', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('😐 Neutral REM Sleep: 15–20%, acceptable but could be improved.', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('😞 Low/High REM Sleep: Below 15%', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 16),
              Text('😊 Good Deep Sleep: 20%+, essential for physical recovery.', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('😐 Neutral Deep Sleep: 15–20%, adequate but could be optimized.', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('😞 Low Deep Sleep: Below 15%, may affect restfulness.', style: TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

        // Safely extract sleep durations, using default values if necessary
        final Map<HealthDataType, double> sleepData = selectedDayData['sleepData'] as Map<HealthDataType, double>? ?? {};
        final Duration remDuration = Duration(minutes: (sleepData[HealthDataType.SLEEP_REM] ?? 0.0).toInt());
        final Duration lightDuration = Duration(minutes: (sleepData[HealthDataType.SLEEP_LIGHT] ?? 0.0).toInt());
        final Duration deepDuration = Duration(minutes: (sleepData[HealthDataType.SLEEP_DEEP] ?? 0.0).toInt());

        // Calculate the total sleep duration
        final Duration totalDuration = remDuration + lightDuration + deepDuration;
        if (totalDuration.inMinutes == 0) {
          return const Center(
            child: Text('No sleep data available', style: TextStyle(color: Colors.white)),
          );
        }

        // Calculate percentages safely
        final double remPercentage = (remDuration.inMinutes / totalDuration.inMinutes) * 100;
        final double lightPercentage = (lightDuration.inMinutes / totalDuration.inMinutes) * 100;
        final double deepPercentage = (deepDuration.inMinutes / totalDuration.inMinutes) * 100;

        return SizedBox(
          height: 250,
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
                        color: Colors.orange,
                        value: remPercentage,
                        title: '${remPercentage.toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.purple,
                        value: deepPercentage,
                        title: '${deepPercentage.toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.pink.shade400,
                        value: lightPercentage,
                        title: '${lightPercentage.toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    
                    _buildLabel('Light Sleep', _formatDuration(lightDuration), Colors.pink.shade400, '🌙'),
                    const SizedBox(height: 8),
                    _buildLabel('Deep Sleep', _formatDuration(deepDuration), Colors.purple, _getEmoji(deepPercentage, 'deep')),
                    const SizedBox(height: 8),
                    _buildLabel('REM Sleep', _formatDuration(remDuration), Colors.orange, _getEmoji(remPercentage, 'rem')),
                    SizedBox(height: 8),
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.white70),
                      onPressed: () => _showDisclaimerDialog(context),
                    ),
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

  String _getEmoji(double percentage, String type) {
    if (type == 'rem') {
      if (percentage >= 20 && percentage <= 25) return '😊';
      if (percentage < 15) return '😞';
      return '😐';
    } else if (type == 'deep') {
      if (percentage >= 20) return '😊';
      if (percentage >= 15 && percentage < 20) return '😐';
      return '😞';
    }
    return '🌙';
  }

  Widget _buildLabel(String title, String duration, Color color, String emoji) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$emoji $title', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(duration, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );

  }
}

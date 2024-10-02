import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/sleep_stat_provider.dart';
import 'statistic_item.dart';
import 'sleep_phase_chart.dart';
import 'sleep_pie_chart.dart';

class WeekStatisticsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              provider.selectedWeekDayDuration ?? '--:--',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 16),
            WeeklyBarChart(
  data: provider.weeklyData,
  onBarSelected: provider.selectDayInWeekView,
),
            SizedBox(height: 24),
            StatisticItem(title: 'Sleep Duration (AVG)', value: '6 hr 30 min'),
            SizedBox(height: 16),
            StatisticItem(
                title: 'Best Sleep Pattern', value: '22:30 p.m - 09:30 p.m'),
            SizedBox(height: 24),
            SleepScoreWidget(score: 81),
            SizedBox(height: 24),
            SleepPhasesWidget(
              deepSleep: Duration(hours: 5, minutes: 1),
              lightSleep: Duration(hours: 3, minutes: 28),
              remSleep: Duration(hours: 1, minutes: 2),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticItem(title: 'Light Sleep (AVG)', value: '32%'),
                StatisticItem(title: 'Deep Sleep (AVG)', value: '46%'),
              ],
            ),
            SizedBox(height: 16),
            StatisticItem(title: 'REM Sleep (AVG)', value: '22%'),
          ],
        );
      },
    );
  }
}

class WeeklyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data; // Adjusted to specify the type
  final Function(int) onBarSelected;

  WeeklyBarChart({required this.data, required this.onBarSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(data.length, (index) {
          final item = data[index];
          final double remFactor = item['remFactor'] ?? 0.0;
          final double lightFactor = item['lightFactor'] ?? 0.0;
          final double deepFactor = item['deepFactor'] ?? 0.0;
          final String day = item['day'] ?? 'N/A';

          return GestureDetector(
            onTap: () => onBarSelected(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    width: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildSegment(remFactor, Color(0xFFFF9AA2), isTopSegment: true), // Rounded top for REM
                        _buildSegment(lightFactor, Color(0xFFFFB7B2)), // Square corners for Light
                        _buildSegment(deepFactor, Color(0xFF800080)), // Square corners for Deep
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  day,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSegment(double factor, Color color, {bool isTopSegment = false}) {
    return Container(
      height: factor * 150,
      width: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: isTopSegment 
            ? BorderRadius.vertical(top: Radius.circular(8)) // Rounded top for REM
            : BorderRadius.zero, // Square corners for Light and Deep
      ),
    );
  }
}

class SleepScoreWidget extends StatelessWidget {
  final int score;

  SleepScoreWidget({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align items to start
        children: [
          // Score section on the left
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sleep Score', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('$score Points',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          SizedBox(width: 20), // Add space between score and progress section
          // Progress section on the right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align emojis and progress bar to start
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEmojiIndicator('😞', 'Low'),
                    _buildEmojiIndicator('😐', 'Med'),
                    _buildEmojiIndicator('😊', 'High'),
                  ],
                ),
                SizedBox(height: 4), // Space between emojis and progress bar
                LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiIndicator(String emoji, String label) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 20)),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
class SleepPhasesWidget extends StatelessWidget {
  final Duration deepSleep;
  final Duration lightSleep;
  final Duration remSleep;

  SleepPhasesWidget(
      {required this.deepSleep,
      required this.lightSleep,
      required this.remSleep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSleepPhaseRow('Deep Sleep', deepSleep, Color(0xFF800080)),
          SizedBox(height: 8),
          _buildSleepPhaseRow('Light Sleep', lightSleep, Color(0xFFFFB7B2)),
          SizedBox(height: 8),
          _buildSleepPhaseRow('REM Sleep', remSleep, Color(0xFFFF9AA2)),
        ],
      ),
    );
  }

  Widget _buildSleepPhaseRow(String label, Duration duration, Color color) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.white70)),
        Spacer(),
        Text('${duration.inHours} hr ${duration.inMinutes.remainder(60)} min',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

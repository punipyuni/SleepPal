import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleeppal_update/widgets/statistic/sleep_stat_provider.dart';

class DailySleepScoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sleepStats = Provider.of<SleepStatisticsProvider>(context);
    final selectedDayData = sleepStats.selectedDayData;
    
    final deepSleepDuration = selectedDayData['deep'] as Duration;
    final totalSleepDuration = selectedDayData['duration'] as Duration;
    
    final score = _calculateDailySleepScore(deepSleepDuration, totalSleepDuration);

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
              Text('Sleep Score (Daily)', style: TextStyle(color: Colors.white70)),
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

  int _calculateDailySleepScore(Duration deepSleep, Duration totalSleep) {
    // Calculate the percentage of deep sleep
    double deepSleepPercentage = deepSleep.inMinutes / totalSleep.inMinutes * 100;

    // Base score on deep sleep percentage
    int score = (deepSleepPercentage * 2).round(); // 2 points per percentage

    // Adjust score based on total sleep duration
    if (totalSleep.inHours >= 7 && totalSleep.inHours <= 9) {
      score += 20; // Bonus for ideal sleep duration
    } else if (totalSleep.inHours < 6 || totalSleep.inHours > 10) {
      score -= 10; // Penalty for too little or too much sleep
    }

    // Ensure score is within 0-100 range
    return score.clamp(0, 100);
  }
}
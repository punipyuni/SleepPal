import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleeppal_update/widgets/Stats/sleep_stat_provider.dart';

class DailySleepScoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sleepStats = Provider.of<SleepStatisticsProvider>(context);
    final selectedDayData = sleepStats.selectedDayData;
    
    final score = _calculateDailySleepScore(selectedDayData);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sleep Score (Daily)', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('${score.round()} Points',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEmojiIndicator('😞', 'Low'),
                    _buildEmojiIndicator('😐', 'Med'),
                    _buildEmojiIndicator('😊', 'High'),
                  ],
                ),
                SizedBox(height: 4),
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

 double _calculateDailySleepScore(Map<String, dynamic> dayData) {
  // Extract durations from data
  final Duration deepSleep = dayData['deep'] as Duration;
  final Duration remSleep = dayData['rem'] as Duration;
  final Duration lightSleep = dayData['light'] as Duration;
  final Duration awake = dayData['awake'] as Duration;

  // Convert all durations to minutes
  final int deepSleepMinutes = deepSleep.inHours * 60 + deepSleep.inMinutes.remainder(60);
  final int remSleepMinutes = remSleep.inHours * 60 + remSleep.inMinutes.remainder(60);
  final int lightSleepMinutes = lightSleep.inHours * 60 + lightSleep.inMinutes.remainder(60);
  final int totalSleepMinutes = deepSleepMinutes + remSleepMinutes + lightSleepMinutes;
  final int awakeMinutes = awake.inHours * 60 + awake.inMinutes.remainder(60);

  // Calculate percentages
  final double deepPercentage = deepSleepMinutes / totalSleepMinutes;
  final double remPercentage = remSleepMinutes / totalSleepMinutes;
  final double lightPercentage = lightSleepMinutes / totalSleepMinutes;
  final double awakePercentage = awakeMinutes / (totalSleepMinutes + awakeMinutes);

  // Define ideal percentages
  const double deepIdeal = 0.25;  // 25%
  const double remIdeal = 0.25;   // 25%
  const double lightIdeal = 0.50; // 50%

  // Define weights
  const double wDeep = 0.4;
  const double wRem = 0.4;
  const double wLight = 0.2;

  // Calculate score components
  final double deepScore = wDeep * (deepPercentage / deepIdeal);
  final double remScore = wRem * (remPercentage / remIdeal);
  final double lightScore = wLight * (lightPercentage / lightIdeal);

  // Calculate final score
  double score = 100 * (deepScore + remScore + lightScore - awakePercentage);
  
  // Round to nearest integer and clamp between 0 and 100
  return score.round().toDouble().clamp(0, 100);
}

}
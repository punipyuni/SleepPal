import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/Stats/sleep_stat_provider.dart';

class DailySleepScoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sleepStats = Provider.of<SleepStatisticsProvider>(context);
    final selectedDayData = sleepStats.selectedDayData ?? {}; // Provide a default empty map

    // Use the public method to calculate the sleep score
    final score = sleepStats.calculateDailySleepScore(selectedDayData);

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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                  value: (score / 100).clamp(0.0, 1.0), // Ensure value is between 0 and 1
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

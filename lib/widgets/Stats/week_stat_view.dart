import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/Stats/weekly_bar_chart.dart';
import 'sleep_stat_provider.dart';
import 'statistic_item.dart';

class WeekStatisticsView extends StatelessWidget {
  const WeekStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        print("Min Ideal Sleep: ${provider.recommendedMinSleepHours}");
        print("Max Ideal Sleep: ${provider.recommendedMaxSleepHours}");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              provider.selectedWeekDayDuration ?? '--:--',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
           WeeklyBarChart(
              data: provider.weeklyChartData,
              minIdealSleep: provider.recommendedMinSleepHours, // Pass min sleep
              maxIdealSleep: provider.recommendedMaxSleepHours, // Pass max sleep
              onBarSelected: (int? index) {
                if (index != null) {
                  provider.selectDayInWeekView(index);
                  provider.updateSelectedDayDuration(index); // Update the duration
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjusts spacing between items
  children: [
    StatisticItem(
      title: 'Sleep Duration (AVG)',
      value: provider.averageSleepDurationString,
    ),
    const SizedBox(width: 16), // Adds space between the two items
    StatisticItem(
      title: 'Best Sleep Pattern',
      value: provider.bestSleepPattern,
    ),
  ],
),
            const SizedBox(height: 24),
            WeeklySleepScoreWidget(),
            const SizedBox(height: 24),
            SleepPhasesWidget(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticItem(
                  title: 'Light Sleep (AVG)',
                  value:
                      '${provider.averageLightSleepPercentage.toStringAsFixed(1)}%',
                ),
                StatisticItem(
                  title: 'Deep Sleep (AVG)',
                  value:
                      '${provider.averageDeepSleepPercentage.toStringAsFixed(1)}%',
                ),
              ],
            ),
            const SizedBox(height: 16),
            StatisticItem(
              title: 'REM Sleep (AVG)',
              value:
                  '${provider.averageRemSleepPercentage.toStringAsFixed(1)}%',
            ),
          ],
        );
      },
    );
  }
}


class WeeklySleepScoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sleepStats = Provider.of<SleepStatisticsProvider>(context);
    final weeklyData = sleepStats.weeklyData;

    double averageScore = _calculateWeeklyAverageSleepScore(weeklyData);

    return Container(
      padding: const EdgeInsets.all(16),
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
              const Text('Sleep Score (Weekly AVG)', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('${averageScore.round()} Points',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(width: 20),
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
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: averageScore.isNaN ? 0 : averageScore / 100,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
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
        Text(emoji, style: const TextStyle(fontSize: 20)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  double _calculateWeeklyAverageSleepScore(List<Map<String, dynamic>> weeklyData) {
    if (weeklyData.isEmpty) {
      return 0; // Return 0 if there's no data to prevent division by zero
    }

    double totalScore = 0;

    for (var dayData in weeklyData) {
      totalScore += _calculateDailySleepScore(dayData);
    }

    return totalScore / weeklyData.length;
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

    if (totalSleepMinutes == 0) return 0; // Return 0 if no sleep data is available

    // Calculate percentages
    final double deepPercentage = deepSleepMinutes / totalSleepMinutes;
    final double remPercentage = remSleepMinutes / totalSleepMinutes;
    final double lightPercentage = lightSleepMinutes / totalSleepMinutes;
    final double awakePercentage = awakeMinutes / (totalSleepMinutes + awakeMinutes);

    // Define ideal percentages
    const double deepIdeal = 0.25; // 25%
    const double remIdeal = 0.25; // 25%
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

    // Clamp score between 0 and 100
    return score.clamp(0, 100);
  }
}


class SleepPhasesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSleepPhaseRow('Deep Sleep (AVG)',
                  provider.averageDeepSleepDuration, Colors.purple),
              const SizedBox(height: 8),
              _buildSleepPhaseRow('Light Sleep (AVG)',
                  provider.averageLightSleepDuration, Colors.pink.shade400),
              const SizedBox(height: 8),
              _buildSleepPhaseRow('REM Sleep (AVG)',
                  provider.averageRemSleepDuration, Colors.orange),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSleepPhaseRow(String label, Duration duration, Color color) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
        const Spacer(),
        Text('${duration.inHours} hr ${duration.inMinutes.remainder(60)} min',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

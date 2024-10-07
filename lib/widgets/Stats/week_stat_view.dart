import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sleep_stat_provider.dart';
import 'statistic_item.dart';


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
              data: provider.weeklyChartData,
              onBarSelected: provider.selectDayInWeekView,
            ),
            SizedBox(height: 24),
            StatisticItem(title: 'Sleep Duration (AVG)', value: provider.averageSleepDurationString),
            SizedBox(height: 16),
            StatisticItem(title: 'Best Sleep Pattern', value: provider.bestSleepPattern),
            SizedBox(height: 24),
            SleepScoreWidget(score: provider.calculateSleepScore()),
            SizedBox(height: 24),
            SleepPhasesWidget(),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticItem(
                  title: 'Light Sleep (AVG)',
                  value: '${provider.averageLightSleepPercentage.toStringAsFixed(1)}%'
                ),
                StatisticItem(
                  title: 'Deep Sleep (AVG)',
                  value: '${provider.averageDeepSleepPercentage.toStringAsFixed(1)}%'
                ),
              ],
            ),
            SizedBox(height: 16),
            StatisticItem(
              title: 'REM Sleep (AVG)',
              value: '${provider.averageRemSleepPercentage.toStringAsFixed(1)}%'
            ),
          ],
        );
      },
    );
  }
}


class WeeklyBarChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Function(int?) onBarSelected;

  WeeklyBarChart({required this.data, required this.onBarSelected});

  @override
  _WeeklyBarChartState createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Start the animation
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SleepStatisticsProvider>(context);

    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.data.length, (index) {
          final item = widget.data[index];
          final double remFactor = item['remFactor'] ?? 0.0;
          final double lightFactor = item['lightFactor'] ?? 0.0;
          final double deepFactor = item['deepFactor'] ?? 0.0;
          final double heightFactor = item['heightFactor'] ?? 0.0;
          final String day = item['day'] ?? 'N/A';
          final bool isSelected = provider.selectedWeekDayIndex == index;

          return GestureDetector(
            onTap: () => widget.onBarSelected(isSelected ? null : index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 20,
                        height: (150 * heightFactor) * _animation.value,
                        decoration: BoxDecoration(
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            _buildSegment(remFactor, Color(0xFFFF9AA2), isTopSegment: true),
                            _buildSegment(lightFactor, Color(0xFFFFB7B2)),
                            _buildSegment(deepFactor, Color(0xFF800080), isBottomSegment: true),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  day,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSegment(double factor, Color color, {bool isTopSegment = false, bool isBottomSegment = false}) {
    return Expanded(
      flex: (factor * 100).round(),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.vertical(
            top: isTopSegment ? Radius.circular(8) : Radius.zero,
            bottom: isBottomSegment ? Radius.circular(8) : Radius.zero,
          ),
        ),
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
  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSleepPhaseRow('Deep Sleep (AVG)', provider.averageDeepSleepDuration, Color(0xFF800080)),
              SizedBox(height: 8),
              _buildSleepPhaseRow('Light Sleep (AVG)', provider.averageLightSleepDuration, Color(0xFFFFB7B2)),
              SizedBox(height: 8),
              _buildSleepPhaseRow('REM Sleep (AVG)', provider.averageRemSleepDuration, Color(0xFFFF9AA2)),
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
          decoration: BoxDecoration(shape: BoxShape.circle, color: color)
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.white70)),
        Spacer(),
        Text(
          '${duration.inHours} hr ${duration.inMinutes.remainder(60)} min',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ],
    );
  }
}
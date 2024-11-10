import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sleep_stat_provider.dart';

class SleepPhaseChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        final selectedDayData = provider.selectedDayData ?? {};
        final sleepStart = selectedDayData['sleepingTime'] as DateTime?;
        final wakeUpTime = selectedDayData['wakeUpTime'] as DateTime?;
        final sleepStages =
            selectedDayData['sleepStages'] as List<Map<String, dynamic>>? ?? [];

        if (sleepStart == null || wakeUpTime == null || sleepStages.isEmpty) {
          return Center(
            child: Text(
              'No sleep data available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        double startX = sleepStart.hour + (sleepStart.minute / 60);
        double endX = wakeUpTime.hour + (wakeUpTime.minute / 60);

        if (endX <= startX) {
          endX += 24;
        }

        final stageValues = {
          'deep': 0.0,
          'light': 1.0,
          'rem': 2.0,
          'wake': 3.0,
        };

        final stageColors = {
          'deep': Colors.purple,
          'light': Colors.pink,
          'rem': Colors.orange,
          'wake': Colors.yellow,
        };

        List<LineChartBarData> lineBarsData = [];

        for (int i = 0; i < sleepStages.length; i++) {
          final stage = sleepStages[i];
          final stageName = stage['stage'] as String?;
          final stageValue = stageValues[stageName];
          final stageColor = stageColors[stageName];

          if (stageValue != null && stageColor != null) {
            final startHour =
                _convertToFractionalHour(sleepStart, stage['start'] as String);
            final endHour =
                _convertToFractionalHour(sleepStart, stage['end'] as String);

            double normalizedStart =
                startHour >= startX ? startHour : startHour + 24;
            double normalizedEnd = endHour >= startX ? endHour : endHour + 24;

            lineBarsData.add(
              LineChartBarData(
                spots: [
                  FlSpot(normalizedStart, stageValue),
                  FlSpot(normalizedEnd, stageValue),
                ],
                isCurved: true,
                color: stageColor,
                barWidth: 4,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      stageColor.withOpacity(0.5),
                      stageColor.withOpacity(0.1),
                    ],
                    stops: [0.1, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  cutOffY: stageValue - 0.5,
                  applyCutOffY: true,
                ),
                dotData: FlDotData(show: false),
              ),
            );

            if (i < sleepStages.length - 1) {
              final nextStage = sleepStages[i + 1];
              final nextStageValue = stageValues[nextStage['stage'] as String?];
              final nextStageColor = stageColors[nextStage['stage'] as String?];

              if (nextStageValue != null &&
                  nextStageColor != null &&
                  nextStageValue != stageValue) {
                bool isAscending = nextStageValue > stageValue;

                lineBarsData.add(
                  LineChartBarData(
                    spots: [
                      FlSpot(normalizedEnd, stageValue),
                      FlSpot(normalizedEnd, nextStageValue),
                    ],
                    isCurved: true,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    gradient: LinearGradient(
                      colors: [
                        stageColor.withOpacity(0.7),
                        nextStageColor.withOpacity(0.7),
                      ],
                      begin: isAscending
                          ? Alignment.bottomCenter
                          : Alignment.topCenter,
                      end: isAscending
                          ? Alignment.topCenter
                          : Alignment.bottomCenter,
                    ),
                  ),
                );
              }
            }
          }
        }

        return GestureDetector(
          onTapUp: (details) {
            final tappedX =
                _calculateTappedX(details.localPosition, startX, endX, context);
            _showStageDialog(
                context, tappedX, sleepStages, stageValues, sleepStart);
          },
          child: Container(
            height: 300,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sleep Stages',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value == startX) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${sleepStart.day}/${sleepStart.month}',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Bed time ${sleepStart.hour}:${sleepStart.minute.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10),
                                      ),
                                    ],
                                  );
                                } else if (value == endX) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            50.0), 
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${wakeUpTime.day}/${wakeUpTime.month}',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Woke up ${wakeUpTime.hour}:${wakeUpTime.minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Text('');
                              },
                              interval: (endX - startX) / 2,
                              reservedSize: 45,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return Text('Deep',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10));
                                  case 1:
                                    return Text('Light',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10));
                                  case 2:
                                    return Text('REM',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10));
                                  case 3:
                                    return Text('Awake',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10));
                                  default:
                                    return Text('');
                                }
                              },
                              interval: 1,
                              reservedSize: 40,
                            ),
                          ),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: startX,
                        maxX: endX,
                        minY: -1,
                        maxY: 4,
                        lineBarsData: lineBarsData,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _convertToFractionalHour(DateTime baseDate, String timeString) {
    final timeParts = timeString.split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    double fractionalHour = hours + (minutes / 60);

    if (hours < baseDate.hour) fractionalHour += 24;
    return fractionalHour;
  }

  double _calculateTappedX(
      Offset localPosition, double startX, double endX, BuildContext context) {
    final chartWidth = MediaQuery.of(context).size.width;
    final relativeX = localPosition.dx / chartWidth;
    return startX + (endX - startX) * relativeX;
  }

  void _showStageDialog(
    BuildContext context,
    double tappedX,
    List<Map<String, dynamic>> sleepStages,
    Map<String, double> stageValues,
    DateTime sleepStart,
  ) {
    for (var stage in sleepStages) {
      final startHour =
          _convertToFractionalHour(sleepStart, stage['start'] as String);
      final endHour =
          _convertToFractionalHour(sleepStart, stage['end'] as String);

      if (tappedX >= startHour && tappedX <= endHour) {
        final stageName = stage['stage'] as String;
        final startTime = stage['start'] as String;
        final endTime = stage['end'] as String;

        final start = DateTime(
          sleepStart.year,
          sleepStart.month,
          sleepStart.day,
          int.parse(startTime.split(':')[0]),
          int.parse(startTime.split(':')[1]),
        );
        final end = DateTime(
          sleepStart.year,
          sleepStart.month,
          sleepStart.day,
          int.parse(endTime.split(':')[0]),
          int.parse(endTime.split(':')[1]),
        );
        final duration = end.difference(start).inMinutes;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sleep Stage: $stageName'),
            content: Text(
                'From: $startTime\nTo: $endTime\nDuration: $duration minutes'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        );
        break;
      }
    }
  }
}

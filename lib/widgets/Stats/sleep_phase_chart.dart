import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepPhaseChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 2 == 0) {
                          return Text(
                            '${value.toInt()}:00AM',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 10),
                          );
                        }
                        return Text('');
                      },
                      interval: 1,
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
                                    color: Colors.white70, fontSize: 10));
                          case 1:
                            return Text('Light',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10));
                          case 2:
                            return Text('REM',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10));
                          case 3:
                            return Text('Awake',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10));
                          default:
                            return Text('');
                        }
                      },
                      interval: 1,
                      reservedSize: 40,
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 8,
                minY: -1,
                maxY: 4, // Adjusted maxY to accommodate 'Awake'
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 0),
                      FlSpot(1, 0),
                      FlSpot(1, 1),
                      FlSpot(2, 1),
                      FlSpot(2, 2),
                      FlSpot(3, 2),
                      FlSpot(3, 1),
                      FlSpot(4, 1),
                      FlSpot(4, 0),
                      FlSpot(5, 0),
                      FlSpot(5, 1),
                      FlSpot(6, 1),
                      FlSpot(6, 2),
                      FlSpot(7, 2),
                      FlSpot(7, 1),
                      FlSpot(8, 1),
                    ],
                    isCurved: false,
                    color: Colors.blue,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show:
                          false, // Set to false to remove the area below the line
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(y: -0.5, color: Colors.white.withOpacity(0.2)),
                    HorizontalLine(y: 0.5, color: Colors.white.withOpacity(0.2)),
                    HorizontalLine(y: 1.5, color: Colors.white.withOpacity(0.2)),
                    HorizontalLine(y: 2.5, color: Colors.white.withOpacity(0.2)),
                    HorizontalLine(y: 3.5, color: Colors.white.withOpacity(0.2)), // Added line for Awake
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
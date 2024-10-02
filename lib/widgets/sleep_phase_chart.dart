import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepPhaseChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text("00", style: TextStyle(color: Colors.white, fontSize: 12));
                    case 1:
                      return Text("01", style: TextStyle(color: Colors.white,fontSize: 12));
                    case 2:
                      return Text("02", style: TextStyle(color: Colors.white,fontSize: 12));
                    case 3:
                      return Text("03", style: TextStyle(color: Colors.white,fontSize: 12));
                    case 4:
                      return Text("04", style: TextStyle(color: Colors.white,fontSize: 12));
                    case 5:
                      return Text("05", style: TextStyle(color: Colors.white,fontSize: 12));
                    case 6:
                      return Text("06", style: TextStyle(color: Colors.white,fontSize: 12));
                    case 7:
                      return Text("07", style: TextStyle(color: Colors.white,fontSize: 12));
                    case 8:
                      return Text("08", style: TextStyle(color: Colors.white,fontSize: 12));
                    case 9:
                      return Text("09", style: TextStyle(color: Colors.white,fontSize: 12));
                    default:
                      return Container();
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1.2,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return Text("Deep",
                          style: TextStyle(color: Colors.white, fontSize: 12));
                    case 2:
                      return Text("Light",
                          style: TextStyle(color: Colors.white, fontSize: 12));
                    case 3:
                      return Text("REM",
                          style: TextStyle(color: Colors.white, fontSize: 12));
                    default:
                      return Container();
                  }
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          minX: 0,
          maxX: 9,
          minY: 0.5,
          maxY: 3.5,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 2.5),
                FlSpot(1, 1.8),
                FlSpot(2, 1.2),
                FlSpot(3, 1.5),
                FlSpot(4, 1.2),
                FlSpot(5, 2.1),
                FlSpot(6, 1.3),
                FlSpot(7, 2.2),
                FlSpot(8, 2.8),
                FlSpot(9, 3.0),
              ],
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.blueAccent.withOpacity(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
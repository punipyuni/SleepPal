import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepTypesPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
                    color: Color(0xFFFF9999),  // Orangish for REM
                    value: 22,
                    title: '22%',
                    radius: 50,
                    titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Color(0xFFAA77FF),  // Purple for Deep
                    value: 46,
                    title: '46%',
                    radius: 50,
                    titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Color(0xFFFF77FF),  // Pink for Light
                    value: 32,
                    title: '32%',
                    radius: 50,
                    titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Light Sleep', '3h 28m', Color(0xFFFF77FF)),
                SizedBox(height: 8),
                _buildLabel('Deep Sleep', '5h 01m', Color(0xFFAA77FF)),
                SizedBox(height: 8),
                _buildLabel('REM Sleep', '1h 02m', Color(0xFFFF9999)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String title, String duration, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              duration,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class SleepTypesLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLegendItem('Deep Sleep', '5 hr 01 min', Color(0xFFAA77FF)),
        _buildLegendItem('Light Sleep', '3 hr 28 min', Color(0xFFFF77FF)),
        _buildLegendItem('REM Sleep', '1 h 02 min', Color(0xFFFF9999)),
      ],
    );
  }

  Widget _buildLegendItem(String title, String duration, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: 8),
          Text(title, style: TextStyle(color: Colors.white70)),
          Spacer(),
          Text(duration, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
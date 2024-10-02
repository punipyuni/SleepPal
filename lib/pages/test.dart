import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepStatisticsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Statistics',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    // Add user avatar here
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Day/Week toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(child: Text('Day', style: TextStyle(color: Colors.black))),
                      ),
                    ),
                    Expanded(
                      child: Center(child: Text('Week', style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Date selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDateButton('Mon', '17', false),
                  _buildDateButton('Tue', '18', true),
                  _buildDateButton('Wed', '19', false),
                  _buildDateButton('Thu', '20', false),
                ],
              ),
              SizedBox(height: 20),
              // Sleep statistics
              _buildStatRow('Sleep Duration', '9 hr 30 min', 'Time Asleep', '0 hr 37 min'),
              _buildStatRow('Sleeping Time', '23:00 p.m.', 'Wake Up Time', '08:30 a.m.'),
              SizedBox(height: 20),
              // Sleep phase chart
              Text('Sleeping Phase', style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),
              Container(
                height: 200,
                
              ),
              SizedBox(height: 20),
              // Sleep type breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSleepTypeCard('Deep Sleep', '5 hr 01 min', Colors.purple),
                  _buildSleepTypeCard('Light Sleep', '3 hr 28 min', Colors.pink),
                  _buildSleepTypeCard('REM Sleep', '1 h 02 min', Colors.orange),
                ],
              ),
              SizedBox(height: 20),
              // Sleep percentages
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSleepPercentage('Light Sleep', '32%'),
                  _buildSleepPercentage('Deep Sleep', '46%'),
                  _buildSleepPercentage('REM Sleep', '22%'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton(String day, String date, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(day, style: TextStyle(color: Colors.white)),
          Text(date, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label1, String value1, String label2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStat(label1, value1),
        _buildStat(label2, value2),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSleepTypeCard(String type, String duration, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
          Text(type, style: TextStyle(color: Colors.white)),
          Text(duration, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSleepPercentage(String type, String percentage) {
    return Column(
      children: [
        Text(type, style: TextStyle(color: Colors.grey)),
        Text(percentage, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
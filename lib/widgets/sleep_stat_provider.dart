

import 'package:flutter/foundation.dart';

class SleepStatisticsProvider with ChangeNotifier {
  bool _isDayView = true;
  late DateTime _currentWeekStart;
  late int _selectedDayIndex;
  int? _selectedWeekDayIndex;

  SleepStatisticsProvider() {
    _initializeDates();
  }

  void _initializeDates() {
    final now = DateTime.now();
    _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    _selectedDayIndex = now.weekday - 1; // 0-based index (0 = Monday, 6 = Sunday)
  }

  List<Map<String, dynamic>> _weeklyData = [
     {
      'day': 'Mon',
      'duration': Duration(hours: 7, minutes: 30),
      'rem': Duration(hours: 1, minutes: 30),
      'light': Duration(hours: 4, minutes: 0),
      'deep': Duration(hours: 2, minutes: 0),
    },
    {
      'day': 'Tue',
      'duration': Duration(hours: 6, minutes: 45),
      'rem': Duration(hours: 1, minutes: 15),
      'light': Duration(hours: 3, minutes: 30),
      'deep': Duration(hours: 2, minutes: 0),
    },
    {
      'day': 'Wed',
      'duration': Duration(hours: 9, minutes: 30),
      'rem': Duration(hours: 2, minutes: 0),
      'light': Duration(hours: 5, minutes: 30),
      'deep': Duration(hours: 1, minutes: 30),
    },
    {
      'day': 'Thu',
      'duration': Duration(hours: 5, minutes: 50),
      'rem': Duration(hours: 1, minutes: 15),
      'light': Duration(hours: 3, minutes: 30),
      'deep': Duration(hours: 2, minutes: 0),
    },
    {
      'day': 'Fri',
      'duration': Duration(hours: 8, minutes: 34),
      'rem': Duration(hours: 1, minutes: 15),
      'light': Duration(hours: 3, minutes: 30),
      'deep': Duration(hours: 2, minutes: 0),
    },
    {
      'day': 'Sat',
      'duration': Duration(hours: 10, minutes: 11),
      'rem': Duration(hours: 1, minutes: 15),
      'light': Duration(hours: 3, minutes: 30),
      'deep': Duration(hours: 2, minutes: 0),
    },
    {
      'day': 'Sun',
      'duration': Duration(hours: 9, minutes: 0),
      'rem': Duration(hours: 1, minutes: 15),
      'light': Duration(hours: 3, minutes: 30),
      'deep': Duration(hours: 2, minutes: 0),
    },

  ];

    List<Map<String, dynamic>> get weeklyChartData {
    final maxDuration = _weeklyData.map((day) => day['duration'] as Duration).reduce((a, b) => a > b ? a : b);
    
    return _weeklyData.map((day) {
      final totalMinutes = day['duration'].inMinutes;
      return {
        'day': day['day'],
        'remFactor': day['rem'].inMinutes / totalMinutes,
        'lightFactor': day['light'].inMinutes / totalMinutes,
        'deepFactor': day['deep'].inMinutes / totalMinutes,
        'totalDuration': day['duration'] as Duration,
        'heightFactor': (day['duration'] as Duration).inMinutes / maxDuration.inMinutes,
      };
    }).toList();
  }

bool get isDayView => _isDayView;
  int get selectedDayIndex => _selectedDayIndex;
  int? get selectedWeekDayIndex => _selectedWeekDayIndex;
  DateTime get currentWeekStart => _currentWeekStart;
  
  List<Map<String, dynamic>> get weeklyData => _weeklyData;

  Map<String, dynamic> get selectedDayData => _weeklyData[_selectedDayIndex];

  Map<String, dynamic>? get selectedWeekDayData => 
      _selectedWeekDayIndex != null ? _weeklyData[_selectedWeekDayIndex!] : null;

  String get selectedDaySleepDuration {
    final duration = selectedDayData['duration'] as Duration;
    return '${duration.inHours} hr ${duration.inMinutes.remainder(60)} min';
  }

  String get selectedDayTimeAsleep {
    final rem = selectedDayData['rem'] as Duration;
    final light = selectedDayData['light'] as Duration;
    final deep = selectedDayData['deep'] as Duration;
    final totalAsleep = rem + light + deep;
    return '${totalAsleep.inHours} hr ${totalAsleep.inMinutes.remainder(60)} min';
  }

  String? get selectedWeekDayDuration {
    if (_selectedWeekDayIndex != null) {
      final duration = selectedWeekDayData!['duration'] as Duration;
      return '${duration.inHours} hr ${duration.inMinutes.remainder(60)} min';
    }
    return null;
  }

  String get selectedDaySleepingTime {
    // Assuming you store sleeping time in your data model
    // If not, you might want to calculate it based on your data
    return '23:00 p.m.';
  }
  

  String get selectedDayWakeUpTime {
    // Assuming you store wake up time in your data model
    // If not, you might want to calculate it based on your data
    return '08:30 a.m.';
  }

  // ... (keep the rest of the methods from the previous version)

  void toggleView(bool isDay) {
    _isDayView = isDay;
    if (!isDay) {
      _selectedWeekDayIndex = null; // Reset week selection when switching to week view
    }
    notifyListeners();
  }

  void selectDayInDayView(int index) {
    _selectedDayIndex = index;
    _selectedWeekDayIndex = null;
    notifyListeners();
  }

    void selectDayInWeekView(int? index) {
    if (_selectedWeekDayIndex == index) {
      // If the tapped day is already selected, deselect it
      _selectedWeekDayIndex = null;
    } else {
      // Otherwise, select the tapped day
      _selectedWeekDayIndex = index;
    }
    notifyListeners();
  }


  DateTime getDateForIndex(int index) {
    return _currentWeekStart.add(Duration(days: index));
  }
}
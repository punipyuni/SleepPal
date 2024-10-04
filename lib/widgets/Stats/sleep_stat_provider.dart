

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
    'sleepingTime': DateTime(2024, 10, 1, 23, 0), // Sleep at 11 PM
    'wakeUpTime': DateTime(2024, 10, 2, 6, 30),   // Wake up at 6:30 AM
  },
  {
    'day': 'Tue',
    'duration': Duration(hours: 6, minutes: 45),
    'rem': Duration(hours: 1, minutes: 15),
    'light': Duration(hours: 3, minutes: 30),
    'deep': Duration(hours: 2, minutes: 0),
    'sleepingTime': DateTime(2024, 10, 2, 23, 15), // Sleep at 11:15 PM
    'wakeUpTime': DateTime(2024, 10, 3, 6, 45),   // Wake up at 6:45 AM
  },
  {
    'day': 'Wed',
    'duration': Duration(hours: 8, minutes: 0),
    'rem': Duration(hours: 1, minutes: 45),
    'light': Duration(hours: 4, minutes: 15),
    'deep': Duration(hours: 2, minutes: 0),
    'sleepingTime': DateTime(2024, 10, 3, 22, 30), // Sleep at 10:30 PM
    'wakeUpTime': DateTime(2024, 10, 4, 6, 30),   // Wake up at 6:30 AM
  },
  {
    'day': 'Thu',
    'duration': Duration(hours: 7, minutes: 20),
    'rem': Duration(hours: 1, minutes: 10),
    'light': Duration(hours: 3, minutes: 50),
    'deep': Duration(hours: 2, minutes: 20),
    'sleepingTime': DateTime(2024,10 ,4 ,23 ,5), // Sleep at around midnight
    'wakeUpTime': DateTime(2024 ,10 ,5 ,6 ,25), // Wake up at around midnight
   },
   {
     'day': 'Fri',
     'duration': Duration(hours:8 ,minutes :34),
     'rem' : Duration(hours :4 ,minutes :4),
     'light' : Duration(hours :2 ,minutes :30),
     'deep' : Duration(hours :2 ,minutes :0),
     'sleepingTime' : DateTime(2024 ,10 ,5 ,23 ,0), // Sleep at midnight
     'wakeUpTime' : DateTime(2024 ,10 ,6 ,7 ,0), // Wake up at around midnight
   },
   {
     'day':'Sat',
     'duration' :Duration(hours :9 ,minutes :45),
     'rem' :Duration(hours :3 ,minutes :15),
     'light' :Duration(hours :3 ,minutes :0),
     'deep' :Duration(hours :3 ,minutes :30),
     'sleepingTime' :DateTime(2024 ,10 ,6 ,1 ,0), // Sleep at around midnight
     'wakeUpTime' :DateTime(2024 ,10 ,6 ,9 ,45), // Wake up at around midnight
   },
   {
     'day':'Sun',
     'duration' :Duration(hours :8 ,minutes :15),
     'rem' :Duration(hours :2 ,minutes :15),
     'light' :Duration(hours :3 ,minutes :0),
     'deep' :Duration(hours :2 ,minutes :0),
     'sleepingTime' :DateTime(2024 ,10 ,7 ,23 ,30), // Sleep at around midnight
     'wakeUpTime' :DateTime(2024 ,10 ,8 ,7 ,45), // Wake up at around midnight
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
    final sleepingTime = selectedDayData['sleepingTime'] as DateTime;
    return '${sleepingTime.hour.toString().padLeft(2, '0')}:${sleepingTime.minute.toString().padLeft(2, '0')}';
}

String get selectedDayWakeUpTime {
    final wakeUpTime = selectedDayData['wakeUpTime'] as DateTime;
    return '${wakeUpTime.hour.toString().padLeft(2, '0')}:${wakeUpTime.minute.toString().padLeft(2, '0')}';
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
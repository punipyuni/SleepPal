

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
    'awake': Duration(minutes: 15),
    'sleepingTime': DateTime(2024, 10, 1, 23, 0), // Sleep at 11 PM
    'wakeUpTime': DateTime(2024, 10, 2, 6, 30),   // Wake up at 6:30 AM
    'sleepStages': [
      {'stage': 'light', 'start': '23:00', 'end': '00:00'},
      {'stage': 'deep', 'start': '00:00', 'end': '02:00'},
      {'stage': 'wake', 'start': '02:00', 'end': '02:05'},
      {'stage': 'rem', 'start': '02:05', 'end': '03:35'},
      {'stage': 'light', 'start': '03:35', 'end': '06:30'},
    ],
  },
  {
    'day': 'Tue',
    'duration': Duration(hours: 6, minutes: 45),
    'rem': Duration(hours: 1, minutes: 15),
    'light': Duration(hours: 3, minutes: 30),
    'deep': Duration(hours: 2, minutes: 0),
    'awake': Duration(minutes: 10),
    'sleepingTime': DateTime(2024, 10, 2, 23, 15), // Sleep at 11:15 PM
    'wakeUpTime': DateTime(2024, 10, 3, 6, 45),   // Wake up at 6:45 AM
    'sleepStages': [
      {'stage': 'light', 'start': '23:15', 'end': '23:45'},
      {'stage': 'deep', 'start': '23:45', 'end': '01:45'},
      {'stage': 'wake', 'start': '01:45', 'end': '01:50'},
      {'stage': 'rem', 'start': '01:50', 'end': '03:05'},
      {'stage': 'light', 'start': '03:05', 'end': '06:45'},
    ],
  },
  {
    'day': 'Wed',
    'duration': Duration(hours: 8, minutes: 0),
    'rem': Duration(hours: 1, minutes: 45),
    'light': Duration(hours: 4, minutes: 15),
    'deep': Duration(hours: 2, minutes: 0),
    'awake': Duration(minutes: 20),
    'sleepingTime': DateTime(2024, 10, 3, 22, 30), // Sleep at 10:30 PM
    'wakeUpTime': DateTime(2024, 10, 4, 6, 30),   // Wake up at 6:30 AM
    'sleepStages': [
      {'stage': 'light', 'start': '22:30', 'end': '23:15'},
      {'stage': 'deep', 'start': '23:15', 'end': '01:15'},
      {'stage': 'wake', 'start': '01:15', 'end': '01:25'},
      {'stage': 'rem', 'start': '01:25', 'end': '03:10'},
      {'stage': 'light', 'start': '03:10', 'end': '06:30'},
    ],
  },
  {
    'day': 'Thu',
    'duration': Duration(hours: 7, minutes: 20),
    'rem': Duration(hours: 1, minutes: 10),
    'light': Duration(hours: 3, minutes: 50),
    'deep': Duration(hours: 2, minutes: 20),
    'awake': Duration(minutes: 5),
    'sleepingTime': DateTime(2024, 10, 4, 23, 5), // Sleep at 11:05 PM
    'wakeUpTime': DateTime(2024, 10, 5, 6, 25),   // Wake up at 6:25 AM
    'sleepStages': [
      {'stage': 'light', 'start': '23:05', 'end': '00:00'},
      {'stage': 'deep', 'start': '00:00', 'end': '02:20'},
      {'stage': 'wake', 'start': '02:20', 'end': '02:25'},
      {'stage': 'rem', 'start': '02:25', 'end': '03:35'},
      {'stage': 'light', 'start': '03:35', 'end': '06:25'},
    ],
  },
  {
    'day': 'Fri',
    'duration': Duration(hours: 8, minutes: 34),
    'rem': Duration(hours: 2, minutes: 15),
    'light': Duration(hours: 4, minutes: 0),
    'deep': Duration(hours: 2, minutes: 0),
    'awake': Duration(minutes: 10),
    'sleepingTime': DateTime(2024, 10, 5, 23, 0), // Sleep at 11 PM
    'wakeUpTime': DateTime(2024, 10, 6, 7, 0),   // Wake up at 7 AM
    'sleepStages': [
      {'stage': 'light', 'start': '23:00', 'end': '00:00'},
      {'stage': 'deep', 'start': '00:00', 'end': '02:00'},
      {'stage': 'wake', 'start': '02:00', 'end': '02:10'},
      {'stage': 'rem', 'start': '02:10', 'end': '04:25'},
      {'stage': 'light', 'start': '04:25', 'end': '07:00'},
    ],
  },
  {
    'day': 'Sat',
    'duration': Duration(hours: 9, minutes: 45),
    'rem': Duration(hours: 3, minutes: 15),
    'light': Duration(hours: 3, minutes: 0),
    'deep': Duration(hours: 3, minutes: 30),
    'awake': Duration(minutes: 15),
    'sleepingTime': DateTime(2024, 10, 6, 1, 0), // Sleep at 1 AM
    'wakeUpTime': DateTime(2024, 10, 6, 9, 45),  // Wake up at 9:45 AM
    'sleepStages': [
      {'stage': 'light', 'start': '01:00', 'end': '01:45'},
      {'stage': 'deep', 'start': '01:45', 'end': '04:45'},
      {'stage': 'wake', 'start': '04:45', 'end': '05:00'},
      {'stage': 'rem', 'start': '05:00', 'end': '08:15'},
      {'stage': 'light', 'start': '08:15', 'end': '09:45'},
    ],
  },
  {
    'day': 'Sun',
    'duration': Duration(hours: 8, minutes: 15),
    'rem': Duration(hours: 2, minutes: 15),
    'light': Duration(hours: 3, minutes: 0),
    'deep': Duration(hours: 2, minutes: 0),
    'awake': Duration(minutes: 10),
    'sleepingTime': DateTime(2024, 10, 7, 23, 30), // Sleep at 11:30 PM
    'wakeUpTime': DateTime(2024, 10, 8, 7, 45),   // Wake up at 7:45 AM
    'sleepStages': [
      {'stage': 'light', 'start': '23:30', 'end': '00:15'},
      {'stage': 'deep', 'start': '00:15', 'end': '02:15'},
      {'stage': 'wake', 'start': '02:15', 'end': '02:25'},
      {'stage': 'rem', 'start': '02:25', 'end': '04:40'},
      {'stage': 'light', 'start': '04:40', 'end': '07:45'},
    ],
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
  final awake = selectedDayData['awake'] as Duration; // Awake time

  final totalAsleep = rem + light + deep;
  final actualSleep = totalAsleep - awake; // Subtract awake time from total sleep

  return '${actualSleep.inHours} hr ${actualSleep.inMinutes.remainder(60)} min';
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

   Duration get averageSleepDuration {
    final totalDuration = _weeklyData.fold(Duration.zero, (sum, day) => sum + day['duration']);
    return Duration(minutes: totalDuration.inMinutes ~/ _weeklyData.length);
  }

  String get averageSleepDurationString {
    final avg = averageSleepDuration;
    return '${avg.inHours} hr ${avg.inMinutes.remainder(60)} min';
  }

  String get bestSleepPattern {
    // This is a simplified version. You might want to implement a more sophisticated algorithm.
    final bestDay = _weeklyData.reduce((a, b) => a['duration'] > b['duration'] ? a : b);
    final sleepTime = bestDay['sleepingTime'] as DateTime;
    final wakeTime = bestDay['wakeUpTime'] as DateTime;
    return '${sleepTime.hour.toString().padLeft(2, '0')}:${sleepTime.minute.toString().padLeft(2, '0')} - '
           '${wakeTime.hour.toString().padLeft(2, '0')}:${wakeTime.minute.toString().padLeft(2, '0')}';
  }

  double get averageLightSleepPercentage {
    final totalLight = _weeklyData.fold(0.0, (sum, day) => sum + (day['light'] as Duration).inMinutes);
    final totalSleep = _weeklyData.fold(0.0, (sum, day) => sum + (day['duration'] as Duration).inMinutes);
    return (totalLight / totalSleep) * 100;
  }

  double get averageDeepSleepPercentage {
    final totalDeep = _weeklyData.fold(0.0, (sum, day) => sum + (day['deep'] as Duration).inMinutes);
    final totalSleep = _weeklyData.fold(0.0, (sum, day) => sum + (day['duration'] as Duration).inMinutes);
    return (totalDeep / totalSleep) * 100;
  }

  double get averageRemSleepPercentage {
    final totalRem = _weeklyData.fold(0.0, (sum, day) => sum + (day['rem'] as Duration).inMinutes);
    final totalSleep = _weeklyData.fold(0.0, (sum, day) => sum + (day['duration'] as Duration).inMinutes);
    return (totalRem / totalSleep) * 100;
  }

  Duration get averageDeepSleepDuration {
    final totalDeep = _weeklyData.fold(Duration.zero, (sum, day) => sum + (day['deep'] as Duration));
    return Duration(minutes: totalDeep.inMinutes ~/ _weeklyData.length);
  }

  Duration get averageLightSleepDuration {
    final totalLight = _weeklyData.fold(Duration.zero, (sum, day) => sum + (day['light'] as Duration));
    return Duration(minutes: totalLight.inMinutes ~/ _weeklyData.length);
  }

  Duration get averageRemSleepDuration {
    final totalRem = _weeklyData.fold(Duration.zero, (sum, day) => sum + (day['rem'] as Duration));
    return Duration(minutes: totalRem.inMinutes ~/ _weeklyData.length);
  }

  // You can add a method to calculate sleep score if needed
  int calculateSleepScore() {
    // Implement your sleep score calculation logic here
    // This is a placeholder implementation
    return 81;
  }

  DateTime getDateForIndex(int index) {
    return _currentWeekStart.add(Duration(days: index));
  }
}
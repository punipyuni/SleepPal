// import 'package:flutter/foundation.dart';

// class SleepStatisticsProvider with ChangeNotifier {
//   bool _isDayView = true;
//   int _selectedDayIndex = 0; // For day view
//   int? _selectedWeekDayIndex; // For week view
//   List<Map<String, dynamic>> _weeklyData = [
//     {'day': 'Mon', 'duration': Duration(hours: 7, minutes: 30)},
//     {'day': 'Tue', 'duration': Duration(hours: 6, minutes: 45)},
//     {'day': 'Wed', 'duration': Duration(hours: 8, minutes: 0)},
//     {'day': 'Thu', 'duration': Duration(hours: 7, minutes: 15)},
//     {'day': 'Fri', 'duration': Duration(hours: 9, minutes: 30)},
//     {'day': 'Sat', 'duration': Duration(hours: 8, minutes: 45)},
//     {'day': 'Sun', 'duration': Duration(hours: 7, minutes: 0)},
//   ];

  

//   bool get isDayView => _isDayView;
//   int get selectedDayIndex => _selectedDayIndex;
//   int? get selectedWeekDayIndex => _selectedWeekDayIndex;
//   List<Map<String, dynamic>> get weeklyData => _weeklyData;

//   String? get selectedWeekDayDuration {
//     if (_selectedWeekDayIndex != null && _selectedWeekDayIndex! >= 0 && _selectedWeekDayIndex! < _weeklyData.length) {
//       final duration = _weeklyData[_selectedWeekDayIndex!]['duration'] as Duration;
//       return '${duration.inHours} hr ${duration.inMinutes.remainder(60)} min';
//     }
//     return null;
//   }

//   void toggleView(bool isDay) {
//     _isDayView = isDay;
//     notifyListeners();
//   }

//   void selectDayInDayView(int index) {
//     _selectedDayIndex = index;
//     notifyListeners();
//   }

//   void selectDayInWeekView(int? index) {
//     _selectedWeekDayIndex = index;
//     notifyListeners();
//   }

//   // Add more methods as needed for fetching and updating sleep statistics data
// }

import 'package:flutter/foundation.dart';

class SleepStatisticsProvider with ChangeNotifier {
  bool _isDayView = true;
  int _selectedDayIndex = 0; // For day view
  int? _selectedWeekDayIndex; // For week view
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
      'duration': Duration(hours: 9, minutes: 0),
      'rem': Duration(hours: 2, minutes: 0),
      'light': Duration(hours: 5, minutes: 30),
      'deep': Duration(hours: 1, minutes: 30),
    },
    {
      'day': 'Thu',
      'duration': Duration(hours: 6, minutes: 45),
      'rem': Duration(hours: 1, minutes: 15),
      'light': Duration(hours: 3, minutes: 30),
      'deep': Duration(hours: 2, minutes: 0),
    },
    {
      'day': 'Fri',
      'duration': Duration(hours: 6, minutes: 45),
      'rem': Duration(hours: 1, minutes: 15),
      'light': Duration(hours: 3, minutes: 30),
      'deep': Duration(hours: 2, minutes: 0),
    },
    {
      'day': 'Sat',
      'duration': Duration(hours: 6, minutes: 45),
      'rem': Duration(hours: 1, minutes: 15),
      'light': Duration(hours: 3, minutes: 30),
      'deep': Duration(hours: 2, minutes: 0),
    },
    {
      'day': 'Sun',
      'duration': Duration(hours: 6, minutes: 45),
      'rem': Duration(hours: 1, minutes: 15),
      'light': Duration(hours: 3, minutes: 30),
      'deep': Duration(hours: 2, minutes: 0),
    },
    // Add similar data for Wed, Thu, Fri, Sat, Sun
  ];

  bool get isDayView => _isDayView;
  int get selectedDayIndex => _selectedDayIndex;
  int? get selectedWeekDayIndex => _selectedWeekDayIndex;
  
  List<Map<String, dynamic>> get weeklyData {
    return _weeklyData.map((day) {
      final totalMinutes = day['duration'].inMinutes;
      return {
        'day': day['day'],
        'remFactor': day['rem'].inMinutes / totalMinutes,
        'lightFactor': day['light'].inMinutes / totalMinutes,
        'deepFactor': day['deep'].inMinutes / totalMinutes,
      };
    }).toList();
  }

  String? get selectedWeekDayDuration {
    if (_selectedWeekDayIndex != null && _selectedWeekDayIndex! >= 0 && _selectedWeekDayIndex! < _weeklyData.length) {
      final duration = _weeklyData[_selectedWeekDayIndex!]['duration'] as Duration;
      return '${duration.inHours} hr ${duration.inMinutes.remainder(60)} min';
    }
    return null;
  }

  void toggleView(bool isDay) {
    _isDayView = isDay;
    notifyListeners();
  }

  void selectDayInDayView(int index) {
    _selectedDayIndex = index;
    notifyListeners();
  }

  void selectDayInWeekView(int? index) {
    _selectedWeekDayIndex = index;
    notifyListeners();
  }

  // Add more methods as needed for fetching and updating sleep statistics data
}
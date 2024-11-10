import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:health/health.dart';

class SleepStatisticsProvider with ChangeNotifier {
  bool isDayView = true;
  late DateTime _currentWeekStart;
  late int _selectedDayIndex;
  int? _selectedWeekDayIndex;
  int? _userAge;
  Map<String, Map<String, dynamic>> dailySleepTotals = {};
  Map<String, double> dailySleepScores =
      {}; // New map to store daily sleep scores
  int _lastSelectedDayIndex =
      DateTime.now().weekday - 1; // Store last selected day for daily view

  SleepStatisticsProvider() {
    _initializeDates();
    _fetchHealthData();
  }

  DateTime get currentWeekStart => _currentWeekStart;

  void _populateDailySleepScores() {
    dailySleepScores.clear();

    dailySleepTotals.forEach((date, sleepData) {
      final score = calculateDailySleepScore({
        'sleepData': sleepData['sleepData'],
        'sleepingTime': sleepData['sleepingTime'],
        'wakeUpTime': sleepData['wakeUpTime'],
      });

      // Debug: Check if the score is being calculated
      debugPrint("Date: $date, Score: $score");

      dailySleepScores[date] = score;
    });

    // Debug: Check if dailySleepScores is populated
    debugPrint("dailySleepScores: $dailySleepScores");
  }
 
  List<DateTime> getAvailableDates() {
  return dailySleepTotals.keys.map((key) {
    final dateParts = key.split('-');
    return DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
  }).toList();
}



  void resetSelectedDay() {
    _selectedDayIndex = -1; // Reset to an invalid index
    _selectedWeekDayIndex = null;
    _selectedWeekDayDuration = null;
    notifyListeners();
  }

  void _initializeDates() {
    final now = DateTime.now();
    _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    _selectedDayIndex = now.weekday - 1;
    _lastSelectedDayIndex = _selectedDayIndex;
  }

  int get selectedDayIndex => _selectedDayIndex;

  void selectDayInDayView(int index) {
    if (index < 0 || index >= 7) return;
    _selectedDayIndex = index;
    _lastSelectedDayIndex = index; // Update last selected day when changing day
    notifyListeners();
  }

  DateTime getDateForIndex(int index) {
    return _currentWeekStart.add(Duration(days: index));
  }

  void navigateToPreviousWeek() {
    _currentWeekStart = _currentWeekStart.subtract(Duration(days: 7));
    _fetchHealthData();
    _selectedDayIndex = 0;
    notifyListeners();
  }

  void navigateToNextWeek() {
    _currentWeekStart = _currentWeekStart.add(Duration(days: 7));
    _fetchHealthData();
    _selectedDayIndex = 0;
    notifyListeners();
  }

  String? _selectedWeekDayDuration; // Add this private variable

  // Getter for the selected weekday duration
  String? get selectedWeekDayDuration => _selectedWeekDayDuration;

  // Method to update the selected weekday duration
  void updateSelectedDayDuration(int index) {
    final selectedDay = weeklyData[index];
    final duration = selectedDay['duration'] as Duration;
    _selectedWeekDayDuration = _formatDuration(duration);
    notifyListeners();
  }

  Future<void> _fetchHealthData() async {
    final startDate = DateTime(_currentWeekStart.year, _currentWeekStart.month,
        _currentWeekStart.day, 0, 0, 0);
    final endDate = _currentWeekStart
        .add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    List<HealthDataType> sleepTypes = [
      HealthDataType.SLEEP_REM,
      HealthDataType.SLEEP_LIGHT,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_DEEP,
    ];

    try {
      List<HealthDataPoint> sleepData = await Health().getHealthDataFromTypes(
        types: sleepTypes,
        startTime: startDate,
        endTime: endDate,
      );

      // Sort sleep data by dateFrom in ascending order
      sleepData.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
      debugPrint("Fetched sleep data: $sleepData");

      dailySleepTotals.clear();
      dailySleepScores.clear();

      for (var dataPoint in sleepData) {
        final dateKey =
            "${dataPoint.dateFrom.year}-${dataPoint.dateFrom.month}-${dataPoint.dateFrom.day}";

        dailySleepTotals.putIfAbsent(
            dateKey,
            () => {
                  'sleepData': {
                    HealthDataType.SLEEP_LIGHT: 0.0,
                    HealthDataType.SLEEP_REM: 0.0,
                    HealthDataType.SLEEP_AWAKE: 0.0,
                    HealthDataType.SLEEP_DEEP: 0.0,
                    HealthDataType.SLEEP_ASLEEP: 0.0,
                  },
                  'sleepingTime': dataPoint.dateFrom,
                  'wakeUpTime': dataPoint.dateTo,
                  'sleepStages': <Map<String, dynamic>>[],
                });

        // Update wakeUpTime to the latest dateTo
        if (dataPoint.dateTo
            .isAfter(dailySleepTotals[dateKey]!['wakeUpTime'])) {
          dailySleepTotals[dateKey]!['wakeUpTime'] = dataPoint.dateTo;
        }

        // Add sleep stage information
        (dailySleepTotals[dateKey]!['sleepStages']
                as List<Map<String, dynamic>>)
            .add({
          'stage': _mapHealthDataTypeToStageName(dataPoint.type),
          'start': _formatTime(dataPoint.dateFrom),
          'end': _formatTime(dataPoint.dateTo),
        });

        if (dataPoint.value is NumericHealthValue) {
          double duration =
              (dataPoint.value as NumericHealthValue).numericValue.toDouble();
          dailySleepTotals[dateKey]!['sleepData'][dataPoint.type] =
              (dailySleepTotals[dateKey]!['sleepData'][dataPoint.type] ?? 0.0) +
                  duration;
        }
      }

      dailySleepTotals.forEach((date, sleepData) {
        sleepData['sleepData'][HealthDataType.SLEEP_ASLEEP] =
            (sleepData['sleepData'][HealthDataType.SLEEP_REM] ?? 0.0) +
                (sleepData['sleepData'][HealthDataType.SLEEP_LIGHT] ?? 0.0) +
                (sleepData['sleepData'][HealthDataType.SLEEP_DEEP] ?? 0.0) +
                (sleepData['sleepData'][HealthDataType.SLEEP_AWAKE] ?? 0.0);
        debugPrint(
            "Total sleep for $date: ${sleepData['sleepData'][HealthDataType.SLEEP_ASLEEP]} minutes");
      });

      // Populate daily sleep scores
      _populateDailySleepScores();

      notifyListeners();
    } catch (error) {
      debugPrint("Error fetching health data: $error");
    }
  }
  
  

  String get bestSleepPattern {
    if (dailySleepScores.isEmpty) {
      debugPrint("dailySleepScores is empty. No data to display.");
      return 'No data';
    }

    String? bestDateKey;
    double highestScore = -1;

    dailySleepScores.forEach((dateKey, score) {
      debugPrint("Date: $dateKey, Score: $score");
      if (score > highestScore) {
        highestScore = score;
        bestDateKey = dateKey;
      }
    });

    // Check if bestDateKey is null
    if (bestDateKey == null) {
      debugPrint("No best date found in dailySleepScores.");
      return 'No data';
    }

    // Perform null check before calling split
    List<String> dateParts = bestDateKey!.split('-');
    String formattedDateKey =
        "${dateParts[0]}-${dateParts[1].padLeft(2, '0')}-${dateParts[2].padLeft(2, '0')}";

    // Parse the formatted date
    DateTime bestDate = DateTime.parse(formattedDateKey);
    String bestDayName = getDayName(bestDate);

    Map<String, dynamic>? bestDayData;
    for (var dayData in weeklyData) {
      debugPrint("Checking if ${dayData['day']} matches $bestDayName");
      if (dayData['day'] == bestDayName) {
        bestDayData = dayData;
        break;
      }
    }

    if (bestDayData == null) {
      debugPrint("No matching day data found in weeklyData for $bestDayName.");
      return 'No data';
    }

    final sleepingTime = bestDayData['sleepingTime'] as DateTime?;
    final wakeUpTime = bestDayData['wakeUpTime'] as DateTime?;

    if (sleepingTime == null || wakeUpTime == null) {
      debugPrint("Sleeping or wake-up time is null for $bestDayName.");
      return 'No data';
    }

    final formattedSleepingTime =
        '${sleepingTime.hour.toString().padLeft(2, '0')}:${sleepingTime.minute.toString().padLeft(2, '0')}';
    final formattedWakeUpTime =
        '${wakeUpTime.hour.toString().padLeft(2, '0')}:${wakeUpTime.minute.toString().padLeft(2, '0')}';

    debugPrint(
        "Best sleep pattern found: $formattedSleepingTime - $formattedWakeUpTime ($bestDayName)");
    return '$formattedSleepingTime - $formattedWakeUpTime ($bestDayName)';
  }

// Helper function to map HealthDataType to stage name
  String _mapHealthDataTypeToStageName(HealthDataType type) {
    switch (type) {
      case HealthDataType.SLEEP_DEEP:
        return 'deep';
      case HealthDataType.SLEEP_LIGHT:
        return 'light';
      case HealthDataType.SLEEP_REM:
        return 'rem';
      case HealthDataType.SLEEP_AWAKE:
        return 'wake';
      default:
        return 'unknown';
    }
  }

// Helper function to format DateTime to "HH:mm" string
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic>? get selectedDayData {
    DateTime date = getDateForIndex(_selectedDayIndex);
    String dateKey = "${date.year}-${date.month}-${date.day}";
    if (dailySleepTotals.containsKey(dateKey)) {
      return dailySleepTotals[dateKey];
    }
    return null;
  }

  String get selectedDaySleepDuration {
    final duration =
        (selectedDayData?['sleepData'][HealthDataType.SLEEP_ASLEEP] ?? 0.0)
            as double;
    return _formatDuration(Duration(minutes: duration.toInt()));
  }

  String get selectedDayTimeAsleep {
    final rem = (selectedDayData?['sleepData'][HealthDataType.SLEEP_REM] ?? 0.0)
        as double;
    final light = (selectedDayData?['sleepData'][HealthDataType.SLEEP_LIGHT] ??
        0.0) as double;
    final deep = (selectedDayData?['sleepData'][HealthDataType.SLEEP_DEEP] ??
        0.0) as double;
    final awake = (selectedDayData?['sleepData'][HealthDataType.SLEEP_AWAKE] ??
        0.0) as double;

    final totalAsleep = rem + light + deep;
    final actualSleep = totalAsleep - awake;

    return _formatDuration(Duration(minutes: actualSleep.toInt()));
  }

  List<Map<String, dynamic>> get weeklyChartData {
    return weeklyData.map((day) {
      final duration = day['duration'] as Duration;
      final totalMinutes = duration.inMinutes;
      return {
        'day': day['day'],
        'remFactor': (day['rem'] as Duration).inMinutes / totalMinutes,
        'lightFactor': (day['light'] as Duration).inMinutes / totalMinutes,
        'deepFactor': (day['deep'] as Duration).inMinutes / totalMinutes,
        'totalDuration': duration,
      };
    }).toList();
  }

  List<Map<String, Object>> get weeklyData {
    // Convert the keys to DateTime objects and sort by weekday
    final sortedKeys = dailySleepTotals.keys.map((dateKey) {
      final dateParts = dateKey.split('-');
      return DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );
    }).toList()
      ..sort((a, b) => a.weekday.compareTo(b.weekday)); // Sort by weekday

    // Map the sorted dates to the corresponding sleep data
    return sortedKeys.map((date) {
      final dateKey = "${date.year}-${date.month}-${date.day}";
      final sleepData = dailySleepTotals[dateKey] ?? {};
      return {
        'day': getDayName(date) as Object,
        'duration': Duration(
            minutes:
                (sleepData['sleepData']?[HealthDataType.SLEEP_ASLEEP] ?? 0.0)
                    .toInt()) as Object,
        'rem': Duration(
            minutes: (sleepData['sleepData']?[HealthDataType.SLEEP_REM] ?? 0.0)
                .toInt()) as Object,
        'light': Duration(
            minutes:
                (sleepData['sleepData']?[HealthDataType.SLEEP_LIGHT] ?? 0.0)
                    .toInt()) as Object,
        'deep': Duration(
            minutes: (sleepData['sleepData']?[HealthDataType.SLEEP_DEEP] ?? 0.0)
                .toInt()) as Object,
        'awake': Duration(
            minutes:
                (sleepData['sleepData']?[HealthDataType.SLEEP_AWAKE] ?? 0.0)
                    .toInt()) as Object,
        'sleepingTime': sleepData['sleepingTime'] as Object,
        'wakeUpTime': sleepData['wakeUpTime'] as Object,
      };
    }).toList();
  }

  String getDayName(DateTime date) {
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours} hr ${duration.inMinutes.remainder(60)} min';
  }

  String get selectedDaySleepingTime {
    final sleepingTime = selectedDayData?['sleepingTime'] as DateTime?;
    if (sleepingTime == null) return '--:--';
    return '${sleepingTime.hour.toString().padLeft(2, '0')}:${sleepingTime.minute.toString().padLeft(2, '0')}';
  }

  String get selectedDayWakeUpTime {
    final wakeUpTime = selectedDayData?['wakeUpTime'] as DateTime?;
    if (wakeUpTime == null) return '--:--';
    return '${wakeUpTime.hour.toString().padLeft(2, '0')}:${wakeUpTime.minute.toString().padLeft(2, '0')}';
  }

  Duration get averageDeepSleepDuration {
    if (weeklyData.isEmpty) return Duration.zero;
    final totalDeep = weeklyData.fold(
        Duration.zero, (sum, day) => sum + (day['deep'] as Duration));
    return Duration(minutes: totalDeep.inMinutes ~/ weeklyData.length);
  }

  Duration get averageLightSleepDuration {
    if (weeklyData.isEmpty) return Duration.zero;
    final totalLight = weeklyData.fold(
        Duration.zero, (sum, day) => sum + (day['light'] as Duration));
    return Duration(minutes: totalLight.inMinutes ~/ weeklyData.length);
  }

  Duration get averageRemSleepDuration {
    if (weeklyData.isEmpty) return Duration.zero;
    final totalRem = weeklyData.fold(
        Duration.zero, (sum, day) => sum + (day['rem'] as Duration));
    return Duration(minutes: totalRem.inMinutes ~/ weeklyData.length);
  }

  String get averageSleepDurationString {
    if (weeklyData.isEmpty) return '0 hr 0 min';
    final totalDuration = weeklyData.fold(
        Duration.zero, (sum, day) => sum + (day['duration'] as Duration));
    final averageDuration =
        Duration(minutes: totalDuration.inMinutes ~/ weeklyData.length);
    return '${averageDuration.inHours} hr ${averageDuration.inMinutes.remainder(60)} min';
  }

//return '$formattedSleepingTime - $formattedWakeUpTime (${bestDay['day']})';

  double calculateDailySleepScore(Map<String, dynamic> dayData) {
    final Map<HealthDataType, double> sleepData =
        dayData['sleepData'] as Map<HealthDataType, double>? ?? {};
    final Duration deepSleep = Duration(
        minutes: (sleepData[HealthDataType.SLEEP_DEEP] ?? 0.0).toInt());
    final Duration remSleep =
        Duration(minutes: (sleepData[HealthDataType.SLEEP_REM] ?? 0.0).toInt());
    final Duration lightSleep = Duration(
        minutes: (sleepData[HealthDataType.SLEEP_LIGHT] ?? 0.0).toInt());
    final Duration awake = Duration(
        minutes: (sleepData[HealthDataType.SLEEP_AWAKE] ?? 0.0).toInt());

    final int totalSleepMinutes =
        deepSleep.inMinutes + remSleep.inMinutes + lightSleep.inMinutes;
    final int awakeMinutes = awake.inMinutes;

    if (totalSleepMinutes == 0) return 0;

    final double deepPercentage = deepSleep.inMinutes / totalSleepMinutes;
    final double remPercentage = remSleep.inMinutes / totalSleepMinutes;
    final double lightPercentage = lightSleep.inMinutes / totalSleepMinutes;
    final double awakePercentage =
        awakeMinutes / (totalSleepMinutes + awakeMinutes);

    const double deepIdeal = 0.25;
    const double remIdeal = 0.25;
    const double lightIdeal = 0.50;
    const double wDeep = 0.4;
    const double wRem = 0.4;
    const double wLight = 0.2;

    final double deepScore = wDeep * (deepPercentage / deepIdeal);
    final double remScore = wRem * (remPercentage / remIdeal);
    final double lightScore = wLight * (lightPercentage / lightIdeal);

    double score = 100 * (deepScore + remScore + lightScore - awakePercentage);
    final double totalSleepHours = totalSleepMinutes / 60.0;

    if (totalSleepHours < 6) {
      score = score.clamp(0, 50);
    } else {
      score = score.clamp(0, 75);
    }

    return score;
  }

  double get averageLightSleepPercentage {
    if (weeklyData.isEmpty) return 0.0;
    final totalLight = weeklyData.fold(
        0.0, (sum, day) => sum + (day['light'] as Duration).inMinutes);
    final totalSleep = weeklyData.fold(
        0.0, (sum, day) => sum + (day['duration'] as Duration).inMinutes);
    return (totalLight / totalSleep) * 100;
  }

  double get averageDeepSleepPercentage {
    if (weeklyData.isEmpty) return 0.0;
    final totalDeep = weeklyData.fold(
        0.0, (sum, day) => sum + (day['deep'] as Duration).inMinutes);
    final totalSleep = weeklyData.fold(
        0.0, (sum, day) => sum + (day['duration'] as Duration).inMinutes);
    return (totalDeep / totalSleep) * 100;
  }

  double get averageRemSleepPercentage {
    if (weeklyData.isEmpty) return 0.0;
    final totalRem = weeklyData.fold(
        0.0, (sum, day) => sum + (day['rem'] as Duration).inMinutes);
    final totalSleep = weeklyData.fold(
        0.0, (sum, day) => sum + (day['duration'] as Duration).inMinutes);
    return (totalRem / totalSleep) * 100;
  }

  int? get selectedWeekDayIndex => _selectedWeekDayIndex;

  void toggleView(bool isDay) {
    isDayView = isDay;
    if (isDay) {
      // Restore last selected day index when switching back to daily view
      _selectedDayIndex = _lastSelectedDayIndex;
    } else {
      // Optionally reset the day index when switching to weekly view
      _selectedDayIndex = 0;
    }
    notifyListeners();
  }

  void selectDayInWeekView(int? index) {
    if (_selectedWeekDayIndex == index) {
      _selectedWeekDayIndex = null;
    } else {
      _selectedWeekDayIndex = index;
    }
    notifyListeners();
  }

  int? get userAge => _userAge;

  set userAge(int? age) {
    if (_userAge != age) {
      _userAge = age;
      notifyListeners();
    }
  }
  double? get recommendedMinSleepHours {
    if (_userAge == null) return null;
    try {
      final recommendation = _sleepRecommendations.firstWhere(
        (rec) => rec.isInAgeRange(_userAge!),
      );
      return recommendation.recommendedMin.inMinutes / 60.0;
    } catch (e) {
      return null;
    }
  }

  double? get recommendedMaxSleepHours {
    if (_userAge == null) return null;
    try {
      final recommendation = _sleepRecommendations.firstWhere(
        (rec) => rec.isInAgeRange(_userAge!),
      );
      return recommendation.recommendedMax.inMinutes / 60.0;
    } catch (e) {
      return null;
    }
  }

  static const List<AgeBasedSleepRecommendation> _sleepRecommendations = [
    AgeBasedSleepRecommendation(
      minAge: 0,
      maxAge: 3,
      recommendedMin: Duration(hours: 14),
      recommendedMax: Duration(hours: 17),
    ),
    AgeBasedSleepRecommendation(
      minAge: 4,
      maxAge: 11,
      recommendedMin: Duration(hours: 12),
      recommendedMax: Duration(hours: 15),
    ),
    AgeBasedSleepRecommendation(
      minAge: 12,
      maxAge: 13,
      recommendedMin: Duration(hours: 9),
      recommendedMax: Duration(hours: 11),
    ),
    AgeBasedSleepRecommendation(
      minAge: 14,
      maxAge: 17,
      recommendedMin: Duration(hours: 8),
      recommendedMax: Duration(hours: 10),
    ),
    AgeBasedSleepRecommendation(
      minAge: 18,
      maxAge: 64,
      recommendedMin: Duration(hours: 7),
      recommendedMax: Duration(hours: 9),
    ),
    AgeBasedSleepRecommendation(
      minAge: 65,
      maxAge: 120,
      recommendedMin: Duration(hours: 7),
      recommendedMax: Duration(hours: 8),
    ),
  ];
}

class AgeBasedSleepRecommendation {
  final int minAge;
  final int maxAge;
  final Duration recommendedMin;
  final Duration recommendedMax;

  const AgeBasedSleepRecommendation({
    required this.minAge,
    required this.maxAge,
    required this.recommendedMin,
    required this.recommendedMax,
  });

  bool isInAgeRange(int age) => age >= minAge && age <= maxAge;
}
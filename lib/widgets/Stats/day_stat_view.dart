import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/Stats/daily_sleep_score.dart';
import 'day_selector.dart';
import 'sleep_phase_chart.dart';
import 'sleep_pie_chart.dart';
import 'statistic_item.dart';
import 'sleep_stat_provider.dart';
import 'package:provider/provider.dart';
import '../../pages/MainScreen.dart';

class DayStatisticsView extends StatefulWidget {
  final token;

  const DayStatisticsView({super.key, required this.token});

  @override
  DayStatisticsViewState createState() => DayStatisticsViewState();
}

class DayStatisticsViewState extends State<DayStatisticsView> {
  SharedPreferences? prefs;
  String? token;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
  prefs = await SharedPreferences.getInstance();
  token = (widget.token != null && widget.token.isNotEmpty) ? widget.token : prefs?.getString('token');
}


  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        final sleepingTime = provider.selectedDaySleepingTime;

        // Check if sleeping time is past 1 am
        bool isLateSleeping = false;
        if (sleepingTime != '--:--') {
          final timeParts = sleepingTime.split(':');
          final hour = int.parse(timeParts[0]);
          isLateSleeping = hour >= 1 && hour <= 12;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DaySelector(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticItem(
                  title: 'Sleep Duration',
                  value: provider.selectedDaySleepDuration,
                ),
                StatisticItem(
                  title: 'Time Asleep',
                  value: provider.selectedDayTimeAsleep,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    StatisticItem(
                      title: 'Sleeping Time',
                      value: sleepingTime,
                    ),
                    if (isLateSleeping)
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 30),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Sleep Warning'),
                                  content: const Text(
                                      'Your sleeping time is after 1 am. Consider going to bed earlier for better sleep quality.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        // Parse the `sleepingTime` and adjust it by subtracting 1 hour
                                        if (sleepingTime != '--:--') {
                                          final timeParts =
                                              sleepingTime.split(':');
                                          int hour = int.parse(timeParts[0]);
                                          final minute =
                                              int.parse(timeParts[1]);

                                          // Subtract 1 hour and handle midnight edge case
                                          hour =
                                              (hour - 1) < 0 ? 23 : (hour - 1);

                                          final adjustedTime = TimeOfDay(
                                              hour: hour, minute: minute);

                                          // Navigate to MainScreen with `adjustedTime`
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => MainScreen(
                                                token: token,
                                                initialIndex: 2,
                                                bedtimeReminder:
                                                    adjustedTime, // Pass adjusted time
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Go sleep earlier',
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Close',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                '!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                StatisticItem(
                  title: 'Wake Up Time',
                  value: provider.selectedDayWakeUpTime,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SleepPhaseChart(),
            const SizedBox(height: 24),
            DailySleepScoreWidget(),
            const SizedBox(height: 24),
            SleepTypesPieChart(),
          ],
        );
      },
    );
  }
}

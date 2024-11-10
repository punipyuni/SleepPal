import 'package:flutter/material.dart';
import 'day_button.dart';
import 'sleep_stat_provider.dart';
import 'package:provider/provider.dart';

class DaySelector extends StatefulWidget {
  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  late ScrollController _scrollController;
  double _itemWidth = 68.0; // Default item width, adjust as needed

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SleepStatisticsProvider>(context, listen: false);
      _scrollToSelectedDay(provider.selectedDayIndex);
    });
  }

  void _scrollToSelectedDay(int selectedDayIndex) {
    final double offset = selectedDayIndex * _itemWidth;
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate item width based on screen size for better accuracy
    _itemWidth = MediaQuery.of(context).size.width / 7; // Assuming 7 days in a row
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SleepStatisticsProvider>(
      builder: (context, provider, child) {
        final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final List<DateTime> availableDates = provider.getAvailableDates();
        DateTime selectedDate = provider.getDateForIndex(provider.selectedDayIndex);

        // Get today's date
        DateTime now = DateTime.now();

        // Calculate the start and end of the current week
        DateTime weekStart = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
        DateTime weekEnd = weekStart.add(Duration(days: 6));

        // Determine if the user is viewing the current week
        bool isCurrentWeek = now.isAfter(weekStart.subtract(Duration(days: 1))) &&
                             now.isBefore(weekEnd.add(Duration(days: 1)));

        return Column(
          children: [
            // Navigation Arrows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, color: Colors.white),
                  onPressed: () {
                    provider.navigateToPreviousWeek();
                  },
                ),
                Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", // Show selected day's date
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_right,
                    color: isCurrentWeek ? Colors.grey.withOpacity(0.5) : Colors.white,
                  ),
                  onPressed: isCurrentWeek
                      ? null
                      : () {
                          provider.navigateToNextWeek();
                        },
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 80,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final date = provider.getDateForIndex(index);
                  final isFutureDate = date.isAfter(DateTime.now());

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: DayButton(
                      day: days[index],
                      date: date.day.toString(),
                      isSelected: index == provider.selectedDayIndex,
                      color: isFutureDate ? Colors.grey.withOpacity(0.5) : null, // Grey out future dates
                      onTap: isFutureDate
                          ? () {} // Provide an empty callback for future dates
                          : () {
                              provider.selectDayInDayView(index);
                              _scrollToSelectedDay(index); // Scroll to selected day
                            },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sleep_stat_provider.dart';

class WeeklyBarChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final double? minIdealSleep; // Minimum ideal sleep line
  final double? maxIdealSleep; // Maximum ideal sleep line
  final Function(int?) onBarSelected;

  WeeklyBarChart({
    required this.data,
    required this.onBarSelected,
    this.minIdealSleep,
    this.maxIdealSleep,
  });

  @override
  _WeeklyBarChartState createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SleepStatisticsProvider>(context);
    final double chartHeight = 150.0;

    // Calculate the maximum sleep duration for scaling the chart
    final maxSleepDuration = [
          ...widget.data
              .map((e) => (e['totalDuration'] as Duration?)?.inMinutes ?? 0.0),
          if (widget.minIdealSleep != null) widget.minIdealSleep! * 60,
          if (widget.maxIdealSleep != null) widget.maxIdealSleep! * 60,
        ].reduce((a, b) => a > b ? a : b) / 60.0;

    final double oneHourHeight =
        chartHeight / (maxSleepDuration > 0 ? maxSleepDuration : 1);

    return Container(
      height: 200,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.data.length, (index) {
                final item = widget.data[index];
                final duration = item['totalDuration'] as Duration?;
                final double hours =
                    duration != null ? duration.inMinutes / 60.0 : 0.0;
                final double heightFactor = hours / maxSleepDuration;
                final double remFactor = item['remFactor'] ?? 0.0;
                final double lightFactor = item['lightFactor'] ?? 0.0;
                final double deepFactor = item['deepFactor'] ?? 0.0;
                final String day = item['day'] ?? 'N/A';

                return GestureDetector(
                  onTap: () {
                    if (provider.selectedWeekDayIndex == index) {
                      widget.onBarSelected(null);
                      provider.resetSelectedDay();
                    } else {
                      widget.onBarSelected(index);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Container(
                              width: 20,
                              height: (chartHeight * heightFactor) *
                                  _animation.value,
                              decoration: BoxDecoration(
                                border: provider.selectedWeekDayIndex == index
                                    ? Border.all(color: Colors.white, width: 2)
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  _buildSegment(remFactor, Colors.orange,
                                      isTopSegment: true),
                                  _buildSegment(
                                      lightFactor, Colors.pink.shade400,
                                      isTopSegment: remFactor == 0.0),
                                  _buildSegment(deepFactor, Colors.purple,
                                      isBottomSegment: true),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "$day",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: provider.selectedWeekDayIndex == index
                              ? Colors.white
                              : Colors.white70,
                          fontSize: 12,
                          fontWeight: provider.selectedWeekDayIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      // Add a SizedBox for spacing under the day
                      SizedBox(height: 16), // Adjust the height as needed
                    ],
                  ),
                );
              }),
            ),
          ),

          // Dashed ideal sleep lines with hour labels on the right side
          if (widget.minIdealSleep != null)
            Positioned(
              top: (chartHeight - (widget.minIdealSleep! * oneHourHeight))
                  .clamp(0.0, chartHeight),
              left: 0,
              right: 0,
              child: CustomPaint(
                painter: DashedLinePainter(color: Colors.white),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      '${widget.minIdealSleep!.toStringAsFixed(1)} hrs',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.maxIdealSleep != null)
            Positioned(
              top: (chartHeight - (widget.maxIdealSleep! * oneHourHeight))
                  .clamp(0.0, chartHeight),
              left: 0,
              right: 0,
              child: CustomPaint(
                painter: DashedLinePainter(color: Colors.white),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Text(
                      '${widget.maxIdealSleep!.toStringAsFixed(1)} hrs',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSegment(double factor, Color color,
      {bool isTopSegment = false, bool isBottomSegment = false}) {
    // Ensure factor is a finite number; otherwise, set it to 0
    final int flexFactor = factor.isFinite ? (factor * 100).round() : 0;

    return Expanded(
      flex: flexFactor,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.vertical(
            top: isTopSegment ? Radius.circular(8) : Radius.zero,
            bottom: isBottomSegment ? Radius.circular(8) : Radius.zero,
          ),
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter(
      {this.color = Colors.white, this.dashWidth = 5.0, this.dashSpace = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

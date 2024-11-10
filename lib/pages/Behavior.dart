import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_color.utils.dart';
import '../widgets/Behavior/behavior_header.dart';
import '../widgets/Behavior/drink_selection.dart';
import '../widgets/Behavior/stress_form.dart';
import '../widgets/Behavior/ExerciseForm.dart'; // Import the ExerciseForm

class BehaviorWidget extends StatefulWidget {
  final token;

  const BehaviorWidget({super.key, required this.token});

  @override
  State<BehaviorWidget> createState() => _BehaviorWidgetState();
}

class _BehaviorWidgetState extends State<BehaviorWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DrinkEntry> drinkEntries = [];
  bool? pregnancyStatus;
  bool showPregnancyOption = true;

  SharedPreferences? prefs;
  String? token;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    _tabController = TabController(length: 3, vsync: this);
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    token = widget.token.isNotEmpty ? widget.token : prefs?.getString('token');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleDrinkSelectionsChanged(List<DrinkEntry> entries) {
    setState(() {
      drinkEntries = entries;
    });
    print('Updated drink entries: $drinkEntries');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const BehaviorHeader(),
                SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Daily'),
                    Tab(text: 'Weekly'),
                    Tab(text: 'Monthly'),
                  ],
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Daily Section Content
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Add padding of 16 pixels
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                DrinkSelectionWidget(
                                  onDrinkSelectionsChanged:
                                      _handleDrinkSelectionsChanged,
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Weekly Section Content
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Add padding of 16 pixels
                          child: SingleChildScrollView(
                            child:
                                ExerciseForm(), // Use the ExerciseForm widget
                          ),
                        ),
                      ),
                      // Monthly Section Content
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: MonthlyStressForm(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

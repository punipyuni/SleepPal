import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleeppal_update/pages/MainScreen.dart';
import 'package:sleeppal_update/pages/chatGPT.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';

class ScoresOverviewScreen extends StatefulWidget {
  const ScoresOverviewScreen({Key? key}) : super(key: key);

  @override
  _ScoresOverviewScreenState createState() => _ScoresOverviewScreenState();
}

class _ScoresOverviewScreenState extends State<ScoresOverviewScreen> {
  bool _hasCompletedForm = false;

  @override
  void initState() {
    super.initState();
    _checkFormCompletion();
  }

  Future<void> _checkFormCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    final stressLevel = prefs.getString('lastStressLevel');
    final caffeineIntake = prefs.getInt('dailyCaffeineIntake');
    final exerciseLevel = prefs.getString('lastExerciseLevel');

    setState(() {
      _hasCompletedForm = stressLevel != null && 
                         caffeineIntake != null && 
                         exerciseLevel != null &&
                         stressLevel != "Not measured" &&
                         exerciseLevel != "Not measured";
    });
  }

  Future<void> _refreshData() async {
    await _checkFormCompletion();
    setState(() {});
  }

  void _showFormAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complete Form Required'),
          content: Text('Please complete the behavior form first to get personalized recommendations.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // You can add navigation to the form page here if needed
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              children: [
                ScoreOverView(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildScoreCard(),
                      SizedBox(height: 20),
                      ElevatedButton(
  onPressed: _hasCompletedForm 
    ? () async {
        final prefs = await SharedPreferences.getInstance();
        final metrics = {
          'stressLevel': prefs.getString('lastStressLevel'),
          'caffeineIntake': prefs.getInt('dailyCaffeineIntake'),
          'exerciseLevel': prefs.getString('lastExerciseLevel'),
        };
        
        // Store metrics in SharedPreferences for ChatGPT to access
        await prefs.setString('pendingChatMetrics', metrics.toString());
        
        // Navigate to MainScreen with ChatGPT (index 0) selected
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              token: prefs.getString('token') ?? '',
              initialIndex: 0,  // Index 0 is ChatGPT in your MainScreen
            ),
          ),
        );
      }
    : _showFormAlert,
  child: Text(
    'See Recommendations',
    style: TextStyle(color: Colors.white),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: _hasCompletedForm 
      ? Color(0xFF6A7BFF)
      : Colors.grey,
    padding: EdgeInsets.symmetric(vertical: 16),
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

Widget _buildScoreCard() {
  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      final prefs = snapshot.data!;
      final stressLevel = prefs.getString('lastStressLevel') ?? "Not measured";
      final caffeineIntake = prefs.getInt('dailyCaffeineIntake') ?? 0;
      final exerciseLevel =
          prefs.getString('lastExerciseLevel') ?? "Not measured";

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Behavior Metrics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _buildMetricTile(
              icon: Icons.mood,
              label: 'Stress Level',
              value: stressLevel,
            ),
            SizedBox(height: 15),
            _buildMetricTile(
              icon: Icons.local_cafe,
              label: 'Daily Caffeine Intake',
              value: '$caffeineIntake mg',
            ),
            SizedBox(height: 15),
            _buildMetricTile(
              icon: Icons.fitness_center,
              label: 'Weekly Exercise',
              value: exerciseLevel,
            ),
            
          ],
        ),
      );
    },
  );
}

Widget _buildMetricTile({
  required IconData icon,
  required String label,
  required String value,
}) {
  // Format caffeine value if it's the caffeine metric
  if (label == 'Daily Caffeine Intake') {
    // Check if the value is "0 mg" (default) or has actual data
    if (value == '0 mg') {
      value = 'Not measured';
    }
  }
  return Row(
    children: [
      Icon(
        icon,
        color: Colors.white70,
        size: 28,
      ),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class ScoreOverView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate back to SleepScreen
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 16),
          Text(
            'Behavior Score Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleeppal_update/pages/MainScreen.dart';
import 'package:sleeppal_update/pages/Relax.dart';
import 'package:sleeppal_update/pages/Score_overview.dart';

class MonthlyStressForm extends StatefulWidget {
  const MonthlyStressForm({Key? key}) : super(key: key);

  @override
  State<MonthlyStressForm> createState() => _MonthlyStressFormState();
}

class _MonthlyStressFormState extends State<MonthlyStressForm> {
  final List<int> _answers = List<int>.filled(5, 0);
  bool _isSubmitted = false;
  String _stressLevel = "Low stress";

  @override
  void initState() {
    super.initState();
    _loadLastSubmissionData();
  }

  Future<void> _loadLastSubmissionData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? lastStressLevel = prefs.getString('lastStressLevel');
  List<int> answers = [];
  
  // Load each answer from SharedPreferences
  for (int i = 0; i < _answers.length; i++) {
    answers.add(prefs.getInt('stressAnswer$i') ?? 0);
  }

  setState(() {
    _isSubmitted = lastStressLevel != null;
    _stressLevel = lastStressLevel ?? "Low stress";
    for (int i = 0; i < _answers.length; i++) {
      _answers[i] = answers[i];
    }
  });
}


  void _calculateScore() {
    int totalScore = _answers[0] + _answers[1] + (4 - _answers[2]) + _answers[3] + _answers[4];
    _setStressLevel(totalScore);
  }

  void _setStressLevel(int score) {
    if (score >= 0 && score <= 6) {
      _stressLevel = "Low stress";
    } else if (score >= 7 && score <= 13) {
      _stressLevel = "Moderate stress";
    } else if (score >= 14 && score <= 20) {
      _stressLevel = "High stress";
    }
  }

  Future<void> _handleSubmit() async {
  _calculateScore();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  await prefs.setString('lastStressLevel', _stressLevel);
  
  // Save each answer to SharedPreferences
  for (int i = 0; i < _answers.length; i++) {
    await prefs.setInt('stressAnswer$i', _answers[i]);
  }

  setState(() {
    _isSubmitted = true;
  });
}

  void _handleEdit() async {
  await _loadLastSubmissionData();
  setState(() {
    _isSubmitted = false;
  });
}


  Widget _buildQuestion(String questionText, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionText,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (optionIndex) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _answers[index] = optionIndex;
                });
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  color: _answers[index] == optionIndex ? Colors.blue : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    "$optionIndex",
                    style: TextStyle(
                      color: _answers[index] == optionIndex ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Thank you for submitting!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            "Your stress level is: $_stressLevel",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          if (_stressLevel == "High stress")
            Column(
              children: [
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RelaxingMusic()
                      ),
                    );
                  },
                  child: Text("Relaxing Sound"),
                ),
              ],
            ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleEdit,
            child: Text("Edit"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScoresOverviewScreen(),
            ),
          );
        },
        child: Text("See All Scores"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6A7BFF),
          foregroundColor: Colors.white,
        ),
      ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "For each question, choose from the following alternatives:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("0 - Never", style: TextStyle(fontSize: 12, color: Colors.white70)),
              SizedBox(width: 16),
              Text("1 - Almost Never", style: TextStyle(fontSize: 12, color: Colors.white70)),
              SizedBox(width: 16),
              Text("2 - Sometimes", style: TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("3 - Fairly Often", style: TextStyle(fontSize: 12, color: Colors.white70)),
              SizedBox(width: 16),
              Text("4 - Very Often", style: TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
          SizedBox(height: 20),
          _buildQuestion("How often have you been upset because of something unexpected?", 0),
          _buildQuestion("How often have you felt nervous and stressed?", 1),
          _buildQuestion("How often have you felt confident about your ability to handle your personal problems?", 2),
          _buildQuestion("How often have you found that you could not cope with everything you had to do?", 3),
          _buildQuestion("How often have difficulties felt too high to overcome?", 4),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: Text("Submit", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6A7BFF),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

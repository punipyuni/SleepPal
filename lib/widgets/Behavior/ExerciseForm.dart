import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleeppal_update/widgets/Stats/sleep_stat_provider.dart';

class ExerciseForm extends StatefulWidget {
  const ExerciseForm({Key? key}) : super(key: key);

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  TextEditingController _moderateExerciseController = TextEditingController();
  TextEditingController _intenseExerciseController = TextEditingController();
  int _muscleStrengtheningDays = 0;
  String _exerciseType = "Moderate Exercise";
  String _exerciseLevel = "Low";
  bool _isSubmitted = false;
  int? _userAge;

  @override
  void initState() {
    super.initState();
    _loadLastSubmissionData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userAge = Provider.of<SleepStatisticsProvider>(context).userAge;
  }

  Future<void> _loadLastSubmissionData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? lastExerciseLevel = prefs.getString('lastExerciseLevel');
  int? moderateMinutes = prefs.getInt('moderateExerciseMinutes');
  int? intenseMinutes = prefs.getInt('intenseExerciseMinutes');
  int? muscleDays = prefs.getInt('muscleStrengtheningDays');

  setState(() {
    _isSubmitted = lastExerciseLevel != null;
    _exerciseLevel = lastExerciseLevel ?? "Low";
    _moderateExerciseController.text = (moderateMinutes ?? 0).toString();
    _intenseExerciseController.text = (intenseMinutes ?? 0).toString();
    _muscleStrengtheningDays = muscleDays ?? 0;
  });
}


  void _calculateExerciseLevel() {
  if (_userAge == null) {
    setState(() {
      _exerciseLevel = "Unable to calculate - Age not provided";
    });
    return;
  }

  // Parse exercise minutes, default to 0 if parsing fails
  int moderateMinutes = int.tryParse(_moderateExerciseController.text) ?? 0;
  int intenseMinutes = int.tryParse(_intenseExerciseController.text) ?? 0;
  
  setState(() {
    if (_userAge! >= 6 && _userAge! <= 17) {
      // Children and adolescents (6-17 years)
      bool meetsMinutesRequirement = (moderateMinutes + intenseMinutes) >= 420; // 60 minutes daily
      bool meetsVigorousRequirement = intenseMinutes >= 180; // Vigorous activity at least 3 days
      bool meetsMuscleRequirement = _muscleStrengtheningDays >= 3; // Muscle strengthening 3 days
      
      if (meetsMinutesRequirement && meetsVigorousRequirement && meetsMuscleRequirement) {
        _exerciseLevel = "Meets Recommendations";
      } else {
        List<String> missingRequirements = [];
        if (!meetsMinutesRequirement) {
          missingRequirements.add("Need 60 minutes daily of activity");
        }
        if (!meetsVigorousRequirement) {
          missingRequirements.add("Need more vigorous activity (at least 3 days)");
        }
        if (!meetsMuscleRequirement) {
          missingRequirements.add("Need more muscle strengthening (at least 3 days)");
        }
        _exerciseLevel = "Below Recommendations: ${missingRequirements.join(', ')}";
      }
    } else if (_userAge! >= 18 && _userAge! <= 64) {
      // Adults (18-64 years)
      bool meetsMinutesRequirement = moderateMinutes >= 150 || 
                                   (moderateMinutes + (intenseMinutes * 2) >= 150); // Intense counts double
      bool meetsMuscleRequirement = _muscleStrengtheningDays >= 2;
      
      if (meetsMinutesRequirement && meetsMuscleRequirement) {
        _exerciseLevel = "Meets Recommendations";
      } else {
        List<String> missingRequirements = [];
        if (!meetsMinutesRequirement) {
          missingRequirements.add("Need 150 minutes of moderate activity per week");
        }
        if (!meetsMuscleRequirement) {
          missingRequirements.add("Need muscle strengthening at least 2 days per week");
        }
        _exerciseLevel = "Below Recommendations: ${missingRequirements.join(', ')}";
      }
    } else {
      // Age outside of specified ranges
      _exerciseLevel = "Age outside of specified ranges (6-64 years)";
    }
  });
}

Future<void> _handleSubmit() async {
  _calculateExerciseLevel();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastExerciseLevel', _exerciseLevel);

  int moderateMinutes = int.tryParse(_moderateExerciseController.text.trim()) ?? 0;
  int intenseMinutes = int.tryParse(_intenseExerciseController.text.trim()) ?? 0;
  await prefs.setInt('moderateExerciseMinutes', moderateMinutes);
  await prefs.setInt('intenseExerciseMinutes', intenseMinutes);
  await prefs.setInt('muscleStrengtheningDays', _muscleStrengtheningDays);

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
            "Your exercise frequency is: $_exerciseLevel",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleEdit,
            child: Text("Edit", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
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
            "Type of exercise per week",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 8),
          DropdownButton<String>(
            value: _exerciseType,
            dropdownColor: Colors.grey,
            onChanged: (String? newValue) {
              setState(() {
                _exerciseType = newValue!;
              });
            },
            items: <String>[
              "Moderate Exercise",
              "Intense Exercise",
              "Moderate and Intense Exercise"
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            isExpanded: true,
            underline: SizedBox(),
            iconEnabledColor: Colors.white,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          if (_exerciseType == "Moderate Exercise" || _exerciseType == "Moderate and Intense Exercise")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Time for moderate exercise (minutes)",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _moderateExerciseController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter minutes',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          if (_exerciseType == "Intense Exercise" || _exerciseType == "Moderate and Intense Exercise")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Time for intense exercise (minutes)",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _intenseExerciseController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter minutes',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 16),
          Text(
            "Muscle strengthening times",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<int>(
              value: _muscleStrengtheningDays,
              dropdownColor: Colors.grey,
              onChanged: (int? newValue) {
                setState(() {
                  _muscleStrengtheningDays = newValue!;
                });
              },
              items: List.generate(8, (index) => index)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    "$value times",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              iconEnabledColor: Colors.white,
              style: TextStyle(color: Colors.white),
            ),
          ),
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

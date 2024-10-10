import 'package:flutter/material.dart';

class BehaviorForm extends StatefulWidget {
  BehaviorForm({Key? key}) : super(key: key);

  @override
  BehaviorFormState createState() => BehaviorFormState();
}

class BehaviorFormState extends State<BehaviorForm> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'During the past month, what time have you usually gone to bed at night?',
      'inputType': 'time',
      'selected': '',
    },
    {
      'question': 'During the past month, how long (in minutes) has it usually taken you to fall asleep each night?',
      'inputType': 'number',
      'selected': '',
    },
    {
      'question': 'During the past month, what time have you usually gotten up in the morning?',
      'inputType': 'time',
      'selected': '',
    },
    {
      'question': 'During the past month, how many hours of actual sleep did you get at night?',
      'inputType': 'number',
      'selected': '',
    },
    {
      'question': 'During the past month, Cannot get to sleep within 30 minutes',
      'options': ['Not during the past month', 'Less than once a week', 'Once or twice a week', 'Three or more times a week'],
      'selected': '',
    },
    {
      'question': 'During the past month, Cannot breathe comfortably',
      'options': ['Not during the past month', 'Less than once a week', 'Once or twice a week', 'Three or more times a week'],
      'selected': '',
    },
    {
      'question': 'During the past month, Cough or snore loudly',
      'options': ['Not during the past month', 'Less than once a week', 'Once or twice a week', 'Three or more times a week'],
      'selected': '',
    },
    {
      'question': 'During the past month, Feel too cold',
      'options': ['Not during the past month', 'Less than once a week', 'Once or twice a week', 'Three or more times a week'],
      'selected': '',
    },
    {
      'question': 'During the past month, Feel too hot',
      'options': ['Not during the past month', 'Less than once a week', 'Once or twice a week', 'Three or more times a week'],
      'selected': '',
    },
    {
      'question': 'During the past month, Had bad dreams',
      'options': ['Not during the past month', 'Less than once a week', 'Once or twice a week', 'Three or more times a week'],
      'selected': '',
    },
    {
      'question': 'During the past month, Have pain',
      'options': ['Not during the past month', 'Less than once a week', 'Once or twice a week', 'Three or more times a week'],
      'selected': '',
    },
    {
      'question': 'During the past month, how would you rate your sleep quality overall?',
      'options': ['Very good', 'Fairly good', 'Fairly bad', 'Very bad'],
      'selected': '',
    },
    {
      'question': 'During the past month, how often have you taken medicine to help you sleep (prescribed or over the counter)?',
      'options': ['Not during the past month', 'Less than once a week', 'Once or twice a week', 'Three or more times a week'],
      'selected': '',
    },
    {
      'question': 'During the past month, how often have you had trouble staying awake while driving, eating meals, or engaging in social activity?',
      'options': ['Not during the past month', 'Less than once a week', 'Once or twice a week', 'Three or more times a week'],
      'selected': '',
    },
    {
      'question': 'During the past month, how much of a problem has it been for you to keep up enough enthusiasm to get things done?',
      'options': ['No problem at all', 'Only a very slight problem', 'Somewhat of a problem', 'A very big problem'],
      'selected': '',
    }
  ];

  Map<String, String> getSelectedBehaviors() {
    Map<String, String> selectedAnswers = {};
    for (var question in _questions) {
      selectedAnswers[question['question']] = question['selected'] ?? '';
    }
    return selectedAnswers;
  }

  int calculatePSQIScore() {
    int totalScore = 0;

    // Component 1: Subjective Sleep Quality
    int c1 = _getSleepQualityScore();

    // Component 2: Sleep Latency
    int c2 = _getSleepLatencyScore();

    // Component 3: Sleep Duration
    int c3 = _getSleepDurationScore();

    // Component 4: Habitual Sleep Efficiency
    int c4 = _getSleepEfficiencyScore();

    // Component 5: Sleep Disturbances
    int c5 = _getSleepDisturbancesScore();

    // Component 6: Use of Sleeping Medication
    int c6 = _getSleepMedicationScore();

    // Component 7: Daytime Dysfunction
    int c7 = _getDaytimeDysfunctionScore();

    totalScore = c1 + c2 + c3 + c4 + c5 + c6 + c7;
    return totalScore;
  }

  int _getSleepQualityScore() {
    String quality = _getAnswer('During the past month, how would you rate your sleep quality overall?');
    switch (quality) {
      case 'Very good': return 0;
      case 'Fairly good': return 1;
      case 'Fairly bad': return 2;
      case 'Very bad': return 3;
      default: return 0;
    }
  }

  int _getSleepLatencyScore() {
    int q2Score = _convertTimeToScore(_getAnswer('During the past month, how long (in minutes) has it usually taken you to fall asleep each night?'));
    int q5aScore = _convertFrequencyToScore(_getAnswer('During the past month, Cannot get to sleep within 30 minutes'));
    int sum = q2Score + q5aScore;
    if (sum == 0) return 0;
    if (sum <= 2) return 1;
    if (sum <= 4) return 2;
    return 3;
  }

  int _getSleepDurationScore() {
    double hours = double.tryParse(_getAnswer('During the past month, how many hours of actual sleep did you get at night?')) ?? 0;
    if (hours > 7) return 0;
    if (hours >= 6) return 1;
    if (hours >= 5) return 2;
    return 3;
  }

  int _getSleepEfficiencyScore() {
    String bedTime = _getAnswer('During the past month, what time have you usually gone to bed at night?');
    String wakeTime = _getAnswer('During the past month, what time have you usually gotten up in the morning?');
    double sleepHours = double.tryParse(_getAnswer('During the past month, how many hours of actual sleep did you get at night?')) ?? 0;

    double hoursInBed = _calculateHoursInBed(bedTime, wakeTime);
    double efficiency = (sleepHours / hoursInBed) * 100;

    if (efficiency >= 85) return 0;
    if (efficiency >= 75) return 1;
    if (efficiency >= 65) return 2;
    return 3;
  }

  int _getSleepDisturbancesScore() {
    List<String> disturbanceQuestions = [
      'Cannot breathe comfortably',
      'Cough or snore loudly',
      'Feel too cold',
      'Feel too hot',
      'Had bad dreams',
      'Have pain'
    ];

    int sum = disturbanceQuestions.fold(0, (sum, question) =>
        sum + _convertFrequencyToScore(_getAnswer('During the past month, $question')));

    if (sum == 0) return 0;
    if (sum <= 9) return 1;
    if (sum <= 18) return 2;
    return 3;
  }

  int _getSleepMedicationScore() {
    return _convertFrequencyToScore(_getAnswer('During the past month, how often have you taken medicine to help you sleep (prescribed or over the counter)?'));
  }

  int _getDaytimeDysfunctionScore() {
    int q8Score = _convertFrequencyToScore(_getAnswer('During the past month, how often have you had trouble staying awake while driving, eating meals, or engaging in social activity?'));
    int q9Score = _convertProblemToScore(_getAnswer('During the past month, how much of a problem has it been for you to keep up enough enthusiasm to get things done?'));
    int sum = q8Score + q9Score;
    if (sum == 0) return 0;
    if (sum <= 2) return 1;
    if (sum <= 4) return 2;
    return 3;
  }

  String _getAnswer(String question) {
    return _questions.firstWhere((q) => q['question'] == question)['selected'] ?? '';
  }

  int _convertTimeToScore(String minutes) {
    int mins = int.tryParse(minutes) ?? 0;
    if (mins <= 15) return 0;
    if (mins <= 30) return 1;
    if (mins <= 60) return 2;
    return 3;
  }

  int _convertFrequencyToScore(String frequency) {
    switch (frequency) {
      case 'Not during the past month': return 0;
      case 'Less than once a week': return 1;
      case 'Once or twice a week': return 2;
      case 'Three or more times a week': return 3;
      default: return 0;
    }
  }

  int _convertProblemToScore(String problem) {
    switch (problem) {
      case 'No problem at all': return 0;
      case 'Only a very slight problem': return 1;
      case 'Somewhat of a problem': return 2;
      case 'A very big problem': return 3;
      default: return 0;
    }
  }

  double _calculateHoursInBed(String bedTime, String wakeTime) {
    List<int> bedTimeParts = bedTime.split(':').map(int.parse).toList();
    List<int> wakeTimeParts = wakeTime.split(':').map(int.parse).toList();

    int bedMinutes = bedTimeParts[0] * 60 + bedTimeParts[1];
    int wakeMinutes = wakeTimeParts[0] * 60 + wakeTimeParts[1];

    if (wakeMinutes < bedMinutes) {
      wakeMinutes += 24 * 60;  // Add 24 hours if wake time is on the next day
    }

    return (wakeMinutes - bedMinutes) / 60.0;
  }

  bool validateForm() {
    for (var question in _questions) {
      if (question['inputType'] == null && (question['options'] != null && question['selected'] == '') ||
          (question['inputType'] != null && question['selected'] == '')
      ) {
        return false; // Return false if any question is unanswered
      }
    }
    return true; // All questions answered
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._questions.map((questionData) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questionData['question'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    if (questionData['inputType'] == 'time' || questionData['inputType'] == 'number')
                      TextField(
                        keyboardType: questionData['inputType'] == 'number'
                            ? TextInputType.number
                            : TextInputType.datetime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: questionData['inputType'] == 'time' ? 'Enter time' : 'Enter number',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            questionData['selected'] = value;
                          });
                        },
                      )
                    else
                      Column(
                        children: questionData['options'].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option, style: TextStyle(color: Colors.white)),
                            value: option,
                            groupValue: questionData['selected'],
                            onChanged: (String? value) {
                              setState(() {
                                questionData['selected'] = value!;
                              });
                            },
                            activeColor: Colors.white,
                          );
                        }).toList(),
                      ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (validateForm()) {
                  int psqiScore = calculatePSQIScore();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PSQI Score: $psqiScore')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields before submitting.')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
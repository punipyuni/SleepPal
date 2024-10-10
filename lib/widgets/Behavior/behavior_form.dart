import 'package:flutter/material.dart';

class BehaviorForm extends StatefulWidget {
  BehaviorForm({Key? key}) : super(key: key);

  @override
  BehaviorFormState createState() => BehaviorFormState();
}

class BehaviorFormState extends State<BehaviorForm> {
  // Updated List of behaviors/questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'During the past month, what time have you usually gone to bed at night?',
      'inputType': 'time', // Indicates time input field
      'selected': '',
    },
    {
      'question': 'During the past month, how long (in minutes) has it usually taken you to fall asleep each night?',
      'inputType': 'number', // Indicates number input field
      'selected': '',
    },
    {
      'question': 'During the past month, what time have you usually gotten up in the morning?',
      'inputType': 'time', // Indicates time input field
      'selected': '',
    },
    {
      'question': 'During the past month, how many hours of actual sleep did you get at night?',
      'inputType': 'number', // Indicates number input field
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
      'question': 'During the past month, Feel to hot',
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
      'options': ['Very good', 'Fairly good', 'Fairly bad', 'Very bad' ],
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

  // This method will return the selected answers for all questions
  Map<String, String> getSelectedBehaviors() {
    Map<String, String> selectedAnswers = {};
    for (var question in _questions) {
      selectedAnswers[question['question']] = question['selected'] ?? '';
    }
    return selectedAnswers;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Set background color to black
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _questions.map((questionData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionData['question'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Changed text color to white
                ),
                SizedBox(height: 8),
                if (questionData['inputType'] == 'time' || questionData['inputType'] == 'number') 
                  // Time or number input field
                  TextField(
                    keyboardType: questionData['inputType'] == 'number'
                        ? TextInputType.number
                        : TextInputType.datetime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: questionData['inputType'] == 'time' ? 'Enter time' : 'Enter number',
                      labelStyle: TextStyle(color: Colors.white), // Label text color
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)), // Border color when enabled
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)), // Border color when focused
                    ),
                    style: TextStyle(color: Colors.white), // Input text color
                    onChanged: (value) {
                      setState(() {
                        questionData['selected'] = value;
                      });
                    },
                  )
                else 
                  // Radio buttons for options
                  Column(
                    children: questionData['options'].map<Widget>((option) {
                      return RadioListTile<String>(
                        title: Text(option, style: TextStyle(color: Colors.white)), // Option text color
                        value: option,
                        groupValue: questionData['selected'],
                        onChanged: (value) {
                          setState(() {
                            questionData['selected'] = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
                Divider(thickness: 1, color: Colors.white), // Divider color
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
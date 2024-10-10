import 'package:flutter/material.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import 'package:sleeppal_update/widgets/Behavior/question.dart';


class BehaviorForm extends StatefulWidget {
  const BehaviorForm({Key? key}) : super(key: key);

  @override
  BehaviorFormState createState() => BehaviorFormState();
}

class BehaviorFormState extends State<BehaviorForm> {
  
  // Use imported behaviors and frequencies
  Map<String, int> selectedFrequencies = {};

  @override
  void initState() {
    super.initState();
    for (var behavior in behaviors) {
      selectedFrequencies[behavior] = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: behaviors.map((behavior) => _buildBehaviorItem(behavior)).toList(),
    );
  }

  Widget _buildBehaviorItem(String behavior) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            behavior,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            frequencies.length,
            (index) => _buildFrequencyOption(behavior, index),
          ),
        ),
        SizedBox(height: 16),
        Divider(color: Colors.white, thickness: 1), // Separator line
        SizedBox(height: 8), // Space after the line
      ],
    );
  }

  Widget _buildFrequencyOption(String behavior, int index) {
    bool isSelected = selectedFrequencies[behavior] == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFrequencies[behavior] = index;
        });
      },
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              color: isSelected ? Colors.white : Colors.transparent,
            ),
          ),
          SizedBox(height: 4),
          Text(
            frequencies[index],
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Method to get the current state of selections
  Map<String, String> getSelectedBehaviors() {
    Map<String, String> result = {};
    selectedFrequencies.forEach((behavior, index) {
      if (index != -1) {
        result[behavior] = frequencies[index];
      }
    });
    return result;
  }
}
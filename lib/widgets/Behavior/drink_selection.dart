import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrinkEntry {
  String drinkType;
  double amount;
  double caffeineContent;

  DrinkEntry({
    required this.drinkType,
    required this.amount,
    this.caffeineContent = 0.0,
  });
}

class DrinkSelectionWidget extends StatefulWidget {
  final Function(List<DrinkEntry>) onDrinkSelectionsChanged;
  final int? age;
  final String? gender;
  final bool? isPregnant;

  const DrinkSelectionWidget({
    Key? key,
    required this.onDrinkSelectionsChanged,
    this.age,
    this.gender,
    this.isPregnant,
  }) : super(key: key);

  @override
  _DrinkSelectionWidgetState createState() => _DrinkSelectionWidgetState();
}

class _DrinkSelectionWidgetState extends State<DrinkSelectionWidget> {
  List<DrinkEntry> drinkEntries = [
    DrinkEntry(drinkType: 'Espresso', amount: 240.0)
  ];
  bool isSubmitted = false;
  double savedScore = 0.0;
  String caffeineLevel = "Level -";

  final Map<String, double> caffeineContentPerMl = {
    'Espresso': 2.1,       // ~63 mg per 30 ml
    'Drip Coffee': 0.4,    // ~95 mg per 240 ml
    'Cold Brew': 0.6,      // ~175 mg per 300 ml
    'Instant Coffee': 0.25, // ~60 mg per 240 ml
    'Decaf Coffee': 0.0146, // ~3.5 mg per 240 ml
    'Black Tea': 0.23,     // ~55 mg per 240 ml
    'Green Tea': 0.135,    // ~32.5 mg per 240 ml
    'Herbal Tea': 0.0,
    'Coca Cola': 0.12,     // ~35 mg per 300 ml
    'Diet Cola': 0.133,    // ~40 mg per 300 ml
    'Mountain Dew': 0.18,  // ~54 mg per 300 ml
    'Red Bull': 0.31,      // ~80 mg per 250 ml
    'Monster': 0.33,       // ~160 mg per 500 ml
  };

  @override
  void initState() {
    super.initState();
    _loadSubmissionStatus();
  }

  @override
  void didUpdateWidget(covariant DrinkSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.age != widget.age ||
        oldWidget.gender != widget.gender ||
        oldWidget.isPregnant != widget.isPregnant) {
      double totalCaffeine = _calculateTotalCaffeine();
      _calculateCaffeineLevel(totalCaffeine);
    }
  }

  Future<void> _loadSubmissionStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? lastSubmissionDateString = prefs.getString('drinkSelectionLastSubmissionDate');
  double? score = prefs.getDouble('drinkSelectionTotalCaffeineScore');
  String? savedCaffeineLevel = prefs.getString('drinkSelectionCaffeineLevel');
  int currentDate = DateTime.now().day;

  // Load saved drink entries
  int drinkEntryCount = prefs.getInt('drinkEntryCount') ?? 0;
  List<DrinkEntry> savedDrinkEntries = [];
  for (int i = 0; i < drinkEntryCount; i++) {
    String? drinkType = prefs.getString('drinkEntryType$i');
    double amount = prefs.getDouble('drinkEntryAmount$i') ?? 0.0;
    if (drinkType != null) {
      savedDrinkEntries.add(DrinkEntry(drinkType: drinkType, amount: amount));
    }
  }

  print('Loaded last submission date: $lastSubmissionDateString');
  print('Loaded caffeine intake score: $score');
  print('Loaded caffeine level: $savedCaffeineLevel');

  setState(() {
    if (lastSubmissionDateString != null &&
        int.parse(lastSubmissionDateString) == currentDate) {
      isSubmitted = true;
      savedScore = score ?? 0.0;
      caffeineLevel = savedCaffeineLevel ?? "Level -";
    }
    drinkEntries = savedDrinkEntries.isNotEmpty ? savedDrinkEntries : drinkEntries;
  });
}



 Future<void> _saveSubmissionStatus(double totalCaffeine) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int currentDate = DateTime.now().day;

  await prefs.setString('drinkSelectionLastSubmissionDate', currentDate.toString());
  await prefs.setDouble('drinkSelectionTotalCaffeineScore', totalCaffeine);
  await prefs.setString('drinkSelectionCaffeineLevel', caffeineLevel);
  await prefs.setInt('dailyCaffeineIntake', totalCaffeine.round());

  // Save each drink entry
  await prefs.setInt('drinkEntryCount', drinkEntries.length);
  for (int i = 0; i < drinkEntries.length; i++) {
    await prefs.setString('drinkEntryType$i', drinkEntries[i].drinkType);
    await prefs.setDouble('drinkEntryAmount$i', drinkEntries[i].amount);
  }

  print('Saved caffeine intake score: $totalCaffeine');
  print('Saved caffeine level: $caffeineLevel');

  setState(() {
    isSubmitted = true;
    savedScore = totalCaffeine;
  });
}



  void _updateCaffeineContent() {
    setState(() {
      for (var entry in drinkEntries) {
        double caffeinePerMl = caffeineContentPerMl[entry.drinkType] ?? 0.0;
        entry.caffeineContent = caffeinePerMl * entry.amount;
      }
    });
  }

  double _calculateTotalCaffeine() {
    _updateCaffeineContent();
    return drinkEntries.fold(0, (sum, entry) => sum + entry.caffeineContent);
  }

  void _calculateCaffeineLevel(double totalCaffeine) {
    double acceptableDailyIntake = 400;

    if (widget.age != null && widget.age! < 3) {
      caffeineLevel = "Level -";
      return;
    } else if (widget.age != null && widget.age! >= 3 && widget.age! < 10) {
      acceptableDailyIntake = 5.7;
    } else if (widget.age != null && widget.age! >= 10 && widget.age! < 18) {
      acceptableDailyIntake = 5.7;
    } else if (widget.age != null && widget.age! >= 18) {
      if (widget.gender == "Female" && widget.isPregnant == true) {
        acceptableDailyIntake = 0;
      }
    }

    if (totalCaffeine <= acceptableDailyIntake * 0.5) {
      caffeineLevel = "Low";
    } else if (totalCaffeine <= acceptableDailyIntake) {
      caffeineLevel = "Moderate";
    } else {
      caffeineLevel = "High";
    }

    setState(() {
      caffeineLevel = caffeineLevel;
    });
  }

  void _handleSubmit() async {
    double totalCaffeine = _calculateTotalCaffeine();
    _calculateCaffeineLevel(totalCaffeine);
    await _saveSubmissionStatus(totalCaffeine);
  }

 void _handleEdit() async {
  await _loadSubmissionStatus();
  setState(() {
    isSubmitted = false;
  });
}



  @override
  Widget build(BuildContext context) {
    if (isSubmitted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Thank you for submitting!",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              "Your total caffeine intake is: ${savedScore.toStringAsFixed(2)} mg",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              "Caffeine Level: $caffeineLevel",
              style: TextStyle(fontSize: 16, color: Colors.white),
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
          ],
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: drinkEntries.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 4.0, bottom: 15.0, right: 0.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: drinkEntries[index].drinkType,
                          dropdownColor: Colors.grey[800],
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Drink Type',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          items:
                              caffeineContentPerMl.keys.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              drinkEntries[index].drinkType = newValue!;
                              _updateCaffeineContent();
                            });
                            widget.onDrinkSelectionsChanged(drinkEntries);
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<double>(
                          value: drinkEntries[index].amount,
                          dropdownColor: Colors.grey[800],
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Amount (ml)',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          items:
                              [120.0, 240.0, 355.0, 473.0, 591.0].map((double amount) {
                            return DropdownMenuItem<double>(
                              value: amount,
                              child: Text('${amount.toStringAsFixed(1)} ml'),
                            );
                          }).toList(),
                          onChanged: (double? newValue) {
                            setState(() {
                              drinkEntries[index].amount = newValue!;
                              _updateCaffeineContent();
                            });
                            widget.onDrinkSelectionsChanged(drinkEntries);
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            drinkEntries.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          icon: Icon(Icons.add, color: Colors.white),
          label: Text('Add Drink', style: TextStyle(color: Colors.white)),
          onPressed: () {
            setState(() {
              drinkEntries.add(DrinkEntry(drinkType: 'Espresso', amount: 240.0));
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6A7BFF)),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text('Submit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6A7BFF),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

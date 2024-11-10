import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/app_color.utils.dart';
import '../const.dart';
import '../pages/mainscreen.dart';

class GettingStartedPage extends StatefulWidget {
  final token;

  const GettingStartedPage({required this.token, Key? key}) : super(key: key);

  @override
  _GettingStartedPageState createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends State<GettingStartedPage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  DateTime? birthday;
  String? gender;
  String? pregnancyStatus = '-';
  int currentPage = 0;
  final PageController _pageController = PageController();

  Future<void> _saveProfileData() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Prepare the data
      final Map<String, dynamic> profileData = {
        'weight': weightController.text,
        'height': heightController.text,
        'gender': gender,
        'birthday': birthday?.toIso8601String(),
      };

      // Only include pregnancy status if user is female
      if (gender == 'Female') {
        profileData['pregnancy'] = pregnancyStatus;
      }

      print('Sending profile data: $profileData'); // Debug print
      print('Token: ${widget.token}'); // Debug print

      final response = await http.put(
        Uri.parse('$url/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode(profileData),
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      // Pop loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      if (response.statusCode == 200) {
        // Save that the user has completed onboarding
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding_completed', true);

        // Navigate to main screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(token: widget.token),
            ),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving profile data: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Pop loading dialog if there's an error
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error saving profile data: $e'); // Debug print
    }
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildWelcomePage();
      case 1:
        return _buildBirthdayPage();
      case 2:
        return _buildHeightWeightPage();
      case 3:
        return _buildGenderPage();
      default:
        return Container();
    }
  }

  Widget _buildWelcomePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
                'assets/images/sleeppal.png',
                width: 300,
                height: 300,
              ),
          const Text(
            'Welcome to SleepPal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Let\'s get to know you better to provide personalized sleep recommendations',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdayPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cake, color: Colors.white, size: 60),
          const SizedBox(height: 20),
          const Text(
            'When were you born?',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  birthday = picked;
                });
              }
            },
            child: Text(
              birthday != null
                  ? DateFormat('MMMM dd, yyyy').format(birthday!)
                  : 'Select your birthday',
              style: TextStyle(
                color: birthday != null ? Colors.white : Colors.white70,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightWeightPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your measurements',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, color: Colors.white, size: 60),
          const SizedBox(height: 20),
          const Text(
            'What\'s your gender?',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 30),
          Column(
            children: ['Male', 'Female', 'Other'].map((String value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        gender == value ? Colors.white : Colors.white24,
                    minimumSize: const Size(200, 50),
                  ),
                  onPressed: () {
                    setState(() {
                      gender = value;
                      if (gender != 'Female') {
                        pregnancyStatus = '-';
                      }
                    });
                  },
                  child: Text(
                    value,
                    style: TextStyle(
                      color: gender == value ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (gender == 'Female')
            Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Are you pregnant?',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['Yes', 'No'].map((String value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pregnancyStatus == value
                              ? Colors.white
                              : Colors.white24,
                          minimumSize: const Size(100, 40),
                        ),
                        onPressed: () {
                          setState(() {
                            pregnancyStatus = value;
                          });
                        },
                        child: Text(
                          value,
                          style: TextStyle(
                            color: pregnancyStatus == value
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildPage(index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentPage > 0)
                      TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Back',
                            style: TextStyle(color: Colors.white70)),
                      )
                    else
                      const SizedBox(width: 80),
                    Row(
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Colors.white
                                : Colors.white38,
                          ),
                        ),
                      ),
                    ),
                    if (currentPage < 3)
                      TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Next',
                            style: TextStyle(color: Colors.white)),
                      )
                    else
                      TextButton(
                        onPressed: _canProceed() ? _saveProfileData : null,
                        child: Text('Get Started',
                            style: TextStyle(
                                color: _canProceed()
                                    ? Colors.white
                                    : Colors.white38)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canProceed() {
    bool hasValidMeasurements = weightController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        double.tryParse(weightController.text) != null &&
        double.tryParse(heightController.text) != null;
    bool hasValidBirthday = birthday != null;
    bool hasValidGender = gender != null;
    bool hasValidPregnancyStatus =
        gender != 'Female' || (gender == 'Female' && pregnancyStatus != '-');

    return hasValidMeasurements &&
        hasValidBirthday &&
        hasValidGender &&
        hasValidPregnancyStatus;
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
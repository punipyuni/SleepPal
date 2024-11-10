import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:sleeppal_update/widgets/Stats/sleep_stat_provider.dart';
import 'package:provider/provider.dart';
import '../utils/app_color.utils.dart';
import '../const.dart';

import '../auth/signup.auth.dart';

class ProfilePage extends StatefulWidget {
  final token;

  const ProfilePage({required this.token, super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String email;
  String? weight, height, gender = '-';
  String? pregnancyStatus = '-';
  DateTime? birthday;
  bool isEditing = false;

  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

   int calculateAge(DateTime birthday) {
    final DateTime today = DateTime.now();
    int age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }

  void _updateAgeInProvider(BuildContext context) {
  final age = birthday != null ? calculateAge(birthday!) : null;
  Provider.of<SleepStatisticsProvider>(context, listen: false).userAge = age;
}



  Future<void> _fetchProfileData() async {
  final userId = _extractUserIdFromToken(widget.token);
  final response = await http.get(Uri.parse('$url/profile'),
      headers: {'Authorization': 'Bearer ${widget.token}'});

  if (response.statusCode == 200) {
    final profileData = jsonDecode(response.body);
    setState(() {
      weight = profileData['weight'] ?? '-';
      height = profileData['height'] ?? '-';
      gender = profileData['gender'] ?? '-';
      birthday = profileData['birthday'] != null
          ? DateTime.parse(profileData['birthday'])
          : null;
      pregnancyStatus = profileData['pregnancy'] ?? '-';
      weightController.text = weight ?? '';
      heightController.text = height ?? '';

      // Calculate the user's age and pass it to the provider
      if (birthday != null) {
        int age = calculateAge(birthday!);
        Provider.of<SleepStatisticsProvider>(context, listen: false).userAge = age;
      }
    });
  } else {
    print("Error fetching profile data: ${response.statusCode}");
  }
}



  Future<void> _updateProfileData() async {
  final userId = _extractUserIdFromToken(widget.token);
  final response = await http.put(
    Uri.parse('$url/profile'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    },
    body: jsonEncode({
      'weight': weightController.text,
      'height': heightController.text,
      'gender': gender,
      'pregnancy': pregnancyStatus,
      'birthday': birthday?.toIso8601String(),
    }),
  );

  if (response.statusCode == 200) {
    // Update UI on success
    setState(() {
      weight = weightController.text;
      height = heightController.text;
    });

    // Update the provider with the new age after saving profile data
    int? updatedAge = birthday != null ? calculateAge(birthday!) : null;
    Provider.of<SleepStatisticsProvider>(context, listen: false).userAge = updatedAge;
  } else {
    // Handle update error
    print("Error updating profile data: ${response.statusCode}");
  }
}


  String _extractUserIdFromToken(String token) {
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken['_id'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.primaryBackgroundColor, // Example background color
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Profile image
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://img.freepik.com/premium-vector/business-man-icon-workshop-icon-set-flat-design-human-resources_956982-3510.jpg?semt=ais_hybrid"),
                  ),
                ),

                const SizedBox(height: 20),

                /// Email
                Center(
                  child: Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Age
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cake, color: Colors.white),
                    const SizedBox(width: 8),
                    isEditing
                        ? TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: birthday ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null && picked != birthday) {
                                setState(() {
                                  birthday = picked;
                                });
                              }
                            },
                            child: Text(
                                'Birthday: ${birthday != null ? DateFormat('yyyy-MM-dd').format(birthday!) : '-'}',
                                style: const TextStyle(color: Colors.white54)),
                          )
                        : Text(
                            'Age: ${birthday != null ? calculateAge(birthday!) : '?'}',
                            style: const TextStyle(color: Colors.white)),
                  ],
                ),

                const SizedBox(height: 10),

                /// Weight
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.fitness_center, color: Colors.white),
                    const SizedBox(width: 8),
                    isEditing
                        ? SizedBox(
                            width: 150,
                            child: TextField(
                              controller: weightController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                              onChanged: (value) {
                                setState(() {
                                  weight = value.isEmpty ? '-' : value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Enter weight',
                                labelStyle: TextStyle(color: Colors.white54),
                              ),
                            ),
                          )
                        : Text('Weight: ${weight ?? '-'}',
                            style: const TextStyle(color: Colors.white)),
                    const Text(' kg', style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 10),

                /// Height
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.height, color: Colors.white),
                    const SizedBox(width: 8),
                    isEditing
                        ? SizedBox(
                            width: 150,
                            child: TextField(
                              controller: heightController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false),
                              onChanged: (value) {
                                setState(() {
                                  height = value.isEmpty ? '-' : value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Enter height',
                                labelStyle: TextStyle(color: Colors.white54),
                              ),
                            ),
                          )
                        : Text('Height: ${height ?? '-'}',
                            style: const TextStyle(color: Colors.white)),
                    const Text(' cm', style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 10),

                /// Gender
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, color: Colors.white),
                    const SizedBox(width: 8),
                    isEditing
                        ? DropdownButton<String>(
                            value: gender == '-' ? null : gender,
                            dropdownColor:
                                Colors.blueGrey[800], // Example dropdown color
                            iconEnabledColor: Colors.white,
                            items: <String>['Male', 'Female', 'Other']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                gender = newValue!;
                                if (gender != 'Female') {
                                  pregnancyStatus =
                                      '-'; // Reset pregnancy status if gender is not Female
                                }
                              });
                            },
                          )
                        : Text(
                            'Gender: $gender',
                            style: const TextStyle(color: Colors.white),
                          ),
                  ],
                ),

                if ((gender == 'Female' || gender == 'Other') &&
                    (birthday == null || calculateAge(birthday!) >= 15))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pregnant_woman, color: Colors.white),
                      const SizedBox(width: 8),
                      isEditing
                          ? DropdownButton<String>(
                              value: pregnancyStatus == '-'
                                  ? null
                                  : pregnancyStatus,
                              dropdownColor: Colors.blueGrey[800],
                              iconEnabledColor: Colors.white,
                              items: <String>['Yes', 'No'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  pregnancyStatus = newValue!;
                                });
                              },
                            )
                          : Text(
                              'Pregnancy: $pregnancyStatus',
                              style: const TextStyle(color: Colors.white),
                            ),
                    ],
                  ),
                const SizedBox(height: 20),

                /// Edit Profile button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (isEditing) {
                        _updateProfileData();
                      }
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                    ),
                    child: Text(isEditing ? 'Save Changes' : 'Edit Profile'),
                  ),
                ),
                const SizedBox(height: 20),

                /// Sign Out button (only visible when not editing)
                if (!isEditing)
                  Center(
                    child: ElevatedButton(
                      onPressed: () => {
                        // Sign out logic
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        ),
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Sign Out',
                          style: TextStyle(color: Colors.white)),
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

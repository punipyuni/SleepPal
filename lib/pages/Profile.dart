import 'package:flutter/material.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import '../widgets/Profile/profile_header.dart'; // Replace with the actual path to your ProfileHeader widget

class ProfilePage extends StatelessWidget {
  final String email = 'user@example.com'; // Replace with actual user email
  final String profileImageUrl = 'https://example.com/profile.jpg'; // Replace with actual image URL
  final String weight = '70 kg'; // Replace with actual user weight
  final String height = '175 cm'; // Replace with actual user height
  final String bloodGroup = 'O+'; // Replace with actual user blood group

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Profile image
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                ),

                const SizedBox(height: 20),

                /// Email
                Center(
                  child: Text(
                    email, // Displaying the user's email
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Weight
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.fitness_center, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Weight: $weight',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Height
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.height, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Height: $height',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Blood Group
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bloodtype, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Blood Group: $bloodGroup',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Sign out button
                Center(
                  child: ElevatedButton(
                    onPressed: () => {
                      print('Sign out'),
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.alertButtonColor,
                    ),
                    child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
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
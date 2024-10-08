import 'package:flutter/material.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import '../widgets/Profile/profile_header.dart'; // Replace with the actual path to your ProfileHeader widget

class ProfilePage extends StatelessWidget {
  final String email = 'user@example.com'; // Replace with actual user email
  final String profileImageUrl = 'https://example.com/profile.jpg'; // Replace with actual image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProfileHeader(), // Use the ProfileHeader widget here
                SizedBox(height: 20),
                Center( // Center the following widgets within their own container
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                ),
                SizedBox(height: 20),
                Center( // Center the text as well
                  child: Text(
                    email,
                    style: TextStyle(fontSize: 18, color: Colors.white), // Optional: Change text color for better contrast
                  ),
                ),
                SizedBox(height: 20),
                Center( // Center the button too
                  child: ElevatedButton(
                    onPressed: () {
                      // Add sign out logic here
                      print('Sign out button pressed');
                    },
                    child: Text('Sign Out'),
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
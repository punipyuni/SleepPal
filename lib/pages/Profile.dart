import 'package:flutter/material.dart';
import '../widgets/Profile/profile_header.dart'; // Replace with the actual path to your ProfileHeader widget

class ProfilePage extends StatelessWidget {
  final String email = 'user@example.com'; // Replace with actual user email
  final String profileImageUrl = 'https://example.com/profile.jpg'; // Replace with actual image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-1.0, -0.8),
            radius: 1.3,
            colors: [
              Color(0xFF6C51A6), // Light purple
              Color(0xFF1A102E), // Darker shade
              Color(0xFF131417), // Almost black
            ],
            stops: [0.17, 0.56, 1.0],
          ),
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
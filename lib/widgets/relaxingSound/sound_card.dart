import 'package:flutter/material.dart';
import 'sound_card_list.dart';

class SoundCard extends StatelessWidget {
  final String title;
  final String category;
  final String subcategory;
  final String imageUrl;

  const SoundCard({
    Key? key,
    required this.title,
    required this.category,
    required this.subcategory,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Color(0xFF272D42), // Set the card color to #272D42
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Change text color to white
                ),
                SizedBox(height: 4),
                Text(
                  '$category\n$subcategory',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors
                          .white70), // Change text color to a lighter shade
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/forum_detail.dart';

class ForumPostWidget extends StatelessWidget {
  final String title;
  final String author;
  final String avatarUrl;

  const ForumPostWidget({
    Key? key,
    required this.title,
    required this.author,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              title: title,
              author: author,
              avatarUrl: avatarUrl,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8), // Add margin for spacing between posts
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12), // Increased space between title and author
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 20, // Slightly larger avatar for better visibility
                ),
                SizedBox(width: 12), // Increased space between avatar and author name
                Text(
                  author,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
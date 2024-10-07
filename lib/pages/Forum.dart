import 'package:flutter/material.dart';
import '../widgets/Forum/forum_header.dart';
import '../widgets/Forum/forum_post.dart';
import '../widgets/bottom_nav_bar.dart'; // Assuming you want to include the BottomNavBar
import '../pages/sleep.dart'; // Import other screens here as well

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
              children: [
                const ForumHeader(), // Assuming you have a header for the forum
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 10),
                    children: const [
                      ForumPostWidget(
                        title: 'How to sleep like a pro',
                        author: 'Yeji shii',
                        avatarUrl: 'https://example.com/yeji.jpg',
                      ),
                      ForumPostWidget(
                        title: 'Best sleep position',
                        author: 'Poin',
                        avatarUrl: 'https://example.com/poin.jpg',
                      ),
                      ForumPostWidget(
                        title: 'How to sleep in 2 minutes',
                        author: 'Pooh',
                        avatarUrl: 'https://example.com/pooh.jpg',
                      ),
                      ForumPostWidget(
                        title: "Don't do this before sleep",
                        author: 'Lil Marco',
                        avatarUrl: 'https://example.com/lilmarco.jpg',
                      ),
                      ForumPostWidget(
                        title: 'How can I have a better sleep',
                        author: 'uou',
                        avatarUrl: 'https://example.com/uou.jpg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for adding a new post
          // You can navigate to a new page or show a dialog here
          Navigator.pushNamed(context, '/createPost'); // Example route for creating a post
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
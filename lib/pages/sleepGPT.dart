import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import '../widgets/forum_header.dart';

class SleepGPT extends StatefulWidget {
  const SleepGPT({Key? key}) : super(key: key);

  @override
  State<SleepGPT> createState() => _SleepGPTState();
  
}

final ChatUser currentUser = ChatUser(id: '1', firstName: 'Nigga', lastName: '56');
final ChatUser gptChatUser = ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');
List<ChatMessage> messages = <ChatMessage>[];
class _SleepGPTState extends State<SleepGPT> {
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
                const ForumHeader(), // Include the ForumHeader widget
                DashChat(currentUser: currentUser, onSend: (ChatMessage m) {
                  getChatResponse(m);
                }, messages: messages)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async{

  }

}
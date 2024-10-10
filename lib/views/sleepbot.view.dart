import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For encoding/decoding JSON
import 'package:http/http.dart' as http;
import 'package:sleeppal_update/config.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart'; // For making HTTP requests

class SleepBot extends StatefulWidget {
  const SleepBot({super.key});

  @override
  State<SleepBot> createState() => _SleepBotState();
}

final ChatUser currentUser =
    ChatUser(id: '1', firstName: 'User', lastName: 'Name');
final ChatUser gptChatUser =
    ChatUser(id: '2', firstName: 'Sleep', lastName: 'Bot');
List<ChatMessage> messages = <ChatMessage>[];
List<ChatUser> typingUsers = <ChatUser>[];

class _SleepBotState extends State<SleepBot> {
  bool _showPromptButtons = true; // Control visibility of prompt buttons

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF121317),
        title: Text(
          'SleepBot',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: Stack(
          children: [
            DashChat(
              currentUser: currentUser,
              typingUsers: typingUsers,
              messageOptions: const MessageOptions(
                currentUserContainerColor: Color(0xFF6A7BFF),
                containerColor: Color(0xFF49516A),
                textColor: Colors.white,
              ),
              onSend: (ChatMessage m) {
                getChatResponse(m);
              },
              messages: messages,
            ),
            if (_showPromptButtons) // Show prompt buttons conditionally
              Positioned(
                bottom: 70, // Adjust this value as needed
                right: 16,
                child: _buildExpandedButtons(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedButtons() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.end,
            children: [
              _buildPromptButton("Sleep Quality", "How can I improve my sleep quality?"),
              _buildPromptButton("Bedtime Routines", "What are some bedtime routines for better sleep?"),
              _buildPromptButton("Diet and Sleep", "How does diet affect sleep?"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromptButton(String label, String prompt) {
    return ElevatedButton(
      onPressed: () {
        _sendPrompt(prompt);
        setState(() {
          _showPromptButtons = false; // Hide buttons after tap
        });
      },
      child: Text(
        label,
        style: TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6A7BFF),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size(100, 36),
      ),
    );
  }

  void _sendPrompt(String prompt) {
    ChatMessage message = ChatMessage(
      text: prompt,
      user: currentUser,
      createdAt: DateTime.now(),
    );
    getChatResponse(message);
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      messages.insert(0, m);
      typingUsers.add(gptChatUser);
    });

    List<Map<String, String>> messagesHistory = messages.reversed.map((m) {
      if (m.user == currentUser) {
        return {"role": "user", "content": m.text};
      } else {
        return {"role": "assistant", "content": m.text};
      }
    }).toList();

    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $openRouter_API_KEY',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'nousresearch/hermes-3-llama-3.1-405b:free',
        'messages': messagesHistory,
        'max_tokens': 200,
      }),
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var choices = responseBody['choices'] as List;

      for (var element in choices) {
        var content = element['message']['content'];
        if (content != null) {
          setState(() {
            messages.insert(
                0,
                ChatMessage(
                    user: gptChatUser,
                    createdAt: DateTime.now(),
                    text: content));
          });
        }
      }
      setState(() {
        typingUsers.remove(gptChatUser);
      });
    } else {
      print('Failed to fetch data from OpenRouter: ${response.statusCode}');
    }
  }
}
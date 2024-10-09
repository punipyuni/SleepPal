import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For encoding/decoding JSON
import 'package:http/http.dart' as http;
import 'package:sleeppal_update/const.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart'; // For making HTTP requests

class Chatgpt extends StatefulWidget {
  const Chatgpt({super.key});

  @override
  State<Chatgpt> createState() => _ChatgptState();
}

final ChatUser currentUser =
    ChatUser(id: '1', firstName: 'User', lastName: 'Name');
final ChatUser gptChatUser =
    ChatUser(id: '2', firstName: 'Sleep', lastName: 'Bot');
List<ChatMessage> messages = <ChatMessage>[];
List<ChatUser> typingUsers = <ChatUser>[];

class _ChatgptState extends State<Chatgpt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF121317),
        title: Text(
          'SleepBot',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: DashChat(
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
      ),
    );
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

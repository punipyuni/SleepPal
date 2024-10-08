import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;

import '../utils/app_color.utils.dart';
import '../config.dart';

class SleepGPTPage extends StatefulWidget {
  const SleepGPTPage({super.key});

  @override
  State<SleepGPTPage> createState() => _SleepGPTPageState();
}

final ChatUser currentUser =
    ChatUser(id: '1', firstName: 'User', lastName: 'Name');
final ChatUser gptChatUser =
    ChatUser(id: '2', firstName: 'Sleep', lastName: 'GPT');
List<ChatMessage> messages = <ChatMessage>[];

class _SleepGPTPageState extends State<SleepGPTPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF121317),
        title: const Text(
          'SleepGPT',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: DashChat(
          currentUser: currentUser,
          messageOptions: MessageOptions(
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
    } else {
      print('Failed to fetch data from OpenRouter: ${response.statusCode}');
    }
  }
}

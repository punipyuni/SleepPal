import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For encoding/decoding JSON
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:sleeppal/const.dart'; // Ensure you add your API key in this file

class Chatgpt extends StatefulWidget {
  const Chatgpt({super.key});

  @override
  State<Chatgpt> createState() => _ChatgptState();
}

// Replace OpenAI instance with a placeholder for OpenRouter API
final ChatUser currentUser =
    ChatUser(id: '1', firstName: 'Nigga', lastName: '56');
final ChatUser gptChatUser =
    ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');
List<ChatMessage> messages = <ChatMessage>[];

class _ChatgptState extends State<Chatgpt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('sleepGPT')),
        body: DashChat(
            currentUser: currentUser,
            messageOptions: const MessageOptions(
                currentUserContainerColor: Colors.black,
                containerColor: Colors.purple,
                textColor: Colors.white),
            onSend: (ChatMessage m) {
              getChatResponse(m);
            },
            messages: messages));
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

    // OpenRouter API call
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $openRouter_API_KEY', // Replace with your OpenRouter API key
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'nousresearch/hermes-3-llama-3.1-405b:free', // Adjust model if necessary
        'messages': messagesHistory,
        'max_tokens': 200, // Adjust token count based on your needs
      }),
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var choices = responseBody['choices'] as List;

      for (var element in choices) {
        var content = element['message']['content'];
        if (content != null) {
          setState(() {
            messages.insert(0, ChatMessage(
              user: gptChatUser, 
              createdAt: DateTime.now(), 
              text: content
            ));
          });
        }
      }
    } else {
      // Handle error response
      print('Failed to fetch data from OpenRouter: ${response.statusCode}');
    }
  }
}

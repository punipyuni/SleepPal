import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import '../utils/app_color.utils.dart';
import '../widgets/Behavior/behavior_header.dart';
import '../widgets/SleepBot/sleepBot_header.dart';

class Chatgpt extends StatefulWidget {
     final Map<String, dynamic>? behaviorMetrics;
  
  const Chatgpt({Key? key, this.behaviorMetrics}) : super(key: key);
  

  @override
  State<Chatgpt> createState() => _ChatgptState();
}

final ChatUser currentUser = ChatUser(id: '1', firstName: 'User', lastName: 'Name');
final ChatUser gptChatUser = ChatUser(id: '2', firstName: 'Sleep', lastName: 'Bot');
List<ChatMessage> messages = <ChatMessage>[];
List<ChatUser> typingUsers = <ChatUser>[];

class _ChatgptState extends State<Chatgpt> {
  bool _showPromptButtons = true;
  bool _isTyping = false; // Track if bot is typing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                const SleepbotHeader(),
                Expanded(
                  child: Stack(
                    children: [
                      DashChat(
                        currentUser: currentUser,
                        messageOptions: const MessageOptions(
                          currentUserContainerColor: Color(0xFF6A7BFF),
                          containerColor: Color(0xFF49516A),
                          textColor: Colors.white,
                        ),
                        onSend: (ChatMessage m) {
                          setState(() {
                            _showPromptButtons = false;
                          });
                          getChatResponse(m);
                        },
                        messages: messages,
                      ),
                      if (_showPromptButtons)
                        Positioned(
                          bottom: 70,
                          right: 16,
                          child: _buildExpandedButtons(),
                        ),
                      // Show typing indicator when bot is generating response
                      if (_isTyping)
                        Positioned(
                          bottom: 60,
                          left: 16,
                          child: TypingIndicator(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedButtons() {
  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return CircularProgressIndicator();
      }

      final prefs = snapshot.data!;
      final hasCompletedForm = prefs.getString('lastStressLevel') != null &&
                              prefs.getInt('dailyCaffeineIntake') != null &&
                              prefs.getString('lastExerciseLevel') != null;

      return Container(
        padding: const EdgeInsets.only(top: 10, right: 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.end,
            children: [
              _buildPromptButton("Sleep Quality", "How can I improve my sleep quality?"),
              if (hasCompletedForm) _buildPromptButton(
                "See Recommendation", 
                "Based on my metrics (Stress Level: ${prefs.getString('lastStressLevel')}, "
                "Caffeine Intake: ${prefs.getInt('dailyCaffeineIntake')}mg, "
                "Exercise Level: ${prefs.getString('lastExerciseLevel')}), "
                "refer to  my metrics what are your behavior recommendation?"
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildPromptButton(String label, String prompt) {
    return ElevatedButton(
      onPressed: () {
        _sendPrompt(prompt);
        setState(() {
          _showPromptButtons = false;
        });
      },
      child: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A7BFF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(100, 36),
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
      _isTyping = true; // Start typing indicator
    });

    try {
      List<Map<String, String>> messagesHistory = messages.reversed.map((m) {
        return m.user == currentUser
            ? {"role": "user", "content": m.text}
            : {"role": "assistant", "content": m.text};
      }).toList();

      // Add user context here
      // ignore: prefer_interpolation_to_compose_strings
      String userContext = "You are SleepBot, an AI designed to help users improve their sleep habits. Your task is to educate users on the importance of sleep, suggest ways to improve sleep quality, and guide them on how to deal with sleep problems. Always offer helpful advice in a friendly, empathetic, and supportive tone.\n\n"  
"Here are the main areas you should focus on:\n\n" 
"1. Importance of Sleep:\n"  
"- Explain why sleep is crucial for mental, physical, and emotional health.\n" 
"- Mention the recommended hours of sleep for different age groups (adults, teens, children).\n" 
"- Highlight the benefits of consistent, high-quality sleep for productivity, mood, and overall well-being.\n\n" 
"2. Healthy Sleep Habits:\n" 
"- Suggest establishing a consistent sleep schedule.\n" 
"- Offer advice on creating a bedtime routine to signal to the body that it’s time to wind down.\n" 
"- Encourage a sleep-friendly environment (dark, quiet, and cool).\n" 
"- Discuss the importance of limiting screen time before bed.\n\n" 
"3. Improving Sleep Quality:\n" 
"- Recommend avoiding caffeine or heavy meals late in the day.\n" 
"- Caffeine Intake Guidelines:\n" 
"  - Toddlers (12 to <36 months): No safe single dose recommended; mean intake is 5.9 mg/day.\n" 
"  - Other Children (3 to <10 years): Safe intake is 3 mg/kg body weight, up to 5.7 mg/kg per day.\n" 
"  - Adolescents (10 to <18 years): Similar to children, with 3 mg/kg body weight and 5.7 mg/kg per day.\n" 
"  - Adults (18 to <65 years): Safe single dose of 200 mg; daily limit of 400 mg.\n" 
"  - Elderly (65+ years): Same as adults, with 200 mg per dose and up to 400 mg per day.\n" 
"  - Pregnant Women: Recommended daily limit of 200 mg.\n" 
"- Suggest incorporating relaxation techniques (deep breathing, meditation, gentle stretches) before bed.\n" 
"- Talk about the importance of physical activity during the day to improve sleep.\n" 
"- Physical Activity Recommendations:\n" 
"  - Preschool-aged children (3-5 years): Physical activity throughout the day.\n" 
"  - Children and Adolescents (6-17 years): At least 60 minutes of moderate to vigorous activity daily, with muscle- and bone-strengthening activities on 3 days a week.\n" +
"  - Adults (18-64 years): 150 minutes of moderate activity per week, with muscle-strengthening activities on at least 2 days.\n" 
"  - Older Adults (65+ years): Similar to adults, with additional exercises for balance.\n" 
"  - Pregnant and Postpartum Women: 150 minutes of moderate-intensity aerobic activity per week.\n" 
"- Mention any sleep apps or tools that can track sleep patterns or help with relaxation.\n\n" 
"4. Sleep Problems:\n" 
"- Offer strategies to handle common issues like insomnia, difficulty falling asleep, or frequent waking.\n" 
"- Provide advice on sleep disorders (e.g., sleep apnea, restless leg syndrome) and suggest seeing a professional if needed.\n" 
"- Suggest sleep hygiene tips to address problems like sleep interruptions and poor sleep quality.\n\n" 
"5. Encouragement & Support:\n" 
"- Be patient and understanding if users are struggling with sleep-related issues.\n" 
"- Encourage small, manageable changes over time rather than drastic shifts.\n" 
"- Offer continuous motivation and reminders to stick to healthy habits.\n\n" 
"Always be kind, gentle, and non-judgmental in your responses. Your aim is to educate, guide, and provide only the 'SLEEPING' topic. If the user asks about non-related topics, respond with: 'I'm so sorry, but I'm here to only provide information about sleep and good habits for your better sleep.' and dont say anything more than that.";
 // Your personalized prompt
      
      final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $openRouter_API_KEY',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://yourapp.com',
          'X-Title': 'SleepPal Chat',
        },
        body: jsonEncode({
          // 'model': 'meta-llama/llama-3.2-3b-instruct:free',
          // 'model': 'nousresearch/hermes-3-llama-3.1-70b',
          'model':'nvidia/Llama-3.1-Nemotron-70B-Instruct-HF',
          'messages': [
            {"role": "system", "content": userContext}, // Inserted personalized prompt here
            ...messagesHistory,
          ],
          'max_tokens': 750,
          'temperature': 0.7,
        }),
        
      );

  //  final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
//   final response = await http.post(
//     url,
//     headers: {
//       'Authorization': 'Bearer $openRouter_API_KEY',
//       'Content-Type': 'application/json',
//       'HTTP-Referer': "http://10.4.152.47:3000", // Replace with your app's URL
//       'X-Title': 'sleeppal_update', // Replace with your app's name
//     },
//     body: jsonEncode({
//       'model': 'nousresearch/hermes-3-llama-3.1-405b',
//       'messages': messagesHistory,
//       'max_tokens': 200,
//     }),
//   );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var choices = responseBody['choices'] as List<dynamic>?;

        if (choices != null && choices.isNotEmpty) {
          var content = choices[0]['message']['content'];
          if (content != null) {
            setState(() {
              messages.insert(
                0,
                ChatMessage(
                  user: gptChatUser,
                  createdAt: DateTime.now(),
                  text: content,
                ),
              );
            });
          } else {
            throw Exception('Response content is null. Full response: $responseBody');
          }
        } else {
          throw Exception('No choices in response. Full response: $responseBody');
        }
      } else {
        throw Exception(
          'API Error: Status ${response.statusCode}\n'
          'Body: ${response.body}\n'
          'Headers: ${response.headers}'
        );
      }
    } catch (e, stackTrace) {
      print('Error in getChatResponse: $e');
      print('Stack trace: $stackTrace');
      
      setState(() {
        messages.insert(
          0,
          ChatMessage(
            user: gptChatUser,
            createdAt: DateTime.now(),
            text: "Error: $e\nPlease check console logs for details.",
          ),
        );
      });
    } finally {
      setState(() {
        typingUsers.remove(gptChatUser);
        _isTyping = false; // Stop typing indicator
      });
    }
}
}

// Typing Indicator Widget
class TypingIndicator extends StatefulWidget {
  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> {
  final List<String> _dots = ['.', '..', '...'];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    // Change the current index every 500 milliseconds
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _dots.length;
        });
        _startAnimation(); // Repeat the animation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        // Display the typing indicator with changing dots
        Text(
          _dots[_currentIndex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24, // Adjust this value to make the dots bigger or smaller
          ),
        ),
      ],
    );
  }
}

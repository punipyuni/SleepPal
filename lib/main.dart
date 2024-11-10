import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sleeppal_update/notification.dart';
import 'package:sleeppal_update/widgets/Stats/sleep_stat_provider.dart';
import 'package:sleeppal_update/widgets/relaxingSound/playlist_provider.dart'; // Import PlaylistProvider
import 'package:sleeppal_update/auth/signup.auth.dart';
import 'package:sleeppal_update/pages/MainScreen.dart';
import 'package:sleeppal_update/pages/LogoPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await NotificationService.init();
    
    String? token = prefs.getString('token');
    
    // Validate token if necessary
    if (token != null && JwtDecoder.isExpired(token)) {
      token = null; // Invalidate expired token
    }
    
    runApp(MyApp(token: token));
  } catch (e) {
    print("Error during initialization: $e");
  }
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SleepStatisticsProvider(),
      child: ChangeNotifierProvider(
        create: (context) => PlaylistProvider(), // Provide PlaylistProvider
        child: MaterialApp(
          home: LogoPage(token: token), // Show LogoPage first
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

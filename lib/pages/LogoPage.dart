import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import 'package:sleeppal_update/pages/MainScreen.dart';
import 'package:sleeppal_update/auth/signup.auth.dart';

class LogoPage extends StatefulWidget {
  final String? token;
  
  const LogoPage({Key? key, this.token}) : super(key: key);

  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      if (widget.token != null && !JwtDecoder.isExpired(widget.token!)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(token: widget.token!)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/sleeppal.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(), // Added loading indicator
            ],
          ),
        ),
      ),
    );
  }
}
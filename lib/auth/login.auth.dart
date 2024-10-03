import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

// TODO: Replace Login Page with acutal UI and functions

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Call the API to login the user
      var loginBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      // var response = await http.post(
      //   Uri.parse('http://localhost:3000/login'),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(loginBody),
      // );

      // var jsonResponse = await jsonDecode(response.body);

      // print(jsonResponse['status']);

      // if (jsonResponse['status']) {
      //   // Save the token in the shared preferences
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString('token', jsonResponse['token']);

      //   // Navigate to the home page
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      // } else {
      //   // Show an error message
      //   print('Something went wrong');
      // }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Login Page'),
      ),
    );
  }
}

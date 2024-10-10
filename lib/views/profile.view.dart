import 'package:flutter/material.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sleeppal_update/auth/signup.auth.dart';

//import '../widgets/Profile/profile_header.dart';

import '../utils/app_color.utils.dart';

class ProfilePage extends StatefulWidget {
  final token;

  const ProfilePage({@required this.token, super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userid;

  final String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userid = jwtDecodedToken['_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Profile image
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),

                const SizedBox(height: 20),

                /// Email
                Text(
                  userid,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                /// Sign out button
                ElevatedButton(
                  onPressed: () => {
                    print('Sign out'),
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.alertButtonColor,
                  ),
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

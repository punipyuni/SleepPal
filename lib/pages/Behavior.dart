import 'package:flutter/material.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import 'package:sleeppal_update/widgets/Behavior/behavior_header.dart';
import 'package:sleeppal_update/widgets/Behavior/behavior_form.dart';

class Behavior extends StatefulWidget {
  @override
  _BehaviorState createState() => _BehaviorState();
}

class _BehaviorState extends State<Behavior> {
  late GlobalKey<BehaviorFormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<BehaviorFormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const BehaviorHeader(),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: BehaviorForm(key: _formKey),
                  ),
                ),
                 
              ],
            ),
          ),
        ),
      ),
    );
  }
}

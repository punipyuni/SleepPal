import 'package:flutter/material.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import '../../widgets/asmr/header_widget.dart';
import '../../widgets/asmr/category_list.dart';
import '../../widgets/asmr/sound_card_list.dart';

class RelaxingSoundPage extends StatefulWidget {
  const RelaxingSoundPage({super.key});

  @override
  _RelaxingSoundPageState createState() => _RelaxingSoundPageState();
}

class _RelaxingSoundPageState extends State<RelaxingSoundPage> {
  String selectedCategory = 'Recent';

  void updateSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              HeaderWidget(),
              CategoryListWidget(
                selectedCategory: selectedCategory,
                onCategorySelected: updateSelectedCategory,
              ),
              Expanded(
                child: SoundCardListWidget(selectedCategory: selectedCategory),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../utils/app_color.utils.dart';
import '../widgets/relaxingSound/header_widget.dart';
import '../widgets/relaxingSound/category_list.dart';
import '../widgets/relaxingSound/sound_card_list.dart';

class RelaxingSoundPage extends StatefulWidget {
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

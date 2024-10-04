import 'package:flutter/material.dart';
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
          gradient: RadialGradient(
            center: Alignment(-1.0, -0.8),
            radius: 1.3,
            colors: [
              Color(0xFF6C51A6), // Light purple
              Color(0xFF1A102E), // Darker shade
              Color(0xFF131417), // Almost black
            ],
            stops: [0.17, 0.56, 1.0],
          ),
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
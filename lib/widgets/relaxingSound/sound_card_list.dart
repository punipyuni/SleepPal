import 'package:flutter/material.dart';
import 'sound_card.dart';

class SoundCardListWidget extends StatelessWidget {
  final String selectedCategory;

  SoundCardListWidget({required this.selectedCategory});

  final List<Map<String, String>> allSoundCards = [
    {
      'title': 'Rain ASMR sound',
      'category': 'Rain',
      'subcategory': 'ASMR sound',
      'imageUrl': 'assets/images/rain.jpg',
    },
    {
      'title': 'Nature ASMR sound',
      'category': 'Nature',
      'subcategory': 'ASMR sound',
      'imageUrl': 'assets/images/nature.jpg',
    },
    // Add more sound cards here
  ];

  @override
  Widget build(BuildContext context) {
    final filteredSoundCards = selectedCategory == 'Recent'
        ? allSoundCards
        : allSoundCards.where((card) => card['category'] == selectedCategory).toList();

    return ListView.builder(
      itemCount: filteredSoundCards.length,
      itemBuilder: (context, index) {
        return SoundCard(
          title: filteredSoundCards[index]['title']!,
          category: filteredSoundCards[index]['category']!,
          subcategory: filteredSoundCards[index]['subcategory']!,
          imageUrl: filteredSoundCards[index]['imageUrl']!,
        );
      },
    );
  }
}
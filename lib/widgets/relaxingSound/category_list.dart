import 'package:flutter/material.dart';
import 'category_chip.dart';

class CategoryListWidget extends StatelessWidget {
  final List<String> categories = ['Recent', 'Rain', 'Nature', 'life', 'Meditation'];
  final String selectedCategory;
  final Function(String) onCategorySelected;

  CategoryListWidget({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
  return Container(
    height: 40,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CategoryChip(
            label: categories[index],
            isSelected: categories[index] == selectedCategory,
            onSelected: () => onCategorySelected(categories[index]),
             
          ),
        );
      },
    ),
  );
}
}
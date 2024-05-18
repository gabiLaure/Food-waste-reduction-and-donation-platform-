import 'package:flutter/material.dart';

class FoodCategoriesPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'title': 'Fruits', 'image': 'assets/fruits.jpeg'},
    {'title': 'Vegetables', 'image': 'assets/vegetables.jpeg'},
    {'title': 'Desserts', 'image': 'assets/desserts.jpeg'},
    {'title': 'Grains', 'image': 'assets/grains.jpeg'},
    {'title': 'Sweets an Snacks', 'image': 'assets/sweets_snacks.jpeg'},
    {'title': 'Beverages', 'image': 'assets/beverages.jpeg'},
    {'title': 'Herbes and Spices', 'image': 'assets/herbes_spices.jpeg'},
    {'title': 'Baked Goods', 'image': 'assets/baked_goods.jpeg'},
    {'title': 'Fat&Oil', 'image': 'assets/fat_oil.jpeg'},
    // Add more categories here
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Food Category',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        SizedBox(
          height: 8,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return FoodCategoryCard(
                title: category['title']!,
                imageAsset: category['image']!,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class FoodCategoryCard extends StatelessWidget {
  final String title;
  final String imageAsset;

  FoodCategoryCard({required this.title, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(imageAsset),
          ),
          SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}

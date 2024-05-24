import 'package:caritas/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../pages/food_tips.dart';

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

  final List<Map<String, String>> tips = [
    {
      'image': 'assets/fruits.jpeg',
      'foodName': 'Vegetables',
      'foodDescription': 'A nutritious salad with fresh veggies and greens.',
      'foodTip':
          'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
    },

    {
      'image': 'assets/fruits.jpeg',
      'foodName': 'Vegetables',
      'foodDescription': 'A nutritious salad with fresh veggies and greens.',
      'foodTip':
          'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
    },
    {
      'image': 'assets/fruits.jpeg',
      'foodName': 'Vegetables',
      'foodDescription': 'A nutritious salad with fresh veggies and greens.',
      'foodTip':
          'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
    },
    {
      'image': 'assets/fruits.jpeg',
      'foodName': 'Vegetables',
      'foodDescription': 'A nutritious salad with fresh veggies and greens.',
      'foodTip':
          'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
    },
    {
      'image': 'assets/fruits.jpeg',
      'foodName': 'Vegetables',
      'foodDescription': 'A nutritious salad with fresh veggies and greens.',
      'foodTip':
          'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
    },
    {
      'image': 'assets/fruits.jpeg',
      'foodName': 'Vegetables',
      'foodDescription': 'A nutritious salad with fresh veggies and greens.',
      'foodTip':
          'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
    },
    {
      'image': 'assets/fruits.jpeg',
      'foodName': 'Vegetables',
      'foodDescription': 'A nutritious salad with fresh veggies and greens.',
      'foodTip':
          'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
    },
    {
      'image': 'assets/fruits.jpeg',
      'foodName': 'Vegetables',
      'foodDescription': 'A nutritious salad with fresh veggies and greens.',
      'foodTip':
          'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
    },
    {
      'image': 'assets/fruits.jpeg',
      'foodName': 'Vegetables',
      'foodDescription': 'A nutritious salad with fresh veggies and greens.',
      'foodTip':
          'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
    },
    // Add more categories here
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Food Tips',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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

  FoodCategoryCard({
    required this.title,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle the click action here
        // For example, navigate to a new screen or perform an action.
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FoodDetailsPage(
                    image: 'image',
                    foodName: 'foodName',
                    foodDescription: 'foodDescription',
                    foodTip: 'foodTip',
                  )),
        );
      },
      child: Container(
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
      ),
    );
  }
}

class FoodCategoryTips extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String image;
  final String foodName;
  final String foodDescription;
  final String foodTip;

  FoodCategoryTips(
      {required this.title,
      required this.imageAsset,
      required this.image,
      required this.foodName,
      required this.foodDescription,
      required this.foodTip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle the click action here
        // For example, navigate to a new screen or perform an action.
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FoodDetailsPage(
                    image: 'image',
                    foodName: 'foodName',
                    foodDescription: 'foodDescription',
                    foodTip: 'foodTip',
                  )),
        );
      },
      child: Container(
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
      ),
    );
  }
}

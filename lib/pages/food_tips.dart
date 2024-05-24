import 'package:flutter/material.dart';

class FoodDetailsPage extends StatelessWidget {
  final String image;
  final String foodName;
  final String foodDescription;
  final String foodTip;

  FoodDetailsPage({
    required this.image,
    required this.foodName,
    required this.foodDescription,
    required this.foodTip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              height: 200, // Adjust the image height as needed
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(foodDescription),
                  SizedBox(height: 16),
                  Text(foodTip),
                  // Add more tips as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage:
//

// final List<Map<String, String>> tips = [
  
//     image: 'assets/fruits.jpeg',
//     foodName: 'Vegetables',
//     foodDescription: 'A nutritious salad with fresh veggies and greens.',
//     foodTip:
//         'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.',
  
  
//     image: 'assets/fruits.jpeg',
//     foodName: 'Vegetables',
//     foodDescription: 'A nutritious salad with fresh veggies and greens.',
//     foodTip:
//         'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.',
  
//     image: 'assets/fruits.jpeg',
//     foodName: 'Vegetables',
//     foodDescription: 'A nutritious salad with fresh veggies and greens.',
//     foodTip:
//         'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
  
  
//     image: 'assets/fruits.jpeg',
//     foodName: 'Vegetables',
//     foodDescription: 'A nutritious salad with fresh veggies and greens.',
//     foodTip:
//         'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
  
  
//     image: 'assets/fruits.jpeg',
//     foodName: 'Vegetables',
//     foodDescription: 'A nutritious salad with fresh veggies and greens.',
//     foodTip:
//         'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
  
  
//     image: 'assets/fruits.jpeg',
//     foodName: 'Vegetables',
//     foodDescription: 'A nutritious salad with fresh veggies and greens.',
//     foodTip:
//         'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
  

//     'image': 'assets/fruits.jpeg',
//     'foodName': 'Vegetables',
//     'foodDescription': 'A nutritious salad with fresh veggies and greens.',
//     'foodTip':
//         'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
  
  
//     'image': 'assets/fruits.jpeg',
//     'foodName': 'Vegetables',
//     'foodDescription': 'A nutritious salad with fresh veggies and greens.',
//     'foodTip':
//         'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
  
  
//     'image': 'assets/fruits.jpeg',
//     'foodName': 'Vegetables',
//     'foodDescription': 'A nutritious salad with fresh veggies and greens.',
//     'foodTip':
//         'Tips: 1. Conserve food by planning meals.\n 2. Properly store leftovers in airtight containers. \n 3. Reduce waste by recycling food scraps.'
  
//   // Add more categories here
// ];

import 'package:caritas/pages/Registration/login_page.dart';
import 'package:flutter/material.dart';

class FoodCategoriesPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {
      'title': 'Fruits',
      'image': 'assets/fruits.jpeg',
      'description': 'Fruits Description',
      'foodDescription':
          'Fruits are packed with essential vitamins, minerals, and antioxidants that contribute to a healthy diet.',
      'tips': 'Food Tips',
      'foodTips':
          'Keep Fruits Cool (Store fruits in a cool environment to prolong freshness), '
              'Separate Ethylene Producers (Keep ethylene-producing fruits away from others), '
              'Freezing (Freeze fruits to extend shelf life), '
              'Canning (Preserve fruits in jars for long-term storage), '
              'Dehydrating (Remove moisture to concentrate flavors), '
              'Use Citrus Juice (Coat cut fruits to prevent browning)'
    },
    {
      'title': 'Vegetables',
      'image': 'assets/vegetables.jpeg',
      'description': 'Vegetables Description',
      'foodDescription':
          'Vegetables are rich in vitamins, minerals, and fiber.',
      'tips': 'Food Tips',
      'foodTips': 'Keep Vegetables Dry (Moisture can lead to spoilage), '
          'Store in Airtight Containers (Prevent exposure to air), '
          'Freeze for Long-Term Storage (Extend shelf life by freezing), '
          'Regularly Inspect Stored Vegetables (Check for spoilage), '
          'Use Ethylene Absorbers (Keep vegetables fresh longer)'
    },
    {
      'title': 'Desserts',
      'image': 'assets/desserts.jpeg',
      'description': 'Desserts Description',
      'foodDescription':
          'Desserts are sweet dishes, often served at the end of a meal.',
      'tips': 'Food Tips',
      'foodTips': 'Store Desserts in Cool Places (Avoid heat exposure), '
          'Avoid Direct Sunlight Exposure (Keep desserts away from sunlight), '
          'Use Airtight Containers (Retain freshness), '
          'Refrigerate Dairy-Based Desserts (Prevent spoilage), '
          'Freeze for Long-Term Preservation (Store desserts for later enjoyment)'
    },
    {
      'title': 'Grains',
      'image': 'assets/grains.jpeg',
      'description': 'Grains Description',
      'foodDescription':
          'Grains are a staple food rich in carbohydrates, providing energy.',
      'tips': 'Food Tips',
      'foodTips': 'Store Grains in Dry, Cool Places (Moisture can cause spoilage), '
          'Use Airtight Containers (Prevent pests from getting in), '
          'Freeze Flour or Grains (Protect against insect infestation), '
          'Inspect for Signs of Mold or Insects (Ensure grains are safe to eat)'
    },
    {
      'title': 'Sweets and Snacks',
      'image': 'assets/sweets_snacks.jpeg',
      'description': 'Sweets and Snacks Description',
      'foodDescription':
          'Sweets and snacks are often small, ready-to-eat treats enjoyed between meals.',
      'tips': 'Food Tips',
      'foodTips':
          'Store Snacks in Airtight Containers (Prevent moisture absorption), '
              'Keep Sweets in Cool, Dry Places (Avoid melting or spoilage), '
              'Freeze for Long-Term Storage (Enjoy snacks later without loss of quality), '
              'Keep Away from Moisture (Moisture can lead to spoilage)'
    },
    {
      'title': 'Beverages',
      'image': 'assets/beverages.jpeg',
      'description': 'Beverages Description',
      'foodDescription': 'Beverages are liquids intended for drinking.',
      'tips': 'Food Tips',
      'foodTips': 'Store Beverages in Cool Areas (Prevent spoilage), '
          'Refrigerate After Opening (Maintain freshness), '
          'Shake Well Before Drinking (Ensure ingredients mix properly), '
          'Avoid Exposure to Sunlight (Preserve flavor and quality)'
    },
    {
      'title': 'Herbs and Spices',
      'image': 'assets/herbes_spices.jpeg',
      'description': 'Herbs and Spices Description',
      'foodDescription':
          'Herbs and spices are used to add flavor and aroma to food.',
      'tips': 'Food Tips',
      'foodTips':
          'Store in Airtight Containers (Protect from moisture and air), '
              'Keep Away from Moisture (Prevent spoilage), '
              'Use Dry, Cool Areas (Extend shelf life), '
              'Avoid Direct Sunlight (Preserve flavors), '
              'Regularly Check for Freshness (Ensure quality for cooking)'
    },
    {
      'title': 'Baked Goods',
      'image': 'assets/baked_goods.jpeg',
      'description': 'Baked Goods Description',
      'foodDescription':
          'Baked goods include bread, cakes, and pastries made by baking.',
      'tips': 'Food Tips',
      'foodTips': 'Store in Airtight Containers (Prevent drying out), '
          'Keep Away from Moisture (Avoid spoilage), '
          'Freeze for Long-Term Storage (Maintain quality), '
          'Avoid Direct Sunlight (Protect from heat)'
    },
    {
      'title': 'Fat & Oil',
      'image': 'assets/fat_oil.jpeg',
      'description': 'Fat & Oil Description',
      'foodDescription':
          'Fat and oil are used for cooking and enhancing flavor in food.',
      'tips': 'Food Tips',
      'foodTips': 'Store in Cool, Dark Places (Protect from heat and light), '
          'Use Airtight Containers (Prevent rancidity), '
          'Avoid Exposure to Heat or Sunlight (Maintain quality), '
          'Check Expiry Dates Regularly (Ensure safety for consumption), '
          'Use Clean Utensils (Prevent contamination)'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Food Tips',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return FoodCategoryCard(
                title: category['title'] ?? "",
                imageAsset: category['image'] ?? "",
                foodName: category['title'] ?? "",
                description: category['description'] ?? "",
                foodDescription: category['foodDescription'] ?? "",
                tip: category['tips'] ?? "",
                foodTip: category['foodTips'] ?? "",
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
  final String foodName;
  final String description;
  final String foodDescription;
  final String tip;
  final String foodTip;

  FoodCategoryCard({
    required this.title,
    required this.imageAsset,
    required this.foodName,
    required this.description,
    required this.foodDescription,
    required this.tip,
    required this.foodTip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FoodCategoryTips(
                    title: title,
                    imageAsset: imageAsset,
                    image: imageAsset,
                    foodName: foodName,
                    foodDescription: foodDescription,
                    description: description,
                    tip: tip,
                    foodTip: foodTip,
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
  final String description;
  final String foodDescription;
  final String tip;
  final String foodTip;

  FoodCategoryTips({
    required this.title,
    required this.imageAsset,
    required this.image,
    required this.foodName,
    required this.description,
    required this.foodDescription,
    required this.tip,
    required this.foodTip,
  });

  @override
  Widget build(BuildContext context) {
    // Split the food tips by commas to create a list of tips
    List<String> tipsList = foodTip.split(',');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(image),
              SizedBox(height: 8),
              Text(description,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(foodDescription),
              SizedBox(height: 16),
              Text(tip,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),

              // Displaying food tips with bullet points
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tipsList.map((tip) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• ",
                            style: TextStyle(fontSize: 18)), // Bullet point
                        Expanded(
                          child:
                              Text(tip.trim(), style: TextStyle(fontSize: 16)),
                        ), // Display each tip
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

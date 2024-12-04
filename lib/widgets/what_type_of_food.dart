import 'package:flutter/material.dart';

class WhatTypeOfFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What Type of Food Are Allowed on Caritas?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Introduction Section
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'At Caritas, we believe in making food donations not only possible but also safe and effective. Here are some essential guidelines and recommendations to ensure the quality and safety of the food you wish to donate.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Food Quality and Safety Considerations Section
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Food Quality and Safety Considerations:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildSafetyText(
                        '- Check Expiry Dates: Always ensure that the food has not passed its expiration date. Expired food can pose health risks and should not be donated.'),
                    _buildSafetyText(
                        '- Proper Storage: Only donate food that has been stored according to safety standards (e.g., refrigerated items should remain chilled until donation).'),
                    _buildSafetyText(
                        '- Condition of Packaging: Food packaging must be intact. Do not donate food in damaged or opened containers as it can lead to contamination.'),
                    _buildSafetyText(
                        '- Cleanliness: Don’t donate food that looks spoiled or has visible signs of contamination. Ensure food is safe and edible.'),
                    _buildSafetyText(
                        '- Temperature Control: Perishable food should be kept at safe temperatures to avoid spoilage, especially if they require refrigeration or freezing.'),
                    _buildSafetyText(
                        '- Home-Cooked Meals: If donating homemade food, ensure it is freshly prepared, properly packed, and within safe consumption timelines.'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Duration and Handling Section
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Important Points on Food Duration and Handling:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildSafetyText(
                        '- Fresh Food Timeline: Fresh produce and meals should be donated within 1-2 days after preparation or harvesting to maintain their nutritional value and safety.'),
                    _buildSafetyText(
                        '- Frozen Food: If donating frozen items, ensure they are kept frozen until they reach the donation point.'),
                    _buildSafetyText(
                        '- Cooked Meals: Cooked food should be donated within 2 hours of cooking, or kept in a temperature-controlled environment (below 40°F/4°C) to prevent bacterial growth.'),
                    _buildSafetyText(
                        '- Packaged Foods: Shelf-stable, non-perishable items such as canned goods or dry grains can be stored longer, but check packaging for any signs of damage or rust.'),
                    _buildSafetyText(
                        '- Labeling: For packaged items, it’s a good practice to include a label with the donation specifying ingredients, dietary restrictions, or special handling instructions if necessary.'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Types of Acceptable Foods Section
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Types of Acceptable Foods:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildFoodList('Non-Perishable Foods', [
                      'Canned goods (vegetables, fruits, soups)',
                      'Packaged dry foods (pasta, rice, oats)',
                      'Dried beans, lentils, and legumes',
                      'Powdered or boxed milk',
                      'Cereal, granola, and energy bars',
                      'Instant meals (e.g., ramen, packaged soups)'
                    ]),
                    SizedBox(height: 20),
                    _buildFoodList(
                        'Perishable Foods (Only if Fresh and Properly Stored)',
                        [
                          'Fresh fruits and vegetables (must be free from spoilage)',
                          'Dairy products (within expiry date)',
                          'Fresh bread (donated within 1-2 days of baking)',
                          'Eggs (properly sealed and stored)'
                        ]),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Foods That Are Not Allowed Section
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Foods That Are Not Allowed for Donation:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    _buildSafetyText(
                        '- Expired or Damaged Items: Food that has passed its expiry date or is in compromised packaging.'),
                    _buildSafetyText(
                        '- Foods Requiring Special Storage: Items like raw meat or seafood that need precise temperature control.'),
                    _buildSafetyText(
                        '- Non-Food Items: Alcohol, tobacco, and other non-edible goods are not accepted.'),
                    _buildSafetyText(
                        '- Unlabeled or Unsealed Foods: Any food that is improperly sealed or lacks necessary labels to indicate its contents.'),
                    _buildSafetyText(
                        '- Spoiled or Contaminated Foods: Items that show signs of mold, foul odor, or contamination.'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Closing Message Section
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'By following these guidelines, we ensure that the food donations are safe, nutritious, and impactful for those in need. Your generosity can help reduce food waste and support communities in need.\n\nThank you for helping us make a difference!',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build safety guidelines
  Widget _buildSafetyText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  // Helper method to build list of food items
  Widget _buildFoodList(String title, List<String> foodItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ...foodItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                '- $item',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ))
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_cupernino_bottom_sheet/flutter_cupernino_bottom_sheet.dart';

class RequestDonation extends StatefulWidget {
  @override
  State<RequestDonation> createState() => _RequestDonationState();
}

class _RequestDonationState extends State<RequestDonation> {
  //String _output = '';
  String _listingType = 'Request'; // Default value

  final TextEditingController _descriptionController =
      TextEditingController(); // Create the controller

  final TextEditingController _controller = TextEditingController();
  final int maxTitleLength = 50;
  final int maxDescriptionLength = 500;

  //bool _showCalendar = true;
  // Holds the selected action
  String selectedAction = '';
  DateTime? selectedDate;
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listing Creation'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the page with information about allowed food types
            },
            child: const Center(
              child: Text(
                'What type of food are allowed on Caritas?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 24),
          _buildListingType(),
          _buildTitle(),
          _buildDescription(),
          //_buildAvailabilities(),
          //Divider(),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Validate and submit all responses
            },
            child: Text('Validate Request'),
          ),
        ],
      ),
    );
  }

  Widget _buildListingType() {
    // Implement the widget for selecting the listing type
    return DropdownButtonFormField<String>(
      value: _listingType,
      onChanged: (newValue) {
        setState(() {
          _listingType = newValue!;
        });
      },
      items: <String>['Donation', 'Request'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Listing Type',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTitle() {
    // Implement the widget for entering the title
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.0),
            const ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Row(children: [
                  Text(
                    'Enter Ad Title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ])),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Add a border
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: TextField(
                controller: _controller,
                maxLength: maxTitleLength,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.all(12.0), // Add padding inside the box
                  border: InputBorder.none,
                  hintText: 'E.g. Vegetable, Cakes, Cereals',
                  counterText: '${_controller.text.length}/$maxTitleLength',
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDescription() {
    // Implement the widget for entering the description
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Row(children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Add a border
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            child: TextField(
              minLines: null,
              maxLines: null,
              controller: _descriptionController,
              maxLength: maxDescriptionLength,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.all(12.0), // Add padding inside the box
                border: InputBorder.none,
                hintText:
                    'E.g. Tomatoes from the garden,Give as many details as possible to increase your chances of giving',
                counterText: '${_controller.text.length}/$maxDescriptionLength',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilities() {
    // Implement the widget for selecting availabilities
    return ListTile(
        leading: Icon(Icons.check_circle_outline),
        title: Row(
          children: [
            Text(
              'Avalaibility : ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(selectedAction)
          ],
        ),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: () {
          // Navigate to the listing creation page for donation
          setState(() {
            _showModalBottomSheet();
          });
        });
  }

  void _showModalBottomSheet() {
    final options = [
      'Week Days',
      'Week Evening',
      'Weekend',
      'I am available',
      'Cancel',
    ];

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Availability',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(), // Add a divider below the heading
          ...options.map((option) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(option),
                  onTap: () {
                    if (option != 'Cancel') {
                      setState(() {
                        selectedAction = option;
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
                Divider(),
              ],
            );
          }).toList(),
        ]);
      },
    );
  }

  Widget _buildBestBefore() {
    // Implement the food icon message widget
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text(
            'Best Before : ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
              selectedDate != null ? selectedDate.toString() : 'Select a date'),
          trailing: Icon(Icons.calendar_today),
          onTap: () {
            _showDatePicker(context);
          },
        ),
        Divider(),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          const ListTile(
              title: Center(
                child: Text(
                  'Select Expiration Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              trailing: Text(
                'Done',
                style: TextStyle(color: Colors.blue),
              )),
          Divider(),
          Container(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                });
              },
            ),
          )
        ]);
      },
    );
  }
}

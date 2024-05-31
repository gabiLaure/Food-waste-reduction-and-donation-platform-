import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class ListingEditPage extends StatefulWidget {
  final String listingType;
  final String communityType;
  final List<File> selectedImages;
  final String title;
  final String description;
  final String availability;
  final DateTime bestBeforeDate;
  final bool isMerchant;

  ListingEditPage({
    required this.listingType,
    required this.communityType,
    required this.selectedImages,
    required this.title,
    required this.description,
    required this.availability,
    required this.bestBeforeDate,
    required this.isMerchant,
  });

  @override
  State<ListingEditPage> createState() => _ListingEditPageState();
}

class _ListingEditPageState extends State<ListingEditPage> {
  late String _listingType;
  late String _communityType;
  late List<File> _selectedImages;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String selectedAction;
  DateTime? selectedDate;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _listingType = widget.listingType;
    _communityType = widget.communityType;
    _selectedImages = List.from(widget.selectedImages);
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    selectedAction = widget.availability;
    selectedDate = widget.bestBeforeDate;
    isSwitched = widget.isMerchant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Listing'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {},
            child: const Center(
              child: Text(
                'What type of food are allowed on Caritas?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildListingType(),
          SizedBox(height: 24),
          _buildLocalCommunity(),
          SizedBox(height: 16),
          _buildLocation(),
          _buildPhotosContainer(),
          _buildTitle(),
          _buildDescription(),
          _buildAvailabilities(),
          Divider(),
          _buildBestBefore(),
          _buildFoodIcon(),
          _buildMerchantSwitch(),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Validate and submit all responses
            },
            child: Text('Update Listing'),
          ),
        ],
      ),
    );
  }

  Widget _buildListingType() {
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

  Widget _buildLocalCommunity() {
    return DropdownButtonFormField<String>(
      value: _communityType,
      onChanged: (newValue) {
        setState(() {
          _communityType = newValue!;
        });
      },
      items: <String>[
        'CEPREJED',
        'ONDAPA',
        'DORCAS Foundation',
        'MSDAC',
        'Fondation des Enfants Orphelins'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Local Community',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLocation() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text(
            'Location : ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(selectedDate != null
              ? selectedDate.toString()
              : 'Select location'),
          trailing: Icon(Icons.location_on_sharp),
          onTap: () {
            _showDatePicker(context);
          },
        ),
        Divider(),
      ],
    );
  }

  Widget _buildPhotosContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Row(children: [
            Text(
              'Photos of the Food',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
        SizedBox(height: 8),
        _buildSelectedImages(),
        SizedBox(height: 8),
        Visibility(
          visible: _selectedImages.length < 4,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _showImageSourceDialog();
            },
            icon: Icon(Icons.add),
            label: Text('Add Image'),
          ),
        ),
        Visibility(
          visible: _selectedImages.length == 4,
          child: Text(
            'You can add a maximum of 4 photos.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedImages() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedImages.map((image) {
        return Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImages.remove(image);
                  });
                },
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Select Image Source')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
                child: Text('Take Photo'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
                child: const Text('Choose from Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (_selectedImages.length < 4) {
          _selectedImages.add(File(pickedFile.path));
        }
      });
    }
  }

  Widget _buildTitle() {
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
            ]),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
                hintText: 'E.g. Vegetable, Cakes, Cereals',
                counterText: '${_titleController.text.length}/50',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
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
            ]),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              minLines: null,
              maxLines: null,
              controller: _descriptionController,
              maxLength: 500,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
                hintText:
                    'E.g. Tomatoes from the garden,Give as many details as possible to increase your chances of giving',
                counterText: '${_descriptionController.text.length}/500',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilities() {
    return ListTile(
      leading: Icon(Icons.check_circle_outline),
      title: Row(
        children: [
          Text(
            'Availability : ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(selectedAction),
        ],
      ),
      trailing: Icon(Icons.arrow_drop_down),
      onTap: () {
        setState(() {
          _showModalBottomSheet();
        });
      },
    );
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
          Divider(),
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
            ),
          ),
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
          ),
        ]);
      },
    );
  }

  Widget _buildFoodIcon() {
    return const Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.check_circle_outline,
            color: Colors.blue,
          ),
          title: Row(
            children: [
              Icon(
                Icons.fastfood_outlined,
                size: 18,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Food',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildMerchantSwitch() {
    return ListTile(
      leading: Icon(Icons.check_circle_outline),
      title: Text(
        'I am a merchant',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

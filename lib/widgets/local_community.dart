import 'package:flutter/material.dart';

Widget _buildLocalCommunity() {
  String _communityType = 'DORCAS Foundation'; // Default value

  // Implement the widget for selecting the listing type
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

void setState(Null Function() param0) {}

import 'package:flutter/material.dart';
import '../models/donation.dart';

class AddDonation extends StatefulWidget {
  final Function(Donation) onAddDonation;

  AddDonation({required this.onAddDonation});

  @override
  _AddDonationState createState() => _AddDonationState();
}

class _AddDonationState extends State<AddDonation> {
  final _donorNameController = TextEditingController();
  final _recipientController = TextEditingController();
  final _foodTypeController = TextEditingController();
  final _dateController = TextEditingController();

  void _submit() {
    final donorName = _donorNameController.text;
    final recipient = _recipientController.text;
    final foodType = _foodTypeController.text;
    final date = _dateController.text;

    if (donorName.isNotEmpty &&
        recipient.isNotEmpty &&
        foodType.isNotEmpty &&
        date.isNotEmpty) {
      widget.onAddDonation(Donation(
          donorName: donorName,
          recipient: recipient,
          foodType: foodType,
          date: date));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un Don')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _donorNameController,
              decoration: InputDecoration(labelText: 'Nom du Donneur'),
            ),
            TextField(
              controller: _recipientController,
              decoration: InputDecoration(labelText: 'Destinataire'),
            ),
            TextField(
              controller: _foodTypeController,
              decoration: InputDecoration(labelText: 'Type de Nourriture'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date du Don'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text('Ajouter Don')),
          ],
        ),
      ),
    );
  }
}

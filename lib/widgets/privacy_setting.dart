import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool locationSharing = true;
  bool dataCollectionConsent = true;
  bool contactSharing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your privacy settings to control how your data is shared within the application.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),

            // Location Sharing Toggle
            SwitchListTile(
              title: Text('Share Location Data'),
              subtitle: Text(
                  'Allow the app to access your location to match donations nearby.'),
              value: locationSharing,
              onChanged: (bool value) {
                setState(() {
                  locationSharing = value;
                });
              },
            ),

            // Data Collection Consent Toggle
            SwitchListTile(
              title: Text('Data Collection Consent'),
              subtitle: Text(
                  'Allow the app to collect anonymous data for improving services.'),
              value: dataCollectionConsent,
              onChanged: (bool value) {
                setState(() {
                  dataCollectionConsent = value;
                });
              },
            ),

            // Contact Sharing Toggle
            SwitchListTile(
              title: Text('Share Contact Information'),
              subtitle: Text(
                  'Allow donors and recipients to view your contact details for coordination.'),
              value: contactSharing,
              onChanged: (bool value) {
                setState(() {
                  contactSharing = value;
                });
              },
            ),

            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save preferences or update user profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Privacy settings updated')),
                  );
                },
                child: Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

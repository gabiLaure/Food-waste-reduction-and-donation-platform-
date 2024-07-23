/* import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  PickResult? selectedPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Selection'),
      ),
      body: _buildLocation(),
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
          subtitle: selectedPlace != null
              ? Text(selectedPlace!.formattedAddress ?? 'Select location')
              : Text('Select location'),
          trailing: Icon(Icons.location_on_sharp),
          onTap: () async {
            PickResult? result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlacePicker(
                  apiKey: 'YOUR_GOOGLE_MAPS_API_KEY',
                  initialPosition: LatLng(0.0, 0.0),
                  useCurrentLocation: true,
                ),
              ),
            );
            if (result != null) {
              setState(() {
                selectedPlace = result;
              });
            }
          },
        ),
        Divider(),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LocationSelectionScreen(),
  ));
}
 */


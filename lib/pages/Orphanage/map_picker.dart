import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // Add geocoding package to your pubspec.yaml
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng position) onLocationPicked;

  LocationPicker({required this.onLocationPicked});

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _mapController;
  LatLng? _pickedLocation;
  String? _address = ''; // To store the address name
  double? _latitude; // To store latitude
  double? _longitude; // To store longitude

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(4.0521, 9.7075), // Default coordinates
                zoom: 14.0,
              ),
              onTap: _onMapTapped,
              markers: _pickedLocation != null
                  ? {
                      Marker(
                          markerId: MarkerId('picked-location'),
                          position: _pickedLocation!)
                    }
                  : {},
            ),
          ),
          ElevatedButton(
            onPressed: _pickedLocation == null
                ? null
                : () async {
                    // Get the address for the picked location
                    List<Placemark>? placemarks = await GeocodingPlatform
                        .instance
                        ?.placemarkFromCoordinates(
                      _pickedLocation!.latitude,
                      _pickedLocation!.longitude,
                    );
                    String address = placemarks!.isNotEmpty
                        ? placemarks.first.name ?? 'No address found'
                        : 'No address found';

                    // Return the selected location and its name
                    widget.onLocationPicked(_pickedLocation!);
                    Navigator.pop(context);
                  },
            child: Text('Select Location'),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }
}

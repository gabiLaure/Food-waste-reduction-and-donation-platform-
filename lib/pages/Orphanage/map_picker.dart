import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng position) onLocationPicked;

  LocationPicker({required this.onLocationPicked});

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? _mapController; // Make it nullable
  LatLng? _pickedLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
  }

  Future<void> _getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _pickedLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    // Move the camera if the map controller is already initialized
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _pickedLocation!, zoom: 14.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Location'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (_pickedLocation != null) {
                        _mapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _pickedLocation!,
                              zoom: 14.0,
                            ),
                          ),
                        );
                      }
                    },
                    initialCameraPosition: CameraPosition(
                      target: _pickedLocation ??
                          LatLng(4.0521, 9.7075), // Default coordinates
                      zoom: 14.0,
                    ),
                    onTap: _onMapTapped,
                    markers: _pickedLocation != null
                        ? {
                            Marker(
                              markerId: MarkerId('picked-location'),
                              position: _pickedLocation!,
                            )
                          }
                        : {},
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickedLocation == null
                      ? null
                      : () async {
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                            _pickedLocation!.latitude,
                            _pickedLocation!.longitude,
                          );
                          String address = placemarks.isNotEmpty
                              ? placemarks.first.name ?? 'No address found'
                              : 'No address found';

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
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(position),
      );
    }
  }
}

import 'package:caritas/models/orphanage.dart';
import 'package:caritas/pages/Orphanage/orphanage_details.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class DisplayMap extends StatefulWidget {
  final List<Map<String, dynamic>>
      orphanages; // List containing orphanages info

  DisplayMap({required this.orphanages});

  @override
  _DisplayMapState createState() => _DisplayMapState();
}

class _DisplayMapState extends State<DisplayMap> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};

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

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);

      // Add user location marker
      _markers.add(
        Marker(
          markerId: const MarkerId('user-location'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
        ),
      );

      // Add donation markers
      for (var donation in widget.orphanages) {
        LatLng donationPosition =
            LatLng(donation['latitude'], donation['longitude']);
        final distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          donation['latitude'],
          donation['longitude'],
        );
        // Store calculated distance
        final distanceBetweenUs = distanceInMeters / 1000; // Convert to km
        _markers.add(
          Marker(
            markerId: MarkerId(donation['id']),
            position: donationPosition,
            infoWindow: InfoWindow(
              title: donation['name'],
              snippet: donation['description'],
              onTap: () {
                // Navigate to ViewDonationPage with the selected donation's info
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrphanageDetailPage(
                      orphanage: Orphanage.fromObject(donation),
                    ),
                  ),
                );
              },
            ),
            icon: distanceBetweenUs <= 20.0
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
          ),
        );
      }
    });

    // Center map on user's location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 12.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                if (_currentPosition != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: _currentPosition!, zoom: 12.0),
                    ),
                  );
                }
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition ??
                    LatLng(4.0521, 9.7075), // Default location
                zoom: 14.0,
              ),
              markers: _markers,
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geo/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  final LocationService _locationService = LocationService();
  final CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(-23.563308, -46.632748),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: cameraPosition,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_on),
        onPressed: () async {
          Position position = await _locationService.getCurrentPosition();
          print(position);
        },
      ),
    );
  }
}

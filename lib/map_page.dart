import 'dart:async';

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

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Future<void> _goToUserLocation() async {
    final location = await _locationService.getCurrentPosition();

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(location.latitude, location.longitude), 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: cameraPosition,
          onMapCreated: (GoogleMapController controller) => _controller.complete(controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_on),
        onPressed: () async {
          await _goToUserLocation();
        },
      ),
    );
  }
}

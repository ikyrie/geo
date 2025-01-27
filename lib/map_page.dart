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

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(-23.303365, -51.162312),
      infoWindow:
          InfoWindow(title: "Depósito 1", snippet: "Depósito de peixes"),
    ),
    Marker(
      markerId: MarkerId("2"),
      position: LatLng(-23.296617, -51.174109),
      infoWindow:
          InfoWindow(title: "Depósito 2", snippet: "Depósito de frutas"),
    ),
    Marker(
      markerId: MarkerId("3"),
      position: LatLng(-23.264221, -51.175516),
      infoWindow:
          InfoWindow(title: "Depósito 3", snippet: "Depósito de caminhões"),
    ),
  };

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Future<void> _goToUserLocation() async {
    final location = await _locationService.getCurrentPosition();

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(location.latitude, location.longitude), 15));
  }

  void createMarker(LatLng position) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController snippetController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(16, 26, 16, MediaQuery.of(context).viewInsets.bottom + 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Nome do marcador',
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: snippetController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
            ),
            SizedBox(height: 26,),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _markers.add(
                    Marker(
                      markerId:
                          MarkerId("${position.latitude}, ${position.longitude}"),
                      position: position,
                      infoWindow: InfoWindow(
                        title: titleController.text,
                        snippet: snippetController.text,
                      ),
                    ),
                  );
                });
              },
              borderRadius: BorderRadius.circular(30),
              child: Ink(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFF4D5BD9),
                ),
                child: Text(
                  "Adicionar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: _markers,
              onLongPress: (LatLng position) => createMarker(position),
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) =>
                  _controller.complete(controller),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 60),
              child: InkWell(
                onTap: () async {
                  await _goToUserLocation();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: kElevationToShadow[3],
                    color: Color(0xFF4D5BD9),
                  ),
                  height: 56,
                  width: 56,
                  child: Icon(Icons.my_location, color: Colors.white,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

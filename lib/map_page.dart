import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
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
          await Permission.location.request();
          bool hasPermission = await Permission.location.isGranted;
          if (hasPermission) {
            Position position = await Geolocator.getCurrentPosition();
            print("${position.latitude}  ${position.longitude}");
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Permissão negada"),
                content: Text("Por favor, permita a permissão de localização"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

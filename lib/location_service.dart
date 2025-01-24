import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    try {
      var locationStatus = await Permission.location.status;
      if (locationStatus.isGranted) {
        return await Geolocator.getCurrentPosition();
      } else {
        throw Exception('Location permission not granted');
      }
    } catch (e) {
      print(e);
      return Position(
        latitude: 0.0,
        longitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    }
  }
}

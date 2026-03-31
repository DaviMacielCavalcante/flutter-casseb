import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {

  static Future<LatLng?> getUserRoute() async {

    bool isGeolocatorEnabled = await Geolocator.isLocationServiceEnabled();

    if (isGeolocatorEnabled) {

      LocationPermission isGeolocationHabilited = await Geolocator.checkPermission();

      if (isGeolocationHabilited == LocationPermission.denied) {

        isGeolocationHabilited= await Geolocator.requestPermission();
        
      if (isGeolocationHabilited == LocationPermission.denied ||  isGeolocationHabilited == LocationPermission.deniedForever) {
        return null;
        }
      } 

      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);

    }
  }
}
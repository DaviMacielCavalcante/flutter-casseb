import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoutingService {

   static Future<List<LatLng>?> getRoutes(LatLng origem, LatLng dest) async {

    Uri url = Uri.parse("https://router.project-osrm.org/route/v1/driving/${origem.longitude},${origem.latitude};${dest.longitude},${dest.latitude}?overview=full&geometries=geojson");

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final jsonResponse = json.decode(response.body);

      final points = jsonResponse['routes'][0]['geometry']['coordinates'];

      List<LatLng> routesCoords = points.map<LatLng>((item) => LatLng(item[1].toDouble(), item[0].toDouble())).toList();

      return routesCoords;

    } else {

      return null;

    }    

  }

}
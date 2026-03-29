import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
    const MapScreen({super.key});

  @override
  State createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {

  LatLng coords = LatLng(-1.4561,-48.5044);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Círio de Nazaré"),),
      body: FlutterMap(
        options: MapOptions(initialCenter: coords, initialZoom: 15.0),
        children: [TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.example.cirio_app",)],
        ),);
  } 
}
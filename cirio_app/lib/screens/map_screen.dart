import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/routes_data.dart';
import '../services/routing_service.dart';

class MapScreen extends StatefulWidget {
    const MapScreen({super.key});

  @override
  State createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {

  LatLng coords = LatLng(-1.4561,-48.5044);

  List<LatLng> rotaAtual = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Círio de Nazaré"),),
      body: FlutterMap(
        options: MapOptions(initialCenter: coords, initialZoom: 15.0),
        children: [
          TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.example.cirio_app",),
          PolylineLayer(polylines: [Polyline(points: rotaAtual,
          color: Colors.blue, strokeWidth: 5.0
          )],),
          MarkerLayer(markers: [
           Marker(point: coords, 
           child:  Icon(Icons.location_on, color: Colors.red, size: 40,))
          ])
        ],
        ),
      bottomNavigationBar: Row(
        children: [
        ElevatedButton(onPressed: () async {

          final rota = await RoutingService.getRoutes(RoutesData.catedralSe, RoutesData.basilica);

          print("Rota recebida: ${rota?.length} pontos");

          setState(() {
            rotaAtual = rota ?? [];
          });

        }, child: Text("Rota do Círio"),),
        ElevatedButton(onPressed:() async {

          final rota = await RoutingService.getRoutes(RoutesData.colegioGentil, RoutesData.catedralSe);

          print("Rota recebida: ${rota?.length} pontos");

          setState(() {
            rotaAtual = rota ?? [];
          });

        }, child: Text("Rota da Trasladação"),)
      ]
      ),
      );
  } 
}
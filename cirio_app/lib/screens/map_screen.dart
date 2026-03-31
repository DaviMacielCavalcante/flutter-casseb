import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import '../data/routes_data.dart';
import '../services/routing_service.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
    const MapScreen({super.key});

  @override
  State createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {

  List<LatLng> rotaAtual = [];

  LatLng? userLocation;

  late final AnimatedMapController mapController = AnimatedMapController(vsync: this);

  _loadUserLocation() async {
    var userLocation = await LocationService.getUserRoute();

    setState(() {
      this.userLocation = userLocation;
    });

    mapController.animateTo(dest: userLocation!, zoom: 15.0);
  }

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Círio de Nazaré"),),
      body: FlutterMap(
        mapController: mapController.mapController,
        options: MapOptions(initialCenter: RoutesData.catedralSe, initialZoom: 15.0),
        children: [
          TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.example.cirio_app",),
          PolylineLayer(polylines: [Polyline(points: rotaAtual,
          color: Colors.blue, strokeWidth: 5.0
          )],),
          MarkerLayer(markers: [
           Marker(point: RoutesData.catedralSe, 
           child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Catedral da Sé - Início do Círio"))
              );
            },
            child: Icon(Icons.location_on, color: Colors.deepOrange, size: 40,),
           )),
           Marker(point: RoutesData.verOPeso, 
           child:  GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mercado do Ver-o-Peso")));
            },
            child: Icon(Icons.store_outlined, color: Colors.blueAccent, size: 40,),
           )),
           Marker(point: RoutesData.basilica, 
           child:  GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Basílica de Nazaré - Destino do Círio")));
            },
            child: Icon(Icons.church_outlined, color: const Color.fromARGB(255, 133, 80, 0), size: 40,),
           )),
           Marker(point: RoutesData.colegioGentil, 
           child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Colégio Gentil")));
            },
            child: Icon(Icons.school_outlined, color: Colors.blue, size: 40,),
           )),
           Marker(point: RoutesData.estacaoDocas, 
           child:  GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Estação das Docas")));
            },
            child: Icon(Icons.food_bank_outlined, color: const Color.fromARGB(255, 190, 26, 14), size: 40,),
           )),
           Marker(point: RoutesData.pracaRepublica, 
           child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Praça da República")));
            },
            child: Icon(Icons.park_outlined, color: const Color.fromARGB(255, 86, 161, 0), size: 40,),
           )),
           if (userLocation != null) 
              Marker(point: userLocation!, 
              child: Icon(
                Icons.person_outline_outlined, color: Colors.blue,
                size: 40
              ))
          ])
        ],
        ),
      bottomNavigationBar: Row(
        children: [
        ElevatedButton(onPressed: () async {

          final rota = await RoutingService.getRoutes(RoutesData.catedralSe, RoutesData.basilica);

          setState(() {
            rotaAtual = rota ?? [];
          });

          mapController.animatedFitCamera(
            cameraFit: CameraFit.bounds(
              bounds: LatLngBounds.fromPoints(rotaAtual),
              padding: EdgeInsets.all(50)
            )
          );

        }, child: Text("Rota do Círio"),),
        ElevatedButton(onPressed:() async {

          final rota = await RoutingService.getRoutes(RoutesData.colegioGentil, RoutesData.catedralSe);

          setState(() {
            rotaAtual = rota ?? [];
          });

          mapController.animatedFitCamera(
            cameraFit: CameraFit.bounds(
              bounds: LatLngBounds.fromPoints(rotaAtual),
              padding: EdgeInsets.all(50)
            )
          );

        }, child: Text("Rota da Trasladação"),),
        ElevatedButton(onPressed:() async {

          final localizacao = await LocationService.getUserRoute();

          if (localizacao != null) {

            final rotaComeco = await RoutingService.getRoutes(localizacao, RoutesData.catedralSe);

            setState(() {
              rotaAtual = rotaComeco ?? [];
            });

            mapController.animatedFitCamera(
              cameraFit: CameraFit.bounds(
                bounds: LatLngBounds.fromPoints(rotaAtual),
                padding: EdgeInsets.all(50)
              )
            );
          }          

        }, child: Text("Rota para o ínicio do trajeto"),),
      ]
      ),
      );
  } 
}
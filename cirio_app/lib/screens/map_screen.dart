import 'package:cirio_app/data/app_theme.dart';
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

  int selectBtn = -1; // Nenhum botão selecionado

  _loadUserLocation() async {
    var userLocation = await LocationService.getUserRoute();

    if (!mounted) return;

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

  Widget routeBtn({required IconData icon, required String label, required int btnIndex, required VoidCallback callBack}) {

    bool selected = selectBtn == btnIndex;

    return GestureDetector(
      onTap: callBack,
      child: Container(
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : Colors.transparent,
            border: selected ? Border.all(color: AppTheme.secondary, width: 1.5) : null,
            borderRadius: BorderRadius.circular(12)
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? AppTheme.onPrimary : AppTheme.primary,
                size: 24,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? AppTheme.onPrimary : AppTheme.primary
                ),
              )
            ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Círio de Nazaré"),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
      ),
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
        Expanded(child: 
          routeBtn(
            callBack: () async {

              setState(() {
                selectBtn = 0;
              });

              final rota = await RoutingService.getRoutes(RoutesData.catedralSe, RoutesData.basilica);

              setState(() {
                rotaAtual = rota ?? [];
                selectBtn = 0;
              });

              mapController.animatedFitCamera(
                cameraFit: CameraFit.bounds(
                  bounds: LatLngBounds.fromPoints(rotaAtual),
                  padding: EdgeInsets.all(50)
                )
              );

            }, label: "Rota do Círio",
            icon: Icons.map,
            btnIndex: 0
          )
        ),
        Expanded(child: 
          routeBtn(
            callBack:() async {

              setState(() {
              selectBtn = 1;
              });

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

            }, 
            label: "Rota da Trasladação",
            icon: Icons.auto_fix_off,
            btnIndex: 1
          )
        ),
        Expanded(child: 
          routeBtn(
            callBack:() async {

              setState(() {
              selectBtn = 2;
              });

              final localizacao = await LocationService.getUserRoute();

              if (localizacao != null) {

                final rotaComeco = await RoutingService.getRoutes(localizacao, RoutesData.catedralSe);

                setState(() {
                  rotaAtual = rotaComeco ?? [];
                  selectBtn = 2;
                });

                mapController.animatedFitCamera(
                  cameraFit: CameraFit.bounds(
                    bounds: LatLngBounds.fromPoints(rotaAtual),
                    padding: EdgeInsets.all(50)
                  )
                );
              }   
          }, 
          label: "Rota para o ínicio do trajeto",
          icon: Icons.route,
          btnIndex: 2
          )
        ),
      ]
      ),
      );
  } 
}
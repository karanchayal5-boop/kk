import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';

class MyAppleMap extends StatefulWidget {
  @override
  _MyAppleMapState createState() => _MyAppleMapState();
}

class _MyAppleMapState extends State<MyAppleMap> {
  late AppleMapController mapController;

  
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.39916, 74.02544),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apple Maps Flutter')),
      body: AppleMap(
        onMapCreated: (AppleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: _initialPosition,
        mapType: MapType.standard, 
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
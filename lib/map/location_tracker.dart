import 'dart:async';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationTracker {
  static Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    final pos = await Geolocator.getCurrentPosition();
    return LatLng(pos.latitude, pos.longitude);
  }

  static StreamSubscription<Position> listen(
    Function(LatLng) onUpdate,
  ) {
    const settings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5);

    return Geolocator.getPositionStream(locationSettings: settings).listen((pos) {
      onUpdate(LatLng(pos.latitude, pos.longitude));
    });
  }
}

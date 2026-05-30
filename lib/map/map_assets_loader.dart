import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapAssetsLoader {
  static Future<Map<String, BitmapDescriptor>> loadIcons() async {
    final userIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/bitmoji@3x.png',
    );

    final taxiIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(35, 35)),
      'assets/images/car_group.png',
    );

    final sourceIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/images/Group 36@3x.png',
    );

    final destinationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/images/Group 37@3x.png',
    );

    return {
      "user": userIcon,
      "taxi": taxiIcon,
      "source": sourceIcon,
      "destination": destinationIcon,
    };
  }
}

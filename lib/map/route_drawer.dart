import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';

class RouteDrawer {

  static void drawRoute({
    required AppleMapController? mapController,
    required LatLng source,
    required LatLng destination,
    required BitmapDescriptor? sourceIcon,
    required BitmapDescriptor? destinationIcon,
    required Set<Polyline> polylines,
    required Set<Annotation> annotations,
    required Function(Set<Polyline>, Set<Annotation>) onUpdate,
  }) {

    if (mapController == null) return;

    // 1. Polyline
    final newPolylines = <Polyline>{
      Polyline(
        polylineId: PolylineId("route_1"),
        visible: true,
        points: [source, destination],
        color: Colors.orange,
        width: 5,
      ),
    };

    // 2. Annotations
    final newAnnotations = Set<Annotation>.from(annotations)
      ..addAll({
        Annotation(
          annotationId: AnnotationId("source_point"),
          position: source,
          icon: sourceIcon ?? BitmapDescriptor.defaultAnnotation,
        ),
        Annotation(
          annotationId: AnnotationId("destination_point"),
          position: destination,
          icon: destinationIcon ?? BitmapDescriptor.defaultAnnotation,
        ),
      });

    // 3. Update UI
    onUpdate(newPolylines, newAnnotations);

    // 4. Camera bounds
    LatLngBounds bounds;
    if (source.latitude < destination.latitude) {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    } else {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }
}

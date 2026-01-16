import 'package:apple_maps_flutter/apple_maps_flutter.dart';

class MarkerManager {
  static Set<Annotation> buildMarkers({
    required LatLng userPos,
    required BitmapDescriptor userIcon,
    required BitmapDescriptor taxiIcon,
  }) {
    return {
      Annotation(
        annotationId: AnnotationId("user"),
        position: userPos,
        icon: userIcon,
      ),
      Annotation(
        annotationId: AnnotationId("taxi1"),
        position: LatLng(userPos.latitude + 0.002, userPos.longitude + 0.002),
        icon: taxiIcon,
      ),
      Annotation(
        annotationId: AnnotationId("taxi2"),
        position: LatLng(userPos.latitude - 0.002, userPos.longitude - 0.001),
        icon: taxiIcon,
      ),
    };
  }
}

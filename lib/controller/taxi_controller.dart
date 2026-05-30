import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:get/get.dart';


class TaxiController extends GetxController {
  var isDestinationSelected = false.obs;
  var destinationAddress = "".obs;
  var destinationLatLng = const LatLng(0, 0).obs;
  var routePoints = <LatLng>[].obs;
  var selectedPaymentIndex = 0.obs;
  var selectedCardText = "xxxx xxxx 4793".obs;
  
  var selectedVehicleIndex =0.obs;
  var etaMinutes = 0.obs;
  var distanceMeters = 0.0.obs;
  var currentStep = 0.obs;
  var scheduledDateTime = DateTime.now().obs;

  var estimatedTimeMin = 0.obs;
  var estimatedDistanceKm = 0.0.obs;

  void destinationDone(String address, LatLng coords) {
    destinationAddress.value = address;
    destinationLatLng.value = coords;
    isDestinationSelected.value = true;
  }

  void setRouteData(List<LatLng> points, int time, double distance) {
    routePoints.value = points;
    etaMinutes.value = time;
    distanceMeters.value = distance;
  }

  void resetSearch() {
    isDestinationSelected.value = false;
    routePoints.clear();
    etaMinutes.value = 0;
    distanceMeters.value = 0;
    currentStep.value = 0;
  }
}

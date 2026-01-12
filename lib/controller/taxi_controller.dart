import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:get/get.dart';

class TaxiController extends GetxController {
  var isDestinationSelected = false.obs;
  var destinationAddress = "".obs;
  var destinationLatLng = const LatLng(0, 0).obs;
  
  var currentStep = 0.obs;

  void goToNoteStep() {
    currentStep.value = 1;
  }
  void resetSteps() {
    currentStep.value = 0;
  }
  

  // Jab user koi address select kar le
  void destinationDone(String address, LatLng coords) {
    destinationAddress.value = address;   // Address save karein
    destinationLatLng.value = coords;          // Search band karein
    isDestinationSelected.value = true;   // Vehicle selection sheet dikhayein
  }

  // Wapis jane ke liye (Reset function)
  void resetSearch() {
    
    isDestinationSelected.value = false;
  }
}
import 'package:get/get.dart';

class TaxiController extends GetxController {
  
  var isDestinationSelected = false.obs; 
  var selectedDestination = "".obs;

  
  void destinationDone(String address) {
    selectedDestination.value = address;
    isDestinationSelected.value = true; 
    Get.back(); 
  }
}
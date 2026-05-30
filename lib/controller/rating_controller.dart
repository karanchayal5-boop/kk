import 'package:get/get.dart';

class RatingController extends GetxController {
  var rating = 1.obs;

  void setRating(int value) {
    rating.value = value;
  }
}



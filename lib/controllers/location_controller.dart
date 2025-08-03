import 'package:get/get.dart';

class LocationController extends GetxController {
  final RxString currentLocation = 'Dhaka, Banassre'.obs;

  void updateLocation(String newLocation) {
    currentLocation.value = newLocation;
  }
} 
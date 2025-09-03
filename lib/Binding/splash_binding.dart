import 'package:get/get.dart';
import 'package:ict_faculties/Controllers/splash_controller.dart';

import '../Controllers/internet_connectivity.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(SplashController());
  }
}

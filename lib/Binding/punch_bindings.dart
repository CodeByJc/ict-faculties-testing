import 'package:get/get.dart';
import 'package:ict_faculties/Controllers/punch_controller.dart';
import '../Controllers/internet_connectivity.dart';

class PunchBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(PunchController());
  }
}

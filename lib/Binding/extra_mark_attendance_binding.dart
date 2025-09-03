import 'package:get/get.dart';
import '../Controllers/extra_attendance_mark_controller.dart';
import '../Controllers/internet_connectivity.dart';

class ExtraMarkAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(ExtraMarkAttendanceController());
  }
}

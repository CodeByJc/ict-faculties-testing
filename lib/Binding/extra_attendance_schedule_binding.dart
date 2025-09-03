import 'package:get/get.dart';

import '../Controllers/extra_attendance_schedule_controller.dart';
import '../Controllers/internet_connectivity.dart';

class ExtraAttendanceScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(ExtraAttendanceScheduleController());
  }
}

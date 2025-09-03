import 'package:get/get.dart';
import 'package:ict_faculties/Controllers/reg_attendance_schedule_controller.dart';

import '../Controllers/internet_connectivity.dart';

class RegAttendanceScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(RegAttendanceScheduleController());
  }
}

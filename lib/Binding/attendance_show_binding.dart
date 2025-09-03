import 'package:get/get.dart';
import '../Controllers/attendance_show_controller.dart';

class AttendanceShowBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AttendanceShowController());
  }
}

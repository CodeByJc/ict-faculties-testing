import 'package:get/get.dart';
import '../Controllers/feedback_controller.dart';
import '../Controllers/internet_connectivity.dart';

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(FeedbackController());
  }
}

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Helper/Utils.dart';
import '../Models/extra_attendance_schedule.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class ExtraAttendanceScheduleController extends GetxController {
  RxList<ExtraSchedule> scheduleDataList = <ExtraSchedule>[].obs;
  RxBool isLoadingFetchExtraSchedule = true.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  int facultyId = Get.arguments['faculty_id'];
  final internetController = Get.find<InternetConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    fetchExtraSchedule();
  }

  Future<void> fetchExtraSchedule() async {
    isLoadingFetchExtraSchedule.value = true;
    try {
      if (!internetController.isConnected.value) {
        isLoadingFetchExtraSchedule.value = false;
        Utils().showInternetAlert(
            context: Get.context!, onConfirm: () => fetchExtraSchedule());
      } else {
        Map<String, dynamic> body = {'f_id': facultyId};
        final response = await http.post(
          Uri.parse(getExtraScheduleAPI),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': validApiKey,
          },
          body: json.encode(body),
        );
        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);

          List<ExtraSchedule> extraScheduleDataList = responseData
              .map((scheduleData) => ExtraSchedule.fromJson(scheduleData))
              .toList();
          scheduleDataList.assignAll(extraScheduleDataList);
        } else {
          Utils().showSomethingWrongAlert(
              context: Get.context!, onConfirm: () => fetchExtraSchedule());
        }
        isLoadingFetchExtraSchedule.value = false;
      }
    } catch (e) {
      Utils().showSomethingWrongAlert(
          context: Get.context!, onConfirm: () => fetchExtraSchedule());
    }
  }
}

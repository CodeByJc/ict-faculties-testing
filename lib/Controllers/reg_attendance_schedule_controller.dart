import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_faculties/Models/reg_attendance_schedule.dart';
import 'package:ict_faculties/Network/API.dart';
import 'package:intl/intl.dart';

import '../Helper/Utils.dart';
import 'internet_connectivity.dart';

class RegAttendanceScheduleController extends GetxController {
  RxList<RegSchedule> scheduleDataList = <RegSchedule>[].obs;
  RxBool isLoadingFetchSchedule = true.obs;
  int facultyId = Get.arguments['faculty_id'];
  Rx<DateTime> selectedDate = DateTime.now().obs;
  final internetController = Get.find<InternetConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    fetchSchedule(date: selectedDate.value);
  }

  Future<void> fetchSchedule({required DateTime date}) async {
    isLoadingFetchSchedule.value = true;
    scheduleDataList.value = [];
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingFetchSchedule.value = false;
      Utils().showInternetAlert(
          context: Get.context!,
          onConfirm: () => fetchSchedule(date: selectedDate.value));
    } else {
      String todayDate = DateFormat('yyyy-MM-dd').format(date);
      List<RegSchedule>? fetchedScheduleDataList =
          await getSchedule(facultyId, todayDate);
      if (fetchedScheduleDataList != null) {
        scheduleDataList.assignAll(fetchedScheduleDataList);
      }
      isLoadingFetchSchedule.value = false;
    }
  }

  Future<List<RegSchedule>?> getSchedule(int fid, String date) async {
    try {
      Map<String, dynamic> body = {'f_id': fid, 'date': date};

      final response = await http.post(
        Uri.parse(getScheduleAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        List<RegSchedule> scheduleDataList = responseData
            .map((scheduleData) => RegSchedule.fromJson(scheduleData))
            .toList();

        return scheduleDataList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

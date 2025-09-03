// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_faculties/Helper/Utils.dart';
import 'package:intl/intl.dart';
import '../Models/extra_attendance_list.dart';
import '../Models/extra_attendance_schedule.dart';
import '../Models/extra_mark_attendance_data.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class ExtraMarkAttendanceController extends GetxController {
  RxList<ExtraAttendanceList> extraAttendanceDataList =
      <ExtraAttendanceList>[].obs;
  RxList<ExtraAttendanceList> extraAttendanceDataCopyList =
      <ExtraAttendanceList>[].obs;
  RxList<ExtraMarkAttendanceData> uploadExtraAttendanceDataList =
      <ExtraMarkAttendanceData>[].obs;

  RxBool isLoadingExtraAttendanceList = false.obs;
  RxBool isUploadingExtraAttendance = false.obs;
  RxBool isSelectAll = true.obs;

  DateTime selectedDate = Get.arguments['selected_date'];
  int subjectId = Get.arguments['subject_id'];
  int facultyId = Get.arguments['faculty_id'];
  ExtraSchedule scheduleData = Get.arguments['schedule'];
  final internetController = Get.find<InternetConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    fetchExtraAttendanceList();
  }

  Future<void> fetchExtraAttendanceList() async {
    isLoadingExtraAttendanceList.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingExtraAttendanceList.value = false;
      Utils().showInternetAlert(
          context: Get.context!, onConfirm: () => fetchExtraAttendanceList());
    } else {
      String formatedSelectedDate =
          DateFormat("yyyy-MM-dd").format(selectedDate);
      List<ExtraAttendanceList> fetchedAttendanceDataList =
          await getExtraAttendanceList(
              scheduleData.subjectID, facultyId, formatedSelectedDate);

      extraAttendanceDataList.assignAll(fetchedAttendanceDataList);
      createExtraAttendanceCopy();
      isLoadingExtraAttendanceList.value = false;
    }
  }

  Future<List<ExtraAttendanceList>> getExtraAttendanceList(
      int subId, int fid, String cdate) async {
    try {
      Map<String, dynamic> body = {
        'sub_id': subId,
        'f_id': fid,
        'c_date': cdate,
      };
      final response = await http.post(
        Uri.parse(getExtraAttendanceListAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<ExtraAttendanceList> ExtraAttendanceDataList = responseData
            .map((attendanceData) =>
                ExtraAttendanceList.fromJson(attendanceData))
            .toList();

        return ExtraAttendanceDataList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> createExtraAttendanceCopy() async {
    extraAttendanceDataCopyList.value =
        extraAttendanceDataList.map((attendance) {
      ExtraAttendanceList copiedAttendance = attendance.copyWith(
          newCount: attendance.count == (-1) ? 0 : attendance.count);
      return copiedAttendance;
    }).toList();
  }

  Future<void> uploadExtraAttendance() async {
    isUploadingExtraAttendance.value = true;

    for (int i = 0; i < extraAttendanceDataCopyList.length; i++) {
      if (extraAttendanceDataList[i].count !=
          extraAttendanceDataCopyList[i].count) {
        uploadExtraAttendanceDataList.add(ExtraMarkAttendanceData(
          subjectId: subjectId,
          facultyId: facultyId,
          studentId: extraAttendanceDataCopyList[i].studentID,
          date: DateFormat("yyyy-MM-dd").format(selectedDate),
          count: extraAttendanceDataCopyList[i].count,
        ));
      }
    }

    if (!internetController.isConnected.value) {
      isUploadingExtraAttendance.value = false;
      Utils().showInternetAlert(
          context: Get.context!, onConfirm: () => uploadExtraAttendance());
    } else {
      if (uploadExtraAttendanceDataList.isEmpty) {
        Utils().showNoChangesUploadAlert();
        isUploadingExtraAttendance.value = false;
        return;
      }
      List<Map<String, dynamic>> body =
          uploadExtraAttendanceDataList.map((data) => data.toJson()).toList();
      final response = await http.post(
        Uri.parse(uploadExtraAttendanceAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Utils().showUploadSuccessAlert();
      } else {
        Utils().showUploadFailedAlert();
      }
    }
    isUploadingExtraAttendance.value = false;
  }
}
